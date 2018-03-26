from . import asm
from . import spots

pseudo_registers = [asm.ASM.preg1, asm.ASM.preg2, asm.ASM.preg3, asm.ASM.preg4, asm.ASM.preg5,
                    asm.ASM.preg6, asm.ASM.preg7, asm.ASM.preg8, asm.ASM.preg9, asm.ASM.preg10,
                    asm.ASM.preg11, asm.ASM.preg12, asm.ASM.preg13, asm.ASM.preg14, asm.ASM.preg15,
                    asm.ASM.preg16, asm.ASM.preg17, asm.ASM.preg18]
return_register = asm.ASM.preg1


class ILValue:
    def __init__(self, value_type):
        self.type = value_type


class ILInst:
    def inputs(self):
        return []

    def outputs(self):
        return []

    def scratch_spaces(self):
        return []

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        raise NotImplementedError


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
            assembly.add_inst("LDA", value.asm_str(0))
            assembly.add_inst("STA", output.asm_str(0))
            assembly.add_inst("LDA", value.asm_str(1))
            assembly.add_inst("STA", output.asm_str(1))


class Label(ILInst):
    def __init__(self, label: str):
        self.label = label

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        assembly.add_inst(label=self.label)


class Jmp(ILInst):
    def __init__(self, label: str):
        self.label = label

    def gen_asm(self, assembly: asm.ASM, mpotmap, il):
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

        assembly.add_inst("LDA", value.asm_str(0))
        assembly.add_inst("BNE", label)
        assembly.add_inst("LDA", value.asm_str(1))
        assembly.add_inst("BEQ", self.label)
        assembly.add_inst(label=label)


class JmpNotZero(ILInst):
    def __init__(self, value: ILValue, label: str):
        self.value = value
        self.label = label

    def inputs(self):
        return [self.value]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        value = spotmap[self.value]

        assembly.add_inst("LDA", value.asm_str(0))
        assembly.add_inst("BNE", self.label)
        assembly.add_inst("LDA", value.asm_str(1))
        assembly.add_inst("BNE", self.label)


class Return(ILInst):
    def __init__(self, value):
        self.value = value

    def inputs(self):
        return [self.value]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        value = spotmap[self.value]
        ret_reg = spots.Pseudo16RegisterSpot(return_register, value.type)

        if value != ret_reg:
            assembly.add_inst("LDA", value.asm_str(1))
            assembly.add_inst("STA", ret_reg.asm_str(1))
            assembly.add_inst("LDA", value.asm_str(0))
            assembly.add_inst("STA", ret_reg.asm_str(0))

        assembly.add_inst("RTS")


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
        assembly.add_inst("LDA", left.asm_str(1))
        assembly.add_inst("ADC", right.asm_str(1))
        assembly.add_inst("STA", output.asm_str(1))
        assembly.add_inst("LDA", left.asm_str(0))
        assembly.add_inst("ADC", right.asm_str(0))
        assembly.add_inst("STA", output.asm_str(0))


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
        assembly.add_inst("LDA", left.asm_str(1))
        assembly.add_inst("SBC", right.asm_str(1))
        assembly.add_inst("STA", output.asm_str(1))
        assembly.add_inst("LDA", left.asm_str(0))
        assembly.add_inst("SBC", right.asm_str(0))
        assembly.add_inst("STA", output.asm_str(0))


