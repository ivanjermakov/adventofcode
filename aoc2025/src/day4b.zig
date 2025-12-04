const std = @import("std");

pub fn solve(input: []const u8) !usize {
    const in = if (input[input.len - 1] == '\n') input[0 .. input.len - 2] else input;
    var total: usize = 0;
    var dirty = true;
    const stride: u8 = @intCast(std.mem.indexOfScalar(u8, in, '\n').?);
    var positions = std.mem.zeroes([2 << 14]u1);
    var positions_next = std.mem.zeroes([2 << 14]u1);

    var len: usize = 0;
    for (in) |ch| {
        if (ch == '\n') continue;
        positions[len] = @intFromBool(ch == '@');
        len += 1;
    }
    positions_next = positions;

    const rows: usize = @divExact(len, stride);
    while (dirty) {
        positions = positions_next;
        dirty = false;
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
                if (is_roll) {
                    total += 1;
                    positions_next[i] = 0;
                    dirty = true;
                }
            }
        }
    }
    return total;
}

test "day4b demo" {
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
    ;
    try std.testing.expectEqual(43, solve(input));
}

test "day4b" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day4.txt", &buf);
    try std.testing.expectEqual(9609, solve(input));
}
