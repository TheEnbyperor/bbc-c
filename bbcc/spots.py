from . import asm
from . import il


class Spot:
    def prologue(self, assembly: asm.ASM):
        pass

    def has_address(self):
        return True

    def asm_str(self, loc: int):
        raise NotImplementedError


class LiteralSpot(Spot):
    def __init__(self, value, value_type):
        self.value = value
        self.type = value_type

    def has_address(self):
        return False

    def asm_str(self, loc: int) -> str:
        if loc > 1:
            return "#&00"
        return "#&" + asm.ASM.to_hex(self.value, 4)[loc*2:loc*2+2]

    def __str__(self):
        return '<LiteralSpot({type}:{value})>'.format(value=self.value, type=self.type)

    def __repr__(self):
        return self.__str__()


class Pseudo16RegisterSpot(Spot):
    def __init__(self, loc, value_type):
        self.loc = loc
        self.type = value_type

    def asm_str(self, loc: int) -> str:
        if loc not in [0, 1]:
            raise NotImplementedError("16-bit pseudo register cannot be accessed at offset {}".format(loc))
        return "&" + asm.ASM.to_hex(self.loc+loc, 2)

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

    def asm_str(self, loc: int):
        return "&" + asm.ASM.to_hex(self.loc+loc, 2)

    def __eq__(self, other):
        if isinstance(other, AbsoluteMemorySpot):
            if other.loc == self.loc:
                return True
        return False


class StackSpot(Spot):
    def __init__(self, offset, value_type):
        self.offset = offset
        self.type = value_type

    def prologue(self, assembly: asm.ASM):
        assembly.add_inst("LDY", "#&{}".format(assembly.to_hex(self.offset)))

    def asm_str(self, loc: int):
        return "({}),Y".format(il.stack_register.asm_str(0))

    def __eq__(self, other):
        if isinstance(other, StackSpot):
            if other.offset == self.offset:
                return True
        return False

    def __str__(self):
        return '<StackSpot({type}:{offset})>'.format(offset=self.offset, type=self.type)

    def __repr__(self):
        return self.__str__()
