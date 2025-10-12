// build with `zig build-exe c_tesst.zig -lc -lraylib`
const ray = @cImport({
    @cInclude("raylib.h");
});

pub fn main() void {
    const screenWidth = 800;
    const screenHeight = 450;

    ray.InitWindow(screenWidth, screenHeight, "raylib [core] example - basic window");
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);

    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.RAYWHITE);
        ray.DrawText("KOCHAM CIE  !", 190, 200, 20, ray.PINK);
        ray.DrawText("MAMO!!!", 150, 160, 30, ray.RED);
    }
}
