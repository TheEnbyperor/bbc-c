INTEGER, CHARACTER, STRING, \
    PLUS, MINUS, DIVIDE, MOD, LPAREM, RPAREM, SEMI, \
    EQUALS, PLUSEQUALS, MINUSEQUALS, STAREQUALS, DIVEQUALS, MODEQUALS, \
    BOOLOR, BOOLAND, BOOLEQUALS, BOOLNOT, LESSTHAN, MORETHAN, LESSEQUAL, MOREEQUAL, \
    ID, INT, CHAR, VOID, BOOL, RETURN, LBRACE, RBRACE, LBRACK, RBRACK, COMMA, BREAK, CONTINUE, \
    SIGNED, UNISGNED, STATIC, AUTO, CONST, \
    INCR, DECR, AMP, STAR, NOT, \
    IF, ELSE, WHILE, DO, FOR, EOF, \
    HASH, NEWLINE = \
    "INTEGER", "CHAR", "STRING", \
    "PLUS", "MINUS", "DIVIDE", "MOD", "LRAPEM", "RPAREM", "SEMI", \
    "EQUALS", "PLUSEQUALS", "MINUSEQUALS", "STAREQUALS", "DIVEQUALS", "MODEQUALS", \
    "BOOLOR", "BOOLAND", "BOOLEQUALS", "BOOLNOT", "LESSTHAN", "MORETHAN", "LESSEQUAL", "MOREEQUAL", \
    "ID", "int", "char", "void", "bool", "RETURN", "LBRACE", "RBRACE", "LBRACK", "RBRACK", "COMMA", "BREAK", "CONTINUE", \
    "signed", "unsigned", "static", "auto", "const", \
    "INCR", "DECR", "AMP", "STAR", "NOT", \
    "IF", "ELSE", "WHILE", "DO", "FOR", "EOF", \
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

MODIFIERS = {
    'signed': Token(SIGNED, 'signed'),
    'unsigned': Token(UNISGNED, 'unsigned'),
    'auto': Token(AUTO, 'auto'),
    'static': Token(STATIC, 'static'),
    'const': Token(CONST, 'const'),
}

RESERVED_KEYWORDS = dict(TYPES, **dict(MODIFIERS, **{
    'return': Token(RETURN, 'return'),
    'break': Token(BREAK, 'break'),
    'continue': Token(CONTINUE, 'continue'),
    'if': Token(IF, 'if'),
    'else': Token(ELSE, 'else'),
    'while': Token(WHILE, 'while'),
    'do': Token(DO, 'do'),
    'for': Token(FOR, 'for')
}))
