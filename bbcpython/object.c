#include "object.h"
#include "memory.h"
#include "vm.h"
#include "value.h"
#include "string.h"

static struct Obj *allocateObject(size_t size, ObjType type, struct VM *vm) {
    struct Obj *object = (struct Obj *) reallocate(NULL, size);
    object->type = type;
    object->next = vm->objects;
    vm->objects = object;
    return object;
}

static bool isObjType(struct Value *value, ObjType type) {
    return isObj(value) && (asObj(value))->type == type;
}

ObjType objType(struct Value *value) {
    return (asObj(value))->type;
}

bool isString(struct Value *value) {
    return isObjType(value, OBJ_STRING);
}

struct ObjString *asString(struct Value *value) {
    return (struct ObjString *) asObj(value);
}

char *asCString(struct Value *value) {
    return ((struct ObjString *) asObj(value))->chars;
}

static struct ObjString *allocateString(char *chars, int length, struct VM *vm) {
    struct ObjString *string;
    string = (struct ObjString *) allocateObject(sizeof(struct ObjString), OBJ_STRING, vm);
    string->length = length;
    string->chars = chars;
    return string;
}

struct ObjString *takeString(char *chars, int length, struct VM *vm) {
    return allocateString(chars, length, vm);
}

struct ObjString* copyString(const char* chars, int length, struct VM *vm) {
    char* heapChars = reallocate(NULL, length + 1);
    memcpy(heapChars, chars, length);
    heapChars[length] = '\0';

    return allocateString(heapChars, length, vm);
}