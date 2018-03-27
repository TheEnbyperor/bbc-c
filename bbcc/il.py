from . import asm
from . import spots

pseudo_registers = [asm.ASM.preg1, asm.ASM.preg2, asm.ASM.preg3, asm.ASM.preg4, asm.ASM.preg5,
                    asm.ASM.preg6, asm.ASM.preg7, asm.ASM.preg8, asm.ASM.preg9, asm.ASM.preg10,
                    asm.ASM.preg11, asm.ASM.preg12, asm.ASM.preg13, asm.ASM.preg14, asm.ASM.preg15]
return_register = asm.ASM.preg1
stack_register = spots.Pseudo16RegisterSpot(asm.ASM.cstck, 'int')


class ILValue:
    def __init__(self, value_type):
        self.type = value_type
        self.stack_offset = None

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
        assembly.add_inst("SEC")
        stack_register.asm(assembly, "LDA", 0)
        assembly.add_inst("SBC", "#2")
        stack_register.asm(assembly, "STA", 0)
        assembly.add_inst("BCS", "_bbcc_pushax_1")
        stack_register.asm(assembly, "DEC", 1)
        assembly.add_inst("LDY", "#0",  label="_bbcc_pushax_1")
        assembly.add_inst("PLA")
        stack_register.asm(assembly, "STA", 0, "({}),Y")
        assembly.add_inst("RTS")

        assembly.add_inst("LDY", "#0", label="_bbcc_pulla")
        stack_register.asm(assembly, "LDA", 0, "({}),Y")
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
            value.asm(assembly,"LDA", 0)
            output.asm(assembly, "STA", 0)
            value.asm(assembly, "LDA", 1)
            output.asm(assembly, "STA", 1)


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

        value.asm(assembly, "LDA", 0)
        assembly.add_inst("BNE", label)
        value.asm(assembly, "LDA", 1)
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

        value.asm(assembly, "LDA", 0)
        assembly.add_inst("BNE", self.label)
        value.asm(assembly, "LDA", 1)
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
            value.asm(assembly, "LDA", 1)
            ret_reg.asm(assembly, "STA", 1)
            value.asm(assembly, "LDA", 0)
            ret_reg.asm(assembly, "STA", 0)

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
            a.asm(assembly, "LDA", 1)
            assembly.add_inst("JSR", "_bbc_pusha")
            a.asm(assembly, "LDA", 0)
            assembly.add_inst("JSR", "_bbc_pusha")
            offset += 2
        assembly.add_inst("SEC")
        stack_register.asm(assembly, "LDA", 0)
        assembly.add_inst("SBC", "#&{}".format(assembly.to_hex(offset, 4)[2:4]))
        stack_register.asm(assembly, "STA", 0)
        stack_register.asm(assembly, "LDA", 1)
        assembly.add_inst("SBC", "#&{}".format(assembly.to_hex(offset, 4)[0:2]))
        stack_register.asm(assembly, "STA", 1)

        assembly.add_inst("JSR", "__{}".format(self.name))

        assembly.add_inst("CLC")
        stack_register.asm(assembly, "LDA", 0)
        assembly.add_inst("ADC", "#&{}".format(assembly.to_hex(offset, 4)[2:4]))
        stack_register.asm(assembly, "STA", 0)
        stack_register.asm(assembly, "LDA", 1)
        assembly.add_inst("ADC", "#&{}".format(assembly.to_hex(offset, 4)[0:2]))
        stack_register.asm(assembly, "STA", 1)

        if output != ret_reg:
            ret_reg.asm(assembly, "LDA", 1)
            output.asm(assembly, "STA", 1)
            ret_reg.asm(assembly, "LDA", 0)
            output.asm(assembly, "STA", 0)


class FunctionPrologue(ILInst):
    def __init__(self, params):
        self.params = params

    def inputs(self):
        return [v.il_value for v in self.params]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        for r in pseudo_registers[::-1]:
            reg = spots.Pseudo16RegisterSpot(r, '')
            reg.asm(assembly, "LDA", 0)
            assembly.add_inst("PHA")
            reg.asm(assembly, "LDA", 1)
            assembly.add_inst("PHA")


