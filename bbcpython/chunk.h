#ifndef bbc_python_chunk_h
#define bbc_python_chunk_h

#include "common.h"
#include "value.h"
#include "debug.h"

#define OpCode uint8_t

#define OP_CONSTANT 0
#define OP_CONSTANT_LONG 1
#define OP_RETURN 2

struct Chunk {
  unsigned int count;
  unsigned int capacity;
  uint8_t* code;
  struct ValueArray constants;
  struct LineInfoArray lineInfo;
};

void initChunk(struct Chunk* chunk);
void freeChunk(struct Chunk* chunk);
void writeChunk(struct Chunk* chunk, uint8_t byte, unsigned int lineNum);
int addConstant(struct Chunk* chunk, Value value);

#endif
