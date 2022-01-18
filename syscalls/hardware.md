---
layout: default
title: Hardware interfaces
parent: System Calls
---

# Hardware interfaces
These syscalls provide interfaces for interacting with the hardware (including drivers), as well as some miscellaneous functionality to interact with the physical computer.

## `shutdown()`
Shuts down the computer.

### Arguments
This syscall does not take any arguments.

### Return Values
This syscall only returns `false` if the current user isn't root. Otherwise, it does not return.

### Errors
This syscall does not throw any errors.

## `reboot()`
Reboots the computer.

### Arguments
This syscall does not take any arguments.

### Return Values
This syscall only returns `false` if the current user isn't root. Otherwise, it does not return.

### Errors
This syscall does not throw any errors.

## `computerid(): number`
Returns the computer's ID.

### Arguments
This syscall does not take any arguments.

### Return Values
The physical ID of the computer.

### Errors
This syscall does not throw any errors.

## `gethostname(): string`
Returns the computer's label.

### Arguments
This syscall does not take any arguments.

### Return Values
The label of the computer.

### Errors
This syscall does not throw any errors.

## `sethostname(name: string)`
Sets the computer's label.

### Arguments
1. `name`: The new label for the computer

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw any errors.

## `version(buildnum: boolean?): string`
Returns the Phoenix version or build number.

### Arguments
1. `buildnum`: `true` to return the minor build string/information, `false` to return the version number

## `cchost(): string`
Returns the value of the `_HOST` variable.

### Arguments
This syscall does not take any arguments.

### Return Values
The value of `_HOST`, which is in the format `ComputerCraft [0-9%.]+ %b()`.

### Errors
This syscall does not throw any errors.