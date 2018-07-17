import struct
from . import ast


# noinspection PyArgumentList
class Assembler:
    def __init__(self, ast):
        self.ast = ast
        self.loc = None
        self.insts = None
        self.exports = None
        self.imports = None
        self.labels = None
        self.imported_labels = None
        self.cur_labels = None

    def assemble(self):
        self.loc = 0
        self.insts = bytearray()
        self.exports = []
        self.imports = []
        self.labels = {}
        self.imported_labels = []
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
            lil, lal, lal2, lml, ln = l
            header.append(0x1)
            header.extend(struct.pack("<hhbh", lil, lal, lal2, lml))
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

    def visit_ImportCommand(self, node):
        self.imported_labels.append(node.label)

    def visit_ExportCommand(self, node):
        self.exports.append(node.label)

    def visit_Label(self, node):
        self.cur_labels.append(node.label)

    def setup_labels(func):
        def wrapper(self, node):
            for l in self.cur_labels:
                self.labels[l] = self.loc
            self.cur_labels = []
            return func(self, node)
        return wrapper

    def get_label_val(self, value, al, al2, ml):
        am = 0x0
        mv = 0x0
        if isinstance(value, ast.LabelValue):
            label = value.label
            if label in self.labels:
                if self.labels[label] < self.loc:
                    am = 0x1
                    mv = ml - self.labels[label]
                else:
                    am = 0x2
                    mv = self.labels[label] - ml
            elif label in self.imported_labels:
                self.imports.append((self.loc, al, al2, ml, label))
            else:
                raise ValueError(f"Undefined label: {label}")
        return am, mv

    @setup_labels
    def visit_Bytes(self, node):
        values = []
        for b in node.bytes:
            if isinstance(b, ast.LiteralValue):
                values.append(b.val)
        self.insts.extend(values)
        self.loc += len(values)

    @setup_labels
    def visit_Ret(self, node):
        self.insts.append(0x82)
        self.loc += 1

    @setup_labels
    def visit_Exit(self, node):
        self.insts.append(0x83)
        self.loc += 1

    @setup_labels
    def visit_Push(self, node):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x06)
            self.insts.append(node.value.reg_num & 0x0F)
            self.loc += 2
        else:
            raise SyntaxError(f"Can't push {node.value}")

    @setup_labels
    def visit_Pop(self, node):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x07)
            self.insts.append(node.value.reg_num & 0x0F)
            self.loc += 2
        else:
            raise SyntaxError(f"Can't pop {node.value}")

    @setup_labels
    def visit_Mov(self, node):
        if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x05)
            self.insts.append(((node.right.reg_num & 0x0F) << 4) | (node.left.reg_num & 0x0F))
            self.loc += 2
        elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x00)
            self.insts.append(node.right.reg_num & 0x0F)
            self.insts.extend(struct.pack("<h", node.left.val))
            self.loc += 4
        else:
            raise SyntaxError(f"Can't mov {node.left} into {node.right}")

    @setup_labels
    def visit_Call(self, node):
        if isinstance(node.value, ast.LabelValue):
            self.insts.append(0x2D)
            lal = self.loc + 1
            lml = self.loc + 2
            av, mv = self.get_label_val(node.value, lal, 0, lml)
            self.insts.append((av << 4) & 0xF0)
            self.insts.extend(struct.pack("<h", mv))
            self.loc += 4
        else:
            raise SyntaxError(f"Can't call {node.value}")
