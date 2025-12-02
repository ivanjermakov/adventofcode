const std = @import("std");
const day2a = @import("day2a.zig");

pub fn solve(input: []const u8) !usize {
    var alloc_buf: [1 << 14]u8 = undefined;
    var alloc: std.heap.FixedBufferAllocator = .init(&alloc_buf);
    var map: std.AutoArrayHashMap(u64, void) = .init(alloc.allocator());

    const in = if (input[input.len - 1] == '\n') input[0 .. input.len - 2] else input;
    var it = std.mem.splitScalar(u8, in, ',');
    var total: u64 = 0;

    while (it.next()) |range| {
        var range_it = std.mem.splitScalar(u8, range, '-');
        const from_str = range_it.next().?;
        const from = try std.fmt.parseInt(u64, from_str, 10);
        const to_str = range_it.next().?;
        const to = try std.fmt.parseInt(u64, to_str, 10);
        if (from_str.len == to_str.len) {
            map.clearRetainingCapacity();
            for (modulos[from_str.len]) |ms| total += sumRange(from, to, ms, &map);
        } else {
            for (from..to + 1) |i| {
                if (isInvalid(i)) total += i;
            }
        }
    }
    return total;
}

const modulos = [_][]const u64{
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

fn isInvalid(n: u64) bool {
    const ds = day2a.digits(n);
    for (modulos[ds]) |m| {
        if (n % m == 0) return true;
    }
    return false;
}

fn sumRange(from: u64, to: u64, m: u64, map: *std.AutoArrayHashMap(u64, void)) u64 {
    var total: u64 = 0;
    var n = from - @mod(from, m);
    while (n <= to) {
        if (n >= from and !map.contains(n)) {
            total += n;
            map.put(n, {}) catch unreachable;
        }
        n += m;
    }
    return total;
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

test "day2b demo" {
    const input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    try std.testing.expectEqual(4174379265, solve(input));
}

test "day2b" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day2.txt", &buf);
    try std.testing.expectEqual(49046150754, solve(input));
}
