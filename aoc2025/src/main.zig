const std = @import("std");
const day1a = @import("day1a.zig");
const day1b = @import("day1b.zig");

pub fn main() !void {
    const warmup = 10;
    const runs = 100;
    var buf: [2 << 16]u8 = undefined;
    var timer = try std.time.Timer.start();
    inline for (.{
        .{ .part = "day1a", .solve_fn = day1a.solve, .input = "day1.txt" },
        .{ .part = "day1b", .solve_fn = day1b.solve, .input = "day1.txt" },
    }) |entry| {
        const input = try std.fs.cwd().readFile(std.fmt.comptimePrint("./data/{s}", .{entry.input}), &buf);
        for (0..warmup) |_| _ = try entry.solve_fn(input);

        var total: u64 = 0;
        for (0..runs) |_| {
            timer.reset();
            _ = try entry.solve_fn(input);
            total += @divFloor(timer.read(), std.time.ns_per_us);
        }
        std.debug.print("{s}: {}us\n", .{ entry.part, @divFloor(total, runs) });
    }
}

test {
    std.testing.refAllDecls(@This());
}
