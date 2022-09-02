---
layout: default
title: Kernel API
---

# Kernel API
This page contains documentation for the public kernel module API.

This is a work-in-progress! Some parts may be broken or don't make sense.

## `version: string`
Version number of Phoenix.

## `do_syscall(call: string, ...: any): any...`
Small function to execute a syscall and error if it fails.

### Arguments
1. `call`: The syscall to execute
2. `...`: The arguments to pass to the syscall

### Return Values
The values returned from the syscall

## `deepcopy(tab: any): any`
Copies a value.  If the value is a table, copies all of its contents too.

### Arguments
1. `tab`: The value to copy

### Return Values
The new copied value

## `split(str: string[, sep: string = "%s"]): {string}`
Splits a string by a separator.

### Arguments
1. `str`: The string to split
2. `sep`: The separator pattern to split by (defaults to "%s")

### Return Values
A list of items in the string

## `executeThread(process: Process, thread: Thread, ev: table, dead: boolean, allWaiting: boolean): boolean, boolean`
Resumes a thread's coroutine, handling different yield types.

### Arguments
1. `process`: The process that owns the thread
2. `thread`: The thread to resume
3. `ev`: An event to pass to the thread, if present
4. `dead`: Whether a thread in the current run cycle has died
5. `allWaiting`: Whether all previous threads were waiting for an event

### Return Values
This function may return the following values:
1. Whether this thread or a previous thread has died
2. Whether all threads (including this one) are waiting for an event

## `userModeCallback(process: Process, func: function, ...: any): boolean, any`
Executes a function in user mode from kernel code.

### Arguments
1. `process`: The process to execute as
2. `func`: The function to execute
3. `...`: Any parameters to pass to the function

### Return Values
This function may return the following values:
1. Whether the function returned successfully
2. The value that the function returned.

## `make_ENV(env: table): table`
Creates a new _ENV shadow environment for a table.  The resulting table can
 have its environment set through `t._ENV = val`.

### Arguments
1. `env`: The environment table to use

### Return Values
A new _ENV-ized table

## `args`
Stores all kernel arguments passed on the command line.

### Fields
- `init`:
- `root`:
- `rootfstype`:
- `preemptive`:
- `quantum`:
- `splitkernpath`:
- `loglevel`:
- `console`:
- `traceback`:

## `syscalls`
Contains every syscall defined in the kernel.

## `processes`
Stores all currently running processes.

### Fields
- `[0]`:
- `id`:
- `user`:
- `dir`:
- `dependents`:

## `modules`
Stores all currently loaded kernel modules.

## `eventHooks`
Stores a list of hooks to call on certain CraftOS events.  Each entry has the
 event name as a key, and a list of functions to call as the value. The
 functions are called with a single table parameter with the event parameters.

## `process`
Process API

## `filesystem`
Filesystem API

## `terminal`
Terminal API

## `user`
User API

## `syslog`
System logger API

## `hardware`
Hardware API

## `PHOENIX_BUILD`
Build string of Phoenix.

### Fields
This function does not take any arguments.

## `systemStartTime`
Stores the start time of the kernel.

### Fields
This function does not take any arguments.

## `KERNEL`
Stores a quick reference to the kernel process object.

### Fields
This function does not take any arguments.

# filesystem


## `mounts`
Stores the current mounts as a key-value table of paths to filesystem objects.

## `filesystems`
This table contains all filesystem types.  Use this to insert more filesystem
 types into the system.

 A filesystem type has to implement one method for each function in the
 filesystem API, with the exception of mounting-related functions and `combine`,
 as well as a `new` method that is called with the process, the source device,
 and the options table (if present). Paths passed to these methods (outside
 `new`) take a relative path to the mountpoint, NOT the absolute path.

### Fields
- `craftos`:
- `owner`:
- `permissions`:
- `write`:
- `execute`:

## `filesystem.open(process: Process, path: string, mode: string): Handle / nil, string`
Opens a file for reading or writing.

### Arguments
1. `process`: The process to operate as
2. `path`: The file path to open, which may be absolute or relative
 to the process's working directory
3. `mode`: The mode to open the file as

### Return Values
This function may return the following values:
1. The new file handle

Or:
1. If an error occurred
2. An error message describing why the file couldn't be opened

## `filesystem.list(process: Process, path: string): {string}`
Returns a list of file names in the directory.

### Arguments
1. `process`: The process to operate as
2. `path`: The file path to list, which may be absolute or relative
 to the process's working directory

