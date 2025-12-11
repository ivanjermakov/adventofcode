const std = @import("std");
const day11a = @import("day11a.zig");
const traverse = day11a.traverse;

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
    const a = traverse(connections.items, svr.?, dac.?) * traverse(connections.items, dac.?, fft.?) * traverse(connections.items, fft.?, 0);
    const b = traverse(connections.items, svr.?, fft.?) * traverse(connections.items, fft.?, dac.?) * traverse(connections.items, dac.?, 0);
    return a + b;
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
    try std.testing.expectEqual(525518050323600, solve(input));
}
