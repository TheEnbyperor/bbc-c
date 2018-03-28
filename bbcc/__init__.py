from .lexer import Lexer
from .parser import Parser
from .asm import ASM
from .interpreter import Interpreter
from .symbols import SymbolTableBuilder
from .il import IL


def main(text: str):
    lexer_inst = Lexer(text)
    token_list = lexer_inst.tokenize()

    p = Parser(token_list)
    ast_out = p.parse()

    symbol_table_builder = SymbolTableBuilder()
    symbol_table_builder.visit(ast_out)
    symbol_table = symbol_table_builder.scope_out
    il = IL()
    interp = Interpreter(symbol_table, il)

    il_out = interp.interpret(ast_out)

    asm_code = ASM()
    il_out.gen_asm(asm_code)

    return asm_code.get_asm()
