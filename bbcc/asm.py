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
    preg15 = preg14 + 2
    preg16 = preg15 + 2
    preg17 = preg16 + 2
    preg18 = preg17 + 2

    def __init__(self):
        self.asm = ""
        # self.add_inst("LDA", "&" + self.to_hex(self.num2), "neg")
        # self.add_inst("EOR", "#&FF")
        # self.add_inst("STA", "&" + self.to_hex(self.num2))
        # self.add_inst("LDA", "&" + self.to_hex(self.num2 - 1))
        # self.add_inst("EOR", "#&FF")
        # self.add_inst("STA", "&" + self.to_hex(self.num2 - 1))
        # self.add_inst("LDA", "#0")
        # self.add_inst("STA", "&" + self.to_hex(self.num1 - 1))
        # self.add_inst("LDA", "#1")
        # self.add_inst("STA", "&" + self.to_hex(self.num1))
        # self.add_inst("JSR", "add")
        # self.add_inst("RTS")

    @classmethod
    def to_hex(cls, num, length=2):
        return (('%0' + str(length) + 'x') % num).upper()

    def add_comment(self, comment):
        self.asm += "\n\\ " + comment + "\n"

    def add_inst(self, isnt="", op="", label=""):
        if label != "":
            self.asm += "." + label + " "
        self.asm += isnt.upper()
        if op != "":
            self.asm += " " + str(op)
        self.asm += "\n"

    def get_asm(self):
        return self.asm
