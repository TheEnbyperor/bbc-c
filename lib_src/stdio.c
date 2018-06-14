#include "stdio.h"
#include "stdlib.h"

static char out[6];

static int _puts(const char *s) {
    char c;

    for (; c = *s; ++s) {
        putchar(c);
    }
    return 0;
}

int puts(const char *s) {
    _puts(s);
    putchar('\n');
    return 0;
}

char *gets(char *s, int n) {
    char *cs;

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
    char c;

    ap = &format+sizeof(format);

    for (; c = *format; ++format) {
        if (c == '%') {
            ++format;
            c = *format;
            if (c == 'c') {
                char c = *((char *)ap);
                ap += sizeof(char);
				putchar(c);
                continue;
            }
            if (c == 's') {
                char* s = *((char **)ap);
                ap += sizeof(char *);
				_puts(s);
                continue;
            }
            if (c == 'i' || c == 'd') {
                int i = *((int *)ap);
                ap += sizeof(int);
                itoa(i, out);
                _puts(out);
                continue;
            }
        }
        putchar(c);
    }
}