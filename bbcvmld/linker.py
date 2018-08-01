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
                if symbol_name in obj.exports:
                    return obj
            except SyntaxError:
                pass

    def _get_symbol(self, s, static):
        if s not in self.defined_symbols and s != "_HIMEM" and static:
            lib = self._find_lib(s)
            if lib is None:
                raise LookupError("Symbol {} not exported anywhere".format(s))
            lib = self._load_exports(lib)
            self.executables.append(lib)

    def _load_exports(self, e):
        for n, l in e.exports.items():
            self.defined_symbols[n] = l + self.pos
        e.pos = self.pos
        self.pos += len(e.code)
        return e

    def _get_symbols(self, static):
        for e in self.executables:
            for i in e.imports:
                self._get_symbol(i[0], static)

    def _parse_obj(self, obj):
        p = parser.Parser(obj)
        e = p.parse()
        e = self._load_exports(e)
        self.executables.append(e)

    def link_static(self):
        for o in self.objects:
            self._parse_obj(o)
        self._get_symbols(static=True)
        self._get_symbol("_start", static=True)

        himem = 0
        for e in self.executables:
            if e.pos + len(e.code) > himem:
                himem = e.pos + len(e.code)

        self.defined_symbols["_HIMEM"] = himem

        out = bytearray()
        for e in self.executables:
            code = bytearray(e.code)
            for i in e.imports:
                s_addr = self.defined_symbols[i[0]]
                pos = i[4] + e.pos
                if s_addr < pos:
                    am = 0x1
                    mv = pos - s_addr
                else:
                    am = 0x2
                    mv = s_addr - pos

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

        cur_dir = os.path.dirname(__file__)
        with open(os.path.join(cur_dir, "start.o"), "rb") as f:
            start_o = bytearray(f.read())

        start_o.extend([0x2F, 0x20])
        start_o.extend(struct.pack("<h", start_symbol + 2))  # 2 is length of jump instruction excluding address

        return start_o + out

    def link_shared(self, strip, static):
        for o in self.objects:
            self._parse_obj(o)
        self._get_symbols(static=static)
        if static:
            self._get_symbol("_start", static=True)

            himem = 0
            for e in self.executables:
                if e.pos + len(e.code) > himem:
                    himem = e.pos + len(e.code)

            self.defined_symbols["_HIMEM"] = himem

        out = bytearray([0xB, 0xB, 0xC, ord('V'), ord('M'), 0x0])
        code_out = bytearray()
        exports = []
        imports = []

        for e in self.executables:
            code = bytearray(e.code)
            for i, l in e.exports.items():
                pos = l + e.pos
                exports.append((i, pos))
            for i in e.imports:
                s_addr = self.defined_symbols.get(i[0])
                if s_addr is not None:
                    pos = i[4] + e.pos
                    if s_addr < pos:
                        am = 0x1
                        mv = pos - s_addr
                    else:
                        am = 0x2
                        mv = s_addr - pos

                    lal = i[2]
                    if i[3] == 0:
                        code[lal] = (code[lal] & 0x0F) | ((am << 4) & 0xF0)
                    else:
                        code[lal] = (code[lal] & 0xF0) | (am & 0x0F)

                    code[i[4]:i[4]+2] = struct.pack("<h", mv)
                else:
                    imports.append((i[1]+e.pos, i[2]+e.pos, i[3], i[4]+e.pos, i[0]))

            code_out.extend(code)

        offset = 4 if static else 0
        header = bytearray()
        for i, l in exports:
            header.append(0x0)
            header.extend(struct.pack("<H", l+offset))
            header.extend(i.encode())
            header.append(0x0)

        for l in imports:
            lil, lal, lal2, lml, ln = l
            header.append(0x1)
            header.extend(struct.pack("<HHBH", lil+offset, lal+offset, lal2, lml+offset))
            header.extend(ln.encode())
            header.append(0x0)

        out.extend(struct.pack("<H", len(header)))
        out.extend(header)

        if static:
            start_symbol = self.defined_symbols.get("_start")
            if start_symbol is None:
                raise LookupError("No _start symbol, don't know where to start execution")

            out.extend([0x2F, 0x20])
            out.extend(struct.pack("<h", start_symbol + 2))  # 2 is length of jump instruction excluding address

        out.extend(code_out)

        return out
