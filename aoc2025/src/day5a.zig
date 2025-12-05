const std = @import("std");
const day5b = @import("day5b.zig");

const Range = struct { from: u64, to: u64 };

pub fn solve(input: []const u8) !usize {
    var alloc_buf: [1 << 16]u8 = undefined;
    var alloc: std.heap.FixedBufferAllocator = .init(&alloc_buf);
    var ranges: std.array_list.Managed(day5b.Range) = try .initCapacity(alloc.allocator(), 1 << 8);

    const in = if (input[input.len - 1] == '\n') input[0 .. input.len - 2] else input;
    var parts = std.mem.splitSequence(u8, in, "\n\n");
    const ranges_in = parts.next().?;
    day5b.buildRanges(ranges_in, &ranges);

    var ids: std.array_list.Managed(u64) = try .initCapacity(alloc.allocator(), 1 << 12);
    const ids_in = parts.next().?;
    var ids_it = std.mem.splitScalar(u8, ids_in, '\n');
    var count: usize = 0;
    while (ids_it.next()) |id_in| {
        ids.append(std.fmt.parseInt(u64, id_in, 10) catch unreachable) catch unreachable;
    }
    std.mem.sortUnstable(u64, ids.items, {}, comptime std.sort.asc(u64));

    var range_idx: usize = 0;
    for (ids.items) |id| {
        for (range_idx..ranges.items.len) |ri| {
            const range = ranges.items[ri];
            if (id >= range.from and id <= range.to) {
                range_idx = ri;
                break;
            }
        } else {
            continue;
        }
        count += 1;
    }
    return count;
}

test "day5a demo" {
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
    ;
    try std.testing.expectEqual(3, solve(input));
}

test "day5a" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day5.txt", &buf);
    try std.testing.expectEqual(739, solve(input));
}