class FunctionEpilogue(ILInst):
    def __init__(self):
        pass

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        for r in pseudo_registers:
            reg = spots.Pseudo16RegisterSpot(r, '')
            assembly.add_inst("PLA")
            reg.asm(assembly, "STA", 1)
            assembly.add_inst("PLA")
            reg.asm(assembly, "STA", 0)


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
        left.asm(assembly, "LDA", 1)
        right.asm(assembly, "ADC", 1)
        output.asm(assembly, "STA", 1)
        left.asm(assembly, "LDA", 0)
        right.asm(assembly, "ADC", 0)
        output.asm(assembly, "STA", 0)


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
        left.asm(assembly, "LDA", 1)
        right.asm(assembly, "SBC", 1)
        output.asm(assembly, "STA", 1)
        left.asm(assembly, "LDA", 0)
        right.asm(assembly, "SBC", 0)
        output.asm(assembly, "STA", 0)


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
            left.asm(assembly, "LDA", 0)
            scratch1.asm(assembly, "STA", 0)
            left.asm(assembly, "LDA", 1)
            scratch1.asm(assembly, "STA", 1)
            left = scratch1

        if not right.has_address():
            scratch2 = spotmap[self.scratch2]
            right.asm(assembly, "LDA", 0)
            scratch2.asm(assembly, "STA", 0)
            right.asm(assembly, "LDA", 1)
            scratch2.asm(assembly, "STA", 1)
            right = scratch2

        label1 = il.get_label()
        label2 = il.get_label()

        assembly.add_inst("LDA", "#0")
        output.asm(assembly, "STA", 0)
        output.asm(assembly, "STA", 1)
        assembly.add_inst("LDX", "#16")
        assembly.add_inst(label=label1)
        right.asm(assembly, "LSR", 0)
        right.asm(assembly, "ROR", 1)
        assembly.add_inst("BCC", label2)
        assembly.add_inst("CLC")
        left.asm(assembly, "ASL", 1)
        left.asm(assembly, "ROL", 0)
        left.asm(assembly, "LDA", 1)
        output.asm(assembly, "ADC", 1)
        output.asm(assembly, "STA", 1)
        left.asm(assembly, "LDA", 0)
        output.asm(assembly, "ADC", 0)
        output.asm(assembly, "STA", 0)
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
            left.asm(assembly, "LDA", 0)
            scratch1.asm(assembly, "STA", 0)
            left.asm(assembly, "LDA", 1)
            scratch1.asm(assembly, "STA", 1)
            left = scratch1

        if not right.has_address():
            scratch2 = spotmap[self.scratch2]
            right.asm(assembly, "LDA", 0)
            scratch2.asm(assembly, "STA", 0)
            right.asm(assembly, "LDA", 1)
            scratch2.asm(assembly, "STA", 1)
            right = scratch2

        label1 = il.get_label()
        label2 = il.get_label()

        assembly.add_inst("LDA", "#0")
        scratch3.asm(assembly, "STA", 0)
        scratch3.asm(assembly, "STA", 1)
        assembly.add_inst("LDX", "#16")
        assembly.add_inst(label=label1)
        left.asm(assembly, "ASL", 1)
        left.asm(assembly, "ROL", 0)
        scratch3.asm(assembly, "ROL", 1)
        scratch3.asm(assembly, "ROL", 0)
        assembly.add_inst("SEC")
        scratch3.asm(assembly, "LDA", 1)
        right.asm(assembly, "SBC", 1)
        assembly.add_inst("PHA")
        scratch3.asm(assembly, "LDA", 0)
        right.asm(assembly, "SBC", 0)
        assembly.add_inst("BCC", label2)
        scratch3.asm(assembly, "STA", 0)
        assembly.add_inst("PLA")
        scratch3.asm(assembly, "STA", 1)
        left.asm(assembly, "INC", 1)
        assembly.add_inst("DEX", label=label2)
        assembly.add_inst("BNE", label1)

        if left != output:
            left.asm(assembly, "LDA", 0)
            output.asm(assembly, "STA", 0)
            left.asm(assembly, "LDA", 1)
            output.asm(assembly, "STA", 1)


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
            left.asm(assembly, "LDA", 0)
            scratch1.asm(assembly, "STA", 0)
            left.asm(assembly, "LDA", 1)
            scratch1.asm(assembly, "STA", 1)
            left = scratch1

        if not right.has_address():
            scratch2 = spotmap[self.scratch2]
            right.asm(assembly, "LDA", 0)
            scratch2.asm(assembly, "STA", 0)
            right.asm(assembly, "LDA", 1)
            scratch2.asm(assembly, "STA", 1)
            right = scratch2

        label1 = il.get_label()
        label2 = il.get_label()

        assembly.add_inst("LDA", "#0")
        output.asm(assembly, "STA", 0)
        output.asm(assembly, "STA", 1)
        assembly.add_inst("LDX", "#16")
        assembly.add_inst(label=label1)
        left.asm(assembly, "ASL", 1)
        left.asm(assembly, "ROL", 0)
        output.asm(assembly, "ROL", 1)
        output.asm(assembly, "ROL", 0)
        assembly.add_inst("SEC")
        output.asm(assembly, "LDA", 1)
        right.asm(assembly, "SBC", 1)
        assembly.add_inst("PHA")
        output.asm(assembly, "LDA", 0)
        right.asm(assembly, "SBC", 0)
        assembly.add_inst("BCC", label2)
        output.asm(assembly, "STA", 0)
        assembly.add_inst("PLA")
        output.asm(assembly, "STA", 1)
        left.asm(assembly, "INC", 1)
        assembly.add_inst("DEX", label=label2)
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
            value.asm(assembly, "INC", 1)
            assembly.add_inst("BNE", label)
            value.asm(assembly, "INC", 0)
            assembly.add_inst(label=label)


