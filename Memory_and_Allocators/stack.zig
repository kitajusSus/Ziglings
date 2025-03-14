//The stack is a type of memory that uses the power of the stack data structure, hence the name.
//A “stack” is a type of data structure that uses a “last in, first out”
//(LIFO) mechanism to store the values you give it to. I imagine you are familiar with this data structure.
//But, if you are not, the Wikipedia page1 , or, the Geeks For Geeks page2 are both
//excellent and easy resources to fully understand how this data structure works.:e
//
//

const std = @import("std");

fn add(x: u8, y: u8) u8 {
    const result = x + y;
    return result;
}
/// The stack is a type of memory that uses the power of the stack data structure, hence the name.
/// Looking at the example below, the object result is a local object declared inside the scope of the add() function.
/// Because of that, this object is stored inside the stack space reserved for the add() function.
/// The r object (which is declared outside of the add() function scope) is also stored in the stack.
/// But since it’s declared in the “outer” scope, this object is stored in the stack space that belongs to this outer scope.
pub fn main() !void {
    const r = add(5, 27);
    //_ = r;
    std.debug.print("result: {d}\n", .{r});
}
