from . import spots


class TempAsm:
    def __init__(self):
        self.asm = []

    def add_inst(self, inst):
        self.asm.append(inst)


class ASM:
    def __init__(self):
        self.asm = []
        self.imports = []
        self.exports = []

    @classmethod
    def to_hex(cls, num, length=2):
        return (('%0' + str(length) + 'x') % ((num + (1 << length*4)) % (1 << length*4))).upper()

    def add_inst(self, inst):
        self.asm.append(inst)

    def merge_temp_asm(self, asm: TempAsm, ret_label):
        for inst in asm.asm:
            if isinstance(inst, JmpRet):
                self.asm.append(Jmp(spots.MemorySpot(ret_label)))
            else:
                self.asm.append(inst)

    def add_import(self, name):
        self.imports.append(name)

    def add_export(self, name):
        self.exports.append(name)

    def get_asm(self):
        out = ""
        for name in self.imports:
            out += f".import {name}\n"
        for name in self.exports:
            out += f".export {name}\n"

        return out + "\n".join([str(inst) for inst in self.asm])


class _Inst:
    name = None

    def __init__(self, source=None, dest=None, size=None):
        self.dest = dest.asm(size) if dest else None
        self.source = source.asm(size) if source else None
        self.size = size

    def __str__(self):
        s = "\t" + self.name
        if self.source:
            s += " " + self.source
        if self.dest:
            s += ", " + self.dest
        return s


class Label:
    def __init__(self, label):
        self.label = label

    def __str__(self):
        return self.label + ":"


class Comment:
    def __init__(self, comment):
        self.comment = comment

    def __str__(self):
        return "// " + self.comment


class Bytes:
    def __init__(self, data):
        self.data = data

    def __str__(self):
        return ".byte " + ",".join(["#{}".format(b) for b in self.data])


class JmpRet:
    def __init__(self):
        pass


class Inline:
    def __init__(self, asm):
        self.asm = asm

    def __str__(self):
        return f"\t{self.asm}"

class Mov(_Inst):
    name = "mov"


class Lea(_Inst):
    name = "lea"


class Call(_Inst):
    name = "call"


class Jmp(_Inst):
    name = "jmp"


class Jze(_Inst):
    name = "jze"


class Jnz(_Inst):
    name = "jnz"


class Jl(_Inst):
    name = "jl"


class Jle(_Inst):
    name = "jle"


class Jg(_Inst):
    name = "jg"


class Jge(_Inst):
    name = "jge"


class Ja(_Inst):
    name = "ja"


class Jae(_Inst):
    name = "jae"


class Jb(_Inst):
    name = "jb"


class Jbe(_Inst):
    name = "jbe"

class Sze(_Inst):
    name = "sze"


class Snz(_Inst):
    name = "snz"


class Sl(_Inst):
    name = "sl"


class Sle(_Inst):
    name = "sle"


class Sg(_Inst):
    name = "sg"


class Sge(_Inst):
    name = "sge"


class Sa(_Inst):
    name = "sa"


class Sae(_Inst):
    name = "sae"


class Sb(_Inst):
    name = "sb"


class Sbe(_Inst):
    name = "sbe"


class Sub(_Inst):
    name = "sub"


class Add(_Inst):
    name = "add"


class Mul(_Inst):
    name = "mul"


class Div(_Inst):
    name = "div"


class Mod(_Inst):
    name = "mod"


class And(_Inst):
    name = "and"


class Or(_Inst):
    name = "or"


class Not(_Inst):
    name = "not"


class Xor(_Inst):
    name = "xor"


class Shl(_Inst):
    name = "shl"


class Shr(_Inst):
    name = "shr"


class Neg(_Inst):
    name = "neg"


class Inc(_Inst):
    name = "inc"


class Dec(_Inst):
    name = "dec"


class Cmp(_Inst):
    name = "cmp"


class Push(_Inst):
    name = "push"


class Pop(_Inst):
    name = "pop"


class Ret(_Inst):
    name = "ret"
