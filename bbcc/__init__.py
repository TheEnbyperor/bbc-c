from .lexer import Lexer
from .parser import Parser
from .asm import ASM
from .interpreter import Interpreter
from .symbols import SymbolTableBuilder
from .il import IL
from .preproc import Preproc


def main(text: str):
    lexer_inst = Lexer(text)
    token_list = lexer_inst.tokenize()

    pre = Preproc(token_list)
    token_list = pre.process()

    p = Parser(token_list)
    ast_out = p.parse()

    symbol_table_builder = SymbolTableBuilder()
    symbol_table_builder.visit(ast_out)
    symbol_table = symbol_table_builder.scope_out

    asm_code = ASM()
    il = IL(symbol_table, asm_code)
    interp = Interpreter(symbol_table, il)

    il_out = interp.interpret(ast_out)

    il_out.gen_asm()

    return asm_code.get_asm()
