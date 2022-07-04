---
layout: default
title: system.ipc
parent: libsystem
---

# system.ipc
The IPC module provides functions for sending messages to other processes.

## `kill(pid: number, signal: number)`
Sends a basic signal to a process.

### Arguments
1. `pid`: The PID of the process to send to
2. `signal`: The signal to send to the process

### Return Values
This function does not return anything.

## `sigaction(signal: number, fn: function|nil)`
Sets the handler for a signal.

### Arguments
1. `signal`: The signal to modify
2. `fn`: The function to call, or `nil` to remove

### Return Values
This function does not return anything.

## `sendEvent(pid: number, event: string, param: table): boolean`
Sends a remote event to a process.

### Arguments
1. `pid`: The PID of the process to send to
2. `event`: The event name to send
3. `param`: The parameter table to send with the event

### Return Values
Whether the event was sent

## `register(name: string): boolean`
Registers the current process as the receiver of a service name.

### Arguments
1. `name`: The service name to register for

### Return Values
Whether the service was registered

## `lookup(name: string): number|nil`
Returns the ID of the process that receives a service name.

### Arguments
1. `name`: The service to lookup

### Return Values
The PID of the process that owns it (if available)

## `sendServiceEvent(name: string, event: string, param: table): boolean`
Sends an event to the owner of a service.

### Arguments
1. `name`: The service to send to
2. `event`: The event name to send
3. `param`: The parameter table to send with the event

### Return Values
Whether the event was sent

## `receiveEvent(pid: number?, event: string?, timeout: number?): string, table / nil`
Waits for a remote event, filtering for processes or event names, with an optional timeout.

### Arguments
1. `pid`: The PID to wait for an event from (optional)
2. `event`: The event to filter for (optional)
3. `timeout`: The maximum number of seconds to wait for (optional)

### Return Values
This function may return the following values:
1. The event name received
2. The parameters for the event

Or:
1. If the function timed out

## `signal`
Constants for signal numbers

### Fields
- `SIGHUP`:
- `SIGINT`:
- `SIGQUIT`:
- `SIGTRAP`:
- `SIGABRT`:
- `SIGKILL`:
- `SIGPIPE`:
- `SIGTERM`:
- `SIGCONT`:
- `SIGSTOP`:
- `SIGTTIN`:
- `SIGTTOU`:

