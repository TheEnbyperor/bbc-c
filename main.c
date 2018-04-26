// Comment
#include "stdio.h"

void reverse(char s[], int len) {
  int i, j;
  char c;

  for (i = 0, j = len-1; i<j; i++, j--) {
    c = s[i];
    s[i] = s[j];
    s[j] = c;
  }
}

void itoa(int n, char s[]) {
  int i;

  i = 0;
  do {       /* generate digits in reverse order */
    s[i++] = n % 10 + '0';   /* get next digit */
  } while ((n /= 10) > 0);     /* delete it */
  s[i] = '\0';
  reverse(s, i);
 }

#define BUF_LEN 10

int main() {
    return 3 * BUF_LEN;
}

//int Fibonacci(int n) {
//    if ( n == 0 )
//        return 0;
//    else if ( n == 1 )
//        return 1;
//    else
//        return ( Fibonacci(n-1) + Fibonacci(n-2) );
//}