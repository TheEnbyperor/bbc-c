import bbcc
import bbcasm
import bbcld
import sys
import os


def usage():
    print("Usage: {} [source files...]".format(sys.argv[0]))
    sys.exit(1)


def compile_c(text: str, name: str):
    asm = bbcc.main(text)
    asm_file = open("{}.s".format(name), "w")
    asm_file.write(asm)


def assemble_s(text: str, name: str):
    out = bbcasm.asm_to_object(text)
    obj_file = open("{}.o".format(name), "wb")
    obj_file.write(out)


def link_o(objs):
    out, exa = bbcld.link_object_files(objs, 0xE00)

    out_file = open("out", "wb")
    out_file.write(out)

    disk = bbcasm.object_to_disk("$.MAIN", out, 0xE00, exa)
    disk_file = open("out.ssd", "wb")
    disk_file.write(disk)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        usage()

    file_names = sys.argv[1:]

    source_files = []

    for f in file_names:
        try:
            sourceFile = open(f, "rb")
        except FileNotFoundError as e:
            print("Unable to load file {}".format(e))
            sys.exit(1)

        source_files.append(sourceFile.read())
        sourceFile.close()

    names = list(map(lambda f: os.path.splitext(os.path.basename(f)), file_names))

    first_e = names[0][1]
    for e in map(lambda n: n[1], names):
        if e != first_e:
            raise RuntimeError("All input files must be of same type")

    if first_e == ".c":
        for s, n in zip(source_files, names):
            compile_c(s.decode(), n[0])
    elif first_e == ".s":
        for s, n in zip(source_files, names):
            assemble_s(s.decode(), n[0])
    elif first_e == ".o":
        link_o(source_files)
