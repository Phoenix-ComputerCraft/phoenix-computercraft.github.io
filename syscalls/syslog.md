---
layout: default
title: System logger
parent: System Calls
---

# System logger
The following syscalls are used to interact with the built-in logging system.

## `syslog(options: table?, message...: any)`
Adds a message to the specified log stream, or the system log if not specified. This can be customized using the options table.

### Arguments
1. `options`: A table with options for the message. If this option slot contains a non-table value, it's assumed to be part of the message. This can contain:
    * `name: string`: The log to send to. Defaults to `default`, the system log.
    * `category: string`: A custom category name that may be used by listeners to filter certain messages.
    * `level: number|string`: A number indicating the log level of the message, from 0 to 6. Defaults to 1. This may also be a level name as listed below. The available level names are:
        <ol style="counter-set: sub-counter -1">
        <li>Debug</li>
        <li>Info</li>
        <li>Notice</li>
        <li>Warning</li>
        <li>Error</li>
        <li>Critical</li>
        <li>Panic (should not be used in normal applications - for kernel use only)</li>
        </ol>
        
    * `time: number`: The timestamp of the event, in milliseconds since the UNIX Epoch (UTC). Defaults to the current time.
    * `process: number`: The PID of the process that sent the message. Defaults to the PID of the calling process.
    * `thread: number`: The thread ID that sent the message. Defaults to none.
    * `module: string`: A custom module name that indicates what part of the program sent the message, for use by listeners for filtering.
    * `traceback: boolean`: If set to `true`, an automatic colorizer will be applied to format a stack trace.
2. `message...`: The contents of the message. Each option is serialized and concatenated with a space, so sending tables will show their contents.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The specified log does not exist.

## `mklog(name: string, streamed: boolean?, path: string?)`
Creates a new log with the specified name, and selects whether to stream it or write it to a file.

### Arguments
1. `name`: The name of the log.
2. `streamed`: Whether to stream the log and allow other processes to connect.
3. `path`: The path to the file to write to, or `nil` to not write to a file.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The current user is not the root user.
* The log already exists.
* The log file could not be opened.

## `rmlog(name: string)`
Removes a log previously created with `mklog`.

### Arguments
1. `name`: The name of the log to remove.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The current user is not the root user.
* The log does not exist.
* The log name is `default`.

## `openlog(name: string, filter: string?): number`
Opens a log for streaming into the current process, with the ability to filter messages automatically. Messages are sent by adding a `syslog` event to the event queue.

### Arguments
1. `name`: The name of the log to open.
2. `filter`: A string to filter the messages.
    A filter consists of a series of clauses separated by semicolons.
    Each clause consists of a name, operator, and one or more values separated by bars (`|`).
    String values may be surrounded with double quotes to allow semicolons, bars, and leading spaces.
    If multiple values are specified, any value matching will cause the clause to resolve to true.
    Available operators: `==`, `!=`/`~=`, `=%` (match), `!%/~%` (not match), `<`, `<=`, `>=`, `>` (numbers only).
    All clauses must be true for the filter to match.
    Example: `level == 3 | 4 | 5; category != filesystem; process > 0; message =% "Unexpected error"`

### Return Values
A unique (to the process) ID that is sent in the `syslog` event. Use this number to determine what log messages are related to this log/filter.

### Errors
This syscall may throw an error if:
* The log does not exist.
* The log was created without a stream.

## `closelog(name: string|number)`
Closes all connections open on the specified log (if `name` is a string), or closes a specific connection (if `name` is a number).

### Arguments
1. `name`: Either the name of a log, or an ID returned by `openlog`.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The log does not exist.
* The log does not have streaming enabled.
* The log connection does not exist.

## `logtty(name: string, tty: table?, level: number?)`
Sets the output TTY for the specified log.

### Arguments
1. `name`: The name of the log to modify.
2. `tty`: The TTY to send the output to. If unset, this disables TTY output.
3. `level`: The lowest log level that will be shown on the TTY. If unset, all messages will be displayed.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The current user is not the root user.
* The log does not exist.
* The TTY passed is invalid.