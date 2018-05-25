// Comment
#include "stdio.h"

#define BUF_LEN 10

struct Bla {
    unsigned int a, b;
};

struct Bla buf[BUF_LEN];

int Fibonacci(int);

int main() {
    return Fibonacci(2);
}

int Fibonacci(int n) {
    return (n-1) + (n-2);
    if ( n == 0 )
        return 0;
    else if ( n == 1 )
        return 1;
    else
        return ( Fibonacci(n-1) + Fibonacci(n-2) );
}