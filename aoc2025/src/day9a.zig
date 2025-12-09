const std = @import("std");

pub const Vec2 = struct {
    const Size = u32;

    x: Size,
    y: Size,

    pub fn parse(line: []const u8) Vec2 {
        var it = std.mem.splitScalar(u8, line, ',');
        return .{
            .x = std.fmt.parseUnsigned(Size, it.next().?, 10) catch unreachable,
            .y = std.fmt.parseUnsigned(Size, it.next().?, 10) catch unreachable,
        };
    }

    pub fn area(self: Vec2, other: Vec2) u64 {
        const dx = @abs(@as(i64, self.x) - other.x) + 1;
        const dy = @abs(@as(i64, self.y) - other.y) + 1;
        return @intCast(dx * dy);
    }
};

pub fn solve(input: []const u8) !usize {
    var it = std.mem.splitScalar(u8, input[0 .. input.len - 1], '\n');
    const boxes_len = std.mem.count(u8, input, "\n");
    var tiles_buf: [2 << 8]Vec2 = undefined;
    var tile_idx: usize = 0;
    while (it.next()) |line| {
        defer tile_idx += 1;
        const tile: Vec2 = .parse(line);
        tiles_buf[tile_idx] = tile;
    }
    const tiles = tiles_buf[0..boxes_len];

    var max_area: usize = 0;
    for (0..tiles.len - 1) |t1| {
        for (t1 + 1..tiles.len) |t2| {
            const a = tiles[t1].area(tiles[t2]);
            if (a > max_area) max_area = a;
        }
    }
    return max_area;
}

test "demo" {
    const input =
        \\7,1
        \\11,1
        \\11,7
        \\9,7
        \\9,5
        \\2,5
        \\2,3
        \\7,3
        \\
    ;
    try std.testing.expectEqual(50, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day9.txt", &buf);
    try std.testing.expectEqual(4738108384, solve(input));
}
