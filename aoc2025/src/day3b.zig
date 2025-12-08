const std = @import("std");
const day3a = @import("day3a.zig");

pub fn solve(input: []const u8) !usize {
    var it = std.mem.splitScalar(u8, input[0..input.len - 1], '\n');
    var total: usize = 0;
    while (it.next()) |line| total += day3a.largestJoltage(line, 12);
    return total;
}

test "demo" {
    const input =
        \\987654321111111
        \\811111111111119
        \\234234234234278
        \\818181911112111
        \\
    ;
    try std.testing.expectEqual(3121910778619, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day3.txt", &buf);
    try std.testing.expectEqual(170449335646486, solve(input));
}
