const std = @import("std");

pub const Vec3 = struct {
    const Size = u32;

    x: Size,
    y: Size,
    z: Size,

    pub fn parse(line: []const u8) Vec3 {
        var it = std.mem.splitScalar(u8, line, ',');
        return .{
            .x = std.fmt.parseUnsigned(Size, it.next().?, 10) catch unreachable,
            .y = std.fmt.parseUnsigned(Size, it.next().?, 10) catch unreachable,
            .z = std.fmt.parseUnsigned(Size, it.next().?, 10) catch unreachable,
        };
    }

    pub fn distanceSq(self: Vec3, other: Vec3) u64 {
        const dx = @abs(@as(i64, @intCast(self.x)) - other.x);
        const dy = @abs(@as(i64, @intCast(self.y)) - other.y);
        const dz = @abs(@as(i64, @intCast(self.z)) - other.z);
        return dx * dx + dy * dy + dz * dz;
    }
};

pub const Pair = struct {
    bi1: u10,
    bi2: u10,
    dSq: u64,
};

pub fn lessThanDSq(ctx: @TypeOf(.{}), p1: Pair, p2: Pair) bool {
    _ = ctx;
    return p1.dSq < p2.dSq;
}

pub fn solve(input: []const u8) !usize {
    return solveSteps(input, 1000);
}

fn solveSteps(input: []const u8, steps: u10) !usize {
    const alloc = std.heap.page_allocator;
    var it = std.mem.splitScalar(u8, input[0 .. input.len - 1], '\n');
    const boxes_len = std.mem.count(u8, input, "\n");
    var boxes_buf: [2 << 10]Vec3 = undefined;
    var box_idx: usize = 0;
    while (it.next()) |line| {
        defer box_idx += 1;
        boxes_buf[box_idx] = .parse(line);
    }
    const boxes = boxes_buf[0..boxes_len];

    var pairs_buf = try alloc.create([2 << 22]Pair);
    var pairs_len: usize = 0;
    for (0..boxes_len - 1) |bi1| {
        for (bi1 + 1..boxes_len) |bi2| {
            pairs_buf[pairs_len] = .{
                .bi1 = @intCast(bi1),
                .bi2 = @intCast(bi2),
                .dSq = Vec3.distanceSq(boxes[bi1], boxes[bi2]),
            };
            pairs_len += 1;
        }
    }
    const pairs = pairs_buf[0..pairs_len];
    std.mem.sortUnstable(Pair, pairs, .{}, comptime lessThanDSq);

    var box_circuit_buf: [2 << 10]?u10 = @splat(null);
    const box_circuit = box_circuit_buf[0..boxes_len];
    var circuit_len: u10 = 0;
    var connections: u10 = 0;
    for (pairs) |pair| {
        defer connections += 1;
        if (connections == steps) break;
        if (box_circuit[pair.bi1] != null and box_circuit[pair.bi1] == box_circuit[pair.bi2]) {
            continue;
        } else if (box_circuit[pair.bi1] != null and box_circuit[pair.bi2] != null) {
            const c1 = box_circuit[pair.bi1].?;
            const c2 = box_circuit[pair.bi2].?;
            for (0..boxes.len) |bi| {
                if (box_circuit[bi] == c2) {
                    box_circuit[bi] = c1;
                }
            }
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
        }
    }
    var sizes_buf: [2 << 10]u32 = @splat(0);
    const sizes = sizes_buf[0..boxes.len];
    for (0..boxes.len) |bi| {
        if (box_circuit[bi]) |bci| sizes[bci] += 1;
    }
    std.mem.sortUnstable(u32, sizes, {}, comptime std.sort.desc(u32));
    return sizes[0] * sizes[1] * sizes[2];
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
    try std.testing.expectEqual(40, solveSteps(input, 10));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day8.txt", &buf);
    try std.testing.expectEqual(72150, solve(input));
}
