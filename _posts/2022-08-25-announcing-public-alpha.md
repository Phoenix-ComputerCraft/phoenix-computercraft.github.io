---
layout: post
title:  "Announcing the Release of the Phoenix Public Alpha, + Future Plans"
---

# Announcing the Release of the Phoenix Public Alpha, + Future Plans
After many months of active development, the official public alpha of the Phoenix operating system is now available for download. Phoenix was first announced on April 25, 2022, after a year of on and off work with small tidbits being posted on the ComputerCraft Discord server. Since then, a lot of work has gone into creating a working userspace for Phoenix, and it's finally ready for the public.

## Contents
This public alpha contains the kernel, the pxboot bootloader, the libsystem and libcraftos system libraries, the baseutils utility package, the startmgr init system and service manager, the usermgr user profile service, a port of Debian dpkg for package management, and various other libraries to support dpkg. This version does *not*, **and will not**, contain the graphical portions of Phoenix - these will be available later, and I'll describe how later in the article. Here's an overview of the components:

### Phoenix kernel
The Phoenix kernel is the core of the Phoenix operating system, and it powers the rest of the system. It includes the process scheduler, filesystem manager, hardware abstraction layer, networking utilities, terminal emulator, and more. More information on the system calls in the kernel is available [on the website](https://phoenix.madefor.cc/syscalls/).

### pxboot
pxboot is the default bootloader interface for Phoenix. It's a CraftOS program that shows a simple menu interface for selecting which OS to boot. The default configuration allows you to choose between booting Phoenix and CraftOS, but the configuration format is simple and highly flexible, allowing booting other OSes using CraftOS-based chainloaders or UnBIOS kernels. This means that pxboot can boot not only Phoenix and CraftOS, but also LevelOS (a CraftOS-based startup file) and Recrafted (an UnBIOS kernel), among others. Unlike most of the other code, pxboot is freely available [on GitHub](https://github.com/Phoenix-ComputerCraft/pxboot).

### libsystem
libsystem is the standard system library for Phoenix. It includes direct interfaces for every syscall available in the kernel, as well as other various utility functions and modules building upon that functionality. libsystem aims to provide similar functionality to CraftOS's API set, plus additional functions for Phoenix-specific features and more. Documentation for libsystem is available [on the website](https://phoenix.madefor.cc/libsystem/).

### libcraftos
libcraftos is an alternate system library that provides a CraftOS API compatibility layer under Phoenix. It includes modules for every API in CraftOS, allowing many CraftOS programs to be easily ported to Phoenix. The package also includes a `craftos` program that automatically loads libcraftos into the program's global table, letting compatible CraftOS programs run unmodified under Phoenix. To use libcraftos, simply use `require "craftos.<api>"` for each API to load, or `require "cc.<module>"` for CC: Tweaked modules (which matches CraftOS's syntax).

Note: The current version of libcraftos is incomplete. Please wait for a future update for full support.

### baseutils
baseutils is the name for a package of standard POSIX utilities for Phoenix. Currently, this includes only a small number of essential programs and useful utilities, but this list will be expanding as Phoenix continues developing. All relevant programs in baseutils follow POSIX.1-2017 standards where possible.

### startmgr
startmgr is the default init system and service manager for Phoenix. It uses a basic service definition format based on Lua to run services, and automatically starts some services on startup.

### usermgr
usermgr provides user login services for the system, as well as related login tools, including `su`/`sudo`. It uses standard UNIX `/etc/passwd` and `/etc/shadow` files for user storage, and emulates the Linux standard `user*` user modification tools.

### dpkg-lua
Phoenix includes a port of the dpkg-lua program and library for basic package management. This is mostly used internally for installation and update management, but it can also be used to install new software. It supports standard `.deb` package files with gzip or xz compression. Note that this does not include APT yet, but this is planned in the future - until then, an `update` program is included to allow quickly checking for and installing updates.

## Installation
To install Phoenix, run `wget run https://phoenix.madefor.cc/install.lua` in a CraftOS shell. Then follow the instructions in the setup program.

The installer will ask for a root directory to install in - this is where all files visible to the Phoenix system will be placed. Note that any files outside this folder will *not* be visible to the installed system, unless the CraftOS root or a separate subdirectory is mounted (this includes the ROM and any disk drives) - this is a security measure to avoid exposing the `meta.ltn` permissions database.

It will also ask for a username and password for the primary user, which will be used to log in. Other users may be added later through the `useradd` command. (If you want to log in as root at first, you may use `root` for the username - note that this will defeat any security measures!) Once installation is complete, use this username and password to log into the new system.

## Caveats
Being an alpha version, there's a lot of missing features and bugs. Please be aware that there will likely be a *lot* of things that are broken or incomplete. Some major things to note include:
- cash does not currently have readline-like functionality, and as such does not support history or tab completion.
- cash also does not support process output redirection outside `>`.
- Filesystem links and FIFOs are currently not implemented, but they are planned for a future release.
- sudo/su currently don't have PATH resolution, so you must pass the full file path for commands.
- sudo also does not have any sudoers control or password caching.
- The halt and reboot commands do not go through startmgr, so services aren't safely stopped - use `shutdown` or `startctl shutdown/reboot` instead.
- libsystem.serialization is currently missing Lua table serialization functions.
- nano is severely incomplete, and only supports basic editing features at the moment.

When you run into issues, please submit an issue report to [the public issue tracker](https://github.com/Phoenix-ComputerCraft/issues). Please check for duplicate reports before posting your own!

## Future Plans
You may notice that there is no public source repository for Phoenix, and that the license is very restrictive. I do not intend to make Phoenix open-source until it reaches version 1.0, and the code will remain proprietary until then. This may be considered impractical with a scripting language like Lua, but all public code will be minified, which makes reading the code nearly as impractical as reading a disassembled binary.

I plan to update the Phoenix public alpha every week or two until it reaches a decently well-working state, mainly for bugfixes and completing features that aren't complete now. After that, I may take a break to work on new features or the graphical portion of the OS.

At some point in the future, I will be announcing a Patreon page for Phoenix. Here, I will be posting weekly updates for Phoenix, development builds of the desktop environment (which is the only place it will be available before 1.0), and more. The public alpha version will still be maintained, but it will not receive major upgrades or GUI functionality, and updates will release only once a month or so.

Once Phoenix is in a stable state, and I've implemented all of the major features, Phoenix will enter beta, where development will focus on fixing bugs and generally improving the user experience. During this time, the base system will be available to all users for free, and updates will ship at the same time. However, the desktop will remain exclusive to Patreon supporters.

After a few months in beta, once the system is running smoothly, Phoenix 1.0 will be officially released. With this, the entire project will become open-sourced on GitHub, including the desktop environment. The Patreon page will no longer be as relevant, but I may still use it for development updates or early previews.

I understand that putting much of the OS behind a paywall will disappoint people. I'm doing this because I will not have as much time to work on Phoenix after this; and knowing I have supporters will help motivate me to speed up development. ~~(Also because I like money :P.)~~ If I ever come to a point where I cannot continue development on Phoenix, I promise to open-source all of the code at that point for anyone to download and use.

-----

All documentation for Phoenix will be available on the official website at https://phoenix.madefor.cc as usual. Since full annotated source is not available, I will be posting documentation for all components of Phoenix (besides a few POSIX utilities and libcraftos) on the website. Documentation for the syscalls, libsystem, startmgr, usermgr, pxboot, and some other general information is already posted, and I will be expanding this to include the kernel API in the near future.

I hope you enjoy this preview of the Phoenix operating system, and please look forward to future updates with even more content.