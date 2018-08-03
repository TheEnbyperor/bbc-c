from . import il
from . import ctypes


class AST:
    pass


class Root(AST):
    def __init__(self, nodes):
        self.nodes = nodes


class Compound(AST):
    def __init__(self, items):
        self.items = items

    def __repr__(self):
        return "Compound\n{}".format(
            "\n".join(map(lambda x: "  " + "  ".join(str(x).splitlines(True)), self.items))
        )


class TranslationUnit(AST):
    def __init__(self, items):
        self.items = items

    def __repr__(self):
        return "TranslationUnit\n{}".format(
            "\n".join(map(lambda x: "  " + "  ".join(str(x).splitlines(True)), self.items))
        )


class IfStatement(AST):
    def __init__(self, condition, statement, else_statement):
        self.condition = condition
        self.statement = statement
        self.else_statement = else_statement

    def __repr__(self):
        return "IfStatement\n{}\n{}\n{}".format("  " + "  ".join(str(self.condition).splitlines(True)),
                                                "  " + "  ".join(str(self.statement).splitlines(True)),
                                                "  " + "  ".join(str(self.else_statement).splitlines(True)))


class Conditional(AST):
    def __init__(self, condition, statement, else_statement):
        self.condition = condition
        self.statement = statement
        self.else_statement = else_statement


class WhileStatement(AST):
    def __init__(self, condition, statement):
        self.condition = condition
        self.statement = statement

    def __repr__(self):
        return "WhileStatement\n{}\n{}".format("  " + "  ".join(str(self.condition).splitlines(True)),
                                               "  " + "  ".join(str(self.statement).splitlines(True)))


class DoWhileStatement(AST):
    def __init__(self, condition, statement):
        self.condition = condition
        self.statement = statement

    def __repr__(self):
        return "DoWhileStatement\n{}\n{}".format("  " + "  ".join(str(self.condition).splitlines(True)),
                                                 "  " + "  ".join(str(self.statement).splitlines(True)))


class ForStatement(AST):
    def __init__(self, first, second, third, statement):
        self.statement = statement
        self.first = first
        self.second = second
        self.third = third


class Function(AST):
    def __init__(self, decl, nodes):
        self.decl = decl
        self.nodes = nodes

    def __repr__(self):
        return "Function<{}>\n{}".format(self.decl,
                                                   "  " + "  ".join(str(self.nodes).splitlines(True)))

class ExprStatement(AST):
    def __init__(self, expr):
        self.expr = expr

    def __repr__(self):
        return "ExprStatement\n{}".format("  " + "  ".join(str(self.expr).splitlines(True)))


class DeclInfo:
    # Storage class specifiers for declarations
    AUTO = 1
    STATIC = 2
    EXTERN = 3

    def __init__(self, identifier, ctype, storage=None, init=None, params=None):
        if params is None:
            params = []
        self.identifier = identifier
        self.ctype = ctype
        self.storage = storage
        self.init = init
        self.params = params

    def __str__(self):
        return '<DeclInfo({identifier}:{ctype}:{storage}:{init})>'.format(identifier=self.identifier, ctype=self.ctype,
                                                                          storage=self.storage, init=self.init)

    def __repr__(self):
        return self.__str__()


class Declaration(AST):
    def __init__(self, node):
        self.node = node

    def __repr__(self):
        return "Declaration\n{}".format("  " + str(self.node))


class Return(AST):
    def __init__(self, right):
        self.right = right

    def __repr__(self):
        return "Return\n{}\n".format("  " + "  ".join(str(self.right).splitlines(True)))


class Break(AST):
    def __repr__(self):
        return "Break"


class Continue(AST):
    pass


class NoOp(AST):
    pass


class _RExprNode(AST):
    """Base class for representing an rvalue expression node in the AST.
    There are two types of expression nodes, RExprNode and LExprNode.
    An expression node which can be used as an lvalue (that is, an expression
    node which can be the argument of an address-of operator) derives from
    LExprNode. Expression nodes which cannot be used as lvalues derive from
    RExprNode.
    """


class _LExprNode(AST):
    """Base class for representing an lvalue expression node in the AST.
    See RExprNode for general explanation.
    """


class MultiExpr(_RExprNode):
    """Expression that is two expressions joined by comma."""

    def __init__(self, left, right, op):
        """Initialize node."""
        self.left = left
        self.right = right
        self.op = op


