const std = @import("std");

const alloc = std.heap.page_allocator;

pub fn solve(input: []const u8) !usize {
    var devices: std.array_list.Managed([]const u8) = .init(alloc);
    var it = std.mem.splitScalar(u8, input[0 .. input.len - 1], '\n');
    try devices.append("out");
    var you_idx: usize = undefined;
    while (it.next()) |line| {
        var t_it = std.mem.splitSequence(u8, line, ": ");
        const token_device = t_it.next().?;
        if (std.mem.eql(u8, token_device, "you")) you_idx = devices.items.len;
        try devices.append(token_device);
    }

    var connections: std.array_list.Managed([]const usize) = .init(alloc);
    // slot for "out"
    try connections.append(&.{});
    var it2 = std.mem.splitScalar(u8, input[0 .. input.len - 1], '\n');
    while (it2.next()) |line| {
        var t_it = std.mem.splitSequence(u8, line, ": ");
        _ = t_it.next().?;
        var c_it = std.mem.splitScalar(u8, t_it.next().?, ' ');
        var cs: std.array_list.Managed(usize) = .init(alloc);
        while (c_it.next()) |c| {
            const d_idx = b: {
                for (0..devices.items.len) |di| {
                    if (std.mem.eql(u8, devices.items[di], c)) {
                        break :b di;
                    }
                }
                unreachable;
            };
            try cs.append(d_idx);
        }
        try connections.append(cs.items);
    }
    return traverse(connections.items, &.{you_idx});
}

fn traverse(connections: []const []const usize, visited: []const usize) usize {
    const at = visited[visited.len - 1];
    // std.debug.print("at {}, visited {any}\n", .{ at, visited });
    if (at == 0) return 1;
    var acc: usize = 0;
    for (connections[at]) |to| {
        if (std.mem.containsAtLeastScalar(usize, visited, 1, to)) {
            // std.debug.print("already been to {} {any}\n", .{ to, visited });
            continue;
        }
        // std.debug.print("traverse {}->{}\n", .{ at, to });
        var next = alloc.alloc(usize, visited.len + 1) catch unreachable;
        @memcpy(next[0..visited.len], visited);
        next[visited.len] = to;
        acc += traverse(connections, next);
    }
    return acc;
}

test "demo" {
    const input =
        \\aaa: you hhh
        \\you: bbb ccc
        \\bbb: ddd eee
        \\ccc: ddd eee fff
        \\ddd: ggg
        \\eee: out
        \\fff: out
        \\ggg: out
        \\hhh: ccc fff iii
        \\iii: out
        \\
    ;
    try std.testing.expectEqual(5, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day11.txt", &buf);
    try std.testing.expectEqual(0, solve(input));
}
