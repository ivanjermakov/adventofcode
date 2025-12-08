const std = @import("std");

const Pos = struct {
    row: u8,
    col: u8,
};

const diagonals = .{
    .{ -1, -1 },
    .{ -1, 0 },
    .{ -1, 1 },
    .{ 0, -1 },
    .{ 0, 1 },
    .{ 1, -1 },
    .{ 1, 0 },
    .{ 1, 1 },
};

pub fn solve(input: []const u8) !usize {
    var total: usize = 0;
    const cols = std.mem.indexOfScalar(u8, input, '\n').?;

    var positions = std.mem.zeroes([2 << 14]u8);
    var len: usize = 0;
    for (input) |ch| {
        switch (ch) {
            '\n' => continue,
            '@' => positions[len] = 1,
            else => {},
        }
        len += 1;
    }
    const rows: usize = @divExact(len, cols);

    var dirty: [2 << 10]Pos = undefined;
    var dirty_len: usize = 0;
    var neighbor_count = std.mem.zeroes([2 << 14]u8);
    for (0..rows) |row| {
        for (0..cols) |col| {
            const i = cols * row + col;
            if (positions[i] == 0) continue;

            var neighbors: u8 = 0;
            inline for (diagonals) |offset| {
                const n_row = @as(i32, @intCast(row)) + offset[0];
                const n_col = @as(i32, @intCast(col)) + offset[1];

                if (n_row >= 0 and n_row < rows and n_col >= 0 and n_col < cols) {
                    const np = cols * @abs(n_row) + @abs(n_col);
                    neighbors += positions[np];
                }
            }

            if (neighbors < 4) {
                dirty[dirty_len] = .{ .row = @intCast(row), .col = @intCast(col) };
                dirty_len += 1;
            } else {
                neighbor_count[i] = neighbors;
            }
        }
    }

    while (dirty_len > 0) {
        const p = dirty[dirty_len - 1];
        dirty_len -= 1;
        total += 1;
        inline for (diagonals) |offset| {
            const n_row = @as(i32, @intCast(p.row)) + offset[0];
            const n_col = @as(i32, @intCast(p.col)) + offset[1];
            if (n_row >= 0 and n_row < rows and n_col >= 0 and n_col < cols) {
                const ni = @abs(@as(i32, @intCast(cols)) * n_row + n_col);
                if (neighbor_count[ni] == 4) {
                    dirty[dirty_len] = .{ .row = @intCast(n_row), .col = @intCast(n_col) };
                    dirty_len +|= 1;
                }
                neighbor_count[ni] -|= 1;
            }
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
    try std.testing.expectEqual(43, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day4.txt", &buf);
    try std.testing.expectEqual(9609, solve(input));
}
