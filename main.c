// Comment
#include "stdio.h"

#define BUF_LEN 10

char buf[BUF_LEN];

union Bla {
    unsigned int a : 1, b : 2;
} bla;

int main() {
    sizeof buf;
    return buf[0];
}

//int Fibonacci(int n) {
//    if ( n == 0 )
//        return 0;
//    else if ( n == 1 )
//        return 1;
//    else
//        return ( Fibonacci(n-1) + Fibonacci(n-2) );
//}