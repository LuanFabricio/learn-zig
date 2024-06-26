const std = @import("std");

const Allocator = std.mem.Allocator;

const ray = @cImport({
    @cInclude("/usr/local/include/raylib.h");
    @cInclude("/usr/local/include/raymath.h");
});

const box = @import("box/box.zig");
const Box = box.Box;
const BoxArray = box.BoxArray;

const snake = @import("snake/snake.zig");
const Snake = snake.Snake;
const MoveDirection = snake.MoveDirection;

const WIDTH = 1280;
const HEIGHT = 720;

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
    var player = try Snake.init(allocator, ray.Vector2{ .x = WIDTH / 2 - 32, .y = HEIGHT / 2 - 32 }, 32, MoveDirection.Up);
    defer BoxArray.deinit(player.body);
    var score: u32 = 0;

    while (!ray.WindowShouldClose()) {
        player.updateDirection();
        player.move();
        {
            ray.BeginDrawing();
            defer ray.EndDrawing();

            ray.ClearBackground(ray.RAYWHITE);

            player.draw();
            cherry.draw();

            const score_str = try std.fmt.allocPrintZ(allocator, "Score: {d}", .{score});
            ray.DrawText(score_str, 20, 20, 20, ray.LIGHTGRAY);
        }

        if (player.head.checkCollision(cherry)) {
            cherry = createCherry();
            score += 1;
            try player.increaseBody();
        }
    }
}
