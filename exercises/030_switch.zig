//
// The "switch" statement lets you match the possible values of an
// expression and perform a different action for each.
//
// This switch:
//
//     switch (players) {
//         1 => startOnePlayerGame(),
//         2 => startTwoPlayerGame(),
//         else => {
//             alert();
//             return GameError.TooManyPlayers;
//         }
//     }
//
// Is equivalent to this if/else:
//
//     if (players == 1) startOnePlayerGame();
//     else if (players == 2) startTwoPlayerGame();
//     else {
//         alert();
//         return GameError.TooManyPlayers;
//     }
//
const std = @import("std");

pub fn main() void {
    const lang_chars = [_]u8{ 26, 9, 7, 42 };
    for (lang_chars) |c| {
        switch (c) {
            1 => std.debug.print("A", .{}),
            2 => std.debug.print("B", .{}),
            3 => std.debug.print("C", .{}),
            4 => std.debug.print("D", .{}),
            5 => std.debug.print("E", .{}),
            6 => std.debug.print("F", .{}),
            7 => std.debug.print("G", .{}),
            8 => std.debug.print("H", .{}),
            9 => std.debug.print("I", .{}),
            10 => std.debug.print("J", .{}),
            // ... we don't need everything in between ...
            25 => std.debug.print("Y", .{}),
            26 => num(2),

            // Switch statements must be "exhaustive" (there must be a
            // match for every possible value).  Please add an "else"
            // to this switch to print a question mark "?" when c is
            // not one of the existing matches.
            else => std.debug.print("?", .{}),
        }
    }

    std.debug.print("\n", .{});
}
// samodzielnie zrobione funkcje nie było ich w oryginalnym kodzie chciałem cos sprawdzic
fn x(y: anytype) void {
    return std.debug.print("{s}", .{y}); // {s} sprawia ze y jest traktowane jako string i wyswietlany jest jako string. mozna  zamiast tego dodac {any} ale to sprawia ze `y` jest traktowany w uniwersalny sposób czyli jako cyferki  "z" = 122 czy cos takiego
}

fn num(z: anytype) void {
    return std.debug.print("{any}", .{z}); //
}
