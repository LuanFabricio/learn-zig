const std = @import("std");

const expect = std.testing.expect;

const Direction = enum { north, south, east, weast };
const Value = enum(u2) { zero, one, two, three };

test "enum ordinal value" {
    try expect(@intFromEnum(Value.zero) == 0b00);
    try expect(@intFromEnum(Value.one) == 0b01);
    try expect(@intFromEnum(Value.two) == 0b10);
    try expect(@intFromEnum(Value.three) == 0b11);
}

const Value2 = enum(u32) { hundred = 100, thousand = 1000, million = 1000000, next };

test "set enum ordinal value" {
    try expect(@intFromEnum(Value2.hundred) == 100);
    try expect(@intFromEnum(Value2.thousand) == 1000);
    try expect(@intFromEnum(Value2.million) == 1000000);
    try expect(@intFromEnum(Value2.next) == 1000001);
}

const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};

test "enum method" {
    try expect(Suit.spades.isClubs() == Suit.isClubs(.spades));
}

const Mode = enum {
    var count: u32 = 0;
    on,
    off,
};

test "hmm" {
    Mode.count += 1;
    try expect(Mode.count == 1);
}
