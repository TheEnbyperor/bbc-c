#include "io.h"

#define SCREEN_START 0x7C00

int main() {
    writeio(0xFE00, 12);
    writeio(0xFE01, ((SCREEN_START >> 4) - 0x74) ^ 0x20);
}

