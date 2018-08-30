#include "memory.h"
#include "object.h"
#include "value.h"

void initValueArray(struct ValueArray *array) {
    array->values = NULL;
    array->capacity = 0;
    array->count = 0;
}

void writeValueArray(struct ValueArray *array, struct Value *value) {
    if (array->capacity < array->count + 1) {
        int oldCapacity = array->capacity;
        array->capacity = growCapacity(oldCapacity);
        array->values = (struct Value *) reallocate(array->values, array->capacity * sizeof(struct Value));
    }

    array->values[array->count] = *value;
    array->count++;
}

void freeValueArray(struct ValueArray *array) {
    reallocate(array->values, 0);
    initValueArray(array);
}

static void printObject(struct Value *value) {
    ObjType type = objType(value);
    if (type == OBJ_STRING) printf("%s", asCString(value));
}

void printValue(struct Value *value) {
    ValueType type = value->type;
    if (type == VAL_INT) printf("%d", asInt(value));
    else if (type == VAL_NONE) printf("None");
    else if (type == VAL_BOOL) printf(asBool(value) ? "True" : "False");
    else if (type == VAL_OBJ) printObject(value);
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

void objVal(struct Obj *val, struct Value *value) {
    value->type = VAL_OBJ;
    value->as.obj = val;
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

bool isObj(struct Value *value) {
    return value->type == VAL_OBJ;
}

bool asBool(struct Value *value) {
    return value->as.boolean;
}

int asInt(struct Value *value) {
    return value->as.number;
}

struct Obj *asObj(struct Value *value) {
    return value->as.obj;
}