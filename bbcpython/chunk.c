#include "chunk.h"
//#include "memory.h"
//
//void initChunk(struct Chunk* chunk) {
//  chunk->count = 0;
//  chunk->capacity = 0;
//  chunk->code = NULL;
//  initValueArray(&chunk->constants);
//  initLineInfoArray(&chunk->lineInfo);
//}
//
//void writeChunk(struct Chunk* chunk, uint8_t byte, unsigned int lineNum) {
//  if (chunk->capacity < chunk->count + 1) {
//    chunk->capacity = growCapacity(chunk->capacity);
//    chunk->code = (uint8_t*)reallocate(chunk->code, chunk->capacity);
//  }
//
//  if (getLastLine(&chunk->lineInfo) != lineNum) {
//    writeLine(&chunk->lineInfo, chunk->count, lineNum);
//  }
//
//  chunk->code[chunk->count] = byte;
//  ++chunk->count;
//}
//
//int addConstant(struct Chunk* chunk, struct Value *value) {
//  writeValueArray(&chunk->constants, value);
//  return chunk->constants.count - 1;
//}
//
//void freeChunk(struct Chunk* chunk) {
//  reallocate(chunk->code, 0);
//  freeValueArray(&chunk->constants);
//  freeLineInfoArray(&chunk->lineInfo);
//  initChunk(chunk);
//}
