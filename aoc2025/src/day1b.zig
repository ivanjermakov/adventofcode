const std = @import("std");

pub fn solve(input: []const u8) !usize {
    var zero_count: usize = 0;
    var head: i32 = 50;
    var line_iter = std.mem.splitScalar(u8, input, '\n');
    while (line_iter.next()) |line| {
        if (line.len == 0) continue;
        const count = try std.fmt.parseInt(i32, line[1..], 10);
        const head_unbound = (if (line[0] == 'R') head else @rem(100 - head, 100)) + count;
        const laps = @divFloor(head_unbound, 100);
        var head_next = @rem(head_unbound, 100);
        head_next = if (line[0] == 'R') head_next else @rem(100 - head_next, 100);
        zero_count += @abs(laps);
        head = head_next;
    }
    return zero_count;
}

test "day1b demo" {
    const input =
        \\L68
        \\L30
        \\R48
        \\L5
        \\R60
        \\L55
        \\L1
        \\L99
        \\R14
        \\L82
    ;
    try std.testing.expectEqual(6, solve(input));
}

test "day1b" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day1.txt", &buf);
    try std.testing.expectEqual(6268, solve(input));
}
