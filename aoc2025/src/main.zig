const std = @import("std");
const day1 = @import("day1.zig");

pub fn main() !void {
    std.debug.print("Hello, AOC!\n", .{});
}

test {
    std.testing.refAllDeclsRecursive(@This());
}

test "test" {}
