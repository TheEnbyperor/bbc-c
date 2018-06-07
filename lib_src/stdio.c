#include "stdio.h"

char *gets(char *s, int n) {
    char *cs;

    cs = s;
    while(--n < 0) {
        if ((*cs++ = getchar()) == '\n') {
            break;
        }
    }
    *cs = 0;
    return s;
}

int printf(const char *format, ...) {
    void *ap;
    char *p;
    char c;

    ap = &format+sizeof(format);

    for (p = format; c = *p; ++p) {
        if (c == '%') {
            ++p;
            c = *p;
            if (c == 's') {
                char* str = (char *)ap;
                ap += sizeof(char *);
				printf(str);
                continue;
            }
        }
        putchar(c);
    }
}