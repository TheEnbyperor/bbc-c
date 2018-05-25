// Comment
#include "stdio.h"

#define BUF_LEN 10

struct Bla {
    unsigned int a, b;
};

struct Bla buf[BUF_LEN];

int Fibonacci(int);

int main() {
    char in = getchar();
    return Fibonacci(in-65);
}

int Fibonacci(int n) {
    if ( n == 0 )
        return 0;
    else if ( n == 1 )
        return 1;
    else
        return ( Fibonacci(n-1) + Fibonacci(n-2) );
}