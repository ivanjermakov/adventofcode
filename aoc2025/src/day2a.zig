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

fn isInvalid(n: u64) bool {
    const ds = digits(n);
    if (ds % 2 != 0) return false;
    const hl = @divExact(ds, 2);
    return slice(n, 0, hl, ds) == slice(n, hl, ds, ds);
}

fn digits(n: u64) u8 {
    var d: u8 = 1;
    inline for (1..12) |e| d += @intFromBool(n >= std.math.pow(u64, 10, e));
    return d;
}

fn slice(n: u64, start: u8, end: u8, ds: u8) u64 {
    const powers = [_]u64{ 1, 10, 100, 1000, 10000, 100000, 1000000, 10000000 };
    const left: u64 = ds - end;
    const len: u64 = end - start;
    return @mod(@divFloor(n, powers[left]), powers[len]);
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
