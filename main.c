#include "stdio.h"

int fputs(const char *s) {
    char c;

    for (; c = *s; ++s) {
        putchar(c);
    }
    return 0;
}


int main() {
    fputs("Hello, world!\n");
}