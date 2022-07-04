---
layout: default
title: system.sync
parent: libsystem
---

# system.sync
The sync library exposes interfaces for various synchronization structures.

# Class mutex
A mutex is an object that controls access to a variable across multiple threads.
 It ensures only one thread accesses a resource at a time by blocking other
 threads from locking the mutex until the current thread unlocks it.

## `sync.mutex.new(recursive: boolean?): mutex`
Creates a new mutex.

### Arguments
1. `recursive`: Whether to make the mutex recursive (optional)

### Return Values
The new mutex object

## `sync.mutex:lock()`
Locks the mutex, waiting if it's currently owned by another thread.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

## `sync.mutex:unlock()`
Unlocks the mutex.  This is only valid from the thread that owns the lock.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

## `sync.mutex:tryLock(): boolean`
Tries to lock the thread, returning false if it could not be locked.

### Arguments
This function does not take any arguments.

### Return Values
Whether the mutex is now locked

## `sync.mutex:tryLockFor(timeout: number): boolean`
Locks the mutex, waiting until it's unlocked or until the specified timeout.

### Arguments
1. `timeout`: The number of seconds to wait

### Return Values
Whether the mutex is now locked

# Class semaphore
A semaphore controls access to a limited number of resources.  A function may
 acquire a resource from the semaphore, decrementing its available count. If
 the count is zero, it waits until another function releases a resource, at
 which point it will acquire it and return.

## `sync.semaphore.new([init: number = 1]): semaphore`
Creates a new semaphore.

### Arguments
1. `init`: The initial count of the semaphore (defaults to 1)

### Return Values
The new semaphore object

## `sync.semaphore:acquire()`
Acquires a resource from the semaphore, waiting until there is one available.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

## `sync.semaphore:tryAcquireFor(timeout: number): boolean`
Acquires a resource from the semaphore, waiting until there is one available or until a timeout.

### Arguments
1. `timeout`: The number of seconds to wait

### Return Values
Whether the resource was acquired

## `sync.semaphore:release()`
Releases a resource to the semaphore.  This can be called from any thread.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

# Class conditionVariable
A condition variable allows threads to wait until another thread notifies
 them to resume.

## `sync.conditionVariable.new(): conditionVariable`
Creates a new condition variable.

### Arguments
This function does not take any arguments.

### Return Values
The new condition variable.

## `sync.conditionVariable:wait()`
Waits for a notification from another thread.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

## `sync.conditionVariable:waitFor(timeout: number): boolean`
Waits for a notification from another thread, or until a timeout occurs.

### Arguments
1. `timeout`: The number of seconds to wait

### Return Values
Whether a notification occurred

## `sync.conditionVariable:notifyOne()`
Notifies a single (unspecified) thread to continue.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

## `sync.conditionVariable:notifyAll()`
Notifies all waiting threads to continue.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

# Class barrier
A barrier is a lock that waits for a specific number of threads to wait on
 the object, at which point all threads will be released together.

## `sync.barrier.new(count: number): barrier`
Creates a new barrier object.

### Arguments
1. `count`: The number of threads to wait for

### Return Values
A new barrier object

## `sync.barrier:wait(): boolean`
Adds one to the thread wait count, and waits until it meets the limit.

### Arguments
This function does not take any arguments.

### Return Values
Whether this call directly resulted in the barrier being met

# Class rwlock
A readers-writer lock implements two related locks: a read lock, which can
 be held by multiple threads, and a write lock, which can only be held by one
 thread.  Multiple threads can hold a read lock, but a write lock blocks both
 read and write locks.

## `sync.rwLock.new(): rwlock`
Creates a new RW lock.

### Arguments
This function does not take any arguments.

### Return Values
The new RW lock

## `sync.rwLock:lockRead()`
Acquires the lock for reading, waiting for the write lock to be released first.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

## `sync.rwLock:unlockRead()`
Releases the lock for reading.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

## `sync.rwLock:lockWrite()`
Acquires the lock for writing, waiting for the read and write locks to be released.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

## `sync.rwLock:unlockWrite()`
Releases the lock for writing.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

## `rwlock:lockGuard(mutex: mutex, fn: function, ...: any): any...`
Calls a function, ensuring that the mutex is locked before calling and unlocked
 after calling, even if the function returns early or throws an error.

### Arguments
1. `mutex`: The mutex to lock
2. `fn`: The function to call
3. `...`: Any parameters to pass

### Return Values
The return values from the function

