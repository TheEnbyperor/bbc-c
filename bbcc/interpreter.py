from . import ast
from . import decl_tree
from .tokens import *
from . import il


class Interpreter(ast.NodeVisitor):
    variables = {}

    def __init__(self, asm, scope, il):
        self.asm = asm
        self.scope = scope
        self.il = il
        self.current_scope = ""
        self.branch_count = 1

    def visit_TranslationUnit(self, node):
        self.asm.add_inst("LDA", "#0", "mul")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result - 2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result - 3))
        self.asm.add_inst("LDX", "#&10")
        self.asm.add_inst("LSR", "&" + self.asm.to_hex(self.asm.num1 - 1), "mul1")
        self.asm.add_inst("ROR", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("BCC", "mul2") 
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.result - 2))
        self.asm.add_inst("CLC")
        self.asm.add_inst("ADC", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result - 2))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.result - 3))
        self.asm.add_inst("ADC", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("ROR", "A", "mul2")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result - 3))
        self.asm.add_inst("ROR", "&" + self.asm.to_hex(self.asm.result - 2))
        self.asm.add_inst("ROR", "&" + self.asm.to_hex(self.asm.result - 1))
        self.asm.add_inst("ROR", "&" + self.asm.to_hex(self.asm.result))
        self.asm.add_inst("DEX")
        self.asm.add_inst("BNE", "mul1")
        self.asm.add_inst("JSR", "movres")
        self.asm.add_inst("RTS")
        self.asm.add_inst("LDA", "#0", "div")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result - 1))
        self.asm.add_inst("LDX", "#16")
        self.asm.add_inst("ASL", "&" + self.asm.to_hex(self.asm.num1), "div1")
        self.asm.add_inst("ROL", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("ROL", "&" + self.asm.to_hex(self.asm.result))
        self.asm.add_inst("ROL", "&" + self.asm.to_hex(self.asm.result - 1))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.result))
        self.asm.add_inst("SEC")
        self.asm.add_inst("SBC", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("TAY")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.result - 1))
        self.asm.add_inst("SBC", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("BCC", "div2")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result - 1))
        self.asm.add_inst("STY", "&" + self.asm.to_hex(self.asm.result))
        self.asm.add_inst("INC", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("DEX", label="div2")
        self.asm.add_inst("BNE", "div1")
        self.asm.add_inst("RTS")
        self.asm.add_inst("CLC", label="add")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("ADC", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("ADC", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result - 1))
        self.asm.add_inst("JSR", "movres")
        self.asm.add_inst("RTS")
        self.asm.add_inst("SEC", label="sub")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("SBC", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("SBC", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result - 1))
        self.asm.add_inst("JSR", "movres")
        self.asm.add_inst("RTS")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2), "movnum")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("RTS")
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num1), "movloc")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc3))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc4))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc3 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc4 - 1))
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("RTS")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.result), "movres")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.result - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("RTS")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2), "neg")
        self.asm.add_inst("EOR", "#&FF")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("EOR", "#&FF")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "#1")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("JSR", "add")
        self.asm.add_inst("JSR", "movres")
        self.asm.add_inst("RTS")
        self.asm.add_inst("LDA", "#0", "reset")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result - 2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result - 3))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.ret))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.ret - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.temp))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.temp - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc3))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc3 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc4))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc4 + 1))
        self.asm.add_inst("RTS")
        for n in node.items:
            self.visit(n)

    def visit_Declaration(self, node):
        for i, d in enumerate(node.decls):
            if type(d.child) == decl_tree.Identifier:
                var_name = d.child.identifier.value
                var = self.scope.lookup(var_name, self.current_scope)
                if var.type.name == INT or var.type.name == CHAR:
                    self.asm.add_inst("LDA", "#0")
                    self.asm.add_inst("STA", "&" + self.asm.to_hex(var.location))
                    self.asm.add_inst("STA", "&" + self.asm.to_hex(var.location - 1))
                if node.inits[i] is not None:
                    self.visit(node.inits[i])
                    self.asm.add_inst("LDY", "#0")
                    self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
                    self.asm.add_inst("STA", "&" + self.asm.to_hex(var.location))
                    self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
                    self.asm.add_inst("STA", "&" + self.asm.to_hex(var.location - 1))

    # TODO: Implement arguments
    def visit_Function(self, node):
        func_name = node.name.identifier.value
        self.current_scope = func_name
        if func_name == "main":
            self.asm.add_inst("JSR", "reset", label=func_name)
        else:
            self.asm.add_inst(label=func_name)
        self.visit(node.nodes)
        self.asm.add_inst("RTS")
        self.current_scope = ""

    # TODO: Implement arguments
    def visit_FuncCall(self, node):
        self.asm.add_inst("JSR", node.func.identifier.value)
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.ret))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.ret - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))

    def visit_Identifier(self, node):
        var_name = node.identifier.value
        val = self.scope.lookup(var_name, self.current_scope)
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(val.location, 4)[2:4])
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(val.location, 4)[0:2])
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(val.location - 1, 4)[2:4])
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(val.location - 1, 4)[0:2])
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))

    def visit_Compound(self, node):
        for n in node.items:
            self.visit(n)

    def visit_ExprStatement(self, node):
        self.visit(node.expr)

    def visit_Equals(self, node):
        self.visit(node.right)
        self.asm.add_inst("JSR", "movloc")
        self.visit(node.left)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc3) + "),Y")
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc4) + "),Y")
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")

    def visit_PlusEquals(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movloc")
        self.visit(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc3) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc4) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "add")
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")

    def visit_MinusEquals(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movloc")
        self.visit(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc3) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc4) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "sub")
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")

    def visit_StarEquals(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movloc")
        self.visit(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc3) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc4) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "mul")
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")

    def visit_DivEquals(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movloc")
        self.visit(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc3) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc4) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "div")
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")

    def visit_ModEquals(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movloc")
        self.visit(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc3) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc4) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "div")
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.result))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.result - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")

    def visit_MultiExpr(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_Number(self, node):
        il_value = il.ILValue('int')
        self.il.register_literal_value(il_value, node.number)
        return il_value
        # self.asm.add_inst("LDA", "#&" + self.asm.to_hex(node.number, 4)[2:4])
        # self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        # self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2))
        # self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        # self.asm.add_inst("LDA", "#0")
        # self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))
        # self.asm.add_inst("LDA", "#&" + self.asm.to_hex(node.number, 4)[0:2])
        # self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        # self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2 - 1))
        # self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        # self.asm.add_inst("LDA", "#0")
        # self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))

    # TODO: Implement
    def visit_String(self, node):
        pass

    # TODO: Reimplementing
    def visit_ParenExpr(self, node):
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("PHA")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1-1))
        self.asm.add_inst("PHA")
        self.visit(node.expr)
        self.asm.add_inst("PLA")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1-1))
        self.asm.add_inst("PLA")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))

    # TODO: Reimplementing
    def check_ArithOp(self, node):
        if isinstance(node, ast._ArithBinOp):
            self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
            self.asm.add_inst("PHA")
            self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1-1))
            self.asm.add_inst("PHA")
            self.visit(node)
            self.asm.add_inst("PLA")
            self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1-1))
            self.asm.add_inst("PLA")
            self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        else:
            self.visit(node)

    def visit_Plus(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)
        output = il.ILValue('int')
        self.il.add(il.Add(left, right, output))
        return output

    def visit_Minus(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)
        output = il.ILValue('int')
        self.il.add(il.Sub(left, right, output))
        return output

    def visit_Mult(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)
        output = il.ILValue('int')
        self.il.add(il.Mult(left, right, output))
        return output

    def visit_Div(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)
        output = il.ILValue('int')
        self.il.add(il.Div(left, right, output))
        return output

    def visit_Mod(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)
        output = il.ILValue('int')
        self.il.add(il.Mod(left, right, output))
        return output

    def visit_Equality(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)
        output = il.ILValue('int')
        self.il.add(il.EqualCmp(left, right, output))
        return output

    def visit_Inequality(self, node):
        left = self.visit(node.left)
        right = self.visit(node.right)
        output = il.ILValue('int')
        self.il.add(il.NotEqualCmp(left, right, output))
        return output

    def visit_BoolAnd(self, node):
        output = il.ILValue('int')

        init = il.ILValue('int')
        self.il.register_literal_var(init, 1)
        other = il.ILValue('int')
        self.il.register_literal_var(other, 0)

        set_out = self.il.get_label()
        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        left = self.visit(node.left)
        self.il.add(il.JmpZero(left, set_out))

        right = self.visit(node.right)
        self.il.add(il.JmpZero(right, set_out))
        self.il.add(il.Jmp(end))

        self.il.add(il.Label(set_out))
        self.il.add(il.Set(other, output))
        self.il.add(il.Label(end))

        return output

    def visit_BoolOr(self, node):
        output = il.ILValue('int')

        init = il.ILValue('int')
        self.il.register_literal_var(init, 0)
        other = il.ILValue('int')
        self.il.register_literal_var(other, 1)

        set_out = self.il.get_label()
        end = self.il.get_label()

        self.il.add(il.Set(init, output))

        left = self.visit(node.left)
        self.il.add(il.JmpNotZero(left, set_out))

        right = self.visit(node.right)
        self.il.add(il.JmpNotZero(right, set_out))
        self.il.add(il.Jmp(end))

        self.il.add(il.Label(set_out))
        self.il.add(il.Set(other, output))
        self.il.add(il.Label(end))

        return output

    def visit_BoolNot(self, node):
        self.visit(node.expr)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("CMP", "#0")
        self.asm.add_inst("BNE", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("CMP", "#0")
        self.asm.add_inst("BNE", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("LDA", "#1")
        self.asm.add_inst("JMP", "bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#0", label="bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2),
                          label="bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.branch_count += 2
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))

    def visit_LessThan(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movloc")
        self.check_ArithOp(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc3) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc4) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "sub")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 2))
        self.asm.add_inst("BMI", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("JMP", "bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#1", label="bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2),
                          label="bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.branch_count += 2
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))

    def visit_MoreThan(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movloc")
        self.check_ArithOp(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc3) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc4) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "sub")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 2))
        self.asm.add_inst("SBC", "#1")
        self.asm.add_inst("BPL", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("JMP", "bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#1", label="bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2),
                          label="bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.branch_count += 2
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))

    def visit_LessEqual(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movloc")
        self.check_ArithOp(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc3) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc4) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "sub")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 2))
        self.asm.add_inst("SBC", "#1")
        self.asm.add_inst("BMI", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("JMP", "bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#1", label="bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2),
                          label="bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.branch_count += 2
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))

    def visit_MoreEqual(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movloc")
        self.check_ArithOp(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc3) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc4) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "sub")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 2))
        self.asm.add_inst("BPL", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("JMP", "bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#1", label="bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2),
                          label="bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.branch_count += 2
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))

    def visit_PreIncr(self, node):
        self.visit(node.expr)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "#1")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "add")
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))

    def visit_PostIncr(self, node):
        self.visit(node.expr)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.temp))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.temp - 1))
        self.asm.add_inst("LDA", "#1")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "add")
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.temp))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.temp - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))

    def visit_PreDecr(self, node):
        self.visit(node.expr)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "#1")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "sub")
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))

    def visit_PostDecr(self, node):
        self.visit(node.expr)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.temp))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.temp - 1))
        self.asm.add_inst("LDA", "#1")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "sub")
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.temp))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.temp - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))

    def visit_AddrOf(self, node):
        self.visit(node.expr)
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.loc1 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))

    def visit_Deref(self, node):
        self.visit(node.expr)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc1 + 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "#1")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "sub")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc2 + 1))

    def visit_IfStatement(self, node):
        self.visit(node.condition)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("CMP", "#0")
        self.asm.add_inst("BEQ", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("CMP", "#0")
        self.asm.add_inst("BEQ", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.visit(node.statement)
        if node.else_statement is not None:
            self.asm.add_inst("JMP", "bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
            self.asm.add_inst(label="bbcc_" + self.current_scope + "_" + str(self.branch_count))
            self.visit(node.else_statement)
        self.asm.add_inst(label="bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.branch_count += 2
        
    def visit_WhileStatement(self, node):
        self.asm.add_inst(label="bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.visit(node.condition)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("CMP", "#0")
        self.asm.add_inst("BEQ", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("CMP", "#0")
        self.asm.add_inst("BEQ", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.visit(node.statment)
        self.asm.add_inst("JMP", "bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("", label="bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.branch_count += 2
        
    def visit_ForStatement(self, node):
        self.visit(node.first)
        self.asm.add_inst("", label="bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        if node.second is not None:
            self.visit(node.second)
            self.asm.add_inst("LDY", "#0")
            self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
            self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
            self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
            self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
            self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
            self.asm.add_inst("CMP", "#0")
            self.asm.add_inst("BEQ", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
            self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1 - 1))
            self.asm.add_inst("CMP", "#0")
            self.asm.add_inst("BEQ", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.visit(node.statment)
        if node.third is not None:
            self.visit(node.third)
        self.asm.add_inst("JMP", "bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("", label="bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.branch_count += 2
        
    def visit_Break(self, node):
        self.asm.add_inst("JMP", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        
    def visit_Continue(self, node):
        self.asm.add_inst("JMP", "bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))

    def visit_NoOp(self, node):
        pass

    def visit_Return(self, node):
        self.visit(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.ret))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.ret - 1))
        self.asm.add_inst("RTS")

    def interpret(self, ast_root):
        self.visit(ast_root)
        return self.il