class Number(_RExprNode):
    """Expression that is just a single number."""

    def __init__(self, number):
        """Initialize node."""
        self.number = number

    def __repr__(self):
        return "Number<{}>".format(self.number)


class InitializerList(_RExprNode):
    """Expression that is just a single number."""

    def __init__(self, inits):
        """Initialize node."""
        self.inits = inits

    def __repr__(self):
        return "InitializerList<{}>".format(self.inits)


class String(_LExprNode):
    """Expression that is a string.
    chars (List(int)) - String this expression represents, as a null-terminated
    list of the ASCII representations of each character.
    """

    def __init__(self, chars):
        """Initialize Node."""
        self.chars = chars


class Identifier(_LExprNode):
    """Expression that is a single identifier."""

    def __init__(self, identifier):
        """Initialize node."""
        self.identifier = identifier

    def __repr__(self):
        return "Identifier<{}>".format(self.identifier.value)


class ParenExpr(AST):
    """Expression in parentheses."""

    def __init__(self, expr):
        """Initialize node."""
        self.expr = expr


class Sizeof(AST):
    def __init__(self, expr):
        """Initialize node."""
        self.expr = expr

    def __repr__(self):
        return "SizeOf\n{}".format("  " + "  ".join(str(self.expr).splitlines(True)))


class SizeofType(AST):
    def __init__(self, expr):
        """Initialize node."""
        self.type = expr


class _ArithBinOp(_RExprNode):
    """Base class for some binary operators.
    Binary operators like +, -, ==, etc. are similar in many respects. They
    convert their arithmetic arguments, etc. This is a base class for
    nodes of those types of operators.
    """

    def __init__(self, left, right, op):
        """Initialize node."""
        self.left = left
        self.right = right
        self.op = op

    def __repr__(self):
        return "{}\n{}".format(self.__class__.__name__,
                               "  " + "  ".join((str(self.left) + "\n" + str(self.right)).splitlines(True)))


class Plus(_ArithBinOp):
    """Expression that is sum of two expressions.
    left - Expression on left side
    right - Expression on right side
    op (Token) - Plus operator token
    """

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class Minus(_ArithBinOp):
    """Expression that is the difference of two expressions.
    left - Expression on left side
    right - Expression on right side
    op (Token) - Plus operator token
    """

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class Mult(_ArithBinOp):
    """Expression that is product of two expressions."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class Div(_ArithBinOp):
    """Expression that is quotient of two expressions."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class Mod(_ArithBinOp):
    """Expression that is modulus of two expressions."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class _Equality(_ArithBinOp):
    """Base class for == and != nodes."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class Equality(_Equality):
    """Expression that checks equality of two expressions."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class Inequality(_Equality):
    """Expression that checks inequality of two expressions."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class LessThan(_Equality):
    """Expression that checks relation of two expressions."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class MoreThan(_Equality):
    """Expression that checks relation of two expressions."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class LessEqual(_Equality):
    """Expression that checks relation of two expressions."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class MoreEqual(_Equality):
    """Expression that checks relation of two expressions."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class _BoolAndOr(_RExprNode):
    """Base class for && and || operators."""

    def __init__(self, left, right, op):
        """Initialize node."""
        self.left = left
        self.right = right
        self.op = op


class BoolAnd(_BoolAndOr):
    """Expression that performs boolean and of two values."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class BoolOr(_BoolAndOr):
    """Expression that performs boolean or of two values."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class And(_ArithBinOp):

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class IncOr(_ArithBinOp):

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class ExcOr(_ArithBinOp):

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class Equals(_RExprNode):
    """Expression that is an assignment."""

    def __init__(self, left, right, op):
        """Initialize node."""
        self.left = left
        self.right = right
        self.op = op

    def __repr__(self):
        return "Equals\n{}\n{}".format("  " + "  ".join(str(self.left).splitlines(True)),
                                       "  " + "  ".join(str(self.right).splitlines(True)))


class _CompoundPlusMinus(_RExprNode):
    """Expression that is += or -=."""

    def __init__(self, left, right, op):
        """Initialize node."""
        self.left = left
        self.right = right
        self.op = op


class PlusEquals(_CompoundPlusMinus):
    """Expression that is +=."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class MinusEquals(_CompoundPlusMinus):
    """Expression that is -=."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class StarEquals(_CompoundPlusMinus):
    """Expression that is *=."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class DivEquals(_CompoundPlusMinus):
    """Expression that is /=."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class ModEquals(_CompoundPlusMinus):
    """Expression that is %=."""

    def __init__(self, left, right, op):
        """Initialize node."""
        super().__init__(left, right, op)


