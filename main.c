// Comment
#include "stdio.h"
#include "stdlib.h"

//#define BUF_LEN 10
//
//struct Bla {
//    unsigned int a, b;
//};
//
//struct Bla buf[BUF_LEN];

//int Fibonacci(int);

char out[5];

int main() {
    int a = 42;
    itoa(a, out);
    printf("%s\n", out);
}

//int Fibonacci(int n) {
//return n;
////    if ( n == 0 )
////        return 0;
////    else if ( n == 1 )
////        return 1;
////    else
////        return ( Fibonacci(n-1) + Fibonacci(n-2) );
//}