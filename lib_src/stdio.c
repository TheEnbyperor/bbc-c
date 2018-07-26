#include "stdio.h"
#include "stdlib.h"
#include "string.h"

int fputs(const char *s) {
    char c;

    for (; c = *s; ++s) {
        putchar(c);
    }
    return 0;
}

int puts(const char *s) {
    fputs(s);
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
    int i;

    ap = &format+sizeof(format);

    for (; c = *format; ++format) {
//        if (c == '%') {
//            ++format;
//            c = *format;
//            if (c == 0) {
//                break;
//            }
//            if (c == 'c') {
//                char c = *((char *)ap);
//                ap += sizeof(char);
//				putchar(c);
//				++i;
//                continue;
//            }
//            if (c == 's') {
//                char* s = *((char **)ap);
//                ap += sizeof(char *);
//				_puts(s);
//				i+= strlen(s);
//                continue;
//            }
//            if (c == 'i' || c == 'd') {
//                char out[6] = {0};
//                int i = *((int *)ap);
//                ap += sizeof(int);
//                itoa(i, out);
//                _puts(out);
//				i += strlen(out);
//                continue;
//            }
//            putchar(c);
//        }
        putchar(c);
        ++i;
    }
}