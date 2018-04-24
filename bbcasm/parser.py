from . import insts
from .tokens import *


class Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.insts = []

    def error(self):
        raise SyntaxError("Invalid syntax")

    def eat(self, index, token_type):
        if self.tokens[index].type == token_type:
            return index+1
        else:
            self.error()

    def token_is(self, index, token_type):
        if self.tokens[index].type == token_type:
            return True
        else:
            return False

    def parse_immediate(self, index):
        index = self.eat(index, HASH)
        return insts.LiteralVal(self.tokens[index].value), index+1

    def parse_zero_page(self, index):
        if self.tokens[index].value > 255:
            self.error()
        return insts.ZpVal(self.tokens[index].value), index+1

    def parse_mem(self, index):
        if self.tokens[index].value > 65535:
            self.error()
        return insts.MemVal(self.tokens[index].value), index+1

    def parse_y_indirect(self, index):
        index = self.eat(index, LPAREM)
        value, index = self.parse_zero_page(index)
        index = self.eat(index, RPAREM)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "Y":
                return insts.IndirectYVal(value), index+1
        self.error()

    def parse_x_indirect(self, index):
        index = self.eat(index, LPAREM)
        value, index = self.parse_zero_page(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "X":
                return insts.IndirectXVal(value), self.eat(index+1, RPAREM)
        self.error()

    def parse_ID(self, index):
        if self.tokens[index].value == "LDY":
            return self.parse_LDY(index+1)
        elif self.tokens[index].value == "LDA":
            return self.parse_LDA(index+1)
        return index

    def parse_LDY(self, index):
        try:
            value, index = self.parse_immediate(index)
        except SyntaxError:
            value, index = self.parse_zero_page(index)
        self.insts.append(insts.LDY(value))
        return index

    def parse_LDA(self, index):
        try:
            value, index = self.parse_x_indirect(index)
        except SyntaxError:
            try:
                value, index = self.parse_y_indirect(index)
            except SyntaxError:
                try:
                    value, index = self.parse_immediate(index)
                except SyntaxError:
                    value, index = self.parse_zero_page(index)

        self.insts.append(insts.LDA(value))
        return index

    def parse(self):
        index = 0
        while self.tokens[index].type != EOF:
            t = self.tokens[index]
            if t.type == ID:
                index = self.parse_ID(index+1)
            else:
                index += 1

        return self.insts
