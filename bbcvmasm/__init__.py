from . import lexer
from . import parser
from . import assembler


def asm_to_object(asm):
    lex = lexer.Lexer(asm)
    tokens = lex.tokenize()

    parse = parser.Parser(tokens)
    ast = parse.parse()

    assemble = assembler.Assembler(ast)

    out = assemble.assemble()

    return out
