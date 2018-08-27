int strlen(char s[]) {
  int len = 0;
  while(s[len]) ++len;
  return len;
}

void strrev(char *s) {
  int i, j;
  char c;

  for (i = 0, j = strlen(s)-1; i<j; ++i, --j) {
    c = s[i];
    s[i] = s[j];
    s[j] = c;
  }
}

int strcmp(char s1[], char s2[]) {
    int i;
    for (i = 0; s1[i] == s2[i]; ++i) {
        if (s1[i] == '\0') return 0;
    }
    return s1[i] - s2[i];
}

int memcmp(const void *str1, const void *str2, unsigned int n) {
  char *s1, *s2;
  s1 = str1;
  s2 = str2;
  for (unsigned int i = 0; s1[i] == s2[i]; ++i) {
    if ((i + 1) == n) return 0;
  }
  return s1[i] - s2[i];
}

void *memset(char *s, char c, unsigned int n) {
  for (unsigned int i = 0; i < n; ++i)
    s[i] = c;
}

void backspace(char *s) {
    int len = strlen(s);
    s[len-1] = '\0';
}

void append(char *s, int buf_len, char n) {
    int len = strlen(s);
    if ((len + 1) >= buf_len) {
        return;
    }
    s[len] = n;
    s[len+1] = '\0';
}