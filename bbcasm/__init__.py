from .lexer import Lexer
from .parser import Parser
from .asm import Assemble


def asm_to_object(asm):
    lexer_inst = Lexer(asm)
    token_list = lexer_inst.tokenize()

    parser = Parser(token_list)
    prog = parser.parse()

    assembler = Assemble(prog)
    assembler.fill_labels()

    out = assembler.assemble()
    return bytes(out)
