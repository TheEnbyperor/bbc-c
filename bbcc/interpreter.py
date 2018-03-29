from . import ast
from . import decl_tree
from .tokens import *
from . import il


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

    def visit_TranslationUnit(self, node):
        self.il.add(il.Routines())

        self.il.add(il.Label("_setup_global"))
        for n in node.items:
            if isinstance(n, ast.Declaration):
                self.visit(n)
        self.il.add(il.Return(None, epilouge=False))

        ret_val = il.ILValue('int')
        self.il.add(il.Function([], "_start", prolouge=False))

        stack_start = il.ILValue('int')
        stack_register = il.ILValue('char')
        self.il.register_literal_value(stack_start, 0x0018)
        self.il.register_spot_value(stack_register, il.stack_register)
        self.il.add(il.Set(stack_start, stack_register))

        self.il.add(il.JmpSub("_setup_global"))

        self.il.add(il.CallFunction("__main", [], ret_val))
        self.il.add(il.Return(ret_val, "_start", epilouge=False))

        for n in node.items:
            if isinstance(n, ast.Function):
                self.visit(n)

    def visit_Declaration(self, node):
        for i, d in enumerate(node.decls):
            if type(d.child) == decl_tree.Identifier:
                var_name = d.child.identifier.value
                var = self.scope.lookup(var_name, self.current_scope)
                if var.type.name == INT or var.type.name == CHAR:
                    if node.inits[i] is None:
                        val = il.ILValue('int')
                        self.il.register_literal_value(val, 0)
                        self.il.add(il.Set(val, var.il_value))
                    else:
                        val = self.visit(node.inits[i]).val(self.il)
                        self.il.add(il.Set(val, var.il_value))

    def visit_Function(self, node):
        func_name = node.name.identifier.value
        self.current_scope = func_name
        params = []
        for i, p in enumerate(node.params):
            if type(p.child) == decl_tree.Identifier:
                var_name = p.child.identifier.value
                var = self.scope.lookup(var_name, self.current_scope)
                var.il_value.stack_offset = i*2
                params.append(var)
        self.il.add(il.Function(params, "__{}".format(func_name)))
        self.current_function = "__{}".format(func_name)
        self.visit(node.nodes)
        should_return = True
        if node.nodes.items is not None:
            if isinstance(node.nodes.items[-1], ast.Return):
                should_return = False
        if should_return:
            il_value = il.ILValue('int')
            self.il.register_literal_value(il_value, 0)
            self.il.add(il.Return(il_value, "__{}".format(func_name)))
        self.current_scope = ""

    def visit_FuncCall(self, node):
        func_name = node.func.identifier.value
        func = self.scope.lookup(func_name, self.current_scope)

        args = []
        for a in node.args:
            args.append(self.visit(a).val(self.il))

        output = il.ILValue(func.type)
        self.il.add(il.CallFunction("__{}".format(func_name), args, output))
        return output

    def visit_Identifier(self, node):
        var_name = node.identifier.value
        val = self.scope.lookup(var_name, self.current_scope)
        return ast.DirectLValue(val.il_value)

    def visit_Compound(self, node):
        for n in node.items:
            self.visit(n)

    def visit_ExprStatement(self, node):
        self.visit(node.expr)

    def visit_Equals(self, node):
        right = self.visit(node.right).val(self.il)
        left = self.visit(node.left)
        left.set_to(right, self.il)
        return right

    def visit_PlusEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')
        left_val = left.val(self.il)
        self.il.add(il.Sub(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_MinusEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')
        left_val = left.val(self.il)
        self.il.add(il.Sub(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_StarEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')
        left_val = left.val(self.il)
        self.il.add(il.Mult(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_DivEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')
        left_val = left.val(self.il)
        self.il.add(il.Div(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_ModEquals(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')
        left_val = left.val(self.il)
        self.il.add(il.Mod(left_val, right, output))
        left.set_to(output, self.il)
        return left

    def visit_MultiExpr(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_Number(self, node):
        il_value = il.ILValue('int')
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
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')
        self.il.add(il.Add(left, right, output))
        return output

    def visit_Minus(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')
        self.il.add(il.Sub(left, right, output))
        return output

    def visit_Mult(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')
        self.il.add(il.Mult(left, right, output))
        return output

    def visit_Div(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')
        self.il.add(il.Div(left, right, output))
        return output

    def visit_Mod(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')
        self.il.add(il.Mod(left, right, output))
        return output

    def visit_BoolAnd(self, node):
        output = il.ILValue('int')

        init = il.ILValue('int')
        self.il.register_literal_value(init, 1)
        other = il.ILValue('int')
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
        output = il.ILValue('int')

        init = il.ILValue('int')
        self.il.register_literal_value(init, 0)
        other = il.ILValue('int')
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
        output = il.ILValue('int')

        init = il.ILValue('int')
        self.il.register_literal_value(init, 1)
        other = il.ILValue('int')
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
        output = il.ILValue('int')

        init = il.ILValue('int')
        self.il.register_literal_value(init, 0)
        other = il.ILValue('int')
        self.il.register_literal_value(other, 1)

        set_out = self.il.get_label()
        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        self.il.add(il.EqualCmp(left, right, set_out))
        self.il.add(il.Jmp(end))

        self.il.add(il.Label(set_out))
        self.il.add(il.Set(other, output))
        self.il.add(il.Label(end))

        return output

    def visit_Inequality(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')

        init = il.ILValue('int')
        self.il.register_literal_value(init, 0)
        other = il.ILValue('int')
        self.il.register_literal_value(other, 1)

        set_out = self.il.get_label()
        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        self.il.add(il.NotEqualCmp(left, right, set_out))
        self.il.add(il.Jmp(end))

        self.il.add(il.Label(set_out))
        self.il.add(il.Set(other, output))
        self.il.add(il.Label(end))

        return output

    def visit_LessThan(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')

        init = il.ILValue('int')
        self.il.register_literal_value(init, 0)
        other = il.ILValue('int')
        self.il.register_literal_value(other, 1)

        set_out = self.il.get_label()
        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        self.il.add(il.LessThanCmp(left, right, set_out))
        self.il.add(il.Jmp(end))

        self.il.add(il.Label(set_out))
        self.il.add(il.Set(other, output))
        self.il.add(il.Label(end))

        return output

    def visit_MoreThan(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')

        init = il.ILValue('int')
        self.il.register_literal_value(init, 0)
        other = il.ILValue('int')
        self.il.register_literal_value(other, 1)

        set_out = self.il.get_label()
        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        self.il.add(il.MoreThanCmp(left, right, set_out))
        self.il.add(il.Jmp(end))

        self.il.add(il.Label(set_out))
        self.il.add(il.Set(other, output))
        self.il.add(il.Label(end))

        return output

    def visit_LessEqual(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')

        init = il.ILValue('int')
        self.il.register_literal_value(init, 0)
        other = il.ILValue('int')
        self.il.register_literal_value(other, 1)

        set_out = self.il.get_label()
        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        self.il.add(il.LessEqualCmp(left, right, set_out))
        self.il.add(il.Jmp(end))

        self.il.add(il.Label(set_out))
        self.il.add(il.Set(other, output))
        self.il.add(il.Label(end))

        return output

    def visit_MoreEqual(self, node):
        left = self.visit(node.left).val(self.il)
        right = self.visit(node.right).val(self.il)
        output = il.ILValue('int')

        init = il.ILValue('int')
        self.il.register_literal_value(init, 0)
        other = il.ILValue('int')
        self.il.register_literal_value(other, 1)

        set_out = self.il.get_label()
        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        self.il.add(il.MoreEqualCmp(left, right, set_out))
        self.il.add(il.Jmp(end))

        self.il.add(il.Label(set_out))
        self.il.add(il.Set(other, output))
        self.il.add(il.Label(end))

        return output

    def visit_PreIncr(self, node):
        value = self.visit(node.expr).val(self.il)
        self.il.add(il.Inc(value))
        return value

    def visit_PostIncr(self, node):
        value = self.visit(node.expr).val(self.il)
        output = il.ILValue('int')

        self.il.add(il.Set(value, output))
        self.il.add(il.Inc(value))
        return output

    def visit_PreDecr(self, node):
        value = self.visit(node.expr).val(self.il)

        self.il.add(il.Dec(value))
        return value

    def visit_PostDecr(self, node):
        value = self.visit(node.expr).val(self.il)
        output = il.ILValue('int')

        self.il.add(il.Set(value, output))
        self.il.add(il.Dec(value))
        return output

    def visit_AddrOf(self, node):
        output = il.ILValue('int')
        value = self.visit(node.expr)
        value.addr_of(output, self.il)
        return output

    def visit_Deref(self, node):
        value = self.visit(node.expr)

        return ast.IndirectLValue(value)

    def visit_ArraySubsc(self, node):
        head = self.visit(node.head).val(self.il)
        arg = self.visit(node.arg).val(self.il)

        output = il.ILValue('int')
        self.il.add(il.Add(head, arg, output))
        return ast.IndirectLValue(output)

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
        if self.current_loop["end"] is "":
            raise SyntaxError("Break outside loop")
        else:
            self.il.add(il.Jmp(self.current_loop["end"]))
        
    def visit_Continue(self, node):
        if self.current_loop["start"] is "":
            raise SyntaxError("Continue outside loop")
        else:
            self.il.add(il.Jmp(self.current_loop["start"]))

    def visit_NoOp(self, node):
        pass

    def visit_Return(self, node):
        value = self.visit(node.right).val(self.il)
        self.il.add(il.Return(value, self.current_function))

    def interpret(self, ast_root) -> il.IL:
        self.visit(ast_root)
        return self.il
