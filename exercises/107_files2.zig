//
// Prerequisite :
//    - exercise/106_files.zig, or
//    - create a file {project_root}/output/zigling.txt
//      with content `It's zigling time!`(18 bytes total)
//
// Now there's no point in writing to a file if we don't read from it, am I right?
// Let's write a program to read the content of the file that we just created.
//
// I am assuming that you've created the appropriate files for this to work.
//
// Alright, bud, lean in close. Here's the game plan.
//    - First, we open the {project_root}/output/ directory
//    - Secondly, we open file `zigling.txt` in that directory
//    - Then, we initialize an array of characters with all letter 'A', and print it
//    - After that, we read the content of the file into the array
//    - Finally, we print out the content we just read
//
// Note: For simplicity, we read byte-by-byte without buffering.
// In real applications, you'd typically use a buffer for better
// performance. We'll learn about buffered I/O in a later exercise.

const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    // Get the current working directory
    const cwd = std.Io.Dir.cwd();

    // try to open ./output assuming you did your 106_files exercise
    var output_dir = try cwd.openDir(io, "output", .{});
    defer output_dir.close(io);

    // try to open the file
    const file = try output_dir.openFile(io, "zigling.txt", .{});
    defer file.close(io);

    // initialize an array of u8 with all letter 'A'
    // we need to pick the size of the array, 64 seems like a good number
    // fix the initialization below
    var content = [_]u8{'A'} ** 64;
    // this should print out : `AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA`
    std.debug.print("{s}\n", .{content});

    var file_reader = file.reader(io, &.{});
    const reader = &file_reader.interface;

    // okay, seems like a threat of violence is not the answer in this case
    // can you go here to find a way to read the content?
    // https://ziglang.org/documentation/master/std/#std.Io.Reader
    // hint: look for a method that reads into a slice
    const bytes_read = try reader.readSliceShort(&content);

    // Woah, too screamy. I know you're excited for zigling time but tone it down a bit.
    // Can you print only what we read from the file?
    std.debug.print("Successfully Read {d} bytes: {s}\n", .{
        bytes_read,
        content[0..bytes_read], // change this line only
    });
}
