int strlen(char *s) {
  int len = 0;
  while(1) {
    if (s[len] == 0) {
      return len+1;
    }
    len++;
  }
}

void strrev(char *s) {
  int i, j;
  char c;

  for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
    c = s[i];
    s[i] = s[j];
    s[j] = c;
  }
}