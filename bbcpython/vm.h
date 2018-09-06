#ifndef bbc_python_vm_h
#define bbc_python_vm_h

#include "chunk.h"
#include "memory.h"
#include "value.h"

typedef uint8_t InterpretResult;
#define INTERPRET_OK 0
#define INTERPRET_COMPILE_ERROR 1
#define INTERPRET_RUNTIME_ERROR 2

typedef struct {
  ArrayMeta meta;
  Value* data;
} Stack;

typedef struct {
  struct sChunk* chunk;
  uint8_t* ip;
  Stack stack;
  Obj* objects;
} VM;

#include "object.h"

void pushStack(Stack* stack, Value *value);
void popStack(Stack* stack, Value *value);

void initVM(VM* vm);
InterpretResult interpret(VM *vm, const char* source);
void freeVM(VM* vm);

#endif