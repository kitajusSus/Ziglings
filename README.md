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

it value of the variable. Or should be seen like one, can be used as some placeholder. You are telling that you are not giving it value _*yet*_ its `var` means you can change it later.

2. Close your eyes bro. What do you see? .... Nothing.

```zig
var skibi: ?u8 = null;
```

Imagine that there is nothing. You are not giving it value. It is not defined. It is not undefined. It is null. It is a promise that this is a no_value value.
Now skibidi is something like:

> I'm u8 or I'm nothig, but to be nothing you need to be a thing.
> Holds value which is saying, `no value`

3. ERROR
   Imagine that something went wrong and you are not able to give it value.
   You got 2 options,
   a) you can ignore it and let your program crash
   b). -> [tests/test_050_error.zig](test_050_error.zig)

```zig
var toilet: u8!MyError = SomeError;
```

It was said that they are very similar to `null`, these two holds value

4.  _void_
    This is a type not a value. (hold semantic value == dont take any space),
    > It's much more common to see void as
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

I added a 1 commend close to first_line2, to show how error looks like,

## 051_values.zig

??? computer's molten core??? wtf is this.

the ziggi it saying that:

```zig
const std = @import("std");
```

Is a structure that holds a lot of different values. I think the whole program will tell us what are those crazy bits and bytes.

