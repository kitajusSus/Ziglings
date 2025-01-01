//
// A common case for errors is a situation where we're expecting to
// have a value OR something has gone wrong. Take this example:
//
//     var text: Text = getText("foo.txt");
//
// What happens if getText() can't find "foo.txt"?  How do we express
// this in Zig?
//
// Zig lets us make what's called an "error union" which is a value
// which could either be a regular value OR an error from a set:
//
//     var text: MyErrorSet!Text = getText("foo.txt");
//
// For now, let's just see if we can try making an error union!
//
const std = @import("std");

const MyNumberError = error{TooSmall};

pub fn main() {
    var my_number: MyNumberError!u16 = 5;
    // wykrzyknik sprawia ze my_number moze byc albo u16 albo MyNumberError  czyli albo bedzie cyferka albo bedzie bledem

    // Looks like my_number will need to either store a number OR
    // an error. Can you set the type correctly above?
    my_number = MyNumberError.TooSmall;

    std.debug.print("I compiled!\n", .{});
}

// BONUSOWY KOD POKAZYJĄCY JAK TO DZIAŁA PO MOJEMU NA PRZYKŁADZIE
//

