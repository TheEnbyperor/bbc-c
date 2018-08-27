#include "memory.h"
#include "stdlib.h"

int growCapacity(int oldCapacity) {
    return ((oldCapacity) < 8 ? 8 : (oldCapacity) + 8);
}

int shrinkCapacity(int oldCapacity, int count) {
    return ((oldCapacity - 8) < count ? oldCapacity : oldCapacity - 8);
}

void* reallocate(void* previous, size_t newSize) {
  if (newSize == 0) {
    free(previous);
    return NULL;
  }

  return realloc(previous, newSize);
}