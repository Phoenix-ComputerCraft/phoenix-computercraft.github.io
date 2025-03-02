---
layout: default
title: system.util
parent: libsystem
---

# system.util
The util module contains various functions that don't have any specific
 system function, or help improve the usability of the general system.

## `argparse(arguments: {[string]=string|boolean|nil}, ...: string): {[string]=string|number|boolean|nil,string...} / nil, string`
Takes a list of valid arguments + the arguments to a program, and returns a
 table with the extracted arguments (and values if requested).
 If an argument with all `-`s is passed, processing of arguments stops, and
 all subsequent arguments are added to the list.

### Arguments
1. `arguments`: A list of arguments that
 the program accepts. Single-character arguments are handled through `-a`, and
 longer arguments are handled through `--argument`. The value of the entry
 specifies how the argument is handled:
 * If the value is a truthy value, this argument requires a parameter.
 * If the value is `"number"`, the argument requires a number parameter.
 * If the value is `"multiple"`, the argument can be specified multiple times,
   and will require a parameter. The values returned will be in a table.
 * If the value is `"multiple number"`, the argument can be specified multiple
   times, and will require a number parameter. These are also in a table.
 * If the value is `false`, the argument does not take a parameter.
 * If the value is `nil`, the argument does not exist and will throw an error
   if passed.
 * If the value starts with `@`, the parameter is an alias and will be stored
   in that argument instead, following the same rules as that argument as well.
 Special parameters to the parser can be added in a `[""]` table. The following
 parameters are specified:
 * `stopProcessingOnPositionalArgument` [boolean]: Whether to stop processing
   arguments when a positional argument is passed, e.g. `myprog -s arg -i` will
   return `args.s = true`, but `args.i = nil`.
2. `...`: The arguments as passed to the program.

### Return Values
This function may return the following values:
1.  The arguments
 as parsed from the arguments table as key-value entries, plus positional
 arguments as list entries.

Or:
1. If the arguments passed are invalid.
2. An error string describing what was invalid, which can be
 printed for the user.

## `timer(time: number): number`
Starts a timer that will run for the specified number of seconds.
 A timer event will be queued on completion.

### Arguments
1. `time`: The number of seconds to wait until sending the event

### Return Values
The ID of the newly created timer

## `alarm(time: number): number`
Starts an alarm that will run until the specified time.
 A timer event will be queued on completion.

### Arguments
1. `time`: The time to send the event at

### Return Values
The ID of the newly created alarm

## `cancel(id: number)`
Cancels a timer or alarm.  This prevents the event from triggering.

### Arguments
1. `id`: The ID of the timer or alarm to cancel

### Return Values
This function does not return anything.

## `sleep(time: number)`
Pauses the process for a certain amount of time.

### Arguments
1. `time`: The amount of time to wait for, in seconds

### Return Values
This function does not return anything.

## `pullEvent(): string, table`
Returns the next event from the event queue.  This is intended to make it more
 clear when events are being pulled, and also has the benefit of supporting
 libsystem-craftos better.

### Arguments
This function does not take any arguments.

### Return Values
This function may return the following values:
1. The event pulled
2. The parameters for the event

## `filterEvent(...: string): string, table`
Waits until an event of the specified type(s) occurs.

### Arguments
1. `...`: The event names to filter for

### Return Values
This function may return the following values:
1. The event type that was matched
2. The parameters for the event

## `queueEvent(event: string, param: table)`
Queues an event to loop back to the process.

### Arguments
1. `event`: The event name to send
2. `param`: The parameter table to send with the event

### Return Values
This function does not return anything.

## `peekEvent(): string|nil, table|nil`
Peeks at the next event in the queue.

### Arguments
This function does not take any arguments.

### Return Values
This function may return the following values:
1. The name of the next event, or `nil` if there is none
2. The parameters of the next event.

## `split(str: string[, sep: string = "%s"][, includeEmpty: boolean = false]): {string...}`
Splits a string into components.

### Arguments
1. `str`: The string to split
2. `sep`: The delimiter match class to split by (defaults to "%s")
3. `includeEmpty`: Whether to include empty matches (defaults to false)

### Return Values
The components of the string

## `copy(value: any): any`
Copies a value recursively, including all its keys and values.

### Arguments
1. `value`: The value to copy

### Return Values
A copy of the value, with all keys, values, and metatables duplicated.

## `addEventListener(event: string, callback: function(string,table):boolean)`
Adds an event listener to the listening module.

### Arguments
1. `event`: The event to listen for
2. `callback`: The function to call when
 the event is queued. If the function returns a truthy value, processing for
 the current event will stop. If the function throws an error, the loop will
 stop.

### Return Values
This function does not return anything.

## `removeEventListener(event: string, callback: function(string,table))`
Removes an event listener from the listening module.

### Arguments
1. `event`: The event to listen for
2. `callback`: The function to remove

### Return Values
This function does not return anything.

## `runEvents(): string`
Runs the event listening loop on the current thread, blocking forever.

### Arguments
This function does not take any arguments.

### Return Values
The error that caused the function to stop

## `startEvents(): number`
Runs the event listening loop on a new thread, allowing code to run after.

### Arguments
This function does not take any arguments.

### Return Values
The ID of the new thread

## `type(value: any): string`
Returns the type of the parameter, with the ability to check the __name
 metamethod for custom types.

### Arguments
1. `value`: The value to check

### Return Values
The type of the value

## `crc32(str: string[, polynomial: table|number = 0xEDB88320][, crc: number = 0xFFFFFFFF]): number`
Calculates the CRC-32 checksum of the specified data.

### Arguments
1. `str`: The data to checksum
2. `polynomial`: The polynomial for the CRC, or the lookup table to use (defaults to 0xEDB88320)
3. `crc`: The initial CRC value (defaults to 0xFFFFFFFF)

### Return Values
The calculated CRC checksum

## `syscall`
util.syscall wraps all available syscalls into a table of functions, making
 it possible to call syscalls using direct function calls instead of manually
 yielding and managing the return values.

### Fields
This function does not take any arguments.

