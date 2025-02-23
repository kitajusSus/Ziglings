//
// Let's see if we can make use of some of the things we've learned so far.
// We'll create two functions: one that contains a "for" loop and one
// that contains a "while" loop.
//
// Both of these are simply labeled "loop" below.
//
const std = @import("std");

pub fn main() void {
    const my_numbers = [4]u16{ 5, 6, 7, 8 };

    printPowersOfTwo(my_numbers);
    std.debug.print("\n", .{});
}

// You won't see this every day: a function that takes an array with
// exactly four u16 numbers. This is not how you would normally pass
// an array to a function. We'll learn about slices and pointers in
// a little while. For now, we're using what we know.
//
// This function prints, but does not return anything.
// komentarz VOID - funkcja nie zwraca wartości WIEC MUSI BYC VOID A NIE JAKIES DANE
// BO JAK PISZESZ U16 CZY COS TO SUGERUJE ZE FUNKCJA POWINNA ZWROCIC  WARTOSC I TAKIM PARAMETRZE
fn printPowersOfTwo(numbers: [4]u16) void {
    for (numbers) |n| {
        std.debug.print("{} ", .{twoToThe(n)});
    }
}

// This function bears a striking resemblance to twoToThe() in the last
// exercise. But don't be fooled! This one does the math without the aid
// of the standard library!
//
fn twoToThe(number: u16) u16 { // jesli  funcja ma ci dac jakas informacje to zapisz jaka to bedzie informacja
    // tutaj mamy (numer: u16)<--- informacja która "wchodzi w funkcję" a obok jest u16 czyli informacja która ucieka z funkcji jako output return total
    var n: u16 = 0;
    var total: u16 = 1;

    while (n < number) : (n += 1) {
        total *= 2;
    }

    return total;
}
