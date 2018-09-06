#include "object.h"
#include "memory.h"
#include "vm.h"
#include "value.h"
#include "string.h"

static Obj *allocateObject(size_t size, ObjType type, VM *vm) {
    Obj *object = (Obj *) reallocate(NULL, size);
    object->type = type;
    object->next = vm->objects;
    vm->objects = object;
    return object;
}

static bool isObjType(Value *value, ObjType type) {
    return isObj(value) && (asObj(value))->type == type;
}

ObjType objType(Value *value) {
    return (asObj(value))->type;
}

bool isString(Value *value) {
    return isObjType(value, OBJ_STRING);
}

struct ObjString *asString(Value *value) {
    return (ObjString *) asObj(value);
}

char *asCString(Value *value) {
    return ((ObjString *) asObj(value))->chars;
}

static ObjString *allocateString(char *chars, int length, struct VM *vm) {
    ObjString *string;
    string = (ObjString *) allocateObject(sizeof(ObjString), OBJ_STRING, vm);
    string->length = length;
    string->chars = chars;
    return string;
}

ObjString *takeString(char *chars, int length, struct VM *vm) {
    return allocateString(chars, length, vm);
}

ObjString* copyString(const char* chars, int length, struct VM *vm) {
    char* heapChars = reallocate(NULL, length + 1);
    memcpy(heapChars, chars, length);
    heapChars[length] = '\0';

    return allocateString(heapChars, length, vm);
}

static void freeObject(Obj* object) {
    ObjType type = object->type;
    if (type == OBJ_STRING) {
        ObjString *string = (ObjString *) object;
        reallocate(string->chars, 0);
        reallocate(object, 0);
    }
}

void freeObjects(VM *vm) {
    Obj *object = vm->objects;
    while (object != NULL) {
        Obj *next = object->next;
        freeObject(object);
        object = next;
    }
}