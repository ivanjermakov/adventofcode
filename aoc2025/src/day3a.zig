const std = @import("std");

pub fn solve(input: []const u8) !usize {
    const in = if (input[input.len - 1] == '\n') input[0 .. input.len - 2] else input;
    var it = std.mem.splitScalar(u8, in, '\n');
    var total: usize = 0;
    while (it.next()) |line| {
        var largest1: u8 = 0;
        var largest1_idx: usize = 0;
        for (0..line.len - 1) |i| {
            const d = line[i] - '0';
            if (d > largest1) {
                largest1 = d;
                largest1_idx = i;
            }
        }
        var largest2: u8 = 0;
        for (largest1_idx + 1..line.len) |i| {
            const d = line[i] - '0';
            if (d > largest2) largest2 = d;
        }
        total += 10 * largest1 + largest2;
    }
    return total;
}

test "day3a demo" {
    const input =
        \\987654321111111
        \\811111111111119
        \\234234234234278
        \\818181911112111
    ;
    try std.testing.expectEqual(357, solve(input));
}

test "day3a" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day3.txt", &buf);
    try std.testing.expectEqual(0, solve(input));
}
