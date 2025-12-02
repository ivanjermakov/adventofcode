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

fn isInvalid(i: u64) bool {
    var buf: [32]u8 = undefined;
    const str = buf[0..std.fmt.printInt(&buf, i, 10, .lower, .{})];
    b: for (1..16) |pattern_len| {
        if (str.len % pattern_len != 0) continue;
        const pattern_count = @divExact(str.len, pattern_len);
        if (pattern_count < 2) continue;
        const pattern = str[0..pattern_len];
        for (1..pattern_count) |pi| {
            if (!std.mem.eql(u8, pattern, str[pi * pattern_len .. (pi + 1) * pattern_len])) continue :b;
        }
        return true;
    }
    return false;
}

test "isInvalid" {
    try std.testing.expectEqual(false, isInvalid(10));
    try std.testing.expectEqual(true, isInvalid(11));
    try std.testing.expectEqual(false, isInvalid(20));
    try std.testing.expectEqual(true, isInvalid(22));
    try std.testing.expectEqual(false, isInvalid(990));
    try std.testing.expectEqual(true, isInvalid(999));
    try std.testing.expectEqual(false, isInvalid(1011));
    try std.testing.expectEqual(true, isInvalid(1010));
}

test "day2a demo" {
    const input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    try std.testing.expectEqual(4174379265, solve(input));
}

test "day2a" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day2.txt", &buf);
    try std.testing.expectEqual(49046150754, solve(input));
}
