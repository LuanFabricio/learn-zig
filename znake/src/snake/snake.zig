const Allocator = @import("std").mem.Allocator;

const ray = @cImport({
    @cInclude("/usr/local/include/raylib.h");
    @cInclude("/usr/local/include/raymath.h");
});

const box = @import("../box/box.zig");
const Box = box.Box;
const BoxArray = box.BoxArray;

pub const MoveDirection = enum(usize) {
    Left,
    Right,
    Up,
    Down,
};

pub const Snake = struct {
    head: Box,
    body: BoxArray,
    move_step: f32,
    move_direction: MoveDirection,

    pub fn init(allocator: Allocator, pos: ray.Vector2, move_step: f32, move_direction: MoveDirection) !Snake {
        var snake: Snake = undefined;
        snake.head.pos = pos;
        snake.head.size.x = 32;
        snake.head.size.y = 32;
        snake.head.color = ray.GREEN;

        snake.move_step = move_step;
        snake.move_direction = move_direction;
        snake.body = try BoxArray.init(allocator);

        return snake;
    }

    pub fn draw(self: *Snake) void {
        self.head.draw();

        for (self.body.items) |b| {
            b.draw();
        }
    }

    pub fn move(self: *Snake) void {
        switch (self.move_direction) {
            MoveDirection.Up => {
                self.head.pos.y -= self.move_step;
            },
            MoveDirection.Down => {
                self.head.pos.y += self.move_step;
            },
            MoveDirection.Left => {
                self.head.pos.x -= self.move_step;
            },
            MoveDirection.Right => {
                self.head.pos.x += self.move_step;
            },
        }
    }

    pub fn updateDirection(self: *Snake) void {
        if (ray.IsKeyPressed(ray.KEY_W)) {
            self.move_direction = MoveDirection.Up;
        } else if (ray.IsKeyPressed(ray.KEY_S)) {
            self.move_direction = MoveDirection.Down;
        } else if (ray.IsKeyPressed(ray.KEY_A)) {
            self.move_direction = MoveDirection.Left;
        } else if (ray.IsKeyPressed(ray.KEY_D)) {
            self.move_direction = MoveDirection.Right;
        }
    }
};
