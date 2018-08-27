#ifndef bbc_python_value_h
#define bbc_python_value_h

#include "common.h"

#define ValueType unsigned int
#define VAL_NONE 0
#define VAL_INT 1
#define VAL_BOOL 2

struct Value {
  ValueType type;
  union {
    bool boolean;
    int number;
  } as;
};

struct ValueArray {
  unsigned int count;
  unsigned int capacity;
  struct Value* values;
};

void initValueArray(struct ValueArray* array);
void writeValueArray(struct ValueArray* array, struct Value *value);
void freeValueArray(struct ValueArray* array);

void boolVal(bool val, struct Value *value);
void noneVal(struct Value *value);
void intVal(int val, struct Value *value);

bool isBool(struct Value *value);
bool isNone(struct Value *value);
bool isInt(struct Value *value);

bool asBool(struct Value *value);
int asInt(struct Value *value);

void printValue(struct Value *value);

#endif