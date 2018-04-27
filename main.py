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

    # libc = open("libc.s")
    # libc_asm = "".join(libc.readlines())
    #
    # asm = libc_asm + "\n" + asm

    asm_file = open("main.s", "w")
    asm_file.write(asm)

    basic = bbcasm.asm_to_basic(asm)
    # print(basic)

    out, exa = bbcasm.asm_to_object(asm)

    obj_file = open("main.o", "wb")
    obj_file.write(out)

    disk = bbcasm.object_to_disk("$.MAIN", out, 0xE00, exa)

    out_file = open("main.ssd", "wb")
    out_file.write(disk)
