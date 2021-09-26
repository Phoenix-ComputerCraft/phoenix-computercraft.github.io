---
layout: default
title: Terminal I/O
parent: System Calls
---

# Terminal I/O
The following syscalls allow reading and writing to terminal devices and the screen.

## `write(value...: any)`
Writes a series of values to the standard output. ANSI escape codes are supported. When displayed on a TTY, text is automatically wrapped and scrolled.

### Arguments
1. `value...`: The values to write. Any non-string values are converted to strings.

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw errors.

## `writeerr(value...: any)`
Writes a series of values to the standard error. This functions like `write`, but goes to `stderr` instead. When displayed on a TTY, text is red by default.

### Arguments
1. `value...`: The values to write. Any non-string values are converted to strings.

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw errors.

## `read(count: number): string?`
Reads a number of bytes from the standard input. This syscall may return `nil` if the EOF has been reached.
- If the standard input is connected to an active TTY, EOF is triggered with Ctrl+D. When Ctrl+D is pressed, `read` immediately returns with the text entered. The next call to `read` will return `nil`.
- If the standard input is connected to a pipe, EOF is triggered when there is no data left in the pipe.
- If the standard input is connected to a file, EOF is triggered when the end of that file is reached.

### Arguments
1. `count`: The number of bytes to read.

### Return Values
The bytes read from input, or `nil` if the EOF flag is set.

### Errors
This syscall does not throw errors.

## `readline(): string?`
Reads a line of text from the standard input. This syscall may return `nil` if the EOF has been reached.
- If the standard input is connected to an active TTY, EOF is triggered with Ctrl+D. When Ctrl+D is pressed, `read` immediately returns with the text entered. The next call to `read` will return `nil`.
- If the standard input is connected to a pipe, EOF is triggered when there is no data left in the pipe.
- If the standard input is connected to a file, EOF is triggered when the end of that file is reached.

### Arguments
This syscall does not take any arguments.

### Return Values
The text read from input, or `nil` if the EOF flag is set.

### Errors
This syscall does not throw errors.

## `termctl(flags: table?): table?`
Sets various control flags on the active TTY if specified, and returns the status of all flags. If the program is not assigned to a TTY, this syscall does nothing and returns `nil`.

### Arguments
1. `flags`: A table with flags to set. If `nil` is passed, no flags will be changed. Any flag set to `nil` will keep the current value. These are the flags available:
    * `cbreak: boolean?`: If set, text is not line buffered, and characters are made available as they are typed. Defaults to `false`.
    * `delay: boolean?`: Controls whether `read`/`readline` will wait for input. If disabled, `read`/`readline` will return `nil`. Defaults to `true`.
    * `echo: boolean?`: Controls whether text input is displayed on the terminal. Defaults to `true`.
    * `keypad: boolean?`: Controls whether non-text-representable keys will be sent through `read`/`readline`. If set, those keys will be represented either as special 8-bit characters, or as ANSI escape codes. All keys can still be read through `key` events independent of this setting. Defaults to `false`.
    * `raw: boolean?`: Disables the use of Ctrl key shortcuts (e.g. Ctrl+C, Ctrl+D, Ctrl+Z, Ctrl+\\). Defaults to `false`.

### Return Values
The list of flags currently set on the TTY. If the program isn't connected to a TTY, returns `nil`.

### Errors
This syscall does not throw errors.

## `openterm(): Terminal?`
Attempts to acquire exclusive access to the current TTY and switch into exclusive-text mode.

### Arguments
This syscall does not take any arguments.

### Return Values
A text-mode handle to the current TTY, or `nil` + an error if the handle could not be acquired.

### Errors
This syscall does not throw errors.

## `opengfx(): GFXTerminal?`
Attempts to acquire exclusive access to the current TTY and switch into graphics mode. This only works on CraftOS-PC hosts.

### Arguments
This syscall does not take any arguments.

### Return Values
A graphics-mode handle to the current TTY, or `nil` + an error if the handle could not be acquired.

### Errors
This syscall does not throw errors.

## `mktty(width: number, height: number): TTY`
Creates a new pseudo-TTY of the specified size.

### Arguments
1. `width`: The width of the new TTY in character cells.
2. `height`: The height of the new TTY in character cells.

### Return Values
The new TTY handle.

### Errors
This syscall does not throw errors.