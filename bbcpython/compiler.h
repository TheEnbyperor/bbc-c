#ifndef bbc_python_compiler_h
#define bbc_python_compiler_h

#include "chunk.h"

bool compile(const char* source, struct Chunk *chunk);

#endif