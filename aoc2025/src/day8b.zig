const std = @import("std");
const day8a = @import("day8a.zig");

pub fn solve(input: []const u8) !usize {
    var it = std.mem.splitScalar(u8, input[0 .. input.len - 1], '\n');
    const boxes_len = std.mem.count(u8, input, "\n");
    var boxes_buf: [2 << 10]day8a.Vec3 = undefined;
    var box_idx: usize = 0;
    while (it.next()) |line| {
        defer box_idx += 1;
        boxes_buf[box_idx] = .parse(line);
    }
    const boxes = boxes_buf[0..boxes_len];

    const threshold_dist = 15_000;
    const threshold_dist_sq = threshold_dist * threshold_dist;
    var pairs_buf: [2 << 12]day8a.Pair = undefined;
    var pairs_len: usize = 0;
    for (0..boxes_len - 1) |bi1| {
        for (bi1 + 1..boxes_len) |bi2| {
            const d_sq = day8a.Vec3.distanceSq(boxes[bi1], boxes[bi2]);
            if (d_sq > threshold_dist_sq) continue;
            pairs_buf[pairs_len] = .{
                .bi1 = @intCast(bi1),
                .bi2 = @intCast(bi2),
                .d_sq = d_sq,
            };
            pairs_len += 1;
        }
    }
    const pairs = pairs_buf[0..pairs_len];
    std.mem.sortUnstable(day8a.Pair, pairs, .{}, comptime day8a.lessThanDSq);

    var last_circuit: ?u16 = null;
    var box_circuit_buf: [2 << 10]?u16 = @splat(null);
    const box_circuit = box_circuit_buf[0..boxes_len];
    var circuit_len: u16 = 0;
    for (pairs) |pair| {
        if (box_circuit[pair.bi1] != null and box_circuit[pair.bi1] == box_circuit[pair.bi2]) {
            continue;
        } else if (box_circuit[pair.bi1] != null and box_circuit[pair.bi2] != null) {
            const c1 = box_circuit[pair.bi1].?;
            const c2 = box_circuit[pair.bi2].?;
            std.mem.replaceScalar(?u16, box_circuit, c2, c1);
            last_circuit = c1;
        } else if (box_circuit[pair.bi1]) |c1| {
            std.debug.assert(box_circuit[pair.bi2] == null);
            box_circuit[pair.bi2] = c1;
        } else if (box_circuit[pair.bi2]) |c2| {
            std.debug.assert(box_circuit[pair.bi1] == null);
            box_circuit[pair.bi1] = c2;
        } else {
            box_circuit[pair.bi1] = circuit_len;
            box_circuit[pair.bi2] = circuit_len;
            circuit_len += 1;
            continue;
        }
        if (last_circuit != null and std.mem.allEqual(?u16, box_circuit, last_circuit)) {
            return @as(usize, boxes[pair.bi1].x) * boxes[pair.bi2].x;
        }
    }
    unreachable;
}

test "demo" {
    const input =
        \\162,817,812
        \\57,618,57
        \\906,360,560
        \\592,479,940
        \\352,342,300
        \\466,668,158
        \\542,29,236
        \\431,825,988
        \\739,650,466
        \\52,470,668
        \\216,146,977
        \\819,987,18
        \\117,168,530
        \\805,96,715
        \\346,949,466
        \\970,615,88
        \\941,993,340
        \\862,61,35
        \\984,92,344
        \\425,690,689
        \\
    ;
    try std.testing.expectEqual(25272, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day8.txt", &buf);
    try std.testing.expectEqual(3926518899, solve(input));
}
