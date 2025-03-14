const std = @import("std");

const MyError = error{
    BadError,
};

pub fn main() void {
    const toilet: MyError!u8 = MyError.BadError;

    const stdout = std.io.getStdOut().writer();
    if (toilet) |err| {
        stdout.print("Error: {}\n", .{err}) catch {};
    } else |value| {
        stdout.print("No error value {}\n", .{value}) catch {};
    }
    //main2();
}
// Sure, let's explain why you need to use `else |value|` instead
// of just `else { ... }` in Zig.

//In Zig, when you are working with an error union type, you need
// to explicitly unpack the value if it is not an error.
// This is because Zig enforces explicit handling of both the error
// and the success cases to ensure type safety and clarity in the code.
//
//
// but if you dont use this function nothing bad will happen
fn main2() void {
    const skibidi: u8!MyError = MyError.BadError;

    const stdout = std.io.getStdOut().writer();
    if (skibidi) |err| {
        stdout.print("Error: {}\n", .{err}) catch {};
    } else {
        stdout.print("No error\n", .{}) catch {};
    }
}
