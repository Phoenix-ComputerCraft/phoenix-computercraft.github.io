---
layout: default
title: Changelog
parent: Documentation
---

# Changelog
This page lists the changes in each major update to Phoenix, broken down by package.

## 0.0.8 - 2025-03-02

### `phoenix`
Package version: 0.0.8
- Added debugging system calls
  - See [the docs page](/docs/debugging.html) for more info on debugging.
- Added enhanced support for running in CraftOS-PC headless mode
- Added driver for new redstone relay peripheral
- Added time-to-live parameter to PIP control messages
- Added `capture` and `release` syscalls to force capture input from stdin
- Added `peekEvent` syscall to see the next event without consuming it or waiting
- Debug hooks now work properly per-coroutine
- Implemented bell character
- Signal handler and user mode callback threads are now named as such
- Fixed wired modems not registering drivers on attached devices
- Fixed many issues caused by processes not being woken up on queued events
- Fixed `mouse_scroll.direction` type

### `libsystem`
Package version: 0.1.6
- Added debugging system calls
- Added `network.parseURI`, `network.urlEncode`
- Added `terminal.capture` and `terminal.release` syscalls to force capture input from stdin
  - `terminal.readline2` now captures input automatically
- Fixed many issues with framebuffers
- Fixed typo in `util.copy`

### `githubfs` *(new)*
Package version: 1.0
- Initial release
- Provides a FUSE filesystem for mounting GitHub repositories on the local system.

### `pdb` *(new)*
Package version: 0.1
- Initial release
- Implements a GDB-like debugger for Phoenix programs.
- Will include a DAP debugger for connecting to VS Code in a future release.

### `typescript`
Package version: 1.28.1
- Updated to newer version

## 0.0.7 - 2024-08-31

Some packages had version bumps without changing the contents, to fix some missed version bumps before:
- `diskmgr`: 1.0 -> 1.0.1
- `startmgr`: 0.1.1 -> 0.1.2
- `yahtcc`: 0.1-2 -> 0.1-3

### `phoenix`
Package version: 0.0.7
- Fixed compatibility with CC:T 1.112.0 and later
- Fixed crash in installer
- Added overlay mounting capabilities
- Implemented ^L shortcut to clear terminal screen
- Improved handling of deeply recursive links
- Fixed some issues with links in craftos mounts
- Removed some unnecessary debug log lines

### `baseutils`
Package version: 0.2.2
- Added `-h` option to `ls`
- Fixed argument passing to `mount`

### `dpkg`
Package version: 0.2.6
- Fixed some handling of links
- Fixed version comparison issues
- Fixed issues with parsing certain control files

## 0.0.6 - 2024-07-31

### `phoenix`
Package version: 0.0.6
- Reduced default quantum to 20,000 instructions
- Fixed `string.pack` backport not working on CC older than 1.89.0
- Fixed some issues around passing tables in system call parameters
- Added `secure_syscall`, `secure_event` yield types (experimental)
- Added file system events system through the `fsevent` syscall
  - Call `fsevent` on a path to receive events when the file or directory is modified
- Fixed read handles on empty files not working in custom filesystems
- Fixed environment of user mode callbacks to custom write file handles
- Fixed root user not having absolute permissions on files
- Re-added `utf8` library to programs
- Changed VT key combo to Ctrl+Shift+F*n*
- Text mode cursor color is now set to the active foreground color
- Fixed `(GFX)Terminal.nativePaletteColor` being missing
- Added `tty.write` and `tty.sendEvent` methods
- Fixed issues with standard handle redirection relating to frontmost processes
- Added `require`/`package` implementation in the kernel environment
- Added `getfenv` syscall to get the process environment table
- Fixed global metatables per process using kernel global APIs
- Added `atexit` syscall to run a function before the process quits
- Mutexes can now be shared across processes properly
- Fixed panic from resizing an attached monitor
- Fixed missing initialization function for speakers
- Fixed small bug on HTTP failures

### `libsystem`
Package version: 0.1.5
- Added `filesystem.fsevent`, `filesystem.absolute`, `process.getfenv`, `process.atexit`, `sync.synctab`
- Added transparency option to `framebuffer.framebuffer`
- Added range check to colors in `graphics.drawFilledBox`

### `libcraftos`
Package version: 0.2.3
- Added `cc.strings` library to libcc
- Fixed `fs.getFreeSpace`, `fs.getCapacity`, and `fs.move` not finding mount info when destination path doesn't exist
- Fixed `fs.getName` not working
- Moved event conversion logic into `os._convertEvent(event, param)`
- Fixed `peripheral.hasType` not working
- `term.native()` now returns a copy of the TTY handle

### `aes` *(new)*
Package version: 1.0
- Initial release
- Provides functions to encrypt and decrypt data using the AES algorithm.
- Ported from https://gist.github.com/afonya2/489c3306a7d85f8f9512df321d904dbb

### `ar`
Package version: 1.1.1
- Fixed issue with long file names in some archives

### `asn1` *(new)*
Package version: 1.0
- Initial release
- Handles serializing and deserializing tables in ASN.1 DER format.

### `ccryptolib`
Package version: 1.2.2
- This version adds a way to initialize the generator from noise present in VM instruction timings. This is a reworked version of the previous approach used for initializing the `ecc.lua` random generator.

