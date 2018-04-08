from .tokens import *
from . import lexer


class Preproc:
    def __init__(self, tokens):
        self.tokens = tokens
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

        index = self.parse_define(index)
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

    @staticmethod
    def read_file(file):
        f = open(file)
        source = "".join(f.readlines())
        lex = lexer.Lexer(source)
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

        index = 0
        while not self.token_is(index, EOF):
            if self.token_is(index, NEWLINE):
                self.tokens = self.tokens[:index] + self.tokens[index+1:]
            else:
                index += 1

        return self.tokens
