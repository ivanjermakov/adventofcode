const std = @import("std");

pub fn solve(input: []const u8) !usize {
    var total: usize = 0;
    const stride: u8 = @intCast(std.mem.indexOfScalar(u8, input, '\n').?);
    var positions = std.mem.zeroes([2 << 14]u1);
    var len: usize = 0;
    for (input) |ch| {
        if (ch == '\n') continue;
        positions[len] = @intFromBool(ch == '@');
        len += 1;
    }
    const rows: usize = @divExact(len, stride);
    for (0..rows) |row| {
        for (0..stride) |col| {
            const i = stride * row + col;
            if (positions[i] == 0) {
                continue;
            }
            var neighbors: u8 = 0;
            inline for (.{
                .{ -1, -1 },
                .{ -1, 0 },
                .{ -1, 1 },
                .{ 0, -1 },
                .{ 0, 1 },
                .{ 1, -1 },
                .{ 1, 0 },
                .{ 1, 1 },
            }) |offset| {
                const n_row = @as(i32, @intCast(row)) + offset[0];
                const n_col = @as(i32, @intCast(col)) + offset[1];
                if (n_row >= 0 and n_row < rows and n_col >= 0 and n_col < stride) {
                    const np: i32 = @as(i32, @intCast(stride)) * n_row + n_col;
                    if (positions[@abs(np)] == 1) {
                        neighbors += 1;
                    }
                }
            }
            const is_roll = neighbors < 4;
            total += @intFromBool(is_roll);
        }
    }
    return total;
}

test "demo" {
    const input =
        \\..@@.@@@@.
        \\@@@.@.@.@@
        \\@@@@@.@.@@
        \\@.@@@@..@.
        \\@@.@@@@.@@
        \\.@@@@@@@.@
        \\.@.@.@.@@@
        \\@.@@@.@@@@
        \\.@@@@@@@@.
        \\@.@.@@@.@.
        \\
    ;
    try std.testing.expectEqual(13, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day4.txt", &buf);
    try std.testing.expectEqual(1560, solve(input));
}
