---
layout: default
title: system.hardware
parent: libsystem
---

# system.hardware
The hardware module implements functions for operating on peripherals and
 other hardware devices.

## `wrap(device: string): device`
Wraps a device into an indexable object, allowing accessing properties and
 methods of the device by indexing the table.
 If an object is passed, this simply re-wraps the device in a new object.

### Arguments
1. `device`: The device specifier or object to wrap

### Return Values
The wrapped device

## `find(type: string): device...`
Returns a list of wrapped devices that implement the specified type.

### Arguments
1. `type`: The type to search for

### Return Values
The devices found, or `nil` if none were found

## `path(device: string|device): string...`
Returns a list of device paths that match the device specifier or object.
 If an absolute path is specified, this returns the same path back.
 If a device object is specified, this returns the path to the device.

### Arguments
1. `device`: The device specifier or object to read

### Return Values
The paths that match the specifier or device object.

## `hasType(device: string|device, type: string): boolean`
Returns whether the device implements the specified type.

### Arguments
1. `device`: The device specifier or object to query
2. `type`: The type to check for

### Return Values
Whether the device implements the type

## `info(device: string|device): HWInfo|nil`
Returns a table of information about the specified device.

### Arguments
1. `device`: The device specifier or object to query

### Return Values
The hardware info table, or `nil` if no device was found

## `methods(device: string|device): {string...}`
Returns a list of methods implemented by this device.

### Arguments
1. `device`: The device specifier or object to query

### Return Values
The methods available to call on this device

## `properties(device: string|device): {string...}`
Returns a list of properties implemented by this device.

### Arguments
1. `device`: The device specifier or object to query

### Return Values
The properties available on this device

## `children(device: string|device): {string...}`
Returns a list of children of this device.

### Arguments
1. `device`: The device specifier or object to query

### Return Values
The names of children of the device

## `call(device: string|device, method: string, ...: any): any...`
Calls a method on a device.

### Arguments
1. `device`: The device specifier or object to call on
2. `method`: The method to call
3. `...`: Any arguments to pass to the method

### Return Values
The return values from the method

## `listen(device: string|device[, state: boolean = true])`
Toggles whether this process should receive events from the device.

### Arguments
1. `device`: The device specifier or object to modify
2. `state`: Whether to allow events (defaults to true)

### Return Values
This function does not return anything.

## `lock(device: string|device[, wait: boolean = true]): boolean`
Locks the device from being called on or listened to by other processes.

### Arguments
1. `device`: The device specifier or object to modify
2. `wait`: Whether to wait for the device to unlock if
 it's currently locked by another process (defaults to true)

### Return Values
Whether the current process now owns the lock

## `unlock(device: string|device)`
Unlocks the device after previously locking it.

### Arguments
1. `device`: The device specifier or object to modify

### Return Values
This function does not return anything.

## `tree`
A table that allows accessing device object pointers in a tree.  This is
 simply syntax sugar for real paths.

### Fields
This function does not take any arguments.

