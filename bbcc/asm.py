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
        return "\ " + self.comment


class Bytes:
    def __init__(self, data):
        self.data = data

    def __str__(self):
        return ".byte " + ",".join(["#{}".format(b) for b in self.data])


class Mov(_Inst):
    name = "mov"


class Push(_Inst):
    name = "push"


class Pop(_Inst):
    name = "pop"


class Ret(_Inst):
    name = "ret"
