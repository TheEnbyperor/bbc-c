import itertools

from . import asm
from . import ast
from . import spots
from . import ctypes

return_register = spots.R0


class ILValue:
    def __init__(self, value_type, storage=None, name=None):
        self.type = value_type
        self.stack_offset = None
        self.storage = storage
        self.name = name

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

    def references(self):
        return {}

    def label_name(self):
        return None

    def targets(self):
        return []

    def rel_spot_conf(self):
        return {}

    def abs_spot_conf(self):
        return {}

    def rel_spot_pref(self):
        return {}

    def abs_spot_pref(self):
        return {}

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        value = spotmap[self.value]
        output = spotmap[self.output]

        if value != output:
            assembly.add_inst(asm.Mov(value, output, self.output.type.size))


class ReadAt(ILInst):
    def __init__(self, value: ILValue, output: ILValue):
        self.value = value
        self.output = output

    def inputs(self):
        return [self.value]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        value = spotmap[self.value]
        output = spotmap[self.output]

        if output.has_address():
            scratch = value
            if not isinstance(value, spots.Pseudo16RegisterSpot):
                scratch = spots.Pseudo16RegisterSpot(get_reg([], []), ctypes.unsig_int)
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

    def inputs(self):
        return [self.value, self.output]

    def outputs(self):
        return []

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        value = spotmap[self.value]
        output = spotmap[self.output]

        if value.has_address():
            scratch = value
            if not isinstance(value, spots.Pseudo16RegisterSpot):
                scratch = spots.Pseudo16RegisterSpot(get_reg([], []), ctypes.unsig_int)
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

    def references(self):
        return {self.output: [self.value]}

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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
            elif isinstance(value, spots.BaseStackSpot):
                assembly.add_inst("CLC")
                base_register.asm(assembly, "LDA", 0)
                assembly.add_inst("ADC", "#&{}".format(assembly.to_hex(value.offset, 4)[2:4]))
                output.asm(assembly, "STA", 0)
                base_register.asm(assembly, "LDA", 1)
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

    def label_name(self):
        return self.label

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        assembly.add_inst(label=self.label)


class JmpSub(ILInst):
    def __init__(self, label: str):
        self.label = label

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        assembly.add_inst("JSR", self.label)


class Jmp(ILInst):
    def __init__(self, label: str):
        self.label = label

    def targets(self):
        return [self.label]

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        assembly.add_inst("JMP", self.label)


class JmpZero(ILInst):
    def __init__(self, value: ILValue, label: str):
        self.value = value
        self.label = label

    def targets(self):
        return [self.label]

    def inputs(self):
        return [self.value]

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def targets(self):
        return [self.label]

    def inputs(self):
        return [self.value]

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        if self.value is not None:
            value = spotmap[self.value]

            if value != return_register:
                assembly.add_inst(asm.Mov(value, return_register, self.value.type.size))

        used_regs = []
        for v in spotmap.values():
            if isinstance(v, spots.RegisterSpot):
                if v not in used_regs and v != return_register:
                    used_regs.append(v)

        for r in used_regs[::-1]:
            assembly.add_inst(asm.Pop(r, None, 2))

        assembly.add_inst(asm.Mov(spots.RBP, spots.RSP, 2))
        assembly.add_inst(asm.Pop(spots.RBP, None, 2))

        assembly.add_inst(asm.Ret())


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
        return [return_register] if not self.output.type.is_void() else []

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        output = spotmap[self.output]

        offset = 0
        for a in self.args[::-1]:
            spot = spotmap[a]
            if not isinstance(spot, spots.RegisterSpot):
                old_spot = spot
                spot = get_reg()
                assembly.add_inst(asm.Mov(old_spot, spot))
            assembly.add_inst(asm.Push(spot, None))
            offset += 2

        assembly.add_inst(asm.Call(spots.MemorySpot(self.name), None))

        if offset > 0:
            assembly.add_inst(asm.Add(spots.LiteralSpot(offset), spots.RSP, 2))

        if not self.output.type.is_void():
            if return_register != output:
                assembly.add_inst(asm.Mov(return_register, output, self.output.type.size))


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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        value = spotmap[self.value]

        label = il.get_label()

        if value.has_address():
            if isinstance(value, spots.StackSpot) or isinstance(value, spots.BaseStackSpot):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        value = spotmap[self.value]

        labels = []

        if value.has_address():
            if isinstance(value, spots.StackSpot) or isinstance(value, spots.BaseStackSpot):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        label = il.get_label()
        is_signed = left.type.is_signed() or right.type.is_signed()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)

        for i in range(left.type.size):
            left.asm(assembly, "LDA", i)
            if i == 0:
                right.asm(assembly, "CMP", i)
            else:
                right.asm(assembly, "SBC", i)
        if not is_signed:
            assembly.add_inst("BCS", label)
        else:
            label2 = il.get_label()
            assembly.add_inst("BVC", label2)
            assembly.add_inst("EOR", "#&80")
            assembly.add_inst("BPL", label, label=label2)

        assembly.add_inst("LDA", "#01")
        output.asm(assembly, "STA", 0)
        assembly.add_inst(label=label)


class LessEqualCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output

    def inputs(self):
        return [self.left, self.right]

    def outputs(self):
        return [self.output]

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        label = il.get_label()
        is_signed = left.type.is_signed() or right.type.is_signed()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)

        assembly.add_inst("CLC")
        for i in range(left.type.size):
            left.asm(assembly, "LDA", i)
            right.asm(assembly, "SBC", i)
        if not is_signed:
            assembly.add_inst("BCS", label)
        else:
            label2 = il.get_label()
            assembly.add_inst("BVC", label2)
            assembly.add_inst("EOR", "#&80")
            assembly.add_inst("BPL", label, label=label2)

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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        label = il.get_label()
        is_signed = left.type.is_signed() or right.type.is_signed()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)

        assembly.add_inst("CLC")
        for i in range(left.type.size):
            left.asm(assembly, "LDA", i)
            right.asm(assembly, "SBC", i)
        if not is_signed:
            assembly.add_inst("BCC", label)
        else:
            label2 = il.get_label()
            assembly.add_inst("BVC", label2)
            assembly.add_inst("EOR", "#&80")
            assembly.add_inst("BMI", label, label=label2)

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

    def gen_asm(self, assembly: asm.ASM, spotmap, il, get_reg):
        left = spotmap[self.left]
        right = spotmap[self.right]
        output = spotmap[self.output]

        label = il.get_label()
        is_signed = left.type.is_signed() or right.type.is_signed()

        assembly.add_inst("LDA", "#00")
        for i in range(output.type.size):
            output.asm(assembly, "STA", i)

        for i in range(left.type.size):
            left.asm(assembly, "LDA", i)
            if i == 0:
                right.asm(assembly, "CMP", i)
            else:
                right.asm(assembly, "SBC", i)
        if not is_signed:
            assembly.add_inst("BCC", label)
        else:
            label2 = il.get_label()
            assembly.add_inst("BVC", label2)
            assembly.add_inst("EOR", "#&80")
            assembly.add_inst("BMI", label, label=label2)

        assembly.add_inst("LDA", "#01")
        output.asm(assembly, "STA", 0)
        assembly.add_inst(label=label)


