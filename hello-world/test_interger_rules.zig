const std = @import("std");

const expect = std.testing.expect;

const decimal_int: i32 = 98222;
const hex_int: u8 = 0xff;
const another_hex_int: u8 = 0xFF;
const octal_int: u16 = 0o755;
const binary_int: u8 = 0b11110000;

const one_billion: u64 = 1_000_000_000;
const binary_mask: u64 = 0b1_1111_1111;
const permissions: u64 = 0o755;
const bit_address: u64 = 0xFF80_0000_0000_0000;

test "interger widening" {
    const a: u8 = 250;
    const b: u8 = a;
    const c: u8 = b;

    try expect(a == c);
}

test "@intCast" {
    const x: u64 = 200;
    const y = @as(u8, @intCast(x));
    try expect(@TypeOf(y) == u8);
    try expect(x == y);
}

test "well defined overflow" {
    var a: u8 = 255;
    a +%= 1;
    try expect(a == 0);
}
