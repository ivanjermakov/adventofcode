#include "common.h"
#include "day1a.h"
#include "day1b.h"
#include "day2a.h"
#include "day2b.h"

int main() {
    char input[1 << 14];
    FILE* f;
    size_t size;

    f = fopen("data/1.txt", "r");
    if (!f) return 1;
    size = fread(input, 1, sizeof input, f) - 1;
    printf("day 1a: %ld\n", day1a_solve(input, size));
    printf("day 1b: %ld\n", day1b_solve(input, size));

    f = fopen("data/2.txt", "r");
    if (!f) return 1;
    size = fread(input, 1, sizeof input, f) - 1;
    printf("day 2a: %ld\n", day2a_solve(input, size));
    printf("day 2b: ");
    day2b_solve(input, size);
    printf("\n");

    return 0;
}
