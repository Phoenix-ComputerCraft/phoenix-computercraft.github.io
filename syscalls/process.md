---
layout: default
title: Process and thread management
parent: System Calls
---

# Process and thread management
These syscalls are related to the system's process manager.

## `getpid(): number`
Returns the process ID (PID) of the current process.

### Arguments
This syscall does not take any arguments.

### Return Values
The process's ID.

### Errors
This syscall does not throw errors.

## `getppid(): number`
Returns the PID of the parent process.

### Arguments
This syscall does not take any arguments.

### Return Values
The parent process's ID.

### Errors
This syscall does not throw errors.

## `clock(): number`
Returns the total amount of time used by the current process.

### Arguments
This syscall does not take any arguments.

### Return Values
The amount of time used by the current process, in milliseconds.

### Errors
This syscall does not throw errors.

## `getenv(): table`
Returns the environment variable table for the current process.

### Arguments
This syscall does not take any arguments.

### Return Values
The environment variable table of the process.

### Errors
This syscall does not throw errors.

## `getfenv(): table`
Returns the environment table for the current process.

### Arguments
This syscall does not take any arguments.

### Return Values
The environment table of the process.

### Errors
This syscall does not throw errors.

## `getname(): string`
Returns the name of the current process.

### Arguments
This syscall does not take any arguments.

### Return Values
The name of the process.

### Errors
This syscall does not throw errors.

## `getcwd(): string`
Returns the current working directory of the current process.

### Arguments
This syscall does not take any arguments.

### Return Values
The current directory of the process.

### Errors
This syscall does not throw errors.

## `chdir(dir: string): boolean, string?`
Changes the current working directory.

### Arguments
1. `dir`: The directory to change to, which may be relative to the current directory or absolute.

### Return Values
`true` if the command succeeded, or `false` + an error message if it did not.

### Errors
This syscall does not throw errors.

## `getuser(): string, string?`
Returns the user for the current process.

### Arguments
This syscall does not take any arguments.

### Return Values
The user of the current process, plus the previous user if the current user was set using the `setuser` bit.

### Errors
This syscall does not throw errors.

## `setuser(user: string)`
Sets the user for the current process. This requires root permissions.

### Arguments
1. `user`: The new user to switch to

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The current process is not root.

## `fork(func: function, name: string?, args...: any): number`
Creates a new process that calls the specified function.

### Arguments
1. `func`: The function to call. This is the entrypoint of the new process.
2. `name`: The name of the new process. Defaults to the name of the current process.
3. `args...`: Any arguments to pass to the function on first run.

### Return Values
The PID of the newly created process.

### Errors
This syscall does not throw errors.

## `exec(path: string, args...: any): never`
Replaces the current process with the specified Lua script, keeping all process info intact.

### Arguments
1. `path`: The path to the file to run.
2. `args...`: Any arguments to pass to the program.

### Return Values
This syscall does not return.

### Errors
This syscall may throw an error if:
* The file could not be opened.
* The file contains a recursive shebang entry.
* An error occurred while loading the file.

## `newthread(func: function, args...: any): number`
Creates a new thread that calls the specified function. A thread uses the same environment table as other threads in the process, while different processes have different environments.

### Arguments
1. `func`: The function to call. This is the entrypoint of the new thread.
2. `args...`: Any arguments to pass to the function on first run.

### Return Values
The ID of the newly created thread.

### Errors
This syscall does not throw errors.

## `exit(code: number?): never`
Exits the current process with the specified exit code.

### Arguments
1. `code`: The exit code for the process. Defaults to `0`.

### Return Values
This syscall does not return.

### Errors
This syscall does not throw errors.

## `getplist(): table`
Returns a list of all currently active process IDs.

### Arguments
This syscall does not take any arguments.

### Return Values
A sorted list of all process IDs that are currently running.

### Errors
This syscall does not throw errors.

## `getpinfo(pid: number): table | nil, string`
Returns a table with information about a process.

### Arguments
1. `pid`: The ID of the process to query.

