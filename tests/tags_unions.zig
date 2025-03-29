const std = @import("std");

// Define the type of item you can have
const ItemType = enum { weapon, potion };

// Define our tagged union ()056_unions.zig
const Item = union(ItemType) {
    weapon: struct {
        damage: u32,
    },
    potion: struct {
        healing: u32,
    },
};

pub fn main() void {
    // Create a weapon with 25 damage
    const sword = Item{
        .weapon = .{
            .damage = 25,
        },
    };

    // Create a potion with 50 healing
    const health_potion = Item{
        .potion = .{
            .healing = 50,
        },
    };

    useItem(sword);
    useItem(health_potion);
}

fn useItem(item: Item) void {
    switch (item) {
        .weapon => |weapon| {
            std.debug.print("Using weapon that deals {} damage!\n", .{weapon.damage});
        },
        .potion => |potion| {
            std.debug.print("Drinking potion that heals {} health!\n", .{potion.healing});
        },
    }
}
