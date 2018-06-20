import struct
from . import ast


class Assembler:
    def __init__(self, ast):
        self.ast = ast
        self.loc = None
        self.insts = None
        self.exports = None
        self.imports = None
        self.labels = None
        self.cur_labels = None

    def assemble(self):
        self.loc = 0
        self.insts = bytearray()
        self.exports = []
        self.imports = []
        self.labels = {}
        self.cur_labels = []
        self.visit(self.ast)

        out = bytearray([0xB, 0xB, 0xC, ord('V'), ord('M'), 0x0])

        header = bytearray()
        for l in self.exports:
            lv = self.labels[l]
            header.append(0x0)
            header.extend(struct.pack("<h", lv))
            header.extend(l.encode())
            header.append(0x0)

        for l in self.imports:
            lv, ln = l
            header.append(0x1)
            header.extend(struct.pack("<h", lv))
            header.extend(ln.encode())
            header.append(0x0)

        out.extend(struct.pack("<h", len(header)))
        out.extend(header)

        out.extend(self.insts)
        return out

    def visit(self, node):
        method_name = 'visit_' + type(node).__name__
        visitor = getattr(self, method_name, self.generic_visit)
        return visitor(node)

    @staticmethod
    def generic_visit(node):
        raise RuntimeError('No visit_{} method'.format(type(node).__name__))

    def visit_TranslationUnit(self, node):
        for item in node.items:
            self.visit(item)

    def visit_ExportCommand(self, node):
        self.exports.append(node.label)

    def visit_Label(self, node):
        self.cur_labels.append(node.label)

    def setup_labels(self):
        for l in self.cur_labels:
            self.labels[l] = self.loc
        self.cur_labels = []

    def visit_Ret(self, node):
        self.setup_labels()
        self.insts.append(0x83)
        self.loc += 1

    def visit_Push(self, node):
        self.setup_labels()
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x06)
            self.insts.append(node.value.reg_num & 0x0F)
            self.loc += 2
        else:
            raise SyntaxError(f"Can't push {node.value}")

    def visit_Pop(self, node):
        self.setup_labels()
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x07)
            self.insts.append(node.value.reg_num & 0x0F)
            self.loc += 2
        else:
            raise SyntaxError(f"Can't pop {node.value}")

    def visit_Mov(self, node):
        self.setup_labels()
        if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x05)
            self.insts.append(((node.left.reg_num & 0x0F) << 4) | (node.right.reg_num & 0x0F))
            self.loc += 2
        elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x00)
            self.insts.append(node.right.reg_num & 0x0F)
            self.insts.extend(struct.pack("<h", node.left.val))
            self.loc += 4
        else:
            raise SyntaxError(f"Can't mov {node.left} into {node.right}")
