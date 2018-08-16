#ifndef bbc_python_vm_h
#define bbc_python_vm_h

#include "chunk.h"

#define INTERPRET_OK 0
#define INTERPRET_COMPILE_ERROR 1
#define INTERPRET_RUNTIME_ERROR 2

struct VM {
  struct Chunk* chunk;
  uint8_t* ip;
};

void initVM(struct VM* vm);
unsigned int interpret(struct VM* vm, struct Chunk* chunk);
void freeVM(struct VM* vm);

#endif