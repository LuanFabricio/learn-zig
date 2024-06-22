const std = @import("std");
const idk = @import("idk/idk.zig");

const Allocator = std.mem.Allocator;

const ray = @cImport({
    @cInclude("/usr/local/include/raylib.h");
});

const WIDTH = 1280;
const HEIGHT = 720;

const MoveDirection = enum(usize) {
    Left,
    Right,
    Up,
    Down,
};

// TODO: Create a box module
const Box = struct {
    pos: ray.Vector2,
    size: ray.Vector2,
    color: ray.Color,

    fn init(x: f32, y: f32, w: f32, h: f32, color: ray.Color) Box {
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

    fn clone(self: *const Box) Box {
        return .{
            .pos = self.pos,
            .size = self.size,
            .color = self.color,
        };
    }

    fn draw(self: *const Box) void {
        ray.DrawRectangleV(self.pos, self.size, self.color);
    }

    fn checkCollision(self: *Box, other: Box) bool {
        return self.pos.x <= other.pos.x + other.size.x and self.pos.x + self.size.x >= other.pos.x and self.pos.y <= other.pos.y + other.size.y and self.pos.y + self.size.y >= other.pos.y;
    }
};

const BoxArray = struct {
    pos: usize,
    items: []Box,
    allocator: Allocator,

    fn init(allocator: Allocator) !BoxArray {
        return .{
            .pos = 0,
            .allocator = allocator,
            .items = try allocator.alloc(Box, 1),
        };
    }

    fn deinit(self: BoxArray) void {
        self.allocator.free(self.items);
    }

    fn add(self: *BoxArray, value: Box) !void {
        const pos = self.pos;
        const len = self.items.len;

        if (pos >= len) {
            try self.realloc();
        }

        self.items[self.pos] = value;
        self.pos += 1;
    }

    fn realloc(self: *BoxArray) !void {
        const len = self.items.len;
        var tmp = try self.allocator.alloc(Box, len * 2);

        @memcpy(tmp[0..len], self.items);
        self.items = tmp;
    }
};

fn CherryFromRandom() Box {
    const rand = std.crypto.random;

    var cherry: Box = undefined;
    cherry.size.x = 32;
    cherry.size.y = 32;
    cherry.color = ray.RED;

    cherry.pos.x = 0 + WIDTH * rand.float(f32);
    cherry.pos.y = 0 + HEIGHT * rand.float(f32);
    return cherry;
}

// TODO: Create a snake module
const Snake = struct {
    head: Box,
    body: BoxArray,
    move_step: f32,
    move_direction: MoveDirection,

    fn draw(self: *Snake) void {
        self.head.draw();

        for (self.body.items) |box| {
            box.draw();
        }
    }

    fn move(self: *Snake) void {
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

    fn updateDirection(self: *Snake) void {
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

// TODO: Move to init function o Snake struct
fn SnakeNew(allocator: Allocator, pos: ray.Vector2, move_step: f32, move_direction: MoveDirection) !Snake {
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

pub fn main() !void {
    ray.InitWindow(WIDTH, HEIGHT, "Znake");
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);
    const allocator = std.heap.page_allocator;

    var cherry = CherryFromRandom();
    var snake = try SnakeNew(allocator, ray.Vector2{ .x = WIDTH / 2 - 32, .y = HEIGHT / 2 - 32 }, 1.75, MoveDirection.Up);
    defer BoxArray.deinit(snake.body);
    var score: u32 = 0;

    var blocks = try BoxArray.init(allocator);
    defer BoxArray.deinit(blocks);

    const boxs: [3]Box = .{
        Box.init(42, 42, 32, 32, ray.BLUE),
        Box.init(72, 42, 32, 32, ray.RED),
        Box.init(42, 72, 32, 32, ray.GRAY),
    };

    inline for (boxs) |v| {
        try blocks.add(v);
    }

    while (!ray.WindowShouldClose()) {
        snake.updateDirection();
        snake.move();
        {
            ray.BeginDrawing();
            defer ray.EndDrawing();

            ray.ClearBackground(ray.RAYWHITE);
            const score_str = try std.fmt.allocPrintZ(allocator, "Score: {d}", .{score});

            ray.DrawText(score_str, 20, 20, 20, ray.LIGHTGRAY);
            snake.draw();
            cherry.draw();
        }

        if (snake.head.checkCollision(cherry)) {
            cherry = CherryFromRandom();
            score += 1;
            // TODO: Add a box on the body
            // var clone = snake.head.clone();
            // clone.pos.x += clone.size.x;
            // try snake.body.add(clone);
        }
    }
}
