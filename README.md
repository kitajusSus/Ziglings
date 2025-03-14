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

## 043


```zig 
printCharacter(&glorp);
// wskaznik do tej struktury

```

## 044_quiz5.zig


## 050_no_value.zig
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


# 051_values.zig

