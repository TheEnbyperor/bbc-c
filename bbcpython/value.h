#ifndef bbc_python_value_h
#define bbc_python_value_h

#include "common.h"
#include "memory.h"

typedef uint8_t ValueType;
#define VAL_NONE 0
#define VAL_INT 1
#define VAL_BOOL 2
#define VAL_OBJ 3

typedef struct sObj Obj;

typedef struct {
    ValueType type;
    union {
        bool boolean;
        int number;
        struct Obj *obj;
    } as;
} Value;

typedef struct {
    ArrayMeta meta;
    Value *values;
} ValueArray;


void writeValueArray(ValueArray *array, Value *value);

void boolVal(bool val, Value *value);

void noneVal(Value *value);

void intVal(int val, Value *value);

void objVal(Obj *val, Value *value);

bool isBool(Value *value);

bool isNone(Value *value);

bool isInt(Value *value);

bool isObj(Value *value);

bool asBool(Value *value);

int asInt(Value *value);

Obj *asObj(Value *value);

void printValue(Value *value);

#endif