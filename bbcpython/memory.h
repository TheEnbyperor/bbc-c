#ifndef bbc_python_memory_h
#define bbc_python_memory_h

int growCapacity(int oldCapacity);
void* reallocate(void* previous, size_t newSize);

#endif