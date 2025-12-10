const std = @import("std");

pub fn solve(input: []const u8) !usize {
    var it = std.mem.splitScalar(u8, input[0 .. input.len - 1], '\n');
    var total: usize = 0;
    while (it.next()) |line| {
        var target: u10 = 0;
        var s_it = std.mem.splitScalar(u8, line, ' ');
        var wirings_buf: [1 << 5]u10 = undefined;
        var wirings_len: usize = 0;
        var size: u4 = 0;
        while (s_it.next()) |token| {
            switch (token[0]) {
                '[' => {
                    size = @intCast(token.len - 2);
                    for (1..token.len - 1) |i| {
                        if (token[i] == '#') target |= @as(u10, 1) << @as(u4, @intCast(i - 1));
                    }
                },
                '(' => {
                    var w_t = std.mem.splitScalar(u8, token[1 .. token.len - 1], ',');
                    var wiring: u10 = 0;
                    while (w_t.next()) |w| {
                        const wi = std.fmt.parseUnsigned(u10, w, 10) catch unreachable;
                        wiring |= @as(u10, 1) << @as(u4, @intCast(wi));
                    }
                    wirings_buf[wirings_len] = wiring;
                    wirings_len += 1;
                },
                else => {},
            }
        }
        const wirings = wirings_buf[0..wirings_len];
        const min = minToggles(target, wirings, size);
        total += min;
    }
    return total;
}

fn minToggles(target: u10, wirings: []const u10, size: u4) u8 {
    _ = size;
    // std.debug.print("{b:08} {} {} |", .{ target, size, wirings.len });
    // for (wirings) |w| std.debug.print(" {b:08}", .{w});
    // std.debug.print("\n", .{});
    var min: ?u8 = null;
    for (0..@as(u16, 1) << @intCast(wirings.len)) |wiring_mask| {
        // std.debug.print("  mask {b:010}\n", .{wiring_mask});
        var toggle_result: u10 = 0;
        var toggles: u8 = 0;
        for (0..wirings.len) |wiring_bit| {
            if (wiring_mask & @as(u16, 1) << @as(u4, @intCast(wiring_bit)) > 0) {
                // std.debug.print("  {b:08} {b:08} {b:08}\n", .{ toggle_result, wirings[wiring_bit], toggle_result ^ wirings[wiring_bit] });
                toggle_result ^= wirings[wiring_bit];
                toggles += 1;
            }
        }
        if (target == toggle_result and toggles < min orelse std.math.maxInt(u8)) {
            // std.debug.print("new min {}\n", .{toggles});
            min = toggles;
        }
    }
    return min orelse unreachable;
}

fn bitLen(v: u10) u8 {
    var n = v;
    if (n == 0) return 0;
    var bits: u8 = 0;
    while (n > 0) {
        n >>= 1;
        bits += 1;
    }
    return bits;
}

test "demo" {
    const input =
        \\[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
        \\[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
        \\[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
        \\
    ;
    try std.testing.expectEqual(7, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day10.txt", &buf);
    try std.testing.expectEqual(488, solve(input));
}
