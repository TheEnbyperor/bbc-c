from .tokens import *


class Lexer:
    def __init__(self, text):
        self.text = text
        self.pos = 0
        self.current_char = self.text[self.pos]

    def error(self):
        raise Exception("Invalid character: " + self.current_char)

    def peek(self):
        peek_pos = self.pos + 1
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
        while self.current_char != '\n':
            self.advance()
        self.advance()

    def skip_comment(self):
        while self.current_char != '*' and self.peek() != "/":
            self.advance()
        self.advance()

    def integer(self):
        """Return a (multidigit) integer consumed from the input."""
        result = ''
        while self.current_char is not None and self.current_char.isdigit():
            result += self.current_char
            self.advance()
        return int(result)

    def string(self):
        result = ''
        while self.current_char is not None and self.current_char != '"':
            result += self.current_char
            self.advance()
        return result

    def id(self):
        """Handle identifiers and reserved keywords"""
        result = ''
        while self.current_char is not None and self.current_char.isalnum():
            result += self.current_char
            self.advance()

        token = RESERVED_KEYWORDS.get(result, Token(ID, result))
        return token

    def tokenize(self):
        tokens = []
        while self.pos < len(self.text):

            if self.current_char.isspace():
                self.skip_whitespace()
                continue
            elif self.current_char == "/" and self.peek() == "/":
                self.skip_line_comment()
            elif self.current_char == "/" and self.peek() == "*":
                self.skip_comment()

            elif self.current_char.isdigit():
                tokens.append(Token(INTEGER, self.integer()))

            elif self.current_char.isalpha():
                tokens.append(self.id())
            elif self.current_char == "'":
                self.advance()
                tokens.append(Token(CHARACTER, self.current_char))
                self.advance()
                self.advance()
            elif self.current_char == '"':
                self.advance()
                tokens.append(Token(STRING, self.string()))
                self.advance()

            elif self.current_char == "|" and self.peek() == "|":
                self.advance()
                self.advance()
                tokens.append(Token(BOOLOR, "||"))
            elif self.current_char == "&" and self.peek() == "&":
                self.advance()
                self.advance()
                tokens.append(Token(BOOLAND, "&&"))
            elif self.current_char == "=" and self.peek() == "=":
                self.advance()
                self.advance()
                tokens.append(Token(BOOLEQUALS, "=="))
            elif self.current_char == "!" and self.peek() == "=":
                self.advance()
                self.advance()
                tokens.append(Token(BOOLNOT, "!="))

            elif self.current_char == "+" and self.peek() == "+":
                self.advance()
                self.advance()
                tokens.append(Token(INCR, "++"))
            elif self.current_char == "-" and self.peek() == "-":
                self.advance()
                self.advance()
                tokens.append(Token(DECR, "--"))

            elif self.current_char == "+" and self.peek() == "=":
                self.advance()
                self.advance()
                tokens.append(Token(PLUSEQUALS, "+="))
            elif self.current_char == "-" and self.peek() == "=":
                self.advance()
                self.advance()
                tokens.append(Token(MINUSEQUALS, "-="))
            elif self.current_char == "*" and self.peek() == "=":
                self.advance()
                self.advance()
                tokens.append(Token(STAREQUALS, "*="))
            elif self.current_char == "/" and self.peek() == "=":
                self.advance()
                self.advance()
                tokens.append(Token(DIVEQUALS, "/="))
            elif self.current_char == "%" and self.peek() == "=":
                self.advance()
                self.advance()
                tokens.append(Token(MODEQUALS, "%="))
            elif self.current_char == '=':
                self.advance()
                tokens.append(Token(EQUALS, '='))

            elif self.current_char == ';':
                self.advance()
                tokens.append(Token(SEMI, ';'))
            elif self.current_char == "{":
                self.advance()
                tokens.append(Token(LBRACE, "{"))
            elif self.current_char == "}":
                self.advance()
                tokens.append(Token(RBRACE, "}"))
            elif self.current_char == "(":
                self.advance()
                tokens.append(Token(LPAREM, "("))
            elif self.current_char == ")":
                self.advance()
                tokens.append(Token(RPAREM, ")"))
            elif self.current_char == "[":
                self.advance()
                tokens.append(Token(LBRACK, "["))
            elif self.current_char == "]":
                self.advance()
                tokens.append(Token(RBRACK, "]"))
            elif self.current_char == ",":
                self.advance()
                tokens.append(Token(COMMA, ","))

            elif self.current_char == "+":
                self.advance()
                tokens.append(Token(PLUS, "+"))
            elif self.current_char == "-":
                self.advance()
                tokens.append(Token(MINUS, "-"))
            elif self.current_char == "*":
                self.advance()
                tokens.append(Token(STAR, "*"))
            elif self.current_char == "/":
                self.advance()
                tokens.append(Token(DIVIDE, "/"))
            elif self.current_char == "%":
                self.advance()
                tokens.append(Token(MOD, "%"))
            elif self.current_char == "&":
                self.advance()
                tokens.append(Token(AMP, "&"))
            elif self.current_char == "!":
                self.advance()
                tokens.append(Token(NOT, "!"))

            else:
                self.error()
        tokens.append(Token(EOF, None))

        return tokens
