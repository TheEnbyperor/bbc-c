#ifndef bbc_python_chunk_h
#define bbc_python_chunk_h

#include "common.h"
#include "memory.h"
#include "debug.h"
#include "value.h"

typedef uint8_t OpCode;
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

struct sChunk {
  ArrayMeta meta;
  uint8_t* code;
  ValueArray constants;
  LineInfoArray lineInfo;
};
typedef struct sChunk Chunk;

void initChunk(Chunk* chunk);
void freeChunk(Chunk* chunk);
void writeChunk(Chunk* chunk, uint8_t byte, unsigned int lineNum);
int addConstant(Chunk* chunk, struct Value *value);

#endif