### Return Values
A table with the following fields:
* `id`: The ID of the process
* `name`: The name of the process
* `user`: The user of the process
* `parent`: The ID of the parent process, if available
* `dir`: The working directory of the process
* `stdin`: The ID of the TTY the standard input is attached to, if available
* `stdout`: The ID of the TTY the standard output is attached to, if available
* `stderr`: The ID of the TTY the standard error is attached to, if available
* `cputime`: The total time spent by the process, in seconds
* `systime`: The total time spent by syscalls triggered by the process, in seconds
* `threads`: A sparse list of thread information with the following fields:
  * `id`: The ID of the thread
  * `name`: The name of the thread
  * `status`: The status of the thread

If the information could not be read, the syscall will return `nil` + an error message.

### Errors
This syscall does not throw errors.

## `nice(level: number[, pid: number])`
Sets the niceness level of the specified process, or the current one if left unspecified. Nice values cause the process to run longer with a lower number (requires root), or shorter with a higher number. Values range from -20 to 20.

### Arguments
1. `level`: The niceness level to set
2. `pid`: The ID of the process to modify (defaults to the current one)

### Return Values
This syscall does not return anything.

### Errors
This syscall may error if:
* The process ID does not exist.
* The user does not have permission to modify the selected process.
* The user tries to set a negative niceness level and is not `root`.

## `atexit(fn: function)`
Calls a function when the process exits. This function is run in a new temporary thread, and is run outside of the scheduler - no other processes or threads will run until this function ends. Due to this, the function is time-limited, and inter-process communication will not be possible, so only use this for last-minute tasks inside the process.

### Arguments
1. `fn`: The function to run

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw any errors.

## `debug_enable(pid: number|nil, enabled: boolean)`
Enables or disables debugging for the specified process. If `pid` is `nil`, it will set whether other processes can debug this one. In other words, calling `debug_enable(nil, false)` will disable any form of debugging on the current program, even by root.

### Arguments
1. `pid`: The process ID to operate on
2. `enabled`: Whether to enable debugging

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
- The specified process ID does not exist.
- The process has disabled debugging itself.
- The process is not owned by the current user, unless the caller is root.

## `debug_break(pid: number|nil, thread: number|nil)`
Pauses the specified thread, or all threads if none is specified, in the target process. This will trigger a `debug_break` event in the calling process for each thread that was paused as a result of this syscall.

If `pid` is `nil`, then this syscall operates differently: it will pause the current thread (regardless of the `thread` parameter), and sends a `debug_break` event to the last process that called `debug_enable` on this process. If debugging is not enabled, then this syscall is a no-op, allowing for programs to break to a debugger only if one is enabled.

### Arguments
1. `pid`: The process ID to pause, or `nil` to pause the current process
2. `thread`: The thread to pause, or `nil` to pause all threads

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
- The specified process ID does not exist.
- The process does not have debugging enabled, unless `pid` is `nil`.
- The process is not owned by the current user, unless the caller is root.
- The thread specified (if any) does not exist.

## `debug_continue(pid: number, thread: number|nil)`
Continues a paused thread, or all threads if none is specified.

### Arguments
1. `pid`: The process ID to unpause
2. `thread`: The thread to unpause, or `nil` to unpause all threads

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
- The specified process ID does not exist.
- The process does not have debugging enabled.
- The process is not owned by the current user, unless the caller is root.
- The thread specified (if any) does not exist.

## `debug_setbreakpoint(pid: number, thread: number|nil, type: string|number, filter: table?): number`
Sets a breakpoint for the specified process, optionally filtering by thread. When a breakpoint is hit in the target process, the thread (or all threads if none is specified) is paused, and a `debug_break` event is queued in the process that set the breakpoint.

The type can be one of these values:
- `call`: Break on a function call
- `return`: Break on a function return
- `line`: Break when execution changes lines
- `error`: Break when an error is thrown
- `resume`: Break when a coroutine is resumed
- `yield`: Break when a coroutine yields (not including preemption)
- `syscall`: Break when the process executes a system call
  - For this case, the filter argument will only respect the `name` field (for syscall name)
- Any number: Break after this number of VM instructions

The filter contains entries from a `debug.getinfo` table to match before breaking. The breakpoint will only be triggered if all provided filters match.

This example shows how to set a breakpoint on a specific line of a file, and then wait for the breakpoint to be hit:

