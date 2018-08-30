#include "common.h"
#include "compiler.h"
#include "scanner.h"
#include "stdlib.h"

#ifdef DEBUG_PRINT_CODE
#include "debug.h"
#endif

#define Precedence unsigned char
#define PREC_NONE 0
#define PREC_NEWLINE 1
#define PREC_ASSIGNMENT 2
#define PREC_LAMBDA 3
#define PREC_CONDITIONAL 4
#define PREC_OR 5
#define PREC_AND 6
#define PREC_NOT 7
#define PREC_COMPARISON 8
#define PREC_BITWISE_OR 9
#define PREC_BITWISE_XOR 10
#define PREC_BITWISE_AND 11
#define PREC_SHIFT 12
#define PREC_ADDITION 13
#define PREC_MULTIPLICATION 14
#define PREC_UNARY 15
#define PREC_EXPONENT 16
#define PREC_AWAIT 17
#define PREC_CALL 18
#define PREC_GROUP 19

struct Parser {
  struct Token current;
  struct Token previous;
  bool hadError;
  bool panicMode;
  struct Chunk *currentChunk;
  struct Scanner *scanner;
  struct VM *vm;
};

struct ParseRule {
  void (*prefix)(struct Parser *parser);
  void (*suffix)(struct Parser *parser);
  Precedence precedence;
};

static struct Chunk* currentChunk(struct Parser *parser) {
  return parser->currentChunk;
}

static void errorAt(struct Parser *parser, struct Token* token, const char* message) {
  if (parser->panicMode) return;
  parser->panicMode = true;

  printf("[line %d] Error", token->line);

  if (token->type == TOKEN_EOF) {
    printf(" at end");
  } else if (token->type == TOKEN_ERROR) {
    // Nothing.
  } else {
    printf(" at '");
    for (unsigned int i = 0; i < token->length; ++i) {
      putchar(token->start[i]);
    }
    printf("'");
  }

  printf(": %s\n", message);
  parser->hadError = true;
}

static void errorAtCurrent(struct Parser *parser, const char* message) {
  errorAt(parser, &parser->current, message);
}

static void error(struct Parser *parser, const char* message) {
  errorAt(parser, &parser->previous, message);
}

static void advance(struct Parser *parser) {
  parser->previous = parser->current;

  for (;;) {
    struct Token token;
    scanToken(parser->scanner, &token);

    #ifdef DEBUG_PRINT_TOKENS
      printf("%04u %02u ", token.line, token.type);
      for (unsigned i = 0; i < token.length; ++i) {
        printf("%c", token.start[i]);
      }
      printf("\n");
    #endif

    parser->current = token;
    if (parser->current.type != TOKEN_ERROR) break;

    errorAtCurrent(parser, parser->current.start);
  }
}

static void consume(struct Parser *parser, TokenType type, const char* message) {
  if (parser->current.type == type) {
    advance(parser);
    return;
  }

  errorAtCurrent(parser, message);
}

static void emitByte(struct Parser *parser, uint8_t byte) {
  writeChunk(currentChunk(parser), byte, parser->previous.line);
}

static void emitBytes(struct Parser *parser, uint8_t byte1, uint8_t byte2) {
  emitByte(parser, byte1);
  emitByte(parser, byte2);
}

static void emitReturn(struct Parser *parser) {
  emitByte(parser, OP_RETURN);
}

static uint8_t makeConstant(struct Parser *parser, struct Value *value) {
  unsigned int constant = addConstant(currentChunk(parser), value);
  if (constant > 256) {
    error(parser, "Too many constants in one chunk.");
    return 0;
  }

  return (uint8_t)constant;
}

static void emitConstant(struct Parser *parser, struct Value *value) {
  emitBytes(parser, OP_CONSTANT, makeConstant(parser, value));
}

static void endCompiler(struct Parser *parser) {
  emitReturn(parser);

  #ifdef DEBUG_PRINT_CODE
    if (!parser->hadError) {
      printf("\n");
      disassembleChunk(currentChunk(parser), "code");
    }
  #endif
}

static void expression();
static struct ParseRule* getRule(TokenType type);
static void parsePrecedence(struct Parser *parser, Precedence precedence);

static void number(struct Parser *parser) {
  struct Value value;
  int number;
  number = atoi(parser->previous.start);
  intVal(number, &value);
  emitConstant(parser, &value);
}
static void string(struct Parser *parser) {
  struct Value value;
  objVal(copyString(parser->previous.start + 1, parser->previous.length - 2, parser->vm), &value);
  emitConstant(parser, &value);
}

static void newline(struct Parser *parser) {
}

static void grouping(struct Parser *parser) {
  expression(parser);
  consume(parser, TOKEN_RIGHT_PAREN, "Expect ')' after expression.");
}

