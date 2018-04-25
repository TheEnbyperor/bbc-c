class Value:
    label = None


class LiteralVal(Value):
    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "LiteralVal({})".format(self.value)


class AccumulatorVal(Value):
    def __repr__(self):
        return "AccumulatorVal"


class ZpVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "ZpVal(0x{:x})".format(self.loc)


class MemVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "MemVal(0x{:x})".format(self.loc)


class LabelVal(Value):
    def __init__(self, label):
        self.label = label

    def __repr__(self):
        return "LabelVal({})".format(self.label)


class MemXVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "MemXVal(0x{:x})".format(self.loc)


class MemYVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "MemYVal(0x{:x})".format(self.loc)


class ZpXVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "ZpXVal({})".format(self.loc)


class ZpYVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "ZpYVal({})".format(self.loc)


class IndirectVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "IndirectVal({})".format(self.loc)


class IndirectXVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "IndirectXVal({})".format(self.loc)


class IndirectYVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "IndirectYVal({})".format(self.loc)


class Inst:
    modes = []


class NOP(Inst):

    def __repr__(self):
        return "<NOP>"


class LDA(Inst):
    modes = [LiteralVal, ZpVal, ZpXVal, MemVal, MemXVal, MemYVal, IndirectXVal, IndirectYVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LDA({})>".format(self.value)


class STA(Inst):
    modes = [ZpVal, ZpXVal, MemVal, MemXVal, MemYVal, IndirectXVal, IndirectYVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<STA({})>".format(self.value)


class LDX(Inst):
    modes = [LiteralVal, ZpVal, ZpYVal, MemVal, MemYVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LDX({})>".format(self.value)


class LDY(Inst):
    modes = [LiteralVal, ZpVal, ZpXVal, MemVal, MemXVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LDY({})>".format(self.value)


class JSR(Inst):
    modes = [MemVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<JSR({})>".format(self.value)


class JMP(Inst):
    modes = [MemVal, IndirectVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<JMP({})>".format(self.value)


class RTS(Inst):
    def __repr__(self):
        return "<RTS>"


class PHA(Inst):
    def __repr__(self):
        return "<PHA>"


class PLA(Inst):
    def __repr__(self):
        return "<PLA>"


class PHP(Inst):
    def __repr__(self):
        return "<PHP>"


class PLP(Inst):
    def __repr__(self):
        return "<PLP>"


class TAX(Inst):
    def __repr__(self):
        return "<TAX>"


class TXA(Inst):
    def __repr__(self):
        return "<TXA>"


class DEX(Inst):
    def __repr__(self):
        return "<DEX>"


class INX(Inst):
    def __repr__(self):
        return "<INX>"


class TAY(Inst):
    def __repr__(self):
        return "<TAY>"


class TYA(Inst):
    def __repr__(self):
        return "<TYA>"


class DEY(Inst):
    def __repr__(self):
        return "<DEY>"


class INY(Inst):
    def __repr__(self):
        return "<INY>"


class INC(Inst):
    modes = [AccumulatorVal, ZpVal, ZpXVal, MemVal, MemXVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<INC({})>".format(self.value)


class DEC(Inst):
    modes = [AccumulatorVal, ZpVal, ZpXVal, MemVal, MemXVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<DEC({})>".format(self.value)


class ADC(Inst):
    modes = [LiteralVal, ZpVal, ZpXVal, MemVal, MemXVal, MemYVal, IndirectXVal, IndirectYVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<ADC({})>".format(self.value)


class SBC(Inst):
    modes = [LiteralVal, ZpVal, ZpXVal, MemVal, MemXVal, MemYVal, IndirectXVal, IndirectYVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<SBC({})>".format(self.value)


class LSR(Inst):
    modes = [ZpVal, ZpXVal, MemVal, MemXVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LSR({})>".format(self.value)


class ASL(Inst):
    modes = [ZpVal, ZpXVal, MemVal, MemXVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<ASL({})>".format(self.value)


class ROL(Inst):
    modes = [ZpVal, ZpXVal, MemVal, MemXVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<ROL({})>".format(self.value)


class ROR(Inst):
    modes = [ZpVal, ZpXVal, MemVal, MemXVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<ROR({})>".format(self.value)


class CMP(Inst):
    modes = [LiteralVal, ZpVal, ZpXVal, MemVal, MemXVal, MemYVal, IndirectXVal, IndirectYVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<CMP({})>".format(self.value)


class BCC(Inst):
    modes = [MemVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BCC({})>".format(self.value)


class BCS(Inst):
    modes = [MemVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BCS({})>".format(self.value)


class BNE(Inst):
    modes = [MemVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BNE({})>".format(self.value)


class BEQ(Inst):
    modes = [MemVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BEQ({})>".format(self.value)


class BPL(Inst):
    modes = [MemVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BPL({})>".format(self.value)


class BMI(Inst):
    modes = [MemVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BMI({})>".format(self.value)


class BVC(Inst):
    modes = [MemVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BVC({})>".format(self.value)


class BVS(Inst):
    modes = [MemVal]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BVS({})>".format(self.value)


class CLC(Inst):
    def __repr__(self):
        return "<CLC>"


class SEC(Inst):
    def __repr__(self):
        return "<SEC>"


class CLI(Inst):
    def __repr__(self):
        return "<CLI>"


class SEI(Inst):
    def __repr__(self):
        return "<SEI>"


class CLV(Inst):
    def __repr__(self):
        return "<CLV>"


class CLD(Inst):
    def __repr__(self):
        return "<CLD>"


class SED(Inst):
    def __repr__(self):
        return "<SED>"
