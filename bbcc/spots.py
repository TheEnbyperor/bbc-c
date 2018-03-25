from . import asm


class Spot:
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
