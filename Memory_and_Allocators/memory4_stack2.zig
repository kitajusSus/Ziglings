fn add(x: u8, y: u8) *const u8 {
    const result = x + y;
    return &result;
}

pub fn main() !void {
    // This code compiles successfully. But it has
    // undefined behaviour. Never do this!!!
    // The `r` object is undefined!
    const r = add(5, 27);
    //this
    //_ = r;
    // or that
    const print = @import("std").debug.print;
    print("{}", .{r});
}

// If a local object in your function is stored in the stack,
// you should never return a pointer to this local object from the function.
// Because this pointer will always become undefined after the function returns,
// since the stack space of the function is destroyed at the end of its scope.
