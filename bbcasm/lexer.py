from .tokens import *


class Lexer:
    def __init__(self, text):
        self.text = text
        self.pos = 0
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
        while self.current_char is not None and \
                (self.current_char.isdigit() or self.current_char.lower() in ["a", "b", "c", "d", "e", "f"]):
            result += self.current_char
            self.advance()
        return int(result, 16)

    def string(self):
        result = ''
        while self.current_char is not None and (self.current_char.isalnum() or self.current_char == "_"):
            result += self.current_char
            self.advance()
        return result

    def tokenize(self):
        tokens = []
        while self.current_char is not None:
            if self.current_char.isspace() and self.current_char is not "\n":
                self.skip_whitespace()
                continue
            elif self.current_char == "\n":
                self.advance()

            elif self.current_char == "/" and self.peek() == "/":
                self.advance()
                self.advance()
                self.skip_line_comment()

            elif self.current_char == "#":
                self.advance()
                tokens.append(Token(HASH, "#"))
            elif self.current_char == ".":
                self.advance()
                tokens.append(Token(PERIOD, "."))

            elif self.current_char == "$":
                self.advance()
                tokens.append(Token(INTEGER, self.integer_hex()))
            elif self.current_char.isdigit():
                tokens.append(Token(INTEGER, self.integer()))

            elif self.current_char == "(":
                self.advance()
                tokens.append(Token(LPAREM, "("))
            elif self.current_char == ")":
                self.advance()
                tokens.append(Token(RPAREM, ")"))
            elif self.current_char == "<":
                self.advance()
                tokens.append(Token(LT, "<"))
            elif self.current_char == ">":
                self.advance()
                tokens.append(Token(GT, ">"))
            elif self.current_char == "+":
                self.advance()
                tokens.append(Token(PLUS, "+"))
            elif self.current_char == "-":
                self.advance()
                tokens.append(Token(MINUS, "-"))
            elif self.current_char == ",":
                self.advance()
                tokens.append(Token(COMMA, ","))

            elif not self.current_char.isspace():
                string = self.string()
                if self.current_char == ":":
                    self.advance()
                    tokens.append(Token(LABEL, string))
                else:
                    tokens.append(Token(ID, string))

            else:
                self.advance()

        tokens.append(Token(EOF, None))

        return tokens
