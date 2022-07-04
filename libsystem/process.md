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

## `exec(path: string, ...: any)`
Replaces the current process with the contents of the specified file.
 This function does not return - it can only throw an error.

### Arguments
1. `path`: The path to the file to execute.
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

## `run(path: string, ...: any): true, any / false, string`
Runs a program from the specified path in a new process, waiting until it completes.

### Arguments
1. `path`: The path to the file to execute
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

