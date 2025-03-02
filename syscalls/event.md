---
layout: default
title: Event system
parent: System Calls
---

# Event system
The following syscalls are used in the event system, including events that can be sent to other processes.

## `kill(pid: number, signal: number)`
Sends a [signal](/docs/events.html#signals) to another process.

### Parameters
1. `pid`: The ID of the process to send to
2. `signal`: The signal ID to send

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The target process ID does not exist.
* The current user does not have permission to send a signal to the target.
  * The target process must be under the same user as the current one.
  * If the current process is running as root, it may send a signal to any process.

## `signal(signal: number, handler: function(signal: number))`
Registers a handler function to be called for a signal.

### Parameters
1. `signal`: The signal ID to register for.
2. `handler`: The handler function to call, which takes the signal ID as its only argument.

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw errors.

## `queueEvent(name: string, params: table)`
Queues an arbitrary event to be sent back to the current process.

### Parameters
1. `name`: The name of the event to send.
2. `params`: The parameter list to send in the event.

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw errors.

## `peekEvent(): (string, table) | nil`
Returns the next event in the queue if present, without removing it from the queue.

### Parameters
This syscall does not take any parameters.

### Return Values
The next event name and parameter table, or `nil` if no event is in the queue.

### Errors
This syscall does not throw errors.

## `sendEvent(pid: number, name: string, params: any)`
Queues a [remote event](/docs/events.html#remote-events) to be sent to another process.

### Parameters
1. `pid`: The ID of the process to send to.
2. `name`: The name of the remote event to send.
3. `params`: The data to send with the event.

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw errors.

## `timer(timeout: number): number`
Sets a timer that will send a `timer` event after the specified number of seconds.

### Parameters
1. `timeout`: The amount of time to set the timer for.

### Return Values
The ID of the new timer created.

### Errors
This syscall does not throw errors.

## `alarm(timeout: number): number`
Sets an alarm that will send an `alarm` event at the specified time.

### Parameters
1. `timeout`: The time to set the alarm to.

### Return Values
The ID of the new alarm created.

### Errors
This syscall does not throw errors.

## `cancel(tm: number)`
Cancels a previously set timer or alarm.

### Parameters
1. `tm`: The ID of the timer or alarm to cancel.

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw errors.