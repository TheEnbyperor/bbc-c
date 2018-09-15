#include "string.h"
#include "ctype.h"
#include "common.h"
#include "scanner.h"

static void pushIndent(Scanner *scanner, int indent);

void initScanner(Scanner *scanner, const char *source) {
    scanner->start = source;
    scanner->current = source;
    scanner->line = 1;
    scanner->isStartOfLine = true;
    scanner->curIndent = &scanner->indent;

    pushIndent(scanner, 0);
}

static bool isAtEnd(Scanner *scanner) {
    return *scanner->current == '\0';
}

static void pushIndent(Scanner *scanner, int indent) {
    *scanner->curIndent = indent;
    ++scanner->curIndent;
}

static int popIndent(Scanner *scanner) {
    --scanner->curIndent;
    return *scanner->curIndent;
}

static int peekIndent(Scanner *scanner) {
    return scanner->curIndent[-1];
}

static void makeToken(Scanner *scanner, Token *token, TokenType type) {
    token->type = type;
    token->start = scanner->start;
    token->length = (int) (scanner->current - scanner->start);
    token->line = scanner->line;
}

static void errorToken(Scanner *scanner, Token *token, const char *message) {
    token->type = TOKEN_ERROR;
    token->start = message;
    token->length = (int) strlen(message);
    token->line = scanner->line;
}

static char advance(Scanner *scanner) {
    char a = *scanner->current;
    scanner->current++;
    return a;
}

static char peek(Scanner *scanner) {
    return *scanner->current;
}

static bool match(Scanner *scanner, char expected) {
    if (isAtEnd(scanner)) return false;
    if (*scanner->current != expected) return false;

    scanner->current++;
    return true;
}

static void skipWhitespace(Scanner *scanner) {
    for (;;) {
        char c = peek(scanner);
        if (c == ' ' || c == '\r' || c == '\t') {
            advance(scanner);
        } else if (c == '#') {
            while (peek(scanner) != '\n' && !isAtEnd(scanner)) advance(scanner);
        } else {
            return;
        }
    }
}

static bool indent(Scanner *scanner, Token *token) {
    int indent;
    indent = 0;
    for (;;) {
        char c = peek(scanner);
        if (c == ' ' || c == '\t') {
            advance(scanner);
            if (c == '\t') {
                indent += 4;
            } else {
                indent += 1;
            }
        } else if (c == '\n') {
            return false;
        } else {
            break;
        }
    }

    int curIndent = peekIndent(scanner);
    if (indent == curIndent) {
        return false;
    } else if (indent > curIndent) {
        pushIndent(scanner, indent);
        makeToken(scanner, token, TOKEN_INDENT);
        return true;
    } else if (indent < curIndent) {
        do {
            popIndent(scanner);
            if ((curIndent = peekIndent(scanner)) == indent) {
                makeToken(scanner, token, TOKEN_DEDENT);
                return true;
            }
        } while (indent < curIndent);
        errorToken(scanner, token, "Invalid indent.");
        return true;
    }
}

static bool isAlpha(char c) {
    return isalpha(c) || c == '_';
}

static void string(Scanner *scanner, Token *token, char start) {
    while (peek(scanner) != start && peek(scanner) != '\n' && !isAtEnd(scanner)) {
        advance(scanner);
    }

    if (isAtEnd(scanner) || peek(scanner) == '\n') {
        errorToken(scanner, token, "Unterminated string.");
        return;
    }

    advance(scanner);
    makeToken(scanner, token, TOKEN_STRING);
    return;
}

static void number(Scanner *scanner, Token *token) {
    while (isdigit(peek(scanner))) {
        advance(scanner);
    }

    makeToken(scanner, token, TOKEN_NUMBER);
    return;
}

static TokenType checkKeyword(Scanner *scanner, int start, int length, const char *rest, TokenType type) {
    if (scanner->current - scanner->start == start + length &&
        memcmp(scanner->start + start, rest, length) == 0) {
        return type;
    }

    return TOKEN_IDENTIFIER;
}

