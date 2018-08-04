import itertools
from . import ast
from . import il
from . import ctypes


class Interpreter(ast.NodeVisitor):
    variables = {}

    def __init__(self, scope, il):
        self.scope = scope
        self.il = il
        self.current_scope = ""
        self.branch_count = 1
        self.current_function = None
        self.current_loop = {
            "start": "",
            "end": ""
        }
        self.exports = []

    def visit_TranslationUnit(self, node):
        for n in node.items:
            self.visit(n)

    def visit_Declaration(self, node):
        decl_infos = self.scope.lookup_decl(id(node))

        for d in decl_infos:
            if type(d.ctype) != ctypes.FunctionCType:
                var_name = d.identifier.value
                var_global = self.scope.lookup(var_name, "")
                var = self.scope.lookup(var_name, self.current_scope)
                if var_global is None:
                    def init_var(init, il_value):
                        if il_value.storage == ast.DeclInfo.STATIC and init is None:
                                val = il.ILValue(il_value.type)
                                self.il.register_literal_value(val, 0)
                                self.il.add(il.Set(val, il_value))
                        if init is not None:
                            if il_value.type.is_scalar():
                                if isinstance(init, ast.InitializerList):
                                    if len(init.inits) != 1:
                                        raise SyntaxError("Can't assign list to scalar type")
                                val = self.visit(init)
                                val = self._set_type(val, var.type)
                                self.il.add(il.Set(val, var.il_value))
                            elif il_value.type.is_array():
                                if not isinstance(init, ast.InitializerList):
                                    raise SyntaxError("Array must be initialized with list")
                                loc = il.ILValue(ctypes.unsig_int)
                                self.il.add(il.AddrOf(il_value, loc))
                                size = il.ILValue(ctypes.unsig_int)
                                self.il.register_literal_value(size, il_value.type.el.size)
                                for i in range(il_value.type.size):
                                    if i >= len(init.inits):
                                        val = il.ILValue(il_value.type.el)
                                        self.il.register_literal_value(val, 0)
                                    else:
                                        val = self.visit(init.inits[i])
                                        if val.type != il_value.type.el:
                                            val = self._set_type(val, il_value.type.el)
                                        val = val.val(self.il)
                                    self.il.add(il.SetAt(loc, val))
                                    if i != il_value.type.size - 1:
                                        if il_value.type.el.size == 1:
                                            self.il.add(il.Inc(loc))
                                        else:
                                            self.il.add(il.Add(loc, size, loc))

                    init_var(d.init, var.il_value)

    def visit_Function(self, node):
        old_scope = self.current_scope
        self.current_scope = str(id(node))

        decl_info = self.scope.lookup_decl(id(node))
        func_name = decl_info.identifier.value
        self.il.start_function(func_name)
        self.current_function = decl_info
        for n in node.nodes.items:
            self.visit(n)
        should_return = True
        if node.nodes.items is not None and len(node.nodes.items) != 0 and isinstance(node.nodes.items[-1], ast.Return):
            should_return = False
        if should_return:
            if func_name == "main":
                il_value = il.ILValue(decl_info.ctype.ret)
            else:
                il_value = il.ILValue(ctypes.void)
            self.il.register_literal_value(il_value, 0)
            self.il.add(il.Return(il_value))
        self.il.end_function()
        self.current_scope = old_scope

    def visit_FuncCall(self, node):
        func_name = node.func.identifier.value
        func = self.scope.lookup(func_name, self.current_scope)

        args = []
        for a, fa in itertools.zip_longest(node.args, func.type.args):
            arg = self.visit(a)
            if arg.type.is_array():
                arg = arg.addr(self.il)

            arg_val = arg.val(self.il)
            if fa is not None:
                arg_val = self._set_type(arg_val, fa)
            args.append(arg_val)

        output = il.ILValue(func.type.ret)
        self.il.add(il.CallFunction(func_name, args, output))
        return output

    def visit_Identifier(self, node):
        var_name = node.identifier.value
        val = self.scope.lookup(var_name, self.current_scope)
        return ast.DirectLValue(val.il_value)

    def visit_Number(self, node):
        il_value = il.ILValue(ctypes.integer)
        self.il.register_literal_value(il_value, node.number)
        return il_value

    def visit_String(self, node):
        il_value = il.ILValue(ctypes.ArrayCType(ctypes.char, len(node.chars)))
        self.il.register_literal_string(il_value, node.chars)
        return ast.DirectLValue(il_value)

    def make_const_int(self, node):
        if isinstance(node, ast.Number):
            return node.number
        elif isinstance(node, ast.Plus):
            left = self.make_const_int(node.left)
            right = self.make_const_int(node.right)
            if left is not None and right is not None:
                return left + right
        else:
            return None

    def visit_Compound(self, node):
        old_scope = self.current_scope
        self.current_scope = str(id(node))
        for n in node.items:
            self.visit(n)
        self.current_scope = old_scope

    def visit_ExprStatement(self, node):
        self.visit(node.expr)

    def visit_Equals(self, node):
        right = self.visit(node.right).val(self.il)
        left = self.visit(node.left)

        if not left.modable():
            raise TypeError("{} is not modable".format(left.type))

        right = self._set_type(right, left.type)
        left.set_to(right, self.il)
        return left

    def visit_PlusEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)
        if not left.modable():
            raise TypeError("{} is not modable".format(left.type))

        left_val = left.val(self.il)
        right_val = right.val(self.il)
        left_val, right_val = self._arith_convert(left_val, right_val)

        output = il.ILValue(left_val.type)

        if left.type.is_pointer():
            if left.type.arg.size != 1:
                type_len = il.ILValue(ctypes.unsig_char)
                self.il.register_literal_value(type_len, left.type.arg.size)

                offset = il.ILValue(ctypes.unsig_int)
                self.il.add(il.Mult(right_val, type_len, offset))
            else:
                offset = right_val
            self.il.add(il.Add(left_val, offset, output))
        else:
            self.il.add(il.Add(left_val, right_val, output))
        left.set_to(output, self.il)
        return left

    def visit_MinusEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        if not left.modable():
            raise TypeError("{} is not modable".format(left.type))
        output = il.ILValue(left.type)
        left_val = left.val(self.il)
        self.il.add(il.Sub(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_StarEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        if not left.modable():
            raise TypeError("{} is not modable".format(left.type))
        output = il.ILValue(left.type)
        left_val = left.val(self.il)
        self.il.add(il.Mult(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_DivEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        if not left.modable():
            raise TypeError("{} is not modable".format(left.type))
        output = il.ILValue(left.type)
        left_val = left.val(self.il)
        self.il.add(il.Div(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_ModEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        if not left.modable():
            raise TypeError("{} is not modable".format(left.type))
        output = il.ILValue(left.type)
        left_val = left.val(self.il)
        self.il.add(il.Mod(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_MultiExpr(self, node):
        self.visit(node.left)
        val = self.visit(node.right).val(self.il)
        return val

    def visit_ParenExpr(self, node):
        il_value = self.visit(node.expr)
        return il_value

    def visit_Plus(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)

        left_val = left.val(self.il)
        right_val = right.val(self.il)
        left_val, right_val = self._arith_convert(left_val, right_val)

        output = il.ILValue(left_val.type)

        if left.type.is_pointer():
            if left.type.arg.size != 1:
                type_len = il.ILValue(ctypes.unsig_char)
                self.il.register_literal_value(type_len, left.type.arg.size)

                offset = il.ILValue(ctypes.unsig_int)
                self.il.add(il.Mult(right_val, type_len, offset))
            else:
                offset = right_val
            self.il.add(il.Add(left_val, offset, output))
        else:
            self.il.add(il.Add(left_val, right_val, output))
        return output

    def visit_Minus(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)

        left_val = left.val(self.il)
        right_val = right.val(self.il)
        left_val, right_val = self._arith_convert(left_val, right_val)

        output = il.ILValue(left.type)

        if left.type.is_pointer():
            if left.type.arg.size != 1:
                type_len = il.ILValue(ctypes.unsig_char)
                self.il.register_literal_value(type_len, left.type.arg.size)

                offset = il.ILValue(ctypes.unsig_int)
                self.il.add(il.Mult(right_val, type_len, offset))
            else:
                offset = right_val
            self.il.add(il.Sub(left_val, offset, output))
        else:
            self.il.add(il.Sub(left_val, right_val, output))
        return output

    def visit_Mult(self, node):
        left = self.visit(node.left)
        left_val = left.val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(left.type)
        self.il.add(il.Mult(left_val, right, output))
        return output

    def visit_Div(self, node):
        left = self.visit(node.left)
        left_val = left.val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(left.type)
        self.il.add(il.Div(left_val, right, output))
        return output

    def visit_Mod(self, node):
        left = self.visit(node.left)
        left_val = left.val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(left.type)
        self.il.add(il.Mod(left_val, right, output))
        return output

    def visit_BoolAnd(self, node):
        output = il.ILValue(ctypes.char)

        init = il.ILValue(ctypes.char)
        self.il.register_literal_value(init, 0)
        other = il.ILValue(ctypes.char)
        self.il.register_literal_value(other, 1)

        set_out = self.il.get_label()
        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        left_conition, left_jmp_inst = self.simplify_condition(node.left)
        left_conition = left_conition.val(self.il)
        self.il.add(left_jmp_inst(left_conition, end))

        right_condition, right_jmp_inst = self.simplify_condition(node.right)
        right_condition = right_condition.val(self.il)
        self.il.add(right_jmp_inst(right_condition, end))

        self.il.add(il.Set(other, output))
        self.il.add(il.Label(end))

        return output

    def visit_BoolOr(self, node):
        output = il.ILValue(ctypes.char)

        init = il.ILValue(ctypes.char)
        self.il.register_literal_value(init, 0)
        other = il.ILValue(ctypes.char)
        self.il.register_literal_value(other, 1)

        set_out = self.il.get_label()
        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        left = self.visit(node.left).val(self.il)
        self.il.add(il.JmpNotZero(left, set_out))

        right = self.visit(node.right).val(self.il)
        self.il.add(il.JmpNotZero(right, set_out))
        self.il.add(il.Jmp(end))

        self.il.add(il.Label(set_out))
        self.il.add(il.Set(other, output))
        self.il.add(il.Label(end))

        return output

    def visit_BoolNot(self, node):
        output = il.ILValue(ctypes.char)

        init = il.ILValue(ctypes.char)
        self.il.register_literal_value(init, 1)
        other = il.ILValue(ctypes.char)
        self.il.register_literal_value(other, 0)

        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        condition, jmp_inst = self.simplify_condition(node.expr)
        condition = condition.val(self.il)
        self.il.add(jmp_inst(condition, end))
        self.il.add(il.Set(other, output))
        self.il.add(il.Label(end))

        return output

    def visit_And(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)

        left_val = left.val(self.il)
        right_val = right.val(self.il)
        left_val, right_val = self._arith_convert(left_val, right_val)

        output = il.ILValue(left_val.type)

        self.il.add(il.And(left_val, right_val, output))
        return output

    def visit_IncOr(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)

        left_val = left.val(self.il)
        right_val = right.val(self.il)
        left_val, right_val = self._arith_convert(left_val, right_val)

        output = il.ILValue(left_val.type)

        self.il.add(il.IncOr(left_val, right_val, output))
        return output

    def visit_ExcOr(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)

        left_val = left.val(self.il)
        right_val = right.val(self.il)
        left_val, right_val = self._arith_convert(left_val, right_val)

        output = il.ILValue(left_val.type)

        self.il.add(il.ExcOr(left_val, right_val, output))
        return output

    def visit_Negate(self, node):
        expr = self.visit(node.expr).val(self.il)

        output = il.ILValue(expr.type)

        self.il.add(il.Neg(expr, output))
        return output

    def visit_Conditional(self, node):
        condition, jmp_inst = self.simplify_condition(node.condition)
        condition = condition.val(self.il)
        left = self.visit(node.statement)
        right = self.visit(node.else_statement)

        max_len = max([left.type, right.type], key=lambda v: v.size)
        output = il.ILValue(max_len)

        else_label = self.il.get_label()

        self.il.add(jmp_inst(condition, else_label))
        left_val = left.val(self.il)
        self.il.add(il.Set(left_val, output))
        else_end_label = self.il.get_label()
        self.il.add(il.Jmp(else_end_label))

        self.il.add(il.Label(else_label))
        right_val = right.val(self.il)
        self.il.add(il.Set(right_val, output))
        self.il.add(il.Label(else_end_label))

        return output

    def visit_Equality(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(ctypes.char)

        self.il.add(il.EqualCmp(left, right, output))
        return output

    def visit_Inequality(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(ctypes.char)

        self.il.add(il.NotEqualCmp(left, right, output))
        return output

    def visit_LessThan(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(ctypes.char)

        self.il.add(il.LessThanCmp(left, right, output))
        return output

    def visit_MoreThan(self, node):

        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(ctypes.char)

        self.il.add(il.MoreThanCmp(left, right, output))
        return output

    def visit_LessEqual(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(ctypes.char)

        self.il.add(il.LessEqualCmp(left, right, output))
        return output

    def visit_MoreEqual(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(ctypes.char)

        self.il.add(il.MoreEqualCmp(left, right, output))
        return output

    def visit_PreIncr(self, node):
        expr = self.visit(node.expr)
        value = expr.val(self.il)
        new_val = il.ILValue(expr.type)

        if expr.type.is_pointer() and expr.type.arg.size != 1:
            type_len = il.ILValue(ctypes.unsig_char)
            self.il.register_literal_value(type_len, expr.type.arg.size)
            self.il.add(il.Add(value, type_len, new_val))
            expr.set_to(new_val, self.il)
        else:
            one = il.ILValue(expr.type)
            self.il.register_literal_value(one, 1)
            self.il.add(il.Add(one, value, new_val))
            expr.set_to(new_val, self.il)
        return value

    def visit_PostIncr(self, node):
        expr = self.visit(node.expr)
        value = expr.val(self.il)
        output = il.ILValue(expr.type)
        new_val = il.ILValue(expr.type)

        self.il.add(il.Set(value, output))
        if value.type.is_pointer() and value.type.arg.size != 1:
            type_len = il.ILValue(ctypes.unsig_char)
            self.il.register_literal_value(type_len, expr.type.arg.size)
            self.il.add(il.Add(value, type_len, new_val))
            expr.set_to(new_val, self.il)
        else:
            one = il.ILValue(expr.type)
            self.il.register_literal_value(one, 1)
            self.il.add(il.Add(one, value, new_val))
            expr.set_to(new_val, self.il)
        return output

    def visit_PreDecr(self, node):
        expr = self.visit(node.expr)
        value = expr.val(self.il)
        new_val = il.ILValue(expr.type)

        if expr.type.is_pointer() and expr.type.arg.size != 1:
            type_len = il.ILValue(ctypes.unsig_char)
            self.il.register_literal_value(type_len, expr.type.arg.size)
            self.il.add(il.Sub(value, type_len, new_val))
            expr.set_to(new_val, self.il)
        else:
            one = il.ILValue(expr.type)
            self.il.register_literal_value(one, 1)
            self.il.add(il.Sub(one, value, new_val))
            expr.set_to(new_val, self.il)
        return value

    def visit_PostDecr(self, node):
        expr = self.visit(node.expr)
        value = expr.val(self.il)
        output = il.ILValue(expr.type)
        new_val = il.ILValue(expr.type)

        self.il.add(il.Set(value, output))
        if value.type.is_pointer() and value.type.arg.size != 1:
            type_len = il.ILValue(ctypes.unsig_char)
            self.il.register_literal_value(type_len, expr.type.arg.size)
            self.il.add(il.Sub(value, type_len, new_val))
            expr.set_to(new_val, self.il)
        else:
            one = il.ILValue(expr.type)
            self.il.register_literal_value(one, 1)
            self.il.add(il.Sub(one, value, new_val))
            expr.set_to(new_val, self.il)
        return output

    def visit_AddrOf(self, node):
        value = self.visit(node.expr)
        return value.addr(self.il)

    def visit_Deref(self, node):
        value = self.visit(node.expr)
        if value.type.arg.is_void():
            raise SyntaxError("Can't dereference void pointer")
        offset = il.ILValue(ctypes.unsig_int)
        self.il.register_literal_value(offset, 0)
        return ast.IndirectLValue(value.val(self.il), value.type.arg, offset)

    def visit_ObjPtrMember(self, node):
        head = self.visit(node.head)
        if not head.type.is_pointer():
            raise SyntaxError("Object is not pointer")
        if not head.type.arg.is_struct_union():
            raise SyntaxError("Object pointed to is not struct or union")

        member = node.member
        offset = head.type.arg.get_offset(member)
        if offset[0] is None:
            raise SyntaxError(f"{member} is not a member of the struct")

        offset_val = il.ILValue(ctypes.unsig_char)
        self.il.register_literal_value(offset_val, offset[0])

        val = head.val(self.il)
        return ast.IndirectLValue(val, offset[1], offset_val)

    def visit_ArraySubsc(self, node):
        head = self.visit(node.head)
        arg = self.visit(node.arg).val(self.il)

        htype = None
        if head.type.is_array():
            htype = head.type.el
            head_val = head.addr(self.il)
        elif head.type.is_pointer():
            htype = head.type.arg
            head_val = head.val(self.il)

        if htype.size != 1:
            type_len = il.ILValue(ctypes.unsig_char)
            self.il.register_literal_value(type_len, htype.size)

            offset = il.ILValue(ctypes.unsig_int)
            self.il.add(il.Mult(type_len, arg, offset))
        else:
            offset = arg

        return ast.IndirectLValue(head_val, htype, offset)

    def simplify_condition(self, condition):
        if isinstance(condition, ast.BoolNot):
            return self.simplify_condition(condition.expr)[0], il.JmpNotZero
        else:
            return self.visit(condition), il.JmpZero

    def visit_IfStatement(self, node):
        condition, jmp_inst = self.simplify_condition(node.condition)
        condition = condition.val(self.il)

        end_label = self.il.get_label()

        self.il.add(jmp_inst(condition, end_label))
        self.visit(node.statement)
        if node.else_statement is not None:
            else_end_label = self.il.get_label()

            self.il.add(il.Jmp(else_end_label))
            self.il.add(il.Label(end_label))
            self.visit(node.else_statement)
            self.il.add(il.Label(else_end_label))
        else:
            self.il.add(il.Label(end_label))
        
    def visit_WhileStatement(self, node):
        start_label = self.il.get_label()
        end_label = self.il.get_label()

        self.il.add(il.Label(start_label))
        condition, jmp_inst = self.simplify_condition(node.condition)
        condition = condition.val(self.il)

        self.il.add(jmp_inst(condition, end_label))

        self.current_loop["start"] = start_label
        self.current_loop["end"] = end_label
        self.visit(node.statement)

        self.il.add(il.Jmp(start_label))

        self.il.add(il.Label(end_label))

    def visit_DoWhileStatement(self, node):
        start_label = self.il.get_label()
        end_label = self.il.get_label()

        self.il.add(il.Label(start_label))

        self.current_loop["start"] = start_label
        self.current_loop["end"] = end_label
        self.visit(node.statement)

        condition, jmp_inst = self.simplify_condition(node.condition)
        condition = condition.val(self.il)
        self.il.add(jmp_inst(condition, end_label))
        self.il.add(il.Jmp(start_label))

        self.il.add(il.Label(end_label))
        
    def visit_ForStatement(self, node):
        start_label = self.il.get_label()
        mod_label = self.il.get_label()
        end_label = self.il.get_label()

        if node.first:
            self.visit(node.first)
        self.il.add(il.Label(start_label))

        if node.second:
            condition, jmp_inst = self.simplify_condition(node.second)
            condition = condition.val(self.il)
            self.il.add(jmp_inst(condition, end_label))

        self.current_loop["start"] = mod_label
        self.current_loop["end"] = end_label
        self.visit(node.statement)

        self.il.add(il.Label(mod_label))
        if node.third:
            self.visit(node.third)

        self.il.add(il.Jmp(start_label))
        self.il.add(il.Label(end_label))
        
    def visit_Break(self, node):
        if self.current_loop["end"] == "":
            raise SyntaxError("Break outside loop")
        else:
            self.il.add(il.Jmp(self.current_loop["end"]))
        
    def visit_Continue(self, node):
        if self.current_loop["start"] == "":
            raise SyntaxError("Continue outside loop")
        else:
            self.il.add(il.Jmp(self.current_loop["start"]))

    def visit_NoOp(self, node):
        pass

    def visit_SizeofType(self, node):
        decl_info = self.scope.lookup_decl(id(node))
        val = il.ILValue(ctypes.unsig_int)
        self.il.register_literal_value(val, decl_info.ctype.size)
        return val

    def visit_Sizeof(self, node):
        node_val = self.visit(node.expr)
        val = il.ILValue(ctypes.unsig_int)
        self.il.register_literal_value(val, node_val.type.size)
        return val

    def visit_Cast(self, node):
        val = self.visit(node.expr).val(self.il)
        decl_info = self.scope.lookup_decl(id(node))
        output = il.ILValue(decl_info.ctype)

        self.il.add(il.Set(val, output))
        return output

    def visit_Return(self, node):
        if node.right is not None:
            value = self.visit(node.right).val(self.il)
        else:
            value = il.ILValue(self.current_function.ctype.ret)
            self.il.register_literal_value(value, 0)
        self.il.add(il.Return(value))

    def interpret(self, ast_root) -> il.IL:
        self.visit(ast_root)
        return self.il

    def _set_type(self, il_value, ctype: ctypes.CType):
        if il_value.type.is_void():
            raise RuntimeError("Can't do anything with void type")
        if il_value.type == ctype:
            return il_value.val(self.il)
        else:
            output = il.ILValue(ctype)
            if isinstance(il_value, il.ILValue):
                iv = il_value
            else:
                iv = il_value.il_value
            if ctype.is_pointer() and ctype.arg == ctypes.char and self.il.is_string_literal(iv):
                il_value = il_value.addr(self.il)
            else:
                il_value = il_value.val(self.il)
            self.il.add(il.Set(il_value, output))
            return output

    def _arith_convert(self, left: il.ILValue, right: il.ILValue):
        max_len = max([left.type, right.type], key=lambda v: v.size)
        return self._set_type(left, max_len), self._set_type(right, max_len)
