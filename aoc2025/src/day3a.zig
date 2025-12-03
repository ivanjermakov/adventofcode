const std = @import("std");

pub fn solve(input: []const u8) !usize {
    const in = if (input[input.len - 1] == '\n') input[0 .. input.len - 2] else input;
    var it = std.mem.splitScalar(u8, in, '\n');
    var total: usize = 0;
    while (it.next()) |line| total += largestJoltage(line, 2);
    return total;
}

pub fn largestJoltage(line: []const u8, digits: comptime_int) usize {
    var largest = std.mem.zeroes([digits]u8);
    var largest_idx: usize = 0;
    for (0..line.len - 1) |i| {
        const d = line[i] - '0';
        if (d > largest[0]) {
            largest[0] = d;
            largest_idx = i;
        }
    }
    for (largest_idx + 1..line.len) |i| {
        const d = line[i] - '0';
        if (d > largest[1]) largest[1] = d;
    }
    return 10 * largest[0] + largest[1];
}

test "day3a demo" {
    const input =
        \\987654321111111
        \\811111111111119
        \\234234234234278
        \\818181911112111
    ;
    try std.testing.expectEqual(357, solve(input));
}

test "day3a" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day3.txt", &buf);
    try std.testing.expectEqual(17158, solve(input));
}
