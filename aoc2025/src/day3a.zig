const std = @import("std");
const day2a = @import("day2a.zig");

pub fn solve(input: []const u8) !usize {
    var it = std.mem.splitScalar(u8, input[0..input.len - 1], '\n');
    var total: usize = 0;
    while (it.next()) |line| total += largestJoltage(line, 2);
    return total;
}

pub fn largestJoltage(line: []const u8, digits: comptime_int) usize {
    var largest = std.mem.zeroes([digits]u8);
    var largest_idx: usize = 0;
    inline for (0..digits) |order| {
        for (largest_idx..line.len - (digits - order - 1)) |i| {
            if (line[i] > largest[order]) {
                largest[order] = line[i];
                largest_idx = i;
            }
        }
        largest_idx += 1;
    }
    var total: u64 = 0;
    for (0..digits) |i| {
        total += (largest[i] - '0') * day2a.powers[digits - i - 1];
    }
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
    try std.testing.expectEqual(357, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day3.txt", &buf);
    try std.testing.expectEqual(17158, solve(input));
}
