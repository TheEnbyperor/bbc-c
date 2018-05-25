// Comment
#include "stdio.h"
#include "stdlib.h"

#define BUF_LEN 10

struct Bla {
    unsigned int a, b;
};

struct Bla buf[BUF_LEN];

int Fibonacci(int);

char num[10];

int main() {
    while (1) {
        char in = getchar();
        int fib = Fibonacci(in-65);
        itoa(fib, num);
        for (int i=0;i<10;i++) {
            putchar(num[i]);
        }
    }
}

int Fibonacci(int n) {
    if ( n == 0 )
        return 0;
    else if ( n == 1 )
        return 1;
    else
        return ( Fibonacci(n-1) + Fibonacci(n-2) );
}