#include "common.h"

int32_t clamp(int32_t a, int32_t low, int32_t high) {
    return MIN(high, MAX(a, low));
}

uint8_t lut[] = {7, 8, 9, 4, 5, 6, 1, 2, 3};

int64_t day2a_solve(char input[], size_t size) {
    Vec2 pos = {.x = 1, .y = 1};
    int64_t res;
    size_t i = 0;
    while (i < size) {
        char c = input[i];
        switch (c) {
            case '\n': {
                res *= 10;
                res += lut[3 * pos.y + pos.x];
                goto c;
            }
            case 'U': pos.y += 1; break;
            case 'R': pos.x += 1; break;
            case 'D': pos.y -= 1; break;
            case 'L': pos.x -= 1; break;
            default: assert(false);
        }
        pos.x = clamp(pos.x, 0, 2);
        pos.y = clamp(pos.y, 0, 2);
    c:
        i++;
    }

    res *= 10;
    res += lut[3 * pos.y + pos.x];
    return res;
}
