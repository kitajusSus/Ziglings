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
> part of this code above was copied from -> https://github.com/Laz4rz/ziglings/README

**Answer**
```zig
//in leverUp we needed to change arguments to a values. 
levelUp(&glorp, reward_xp); //original wal levelUp(glorp, reward_xp);
//later on I needed to see that the argument `character_access` is imported as a const, I needed a pointer to check sum. 
fn levelUp(const character_access: *Character, xp: u32) void{

};
```


