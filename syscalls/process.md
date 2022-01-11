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

## `exec(path: string, args...: any): number`
Creates a new process that runs the specified program.

### Arguments
1. `path`: The path to the file to run.
2. `args...`: Any arguments to pass to the program.

### Return Values
The PID of the newly created process.

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

## `exit(code: number?)`
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
This syscall does not throw errors