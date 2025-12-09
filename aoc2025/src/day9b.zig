const std = @import("std");
const day9a = @import("day9a.zig");
const Vec2 = day9a.Vec2;

pub fn solve(input: []const u8) !usize {
    std.debug.print("\n", .{});
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
    var threshold_low: ?u32 = null;
    var threshold_high: ?u32 = null;
    const size: Vec2 = .{ .x = 100_000, .y = 100_000 };
    b: for (ys) |y| {
        for (0..tiles.len - 1) |t1| {
            const tile1 = tiles[t1];
            if (tile1.y != y) continue;
            for (t1 + 1..tiles.len) |t2| {
                const tile2 = tiles[t2];
                if (tile1.y == tile2.y and @abs(@as(i32, @intCast(tile1.x)) - @as(i32, @intCast(tile2.x))) > @divFloor(size.x, 2)) {
                    if (threshold_low == null) {
                        threshold_low = @intCast(y);
                        continue :b;
                    }
                    if (threshold_high == null) {
                        threshold_high = @intCast(y);
                        break :b;
                    }
                }
            }
        }
    }

    var xs: [1 << 8]u32 = undefined;
    var xs_len: usize = 0;
    var max_area: usize = 0;
    // iterate lines above `threshold_top` and below `threshold_bottom` and find maximum area
    for (1..ys.len - 1) |yi| {
        const y = ys[yi];
        xs_len = 0;
        if (y >= threshold_low.? and y <= threshold_high.?) continue;
        const threshold = if (y < threshold_low.?) threshold_low.? else threshold_high.?;
        if (y < threshold_low.?) {
            const y_prev = ys[yi - 1];
            for (tiles) |t| {
                if (t.y <= threshold and t.y <= y and t.y >= y_prev) {
                    xs[xs_len] = t.x;
                    xs_len += 1;
                }
            }
        } else {
            const y_next = ys[yi + 1];
            for (tiles) |t| {
                if (t.y >= threshold and t.y >= y and t.y <= y_next) {
                    xs[xs_len] = t.x;
                    xs_len += 1;
                }
            }
        }
        if (xs_len == 0) continue;
        std.mem.sortUnstable(u32, xs[0..xs_len], {}, comptime std.sort.asc(u32));

        const x_low = xs[0];
        const x_high = xs[xs_len - 1];
        const c1 = Vec2{ .x = x_high, .y = threshold };
        const c2 = Vec2{ .x = x_low, .y = y };
        const area = c1.area(c2);
        if (area > max_area) {
            std.debug.print("{} {} {} {}\n", .{ area, y, c1, c2 });
            max_area = area;
        }
    }

    return max_area;
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day9.txt", &buf);
    try std.testing.expectEqual(0, solve(input));
}
