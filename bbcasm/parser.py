from . import insts
from .tokens import *


class Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.cur_label = None
        self.insts = []

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

    def parse_immediate(self, index):
        index = self.eat(index, HASH)
        if self.tokens[index].value > 255:
            self.error()
        return insts.LiteralVal(self.tokens[index].value), index + 1

    def parse_zero_page(self, index):
        if self.tokens[index].value > 255:
            self.error()
        return insts.ZpVal(self.tokens[index].value), index + 1

    def parse_mem(self, index):
        if self.tokens[index].type == ID:
            return insts.LabelVal(self.tokens[index].value), index + 1

        if self.tokens[index].value > 65535:
            self.error()
        return insts.MemVal(self.tokens[index].value), index + 1

    def parse_zp_x(self, index):
        value, index = self.parse_zero_page(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "X":
                return insts.ZpXVal(value), index + 1
        self.error()

    def parse_zp_y(self, index):
        value, index = self.parse_zero_page(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "X":
                return insts.ZpXVal(value), index + 1
        self.error()

    def parse_mem_x(self, index):
        value, index = self.parse_mem(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "X":
                return insts.MemXVal(value), index + 1
        self.error()
        self.error()

    def parse_mem_y(self, index):
        value, index = self.parse_mem(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "Y":
                return insts.MemYVal(value), index + 1
        self.error()

    def parse_y_indirect(self, index):
        index = self.eat(index, LPAREM)
        value, index = self.parse_zero_page(index)
        index = self.eat(index, RPAREM)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "Y":
                return insts.IndirectYVal(value), index + 1
        self.error()

    def parse_x_indirect(self, index):
        index = self.eat(index, LPAREM)
        value, index = self.parse_zero_page(index)
        index = self.eat(index, COMMA)
        if self.token_is(index, ID):
            if self.tokens[index].value == "X":
                return insts.IndirectXVal(value), self.eat(index + 1, RPAREM)
        self.error()

    def parse_INST(self, index):
        if self.tokens[index].value == "LDX":
            return self.parse_LDX(index + 1)
        elif self.tokens[index].value == "LDY":
            return self.parse_LDY(index + 1)
        elif self.tokens[index].value == "LDA":
            return self.parse_LDA(index + 1)
        elif self.tokens[index].value == "STA":
            return self.parse_STA(index + 1)

        elif self.tokens[index].value == "JSR":
            return self.parse_JSR(index + 1)
        elif self.tokens[index].value == "RTS":
            return self.parse_RTS(index + 1)

        elif self.tokens[index].value == "PHA":
            return self.parse_PHA(index + 1)
        elif self.tokens[index].value == "PLA":
            return self.parse_PLA(index + 1)
        elif self.tokens[index].value == "PHP":
            return self.parse_PHP(index + 1)
        elif self.tokens[index].value == "PLP":
            return self.parse_PLP(index + 1)

        elif self.tokens[index].value == "TAX":
            return self.parse_TAX(index + 1)
        elif self.tokens[index].value == "TXA":
            return self.parse_TXA(index + 1)
        elif self.tokens[index].value == "DEX":
            return self.parse_DEX(index + 1)
        elif self.tokens[index].value == "INX":
            return self.parse_INX(index + 1)

        elif self.tokens[index].value == "TAY":
            return self.parse_TAY(index + 1)
        elif self.tokens[index].value == "TYA":
            return self.parse_TYA(index + 1)
        elif self.tokens[index].value == "DEY":
            return self.parse_DEY(index + 1)
        elif self.tokens[index].value == "INY":
            return self.parse_INY(index + 1)
        return insts.NOP(), index + 1

    def parse_LDX(self, index):
        try:
            value, index = self.parse_immediate(index)
        except SyntaxError:
            try:
                value, index = self.parse_zero_page(index)
            except SyntaxError:
                try:
                    value, index = self.parse_zp_y(index)
                except SyntaxError:
                    try:
                        value, index = self.parse_mem(index)
                    except SyntaxError:
                        value, index = self.parse_mem_y(index)

        return insts.LDX(value), index

    def parse_LDY(self, index):
        try:
            value, index = self.parse_immediate(index)
        except SyntaxError:
            try:
                value, index = self.parse_zero_page(index)
            except SyntaxError:
                try:
                    value, index = self.parse_zp_x(index)
                except SyntaxError:
                    try:
                        value, index = self.parse_mem(index)
                    except SyntaxError:
                        value, index = self.parse_mem_x(index)

        return insts.LDY(value), index

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
                    try:
                        value, index = self.parse_zero_page(index)
                    except SyntaxError:
                        try:
                            value, index = self.parse_zp_x(index)
                        except SyntaxError:
                            try:
                                value, index = self.parse_mem(index)
                            except SyntaxError:
                                try:
                                    value, index = self.parse_mem_x(index)
                                except SyntaxError:
                                    value, index = self.parse_mem_y(index)

        return insts.LDA(value), index

    def parse_STA(self, index):
        try:
            value, index = self.parse_x_indirect(index)
        except SyntaxError:
            try:
                value, index = self.parse_y_indirect(index)
            except SyntaxError:
                try:
                    value, index = self.parse_zero_page(index)
                except SyntaxError:
                    try:
                        value, index = self.parse_zp_x(index)
                    except SyntaxError:
                        try:
                            value, index = self.parse_mem(index)
                        except SyntaxError:
                            try:
                                value, index = self.parse_mem_x(index)
                            except SyntaxError:
                                value, index = self.parse_mem_y(index)

        return insts.STA(value), index

    def parse_JSR(self, index):
        value, index = self.parse_mem(index)

        return insts.JSR(value), index

    def parse_RTS(self, index):
        return insts.RTS(), index

    def parse_PHA(self, index):
        return insts.PHA(), index

    def parse_PLA(self, index):
        return insts.PLA(), index

    def parse_PHP(self, index):
        return insts.PHP(), index

    def parse_PLP(self, index):
        return insts.PLP(), index

    def parse_TXA(self, index):
        return insts.TXA(), index

    def parse_TAX(self, index):
        return insts.TAX(), index

    def parse_DEX(self, index):
        return insts.DEX(), index

    def parse_INX(self, index):
        return insts.INX(), index

    def parse_TYA(self, index):
        return insts.TYA(), index

    def parse_TAY(self, index):
        return insts.TAY(), index

    def parse_DEY(self, index):
        return insts.DEY(), index

    def parse_INY(self, index):
        return insts.INY(), index

    def parse(self):
        index = 0
        while self.tokens[index].type != EOF:
            t = self.tokens[index]
            if t.type == ID:
                inst, index = self.parse_INST(index)
                if self.cur_label is not None:
                    inst.label = self.cur_label
                    self.cur_label = None
                self.insts.append(inst)
            elif t.type == LABEL:
                self.cur_label = t.value
                index += 1
            else:
                index += 1

        return self.insts
