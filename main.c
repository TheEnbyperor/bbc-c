#include "stdio.h"
#include "stdlib.h"
#include "string.h"

#define PROMPT "$ "
#define EXIT "exit"
#define CLEAR "clear"
#define KEY_BUF_LEN 20
static char key_buffer[KEY_BUF_LEN];

int main() {
//    void *a = malloc(30);
//    realloc(a, 4);
//    realloc(a, 10);
//    realloc(a, 40);
    fputs(PROMPT);
//    while (1) {
//        char in = getchar();
//        if (in == 27) {
//            putchar('\n');
//            break;
//        } else if (in == 127) {
//            if (strlen(key_buffer) > 0) {
//                backspace(key_buffer);
//                putchar(in);
//            }
//        } else if (in == '\n') {
//            putchar('\n');
//            if (strcmp(key_buffer, EXIT) == 0) {
//                break;
//            } else if (strcmp(key_buffer, CLEAR) == 0) {
//                putchar(12);
//            } else {
//                puts(key_buffer);
//            }
//            key_buffer[0] = '\0';
//            fputs(PROMPT);
//        } else {
//            append(key_buffer, KEY_BUF_LEN, in);
//            putchar(in);
//        }
//    }
//    puts("Bye!");
}