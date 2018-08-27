class ASTNode:
    pass


class RegisterValue(ASTNode):
    def __init__(self, reg_num):
        self.reg_num = reg_num


class LiteralValue(ASTNode):
    def __init__(self, val):
        self.val = val


class MemoryValue(ASTNode):
    def __init__(self, const_loc, reg_indirect, length):
        self.const_loc = const_loc
        self.reg_indirect = reg_indirect
        self.length = length


class LabelValue(ASTNode):
    def __init__(self, label):
        self.label = label


class TranslationUnit(ASTNode):
    def __init__(self, items):
        self.items = items


class Label(ASTNode):
    def __init__(self, label):
        self.label = label


class ExportCommand(ASTNode):
    def __init__(self, label):
        self.label = label


class ImportCommand(ASTNode):
    def __init__(self, label):
        self.label = label


class Bytes(ASTNode):
    def __init__(self, bytes):
        self.bytes = bytes


class _ZeroValueNode(ASTNode):
    num_values = 0

    def __init__(self):
        pass


class _OneValueNode(ASTNode):
    num_values = 1

    def __init__(self, value):
        self.value = value


class _TwoValueNode(ASTNode):
    num_values = 2

    def __init__(self, left, right):
        self.left = left
        self.right = right


class Call(_OneValueNode):
    pass


class Jmp(_OneValueNode):
    pass


class Jze(_OneValueNode):
    pass


class Jnz(_OneValueNode):
    pass


class Jl(_OneValueNode):
    pass


class Jle(_OneValueNode):
    pass


class Jg(_OneValueNode):
    pass


class Jge(_OneValueNode):
    pass


class Ja(_OneValueNode):
    pass


class Jae(_OneValueNode):
    pass


class Jb(_OneValueNode):
    pass


class Jbe(_OneValueNode):
    pass


class Sze(_OneValueNode):
    pass


class Snz(_OneValueNode):
    pass


class Sl(_OneValueNode):
    pass


class Sle(_OneValueNode):
    pass


class Sg(_OneValueNode):
    pass


class Sge(_OneValueNode):
    pass


class Sa(_OneValueNode):
    pass


class Sae(_OneValueNode):
    pass


class Sb(_OneValueNode):
    pass


class Sbe(_OneValueNode):
    pass


class Calln(_TwoValueNode):
    pass


class Push(_OneValueNode):
    pass


class Pop(_OneValueNode):
    pass


class Inc(_OneValueNode):
    pass


class Dec(_OneValueNode):
    pass


class Neg(_OneValueNode):
    pass


class Mov(_TwoValueNode):
    pass


class Lea(_TwoValueNode):
    pass


class Cmp(_TwoValueNode):
    pass


class Add(_TwoValueNode):
    pass


class Sub(_TwoValueNode):
    pass


class Mul(_TwoValueNode):
    pass


class Div(_TwoValueNode):
    pass


class Mod(_TwoValueNode):
    pass


class And(_TwoValueNode):
    pass


class Or(_TwoValueNode):
    pass


class Ret(_ZeroValueNode):
    pass


class Exit(_ZeroValueNode):
    pass
