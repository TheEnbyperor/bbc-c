import string
from .tokens import *


class Lexer:
    def __init__(self, text):
        self.text = text
        self.pos = 0
        if len(text) == 0:
            self.text = " "
        self.current_char = self.text[self.pos]

    def error(self):
        raise Exception("Invalid character: " + self.current_char)

    def peek(self, i=1):
        peek_pos = self.pos + i
        if peek_pos > len(self.text) - 1:
            return None
        else:
            return self.text[peek_pos]

    def advance(self):
        """Advance the 'pos' pointer and set the 'current_char' variable."""
        self.pos += 1
        if self.pos > len(self.text) - 1:
            self.current_char = None  # Indicates end of input
        else:
            self.current_char = self.text[self.pos]

    def skip_whitespace(self):
        while self.current_char is not None and self.current_char.isspace():
            self.advance()

    def skip_line_comment(self):
        while self.current_char != '\n' and self.current_char is not None:
            self.advance()
        self.advance()

    def integer(self):
        result = ''
        while self.current_char is not None and self.current_char.isdigit():
            result += self.current_char
            self.advance()
        return int(result)

    def integer_hex(self):
        """Return a integer consumed from the input."""
        result = ''
        while self.current_char is not None and (self.current_char.isdigit() or
                                                 self.current_char.lower() in ["a", "b", "c", "d", "e", "f"]):
            result += self.current_char
            self.advance()
        return int(result, 16)

    def id(self):
        result = ''
        while self.current_char is not None and self.current_char in string.ascii_letters+string.digits+"_":
            result += self.current_char
            self.advance()

        token_type = RESERVED.get(result, ID)
        token = Token(token_type, result)
        return token

    def tokenize(self):
        tokens = []
        while self.current_char is not None:
            if self.current_char.isspace() and self.current_char is not "\n":
                self.skip_whitespace()
            elif self.current_char == "\n":
                self.advance()

            elif self.current_char == "\\":
                self.advance()
                self.skip_line_comment()

            elif self.current_char == "$":
                self.advance()
                tokens.append(Token(INTEGER, self.integer_hex()))
            elif self.current_char.isdigit():
                tokens.append(Token(INTEGER, self.integer()))
            elif self.current_char == '-':
                self.advance()
                tokens.append(Token(INTEGER, -self.integer()))

            elif self.current_char in string.ascii_letters+string.digits+"_":
                tokens.append(self.id())

            elif self.current_char == ":":
                self.advance()
                tokens.append(Token(COLON, ":"))
            elif self.current_char == ".":
                self.advance()
                tokens.append(Token(PERIOD, "."))
            elif self.current_char == "%":
                self.advance()
                tokens.append(Token(PERCENT, "%"))
            elif self.current_char == ",":
                self.advance()
                tokens.append(Token(COMMA, ","))
            elif self.current_char == "#":
                self.advance()
                tokens.append(Token(HASH, "#"))
            elif self.current_char == "[":
                self.advance()
                tokens.append(Token(LBRACE, "["))
            elif self.current_char == "]":
                self.advance()
                tokens.append(Token(RBRACE, "]"))
            elif self.current_char == "+":
                self.advance()
                tokens.append(Token(PLUS, "+"))

            else:
                self.error()

        tokens.append(Token(EOF, None))

        return tokens
