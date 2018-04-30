import bbcc
import bbcasm
import bbcld
import bbcdisk
import sys
import os
import argparse


def compile_c(text: str, out: str):
    asm = bbcc.main(text)
    asm_file = open(out, "w")
    asm_file.write(asm)


def assemble_s(text: str, name: str):
    out = bbcasm.asm_to_object(text)
    obj_file = open("{}.o".format(name), "wb")
    obj_file.write(out)


def link_o(objs):
    out, exa = bbcld.link_object_files(objs, 0xE00)

    out_file = open("out", "wb")
    out_file.write(out)


def make_disk(files):
    files = map(lambda f: bbcdisk.File(f[0], f[1], 0xE00, 0xE00), files)
    disk = bbcdisk.files_to_disk(files)
    disk_file = open("out.ssd", "wb")
    disk_file.write(disk)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Compiler suite for the BBC Microcomputer')
    parser.add_argument("-o", "--output", help="Output file name", type=str)
    parser.add_argument("-Wa", nargs="*", help="Assembler options", type=str)
    parser.add_argument("-Wl", nargs="*", help="Linker options", type=str)
    parser.add_argument("-S", help="Compile only", action="store_true")
    parser.add_argument("-c", help="Compile and assemble but do not link", action="store_true")
    parser.add_argument("files", nargs="+", help="Input files", type=str)

    args = parser.parse_args()

    source_files = []

    for f in args.files:
        try:
            sourceFile = open(f, "rb")
        except FileNotFoundError as e:
            print("Unable to load file {}".format(e))
            sys.exit(1)

        source_files.append(sourceFile.read())
        sourceFile.close()

    names = list(map(lambda f: os.path.splitext(os.path.basename(f)), args.files))

    first_e = names[0][1]
    for e in map(lambda n: n[1], names):
        if e != first_e:
            raise RuntimeError("All input files must be of same type")

    if first_e == ".c":
        for s, n in zip(source_files, names):
            if args.output == "":
                name = "{}.s".format(n[0])
            else:
                name = args.output
            compile_c(s.decode(), name)
    elif first_e == ".s":
        for s, n in zip(source_files, names):
            assemble_s(s.decode(), n[0])
    elif first_e == ".o":
        link_o(source_files)
