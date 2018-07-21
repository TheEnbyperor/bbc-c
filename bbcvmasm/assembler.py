import struct
import typing
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
        self.label_errors = True

    def assemble(self):
        self.loc = 0
        self.insts = bytearray()
        self.exports = []
        self.imports = []
        self.labels = {}
        self.imported_labels = []
        self.cur_labels = []
        self.label_errors = False
        self.visit(self.ast)

        self.loc = 0
        self.insts = bytearray()
        self.exports = []
        self.imports = []
        self.imported_labels = []
        self.cur_labels = []
        self.label_errors = True
        self.visit(self.ast)

        out = bytearray([0xB, 0xB, 0xC, ord('V'), ord('M'), 0x0])

        header = bytearray()
        for l in self.exports:
            lv = self.labels[l]
            header.append(0x0)
            header.extend(struct.pack("<H", lv))
            header.extend(l.encode())
            header.append(0x0)

        for l in self.imports:
            lil, lal, lal2, lml, ln = l
            header.append(0x1)
            header.extend(struct.pack("<HHBH", lil, lal, lal2, lml))
            header.extend(ln.encode())
            header.append(0x0)

        out.extend(struct.pack("<H", len(header)))
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

    def visit_TranslationUnit(self, node: ast.TranslationUnit):
        for item in node.items:
            self.visit(item)

    def visit_ImportCommand(self, node: ast.ImportCommand):
        self.imported_labels.append(node.label)

    def visit_ExportCommand(self, node: ast.ExportCommand):
        self.exports.append(node.label)

    def visit_Label(self, node: ast.Label):
        self.cur_labels.append(node.label)

    def setup_labels(func):
        def wrapper(self, node):
            for l in self.cur_labels:
                self.labels[l] = self.loc
            self.cur_labels = []
            return func(self, node)
        return wrapper

    def get_mem_val(self, value: ast.MemoryValue, al, al2, ml):
        al = self.loc + al
        ml = self.loc + ml
        am = 0x0
        mv = 0x0
        if isinstance(value.const_loc, ast.LabelValue):
            if value.reg_indirect is not None:
                raise SyntaxError("Indirect with label as constant is not supported")
            label = value.const_loc.label
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
                if self.label_errors:
                    raise ValueError(f"Undefined label: {label}")
        elif isinstance(value.const_loc, ast.LiteralValue):
            if value.reg_indirect is None:
                mv = value.const_loc.val - 1
            elif isinstance(value.reg_indirect, ast.RegisterValue):
                am = 0x3
                mv = (((value.reg_indirect.reg_num << 4) & 0xF0) | (value.const_loc.val & 0x0F)) |\
                     ((value.const_loc.val & 0xFF0) << 4)
            else:
                raise SyntaxError(f"Indirect register can't be {value.reg_indirect}")
        elif value.const_loc is not None:
            raise SyntaxError(f"Memory address constant offset can't be {value.const_loc}")
        if al2 == 0:
            self.insts.append((am << 4) & 0xF0)
        elif al2 == 1:
            self.insts.append(am & 0x0F)
        self.insts.extend(struct.pack("<H", mv))
        self.loc += 3

    def get_reg_val(self, left: typing.Union[ast.RegisterValue, None], right: typing.Union[ast.RegisterValue, None]):
        left_num = left.reg_num if left is not None else 0
        right_num = right.reg_num if right is not None else 0
        self.insts.append(((right_num & 0x0F) << 4) | (left_num & 0x0F))
        self.loc += 1

    def get_mem_reg_val(self, mem: ast.MemoryValue, reg: ast.RegisterValue, al, ml):
        self.get_mem_val(mem, al, 0, ml)
        self.insts[-3] |= (reg.reg_num & 0x0F)

    @setup_labels
    def visit_Bytes(self, node: ast.Bytes):
        values = []
        for b in node.bytes:
            if isinstance(b, ast.LiteralValue):
                values.append(b.val)
            else:
                raise SyntaxError(f"Bytes can't be {b}")
        self.insts.extend(values)
        self.loc += len(values)

    @setup_labels
    def visit_Ret(self, node: ast.Ret):
        self.insts.append(0x82)
        self.loc += 1

    @setup_labels
    def visit_Exit(self, node: ast.Exit):
        self.insts.append(0x83)
        self.loc += 1

    @setup_labels
    def visit_Push(self, node: ast.Push):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x06)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't push {node.value}")

    @setup_labels
    def visit_Pop(self, node: ast.Pop):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x07)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't pop {node.value}")

    @setup_labels
    def visit_Inc(self, node: ast.Pop):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x19)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't increment {node.value}")

    @setup_labels
    def visit_Dec(self, node: ast.Pop):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x1A)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't decrement {node.value}")

    @setup_labels
    def visit_Mov(self, node: ast.Mov):
        if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x05)
            self.get_reg_val(node.left, node.right)
            self.loc += 1
        elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x00)
            self.get_reg_val(node.right, None)
            self.insts.extend(struct.pack("<h", node.left.val))
            self.loc += 3
        elif isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
            if node.left.length == 1:
                self.insts.append(0x01)
            elif node.left.length == 2:
                self.insts.append(0x02)
            self.get_mem_reg_val(node.left, node.right, 1, 2)
            self.loc += 1
        elif isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.MemoryValue):
            if node.right.length == 1:
                self.insts.append(0x03)
            elif node.right.length == 2:
                self.insts.append(0x04)
            self.get_mem_reg_val(node.right, node.left, 1, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't mov {node.left} into {node.right}")

    @setup_labels
    def visit_Lea(self, node: ast.Calln):
        if isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x08)
            self.get_mem_reg_val(node.left, node.right, 1, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't put effective address of {node.left} into {node.right}")

    @setup_labels
    def visit_Add(self, node: ast.Mov):
        if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x0B)
            self.get_reg_val(node.left, node.right)
            self.loc += 1
        elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x09)
            self.get_reg_val(node.right, None)
            self.insts.extend(struct.pack("<h", node.left.val))
            self.loc += 3
        else:
            raise SyntaxError(f"Can't add {node.left} to {node.right}")

    @setup_labels
    def visit_Cmp(self, node: ast.Mov):
        if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x2A)
            self.get_reg_val(node.left, node.right)
            self.loc += 1
        elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x29)
            self.get_reg_val(node.right, None)
            self.insts.extend(struct.pack("<h", node.left.val))
            self.loc += 3
        else:
            raise SyntaxError(f"Can't compare {node.left} and {node.right}")

    @setup_labels
    def visit_Jmp(self, node: ast.Call):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length == 1:
                raise SyntaxError("Can't jump to a byte pointer")
            self.insts.append(0x2F)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump to {node.value}")

    @setup_labels
    def visit_Jze(self, node: ast.Call):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length == 1:
                raise SyntaxError("Can't jump on zero to a byte pointer")
            self.insts.append(0x30)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump on zero to {node.value}")

    @setup_labels
    def visit_Jnz(self, node: ast.Call):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length == 1:
                raise SyntaxError("Can't jump on not zero to a byte pointer")
            self.insts.append(0x31)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump on not zero to {node.value}")

    @setup_labels
    def visit_Call(self, node: ast.Call):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length == 1:
                raise SyntaxError("Can't call byte pointer")
            self.insts.append(0x2D)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't call {node.value}")

    @setup_labels
    def visit_Calln(self, node: ast.Calln):
        if isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
            if node.left.length == 1:
                raise SyntaxError("Can't call byte pointer")
            self.insts.append(0x2E)
            self.get_mem_reg_val(node.left, node.right, 1, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't call native code at {node.left} with value {node.right}")
