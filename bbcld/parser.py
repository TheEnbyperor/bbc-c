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


class Executable:
    def __init__(self, symbols, code, pos=0):
        self.symbols = symbols
        self.code = code
        self.pos = pos

    def __repr__(self):
        return "<Executable({}:{}:{})>".format(self.symbols, self.pos, self.code)


class Parser:
    HEADER = [0xB, 0xB, 0xC, 0x42, 0x42, 0x43]

    def __init__(self, obj):
        self.obj = obj

    def _parse_header(self, header):
        symbols = []
        while len(header) > 0:
            s_type, s_addr = struct.unpack("<BH", bytes(header[:3]))
            header = header[3:]
            s_name = ""
            while header[0] != 0:
                s_name += chr(header[0])
                header = header[1:]
            symbols.append(Symbol(s_name, s_addr, s_type))
            header = header[1:]
        return symbols

    def parse(self):
        obj = self.obj
        if obj[:len(self.HEADER)] != self.HEADER:
            raise SyntaxError("File is not a BBC executable")
        obj = obj[len(self.HEADER):]

        header_len = struct.unpack("<H", bytes(obj[:2]))[0]
        obj = obj[2:]

        symbols = self._parse_header(obj[:header_len])
        obj = obj[header_len:]

        return Executable(symbols, obj)
