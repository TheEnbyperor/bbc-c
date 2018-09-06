import bbcc
import bbcasm
import bbcvmasm
import bbcld
import bbcvmld
import bbcdisk
import bbctape
import sys
import os
import argparse
import wave


def compile_c(text: str, out: str):
    asm = bbcc.main(text)
    asm_file = open(out, "w")
    asm_file.write(asm)


def assemble_s(text: str, name: str, arg):
    if getattr(arg, "6502", False):
        out = bbcasm.asm_to_object(text)
    else:
        out = bbcvmasm.asm_to_object(text)
    obj_file = open(name, "wb")
    obj_file.write(out)


def link_o(arg, *args, **kwargs):
    if arg.static and arg.shared:
        link_o_static_shared(arg, *args, **kwargs)
    elif arg.static:
        link_o_static(arg, *args, **kwargs)
    elif arg.shared:
        link_o_shared(arg, *args, **kwargs)


def link_o_static(arg, objs, name: str):
    exa = 0
    if getattr(arg, "6502", False):
        out, exa = bbcld.link_object_files_static(objs, 0x1900)
    else:
        out = bbcvmld.link_object_files_static(objs)

    out_file = open(name, "wb")
    out_file.write(out)

    if getattr(arg, "6502", False):
        make_tape(name, name, 0x1900, exa, out)
        make_disk([("$.{}".format(name.upper()), out, 0x1900, exa)], name)
    else:
        make_disk_with_vm([("$.{}".format(name.upper()), out)], name)


def link_o_static_shared(arg, objs, name: str):
    if not getattr(arg, "6502", False):
        out = bbcvmld.link_object_files_shared(objs, arg.strip, True)

        out_file = open(name, "wb")
        out_file.write(out)


def link_o_shared(arg, objs, name: str):
    if getattr(arg, "6502", False):
        out = bbcld.link_object_files_shared(objs, arg.strip)
    else:
        out = bbcvmld.link_object_files_shared(objs, arg.strip)

    out_file = open(name, "wb")
    out_file.write(out)


def make_tape(name, file, lda, exa, data):
    w = wave.open("{}.wav".format(name), "w")
    bbctape.make_file(w, file, lda, exa, 0, data)


def make_disk(files, out):
    files = list(map(lambda f: bbcdisk.File(f[0], f[1], f[2], f[3]), files))
    disk = bbcdisk.files_to_disk(files)
    disk_file = open("{}.ssd".format(out), "wb")
    disk_file.write(disk)


def make_disk_with_vm(files, out):
    files = list(map(lambda f: (f[0], f[1], 0, 0), files))
    vm_dir = os.path.join(os.path.dirname(__file__), "bbcvm")
    loader_file = os.path.join(vm_dir, "loader")
    vm_file = os.path.join(vm_dir, "vm")
    with open(loader_file, 'rb') as l:
        loader = bytes(l.read())
    with open(vm_file, 'rb') as v:
        vm = bytes(v.read())
    files += (("$.LOADER", loader, 0x1900, 0x1900),)
    files += (("$.VM", vm, 0x1900, 0x1900),)
    make_disk(files, out)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Compiler suite for the BBC Microcomputer')
    parser.add_argument("-o", "--output", help="Output file name", type=str)
    parser.add_argument("-Wa", nargs="*", help="Assembler options", type=str)
    parser.add_argument("-Wl", nargs="*", help="Linker options", type=str)
    parser.add_argument("-S", help="Compile only", action="store_true")
    parser.add_argument("-c", help="Compile and assemble but do not link", action="store_true")
    parser.add_argument("-shared", help="Create a shared library", action="store_true")
    parser.add_argument("-static", help="Create a statically linked executable", action="store_true")
    parser.add_argument("-strip", help="Strip names of internal symbols", action="store_true")
    parser.add_argument("-6502", help="Assemble and link (not compile) for 6502 instead of VM", action="store_true")
    parser.add_argument("files", nargs="+", help="Input files", type=str)

    args = parser.parse_args()

    source_files = []

    for f in args.files:
        try:
            sourceFile = open(f, "rb")
        except FileNotFoundError as e:
            print("Unable to load file {}".format(e))
            sys.exit(1)

        source_files.append((os.path.splitext(f), sourceFile.read()))
        sourceFile.close()

    first_e = source_files[0][0][1]
    for e in map(lambda name: name[0][1], source_files):
        if e != first_e:
            raise RuntimeError("All input files must be of same type")

    if first_e == ".c":
        for n, s in source_files:
            if args.output is None or not args.S:
                name = "{}.s".format(n[0])
            else:
                name = args.output
            compile_c(s.decode(), name)

            if not args.S:
                sourceFile = open(name, "r")
                if args.output is None or not args.c:
                    name = "{}.o".format(n[0])
                else:
                    name = args.output
                assemble_s(sourceFile.read(), name, args)
                sourceFile.close()

        if not args.c and not args.S:
            files = []
            for n, s in source_files:
                name = "{}.o".format(n[0])
                sourceFile = open(name, "rb")
                files.append(sourceFile.read())
                sourceFile.close()
            if args.output is None:
                name = "out"
            else:
                name = args.output

            link_o(args, files, name)
    elif first_e == ".s":
        if args.S:
            raise RuntimeError("Cant just compile assembly")
        for n, s in source_files:
            if args.output is None or not args.c:
                name = "{}.o".format(n[0])
            else:
                name = args.output
            assemble_s(s.decode(), name, args)

        if not args.c and not args.S:
            files = []
            for n, s in source_files:
                name = "{}.o".format(n[0])
                sourceFile = open(name, "rb")
                files.append(sourceFile.read())
                sourceFile.close()
            if args.output is None:
                name = "out"
            else:
                name = args.output

            link_o(args, files, name)
    elif first_e == ".o":
        if args.S or args.c:
            raise RuntimeError("Cant just compile or assemble object file")

        if args.output is None:
            name = "out"
        else:
            name = args.output

        link_o(args, map(lambda s: s[1], source_files), name)
