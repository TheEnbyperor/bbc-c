#include "memory.h"
#include "object.h"
#include "vm.h"
#include "stdlib.h"

int growCapacity(int oldCapacity) {
    return ((oldCapacity) < 8 ? 8 : (oldCapacity) + 8);
}

int shrinkCapacity(int oldCapacity, int count) {
    return ((oldCapacity - 8) < count ? oldCapacity : oldCapacity - 8);
}

void* reallocate(void* previous, size_t newSize) {
  if (newSize == 0) {
    free(previous);
    return NULL;
  }

  return realloc(previous, newSize);
}

static void freeObject(struct Obj* object) {
    ObjType type = object->type;
    if (type == OBJ_STRING) {
        struct ObjString *string = (struct ObjString *) object;
        reallocate(string->chars, 0);
        reallocate(object, 0);
    }
}

void freeObjects(struct VM *vm) {
    struct Obj *object = vm->objects;
    while (object != NULL) {
        struct Obj *next = object->next;
        freeObject(object);
        object = next;
    }
}