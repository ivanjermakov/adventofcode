const std = @import("std");

pub fn solve(input: []const u8) !usize {
    var zero_count: usize = 0;
    var head: i32 = 50;
    var line_iter = std.mem.splitScalar(u8, input, '\n');
    while (line_iter.next()) |line| {
        if (line.len == 0) continue;
        const count = try std.fmt.parseInt(i32, line[1..], 10);
        head = @mod(head + if (line[0] == 'R') count else -count, 100);
        if (head == 0) zero_count += 1;
    }
    return zero_count;
}

test "day1a demo" {
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
    try std.testing.expectEqual(3, solve(input));
}

test "day1a" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day1.txt", &buf);
    try std.testing.expectEqual(1086, solve(input));
}
