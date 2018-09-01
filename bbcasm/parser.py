from . import insts
from .tokens import *
import sys
import inspect


class Prog:
    insts = []
    imports = []
    exports = []
    end_labels = []

    def __int__(self, insts=None, imports=None, exports=None):
        if exports is None:
            exports = []
        if imports is None:
            imports = []
        if insts is None:
            insts = []

        self.insts = insts
        self.imports = imports
        self.exports = exports


class Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.cur_labels = []

        self.ops = {}
        clsmembers = inspect.getmembers(sys.modules[insts.__name__], inspect.isclass)
        for c in clsmembers:
            if issubclass(c[1], insts.Inst):
                self.ops[c[0]] = c[1]

        self.prog = Prog()

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
        if self.tokens[index].type == INTEGER:
            offset = self.tokens[index].value
            if self.tokens[index+1].type == LPAREM:
                index = self.eat(index+1, LPAREM)
                if self.tokens[index].type == ID:
                    name = self.tokens[index].value
                    loc_offset = 0
                    index += 1
                    if self.tokens[index].type in [PLUS, MINUS]:
                        index += 1
                        if not self.tokens[index].type == INTEGER:
                            self.error()
                        loc_offset = self.tokens[index].value
                        if self.tokens[index-1].type == MINUS:
                            loc_offset = -loc_offset
                    index = self.eat(index+1, RPAREM)
                    return insts.LabelAddrVal(name, offset=offset, loc_offset=loc_offset), index
                else:
                    self.error()
            else:
                if self.tokens[index].value > 255:
                    self.error()
                return insts.LiteralVal(self.tokens[index].value), index + 1
        self.error()

    def parse_AccumulatorVal(self, index):
        if self.token_is(index, ID):
            if self.tokens[index].value.upper() == "A":
                return insts.AccumulatorVal(), index + 1
        self.error()

    def parse_ZpVal(self, index):
        if self.tokens[index].type != INTEGER:
            self.error()
        if self.tokens[index].value > 255:
            self.error()
        if self.tokens[index+1].type == LPAREM:
            self.error()
        return insts.ZpVal(self.tokens[index].value), index + 1

    def parse_MemVal(self, index):
        if self.tokens[index].type == ID:
            return insts.MemVal(insts.LabelVal(self.tokens[index].value)), index + 1
        if self.tokens[index].type == INTEGER:
            offset = self.tokens[index].value
            if self.tokens[index+1].type == LPAREM:
                index = self.eat(index+1, LPAREM)
                if self.tokens[index].type == ID:
                    name = self.tokens[index].value
                    index = self.eat(index+1, RPAREM)
                    return insts.MemVal(insts.LabelVal(name, offset=offset)), index
                else:
                    self.error()
            else:
                if self.tokens[index].value > 65535:
                    self.error()
                return insts.MemVal(self.tokens[index].value), index + 1
        self.error()

    def parse_ZpXVal(self, index):
        value, index = self.parse_ZpVal(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value.upper() == "X":
                return insts.ZpXVal(value.loc), index + 1
        self.error()

    def parse_ZpYVal(self, index):
        value, index = self.parse_ZpVal(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value.upper() == "Y":
                return insts.ZpYVal(value.loc), index + 1
        self.error()

    def parse_MemXVal(self, index):
        value, index = self.parse_MemVal(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value.upper() == "X":
                return insts.MemXVal(value.loc), index + 1
        self.error()

    def parse_MemYVal(self, index):
        value, index = self.parse_MemVal(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value.upper() == "Y":
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
            if self.tokens[index].value.upper() == "Y":
                return insts.IndirectYVal(value.loc), index + 1
        self.error()

    def parse_IndirectXVal(self, index):
        index = self.eat(index, LPAREM)
        value, index = self.parse_ZpVal(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value.upper() == "X":
                return insts.IndirectXVal(value.loc), self.eat(index + 1, RPAREM)
        self.error()

    def parse_default(self, index):
        self.error()

    def parse_inst(self, index):
        inst = self.tokens[index].value
        op = self.ops.get(inst.upper())

        if op is None:
            raise SyntaxError("Unknown instruction: {}".format(inst))
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

    def parse_cmd(self, index):
        cmd = self.tokens[index].value

        parser = getattr(self, "parse_cmd_{}".format(cmd), self.parse_default)
        index = parser(index + 1)

        return index

    def parse_cmd_export(self, index):
        if self.token_is(index, ID):
            self.prog.exports.append(self.tokens[index].value)
            return index + 1
        self.error()

    def parse_cmd_import(self, index):
        if self.token_is(index, ID):
            self.prog.imports.append(self.tokens[index].value)
            return index + 1
        self.error()

    def parse_cmd_byte(self, index):
        nums = []
        while True:
            num, index = self.parse_LiteralVal(index)
            inst = insts.Byte(num)
            nums.append(inst)
            if self.token_is(index, COMMA):
                index += 1
            else:
                break
        if len(self.cur_labels) > 0:
            nums[0].labels = self.cur_labels
            self.cur_labels = []
        self.prog.insts.extend(nums)
        return index

    def parse(self):
        index = 0
        while self.tokens[index].type != EOF:
            t = self.tokens[index]
            if t.type == ID:
                inst, index = self.parse_inst(index)
                if len(self.cur_labels) > 0:
                    inst.labels = self.cur_labels
                    self.cur_labels = []
                self.prog.insts.append(inst)

            elif t.type == LABEL:
                self.cur_labels.append(t.value)
                index += 1

            elif t.type == PERIOD:
                index = self.parse_cmd(index+1)

            else:
                self.error()

        if len(self.cur_labels) > 0:
            self.prog.end_labels = self.cur_labels

        return self.prog
