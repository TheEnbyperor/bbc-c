#include "string.h"
#include "stddef.h"
#include "stdbool.h"

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
#define MIN_BLOCK_SIZE 4

static struct block_meta *get_block_ptr(void *ptr) {
  return (char *)ptr - META_SIZE;
}
static struct block_meta *get_data_ptr(void *ptr) {
  return (char *)ptr + META_SIZE;
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

  if (last)
    last->next = block;
  block->prev = last;
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
  new_block->prev = block;
  new_block->free = 1;
  block->size = size;
  block->next = new_block;
  if (new_block->next)
    new_block->next->prev = new_block;
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
          if ((block->size - size) >= (META_SIZE + MIN_BLOCK_SIZE))
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

static void copy_block(struct block_meta *old_block, struct block_meta *new_block) {
  char *old_data, *new_data;
  old_data = get_data_ptr(old_block);
  new_data = get_data_ptr(new_block);
  for (unsigned int i = 0; i < old_block->size && i < new_block->size; ++i)
    new_data[i] = old_data[i];
}

void *realloc(void *p, unsigned int size) {
  if (!p)
    return malloc(size);

  struct block_meta *block, *new_block;
  block = get_block_ptr(p);

  if (block->size >= size) {
    if ((block->size - size) >= (META_SIZE + MIN_BLOCK_SIZE))
      split_block(block, size);
  } else {
    if (block->next && block->next->free && (block->size + META_SIZE + block->next->size) >= size) {
      fusion(block);
      if ((block->size - size) >= (META_SIZE + MIN_BLOCK_SIZE))
        split_block(block, size);
    } else {
      void *newp = malloc(size);
      if (!newp)
        return NULL;
      new_block = get_block_ptr(newp);
      copy_block(block, new_block);
      free(p);
      return newp;
    }
  }
  return p;
}