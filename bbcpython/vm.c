#include "common.h"
#include "debug.h"
#include "vm.h"

void initVM(struct VM* vm) {
}

void freeVM(struct VM* vm) {
}

static uint8_t readByte(struct VM* vm) {
  return *vm->ip++;
}

static Value readConstant(struct VM* vm) {
  return vm->chunk->constants.values[readByte(vm)];
}

static unsigned int run(struct VM* vm) {
  for (;;) {
    #ifdef DEBUG_TRACE_EXECUTION
      disassembleInstruction(vm->chunk, (int)(vm->ip - vm->chunk->code));
    #endif

    uint8_t instruction = readByte(vm);
    if (instruction == OP_CONSTANT) {
      Value constant = readConstant(vm);
      printValue(constant);
      printf("\n");
    } else if (instruction == OP_RETURN) {
      return INTERPRET_OK;
    }
  }
}

unsigned int interpret(struct VM* vm, struct Chunk* chunk) {
  vm->chunk = chunk;
  vm->ip = chunk->code;
  return run(vm);
}