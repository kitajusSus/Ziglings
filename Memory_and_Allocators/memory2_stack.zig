// stack is a data structure = LIFO...
//  which means last in first out
//
// One very important detail about the stack memory is that it frees itself automatically.
// This is very important, remember that.
// When objects are stored in the stack memory,
// you don’t have the work (or the responsibility) of freeing/destroying these objects.
// Because they will be automatically destroyed once the stack space is freed at the end of the function scope.
//
fn add(x: u8, y: u8) u8 {
    const result = x + y;
    return result;
}

//So, any object that you declare inside the scope of a function is
//always stored inside the space that was reserved for
//that particular function in the stack memory.
//This also counts for any object declared inside the scope of your main() function for example.
//As you would expect, in this case,
//they are stored inside the stack space reserved for the main() function.

pub fn main() !void {
    const r = add(5, 27);
    // const print = @import("std").debug.print;
    // print("r {any}", .{r});
    _ = r;
}

//stack memory free's itself after a return,
// it gives you a value and it deletes itself
// thats why we need to create variables to hold that values in memory
//
//  IMPORTANT
// Local objects that are stored in the stack space of a function
// are automatically freed/destroyed at the end of the function scope.

//
