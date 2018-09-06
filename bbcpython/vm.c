#include "common.h"
#include "debug.h"
#include "memory.h"
#include "compiler.h"
#include "string.h"
#include "vm.h"

void pushStack(Stack *stack, Value *value) {
    writeArray(stack, sizeof(Value), value);
}

void popStack(Stack *stack, Value *value) {
    popArray(stack, sizeof(Value), value);
}

void initVM(VM *vm) {
    initArray(&vm->stack);
    vm->objects = NULL;
}

void freeVM(VM *vm) {
    freeArray(&vm->stack);
    freeObjects(vm);
}

static uint8_t readByte(VM *vm) {
    return *vm->ip++;
}

static Value *readConstant(VM *vm) {
    return &vm->chunk->constants.values[readByte(vm)];
}

static Value *peek(VM *vm, int distance) {
    return &vm->stack.data[vm->stack.meta.count - 1 - distance];
}

static void runtimeError(VM *vm, const char *format) {
    unsigned int instruction = vm->ip - vm->chunk->code - 1;
    printf("[line %d] in script: %s\n", getLine(&vm->chunk->lineInfo, instruction), format);
    freeArray(&vm->stack);
}

static bool checkArithType(VM *vm, int *a, int *b, Value **value) {
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

static bool isFalsey(VM *vm, Value **value) {
    *value = peek(vm, 0);
    if (isNone(*value)) return true;
    else if (isBool(*value)) return !asBool(*value);
    else if (isInt(*value)) return asInt(*value) == 0;
}

static bool valuesEqual(VM *vm, Value **a) {
    Value b;
    popStack(&vm->stack, &b);
    *a = peek(vm, 0);

    if (b.type != (*a)->type) return false;

    ValueType type = (*a)->type;
    if (type == VAL_BOOL) return asBool(*a) == asBool(&b);
    if (type == VAL_NONE) return true;
    if (type == VAL_INT) return asInt(*a) == asInt(&b);
}

void concatenate(VM *vm) {
    Value bVal;
    Value *aVal;
    ObjString *bStr, *aStr;
    popStack(&vm->stack, &bVal);
    aVal = peek(vm, 0);
    bStr = asString(&bVal);
    aStr = asString(aVal);

    int length = aStr->length + bStr->length;
    char *chars = reallocate(NULL, length + 1);
    memcpy(chars, aStr->chars, aStr->length);
    memcpy(chars + aStr->length, bStr->chars, bStr->length);
    chars[length] = '\0';

    aStr = takeString(chars, length, vm);
    objVal(aStr, aVal);
}

static InterpretResult run(VM *vm) {
    Value value;
    Value *valuePtr;
    int a, b;

    for (;;) {
#ifdef DEBUG_TRACE_EXECUTION
        printf("[");
        for (int slot = 0; slot < vm->stack.meta.count; slot++) {
            if (slot != 0) {
                printf(", ");
            }
            printValue(&vm->stack.data[slot]);
        }
        printf("]\n");
        disassembleInstruction(vm->chunk, (int) (vm->ip - vm->chunk->code));
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
            if (isString(peek(vm, 0)) && isString(peek(vm, 1))) {
                concatenate(vm);
            } else if (isInt(peek(vm, 0)) && isInt(peek(vm, 1))) {
                valuePtr = peek(vm, 1);
                popStack(&vm->stack, &value);
                a = asInt(valuePtr);
                b = asInt(&value);
                intVal(a + b, valuePtr);
            } else {
                runtimeError(vm, "Operands must be two numbers or two strings.");
                return INTERPRET_RUNTIME_ERROR;
            }
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

InterpretResult interpret(VM *vm, const char *source) {
    Chunk chunk;
    initChunk(&chunk);

    if (!compile(source, &chunk, vm)) {
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