const std = @import("std");

pub fn solve(input: []const u8) !usize {
    const in = if (input[input.len - 1] == '\n') input[0 .. input.len - 2] else input;
    var it = std.mem.splitScalar(u8, in, ',');
    var total: u64 = 0;

    while (it.next()) |range| {
        var range_it = std.mem.splitScalar(u8, range, '-');
        const from_str = range_it.next().?;
        const from = try std.fmt.parseInt(u64, from_str, 10);
        const to_str = range_it.next().?;
        const to = try std.fmt.parseInt(u64, to_str, 10);
        for (from..to + 1) |i| {
            if (isInvalid(i)) total += i;
        }
    }
    return total;
}

pub const powers = [_]u64{ 1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, 10000000000, 100000000000 };

pub fn digits(n: u64) u8 {
    var d: u8 = 1;
    inline for (1..12) |e| d += @intFromBool(n >= powers[e]);
    return d;
}

fn isInvalid(n: u64) bool {
    const ds = digits(n);
    if (ds > 10) std.debug.assert(false);
    if (ds == 10) return n % 100_001 == 0;
    if (ds == 8) return n % 10_001 == 0;
    if (ds == 6) return n % 1_001 == 0;
    if (ds == 4) return n % 101 == 0;
    if (ds == 2) return n % 11 == 0;
    return false;
}

test "isInvalid" {
    try std.testing.expectEqual(false, isInvalid(10));
    try std.testing.expectEqual(true, isInvalid(11));
    try std.testing.expectEqual(false, isInvalid(20));
    try std.testing.expectEqual(true, isInvalid(22));
    try std.testing.expectEqual(false, isInvalid(9099));
    try std.testing.expectEqual(true, isInvalid(9090));
    try std.testing.expectEqual(false, isInvalid(1011));
    try std.testing.expectEqual(true, isInvalid(1010));
}

test "day2a demo" {
    const input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    try std.testing.expectEqual(1227775554, solve(input));
}

test "day2a" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day2.txt", &buf);
    try std.testing.expectEqual(38437576669, solve(input));
}
