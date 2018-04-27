from . import insts
import struct


class Symbol:
    def __init__(self, name, addr, defined):
        self.name = name
        self.addr = addr
        self.defined = defined

    def make_bin(self):
        return list(struct.pack("<?H", self.defined, self.addr) + self.name.encode()) + [0]

    def __repr__(self):
        return "<Symbol({}:{}:{})>".format(self.name, self.addr, self.defined)


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
                        self.symbols.append(Symbol(l, addr, True))
            addr += len(i)
        addr = 0
        for n, i in enumerate(self.prog.insts):
            if isinstance(i.value, insts.LabelVal):
                if i.value.label in self.prog.imports:
                    val = insts.MemVal(i.value.offset)
                    self.symbols.append(Symbol(i.value.label, addr+1, False))
                else:
                    val = insts.MemVal(self.labels[i.value.label])
                self.prog.insts[n].value = val
            addr += len(i)

    def _make_header(self):
        header = []
        for s in self.symbols:
            header.extend(s.make_bin())

        return header

    def assemble(self):
        b = ord("B")
        c = ord("C")
        out = [0xB, 0xB, 0xC, 0xC, b, b, c, c, 0]

        header = self._make_header()
        out.extend(list(struct.pack("<H", len(header))))
        out.extend(header)

        addr = 0
        for i in self.prog.insts:
            out.extend(i.gen(addr))
            addr += len(i)

        print(self.symbols)

        return out, self.labels["_start"]
