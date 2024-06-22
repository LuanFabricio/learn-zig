const std = @import("std");

const ray = @cImport({
    @cInclude("/usr/local/include/raylib.h");
    @cInclude("/usr/local/include/raymath.h");
});

pub const Box = struct {
    pos: ray.Vector2,
    size: ray.Vector2,
    color: ray.Color,

    pub fn init(x: f32, y: f32, w: f32, h: f32, color: ray.Color) Box {
        return .{
            .pos = ray.Vector2{
                .x = x,
                .y = y,
            },
            .size = ray.Vector2{
                .x = w,
                .y = h,
            },
            .color = color,
        };
    }

    pub fn CherryFromRandom(minPos: ray.Vector2, maxPos: ray.Vector2, size: ray.Vector2, color: ray.Color) Box {
        const rand = std.crypto.random;

        var cherry: Box = undefined;
        cherry.size = size;
        cherry.color = color;

        cherry.pos.x = minPos.x + maxPos.x * rand.float(f32);
        cherry.pos.y = minPos.y + maxPos.y * rand.float(f32);
        return cherry;
    }
    pub fn clone(self: *const Box) Box {
        return .{
            .pos = self.pos,
            .size = self.size,
            .color = self.color,
        };
    }

    pub fn draw(self: *const Box) void {
        ray.DrawRectangleV(self.pos, self.size, self.color);
    }

    pub fn checkCollision(self: *Box, other: Box) bool {
        return self.pos.x <= other.pos.x + other.size.x and self.pos.x + self.size.x >= other.pos.x and self.pos.y <= other.pos.y + other.size.y and self.pos.y + self.size.y >= other.pos.y;
    }
};