**Struct is a very convenient way to deal with memory** <- thats a quote from the exercise.
All the values of the struct are stored in memmory, if you add size of all the particular values you will get the size of struct as a whole.

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
> **FUNCTION PARAMETERS IN Z I G ARE ALWAYS IMMUTABLE**

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
```

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

Enter slices. Think of slices as a way to peek into an existing array without being tied down by its full size. They're like dynamic windows into an array(you come inside, see what you want and go home), letting you specify a starting point and a length.

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

> Noticed the empty brackets? Of course you did smart fella. I love you Timmie

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
2. Timmie, you need to remember that in _Zig_, strings literals, are immutable (you cant change them). {const}
3. Thats why if you want to take slice of a string, you need to use `[]const u8` type, because output needs to be the same type as input.

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

_Pointers_ are a way to reference a value in memory. I can do them to multiple items without using slicing.

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

- **Definition:** An array in Zig has a **fixed size known at compile time**. The type `[N]T` represents an array of `N` elements of type `T`.
- **Example:** `var foo: [4]u8 = [4]u8{ 1, 2, 3, 4 };` defines an array named `foo` that holds exactly 4 `u8` values.
- **Nature:** Arrays often behave like value types. When assigned or passed by value, the entire content might be copied (depending on context and size). The size `N` is part of the array's type.

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

- **Definition:** A slice is a **view** or a _section_ into an array(memory). It doesn't have a fixed size known at compile time. The type `[]T` represents a slice of elements of type `T`. But is stored with the slice and is know at **RUNTIME**
- **Example:** `var foo_slice: []u8 = foo[0..];` creates a slice `foo_slice` that points to the beginning of the `foo` array and knows its length is 4. Slices can represent a part of an array too: `foo[1..3]` would be a slice of length 2 containing `{ 2, 3 }`.
- **Key Feature:** Slices **always know their length**. This makes them safer to work with for iteration and bounds checking. They are often used for function arguments that accept sequences of unknown length at compile time.

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

- **Definition:** A many-item pointer (`[*]T`) is a **pointer to one or more items** of type `T`, but **it does not store the length**. It's essentially just a memory address pointing to the start of a sequence.
- **Analogy:** This is similar to how pointers often work in C/C++, where you have a pointer to the first element but need a separate mechanism (like a null terminator or an explicit length variable) to know where the sequence ends.
- **Example:** `var foo_ptr: [*]u8 = &foo;` creates a many-item pointer `foo_ptr` that points to the start of the `foo` array's data. **Crucially, the type `[*]u8` itself does not retain the information that there are 4 elements.**
- **Responsibility:** When using a `[*]T`, **you (the programmer) are responsible for keeping track of the number of valid items** this pointer points to. Accessing beyond the actual bounds leads to undefined behavior. These are often used for C interoperability or low-level memory manipulation where length tracking is handled separately.

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

- **Definition:** This is a pointer to a _specific, fixed-size array type_. The type `*[N]T` is a pointer to _one_ instance of `[N]T`.
- **Example:** `var foo_ptr_to_array: *[4]u8 = &foo;`
- **Difference from `[*]T`:** This pointer type _knows_ it points to an array of exactly `N` items because `N` is part of the type itself (`*[N]T`). You can get the size by dereferencing the pointer and accessing the `.len` of the underlying array type. `[*]T` loses this compile-time size information.

- **Code Snippet:**

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
> Realy good for ecolodgy of memory. You can reuse the same memory shelf.

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

By using swtich state I can change/act on my taged union `skibidi`. For example like this,

```zig
switch (skibidi) {
    .x => |argument| do_something_function(argument),
    .y => |argument_2| function2(argument_2),
    .z => |argument_3| function3(argument_3) ,
}
```

> Optional Values are basically `null unions`, and Erros are using "error union types".

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
> specific sizes: f16, f32, f64, f80, and f128. Floating point
> literals may be written in the same ways as integers but also
> in scientific notation:

- `const a1: f32 = 1200;` // 1,200
- `const a2: f32 = 1.2e+3;` // 1,200
- `const b1: f32 = -500_000.0;` // -500,000
- `const b2: f32 = -5.0e+5;` // -500,000

## 061_coertion.

Zig's type coercion allows for automatic conversion between certain types, making the code cleaner and more concise. Here's a breakdown of the key rules:

**Core Principles:**

- **Restriction:** Types can always be coerced to a _more_ restrictive type (e.g., mutable to immutable).
- **Expansion:** Numeric types can be coerced to _larger_ types (e.g., `u8` to `u16`, `f32` to `f64`).

**Key Coercion Rules:**

1. **Pointer to Array:** Single-item pointers to arrays coerce to slices (`[]T`) and many-item pointers (`[*]T`).
2. **Single-Item to Array Pointer:** Single-item pointers (`*T`) can coerce to pointers to a one-element array (`*[1]T`). This allows treating a single value as if it were in an array.
3. **Optional Types:** Values and `null` coerce to optional types (`?T`).
4. **Error Unions:** Values and errors coerce to error unions (`Error!T`).
5. **Undefined:** `undefined` coerces to any type. This is essential for uninitialized variables.

**Example: Coercing a Pointer**

Let's say you have `var x: u8 = 10;` and `var ptr: *u8 = &x;`.

- `ptr` can coerce to `*const u8` (mutable to immutable).
- `ptr` can coerce to `*[1]u8` (single-item pointer to array pointer).
- `ptr` can coerce to `?*const [1]u8` (optional pointer to a const array pointer).

**Important Considerations:**

- Coercion must not lead to data loss. You cannot coerce a `u32` to a `u8` directly (explicit casting needed).
- Understanding coercion rules is crucial for writing safe and efficient Zig code. The compiler will help by enforcing these rules and reporting errors when coercion is not possible.

## 062_loop_explessions.zig

[exercise link](exercises/062_loop_expressions.zig)

Simple example of using loop expressions in Zig. Loop expressions are a powerful feature that allows you to iterate over collections and perform operations in a concise manner.

Just add else statement on the end

## 063_labels.zig

[exercise063 link](exercises/063_labels.zig)

Zig utilizes labels primarily for fine-grained control over flow in loops and blocks. They allow you to specify exactly which loop or block a `break` or `continue` statement should affect, especially in nested situations.

Labels can be attached to `while` and `for` loops.

- **`break :label;`**: Exits the specific loop identified by `label`, even from within nested loops.
- **`break :label value;`**: Exits the specific loop identified by `label` _and_ makes the loop expression evaluate to `value`. (Useful when the loop is used as an expression).
- **`continue :label;`**: Skips the rest of the current iteration and proceeds to the next iteration of the specific loop identified by `label`.

```zig
const std = @import("std");

pub fn main() !void {
    var i: u3 = 0;
    outer_loop: while (i < 5) : (i += 1) {
        std.debug.print("Outer: {d}\n", .{i});
        var j: u3 = 0;
        inner_loop: while (j < 5) : (j += 1) {
            std.debug.print("  Inner: {d}\n", .{j});
            if (i == 2 and j == 1) {
                std.debug.print("  -> Breaking outer_loop from inner!\n", .{});
                break :outer_loop; // Exit the loop labeled 'outer_loop'
            }
            if (i == 0 and j == 3) {
                // This would only break the inner_loop if uncommented
                // break :inner_loop;
            }
        }
        // This line is skipped when break :outer_loop is hit
         std.debug.print("End of outer iteration {d}\n", .{i});
    }
    std.debug.print("After loops.\n", .{});
    // Output stops after "Outer: 2", "  Inner: 0", "  Inner: 1", "  -> Breaking outer_loop from inner!"
}
```

Labels can also be applied to regular blocks (`{ ... }`). This turns the block into an _expression_ that can be exited early using `break :label value;`.

- **`break :label value;`**: Immediately exits the block identified by `label`, and the entire block expression evaluates to `value`.

**Example:** Using a labeled block as an expression with early exit.

```zig
const std = @import("std");

