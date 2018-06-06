from . import parser
import glob
import struct
import os


class Linker:
    def __init__(self, objects, sta):
        self.objects = objects
        self.defined_symbols = {}
        self.executables = []
        self.sta = sta

    def _find_lib(self, symbol_name):
        lib_dir = os.path.join(os.path.dirname(__file__), "..", "lib")
        libs = glob.glob(os.path.join(lib_dir, "*.o"))
        for l in libs:
            lib = open(l, "rb")
            lib_source = lib.read()
            lib.close()
            parse = parser.Parser(list(lib_source))
            obj = parse.parse()
            for s in obj.symbols:
                if s.type == parser.Symbol.EXPORT and s.name == symbol_name:
                    return obj

    def _get_symbol(self, s, static):
        if s not in self.defined_symbols and static:
            lib = self._find_lib(s)
            if lib is None:
                raise LookupError("Symbol {} not exported anywhere".format(s))
            lib = self._get_symbols(lib, static)
            self.executables.append(lib)

    def _get_symbols(self, e, static):
        symbols = []
        for s in filter(lambda symbol: symbol.type == parser.Symbol.EXPORT, e.symbols):
            self.defined_symbols[s.name] = (s, -1)
            symbols.append(s.name)

        for s in filter(lambda symbol: symbol.type == parser.Symbol.IMPORT or
                                       symbol.type == parser.Symbol.IMPORT_ADDR, e.symbols):
            self._get_symbol(s.name, static)

        for symbol in symbols:
            s = self.defined_symbols[symbol]
            if s[1] == -1:
                self.defined_symbols[symbol] = (s[0], s[0].addr + self.sta)
        e.pos = self.sta
        self.sta += len(e.code)
        return e

    def _parse_obj(self, obj, static):
        p = parser.Parser(list(obj))
        e = p.parse()
        e = self._get_symbols(e, static)
        self.executables.append(e)

    def link_static(self):
        for o in self.objects:
            self._parse_obj(o, True)
        self._get_symbol("_start", True)

        out = []
        for e in self.executables:
            for s in e.symbols:
                if s.type == parser.Symbol.IMPORT:
                    d_symbol, d_addr = self.defined_symbols[s.name]
                    cur_val = struct.unpack("<H", bytes(e.code[s.addr:s.addr+2]))[0]
                    e.code = e.code[:s.addr] + list(struct.pack("<H", cur_val+d_addr)) + e.code[s.addr+2:]
                elif s.type == parser.Symbol.IMPORT_ADDR:
                    d_symbol, d_addr = self.defined_symbols[s.name]
                    cur_val = struct.unpack("<B", bytes(e.code[s.addr:s.addr+1]))[0]
                    e.code = e.code[:s.addr] + list(struct.pack("<B", (d_addr >> (cur_val*8)) & 0xff)) +\
                             e.code[s.addr+1:]

                elif s.type == parser.Symbol.INTERNAL:
                    cur_val = struct.unpack("<H", bytes(e.code[s.addr:s.addr+2]))[0]
                    e.code = e.code[:s.addr] + list(struct.pack("<H", cur_val+e.pos)) + e.code[s.addr+2:]
                elif s.type == parser.Symbol.INTERNAL_ADDR:
                    cur_val = struct.unpack("<B", bytes(e.code[s.addr:s.addr+1]))[0]
                    e.code = e.code[:s.addr] + list(struct.pack("<B", ((s.extra + e.pos) >> (cur_val*8)) & 0xff)) + e.code[s.addr+1:]
            out.extend(e.code)

        start_symbol = self.defined_symbols.get("_start")
        if start_symbol is None:
            raise LookupError("No _start symbol, don't know where to start execution")

        return out, start_symbol[1]

    def link_shared(self, stip):
        for o in self.objects:
            self._parse_obj(o, False)

        out = [0xB, 0xB, 0xC, 0x42, 0x42, 0x43]
        symbols = []
        code = []
        for e in self.executables:
            for s in e.symbols:
                if s.type == parser.Symbol.IMPORT:
                    sym = self.defined_symbols.get(s.name)
                    if sym is not None:
                        d_symbol, d_addr = sym
                        cur_val = struct.unpack("<H", bytes(e.code[s.addr:s.addr + 2]))[0]
                        e.code = e.code[:s.addr] + list(struct.pack("<H", cur_val + d_addr)) + e.code[s.addr + 2:]
                        if stip:
                            name = ""
                        else:
                            name = s.name
                        symbols.append(parser.Symbol(name, e.pos+s.addr, parser.Symbol.INTERNAL))
                    else:
                        symbols.append(parser.Symbol(s.name, e.pos+s.addr, parser.Symbol.IMPORT))

                elif s.type == parser.Symbol.INTERNAL:
                    cur_val = struct.unpack("<H", bytes(e.code[s.addr:s.addr + 2]))[0]
                    e.code = e.code[:s.addr] + list(struct.pack("<H", cur_val + e.pos)) + e.code[s.addr + 2:]
                    if stip:
                        name = ""
                    else:
                        name = s.name
                    symbols.append(parser.Symbol(name, e.pos+s.addr, parser.Symbol.INTERNAL))

                elif s.type == parser.Symbol.EXPORT:
                    symbols.append(parser.Symbol(s.name, e.pos+s.addr, parser.Symbol.EXPORT))
                elif s.type == parser.Symbol.INTERNAL_ADDR:
                    cur_val = struct.unpack("<B", bytes(e.code[s.addr:s.addr+1]))[0]
                    e.code = e.code[:s.addr] + list(struct.pack("<B", ((s.extra + e.pos) >> (cur_val*8)) & 0xff)) + e.code[s.addr+1:]
                    if stip:
                        name = ""
                    else:
                        name = s.name
                    symbols.append(parser.Symbol(name, e.pos+s.addr, parser.Symbol.INTERNAL_ADDR, s.extra))
            code.extend(e.code)

        header = []
        for s in symbols:
            header.extend(s.make_bin())
        out.extend(list(struct.pack("<H", len(header))))
        out.extend(header)
        out.extend(code)

        return out
