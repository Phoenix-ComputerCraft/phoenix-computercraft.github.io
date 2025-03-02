---
layout: default
title: system.process
parent: libsystem
---

# system.process
The process module allows querying various properties about the current
 process, as well as creating, modifying, and searching other processes.

## `getpid(): number`
Returns the process ID of the current process.

### Arguments
This function does not take any arguments.

### Return Values
The process ID of the current process

## `getppid(): number`
Returns the process ID of the parent process, if available.

### Arguments
This function does not take any arguments.

### Return Values
The process ID of the parent process, if available

## `getuser(): string`
Returns the username the process is running under.

### Arguments
This function does not take any arguments.

### Return Values
The username the process is running under

## `setuser(user: string)`
Sets the user of the current process.  This can only be run by root.

### Arguments
1. `user`: The user to switch to

### Return Values
This function does not return anything.

## `clock(): number`
Returns the amount of time this process has executed.  This may not be
 entirely accurate due to a lack of precision in the system clock.

### Arguments
This function does not take any arguments.

### Return Values
The amount of time this process has executed

## `getenv(): table`
Returns the environment variable table for the current process.

### Arguments
This function does not take any arguments.

### Return Values
The environment variable table for the current process

## `getfenv(): table`
Returns the environment table for the current process.

### Arguments
This function does not take any arguments.

### Return Values
The environment table for the current process

## `getname(): string`
Returns the name of the current process.

### Arguments
This function does not take any arguments.

### Return Values
The name of the current process

## `getcwd(): string`
Returns the working directory of the current process.

### Arguments
This function does not take any arguments.

### Return Values
The working directory of the current process

## `chdir(dir: string)`
Sets the working directory of the current process.

### Arguments
1. `dir`: The new working directory, which must be absolute and existent.

### Return Values
This function does not return anything.

## `fork(func: function, name: string, ...: any): number`
Creates a new process running the specified function with arguments.

### Arguments
1. `func`: The function to run in the new process. This will be the
 main function of the first thread, and will have its environment set to the
 new process's environment.
2. `name`: ? The name of the new process.
3. `...`: Any arguments to pass to the function.

### Return Values
The PID of the new process.

## `forkbg(func: function, name: string, ...: any): number`
Creates a new process running the specified function with arguments.  This
 process will be placed in the background, meaning it has no stdin/out.

### Arguments
1. `func`: The function to run in the new process. This will be the
 main function of the first thread, and will have its environment set to the
 new process's environment.
2. `name`: ? The name of the new process.
3. `...`: Any arguments to pass to the function.

### Return Values
The PID of the new process.

## `exec(path: string, ...: any)`
Replaces the current process with the contents of the specified file.
 This function does not return - it can only throw an error.

### Arguments
1. `path`: The path to the file to execute.
2. `...`: Any arguments to pass to the file.

### Return Values
This function does not return anything.

## `execp(command: string, ...: any)`
Replaces the current process with the contents of the specified file or
 command, searching the PATH environment variable if necessary.
 This function does not return - it can only throw an error.

### Arguments
1. `command`: The command or file to execute.
2. `...`: Any arguments to pass to the file.

### Return Values
This function does not return anything.

## `start(path: string, ...: any): number`
Starts a new process from the specified path.

### Arguments
1. `path`: The path to the file to execute.
2. `...`: Any arguments to pass to the file.

### Return Values
The PID of the new process.

## `startbg(path: string, ...: any): number`
Starts a new process from the specified path.  This process will be placed in
 the background, meaning it has no stdin/out.

### Arguments
1. `path`: The path to the file to execute.
2. `...`: Any arguments to pass to the file.

### Return Values
The PID of the new process.

## `run(path: string, ...: any): true, any / false, string`
Runs a program from the specified path in a new process, waiting until it completes.

### Arguments
1. `path`: The command or file to execute
2. `...`: Any arguments to pass to the file