class _IncrDecr(_RExprNode):
    """Base class for prefix/postfix increment/decrement operators."""

    def __init__(self, expr):
        """Initialize node."""
        self.expr = expr


class PreIncr(_IncrDecr):
    """Prefix increment."""

    def __init__(self, expr):
        """Initialize node."""
        super().__init__(expr)


class PostIncr(_IncrDecr):
    """Postfix increment."""

    def __init__(self, expr):
        """Initialize node."""
        super().__init__(expr)


class PreDecr(_IncrDecr):
    """Prefix decrement."""

    def __init__(self, expr):
        """Initialize node."""
        super().__init__(expr)


class PostDecr(_IncrDecr):
    """Postfix decrement."""

    def __init__(self, expr):
        """Initialize node."""
        super().__init__(expr)


class BoolNot(_RExprNode):
    """Boolean not."""

    def __init__(self, expr):
        """Initialize node."""
        self.expr = expr


class Negate(_RExprNode):
    """Boolean not."""

    def __init__(self, expr):
        """Initialize node."""
        self.expr = expr


class AddrOf(_RExprNode):
    """Address-of expression."""

    def __init__(self, expr):
        """Initialize node."""
        self.expr = expr


class Deref(_LExprNode):
    """Dereference expression."""

    def __init__(self, expr):
        """Initialize node."""
        self.expr = expr


class ArraySubsc(_LExprNode):
    """Array subscript."""

    def __init__(self, head, arg):
        """Initialize node."""
        self.head = head
        self.arg = arg

    def __repr__(self):
        return "ArraySubsc\n{}\n{}".format("  " + str(self.head),
                                           "  " + str(self.arg))


class FuncCall(_RExprNode):
    """Function call.
    func - Expression of type function pointer
    args - List of expressions for each argument
    """

    def __init__(self, func, args):
        """Initialize node."""
        self.func = func
        self.args = args

    def __repr__(self):
        return "FuncCall\n{}\n{}".format("  " + str(self.func),
                                         "\n".join(map(lambda x: "  " + "  ".join(str(x).splitlines(True)), self.args)))


class Cast(_RExprNode):
    def __init__(self, type, expr):
        self.type = type
        self.expr = expr


class _ObjLookup(_LExprNode):
    def __init__(self, head, member):
        super().__init__()
        self.head = head
        self.member = member


class ObjMember(_ObjLookup):
    pass


class ObjPtrMember(_ObjLookup):
    pass


class NodeVisitor:
    def visit(self, node):
        method_name = 'visit_' + type(node).__name__
        visitor = getattr(self, method_name, self.generic_visit)
        return visitor(node)

    @staticmethod
    def generic_visit(node):
        raise RuntimeError('No visit_{} method'.format(type(node).__name__))


class LValue:
    @property
    def type(self) -> ctypes.CType:
        raise NotImplementedError

    def set_to(self, rvalue, il_code: il.IL):
        raise NotImplementedError

    def addr(self, il_code: il.IL):
        raise NotImplementedError

    def val(self, il_code):
        raise NotImplementedError

    def modable(self):
        ctype = self.type
        if ctype.is_array():
            return False
        if not ctype.is_complete():
            return False
        if ctype.is_const():
            return False

        return True


class DirectLValue(LValue):
    def __init__(self, il_value: il.ILValue):
        self.il_value = il_value

    @property
    def type(self):
        return self.il_value.type

    def set_to(self, rvalue, il_code: il.IL):
        il_code.add(il.Set(rvalue, self.il_value))

    def addr(self, il_code: il.IL):
        output = il.ILValue(ctypes.unsig_int)
        il_code.add(il.AddrOf(self.il_value, output))
        return output

    def val(self, il_code: il.IL):
        return self.il_value


class IndirectLValue(LValue):
    def __init__(self, addr_val: il.ILValue, ctype: ctypes.CType, offset: il.ILValue):
        self.il_value = addr_val
        self.offset = offset
        self.ctype = ctype

    @property
    def type(self):
        return self.ctype

    def set_to(self, rvalue, il_code: il.IL):
        il_code.add(il.SetAt(self.il_value.val(il), rvalue, self.offset.val(il)))

    def addr(self, il_code: il.IL):
        return self.il_value

    def val(self, il_code: il.IL):
        output = il.ILValue(self.ctype)
        il_code.add(il.ReadAt(self.il_value.val(il_code), output, self.offset.val(il)))
        return output
