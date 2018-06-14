class ASM:
    preg1 = 0x70
    preg2 = preg1 + 2
    preg3 = preg2 + 2
    preg4 = preg3 + 2
    preg5 = preg4 + 2
    preg6 = preg5 + 2
    preg7 = preg6 + 2
    preg8 = preg7 + 2
    preg9 = preg8 + 2
    preg10 = preg9 + 2
    preg11 = preg10 + 2
    preg12 = preg11 + 2
    preg13 = preg12 + 2
    preg14 = preg13 + 2
    bstck = preg14 + 2
    cstck = bstck + 2

    def __init__(self):
        self.asm = ""

    @classmethod
    def to_hex(cls, num, length=2):
        return (('%0' + str(length) + 'x') % ((num + (1 << length*4)) % (1 << length*4))).upper()

    def add_comment(self, comment):
        self.asm += "\n\\ " + comment + "\n"

    def add_inst(self, isnt="", op="", label=""):
        if label != "":
            self.asm += "{}: ".format(label)
        self.asm += isnt.lower()
        if op != "":
            self.asm += " " + str(op)
        self.asm += "\n"

    def get_asm(self):
        return self.asm
