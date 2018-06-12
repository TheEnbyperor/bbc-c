from . import asm
from . import ast
from . import spots
from . import ctypes
from . import optimiser

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

        if output.has_address() and value != output:
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
        return [self.value, self.output]

    def outputs(self):
        return []

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
            if isinstance(value, spots.LabelMemorySpot):
                value.asm(assembly, "LDA", 0, extra=lambda x: "#{}".format(x))
                output.asm(assembly, "STA", 0)
                value.asm(assembly, "LDA", 1, extra=lambda x: "#{}".format(x))
                output.asm(assembly, "STA", 1)
            elif isinstance(value, spots.StackSpot):
                assembly.add_inst("CLC")
                stack_register.asm(assembly, "LDA", 0)
                assembly.add_inst("ADC", "#&{}".format(assembly.to_hex(value.offset, 4)[2:4]))
                output.asm(assembly, "STA", 0)
                stack_register.asm(assembly, "LDA", 1)
                assembly.add_inst("ADC", "#&{}".format(assembly.to_hex(value.offset, 4)[0:2]))
                output.asm(assembly, "STA", 1)
            else:
                value.asm(assembly, "LDA", 0, extra=lambda x: "#{}".format(x[:3]))
                output.asm(assembly, "STA", 1)
                value.asm(assembly, "LDA", 0, extra=lambda x: "#{}".format(x[3:5]))
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
            for c in il.commands:
                if isinstance(c, Function):
                    if c.func_name == self.func_name:
                        found_start = True
                        continue
                if found_start:
                    if type(c) == Return:
                        if c.func_name != self.func_name:
                            break
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

        if il.func_stack_size[self.func_name] > 0:
            offset = il.func_stack_size[self.func_name]
            assembly.add_inst("CLC")
            stack_register.asm(assembly, "LDA", 0)
            assembly.add_inst("ADC", "#&{}".format(assembly.to_hex(offset, 4)[2:4]))
            stack_register.asm(assembly, "STA", 0)
            stack_register.asm(assembly, "LDA", 1)
            assembly.add_inst("ADC", "#&{}".format(assembly.to_hex(offset, 4)[0:2]))
            stack_register.asm(assembly, "STA", 1)

        for reg in used:
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

    def inputs(self):
        return self.args

    def outputs(self):
        return [self.output]

    def clobber(self):
        return [spots.Pseudo16RegisterSpot(return_register, self.output.type)]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        output = spotmap[self.output]
        ret_reg = spots.Pseudo16RegisterSpot(return_register, output.type)

        offset = 0
        for a in self.args[::-1]:
            spot = spotmap[a]
            for i in range(spot.type.size)[::-1]:
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
                    if type(c) == Function:
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

        if il.func_stack_size[self.func_name] > 0:
            offset = il.func_stack_size[self.func_name]
            assembly.add_inst("SEC")
            stack_register.asm(assembly, "LDA", 0)
            assembly.add_inst("SBC", "#&{}".format(assembly.to_hex(offset, 4)[2:4]))
            stack_register.asm(assembly, "STA", 0)
            stack_register.asm(assembly, "LDA", 1)
            assembly.add_inst("SBC", "#&{}".format(assembly.to_hex(offset, 4)[0:2]))
            stack_register.asm(assembly, "STA", 1)


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
                    assembly.add_inst("ADC", "#0")
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
            if i > left.type.size and i > right.type.size:
                assembly.add_inst("LDA", "#0")
            else:
                if i < left.type.size:
                    left.asm(assembly, "LDA", i)
                else:
                    assembly.add_inst("LDA", "#0")
                if i < right.type.size:
                    right.asm(assembly, "SBC", i)
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
        assembly.add_inst("LDX", "#&{}".format(assembly.to_hex(right.type.size * 8)))
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
        assembly.add_inst("LDX", "#&{}".format(assembly.to_hex(left.type.size * 8)))
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
            if isinstance(value, spots.StackSpot):
                assembly.add_inst("CLC")
                for i in range(value.type.size):
                    value.asm(assembly, "LDA", i)
                    if i == 0:
                        assembly.add_inst("ADC", "#1")
                    else:
                        assembly.add_inst("ADC", "#0")
                    value.asm(assembly, "STA", i)
            else:
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
            if isinstance(value, spots.StackSpot):
                assembly.add_inst("SEC")
                for i in range(value.type.size):
                    value.asm(assembly, "LDA", i)
                    if i == 0:
                        assembly.add_inst("SBC", "#1")
                    else:
                        assembly.add_inst("SBC", "#0")
                    value.asm(assembly, "STA", i)
            else:
                for i in range(value.type.size):
                    if i != value.type.size - 1:
                        labels.insert(i, il.get_label())
                        value.asm(assembly, "LDA", i)
                        assembly.add_inst("BNE", labels[i])

                for i in reversed(range(value.type.size)):
                    if i != value.type.size - 1:
                        assembly.add_inst(label=labels[i])
                    value.asm(assembly, "DEC", i)


class And(ILInst):
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

        for i in range(output.type.size):
            if i > left.type.size and i > right.type.size:
                assembly.add_inst("LDA", "#0")
            else:
                if i < left.type.size:
                    left.asm(assembly, "LDA", i)
                else:
                    assembly.add_inst("LDA", "#0")
                if i < right.type.size:
                    right.asm(assembly, "AND", i)
                else:
                    assembly.add_inst("AND", "#0")
            output.asm(assembly, "STA", i)


class IncOr(ILInst):
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

        for i in range(output.type.size):
            if i > left.type.size and i > right.type.size:
                assembly.add_inst("LDA", "#0")
            else:
                if i < left.type.size:
                    left.asm(assembly, "LDA", i)
                else:
                    assembly.add_inst("LDA", "#0")
                if i < right.type.size:
                    right.asm(assembly, "ORA", i)
                else:
                    assembly.add_inst("ORA", "#0")
            output.asm(assembly, "STA", i)


class ExcOr(ILInst):
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

        for i in range(output.type.size):
            if i > left.type.size and i > right.type.size:
                assembly.add_inst("LDA", "#0")
            else:
                if i < left.type.size:
                    left.asm(assembly, "LDA", i)
                else:
                    assembly.add_inst("LDA", "#0")
                if i < right.type.size:
                    right.asm(assembly, "EOR", i)
                else:
                    assembly.add_inst("EOR", "#0")
            output.asm(assembly, "STA", i)


