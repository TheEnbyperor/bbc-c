#include "common.h"
#include "debug.h"
#include "memory.h"
#include "compiler.h"
#include "vm.h"

void initStack(struct Stack* stack) {
  stack->data = NULL;
  stack->capacity = 0;
  stack->count = 0;
}

void pushStack(struct Stack *stack, struct Value *value) {
  if (stack->capacity < stack->count + 1) {
    int oldCapacity = stack->capacity;
    stack->capacity = growCapacity(oldCapacity);
    stack->data = (struct Value*)reallocate(stack->data, stack->capacity * sizeof(struct Value));
  }

  stack->data[stack->count] = *value;
  stack->count++;
}

void popStack(struct Stack *stack, struct Value *value) {
  stack->count--;
  *value = stack->data[stack->count];
  int oldCapacity = stack->capacity;
  stack->capacity = shrinkCapacity(oldCapacity, stack->count);
  if (stack->capacity != oldCapacity) {
    stack->data = (struct Value*)reallocate(stack->data, stack->capacity * sizeof(struct Value));
  }
}

void freeStack(struct Stack* stack) {
  reallocate(stack->data, 0);
  initStack(stack);
}

void initVM(struct VM *vm) {
  initStack(&vm->stack);
}

void freeVM(struct VM *vm) {
  freeStack(&vm->stack);
}

static uint8_t readByte(struct VM *vm) {
  return *vm->ip++;
}

static struct Value *readConstant(struct VM *vm) {
  return &vm->chunk->constants.values[readByte(vm)];
}

static struct Value *peek(struct VM *vm, int distance) {
  return &vm->stack.data[vm->stack.count - 1 - distance];
}

static void runtimeError(struct VM *vm, const char *format) {
  unsigned int instruction = vm->ip - vm->chunk->code - 1;
  printf("[line %d] in script: %s\n", getLine(&vm->chunk->lineInfo, instruction), format);
  freeStack(&vm->stack);
}

static bool checkArithType(struct VM *vm, int *a, int *b, struct Value **value) {
  *value = peek(vm, 1);
  if (!isInt(peek(vm, 0)) || !isInt(*value)) {
    runtimeError(vm, "Operands must be a number.");
    return false;
  }
  struct Value aVal, bVal;
  popStack(&vm->stack, &bVal);
  *a = asInt(*value);
  *b = asInt(&bVal);
  return true;
}

static bool isFalsey(struct VM *vm, struct Value **value) {
  *value = peek(vm, 0);
  if (isNone(*value)) return true;
  else if (isBool(*value)) return !asBool(*value);
  else if (isInt(*value)) return asInt(*value) == 0;
}

static bool valuesEqual(struct VM *vm, struct Value **a) {
  struct Value b;
  popStack(&vm->stack, &b);
  *a = peek(vm, 0);

  if (b.type != (*a)->type) return false;

  ValueType type = (*a)->type;
  if (type == VAL_BOOL) return asBool(*a) == asBool(&b);
  if (type == VAL_NONE) return true;
  if (type == VAL_INT) return asInt(*a) == asInt(&b);
}

static InterpretResult run(struct VM* vm) {
  struct Value value;
  struct Value *valuePtr;
  int a, b;

  for (;;) {
    #ifdef DEBUG_TRACE_EXECUTION
      printf("[");
      for (int slot = 0; slot < vm->stack.count; slot++) {
        if (slot != 0) {
          printf(", ");
        }
        printValue(&vm->stack.data[slot]);
      }
      printf("]\n");
      disassembleInstruction(vm->chunk, (int)(vm->ip - vm->chunk->code));
    #endif

    uint8_t instruction = readByte(vm);

    if (instruction == OP_CONSTANT) {
      struct Value *constant = readConstant(vm);
      pushStack(&vm->stack, constant);
    } else if (instruction == OP_NEGATE) {
      valuePtr = peek(vm, 0);
      if (!isInt(valuePtr)) {
        runtimeError(vm, "Operand must be a number.");
        return INTERPRET_RUNTIME_ERROR;
      }
      intVal(-asInt(valuePtr), valuePtr);
    } else if (instruction == OP_ADD) {
      if (!checkArithType(vm, &a, &b, &valuePtr)) return INTERPRET_RUNTIME_ERROR;
      intVal(a + b, valuePtr);
    } else if (instruction == OP_SUBTRACT) {
      if (!checkArithType(vm, &a, &b, &valuePtr)) return INTERPRET_RUNTIME_ERROR;
      intVal(a - b, valuePtr);
    } else if (instruction == OP_MULTIPLY) {
      if (!checkArithType(vm, &a, &b, &valuePtr)) return INTERPRET_RUNTIME_ERROR;
      intVal(a * b, valuePtr);
    } else if (instruction == OP_DIVIDE) {
      if (!checkArithType(vm, &a, &b, &valuePtr)) return INTERPRET_RUNTIME_ERROR;
      intVal(a / b, valuePtr);
    } else if (instruction == OP_MODULUS) {
      if (!checkArithType(vm, &a, &b, &valuePtr)) return INTERPRET_RUNTIME_ERROR;
      intVal(a % b, valuePtr);

    } else if (instruction == OP_NOT) {
      boolVal(isFalsey(vm, &valuePtr), valuePtr);
    } else if (instruction == OP_EQUAL) {
      boolVal(valuesEqual(vm, &valuePtr), valuePtr);
    } else if (instruction == OP_GREATER) {
      if (!checkArithType(vm, &a, &b, &valuePtr)) return INTERPRET_RUNTIME_ERROR;
      boolVal(a > b, valuePtr);
    } else if (instruction == OP_LESS) {
      if (!checkArithType(vm, &a, &b, &valuePtr)) return INTERPRET_RUNTIME_ERROR;
      boolVal(a < b, valuePtr);

    } else if (instruction == OP_RETURN) {
      popStack(&vm->stack, &value);
      printValue(&value);
      printf("\n");
      return INTERPRET_OK;
    }
  }

}

InterpretResult interpret(struct VM *vm, const char* source) {
  struct Chunk chunk;
  initChunk(&chunk);

  if (!compile(source, &chunk)) {
    freeChunk(&chunk);
    return INTERPRET_COMPILE_ERROR;
  }

  vm->chunk = &chunk;
  vm->ip = vm->chunk->code;

  #ifdef DEBUG_TRACE_EXECUTION
    printf("\nSTART VM\n");
  #endif
  InterpretResult result = run(vm);
  #ifdef DEBUG_TRACE_EXECUTION
    printf("END VM\n\n");
  #endif

  freeChunk(&chunk);
  return result;
}