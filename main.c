// Comment
#include "stdio.h"
#include "stdlib.h"
#include "string.h"

char out[5];

int main() {
//    const int a = 41;
//    const int b = a+1;
//    itoa(b, out);
    const char *s = "Hello, world!";
    strrev(s);
    printf(s);
}