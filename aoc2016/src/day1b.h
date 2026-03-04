#include "common.h"

bool contains(Vec2 haystack[], size_t haystack_len, Vec2 needle) {
    for (size_t i = 0; i < haystack_len; i++) {
        if (memcmp(&haystack[i], &needle, sizeof(Vec2)) == 0) return true;
    }
    return false;
}

int64_t day1b_solve(char input[], size_t size) {
    Vec2 visited[1 << 10];
    size_t visited_len = 0;
    Vec2 p = {};
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
        for (size_t j = 0; j < n; j++) {
            switch (dir) {
                case 0: p.y++; break;
                case 1: p.x++; break;
                case 2: p.y--; break;
                case 3: p.x--; break;
            }
            if (contains(visited, visited_len, p)) {
                return labs(p.x) + labs(p.y);
            }
            visited[visited_len++] = p;
        }
        i += l;
        i += 2;
    }
    return -1;
}
