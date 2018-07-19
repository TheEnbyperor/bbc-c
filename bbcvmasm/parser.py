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

    def eat_id(self, index, value):
        if self.tokens[index].type == ID and self.tokens[index].value == value:
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
        values = [self.parse_export_command, self.parse_import_command, self.parse_bytes_command]

        for val in values:
            try:
                return val(index)
            except SyntaxError:
                continue
        self.error()

    def parse_export_command(self, index):
        index = self.eat_id(index, "export")
        if not self.token_is(index, ID):
            self.error()
        return ast.ExportCommand(self.tokens[index].value), index + 1

    def parse_import_command(self, index):
        index = self.eat_id(index, "import")
        if not self.token_is(index, ID):
            self.error()
        return ast.ImportCommand(self.tokens[index].value), index + 1

    def parse_bytes_command(self, index):
        index = self.eat_id(index, "byte")
        vals = []
        while True:
            try:
                val, index = self.parse_value(index)
                vals.append(val)
                index = self.eat(index, COMMA)
            except SyntaxError:
                break
        return ast.Bytes(vals), index

    def parse_label(self, index):
        if not self.token_is(index, ID):
            self.error()
        index = self.eat(index + 1, COLON)
        return ast.Label(self.tokens[index-2].value), index

    def parse_inst(self, index):
        insts = [self.parse_push, self.parse_pop, self.parse_ret, self.parse_call, self.parse_calln, self.parse_mov,
                 self.parse_add, self.parse_exit]

        for inst in insts:
            try:
                return inst(index)
            except SyntaxError:
                continue
        self.error()

    def parse_push(self, index):
        index = self.eat_id(index, "push")
        value, index = self.parse_value(index)
        return ast.Push(value), index

    def parse_pop(self, index):
        index = self.eat_id(index, "pop")
        value, index = self.parse_value(index)
        return ast.Pop(value), index

    def parse_ret(self, index):
        index = self.eat_id(index, "ret")
        return ast.Ret(), index

    def parse_exit(self, index):
        index = self.eat_id(index, "exit")
        return ast.Exit(), index

    def parse_call(self, index):
        index = self.eat_id(index, "call")
        value, index = self.parse_value(index)
        return ast.Call(value), index

    def parse_calln(self, index):
        index = self.eat_id(index, "calln")
        left, index = self.parse_value(index)
        index = self.eat(index, COMMA)
        right, index = self.parse_value(index)
        return ast.Calln(left, right), index

    def parse_mov(self, index):
        index = self.eat_id(index, "mov")
        left, index = self.parse_value(index)
        index = self.eat(index, COMMA)
        right, index = self.parse_value(index)
        return ast.Mov(left, right), index

    def parse_add(self, index):
        index = self.eat_id(index, "add")
        left, index = self.parse_value(index)
        index = self.eat(index, COMMA)
        right, index = self.parse_value(index)
        return ast.Add(left, right), index

    def parse_value(self, index):
        values = [self.parse_register_value, self.parse_literal_value, self.parse_mem_value]

        for val in values:
            try:
                return val(index)
            except SyntaxError:
                continue
        self.error()

    def parse_literal_value(self, index):
        index = self.eat(index, HASH)
        if not self.token_is(index, INTEGER):
            self.error()
        num = self.tokens[index].value
        return ast.LiteralValue(num), index + 1

    def parse_literal_mem_value(self, index):
        if not self.token_is(index, INTEGER):
            self.error()
        num = self.tokens[index].value
        return ast.LiteralValue(num), index + 1

    def parse_label_value(self, index):
        if not self.token_is(index, ID):
            self.error()
        label = self.tokens[index].value
        return ast.LabelValue(label), index + 1

    def parse_register_value(self, index):
        index = self.eat(index, PERCENT)
        if not self.token_is(index, ID):
            self.error()
        reg = self.tokens[index].value
        if reg[0] != "r":
            self.error()
        reg_num = int(reg[1:])
        return ast.RegisterValue(reg_num), index + 1

    def parse_mem_value(self, index):
        length = 2
        if self.token_is(index, BYTE):
            length = 1
            index += 1
        elif self.token_is(index, WORD):
            index += 1

        def get_const_loc(index):
            try:
                return self.parse_label_value(index)
            except SyntaxError:
                try:
                    return self.parse_literal_mem_value(index)
                except SyntaxError:
                    return None, index

        const_loc, index = get_const_loc(index)
        reg_indirect = None
        if self.token_is(index, LBRACE):
            index += 1
            seen_const = False
            if const_loc is None:
                const_loc, index = get_const_loc(index)
                seen_const = True
            seen_plus = False
            try:
                if seen_const:
                    index = self.eat(index, PLUS)
                    seen_plus = True
            except SyntaxError:
                pass
            try:
                reg_indirect, index = self.parse_value(index)
            except SyntaxError:
                pass
            if seen_plus and reg_indirect is None:
                self.error()
            index = self.eat(index, RBRACE)
        if const_loc is None and reg_indirect is None:
            self.error()
        return ast.MemoryValue(const_loc, reg_indirect, length), index
