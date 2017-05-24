class ASM:
    num1 = 0x8F
    num2 = num1 - 2
    result = num2 - 2
    ret = result - 4
    loc1 = ret - 2
    loc2 = loc1 - 2
    loc3 = loc2 - 2
    loc4 = loc3 - 2

    def __init__(self):
        self.asm = "NEW\n"
        self.line = 10

    @staticmethod
    def to_hex(num, leng=2):
        return (('%0' + str(leng) + 'x') % num).upper()

    def add_inst(self, isnt, op="", label=""):
        self.asm += str(self.line) + " "
        if label != "":
            self.asm += "." + label + " "
        self.asm += isnt.upper()
        if op != "":
            self.asm += " " + str(op)
        self.asm += "\n"
        self.line += 10

    def get_asm(self):
        asm = self.asm
        asm += "RUN\n"
        return asm
