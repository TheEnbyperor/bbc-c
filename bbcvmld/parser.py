import struct


class Executable:
    def __init__(self, imports, exports, code):
        self.exports = exports
        self.imports = imports
        self.code = code

    def __repr__(self):
        return f"<Executable:{self.exports}:{self.imports}:{self.code}>"


class Parser:
    HEADER = bytes([0xB, 0xB, 0xC, ord('V'), ord('M'), 0x0])

    def __init__(self, obj):
        self.obj = obj

    def parse(self):
        obj = self.obj
        if obj[:len(self.HEADER)] != self.HEADER:
            raise SyntaxError("File is not a BBC VM executable")
        obj = obj[len(self.HEADER):]

        header_len = struct.unpack("<H", bytes(obj[:2]))[0]
        obj = obj[2:]

        header = obj[:header_len]
        obj = obj[header_len:]

        imports = []
        exports = {}

        pos = 0
        while pos < len(header):
            if header[pos] == 0x0:
                pos += 1
                loc, = struct.unpack("<h", header[pos:pos+2])
                pos += 2
                name = ""
                while header[pos] != 0:
                    name += chr(header[pos])
                    pos += 1
                pos += 1
                exports[name] = loc
            elif header[pos] == 0x1:
                pos += 1
                lil, lal, lal2, lml = struct.unpack("<hhbh", header[pos:pos+7])
                pos += 7
                name = ""
                while header[pos] != 0:
                    name += chr(header[pos])
                    pos += 1
                pos += 1
                imports.append((name, lil, lal, lal2, lml))
            else:
                raise SyntaxError("Invalid header")

        return Executable(imports, exports, obj)
