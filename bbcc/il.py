from . import asm
from . import ast
from . import spots
from . import ctypes

pseudo_registers = [asm.ASM.preg1, asm.ASM.preg2, asm.ASM.preg3, asm.ASM.preg4, asm.ASM.preg5,
                    asm.ASM.preg6, asm.ASM.preg7, asm.ASM.preg8, asm.ASM.preg9, asm.ASM.preg10,
                    asm.ASM.preg11, asm.ASM.preg12, asm.ASM.preg13, asm.ASM.preg14, asm.ASM.preg15]
return_register = asm.ASM.preg1
stack_register = spots.Pseudo16RegisterSpot(asm.ASM.cstck, ctypes.integer)


class ILValue:
    def __init__(self, value_type, zp_needed=False, storage=None, name=None):
        self.type = value_type
        self.stack_offset = None
        self.storage = storage
        self.name = name
        self.zp_needed = zp_needed

    def val(self, il_code):
        return self

    def __str__(self):
        return str("{:X}".format(id(self) % 10000))

    def __repr__(self):
        return self.__str__()


class ILInst:
    def inputs(self):
        return []

    def outputs(self):
        return []

    def clobber(self):
        return []

    def scratch_spaces(self):
        return []

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        raise NotImplementedError

    def __str__(self):
        return "<{}>".format(type(self).__name__)

    def __repr__(self):
        return self.__str__()


class Routines(ILInst):
    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        assembly.add_inst("PHA", label="_bbcc_pusha")
        stack_register.asm(assembly, "LDA", 0)
        assembly.add_inst("BNE", "_bbcc_pusha_1")
        stack_register.asm(assembly, "DEC", 1)
        assembly.add_inst(label="_bbcc_pusha_1")
        stack_register.asm(assembly, "DEC", 0)
        assembly.add_inst("PLA")
        assembly.add_inst("LDY", "#00")
        stack_register.asm(assembly, "STA", 0, lambda x: "({}),Y".format(x))
        assembly.add_inst("RTS")

        assembly.add_inst("LDY", "#0", label="_bbcc_pulla")
        stack_register.asm(assembly, "LDA", 0, lambda x: "({}),Y".format(x))
        stack_register.asm(assembly, "INC", 0)
        assembly.add_inst("BEQ", "_bbcc_pulla_1")
        assembly.add_inst("RTS")
        assembly.add_inst(label="_bbcc_pulla_1")
        stack_register.asm(assembly, "INC", 1)
        assembly.add_inst("RTS")


class Set(ILInst):
    def __init__(self, value: ILValue, output: ILValue):
        self.value = value
        self.output = output

    def inputs(self):
        return [self.value]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        value = spotmap[self.value]
        output = spotmap[self.output]

        if output.has_address():
            for i in range(output.type.size):
                if i < value.type.size:
                    value.asm(assembly, "LDA", i)
                else:
                    assembly.add_inst("LDA", "#0")
                output.asm(assembly, "STA", i)


class ReadAt(ILInst):
    def __init__(self, value: ILValue, output: ILValue):
        self.value = value
        self.output = output
        self.scratch = ILValue(value.type, zp_needed=True)

    def inputs(self):
        return [self.value]

    def outputs(self):
        return [self.output]

    def scratch_spaces(self):
        return [self.scratch]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        value = spotmap[self.value]
        output = spotmap[self.output]
        scratch = spotmap[self.scratch]

        if output.has_address():
            value.asm(assembly, "LDA", 1)
            scratch.asm(assembly, "STA", 1)
            value.asm(assembly, "LDA", 0)
            scratch.asm(assembly, "STA", 0)

            for i in range(output.type.size):
                assembly.add_inst("LDY", "#&{}".format(assembly.to_hex(i)))
                scratch.asm(assembly, "LDA", 0, lambda x: "({}),Y".format(x))
                output.asm(assembly, "STA", i)


