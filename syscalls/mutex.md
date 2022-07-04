---
layout: default
title: Mutexes & atomics
parent: System Calls
---

# Mutexes & atomics
These syscalls are related to synchronization primitives provided by the system. The object types used here are not constructed in the kernel - instead, a usermode library creates objects with a suitable format, which involves setting the `__name` metafield to the type name, and adding the required fields to the table. Mutexes require no fields by default (but may use `owner` and `recursive`), and semaphores require a `count` field with the number of resources available.

## `lockmutex(mtx: mutex)`
Locks the specified mutex, waiting for the resource to be freed before claiming it.

### Arguments
1. `mtx`: The mutex to lock.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The mutex is already claimed by the current thread and is not recursive.

## `timelockmutex(mtx: mutex, timeout: number): boolean`
Locks the specified mutex, waiting for the resource to be freed before claiming it. If the mutex isn't unlocked after the specified timeout, the syscall returns without locking.

### Arguments
1. `mtx`: The mutex to lock.
2. `timeout`: The amount of time to wait in seconds.

### Return Values
Whether the mutex could be locked.

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

## `acquiresemaphore(sem: semaphore)`
Acquires a resource from a semaphore object, waiting if none are available.

### Arguments
1. `sem`: The semaphore to acquire.

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw any errors.

## `timeacquiresemaphore(sem: semaphore, timeout: number): boolean`
Acquires a resource from a semaphore object, waiting if none are available, until the specified timeout passes.

### Arguments
1. `sem`: The semaphore to acquire.
2. `timeout`: The amount of time to wait in seconds.

### Return Values
Whether a resource was successfully acquired.

### Errors
This syscall does not throw any errors.

## `releasesemaphore(sem: semaphore)`
Releases a resource from a semaphore. This is a guaranteed atomic alternative to `sem.count = sem.count + 1`, and should be preferred.

### Arguments
1. `sem`: The semaphore to release.

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw any errors.