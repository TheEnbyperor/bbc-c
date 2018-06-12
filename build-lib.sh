#!/usr/bin/env bash

python3 main.py lib_src/ctype.c
python3 main.py lib_src/stdio.c
python3 main.py lib_src/stdlib.c
python3 main.py lib_src/string.c
python3 main.py lib_src/stdio.o lib_src/stdioasm.o lib_src/stdlib.o lib_src/string.o lib_src/ctype.o -o lib/libc.o -shared -strip