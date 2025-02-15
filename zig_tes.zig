const std = @import("std");
const net = std.net;
const http = std.http;

pub fn main() !void {
    // Parsujemy adres IP i port
    const addr = net.Address.parseIp4("127.0.0.1", 9090) catch |err| {
        std.debug.print("Błąd przy rozwiązywaniu adresu IP: {}\n", .{err});
        return;
    };

    // Nasłuchujemy na zadanym adresie
    var server = try addr.listen(.{});
    std.debug.print("Serwer nasłuchuje na {s}:{d}\n", .{ "127.0.0.1", 9090 });

    startServer(&server);
}

fn startServer(server: *net.Server) void {
    // Bufor do odczytu nagłówka HTTP
    var read_buffer: [1024]u8 = undefined;

    while (true) {
        // Akceptujemy połączenie od klienta
        var connection = server.accept() catch |err| {
            std.debug.print("Błąd połączenia: {}\n", .{err});
            continue;
        };
        defer connection.stream.close();

        // Inicjujemy instancję serwera HTTP na danym połączeniu
        var http_server = http.Server.init(connection, &read_buffer);

        // Odczytujemy nagłówek żądania HTTP
        var request = http_server.receiveHead() catch |err| {
            std.debug.print("Nie udało się odczytać nagłówka: {}\n", .{err});
            continue;
        };

        // Obsługujemy żądanie – tutaj odpowiadamy prostym komunikatem
        handleRequest(&request) catch |err| {
            std.debug.print("Błąd podczas obsługi żądania: {}\n", .{err});
            continue;
        };
    }
}

fn handleRequest(request: *http.Server.Request) !void {
    std.debug.print("Otrzymano zaldanie dla: {s}\n", .{request.head.target});
    try request.respond("Hello http!\n", .{});
}
