class ASTNode:
    pass


class TranslationUnit(ASTNode):
    def __init__(self, items):
        self.items = items


class Label(ASTNode):
    def __init__(self, label):
        self.label = label


class ExportCommand(ASTNode):
    def __init__(self, label):
        self.label = label


class RegisterValue(ASTNode):
    def __init__(self, reg_num):
        self.reg_num = reg_num


class LiteralValue(ASTNode):
    def __init__(self, val):
        self.val = val


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


class Ret(ASTNode):
    def __init__(self):
        pass
