import bbcc
import bbcasm
import sys


def usage():
    print("Usage {} [source c file]".format(sys.argv[0]))
    sys.exit(1)


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

    source = "".join(sourceFile.readlines())

    asm = bbcc.main(source)

    libc = open("libc.s")
    libc_asm = "".join(libc.readlines())

    asm = libc_asm + "\n" + asm

    print(asm)

    out = bbcasm.asm_to_object(asm)
    print(out)
