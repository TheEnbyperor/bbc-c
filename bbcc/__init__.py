from .lexer import Lexer
from .parser import Parser
from .asm import ASM
from .interpreter import Interpreter
from .symbols import SymbolTableBuilder
import pdb


def main(text: str):
    lexer_inst = Lexer(text)
    token_list = lexer_inst.tokenize()

    p = Parser(token_list)
    ast_out = p.parse()

    symbol_table_b = SymbolTableBuilder()
    symbol_table_b.visit(ast_out)
    symbol_table = symbol_table_b.scope_out

    casm = ASM()
    interp = Interpreter(casm, symbol_table)

    asm_out = interp.interpret(ast_out)

    return asm_out
