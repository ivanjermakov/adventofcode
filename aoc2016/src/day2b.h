#include "common.h"

// clang-format off
uint8_t keypad[] = {
    0x0, 0x0, 0x1, 0x0, 0x0,
    0x0, 0x2, 0x3, 0x4, 0x0,
    0x5, 0x6, 0x7, 0x8, 0x9,
    0x0, 0xA, 0xB, 0xC, 0x0,
    0x0, 0x0, 0xD, 0x0, 0x0,
};
// clang-format on

void day2b_solve(char input[], size_t size) {
    Vec2 pos = {.x = 0, .y = 2};
    for (size_t i = 0; i < size; i++) {
        Vec2 pos_next = pos;
        char c = input[i];
        switch (c) {
            case '\n': {
                printf("%X", keypad[5 * pos.y + pos.x]);
                continue;
            }
            case 'U': pos_next.y -= 1; break;
            case 'R': pos_next.x += 1; break;
            case 'D': pos_next.y += 1; break;
            case 'L': pos_next.x -= 1; break;
            default: assert(false);
        }
        if (pos_next.x >= 0 && pos_next.x < 5 && pos_next.y >= 0 && pos_next.y < 5 &&
            keypad[5 * pos_next.y + pos_next.x] > 0) {
            pos = pos_next;
        }
    }

    printf("%X", keypad[5 * pos.y + pos.x]);
}
