const std = @import("std");
const day9a = @import("day9a.zig");
const Vec2 = day9a.Vec2;

/// Input assumptions:
///   - polygon looks like a circle with a very deep rectangular cut from the left at vertical center
///   - polygon "steps" are regular, e.g. repeating up-left-up-left-up-... direction in top right quadrant
///   - solution is in the top hemisphere
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

    // find y coordinates with interesting tiles for faster lookup
    var ys_buf: [2 << 8]u32 = undefined;
    var ys_len: usize = 0;
    for (tiles) |t| {
        if (std.mem.containsAtLeastScalar(u32, ys_buf[0..ys_len], 1, t.y)) continue;
        ys_buf[ys_len] = t.y;
        ys_len += 1;
    }
    const ys = ys_buf[0..ys_len];
    std.mem.sortUnstable(u32, ys, {}, comptime std.sort.asc(u32));

    // find circle cut in round polygon
    var threshold: ?Vec2 = null;
    const size = 100_000;
    b: for (ys) |y| {
        for (0..tiles.len - 1) |t1| {
            const tile1 = tiles[t1];
            if (tile1.y != y) continue;
            for (t1 + 1..tiles.len) |t2| {
                const tile2 = tiles[t2];
                if (tile1.y == tile2.y and @as(i32, @intCast(tile2.x)) - @as(i32, @intCast(tile1.x)) > @divFloor(size, 2)) {
                    if (threshold == null) {
                        threshold = tile2;
                        break :b;
                    }
                }
            }
        }
    }

    // find last y pos at which `threshold.x` still fit
    var last_fit_line: ?usize = null;
    for (0..ys.len) |yi| {
        var max_x: ?u32 = null;
        for (tiles) |t| {
            if (t.y != ys[yi]) continue;
            max_x = @max(max_x orelse 0, t.x);
        }
        if (max_x == null) continue;
        if (ys[yi] >= threshold.?.y and max_x.? >= threshold.?.x) {
            last_fit_line = yi;
        }
    }

    // optimal area tile should be within 2 lines from last fit line
    var max_area: usize = 0;
    for (last_fit_line.? - 1..last_fit_line.? + 1) |yi| {
        for (tiles) |t| {
            if (t.y != ys[yi]) continue;
            const a = t.area(threshold.?);
            max_area = @max(max_area, a);
        }
    }

    return max_area;
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day9.txt", &buf);
    try std.testing.expectEqual(1513792010, solve(input));
}
