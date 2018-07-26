//#include "string.h"
#include "stddef.h"
#include "stdbool.h"

//void itoa(int n, char *s) {
//  int i, sign;
//
////  if ((sign = n) < 0) {
////    n = -n;
////  }
//  i = 0;
//  do {       /* generate digits in reverse order */
//    s[i++] = n % 10 + '0';   /* get next digit */
//  } while ((n /= 10) > 0);     /* delete it */
////  if (sign < 0)
////    s[i++] = '-';
//  s[i] = '\0';
//  strrev(s);
//}

extern void *_HIMEM;

struct block_meta {
  unsigned int size;
  struct block_meta *next;
  bool free;
};

void *global_base = NULL;
void *mem_top = NULL;

#define META_SIZE sizeof(struct block_meta)

struct block_meta *get_block_ptr(void *ptr) {
  return (char *)ptr - META_SIZE;
}

struct block_meta *find_free_block(struct block_meta **last, unsigned int size) {
  struct block_meta *current = global_base;
  while (current && !(current->free && current->size >= size)) {
    *last = current;
    current = current->next;
  }
  return current;
}

struct block_meta *request_space(struct block_meta* last, unsigned int size) {
  struct block_meta *block;

  if (!mem_top) {
    mem_top = &_HIMEM;
  }
  block = mem_top;
  mem_top += size + META_SIZE;

  if (last) {
    last->next = block;
  }
  block->size = size;
  block->next = NULL;
  block->free = 0;
  return block;
}

void *malloc(unsigned int size) {
  struct block_meta *block;
  if (size <= 0) return NULL;

  if (!global_base) {
    block = request_space(NULL, size);
    if (!block) {
      return NULL;
    }
    global_base = block;
  } else {
        struct block_meta *last = global_base;
        block = find_free_block(&last, size);
        if (!block) { // Failed to find free block.
          block = request_space(last, size);
          if (!block) {
            return NULL;
          }
        } else {
          // TODO: consider splitting block here.
          block->free = 0;
        }
    }

    return ((char *)block) + META_SIZE;
}

void free(void *ptr) {
  if (!ptr) {
    return;
  }

  // TODO: consider merging blocks once splitting blocks is implemented.
  struct block_meta* block_ptr = get_block_ptr(ptr);
  block_ptr->free = 1;
}
//
//void *realloc(void *p, unsigned int size) {
//    unsigned int *cur_size = (unsigned int *)(((char *)p)-sizeof(int));
//    if (size < *cur_size) {
//        *cur_size = size;
//
//    }
//}