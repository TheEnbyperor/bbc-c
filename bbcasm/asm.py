from . import insts
import struct


class Symbol:
    INTERNAL = 0
    EXPORT = 1
    IMPORT = 2

    def __init__(self, name, addr, type):
        self.name = name
        self.addr = addr
        self.type = type

    def make_bin(self):
        return list(struct.pack("<BH", self.type, self.addr) + self.name.encode()) + [0]

    def __repr__(self):
        return "<Symbol({}:{}:{})>".format(self.name, self.addr, self.type)


class Assemble:
    def __init__(self, prog):
        self.prog = prog
        self.labels = {}
        self.symbols = []

    def fill_labels(self):
        addr = 0
        for i in self.prog.insts:
            if len(i.labels) > 0:
                for l in i.labels:
                    self.labels[l] = addr
                    if l in self.prog.exports:
                        self.symbols.append(Symbol(l, addr, Symbol.EXPORT))
            addr += len(i)
        addr = 0
        for n, i in enumerate(self.prog.insts):
            if isinstance(i.value, insts.LabelVal):
                if i.value.label in self.prog.imports:
                    val = insts.MemVal(i.value.offset)
                    self.symbols.append(Symbol(i.value.label, addr+1, Symbol.IMPORT))
                else:
                    val = insts.MemVal(self.labels[i.value.label])
                    if not i.is_relative():
                        self.symbols.append(Symbol(i.value.label, addr + 1, Symbol.INTERNAL))
                self.prog.insts[n].value = val
            addr += len(i)

    def _make_header(self):
        header = []
        for s in self.symbols:
            header.extend(s.make_bin())

        return header

    def assemble(self):
        out = [0xB, 0xB, 0xC, 0x42, 0x42, 0x43, 0]

        header = self._make_header()
        out.extend(list(struct.pack("<H", len(header))))
        out.extend(header)

        addr = 0
        for i in self.prog.insts:
            out.extend(i.gen(addr))
            addr += len(i)

        return out
