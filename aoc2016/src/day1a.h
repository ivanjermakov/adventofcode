#include "common.h"

int64_t day1a_solve(char input[], size_t size) {
    int64_t vert = 0;
    int64_t horiz = 0;
    // 0 north, 1 east, 2 south, 3 west
    int8_t dir = 0;
    size_t i = 0;
    while (i < size) {
        switch (input[i]) {
            case 'R': dir = (4 + dir + 1) % 4; break;
            case 'L': dir = (4 + dir - 1) % 4; break;
            default: assert(false);
        }
        i++;
        char* end;
        int32_t n = strtol(&input[i], &end, 10);
        size_t l = end - &input[i];
        switch (dir) {
            case 0: vert += n; break;
            case 1: horiz += n; break;
            case 2: vert -= n; break;
            case 3: horiz -= n; break;
        }
        i += l;
        i += 2;
    }
    return labs(vert) + labs(horiz);
}
