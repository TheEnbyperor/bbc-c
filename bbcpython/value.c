#include "value.h"
#include "memory.h"

void initValueArray(struct ValueArray* array) {
  array->values = NULL;
  array->capacity = 0;
  array->count = 0;
}

void writeValueArray(struct ValueArray* array, Value value) {
  if (array->capacity < array->count + 1) {
    int oldCapacity = array->capacity;
    array->capacity = growCapacity(oldCapacity);
    array->values = (Value*)reallocate(array->values, array->capacity * sizeof(Value));
  }

  array->values[array->count] = value;
  array->count++;
}

void freeValueArray(struct ValueArray* array) {
  reallocate(array->values, 0);
  initValueArray(array);
}

void printValue(Value value) {
  printf("%u", value);
}