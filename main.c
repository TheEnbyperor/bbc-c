// Comment
#include "stdio.h"
#include "stdlib.h"

char out[5];

int main() {
    const int a = 41;
    const int b = a+1;
    itoa(b, out);
    printf("%s\n", out);
}