#include "memory.h"
#include "object.h"
#include "stdlib.h"

typedef struct sObj Obj;

void initArray(DynamicArray* array) {
    array->data = NULL;
    array->meta.capacity = 0;
    array->meta.count = 0;
}

void writeArray(DynamicArray* array, size_t elmSize, void *value) {
    if (array->meta.capacity < array->meta.count + 1) {
        int oldCapacity = array->meta.capacity;
        array->meta.capacity = growCapacity(oldCapacity);
        array->data = reallocate(array->data, array->meta.capacity * elmSize);
    }

    size_t offset = array->meta.count * elmSize;
    for (unsigned int i = 0; i < elmSize; ++i)
        array->data[offset+i] = *(((uint8_t *)value)+i);
    array->meta.count++;
}


void popArray(DynamicArray* array, size_t elmSize, void *value) {
    array->meta.count--;
    size_t offset = array->meta.count * elmSize;
    for (unsigned int i = 0; i < elmSize; ++i) {
        *(((uint8_t *)value)+i) = array->data[offset+i];
    }

    int oldCapacity = array->meta.capacity;
    array->meta.capacity = shrinkCapacity(oldCapacity, array->meta.count);
    if (array->meta.capacity != oldCapacity) {
        array->data = reallocate(array->data, array->meta.capacity * elmSize);
    }
}

void freeArray(DynamicArray* array) {
    reallocate(array->data, 0);
    initArray(array);
}

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