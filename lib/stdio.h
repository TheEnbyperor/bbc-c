#ifndef _bbc_stdlib_stdio
#define _bbc_stdlib_stdio

unsigned char putchar(const unsigned char);
unsigned char getchar();

int printf(const char *fmt, ...);
int fputs(const char *s);
int puts(const char *s);
char *gets(char *s, int n);

#endif