### Return Values
A list of file names present in the directory

## `filesystem.stat(process: Process, path: string): table / nil, string`
Returns a table with information about the selected path.

### Arguments
1. `process`: The process to operate as
2. `path`: The file path to stat, which may be absolute or relative
 to the process's working directory

### Return Values
This function may return the following values:
1. A table with information about the path (see the docs for
 the `stat` syscall for more info)

Or:
1. If an error occurred
2. An error message describing why the file couldn't be opened

## `filesystem.remove(process: Process, path: string)`
Removes a file or directory.

### Arguments
1. `process`: The process to operate as
2. `path`: The file path to remove, which may be absolute or relative
 to the process's working directory

### Return Values
This function does not return anything.

## `filesystem.rename(process: Process, path: string, new: The)`
Renames (moves) a file or directory.

### Arguments
1. `process`: The process to operate as
2. `path`: The file path to rename, which may be absolute or relative
 to the process's working directory
3. `new`: path the file will be at, which may be in another directory
 but must be on the same mountpoint

### Return Values
This function does not return anything.

## `filesystem.mkdir(process: Process, path: string)`
Creates a new directory and any parent directories.

### Arguments
1. `process`: The process to operate as
2. `path`: The directory to create, which may be absolute or relative
 to the process's working directory

### Return Values
This function does not return anything.

## `filesystem.chmod(process: Process, path: string, user: string|nil, boolean: number|string|{read)`
Changes the permissions (mode) of a file or directory for the specified user.

### Arguments
1. `process`: The process to operate as
2. `path`: The file path to modify, which may be absolute or relative
 to the process's working directory
3. `user`: The user to change the permissions for, or `nil` for all users
4. `boolean`: ?, write = boolean?, execute = boolean?} mode The
 new permissions for the user (see the docs for the `chmod` syscall for more info)

### Return Values
This function does not return anything.

## `filesystem.chown(process: Process, path: string, user: string)`
Changes the owner of a file or directory.

### Arguments
1. `process`: The process to operate as
2. `path`: The file path to modify, which may be absolute or relative
 to the process's working directory
3. `user`: The user that will own the file

### Return Values
This function does not return anything.

## `filesystem.mount(process: Process, type: string, src: string, dest: string, options: table?)`
Mounts a disk device to a path using the specified filesystem and options.

### Arguments
1. `process`: The process to operate as
2. `type`: The type of filesystem to mount
3. `src`: The source device to mount
4. `dest`: The destination mountpoint
5. `options`: Any options to pass to the mounter (optional)

### Return Values
This function does not return anything.

## `filesystem.unmount(process: Process, path: string)`
Unmounts a filesystem at a mountpoint.

### Arguments
1. `process`: The process to operate as
2. `path`: The mountpoint to remove, which may be absolute or relative
 to the process's working directory

### Return Values
This function does not return anything.

## `filesystem.combine(first: string, ...: string): string`
Combines the specified path components into a single path.

### Arguments
1. `first`: The first path component
2. `...`: Any additional path components to add

### Return Values
The final combined path

## `createLuaLib(process: Process): _G`
Creates a new global table with a Lua 5.2 standard library installed.

### Arguments
1. `process`: The process to generate for

### Return Values
A new global table for the process

# terminal


## `terminal.makeTTY(term: table, width: number, height: number): TTY`
Returns a new TTY object.

### Arguments
1. `term`: The CraftOS terminal object to render on
2. `width`: The width of the TTY
3. `height`: The height of the TTY

### Return Values
The new TTY object

## `TTY`
Stores all virtual TTYs for the main screen.

### Fields
- `terminal`:
- `terminal`:
- `terminal`:
- `terminal`:
- `terminal`:
- `terminal`:
- `terminal`:
- `terminal`:

## `currentTTY`
Stores the TTY that is currently shown on screen.

### Fields
This function does not take any arguments.

## `terminal.userTTYs`
Stores all TTYs that have been created in user mode.

## `keysHeld`
Stores what modifier keys are currently being held.

### Fields
- `ctrl`:
- `alt`:
- `shift`:

## `terminal.redraw(tty: TTY, full: boolean)`
Redraws the specified TTY if on-screen.

### Arguments
1. `tty`: The TTY to redraw
2. `full`: Whether to draw the full screen, or just the changed regions

### Return Values
This function does not return anything.

## `terminal.resize(tty: TTY, width: number, height: number)`
Resizes the TTY.

