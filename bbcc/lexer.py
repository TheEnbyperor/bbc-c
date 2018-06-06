from .tokens import *
import string


class Lexer:
    def __init__(self, text):
        self.text = text
        self.pos = 0
        self.current_char = self.text[self.pos]

    def error(self):
        raise Exception("Invalid character: " + self.current_char)

    def peek(self, i=1):
        peek_pos = self.pos + i
        if peek_pos > len(self.text) - i:
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

    def skip_comment(self):
        while not (self.current_char == '*' and self.peek() == "/") and self.current_char is not None:
            self.advance()
        self.advance()
        self.advance()

    def integer(self):
        """Return a integer consumed from the input."""
        result = ''
        while self.current_char is not None and self.current_char.isdigit():
            result += self.current_char
            self.advance()
        return int(result)

    def char(self):
        if self.current_char == '\\':
            self.advance()
            val = self.process_escape()
            return val
        return self.current_char

    def string(self):
        result = ''
        while self.current_char is not None and self.current_char != '"' and self.current_char != '\n':
            result += self.current_char
            self.advance()
            if self.current_char == "\\":
                self.advance()
                result += self.process_escape()
                self.advance()
        return result

    def process_escape(self):
        if self.current_char == "n":
            return "\n"
        elif self.current_char == "t":
            return "\t"
        elif self.current_char == "v":
            return "\v"
        elif self.current_char == "b":
            return "\b"
        elif self.current_char == "r":
            return "\r"
        elif self.current_char == "f":
            return "\f"
        elif self.current_char == "a":
            return "\a"
        elif self.current_char == "\\":
            return "\\"
        elif self.current_char == "?":
            return "?"
        elif self.current_char == "'":
            return "'"
        elif self.current_char == "\"":
            return "\""
        elif self.current_char == "0":
            return "\0"

    def h_string(self):
        result = ''
        while self.current_char is not None and self.current_char != '>' and self.current_char != '\n':
            result += self.current_char
            self.advance()
            if self.current_char == "\\":
                self.advance()
                result += self.process_escape()
                self.advance()
        return result

    def id(self):
        result = ''
        while self.current_char is not None and self.current_char in string.ascii_letters+string.digits+"_":
            result += self.current_char
            self.advance()

        token = RESERVED_KEYWORDS.get(result, Token(ID, result))
        return token

    def tokenize(self):
        tokens = []
        while self.current_char is not None:
            if self.current_char.isspace() and self.current_char is not "\n":
                self.skip_whitespace()
                continue
            elif self.current_char == "\n":
                self.advance()
                tokens.append(Token(NEWLINE, "\n"))
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
                tokens.append(Token(CHARACTER, self.char()))
                self.advance()
                self.advance()
            elif self.current_char == '"':
                self.advance()
                tokens.append(Token(STRING, self.string()))
                self.advance()

            elif self.current_char == "." and self.peek() == "." and self.peek(2) == ".":
                self.advance()
                self.advance()
                self.advance()
                tokens.append(Token(ELLIPSIS, "..."))

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
            elif self.current_char == "<" and self.peek() == "=":
                self.advance()
                self.advance()
                tokens.append(Token(LESSEQUAL, "<="))
            elif self.current_char == ">" and self.peek() == "=":
                self.advance()
                self.advance()
                tokens.append(Token(MOREEQUAL, ">="))
            elif self.current_char == "<":
                self.advance()
                tokens.append(Token(LESSTHAN, "<"))
            elif self.current_char == ">":
                self.advance()
                tokens.append(Token(MORETHAN, ">"))

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
            elif self.current_char == ':':
                self.advance()
                tokens.append(Token(COLON, ':'))
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

            elif self.current_char == "#":
                self.advance()
                tokens.append(Token(HASH, "#"))

            else:
                self.error()
        tokens.append(Token(EOF, None))

        return tokens
