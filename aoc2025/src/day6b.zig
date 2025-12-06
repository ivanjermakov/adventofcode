const std = @import("std");

pub fn solve(input: []const u8) !usize {
    var alloc_buf: [1 << 18]u8 = undefined;
    var allocator: std.heap.FixedBufferAllocator = .init(&alloc_buf);
    const alloc = allocator.allocator();

    const in = if (std.mem.eql(u8, input[input.len - 2 ..], "\n\n")) input[0 .. input.len - 1] else input;
    const in_width = std.mem.indexOf(u8, in, "\n").? + 1;
    const in_height = @divExact(in.len, in_width);

    var ns: std.array_list.Managed(u64) = .init(alloc);
    var num: std.array_list.Managed(u8) = .init(alloc);
    var blank_cols: std.array_list.Managed(usize) = .init(alloc);
    for (0..in_width) |x| {
        for (0..in_height - 1) |y| {
            const ch = in[y * in_width + x];
            if (std.ascii.isDigit(ch)) {
                try num.append(ch);
            }
        }
        if (num.items.len > 0) {
            try ns.append(try std.fmt.parseInt(u64, num.items, 10));
            num.clearRetainingCapacity();
        } else {
            try blank_cols.append(x);
        }
    }

    var ops: std.array_list.Managed(u1) = .init(alloc);
    for (0..in_width) |x| {
        const ch = in[(in_height - 1) * in_width + x];
        switch (ch) {
            '+' => try ops.append(0),
            '*' => try ops.append(1),
            else => {},
        }
    }

    var acc: u64 = 0;
    var op_idx: usize = 0;
    var n_idx: usize = 0;
    var sub_acc: ?usize = null;
    for (0..in_width) |x| {
        if (blank_cols.items[op_idx] == x) {
            if (sub_acc) |sub| {
                acc += sub;
                sub_acc = null;
            }
            op_idx += 1;
            continue;
        }
        const n = ns.items[n_idx];
        n_idx += 1;
        const op = ops.items[op_idx];
        if (sub_acc) |_| {
            switch (op) {
                0 => sub_acc.? += n,
                1 => sub_acc.? *= n,
            }
        } else {
            sub_acc = n;
        }
    }

    return acc;
}

test "day6b demo" {
    const input =
        \\123 328  51 64 
        \\ 45 64  387 23 
        \\  6 98  215 314
        \\*   +   *   +  
        \\
    ;
    try std.testing.expectEqual(3263827, solve(input));
}

test "day6b" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day6.txt", &buf);
    try std.testing.expectEqual(10756006415204, solve(input));
}
