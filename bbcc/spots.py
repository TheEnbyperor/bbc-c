from . import asm
from . import il


class Spot:
    def prologue(self, assembly: asm.ASM):
        pass

    def has_address(self):
        return True

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        raise NotImplementedError


class LiteralSpot(Spot):
    def __init__(self, value, value_type):
        self.value = value
        self.type = value_type

    def has_address(self):
        return False

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        hex = asm.ASM.to_hex(self.value, self.type.size*2)
        assembly.add_inst(inst, extra("#&" + hex[len(hex)-loc*2-2:len(hex)-loc*2]))

    def __str__(self):
        return '<LiteralSpot({type}:{value})>'.format(value=self.value, type=self.type)

    def __repr__(self):
        return self.__str__()


class Pseudo16RegisterSpot(Spot):
    def __init__(self, loc, value_type):
        self.loc = loc
        self.type = value_type

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        if loc not in [0, 1]:
            raise NotImplementedError("16-bit pseudo register cannot be accessed at offset {}".format(loc))
        assembly.add_inst(inst, extra("&" + asm.ASM.to_hex(self.loc+loc, 2)))

    def __eq__(self, other):
        if isinstance(other, Pseudo16RegisterSpot):
            if other.loc == self.loc:
                return True
        return False

    def __str__(self):
        return '<Pseudo16RegisterSpot({type}:{loc})>'.format(loc=self.loc, type=self.type)

    def __repr__(self):
        return self.__str__()


class AbsoluteMemorySpot(Spot):
    def __init__(self, loc, value_type):
        self.loc = loc
        self.type = value_type

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        assembly.add_inst(inst, extra("&" + asm.ASM.to_hex(self.loc+loc, 2)))

    def __eq__(self, other):
        if isinstance(other, AbsoluteMemorySpot):
            if other.loc == self.loc:
                return True
        return False

    def __str__(self):
        return '<AbsoluteMemorySpot({type}:{pos})>'.format(pos=asm.ASM.to_hex(self.loc), type=self.type)

    def __repr__(self):
        return self.__str__()


class LabelMemorySpot(Spot):
    def __init__(self, label, value_type):
        self.label = label
        self.type = value_type

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        if loc == 0:
            char = "<"
        elif loc == 1:
            char = ">"
        else:
            raise NotImplementedError("Label memory spot cannot be accessed at offset {}".format(loc))
        assembly.add_inst(inst, extra("{}({})".format(char, self.label)))

    def __eq__(self, other):
        if isinstance(other, LabelMemorySpot):
            if other.label == self.label:
                return True
        return False

    def __str__(self):
        return '<LabelMemorySpot({type}:{pos})>'.format(pos=self.label, type=self.type)

    def __repr__(self):
        return self.__str__()


class StackSpot(Spot):
    def __init__(self, offset, value_type):
        self.offset = offset
        self.type = value_type

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        assembly.add_inst("LDY", "#&{}".format(assembly.to_hex(self.offset+loc)))
        assembly.add_inst(inst, "(&{}),Y".format(assembly.to_hex(il.stack_register.loc)))

    def __eq__(self, other):
        if isinstance(other, StackSpot):
            if other.offset == self.offset:
                return True
        return False

    def __str__(self):
        return '<StackSpot({type}:{offset})>'.format(offset=self.offset, type=self.type)

    def __repr__(self):
        return self.__str__()


class DerefSpot(Spot):
    def __init__(self, spot):
        self.spot = spot

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra="{}"):
        pass

    def __eq__(self, other):
        if isinstance(other, DerefSpot):
            if other.spot == self.spot:
                return True
        return False

    def __str__(self):
        return '<DerefSpot({spot})>'.format(spot=self.spot)

    def __repr__(self):
        return self.__str__()
