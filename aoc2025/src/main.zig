const std = @import("std");

pub fn main() !void {
    const warmup = 10;
    const runs = 100;
    var buf: [2 << 16]u8 = undefined;
    var timer = try std.time.Timer.start();
    inline for (.{
        .{ .part = "day1a", .solve_fn = @import("day1a.zig").solve, .input = "day1.txt" },
        .{ .part = "day1b", .solve_fn = @import("day1b.zig").solve, .input = "day1.txt" },
        .{ .part = "day2a", .solve_fn = @import("day2a.zig").solve, .input = "day2.txt" },
        .{ .part = "day2b", .solve_fn = @import("day2b.zig").solve, .input = "day2.txt" },
        .{ .part = "day3a", .solve_fn = @import("day3a.zig").solve, .input = "day3.txt" },
        .{ .part = "day3b", .solve_fn = @import("day3b.zig").solve, .input = "day3.txt" },
        .{ .part = "day4a", .solve_fn = @import("day4a.zig").solve, .input = "day4.txt" },
        .{ .part = "day4b", .solve_fn = @import("day4b.zig").solve, .input = "day4.txt" },
        .{ .part = "day5a", .solve_fn = @import("day5a.zig").solve, .input = "day5.txt" },
        .{ .part = "day5b", .solve_fn = @import("day5b.zig").solve, .input = "day5.txt" },
        .{ .part = "day6a", .solve_fn = @import("day6a.zig").solve, .input = "day6.txt" },
        .{ .part = "day6b", .solve_fn = @import("day6b.zig").solve, .input = "day6.txt" },
        .{ .part = "day7a", .solve_fn = @import("day7a.zig").solve, .input = "day7.txt" },
        .{ .part = "day7b", .solve_fn = @import("day7b.zig").solve, .input = "day7.txt" },
        .{ .part = "day8a", .solve_fn = @import("day8a.zig").solve, .input = "day8.txt" },
        .{ .part = "day8b", .solve_fn = @import("day8b.zig").solve, .input = "day8.txt" },
        .{ .part = "day9a", .solve_fn = @import("day9a.zig").solve, .input = "day9.txt" },
        .{ .part = "day9b", .solve_fn = @import("day9b.zig").solve, .input = "day9.txt" },
        .{ .part = "day10a", .solve_fn = @import("day10a.zig").solve, .input = "day10.txt" },
        // .{ .part = "day10b", .solve_fn = @import("day10b.zig").solve, .input = "day10.txt" },
        .{ .part = "day11a", .solve_fn = @import("day11a.zig").solve, .input = "day11.txt" },
    }) |entry| {
        const input = try std.fs.cwd().readFile(std.fmt.comptimePrint("./data/{s}", .{entry.input}), &buf);
        for (0..warmup) |_| _ = try entry.solve_fn(input);

        var total: u64 = 0;
        for (0..runs) |_| {
            timer.reset();
            _ = try entry.solve_fn(input);
            total += @divFloor(timer.read(), std.time.ns_per_us);
        }
        std.debug.print("{s: <6} {: >5}μs\n", .{ entry.part, @divFloor(total, runs) });
    }
}

test {
    std.testing.refAllDecls(@This());
}
