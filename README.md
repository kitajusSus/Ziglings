# Ziglings
My notes on zigling and zig-book.:w
```zig
// Zig's enums can also have methods! This comment originally asked
// if anyone could find instances of enum methods in the wild. The
// first five pull requests were accepted and here they are:
//
// 1) drforester - I found one in the Zig source:
// https://github.com/ziglang/zig/blob/041212a41cfaf029dc3eb9740467b721c76f406c/src/Compilation.zig#L2495
//
// 2) bbuccianti - I found one!
// https://github.com/ziglang/zig/blob/6787f163eb6db2b8b89c2ea6cb51d63606487e12/lib/std/debug.zig#L477
//
// 3) GoldsteinE - Found many, here's one
// https://github.com/ziglang/zig/blob/ce14bc7176f9e441064ffdde2d85e35fd78977f2/lib/std/target.zig#L65
//
// 4) SpencerCDixon - Love this language so far :-)
// https://github.com/ziglang/zig/blob/a502c160cd51ce3de80b3be945245b7a91967a85/src/zir.zig#L530
//
// 5) tomkun - here's another enum method
// https://github.com/ziglang/zig/blob/4ca1f4ec2e3ae1a08295bc6ed03c235cb7700ab9/src/codegen/aarch64.zig#L24
```

# 043


```zig 
printCharacter(&glorp);
// wskaznik do tej struktury

```

# 044_quiz5.zig


# 050_no_value.zig
What is Undefined?  
There are 4 ways to tell ziggi that variable/const or something does not have any value. ("no value") 
1. Str8 forward
```zig
var skibi: u8 = undefined;
```
it value of the variable. Or should be seen like one, can be used as some placeholder. You are telling that you are not giving it value *_yet_*  its `var` means you can change it later. 

2. Close your eyes bro. What do you see? .... Nothing. 
```zig
var skibi: ?u8 = null;
```
Imagine that there is nothing. You are not giving it value. It is not defined. It is not undefined. It is null. It is a promise that this is a no_value value. 
Now skibidi is something like: 
> I'm u8 or I'm nothig, but to be nothing you need to be a thing.
Holds value which is saying, `no value`

3. ERROR
Imagine that something went wrong and you are not able to give it value. 
You got 2 options, 
a) you can ignore it and let your program crash 
b). -> [tests/test_050_error.zig](test_050_error.zig)
```zig
var toilet: u8!MyError = SomeError;
```
It was said that they are very similar to `null`, these two holds value  

4. *void*
This is a type not a value. (hold semantic value == dont take any  space), 
>  It's much more common to see void as
       the return type of a function that returns nothing.
```zig
var skibidi: void ={};
```

**BRIEFLY WE GOT:**
```zig
//   * undefined - there is no value YET, this cannot be read YET
//   * null      - there is an explicit value of "no value"
//   * errors    - there is no value because something went wrong
//   * void      - there will NEVER be a value stored here
```
Now I am doing the code: 

```zig
//obv i need to do  undefined bc we already have defined type and size (*const [16]u8);
//thats why i will use undefined (maybe later a change my mind? who knows)
var first_line1: *const [16]u8 = undefined;
//there is nothing to say i was explained before why i used rn a 
// Error,
var first_line2: Err!*const [21]u8 = Err.Cthulhu;
// null
var second_line2: ?*const [18]u8 = null;
```
I added a 1 commend close to first_line2,  to show how error looks like,


## 051_values.zig
??? computer's molten core??? wtf is this.

the ziggi it saying that: 
```zig
const std = @import("std");
```
Is a structure that holds a lot of different values. I think the whole program will tell us what are those crazy bits and bytes. 

**Struct is a very convenient way to deal with memory** <- thats a quote from the exercise. 
All the values of the struct are stored in memmory, if you add size of all the particular values  you will get the size of struct as a whole.

```zig
// if the instance of the struct is const, all the values inside are const
const Toilet = struct{
    toilet_paper: u32 = 3,
    toilet_paper_roll: u32 = 1,
};

const skibdi_new= Toilet{
    .toilet_paper = 31,
    .toilet_paper_roll = 10,
};
// but  you can create the instance of the struct that is not const
var free_skibidi = Toilet{};
    
```
> a function is a instruction code at a particular address. 
**FUNCTION PARAMETERS IN  Z  I  G ARE ALWAYS IMMUTABLE**

oh, struct can be written like it was a size/type ex.
```zig 
//its a number
var number: u32 =3;
var nmumber2: u32 = someother_number;
// but with struct?
var skib: *Toilet = &skibidi_new;
```
Remember Timmie that `*Toilet` is a pointer to the struct, and `&skibidi_new` is a reference to thevalue.
Values inside the function are initated as the const. 

