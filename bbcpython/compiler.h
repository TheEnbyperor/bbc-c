#ifndef bbc_python_compiler_h
#define bbc_python_compiler_h

#include "chunk.h"
#include "vm.h"

bool compile(const char* source, Chunk *chunk, VM *vm);

#endif