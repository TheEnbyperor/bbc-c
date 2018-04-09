// Comment
#include <stdio.h>
#ifndef ARR_LEN
#define ARR_LEN 10
#endif
//
//int Fibonacci(int);

int main() {
    char ch[ARR_LEN];
    while (1) {
        ch[0] = getchar();
        if (ch[0] == 27) {
            break;
        }
        putchar(ch[0]);
        if (ch[0] == 13) {
            putchar(10);
        }
    }
//    return 1 + 2;
}

//int Fibonacci(int n) {
//    if ( n == 0 )
//        return 0;
//    else if ( n == 1 )
//        return 1;
//    else
//        return ( Fibonacci(n-1) + Fibonacci(n-2) );
//}