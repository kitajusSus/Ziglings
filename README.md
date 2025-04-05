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
#### 3. Many-Item Pointers (`[*]T`)

*   **Definition:** A many-item pointer (`[*]T`) is a **pointer to one or more items** of type `T`, but **it does not store the length**. It's essentially just a memory address pointing to the start of a sequence.
*   **Analogy:** This is similar to how pointers often work in C/C++, where you have a pointer to the first element but need a separate mechanism (like a null terminator or an explicit length variable) to know where the sequence ends.
*   **Example:** `var foo_ptr: [*]u8 = &foo;` creates a many-item pointer `foo_ptr` that points to the start of the `foo` array's data. **Crucially, the type `[*]u8` itself does not retain the information that there are 4 elements.**
*   **Responsibility:** When using a `[*]T`, **you (the programmer) are responsible for keeping track of the number of valid items** this pointer points to. Accessing beyond the actual bounds leads to undefined behavior. These are often used for C interoperability or low-level memory manipulation where length tracking is handled separately.


```zig
    const std = @import("std");

    pub fn main() void {
        var values: [4]f32 = .{ 1.1, 2.2, 3.3, 4.4 };
        const len: usize = values.len; // We MUST store the length separately

        // Get a many-item pointer to the start of the array
        var values_ptr: [*]f32 = &values;

        // We CANNOT get the length from the pointer itself
        // std.debug.print("Pointer length: {d}\n", .{values_ptr.len}); // COMPILE ERROR: '[*]f32' has no member named 'len'

        // Accessing elements requires knowing the valid range (using our stored 'len')
        std.debug.print("First value via ptr: {d}\n", .{values_ptr[0]}); // Output: First value via ptr: 1.1
        std.debug.print("Third value via ptr: {d}\n", .{values_ptr[2]}); // Output: Third value via ptr: 3.3

        // To use it like a slice, we need to combine the pointer and the length
        var values_slice: []f32 = values_ptr[0..len];
        std.debug.print("Slice created from ptr length: {d}\n", .{values_slice.len}); // Output: Slice created from ptr length: 4
    }
```
#### 4. Pointers to Arrays (`*[N]T`)

*   **Definition:** This is a pointer to a *specific, fixed-size array type*. The type `*[N]T` is a pointer to *one* instance of `[N]T`.
*   **Example:** `var foo_ptr_to_array: *[4]u8 = &foo;`
*   **Difference from `[*]T`:** This pointer type *knows* it points to an array of exactly `N` items because `N` is part of the type itself (`*[N]T`). You can get the size by dereferencing the pointer and accessing the `.len` of the underlying array type. `[*]T` loses this compile-time size information.

*   **Code Snippet:**
```zig
    const std = @import("std");

    pub fn main() void {
        var matrix_data: [2][2]i32 = .{ .{1, 2}, .{3, 4} };

        // Pointer to the specific array type [2][2]i32
        var matrix_ptr: *[2][2]i32 = &matrix_data;

        // Access elements by first dereferencing the pointer (*)
        std.debug.print("Element [0][1]: {d}\n", .{matrix_ptr.*[0][1]}); // Output: Element [0][1]: 2

        // We can get the length (number of rows in this case) from the dereferenced array
        std.debug.print("Matrix rows: {d}\n", .{matrix_ptr.*.len}); // Output: Matrix rows: 2

        // Modify data through the pointer
        matrix_ptr.*[1][1] = 42;
        std.debug.print("Modified element [1][1]: {d}\n", .{matrix_data[1][1]}); // Output: Modified element [1][1]: 42
    }
```
**Free cheatsheet!!!!**
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

It wasnt that difficult, was it? 

## 055_unions.zig
The Big Zig told me few things about unions. Sounds cool. But What is this??

```zig
// imagine a struct like this which can hold either a u8 or a u16 or something else. 
const MyUnion = union {
    x: u8,
    y: u16,
    z: f32,
    a: bool,
    //etc. 
}
```
> Unions are a way to store different types of data in the same memory location.
Realy good for ecolodgy of memory. You can reuse the same memory shelf. 
```zig
 var some_union: MyUnion{ .x = 42 };
some_union.y = 1234; // gives error
some_union = MyUnion{ .y = 1234 }; // works

some_union.a = True; // gives error
// How to make it work??
```
Its important to remember that you can only access the field that was last written to. 

## 056_unions2.zig
[exercise link](exercises/056_unions2.zig)
First look at the code. 
```zig
const BigEnumStruct = enum{small, medium, large};

const MyUnion = union {
    x: u8,
    y: u16,
    z: f32,
};

var skibidi = MyUnion{ .x = 42 };
```
By using swtich state  I can change/act on my taged union  `skibidi`. For example like this, 

```zig 
switch (skibidi) {
    .x => |argument| do_something_function(argument),
    .y => |argument_2| function2(argument_2),
    .z => |argument_3| function3(argument_3) ,
}
```

> Optional Values are basically `null unions`, and  Erros are using "error union types". 

And it's possible to create own unions depends on the needs: 
```zig
const MyUnion = union {
    x: u8,
    y: u16,
    z: f32,
    a: bool,
    b: BigEnumStruct,
    function: void,
};
```

