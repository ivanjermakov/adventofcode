const std = @import("std");

pub fn solve(input: []const u8) !usize {
    const width = std.mem.indexOfScalar(u8, input, '\n').?;
    const height = @divExact(input.len - 1, width);
    var splits: usize = 0;
    var it = std.mem.splitScalar(u8, input[0..input.len - 1], '\n');
    var beams: [2 << 7]u1 = @splat(0);
    var beams_next: [2 << 7]u1 = @splat(0);
    beams_next[@divFloor(width, 2)] = 1;
    for (0..height) |l| {
        const line = it.next() orelse break;
        if (l < 2 or l % 2 != 0) continue;
        beams = beams_next;
        var splitter_idx: usize = 0;
        while (std.mem.indexOfScalar(u8, line[splitter_idx + 1 ..], '^')) |i| {
            splitter_idx += 1 + i;
            beams_next[splitter_idx] = 0;
            if (beams[splitter_idx] == 1) {
                beams_next[splitter_idx - 1] = 1;
                beams_next[splitter_idx + 1] = 1;
                splits += 1;
            }
        }
    }

    return splits;
}

test "demo" {
    const input =
        \\.......S.......
        \\...............
        \\.......^.......
        \\...............
        \\......^.^......
        \\...............
        \\.....^.^.^.....
        \\...............
        \\....^.^...^....
        \\...............
        \\...^.^...^.^...
        \\...............
        \\..^...^.....^..
        \\...............
        \\.^.^.^.^.^...^.
        \\...............
        \\
    ;
    try std.testing.expectEqual(21, solve(input));
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day7.txt", &buf);
    try std.testing.expectEqual(1579, solve(input));
}
