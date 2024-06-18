const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    if (args.len < 2) return error.ExpectedArgument;

    const fahrenheit = try std.fmt.parseFloat(f32, args[1]);
    const celsius = (fahrenheit - 32) * (5.0 / 9.0);

    try stdout.print("{d:.1}c\n", .{celsius});
}
