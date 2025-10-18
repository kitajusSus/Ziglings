// This does not compile successfully!
const a = [_]u8{0, 1, 2, 3, 4};
for (0..a.len) |i| {
    const index = i;
    _ = index;
}
// Trying to use an object that was
// declared in the for loop scope,
// and that does not exist anymore.
std.debug.print("{d}\n", .{index});
// One important consequence of this mechanism is that, once the function returns,
// you can no longer access any memory address that was inside the space in the
// stack reserved for this particular function. Because this space was destroyed.
// This means that, if this local object is stored in the stack,
// you cannot make a function that returns a pointer to this object.
