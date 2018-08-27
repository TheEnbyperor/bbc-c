#include "debug.h"
#include "common.h"
#include "memory.h"

void initLineInfoArray(struct LineInfoArray* array) {
  array->lineInfo = NULL;
  array->capacity = 0;
  array->count = 0;
}

void writeLineInfoArray(struct LineInfoArray* array, struct LineInfo* value) {
  if (array->capacity < array->count + 1) {
    int oldCapacity = array->capacity;
    array->capacity = growCapacity(oldCapacity);
    array->lineInfo = (struct LineInfo*)reallocate(array->lineInfo, array->capacity * sizeof(struct LineInfo));
  }

  array->lineInfo[array->count] = *value;
  array->count++;
}

void freeLineInfoArray(struct LineInfoArray* array) {
  reallocate(array->lineInfo, 0);
  initLineInfoArray(array);
}

unsigned int getLastLine(struct LineInfoArray* array) {
    if (array->count == 0)
      return 0;
    return array->lineInfo[array->count - 1].lineNum;
}

unsigned int getLine(struct LineInfoArray* array, unsigned int offset) {
  unsigned int lastLine = 0;
  for (unsigned int i = 0; i < array->count; i++) {
    struct LineInfo info;
    info = array->lineInfo[i];
    if (info.startByte <= offset) {
      lastLine = info.lineNum;
    } else {
      break;
    }
  }
  return lastLine;
}

void writeLine(struct LineInfoArray* array, unsigned int offset, unsigned int lineNum) {
  struct LineInfo info;
  info.startByte = offset;
  info.lineNum = lineNum;

  writeLineInfoArray(array, &info);
}

static int simpleInstruction(const char* name, int offset);
static int constantInstruction(const char* name, struct Chunk* chunk, int offset);
static int longConstantInstruction(const char* name, struct Chunk* chunk, int offset);

void disassembleChunk(struct Chunk* chunk, const char* name) {
  printf("== %s ==\n", name);

  for (unsigned int i = 0; i < chunk->count;) {
    i = disassembleInstruction(chunk, i);
  }
}

unsigned int disassembleInstruction(struct Chunk* chunk, unsigned int offset) {
  printf("%04u ", offset);

  unsigned int line = getLine(&chunk->lineInfo, offset);
  if (offset > 0 && getLine(&chunk->lineInfo, offset - 1) == line) {
    printf("   | ");
  } else {
    printf("%04u ", line);
  }

  uint8_t instruction = chunk->code[offset];
  if (instruction == OP_CONSTANT) {
    return constantInstruction("OP_CONSTANT", chunk, offset);
  } else if (instruction == OP_CONSTANT_LONG) {
    return longConstantInstruction("OP_CONSTANT_LONG", chunk, offset);
  } else if (instruction == OP_NEGATE) {
    return simpleInstruction("OP_NEGATE", offset);
  } else if (instruction == OP_ADD) {
    return simpleInstruction("OP_ADD", offset);
  } else if (instruction == OP_SUBTRACT) {
    return simpleInstruction("OP_SUBTRACT", offset);
  } else if (instruction == OP_MULTIPLY) {
    return simpleInstruction("OP_MULTIPLY", offset);
  } else if (instruction == OP_DIVIDE) {
    return simpleInstruction("OP_DIVIDE", offset);
  } else if (instruction == OP_MODULUS) {
    return simpleInstruction("OP_MODULUS", offset);
  } else if (instruction == OP_RETURN) {
    return simpleInstruction("OP_RETURN", offset);
  } else if (instruction == OP_NOT) {
    return simpleInstruction("OP_NOT", offset);
  } else if (instruction == OP_EQUAL) {
    return simpleInstruction("OP_EQUAL", offset);
  } else if (instruction == OP_GREATER) {
    return simpleInstruction("OP_GREATER", offset);
  } else if (instruction == OP_LESS) {
    return simpleInstruction("OP_LESS", offset);
  } else {
    printf("Unknown opcode %d\n", instruction);
    return offset + 1;
  }
}

static unsigned int simpleInstruction(const char* name, unsigned int offset) {
  printf("%s\n", name);
  return offset + 1;
}

static unsigned int constantInstruction(const char* name, struct Chunk* chunk, unsigned int offset) {
  uint8_t constant = chunk->code[offset + 1];
  printf("%s %04u '", name, constant);
  printValue(&chunk->constants.values[constant]);
  printf("'\n");
  return offset + 2;
}

static unsigned int longConstantInstruction(const char* name, struct Chunk* chunk, unsigned int offset) {
  uint16_t constant = *(uint16_t *)(&chunk->code[offset + 1]);
  printf("%s %04u '", name, constant);
  printValue(&chunk->constants.values[constant]);
  printf("'\n");
  return offset + 3;
}