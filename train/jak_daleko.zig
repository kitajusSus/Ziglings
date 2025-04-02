const std = @import("std");
// program do liczenia jak daleko coś poleci,

const Projectile = struct {
    x: f32,
    y: f32,
    velocity_x: f32,
    velocity_y: f32,

    pub fn start(v_0: f32, angle: f32) Projectile {
        const angle_radians = angle * std.math.pi / 180.0;
        return Projectile{
            .x = 0.0,
            .y = 0.0,
            .velocity_x = v_0 * @cos(angle_radians),
            .velocity_y = v_0 * @sin(angle_radians),
        };
    }

    pub fn update(self: *Projectile, dt: f32) void {
        self.*.x += self.*.velocity_x * dt;
        self.*.y += self.*.velocity_y * dt;
        self.*.velocity_y -= 9.81 * dt;
    }
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var proj = Projectile.start(100.0, 1.0); // prędkość początkowa 20 m/s, kąt 45 stopni
    const dt: f32 = 0.1;

    while (proj.y >= 0.0) {
        try stdout.print("x={d:.2}m y={d:.2}m\n", .{ proj.x, proj.y });
        proj.update(dt);
    }
}
