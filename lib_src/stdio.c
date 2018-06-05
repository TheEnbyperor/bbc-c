#include "stdio.h"

char *fgets(char *s, int n) {
    int c = 0;
    while (c < n) {
        char c = getchar();
        *s = c;
        ++s;
//        if (c == 10) {
//            break;
//        }
    }
    *s = 0;
    return s;
}