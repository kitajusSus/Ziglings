const std = @import("std");
const math = std.math;

// Import SDL2 z C
const sdl = @cImport({
    @cInclude("SDL.h");
});

// Definicje wektorów 4D, 3D i 2D
const Vec4 = struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,
};

const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,
};

const Vec2 = struct {
    x: f32,
    y: f32,
};

// Rzutowanie z 4D do 3D (perspektywiczne, patrzymy z osi w)
fn project4Dto3D(v: Vec4, d4: f32) Vec3 {
    const factor = d4 / (d4 - v.w);
    return Vec3{ .x = v.x * factor, .y = v.y * factor, .z = v.z * factor };
}

// Rzutowanie z 3D do 2D (perspektywiczne, patrzymy z osi z)
fn project3Dto2D(v: Vec3, d3: f32) Vec2 {
    const factor = d3 / (d3 - v.z);
    return Vec2{ .x = v.x * factor, .y = v.y * factor };
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    // Inicjalizacja SDL2
    if (sdl.SDL_Init(sdl.SDL_INIT_VIDEO) != 0) {
        std.debug.print("Błąd SDL_Init: {}\n", .{sdl.SDL_GetError()});
        return error.Runtime;
    }
    defer sdl.SDL_Quit();

    const width: i32 = 800;
    const height: i32 = 600;

    var window = sdl.SDL_CreateWindow(
        "Animacja Teseraktu i Kulki",
        sdl.SDL_WINDOWPOS_CENTERED,
        sdl.SDL_WINDOWPOS_CENTERED,
        width,
        height,
        sdl.SDL_WINDOW_SHOWN
    );
    if (window == null) {
        std.debug.print("Błąd tworzenia okna: {}\n", .{sdl.SDL_GetError()});
        return error.Runtime;
    }
    defer sdl.SDL_DestroyWindow(window);

    var renderer = sdl.SDL_CreateRenderer(window, -1, sdl.SDL_RENDERER_ACCELERATED);
    if (renderer == null) {
        std.debug.print("Błąd tworzenia renderera: {}\n", .{sdl.SDL_GetError()});
        return error.Runtime;
    }
    defer sdl.SDL_DestroyRenderer(renderer);

    // Przygotowanie wierzchołków teseraktu – 16 punktów, każdy o współrzędnych ±1
    var vertices: [16]Vec4 = undefined;
    for (i, _) in vertices {
        vertices[i] = Vec4{
            .x = if ((i & 1) != 0) 1.0 else -1.0,
            .y = if (((i >> 1) & 1) != 0) 1.0 else -1.0,
            .z = if (((i >> 2) & 1) != 0) 1.0 else -1.0,
            .w = if (((i >> 3) & 1) != 0) 1.0 else -1.0,
        };
    }

    // Wyznaczenie krawędzi teseraktu: dwa wierzchołki łączymy, gdy różnią się dokładnie jedną współrzędną.
    var tesseractEdges = std.ArrayList([]usize).init(allocator);
    defer tesseractEdges.deinit();
    for (i, v) in vertices {
        for (j, u) in vertices[(i+1)..] {
            const j_index = i + 1 + j;
            var diff: i32 = 0;
            if (math.abs(v.x - u.x) > 0.1) diff += 1;
            if (math.abs(v.y - u.y) > 0.1) diff += 1;
            if (math.abs(v.z - u.z) > 0.1) diff += 1;
            if (math.abs(v.w - u.w) > 0.1) diff += 1;
            if (diff == 1) {
                try tesseractEdges.append(i);
                try tesseractEdges.append(j_index);
            }
        }
    }

    // Właściwości kulki: pozycja w 4D i prędkość
    var ballPos = Vec4{ .x = 0.0, .y = 0.0, .z = 0.0, .w = 0.0 };
    var ballVel = Vec4{ .x = 0.5, .y = 0.3, .z = 0.4, .w = 0.2 };

    var lastTicks = sdl.SDL_GetTicks();

    // Główna pętla animacji
    var running = true;
    while (running) {
        var event: sdl.SDL_Event = undefined;
        while (sdl.SDL_PollEvent(&event) != 0) {
            if (event.type == sdl.SDL_QUIT)
                running = false;
        }

        const currentTicks = sdl.SDL_GetTicks();
        const deltaTime = (@intToFloat(f32, currentTicks - lastTicks)) / 1000.0;
        lastTicks = currentTicks;

        // Aktualizacja pozycji kulki
        ballPos.x += ballVel.x * deltaTime;
        ballPos.y += ballVel.y * deltaTime;
        ballPos.z += ballVel.z * deltaTime;
        ballPos.w += ballVel.w * deltaTime;

        // Odbicia kulki od ścian teseraktu (granice: -1 do 1)
        if (ballPos.x < -1.0 or ballPos.x > 1.0) ballVel.x = -ballVel.x;
        if (ballPos.y < -1.0 or ballPos.y > 1.0) ballVel.y = -ballVel.y;
        if (ballPos.z < -1.0 or ballPos.z > 1.0) ballVel.z = -ballVel.z;
        if (ballPos.w < -1.0 or ballPos.w > 1.0) ballVel.w = -ballVel.w;

        // Czyszczenie ekranu
        sdl.SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        sdl.SDL_RenderClear(renderer);

        // Rysowanie krawędzi teseraktu
        sdl.SDL_SetRenderDrawColor(renderer, 100, 100, 100, 255);
        // Obrót teseraktu – przykładowo w płaszczyźnie x-w
        const angle = (@intToFloat(f32, currentTicks)) / 1000.0;
        const cosA = math.cos(angle);
        const sinA = math.sin(angle);
        for (idx, _) in tesseractEdges.items {
            if (idx % 2 == 0) {
                const i0 = tesseractEdges.items[idx];
                const i1 = tesseractEdges.items[idx + 1];
                const v0 = vertices[i0];
                const v1 = vertices[i1];

                // Obrót w płaszczyźnie x-w
                const v0_rot = Vec4{
                    .x = v0.x * cosA - v0.w * sinA,
                    .y = v0.y,
                    .z = v0.z,
                    .w = v0.x * sinA + v0.w * cosA,
                };
                const v1_rot = Vec4{
                    .x = v1.x * cosA - v1.w * sinA,
                    .y = v1.y,
                    .z = v1.z,
                    .w = v1.x * sinA + v1.w * cosA,
                };

                const proj3d_0 = project4Dto3D(v0_rot, 2.0);
                const proj2d_0 = project3Dto2D(proj3d_0, 2.0);
                const proj3d_1 = project4Dto3D(v1_rot, 2.0);
                const proj2d_1 = project3Dto2D(proj3d_1, 2.0);

                // Mapowanie do współrzędnych ekranu
                const scale: f32 = 150.0;
                const x0 = (@intToFloat(f32, width) / 2) + proj2d_0.x * scale;
                const y0 = (@intToFloat(f32, height) / 2) - proj2d_0.y * scale;
                const x1 = (@intToFloat(f32, width) / 2) + proj2d_1.x * scale;
                const y1 = (@intToFloat(f32, height) / 2) - proj2d_1.y * scale;

                sdl.SDL_RenderDrawLine(renderer, @intCast(i32, x0), @intCast(i32, y0), @intCast(i32, x1), @intCast(i32, y1));
            }
        }

        // Rysowanie kulki
        // Dla spójności obracamy również kulkę (można pominąć obrót, wtedy ruch kulki będzie „samodzielny”)
        const ball_rot = Vec4{
            .x = ballPos.x * cosA - ballPos.w * sinA,
            .y = ballPos.y,
            .z = ballPos.z,
            .w = ballPos.x * sinA + ballPos.w * cosA,
        };
        const ball_proj3d = project4Dto3D(ball_rot, 2.0);
        const ball_proj2d = project3Dto2D(ball_proj3d, 2.0);
        const scale: f32 = 150.0;
        const ball_screen_x = (@intToFloat(f32, width) / 2) + ball_proj2d.x * scale;
        const ball_screen_y = (@intToFloat(f32, height) / 2) - ball_proj2d.y * scale;

        // Rysowanie wypełnionego koła – prosty algorytm rysowania okręgu (Midpoint Circle Algorithm)
        sdl.SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
        const radius: i32 = 10;
        const cx = @intCast(i32, ball_screen_x);
        const cy = @intCast(i32, ball_screen_y);
        var x: i32 = radius;
        var y: i32 = 0;
        var decisionOver2: i32 = 1 - x;
        while (y <= x) {
            sdl.SDL_RenderDrawLine(renderer, cx - x, cy + y, cx + x, cy + y);
            sdl.SDL_RenderDrawLine(renderer, cx - x, cy - y, cx + x, cy - y);
            sdl.SDL_RenderDrawLine(renderer, cx - y, cy + x, cx + y, cy + x);
            sdl.SDL_RenderDrawLine(renderer, cx - y, cy - x, cx + y, cy - x);

            y += 1;
            if (decisionOver2 <= 0) {
                decisionOver2 += 2 * y + 1;
            } else {
                x -= 1;
                decisionOver2 += 2 * (y - x) + 1;
            }
        }

        sdl.SDL_RenderPresent(renderer);
        sdl.SDL_Delay(16); // około 60 klatek na sekundę
    }
}

