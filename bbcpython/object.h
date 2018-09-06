#ifndef bbc_python_object_h
#define bbc_python_object_h

#include "common.h"
#include "value.h"
#include "vm.h"

typedef uint8_t ObjType;
#define OBJ_STRING 0

struct sObj {
    ObjType type;
    Obj* next;
};

typedef struct {
    struct sObj object;
    int length;
    char *chars;
} ObjString;

ObjType objType(Value *value);

bool isString(Value *value);

ObjString *asString(Value *value);

char *asCString(Value *value);

ObjString *takeString(char *chars, int length, VM *vm);

ObjString *copyString(const char *chars, int length, VM *vm);

void freeObjects(VM *vm);

#endif