#include "stdio.h"
#include "stdlib.h"

int main() {
#define BUF_SIZE 4

    return malloc(BUF_SIZE);

//    gets(buf, BUF_SIZE);
//    puts(buf);
#undef BUF_SIZE
}