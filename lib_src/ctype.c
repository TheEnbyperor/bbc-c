char isupper(char c) {
	return c >= 'A' && c <= 'Z';
}

char islower(char c) {
	return c >= 'a' && c <= 'z';
}

char isalpha(char c) {
	return islower(c) || isupper(c);
}

char isdigit(char c) {
	return ((unsigned char)c - '0') <= 9;
}

char isalnum(char c) {
	return isalpha(c) || isdigit(c);
}

char isascii(char c)
{
	return !(c & ~127);
}

char isblank(char c)
{
	return (c == '\t') || (c == ' ');
}

char iscntrl(char c)
{
	return c < 32;
}

char isspace(char c)
{
	return c == ' ' || c == '\n' || c == '\t' || c == '\r';
}

char isxdigit(char c)
{
	return isdigit(c) || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F');
}

char toupper(char c)
{
	return islower(c) ? (c & ~32) : c;
}

char tolower(char c)
{
	return isupper(c) ? (c | 32) : c;
}