### Arguments
1. `tty`: The TTY to resize
2. `width`: The new width
3. `height`: The new height

### Return Values
This function does not return anything.

## `terminal.write(tty: TTY, text: string)`
Writes some text to a TTY's text buffer, allowing ANSI escapes.

### Arguments
1. `tty`: The TTY to write to
2. `text`: The text to write

### Return Values
This function does not return anything.

# syslog


## `syslogs`
Stores all open system logs.

### Fields
- `default`: file = filesystem.open(KERNEL, "/var/log/default.log", "a"),

## `panic(message: any?)`
Immediately halts the system and shows an error message on screen.
 This function can be called either standalone or from within xpcall.
 This function never returns.

### Arguments
1. `message`: A message to display on screen (optional)

### Return Values
This function does not return anything.

## `createRequire(process: Process, G: _G)`
Creates a new `package` and `require` set in a global table for the specified process.

### Arguments
1. `process`: The process to make the functions for
2. `G`: The global environment to install in

### Return Values
This function does not return anything.

## `timerMap`
Stores a list of used timers.

## `alarmMap`
Stores a list of used alarms.

## `reap_process(process: Process)`
Finishes a process's resources so it can be removed cleanly.

### Arguments
1. `process`: The process to reap

### Return Values
This function does not return anything.

# hardware


## `deviceTreeRoot`
Stores the root device for hardware.

### Fields
- `id`:
- `uuid`:
- `parent`:
- `displayName`:
- `drivers`:

## `hardware.get(path: string): Device...`
Returns all devices that match a path specifier.

### Arguments
1. `path`: The path to query

### Return Values
The device objects that match

## `hardware.find(type: string): Device...`
Returns all devices that match a type.

### Arguments
1. `type`: The type to find

### Return Values
The device objects that match

## `hardware.path(node: Device): string`
Returns the absolute path to a device node.

### Arguments
1. `node`: The node to lookup

### Return Values
The path to the node

## `hardware.add(parent: Device, name: string): Device`
Adds a new child to the specified node.

### Arguments
1. `parent`: The parent of the new node
2. `name`: The name of the new node

### Return Values
The newly added node

## `hardware.remove(node: Device): boolean, string?`
Removes a node from its parent and the device tree.  The device node should
 no longer be used.

### Arguments
1. `node`: The node to remove

### Return Values
This function may return the following values:
1. Whether the operation succeeded
2. An error message if it failed

## `hardware.register(node: Device, driver: Driver): boolean, string?`
Registers a device driver on a node.

### Arguments
1. `node`: The node to modify
2. `driver`: The driver to add

### Return Values
This function may return the following values:
1. Whether the operation succeeded
2. An error message if it failed

## `hardware.register_callback(driver: Driver): function`
Returns a function that automatically attaches a driver to a node.

### Arguments
1. `driver`: The driver to use

### Return Values
A function that takes a node and registers the driver on it

## `hardware.deregister(node: Device, driver: Driver): boolean, string?`
Deregisters a driver from a node.

### Arguments
1. `node`: The node to modify
2. `driver`: The driver to remove

### Return Values
This function may return the following values:
1. Whether the operation succeeded
2. An error message if it failed

## `hardware.listen(callback: function, parent: Device?, pattern: string?)`
Adds a function that is called when either a parent node or pattern matches on a new node.

### Arguments
1. `callback`: A function that is called with a node when the pattern matches
2. `parent`: A parent node to watch on (optional)
3. `pattern`: A Lua pattern to match on the device name (optional)

### Return Values
This function does not return anything.

## `hardware.unlisten(callback: function)`
Removes a listener callback from the listener list.

### Arguments
1. `callback`: The function to remove

### Return Values
This function does not return anything.

## `hardware.broadcast(node: Device, event: string, param: table)`
Broadcasts an event to all processes listening to events on a node.

### Arguments
1. `node`: The node to broadcast for
2. `event`: The event to broadcast
3. `param`: The parameters to pass for the event

### Return Values
This function does not return anything.

## `hardware.call(process: Process, node: Device, method: string, ...: any): any...`
Calls a method on a device.

### Arguments
1. `process`: The process to run as
2. `node`: The node to call on
3. `method`: The method to call
4. `...`: Any arguments to pass

### Return Values
Any return values from the method

## `uriSchemes`
Stores all URI scheme handlers using Lua patterns as keys.

### Fields
- `[https?]`:
- `[wss?]`:
- `[rednet]`:
- `[rednet%+%a+]`:
- `[psp]`:

