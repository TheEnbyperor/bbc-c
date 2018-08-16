#ifndef bbc_python_debug_h
#define bbc_python_debug_h

struct LineInfo {
  unsigned int startByte;
  unsigned int lineNum;
};

struct LineInfoArray {
  unsigned int count;
  unsigned int capacity;
  struct LineInfo* lineInfo;
};

#include "chunk.h"

void initLineInfoArray(struct LineInfoArray* array);
void writeLineInfoArray(struct LineInfoArray* array, struct LineInfo* value);
void freeLineInfoArray(struct LineInfoArray* array);

unsigned int getLastLine(struct LineInfoArray* array);
unsigned int getLine(struct LineInfoArray* array, unsigned int offset);
void writeLine(struct LineInfoArray* array, unsigned int offset, unsigned int lineNum);

void disassembleChunk(struct Chunk* chunk, const char* name);
unsigned int disassembleInstruction(struct Chunk* chunk, unsigned int i);

#endif