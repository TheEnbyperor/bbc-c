// Comment
void putchar(char);
int Fibonacci(int);

int n = 20;

int main() {
    char ch;

    for(ch='A';ch<='Z';++ch) {
        putchar(ch);
    }

    return ch;
}

//int Fibonacci(int n) {
//    if ( n == 0 )
//        return 0;
//    else if ( n == 1 )
//        return 1;
//    else
//        return ( Fibonacci(n-1) + Fibonacci(n-2) );
//}