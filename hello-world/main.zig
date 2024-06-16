const std = @import("std");

pub fn main() void {
    std.debug.print("Hello, {s}!\n", .{"World"});

    const truth: i32 = 42;
    var idk = @as(u32, 24);
    std.debug.print("truth: {d}!\n", .{truth});
    std.debug.print("idk: {d}!\n", .{idk});
    idk += 20;
    std.debug.print("idk: {d}!\n", .{idk});

    const some_array = [_]u8{ 'I', 'D', 'K' };
    std.debug.print("Something: {s}!\n", .{some_array});
    std.debug.print("Something length: {d}!\n", .{some_array.len});
}
