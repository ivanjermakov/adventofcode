const std = @import("std");

pub fn solve(input: []const u8) !usize {
    var alloc_buf: [1 << 16]u8 = undefined;
    var alloc: std.heap.FixedBufferAllocator = .init(&alloc_buf);

    const in = if (input[input.len - 1] == '\n') input[0 .. input.len - 2] else input;
    var ns: std.array_list.Managed(u64) = .init(alloc.allocator());
    var ops: std.array_list.Managed(u1) = .init(alloc.allocator());

    var i: usize = 0;
    while (i < in.len) {
        defer i += 1;
        const ch = in[i];
        switch (ch) {
            ' ', '\n' => {},
            '+' => ops.append(0) catch unreachable,
            '*' => ops.append(1) catch unreachable,
            else => {
                const end = std.mem.indexOfAny(u8, in[i..], " \n").?;
                const n_str = in[i .. i + end];
                const n = std.fmt.parseUnsigned(u64, n_str, 10) catch unreachable;
                ns.append(n) catch unreachable;
                i += end;
            },
        }
    }

    var acc: u64 = 0;
    const width = @divExact(ns.items.len, ops.items.len);
    const stride = @divExact(ns.items.len, width);

    for (0..ops.items.len) |j| {
        const op = ops.items[j];
        var n = ns.items[j];
        for (1..width) |w| {
            const m = ns.items[j + stride * w];
            switch (op) {
                0 => n += m,
                1 => n *= m,
            }
        }
        acc += n;
    }

    return acc;
}

test "day6a demo" {
    const input =
        \\123 328  51 64 
        \\ 45 64  387 23 
        \\  6 98  215 314
        \\*   +   *   +  
    ;
    try std.testing.expectEqual(4277556, solve(input));
}

test "day6a" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day6.txt", &buf);
    try std.testing.expectEqual(7326876294741, solve(input));
}
