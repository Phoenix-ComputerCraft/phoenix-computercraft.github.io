---
layout: default
title: Monitor
parent: Drivers
---

# `monitor`
This type represents a monitor peripheral. Monitors function as a secondary output TTY, and can be redirected to with `stdout()`. They can also be used without redirection, using the `write`, `openterm`, and `opengfx` methods.

## Drivers that use this type
* `peripheral_monitor`: Implements for networked monitors.

## Properties
* `scale: number {get set}`: The scale of the monitor. Ranges from 0.5 to 5.0.
* `size: {width: number, height: number} {get}`: The size of the monitor's TTY in character cells. Equivalent to `termsize()` syscall on the monitor.

## Methods
* `write(value...: any)`: Writes a series of values to the monitor, accepting ANSI escape codes.
* `termctl(flags: table?): table`: Sets various control flags on the monitor if specified, and returns the status of all flags. This uses the same arguments as the [`termctl` syscall](/syscalls/terminal.html#termctlflags-table-table), but only flags relating to output are used.
* `openterm(): Terminal?`: Attempts to acquire exclusive access to the monitor and switch into exclusive-text mode. This functions the same as the [`openterm` syscall](/syscalls/terminal.html#openterm-terminal).
* `opengfx(): GFXTerminal?`: Attempts to acquire exclusive access to the monitor and switch into graphics mode. This functions the same as the [`opengfx` syscall](/syscalls/terminal.html#opengfx-gfxterminal).

## Events
* `monitor_resize`: Sent when the monitor is resized.
  * `device: string`: The path to the resized monitor
  * `width: number, height: number`: The new size of the monitor