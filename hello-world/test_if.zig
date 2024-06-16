const std = @import("std");

const expect = std.testing.expect;

test "if statement" {
    const a = true;
    var x: i16 = 0;
    if (a) {
        x += 1;
    } else {
        x += 2;
    }

    try expect(x == 1);
}

test "if statment expression" {
    const a = true;
    var x: i16 = 0;
    x += if (a) 1 else 2;
    try expect(x == 1);
}
