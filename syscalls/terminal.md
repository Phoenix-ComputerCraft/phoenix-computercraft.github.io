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

A TTY handle has the following properties:
- `isTTY`: `true`
- `flags`: Table of flags, from `termctl`
- `cursor`: Table with `x` and `y` properties for cursor position in text mode
- `cursorBlink`: Boolean for cursor blink
- `colors`: Table with `bg` and `fg` single-character strings, plus `bold` boolean for colors in text mode
- `size`: Table with `width` and `height` properties
- `dirtyLines`: A set with the lines that need to be redrawn
- `palette`: A table with the palette info, indexed 0-15
- `dirtyPalette`: A set with the palette entries that need to be updated
- `buffer`: Text input into the TTY that is awaiting being read
- `isLocked`: Whether the terminal is in an exclusive mode
- `isGraphics`: Whether the terminal is in exclusive graphics mode
- `textBuffer`: A buffer for exclusive text mode, with indexed lines, plus `cursor`, `cursorBlink`, `colors`, `palette`, `dirtyLines`, and `dirtyPalette`
- `graphicsBuffer`: A buffer for exclusive graphics mode, with indexed 256-color lines, plus `palette`, `dirtyRects`, `dirtyPalette`, and `frozen`

It also has the following methods:
- `write(text: string)`: Writes text to the text mode screen as if it were called through the `write` syscall.
- `sendEvent(event: string, param: table)`: Sends a user interaction event to the TTY. The event must be a valid Phoenix event for `key`, `key_up`, `char`, `paste`, or a mouse event.

Lines of text are stored in `tty[y]`, with three blit string entries for text, text colors, and background colors.

### Errors
This syscall does not throw errors.

## `stdin(handle: number | table | string | nil)`
Sets the standard input handle of the current process.

### Arguments
1. `handle`: The handle to set the input to. This may be one of:
  * a number indicating a virtual terminal to use
  * a TTY created with `mktty`
  * a handle with a `read` function
  * a device path or UUID to a peripheral that has a TTY (such as a monitor)
  * `nil` to disable stdin.

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw errors.

## `stdout(handle: number | table | string | nil)`
Sets the standard output handle of the current process.

### Arguments
1. `handle`: The handle to set the output to. This may be one of:
  * a number indicating a virtual terminal to use
  * a TTY created with `mktty`
  * a handle with a `write` function
  * a device path or UUID to a peripheral that has a TTY (such as a monitor)
  * `nil` to disable stdout.

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw errors.

## `stderr(handle: number | table | nil)`
Sets the standard error handle of the current process.

### Arguments
1. `handle`: The handle to set the output to. This may be one of:
  * a number indicating a virtual terminal to use
  * a TTY created with `mktty`
  * a handle with a `write` function
  * a device path or UUID to a peripheral that has a TTY (such as a monitor)
  * `nil` to disable stderr.

### Return Values
This syscall does not return anything.

### Errors
This syscall does not throw errors.

## `istty(): boolean, boolean`
Returns whether the current process is attached to a TTY's input and/or output.

### Arguments
This syscall does not take any arguments.

### Return Values
Two boolean values indicating whether there is a TTY on the input and output, respectively.

### Errors
This syscall does not throw errors.

## `termsize(): number?, number?`
Returns the size of the current TTY if available.

### Arguments
This syscall does not take any arguments.

### Return Values
The width and height of the terminal, or `nil` if the output is not a TTY.

### Errors
This syscall does not throw errors.