class NodeGraph:
    def __init__(self, nodes=None):
        self._real_nodes = nodes or []
        self._all_nodes = self._real_nodes[:]
        self._conf = {n: [] for n in self._all_nodes}
        self._pref = {n: [] for n in self._all_nodes}

    def is_node(self, n):
        return n in self._conf and n in self._pref

    def add_dummy_node(self, v):
        self._all_nodes.append(v)
        self._conf[v] = []
        self._pref[v] = []

        # Dummy nodes must mutually conflict
        for n in self._all_nodes:
            if n not in self._real_nodes and n != v:
                self.add_conflict(n, v)

    def add_conflict(self, n1, n2):
        if n2 not in self._conf[n1]:
            self._conf[n1].append(n2)
        if n1 not in self._conf[n2]:
            self._conf[n2].append(n1)

    def add_pref(self, n1, n2):
        if n2 not in self._pref[n1]:
            self._pref[n1].append(n2)
        if n1 not in self._pref[n2]:
            self._pref[n2].append(n1)

    def pop(self, n):
        del self._conf[n]
        del self._pref[n]

        if n in self._real_nodes:
            self._real_nodes.remove(n)
        self._all_nodes.remove(n)

        for v in self._conf:
            if n in self._conf[v]:
                self._conf[v].remove(n)
        for v in self._pref:
            if n in self._pref[v]:
                self._pref[v].remove(n)
        return n

    def merge(self, n1, n2):
        # Merge conflict lists
        total_conf = self._conf[n1][:]
        for c in self._conf[n2]:
            if c not in total_conf:
                total_conf.append(c)

        self._conf[n1] = total_conf

        # Restore symmetric invariant
        for c in self._conf[n1]:
            if n2 in self._conf[c]:
                self._conf[c].remove(n2)
            if n1 not in self._conf[c]:
                self._conf[c].append(n1)

        # Merge preference lists
        total_pref = self._pref[n1][:]
        for p in self._pref[n2]:
            if p not in total_pref:
                total_pref.append(p)

        if n1 in total_pref: total_pref.remove(n1)
        if n2 in total_pref: total_pref.remove(n2)
        self._pref[n1] = total_pref

        # Restore symmetric invariant
        for c in self._pref[n1]:
            if n2 in self._pref[c]:
                self._pref[c].remove(n2)
            if n1 not in self._pref[c]:
                self._pref[c].append(n1)

        del self._conf[n2]
        del self._pref[n2]
        self._real_nodes.remove(n2)
        self._all_nodes.remove(n2)

    def remove_pref(self, n1, n2):
        self._pref[n1].remove(n2)
        self._pref[n2].remove(n1)

    def prefs(self, n):
        return self._pref[n]

    def confs(self, n):
        return self._conf[n]

    def nodes(self):
        return self._real_nodes

    def all_nodes(self):
        return self._all_nodes

    def copy(self):
        g = NodeGraph()

        g._real_nodes = self._real_nodes[:]
        g._all_nodes = self._all_nodes[:]
        for n in self._all_nodes:
            g._conf[n] = self._conf[n][:]
            g._pref[n] = self._pref[n][:]

        return g

    def __str__(self):  # pragma: no cover
        """Return this graph as a string for debugging purposes."""
        return ("Conf\n" +
                "\n".join(str((v, self._conf[v])) for v in self._all_nodes)
                + "\nPref\n" +
                "\n".join(str((v, self._pref[v])) for v in self._all_nodes))


