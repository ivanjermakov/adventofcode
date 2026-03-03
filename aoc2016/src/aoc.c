#include "common.h"
#include "day1a.h"

int main() {
    FILE* f = fopen("data/1.txt", "r");
    if (!f) return 1;

    char input[1 << 14];
    size_t size = fread(input, 1, sizeof input, f);
    int64_t res = day1a_solve(input, size - 1);
    printf("day 1a: %ld\n", res);

    return 0;
}