class SetAt(ILInst):
    def __init__(self, value: ILValue, output: ILValue):
        self.value = value
        self.output = output
        self.scratch = ILValue(value.type, zp_needed=True)

    def inputs(self):
        return [self.value]

    def outputs(self):
        return [self.output]

    def scratch_spaces(self):
        return [self.scratch]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        value = spotmap[self.value]
        output = spotmap[self.output]
        scratch = spotmap[self.scratch]

        if value.has_address():
            value.asm(assembly, "LDA", 0)
            scratch.asm(assembly, "STA", 0)
            value.asm(assembly, "LDA", 1)
            scratch.asm(assembly, "STA", 1)

            for i in range(output.type.size):
                output.asm(assembly, "LDA", i)
                assembly.add_inst("LDY", "#&{}".format(assembly.to_hex(i)))
                scratch.asm(assembly, "STA", 0, lambda x: "({}),Y".format(x))


class AddrOf(ILInst):
    def __init__(self, value: ILValue, output: ILValue):
        self.value = value
        self.output = output

    def inputs(self):
        return [self.value]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        value = spotmap[self.value]
        output = spotmap[self.output]

        if value.has_address():
            value.asm(assembly, "LDA", 0, extra=lambda x: "#&{}".format(x[3:5]))
            output.asm(assembly, "STA", 1)
            value.asm(assembly, "LDA", 1, extra=lambda x: "#{}".format(x[:3]))
            output.asm(assembly, "STA", 0)


class Label(ILInst):
    def __init__(self, label: str):
        self.label = label

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        assembly.add_inst(label=self.label)


class JmpSub(ILInst):
    def __init__(self, label: str):
        self.label = label

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        assembly.add_inst("JSR", self.label)


class Jmp(ILInst):
    def __init__(self, label: str):
        self.label = label

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        assembly.add_inst("JMP", self.label)


class JmpZero(ILInst):
    def __init__(self, value: ILValue, label: str):
        self.value = value
        self.label = label

    def inputs(self):
        return [self.value]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        value = spotmap[self.value]

        label = il.get_label()

        for i in range(value.type.size):
            value.asm(assembly, "LDA", i)
            assembly.add_inst("BNE", label)

        assembly.add_inst("JMP", self.label)
        assembly.add_inst(label=label)


class JmpNotZero(ILInst):
    def __init__(self, value: ILValue, label: str):
        self.value = value
        self.label = label

    def inputs(self):
        return [self.value]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        value = spotmap[self.value]

        label1 = il.get_label()
        label2 = il.get_label()

        for i in range(value.type.size):
            value.asm(assembly, "LDA", i)
            assembly.add_inst("BEQ", label1)

        assembly.add_inst("JMP", self.label, label=label1)
        assembly.add_inst(label=label2)


class Return(ILInst):
    def __init__(self, value, func_name=None, epilouge=True):
        self.value = value
        self.epilouge = epilouge
        self.func_name = func_name

    def inputs(self):
        if self.value is not None:
            return [self.value]
        return []

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        used = []
        if self.epilouge:
            found_start = False
            for c in il.commands[::-1]:
                if isinstance(c, Return):
                    if c.func_name == self.func_name:
                        found_start = True
                        continue
                if found_start:
                    if type(c) == Function:
                        break
                    for s in [spotmap[v] for v in c.outputs() + c.scratch_spaces()]:
                        if s not in used and isinstance(s, spots.Pseudo16RegisterSpot):
                            if s.loc in pseudo_registers and s.loc != return_register:
                                used.append(s)

        if self.value is not None:
            value = spotmap[self.value]
            ret_reg = spots.Pseudo16RegisterSpot(return_register, value.type)

            if value != ret_reg:
                for i in range(ret_reg.type.size):
                    value.asm(assembly, "LDA", i)
                    ret_reg.asm(assembly, "STA", i)

        for reg in used[::-1]:
            assembly.add_inst("PLA")
            reg.asm(assembly, "STA", 1)
            assembly.add_inst("PLA")
            reg.asm(assembly, "STA", 0)

        assembly.add_inst("RTS")


