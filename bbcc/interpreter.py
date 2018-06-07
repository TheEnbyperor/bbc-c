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
                if var_global is None:
                    var = self.scope.lookup(var_name, self.current_scope)
                    if d.init is not None:
                        val = self.visit(d.init).val(self.il)
                        self.il.add(il.Set(val, var.il_value))

    def visit_Function(self, node):
        old_scope = self.current_scope
        self.current_scope = str(id(node))

        decl_info = self.scope.lookup_decl(id(node))
        params = []
        offset = 0
        func_name = decl_info.identifier.value
        for param, name in zip(decl_info.ctype.args, decl_info.params):
            param_name = name.value
            param = self.scope.lookup(param_name, self.current_scope)
            param.il_value.stack_offset = offset
            offset += param.type.size
            params.append(param)
        self.il.add(il.Function(params, func_name))
        self.current_function = func_name
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
            self.il.add(il.Return(il_value, func_name))
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
        left.set_to(right, self.il)
        return left

    def visit_PlusEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        if not left.modable():
            raise TypeError("{} is not modable".format(left.type))
        output = il.ILValue(left.type)
        left_val = left.val(self.il)
        self.il.add(il.Add(left_val, right, output))
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
        self.visit(node.right)

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
            type_len = il.ILValue(ctypes.unsig_char)
            self.il.register_literal_value(type_len, left.type.arg.size)

            offset = il.ILValue(ctypes.unsig_int)
            self.il.add(il.Mult(right_val, type_len, offset))
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
            type_len = il.ILValue(ctypes.unsig_char)
            self.il.register_literal_value(type_len, left.type.arg.size)

            offset = il.ILValue(ctypes.unsig_int)
            self.il.add(il.Mult(right_val, type_len, offset))
            self.il.add(il.Add(left_val, offset, output))
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
        self.il.register_literal_value(init, 1)
        other = il.ILValue(ctypes.char)
        self.il.register_literal_value(other, 0)

        set_out = self.il.get_label()
        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        left = self.visit(node.left).val(self.il)
        self.il.add(il.JmpZero(left, set_out))

        right = self.visit(node.right).val(self.il)
        self.il.add(il.JmpZero(right, set_out))
        self.il.add(il.Jmp(end))

        self.il.add(il.Label(set_out))
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

        set_out = self.il.get_label()
        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        expr = self.visit(node.expr).val(self.il)
        self.il.add(il.JmpNotZero(expr, set_out))
        self.il.add(il.Jmp(end))

        self.il.add(il.Label(set_out))
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

        self.il.add(il.Not(expr, output))
        return output

    def visit_Conditional(self, node):
        condition = self.visit(node.condition).val(self.il)
        left = self.visit(node.statement)
        right = self.visit(node.else_statement)

        max_len = max([left.type, right.type], key=lambda v: v.size)
        output = il.ILValue(max_len)

        else_label = self.il.get_label()

        self.il.add(il.JmpZero(condition, else_label))
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

        if expr.type.is_pointer():
            type_len = il.ILValue(ctypes.unsig_char)
            self.il.register_literal_value(type_len, expr.type.arg.size)
            self.il.add(il.Add(value, type_len, value))
        else:
            self.il.add(il.Inc(value))
        return value

    def visit_PostIncr(self, node):
        value = self.visit(node.expr)
        value_val = value.val(self.il)
        output = il.ILValue(value.type)

        self.il.add(il.Set(value_val, output))
        if value.type.is_pointer():
            type_len = il.ILValue(ctypes.unsig_char)
            self.il.register_literal_value(type_len, value.type.arg.size)
            self.il.add(il.Add(value_val, type_len, value_val))
        else:
            self.il.add(il.Inc(value_val))
        return output

    def visit_PreDecr(self, node):
        expr = self.visit(node.expr)
        value = expr.val(self.il)

        if expr.type.is_pointer():
            type_len = il.ILValue(ctypes.unsig_char)
            self.il.register_literal_value(type_len, expr.type.arg.size)
            self.il.add(il.Sub(value, type_len, value))
        else:
            self.il.add(il.Dec(value))
        return value

    def visit_PostDecr(self, node):
        value = self.visit(node.expr)
        value_val = value.val(self.il)
        output = il.ILValue(value.type)

        self.il.add(il.Set(value_val, output))
        if value.type.is_pointer():
            type_len = il.ILValue(ctypes.unsig_char)
            self.il.register_literal_value(type_len, value.type.arg.size)
            self.il.add(il.Sub(value_val, type_len, value_val))
        else:
            self.il.add(il.Dec(value_val))
        return output

    def visit_AddrOf(self, node):
        value = self.visit(node.expr)
        return value.addr(self.il)

    def visit_Deref(self, node):
        value = self.visit(node.expr)
        return ast.IndirectLValue(value.val(self.il), value.type.arg)

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

        type_len = il.ILValue(ctypes.unsig_char)
        self.il.register_literal_value(type_len, htype.size)

        offset = il.ILValue(ctypes.unsig_int)
        self.il.add(il.Mult(type_len, arg, offset))

        output = il.ILValue(ctypes.unsig_int)
        self.il.add(il.Add(head_val, offset, output))
        return ast.IndirectLValue(output, htype)

    def visit_IfStatement(self, node):
        condition = self.visit(node.condition).val(self.il)

        end_label = self.il.get_label()

        self.il.add(il.JmpZero(condition, end_label))
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
        condition = self.visit(node.condition).val(self.il)

        self.il.add(il.JmpZero(condition, end_label))

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

        condition = self.visit(node.condition).val(self.il)
        self.il.add(il.JmpZero(condition, end_label))
        self.il.add(il.Jmp(start_label))

        self.il.add(il.Label(end_label))
        
    def visit_ForStatement(self, node):
        start_label = self.il.get_label()
        end_label = self.il.get_label()

        self.visit(node.first)
        self.il.add(il.Label(start_label))

        if node.second is not None:
            condition = self.visit(node.second).val(self.il)
            self.il.add(il.JmpZero(condition, end_label))

        self.current_loop["start"] = start_label
        self.current_loop["end"] = end_label
        self.visit(node.statement)

        if node.third is not None:
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
        value = self.visit(node.right).val(self.il)
        self.il.add(il.Return(value, self.current_function))

    def interpret(self, ast_root) -> il.IL:
        self.visit(ast_root)
        return self.il

    def _set_type(self, il_value: il.ILValue, ctype: ctypes.CType):
        if il_value.type == ctype:
            return il_value
        else:
            output = il.ILValue(ctype)
            self.il.add(il.Set(il_value, output))
            return output

    def _arith_convert(self, left: il.ILValue, right: il.ILValue):
        max_len = max([left.type, right.type], key=lambda v: v.size)
        return self._set_type(left, max_len), self._set_type(right, max_len)
