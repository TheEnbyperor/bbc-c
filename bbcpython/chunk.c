#include "chunk.h"
#include "memory.h"

void initChunk(struct Chunk* chunk) {
  chunk->count = 0;
  chunk->capacity = 0;
  chunk->code = NULL;
}

void writeChunk(struct Chunk* chunk, uint8_t byte) {
  if (chunk->capacity < chunk->count + 1) {
    chunk->capacity = growCapacity(chunk->capacity);
    chunk->code = (uint8_t*)reallocate(chunk->code, chunk->capacity);
  }

  chunk->code[chunk->count] = byte;
  ++chunk->count;
}

void freeChunk(struct Chunk* chunk) {
  reallocate(chunk->code, 0);
  initChunk(chunk);
}
