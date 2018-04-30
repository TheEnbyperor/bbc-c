from .tokens import *
from . import lexer
import os


class Preproc:
    def __init__(self, tokens):
        self.tokens = tokens
        self.if_depth = 0
        self.macros = {}

    def error(self):
        raise SyntaxError("Invalid syntax")

    def eat(self, index):
        self.tokens = self.tokens[:index] + self.tokens[index + 1:]

    def token_is(self, index, token_type):
        if index < 0:
            index = 0
        try:
            if self.tokens[index].type == token_type:
                return True
            else:
                return False
        except IndexError:
            return False

    def parse_stmt(self, index):
        if not self.token_is(index, ID):
            self.error()

        try:
            index = self.parse_include(index)
            return index
        except SyntaxError:
            pass
        try:
            index = self.parse_define(index)
            return index
        except SyntaxError:
            pass
        try:
            index = self.parse_undef(index)
            return index
        except SyntaxError:
            pass
        try:
            index = self.parse_ifdef(index)
            return index
        except SyntaxError:
            pass
        try:
            index = self.parse_ifndef(index)
            return index
        except SyntaxError:
            pass
        index = self.parse_endif(index)

        return index

    def parse_include(self, index):
        if self.tokens[index].value != "include":
            self.error()

        if not self.token_is(index+1, STRING):
            self.error()
        file = self.tokens[index+1].value
        tokens = self.read_file(file)
        self.tokens = self.tokens[:index] + tokens + self.tokens[index + 2:]
        return index

    def parse_define(self, index):
        if self.tokens[index].value != "define":
            self.error()
        self.eat(index)

        if not self.token_is(index, ID):
            self.error()
        macro_name = self.tokens[index].value
        self.eat(index)

        macro_tokens = []
        while not self.token_is(index, NEWLINE):
            macro_tokens.append(self.tokens[index])
            self.eat(index)

        self.macros[macro_name] = macro_tokens

        return index

    def parse_undef(self, index):
        if self.tokens[index].value != "undef":
            self.error()
        self.eat(index)

        if not self.token_is(index, ID):
            self.error()
        macro_name = self.tokens[index].value
        self.eat(index)

        del self.macros[macro_name]
        return index

    def parse_ifdef(self, index):
        if self.tokens[index].value != "ifdef":
            self.error()
        self.eat(index)

        if not self.token_is(index, ID):
            self.error()
        macro_name = self.tokens[index].value
        self.eat(index)

        if self.macros.get(macro_name) is None:
            self.if_depth += 1
            while not self.token_is(index, EOF):
                self.eat(index)
                if self.token_is(index, HASH) and (self.token_is(index-1, NEWLINE) or index == 0):
                    self.eat(index)
                    if self.tokens[index].value.startswith("if"):
                        self.eat(index)
                        self.if_depth += 1
                    if self.tokens[index].value == "endif":
                        self.eat(index)
                        self.if_depth -= 1

                if self.if_depth == 0:
                    break
        else:
            self.if_depth += 1

        return index

    def parse_ifndef(self, index):
        if self.tokens[index].value != "ifndef":
            self.error()
        self.eat(index)

        if not self.token_is(index, ID):
            self.error()
        macro_name = self.tokens[index].value
        self.eat(index)

        if self.macros.get(macro_name) is not None:
            self.if_depth += 1
            while not self.token_is(index, EOF):
                self.eat(index)
                if self.token_is(index, HASH) and (self.token_is(index-1, NEWLINE) or index == 0):
                    self.eat(index)
                    if self.tokens[index].value.startswith("if"):
                        self.eat(index)
                        self.if_depth += 1
                    if self.tokens[index].value == "endif":
                        self.eat(index)
                        self.if_depth -= 1

                if self.if_depth == 0:
                    break
        else:
            self.if_depth += 1

        return index

    def parse_endif(self, index):
        if self.tokens[index].value != "endif":
            self.error()
        self.eat(index)
        self.if_depth -= 1

        return index

    @staticmethod
    def read_file(file):
        if os.path.exists(file):
            f = open(file)
        else:
            lib = os.path.join(os.path.dirname(__file__), "..", "lib", file)
            if os.path.exists(lib):
                f = open(lib)
            else:
                raise FileNotFoundError("Unable to find {} for the preprocessor".format(file))
        lex = lexer.Lexer(f.read())
        tokens = lex.tokenize()
        return tokens[:-1]

    def process(self):
        index = 0
        while not self.token_is(index, EOF):
            if self.token_is(index, HASH) and (self.token_is(index-1, NEWLINE) or index == 0):
                self.tokens = self.tokens[:index] + self.tokens[index+1:]
                index = self.parse_stmt(index)
            elif self.token_is(index, ID):
                if self.tokens[index].value in self.macros:
                    self.tokens = self.tokens[:index] + self.macros[self.tokens[index].value] + self.tokens[index + 1:]
                else:
                    index += 1
            else:
                index += 1

        if self.if_depth != 0:
            self.error()

        index = 0
        while not self.token_is(index, EOF):
            if self.token_is(index, NEWLINE):
                self.tokens = self.tokens[:index] + self.tokens[index+1:]
            else:
                index += 1

        return self.tokens
