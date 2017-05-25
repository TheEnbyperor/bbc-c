class AST:
    pass


class Root(AST):
    def __init__(self, nodes):
        self.nodes = nodes


class Compound(AST):
    def __init__(self, items):
        self.items = items


class IfStatement(AST):
    def __init__(self, condition, statement, else_statement):
        self.condititon = condition
        self.statment = statement
        self.else_statement = else_statement


class WhileStatement(AST):
    def __init__(self, condition, statement):
        self.condition = condition
        self.statement = statement


class ForStatement(AST):
    def __init__(self, first, second, third, statement):
        self.statement = statement
        self.first = first
        self.second = second
        self.third = third


class ExprStatement(AST):
    def __init__(self, expr):
        self.expr = expr


class Declaration(AST):
    def __init__(self, decls, inits):
        self.decls = decls
        self.inits = inits


class Return(AST):
    def __init__(self, right):
        self.right = right


class Break(AST):
    pass


class Continue(AST):
    pass


class NoOp(AST):
    pass


class Main(AST):
    """Node for the main function."""

    def __init__(self, body):
        """Initialize node."""
        self.body = body


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


class ParenExpr(AST):
    """Expression in parentheses.
    This is implemented a bit hackily. Rather than being an LExprNode or
    RExprNode like all the other nodes, a paren expression can be either
    depending on what's inside. So for all function calls to this function,
    we simply dispatch to the expression inside.
    """

    def __init__(self, expr):
        """Initialize node."""
        self.expr = expr


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


class Equals(_RExprNode):
    """Expression that is an assignment."""

    def __init__(self, left, right, op):
        """Initialize node."""
        self.left = left
        self.right = right
        self.op = op


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


# TODO: Implement
class ArraySubsc(_LExprNode):
    """Array subscript."""

    def __init__(self, head, arg, op):
        """Initialize node."""
        self.head = head
        self.arg = arg
        self.op = op


# TODO: Implement
class FuncCall(_RExprNode):
    """Function call.
    func - Expression of type function pointer
    args - List of expressions for each argument
    tok - Opening parenthesis of this function call, for error reporting
    """

    def __init__(self, func, args, tok):
        """Initialize node."""
        self.func = func
        self.args = args
        self.tok = tok


class NodeVisitor:
    def visit(self, node):
        method_name = 'visit_' + type(node).__name__
        visitor = getattr(self, method_name, self.generic_visit)
        visitor(node)

    @staticmethod
    def generic_visit(node):
        raise Exception('No visit_{} method'.format(type(node).__name__))