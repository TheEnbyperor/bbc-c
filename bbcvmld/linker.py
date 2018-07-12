from . import parser
import glob
import struct
import os


class Linker:
    def __init__(self, objects):
        self.objects = objects
        self.defined_symbols = {}
        self.imports = {}
        self.executables = []
        self.pos = 0

    def _find_lib(self, symbol_name):
        lib_dir = os.path.join(os.path.dirname(__file__), "..", "lib")
        libs = glob.glob(os.path.join(lib_dir, "*.o"))
        for l in libs:
            lib = open(l, "rb")
            lib_source = lib.read()
            lib.close()
            parse = parser.Parser(lib_source)
            try:
                obj = parse.parse()
                if symbol_name in s.exports:
                    return obj
            except SyntaxError:
                pass

    def _get_symbol(self, s, static):
        if s not in self.defined_symbols and static:
            lib = self._find_lib(s)
            if lib is None:
                raise LookupError("Symbol {} not exported anywhere".format(s))
            self._load_exports(lib)
            self.executables.append(lib)

    def _load_exports(self, e):
        for n, l in e.exports.items():
            self.defined_symbols[n] = l + self.pos
        self.pos += len(e.code)

    def _get_symbols(self, static):
        for e in self.executables:
            for i in e.imports:
                self._get_symbol(i[0], static)

    def _parse_obj(self, obj):
        p = parser.Parser(obj)
        e = p.parse()
        self._load_exports(e)
        self.executables.append(e)

    def link_static(self):
        for o in self.objects:
            self._parse_obj(o)
        self._get_symbols(static=True)
        self._get_symbol("_start", static=True)

        out = bytearray()
        for e in self.executables:
            code = bytearray(e.code)
            for i in e.imports:
                s_addr = self.defined_symbols[i[0]]
                if s_addr < i[1]:
                    am = 0x2
                    mv = i[1] - s_addr
                else:
                    am = 0x1
                    mv = s_addr - i[1]

                lal = i[2]
                if i[3] == 0:
                    code[lal] = (code[lal] & 0x0F) | ((am << 4) & 0xF0)
                else:
                    code[lal] = (code[lal] & 0xF0) | (am & 0x0F)

                code[i[4]:i[4]+2] = struct.pack("<h", mv)

            out.extend(code)

        start_symbol = self.defined_symbols.get("_start")
        if start_symbol is None:
            raise LookupError("No _start symbol, don't know where to start execution")

        return out, start_symbol