### Return Values
This function may return the following values:
1. When the process succeeded
2. The return value from the process

Or:
1. When the process errored
2. The error message from the process

## `newthread(func: function, ...: any): number`
Creates a new thread running the specified function with arguments.
 Threads in the same process share the same environment, event queue, and
 other properties.

### Arguments
1. `func`: The function to start
2. `...`: Any arguments to pass to the function

### Return Values
The ID of the new thread

## `exit(code: number)`
Ends the current process immediately, stopping all threads and sending the
 specified return value to the parent.  This function does not return.

### Arguments
1. `code`: ? The value to return.

### Return Values
This function does not return anything.

## `atexit(fn: function)`
Runs a function when the program exists.  This function will never get any
 events, and is time-limited to 100 syscalls due to running in a different
 context than normal threads - avoid passing long-running functions.
 Functions added here cannot be removed later, so if the function may not be
 needed after being added, use a variable check to disable it instead.

### Arguments
1. `fn`: The function to call at exit

### Return Values
This function does not return anything.

## `getplist(): table`
Returns a list of all valid PIDs.

### Arguments
This function does not take any arguments.

### Return Values
A list of all valid PIDs

## `getpinfo(pid: number): {id=number,name=string,user=string,parent?=number,dir=string,stdin?=number,stdout?=number,stderr?=number,cputime=number,systime=number,threads={[number]={id=number,name=string,status=string}}}|nil`
Returns a table with various information about the specified process.

### Arguments
1. `pid`: The process ID to query.

### Return Values
The process information, or nil if the process doesn't exist.

## `nice(level: number, pid: number?)`
Sets the niceness level of the specified process, or the current one if left
 unspecified.  Nice values cause the process to run longer with a lower number
 (requires root), or shorter with a higher number. Values range from -20 to 20.

### Arguments
1. `level`: The nice level to set to
2. `pid`: The process ID to modify (must be root or same user) (optional)

### Return Values
This function does not return anything.

# Debugging subsystem


## `process.debug.enable(pid: number, enabled: boolean)`
Enables or disables debugging for the specified process.  If `pid` is `nil`,
 it will set whether other processes can debug this one. In other words,
 calling `debug_enable(nil, false)` will disable any form of debugging on the
 current program, even by root.

### Arguments
1. `pid`: The process ID to operate on (`nil` for this process)
2. `enabled`: Whether to enable debugging

### Return Values
This function does not return anything.

## `process.debug.brk(pid: number, thread: number)`
Pauses the specified thread, or all threads if none is specified, in the
 target process.  This will trigger a `debug_break` event in the calling
 process for each thread that was paused as a result of this syscall.

 If `pid` is `nil`, then this syscall operates differently: it will pause the
 current thread (regardless of the `thread` parameter), and sends a
 `debug_break` event to the last process that called `debug_enable` on this
 process. If debugging is not enabled, then this syscall is a no-op, allowing
 for programs to break to a debugger only if one is enabled.

### Arguments
1. `pid`: The process ID to pause, or `nil` to pause the current process
2. `thread`: The thread to pause, or `nil` to pause all threads

### Return Values
This function does not return anything.

## `process.debug.continue(pid: number, thread: number)`
Continues a paused thread, or all threads if none is specified.

### Arguments
1. `pid`: The process ID to unpause
2. `thread`: The thread to unpause, or `nil` to unpause all threads

### Return Values
This function does not return anything.

## `process.debug.setbreakpoint(pid: number, thread: number, type: string|number, filter: table?): number`
Sets a breakpoint for the specified process, optionally filtering by thread.
 When a breakpoint is hit in the target process, the thread (or all threads if
 none is specified) is paused, and a `debug_break` event is queued in the
 process that set the breakpoint.

 The type can be one of these values:
 - `call`: Break on a function call
 - `return`: Break on a function return
 - `line`: Break when execution changes lines
 - `error`: Break when an error is thrown
 - `resume`: Break when a coroutine is resumed
 - `yield`: Break when a coroutine yields (not including preemption)
 - `syscall`: Break when the process executes a system call
   - For this case, the filter argument will only respect the `name` field
     (for syscall name)
 - Any number: Break after this number of VM instructions

 The filter contains entries from a `debug.getinfo` table to match before
 breaking. The breakpoint will only be triggered if all provided filters match.

