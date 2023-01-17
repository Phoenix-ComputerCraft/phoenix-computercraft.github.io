---
layout: default
title: Changelog
parent: Documentation
---

# Changelog
This page lists the changes in each major update to Phoenix, broken down by package.

## 0.0.3 - 2023-01-17

### `phoenix`
Package version: 0.0.3
- Added version checking to the kernel to ensure compatible CC:T versions
- Added `chroot` syscall to change process root
- Added support for symbolic links through the `link` syscall
- Added support for FIFOs through the `mkfifo` syscall
- Added new `tablefs` filesystem which loads the filesystem from a serialized table
- Added `nolink` option to `stat` to avoid resolving a final link
- Added new `PACKAGE_PATH` and `PACKAGE_LIBPATH` environment variables to control `package.path` in the environment
- Environment variables are now stored in a separate table from the Lua global environment
- `#!` now passes the path to the interpreter instead of piping the file to the interpreter's stdin
- HTTP requests now default to binary mode
- Fixed a bug causing resizing to not redraw properly

### `libsystem`
Package version: 0.1.2
- Added `filesystem.link`, `filesystem.mkfifo`, `filesystem.chroot`, `filesystem.mountlist`; `nolink` option for `filesystem.stat`
- `filesystem.move` now uses `filesystem.rename` if the source and destination are on the same filesystem
- Added `process.execp` to execute commands using the PATH
- Added `util.pullEvent` as a proxy of `coroutine.yield()`
- Added TypeScript definitions
- Fixed a bug causing `devicetree` objects to not be accepted by `hardware.*`

### `libcraftos`
Package version: 0.2
- Implemented most APIs, allowing more of CraftOS to run (currently missing: `gps`, `rednet`, `multishell`; `shell` and `textutils` are half implemented)
- Added `shell` program to run the CraftOS shell quickly
- Added TypeScript definitions from [cc-tstl-template](https://github.com/MCJack123/cc-tstl-template)

### `typescript`
Package version: 1.10.1
- Initial release

### `baseutils`
Package version: 0.1.2
- Added `chroot`, `link`, `mkfifo` commands
- `mount` now outputs a list of all mounts when run without arguments
- Adjusted cash to work with new environment variable semantics
- Adjusted `chmod`/`chown` to work with links
- Fixed `ls` not working when passed a file path

### `dpkg`
Package version: 0.2.2
- Fixed bugs

### `usermgr`
Package version: 0.1.1
- `su`/`sudo` can now resolve commands from the PATH
- Adjusted programs to work with new environment variable semantics

### `libdeflate`
Package version: 1.0.2
- Updated to resolve licensing issues
- Removed a few unnecessary functions related to WoW and CLI
- Added TypeScript definitions

### `muxzcat`
Package version: 1.0-2
- Added TypeScript definitions

### `tar`
Package version: 1.0.1
- Fixed bugs

### `sha2`
Package version: 12-2
- Added TypeScript definitions

## 0.0.2 - 2022-09-11

### `phoenix`
Package version: 0.0.2
- Added basic Discord plugin support (not super good but it works)
- Fixed some problems with _ENV emulation
- Added new driver registration functions to the kernel API
- Added attach/detach syscalls for peripheral emulators
- Fixed issues with updating frontmost processes when using `stdout`/`stdin`/`stderr`
- Other various fixes

### `libsystem`
Package version: 0.1.1
- Added `serialization` module
- Fixed cursor blink behavior in windows
- Fixed `window.restoreCursor` missing from windows

### `pxboot`
Package version: 0.1.1
- Fixed support for Discord plugin

### `baseutils`
Package version: 0.1.1
- Fixed some invalid argument issues

### `dpkg`
Package version: 0.2.1
- Added `components` package installer
- Bug fixes

### `gfxterm`
Package version: 0.0.1
- Initial release

## 0.0.1 - 2022-08-25

### `phoenix`
Package version: 0.0.1
- Initial release

### `libsystem`
Package version: 0.1
- Initial release

### `libcraftos`
Package version: 0.1
- Initial release

### `pxboot`
Package version: 0.1
- Initial release

### `baseutils`
Package version: 0.1
- Initial release

### `yahtcc`
Package version: 1.0
- Initial release

### `startmgr`
Package version: 0.1
- Initial release

### `usermgr`
Package version: 0.1
- Initial release

### `ar`
Package version: 1.0
- Initial release

### `diff`
Package version: 1.0
- Initial release

### `libdeflate`
Package version: 1.0.0
- Initial release

### `muxzcat`
Package version: 1.0
- Initial release

### `sha2`
Package version: 12
- Initial release

### `tar`
Package version: 1.0
- Initial release

### `dpkg`
Package version: 0.2
- Initial release