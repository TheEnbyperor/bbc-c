// Comment
char putchar(char);
char getchar();
int osbyte(int, int, int);
//
//int Fibonacci(int);

int main() {
    char ch[10];
    while (1) {
        ch = getchar();
        if (ch == 27) {
            break;
        }
        putchar(ch);
        if (ch == 13) {
            putchar(10);
        }
    }
    char a = ch[0];
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