#include "stdbool.h"

int strlen(char s[]) {
    int len = 0;
    while (s[len]) ++len;
    return len;
}

void strrev(char *s) {
    int i, j;
    char c;

    for (i = 0, j = strlen(s) - 1; i < j; ++i, --j) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}

void itoa(int n, char *s, bool unsig, unsigned int zero_pad) {
    int i;
    bool negative = false;

//    putchar('i');

//    if (!unsig && n < 0) {
//        negative = true;
//        n = -n;
//    }

//    putchar('i');
//    putchar(n + '0');

    i = 0;
    do {       /* generate digits in reverse order */
        s[i++] = n % 10 + '0';   /* get next digit */
    } while ((n /= 10) > 0);     /* delete it */

//    putchar('a');

//    for (;i < zero_pad;) s[i++] = '0';

//    if (negative) s[i++] = '-';

    s[i] = '\0';
    strrev(s);
}

int main() {
    char c[20];
    itoa(1, c, true, 0);
}