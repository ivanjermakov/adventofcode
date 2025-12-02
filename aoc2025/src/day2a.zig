const std = @import("std");

pub fn solve(input: []const u8) !usize {
    return solveModulos(input, &modulosHalf);
}

const modulosHalf = [_][]const u64{
    &.{},
    &.{},
    &.{11},
    &.{},
    &.{101},
    &.{},
    &.{1001},
    &.{},
    &.{10001},
    &.{},
    &.{100001},
};

pub fn solveModulos(input: []const u8, modulos: []const []const u64) !usize {
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
        for (from_str.len..to_str.len + 1) |len| {
            map.clearRetainingCapacity();
            const sub_from = @max(from, powers[len - 1]);
            const sub_to = @min(to, powers[len]);
            for (modulos[len]) |ms| total += sumRange(sub_from, sub_to, ms, &map);
        }
    }
    return total;
}

pub fn isInvalid(n: u64, modulos: []const []const u64) bool {
    const ds = digits(n);
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

pub const powers = [_]u64{ 1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, 10000000000, 100000000000 };

pub fn digits(n: u64) u8 {
    var d: u8 = 1;
    inline for (1..12) |e| d += @intFromBool(n >= powers[e]);
    return d;
}

test "isInvalid" {
    try std.testing.expectEqual(false, isInvalid(10, &modulosHalf));
    try std.testing.expectEqual(true, isInvalid(11, &modulosHalf));
    try std.testing.expectEqual(false, isInvalid(20, &modulosHalf));
    try std.testing.expectEqual(true, isInvalid(22, &modulosHalf));
    try std.testing.expectEqual(false, isInvalid(9099, &modulosHalf));
    try std.testing.expectEqual(true, isInvalid(9090, &modulosHalf));
    try std.testing.expectEqual(false, isInvalid(1011, &modulosHalf));
    try std.testing.expectEqual(true, isInvalid(1010, &modulosHalf));
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