## 057_unions3.zig
[exercise link](exercises/057_unions3.zig)
Tagged unions are fun (probably).
damn, instead of creating enums I can just use `enum` and `union` together. toUse this as strucs or something to store data

I can create a union like this:
```zig
const Insect = union(enum) {
    flowers_visited: u16,
    still_alive: bool,
};
```
Instead of having to write it the longer way with separate enum definition (which I was doing before):
```zig 
const InsectStat = enum {
    flowers_visited,
    still_alive,
};

const Insect = union(InsectStat) {
    flowers_visited: u16,
    still_alive: bool,
};
```
Cool Things I Discovered 🌟
- I can use union(enum) to make my code shorter
- It automatically creates the enum types from the union fields
- It's really useful for making different types of data work together (like my ants and bees example!)
**Note to self: This is a really neat way to handle different types of data in one structure!**


## 058_QUIZ.zig
[exercise link](exercises/058_quiz7.zig)

Damn, I was like 30 minutes to do some zigging, you know. `git commit ` and see you later. Wtf is this

```zig
// quote from the exercise
//
//                          u8  single item
//                         *u8  single-item pointer
//                        []u8  slice (size known at runtime)
//                       [5]u8  array of 5 u8s
//                       [*]u8  many-item pointer (zero or more)
//                 enum {a, b}  set of unique values a and b
//                error {e, f}  set of unique error values e and f
//      struct {y: u8, z: i32}  group of values y and z
// union(enum) {a: u8, b: i32}  single value either u8 or i32
```
I'm just going to show you how things were(?) done by me. 
```zig
    // This is a little helper function to print the two different
    // types of item correctly.
    fn printMe(self: TripItem) void {
        switch (self) {
            // Oops! The hermit forgot how to capture the union values
            // in a switch statement. Please capture each value as
            // 'p' so the print statements work!
            .place => |p| print("{s}", .{p.name}), // It was needed to add a |p|
            .path => |p| print("--{}->", .{p.dist}),
        }
    }
};
```
```zig
            if (place == entry.*.?.place) return &entry.*.?;
            // Try to make your answer this long:__________;
        }
        return null;
    }
```

Last: In function get trip to change `void` -> `!void`

## 059_integers.zig
[ex](exercise/059_integers.zig)
skip that

```zig
//
// Zig lets you express integer literals in several convenient
// formats. These are all the same value:
//
//     const a1: u8 = 65;          // decimal
//     const a2: u8 = 0x41;        // hexadecimal
//     const a3: u8 = 0o101;       // octal
//     const a4: u8 = 0b1000001;   // binary
//     const a5: u8 = 'A';         // ASCII code point literal
//     const a6: u16 = '\u{0041}'; // Unicode code points can take up to 21 bits
//
// You can also place underscores in numbers to aid readability:
//
//     const t1: u32 = 14_689_520 // Ford Model T sales 1909-1927
//     const t2: u32 = 0xE0_24_F0 // same, in hex pairs
//
```

In next one(060_floats.zig) I found new notes 

> Zig has support for IEEE-754 floating-point numbers in these
 specific sizes: f16, f32, f64, f80, and f128. Floating point
 literals may be written in the same ways as integers but also
 in scientific notation:

- `const a1: f32 = 1200;`       //    1,200
- `const a2: f32 = 1.2e+3;`     //    1,200
- `const b1: f32 = -500_000.0;` // -500,000
- `const b2: f32 = -5.0e+5;`    // -500,000

## 061_coertion. 
Zig's type coercion allows for automatic conversion between certain types, making the code cleaner and more concise.  Here's a breakdown of the key rules:

**Core Principles:**

* **Restriction:** Types can always be coerced to a *more* restrictive type (e.g., mutable to immutable).
* **Expansion:** Numeric types can be coerced to *larger* types (e.g., `u8` to `u16`, `f32` to `f64`).

**Key Coercion Rules:**

1. **Pointer to Array:** Single-item pointers to arrays coerce to slices (`[]T`) and many-item pointers (`[*]T`).
2. **Single-Item to Array Pointer:** Single-item pointers (`*T`) can coerce to pointers to a one-element array (`*[1]T`). This allows treating a single value as if it were in an array.
3. **Optional Types:** Values and `null` coerce to optional types (`?T`).
4. **Error Unions:** Values and errors coerce to error unions (`Error!T`).
5. **Undefined:** `undefined` coerces to any type. This is essential for uninitialized variables.


**Example: Coercing a Pointer**

Let's say you have `var x: u8 = 10;` and `var ptr: *u8 = &x;`.

* `ptr` can coerce to `*const u8` (mutable to immutable).
* `ptr` can coerce to `*[1]u8` (single-item pointer to array pointer).
* `ptr` can coerce to `?*const [1]u8` (optional pointer to a const array pointer).

**Important Considerations:**

* Coercion must not lead to data loss. You cannot coerce a `u32` to a `u8` directly (explicit casting needed).
* Understanding coercion rules is crucial for writing safe and efficient Zig code. The compiler will help by enforcing these rules and reporting errors when coercion is not possible.

## 
