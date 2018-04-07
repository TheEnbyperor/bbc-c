class Node:
    """Base class for all decl_tree nodes."""
    pass


class Root(Node):
    """Represents a list of declaration specifiers.
    specs (List(Tokens)) - list of the declaration specifiers, as tokens
    child (Node) - child declaration node
    """

    def __init__(self, specs, decls, inits):
        """Generate root node."""
        self.specs = specs
        self.decls = decls
        self.inits = inits


class Pointer(Node):
    """Represents a pointer to a type."""

    def __init__(self, child, const=False):
        """Generate pointer node."""
        self.child = child
        self.const = const


class Array(Node):
    """Represents an array of a type.
    n (int) - size of the array
    """

    def __init__(self, n, child):
        """Generate array node."""
        self.n = n
        self.child = child


class Function(Node):
    """Represents an function with given arguments and returning given type.
    args (List(Node)) - arguments of the functions
    """

    def __init__(self, args, child):
        """Generate array node."""
        self.args = args
        self.child = child


class Identifier(Node):
    """Represents an identifier.
    If this is a type name and has no identifier, `identifier` is None.
    """

    def __init__(self, identifier):
        """Generate identifier node from an identifier token."""
        self.identifier = identifier
