#!/usr/bin/env bash

python3 ../main.py main.c && \
python3 ../main.py io.s && \
python3 ../main.py main.o io.o -static