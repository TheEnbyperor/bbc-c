#ifndef bbc_python_memory_h
#define bbc_python_memory_h

#include "common.h"

typedef struct {
    unsigned int count;
    unsigned int capacity;
} ArrayMeta;

typedef struct {
    ArrayMeta meta;
    uint8_t* data;
} DynamicArray;

void initArray(DynamicArray *array);
void writeArray(DynamicArray *array, size_t elmSize, void *value);
void popArray(DynamicArray *array, size_t elmSize, void *value);
void freeArray(DynamicArray *array);

int growCapacity(int oldCapacity);
int shrinkCapacity(int oldCapacity, int count);
void* reallocate(void* previous, size_t newSize);

#endif