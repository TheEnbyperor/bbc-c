// Comment
#include "stdio.h"

int a;

int strlen(char s[]) {
  int len = 0;
  while(1) {
    if (s[len] == 0) {
      return len+1;
    }
    len++;
  }
}

void reverse(char s[]) {
  int i, j;
  char c;

  for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
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
  reverse(s);
 }

#define BUF_LEN 10

int main() {
    getchar();
    return 3 * BUF_LEN + a;
}

//int Fibonacci(int n) {
//    if ( n == 0 )
//        return 0;
//    else if ( n == 1 )
//        return 1;
//    else
//        return ( Fibonacci(n-1) + Fibonacci(n-2) );
//}