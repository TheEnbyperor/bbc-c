// Comment
#include <stdio.h>
#define BUF_LEN 10

int main() {
    char a[BUF_LEN];
    fgets(a, 2);
    return 3 * a[0];
}

//int Fibonacci(int n) {
//    if ( n == 0 )
//        return 0;
//    else if ( n == 1 )
//        return 1;
//    else
//        return ( Fibonacci(n-1) + Fibonacci(n-2) );
//}