class CallFunction(ILInst):
    def __init__(self, name: str, args, output: ILValue):
        self.name = name
        self.args = args
        self.output = output

    def outputs(self):
        return [self.output]

    def clobber(self):
        return [spots.Pseudo16RegisterSpot(return_register, self.output.type)]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        output = spotmap[self.output]
        ret_reg = spots.Pseudo16RegisterSpot(return_register, output.type)

        offset = 0
        for a in self.args:
            spot = spotmap[a]
            for i in range(spot.type.size):
                spot.asm(assembly, "LDA", i)
                assembly.add_inst("JSR", "_bbcc_pusha")
            offset += spot.type.size

        assembly.add_inst("JSR", self.name)

        if offset > 0:
            assembly.add_inst("CLC")
            stack_register.asm(assembly, "LDA", 0)
            assembly.add_inst("ADC", "#&{}".format(assembly.to_hex(offset, 4)[2:4]))
            stack_register.asm(assembly, "STA", 0)
            stack_register.asm(assembly, "LDA", 1)
            assembly.add_inst("ADC", "#&{}".format(assembly.to_hex(offset, 4)[0:2]))
            stack_register.asm(assembly, "STA", 1)

        if not output.type.is_void():
            if ret_reg != output:
                for i in range(output.type.size):
                    ret_reg.asm(assembly, "LDA", i)
                    output.asm(assembly, "STA", i)


class Function(ILInst):
    def __init__(self, params, func_name, prolouge=True):
        self.params = params
        self.func_name = func_name
        self.prolouge = prolouge

    def inputs(self):
        return [v.il_value for v in self.params]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        used = []

        if self.prolouge:
            found_self = False
            for c in il.commands:
                if c == self:
                    found_self = True
                    continue
                if found_self:
                    if type(c) == Return:
                        if c.func_name != self.func_name:
                            break
                    for s in [spotmap[v] for v in c.outputs() + c.scratch_spaces()]:
                        if s not in used and isinstance(s, spots.Pseudo16RegisterSpot):
                            if s.loc in pseudo_registers and s.loc != return_register:
                                used.append(s)

        assembly.add_inst(label=self.func_name)

        for reg in used[::-1]:
            reg.asm(assembly, "LDA", 0)
            assembly.add_inst("PHA")
            reg.asm(assembly, "LDA", 1)
            assembly.add_inst("PHA")


