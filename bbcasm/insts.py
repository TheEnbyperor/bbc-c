import struct


class Value:
    def __repr__(self):
        raise NotImplementedError

    def val(self):
        raise NotImplementedError


class LiteralVal(Value):
    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "LiteralVal({})".format(self.value)

    def val(self):
        return list(struct.pack("<B", self.value))


class AccumulatorVal(Value):
    def __repr__(self):
        return "AccumulatorVal"

    def val(self):
        return []


class ZpVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "ZpVal(0x{:x})".format(self.loc)

    def val(self):
        return list(struct.pack("<B", self.loc))


class MemVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        if isinstance(self.loc, LabelVal):
            return "MemVal({})".format(self.loc)
        return "MemVal(0x{:x})".format(self.loc)

    def val(self):
        return list(struct.pack("<H", self.loc))


class LabelVal(Value):
    def __init__(self, label, offset=0):
        self.label = label
        self.offset = offset

    def __repr__(self):
        return "LabelVal({}, {})".format(self.label, self.offset)

    def val(self):
        raise NotImplementedError


class LabelAddrVal(Value):
    def __init__(self, label, offset=0, loc_offset=0):
        self.label = label
        self.offset = offset
        self.loc_offset = loc_offset

    def __repr__(self):
        return "LabelAddrVal({})".format(self.label)

    def val(self):
        raise NotImplementedError


class MemXVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        if isinstance(self.loc, LabelVal):
            return "MemXVal({})".format(self.loc)
        return "MemXVal(0x{:x})".format(self.loc)

    def val(self):
        return list(struct.pack("<H", self.loc))


class MemYVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        if isinstance(self.loc, LabelVal):
            return "MemYVal({})".format(self.loc)
        return "MemYVal(0x{:x})".format(self.loc)

    def val(self):
        return list(struct.pack("<H", self.loc))


class ZpXVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "ZpXVal({})".format(self.loc)

    def val(self):
        return list(struct.pack("<B", self.loc))


class ZpYVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "ZpYVal({})".format(self.loc)

    def val(self):
        return list(struct.pack("<B", self.loc))


class IndirectVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "IndirectVal({})".format(self.loc)

    def val(self):
        return list(struct.pack("<H", self.loc))


class IndirectXVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "IndirectXVal({})".format(self.loc)

    def val(self):
        return list(struct.pack("<B", self.loc))


class IndirectYVal(Value):
    def __init__(self, loc):
        self.loc = loc

    def __repr__(self):
        return "IndirectYVal({})".format(self.loc)

    def val(self):
        return list(struct.pack("<B", self.loc))


class Byte:
    labels = []

    def __init__(self, value):
        self.value = value

    def __len__(self):
        return 1

    def gen(self, addr):
        return self.value.val()


class Inst:
    labels = []
    modes = []
    value = None
    inst = None

    def __len__(self):
        if self.value is None:
            return 1
        else:
            if type(self.value) in [AccumulatorVal]:
                return 1
            elif type(self.value) in [LiteralVal, ZpVal, ZpXVal, ZpYVal, IndirectXVal, IndirectYVal]:
                return 2
            elif type(self.value) in [MemVal, MemXVal, MemYVal, IndirectVal, LabelVal, LabelAddrVal]:
                return 3

    def is_relative(self):
        return False

    def gen(self, addr):
        if self.value is None:
            return [self.inst]
        else:
            inst = None
            for m in self.modes:
                if isinstance(self.value, m[0]):
                    inst = m[1]
                    break
            return [inst] + self.value.val()


