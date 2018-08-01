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
#define MEM_TOP 31744

struct block_meta {
  unsigned int size;
  struct block_meta *next;
  struct block_meta *prev;
  bool free;
};

static void *global_base = NULL;
static void *mem_top = NULL;

#define META_SIZE sizeof(struct block_meta)

static struct block_meta *get_block_ptr(void *ptr) {
  return (char *)ptr - META_SIZE;
}

static struct block_meta *find_free_block(struct block_meta **last, unsigned int size) {
  struct block_meta *current = global_base;
  while (current && !(current->free && current->size >= size)) {
    *last = current;
    current = current->next;
  }
  return current;
}

static struct block_meta *request_space(struct block_meta *last, unsigned int size) {
  struct block_meta *block;

  if (!mem_top)
    mem_top = &_HIMEM;
  block = mem_top;

  if (((char *)mem_top + size + META_SIZE) >= MEM_TOP)
    return NULL;
  mem_top = (char *)mem_top + size + META_SIZE;

  if (last) {
    last->next = block;
  }
  block->size = size;
  block->next = NULL;
  block->free = 0;
  return block;
}

static void split_block(struct block_meta *block, unsigned int size) {
  struct block_meta *new_block;

  new_block = (char *)block + META_SIZE + size;
  new_block->size = block->size - size - META_SIZE;
  new_block->next = block->next;
  new_block->free = 1;
  block->size = size;
  block->next = new_block;
}

static struct block_meta *fusion(struct block_meta *block) {
    if (block->next && block->next->free) {
        block->size += META_SIZE + block->next->size;
        block->next = block->next->next;
        if (block->next)
            block->next->prev = block;
    }
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
          if ((block->size - size) >= (META_SIZE + 4))
            split_block(block, size);
          block->free = 0;
        }
    }

    return ((char *)block) + META_SIZE;
}

void free(void *ptr) {
  if (!ptr) {
    return;
  }

  struct block_meta* block_ptr = get_block_ptr(ptr);
  block_ptr->free = 1;

  if (block_ptr->prev && block_ptr->prev->free)
    block_ptr = fusion(block_ptr->prev);

  if (block_ptr->next)
    fusion(block_ptr);
  else {
    if (block_ptr->prev)
      block_ptr->prev->next = NULL;
    else
      global_base = NULL;
    mem_top = block_ptr;
  }
}

//
//void *realloc(void *p, unsigned int size) {
//    unsigned int *cur_size = (unsigned int *)(((char *)p)-sizeof(int));
//    if (size < *cur_size) {
//        *cur_size = size;
//
//    }
//}