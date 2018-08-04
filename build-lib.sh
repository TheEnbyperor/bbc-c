#!/usr/bin/env bash

python3 main.py lib_src/ctype.c
python3 main.py lib_src/stdio.c
python3 main.py lib_src/stdlib.c
python3 main.py lib_src/string.c
python3 main.py lib_src/stdioasm.s
python3 main.py lib_src/stdio.o lib_src/stdlib.o lib_src/ctype.o lib_src/stdioasm.o lib_src/string.o -o lib/libc.o -shared -strip

python3 main.py lib_src/start.s
python3 main.py lib_src/start.o -o lib/start.o -shared -strip