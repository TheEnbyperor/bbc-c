#ifndef bbc_python_debug_h
#define bbc_python_debug_h

#include "memory.h"

typedef struct {
  unsigned int startByte;
  unsigned int lineNum;
} LineInfo;

typedef struct {
  ArrayMeta meta;
  LineInfo* lineInfo;
} LineInfoArray;

#include "chunk.h"

void writeLineInfoArray(LineInfoArray* array, LineInfo* value);

unsigned int getLastLine(LineInfoArray* array);
unsigned int getLine(LineInfoArray* array, unsigned int offset);
void writeLine(LineInfoArray* array, unsigned int offset, unsigned int lineNum);

void disassembleChunk(struct sChunk* chunk, const char* name);
unsigned int disassembleInstruction(struct sChunk* chunk, unsigned int i);

#endif