INTEGER, CHARACTER, STRING, \
PLUS, MINUS, DIVIDE, MOD, LPAREM, RPAREM, SEMI, COLON, \
EQUALS, PLUSEQUALS, MINUSEQUALS, STAREQUALS, DIVEQUALS, MODEQUALS, \
BOOLOR, BOOLAND, BOOLEQUALS, BOOLNOT, LESSTHAN, MORETHAN, LESSEQUAL, MOREEQUAL, \
ID, INT, CHAR, VOID, BOOL, RETURN, LBRACE, RBRACE, LBRACK, RBRACK, COMMA, BREAK, CONTINUE, \
SIGNED, UNSIGNED, STATIC, AUTO, CONST, EXTERN, \
INCR, DECR, AMP, STAR, NOT, ELLIPSIS, TILDA, QMARK, VLINE, \
IF, ELSE, WHILE, DO, FOR, SIZEOF, STRUCT, UNION, TYPEDEF, EOF, \
HASH, NEWLINE = \
    "INTEGER", "CHAR", "STRING", \
    "PLUS", "MINUS", "DIVIDE", "MOD", "LRAPEM", "RPAREM", "SEMI", "COLON", \
    "EQUALS", "PLUSEQUALS", "MINUSEQUALS", "STAREQUALS", "DIVEQUALS", "MODEQUALS", \
    "BOOLOR", "BOOLAND", "BOOLEQUALS", "BOOLNOT", "LESSTHAN", "MORETHAN", "LESSEQUAL", "MOREEQUAL", \
    "ID", "int", "char", "void", "bool", "RETURN", "LBRACE", "RBRACE", "LBRACK", "RBRACK", "COMMA", "BREAK", "CONTINUE", \
    "signed", "unsigned", "static", "auto", "const", "extern", \
    "INCR", "DECR", "AMP", "STAR", "NOT", "ELLIPSIS", "TILDA", "QMARK", "VLINE", \
    "IF", "ELSE", "WHILE", "DO", "FOR", "SIZEOF", "STRUCT", "UNION", "TYPEDEF", "EOF", \
    "HASH", "NEWLINE"


class Token:
    def __init__(self, kind, value, ):
        self.type = kind
        self.value = value

    def __str__(self):
        """String representation of the class instance.

        Examples:
            Token(INTEGER, 3)
            Token(PLUS '+')
        """
        return 'Token({type}, {value})'.format(
            type=self.type,
            value=repr(self.value)
        )

    def __repr__(self):
        return self.__str__()


TYPES = {
    'int': Token(INT, 'int'),
    'char': Token(CHAR, 'char'),
    'void': Token(VOID, 'void'),
    'bool': Token(BOOL, 'bool'),
}

STORAGE = {
    'auto': Token(AUTO, 'auto'),
    'static': Token(STATIC, 'static'),
    'extern': Token(EXTERN, 'extern'),
}

QUALIFIERS = {
    'const': Token(CONST, 'const'),
}

TYPE_MODS = {
    'signed': Token(SIGNED, 'signed'),
    'unsigned': Token(UNSIGNED, 'unsigned'),
}

MODIFIERS = {**STORAGE, **QUALIFIERS, **TYPE_MODS}

RESERVED_KEYWORDS = {**TYPES, **{**MODIFIERS, **{
    'return': Token(RETURN, 'return'),
    'break': Token(BREAK, 'break'),
    'continue': Token(CONTINUE, 'continue'),
    'if': Token(IF, 'if'),
    'else': Token(ELSE, 'else'),
    'while': Token(WHILE, 'while'),
    'do': Token(DO, 'do'),
    'for': Token(FOR, 'for'),
    'sizeof': Token(SIZEOF, 'sizeof'),
    'struct': Token(STRUCT, 'struct'),
    'union': Token(UNION, 'union'),
    'typedef': Token(TYPEDEF, 'typedef'),
}}}