class ADC(Inst):
    modes = [(LiteralVal, 0x69), (IndirectXVal, 0x61), (IndirectYVal, 0x71), (ZpXVal, 0x75), (ZpVal, 0x65),
             (MemVal, 0x6D), (MemXVal, 0x7D), (MemYVal, 0x79)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<ADC({})>".format(self.value)


class AND(Inst):
    modes = [(LiteralVal, 0x29), (IndirectXVal, 0x21), (IndirectYVal, 0x31), (ZpXVal, 0x35), (ZpVal, 0x25),
             (MemVal, 0x2D), (MemXVal, 0x3D), (MemYVal, 0x39)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<AND({})>".format(self.value)


class ASL(Inst):
    modes = [(AccumulatorVal, 0x0A), (ZpXVal, 0x16), (ZpVal, 0x06), (MemVal, 0x0E), (MemXVal, 0x1E)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<ASL({})>".format(self.value)


class BIT(Inst):
    modes = [(LiteralVal, 0x24), (MemVal, 0x2C)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BIT({})>".format(self.value)

    def __len__(self):
        return 2


class Branch(Inst):
    def __len__(self):
        return 2

    def is_relative(self):
        return True

    def gen(self, addr):
        inst = None
        for m in self.modes:
            if isinstance(self.value, m[0]):
                inst = m[1]
                break

        pos = self.value.loc
        jmp = pos-addr-2
        return [inst] + list(struct.pack("<b", jmp))


class BPL(Branch):
    modes = [(MemVal, 0x10)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BPL({})>".format(self.value)


class BMI(Branch):
    modes = [(MemVal, 0x30)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BMI({})>".format(self.value)


class BVC(Branch):
    modes = [(MemVal, 0x50)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BVC({})>".format(self.value)


class BVS(Branch):
    modes = [(MemVal, 0x70)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BVS({})>".format(self.value)


class BCC(Branch):
    modes = [(MemVal, 0x90)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BCC({})>".format(self.value)


class BCS(Branch):
    modes = [(MemVal, 0xB0)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BCS({})>".format(self.value)


class BNE(Branch):
    modes = [(MemVal, 0xD0)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BNE({})>".format(self.value)


class BEQ(Branch):
    modes = [(MemVal, 0xF0)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<BEQ({})>".format(self.value)


class BRK(Inst):
    inst = 0x00

    def __repr__(self):
        return "<BRK>"


class CMP(Inst):
    modes = [(LiteralVal, 0xC9), (IndirectXVal, 0xC1), (IndirectYVal, 0xD1), (ZpXVal, 0xD5), (ZpVal, 0xC5),
             (MemVal, 0xCD), (MemXVal, 0xDD), (MemYVal, 0xD9)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<CMP({})>".format(self.value)


class CPX(Inst):
    modes = [(LiteralVal, 0xE0), (ZpVal, 0xE4), (MemVal, 0xEC)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<CPX({})>".format(self.value)


class CPY(Inst):
    modes = [(LiteralVal, 0xC0), (ZpVal, 0xC4), (MemVal, 0xCC)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<CPY({})>".format(self.value)


class DEC(Inst):
    modes = [(ZpXVal, 0xD6), (ZpVal, 0xC6), (MemVal, 0xCE), (MemXVal, 0xDE)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<DEC({})>".format(self.value)


class EOR(Inst):
    modes = [(LiteralVal, 0xE9), (IndirectXVal, 0x41), (IndirectYVal, 0x51), (ZpXVal, 0x55), (ZpVal, 0x45),
             (MemVal, 0x4D), (MemXVal, 0x5D), (MemYVal, 0x59)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<EOR({})>".format(self.value)


class CLC(Inst):
    inst = 0x18

    def __repr__(self):
        return "<CLC>"


class SEC(Inst):
    inst = 0x38

    def __repr__(self):
        return "<SEC>"


class CLI(Inst):
    inst = 0x58

    def __repr__(self):
        return "<CLI>"


class SEI(Inst):
    inst = 0x78

    def __repr__(self):
        return "<SEI>"


class CLV(Inst):
    inst = 0xB8

    def __repr__(self):
        return "<CLV>"


class CLD(Inst):
    inst = 0xD8

    def __repr__(self):
        return "<CLD>"


class SED(Inst):
    inst = 0xF8

    def __repr__(self):
        return "<SED>"


class INC(Inst):
    modes = [(ZpXVal, 0xF6), (ZpVal, 0xE6), (MemVal, 0xEE), (MemXVal, 0xFE)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<INC({})>".format(self.value)


class JMP(Inst):
    modes = [(MemVal, 0x4C), (IndirectVal, 0x6C)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<JMP({})>".format(self.value)

    def __len__(self):
        return 3


class JSR(Inst):
    modes = [(MemVal, 0x20)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<JSR({})>".format(self.value)

    def __len__(self):
        return 3


class LDA(Inst):
    modes = [(LiteralVal, 0xA9), (IndirectXVal, 0xA1), (IndirectYVal, 0xB1), (ZpXVal, 0xB5),
             (MemXVal, 0xBD), (MemYVal, 0xB9), (ZpVal, 0xA5), (MemVal, 0xAD)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LDA({})>".format(self.value)


class LDX(Inst):
    modes = [(LiteralVal, 0xA2), (ZpYVal, 0xB6), (ZpVal, 0xA6), (MemVal, 0xAE), (MemYVal, 0xBE)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LDX({})>".format(self.value)


class LDY(Inst):
    modes = [(LiteralVal, 0xA0), (ZpXVal, 0xB4), (ZpVal, 0xA4), (MemVal, 0xAC), (MemXVal, 0xBC)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LDY({})>".format(self.value)


class LSR(Inst):
    modes = [(AccumulatorVal, 0x4A), (ZpXVal, 0x56), (ZpVal, 0x46), (MemVal, 0x4e), (MemXVal, 0x5E)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<LSR({})>".format(self.value)


class NOP(Inst):
    inst = 0xEA

    def __repr__(self):
        return "<NOP>"


class ORA(Inst):
    modes = [(LiteralVal, 0x09), (IndirectXVal, 0x01), (IndirectYVal, 0x11), (ZpXVal, 0x15), (ZpVal, 0x05),
             (MemVal, 0x0D), (MemXVal, 0x1D), (MemYVal, 0x19)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<STA({})>".format(self.value)


class TAX(Inst):
    inst = 0xAA

    def __repr__(self):
        return "<TAX>"


class TXA(Inst):
    inst = 0x8A

    def __repr__(self):
        return "<TXA>"


class DEX(Inst):
    inst = 0xCA

    def __repr__(self):
        return "<DEX>"


class INX(Inst):
    inst = 0xE8

    def __repr__(self):
        return "<INX>"


class TAY(Inst):
    inst = 0xA8

    def __repr__(self):
        return "<TAY>"


class TYA(Inst):
    inst = 0x98

    def __repr__(self):
        return "<TYA>"


class DEY(Inst):
    inst = 0x88

    def __repr__(self):
        return "<DEY>"


class INY(Inst):
    inst = 0xC8

    def __repr__(self):
        return "<INY>"


class ROL(Inst):
    modes = [(AccumulatorVal, 0x2A), (ZpXVal, 0x36), (ZpVal, 0x26), (MemVal, 0x2E), (MemXVal, 0x3E)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<ROL({})>".format(self.value)


class ROR(Inst):
    modes = [(AccumulatorVal, 0x6A), (ZpXVal, 0x76), (ZpVal, 0x66), (MemVal, 0x6E), (MemXVal, 0x7E)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<ROR({})>".format(self.value)


class RTI(Inst):
    inst = 0x40

    def __repr__(self):
        return "<RTI>"


class RTS(Inst):
    inst = 0x60

    def __repr__(self):
        return "<RTS>"


class SBC(Inst):
    modes = [(LiteralVal, 0xE9), (IndirectXVal, 0xE1), (IndirectYVal, 0xF1), (ZpXVal, 0xF5), (ZpVal, 0xE5),
             (MemVal, 0xED), (MemXVal, 0xFD), (MemYVal, 0xF9)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<SBC({})>".format(self.value)


class STA(Inst):
    modes = [(IndirectXVal, 0x81), (IndirectYVal, 0x91), (ZpXVal, 0x95), (MemXVal, 0x9D), (MemYVal, 0x99), (ZpVal, 0x85),
             (MemVal, 0x8D)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<STA({})>".format(self.value)


class TXS(Inst):
    inst = 0x9A

    def __repr__(self):
        return "<TXS>"


class TSX(Inst):
    inst = 0xBA

    def __repr__(self):
        return "<TSX>"


class PHA(Inst):
    inst = 0x48

    def __repr__(self):
        return "<PHA>"


class PLA(Inst):
    inst = 0x68

    def __repr__(self):
        return "<PLA>"


class PHP(Inst):
    inst = 0x08

    def __repr__(self):
        return "<PHP>"


class PLP(Inst):
    inst = 0x28

    def __repr__(self):
        return "<PLP>"


class STX(Inst):
    modes = [(ZpYVal, 0x96), (ZpVal, 0x86), (MemVal, 0x8E)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<STX({})>".format(self.value)


class STY(Inst):
    modes = [(ZpXVal, 0x94), (ZpVal, 0x84), (MemVal, 0x8C)]

    def __init__(self, value):
        self.value = value

    def __repr__(self):
        return "<STY({})>".format(self.value)
