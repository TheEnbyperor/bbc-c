#include "chunk.h"
#include "debug.h"
#include "vm.h"

int main() {
  struct VM vm;
  struct Chunk chunk;

  initVM(&vm);
  initChunk(&chunk);

  int constant = addConstant(&chunk, 2);
  writeChunk(&chunk, OP_CONSTANT, 123);
  writeChunk(&chunk, constant, 123);

  writeChunk(&chunk, OP_RETURN, 123);

  disassembleChunk(&chunk, "test chunk");

  interpret(&vm, &chunk);

  freeVM(&vm);
  freeChunk(&chunk);

  return 0;
}