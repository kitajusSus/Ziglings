//
// ARENA ALLOCATOR W ZIG
//
// Arena to alokator, który może zwolnić całą pamięć jednocześnie.
// Bardzo przydatny gdy mamy wiele alokacji, które chcemy zwolnić w tym samym czasie.

const std = @import("std");

const Point = struct {
    x: i32,
    y: i32,
};
/// W Zig, `point.*` jest używane do dereferencji wskaźnika
/// i uzyskania dostępu do wartości,
/// na którą wskazuje. Jest to podobne do użycia
/// operatora `*` w językach takich jak C lub C++.
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    //===== Arena Allocator =====
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit(); // Zwalnia WSZYSTKIE alokacje za jednym razem

    const arena_allocator = arena.allocator();

    // Alokacje z areny nie muszą być zwalniane indywidualnie
    const arr1 = try arena_allocator.alloc(u8, 100);
    const arr2 = try arena_allocator.alloc(u8, 200);
    const point = try arena_allocator.create(Point);

    point.* = Point{ .x = 5, .y = 10 };

    std.debug.print("Długość pierwszej tablicy: {}\n", .{arr1.len});
    std.debug.print("Długość drugiej tablicy: {}\n", .{arr2.len});
    std.debug.print("Punkt: ({}, {})\n", .{ point.x, point.y });

    // Nie potrzebujemy pojedynczych defer dla każdej alokacji
    // arena.deinit() na końcu funkcji zwolni wszystko
}
