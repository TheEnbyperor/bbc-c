#include "chunk.h"
#include "debug.h"

int main() {
  struct Chunk chunk;

  initChunk(&chunk);

  int constant = addConstant(&chunk, 2);
  writeChunk(&chunk, OP_CONSTANT, 123);
  writeChunk(&chunk, constant, 123);

  writeChunk(&chunk, OP_RETURN, 123);

  disassembleChunk(&chunk, "test chunk");
  freeChunk(&chunk);

  return 0;
}