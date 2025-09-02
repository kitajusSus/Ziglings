const std = @import("std");

pub fn main() !void {
    // Uzyskaj uchwyty do standardowych strumieni
    var stdout_file = std.io.getStdOut();
    var stdin_file = std.io.getStdIn();

    // Opakuj strumienie w bufory, aby zmniejszyć liczbę wywołań systemowych
    var bw = std.io.bufferedWriter(stdout_file.writer());
    var br = std.io.bufferedReader(stdin_file.reader());
    const stdout = bw.writer();
    const stdin = br.reader();

    try stdout.print("Podaj swoją ulubioną liczbę: ", .{});
    // Buforowany writer wymaga ręcznego opróżnienia
    try bw.flush();

    var buf: [100]u8 = undefined;
    // Czytanie aż do znaku nowej linii lub końca pliku
    const line = (try stdin.readUntilDelimiterOrEof(&buf, '\n')) orelse {
        try stdout.print("Brak danych wejściowych.\n", .{});
        return;
    };

    // Parsowanie liczby z otrzymanego ciągu znaków
    const number = try std.fmt.parseInt(i64, line, 10);
    try stdout.print("Liczba powiększona o 1 to {d}\n", .{number + 1});
    try bw.flush();
}
