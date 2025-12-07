const std = @import("std");

pub fn solve(input: []const u8) !usize {
    const in = if (std.mem.eql(u8, input[input.len - 2 ..], "\n\n")) input[0 .. input.len - 2] else input;
    const width = std.mem.indexOfScalar(u8, in, '\n').?;
    const height = @divExact(in.len, width);
    var timelines: usize = 1;
    var it = std.mem.splitScalar(u8, in, '\n');
    var beams: [2 << 7]u64 = @splat(0);
    var beams_next: [2 << 7]u64 = @splat(0);
    beams_next[@divFloor(width, 2)] = 1;
    for (0..height) |l| {
        const line = it.next() orelse break;
        if (l < 2 or l % 2 != 0) continue;
        beams = beams_next;
        var splitter_idx: usize = 0;
        while (std.mem.indexOfScalar(u8, line[splitter_idx + 1 ..], '^')) |i| {
            splitter_idx += 1 + i;
            const c = beams[splitter_idx];
            if (c > 0) {
                beams_next[splitter_idx - 1] += c;
                beams_next[splitter_idx + 1] += c;
                timelines += beams[splitter_idx];
            }
            beams_next[splitter_idx] = 0;
        }
    }

    return timelines;
}

test "day7b demo" {
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
    ;
    try std.testing.expectEqual(40, solve(input));
}

test "day7b" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day7.txt", &buf);
    try std.testing.expectEqual(0, solve(input));
}