class Not(ILInst):
    def __init__(self, expr: ILValue, output: ILValue):
        self.expr = expr
        self.output = output

    def inputs(self):
        return [self.expr]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        expr = spotmap[self.expr]
        output = spotmap[self.output]

        for i in range(output.type.size):
            if i < expr.type.size:
                expr.asm(assembly, "LDA", i)
            else:
                assembly.add_inst("LDA", "#0")
            assembly.add_inst("EOR", "#&FF")
            output.asm(assembly, "STA", i)


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
        output.asm(assembly, "STA", 0)
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
        is_signed = left.type.is_signed() or right.type.is_signed()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)

        if is_signed:
            assembly.add_inst("SEC")
            for i in reversed(range(left.type.size)):
                left.asm(assembly, "LDA", i)
                if i < right.type.size:
                    right.asm(assembly, "SBC", i)
                else:
                    assembly.add_inst("SBC", "#0")
                if i == left.type.size-1:
                    label3 = il.get_label()
                    label4 = il.get_label()
                    assembly.add_inst("BVC", label3)
                    assembly.add_inst("EOR", "#&80")
                    assembly.add_inst("BMI", label1, label=label3)
                    assembly.add_inst("BVC", label4)
                    assembly.add_inst("EOR", "#&80")
                    assembly.add_inst("BNE", label2, label=label4)
                else:
                    assembly.add_inst("BCC", label1)
                    if i != 0:
                        assembly.add_inst("BNE", label2)
        else:
            for i in reversed(range(left.type.size)):
                left.asm(assembly, "LDA", i)
                if i < right.type.size:
                    right.asm(assembly, "CMP", i)
                else:
                    assembly.add_inst("CMP", "#0")
                assembly.add_inst("BCC", label1)
                if i != 0:
                    assembly.add_inst("BNE", label2)

        assembly.add_inst(label=label1)
        assembly.add_inst("LDA", "#01")
        output.asm(assembly, "STA", 0)
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

        label = il.get_label()
        is_signed = left.type.is_signed() or right.type.is_signed()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)
        if is_signed:
            assembly.add_inst("SEC")
        else:
            assembly.add_inst("CLC")
        for i in reversed(range(left.type.size)):
            left.asm(assembly, "LDA", i)
            if i < right.type.size:
                right.asm(assembly, "SBC", i)
            else:
                assembly.add_inst("SBC", "#0")

        if is_signed:
            label2 = il.get_label()
            assembly.add_inst("BVC", label2)
            assembly.add_inst("EOR", "#&80")
            assembly.add_inst("BPL", label, label=label2)
        else:
            assembly.add_inst("BCS", label)
        assembly.add_inst("BCS", label)
        assembly.add_inst("LDA", "#01")
        output.asm(assembly, "STA", 0)
        assembly.add_inst(label=label)


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

        label = il.get_label()
        is_signed = left.type.is_signed() or right.type.is_signed()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)
        if is_signed:
            assembly.add_inst("SEC")
        else:
            assembly.add_inst("CLC")
        for i in reversed(range(left.type.size)):
            left.asm(assembly, "LDA", i)
            if i < right.type.size:
                right.asm(assembly, "CMP", i)
            else:
                assembly.add_inst("CMP", "#0")

        if is_signed:
            label2 = il.get_label()
            assembly.add_inst("BVC", label2)
            assembly.add_inst("EOR", "#&80")
            assembly.add_inst("BMI", label, label=label2)
        else:
            assembly.add_inst("BCC", label)
        assembly.add_inst("LDA", "#01")
        output.asm(assembly, "STA", 0)
        assembly.add_inst(label=label)


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

        label = il.get_label()
        is_signed = left.type.is_signed() or right.type.is_signed()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)
        if is_signed:
            assembly.add_inst("CLC")
        else:
            assembly.add_inst("SEC")
        for i in reversed(range(left.type.size)):
            left.asm(assembly, "LDA", i)
            if i == 0:
                if i < right.type.size:
                    right.asm(assembly, "CMP", i)
                else:
                    assembly.add_inst("CMP", "#0")
            else:
                if i < right.type.size:
                    right.asm(assembly, "SBC", i)
                else:
                    assembly.add_inst("SBC", "#0")

        if is_signed:
            label2 = il.get_label()
            assembly.add_inst("BVC", label2)
            assembly.add_inst("EOR", "#&80")
            assembly.add_inst("BMI", label, label=label2)
        else:
            assembly.add_inst("BCC", label)
        assembly.add_inst("LDA", "#01")
        output.asm(assembly, "STA", 0)
        assembly.add_inst(label=label)


