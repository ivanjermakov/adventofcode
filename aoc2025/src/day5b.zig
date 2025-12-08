const std = @import("std");

pub const Range = struct {
    from: u64,
    to: u64,

    pub fn lessThan(ctx: @TypeOf(.{}), a: Range, b: Range) bool {
        _ = ctx;
        if (a.from < b.from) return true;
        if (a.from == b.from) return a.to < b.to;
        return false;
    }
};

pub fn solve(input: []const u8) !usize {
    var alloc_buf: [1 << 14]u8 = undefined;
    var alloc: std.heap.FixedBufferAllocator = .init(&alloc_buf);
    var ranges: std.array_list.Managed(Range) = try .initCapacity(alloc.allocator(), 1 << 8);

    var parts = std.mem.splitSequence(u8, input[0 .. input.len - 1], "\n\n");
    const ranges_in = parts.next().?;
    buildRanges(ranges_in, &ranges);

    var total: usize = 0;
    for (ranges.items) |range| {
        total += range.to - range.from + 1;
    }
    return total;
}

pub fn buildRanges(ranges_in: []const u8, ranges: *std.array_list.Managed(Range)) void {
    var ranges_it = std.mem.splitScalar(u8, ranges_in, '\n');
    while (ranges_it.next()) |range_in| {
        var parts_it = std.mem.splitScalar(u8, range_in, '-');
        ranges.append(Range{
            .from = std.fmt.parseInt(u64, parts_it.next().?, 10) catch unreachable,
            .to = std.fmt.parseInt(u64, parts_it.next().?, 10) catch unreachable,
        }) catch unreachable;
    }
    std.mem.sortUnstable(Range, ranges.items, .{}, comptime Range.lessThan);

    var i: usize = 0;
    while (i < ranges.items.len - 1) {
        const range = &ranges.items[i];
        const next = ranges.items[i + 1];
        if (range.to >= next.from) {
            if (range.from >= next.from and range.to <= next.to) {
                _ = ranges.orderedRemove(i);
                continue;
            }
            if (next.from >= range.from and next.to <= range.to) {
                _ = ranges.orderedRemove(i + 1);
                continue;
            }
            range.to = @min(range.to, next.from - 1);
        }
        std.debug.assert(range.to >= range.from);
        i += 1;
    }
}

test "demo" {
    const input =
        \\3-5
        \\10-14
        \\16-20
        \\12-18
        \\
        \\1
        \\5
        \\8
        \\11
        \\17
        \\32
        \\
    ;
    try std.testing.expectEqual(14, solve(input));
}

test "demo 2" {
    const input =
        \\1-10
        \\4-7
        \\
        \\1
        \\
    ;
    try std.testing.expectEqual(10, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day5.txt", &buf);
    try std.testing.expectEqual(344486348901788, solve(input));
}
