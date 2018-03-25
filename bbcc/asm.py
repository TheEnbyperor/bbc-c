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
        # self.add_inst("LDA", "#0", "mul")
        # self.add_inst("STA", "&" + self.to_hex(self.result - 2))
        # self.add_inst("STA", "&" + self.to_hex(self.result - 3))
        # self.add_inst("LDX", "#&10")
        # self.add_inst("LSR", "&" + self.to_hex(self.num1 - 1), "mul1")
        # self.add_inst("ROR", "&" + self.to_hex(self.num1))
        # self.add_inst("BCC", "mul2")
        # self.add_inst("LDA", "&" + self.to_hex(self.result - 2))
        # self.add_inst("CLC")
        # self.add_inst("ADC", "&" + self.to_hex(self.num2))
        # self.add_inst("STA", "&" + self.to_hex(self.result - 2))
        # self.add_inst("LDA", "&" + self.to_hex(self.result - 3))
        # self.add_inst("ADC", "&" + self.to_hex(self.num2 - 1))
        # self.add_inst("ROR", "A", "mul2")
        # self.add_inst("STA", "&" + self.to_hex(self.result - 3))
        # self.add_inst("ROR", "&" + self.to_hex(self.result - 2))
        # self.add_inst("ROR", "&" + self.to_hex(self.result - 1))
        # self.add_inst("ROR", "&" + self.to_hex(self.result))
        # self.add_inst("DEX")
        # self.add_inst("BNE", "mul1")
        # self.add_inst("JSR", "movres")
        # self.add_inst("RTS")
        # self.add_inst("LDA", "#0", "div")
        # self.add_inst("STA", "&" + self.to_hex(self.result))
        # self.add_inst("STA", "&" + self.to_hex(self.result - 1))
        # self.add_inst("LDX", "#16")
        # self.add_inst("ASL", "&" + self.to_hex(self.num1), "div1")
        # self.add_inst("ROL", "&" + self.to_hex(self.num1 - 1))
        # self.add_inst("ROL", "&" + self.to_hex(self.result))
        # self.add_inst("ROL", "&" + self.to_hex(self.result - 1))
        # self.add_inst("LDA", "&" + self.to_hex(self.result))
        # self.add_inst("SEC")
        # self.add_inst("SBC", "&" + self.to_hex(self.num2))
        # self.add_inst("TAY")
        # self.add_inst("LDA", "&" + self.to_hex(self.result - 1))
        # self.add_inst("SBC", "&" + self.to_hex(self.num2 - 1))
        # self.add_inst("BCC", "div2")
        # self.add_inst("STA", "&" + self.to_hex(self.result - 1))
        # self.add_inst("STY", "&" + self.to_hex(self.result))
        # self.add_inst("INC", "&" + self.to_hex(self.num1))
        # self.add_inst("DEX", label="div2")
        # self.add_inst("BNE", "div1")
        # self.add_inst("RTS")
        # self.add_inst("SEC", label="sub")
        # self.add_inst("LDA", "&" + self.to_hex(self.num1))
        # self.add_inst("SBC", "&" + self.to_hex(self.num2))
        # self.add_inst("STA", "&" + self.to_hex(self.num1))
        # self.add_inst("LDA", "&" + self.to_hex(self.num1 - 1))
        # self.add_inst("SBC", "&" + self.to_hex(self.num2 - 1))
        # self.add_inst("STA", "&" + self.to_hex(self.num1 - 1))
        # self.add_inst("RTS")
        # self.add_inst("LDA", "&" + self.to_hex(self.num2), "movnum")
        # self.add_inst("STA", "&" + self.to_hex(self.num1))
        # self.add_inst("LDA", "&" + self.to_hex(self.num2 - 1))
        # self.add_inst("STA", "&" + self.to_hex(self.num1 - 1))
        # self.add_inst("RTS")
        # self.add_inst("LDA", "#&" + self.to_hex(self.num1), "movloc")
        # self.add_inst("STA", "&" + self.to_hex(self.loc3))
        # self.add_inst("LDA", "#&" + self.to_hex(self.num1 - 1))
        # self.add_inst("STA", "&" + self.to_hex(self.loc4))
        # self.add_inst("LDA", "#0")
        # self.add_inst("STA", "&" + self.to_hex(self.loc3 - 1))
        # self.add_inst("STA", "&" + self.to_hex(self.loc4 - 1))
        # self.add_inst("LDY", "#0")
        # self.add_inst("LDA", "(&" + self.to_hex(self.loc1) + "),Y")
        # self.add_inst("STA", "&" + self.to_hex(self.num1))
        # self.add_inst("LDA", "(&" + self.to_hex(self.loc2) + "),Y")
        # self.add_inst("STA", "&" + self.to_hex(self.num1 - 1))
        # self.add_inst("RTS")
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
        # self.add_inst("JSR", "movres")
        # self.add_inst("RTS")
        # self.add_inst("LDA", "#0", "reset")
        # self.add_inst("STA", "&" + self.to_hex(self.num1))
        # self.add_inst("STA", "&" + self.to_hex(self.num1 - 1))
        # self.add_inst("STA", "&" + self.to_hex(self.num2))
        # self.add_inst("STA", "&" + self.to_hex(self.num2 - 1))
        # self.add_inst("STA", "&" + self.to_hex(self.result))
        # self.add_inst("STA", "&" + self.to_hex(self.result - 1))
        # self.add_inst("STA", "&" + self.to_hex(self.result - 2))
        # self.add_inst("STA", "&" + self.to_hex(self.result - 3))
        # self.add_inst("STA", "&" + self.to_hex(self.ret))
        # self.add_inst("STA", "&" + self.to_hex(self.ret - 1))
        # self.add_inst("STA", "&" + self.to_hex(self.temp))
        # self.add_inst("STA", "&" + self.to_hex(self.temp - 1))
        # self.add_inst("RTS")

    @classmethod
    def to_hex(cls, num, length=2):
        return (('%0' + str(length) + 'x') % num).upper()

    def add_inst(self, isnt="", op="", label=""):
        if label != "":
            self.asm += "." + label + " "
        self.asm += isnt.upper()
        if op != "":
            self.asm += " " + str(op)
        self.asm += "\n"

    def get_asm(self):
        return self.asm
