const std = @import("std");

const Allocator = std.mem.Allocator;

const ray = @cImport({
    @cInclude("/usr/local/include/raylib.h");
    @cInclude("/usr/local/include/raymath.h");
});

const Box = @import("box/box.zig").Box;

const WIDTH = 1280;
const HEIGHT = 720;

const MoveDirection = enum(usize) {
    Left,
    Right,
    Up,
    Down,
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

// TODO: Create a snake module
const Snake = struct {
    head: Box,
    body: BoxArray,
    move_step: f32,
    move_direction: MoveDirection,

    fn draw(self: *Snake) void {
        self.head.draw();

        for (self.body.items) |b| {
            b.draw();
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

fn createCherry() Box {
    return Box.CherryFromRandom(ray.Vector2Zero(), ray.Vector2{
        .x = @as(f32, WIDTH),
        .y = @as(f32, HEIGHT),
    }, ray.Vector2{
        .x = 32,
        .y = 32,
    }, ray.RED);
}

pub fn main() !void {
    ray.InitWindow(WIDTH, HEIGHT, "Znake");
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);
    const allocator = std.heap.page_allocator;

    var cherry = createCherry();
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

            snake.draw();
            cherry.draw();

            const score_str = try std.fmt.allocPrintZ(allocator, "Score: {d}", .{score});
            ray.DrawText(score_str, 20, 20, 20, ray.LIGHTGRAY);
        }

        if (snake.head.checkCollision(cherry)) {
            cherry = createCherry();
            score += 1;
            // TODO: Add a box on the body
            // var clone = snake.head.clone();
            // clone.pos.x += clone.size.x;
            // try snake.body.add(clone);
        }
    }
}
