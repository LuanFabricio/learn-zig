const std = @import("std");

const expect = std.testing.expect;

const Result = union {
    int: i64,
    float: f64,
    bool: bool,
};

test "simple union" {
    const result = Result{ .int = 1234 };
    // result.float = 12.34;
    _ = result;
}

const Tag = enum { a, b, c, d };

const Tagged = union(Tag) { a: u8, b: f32, c: bool };

test "switch on tagged union" {
    var tagged = Tagged{ .b = 1.5 };

    switch (tagged) {
        .a => |*byte| byte.* += 1,
        .b => |*float| float.* *= 2,
        .c => |*b| b.* = !b,
    }

    try expect(tagged.b == 3);
}
