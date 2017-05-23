from .tokens import *
from . import ast


class Interpreter(ast.NodeVisitor):
    variables = {}

    def __init__(self, asm):
        self.asm = asm

    def visit_Function(self, node):
        self.asm.add_inst("", label=node.label.value)
        if node.label.value == "main":
            self.asm.add_inst("JSR", "reset")
        self.visit(node.statements)
        self.asm.add_inst("RTS")

    def visit_StatementList(self, node):
        for child in node.children:
            self.visit(child)

    def visit_NoOp(self, node):
        pass

    def visit_Define(self, node):
        var_name = node.left.value
        self.variables[var_name] = {
            "type": node.vtype,
            "start": self.memstart
        }
        if node.assign is not None:
            self.visit(node.assign)
        self.memstart -= node.vtype[1]

    def visit_Assign(self, node):
        self.visit(node.right)
        memstart = self.variables[node.left.value]["start"]
        self.asm.add_inst("LDA", "&" + ('%02x' % self.asm.num2).upper())
        self.asm.add_inst("STA", "&" + ('%02x' % memstart).upper())
        self.asm.add_inst("LDA", "&" + ('%02x' % (self.asm.num2-1)).upper())
        self.asm.add_inst("STA", "&" + ('%02x' % (memstart - 1)).upper())

    def visit_Var(self, node):
        var_name = node.value
        val = self.variables.get(var_name)
        if val is None:
            raise NameError(repr(var_name))
        else:
            if val["type"] == CTypes.int:
                self.asm.add_inst("LDA", "&" + ('%02x' % val["start"]).upper())
                self.asm.add_inst("STA", "&" + ('%02x' % self.asm.num2).upper())
                self.asm.add_inst("LDA", "&" + ('%02x' % (val["start"] - 1)).upper())
                self.asm.add_inst("STA", "&" + ('%02x' % (self.asm.num2 - 1)).upper())

    def visit_Return(self, node):
        right = node.right
        self.visit(right)
        self.asm.add_inst("LDA", "&" + ('%02x' % self.asm.num2).upper())
        self.asm.add_inst("STA", "&" + ('%02x' % self.asm.ret).upper())
        self.asm.add_inst("LDA", "&" + ('%02x' % (self.asm.num2-1)).upper())
        self.asm.add_inst("STA", "&" + ('%02x' % (self.asm.ret-1)).upper())

    def visit_BinOp(self, node):
        self.visit(node.left)
        self.asm.add_inst("JSR", "movnum")
        if type(node.right) == ast.BinOp:
            self.asm.add_inst("LDA", "&" + ('%02x' % self.asm.num1).upper())
            self.asm.add_inst("PHA")
            self.asm.add_inst("LDA", "&" + ('%02x' % (self.asm.num1-1)).upper())
            self.asm.add_inst("PHA")
            self.visit(node.right)
            self.asm.add_inst("PLA")
            self.asm.add_inst("STA", "&" + ('%02x' % (self.asm.num1-1)).upper())
            self.asm.add_inst("PLA")
            self.asm.add_inst("STA", "&" + ('%02x' % self.asm.num1).upper())
        else:
            self.visit(node.right)
        if node.op.type == PLUS:
            self.asm.add_inst("JSR", "add")
        elif node.op.type == MINUS:
            self.asm.add_inst("JSR", "sub")
        elif node.op.type == MULTIPLY:
            self.asm.add_inst("JSR", "mul")
        elif node.op.type == DIVIDE:
            self.asm.add_inst("JSR", "div")

    def visit_UnaryOp(self, node):
        op = node.op.type
        if op == PLUS:
            self.visit(node.expr)
        elif op == MINUS:
            self.visit(node.expr)
            self.asm.add_inst("JSR", "neg")

    def visit_Num(self, node):
        self.asm.add_inst("LDA", "#&" + ('%04x' % node.value).upper()[2:4])
        self.asm.add_inst("STA", "&" + ('%02x' % self.asm.num2).upper())
        self.asm.add_inst("LDA", "#&" + ('%04x' % node.value).upper()[0:2])
        self.asm.add_inst("STA", "&" + ('%02x' % (self.asm.num2-1)).upper())

    def interpret(self, ast_root):
        self.visit(ast_root)
        return self.asm.get_asm()
