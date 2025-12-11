const std = @import("std");

const alloc = std.heap.page_allocator;

pub fn solve(input: []const u8) !usize {
    var devices: std.array_list.Managed([]const u8) = .init(alloc);
    var it = std.mem.splitScalar(u8, input[0 .. input.len - 1], '\n');
    try devices.append("out");
    var svr: ?usize = null;
    var dac: ?usize = null;
    var fft: ?usize = null;
    while (it.next()) |line| {
        var t_it = std.mem.splitSequence(u8, line, ": ");
        const token_device = t_it.next().?;
        if (std.mem.eql(u8, token_device, "svr")) svr = devices.items.len;
        if (std.mem.eql(u8, token_device, "dac")) dac = devices.items.len;
        if (std.mem.eql(u8, token_device, "fft")) fft = devices.items.len;
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
    std.debug.assert(svr != null);
    std.debug.assert(dac != null);
    std.debug.assert(fft != null);
    var a = traverse(connections.items, svr.?, dac.?);
    if (a > 0) {
        a *= traverse(connections.items, dac.?, fft.?);
        if (a > 0) {
            a *= traverse(connections.items, fft.?, 0);
        }
    }
    var b = traverse(connections.items, svr.?, fft.?);
    if (b > 0) {
        b *= traverse(connections.items, fft.?, dac.?);
        if (b > 0) {
            b *= traverse(connections.items, dac.?, 0);
        }
    }
    return a + b;
    // return traverse(connections.items, svr.?, fft.?, null);
}

fn traverse(connections: []const []const usize, from: usize, target: usize) usize {
    var memo: std.AutoHashMap(usize, usize) = .init(alloc);
    defer memo.deinit();
    return traverseMemo(&memo, connections, from, target, from);
}

fn traverseMemo(
    memo: *std.AutoHashMap(usize, usize),
    connections: []const []const usize,
    from: usize,
    target: usize,
    at: usize,
) usize {
    if (at == target) return 1;
    var acc: usize = 0;
    for (connections[at]) |to| {
        const a = b: {
            if (memo.get(to)) |m| break :b m;
            break :b traverseMemo(memo, connections, from, target, to);
        };
        acc += a;
    }
    memo.put(at, acc) catch unreachable;
    return acc;
}

test "demo" {
    const input =
        \\svr: aaa bbb
        \\aaa: fft
        \\fft: ccc
        \\bbb: tty
        \\tty: ccc
        \\ccc: ddd eee
        \\ddd: hub
        \\hub: fff
        \\eee: dac
        \\dac: fff
        \\fff: ggg hhh
        \\ggg: out
        \\hhh: out
        \\
    ;
    try std.testing.expectEqual(2, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day11.txt", &buf);
    try std.testing.expectEqual(0, solve(input));
}
