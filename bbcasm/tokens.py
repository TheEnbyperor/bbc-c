LABEL, ID, EOF, INTEGER, LPAREM, RPAREM, COMMA, HASH \
    = "LABEL", "ID", "EOF", "INTEGER", "LPAREM", "RPAREM", "COMMA", "HASH"


class Token:
    def __init__(self, kind, value, ):
        self.type = kind
        self.value = value

    def __str__(self):
        return 'Token({type}, {value})'.format(
            type=self.type,
            value=repr(self.value)
        )

    def __repr__(self):
        return self.__str__()