//
/// FIXED BUFFER ALLOCATOR W ZIG
//
//
/// Przydatny gdy chcemy uniknąć dynamicznej alokacji pamięci.
const std = @import("std");

pub fn main() !void {
    // ===== Fixed Buffer Allocator =====
    // Alokator działający na predefiniowanym buforze pamięci
    var buffer: [1000]u8 = undefined;
    var fixed_allocator = std.heap.FixedBufferAllocator.init(&buffer);
    const fixed = fixed_allocator.allocator();

    // To nie wymaga try - nigdy nie może zwrócić OutOfMemory, dopóki
    // mieścimy się w rozmiarze bufora
    const data1 = fixed.alloc(u8, 50) catch unreachable;
    @memset(data1, 'A');

    const data2 = fixed.alloc(u8, 100) catch unreachable;
    @memset(data2, 'B');

    std.debug.print("Buffer 1: {s}\n", .{data1});
    std.debug.print("Buffer 2: {s}\n", .{data2});

    // Próba alokacji większej niż pozostała przestrzeń zakończy się błędem
    const remaining_space = fixed_allocator.end_index - fixed_allocator.index;
    std.debug.print("Pozostała przestrzeń: {} bajtów\n", .{remaining_space});

    // Jeśli spróbujemy zaalokować więcej niż mamy dostępnego miejsca:
    const too_big = fixed.alloc(u8, 1000) catch |err| {
        std.debug.print("Oczekiwany błąd: {}\n", .{err});
        return;
    };
    _ = too_big;
}
