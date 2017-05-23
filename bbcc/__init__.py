from .lexer import Lexer
from .parser import Parser
from .asm import ASM
#from .interpreter import Interpreter
from .symbols import SymbolTableBuilder
import pdb


def main(text):
    l = Lexer(text)
    token_list = l.tokenize()

    p = Parser(token_list)
    ast_out = p.parse()

    # pdb.set_trace()

    # casm = ASM()
    # interp = Interpreter(casm)
    #
    # asm_out = interp.interpret(ast_out)

    symbol_table = SymbolTableBuilder()
    symbol_table.visit(ast_out)

    print(symbol_table)
