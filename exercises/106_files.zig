// Until now, we've only been printing our output in the console,
// which is good enough for fighting aliens and hermit bookkeeping.
//
// However, many other tasks require some interaction with the file system,
// which is the underlying structure for organizing files on your computer.
//
// The file system provides a hierarchical structure for storing files
// by organizing them into directories, which hold files and other directories,
// thus creating a tree structure that can be navigated.
//
// Fortunately, the Zig Standard Library provides a simple API for interacting
// with the file system, see the detail documentation here:
//
// https://ziglang.org/documentation/master/std/#std.Io
//
// In this exercise, we'll try to:
//   - create a new directory,
//   - open a file in the directory,
//   - write to the file.
//
// Note: For simplicity, we write byte-by-byte without buffering.
// In real applications, you'd typically use a buffer for better
// performance. We'll learn about buffered I/O in a later exercise.
//
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    // default I/O implementation
    const io = init.io;

    // first we get the current working directory
    const cwd: std.Io.Dir = std.Io.Dir.cwd();

    // then we'll try to make a new directory /output/
    // to store our output files.
    cwd.createDir(io, "output", .default_dir) catch |e| switch (e) {
        // there is a chance you might want to run this
        // program more than once and the path might already
        // have been created, so we'll have to handle this error
        // by doing nothing
        //
        // we want to catch error.PathAlreadyExists and do nothing
        ??? => {},
        // if there's any other unexpected error we just propagate it through
        else => return e,
    };

    // then we'll try to open our freshly created directory
    // wait a minute...
    // opening a directory might fail!
    // what should we do here?
    var output_dir: std.Io.Dir = try cwd.openDir(io, "output", .{});
    defer output_dir.close(io);

    // we try to open the file `zigling.txt`,
    // and propagate any error up
    const file: std.Io.File = try output_dir.createFile(io, "zigling.txt", .{});
    // it is a good habit to close a file after you are done with it
    // so that other programs can read it and prevent data corruption
    // but here we are not yet done writing to the file
    // if only there were a keyword in Zig that
    // allowed you to "defer" code execution to the end of the scope...
    file.close(io);

    // you are not allowed to move these lines above the file closing line!
    var file_writer = file.writer(io, &.{});
    const writer = &file_writer.interface;

    const byte_written = try writer.write("It's zigling time!");
    std.debug.print("Successfully wrote {d} bytes.\n", .{byte_written});
}
// to check if you actually write to the file, you can either,
// 1. open the file in your text editor, or
// 2. print the content of the file in the console with one of these commands
//    Linux/macOS:   >> cat ./output/zigling.txt
//    Windows (CMD): >> type .\output\zigling.txt
//
//
// More on Creating files
//
// notice in:
// ... try output_dir.createFile(io, "zigling.txt", .{});
//                                                  ^^^
//                 we passed this anonymous struct to the function call
//
// this is the struct `CreateFlag` with default fields
// {
//      read: bool = false,
//      truncate: bool = true,
//      exclusive: bool = false,
//      lock: Lock = .none,
//      lock_nonblocking: bool = false,
//      mode: Mode = default_mode
// }
//
// Question:
//   - what should you do if you want to also read the file after opening it?
//   - go to the documentation of the struct `std.Io.Dir` here:
//     https://ziglang.org/documentation/master/std/#std.Io.Dir
//       - can you find a function for opening a file? how about deleting a file?
//       - what kind of options can you use with those functions?
