#ifndef _bbc_stdlib_stdlib
#define _bbc_stdlib_stdlib

void *malloc(unsigned int size);
void free(void *ptr);
void *realloc(void *p, unsigned int size);

int atoi(const char *s);

#endif