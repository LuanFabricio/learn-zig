const std = @import("std");

const expect = std.testing.expect;

test "optional-if" {
    const maybe_run: ?usize = 10;
    if (maybe_run) |value| {
        try expect(@TypeOf(value) == usize);
        try expect(value == 10);
    } else {
        unreachable;
    }
}

test "error union if" {
    const ent_num: error{UnknowEntity}!i32 = 5;

    if (ent_num) |value| {
        try expect(@TypeOf(value) == i32);
        try expect(value == 5);
    } else |err| {
        _ = err catch {};
        unreachable;
    }
}

test "while optional" {
    var i: ?u32 = 10;
    while (i) |value| : (i.? -= 1) {
        try expect(@TypeOf(value) == u32);
        if (value == 1) {
            i = null;
            break;
        }
    }
    try expect(i == null);
}

var numbers_left2: u32 = undefined;

fn eventuallyErrorSequence() !u32 {
    return if (numbers_left2 == 0) error.ReachedZero else blk: {
        numbers_left2 -= 1;
        break :blk numbers_left2;
    };
}

test "while error union capture" {
    var sum: u32 = 0;
    numbers_left2 = 3;
    while (eventuallyErrorSequence()) |value| {
        sum += value;
    } else |err| {
        try expect(err == error.ReachedZero);
    }
}

test "for capture" {
    const x = [_]i8{ 1, 5, 120, -5 };
    for (x) |v| try expect(@TypeOf(v) == i8);
}

const Info = union(enum) {
    a: u32,
    b: []const u8,
    c,
    d: u32,
};

test "switch capture" {
    const b = Info{ .a = 10 };
    const x = switch (b) {
        .b => |str| blk: {
            try expect(@TypeOf(str) == []const u8);
            break :blk 1;
        },
        .c => 2,
        .a, .d => |num| blk: {
            try expect(@TypeOf(num) == u32);
            break :blk num * 2;
        },
    };
    try expect(x == 20);
}

const eql = std.mem.eql;

test "for with pointer capture" {
    var data = [_]u8{ 1, 2, 3 };
    for (&data) |*byte| byte.* += 1;
    try expect(eql(u8, &data, &[_]u8{ 2, 3, 4 }));
}
