LABEL, ID, EOF, INTEGER, LPAREM, RPAREM, COMMA, HASH, PERIOD, LT, GT, PLUS, MINUS, STRING \
    = "LABEL", "ID", "EOF", "INTEGER", "LPAREM", "RPAREM", "COMMA", "HASH", "PERIOD", "LT", "GT", "PLUS", "MINUS", \
      "STRING"


class Token:
    def __init__(self, kind, value, ):
        self.type = kind
        self.value = value

    def __repr__(self):
        return 'Token({type}, {value})'.format(
            type=self.type,
            value=repr(self.value)
        )
