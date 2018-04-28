#include "string.h"

void itoa(int n, char *s) {
  int i;

  i = 0;
  do {       /* generate digits in reverse order */
    s[i++] = n % 10 + '0';   /* get next digit */
  } while ((n /= 10) > 0);     /* delete it */
  s[i] = '\0';
  strrev(s);
 }