---
layout: default
title: system.filesystem
parent: libsystem
---

# system.filesystem
The filesystem module implements common operations for working with the
 filesystem, including wrappers for syscalls.

## `open(path: string, mode: string): FileHandle / nil, string`
Opens a file for reading or writing.

### Arguments
1. `path`: The path to the file to open
2. `mode`: The mode to open the file in: [rwa]b?

### Return Values
This function may return the following values:
1. The file handle, which has the same functions as CraftOS file handles

Or:
1. If the file could not be opened
2. An error message describing why the file couldn't be opened

## `list(path: string): table`
Returns a list of files in a directory.

### Arguments
1. `path`: The path to query

### Return Values
A list of files and folders in the directory

## `stat(path: string): FileStat`
Returns a table with various information about a file or directory.

### Arguments
1. `path`: The path to query

### Return Values
A table with information about the path

## `remove(path: string)`
Deletes a file or directory at a path, removing any subentries if present.

### Arguments
1. `path`: The path to remove

### Return Values
This function does not return anything.

## `rename(from: string, to: string)`
Moves a file or directory on the same filesystem.

### Arguments
1. `from`: The original file to move
2. `to`: The new path for the file

### Return Values
This function does not return anything.

## `mkdir(path: string)`
Creates a directory, making any parent paths that don't exist.

### Arguments
1. `path`: The directory to create

### Return Values
This function does not return anything.

## `chmod(path: string, user: string|nil, mode: number|string|{read?=boolean,write?=boolean,execute?=boolean})`
Changes the permissions (mode) of the file at a path.

### Arguments
1. `path`: The path to modify
2. `user`: The user to modify, or nil to modify world permissions
3. `mode`: The new permissions, as either an octal bitmask, a string in the format "[+-=][rwx]+" or "[r-][w-][x-]", or a table with the permissions to set (any `nil` arguments are left unset).

### Return Values
This function does not return anything.

## `chown(path: string, user: string)`
Changes the owner of a file or directory.

### Arguments
1. `path`: The path to modify
2. `user`: The new owner of the file

### Return Values
This function does not return anything.

## `mount(type: string, src: string, dest: string, options: table?)`
Mounts a filesystem of the specified type to a directory.  This can only be run by root.

### Arguments
1. `type`: The type of filesystem to mount
2. `src`: The source of the mount (depends on the FS type)
3. `dest`: The destination directory to mount to
4. `options`: A table of options to pass to the filesystem (optional)

### Return Values
This function does not return anything.

## `unmount(path: string)`
Unmounts a mounted filesystem.  This can only be run by root.

### Arguments
1. `path`: The filesystem to unmount

### Return Values
This function does not return anything.

## `combine(...: string): string`
Combines the specified path components into a single path, canonicalizing any links and ./..  paths.

### Arguments
1. `...`: The path components to combine

### Return Values
The combined and canonicalized path

## `copy(from: string, to: string)`
Copies a file or directory.

### Arguments
1. `from`: The path to copy from
2. `to`: The path to copy to

### Return Values
This function does not return anything.

## `move(from: string, to: string)`
Moves a file or directory, allowing cross-filesystem operations.

### Arguments
1. `from`: The path to move from
2. `to`: The path to move to

### Return Values
This function does not return anything.

## `basename(path: string): string`
Returns the file name for a path.

### Arguments
1. `path`: The path to use

### Return Values
The file name of the path

## `dirname(path: string): string`
Returns the parent directory for a path.

### Arguments
1. `path`: The path to use

### Return Values
The parent directory of the path

## `find(wildcard: string): table`
Searches the filesystem for paths matching a glob-style wildcard.

### Arguments
1. `wildcard`: The pathspec to match

### Return Values
A list of matching file paths

## `exists(path: string): boolean`
Convenience function for determining whether a file exists.
 This simply checks that @{stat} does not return `nil`.

### Arguments
1. `path`: The path to check

### Return Values
Whether the path exists

## `isFile(path: string): boolean`
Returns whether the path exists and is a file.

### Arguments
1. `path`: The path to check

### Return Values
Whether the path is a file

## `isDir(path: string): boolean`
Returns whether the path exists and is a directory.

### Arguments
1. `path`: The path to check

### Return Values
Whether the path is a directory

## `isLink(path: string): boolean`
Returns whether the path exists and is a link.

### Arguments
1. `path`: The path to check

### Return Values
Whether the path is a link

# Class FileStat
A table which stores file statistics.

## `FileStat.type`
Stores the type of file: one of "file", "directory", "link", "special"

### Fields
This function does not take any arguments.

## `FileStat.size`
The size of the file

### Fields
This function does not take any arguments.

## `FileStat.created`
The creation date of the file, in milliseconds since January 1, 1970

### Fields
This function does not take any arguments.

## `FileStat.modified`
The modification date of the file, in milliseconds since January 1, 1970

### Fields
This function does not take any arguments.

## `FileStat.owner`
The owner of the file

### Fields
This function does not take any arguments.

## `FileStat.permissions`
The permissions of the file for each user, indexed by user name

### Fields
- `read`: Whether the file can be read
- `write`: Whether the file can be written to
- `execute`: Whether the file can be executed

## `FileStat.worldPermissions`
The permissions of the file for all users not in @{FileStat.permissions}

### Fields
- `read`: Whether the file can be read
- `write`: Whether the file can be written to
- `execute`: Whether the file can be executed

## `FileStat.special`
Any additional data from the filesystem

