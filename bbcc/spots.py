from . import asm
from . import il


class Spot:
    def __init__(self, detail):
        self.detail = detail

    def stack_offset(self):
        return 0

    def __eq__(self, other):
        if type(self) == type(other):
            if other.detail == self.detail:
                return True
        return False

    def __hash__(self):
        return hash((self.__class__.__name__, self.detail))

    def asm(self, size: int):
        raise NotImplementedError


class LiteralSpot(Spot):
    def __init__(self, value):
        super().__init__(value)
        self.value = value

    def has_address(self):
        return False

    def asm(self, size: int):
        return "#{}".format(self.value)

    def __repr__(self):
        return '<LiteralSpot({value})>'.format(value=self.value)


class RegisterSpot(Spot):
    def __init__(self, num):
        super().__init__(num)
        self.num = num

    def asm(self, size: int):
        return "%{}".format(self.num)

    def __repr__(self):
        return f'<RegisterSpot({self.num})>'


class MemorySpot(Spot):
    size_map = {1: "BYTE",
                2: "WORD"}

    def __init__(self, base, offset=0):
        super().__init__((base, offset))
        self.base = base
        self.offset = offset

    def asm(self, size: int):
        if isinstance(self.base, Spot):
            base_str = self.base.asm(0)
        else:
            base_str = self.base

        if self.offset == 0:
            simple = base_str
        elif self.offset > 0:
            simple = f"{base_str}+{self.offset}"
        else:
            simple = f"{base_str}-{-self.offset}"

        size_desc = self.size_map.get(size, "")
        return f"{size_desc}[{simple}]"

    def __repr__(self):
        return f'<MemorySpot({self.base}:{self.offset})>'


R0 = RegisterSpot("r0")
R1 = RegisterSpot("r1")
R2 = RegisterSpot("r2")
R3 = RegisterSpot("r3")
R4 = RegisterSpot("r4")
R5 = RegisterSpot("r5")
R6 = RegisterSpot("r6")
R7 = RegisterSpot("r7")
R8 = RegisterSpot("r8")
R9 = RegisterSpot("r9")
R10 = RegisterSpot("r10")

registers = [R0, R1, R2, R3, R4, R5, R6, R7, R8, R9]

RBP = RegisterSpot("r11")
RSP = RegisterSpot("r13")