pub fn main() !void {
    const input: ?u32 = 10; // Try changing to null, 0, or 101

    const result_message = check_value: {
        const value = input orelse {
            // If input is null, exit the block early
            break :check_value "Input is missing.";
        };

        if (value == 0) {
            break :check_value "Input is zero.";
        } else if (value > 100) {
            break :check_value "Input is too large.";
        }

        // If we reach here, the input is valid and within range
        // The final expression of the block is its value if no break occurred
        // but using break :label is often clearer for the "success" case too.
        break :check_value "Input is valid.";
    };

    std.debug.print("Check result: {s}\n", .{result_message});
    // With input = 10,  Output: Check result: Input is valid.
    // With input = null, Output: Check result: Input is missing.
    // With input = 0,   Output: Check result: Input is zero.
    // With input = 101, Output: Check result: Input is too large.
}
```

Block labels are particularly useful for complex initializations or validation logic where you might need to return a specific result from multiple points within the block.

## 064_builtins.zig

[exercise link](exercises/064_builtins.zig)

Zig provides a set of built-in functions that can be used to perform various operations. These built-ins are available in the `@` namespace and can be used without any imports.
Some of the most commonly used built-ins include:

- `@intToPtr`: Converts an integer to a pointer type.
- `@ptrToInt`: Converts a pointer to an integer type.
- `@sizeOf`: Returns the size of a type in bytes.
- `@alignOf`: Returns the alignment of a type in bytes.
- `@typeInfo`: Returns information about a type, including its size, alignment, and whether it is a pointer or an array.

Juz read the exercise I added the checking `skibidi` to see something

## 065_buildins2.zig

Okay Timmie, let's look at this Zig code like it's about building blocks and asking questions!

Imagine you have a special blueprint for a toy box called `Narcissus`.

1.  **The `Narcissus` Box Blueprint:**

    - This blueprint says the box should have two spots inside called `me` and `myself`. These spots are special because they should hold instructions pointing _back_ to the very same box! Like looking in a mirror.
    - It also has a spot called `echo`, but this spot is like an empty space, it doesn't hold anything real (that's what `void` means here - nothing!).
    - Inside the blueprint, there's a little helper instruction called `fetchTheMostBeautifulType`.

2.  **Building the Box:**

    - In the `main` part, we build _one_ actual toy box using the `Narcissus` blueprint: `var narcissus: Narcissus = Narcissus{};`.
    - Uh oh! The spots `me` and `myself` are empty! The code fixes this by putting instructions in them that point back to our `narcissus` box:
      - `narcissus.me = &narcissus;` (Put a pointer to `narcissus` in the `me` spot)
      - `narcissus.myself = &narcissus;` (Put a pointer to `narcissus` in the `myself` spot)

3.  **Asking Magic Questions (The Built-ins!):**

    - **`@TypeOf(...)` - What kind of toy is this?**
      Imagine you show the computer your `narcissus` box, the instruction in `me` (which points to the box), and the instruction in `myself` (which also points to the box).
      `@TypeOf(narcissus, narcissus.me.*, narcissus.myself.*)` asks the computer: "Hey, if you look at all these things, what _kind_ of toy are they all related to?"
      The computer is smart and says: "They are all related to the `Narcissus` blueprint!" So, `Type1` becomes the _type_ `Narcissus`.

    - **`@This()` - What blueprint am I inside?**
      The `fetchTheMostBeautifulType` helper inside the blueprint uses `@This()`. This is like the helper asking itself: "What's the name of the blueprint I am written inside of?"
      The answer is: "You are inside the `Narcissus` blueprint!"
      _Tiny tricky part:_ The code calls `narcissus.fetchTheMostBeautifulType()`. It's asking the _actual box_ to run the helper. The helper still knows it belongs to the `Narcissus` blueprint. So, `Type2` also becomes the _type_ `Narcissus`.

    - **`@typeInfo(...)` - Tell me about this blueprint!**
      This is like asking the computer to be a detective and look _really closely_ at the `Narcissus` blueprint (not the actual box, but the _idea_ of the box).
      `@typeInfo(Narcissus)` asks: "Tell me all the parts listed in the `Narcissus` blueprint!"
      The computer gives back a list (`fields`) saying: "Okay, the blueprint has a part named `me`, a part named `myself`, and a part named `echo`."

4.  **Checking the Parts:**

    - The code then looks at the list of parts the detective (`@typeInfo`) found.
    - For each part (`me`, `myself`, `echo`), it checks: "Is this part an empty space (`void`)?"
    - `if (fields[0].type != void)`: Is the first part (`me`) NOT an empty space? Yes! So print "me".
    - `if (fields[1].type != void)`: Is the second part (`myself`) NOT an empty space? Yes! So print "myself".
    - `if (fields[2].type != void)`: Is the third part (`echo`) NOT an empty space? No, it _is_ an empty space (`void`)! So, _don't_ print "echo".

5.  **`maximumNarcissism` Helper:**
    - Sometimes the computer gives a long name like `"filename.Narcissus"`. This little helper function just cleans it up and gives you back the main part, `"Narcissus"`. It makes the final printout look nicer.

**So, Timmie, what does the code do?**

It makes a `Narcissus` box that points to itself. Then it uses magic Zig questions (`@TypeOf`, `@This`, `@typeInfo`) to learn about the _type_ of the box (`Narcissus`) and the _parts_ inside its blueprint (`me`, `myself`, `echo`). Finally, it prints the important parts (`me`, `myself`) but skips the empty one (`echo`). It's all about looking at things and asking questions about what they are and what they're made of!

## 066_comptime.zig

[exercise 066 comptime link](exercises/066_comptime.zig)

Comptime is a powerful feature in Zig that allows you to execute code at compile timeThis means you can generate values,
types, and even functions before your program runs,
leading to more efficient and flexible code.

We can do things like this:

```zig
const skibidi = 123;
const toilet = 3.21;
```

I Dont need to precise the `size` of the `const value`. Now they are `comptime_int` and `comptime_float`

If we use variables we need to know how much memory we need to reserve for this.
Which means this code is wrong

```zig
var skibidi_var = 123;
var toilet_var = 3.21;
```

It's needed to add the size of variable:

```zig
var skibidi_var: u32 =  321;
```

## 067_comptime2.zig

[exercise 067 comptime2 link](exercises/067_comptime2.zig)

```bash
//  .     .   .      o       .          .       *  . .     .
//    .  *  |     .    .            .   .     .   .     * .    .
//        --o--            comptime        *    |      ..    .
//     *    |       *  .        .    .   .    --*--  .     *  .
//  .     .    .    .   . . .      .        .   |   .    .  .
```

when I use comptime before declaration of variable, zig will perform every usage of this variable in comptime

```zig
comptime var skibidi: u32 = 123; //comptime
var toilet: f32 = 2.11; //no comptime == RUNtime and no error
var toilet2 = 2123; //error (no declaration of size)
```

But they said that the using of `comptime` is **A CRIME** if I use this on unassigned size variablee. fun?

## 068_comptime3.zig

[exercise 068 comptime3 link](exercises/068_comptime3.zig)

When we write something like this:

```zig
fn scaleMe(self: *Schooner, comptime scale: u32) void {}
```

We are telling compilator that `comptime scale` is a compile-time variable:

> this variable its need to be known at compile time. So, when we call this function, we need to pass a value that is known at compile time.

*This is useful for things like array sizes, loop counts, or any other value that can be determined before the program runs.*

## inline loops
1. **Your blocks**
   You have three blocks: 🔴 (red), 🟢 (green), 🔵 (blue)

2. **A normal loop (“for”)**
   - It’s like telling your toy robot:
     1. “Pick up one block, draw it”
     2. “Pick up the next block, draw it”
     3. “Pick up the next block, draw it”
   - The robot **thinks each time** it picks a block (this happens at _runtime_).

3. **`inline for` loops**
   - You tell your robot **before playtime** exactly what to do with each block.
   - The robot writes down three steps on its plan:
     1. Draw the red block 🔴
     2. Draw the green block 🟢
     3. Draw the blue block 🔵
   - When playtime starts, the robot just follows the steps—no thinking needed!

```zig
```zig
const std = @import("std");

pub fn main() void {
    const blocks = [_]u8{ 10, 20, 30 };
    for (blocks) |value, index| {
        std.debug.print("Block {} has size {}\n", .{index, value});
    }
}
```

