ID, EOF, INTEGER, COLON, PERIOD, PERCENT, COMMA, HASH  \
    = "ID", "EOF", "INTEGER", "COLON", "PERIOD", "PERCENT", "COMMA", "HASH"


class Token:
    def __init__(self, kind, value, ):
        self.type = kind
        self.value = value

    def __repr__(self):
        return 'Token({type}, {value})'.format(
            type=self.type,
            value=repr(self.value)
        )
