INTEGER, CHARACTER, STRING, MAIN, \
PLUS, MINUS, DIVIDE, MOD, LPAREM, RPAREM, SEMI, \
EQUALS, PLUSEQUALS, MINUSEQUALS, STAREQUALS, DIVEQUALS, MODEQUALS, \
BOOLOR, BOOLAND, BOOLEQUALS, BOOLNOT, LESSTHAN, MORETHAN, LESSEQUAL, MOREEQUAL, \
ID, INT, CHAR, VOID, RETURN, LBRACE, RBRACE, LBRACK, RBRACK, COMMA, BREAK, CONTINUE, \
SIGNED, UNISGNED, STATIC, AUTO, \
INCR, DECR, AMP, STAR, NOT, \
IF, ELSE, WHILE, FOR, EOF = \
    "INTEGER", "CHAR", "STRING", "MAIN", \
 "PLUS", "MINUS", "DIVIDE", "MOD", "LRAPEM", "RPAREM", "SEMI", \
 "EQUALS", "PLUSEQUALS", "MINUSEQUALS", "STAREQUALS", "DIVEQUALS", "MODEQUALS", \
    "BOOLOR", "BOOLAND", "BOOLEQUALS", "BOOLNOT", "LESSTHAN", "MORETHAN", "LESSEQUAL", "MOREEQUAL", \
    "ID", "int", "char", "void", "RETURN", "LBRACE", "RBRACE", "LBRACK", "RBRACK", "COMMA", "BREAK", "CONTINUE", \
 "signed", "unsigned", "static", "auto", \
 "INCR", "DECR", "AMP", "STAR", "NOT", \
 "IF", "ELSE", "WHILE", "FOR", "EOF"


class Token:
    def __init__(self, kind, value,):
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
}

MODIFIERS = {
    'signed': Token(SIGNED, 'signed'),
    'unsigned': Token(UNISGNED, 'unsigned'),
    'auto': Token(AUTO, 'auto'),
    'static': Token(STATIC, 'static'),
}

RESERVED_KEYWORDS = dict(TYPES, **dict(MODIFIERS, **{
    'return': Token(RETURN, 'return'),
    'break': Token(BREAK, 'break'),
    'continue': Token(CONTINUE, 'continue'),
    'if': Token(IF, 'if'),
    'else': Token(ELSE, 'else'),
    'while': Token(WHILE, 'while'),
    'for': Token(FOR, 'for'),
    'main': Token(MAIN, 'main')
}))
