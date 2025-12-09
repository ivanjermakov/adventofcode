const std = @import("std");
const day9a = @import("day9a.zig");
const Vec2 = day9a.Vec2;

pub fn solve(input: []const u8) !usize {
    var it = std.mem.splitScalar(u8, input[0 .. input.len - 1], '\n');
    const tiles_len = std.mem.count(u8, input, "\n");
    var tiles_buf: [2 << 8]Vec2 = undefined;
    var tile_idx: usize = 0;
    while (it.next()) |line| {
        defer tile_idx += 1;
        const tile: Vec2 = .parse(line);
        tiles_buf[tile_idx] = tile;
    }
    const tiles = tiles_buf[0..tiles_len];

    var xs_buf: [2 << 8]u32 = undefined;
    var xs_len: usize = 0;
    for (tiles) |t| {
        if (std.mem.containsAtLeastScalar(u32, xs_buf[0..xs_len], 1, t.x)) continue;
        xs_buf[xs_len] = t.x;
        xs_len += 1;
    }
    const xs = xs_buf[0..xs_len];

    var max_area: usize = 0;
    for (0..tiles.len - 1) |t1| {
        for (t1 + 1..tiles.len) |t2| {
            const tile1 = tiles[t1];
            const tile2 = tiles[t2];
            const a = tile1.area(tile2);
            if (a > max_area) {
                const width = @abs(@as(i32, @intCast(tile1.x)) - @as(i32, @intCast(tile2.x)));
                const height = @abs(@as(i32, @intCast(tile1.y)) - @as(i32, @intCast(tile2.y)));
                const tl: Vec2 = .{ .x = @min(tile1.x, tile2.x), .y = @min(tile1.y, tile2.y) };
                const bl: Vec2 = .{ .x = tl.x, .y = tl.y + height };
                const tr: Vec2 = .{ .x = tl.x + width, .y = tl.y };
                const br: Vec2 = .{ .x = tl.x + width, .y = tl.y + height };
                std.debug.assert(std.meta.eql(br, .{ .x = @max(tile1.x, tile2.x), .y = @max(tile1.y, tile2.y) }));
                var valid = true;
                inline for (.{ tl, bl, tr, br }) |corner| {
                    if (!(std.meta.eql(corner, tile1) or std.meta.eql(corner, tile2))) {
                        if (!inside(tiles, xs, corner)) {
                            valid = false;
                            break;
                        }
                    }
                }
                if (valid) {
                    max_area = a;
                }
            }
        }
    }
    return max_area;
}

fn inside(tiles: []const Vec2, xs: []const u32, pos: Vec2) bool {
    // on the line
    for (0..tiles.len) |t| {
        const t1 = tiles[t];
        const t2 = tiles[(t + 1) % tiles.len];
        if (t1.y == pos.y and t2.y == pos.y) {
            const x_min = @min(t1.x, t2.x);
            const x_max = @max(t1.x, t2.x);
            if (pos.x >= x_min and pos.x <= x_max) {
                return true;
            }
        }
        if (t1.x == pos.x and t2.x == pos.x) {
            const y_min = @min(t1.y, t2.y);
            const y_max = @max(t1.y, t2.y);
            if (pos.y >= y_min and pos.y <= y_max) {
                return true;
            }
        }
    }

    // inside
    var crosses_left: usize = 0;
    var crosses_right: usize = 0;
    var edge_left = false;
    var edge_right = false;
    for (xs) |x| {
        for (0..tiles.len) |t| {
            const t1 = tiles[t];
            const t2 = tiles[(t + 1) % tiles.len];
            if (t1.x == x and t2.x == x) {
                const y_min = @min(t1.y, t2.y);
                const y_max = @max(t1.y, t2.y);
                if (pos.y >= y_min and pos.y <= y_max) {
                    if (pos.x < x) {
                        crosses_left += 1;
                    } else {
                        crosses_right += 1;
                    }
                    break;
                }
            }
            if (t1.y == pos.y and t2.y == pos.y) {
                const x_min = @min(t1.x, t2.x);
                const x_max = @max(t1.x, t2.x);
                if (x >= x_min and x <= x_max) {
                    if (pos.x < x) {
                        edge_left = true;
                    } else {
                        edge_right = true;
                    }
                    break;
                }
            }
        }
    }
    return (edge_left or crosses_left % 2 == 1) and (edge_right or crosses_right % 2 == 1);
}

//.........
//.#X#.#X#.
//.X.X.X.X.
//.X.#X#.X.
//.X.....X.
//.X.....X.
//.X.....X.
//.#XXXXX#.
//.........
test "inside" {
    const tiles: []const Vec2 = &.{
        .{ .x = 1, .y = 1 },
        .{ .x = 3, .y = 1 },
        .{ .x = 3, .y = 3 },
        .{ .x = 5, .y = 3 },
        .{ .x = 5, .y = 1 },
        .{ .x = 7, .y = 1 },
        .{ .x = 7, .y = 7 },
        .{ .x = 1, .y = 7 },
    };
    const xs = &.{ 1, 3, 5, 7 };
    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 2, .y = 2 }));
    try std.testing.expectEqual(false, inside(tiles, xs, .{ .x = 4, .y = 2 }));
    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 6, .y = 2 }));

    try std.testing.expectEqual(false, inside(tiles, xs, .{ .x = 0, .y = 3 }));
    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 1, .y = 3 }));
    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 2, .y = 3 }));
    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 3, .y = 3 }));
    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 4, .y = 3 }));
    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 5, .y = 3 }));
    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 6, .y = 3 }));
    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 7, .y = 3 }));
    try std.testing.expectEqual(false, inside(tiles, xs, .{ .x = 8, .y = 3 }));

    for (tiles) |tile| {
        try std.testing.expectEqual(true, inside(tiles, xs, tile));
    }
}

//..............
//.......#XXX#..
//.......X...X..
//..#XXXX#...X..
//..X........X..
//..#XXXXXX#.X..
//.........X.X..
//.........#X#..
//..............
test "inside 2" {
    const tiles: []const Vec2 = &.{
        .{ .x = 7, .y = 1 },
        .{ .x = 11, .y = 1 },
        .{ .x = 11, .y = 7 },
        .{ .x = 9, .y = 7 },
        .{ .x = 9, .y = 5 },
        .{ .x = 2, .y = 5 },
        .{ .x = 2, .y = 3 },
        .{ .x = 7, .y = 3 },
    };
    const xs = &.{ 7, 11, 9, 2 };

    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 9, .y = 5 }));
    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 9, .y = 3 }));
    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 2, .y = 3 }));
    try std.testing.expectEqual(true, inside(tiles, xs, .{ .x = 2, .y = 5 }));

    for (tiles) |tile| {
        try std.testing.expectEqual(true, inside(tiles, xs, tile));
    }
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
    try std.testing.expectEqual(24, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day9.txt", &buf);
    try std.testing.expectEqual(0, solve(input));
}
