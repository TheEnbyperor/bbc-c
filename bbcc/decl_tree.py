from . import tokens


class Node:
    """Base class for all decl_tree nodes."""
    pass


class Root(Node):
    """Represents a list of declaration specifiers.
    specs (List(Tokens)) - list of the declaration specifiers, as tokens
    child (Node) - child declaration node
    """

    def __init__(self, specs, decls, inits=None):
        """Generate root node."""
        self.specs = specs
        self.decls = decls

        if inits:
            self.inits = inits
        else:
            self.inits = [None] * len(self.decls)

    def __repr__(self):
        return str(self.specs) + str(self.decls)


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

    def __repr__(self):
        return str(self.identifier)


class _StructUnion(Node):
    def __init__(self, tag, members):
        self.tag = tag
        self.members = members

        super().__init__()


class Struct(_StructUnion):
    """Represents a struct C type."""

    def __init__(self, tag, members):
        self.type = tokens.STRUCT
        super().__init__(tag, members)


class Union(_StructUnion):
    """Represents a union C type."""

    def __init__(self, tag, members):
        self.type = tokens.UNION
        super().__init__(tag, members)
