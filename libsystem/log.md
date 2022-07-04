---
layout: default
title: system.log
parent: libsystem
---

# system.log
The log module exposes functions for interacting with the logging subsystem.
 The default system log is available under the root `log` table. Other logs
 created through @{log.create} can be accessed by indexing the `log` table with
 the name of the log, e.g. `log.mylog.info("hello")`. Both the main and
 subtables may also be called directly, e.g. `log("test")` or `log.mylog("hello")`.


## `log(options: table?, ...: any)`
Writes a message to the log.

### Arguments
1. `options`: A table of options to supply. See the documentation
 for the syslog syscall for more information. (optional)
2. `...`: The values to print to the log, which will be concatenated as
 strings with \t.

### Return Values
This function does not return anything.

## `debug(options: table?, ...: any)`
Writes a debug message to the log.

### Arguments
1. `options`: A table of options to supply. See the documentation
 for the syslog syscall for more information. (optional)
2. `...`: The values to print to the log, which will be concatenated as
 strings with \t.

### Return Values
This function does not return anything.

## `info(options: table?, ...: any)`
Writes an info message to the log.

### Arguments
1. `options`: A table of options to supply. See the documentation
 for the syslog syscall for more information. (optional)
2. `...`: The values to print to the log, which will be concatenated as
 strings with \t.

### Return Values
This function does not return anything.

## `notice(options: table?, ...: any)`
Writes a notice message to the log.

### Arguments
1. `options`: A table of options to supply. See the documentation
 for the syslog syscall for more information. (optional)
2. `...`: The values to print to the log, which will be concatenated as
 strings with \t.

### Return Values
This function does not return anything.

## `warning(options: table?, ...: any)`
Writes a warning message to the log.

### Arguments
1. `options`: A table of options to supply. See the documentation
 for the syslog syscall for more information. (optional)
2. `...`: The values to print to the log, which will be concatenated as
 strings with \t.

### Return Values
This function does not return anything.

## `error(options: table?, ...: any)`
Writes an error message to the log.

### Arguments
1. `options`: A table of options to supply. See the documentation
 for the syslog syscall for more information. (optional)
2. `...`: The values to print to the log, which will be concatenated as
 strings with \t.

### Return Values
This function does not return anything.

## `critical(options: table?, ...: any)`
Writes a critical error message to the log.

### Arguments
1. `options`: A table of options to supply. See the documentation
 for the syslog syscall for more information. (optional)
2. `...`: The values to print to the log, which will be concatenated as
 strings with \t.

### Return Values
This function does not return anything.

## `traceback(message: string?)`
Writes a traceback error message to the log.

### Arguments
1. `message`: A message to attach to the traceback (optional)

### Return Values
This function does not return anything.

## `create(name: string, streamed: boolean?, file: string?): table`
Creates a new log.

### Arguments
1. `name`: The name of the log to create
2. `streamed`: Whether to make the log available for streaming (optional)
3. `file`: The path to the file to write the log to (optional)

### Return Values
A logger object from `log.*`

## `remove(name: string)`
Removes a previously created log.

### Arguments
1. `name`: The log to remove

### Return Values
This function does not return anything.

## `open(name: string, filter: string?): number`
Opens a log for listening to messages.

### Arguments
1. `name`: The name of the log to listen to
2. `filter`: A filter command to filter messages with (see the
 openlog syscall docs for more info) (optional)

### Return Values
An ID to identify the logged messages with

## `close(name: string|number)`
Closes a log or stream for listening.

### Arguments
1. `name`: The log name to close (closes all streams), or an
 ID returned by <a href="log.html#open">log.open</a>.

### Return Values
This function does not return anything.

## `setTTY(name: string, tty: TTY|nil, level: number?)`
Sets the TTY to output a log to.  (Requires root)

### Arguments
1. `name`: The log to set the TTY of
2. `tty`: The TTY to use, or `nil` to disable
3. `level`: The minimum log level to show messages (optional)

### Return Values
This function does not return anything.

## `levels`
Constants for log levels.

### Fields
- `debug`:
- `info`:
- `notice`:
- `warning`:
- `error`:
- `critical`:

