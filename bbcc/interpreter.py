from .tokens import *
from . import ast
from . import decl_tree


class Interpreter(ast.NodeVisitor):
    variables = {}

    def __init__(self, asm, scope):
        self.asm = asm
        self.scope = scope
        self.current_scope = ""
        self.branch_count = 1

    def visit_Root(self, node):
        self.asm.add_inst("FOR", "opt%=0 TO 2 STEP 2")
        self.asm.add_inst("P%=&E00")
        self.asm.add_inst("[")
        self.asm.add_inst("OPT", "opt%")
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
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.result - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("RTS")
        for n in node.nodes:
            self.visit(n)
        self.asm.add_inst("]")
        self.asm.add_inst("NEXT", "opt%")
        self.asm.add_inst("CALL", "main")
        self.asm.add_inst("RL=&" + self.asm.to_hex(self.asm.ret))
        self.asm.add_inst("RH=&" + self.asm.to_hex(self.asm.ret - 1))
        self.asm.add_inst("PRINT", "~?RH,~?RL")

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
                    self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2))
                    self.asm.add_inst("STA", "&" + self.asm.to_hex(var.location))
                    self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
                    self.asm.add_inst("STA", "&" + self.asm.to_hex(var.location - 1))

    def visit_Main(self, node):
        func_name = "main"
        self.current_scope = func_name
        self.asm.add_inst("JSR", "reset", label=func_name)
        self.visit(node.body)
        self.asm.add_inst("RTS")
        self.current_scope = ""

    def visit_Identifier(self, node):
        var_name = node.identifier.value
        val = self.scope.lookup(var_name, self.current_scope)
        self.asm.add_inst("LDA", "&#" + self.asm.to_hex(val.location))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc))
        self.asm.add_inst("LDA", "&#" + self.asm.to_hex(val.location - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc - 1))

    def visit_Compound(self, node):
        for n in node.items:
            self.visit(n)

    def visit_ExprStatement(self, node):
        self.visit(node.expr)

    def visit_Equals(self, node):
        self.visit(node.right)
        self.asm.add_inst("JSR", "movnum")
        self.visit(node.left)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")

    def visit_PlusEquals(self, node):
        self.visit(node.left)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.visit(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "add")
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")

    def visit_MinusEquals(self, node):
        self.visit(node.left)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.visit(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "sub")
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")

    def visit_StarEquals(self, node):
        self.visit(node.left)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.visit(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "mul")
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")

    def visit_DivEquals(self, node):
        self.visit(node.left)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.visit(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "div")
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")

    def visit_ModEquals(self, node):
        self.visit(node.left)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.visit(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "add")
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.result))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.result - 1))
        self.asm.add_inst("STA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")

    def visit_MultiExpr(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_Number(self, node):
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(node.number.value, 4)[2:4])
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(node.number.value, 4)[0:2])
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2-1))
        self.asm.add_inst("LDA", "&#" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc))
        self.asm.add_inst("LDA", "&#" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.loc - 1))

    def visit_String(self, node):
        pass

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
        self.visit(node.left)
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.check_ArithOp(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "add")

    def visit_Minus(self, node):
        self.visit(node.left)
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.check_ArithOp(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "sub")

    def visit_Mult(self, node):
        self.visit(node.left)
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.check_ArithOp(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "mul")

    def visit_Div(self, node):
        self.visit(node.left)
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.check_ArithOp(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "div")

    def visit_Mod(self, node):
        self.visit(node.left)
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.check_ArithOp(node.right)
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.loc - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("JSR", "div")
        self.asm.add_inst("JSR", "movres")

    def visit_Equality(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movres")
        self.visit(node.right)
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("CMP", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("BNE", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("CMP", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("BNE", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("LDA", "#1")
        self.asm.add_inst("JMP", "bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#0", label="bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2), label="bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.branch_count += 2

    def visit_Inequality(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movres")
        self.visit(node.right)
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("CMP", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("BEQ", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("CMP", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("BEQ", "bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("LDA", "#1")
        self.asm.add_inst("JMP", "bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#0", label="bbcc_" + self.current_scope + "_" + str(self.branch_count))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2), label="bbcc_" + self.current_scope + "_" + str(self.branch_count + 1))
        self.asm.add_inst("LDA", "#0")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.branch_count += 2

    def visit_BoolAnd(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movres")
        self.visit(node.right)
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("AND", "&" + self.asm.to_hex(self.asm.num2))
        sefl.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("AND", "&" + self.asm.to_hex(self.asm.num2 - 1))
        sefl.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))

    def visit_BoolOr(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movres")
        self.visit(node.right)
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1))
        self.asm.add_inst("ORA", "&" + self.asm.to_hex(self.asm.num2))
        sefl.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num1 - 1))
        self.asm.add_inst("ORA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        sefl.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))

    def visit_PreIncr(self, node):
        self.visit(node.expr)

    def visit_PostIncr(self, node):
        self.visit(node.expr)

    def visit_PreDecr(self, node):
        self.visit(node.expr)

    def visit_PostDecr(self, node):
        self.visit(node.expr)

    def visit_AddrOf(self, node):
        var_name = node.expr.identifier.value
        var = self.scope.lookup(var_name, self.current_scope)
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(var.location, 4)[2:4])
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "#&" + self.asm.to_hex(var.location, 4)[0:2])
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2-1))

    def visit_Deref(self, node):
        var_name = node.expr.identifier.value
        var = self.scope.lookup(var_name, self.current_scope)
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(val.location))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(val.location - 1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))
        self.asm.add_inst("LDY", "#0")
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.num2) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("LDA", "(&" + self.asm.to_hex(self.asm.num2 - 1) + "),Y")
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.num2 - 1))

    def visit_NoOp(self, node):
        pass

    def visit_Return(self, node):
        self.visit(node.right)
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.ret))
        self.asm.add_inst("LDA", "&" + self.asm.to_hex(self.asm.num2-1))
        self.asm.add_inst("STA", "&" + self.asm.to_hex(self.asm.ret-1))

    def interpret(self, ast_root):
        self.visit(ast_root)
        return self.asm.get_asm()
