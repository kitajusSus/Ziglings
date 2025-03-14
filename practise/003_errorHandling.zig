//
// PODSTAWOWA OBSŁUGA BŁĘDÓW W ZIG
//
// Ten program pokazuje podstawowe techniki obsługi błędów w Zig.

const std = @import("std");

// Własny typ błędu - wymienia wszystkie możliwe błędy
const MathError = error{
    DivisionByZero,
    Overflow,
    Underflow,
};

// Funkcja zwracająca wartość lub błąd
fn divide(a: i32, b: i32) !i32 {
    if (b == 0) return MathError.DivisionByZero;
    return a / b;
}

// Zwracanie wyniku z funkcji lub błędu
fn safeAdd(a: i32, b: i32) !i32 {
    // @addWithOverflow zwraca krotkę {wynik, czy_było_przepełnienie}
    const result = @addWithOverflow(a, b);
    if (result[1] != 0) return MathError.Overflow;
    return result[0];
}

pub fn main() !void {
    // 1. Używanie catch do obsługi błędów
    const result1 = divide(10, 2) catch |err| {
        std.debug.print("Wystąpił błąd: {}\n", .{err});
        return;
    };
    std.debug.print("Wynik 1: {}\n", .{result1});

    // 2. Obsługa konkretnych błędów
    const result2 = divide(5, 0) catch |err| switch (err) {
        MathError.DivisionByZero => {
            std.debug.print("Nie można dzielić przez zero!\n", .{});
            return;
        },
        else => unreachable,
    };
    std.debug.print("Wynik 2: {}\n", .{result2});

    // 3. Catch z wartością domyślną
    const result3 = divide(8, 0) catch 0;
    std.debug.print("Wynik 3 (z domyślną wartością): {}\n", .{result3});

    // 4. Try - propaguje błąd do funkcji wywołującej
    const result4 = try divide(20, 4);
    std.debug.print("Wynik 4: {}\n", .{result4});

    // 5. Złożone warunki błędów
    const a: i32 = 2_000_000_000;
    const b: i32 = 1_000_000_000;
    const result5 = safeAdd(a, b) catch |err| {
        std.debug.print("Błąd podczas dodawania {d} + {d}: {}\n", .{ a, b, err });
        return;
    };
    std.debug.print("Suma: {d}\n", .{result5});
}
