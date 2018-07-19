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


class Call(ASTNode):
    def __init__(self, value):
        self.value = value


class Calln(ASTNode):
    def __init__(self, left, right):
        self.left = left
        self.right = right


class Push(ASTNode):
    def __init__(self, value):
        self.value = value


class Pop(ASTNode):
    def __init__(self, value):
        self.value = value


class Mov(ASTNode):
    def __init__(self, left, right):
        self.left = left
        self.right = right


class Add(ASTNode):
    def __init__(self, left, right):
        self.left = left
        self.right = right


class Ret(ASTNode):
    def __init__(self):
        pass


class Exit(ASTNode):
    def __init__(self):
        pass
