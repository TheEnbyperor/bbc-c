#ifndef bbc_python_scanner_h
#define bbc_python_scanner_h

typedef struct {
  const char* start;
  const char* current;
  int line;
  bool isStartOfLine;
  int indent[20];
  int *curIndent;
} Scanner;

typedef unsigned int TokenType;
#define TOKEN_EOF 56
#define TOKEN_ERROR 57
#define TOKEN_NEWLINE 58
#define TOKEN_INDENT 59
#define TOKEN_DEDENT 60

#define TOKEN_NUMBER 0
#define TOKEN_STRING 1
#define TOKEN_IDENTIFIER 2

#define TOKEN_PLUS 3
#define TOKEN_MINUS 4
#define TOKEN_SLASH 5
#define TOKEN_STAR 6

#define TOKEN_COMMA 7
#define TOKEN_DOT 8
#define TOKEN_COLON 9

#define TOKEN_LEFT_PAREN 10
#define TOKEN_RIGHT_PAREN 11
#define TOKEN_LEFT_BRACE 12
#define TOKEN_RIGHT_BRACE 13

#define TOKEN_FALSE 14
#define TOKEN_AWAIT 15
#define TOKEN_ELSE 16
#define TOKEN_IMPORT 17
#define TOKEN_PASS 18
#define TOKEN_NONE 19
#define TOKEN_BREAK 20
#define TOKEN_EXCEPT 21
#define TOKEN_IN 22
#define TOKEN_RAISE 23
#define TOKEN_TRUE 24
#define TOKEN_CLASS 25
#define TOKEN_FINALLY 26
#define TOKEN_IS 27
#define TOKEN_RETURN 28
#define TOKEN_AND 29
#define TOKEN_CONTINUE 30
#define TOKEN_FOR 31
#define TOKEN_LAMBDA 32
#define TOKEN_TRY 33
#define TOKEN_AS 34
#define TOKEN_DEF 35
#define TOKEN_FROM 36
#define TOKEN_NONLOCAL 37
#define TOKEN_WHILE 38
#define TOKEN_ASSERT 39
#define TOKEN_DEL 40
#define TOKEN_GLOBAL 41
#define TOKEN_NOT 42
#define TOKEN_WITH 43
#define TOKEN_ASYNC 44
#define TOKEN_ELIF 45
#define TOKEN_IF 46
#define TOKEN_OR 47
#define TOKEN_YIELD 48

#define TOKEN_EQUAL 49
#define TOKEN_EQUAL_EQUAL 50
#define TOKEN_NOT_EQUAL 51
#define TOKEN_GREATER 52
#define TOKEN_GREATER_EQUAL 53
#define TOKEN_LESS 54
#define TOKEN_LESS_EQUAL 55

typedef struct {
  TokenType type;
  const char* start;
  int length;
  int line;
} Token;

void initScanner(Scanner* scanner, const char* source);
void scanToken(Scanner *scanner, Token *token);

#endif