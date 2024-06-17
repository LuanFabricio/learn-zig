const std = @import("std");

fn myImplementation(stdout: std.fs.File.Writer, count: u8) !void {
    var printed = false;

    if (count % 3 == 0) {
        try stdout.print("fizz", .{});
        printed = true;
    }

    if (count % 5 == 0) {
        if (printed) try stdout.print(" ", .{}) else printed = true;
        try stdout.print("buzz", .{});
    }

    if (printed) try stdout.print("\n", .{}) else try stdout.print("{}\n", .{count});
}

fn zigGuideImplementation(stdout: std.fs.File.Writer, count: u8) !void {
    const div_3: u2 = @intFromBool(count % 3 == 0);
    const div_5: u2 = @intFromBool(count % 5 == 0);

    switch (div_5 * 2 + div_3) {
        0b00 => try stdout.print("{}\n", .{count}),
        0b01 => try stdout.writeAll("fizz\n"),
        0b10 => try stdout.writeAll("buzz\n"),
        0b11 => try stdout.writeAll("fizz buzz\n"),
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("Type: {}\n", .{@TypeOf(stdout)});
    var count: u8 = 1;

    while (count <= 100) : (count += 1) {
        try myImplementation(stdout, count);
        // try zigGuideImplementation(stdout, count);
    }
}
