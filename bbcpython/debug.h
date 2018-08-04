#ifndef bbc_python_debug_h
#define bbc_python_debug_h

#include "chunk.h"

void disassembleChunk(struct Chunk* chunk, const char* name);
int disassembleInstruction(struct Chunk* chunk, int i);

#endif