```lua
local bp = syscall.debug_setbreakpoint(processID, nil, "line", {
    source = "@/home/user/program.lua",
    currentline = 11
})
repeat
    local event, param = coroutine.yield()
until event == "debug_break" and param.breakpoint == bp
```

### Arguments
1. `pid`: The process ID to set the breakpoint on
2. `thread`: The thread to set the breakpoint on (or `nil` for any thread)
3. `type`: The type of breakpoint to set
4. `filter`: A filter to set on the breakpoint (see above)

### Return Values
The ID of the new breakpoint.

### Errors
This syscall may throw an error if:
- The specified process ID does not exist.
- The process does not have debugging enabled.
- The process is not owned by the current user, unless the caller is root.

## `debug_unsetbreakpoint(pid: number, breakpoint: number)`
Unsets a previously set breakpoint.

### Arguments
1. `pid`: The process ID to operate on
2. `breakpoint`: The ID of the breakpoint to remove

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
- The specified process ID does not exist.
- The process does not have debugging enabled.
- The process is not owned by the current user, unless the caller is root.

## `debug_listbreakpoints(pid: number): table[]`
Returns a list of currently set breakpoints. Each entry has a `type` field, as well as an optional `thread` field, and any filter items passed to `debug_setbreakpoint`.

### Arguments
1. `pid`: The process ID to check

### Return Values
A list of currently set breakpoints. This table may have holes in it if some breakpoints were unset!

### Errors
This syscall may throw an error if:
- The specified process ID does not exist.
- The process does not have debugging enabled.
- The process is not owned by the current user, unless the caller is root.

## `debug_getinfo(pid: number, thread: number, level: number, what: string?): table`
Calls `debug.getinfo` on the specified thread in another process. Debugging must be enabled for the target process, and the target thread must be paused.

### Arguments
1. `pid`: The process ID to operate on
2. `thread`: The thread ID to operate on
3. `level`: The level in the call stack to get info for
4. `what`: A string with the info to extract, or `nil` for all

### Return Values
Returns the same info as `debug.getinfo`.

### Errors
This syscall may throw an error if:
- The specified process ID does not exist.
- The process does not have debugging enabled.
- The process is not owned by the current user, unless the caller is root.
- The thread is not currently paused.

## `debug_getlocal(pid: number, thread: number, level: number, n: number): string?, any?`
Calls `debug.getlocal` on the specified thread in another process. Debugging must be enabled for the target process, and the target thread must be paused.

### Arguments
1. `pid`: The process ID to operate on
2. `thread`: The thread ID to operate on
3. `level`: The level in the call stack to get info for
4. `n`: The index of the local to select

### Return Values
Returns the same info as `debug.getlocal`.

### Errors
This syscall may throw an error if:
- The specified process ID does not exist.
- The process does not have debugging enabled.
- The process is not owned by the current user, unless the caller is root.
- The thread is not currently paused.
- The selected level is out of range.

## `debug_getupvalue(pid: number, thread: number, level: number, n: number): string?, any?`
Calls `debug.getupvalue` on the specified thread in another process. Debugging must be enabled for the target process, and the target thread must be paused.

### Arguments
1. `pid`: The process ID to operate on
2. `thread`: The thread ID to operate on
3. `level`: The level in the call stack to get info for
4. `n`: The index of the upvalue to select

### Return Values
Returns the same info as `debug.getupvalue`.

### Errors
This syscall may throw an error if:
- The specified process ID does not exist.
- The process does not have debugging enabled.
- The process is not owned by the current user, unless the caller is root.
- The thread is not currently paused.

## `debug_exec(pid: number, thread: number, fn: function)`
Calls a user-specified function in the specified thread in another process asynchronously. Debugging must be enabled for the target process, and the target thread must be paused. The environment for the function will be set to the environment of the process. The result of the function call will be passed in a `debug_exec_result` event. Note that the function runs under the hook environment, and thus will not be preempted - avoid long-running tasks in this environment. (This may be fixed in the future!)

### Arguments
1. `pid`: The process ID to operate on
2. `thread`: The thread ID to operate on
3. `fn`: The function to call

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
- The specified process ID does not exist.
- The process does not have debugging enabled.
- The process is not owned by the current user, unless the caller is root.
- The thread is not currently paused.
