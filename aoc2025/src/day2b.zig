const std = @import("std");
const day2a = @import("day2a.zig");

const modulosMulti = [_][]const u64{
    &.{},
    &.{},
    &.{11},
    &.{111},
    &.{ 101, 1111 },
    &.{11111},
    &.{ 1001, 111111, 10101 },
    &.{1111111},
    &.{ 10001, 11111111, 1010101 },
    &.{ 111111111, 1001001 },
    &.{ 100001, 1111111111, 101010101 },
};

pub fn solve(input: []const u8) !usize {
    return day2a.solveModulos(input, &modulosMulti);
}

test "demo" {
    const input =
        \\11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
        \\
    ;
    try std.testing.expectEqual(4174379265, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day2.txt", &buf);
    try std.testing.expectEqual(49046150754, solve(input));
}