### Arguments
1. `pid`: The process ID to set the breakpoint on
2. `thread`: The thread to set the breakpoint on (or `nil` for any thread)
3. `type`: The type of breakpoint to set
4. `filter`: A filter to set on the breakpoint (see above) (optional)

### Return Values
The ID of the new breakpoint

## `process.debug.unsetbreakpoint(pid: number, breakpoint: number)`
Unsets a previously set breakpoint.

### Arguments
1. `pid`: The process ID to operate on
2. `breakpoint`: The ID of the breakpoint to remove

### Return Values
This function does not return anything.

## `process.debug.listbreakpoints(pid: number): table[]`
Returns a list of currently set breakpoints.  Each entry has a `type` field,
 as well as an optional `thread` field, and any filter items passed to
 `debug_setbreakpoint`.

### Arguments
1. `pid`: The process ID to check

### Return Values
A list of currently set breakpoints. This table may have holes in it if some breakpoints were unset!

## `process.debug.getinfo(pid: number, thread: number, level: number, what: string?): table`
Calls `debug.getinfo` on the specified thread in another process.  Debugging
 must be enabled for the target process, and the target thread must be paused.

### Arguments
1. `pid`: The process ID to operate on
2. `thread`: The thread ID to operate on
3. `level`: The level in the call stack to get info for
4. `what`: A string with the info to extract, or `nil` for all (optional)

### Return Values
A table from `debug.getinfo`

## `process.debug.getlocal(pid: number, thread: number, level: number, n: number): string|nil, any`
Calls `debug.getlocal` on the specified thread in another process.  Debugging
 must be enabled for the target process, and the target thread must be paused.

### Arguments
1. `pid`: The process ID to operate on
2. `thread`: The thread ID to operate on
3. `level`: The level in the call stack to get info for
4. `n`: The index of the local to check

### Return Values
This function may return the following values:
1. The local name
2. The local value

## `process.debug.getupvalue(pid: number, thread: number, level: number, n: number): string|nil, any`
Calls `debug.getupvalue` on the specified thread in another process.  Debugging
 must be enabled for the target process, and the target thread must be paused.

### Arguments
1. `pid`: The process ID to operate on
2. `thread`: The thread ID to operate on
3. `level`: The level in the call stack to get info for
4. `n`: The index of the upvalue to check

### Return Values
This function may return the following values:
1. The upvalue name
2. The upvalue value

## `process.debug.exec(pid: number, thread: number, fn: function): `
Executes a function in the context of another process/thread.  Debugging must
 be enabled for the target process, and the target thread must be paused. The
 environment for the function will be set to the environment of the process.
 Note that the function runs under the hook environment, and thus will not be
 preempted - avoid long-running tasks in this environment. (This may be fixed
 in the future!)

### Arguments
1. `pid`: The process ID to operate on
2. `thread`: The thread ID to operate on
3. `fn`: The function to call

### Return Values
The values returned from the function

## `process.debug.execAsync(pid: number, thread: number, fn: function)`
Executes a function in the context of another process/thread asynchronously.
 Debugging must be enabled for the target process, and the target thread must
 be paused. The environment for the function will be set to the environment of
 the process. The result of the function call will be passed in a
 `debug_exec_result` event. Note that the function runs under the hook
 environment, and thus will not be preempted - avoid long-running tasks in
 this environment. (This may be fixed in the future!)

### Arguments
1. `pid`: The process ID to operate on
2. `thread`: The thread ID to operate on
3. `fn`: The function to call

### Return Values
This function does not return anything.

