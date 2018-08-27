#ifndef bbc_python_vm_h
#define bbc_python_vm_h

#include "chunk.h"

#define InterpretResult unsigned int
#define INTERPRET_OK 0
#define INTERPRET_COMPILE_ERROR 1
#define INTERPRET_RUNTIME_ERROR 2

struct Stack {
  struct Value* data;
  unsigned int count;
  unsigned int capacity;
};

struct VM {
  struct Chunk* chunk;
  uint8_t* ip;
  struct Stack stack;
};

void initStack(struct Stack* stack);
void freeStack(struct Stack* stack);
void pushStack(struct Stack* stack, struct Value *value);
void popStack(struct Stack* stack, struct Value *value);

void initVM(struct VM* vm);
InterpretResult interpret(struct VM *vm, const char* source);
void freeVM(struct VM* vm);

#endif