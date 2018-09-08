#include "stddef.h"
#include "stdio.h"
#include "stdbool.h"
#include "string.h"
#include "ctype.h"
#include "stdlib.h"

int fputs(const char *s) {
    char c;

    for (; c = *s; ++s) {
        putchar(c);
    }
    return 0;
}

int puts(const char *s) {
    fputs(s);
    putchar('\n');
    return 0;
}

char *gets(char *s, int n) {
  char *cs;
  char c;

  cs = s;
  while(--n > 0) {
    c = getchar();
    if (c == 3) {
      return NULL;
    }
    putchar(c);
    if (c == 127) {
      --cs;
      continue;
    }
    if ((*cs++ = c) == '\n') {
      --cs;
      break;
    }
  }
  *cs = '\0';
  return s;
}


//void itoa(int n, char *s, bool unsig, unsigned int zero_pad) {
//  int i;
//  bool negative = false;
//
//  if (!unsig && n < 0) {
//    negative = true;
//    n = -n;
//  }
//
//  i = 0;
//  do {       /* generate digits in reverse order */
//    s[i++] = n % 10 + '0';   /* get next digit */
//  } while ((n /= 10) > 0);     /* delete it */
//
//  for (;i < zero_pad;) s[i++] = '0';
//
//  if (negative) s[i++] = '-';
//
//  s[i] = '\0';
//  strrev(s);
//}
//
//
//int printf(const char *format, ...) {
//    void *ap;
//    char c;
//    char bf[24];
//    int i;
//
//    ap = &format+1;
//
//    for (; c = *format; ++format) {
//        if (c == '%') {
//            char zero_pad = 0;
//
//            c = *(++format);
//
//            if (c == '0') {
//				c = *(++format);
//				if (c == '\0')
//					break;
//				if (isdigit(c))
//					zero_pad = c - '0';
//				c = *(++format);
//            }
//
//            if (c == '\0') {
//                break;
//            } else if (c == 'c') {
//                char c = *((char *)ap);
//                ap = (char*)ap + sizeof(int);
//				putchar(c);
//				++i;
//                continue;
//            } else if (c == 's') {
//                char* s = *((char **)ap);
//                ap = (char*)ap + sizeof(char *);
//				fputs(s);
//				i += strlen(s);
//                continue;
//            } else if (c == 'u') {
//                int i = *((int *)ap);
//                ap = (char*)ap + sizeof(int);
//                itoa(i, bf, true, zero_pad);
//                fputs(bf);
//				i += strlen(bf);
//                continue;
//            } else if (c == 'd') {
//                int i = *((int *)ap);
//                ap = (char*)ap + sizeof(int);
//                itoa(i, bf, false, zero_pad);
//                fputs(bf);
//				i += strlen(bf);
//                continue;
//            }
//            putchar(c);
//        }
//        putchar(c);
//        ++i;
//    }
//}