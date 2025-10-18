# memory and allocators tutorial.
```zig

/// Its taken from https://pedropark99.github.io/zig-book/Chapters/01-memory.html
/// MOST OF THESE COMMENTS ARE JUST COPPIES MATERIALS FROM THIS BOOK but some of them are my own comments.
```
[link](https://pedropark99.github.io/zig-book/Chapters/01-memory.html)




[memory1.zig](memory1.zig)
[memory2_stack.zig](memory2_stack.zig)

[memory3_other.zig](memory3_other.zig)

[memory4_stack2.zig](memory4_stack2.zig)

[memory5_heap.zig](memory5_heap.zig)

```zig

// One important limitation of the stack, is that, only objects whose length/size
// is known at compile-time can be stored in it. In contrast, the heap is a much
// more dynamic (and flexible) type of memory. It’s the perfect type of memory to
// use for objects whose size/length might grow during the execution of your program.
//
// Virtually any application that behaves as a server is a classic use case of the heap.
// A HTTP server, a SSH server, a DNS server, a LSP server, … any type of server.
// In summary, a server is a type of application that runs for long periods of time,
// and that serves (or “deals with”) any incoming request that reaches this particular server.

// "Every memory you allocate in the heap needs
// to be explicitly freed by you, the programmer."
```
More of these in Stack_overflow chapter

The majority of allocators in Zig do allocate memory on the heap.
But some exceptions to this rule are `ArenaAllocator()` and `FixedBufferAllocator()`.
The `ArenaAllocator()` is a special type of allocator that works in conjunction with a second type of allocator.
On the other side, the `FixedBufferAllocator()` is an allocator that works based on buffer objects created on the stack.
This means that the `FixedBufferAllocator()` makes allocations only on the stack.
