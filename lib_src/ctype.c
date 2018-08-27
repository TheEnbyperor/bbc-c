#include "stdbool.h"

bool isupper(int c) {
	return c >= 'A' && c <= 'Z';
}

bool islower(int c) {
	return c >= 'a' && c <= 'z';
}

bool isalpha(int c) {
	return islower(c) || isupper(c);
}

bool isdigit(int c) {
	return c >= '0' && c <= '9';
}

bool isalnum(int c) {
	return isalpha(c) || isdigit(c);
}

bool isascii(int c) {
	return c <= 127;
}

bool isblank(int c) {
	return (c == '\t') || (c == ' ');
}

bool iscntrl(int c) {
	return c < 32;
}

bool isspace(int c) {
	return c == ' ' || c == '\n' || c == '\t' || c == '\r';
}

bool isxdigit(int c) {
	return isdigit(c) || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F');
}

bool toupper(int c) {
	return islower(c) ? (c & ~32) : c;
}

bool tolower(int c) {
	return isupper(c) ? (c | 32) : c;
}