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

    def is_struct_union(self):
        return False

    def is_scalar(self):
        return self.is_arith() or self.is_pointer()

    def is_const(self):
        return self.const

    def is_function(self):
        return False

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

    def __repr__(self):
        return '<IntegerCType({size}:{signed})>'.format(size=self.size, signed=self.signed)


class VoidCType(CType):
    def __init__(self):
        super().__init__(0)

    def is_complete(self):
        return False

    def is_void(self):
        return True

    def __repr__(self):
        return '<VoidCType>'


class PointerCType(CType):
    def __init__(self, arg, const=False):
        self.arg = arg
        super().__init__(2, const)

    def is_complete(self):
        return True

    def is_object(self):
        return True

    def is_pointer(self):
        return True

    def __repr__(self):
        return '<PointerCType({arg})>'.format(arg=self.arg)


class ArrayCType(CType):
    def __init__(self, el, n):
        self.el = el
        self.n = n
        super().__init__((n or 1) * self.el.size)

    def is_complete(self):
        return self.n is not None

    def is_object(self):
        return True

    def is_array(self):
        return True

    def __repr__(self):
        return '<ArrayCType({el}:{n})>'.format(el=self.el, n=self.n)


class FunctionCType(CType):
    def __init__(self, args, ret):
        """Initialize type."""
        self.args = args
        self.ret = ret
        super().__init__(1)

    def is_complete(self):
        return False

    def is_function(self):
        return True

    def __repr__(self):
        return '<FunctionCType({args}:{ret})>'.format(args=self.args, ret=self.ret)


class _UnionStructCType(CType):
    def __init__(self, tag, members=None):
        self.tag = tag
        self.members = members
        self.offsets = {}
        super().__init__(1)

    def is_complete(self):
        return self.members is not None

    def is_object(self):
        return True

    def is_struct_union(self):
        return True

    def get_offset(self, member):
        return self.offsets.get(member, (None, None))

    def set_members(self, members):
        raise NotImplementedError


class StructCType(_UnionStructCType):
    def set_members(self, members):
        self.members = members

        cur_offset = 0
        for member, ctype in members:
            self.offsets[member] = cur_offset, ctype
            cur_offset += ctype.size

        self.size = cur_offset

    def __repr__(self):
        return '<StructCType({})>'.format(self.members)


class UnionCType(_UnionStructCType):
    def set_members(self, members):
        self.members = members
        self.size = max([ctype.size for _, ctype in members], default=0)
        for member, ctype in members:
            self.offsets[member] = 0, ctype

    def __repr__(self):
        return '<UnionCType({})>'.format(self.members)


void = VoidCType()

bool_t = IntegerCType(1, False)

char = IntegerCType(1, True)
unsig_char = IntegerCType(1, False)

integer = IntegerCType(2, True)
unsig_int = IntegerCType(2, False)
int_max = 32767
int_min = -32768

longint = IntegerCType(4, True)
unsig_longint = IntegerCType(4, False)
longint_max = 2147483647
longint_min = -2147483648

simple_types = {tokens.VOID: void,
                tokens.BOOL: bool_t,
                tokens.CHAR: char,
                tokens.INT: integer}
