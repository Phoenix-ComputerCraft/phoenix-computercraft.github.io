---
layout: default
title: Terminal I/O
parent: Documentation
---

# Terminal I/O
This page describes how programs can interact with the user through a terminal & stdio.

## General design
Phoenix borrows the idea of the TTY ("teletype") from the Unix world. A TTY is a virtual object that represents a terminal, with its own set of input and output functions. By default, there are eight virtual terminals (accessible with Ctrl+Alt+1-8) that are each assigned their own TTYs. In addition, programs may create their own TTY objects; for example, a graphical terminal emulator may create its own TTY to be able to run text-mode programs in a GUI.

Each TTY has three display modes available. The first mode is standard text mode, which uses standard I/O syscalls to serially read and write plain text. This mode is similar to a standard text console on Unix-like systems. This mode is also the only one that allows concurrent access to the same TTY. Standard text mode writes characters to the screen one at a time, wrapping at the end of a line and automatically scrolling the screen. It also accepts ASCII control characters (such as `\n`, `\r`, `\t`), as well as ANSI escape codes, allowing primitive control of the terminal without acquiring access to the entire TTY.

The second mode is exclusive text mode, which allows finer-grained access to the terminal subsystem. This mode is like switching to ncurses's alternate screen, and uses the same set of functions as normal ComputerCraft. Switching to this mode uses the `openterm` syscall, which returns a terminal handle object upon success. Exclusive text mode is called "exclusive" because only one program may use this mode at a time on a single TTY - the `openterm` syscall will return `nil` if another program currently has it open. This allows programs to be sure the terminal is in the same state they expect, and not have other programs be mutating the screen contents. When in exclusive text mode, standard text mode syscalls are still accepted, but are sent to a backbuffer (similar to when writing to a backgrounded VT), and are not displayed until the terminal handle is closed.

The third mode is graphics mode, and is only available when running under CraftOS-PC. Graphics mode allows access to bitmapped pixels on the screen, with up to 256 colors available at a time (see [the CraftOS-PC docs](https://www.craftos-pc.cc/docs/gfxmode) for more info). It works similarly to exclusive text mode, in that it uses the `opengfx` syscall to acquire exclusive access to the screen. However, the handle returned by `opengfx` has a different set of functions for pixel manipulation. Only one of exclusive text mode or graphics mode may be acquired at once - if the TTY is currently in graphics mode, a request for exclusive text mode will fail.