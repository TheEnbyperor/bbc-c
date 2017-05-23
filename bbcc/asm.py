class ASM:
    num1 = 0x8F
    num2 = 0x8D
    result = 0x8B
    ret = 0x87

    def __init__(self):
        self.asm = """NEW"""
        self.line = 10

    @staticmethod
    def to_hex(num):
        return ('%02x' % num).upper()

    def add_inst(self, isnt, op="", label=""):
        self.asm += str(self.line) + " "
        if label != "":
            self.asm += "." + label
        self.asm += isnt.upper()
        if op != "":
            self.asm += " " + str(op)
        self.asm += "\n"
        self.line += 10

    def get_asm(self):
        asm = self.asm
        asm += "RUN\n"
        return asm
