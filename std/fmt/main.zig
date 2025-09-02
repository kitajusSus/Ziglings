const std = @import("std");

pub fn main() !void {
    var buffer: [64]u8 = undefined;
    const text = try std.fmt.bufPrint(&buffer, "Witaj {s}, liczba {d}\n", .{"Zig", 42});
    std.debug.print("{s}", .{text});
}
