class Value:
    pass


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


class LDA(Inst):
    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LDA({})>".format(self.value)


class LDY(Inst):
    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LDY({})>".format(self.value)
