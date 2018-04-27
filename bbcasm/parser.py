from . import insts
from .tokens import *
import sys
import inspect


class Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.cur_labels = []
        self.insts = []
        self.ops = {}
        clsmembers = inspect.getmembers(sys.modules[insts.__name__], inspect.isclass)
        for c in clsmembers:
            if issubclass(c[1], insts.Inst):
                self.ops[c[0]] = c[1]

    def error(self):
        raise SyntaxError("Invalid syntax")

    def eat(self, index, token_type):
        if self.tokens[index].type == token_type:
            return index + 1
        else:
            self.error()

    def token_is(self, index, token_type):
        if self.tokens[index].type == token_type:
            return True
        else:
            return False

    def parse_LiteralVal(self, index):
        index = self.eat(index, HASH)
        if type(self.tokens[index].value) != int:
            self.error()
        if self.tokens[index].value > 255:
            self.error()
        return insts.LiteralVal(self.tokens[index].value), index + 1

    def parse_AccumulatorVal(self, index):
        if self.token_is(index, ID):
            if self.tokens[index].value == "A":
                return insts.AccumulatorVal(), index + 1
        self.error()

    def parse_ZpVal(self, index):
        if type(self.tokens[index].value) != int:
            self.error()
        if self.tokens[index].value > 255:
            self.error()
        return insts.ZpVal(self.tokens[index].value), index + 1

    def parse_MemVal(self, index):
        if self.tokens[index].type == ID:
            return insts.LabelVal(self.tokens[index].value), index + 1

        if type(self.tokens[index].value) != int:
            self.error()
        if self.tokens[index].value > 65535:
            self.error()
        return insts.MemVal(self.tokens[index].value), index + 1

    def parse_ZpXVal(self, index):
        value, index = self.parse_ZpVal(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "X":
                return insts.ZpXVal(value.loc), index + 1
        self.error()

    def parse_ZpYVal(self, index):
        value, index = self.parse_ZpVal(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "X":
                return insts.ZpXVal(value.loc), index + 1
        self.error()

    def parse_MemXVal(self, index):
        value, index = self.parse_MemVal(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "X":
                return insts.MemXVal(value.loc), index + 1
        self.error()
        self.error()

    def parse_MemYVal(self, index):
        value, index = self.parse_MemVal(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "Y":
                return insts.MemYVal(value.loc), index + 1
        self.error()

    def parse_IndirectVal(self, index):
        index = self.eat(index, LPAREM)
        value, index = self.parse_MemVal(index)
        index = self.eat(index, RPAREM)
        return insts.IndirectVal(value.loc), index

    def parse_IndirectYVal(self, index):
        index = self.eat(index, LPAREM)
        value, index = self.parse_ZpVal(index)
        index = self.eat(index, RPAREM)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "Y":
                return insts.IndirectYVal(value.loc), index + 1
        self.error()

    def parse_IndirectXVal(self, index):
        index = self.eat(index, LPAREM)
        value, index = self.parse_ZpVal(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "X":
                return insts.IndirectXVal(value.loc), self.eat(index + 1, RPAREM)
        self.error()

    def parse_default(self, index):
        self.error()

    def parse_inst(self, index):
        inst = self.tokens[index].value
        op = self.ops.get(inst.upper())

        if op is None:
            self.error()

        if len(op.modes) > 0:
            value = None
            for m in op.modes:
                try:
                    parser = getattr(self, "parse_{}".format(m[0].__name__), self.parse_default)
                    value, index = parser(index+1)
                    break
                except SyntaxError:
                    pass

            if value is None:
                self.error()

            return op(value), index

        return op(), index+1

    def parse(self):
        index = 0
        while self.tokens[index].type != EOF:
            t = self.tokens[index]
            if t.type == ID:
                inst, index = self.parse_inst(index)
                if len(self.cur_labels) > 0:
                    inst.labels = self.cur_labels
                    self.cur_labels = []
                self.insts.append(inst)
            elif t.type == LABEL:
                self.cur_labels.append(t.value)
                index += 1
            else:
                index += 1

        return self.insts
