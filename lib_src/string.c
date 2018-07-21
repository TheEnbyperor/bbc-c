int strlen(char *s) {
  int len = 0;
  while(*s++ != 0) {
    ++len;
  }
  return len;
}

//void strrev(char *s) {
//  int i, j;
//  char c;
//
//  for (i = 0, j = strlen(s)-1; i<j; ++i, --j) {
//    c = s[i];
//    s[i] = s[j];
//    s[j] = c;
//  }
//}