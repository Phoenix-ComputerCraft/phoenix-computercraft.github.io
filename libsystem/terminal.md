---
layout: default
title: system.terminal
parent: libsystem
---

# system.terminal
The terminal module defines functions to allow interacting with the terminal
 and screen, as well as handling user input.

## `toEscape(color: number[, background: boolean = false]): string`
Converts a @{terminal.colors} constant to an ANSI escape code.

### Arguments
1. `color`: The color to convert
2. `background`: Whether the escape should set the background (defaults to false)

### Return Values
The escape code generated for the color

## `write(...)`
Writes text to the standard output stream.

### Arguments
1. `...`: The entries to write. Each one will be separated by tabs (`\t`).

### Return Values
This function does not return anything.

## `writeerr(...)`
Writes text to the standard error stream.

### Arguments
1. `...`: The entries to write. Each one will be separated by tabs (`\t`).

### Return Values
This function does not return anything.

## `read(n: number): string|nil`
Reads a number of characters from the standard input stream.

### Arguments
1. `n`: The number of characters to read

### Return Values
The text read, or nil if EOF was reached.

## `readline(): string|nil`
Reads a single line of text from the standard input stream.

### Arguments
This function does not take any arguments.

### Return Values
The text read, or nil if EOF was reached.

## `readline2(history: table?, completion: function(partial:string):string[]?): string|nil`
Reads a line of text from the standard input stream, allowing history and
 autocompletion.

### Arguments
1. `history`: A list of history items to scroll through with the
 arrow keys, with the first index being the most recent (optional)
2. `completion`: A function to use
 to get completion options (optional)

### Return Values
The text read, or nil if EOF was reached.

## `termctl(flags: {cbreak?=boolean,delay?=boolean,echo?=boolean,keypad?=boolean,nlcr?=boolean,raw?=boolean}): {cbreak=boolean,delay=boolean,echo=boolean,keypad=boolean,nlcr=boolean,raw=boolean}|nil`
Sets certain terminal control flags on the current TTY if available.

### Arguments
1. `flags`: ? The flags to set, or nil to just query.

### Return Values
The flags that are currently set on the TTY, or nil if no TTY is available.

## `openterm(): Terminal / nil, string`
Opens the current output TTY in exclusive text mode, allowing direct
 manipulation of the screen buffer.  Only one process may open the terminal at
 a time. Once opened, the screen will be cleared, and stdout will be sent to
 an off-screen buffer to be shown once the terminal is closed. The terminal
 will automatically be closed on process exit.

### Arguments
This function does not take any arguments.

### Return Values
This function may return the following values:
1. A terminal object for the current TTY.

Or:
1. If the terminal could not be opened.
2. An error message describing why the terminal couldn't be opened.

## `opengfx(): GFXTerminal / nil, string`
Opens the current output TTY in exclusive graphics mode, allowing direct
 manipulation of the pixels if available.  Only one process may open the terminal
 at a time. Once opened, the screen will be cleared, and stdout will be sent to
 an off-screen buffer to be shown once the terminal is closed. The terminal
 will automatically be closed on process exit. This only works on CraftOS-PC.

### Arguments
This function does not take any arguments.

### Return Values
This function may return the following values:
1. A graphical terminal object for the current TTY.

Or:
1. If the terminal could not be opened.
2. An error message describing why the terminal couldn't be opened.

## `mktty(width: number, height: number): TTY`
Creates a new virtual TTY with the specified size.  This can later be used in
 a call to stdin/stdout/stderr.

### Arguments
1. `width`: The width of the new TTY.
2. `height`: The height of the new TTY.

### Return Values
A new TTY object which is registered with the kernel. See [the syscall docs](/syscalls/terminal#mkttywidth-number-height-number-tty) for more info.

## `capture()`
Captures input on the current stdin TTY, bringing the process to the front.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

## `release()`
Releases a previously captured input on the current stdin TTY.

### Arguments
This function does not take any arguments.

### Return Values
This function does not return anything.

## `stdin(handle: number|TTY|FileHandle|nil)`
Sets the standard input of the current process.

### Arguments
1. `handle`: The input handle to switch to, as
 either a physical TTY, a virtual TTY, a file, or nil.

### Return Values
This function does not return anything.

## `stdout(handle: number|TTY|FileHandle|nil)`
Sets the standard output of the current process.

### Arguments
1. `handle`: The output handle to switch to, as
 either a physical TTY, a virtual TTY, a file, or nil.

### Return Values
This function does not return anything.

## `stderr(handle: number|TTY|FileHandle|nil)`
Sets the standard error of the current process.

### Arguments
1. `handle`: The output handle to switch to, as
 either a physical TTY, a virtual TTY, a file, or nil.

### Return Values
This function does not return anything.

## `istty(): boolean, boolean`
Returns whether the current stdio are linked to a TTY.

### Arguments
This function does not take any arguments.

### Return Values
This function may return the following values:
1. Whether the current stdin is linked to a TTY.
2. Whether the current stdout is linked to a TTY.

## `termsize(): number, number / nil`
Returns the current size of the TTY if available.

### Arguments
This function does not take any arguments.

### Return Values
This function may return the following values:
1. The width of the screen.
2. The height of the screen.

Or:
1. If the current stdout is not a screen.

## `colors`
Constants for colors.  This includes both normal and British spelling.

### Fields
- `white`:
- `orange`:
- `magenta`:
- `lightBlue`:
- `yellow`:
- `lime`:
- `pink`:
- `gray`:
- `grey`:
- `lightGray`:
- `lightGrey`:
- `cyan`:
- `purple`:
- `blue`:
- `brown`:
- `green`:
- `red`:
- `black`:

