#include "stdio.h"
#include "debug.h"

static int simpleInstruction(const char* name, int offset);

void disassembleChunk(struct Chunk* chunk, const char* name) {
  printf("== %s ==\n", name);

  for (int i = 0; i < chunk->count;) {
    i = disassembleInstruction(chunk, i);
  }
}

int disassembleInstruction(struct Chunk* chunk, int offset) {
  printf("%04u ", offset);

  uint8_t instruction = chunk->code[offset];
  if (instruction == OP_RETURN) {
      return simpleInstruction("OP_RETURN", offset);
  } else {
      printf("Unknown opcode %d\n", instruction);
      return offset + 1;
  }
}

static int simpleInstruction(const char* name, int offset) {
  printf("%s\n", name);
  return offset + 1;
}