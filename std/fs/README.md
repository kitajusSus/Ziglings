# std.fs – filesystem reference

This directory contains an executable example and a reference guide for Zig's filesystem module. Run the example with:

```sh
zig run main.zig
```

## Global functions
- `std.fs.cwd()` – return the current working directory handle
- `std.fs.updateFileAbsolute(src, dest, args)` – copy if source is newer
- `std.fs.copyFileAbsolute(src, dest, args)` – copy a file between absolute paths
- `std.fs.makeDirAbsolute(path)` / `makeDirAbsoluteZ` / `makeDirAbsoluteW` – create a directory
- `std.fs.deleteDirAbsolute(path)` / `deleteDirAbsoluteZ` / `deleteDirAbsoluteW` – remove an empty directory
- `std.fs.renameAbsolute(old, new)` / `renameAbsoluteZ` / `renameAbsoluteW` – rename a file or directory
- `std.fs.openDirAbsolute(path, flags)` – open a directory
- `std.fs.openFileAbsolute(path, flags)` – open a file
- `std.fs.accessAbsolute(path, flags)` – check access rights
- `std.fs.createFileAbsolute(path, flags)` – create a new file
- `std.fs.deleteFileAbsolute(path)` / `deleteFileAbsoluteZ` / `deleteFileAbsoluteW` – delete a file
- `std.fs.deleteTreeAbsolute(path)` – recursively delete a directory tree
- `std.fs.readLinkAbsolute(path, buffer)` – read a symbolic link target
- `std.fs.symLinkAbsolute(target, link_path, ...)` – create a symbolic link
- `std.fs.openSelfExe(flags)` – open the running executable
- `std.fs.selfExePathAlloc(allocator)` / `selfExePath` – get path to the executable
- `std.fs.selfExeDirPathAlloc(allocator)` / `selfExeDirPath` – get directory of the executable
- `std.fs.realpathAlloc(allocator, path)` – canonicalize a path

## `Dir` – directory handle methods
- `dir.close()` – release resources
- `dir.openFile(sub_path, flags)` / `openFileZ` / `openFileW` – open a file
- `dir.createFile(sub_path, flags)` / `createFileZ` / `createFileW` – create a file
- `dir.makeDir(sub_path)` / `makeDirZ` / `makeDirW` – create a subdirectory
- `dir.makePath(sub_path)` – create all components of a path
- `dir.makePathStatus(sub_path)` – report whether the path existed or was created
- `dir.makeOpenPath(sub_path, open_dir_options)` – create and open a nested directory
- `dir.realpath(path, buffer)` / `realpathZ` / `realpathW` / `realpathAlloc` – resolve a path
- `dir.setAsCwd()` – set the process working directory
- `dir.openDir(sub_path, options)` / `openDirZ` / `openDirW` – open a subdirectory
- `dir.deleteFile(sub_path)` / `deleteFileZ` / `deleteFileW` – remove a file
- `dir.deleteDir(sub_path)` / `deleteDirZ` / `deleteDirW` – remove an empty subdirectory
- `dir.rename(old_sub_path, new_sub_path)` / `renameZ` / `renameW` – rename within the directory
- `dir.symLink(target, link_path, ...)` / `symLinkZ` / `symLinkW` – create a symbolic link
- `dir.atomicSymLink(target, tmp_path, final_path)` – create a symbolic link atomically
- `dir.readLink(sub_path, buffer)` / `readLinkZ` / `readLinkW` – read a symbolic link
- `dir.readFile(file_path, buffer)` – read a file into a provided buffer
- `dir.readFileAlloc(file_path, allocator, options?)` – allocate a buffer and read a file
- `dir.deleteTree(sub_path)` / `deleteTreeMinStackSize` – recursively delete a directory tree
- `dir.writeFile(options)` – write data to a file, creating or truncating
- `dir.access(sub_path, flags)` / `accessZ` / `accessW` – check permissions
- `dir.updateFile(source, dest, args)` – copy if source is newer
- `dir.copyFile(source, dest, args)` – copy a file
- `dir.atomicFile(dest_path, options)` – open a temporary file to atomically replace the destination
- `dir.stat()` – get information about the directory itself
- `dir.statFile(sub_path)` – get information about a file
- `dir.chmod(new_mode)` – change permissions
- `dir.chown(owner, group)` – change ownership
- `dir.setPermissions(permissions)` – modify POSIX-style permissions
- `dir.iterate()` / `iterateAssumeFirstIteration()` – iterate over entries
- `dir.walk(allocator)` – recursively iterate over a tree
- `Dir.Iterator.next()` / `reset()` – iterator methods
- `Dir.Walker.next()` / `deinit()` – walker methods

## `File` – file handle methods
- `file.close()` – close the handle
- `file.sync()` – flush pending writes to disk
- `file.isTty()` – check whether the handle is a terminal
- `file.getOrEnableAnsiEscapeSupport()` / `supportsAnsiEscapeCodes()` – ANSI escape support
- `file.setEndPos(len)` – truncate or extend the file
- `file.seekBy(offset)` / `seekFromEnd(offset)` / `seekTo(pos)` – move the file cursor
- `file.getPos()` / `getEndPos()` – query current position or size
- `file.mode()` – retrieve mode bits
- `file.stat()` – obtain `File.Stat` information
- `file.chmod(new_mode)` / `chown(owner, group)` / `setPermissions(permissions)` – change metadata
- `file.updateTimes(atime, mtime)` – set access and modification times
- `file.read(buffer)` / `readAll(buffer)` – read data
- `file.pread(buffer, offset)` / `preadAll(buffer, offset)` – positional read
- `file.readv(iovecs)` / `readvAll(iovecs)` – scatter read into multiple buffers
- `file.preadv(iovecs, offset)` / `preadvAll(iovecs, offset)` – positional scatter read
- `file.write(bytes)` / `writeAll(bytes)` – write data
- `file.pwrite(bytes, offset)` / `pwriteAll(bytes, offset)` – positional write
- `file.writev(iovecs)` / `writevAll(iovecs)` – gather write from multiple buffers
- `file.pwritev(iovecs, offset)` / `pwritevAll(iovecs, offset)` – positional gather write
- `file.copyRange(in_offset, out_file, out_offset, len)` / `copyRangeAll` – copy bytes between files
- `File.reader(file, buffer)` / `readerStreaming` – create a buffered reader
- `Reader.getSize()` / `seekBy()` / `seekTo()` / `logicalPos()` / `read()` / `readPositional()` / `readStreaming()` / `atEnd()` – reader methods
- `File.writer(file, buffer)` / `writerStreaming` – create a buffered writer
- `Writer.seekTo()` / `end()` / `moveToReader()` / `drain()` / `sendFile()` – writer methods
- `File.lock(lock)` / `tryLock(lock)` / `unlock()` / `downgradeLock()` – advisory file locking

## `path` utilities
- `path.join(allocator, parts)` – join components into a path
- `path.joinZ(allocator, parts)` – join components and return a null-terminated string
- `path.joinWindows(allocator, parts)` – Windows-style join
- `path.isAbsolute(path)` / `isAbsoluteZ` / `isAbsoluteWindowsW` – test for absolute paths
- `path.resolve(allocator, base, relative)` – resolve a relative path against a base
- `path.basename(path)` – final component of a path
- `path.extension(path)` – file extension
- `path.dirname(path)` – everything except the final component
- `path.normalize(allocator, path)` – clean up "." and ".." segments
- `path.relative(allocator, base, target)` – compute a relative path
- `path.sep_bytes` / `path.sep_char` – directory separator constants

This document summarizes the functions available in `std.fs` and groups them by purpose for quick reference.
