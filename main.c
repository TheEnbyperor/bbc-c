// Comment
#include <stdio.h>
#ifndef ARR_LEN
#define ARR_LEN 10
#endif
//
//int Fibonacci(int);

int main() {
    char a = ARR_LEN;
    a--;
    return 3 * a;
}

//int Fibonacci(int n) {
//    if ( n == 0 )
//        return 0;
//    else if ( n == 1 )
//        return 1;
//    else
//        return ( Fibonacci(n-1) + Fibonacci(n-2) );
//}