# Arithmetic
class Add(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output

    def inputs(self):
        return [self.left, self.right]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        assembly.add_inst("CLC")
        for i in range(output.type.size):
            if i > left.type.size and i > right.type.size:
                assembly.add_inst("LDA", "#0")
            else:
                if i < left.type.size:
                    left.asm(assembly, "LDA", i)
                else:
                    assembly.add_inst("LDA", "#0")
                if i < right.type.size:
                    right.asm(assembly, "ADC", i)
                else:
                    assembly.add_inst("LDA", "#0")
            output.asm(assembly, "STA", i)


class Sub(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output

    def inputs(self):
        return [self.left, self.right]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        assembly.add_inst("SEC")
        for i in range(output.type.size):
            if i < left.type.size and i < right.type.size:
                assembly.add_inst("LDA", "#0")
            else:
                if i < left.type.size:
                    left.asm(assembly, "LDA", i)
                else:
                    assembly.add_inst("LDA", "#0")
                if i < right.type.size:
                    left.asm(assembly, "SBC", i)
                else:
                    assembly.add_inst("LDA", "#0")
            output.asm(assembly, "STA", i)


class Mult(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output
        self.scratch1 = ILValue(left.type)
        self.scratch2 = ILValue(right.type)

    def inputs(self):
        return [self.left, self.right]

    def outputs(self):
        return [self.output]

    def scratch_spaces(self):
        return [self.scratch1, self.scratch2]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        scratch1 = spotmap[self.scratch1]
        for i in range(scratch1.type.size):
            left.asm(assembly, "LDA", i)
            scratch1.asm(assembly, "STA", i)

        left = scratch1

        scratch2 = spotmap[self.scratch2]
        for i in range(scratch2.type.size):
            right.asm(assembly, "LDA", i)
            scratch2.asm(assembly, "STA", i)
        right = scratch2

        label1 = il.get_label()
        label2 = il.get_label()

        assembly.add_inst("LDA", "#0")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)
        assembly.add_inst("LDX", "#&{}".format(assembly.to_hex(right.type.size*8)))
        assembly.add_inst(label=label1)
        for i in reversed(range(right.type.size)):
            if i == right.type.size - 1:
                right.asm(assembly, "LSR", i)
            else:
                right.asm(assembly, "ROR", i)
        assembly.add_inst("BCC", label2)
        assembly.add_inst("CLC")
        for i in range(output.type.size):
            if i < left.type.size:
                left.asm(assembly, "LDA", i)
            else:
                assembly.add_inst("LDA", "#0")
            output.asm(assembly, "ADC", i)
            output.asm(assembly, "STA", i)
        assembly.add_inst("CLC", label=label2)
        for i in range(left.type.size):
            if i == 0:
                left.asm(assembly, "ASL", i)
            else:
                left.asm(assembly, "ROL", i)
        assembly.add_inst("DEX")
        assembly.add_inst("BNE", label1)


class Div(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output
        self.scratch1 = ILValue(left.type)
        self.scratch2 = ILValue(right.type)
        self.scratch3 = ILValue(left.type)

    def inputs(self):
        return [self.left, self.right]

    def outputs(self):
        return [self.output]

    def scratch_spaces(self):
        return [self.scratch1, self.scratch2, self.scratch3]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]
        scratch3 = spotmap[self.scratch3]

        scratch1 = spotmap[self.scratch1]
        for i in range(scratch1.type.size):
            left.asm(assembly, "LDA", i)
            scratch1.asm(assembly, "STA", i)

        left = scratch1

        scratch2 = spotmap[self.scratch2]
        for i in range(scratch2.type.size):
            right.asm(assembly, "LDA", i)
            scratch2.asm(assembly, "STA", i)
        right = scratch2

        label1 = il.get_label()
        label2 = il.get_label()
        label3 = il.get_label()

        assembly.add_inst("LDA", "#0")
        for i in range(output.type.size):
            scratch3.asm(assembly, "STA", i)
        assembly.add_inst("LDX", "#&{}".format(assembly.to_hex(left.type.size*8)))
        assembly.add_inst(label=label1)
        for i in range(left.type.size):
            if i == 0:
                left.asm(assembly, "ASL", i)
            else:
                left.asm(assembly, "ROL", i)
        for i in range(scratch3.type.size):
            scratch3.asm(assembly, "ROL", i)
        assembly.add_inst("SEC")
        for i in range(scratch3.type.size):
            scratch3.asm(assembly, "LDA", i)
            right.asm(assembly, "SBC", i)
            if i != scratch3.type.size - 1:
                assembly.add_inst("PHA")
        assembly.add_inst("BCC", label2)
        for i in reversed(range(scratch3.type.size)):
            if i != scratch3.type.size - 1:
                assembly.add_inst("PLA")
            scratch3.asm(assembly, "STA", i)
        left.asm(assembly, "INC", 0)
        assembly.add_inst("JMP", label3)
        assembly.add_inst(label=label2)
        for i in range(scratch3.type.size - 1):
            assembly.add_inst("PLA")
        assembly.add_inst("DEX", label=label3)
        assembly.add_inst("BNE", label1)

        for i in range(output.type.size):
            if i < left.type.size:
                left.asm(assembly, "LDA", i)
            else:
                assembly.add_inst("LDA", "#0")
            output.asm(assembly, "STA", i)


class Mod(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output
        self.scratch1 = ILValue(left.type)
        self.scratch2 = ILValue(right.type)

    def inputs(self):
        return [self.left, self.right]

    def outputs(self):
        return [self.output]

    def scratch_spaces(self):
        return [self.scratch1, self.scratch2]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        scratch1 = spotmap[self.scratch1]
        for i in range(scratch1.type.size):
            left.asm(assembly, "LDA", i)
            scratch1.asm(assembly, "STA", i)

        left = scratch1

        scratch2 = spotmap[self.scratch2]
        for i in range(scratch2.type.size):
            right.asm(assembly, "LDA", i)
            scratch2.asm(assembly, "STA", i)
        right = scratch2

        label1 = il.get_label()
        label2 = il.get_label()
        label3 = il.get_label()

        assembly.add_inst("LDA", "#0")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)
        assembly.add_inst("LDX", "#&{}".format(assembly.to_hex(left.type.size * 8)))
        assembly.add_inst(label=label1)
        for i in range(left.type.size):
            if i == 0:
                left.asm(assembly, "ASL", i)
            else:
                left.asm(assembly, "ROL", i)
        for i in range(output.type.size):
            output.asm(assembly, "ROL", i)
        assembly.add_inst("SEC")
        for i in range(output.type.size):
            output.asm(assembly, "LDA", i)
            right.asm(assembly, "SBC", i)
            if i != output.type.size - 1:
                assembly.add_inst("PHA")
        assembly.add_inst("BCC", label2)
        for i in reversed(range(output.type.size)):
            if i != output.type.size - 1:
                assembly.add_inst("PLA")
            output.asm(assembly, "STA", i)
        left.asm(assembly, "INC", 0)
        assembly.add_inst("JMP", label3)
        assembly.add_inst(label=label2)
        for i in range(output.type.size - 1):
            assembly.add_inst("PLA")
        assembly.add_inst("DEX", label=label3)
        assembly.add_inst("BNE", label1)


class Inc(ILInst):
    def __init__(self, value: ILValue):
        self.value = value

    def inputs(self):
        return [self.value]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        value = spotmap[self.value]

        label = il.get_label()

        if value.has_address():
            for i in range(value.type.size):
                value.asm(assembly, "INC", i)
                if i != value.type.size - 1:
                    assembly.add_inst("BNE", label)
            assembly.add_inst(label=label)


class Dec(ILInst):
    def __init__(self, value: ILValue):
        self.value = value

    def inputs(self):
        return [self.value]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        value = spotmap[self.value]

        labels = []

        if value.has_address():
            for i in range(value.type.size):
                if i != value.type.size - 1:
                    labels.insert(i, il.get_label())
                    value.asm(assembly, "LDA", i)
                    assembly.add_inst("BNE", labels[i])

            for i in reversed(range(value.type.size)):
                if i != value.type.size - 1:
                    assembly.add_inst(label=labels[i])
                value.asm(assembly, "DEC", i)


# Comparison
class EqualCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output

    def inputs(self):
        return [self.left, self.right]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        label = il.get_label()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)
        for i in range(left.type.size):
            left.asm(assembly, "LDA", i)
            if i < right.type.size:
                right.asm(assembly, "CMP", i)
            else:
                assembly.add_inst("CMP", "#0")
            assembly.add_inst("BNE", label)
        assembly.add_inst("LDA", "#01")
        output.asm(assembly, "STA", 0)
        assembly.add_inst(label=label)


class NotEqualCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output

    def inputs(self):
        return [self.left, self.right]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        label = il.get_label()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)
        for i in range(left.type.size):
            left.asm(assembly, "LDA", i)
            if i < right.type.size:
                right.asm(assembly, "CMP", i)
            else:
                assembly.add_inst("CMP", "#0")
            assembly.add_inst("BEQ", label)
        assembly.add_inst("LDA", "#01")
        output.asm(assembly, "STA", 1)
        assembly.add_inst(label=label)


class LessThanCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output

    def inputs(self):
        return [self.left, self.right]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        label1 = il.get_label()
        label2 = il.get_label()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)
        for i in reversed(range(left.type.size)):
            left.asm(assembly, "LDA", i)
            if i < right.type.size:
                right.asm(assembly, "CMP", i)
            else:
                assembly.add_inst("CMP", "#0")
            if i != 0:
                assembly.add_inst("BCC", label1)
                assembly.add_inst("BNE", label2)
            else:
                assembly.add_inst("BCS", label2)
        assembly.add_inst("LDA", "#01", label=label1)
        output.asm(assembly, "STA", 1)
        assembly.add_inst(label=label2)


class LessEqualCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output

    def inputs(self):
        return [self.left, self.right]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        label1 = il.get_label()
        label2 = il.get_label()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)
        for i in reversed(range(left.type.size)):
            left.asm(assembly, "LDA", i)
            if i < right.type.size:
                right.asm(assembly, "CMP", i)
            else:
                assembly.add_inst("CMP", "#0")
            assembly.add_inst("BCC", label1)
            assembly.add_inst("BNE", label2)
        assembly.add_inst("LDA", "#01", label=label1)
        output.asm(assembly, "STA", 1)
        assembly.add_inst(label=label2)


class MoreThanCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output

    def inputs(self):
        return [self.left, self.right]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        label1 = il.get_label()
        label2 = il.get_label()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)
        for i in reversed(range(left.type.size)):
            left.asm(assembly, "LDA", i)
            if i < right.type.size:
                right.asm(assembly, "CMP", i)
            else:
                assembly.add_inst("CMP", "#0")
            if i != 0:
                assembly.add_inst("BCC", label2)
                assembly.add_inst("BNE", label1)
            else:
                assembly.add_inst("BEQ", label2)
                assembly.add_inst("BCC", label2)
        assembly.add_inst("LDA", "#01", label=label1)
        output.asm(assembly, "STA", 1)
        assembly.add_inst(label=label2)


class MoreEqualCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output

    def inputs(self):
        return [self.left, self.right]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        label1 = il.get_label()
        label2 = il.get_label()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)
        for i in reversed(range(left.type.size)):
            left.asm(assembly, "LDA", i)
            if i < right.type.size:
                right.asm(assembly, "CMP", i)
            else:
                assembly.add_inst("CMP", "#0")
            if i != 0:
                assembly.add_inst("BCC", label2)
                assembly.add_inst("BNE", label1)
            else:
                assembly.add_inst("BCC", label2)
        assembly.add_inst("LDA", "#01", label=label1)
        output.asm(assembly, "STA", 1)
        assembly.add_inst(label=label2)


class IL:
    def __init__(self, symbol_table):
        self.commands = []
        self.literals = {}
        self.string_literals = {}
        self.label_count = 0
        self.spotmap = {}
        self.symbol_table = symbol_table

    def register_literal_value(self, il_value: ILValue, value):
        self.literals[il_value] = value

    def register_literal_string(self, il_value: ILValue, value):
        self.string_literals[il_value] = value

    def register_spot_value(self, il_value: ILValue, spot: spots.Spot):
        self.spotmap[il_value] = spot

    def get_label(self) -> str:
        label = "__bbcc_" + '%08x' % self.label_count
        self.label_count += 1
        return label

    def add(self, command: ILInst):
        self.commands.append(command)

    def gen_asm(self, assembly: asm.ASM):
        exports = []
        imports = []
        for c in self.commands:
            if isinstance(c, Function):
                exports.append(c.func_name)
        for c in self.commands:
            if isinstance(c, CallFunction):
                if c.name not in exports:
                    imports.append(c.name)

        for n, s in self.symbol_table.symbols.items():
            if not s.type.is_function():
                if s.storage == ast.DeclInfo.EXTERN:
                    imports.append("__{}".format(n))
                else:
                    exports.append("__{}".format(n))

        for e in exports:
            assembly.add_inst(".export", e)
        for i in imports:
            assembly.add_inst(".import", i)

        self._print_commands()

        spotmap = self.spotmap

        for i, v in self.literals.items():
            spotmap[i] = spots.LiteralSpot(v, i.type)

        move_to_mem = []
        for c in self.commands:
            for v in c.inputs() + c.outputs() + c.scratch_spaces():
                if v.type.is_array():
                    move_to_mem.append(v)
            if isinstance(c, AddrOf):
                for v in c.inputs():
                    move_to_mem.append(v)

        max_stack_offset = {}
        mem_start = 0x1000
        current_function = ""

        for i, c in enumerate(self.commands):
            if isinstance(c, Function):
                current_function = c.func_name
            elif isinstance(c, Return):
                for c2 in self.commands[i:]:
                    if isinstance(c2, Return):
                        if c2.func_name == c.func_name:
                            break
                    if isinstance(c2, Function):
                        if c2.func_name != c.func_name:
                            current_function = ""
            for v in (c.inputs() + c.outputs() + c.scratch_spaces())[::-1]:
                if v not in spotmap:
                    if v.storage == ast.DeclInfo.EXTERN:
                        spotmap[v] = spots.LabelMemorySpot("__{}".format(v.name), v.type)
                    elif current_function == "":
                        spotmap[v] = spots.AbsoluteMemorySpot(mem_start, v.type)
                        mem_start += v.type.size
                    elif v.stack_offset is None and v not in move_to_mem:
                        reg = self._find_register(spotmap, i)
                        if reg is not None:
                            spotmap[v] = spots.Pseudo16RegisterSpot(reg, v.type)
                        else:
                            if v.zp_needed:
                                raise RuntimeError("Unable to find ZP location for {}".format(i))
                            spotmap[v] = spots.AbsoluteMemorySpot(mem_start, v.type)
                            mem_start += 2
                    elif v.stack_offset is not None:
                        if isinstance(c, Function):
                            if max_stack_offset.get(c.func_name) is None:
                                max_stack_offset[c.func_name] = v.stack_offset
                            elif max_stack_offset[c.func_name] < v.stack_offset:
                                max_stack_offset[c.func_name] = v.stack_offset
                        spotmap[v] = spots.StackSpot(v.stack_offset, v.type)
                    elif not isinstance(c, Function):
                        if v.type.is_array():
                            spotmap[v] = spots.AbsoluteMemorySpot(mem_start, v.type)
                            mem_start += v.type.size

        self._print_spotmap(spotmap)

        for c in self.commands:
            assembly.add_comment(str(type(c).__name__))
            c.gen_asm(assembly, spotmap, self)

    @staticmethod
    def _print_spotmap(spotmap: dict):
        print("* SPOTMAP *")
        for i, s in spotmap.items():
            print("{: <20} {}".format(str(i), str(s)))
        print("")

    def _print_commands(self):
        print("* COMMANDS *")
        for c in self.commands:
            print("{: <20} {: <20} {}".format(str(c), str(c.inputs()), c.outputs()))
        print("")

    def _find_register(self, spotmap, command_i: int):
        for r in pseudo_registers:
            possible = True
            for c in self.commands[command_i + 1:]:
                for value in c.clobber():
                    if isinstance(value, spots.Pseudo16RegisterSpot):
                        if value.loc == r:
                            possible = False
                            break
                for value in c.outputs():
                    if value in spotmap:
                        if isinstance(spotmap[value], spots.Pseudo16RegisterSpot):
                            if spotmap[value].loc == r:
                                break
                for value in c.inputs():
                    if value in spotmap:
                        if isinstance(spotmap[value], spots.Pseudo16RegisterSpot):
                            if spotmap[value].loc == r:
                                possible = False
                                break
            if possible:
                c = self.commands[command_i]
                for value in c.inputs() + c.outputs() + c.scratch_spaces():
                    if value in spotmap:
                        if isinstance(spotmap[value], spots.Pseudo16RegisterSpot):
                            if spotmap[value].loc == r:
                                possible = False
                                break
                if possible:
                    return r
