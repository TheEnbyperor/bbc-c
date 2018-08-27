#ifndef _bbc_stdlib_string
#define _bbc_stdlib_string

int strlen(char s[]);
void strrev(char s[]);
int strcmp(char s1[], char s2[]);
int memcmp(const void *str1, const void *str2, unsigned int n);
void *memset(char *s, char c, unsigned int n);
void backspace(char *s);
void append(char *s, int buf_len, char n);

#endif