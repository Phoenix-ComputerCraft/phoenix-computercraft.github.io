---
layout: default
title: Kernel modules
parent: System Calls
---

# Kernel modules
These syscalls are used to load, unload, and interact with kernel modules.

## `listmodules(): [string]`
Returns a list of currently loaded kernel module names.

### Arguments
This syscall does not take any arguments.

### Return Values
A list of currently loaded kernel module names.

### Errors
This syscall does not throw any errors.

## `loadmodule(path: string)`
Attempts to load a kernel module into memory. This syscall requires root.

### Arguments
1. `path`: The path to the module to load.

### Return Values
This syscall does not return anything

### Errors
This syscall may throw an error if:
* The user is not root.
* The path refers to a directory.
* The module is either not owned by root or world-writable.

## `unloadmodule(name: string)`
Unloads a kernel module from memory. This syscall requires root.

### Arguments
1. `name`: The name of the module to unload

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The user is not root.

## `callmodule(name: string, func: string, args...: any): any...`
Calls a function on a kernel module, if the module exposes an API.

### Arguments
1. `name`: The name of the module to call on
2. `func`: The name of the function to call
3. `args...`: Any arguments to pass to the function

### Return Values
Any values returned from the function call.

### Errors
This syscall may throw an error if:
* The module requested is not loaded.
* The module does not have an exported API.
* The module does not have the requested function.
* The function throws an error.
