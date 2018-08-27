#ifndef bbc_python_memory_h
#define bbc_python_memory_h

#include "common.h"

int growCapacity(int oldCapacity);
int shrinkCapacity(int oldCapacity, int count);
void* reallocate(void* previous, size_t newSize);

#endif