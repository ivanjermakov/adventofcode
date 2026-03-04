#include "common.h"
#include "day1a.h"
#include "day1b.h"

int main() {
    char input[1 << 14];
    FILE* f;

    f = fopen("data/1.txt", "r");
    if (!f) return 1;
    size_t size = fread(input, 1, sizeof input, f) - 1;
    printf("day 1a: %ld\n", day1a_solve(input, size));
    printf("day 1b: %ld\n", day1b_solve(input, size));

    return 0;
}
