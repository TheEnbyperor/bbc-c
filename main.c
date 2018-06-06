// Comment
#include "stdio.h"
#include "stdlib.h"

char out[5];

int main() {
    int a = 42;
    itoa(a, out);
    printf("%s\n", out);
}