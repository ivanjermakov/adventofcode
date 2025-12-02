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
        std.debug.print("{}-{}={}\n", .{ from, to, to - from });
        for (from..to + 1) |i| {
            if (isInvalid(i)) total += i;
        }
    }
    return total;
}

fn isInvalid(i: u64) bool {
    var buf: [32]u8 = undefined;
    const str = buf[0..std.fmt.printInt(&buf, i, 10, .lower, .{})];
    if (str.len % 2 != 0) return false;
    const hl = @divExact(str.len, 2);
    return std.mem.eql(u8, str[0..hl], str[hl..]);
}

test "day2a demo" {
    const input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    try std.testing.expectEqual(1227775554, solve(input));
}

test "day2a" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day2.txt", &buf);
    try std.testing.expectEqual(0, solve(input));
}
