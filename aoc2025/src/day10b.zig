const std = @import("std");

pub fn solve(input: []const u8) !usize {
    var alloc_buf: [1 << 14]u8 = undefined;
    var allocator: std.heap.FixedBufferAllocator = .init(&alloc_buf);
    const alloc = allocator.allocator();

    var it = std.mem.splitScalar(u8, input[0 .. input.len - 1], '\n');
    var total: usize = 0;
    while (it.next()) |line| {
        var counts_buf: [1 << 5]u8 = undefined;
        var wirings: std.array_list.Managed([]u8) = .init(alloc);
        var counts_len: u4 = 0;
        var s_it = std.mem.splitScalar(u8, line, ' ');
        while (s_it.next()) |token| {
            switch (token[0]) {
                '{' => {
                    var w_t = std.mem.splitScalar(u8, token[1 .. token.len - 1], ',');
                    while (w_t.next()) |w| {
                        counts_buf[counts_len] = std.fmt.parseUnsigned(u8, w, 10) catch unreachable;
                        counts_len += 1;
                    }
                },
                '(' => {
                    var w_t = std.mem.splitScalar(u8, token[1 .. token.len - 1], ',');
                    var wiring: std.array_list.Managed(u8) = .init(alloc);
                    while (w_t.next()) |w| {
                        wiring.append(std.fmt.parseUnsigned(u8, w, 10) catch unreachable) catch unreachable;
                    }
                    wirings.append(wiring.items) catch unreachable;
                },
                else => {},
            }
        }
        const min = minPresses(counts_buf[0..counts_len], wirings.items);
        total += min;
    }
    return total;
}

fn minPresses(counts: []u8, wirings: [][]u8) u8 {
    std.debug.print("{any} |", .{counts});
    for (wirings) |w| std.debug.print(" {any}", .{w});
    std.debug.print("\n", .{});
    return 0;
}

fn verify(counts: []const u8, wirings: []const []const u8, presses: []const u8) bool {
    std.debug.assert(wirings.len == presses.len);
    var cs_buf: [1 << 5]u8 = undefined;
    const cs = cs_buf[0..counts.len];
    @memcpy(cs, counts);
    for (0..wirings.len) |i| {
        for (wirings[i]) |w| {
            cs[w] -%= presses[i];
        }
    }
    return std.mem.allEqual(u8, cs, 0);
}

test "verify" {
    try std.testing.expect(verify(
        &.{ 11, 10 },
        &.{ &.{0}, &.{1}, &.{ 0, 1 } },
        &.{ 2, 1, 9 },
    ));
}

// test "demo" {
//     const input =
//         \\[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
//         \\[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
//         \\[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
//         \\
//     ;
//     try std.testing.expectEqual(33, solve(input));
// }

test "demo 1" {
    const input =
        \\[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
        \\
    ;
    try std.testing.expectEqual(10, solve(input));
}

// test "demo 2" {
//     const input =
//         \\[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
//         \\
//     ;
//     try std.testing.expectEqual(12, solve(input));
// }
//
// test "demo 3" {
//     const input =
//         \\[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
//         \\
//     ;
//     try std.testing.expectEqual(11, solve(input));
// }

// test "real" {
//     var buf: [2 << 16]u8 = undefined;
//     const input = try std.fs.cwd().readFile("./data/day10.txt", &buf);
//     try std.testing.expectEqual(488, solve(input));
// }
