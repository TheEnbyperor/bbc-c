from .tokens import *
from . import ast


class Parser:
    def __init__(self, tokens):
        self.tokens = tokens

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

    def parse(self):
        index = 0
        items = []
        while True:
            try:
                item, index = self.parse_line(index)
                items.append(item)
            except SyntaxError:
                break

        if self.tokens[index:][0].type == EOF:
            return ast.TranslationUnit(items)
        else:
            self.error()

    def parse_line(self, index):
        try:
            return self.parse_command(index)
        except SyntaxError:
            try:
                return self.parse_label(index)
            except SyntaxError:
                return self.parse_inst(index)

    def parse_command(self, index):
        index = self.eat(index, PERIOD)
        try:
            return self.parse_export_command(index)
        except SyntaxError:
            self.error()

    def parse_export_command(self, index):
        if not self.token_is(index, ID):
            self.error()
        if self.tokens[index].value != "export":
            self.error()
        index += 1
        if not self.token_is(index, ID):
            self.error()
        return ast.ExportCommand(self.tokens[index].value), index + 1

    def parse_label(self, index):
        if not self.token_is(index, ID):
            self.error()
        index = self.eat(index + 1, COLON)
        return ast.Label(self.tokens[index-2].value), index

    def parse_inst(self, index):
        insts = [self.parse_push, self.parse_pop, self.parse_ret, self.parse_mov]

        for inst in insts:
            try:
                return inst(index)
            except SyntaxError:
                continue
        self.error()

    def parse_push(self, index):
        if not self.token_is(index, ID):
            self.error()
        if self.tokens[index].value != "push":
            self.error()
        value, index = self.parse_value(index + 1)
        return ast.Push(value), index

    def parse_pop(self, index):
        if not self.token_is(index, ID):
            self.error()
        if self.tokens[index].value != "pop":
            self.error()
        value, index = self.parse_value(index + 1)
        return ast.Pop(value), index

    def parse_ret(self, index):
        if not self.token_is(index, ID):
            self.error()
        if self.tokens[index].value != "ret":
            self.error()
        return ast.Ret(), index + 1

    def parse_mov(self, index):
        if not self.token_is(index, ID):
            self.error()
        if self.tokens[index].value != "mov":
            self.error()
        left, index = self.parse_value(index + 1)
        index = self.eat(index, COMMA)
        right, index = self.parse_value(index)
        return ast.Mov(left, right), index

    def parse_value(self, index):
        values = [self.parse_register_value, self.parse_literal_value]

        for val in values:
            try:
                return val(index)
            except SyntaxError:
                continue
        self.error()

    def parse_literal_value(self, index):
        index = self.eat(index, HASH)
        if not self.token_is(index, ID):
            self.error()
        num = int(self.tokens[index].value)
        return ast.LiteralValue(num), index + 1

    def parse_register_value(self, index):
        index = self.eat(index, PERCENT)
        if not self.token_is(index, ID):
            self.error()
        reg = self.tokens[index].value
        if reg[0] != "r":
            self.error()
        reg_num = int(reg[1:])
        return ast.RegisterValue(reg_num), index + 1
