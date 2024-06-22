const std = @import("std");

pub fn something() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.writeAll("IDK\n");
}
