#include "memory.h"
#include "object.h"
#include "value.h"

void writeValueArray(ValueArray *array, Value *value) {
    writeArray(array, sizeof(Value), value);
}

static void printObject(Value *value) {
    ObjType type = objType(value);
    if (type == OBJ_STRING) printf("%s", asCString(value));
}

void printValue(Value *value) {
    ValueType type = value->type;
    if (type == VAL_INT) printf("%d", asInt(value));
    else if (type == VAL_NONE) printf("None");
    else if (type == VAL_BOOL) printf(asBool(value) ? "True" : "False");
    else if (type == VAL_OBJ) printObject(value);
}

void boolVal(bool val, Value *value) {
    value->type = VAL_BOOL;
    value->as.boolean = val;
}

void noneVal(Value *value) {
    value->type = VAL_NONE;
    value->as.number = 0;
}

void intVal(int val, Value *value) {
    value->type = VAL_INT;
    value->as.number = val;
}

void objVal(Obj *val, Value *value) {
    value->type = VAL_OBJ;
    value->as.obj = val;
}

bool isBool(Value *value) {
    return value->type == VAL_BOOL;
}

bool isNone(Value *value) {
    return value->type == VAL_NONE;
}

bool isInt(Value *value) {
    return value->type == VAL_INT;
}

bool isObj(Value *value) {
    return value->type == VAL_OBJ;
}

bool asBool(Value *value) {
    return value->as.boolean;
}

int asInt(Value *value) {
    return value->as.number;
}

Obj *asObj(Value *value) {
    return value->as.obj;
}