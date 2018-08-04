#ifndef bbc_python_chunk_h
#define bbc_python_chunk_h

#include "common.h"

#define OpCode uint8_t
#define OP_RETURN 0

struct Chunk {
  int count;
  int capacity;
  uint8_t* code;
};

void initChunk(struct Chunk* chunk);
void freeChunk(struct Chunk* chunk);
void writeChunk(struct Chunk* chunk, uint8_t byte);

#endif
