#include "stdio.h"
#include "stdlib.h"

char out[6];

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

int puts(const char *s) {
    void *p;
    char c;

    for (p = s; c = *p; ++p) {
        putchar(c);
    }
    return 0;
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
            if (c == 'c') {
                char c = *((char *)ap);
                ap += sizeof(char);
				putchar(c);
                continue;
            }
            if (c == 's') {
                char* s = *((char **)ap);
                ap += sizeof(char *);
				puts(s);
                continue;
            }
//            if (c == 'i' || c == 'd') {
//                int i = *((int *)ap);
//                ap += sizeof(int);
//                itoa(i, out);
//                puts(out);
//                continue;
//            }
        }
        putchar(c);
    }
}