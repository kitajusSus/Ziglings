//
// PODSTAWY PROGRAMOWANIA W CZASIE KOMPILACJI (COMPTIME)
//
// Ten program demonstruje podstawowe użycie comptime w Zig.

const std = @import("std");

/// 1. Funkcje generyczne używające comptime
/// Ta funkcja może działać z dowolnym typem numerycznym
fn min(comptime T: type, a: T, b: T) T {
    return if (a < b) a else b;
}

// Funkcja generyczna do sumowania elementów tablicy
fn sum(comptime T: type, items: []const T) T {
    var result: T = 0;
    for (items) |item| {
        result += item;
    }
    return result;
}

// 2. Stałe comptime - obliczane podczas kompilacji
const ARRAY_SIZE = blk: {
    var result: usize = 10;
    result *= 2;
    break :blk result;
};

// 3. Funkcja używająca comptime do sprawdzania typów
fn printInfo(value: anytype) void {
    const T = @TypeOf(value);

    // @typeName zwraca nazwę typu jako string
    std.debug.print("Typ: {s}\n", .{@typeName(T)});

    // @typeInfo zwraca informacje o typie jako union
    switch (@typeInfo(T)) {
        .Int => std.debug.print("To jest liczba całkowita\n", .{}),
        .Float => std.debug.print("To jest liczba zmiennoprzecinkowa\n", .{}),
        .Bool => std.debug.print("To jest wartość logiczna\n", .{}),
        .Pointer => std.debug.print("To jest wskaźnik\n", .{}),
        .Struct => std.debug.print("To jest struktura\n", .{}),
        else => std.debug.print("Inny typ\n", .{}),
    }
}

pub fn main() !void {
    // Demonstracja funkcji generycznych
    std.debug.print("Min z 42 i 24: {}\n", .{min(i32, 42, 24)});
    std.debug.print("Min z 3.14 i 2.71: {d:.2}\n", .{min(f32, 3.14, 2.71)});

    // Demonstracja tablicy o rozmiarze określonym w comptime
    var numbers: [ARRAY_SIZE]i32 = undefined;
    for (&numbers, 0..) |*n, i| {
        n.* = @as(i32, @intCast(i));
    }
    std.debug.print("Suma tablicy: {}\n", .{sum(i32, &numbers)});
    std.debug.print("Rozmiar tablicy (obliczony w comptime): {}\n", .{ARRAY_SIZE});

    // Demonstracja informacji o typach
    printInfo(@as(i32, 42));
    printInfo(@as(f64, 3.14));
    printInfo(true);
    printInfo("string");
}
