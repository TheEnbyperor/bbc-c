#include "value.h"
#include "memory.h"

void initValueArray(struct ValueArray* array) {
  array->values = NULL;
  array->capacity = 0;
  array->count = 0;
}

void writeValueArray(struct ValueArray* array, struct Value *value) {
  if (array->capacity < array->count + 1) {
    int oldCapacity = array->capacity;
    array->capacity = growCapacity(oldCapacity);
    array->values = (struct Value*)reallocate(array->values, array->capacity * sizeof(struct Value));
  }

  array->values[array->count] = *value;
  array->count++;
}

void freeValueArray(struct ValueArray* array) {
  reallocate(array->values, 0);
  initValueArray(array);
}

void printValue(struct Value *value) {
  ValueType type = value->type;
  if (type == VAL_INT) printf("%d", asInt(value));
  else if (type == VAL_NONE) printf("None");
  else if (type == VAL_BOOL) printf(asBool(value) ? "True" : "False");
}

void boolVal(bool val, struct Value *value) {
  value->type = VAL_BOOL;
  value->as.boolean = val;
}
void noneVal(struct Value *value) {
  value->type = VAL_NONE;
  value->as.number = 0;
}
void intVal(int val, struct Value *value) {
  value->type = VAL_INT;
  value->as.number = val;
}

bool isBool(struct Value *value) {
  return value->type == VAL_BOOL;
}
bool isNone(struct Value *value) {
  return value->type == VAL_NONE;
}
bool isInt(struct Value *value) {
  return value->type == VAL_INT;
}

bool asBool(struct Value *value) {
  return value->as.boolean;
}
int asInt(struct Value *value) {
  return value->as.number;
}