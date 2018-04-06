import copy
from . import tokens


class CType:
    def __init__(self, size, const=False):
        self.size = size
        self.const = const

    def is_complete(self):
        return False

    def is_object(self):
        return False

    def is_arith(self):
        return False

    def is_pointer(self):
        return False

    def is_void(self):
        return False

    def is_array(self):
        return False

    def is_scalar(self):
        return self.is_arith() or self.is_pointer()

    def is_const(self):
        return self.const

    def make_unsigned(self):
        raise NotImplementedError

    def make_const(self):
        const_self = copy.copy(self)
        const_self.const = True
        return const_self


class IntegerCType(CType):
    def __init__(self, size, signed):
        self.signed = signed
        super().__init__(size)

    def is_complete(self):
        return True

    def is_object(self):
        return True

    def is_arith(self):
        return True

    def make_unsigned(self):
        unsign_self = copy.copy(self)
        unsign_self.signed = False
        return unsign_self


class VoidCType(CType):
    def __init__(self):
        super().__init__(1)

    def is_complete(self):
        return False

    def is_void(self):
        return True


class PointerCType(CType):
    def __init__(self, arg, const=False):
        self.arg = arg
        super().__init__(8, const)

    def is_complete(self):
        return True

    def is_object(self):
        return True

    def is_pointer(self):
        return True


class ArrayCType(CType):
    def __init__(self, el, n):
        self.el = el
        self.n = n
        super().__init__(n * self.el.size)

    def is_complete(self):
        return self.n is not None

    def is_object(self):
        return True

    def is_array(self):
        return True


void = VoidCType()

bool_t = IntegerCType(1, False)

char = IntegerCType(1, True)
unsig_char = IntegerCType(1, False)

integer = IntegerCType(2, True)
unsig_int = IntegerCType(2, False)
int_max = 32767
int_min = -32768

simple_types = {tokens.VOID: void,
                tokens.BOOL: bool_t,
                tokens.CHAR: char,
                tokens.INT: integer}