class IL:
    def __init__(self, symbol_table):
        self.commands = []
        self.literals = {}
        self.string_literals = {}
        self.label_count = 0
        self.spotmap = {}
        self.symbol_table = symbol_table
        self.func_stack_size = {}

    def register_literal_value(self, il_value: ILValue, value):
        self.literals[il_value] = value

    def register_literal_string(self, il_value: ILValue, value):
        self.string_literals[il_value] = value

    def is_string_literal(self, il_value: ILValue):
        return il_value in self.string_literals

    def register_spot_value(self, il_value: ILValue, spot: spots.Spot):
        self.spotmap[il_value] = spot

    def get_label(self) -> str:
        label = "__bbcc_" + '%08x' % self.label_count
        self.label_count += 1
        return label

    def add(self, command: ILInst):
        self.commands.append(command)

    def gen_asm(self, assembly: asm.ASM):
        spotmap = self.spotmap

        exports = []
        imports = ["_bbcc_pusha", "_bbcc_pulla"]

        funcs = []
        for c in self.commands:
            if isinstance(c, Function):
                funcs.append(c.func_name)

        for c in self.commands:
            if isinstance(c, CallFunction):
                if c.name not in funcs:
                    imports.append(c.name)

        for n, s in self.symbol_table.symbols.items():
            if s.storage == ast.DeclInfo.EXTERN:
                imports.append(n)
            else:
                if s.storage != ast.DeclInfo.STATIC:
                    if s.type.is_function() and (s.name not in funcs):
                        continue
                    exports.append(n)
                if not s.type.is_function():
                    v = s.il_value
                    label = self.get_label()
                    spotmap[v] = spots.LabelMemorySpot(label, v.type)
                    assembly.add_inst(".byte", ("&00," * v.type.size).rstrip(","), label=label)

        for e in exports:
            assembly.add_inst(".export", e)
        for i in imports:
            assembly.add_inst(".import", i)

        self._print_commands()

        for i, v in self.literals.items():
            spotmap[i] = spots.LiteralSpot(v, i.type)

        for i, v in self.string_literals.items():
            label = self.get_label()
            assembly.add_inst(".byte", ",".join(["&{}".format(assembly.to_hex(b)) for b in v.encode()]), label=label)
            spotmap[i] = spots.LabelMemorySpot(label, i.type)

        move_to_mem = []
        for c in self.commands:
            for v in c.inputs() + c.outputs() + c.scratch_spaces():
                if v.type.is_array() or v.type.is_struct_union():
                    move_to_mem.append(v)
            if isinstance(c, AddrOf):
                for v in c.inputs():
                    move_to_mem.append(v)

        max_stack_offset = {}
        func_stack_size = {}
        current_function = ""

        for i, c in enumerate(self.commands):
            if isinstance(c, Function):
                current_function = c.func_name
                max_stack_offset[current_function] = 0
                func_stack_size[current_function] = 0
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
                        label = self.get_label()
                        spotmap[v] = spots.LabelMemorySpot(label, v.type)
                        assembly.add_inst(".byte", ("&00," * v.type.size).rstrip(","), label=label)
                    elif v.stack_offset is None and v not in move_to_mem:
                        reg = self._find_register(spotmap, i)
                        if reg is not None:
                            spotmap[v] = spots.Pseudo16RegisterSpot(reg, v.type)
                        else:
                            if v.zp_needed:
                                raise RuntimeError("Unable to find ZP location for {}".format(i))
                            if current_function == "":
                                label = self.get_label()
                                spotmap[v] = spots.LabelMemorySpot(label, v.type)
                                assembly.add_inst(".byte", ("&00," * v.type.size).rstrip(","), label=label)
                            else:
                                raise RuntimeError("Stack memory in functions not implemented")
                    elif v.stack_offset is not None:
                        if isinstance(c, Function):
                            if max_stack_offset[c.func_name] < v.stack_offset:
                                max_stack_offset[c.func_name] = v.stack_offset
                        spotmap[v] = spots.StackSpot(v.stack_offset, v.type, self, True, current_function)
                    elif not isinstance(c, Function):
                        if current_function == "":
                            label = self.get_label()
                            spotmap[v] = spots.LabelMemorySpot(label, v.type)
                            assembly.add_inst(".byte", ("&00," * v.type.size).rstrip(","), label=label)
                        else:
                            spotmap[v] = spots.StackSpot(func_stack_size[current_function], v.type, self)
                            func_stack_size[current_function] += v.type.size

        self.func_stack_size = func_stack_size

        optimise = optimiser.Optimiser()
        self.commands, spotmap = optimise.optimise(self.commands, spotmap)

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
