---
layout: default
title: Mutexes & atomics
parent: System Calls
---

# Mutexes & atomics
These syscalls are related to synchronization primitives provided by the system.

## `newmutex(recursive: boolean?): mutex`
Creates a new mutex object.

### Arguments
1. `recursive`: Whether the mutex should be recursive (be able to be locked multiple times).

### Return Values
A new mutex object. The mutex class has the methods `lock()`, `unlock()`, and `try_lock()`, which just call the syscalls below.

### Errors
This syscall does not throw errors.

## `lockmutex(mtx: mutex)`
Locks the specified mutex, waiting for the resource to be freed before claiming it.

### Arguments
1. `mtx`: The mutex to lock.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The mutex is already claimed by the current thread and is not recursive.

## `unlockmutex(mtx: mutex)`
Unlocks the specified mutex.

### Arguments
1. `mtx`: The mutex to unlock.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The mutex is already unlocked.
* The mutex is currently locked by a different thread.

## `trylockmutex(mtx: mutex): boolean`
Attempts to lock the mutex, returning immediately if the mutex could not be locked.

### Arguments
1. `mtx`: The mutex to lock.

### Return Values
Whether the mutex could be locked.

### Errors
This syscall may throw an error if:
* The mutex is already claimed by the current thread and is not recursive.