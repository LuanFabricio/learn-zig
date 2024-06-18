const std = @import("std");

const expect = std.testing.expect;

fn increment(num: *u8) void {
    num.* += 1;
}

test "pointers" {
    var x: u8 = 1;
    increment(&x);
    try expect(x == 2);
}

test "naughty pointer" {
    const x: u16 = 0;
    // const y: *u8 = @ptrFromInt(x);
    // _ = y;
    _ = x;
}

test "const pointers" {
    const x: u8 = 1;
    // var y = &x;
    // y.* += 1;
    // y = 42;

    _ = x;
}

test "usize" {
    try expect(@sizeOf(usize) == @sizeOf(*u8));
    try expect(@sizeOf(isize) == @sizeOf(*u8));
}

test "many pointers" {
    var arr = [2]u16{ 42, 1024 };

    try expect(arr[0] == 42);
    try expect(arr[1] == 1024);

    var ptr: [*]u16 = &arr;
    ptr[0] = 1;
    ptr[1] = 2;

    try expect(arr[0] == 1);
    try expect(arr[1] == 2);
}
