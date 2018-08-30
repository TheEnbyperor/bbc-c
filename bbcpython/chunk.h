#ifndef bbc_python_chunk_h
#define bbc_python_chunk_h

#include "common.h"
#include "debug.h"
#include "value.h"

#define OpCode uint8_t

#define OP_CONSTANT 0
#define OP_CONSTANT_LONG 1
#define OP_NEGATE 2
#define OP_ADD 3
#define OP_SUBTRACT 4
#define OP_MULTIPLY 5
#define OP_DIVIDE 6
#define OP_MODULUS 7
#define OP_RETURN 8
#define OP_NOT 9
#define OP_EQUAL 10
#define OP_GREATER 11
#define OP_LESS 12

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
int addConstant(struct Chunk* chunk, struct Value *value);

#endif