static void binary(struct Parser *parser) {
  TokenType operatorType = parser->previous.type;

  struct ParseRule* rule = getRule(operatorType);
  parsePrecedence(parser, (Precedence)(rule->precedence + 1));

  if (operatorType == TOKEN_PLUS) {
    emitByte(parser, OP_ADD);
  } else if (operatorType == TOKEN_MINUS) {
    emitByte(parser, OP_SUBTRACT);
  } else if (operatorType == TOKEN_STAR) {
    emitByte(parser, OP_MULTIPLY);
  } else if (operatorType == TOKEN_SLASH) {
    emitByte(parser, OP_DIVIDE);
  } else if (operatorType == TOKEN_EQUAL_EQUAL) {
    emitByte(parser, OP_EQUAL);
  } else if (operatorType == TOKEN_NOT_EQUAL) {
    emitBytes(parser, OP_EQUAL, OP_NOT);
  } else if (operatorType == TOKEN_GREATER) {
    emitByte(parser, OP_GREATER);
  } else if (operatorType == TOKEN_GREATER_EQUAL) {
    emitBytes(parser, OP_LESS, OP_NOT);
  } else if (operatorType == TOKEN_LESS) {
    emitByte(parser, OP_LESS);
  } else if (operatorType == TOKEN_LESS_EQUAL) {
    emitBytes(parser, OP_GREATER, OP_NOT);
  }
}

static void unary(struct Parser *parser) {
  TokenType operatorType = parser->previous.type;

  parsePrecedence(parser, PREC_UNARY);

  if (operatorType == TOKEN_MINUS) {
    emitByte(parser, OP_NEGATE);
  } else if (operatorType == TOKEN_NOT) {
    emitByte(parser, OP_NOT);
  }
}

static void literal(struct Parser *parser) {
  TokenType operatorType = parser->previous.type;
  struct Value value;

  if (operatorType == TOKEN_NONE) {
    noneVal(&value);
    emitConstant(parser, &value);
  } else if (operatorType == TOKEN_TRUE) {
    boolVal(true, &value);
    emitConstant(parser, &value);
  } else if (operatorType == TOKEN_FALSE) {
    boolVal(false, &value);
    emitConstant(parser, &value);
  }
}

struct ParseRule rules[61];

static struct ParseRule* getRule(TokenType type) {
  return &rules[type];
}

static void initRule(struct ParseRule *rule, void (*prefix)(struct Parser *parser),
                     void (*suffix)(struct Parser *parser), Precedence precedence) {
  rule->prefix = prefix;
  rule->suffix = suffix;
  rule->precedence = precedence;
}

static void expression(struct Parser *parser) {
  parsePrecedence(parser, PREC_NEWLINE);
}

void parsePrecedence(struct Parser *parser, Precedence precedence) {
  advance(parser);
  void (*prefixRule)(struct Parser *parser) = (getRule(parser->previous.type))->prefix;
  if (prefixRule == NULL) {
    error(parser, "Expect expression.");
    return;
  }

  prefixRule(parser);

  while (precedence <= (getRule(parser->current.type))->precedence) {
    advance(parser);
    void (*suffixRule)(struct Parser *parser) = (getRule(parser->previous.type))->suffix;
    suffixRule(parser);
  }
}

bool compile(const char* source, struct Chunk *chunk, struct VM *vm) {
  initRule(&rules[TOKEN_NUMBER], number, NULL, PREC_NONE);
  initRule(&rules[TOKEN_STRING], string, NULL, PREC_NONE);
  initRule(&rules[TOKEN_NONE], literal, NULL, PREC_NONE);
  initRule(&rules[TOKEN_TRUE], literal, NULL, PREC_NONE);
  initRule(&rules[TOKEN_FALSE], literal, NULL, PREC_NONE);

  initRule(&rules[TOKEN_PLUS], unary, binary, PREC_ADDITION);
  initRule(&rules[TOKEN_MINUS], unary, binary, PREC_ADDITION);
  initRule(&rules[TOKEN_STAR], NULL, binary, PREC_MULTIPLICATION);
  initRule(&rules[TOKEN_SLASH], NULL, binary, PREC_MULTIPLICATION);

  initRule(&rules[TOKEN_NOT], unary, NULL, PREC_NONE);
  initRule(&rules[TOKEN_EQUAL_EQUAL], NULL, binary, PREC_COMPARISON);
  initRule(&rules[TOKEN_NOT_EQUAL], NULL, binary, PREC_COMPARISON);
  initRule(&rules[TOKEN_GREATER], NULL, binary, PREC_COMPARISON);
  initRule(&rules[TOKEN_GREATER_EQUAL], NULL, binary, PREC_COMPARISON);
  initRule(&rules[TOKEN_LESS], NULL, binary, PREC_COMPARISON);
  initRule(&rules[TOKEN_LESS_EQUAL], NULL, binary, PREC_COMPARISON);

  initRule(&rules[TOKEN_LEFT_PAREN], grouping, NULL, PREC_CALL);
  initRule(&rules[TOKEN_NEWLINE], NULL, newline, PREC_NEWLINE);

  struct Scanner scanner;
  struct Parser parser;
  initScanner(&scanner, source);

  parser.currentChunk = chunk;
  parser.scanner = &scanner;
  parser.vm = vm;
  parser.hadError = false;
  parser.panicMode = false;

  #ifdef DEBUG_PRINT_TOKENS
    printf("START PARSE\n");
  #endif

  advance(&parser);
  expression(&parser);
  consume(&parser, TOKEN_EOF, "Expected end of expression.");
  endCompiler(&parser);
  return !parser.hadError;
}