class IL:
    def __init__(self, symbol_table, assembly: asm.ASM):
        self.commands = []
        self.functions = {}
        self.current_function = None
        self.literals = {}
        self.string_literals = {}
        self.label_count = 0
        self.symbol_table = symbol_table
        self.assembly = assembly
        self.func_stack_size = {}

    def register_literal_value(self, il_value: ILValue, value):
        self.literals[il_value] = value

    def register_literal_string(self, il_value: ILValue, value):
        self.string_literals[il_value] = value

    def is_string_literal(self, il_value: ILValue):
        return il_value in self.string_literals

    def get_label(self) -> str:
        label = "__bbcc_" + '%08x' % self.label_count
        self.label_count += 1
        return label

    def start_function(self, name):
        self.current_function = name
        self.functions[name] = []

    def end_function(self):
        self.current_function = None

    def add(self, command: ILInst):
        self.functions[self.current_function].append(command)

    def gen_asm(self):
        global_spotmap = self._get_global_spotmap()

        self._print_spotmap(global_spotmap)

        for func in self.functions:
            self.assembly.add_inst(asm.Comment("Function: {}".format(func)))
            self.assembly.add_inst(asm.Label(func))
            self._gen_asm(self.functions[func], global_spotmap)

    def _gen_asm(self, commands, global_spotmap):
        self._print_commands(commands)
        offset = 0
        free_values = self._get_free_values(commands, global_spotmap)

        move_to_mem = []
        for command in commands:
            refs = command.references().values()
            for line in refs:
                for v in line:
                    if v not in refs:
                        move_to_mem.append(v)

        for v in free_values:
            if v.stack_offset is not None:
                global_spotmap[v] = spots.MemorySpot(spots.RBP, v.stack_offset)
                free_values.remove(v)

        for v in free_values:
            if v.type.size not in {1, 2}:
                move_to_mem.append(v)

        for v in move_to_mem:
            if v in free_values:
                offset += v.type.size
                global_spotmap[v] = spots.MemorySpot(spots.RSP, offset)
                free_values.remove(v)

        live_vars = self._get_live_vars(commands, free_values)

        g_bak = self._generate_graph(commands, free_values, live_vars)

        spilled_nodes = []
        while True:
            g = g_bak.copy()

            # Remove all nodes that have been spilled for this iteration
            for n in spilled_nodes:
                g.pop(n)

            removed_nodes = []
            merged_nodes = {}

            # Repeat simplification, coalescing, and freeze until freeze
            # does not work.
            while True:
                # Repeat simplification and coalescing until nothing
                # happens.
                while True:
                    simplified = self._simplify_all(removed_nodes, g)
                    merged = self._coalesce_all(merged_nodes, g)

                    if not simplified and not merged: break

                if not self._freeze(g):
                    break

            # If no nodes remain, we are done
            if not g.nodes():
                break
            # If nodes do remain, spill one of them and retry
            else:
                # Spill node with highest number of conflicts. This node
                # will never be a merged node because we merge nodes
                # conservatively, so any recently merged node can be
                # simplified immediately.
                n = max(g.nodes(), key=lambda n: len(g.confs(n)))
                spilled_nodes.append(n)

        spotmap = self._generate_spotmap(removed_nodes, merged_nodes, g_bak)

        for v in spilled_nodes:
            offset += v.type.size
            global_spotmap[v] = spots.MemorySpot(spots.RSP, offset)

        for v in global_spotmap:
            spotmap[v] = global_spotmap[v]

        self._print_spotmap(spotmap)

        self._gen_func(commands, spotmap, live_vars)

    def _gen_func(self, commands, spotmap, live_vars):
        max_offset = max(spot.stack_offset() for spot in spotmap.values())

        self.assembly.add_inst(asm.Push(spots.RBP, None, 2))
        self.assembly.add_inst(asm.Mov(spots.RSP, spots.RBP, 2))

        used_regs = []
        for v in spotmap.values():
            if isinstance(v, spots.RegisterSpot):
                if v not in used_regs and v != return_register:
                    used_regs.append(v)

        for r in used_regs:
            self.assembly.add_inst(asm.Push(r, None, 2))
        if max_offset != 0:
            offset_spot = spots.LiteralSpot(max_offset)
            self.assembly.add_inst(asm.Sub(offset_spot, spots.RSP))

        for i, c in enumerate(commands):
            self.assembly.add_inst(asm.Comment(type(c).__name__))

            def get_reg(pref=None, conf=None):
                if not pref:
                    pref = []
                if not conf:
                    conf = []

                bad_vars = set(live_vars[i][0]) & set(live_vars[i][1])
                bad_spots = set(spotmap[var] for var in bad_vars)

                for v in c.outputs():
                    bad_spots.discard(spotmap[v])

                # Spot is bad if it is listed as a conflicting spot.
                bad_spots |= set(conf)

                for s in (pref + spots.registers):
                    if s not in bad_spots:
                        return s

                raise RuntimeError("get_reg can't find register")

            c.gen_asm(self.assembly, spotmap, self, get_reg)

    @staticmethod
    def _print_spotmap(spotmap: dict):
        print("* SPOTMAP *")
        for i, s in spotmap.items():
            print("{: <20} {}".format(str(i), str(s)))
        print("")

    @staticmethod
    def _print_commands(commands):
        print("* COMMANDS *")
        for c in commands:
            print("{: <20} {: <20} {}".format(str(c), str(c.inputs()), c.outputs()))
        print("")

    @staticmethod
    def _get_free_values(commands: list, global_spotmap: dict):
        free_values = []
        for command in commands:
            for value in command.inputs() + command.outputs() + command.scratch_spaces():
                if (value and value not in free_values
                        and value not in global_spotmap):
                    free_values.append(value)

        return free_values

    def _simplify_all(self, removed_nodes, g):
        # Get nodes without preference edges
        no_pref = [v for v in g.nodes() if not g.prefs(v)]

        # Repeat simplification until no more nodes can be removed
        did_something = False
        while True:
            rem = self._simplify_once(no_pref, g)
            if rem:
                removed_nodes.append(rem)
                no_pref.remove(rem)
                did_something = True
            else:
                break

        return did_something

    @staticmethod
    def _simplify_once(nodes, g):
        for v in nodes:
            # If the node has low conflict degree remove it from the graph
            if len(g.confs(v)) < len(spots.registers):
                return g.pop(v)

    def _coalesce_all(self, merged_nodes, g):
        did_something = False
        while True:
            merge = self._coalesce_once(g)
            if merge:
                if merge[0] not in merged_nodes:
                    merged_nodes[merge[0]] = []

                merged_nodes[merge[0]].append(merge[1])
                did_something = True
            else:
                break

        return did_something

    @staticmethod
    def _coalesce_once(g):
        for v1 in g.nodes():
            for v2 in g.prefs(v1):
                # If the two nodes conflict, automatically continue.
                if v1 in g.confs(v2):
                    continue

                total_confs = len(set(g.confs(v1)) | set(g.confs(v2)))

                # If one is a spot, use a special heuristic.
                # (described on section 6, page 311 of George & Appel)
                if isinstance(v1, spots.Spot):
                    v1, v2 = v2, v1
                if isinstance(v2, spots.Spot):
                    for T in g.confs(v1):
                        if v2 in g.confs(T):
                            continue
                        if len(g.confs(T)) < len(spots.registers):
                            continue
                        break
                    else:
                        # We can merge v1 into v2.
                        g.merge(v2, v1)
                        return v2, v1

                # Otherwise, apply regular merging rules.
                elif total_confs < len(spots.registers):
                    g.merge(v1, v2)
                    return v1, v2

    @staticmethod
    def _freeze(g):
        # Sort a list of nodes by conflict degree
        nodes = sorted(g.all_nodes(), key=lambda n: len(g.confs(n)))
        index_pairs = list(itertools.combinations(list(enumerate(nodes)), 2))

        # Sort pairs to prioritize nodes which appear earlier in `nodes`
        index_pairs.sort(key=lambda p: p[0][0] + p[1][0])

        # Extract just the node pairs
        pairs = [(p[0][1], p[1][1]) for p in index_pairs]

        # Now, the earlier pairs in `pairs` have lower conflict degree and
        # are thus superior candidates for freezing.
        for n1, n2 in pairs:
            if n1 in g.prefs(n2):
                g.remove_pref(n1, n2)
                return True

        return False

    @staticmethod
    def _generate_spotmap(removed_nodes, merged_nodes, g):
        """Pop values off stack to generate spot assignments."""

        # Get a set of nodes which interfere with n or anything merged into it
        def get_conflicts(n):
            conflicts = set(g.confs(n))
            for n1 in merged_nodes.get(n, []):
                conflicts |= get_conflicts(n1)
            return conflicts

        # Get a set of nodes which are merged into `n`
        def get_merged(n):
            merged = {n}
            for n1 in merged_nodes.get(n, []):
                merged |= get_merged(n1)
            return merged

        # Build up spotmap
        spotmap = {}
        i = 0
        while removed_nodes:
            i += 1

            # Allocate register to node `n`
            n1 = removed_nodes.pop()
            regs = spots.registers[::-1]

            # If n1 is a Spot (i.e. dummy node), immediately assign it a
            # register.
            if n1 in regs:
                reg = n1
            else:
                # Don't chose any conflicting spots
                for n2 in get_conflicts(n1):
                    # If n2 is a physical spot
                    if n2 in regs:
                        regs.remove(n2)
                    if n2 in spotmap and spotmap[n2] in regs:
                        regs.remove(spotmap[n2])

                # Based on algorithm, there should always be register remaining
                reg = regs.pop()

            # Assign this register to every node merged into n1
            for n2 in get_merged(n1):
                spotmap[n2] = reg

        return spotmap

    def _get_global_spotmap(self):
        spotmap = {}
        funcs = [n for n in self.functions.keys()]

        for i, v in self.literals.items():
            spotmap[i] = spots.LiteralSpot(v)

        for i, v in self.string_literals.items():
            label = self.get_label()
            self.assembly.add_inst(asm.Label(label))
            self.assembly.add_inst(asm.Bytes(v.encode()))
            spotmap[i] = spots.MemorySpot(label)

        for n, s in self.symbol_table.symbols.items():
            if s.storage == ast.DeclInfo.EXTERN:
                self.assembly.add_import(n)
            else:
                if s.storage != ast.DeclInfo.STATIC:
                    if s.type.is_function() and s.name not in funcs:
                        self.assembly.add_import(n)
                    else:
                        self.assembly.add_export(n)
                if not s.type.is_function():
                    v = s.il_value
                    label = s.name
                    spotmap[v] = spots.MemorySpot(label)
                    self.assembly.add_inst(asm.Label(label))
                    self.assembly.add_inst(asm.Bytes([0 for _ in range(v.type.size)]))

        return spotmap

    @staticmethod
    def _get_live_vars(commands, free_values):
        # Preprocess all commands to get a mapping from labels to command
        # number.
        labels = {c.label_name(): i for i, c in enumerate(commands)
                  if c.label_name()}

        # Last iteration of live variables
        prev_live_vars = None

        # This iteration of live variables
        live_vars = [([], []) for _ in range(len(commands))]

        while live_vars != prev_live_vars:
            prev_live_vars = live_vars[:]

            # List of currently live variables
            cur_live = []

            # Iterate through commands in backwards order
            for i, command in list(enumerate(commands))[::-1]:
                # If current command is a jump, add the live inputs of all
                # possible targets to the current live list.
                for label in command.targets():
                    i2 = labels[label]
                    for v in prev_live_vars[i2][0]:
                        if v not in cur_live:
                            cur_live.append(v)

                # Variables live on output from this command
                out_live = cur_live[:]

                # Add variables used in this command to current live variables
                for v in command.inputs():
                    if v in free_values and v not in cur_live:
                        cur_live.append(v)

                # Remove variables defined in this command to live variables
                for v in command.outputs():
                    if v in free_values:
                        if v in cur_live:
                            cur_live.remove(v)
                        else:
                            # If variable is defined in command but was not
                            # live, make it live on output from this command.

                            # TODO: Deal with this more efficiently.
                            # If the output is not live, then we don't actually
                            # need to perform this computation.
                            out_live.append(v)

                # Variables live on input from this command
                in_live = cur_live[:]

                live_vars[i] = (in_live, out_live)

        return live_vars

    @staticmethod
    def _generate_graph(commands, free_values, live_vars):
        g = NodeGraph(free_values)
        for i, command in enumerate(commands):
            # Variables active during input
            for n1, n2 in itertools.combinations(live_vars[i][0], 2):
                g.add_conflict(n1, n2)

            # Variables active during output
            for n1, n2 in itertools.combinations(live_vars[i][1], 2):
                g.add_conflict(n1, n2)

            # Relative conflict set of this command
            for n1 in command.rel_spot_conf():
                for n2 in command.rel_spot_conf()[n1]:
                    if n1 in free_values and n2 in free_values:
                        g.add_conflict(n1, n2)

            # Absolute conflict set of this command
            for n in command.abs_spot_conf():
                for s in command.abs_spot_conf()[n]:
                    if n in free_values:
                        if s not in g.all_nodes():
                            g.add_dummy_node(s)
                        g.add_conflict(n, s)

            # Clobber set of this command
            for s in command.clobber():
                if s not in g.all_nodes():
                    g.add_dummy_node(s)

                # Add a conflict with dummy node for every variable live
                # during both entry and exit from this command.
                for n in live_vars[i][0]:
                    if n in live_vars[i][1]:
                        g.add_conflict(n, s)

            # Form preferences based on rel_spot_pref
            for v1 in command.rel_spot_pref():
                for v2 in command.rel_spot_pref()[v1]:
                    if g.is_node(v1) and g.is_node(v2):
                        g.add_pref(v1, v2)

            # Form preferences based on abs_spot_pref
            for v in command.abs_spot_pref():
                for s in command.abs_spot_pref()[v]:
                    if v in free_values:
                        if s not in g.all_nodes():
                            g.add_dummy_node(s)
                        g.add_pref(v, s)
        return g
