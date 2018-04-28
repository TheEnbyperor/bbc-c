from . import parser
import struct


class Linker:
    def __init__(self, objects):
        self.objects = objects

    def link(self, sta):
        executables = []
        for o in self.objects:
            p = parser.Parser(list(o))
            executables.append(p.parse())

        out = []

        defined_symbols = {}
        for i, e in enumerate(executables):
            e.pos = sta
            executables[i] = e
            for s in e.symbols:
                if s.type == parser.Symbol.EXPORT:
                    defined_symbols[s.name] = (s, sta)
            sta += len(e.code)

        for i, e in enumerate(executables):
            for s in e.symbols:
                if s.type == parser.Symbol.IMPORT:
                    if s.name not in defined_symbols:
                        raise LookupError("Symbol {} not exported anywhere".format(s.name))

                    d_symbol, d_addr = defined_symbols[s.name]
                    cur_val = struct.unpack("<H", bytes(e.code[s.addr:s.addr+2]))[0]
                    e.code = e.code[:s.addr] + list(struct.pack("<H", cur_val+d_addr)) + e.code[s.addr+2:]
                elif s.type == parser.Symbol.INTERNAL:
                    cur_val = struct.unpack("<H", bytes(e.code[s.addr:s.addr+2]))[0]
                    e.code = e.code[:s.addr] + list(struct.pack("<H", cur_val+e.pos)) + e.code[s.addr+2:]
            out.extend(e.code)

        start_symbol = defined_symbols.get("_start")
        if start_symbol is None:
            raise LookupError("No _start symbol, don't know where to start execution")

        start_addr = start_symbol[0].addr+start_symbol[1]
        return out, start_addr
