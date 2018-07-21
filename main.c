#include "stdio.h"
//#include "stdlib.h"
//#include "string.h"

#define PROMPT "~ >"

int main() {
    puts(PROMPT);
    while (1) {
        char in = getchar();
        if (in == 27) {
            break;
        }
        putchar(in);
    }
}