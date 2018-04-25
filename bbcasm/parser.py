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

    def parse_default(self, index):
        self.error()

    def parse_INST(self, index):
        inst = self.tokens[index].value
        parse_inst = getattr(self, "parse_{}".format(inst.upper()), self.parse_default)
        return parse_inst(index+1)

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

    def parse_JMP(self, index):
        value, index = self.parse_mem(index)

        return insts.JMP(value), index

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

    def parse_DEC(self, index):
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

        return insts.DEC(value), index

    def parse_INC(self, index):
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

        return insts.INC(value), index

    def parse_ADC(self, index):
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

        return insts.ADC(value), index

    def parse_SBC(self, index):
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

        return insts.SBC(value), index

    def parse_ASL(self, index):
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

        return insts.ASL(value), index

    def parse_LSR(self, index):
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

        return insts.LSR(value), index

    def parse_ROL(self, index):
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

        return insts.ROL(value), index

    def parse_ROR(self, index):
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

        return insts.ROR(value), index

    def parse_CMP(self, index):
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

        return insts.CMP(value), index

    def parse_BCC(self, index):
        value, index = self.parse_mem(index)

        return insts.BCS(value), index

    def parse_BCS(self, index):
        value, index = self.parse_mem(index)

        return insts.BCS(value), index

    def parse_BNE(self, index):
        value, index = self.parse_mem(index)

        return insts.BNE(value), index

    def parse_BEQ(self, index):
        value, index = self.parse_mem(index)

        return insts.BEQ(value), index

    def parse_BMI(self, index):
        value, index = self.parse_mem(index)

        return insts.BMI(value), index

    def parse_BPL(self, index):
        value, index = self.parse_mem(index)

        return insts.BPL(value), index

    def parse_BVS(self, index):
        value, index = self.parse_mem(index)

        return insts.BVS(value), index

    def parse_BVC(self, index):
        value, index = self.parse_mem(index)

        return insts.BVC(value), index

    def parse_CLC(self, index):
        return insts.CLC(), index

    def parse_SEC(self, index):
        return insts.SEC(), index

    def parse_CLD(self, index):
        return insts.CLD(), index

    def parse_SED(self, index):
        return insts.SED(), index

    def parse_CLV(self, index):
        return insts.CLV(), index

    def parse_SEI(self, index):
        return insts.SEI(), index

    def parse_CLI(self, index):
        return insts.CLI(), index

    def parse_NOP(self, index):
        return insts.NOP(), index

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