*At runtime, the robot thinks*:
- “Pick up block 0…”
- “Pick up block 1…”
- “Pick up block 2…”

2. Inline (`inline for`):
```zig
const std = @import("std");

pub fn main() void {
    const blocks = [_]u8{ 10, 20, 30 };

    inline for (blocks, 0..) |value, index| {
        std.debug.print("Block {} has size {}\n", .{index, value});
    }
}
```

- *At compile time, the robot thinks*:
```bash
std.debug.print("Block {} has size {}\n", .{0, 10});
std.debug.print("Block {} has size {}\n", .{1, 20});
std.debug.print("Block {} has size {}\n", .{2, 30});
```
At runtime, your program just runs those three lines—no looping needed!

### when to use it?
1. When data is known at compile time.
If you're looping over an array, enum, or range that’s fully known during compilation, inline for lets Zig unroll the loop at compile time.
```zig
const primes = [_]u32{2, 3, 5, 7, 11};
inline for (primes) |p| {
    comptime std.debug.assert(isPrime(p));
}
```
Each assertion here runs during compilation. If one fails, you get a compile-time error.

2. **When you want to eliminate loop overhead at runtime**
`inline for` expands into individual statements, so there's no runtime cost for iterating. This can matter in performance-critical code like graphics, DSP, or low-level systems.

