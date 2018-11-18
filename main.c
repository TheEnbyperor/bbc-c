#include "stdio.h"
#include "stdint.h"
#include "stddef.h"

typedef unsigned int TokenType;
typedef uint8_t Precedence;
typedef void (*ParseFunc)();

typedef struct {
    ParseFunc prefix;
    ParseFunc suffix;
    Precedence precedence;
} ParseRule;

ParseRule rules[1];

static ParseRule *getRule(TokenType type) {
    return &rules[type];
}

void initRule(ParseRule *rule, ParseFunc prefix, ParseFunc suffix, Precedence precedence) {
    rule->prefix = prefix;
    rule->suffix = suffix;
    rule->precedence = precedence;
}

void number() {
}

int main() {
    initRule(&rules[0], number, NULL, 0);

    ParseFunc prefixRule = (getRule(0))->prefix;
    prefixRule();
}