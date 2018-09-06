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

    def is_signed(self):
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

    def is_signed(self):
        return self.signed

    def make_unsigned(self):
        unsign_self = copy.copy(self)
        unsign_self.signed = False
        return unsign_self

    def __repr__(self):
        return '<IntegerCType({size}:{signed}:{const})>'.format(size=self.size, signed=self.signed, const=self.const)

    def __eq__(self, other):
        return type(other) == type(self) and other.size == self.size and other.signed == self.signed


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
        return '<PointerCType({arg}:{const})>'.format(arg=self.arg, const=self.const)


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
        return '<ArrayCType({el}:{n}:{const})>'.format(el=self.el, n=self.n, const=self.const)


class FunctionCType(CType):
    def __init__(self, args, ret, is_varargs=False):
        """Initialize type."""
        self.args = args
        self.ret = ret
        self.is_varargs = is_varargs
        super().__init__(0)

    def is_complete(self):
        return False

    def is_function(self):
        return True

    def __repr__(self):
        return '<FunctionCType({args}:{ret}:{varargs})>'.format(args=self.args, ret=self.ret, varargs=self.is_varargs)


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

integer = IntegerCType(4, True)
unsig_int = IntegerCType(4, False)
int_max = 2147483647
int_min = -2147483648

longint = IntegerCType(8, True)
unsig_longint = IntegerCType(8, False)
longint_max = 9223372036854775807
longint_min = -9223372036854775808

simple_types = {tokens.VOID: void,
                tokens.BOOL: bool_t,
                tokens.CHAR: char,
                tokens.INT: integer}
