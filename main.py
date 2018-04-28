import bbcc
import bbcasm
import sys
import os


def usage():
    print("Usage: {} [source file]".format(sys.argv[0]))
    sys.exit(1)


def compile_c(text: str):
    asm = bbcc.main(text)
    asm_file = open("{}.s".format(name), "w")
    asm_file.write(asm)


def assemble_s(text: str):
    out = bbcasm.asm_to_object(text)
    obj_file = open("{}.o".format(name), "wb")
    obj_file.write(out)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        usage()

    file_name = sys.argv[1]

    if file_name == "":
        usage()

    try:
        sourceFile = open(file_name)
    except Exception as e:
        print("Unable to load file {}".format(e))
        sys.exit(1)

    source = sourceFile.read()

    name, extension = os.path.splitext(os.path.basename(file_name))

    if extension == ".c":
        compile_c(source)
    elif extension == ".s":
        assemble_s(source)

    # disk = bbcasm.object_to_disk("$.MAIN", out, 0xE00, exa)
    #
    # out_file = open("main.ssd", "wb")
    # out_file.write(disk)