### `compressfs` *(new)*
Package version: 1.0
- Initial release
- Implements a file system that compresses disk contents automatically.

### `deflateans` *(new)*
Package version: 1.0
- Initial release
- A variant of DEFLATE that uses asymmetrical numeral systems instead of Huffman coding, increasing decompression speed with similar compression ratios.

### `dpkg`
Package version: 0.2.5
- Fixed error when a package has Conflicts
- Fixed `--force-depends-version` not working

### `encryptfs` *(new)*
Package version: 1.0
- Initial release
- Implements a file system that encrypts disk contents automatically.

### `libcert` *(new)*
Package version: 1.0
- Initial release
- Implements a library for working with X.509 and PKCS container formats.

### `libdeflate`
Package version: 1.0.2-2
- Added link to capitalized name in case a program uses it

### `luz`
Package version: 0.1.1
- Fixed issue in init code

### `spanfs`
Package version: 0.1.1
- Refactored some userspace code for safety

### `typescript`
Package version: 1.22.0
- Updated to newer upstream version

### `yellowbox` *(new)*
Package version: 0.1
- Initial release
- Kernel module that implements a ComputerCraft emulator in the Phoenix kernel.

## 0.0.5 - 2024-01-17

### `phoenix`
Package version: 0.0.5
- Improved support for Lua 5.2 runtimes
- Changed some details about how system calls are run in the kernel
  - Syscalls are now run in a separate coroutine
  - This allows them to yield for events
  - User callbacks to syscalls can yield as well
- Added `quiet` boot argument to set the log level to warning
- Added new key translation allocation method that doesn't use bytecode
- Added more protection around kernel panics
- Added checks to make sure the kernel doesn't yield in the wrong places
- Added implementations of common Lua functions in the kernel environment
- Added `unmount` method to filesystems
- Added `localIP` method to PSP socket handles
- Added `transfer` method to PSP socket handles to transfer the handle to another process
- PSP can now listen to multiple clients on the same port, as long as the remote clients use different outgoing ports
- Fixed a bug in `mkdir`
- Fixed a vulnerability in `loadfile` allowing access to the kernel environment
- Fixed a vulnerability in dbprotect allowing accessing the environment of stack functions
- `openterm` and `opengfx` now hold references to their handles, allowing them to be called again to get the handle after initialization
- Fixed many issues in PSP layer
- `craftos` filesystems no longer sync metadata on every write
- Fixed tabs not always aligning correctly
- `mklog` no longer errors if the log already exists
- Improved how the `exit` syscall works

### `pxboot`
Package version: 0.1.3
- Fixed support for Lua 5.2
- Added `insmod` command in entry definitions

### `libsystem`
Package version: 0.1.4
- Added `serialization.toml` TOML parser
- Added `expect.struct`, `expect.array`, `expect.match` type matchers for `expect`
- Added `process.forkbg`, `process.startbg` to create background tasks
- Fixed error when using `filesystem.copy` on a source that doesn't exist
- Fixed some typos in `sync.conditionVariable:waitFor` and `terminal.readline2`

### `libcraftos`
Package version: 0.2.2
- Reverted changes to terminal colors
- Fixed bug in `disk.isPresent` when the requested peripheral isn't a drive
- Fixed typo in `colors.pink`
- Fixed environment error in `init` module
- Fixed some issues with syscalls in `shell` program

### `baseutils`
Package version: 0.2.1
- Added `attach` program for CraftOS-PC
- Added automatic `/rom` mount to `/etc/fstab`
- Fixed issues displaying infinite drive sizes in `df`

### `dpkg`
Package version: 0.2.4
- Fixed bug when extracting links
- Fixed bug causing non-empty directories to be deleted when a single package removes them

### `ccryptolib`
Package version: 1.1.0
- Updated to latest upstream version
- This version stabilizes the API in `ccryptolib.x25519c`.
  - Functions that mixed exchanges with Ed25519 keys were removed.

### `luz` *(new)*
Package version: 0.1
- Initial release
- Lua script compression and decompression utility, library & kernel module
- Can be used with `pxboot` to boot Luz-compressed kernel images

### `phoenix-luz` *(new)*
Package version: 0.0.5
- Initial release
- Alternate distribution of `phoenix` using Luz compression

### `fuse` *(new)*
Package version: 0.1
- Initial release
- Implements filesystems in userspace, allowing filesystems to be implemented without using kernel modules

### `ftp` *(new)*
Package version: 0.1
- Initial release
- RFC 959-compliant File Transfer Protocol client, server, and filesystem driver over PSP

### `netutils` *(new)*
Package version: 0.1
- Initial release
- Various Linux-inspired utilities to manage the current network configurations

### `dhcpmgr` *(new)*
Package version: 0.1
- Initial release
- DHCP autoconfiguration server for assigning IP addresses to clients

### `netmgr` *(new)*
Package version: 0.1
- Initial release
- Network management daemon to set IP addresses from a configuration file, including a DHCP client

### Installer
- Added prompt to use `phoenix-luz` Luz kernel instead of full `phoenix` kernel
- Added confirmation prompt for passwords

## 0.0.4 - 2023-08-03

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