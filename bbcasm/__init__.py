from .lexer import Lexer
from .parser import Parser
from .asm import Assemble
from .tools import makedfs


def asm_to_object(asm):
    lexer_inst = Lexer(asm)
    token_list = lexer_inst.tokenize()

    parser = Parser(token_list)
    prog = parser.parse()

    assembler = Assemble(prog)
    assembler.fill_labels()

    out, exa = assembler.assemble()
    return bytes(out), exa


def object_to_disk(name, obj, lda, exa):
    disk = makedfs.Disk()
    disk.new()

    cat = disk.catalogue()
    files = [makedfs.File(name, obj, lda, exa)]
    cat.write("", files)

    disk.file.seek(0, 0)
    return disk.file.read()


def asm_to_basic(asm):
    asm = asm.splitlines()
    out = "NEW\n"
    start_lines = [
        "DIM MC% {}".format(
            len([line for line in asm if line != "" and not line.startswith(".") and not line.startswith("\\")]) * 3),
        "FOR opt%=0 TO 2 STEP 2",
        "P%=&E00",
        "[",
        "OPT opt%",
    ]
    end_lines = [
        "]",
        "NEXT opt%",
        "PRINT ~_start",
        "CALL _start",
        "RH=&71",
        "RL=&70",
        "PRINT ~?RH,~?RL",
    ]
    for i, line in enumerate(start_lines + asm + end_lines):
        out += str(i) + " " + line.strip() + "\n"

    return out