static TokenType identifierType(Scanner *scanner) {
    char c = scanner->start[0];
    unsigned int len = scanner->current - scanner->start;
    if (c == 'b') return checkKeyword(scanner, 1, 4, "reak", TOKEN_BREAK);
    else if (c == 'g') return checkKeyword(scanner, 1, 5, "lobal", TOKEN_GLOBAL);
    else if (c == 'l') return checkKeyword(scanner, 1, 5, "ambda", TOKEN_LAMBDA);
    else if (c == 'o') return checkKeyword(scanner, 1, 1, "r", TOKEN_OR);
    else if (c == 'p') return checkKeyword(scanner, 1, 3, "ass", TOKEN_PASS);
    else if (c == 'y') return checkKeyword(scanner, 1, 4, "ield", TOKEN_YIELD);
    else if (c == 'F') return checkKeyword(scanner, 1, 4, "alse", TOKEN_FALSE);
    else if (c == 'T') return checkKeyword(scanner, 1, 3, "rue", TOKEN_TRUE);
    else if (c == 't') return checkKeyword(scanner, 1, 2, "ry", TOKEN_TRY);
    else if (c == 'N') return checkKeyword(scanner, 1, 3, "one", TOKEN_NONE);
    else if (c == 'c' && len > 1) {
        c = scanner->start[1];
        if (c == 'l') return checkKeyword(scanner, 2, 3, "ass", TOKEN_AWAIT);
        else if (c == 'o') return checkKeyword(scanner, 2, 6, "ntinue", TOKEN_CONTINUE);
    } else if (c == 'f' && len > 1) {
        c = scanner->start[1];
        if (c == 'i') return checkKeyword(scanner, 2, 5, "nally", TOKEN_FINALLY);
        else if (c == 'o') return checkKeyword(scanner, 2, 1, "r", TOKEN_FOR);
        else if (c == 'r') return checkKeyword(scanner, 2, 2, "om", TOKEN_FROM);
    } else if (c == 'r' && len > 1) {
        c = scanner->start[1];
        if (c == 'a') return checkKeyword(scanner, 2, 3, "ise", TOKEN_RAISE);
        else if (c == 'e') return checkKeyword(scanner, 2, 4, "turn", TOKEN_RETURN);
    } else if (c == 'w' && len > 1) {
        c = scanner->start[1];
        if (c == 'h') return checkKeyword(scanner, 2, 3, "ile", TOKEN_WHILE);
        else if (c == 'i') return checkKeyword(scanner, 2, 2, "th", TOKEN_WITH);
    } else if (c == 'i' && len > 1) {
        c = scanner->start[1];
        if (c == 'm') return checkKeyword(scanner, 2, 4, "port", TOKEN_IMPORT);
        else if (c == 'n') return TOKEN_IN;
        else if (c == 's') return TOKEN_IS;
        else if (c == 'f') return TOKEN_IF;
    } else if (c == 'a' && len > 1) {
        c = scanner->start[1];
        if (c == 'w') return checkKeyword(scanner, 2, 3, "ait", TOKEN_AWAIT);
        else if (c == 'n') return checkKeyword(scanner, 2, 1, "d", TOKEN_AND);
        else if (c == 's' && len == 2) return TOKEN_AS;
        else if (len > 2 && c == 's') {
            c = scanner->start[2];
            if (c == 'y') return checkKeyword(scanner, 3, 2, "nc", TOKEN_ASYNC);
            if (c == 's') return checkKeyword(scanner, 3, 3, "ert", TOKEN_ASSERT);
        }
    } else if (c == 'e' && len > 1) {
        c = scanner->start[1];
        if (c == 'x') return checkKeyword(scanner, 2, 4, "cept", TOKEN_EXCEPT);
        else if (len > 2 && c == 'l') {
            c = scanner->start[2];
            if (c == 'i') return checkKeyword(scanner, 3, 1, "f", TOKEN_ELIF);
            if (c == 's') return checkKeyword(scanner, 3, 1, "e", TOKEN_ELSE);
        }
    } else if (c == 'd' && len > 2 && scanner->start[1] == 'e') {
        c = scanner->start[2];
        if (c == 'f') return TOKEN_DEF;
        else if (c == 'l') return TOKEN_DEL;
    } else if (c == 'n' && len > 2 && scanner->start[1] == 'o') {
        c = scanner->start[2];
        if (c == 't') return TOKEN_NOT;
        else if (c == 'n') return checkKeyword(scanner, 3, 5, "local", TOKEN_NONLOCAL);
    }

    return TOKEN_IDENTIFIER;
}

static void identifier(Scanner *scanner, Token *token) {
    while (isAlpha(peek(scanner)) || isdigit(peek(scanner))) advance(scanner);

    makeToken(scanner, token, identifierType(scanner));
    return;
}

void scanToken(Scanner *scanner, Token *token) {
    if (scanner->isStartOfLine) {
        scanner->isStartOfLine = false;
        scanner->start = scanner->current;
        if (indent(scanner, token)) return;
    }

    skipWhitespace(scanner);

    scanner->start = scanner->current;

    if (isAtEnd(scanner)) {
        makeToken(scanner, token, TOKEN_EOF);
        return;
    }

    char c = advance(scanner);

    if (c == '\n') {
        makeToken(scanner, token, TOKEN_NEWLINE);
        token->length = 0;
        scanner->line++;
        scanner->isStartOfLine = true;
        return;
    } else if (c == '+') {
        makeToken(scanner, token, TOKEN_PLUS);
        return;
    } else if (c == '-') {
        makeToken(scanner, token, TOKEN_MINUS);
        return;
    } else if (c == '/') {
        makeToken(scanner, token, TOKEN_SLASH);
        return;
    } else if (c == '*') {
        makeToken(scanner, token, TOKEN_STAR);
        return;
    } else if (c == '(') {
        makeToken(scanner, token, TOKEN_LEFT_PAREN);
        return;
    } else if (c == ')') {
        makeToken(scanner, token, TOKEN_RIGHT_PAREN);
        return;
    } else if (c == '{') {
        makeToken(scanner, token, TOKEN_LEFT_BRACE);
        return;
    } else if (c == '}') {
        makeToken(scanner, token, TOKEN_RIGHT_BRACE);
        return;
    } else if (c == ',') {
        makeToken(scanner, token, TOKEN_COMMA);
        return;
    } else if (c == '.') {
        makeToken(scanner, token, TOKEN_DOT);
        return;
    } else if (c == ':') {
        makeToken(scanner, token, TOKEN_COLON);
        return;
    } else if (c == '!' && match(scanner, '=')) {
        makeToken(scanner, token, TOKEN_NOT_EQUAL);
        return;
    } else if (c == '=') {
        makeToken(scanner, token, match(scanner, '=') ? TOKEN_EQUAL_EQUAL : TOKEN_EQUAL);
        return;
    } else if (c == '<') {
        makeToken(scanner, token, match(scanner, '=') ? TOKEN_LESS_EQUAL : TOKEN_LESS);
        return;
    } else if (c == '>') {
        makeToken(scanner, token, match(scanner, '=') ? TOKEN_GREATER_EQUAL : TOKEN_GREATER);
        return;
    } else if (c == '"' || c == '\'') {
        string(scanner, token, c);
        return;
    } else if (isdigit(c)) {
        number(scanner, token);
        return;
    } else if (isAlpha(c)) {
        identifier(scanner, token);
        return;
    }

    errorToken(scanner, token, "Unexpected character");
    return;
}