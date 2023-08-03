---
layout: default
title: Changelog
parent: Documentation
---

# Changelog
This page lists the changes in each major update to Phoenix, broken down by package.

## 0.0.4

### `phoenix`
Package version: 0.0.4
- Added `bind` filesystem type for bind mounts
- Added `kernargs` syscall to get kernel argument list (intended for init systems)
- Added `fsmeta` kernel argument to store `meta.ltn` elsewhere
- Added `initrd` kernel argument to use a `tablefs` image as the root, allowing a future init program to use `root`/`rootfstype`/`init` arguments
  - `initrd` images should have the init program at `/init.lua`, instead of `/sbin/init` - the `init` argument is ignored
- Added `filesystem.readhandle` and `filesystem.writehandle` kernel API functions
- Added `nice` syscall to control nice values for a process (preemption times)
- Added kernel API for `exec` loader functions
- `filesystem.openfifo` was renamed to `filesystem.fifohandle`
- `xpcall` is no longer overridden on platforms that support 5.2-style `xpcall`
- Syscall failure logs now add the syscall name in the module field
- ROM files may now have metadata
- `tablefs` now has three writeability modes
  - `ro` will make the filesystem fully read-only, erroring on write operations
  - No options will make the filesystem writable, but not flushed to disk
  - `rw` will make the filesystem writable, and saves changes back to the file
- Kernel initialization code is now properly protected - errors while starting up will now panic instead of crashing the computer
- `mount` now fully supports remounting the root filesystem
- Process IDs are now sequential instead of using the first free ID
- stdin now properly supports paste events
- Implemented `ICH`, `DCH` CSI escape codes
- CSI codes `CUF` and `CUB` now wrap lines properly
- Disk drives now keep their own metadata databases
- `\x1b[0m` now resets the bold attribute as well
- Global type metatables are no longer shared between processes
- Fixed issue where `stat` on a `tmpfs` root may leak kernel functions
- Fixed `chroot` syscall not being functional
- Fixed user mode callbacks not returning anything
- Fixed `math.random` only returning 0/1 when using integer functions
- Fixed `print` creating extra newlines when writing near the edge of the screen
- Fixed `io.stdin:read()` missing newlines
- Fixed some issues with `io.popen`
- Fixed errors in `openterm().get[Text|Background]Color` when the color is 10-15
- Fixed `drive` devices not being registered due to a typo
- Fixed an issue causing devices attached to a modem before startup not being detected
- Fixed an issue causing devices attached to a modem being uncallable

### `libsystem`
Package version: 0.1.3
- Added `terminal.readline2` to read lines with history and completion
- Added `process.nice` to set nice level for a process
- Fixed `hardware.hasType` erroring
- Fixed `hardware.wrap` objects failing to set properties
- Fixed `log.create` objects erroring when using a log level
- Fixed an issue causing `process.run` to fail to run programs
- Fixed `serialization.lua.encode` encoding some table keys incorrectly
- Fixed incorrect encoding of special characters in `serialization.lua.encode`

### `libcraftos`
Package version: 0.2.1
- Added stub `gps` and `rednet` APIs
- Added manual pages for `craftos` and `shell` programs
- Fixed serialization bugs from libsystem in `textutils.serialize`
- Fixed issues with color codes in `term`

### `baseutils`
Package version: 0.2
- Added `man`, `apropos` programs for reading manual pages in Markdown
- Added `comm` program for comparing file contents
- Added `compress` and `uncompress` programs for legacy UNIX LZW file compression
- Added `df` program for displaying filesystem statistics
- Added `dirname` program
- Added `du` program for measuring disk usage
- Added `eject` program to eject disks from drives
- Added `env` program
- Added `expand` program to expand tabs to spaces
- Added `expr` program for calculating expressions
- Added `id` program to get computer and disk IDs
- Added `label` program for changing disk and computer labels
- Added `logger` program for viewing, adding to, and creating and deleting logs
- Added `lsdev` program to list attached devices
- Added `nice`, `renice` programs to run a program with the specified nice level
- Added `nm` program to list functions and variables exported by a library
- Added `pwd` program to show current working directory
- Added `redstone` program to manipulate redstone I/O
- Added `unlink` program as direct wrapper for `remove` syscall
- Added startmgr service to automatically mount `/etc/fstab` entries on boot
- `cash` now supports history and file/program completion
- `cat` no longer requires libsystem
- `less` now supports limited VT-100 color codes
- `lua` now supports history, and alerts the user when they try to use `exit` or `quit` to quit
- `mount` now supports `-a` and responds to `/etc/fstab`
- `nano` now supports cutting and pasting lines
- Installing manual pages will now trigger `man -u` to update the database for `apropos`

### `pxboot`
Package version: 0.1.2
- Added `monitor` subcommand to run the specified OS on an attached monitor
- Added `include` command to include other config subfiles using a wildcard pattern

### `ar`
Package version: 1.1
- Phoenix permissions are now better supported
- Fixed some critical bugs when writing files
- Optimized code

### `ccryptolib` *(new)*
Package version: 1.0.1
- Initial release
- Port of [migeyel's CCryptoLib](https://github.com/migeyel/CCryptoLib) to Phoenix

### `diskmgr` *(new)*
Package version: 1.0
- Initial release
- Manager program to automatically mount disks

### `dpkg`
Package version: 0.2.3
- Added `--root` option to `dpkg`
- Added ability to extract links properly

### `initrd-utils` *(new)*
Package version: 0.1
- Initial release
- Contains tools for building an initrd

### `phoenix-docs` *(new)*
Package version: 0.0.4
- Initial release
- Contains manual pages for Phoenix, libsystem, and baseutils; kept separate from the main packages to save space

### `spanfs` *(new)*
Package version: 0.1
- Initial release
- Contains kernel module for spanned filesystems across multiple disk drives + management tools

### `startmgr`
Package version: 0.1.1
- Implemented `list`, `install` and `uninstall` commands
- Services can now have a `.wants` folder next to them to add other services that the service requires
  - This is useful for packages to install startup services, e.g. in `/etc/startmgr/system/startup.service.wants/`
- Moved `startup.service` to startmgr
- `shutdown` now logs a message before timed shutdown

### `usermgr`
Package version: 0.1.2
- Moved `startup.service` to startmgr
- `useradd` now properly sets the owner of files copied from the skeleton directory

### `yahtcc`
Package version: 1.0-2
- Added manual file

### Installer
- Added automatic setup for installing to a span filesystem

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

### `typescript` *(new)*
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

### `gfxterm` *(new)*
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