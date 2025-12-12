const std = @import("std");

pub fn solve(input: []const u8) !usize {
    var it = std.mem.splitSequence(u8, input[0 .. input.len - 1], "\n\n");

    var shapes: [6]usize = undefined;
    for (0..6) |i| {
        shapes[i] = @intCast(std.mem.count(u8, it.next().?, "#"));
    }

    var valid_count: usize = 0;
    var region_it = std.mem.splitScalar(u8, it.next().?, '\n');
    while (region_it.next()) |r| {
        const x_ch = std.mem.indexOfScalar(u8, r, 'x').?;
        const colon = std.mem.indexOfScalar(u8, r, ':').?;
        const x = try std.fmt.parseUnsigned(usize, r[0..x_ch], 10);
        const y = try std.fmt.parseUnsigned(usize, r[x_ch + 1 .. colon], 10);
        var counts_it = std.mem.splitScalar(u8, r[colon + 2..], ' ');
        var sum: usize = 0;
        var i: usize = 0;
        while (counts_it.next()) |count| {
            sum += shapes[i] * try std.fmt.parseUnsigned(u8, count, 10);
            i+=1;
        }
        if (sum <= x * y) valid_count += 1;
    }
    return valid_count;
}

test "real" {
    var buf: [2 << 16]u8 = undefined;
    const input = try std.fs.cwd().readFile("./data/day12.txt", &buf);
    try std.testing.expectEqual(476, solve(input));
}
