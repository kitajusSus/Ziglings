const std = @import("std");
const math = std.math;
const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

const WIDTH = 800;
const HEIGHT = 600;
const FOCAL_LENGTH = 5.0;
const PROJECTION_SCALE = 2.0;
const ROTATION_SPEED = 0.02;
const BALL_SPEED = 0.05;

// Generowanie wierzchołków teseraktu (±1, ±1, ±1, ±1)
const vertices = blk: {
    var list: [16][4]f32 = undefined;
    for (&list, 0..) |*v, i| {
        const x = if (i & 1 != 0) 1.0 else -1.0;
        const y = if (i & 2 != 0) 1.0 else -1.0;
        const z = if (i & 4 != 0) 1.0 else -1.0;
        const w = if (i & 8 != 0) 1.0 else -1.0;
        v.* = .{ x, y, z, w };
    }
    break :blk list;
};

pub fn main() !void {
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
        std.debug.print("Błąd inicjalizacji SDL: {s}\n", .{c.SDL_GetError()});
        return;
    }
    defer c.SDL_Quit();

    const window = c.SDL_CreateWindow("Tesseract Zig", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, WIDTH, HEIGHT, 0);
    const renderer = c.SDL_CreateRenderer(window, -1, c.SDL_RENDERER_ACCELERATED);

    var angle_xy: f32 = 0.0;
    var angle_zw: f32 = 0.0;
    var ball_time: f32 = 0.0;
    var quit = false;

    // Główna pętla programu
    while (!quit) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != 0) {
            if (event.type == c.SDL_QUIT) quit = true;
        }

        c.SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        c.SDL_RenderClear(renderer);
        
        // Animacja kątów
        angle_xy += ROTATION_SPEED;
        angle_zw += ROTATION_SPEED;
        ball_time += BALL_SPEED;

        // Przetwarzaj wszystkie wierzchołki
        var points2d: [16][2]f32 = undefined;
        for (vertices, 0..) |vertex, i| {
            // Rotacja w płaszczyźnie XY
            const xy_rot = .{
                vertex[0] * math.cos(angle_xy) - vertex[1] * math.sin(angle_xy),
                vertex[0] * math.sin(angle_xy) + vertex[1] * math.cos(angle_xy),
            };
            
            // Rotacja w płaszczyźnie ZW
            const zw_rot = .{
                vertex[2] * math.cos(angle_zw) - vertex[3] * math.sin(angle_zw),
                vertex[2] * math.sin(angle_zw) + vertex[3] * math.cos(angle_zw),
            };

            // Projekcja 4D -> 3D
            const denominator = 1.0 + zw_rot[1] / PROJECTION_SCALE;
            const point3d = .{
                xy_rot[0] / denominator,
                xy_rot[1] / denominator,
                zw_rot[0] / denominator,
            };

            // Projekcja 3D -> 2D
            const depth = FOCAL_LENGTH + point3d[2];
            points2d[i] = .{
                (point3d[0] * FOCAL_LENGTH) / depth * 100 + 400,
                (point3d[1] * FOCAL_LENGTH) / depth * 100 + 300,
            };
        }

        // Rysuj krawędzie teseraktu
        c.SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
        for (0..16) |i| {
            for (0..4) |bit| {
                const j = i ^ (@as(usize, 1) << bit;
                if (j > i) {
                    const p1 = points2d[i];
                    const p2 = points2d[j];
                    _ = c.SDL_RenderDrawLine(renderer, @intFromFloat(p1[0]), @intFromFloat(p1[1]), @intFromFloat(p2[0]), @intFromFloat(p2[1]));
                }
            }
        }

        // Animacja kulki
        const ball_pos = .{
            @cos(ball_time),
            0.0,
            0.0,
            @sin(ball_time),
        };

        // Rotacja kulki
        const ball_xy_rot = .{
            ball_pos[0] * math.cos(angle_xy) - ball_pos[1] * math.sin(angle_xy),
            ball_pos[0] * math.sin(angle_xy) + ball_pos[1] * math.cos(angle_xy),
        };
        
        const ball_zw_rot = .{
            ball_pos[2] * math.cos(angle_zw) - ball_pos[3] * math.sin(angle_zw),
            ball_pos[2] * math.sin(angle_zw) + ball_pos[3] * math.cos(angle_zw),
        };

        // Projekcja kulki
        const ball_denominator = 1.0 + ball_zw_rot[1] / PROJECTION_SCALE;
        const ball3d = .{
            ball_xy_rot[0] / ball_denominator,
            ball_xy_rot[1] / ball_denominator,
            ball_zw_rot[0] / ball_denominator,
        };

        const ball_depth = FOCAL_LENGTH + ball3d[2];
        const ball2d = .{
            (ball3d[0] * FOCAL_LENGTH) / ball_depth * 100 + 400,
            (ball3d[1] * FOCAL_LENGTH) / ball_depth * 100 + 300,
        };

        // Rysuj kulkę
        const radius = 10;
        const ball_rect = c.SDL_Rect{
            .x = @intFromFloat(ball2d[0] - @as(f32, @floatFromInt(radius)) / 2),
            .y = @intFromFloat(ball2d[1] - @as(f32, @floatFromInt(radius)) / 2),
            .w = radius,
            .h = radius,
        };
        c.SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
        _ = c.SDL_RenderFillRect(renderer, &ball_rect);

        c.SDL_RenderPresent(renderer);
        c.SDL_Delay(16);
    }

    c.SDL_DestroyRenderer(renderer);
    c.SDL_DestroyWindow(window);
}
