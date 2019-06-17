# bbc-c
C compiler for the BBC Micro series of micros

The repository is aranged as such

| Folder | Contents |
|:------:|:--------:|
| `bbcasm` | 6502 assembler outputting a with a custom object file header |
| `bbcc` | the C compiler proper |
| `bbcdisk` | utilities for BBC Micro FDD disk images |
| `bbcld` | linker for said custom 6502 object files |
| `bbcnix` | the begginings of *nix for the Beeb (should probably have it's own repo) |
| `bbcpython` | a simple python interpreter for the Beeb (should also be in its own repo) |
| `bbctape` | utilities for BBC Micro tape images |
| `bbcvm` | a custom 32-bit x86-like virtual machine for the 6502 |
| `bbcvmasm` | an assembler for the custom VM |
| `bbcvmem` | a python GUI emulator implementing the VM's instruction set |
| `bbcvmld` | linker for the VM object files |
| `lib` | compiled C standard library |
| `lib_src`| source of the C standard library |
| `memory-expansion` | kicad files for a 24-bit bus memory expansion module for the Beeb |

## Usage

This project requires python 3.

`main.py` is the entrypoint for everything.
```
usage: main.py [-h] [-o OUTPUT] [-Wa [WA [WA ...]]] [-Wl [WL [WL ...]]] [-S]
               [-c] [-shared] [-static] [-strip] [-6502]
               files [files ...]

Compiler suite for the BBC Microcomputer

positional arguments:
  files                 Input files

optional arguments:
  -h, --help            show this help message and exit
  -o OUTPUT, --output OUTPUT
                        Output file name
  -Wa [WA [WA ...]]     Assembler options
  -Wl [WL [WL ...]]     Linker options
  -S                    Compile only
  -c                    Compile and assemble but do not link
  -shared               Create a shared library
  -static               Create a statically linked executable
  -strip                Strip names of internal symbols from executable header
  -6502                 Assemble and link (unable to compile) for 6502 instead of VM

``` 

If no output is specified the generated `.s` `.o` and `out` files be put in the current directory.
Otherwise the `out` (output executable) file will be the specified output file, and the `.s` and `.o` files
will go in the same directory as the output file.

All input files must have the same extension (of the same type).
If they are `.c` then they will be compiled (VM output only) assembled and linked (unless specified otherwise).
If they are `.s` then they will be assembled and linked (unless otherwise specified).
If they are `.o` then they will be linked.

## The VM

The VM is documented in greater detail in it's `bbcvm/instruction_set.md` file.
The 6502 implementation of the VM is in the `bbcvm/vm.s` file.

The `bbcvm/loader.s` file reads files from the BBC Micro filing system into the memory on the extender module,
connected to the system's expansion bus.

There is a python emulator for the VM that reads in files linked with both `-static` and `-shared` set.
The emulator requires WXPython.

## C standard library

The source of the current standard library is in `lib_src`. Compiled versions are in `lib`,
however if you wish to compile them again the `build-lib.sh` script exists.