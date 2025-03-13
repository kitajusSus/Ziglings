const std = @import("std");
//siema siema, program do liczenia silni rekurencyjnie, coś takiego co robiłem w cpp na AiSD
//
//
//
//
//

// Helper do czytania liczby
fn input() !u64 {
    var buf: []u8 = undefined;
    std.debug.print("Podaj liczbę: ", .{});

    const user = try std.io.getStdIn().reader().readUntilDelimiter(&buf, '\n');
    return std.fmt.parseInt(u64, user, 10);
}

pub fn main() !void {
    const n = try input();

    if (n > 20) {
        std.debug.print("Uwaga: Za duża liczba!\n", .{});
        return;
    }

    const wynik = silnia(n);
    std.debug.print("Silnia z {} wynosi {}\n", .{ n, wynik });
}

fn silnia(n: u64) u64 {
    if (n <= 1) return 1;
    return n * silnia(n - 1);
}
