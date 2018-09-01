from . import insts
import struct


class Symbol:
    INTERNAL = 0
    EXPORT = 1
    IMPORT = 2
    IMPORT_ADDR = 3
    INTERNAL_ADDR = 4

    def __init__(self, name, addr, type, extra=0):
        self.name = name
        self.addr = addr
        self.type = type
        self.extra = extra

    def make_bin(self):
        return list(struct.pack("<BHH", self.type, self.addr, self.extra) + self.name.encode()) + [0]

    def __repr__(self):
        return "<Symbol({}:{}:{}:{})>".format(self.name, self.addr, self.type, self.extra)


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
        for l in self.prog.end_labels:
            self.labels[l] = addr
            if l in self.prog.exports:
                self.symbols.append(Symbol(l, addr, Symbol.EXPORT))
        addr = 0
        for n, i in enumerate(self.prog.insts):
            inst_len = 1
            if isinstance(i, insts.Byte):
                inst_len = 0
            if isinstance(getattr(i.value, "loc", None), insts.LabelVal):
                if i.value.loc.label in self.prog.imports:
                    loc = i.value.loc.offset
                    self.symbols.append(Symbol(i.value.loc.label, addr + inst_len, Symbol.IMPORT))
                else:
                    loc = self.labels[i.value.loc.label] + i.value.loc.offset
                    if not i.is_relative():
                        self.symbols.append(Symbol(i.value.loc.label, addr + inst_len, Symbol.INTERNAL))
                self.prog.insts[n].value.loc = loc
            if isinstance(i.value, insts.LabelAddrVal):
                if i.value.label in self.prog.imports:
                    val = insts.LiteralVal(i.value.offset)
                    self.symbols.append(Symbol(i.value.label, addr + inst_len, Symbol.IMPORT_ADDR))
                else:
                    val = insts.LiteralVal(i.value.offset)
                    self.symbols.append(Symbol(i.value.label, addr + inst_len, Symbol.INTERNAL_ADDR,
                                               self.labels[i.value.label]+i.value.loc_offset))
                self.prog.insts[n].value = val
            addr += len(i)

    def _make_header(self):
        header = []
        for s in self.symbols:
            header.extend(s.make_bin())

        return header

    def assemble(self):
        out = [0xB, 0xB, 0xC, 0x42, 0x42, 0x43]

        header = self._make_header()
        out.extend(list(struct.pack("<H", len(header))))
        out.extend(header)

        addr = 0
        for i in self.prog.insts:
            out.extend(i.gen(addr))
            addr += len(i)

        return out
