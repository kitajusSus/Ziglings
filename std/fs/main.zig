const std = @import("std");

pub fn main() !void {
    var cwd = std.fs.cwd();
    const tmp_name = "fs_example.txt";

    {
        var file = try cwd.createFile(tmp_name, .{ .read = true, .truncate = true });
        defer file.close();
        try file.writeAll("example of  std.fs module\n");
    }

    // Read the file back into memory.
    const contents = try std.fs.readFileAlloc(std.heap.page_allocator, tmp_name);
    defer std.heap.page_allocator.free(contents);
    defer cwd.deleteFile(tmp_name) catch {};

    std.debug.print("Plik zawiera: {s}", .{contents});
}