class Dec(ILInst):
    def __init__(self, value: ILValue):
        self.value = value

    def inputs(self):
        return [self.value]

    def gen_asm(self, assembly: asm.ASM, spotmap, il):
        value = spotmap[self.value]

        label = il.get_label()

        if value.has_address():
            value.asm(assembly, "LDA", 1)
            assembly.add_inst("BNE", label)
            value.asm(assembly, "DEC", 0)
            assembly.add_inst(label=label)
            value.asm(assembly, "DEC", 1)


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

        left.asm(assembly, "LDA", 0)
        right.asm(assembly, "CMP", 0)
        assembly.add_inst("BNE", label)
        left.asm(assembly, "LDA", 1)
        right.asm(assembly, "CMP", 1)
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

        left.asm(assembly, "LDA", 0)
        right.asm(assembly, "CMP", 0)
        assembly.add_inst("BEQ", label)
        left.asm(assembly, "LDA", 1)
        right.asm(assembly, "CMP", 1)
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

        left.asm(assembly, "LDA", 0)
        right.asm(assembly, "CMP", 0)
        assembly.add_inst("BCC", self.label)
        assembly.add_inst("BNE", label)
        left.asm(assembly, "LDA", 1)
        right.asm(assembly, "CMP", 1)
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

        left.asm(assembly, "LDA", 0)
        right.asm(assembly, "CMP", 0)
        assembly.add_inst("BCC", self.label)
        assembly.add_inst("BNE", label)
        left.asm(assembly, "LDA", 1)
        right.asm(assembly, "CMP", 1)
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

        left.asm(assembly, "LDA", 0)
        right.asm(assembly, "CMP", 0)
        assembly.add_inst("BCC", label)
        assembly.add_inst("BNE", self.label)
        left.asm(assembly, "LDA", 1)
        right.asm(assembly, "CMP", 1)
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

        left.asm(assembly, "LDA", 0)
        right.asm(assembly, "CMP", 0)
        assembly.add_inst("BCC", label)
        assembly.add_inst("BNE", self.label)
        left.asm(assembly, "LDA", 1)
        right.asm(assembly, "CMP", 1)
        assembly.add_inst("BCS", self.label)
        assembly.add_inst(label=label)


class IL:
    def __init__(self):
        self.commands = []
        self.literals = {}
        self.string_literals = {}
        self.label_count = 0
        self.spotmap = {}

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
        self._print_commands()

        spotmap = {}

        for i, v in self.literals.items():
            spotmap[i] = spots.LiteralSpot(v, i.type)

        for i, c in enumerate(self.commands):
            for v in (c.inputs() + c.outputs() + c.scratch_spaces())[::-1]:
                if v not in spotmap:
                    print(v.stack_offset)
                    if v.stack_offset is None:
                        reg = self._find_register(spotmap, i, v)
                        if reg is None:
                            raise RuntimeError("Failed to find register if ILValue {}".format(v))
                        spotmap[v] = spots.Pseudo16RegisterSpot(reg, v.type)
                    else:
                        spotmap[v] = spots.StackSpot(v.stack_offset, v.type)

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

    def _find_register(self, spotmap, command_i: int, il_value: ILValue):
        for r in pseudo_registers:
            possible = True
            for c in self.commands[command_i+1:]:
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