class Mult(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output
        self.scratch1 = ILValue('int')
        self.scratch2 = ILValue('int')

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

        if not left.has_address():
            scratch1 = spotmap[self.scratch1]
            assembly.add_inst("LDA", left.asm_str(0))
            assembly.add_inst("STA", scratch1.asm_str(0))
            assembly.add_inst("LDA", left.asm_str(1))
            assembly.add_inst("STA", scratch1.asm_str(1))
            left = scratch1

        if not right.has_address():
            scratch2 = spotmap[self.scratch2]
            assembly.add_inst("LDA", right.asm_str(0))
            assembly.add_inst("STA", scratch2.asm_str(0))
            assembly.add_inst("LDA", right.asm_str(1))
            assembly.add_inst("STA", scratch2.asm_str(1))
            right = scratch2

        label1 = il.get_label()
        label2 = il.get_label()

        assembly.add_inst("LDA", "#0")
        assembly.add_inst("STA", output.asm_str(0))
        assembly.add_inst("STA", output.asm_str(1))
        assembly.add_inst("LDX", "#16")
        assembly.add_inst("LSR", right.asm_str(0), label1)
        assembly.add_inst("ROR", right.asm_str(1))
        assembly.add_inst("BCC", label2)
        assembly.add_inst("CLC")
        assembly.add_inst("ASL", left.asm_str(1))
        assembly.add_inst("ROL", left.asm_str(0))
        assembly.add_inst("LDA", left.asm_str(1))
        assembly.add_inst("ADC", output.asm_str(1))
        assembly.add_inst("STA", output.asm_str(1))
        assembly.add_inst("LDA", left.asm_str(0))
        assembly.add_inst("ADC", output.asm_str(0))
        assembly.add_inst("STA", output.asm_str(0))
        assembly.add_inst("DEX", label=label2)
        assembly.add_inst("BNE", label1)


class Div(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output
        self.scratch1 = ILValue('int')
        self.scratch2 = ILValue('int')
        self.scratch3 = ILValue('int')

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

        if not left.has_address():
            scratch1 = spotmap[self.scratch1]
            assembly.add_inst("LDA", left.asm_str(0))
            assembly.add_inst("STA", scratch1.asm_str(0))
            assembly.add_inst("LDA", left.asm_str(1))
            assembly.add_inst("STA", scratch1.asm_str(1))
            left = scratch1

        if not right.has_address():
            scratch2 = spotmap[self.scratch2]
            assembly.add_inst("LDA", right.asm_str(0))
            assembly.add_inst("STA", scratch2.asm_str(0))
            assembly.add_inst("LDA", right.asm_str(1))
            assembly.add_inst("STA", scratch2.asm_str(1))
            right = scratch2

        label1 = il.get_label()
        label2 = il.get_label()

        assembly.add_inst("LDA", "#0")
        assembly.add_inst("STA", scratch3.asm_str(0))
        assembly.add_inst("STA", scratch3.asm_str(1))
        assembly.add_inst("LDX", "#16")
        assembly.add_inst("ASL", left.asm_str(1), label1)
        assembly.add_inst("ROL", left.asm_str(0))
        assembly.add_inst("ROL", scratch3.asm_str(1))
        assembly.add_inst("ROL", scratch3.asm_str(0))
        assembly.add_inst("SEC")
        assembly.add_inst("LDA", scratch3.asm_str(1))
        assembly.add_inst("SBC", right.asm_str(1))
        assembly.add_inst("TAY")
        assembly.add_inst("LDA", scratch3.asm_str(0))
        assembly.add_inst("SBC", right.asm_str(0))
        assembly.add_inst("BCC", label2)
        assembly.add_inst("STA", scratch3.asm_str(0))
        assembly.add_inst("STY", scratch3.asm_str(1))
        assembly.add_inst("INC", left.asm_str(1))
        assembly.add_inst("DEX", label=label2)
        assembly.add_inst("BNE", label1)
        assembly.add_inst("LDA", left.asm_str(0))
        assembly.add_inst("STA", output.asm_str(0))
        assembly.add_inst("LDA", left.asm_str(1))
        assembly.add_inst("STA", output.asm_str(1))


class Mod(ILInst):
    def __init__(self, left: ILValue, right: ILValue, output: ILValue):
        self.left = left
        self.right = right
        self.output = output
        self.scratch1 = ILValue('int')
        self.scratch2 = ILValue('int')

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

        if not left.has_address():
            scratch1 = spotmap[self.scratch1]
            assembly.add_inst("LDA", left.asm_str(0))
            assembly.add_inst("STA", scratch1.asm_str(0))
            assembly.add_inst("LDA", left.asm_str(1))
            assembly.add_inst("STA", scratch1.asm_str(1))
            left = scratch1

        if not right.has_address():
            scratch2 = spotmap[self.scratch2]
            assembly.add_inst("LDA", right.asm_str(0))
            assembly.add_inst("STA", scratch2.asm_str(0))
            assembly.add_inst("LDA", right.asm_str(1))
            assembly.add_inst("STA", scratch2.asm_str(1))
            right = scratch2

        label1 = il.get_label()
        label2 = il.get_label()

        assembly.add_inst("LDA", "#0")
        assembly.add_inst("STA", output.asm_str(0))
        assembly.add_inst("STA", output.asm_str(1))
        assembly.add_inst("LDX", "#16")
        assembly.add_inst("ASL", left.asm_str(1), label1)
        assembly.add_inst("ROL", left.asm_str(0))
        assembly.add_inst("ROL", output.asm_str(1))
        assembly.add_inst("ROL", output.asm_str(0))
        assembly.add_inst("SEC")
        assembly.add_inst("LDA", output.asm_str(1))
        assembly.add_inst("SBC", right.asm_str(1))
        assembly.add_inst("TAY")
        assembly.add_inst("LDA", output.asm_str(0))
        assembly.add_inst("SBC", right.asm_str(0))
        assembly.add_inst("BCC", label2)
        assembly.add_inst("STA", output.asm_str(0))
        assembly.add_inst("STY", output.asm_str(1))
        assembly.add_inst("INC", left.asm_str(1))
        assembly.add_inst("DEX", label=label2)
        assembly.add_inst("BNE", label1)


class Inc(ILInst):
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

        assembly.add_inst("LDA", value.asm_str(0))
        assembly.add_inst("STA", output.asm_str(0))
        assembly.add_inst("LDA", value.asm_str(1))
        assembly.add_inst("STA", output.asm_str(1))

        label = il.get_label()

        assembly.add_inst("INC", output.asm_str(1))
        assembly.add_inst("BNE", label)
        assembly.add_inst("INC", output.asm_str(0))
        assembly.add_inst(label=label)


class Dec(ILInst):
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

        assembly.add_inst("LDA", value.asm_str(0))
        assembly.add_inst("STA", output.asm_str(0))
        assembly.add_inst("LDA", value.asm_str(1))
        assembly.add_inst("STA", output.asm_str(1))

        label = il.get_label()

        assembly.add_inst("LDA", output.asm_str(1))
        assembly.add_inst("BNE", label)
        assembly.add_inst("DEC", output.asm_str(0))
        assembly.add_inst("DEC", output.asm_str(1), label=label)


# Comparison
class EqualCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, label: str):
        self.left = left
        self.right = right
        self.label = label

    def inputs(self):
        return [self.left, self.right]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]

        label = il.get_label()

        assembly.add_inst("LDA", left.asm_str(0))
        assembly.add_inst("CMP", right.asm_str(0))
        assembly.add_inst("BNE", label)
        assembly.add_inst("LDA", left.asm_str(1))
        assembly.add_inst("CMP", right.asm_str(1))
        assembly.add_inst("BEQ", self.label)
        assembly.add_inst(label=label)


class NotEqualCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, label: str):
        self.left = left
        self.right = right
        self.label = label

    def inputs(self):
        return [self.left, self.right]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]

        label = il.get_label()

        assembly.add_inst("LDA", left.asm_str(0))
        assembly.add_inst("CMP", right.asm_str(0))
        assembly.add_inst("BEQ", label)
        assembly.add_inst("LDA", left.asm_str(1))
        assembly.add_inst("CMP", right.asm_str(1))
        assembly.add_inst("BNE", self.label)
        assembly.add_inst(label=label)


class LessThanCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, label: str):
        self.left = left
        self.right = right
        self.label = label

    def inputs(self):
        return [self.left, self.right]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]

        label = il.get_label()

        assembly.add_inst("LDA", left.asm_str(0))
        assembly.add_inst("CMP", right.asm_str(0))
        assembly.add_inst("BCC", self.label)
        assembly.add_inst("BNE", label)
        assembly.add_inst("LDA", left.asm_str(1))
        assembly.add_inst("CMP", right.asm_str(1))
        assembly.add_inst("BCC", self.label)
        assembly.add_inst(label=label)


class LessEqualCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, label: str):
        self.left = left
        self.right = right
        self.label = label

    def inputs(self):
        return [self.left, self.right]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]

        label = il.get_label()

        assembly.add_inst("LDA", left.asm_str(0))
        assembly.add_inst("CMP", right.asm_str(0))
        assembly.add_inst("BCC", self.label)
        assembly.add_inst("BNE", label)
        assembly.add_inst("LDA", left.asm_str(1))
        assembly.add_inst("CMP", right.asm_str(1))
        assembly.add_inst("BCC", self.label)
        assembly.add_inst("BEQ", self.label)
        assembly.add_inst(label=label)


class MoreThanCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, label: str):
        self.left = left
        self.right = right
        self.label = label

    def inputs(self):
        return [self.left, self.right]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]

        label = il.get_label()

        assembly.add_inst("LDA", left.asm_str(0))
        assembly.add_inst("CMP", right.asm_str(0))
        assembly.add_inst("BCC", label)
        assembly.add_inst("BNE", self.label)
        assembly.add_inst("LDA", left.asm_str(1))
        assembly.add_inst("CMP", right.asm_str(1))
        assembly.add_inst("BEQ", label)
        assembly.add_inst("BCS", self.label)
        assembly.add_inst(label=label)


class MoreEqualCmp(ILInst):
    def __init__(self, left: ILValue, right: ILValue, label: str):
        self.left = left
        self.right = right
        self.label = label

    def inputs(self):
        return [self.left, self.right]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        left = spotmap[self.left]
        right = spotmap[self.right]

        label = il.get_label()

        assembly.add_inst("LDA", left.asm_str(0))
        assembly.add_inst("CMP", right.asm_str(0))
        assembly.add_inst("BCC", label)
        assembly.add_inst("BNE", self.label)
        assembly.add_inst("LDA", left.asm_str(1))
        assembly.add_inst("CMP", right.asm_str(1))
        assembly.add_inst("BCS", self.label)
        assembly.add_inst(label=label)


class IL:
    def __init__(self):
        self.commands = []
        self.literals = {}
        self.string_literals = {}
        self.label_count = 0

    def register_literal_value(self, il_value: ILValue, value):
        self.literals[il_value] = value

    def register_literal_string(self, il_value: ILValue, value):
        self.string_literals[il_value] = value

    def get_label(self) -> str:
        label = "bbcc_" + '%08x' % self.label_count
        self.label_count += 1
        return label

    def add(self, command: ILInst):
        self.commands.append(command)

    def gen_asm(self, assembly: asm.ASM):
        spotmap = {}

        for i, v in self.literals.items():
            spotmap[i] = spots.LiteralSpot(v, i.type)

        for i, c in enumerate(self.commands):
            for v in (c.outputs() + c.scratch_spaces())[::-1]:
                if v not in spotmap:
                    reg = self._find_register(spotmap, i, v)
                    if reg is None:
                        raise RuntimeError("Failed to find register if ILValue {}".format(v))
                    spotmap[v] = spots.Pseudo16RegisterSpot(reg, v.type)

        for c in self.commands:
            assembly.add_comment(str(type(c).__name__))
            c.gen_asm(assembly, spotmap, self)
            
    def _find_register(self, spotmap,  command_i: int, il_value: ILValue):
        for r in pseudo_registers:
            possible = True
            for c in self.commands[command_i+1:]:
                if il_value in c.outputs():
                    if il_value in spotmap:
                        if isinstance(spotmap[il_value], spots.Pseudo16RegisterSpot):
                            if spotmap[il_value].loc == r:
                                break
                if il_value in c.inputs():
                    if il_value in spotmap:
                        if isinstance(spotmap[il_value], spots.Pseudo16RegisterSpot):
                            if spotmap[il_value].loc == r:
                                possible = False
                                break
            if possible:
                c = self.commands[command_i]
                for il_value in c.outputs():
                    if il_value in spotmap:
                        if isinstance(spotmap[il_value], spots.Pseudo16RegisterSpot):
                            if spotmap[il_value].loc == r:
                                possible = False
                                break
                for il_value in c.scratch_spaces():
                    if il_value in spotmap:
                        if isinstance(spotmap[il_value], spots.Pseudo16RegisterSpot):
                            if spotmap[il_value].loc == r:
                                possible = False
                                break
                if possible:
                    return r
