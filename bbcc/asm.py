class ASM:
    num1 = 0x8F
    num2 = num1 - 2
    result = num2 - 2
    ret = result - 4
    temp = ret - 2
    loc1 = temp - 3
    loc2 = loc1 - 2
    loc3 = loc2 - 2
    loc4 = loc3 - 2

    def __init__(self):
        self.asm = ""

    @staticmethod
    def to_hex(num, leng=2):
        return (('%0' + str(leng) + 'x') % num).upper()

    def add_inst(self, isnt="", op="", label=""):
        if label != "":
            self.asm += "." + label + " "
        self.asm += isnt.upper()
        if op != "":
            self.asm += " " + str(op)
        self.asm += "\n"

    def get_asm(self):
        return self.asm
