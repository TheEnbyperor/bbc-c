from .lexer import Lexer
from .parser import Parser
from .asm import ASM
from .interpreter import Interpreter
from .symbols import SymbolTableBuilder
import pdb


def main(text):
    l = Lexer(text)
    token_list = l.tokenize()

    p = Parser(token_list)
    ast_out = p.parse()
    
    pdb.set_trace()

    symbol_table_b = SymbolTableBuilder()
    symbol_table_b.visit(ast_out)
    symbol_table = symbol_table_b.scope_out

    casm = ASM()
    interp = Interpreter(casm, symbol_table)

    asm_out = interp.interpret(ast_out)

    print(asm_out)
