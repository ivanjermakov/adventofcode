const std = @import("std");

pub fn solve(input: []const u8) !usize {
    var alloc_buf: [1 << 14]u8 = undefined;
    var allocator: std.heap.FixedBufferAllocator = .init(&alloc_buf);
    const alloc = allocator.allocator();

    var it = std.mem.splitScalar(u8, input[0 .. input.len - 1], '\n');
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
        const counts = counts_buf[0..counts_len];
        printEquation(counts, wirings.items);
        std.debug.print("\n", .{});
    }
    return 0;
}

fn printEquation(counts: []const u8, wirings: []const []const u8) void {
    for (0..wirings.len) |wi| {
        const wiring = wirings[wi];
        const v_name: u8 = @intCast('a' + wi);
        std.debug.print("{c}(", .{v_name});
        for (0..wiring.len) |i| {
            const bi = wiring[i];
            std.debug.print("{}", .{counts[bi]});
            if (i != wiring.len - 1) std.debug.print("+", .{});
        }
        std.debug.print(")", .{});
        if (wi != wirings.len - 1) std.debug.print("*", .{});
    }
    std.debug.print(" min(", .{});
    for (0..wirings.len) |wi| {
        const v_name: u8 = @intCast('a' + wi);
        std.debug.print("{c}", .{v_name});
        if (wi != wirings.len - 1) std.debug.print("+", .{});
    }
    std.debug.print(")", .{});
}
