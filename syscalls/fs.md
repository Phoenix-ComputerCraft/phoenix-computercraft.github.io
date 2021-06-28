---
layout: default
title: Filesystem access
parent: System Calls
---

# Filesystem access
The following syscalls relate to accessing the filesystem.

## `open(path: string, mode: string): file`
Opens a file for reading or writing.

### Arguments
1. `path`: The path to the file to open. This may be a relative path to the current working directory, or an absolute path relative to the root.
2. `mode`: The mode to open the file in. This may be `r`, `w`, or `a`, with an additional `b` at the end to open in binary mode.

### Return Values
A file handle object. See below for more information.

### Errors
This syscall may throw an error if:
* The mode argument is invalid.
* The file was opened in read mode and it does not exist.
* The parent directory of the file does not exist.
* The file is a directory.
* The current user does not have permission to access the file.
* If creating a new file and the current user does not have permission to write the parent directory.

## `combine(components...: string): string`
Combines a set of path components into a valid path.

### Arguments
1. `components...`: The components in the path

### Return Values
The final path composed of the passed components.

### Errors
This syscall does not throw errors.

## `list(path: string): [string]`
Returns a list of file names present in a directory.

### Arguments
1. `path`: The path to the directory to list.

### Return Values
A list of file names. This may or may not be sorted.

### Errors
This syscall may throw an error if:
* The path does not exist.
* The path is not directory.
* The current user does not have permission to access the directory.

## `stat(path: string): table?`
Returns a table with information about a file or directory. If the file does not exist, this returns `nil`.

### Arguments
1. `path`: The path to the file or directory to inspect.

### Return Values
A table with the following contents:
* `size: number`: The total size of the file in bytes
* `type: string`: The type of file, which can be `"file"`, `"directory"`, `"link"`, or `"special"`
* `created: number`: The time the file was created, in milliseconds since the UNIX epoch
* `modified: number`: The time the file was last modified, in milliseconds since the UNIX epoch
* `owner: number`: The ID of the owner of the file
* `group: number`: The ID of the group of the file
* `permissions: table`: The permissions for each user class
    * `owner: table`: The permissions for the owner
        * `read: boolean`: Whether the owner can read the file
        * `write: boolean`: Whether the owner can write to the file
        * `execute: boolean`: Whether the owner can execute the file
    * `group: table`: The permissions for the group
        * `read: boolean`: Whether the group can read the file
        * `write: boolean`: Whether the group can write to the file
        * `execute: boolean`: Whether the group can execute the file
    * `everyone: table`: The permissions for every other user
        * `read: boolean`: Whether everyone can read the file
        * `write: boolean`: Whether everyone can write to the file
        * `execute: boolean`: Whether everyone can execute the file
* `special: table?`: A table that can contain mount-specific data.

### Errors
This syscall does not throw errors.

## `remove(path: string)`
Deletes a file at a path. If the file is a directory, this also removes all files and directories contained within it. If the file does not exist, this does nothing and returns successfully.

### Arguments
1. `path`: The path to the file to delete.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The current user does not have permission to write the file.
* The current user does not have permission to write the parent directory.

## `rename(from: string, to: string)`
Renames (moves) a file or directory from one path to another.

### Arguments
1. `from`: The file to move.
2. `to`: The new destination path for the file.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The original file does not exist.
* The new file already exists.
* The current user does not have permission to read the original file.
* The current user does not have permission to write the new file.
* The current user does not have permission to write the parent directory of the new file.

## `mkdir(path: string)`
Creates a new directory at a path, creating any parent directories if they don't exist. If the directory already exists, this function does nothing and exits successfully.

### Arguments
1. `path`: The path of the directory to create.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The current user does not have permission to write the parent directory of the first directory created.

## `chmod(path: string, mode: number|string|table)`
Changes the permissions (mode) of a file or directory.

### Arguments
1. `path`: The path to the file to modify.
2. `mode`: A value representing the mode. This may be:
    * A UNIX-style octal mode (e.g. `755`)
    * A UNIX-style mode modification string (e.g. `"a+x"`)
    * A 9-character string with "r", "w", and "x" (or "-") representing the permissions for the owner, group, and everyone (e.g. `"rwxr-xr-x"`)
    * A table in the same format as [`stat`'s permission field](#statpath-string-table)

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The file does not exist.
* The current user is not the owner of the file or root.

## `chown(path: string, user: number)`
Changes the owner of a file or directory.

### Arguments
1. `path`: The path to the file to modify.
2. `user`: The ID of the user who will own the file.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The file does not exist.
* The current user is not the owner of the file or root.

## `mount(type: string, src: string, dest: string, options: table?)`
Mounts a disk device to a path using the specified filesystem and options.

### Arguments
1. `type`: The filesystem type to use when mounting.
2. `src`: The source device to mount. This argument's meaning depends on the filesystem type.
3. `dest`: The directory to mount the new filesystem to.
4. `options`: A table of options to pass to the filesystem mounter. The available options are specified by each individual filesystem.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The filesystem type does not exist.
* The source device is invalid for the specified filesystem type.
* The destination path does not exist.
* The options passed to the mounter are invalid for the specified filesystem type.
* The current user does not have permission to access to the source device.
* The current user does not have permission to write to to the destination path.
* The mounter ran into an issue while mounting the device.

## `unmount(path: string)`
Unmounts the mount at the specified path.

### Arguments
1. `path`: The path to the mount.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The path does not exist.
* The path specified is not a mount.
* The user does not have permission to write to the path.