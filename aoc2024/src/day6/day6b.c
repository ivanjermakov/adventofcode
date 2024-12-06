#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdbool.h>
#include <limits.h>
#include <string.h>
#include <sys/mman.h>

#define N 130
size_t loop_threshold = N * N / 2;

bool obstacles[N][N];

struct Pos {
    size_t x;
    size_t y;
    // 0 is up, 1 is right, 2 is down, 3 is left
    size_t dir;
};

bool is_obstacle(size_t x, size_t y) {
    if (x >= N || x < 0 || y >= N || y < 0) return false;
    return obstacles[y][x];
}

bool looping(struct Pos guard) {
    size_t steps = 0;
    while (true) {
        if (
            (guard.dir == 0 && is_obstacle(guard.x, guard.y - 1)) ||
            (guard.dir == 1 && is_obstacle(guard.x + 1, guard.y)) ||
            (guard.dir == 2 && is_obstacle(guard.x, guard.y + 1)) ||
            (guard.dir == 3 && is_obstacle(guard.x - 1, guard.y))
        ) {
            guard.dir = (guard.dir + 1) % 4;
            continue;
        }

        if (guard.x >= N || guard.x < 0 || guard.y >= N || guard.y < 0) return false;
        if (guard.dir == 0) guard.y--;
        if (guard.dir == 1) guard.x++;
        if (guard.dir == 2) guard.y++;
        if (guard.dir == 3) guard.x--;

        steps++;
        if (steps > loop_threshold) return true;
    }
}

int main() {
    int f = open("data/day6.txt", O_RDONLY);
    struct stat sb;
    fstat(f, &sb);
    size_t len = sb.st_size;
    void* mapped = mmap(NULL, len, PROT_READ, MAP_PRIVATE, f, 0);
    char* input = (char*) mapped;

    struct Pos guard;
    guard.dir = 0;

    size_t x = 0;
    size_t y = 0;
    for (size_t i = 0; i < len; i++) {
        if (input[i] == '\n') {
            y++;
            x = 0;
        } else if (input[i] == '^') {
            guard.x = x;
            guard.y = y;
            x++;
        } else {
            if (input[i] == '#') {
                obstacles[y][x] = true;
            }
            x++;
        }
    }

    struct Pos fguard = guard;
    struct Pos visited[N * N];
    size_t visited_len = 0;
    visited[0] = (struct Pos){.x = fguard.x, .y = fguard.y };
    while (true) {
        if (fguard.x >= N || fguard.x < 0 || fguard.y >= N || fguard.y < 0) break;

        size_t i = 0;
        while (i <= visited_len) {
            if (i == visited_len) {
                visited[i] = (struct Pos){.x = fguard.x, .y = fguard.y };
                visited_len++;
                break;
            }
            if (visited[i].x == fguard.x && visited[i].y == fguard.y) {
                break;
            }
            i++;
        }

        if (
                (fguard.dir == 0 && is_obstacle(fguard.x, fguard.y - 1)) ||
                (fguard.dir == 1 && is_obstacle(fguard.x + 1, fguard.y)) ||
                (fguard.dir == 2 && is_obstacle(fguard.x, fguard.y + 1)) ||
                (fguard.dir == 3 && is_obstacle(fguard.x - 1, fguard.y))
        ) {
            fguard.dir = (fguard.dir + 1) % 4;
            continue;
        }
        if (fguard.dir == 0) fguard.y--;
        if (fguard.dir == 1) fguard.x++;
        if (fguard.dir == 2) fguard.y++;
        if (fguard.dir == 3) fguard.x--;
    }

    size_t result = 0;
    for (size_t i = 1; i < visited_len; i++) {
        size_t x = visited[i].x;
        size_t y = visited[i].y;
        obstacles[y][x] = true;
        if (looping(guard)) result++;
        obstacles[y][x] = false;
    }

    printf("%d\n", result);

    return 0;
}