```zig
fn function(arg: u32) void{
    arg =3; //error
}
```
but... 
We will now look at different ways of assigning existing variables to new ones. When do we pass thesame object in memory? When do we make a copy?
```zig
var glorp_access1: Character = glorp;
glorp_access1.gold = 111;
``````
Above creates a copy. You can see it by changing a value after assigning to new name. The two variables will have different values if you change the value for one of them.
```zig
var glorp_access2: *Character = &glorp;
glorp_access2.gold = 222;
```
---
Now we created a proper link to an object. This variable is nothing more than just the original glorp in disguise. If you now change the value of some field, it will be changed for the original glorp as well.
```zig
const glorp_access3: *Character = &glorp;
glorp_access3.gold = 222;
```
---
Now we get back to the pointer differences we've talked when doing pointer exercises. const pointer variable means that we can't change what the pointer variable is pointing at, but we can still change the values of the variable we point at.
```zig
const glorp_access4: *const Character = &glorp;
glorp_access4 = 111;
```
> part of this code above was copied from -> https://github.com/Laz4rz/ziglings

**Answer**
```zig
//in leverUp we needed to change arguments to a values. 
levelUp(&glorp, reward_xp); //original wal levelUp(glorp, reward_xp);
//later on I needed to see that the argument `character_access` is imported as a const, I needed a pointer to check sum. 
fn levelUp(const character_access: *Character, xp: u32) void{

};
```
# 052_slices.zig
Alright, Zigers, let's talk about arrays and how they can be moved around. Remember that function definition from quiz 3? 
Yeah, the one that only worked with arrays of exactly 4 u16s? 
That's the core issue with arrays – their size is baked right into their type. Once you declare an array like: 
```zig
var digits = [10]u8{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
```
, it's stuck being an array of 10 u8s forever. Not super flexible, right?

Enter slices. Think of slices as a way to peek into an existing array without being tied down by its full size. They're like dynamic windows into an array(you come inside, see what you want and  go home), letting you specify a starting point and a length.

Let's break down those examples:
```zig
const foo = digits[0..1];
```
This creates a slice that starts at the very first element (index 0) and includes elements up to, but not including, index 1. So, `foo` will contain just 0.
```zig
const bar = digits[3..9]; 
```
This slice starts at index 3 and goes up to (but not including) index 9. So, bar will hold `3, 4, 5, 6, 7, 8`
```zig
const skibidi = digits[5..9];
```
Similar to `bar`, this starts at index 5 and goes up to index 8. `skibidi` will contain 5, 6, 7, 8.
```zig
const all = digits[0..]; 
```
This is a cool shortcut. By leaving off the end index, you're telling Zig, "Give me everything from the starting index to the end of the array." So, all will contain all the `digits: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9`.

The really neat thing is the type of these slices. If you have an array of u8's, a slice of that array will have the type `[]u8`. 
>Noticed the empty brackets? Of course you did smart fella. I love you Timmie

That signifies that the length of the slice isn't fixed at compile time. It can vary depending on where you're slicing from and how much you're slicing.

So, slices are a game-changer when you want to work with portions of arrays without being constrained by their full, static size.
They make passing data around and writing flexible functions much, much easier.
You'll be seeing slices a lot in Zig, so getting comfortable with them is key!

**Answer** nothing special, just remember that `cards[0..4]` will give you A4K8 because they are indexed inside like `0,1,2,3,4` and `cards[0..4]` stop just before element with index 4. (de facto 5th element)
```bash
zig run exercises/052_slices.zig                                                                         
Hand1: A 4 K 8 
Hand2: 5 2 Q J 
```
your output should be like this.

## 053_slices2.zig
Welcome, todays Subject is: **Slicing... again**, Are you interested in slicing of a string? 
You get to the proper place lad. 
1. String is just an array of characters. (string)
2. Timmie, you need to remember that in *Zig*, strings literals, are immutable (you cant change them). {const}
3. Thats why if you want to take slice of a string, you need to use `[]const u8` type,  because output needs to be the same type as input.

If you forgot about this you will get, 
```bash
exercises/053_slices2.zig:22:34: error: expected type '[]u8', found '*const [16:0]u8'
    const base3: []u8 = scrambled[32..];
                        ~~~~~~~~~^~~~~~
```
I added simple Error, when word in justice1 == "for"

```zig
fn printPhrase(part1: []const u8, part2: []const u8, part3: []const u8) !void {
    const stdout = std.io.getStdOut().writer();

    if (std.mem.eql(u8, part1, "for")) {
        return error.Word_For;
    } else return try stdout.print("'{s} {s} {s}.' ", .{ part1, part2, part3 });
}

const MyError = error{Word_For};
```
```bash
/Ziglings/exercises/053_slices2.zig:37:9: 0x10de1f8 in printPhrase (053_slices2)
        return error.Word_For;

/Ziglings/exercises/053_slices2.zig:28:5: 0x10de54f in main (053_slices2)
    try printPhrase(justice1, justice2, justice3);
```

## 054_manypointers.zig
*Pointers* are a way to reference a value in memory. I can do them to multiple items without using slicing. 
> good to hear fr fr 
```zig
//examples from code
var foo: [4]u8 = [4]u8{ 1, 2, 3, 4 };
var foo_slice: []u8 = foo[0..]; //slice has a known length, 
var foo_ptr: [*]u8 = &foo; // pointer doesn't, 
//Its your duty to keep track 
//of the number of u8 foo_ptr points to
var foo_slice_from_ptr: []u8 = foo_ptr[0..4];
```
### Important Concepts from this: 
#### **1. Arrays `[N]arr`** :
*   **Definition:** An array in Zig has a **fixed size known at compile time**. The type `[N]T` represents an array of `N` elements of type `T`.
*   **Example:** `var foo: [4]u8 = [4]u8{ 1, 2, 3, 4 };` defines an array named `foo` that holds exactly 4 `u8` values.
*   **Nature:** Arrays often behave like value types. When assigned or passed by value, the entire content might be copied (depending on context and size). The size `N` is part of the array's type.
```zig
    const std = @import("std");

    pub fn main() void {
        // Define an array of 3 integers
        var numbers: [3]i32 = .{ 10, 20, 30 };

        // Access an element
        std.debug.print("Second number: {d}\n", .{numbers[1]}); // Output: Second number: 20

        // The size is fixed and known at compile time
        std.debug.print("Array size: {d}\n", .{numbers.len}); // Output: Array size: 3

        // Attempting to resize or assign different size array will cause compile error
        // numbers = .{ 1, 2, 3, 4 }; // COMPILE ERROR: expected type '[3]i32', found '.{ 1, 2, 3, 4 }'
    }
```
#### **2. Slices `[]arr`** : (as you can see there is no N)
-  **Definition:** A slice is a **view** or a *section* into an array(memory). It doesn't have a fixed size known at compile time. The type `[]T` represents a slice of elements of type `T`. But is stored with the slice and is know at **RUNTIME** 
-    **Example:** `var foo_slice: []u8 = foo[0..];` creates a slice `foo_slice` that points to the beginning of the `foo` array and knows its length is 4. Slices can represent a part of an array too: `foo[1..3]` would be a slice of length 2 containing `{ 2, 3 }`.
-   **Key Feature:** Slices **always know their length**. This makes them safer to work with for iteration and bounds checking. They are often used for function arguments that accept sequences of unknown length at compile time.

**Example** : 
```zig
    const std = @import("std");

    pub fn main() void {
        var data: [5]u8 = .{ 'Z', 'i', 'g', '!', '!' };

        // Create a slice covering the whole array
        var full_slice: []u8 = data[0..];
        std.debug.print("Full slice length: {d}\n", .{full_slice.len}); // Output: Full slice length: 5

        // Create a slice covering part of the array
        var partial_slice: []u8 = data[1..3]; // Includes elements at index 1 and 2 ('i', 'g')
        std.debug.print("Partial slice length: {d}\n", .{partial_slice.len}); // Output: Partial slice length: 2
        std.debug.print("Partial slice content: {s}\n", .{partial_slice}); // Output: Partial slice content: ig

        // Modify data through the slice (slices point to the original data)
        partial_slice[0] = 'I';
        std.debug.print("Original data modified: {s}\n", .{data[0..]}); // Output: Original data modified: ZIg!!
    }
```






```bash
//     FREE ZIG POINTER CHEATSHEET! (Using u8 as the example type.)
//   +---------------+----------------------------------------------+
//   |  u8           |  one u8                                      |
//   |  *u8          |  pointer to one u8                           |
//   |  [2]u8        |  two u8s                                     |
//   |  [*]u8        |  pointer to unknown number of u8s            |
//   |  [*]const u8  |  pointer to unknown number of immutable u8s  |
//   |  *[2]u8       |  pointer to an array of 2 u8s                |
//   |  *const [2]u8 |  pointer to an immutable array of 2 u8s      |
//   |  []u8         |  slice of u8s                                |
//   |  []const u8   |  slice of immutable u8s                      |
//   +---------------+----------------------------------------------+
```