3. **When generating code (metaprogramming) `inline for` is great for generating repetitive code safely and cleanly**:
```zig
const Colors = enum { Red, Green, Blue };
comptime {
    inline for (@typeInfo(Colors).Enum.fields) |f| {
        pub const handler_@{f.name} = generateHandler(f.name);
    }
}
```
4. *When initializing complex compile-time structures*
```zig
const N = 4;
comptime var matrix: [N][N]f32 = undefined;
inline for (0..N) |i| {
    inline for (0..N) |j| {
        matrix[i][j] = computeEntry(i, j);
    }
}
```

5. *When you want maintainable and DRY code*
Instead of copy-pasting similar lines, you keep your code clean by looping over a list and generating code for each item.

**When NOT to Use** `inline for`
1. Huge loops (many elements)
inline for will literally duplicate the code for every element, which can lead to large binaries and longer compile times.

2. When working with runtime data
If the data you're looping over is only available at runtime (e.g., user input or file data), you must use a regular for.

3. When performance is not critical
For simple logic where runtime cost is negligible, normal for loops are easier to read and generate smaller binaries.

🧠 Summary
**Use inline for when**:
- All loop data is known at compile time,
- You want the fastest possible code with no runtime overhead,
- You're generating code or doing comptime metaprogramming.

*Avoid it when:*
- Your loop range is large (e.g., 1000+ items),
- You're working with data only known at runtime,
- You care about binary size or compilation speed more than raw performance.


## 073_comptime8.zig
[exercise 073 link](exercises/073_comptime8.zig)

## 074_comptime9.zig


```zig
//
// In addition to knowing when to use the 'comptime' keyword,
// it's also good to know when you DON'T need it.
//
// The following contexts are already IMPLICITLY evaluated at
// compile time, and adding the 'comptime' keyword would be
// superfluous, redundant, and smelly:
//
//    * The container-level scope (outside of any function in a source file)
//    * Type declarations of:
//        * Variables
//        * Functions (types of parameters and return values)
//        * Structs
//        * Unions
//        * Enums
//    * The test expressions in inline for and while loops
//    * An expression passed to the @cImport() builtin
//
// Work with Zig for a while, and you'll start to develop an
// intuition for these contexts. Let's work on that now.
//
// You have been given just one 'comptime' statement to use in
// the program below. Here it is:
//
//     comptime
//
// Just one is all it takes. Use it wisely!
//
```
## Sentinels 77_sentinels.zig
```bash




```

- `const a`: [5]u8 = "array".*;
- `const b:` *const [16]u8 = "pointer to array";
- `const c:` []const u8 = "slice";
- `const d:` [:0]const u8 = "slice with sentinel";
- `const e:` [*:0]const u8 = "many-item pointer with sentinel";
- `const f:` [*]const u8 = "many-item pointer";


## Its imposible to do all async exercises then I  skip them for now

[exercises 084]()

##  092_interfaces.ziggi



