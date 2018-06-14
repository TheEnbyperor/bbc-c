from . import asm
from . import il


class Spot:
    def __init__(self, detail):
        self.detail = detail

    def has_address(self):
        return True

    def stack_offset(self):
        return 0

    def __eq__(self, other):
        if type(self) == type(other):
            if other.detail == self.detail:
                return True
        return False

    def __hash__(self):
        return hash((self.__class__.__name__, self.detail))

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        raise NotImplementedError


class LiteralSpot(Spot):
    def __init__(self, value, value_type):
        super().__init__(value)
        self.value = value
        self.type = value_type

    def has_address(self):
        return False

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        hex = asm.ASM.to_hex(self.value, self.type.size*2)
        assembly.add_inst(inst, extra("#&" + hex[len(hex)-loc*2-2:len(hex)-loc*2]))

    def __repr__(self):
        return '<LiteralSpot({type}:{value})>'.format(value=self.value, type=self.type)


class Pseudo16RegisterSpot(Spot):
    def __init__(self, loc, value_type):
        super().__init__(loc)
        self.loc = loc
        self.type = value_type

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        if loc not in [0, 1]:
            raise NotImplementedError("16-bit pseudo register cannot be accessed at offset {}".format(loc))
        assembly.add_inst(inst, extra("&" + asm.ASM.to_hex(self.loc+loc, 2)))

    def __repr__(self):
        return '<Pseudo16RegisterSpot({type}:{loc})>'.format(loc=self.loc, type=self.type)


class AbsoluteMemorySpot(Spot):
    def __init__(self, loc, value_type):
        super().__init__(loc)
        self.loc = loc
        self.type = value_type

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        assembly.add_inst(inst, extra("&" + asm.ASM.to_hex(self.loc+loc, 2)))

    def __repr__(self):
        return '<AbsoluteMemorySpot({type}:{pos})>'.format(pos=asm.ASM.to_hex(self.loc), type=self.type)


class LabelMemorySpot(Spot):
    def __init__(self, label, value_type):
        super().__init__(label)
        self.label = label
        self.type = value_type

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        assembly.add_inst(inst, extra("{}({})".format(loc, self.label)))
        return False

    def __repr__(self):
        return '<LabelMemorySpot({type}:{pos})>'.format(pos=self.label, type=self.type)


class StackSpot(Spot):
    def __init__(self, offset, value_type,):
        super().__init__(offset)
        self.offset = offset
        self.type = value_type

    def stack_offset(self):
        return self.offset

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        assembly.add_inst("LDY", "#&{}".format(assembly.to_hex(self.offset+loc)))
        assembly.add_inst(inst, "(&{}),Y".format(assembly.to_hex(il.stack_register.loc)))

    def __repr__(self):
        return '<StackSpot({type}:{offset})>'.format(offset=self.offset, type=self.type)


class BaseStackSpot(Spot):
    def __init__(self, offset, value_type,):
        super().__init__(offset)
        self.offset = offset
        self.type = value_type

    def asm(self, assembly: asm.ASM, inst: str, loc: int, extra=lambda x: x):
        assembly.add_inst("LDY", "#&{}".format(assembly.to_hex(self.offset+loc)))
        assembly.add_inst(inst, "(&{}),Y".format(assembly.to_hex(il.base_register.loc)))

    def __repr__(self):
        return '<StackSpot({type}:{offset})>'.format(offset=self.offset, type=self.type)
