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
            header.extend(struct.pack("<I", lv))
            header.extend(l.encode())
            header.append(0x0)

        for l in self.imports:
            lil, lal, lal2, lml, ln = l
            header.append(0x1)
            header.extend(struct.pack("<IIBI", lil, lal, lal2, lml))
            header.extend(ln.encode())
            header.append(0x0)

        out.extend(struct.pack("<I", len(header)))
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
                if self.labels[label] <= self.loc:
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
        elif isinstance(value.const_loc, ast.LiteralValue) or value.const_loc is None:
            if value.reg_indirect is None:
                if value.const_loc is None:
                    raise SyntaxError(f"Constant offset and register indirect can't be None")
                mv = value.const_loc.val
            elif isinstance(value.reg_indirect, ast.RegisterValue):
                const_val = value.const_loc.val if value.const_loc is not None else 0
                am = 0x3
                mv = (((value.reg_indirect.reg_num << 4) & 0xF0) | (const_val & 0x0F)) |\
                     ((const_val & 0xFFFFFF0) << 4)
            else:
                raise SyntaxError(f"Indirect register can't be {value.reg_indirect}")
        elif value.const_loc is not None:
            raise SyntaxError(f"Memory address constant offset can't be {value.const_loc}")
        if al2 == 0:
            self.insts.append((am << 4) & 0xF0)
        elif al2 == 1:
            self.insts.append(am & 0x0F)
        self.insts.extend(struct.pack("<I", mv))
        self.loc += 5

    def get_reg_val(self, left: typing.Union[ast.RegisterValue, None], right: typing.Union[ast.RegisterValue, None]):
        left_num = left.reg_num if left is not None else 0
        right_num = right.reg_num if right is not None else 0
        self.insts.append(((right_num & 0x0F) << 4) | (left_num & 0x0F))
        self.loc += 1

    def get_mem_reg_val(self, mem: ast.MemoryValue, reg: ast.RegisterValue, al, ml):
        self.get_mem_val(mem, al, 0, ml)
        self.insts[-5] |= (reg.reg_num & 0x0F)

    def get_const_val(self, val: ast.LiteralValue):
        if val.val < 0:
            self.insts.extend(struct.pack("<i", val.val))
        else:
            self.insts.extend(struct.pack("<I", val.val))
        self.loc += 4

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
            self.insts.append(0x08)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't push {node.value}")

    @setup_labels
    def visit_Pop(self, node: ast.Pop):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x0a)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't pop {node.value}")

    @setup_labels
    def visit_Inc(self, node: ast.Inc):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x35)
            self.get_reg_val(node.value, None)
            self.loc += 1
        elif isinstance(node.value, ast.MemoryValue):
            if node.value.length == 1:
                self.insts.append(0x36)
            elif node.value.length == 2:
                self.insts.append(0x37)
            elif node.value.length == 4:
                self.insts.append(0x38)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't increment {node.value}")

    @setup_labels
    def visit_Dec(self, node: ast.Dec):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x39)
            self.get_reg_val(node.value, None)
            self.loc += 1
        elif isinstance(node.value, ast.MemoryValue):
            if node.value.length == 1:
                self.insts.append(0x3a)
            elif node.value.length == 2:
                self.insts.append(0x3b)
            elif node.value.length == 4:
                self.insts.append(0x3c)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't decrement {node.value}")

    @setup_labels
    def visit_Neg(self, node: ast.Neg):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x41)
            self.get_reg_val(node.value, None)
            self.loc += 1
        elif isinstance(node.value, ast.MemoryValue):
            if node.value.length == 1:
                self.insts.append(0x42)
            elif node.value.length == 2:
                self.insts.append(0x43)
            elif node.value.length == 4:
                self.insts.append(0x44)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't negate {node.value}")

    @setup_labels
    def visit_Mov(self, node: ast.Mov):
        if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x07)
            self.get_reg_val(node.left, node.right)
            self.loc += 1
        elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x00)
            self.get_reg_val(node.right, None)
            self.get_const_val(node.left)
            self.loc += 1
        elif isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
            if node.left.length == 1:
                self.insts.append(0x01)
            elif node.left.length == 2:
                self.insts.append(0x02)
            elif node.left.length == 4:
                self.insts.append(0x03)
            self.get_mem_reg_val(node.left, node.right, 1, 2)
            self.loc += 1
        elif isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.MemoryValue):
            if node.right.length == 1:
                self.insts.append(0x04)
            elif node.right.length == 2:
                self.insts.append(0x05)
            elif node.right.length == 4:
                self.insts.append(0x06)
            self.get_mem_reg_val(node.right, node.left, 1, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't mov {node.left} into {node.right}")

    @setup_labels
    def visit_Lea(self, node: ast.Lea):
        if isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x0c)
            self.get_mem_reg_val(node.left, node.right, 1, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't put effective address of {node.left} into {node.right}")

    @setup_labels
    def visit_Add(self, node: ast.Add):
        if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x0f)
            self.get_reg_val(node.left, node.right)
            self.loc += 1
        elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x0d)
            self.get_reg_val(node.right, None)
            self.get_const_val(node.left)
            self.loc += 1
        elif isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
            if node.left.length == 1:
                self.insts.append(0x11)
            elif node.left.length == 2:
                self.insts.append(0x13)
            elif node.left.length == 4:
                self.insts.append(0x15)
            self.get_mem_reg_val(node.left, node.right, 1, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't add {node.left} to {node.right}")

    @setup_labels
    def visit_Sub(self, node: ast.Sub):
        if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x19)
            self.get_reg_val(node.left, node.right)
            self.loc += 1
        elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x17)
            self.get_reg_val(node.right, None)
            self.get_const_val(node.left)
            self.loc += 1
        elif isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
            if node.left.length == 1:
                self.insts.append(0x1b)
            elif node.left.length == 2:
                self.insts.append(0x1d)
            elif node.left.length == 4:
                self.insts.append(0x1f)
            self.get_mem_reg_val(node.left, node.right, 1, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't subtract {node.left} from {node.right}")
    #
    # @setup_labels
    # def visit_Mul(self, node: ast.Mul):
    #     if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
    #         self.insts.append(0x43)
    #         self.get_reg_val(node.left, node.right)
    #         self.loc += 1
    #     elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
    #         self.insts.append(0x42)
    #         self.get_reg_val(node.right, None)
    #         self.insts.extend(struct.pack("<h", node.left.val))
    #         self.loc += 3
    #     elif isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
    #         if node.left.length == 1:
    #             self.insts.append(0x44)
    #         elif node.left.length == 2:
    #             self.insts.append(0x45)
    #         self.get_mem_reg_val(node.left, node.right, 1, 2)
    #         self.loc += 1
    #     else:
    #         raise SyntaxError(f"Can't multiply {node.left} and {node.right}")
    #
    # @setup_labels
    # def visit_Div(self, node: ast.Div):
    #     if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
    #         self.insts.append(0x47)
    #         self.get_reg_val(node.left, node.right)
    #         self.loc += 1
    #     elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
    #         self.insts.append(0x46)
    #         self.get_reg_val(node.right, None)
    #         self.insts.extend(struct.pack("<h", node.left.val))
    #         self.loc += 3
    #     elif isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
    #         if node.left.length == 1:
    #             self.insts.append(0x48)
    #         elif node.left.length == 2:
    #             self.insts.append(0x49)
    #         self.get_mem_reg_val(node.left, node.right, 1, 2)
    #         self.loc += 1
    #     else:
    #         raise SyntaxError(f"Can't divide {node.left} and {node.right}")
    #
    # @setup_labels
    # def visit_Mod(self, node: ast.Mod):
    #     if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
    #         self.insts.append(0x4b)
    #         self.get_reg_val(node.left, node.right)
    #         self.loc += 1
    #     elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
    #         self.insts.append(0x4a)
    #         self.get_reg_val(node.right, None)
    #         self.insts.extend(struct.pack("<h", node.left.val))
    #         self.loc += 3
    #     elif isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
    #         if node.left.length == 1:
    #             self.insts.append(0x4c)
    #         elif node.left.length == 2:
    #             self.insts.append(0x4d)
    #         self.get_mem_reg_val(node.left, node.right, 1, 2)
    #         self.loc += 1
    #     else:
    #         raise SyntaxError(f"Can't modulo {node.left} and {node.right}")
    #

    @setup_labels
    def visit_Cmp(self, node: ast.Cmp):
        if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x22)
            self.get_reg_val(node.left, node.right)
            self.loc += 1
        elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x21)
            self.get_reg_val(node.right, None)
            self.get_const_val(node.left)
            self.loc += 1
        elif isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
            if node.left.length == 1:
                self.insts.append(0x23)
            elif node.left.length == 2:
                self.insts.append(0x24)
            elif node.left.length == 4:
                self.insts.append(0x25)
            self.get_mem_reg_val(node.left, node.right, 1, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't compare {node.left} and {node.right}")

    @setup_labels
    def visit_And(self, node: ast.And):
        if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x5D)
            self.get_reg_val(node.left, node.right)
            self.loc += 1
        elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x5C)
            self.get_reg_val(node.right, None)
            self.insts.extend(struct.pack("<h", node.left.val))
            self.loc += 3
        elif isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
            if node.left.length == 1:
                self.insts.append(0x5E)
            elif node.left.length == 2:
                self.insts.append(0x5F)
            elif node.left.length == 4:
                self.insts.append(0x60)
            self.get_mem_reg_val(node.left, node.right, 1, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't and {node.left} and {node.right}")

    @setup_labels
    def visit_Or(self, node: ast.Or):
        if isinstance(node.left, ast.RegisterValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x62)
            self.get_reg_val(node.left, node.right)
            self.loc += 1
        elif isinstance(node.left, ast.LiteralValue) and isinstance(node.right, ast.RegisterValue):
            self.insts.append(0x61)
            self.get_reg_val(node.right, None)
            self.insts.extend(struct.pack("<h", node.left.val))
            self.loc += 3
        elif isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
            if node.left.length == 1:
                self.insts.append(0x63)
            elif node.left.length == 2:
                self.insts.append(0x64)
            self.get_mem_reg_val(node.left, node.right, 1, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't or {node.left} and {node.right}")

    @setup_labels
    def visit_Jmp(self, node: ast.Jmp):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length != 4:
                raise SyntaxError("Can't jump to a non dword pointer")
            self.insts.append(0x47)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump to {node.value}")

    @setup_labels
    def visit_Jze(self, node: ast.Jze):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length != 4:
                raise SyntaxError("Can't jump on zero to a non dword pointer")
            self.insts.append(0x48)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump on zero to {node.value}")

    @setup_labels
    def visit_Jnz(self, node: ast.Jnz):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length != 4:
                raise SyntaxError("Can't jump on not zero to a non dword pointer")
            self.insts.append(0x49)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump on not zero to {node.value}")

    @setup_labels
    def visit_Jl(self, node: ast.Jl):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length != 4:
                raise SyntaxError("Can't jump on lesser to a non dword pointer")
            self.insts.append(0x4e)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump on lesser to {node.value}")

    @setup_labels
    def visit_Jle(self, node: ast.Jle):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length != 4:
                raise SyntaxError("Can't jump on lesser or equal to a non dword pointer")
            self.insts.append(0x4f)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump on lesser or equal to {node.value}")

    @setup_labels
    def visit_Jg(self, node: ast.Jg):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length != 4:
                raise SyntaxError("Can't jump on on greater to a non dword pointer")
            self.insts.append(0x50)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump on greater to {node.value}")

    @setup_labels
    def visit_Jge(self, node: ast.Jge):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length != 4:
                raise SyntaxError("Can't jump on greater or equal to a non dword pointer")
            self.insts.append(0x51)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump on greater or equal to {node.value}")

    @setup_labels
    def visit_Ja(self, node: ast.Ja):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length != 4:
                raise SyntaxError("Can't jump on on above to a non dword pointer")
            self.insts.append(0x4a)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump on above to {node.value}")

    @setup_labels
    def visit_Jae(self, node: ast.Jae):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length != 4:
                raise SyntaxError("Can't jump on above or equal to a non dword pointer")
            self.insts.append(0x4b)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump on above or equal to {node.value}")

    @setup_labels
    def visit_Jb(self, node: ast.Jb):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length != 4:
                raise SyntaxError("Can't jump on on below to a non dword pointer")
            self.insts.append(0x4c)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump on below to {node.value}")

    @setup_labels
    def visit_Jbe(self, node: ast.Jbe):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length != 4:
                raise SyntaxError("Can't jump on below or equal to a non dword pointer")
            self.insts.append(0x4d)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't jump on below or equal to {node.value}")

    @setup_labels
    def visit_Sze(self, node: ast.Sze):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x52)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't set on zero with {node.value}")

    @setup_labels
    def visit_Snz(self, node: ast.Jze):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x53)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't set on not zero with {node.value}")

    @setup_labels
    def visit_Sa(self, node: ast.Jze):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x54)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't set on above with {node.value}")

    @setup_labels
    def visit_Sae(self, node: ast.Jze):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x55)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't set on above or equal with {node.value}")

    @setup_labels
    def visit_Sb(self, node: ast.Jze):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x56)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't set on below with {node.value}")

    @setup_labels
    def visit_Sbe(self, node: ast.Jze):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x57)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't set on below or equal with {node.value}")

    @setup_labels
    def visit_Sl(self, node: ast.Jze):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x58)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't set on lower with {node.value}")

    @setup_labels
    def visit_Sle(self, node: ast.Jze):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x59)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't set on lower or equal with {node.value}")

    @setup_labels
    def visit_Sg(self, node: ast.Jze):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x5a)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't set on greater with {node.value}")

    @setup_labels
    def visit_Sge(self, node: ast.Jze):
        if isinstance(node.value, ast.RegisterValue):
            self.insts.append(0x5b)
            self.get_reg_val(node.value, None)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't set on greater or equal with {node.value}")

    @setup_labels
    def visit_Call(self, node: ast.Call):
        if isinstance(node.value, ast.MemoryValue):
            if node.value.length != 4:
                raise SyntaxError("Can't call non dword pointer")
            self.insts.append(0x45)
            self.get_mem_val(node.value, 1, 0, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't call {node.value}")

    @setup_labels
    def visit_Calln(self, node: ast.Calln):
        if isinstance(node.left, ast.MemoryValue) and isinstance(node.right, ast.RegisterValue):
            if node.left.length != 4:
                raise SyntaxError("Can't call native non dword pointer")
            self.insts.append(0x46)
            self.get_mem_reg_val(node.left, node.right, 1, 2)
            self.loc += 1
        else:
            raise SyntaxError(f"Can't call native code at {node.left} with value {node.right}")
