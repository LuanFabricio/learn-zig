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
    size: f32,
    move_direction: MoveDirection,

    pub fn init(allocator: Allocator, pos: ray.Vector2, size: f32, move_direction: MoveDirection) !Snake {
        var snake: Snake = undefined;
        snake.head.pos = pos;
        snake.head.size.x = size;
        snake.head.size.y = size;
        snake.head.color = ray.GREEN;

        snake.size = size;
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
        const oldPosition = self.head;

        const speed = self.calcSpeed();
        switch (self.move_direction) {
            MoveDirection.Up => {
                self.head.pos.y -= speed;
            },
            MoveDirection.Down => {
                self.head.pos.y += speed;
            },
            MoveDirection.Left => {
                self.head.pos.x -= speed;
            },
            MoveDirection.Right => {
                self.head.pos.x += speed;
            },
        }

        const bodyLen = self.body.items.len;
        var i = if (bodyLen > 0) self.body.items.len - 1 else 0;
        while (i > 0) : (i -= 1) {
            self.body.items[i] = self.body.items[i - 1];
        }
        if (bodyLen > 0) self.body.items[i] = oldPosition;
    }

    pub fn increaseBody(self: *Snake) !void {
        var clone = self.head.clone();
        const speed = self.calcSpeed();

        switch (self.move_direction) {
            MoveDirection.Up => {
                clone.pos.y += speed;
            },
            MoveDirection.Down => {
                clone.pos.y -= speed;
            },
            MoveDirection.Right => {
                clone.pos.x += speed;
            },
            MoveDirection.Left => {
                clone.pos.x -= speed;
            },
        }

        try self.body.add(clone);
    }

    fn calcSpeed(self: *Snake) f32 {
        const frameTime = ray.GetFrameTime();
        const speed = self.size * frameTime * 4.5;
        return speed;
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
