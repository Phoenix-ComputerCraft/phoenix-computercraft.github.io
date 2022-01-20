---
layout: default
title: Coroutine boundary
parent: Documentation
---

# Coroutine boundary
All processes in the Phoenix kernel are implemented as separate coroutines. Each coroutine may yield for various reasons, so the first argument of any yield includes the type of yield requested. This page lists the types of yields that programs may trigger.

## (none)
If no argument is passed to `coroutine.yield`, the thread is put into a waiting state and will be resumed once an event is ready in the queue. Once an event is queued, or if there is one already in the queue, the thread will be resumed on the next loop of the process manager.

## `preempt`
A `preempt` yield is usually triggered automatically by the preemption hook installed by the kernel. This kind of yield has no purpose other than to pause the execution of the current process to allow other processes to continue. No arguments are taken, and no return values are given.

## `syscall <name: string> <arguments...: any>`
A `syscall` yield is triggered by a program requesting a [system call](../syscalls.html) from the kernel. When a `syscall` yield is found, the kernel will proceed to call the syscall named `name` with the specified arguments. The process will then be resumed, with a status boolean + the return values of the syscall as return values. The first return value is a boolean describing whether the syscall ran OK - if it threw an error, the yield will return `false` + the error message. Otherwise, the return values of the syscall function follow. Some syscalls, like `lockmutex`, yield for events internally. This means that the process or thread will not be resumed until the requested event occurs.