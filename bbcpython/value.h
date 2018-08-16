#ifndef bbc_python_value_h
#define bbc_python_value_h

#include "common.h"

#define Value int

struct ValueArray {
  unsigned int count;
  unsigned int capacity;
  Value* values;
};

void initValueArray(struct ValueArray* array);
void writeValueArray(struct ValueArray* array, Value value);
void freeValueArray(struct ValueArray* array);

void printValue(Value value);

#endif