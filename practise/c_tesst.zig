// build with `zig build-exe c_tesst.zig -lc -lraylib`
const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const MAX_PARTICLES = 500;

// Struktura dla pojedynczej cząsteczki
const Particle = struct {
    position: ray.Vector3,
    velocity: ray.Vector3,
    color: ray.Color,
    alpha: f32,
    size: f32,
    active: bool,
};
const colors = [_]ray.Color{
    ray.GOLD,
    ray.PINK,
    ray.LIME,
    ray.SKYBLUE,
    ray.VIOLET,
    ray.ORANGE,
    ray.RED,
    ray.GREEN,
};
// Struktura zarządzająca systemem cząsteczek
var particles: [MAX_PARTICLES]Particle = undefined;
var gravity: ray.Vector3 = .{ .x = 0.001, .y = -0.05, .z = 0 };

// Funkcja do resetowania cząsteczek
fn initParticles() void {
    for (0..MAX_PARTICLES) |i| {
        particles[i] = .{
            .position = .{
                .x = std.crypto.random.float(f32) * 40 - 20,
                .y = std.crypto.random.float(f32) * 20 + 10,
                .z = std.crypto.random.float(f32) * 40 - 20,
            },
            .velocity = .{
                .x = std.crypto.random.float(f32) * 2 - 1,
                .y = std.crypto.random.float(f32) * 2 - 1,
                .z = std.crypto.random.float(f32) * 2 - 1,
            },
            .color = colors[std.crypto.random.intRangeLessThan(u32, 0, colors.len)],
            .alpha = 1.0,
            .size = std.crypto.random.float(f32) * 0.2 + 0.1,
            .active = true,
        };
    }
}

// Funkcja do aktualizacji cząsteczek
fn updateParticles() void {
    for (0..MAX_PARTICLES) |i| {
        if (particles[i].active) {
            particles[i].velocity.y += gravity.y;

            particles[i].position.x += particles[i].velocity.x * 0.1;
            particles[i].position.y += particles[i].velocity.y * 0.1;
            particles[i].position.z += particles[i].velocity.z * 0.1;

            particles[i].alpha -= 0.01;

            if (particles[i].alpha <= 0) {
                particles[i].active = false;
            }
        } else {
            // Reaktywuj cząsteczkę
            particles[i] = .{
                .position = .{
                    .x = std.crypto.random.float(f32) * 40 - 20,
                    .y = std.crypto.random.float(f32) * 20 + 10,
                    .z = std.crypto.random.float(f32) * 40 - 20,
                },
                .velocity = .{
                    .x = std.crypto.random.float(f32) * 2 - 1,
                    .y = std.crypto.random.float(f32) * 2 - 1,
                    .z = std.crypto.random.float(f32) * 2 - 1,
                },
                .color = colors[std.crypto.random.intRangeLessThan(u32, 0, colors.len)],
                .alpha = 1.0,
                .size = std.crypto.random.float(f32) * 0.2 + 0.1,
                .active = true,
            };
        }
    }
}

pub fn main() !void {
    const screenWidth = 1280;
    const screenHeight = 720;

    ray.InitWindow(screenWidth, screenHeight, " Deszcz Meteorytów");
    defer ray.CloseWindow();

    var camera = ray.Camera3D{
        .position = .{ .x = 0.0, .y = 10.0, .z = 25.0 },
        .target = .{ .x = 0.0, .y = 0.0, .z = 0.0 },
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .fovy = 45.0,
        .projection = ray.CAMERA_PERSPECTIVE,
    };

    initParticles();

    ray.SetTargetFPS(60);

    while (!ray.WindowShouldClose()) {
        // Aktualizacja kamery
        const time = ray.GetTime();
        camera.position.x = @cos(@as(f32, @floatCast(time))) * 25.0;
        camera.position.z = @sin(@as(f32, @floatCast(time))) * 25.0;

        updateParticles();

        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.BLACK);

        ray.BeginMode3D(camera);

        // Rysuj cząsteczki
        for (0..MAX_PARTICLES) |i| {
            if (particles[i].active) {
                ray.DrawSphere(particles[i].position, particles[i].size, ray.Fade(particles[i].color, particles[i].alpha));
            }
        }
        // Rysuj podłoże
        ray.DrawGrid(20, 2.0);

        ray.EndMode3D();

        ray.DrawFPS(10, 10);
        ray.DrawText("SKIBIDI TOILET", 250, 350, 60, ray.GREEN);
    }
}
