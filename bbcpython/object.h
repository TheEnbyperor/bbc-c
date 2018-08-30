#ifndef bbc_python_object_h
#define bbc_python_object_h

#include "common.h"
#include "vm.h"

#define ObjType unsigned char
#define OBJ_STRING 0

struct Obj {
    ObjType type;
    struct Obj* next;
};

struct ObjString {
    struct Obj object;
    int length;
    char *chars;
};

ObjType objType(struct Value *value);

bool isString(struct Value *value);

struct ObjString *asString(struct Value *value);

char *asCString(struct Value *value);

struct ObjString *takeString(char *chars, int length, struct VM *vm);

struct ObjString *copyString(const char *chars, int length, struct VM *vm);

#endif