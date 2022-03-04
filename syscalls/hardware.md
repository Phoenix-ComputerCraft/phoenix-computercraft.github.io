---
layout: default
title: Hardware interfaces
parent: System Calls
---

# Hardware interfaces
These syscalls provide interfaces for interacting with the hardware (including drivers), as well as some miscellaneous functionality to interact with the physical computer.

## `devlookup(name: string): string...`
Returns all paths to devices that have the specified node name.

### Arguments
1. `name`: The device name to search for

### Return Values
The path to each node in the device tree that has the specified name.

### Errors
This syscall does not throw any errors.

## `devinfo(device: string): table?`
Returns a table with information describing a device node.

### Arguments
1. `device`: The device path or UUID to look up

### Return Values
A table with the following information:
```ts
type HWInfo = {
    id: string,                // Device hardware ID
    uuid: string,              // Assigned UUID
    parent: string,            // Path to parent device
    displayName: string,       // Display name for users
    types: {[string]: string}, // Types of devices implemented: type = driver name
    metadata: Object           // Opaque metadata for driver use
}
```
If the device does not exist, this returns `nil`.

### Errors
This syscall does not throw any errors.

## `devmethods(device: string): [string]`
Returns a list of methods that can be called on this device.

### Arguments
1. `device`: The device path or UUID to look up

### Return Values
A list of valid methods that can be called.

### Errors
This syscall may throw an error if:
* The specified device does not exist.

## `devproperties(device: string): [string]`
Returns a list of properties on the device.

Properties are intended for use by wrapper APIs (such as `libsystem.hardware`), and specify an alternate name for a corresponding `get<Property>` method. To retrieve the property, capitalize the first character of the property name, prepend `get` to the name, and call that method on the device with no arguments. To set the property, first check for a `set<Property>` method in the same format as `get`, then call that method with one argument (the new value). If no `set` method is available, then that property is read-only.

### Arguments
1. `device`: The device path or UUID to look up

### Return Values
A list of properties that are available. This table may be empty.

### Errors
This syscall may throw an error if:
* The specified device does not exist.

## `devchildren(device: string): [string]`
Returns a list of names of all children of the current device. 

### Arguments
1. `device`: The device path or UUID to look up

### Return Values
A list of child names, in an unspecified order. This table may be empty.

### Errors
This syscall may throw an error if:
* The specified device does not exist.

## `devcall(device: string, method: string, ...: any): any...`
Calls the specified method on the device with arguments.

### Arguments
1. `device`: The device path or UUID to operate on
2. `method`: The name of the method to call
3. `...`: Any arguments to pass to the method

### Return Values
All values returned from the method.

### Errors
This syscall may throw an error if:
* The specified device does not exist.
* Another process has locked this device.
* The specified method does not exist on the device.
* The method threw an error while executing.

## `devlisten(device: string, state: boolean = true)`
Enables (or disables) listening for events from this device.

### Arguments
1. `device`: The device path or UUID to operate on
2. `state`: `true` to allow events to be passed to this process; `false` to stop events from being sent

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The specified device does not exist.

## `devlock(device: string, wait: boolean = true): boolean`
Locks the specified device to this process. This prevents any calls to the device from other processes, and will suppress events from being sent to other processes. If the current process already owns the lock, this syscall returns `true` immediately. (It does not act like a recursive mutex in this case - only one unlock is required no matter how many times it's locked.)

### Arguments
1. `device`: The device path or UUID to operate on
2. `wait`: `true` to wait for the lock to be released before returning; `false` to return immediately if the lock is already owned by another process

### Return Values
`true` if the current process now owns the lock; `false` otherwise.

### Errors
This syscall may throw an error if:
* The specified device does not exist.

## `devunlock(device: string)`
Unlocks the specified device, allowing access to the device in other processes. This syscall does nothing if the device is not locked.

### Arguments
1. `device`: The device path or UUID to operate on

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The specified device does not exist.
* Another process has locked this device.

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