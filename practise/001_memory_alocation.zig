//
// PODSTAWOWE ZARZĄDZANIE PAMIĘCIĄ W ZIG
//
// Ten program pokazuje podstawowe sposoby alokacji pamięci.

const std = @import("std");

pub fn main() !void {
    // Standardowy alokator ogólnego przeznaczenia
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        // Sprawdzamy, czy nie ma wycieków pamięci
        const deinit_status = gpa.deinit();
        std.debug.print("GPA deinit: leaks detected: {}\n", .{deinit_status == .leak});
    }
    const allocator = gpa.allocator();

    // ===== Alokacja pojedynczego obiektu =====
    // create() - przydzielenie pamięci dla pojedynczego obiektu
    const point = try allocator.create(Point);
    defer allocator.destroy(point); // zwalnianie pamięci

    point.* = Point{ .x = 10, .y = 20 };
    std.debug.print("Punkt: x={}, y={}\n", .{ point.x, point.y });

    // ===== Alokacja tablicy =====
    // alloc() - alokuje tablicę elementów
    var numbers = try allocator.alloc(i32, 5);
    defer allocator.free(numbers); // zwalnianie tablicy

    // Poprawiona pętla z poprawnym użyciem @intCast
    for (0..numbers.len) |i| {
        // Poprawne użycie @intCast z dwoma argumentami: typem docelowym i wartością
        numbers[i] = @as(i32, @intCast(i)) * 10;
    }

    std.debug.print("Tablica: {any}\n", .{numbers});
}

// Prosta struktura do demonstracji
const Point = struct {
    x: i32,
    y: i32,
};
