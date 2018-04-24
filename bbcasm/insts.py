class Value:
    label = None


class LiteralVal(Value):
    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "LiteralVal({})".format(self.value)


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
    pass


class NOP(Inst):
    def __repr__(self):
        return "<NOP>"


class LDA(Inst):
    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LDA({})>".format(self.value)


class STA(Inst):
    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<STA({})>".format(self.value)


class LDX(Inst):
    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LDX({})>".format(self.value)


class LDY(Inst):
    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LDY({})>".format(self.value)


class JSR(Inst):
    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<JSR({})>".format(self.value)


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
