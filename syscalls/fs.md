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
Returns a table with information about a file or directory. If the file does not exist, this returns `nil` and an error message.

### Arguments
1. `path`: The path to the file or directory to inspect.

### Return Values
A table with the following contents:
* `size: number`: The total size of the file in bytes
* `type: string`: The type of file, which can be `"file"`, `"directory"`, `"link"`, `"fifo"`, or `"special"`
* `created: number`: The time the file was created, in milliseconds since the UNIX epoch
* `modified: number`: The time the file was last modified, in milliseconds since the UNIX epoch
* `owner: string`: The owner of the file
* `mountpoint: string`: The path to the mountpoint the file is on
* `link: string?`: If the file is a link, the path it links to
* `capacity: number`: The total number of bytes the mount can store
* `freeSpace: number`: The total number of bytes available on the mount
* `permissions: table`: The permissions for each user/group
    * `<string>: table`: The permissions for each user/group who has manual permissions
        * `read: boolean`: Whether the user can read the file
        * `write: boolean`: Whether the user can write to the file
        * `execute: boolean`: Whether the user can execute the file
* `worldPermissions: table`: The permissions for all other users
    * `read: boolean`: Whether everyone else can read the file
    * `write: boolean`: Whether everyone else can write to the file
    * `execute: boolean`: Whether everyone else can execute the file
* `setuser: boolean`: Whether executing the file will set the user to the owner
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
* The current user does not have permission to write child subfiles and subdirectories.
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
* A path component already exists and is a file.

## `link(path: string, location: string)`
Creates a new symbolic link at a path, creating any parent directories if they don't exist.

### Arguments
1. `path`: The path to the link to create.
2. `location`: The location the link should point to. This may be on another filesystem, as the link is symbolic.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The current user does not have permission to write the parent directory of the first directory created.
* The path already exists.

## `mkfifo(path: string)`
Creates a new FIFO (first in first out) pipe file at a path, creating any parent directories if they don't exist.

### Arguments
1. `path`: The path to the FIFO to create.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The current user does not have permission to write the parent directory of the first directory created.
* The path already exists.

## `chmod(path: string, user: string?, mode: number|string|table)`
Changes the permissions (mode) of a file or directory for the specified user. If any setuser bit is specified, this will be applied for all users.

### Arguments
1. `path`: The path to the file to modify.
2. `user`: The user to set the permissions for. If this is `nil`, sets the permissions for all users.
3. `mode`: A value representing the permissions. This may be:
    * A UNIX-style octal mode (e.g. `5`) - setuid bit is bit 4 (010)
    * A UNIX-style mode modification string, without the user specifier (e.g. `"+rx"`) (this does not work with `"-wx"` - use `"-xw"` instead)
    * A 3-character string with "r", "w", and "x" or "s" (or "-") (e.g. `"r-s"`)
    * A table with `read: boolean?`, `write: boolean?`, `execute: boolean?`, and `setuser: boolean?` fields (if a field is `nil`, it uses the previous value)

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The file does not exist.
* The current user is not the owner of the file or root.

## `chown(path: string, user: string)`
Changes the owner of a file or directory, clearing the `setuser` bit if it's set.

### Arguments
1. `path`: The path to the file to modify.
2. `user`: The user who will own the file.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The file does not exist.
* The current user is not the owner of the file or root.

## `chroot(path: string)`
Changes the root directory of the current and future child processes. This syscall requires root.

### Arguments
1. `path`: The path to the new root directory.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The current user is not root.
* The new root directory does not exist.

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

## `mountlist(): [{path: string, type: string, source: string, options: table}]`
Returns a list of mounts on the system.

### Arguments
This syscall does not take any arguments.

### Return Values
A list of tables containing the mount path, the filesystem type, the source path, and any options stored in the mount.

### Errors
This syscall does not throw any errors.

## `loadCraftOSAPI(apiName: string): table`
Loads a CraftOS API or module from the ROM. This can be used to get access to certain functions without having to mount the entire ROM.

This uses the current process's environment as the parent environment. This means the API will use the process's globals. If the API you need requires certain globals (like `colors`), load these in as globals first.

### Arguments
1. `apiName`: The name of the API or module to load. If this starts with `cc.`, it loads a module from `rom/modules/main`. Otherwise, it loads an API from `rom/apis`.

### Return Values
A table with the loaded API or module.

### Errors
This syscall may throw an error if:
* The API name is malformed.
* The API does not exist.
* An error occurred while loading the API.