#include "stdio.h"

char *gets(char *s, int n) {
    char c;
    char *cs;

    cs = s;
    while(--n < 0) {
        if ((*cs++ = (c = getchar())) == 10)
            break;
    }
    *cs = 0;
    return s;
}

int printf(const char *format, ...) {
    char *p;

    for (p = format; *p; ++p) {
        putchar(*p);
    }
}