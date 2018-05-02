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
        decl_infos = node.get_decls_info()

        for d in decl_infos:
            if type(d.ctype) != ctypes.FunctionCType:
                var_name = d.identifier.value
                var_global = self.scope.lookup(var_name, "")
                if var_global is None:
                    var = self.scope.lookup(var_name, self.current_scope)
                    if type(var.type) == ctypes.IntegerCType:
                        if d.init is None:
                            val = il.ILValue(var.type)
                            self.il.register_literal_value(val, 0)
                            self.il.add(il.Set(val, var.il_value))
                        else:
                            val = self.visit(d.init).val(self.il)
                            self.il.add(il.Set(val, var.il_value))

    def visit_Function(self, node):
        func_name = node.name.identifier.value
        old_scope = self.current_scope
        self.current_scope = str(id(node))

        params = []
        offset = 0
        for param in node.params:
            param = ast.Declaration(param)
            param = param.get_decls_info()[0]
            param_name = param.identifier.value
            param = self.scope.lookup(param_name, self.current_scope)
            param.il_value.stack_offset = offset
            offset += param.type.size
            params.append(param)
        self.il.add(il.Function(params, "__{}".format(func_name)))
        self.current_function = "__{}".format(func_name)
        for n in node.nodes.items:
            self.visit(n)
        should_return = True
        if node.nodes.items is not None:
            if isinstance(node.nodes.items[-1], ast.Return):
                should_return = False
        if should_return:
            ctype = node.make_ctype().ret
            il_value = il.ILValue(ctype)
            self.il.register_literal_value(il_value, 0)
            self.il.add(il.Return(il_value, "__{}".format(func_name)))
        self.current_scope = old_scope

    def visit_FuncCall(self, node):
        func_name = node.func.identifier.value
        func = self.scope.lookup(func_name, self.current_scope)

        args = []
        for a, fa in zip(node.args, func.type.args):
            arg = self.visit(a)
            if fa.is_pointer():
                arg = arg.addr(self.il)

            args.append(arg.val(self.il))

        output = il.ILValue(func.type.ret)
        self.il.add(il.CallFunction("__{}".format(func_name), args, output))
        return output

    def visit_Identifier(self, node):
        var_name = node.identifier.value
        val = self.scope.lookup(var_name, self.current_scope)
        return ast.DirectLValue(val.il_value)

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
        return right

    def visit_PlusEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(left.type)
        left_val = left.val(self.il)
        self.il.add(il.Sub(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_MinusEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(left.type)
        left_val = left.val(self.il)
        self.il.add(il.Sub(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_StarEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(left.type)
        left_val = left.val(self.il)
        self.il.add(il.Mult(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_DivEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(left.type)
        left_val = left.val(self.il)
        self.il.add(il.Div(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_ModEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(left.type)
        left_val = left.val(self.il)
        self.il.add(il.Mod(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_MultiExpr(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_Number(self, node):
        il_value = il.ILValue(ctypes.integer)
        self.il.register_literal_value(il_value, node.number)
        return il_value

    def visit_String(self, node):
        il_value = il.ILValue('string')
        self.il.register_literal_string(il_value, node.chars)
        return il_value

    def visit_ParenExpr(self, node):
        il_value = self.visit(node.expr)
        return il_value

    def visit_Plus(self, node):
        left = self.visit(node.left)
        left_val = left.val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(left.type)
        self.il.add(il.Add(left_val, right, output))
        return output

    def visit_Minus(self, node):
        left = self.visit(node.left)
        left_val = left.val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue(left.type)
        self.il.add(il.Sub(left_val, right, output))
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
        value = self.visit(node.expr).val(self.il)
        self.il.add(il.Inc(value))
        return value

    def visit_PostIncr(self, node):
        value = self.visit(node.expr)
        value_val = value.val(self.il)
        output = il.ILValue(value.type)

        self.il.add(il.Set(value_val, output))
        self.il.add(il.Inc(value_val))
        return output

    def visit_PreDecr(self, node):
        value = self.visit(node.expr).val(self.il)

        self.il.add(il.Dec(value))
        return value

    def visit_PostDecr(self, node):
        value = self.visit(node.expr)
        value_val = value.val(self.il)
        output = il.ILValue(value.type)

        self.il.add(il.Set(value_val, output))
        self.il.add(il.Dec(value_val))
        return output

    def visit_AddrOf(self, node):
        output = il.ILValue(ctypes.integer)
        value = self.visit(node.expr)
        value.addr_of(output, self.il)
        return output

    def visit_Deref(self, node):
        value = self.visit(node.expr)

        return ast.IndirectLValue(value.val(self.il), value.type)

    def visit_ArraySubsc(self, node):
        head = self.visit(node.head)
        head_val = head.val(self.il)
        arg = self.visit(node.arg).val(self.il)

        htype = None
        if head.type.is_array():
            htype = head.type.el
        elif head.type.is_pointer():
            htype = head.type.arg

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
        ctype = node.make_ctype()
        val = il.ILValue(ctypes.unsig_int)
        self.il.register_literal_value(val, ctype.size)
        return val

    def visit_Sizeof(self, node):
        node_val = self.visit(node.expr)
        val = il.ILValue(ctypes.unsig_int)
        self.il.register_literal_value(val, node_val.type.size)
        return val

    def visit_Return(self, node):
        value = self.visit(node.right).val(self.il)
        self.il.add(il.Return(value, self.current_function))

    def interpret(self, ast_root) -> il.IL:
        self.visit(ast_root)
        return self.il
