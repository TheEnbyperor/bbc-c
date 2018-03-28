// Comment
int Fibonacci(int);

int n = 3;

int main() {
    Fibonacci(n);
    return &n;
}

int Fibonacci(int n) {
    if ( n == 0 )
        return 0;
    else if ( n == 1 )
        return 1;
    else
        return ( Fibonacci(n-1) + Fibonacci(n-2) );
}