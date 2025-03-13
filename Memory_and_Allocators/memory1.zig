/// Its taken from https://pedropark99.github.io/zig-book/Chapters/01-memory.html
/// MOST OF THESE COMMENTS ARE JUST COPPIES MATERIALS FROM THIS BOOK but some of them are my own comments.

// Let’s look at an example. In the source code below, we have two constant objects (name and array) declared.
// Because the values of these particular objects are written down, in the source code itself
// ("Pedro" and the number sequence from 1 to 4),
// the zig compiler can easily discover the values of these constant objects (name and array) during the compilation process.
// This is what “known at compile time” means. It refers to any object that you have in your Zig source code whose value can be identified at compile time.

const std = @import("std");

fn input_length(input: []const u8) usize {
    const n = input.len;
    return n;
}

pub fn main() !void {
    const name = "Pedro";
    const array = [_]u8{ 1, 2, 3, 4 };
    //_ = name;
    _ = array;
    std.debug.print("name: {s}\n", .{name});
}
