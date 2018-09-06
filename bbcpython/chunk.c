#include "chunk.h"

void initChunk(Chunk* chunk) {
  initArray(chunk);
  initArray(&chunk->constants);
  initArray(&chunk->lineInfo);
}

void writeChunk(Chunk* chunk, uint8_t byte, unsigned int lineNum) {
  if (getLastLine(&chunk->lineInfo) != lineNum) {
    writeLine(&chunk->lineInfo, chunk->meta.count, lineNum);
  }

  writeArray(chunk, sizeof(uint8_t), &byte);
}

int addConstant(Chunk* chunk, struct Value *value) {
  writeValueArray(&chunk->constants, value);
  return chunk->constants.meta.count - 1;
}

void freeChunk(Chunk* chunk) {
  reallocate(chunk->code, 0);
  freeArray(&chunk->constants);
  freeArray(&chunk->lineInfo);
  initChunk(chunk);
}
