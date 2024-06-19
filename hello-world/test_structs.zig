const std = @import("std");

const expect = std.testing.expect;

const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,
};

test "struct usage" {
    const my_vector = Vec3{
        .x = 0,
        .y = 100,
        .z = 50,
    };

    _ = my_vector;
}

test "missing struct field" {
    // const my_vector = Vec3{
    //     .x = 0,
    //     .z = 50,
    // };

    // _ = my_vector;
}

const Vec4 = struct {
    x: f32 = 0,
    y: f32 = 0,
    z: f32 = 0,
    w: f32 = 0,
};

test "struct defaults" {
    const my_vector = Vec4{
        .x = 25,
        .y = -50,
    };

    _ = my_vector;
}

const Stuff = struct {
    x: f32,
    y: f32,
    fn swap(self: *Stuff) void {
        const tmp = self.x;
        self.x = self.y;
        self.y = tmp;
    }
};

test "automatic dereference" {
    var thing = Stuff{ .x = 42.0, .y = 1024 };
    thing.swap();
    try expect(thing.x == 1024);
    try expect(thing.y == 42.0);
}
