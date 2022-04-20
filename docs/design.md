---
layout: default
title: OS Design
parent: Documentation
---

# OS Design
This page lists some general information about the design of the Phoenix operating system.

## Goals
Phoenix is designed with a few main goals in mind:
- Modular
- POSIX-inspired, but not tied to any particular goal
- Takes full advantage of Lua - act as extension over original language design
- Simple to use, easy to extend
- Include all features of CraftOS in new, more sensible & extensible forms
- Evolving, not set in stone until 1.0
- Documentation-based - document first, then implement
- Keep the code CCPL-free, use as little of CraftOS as possible

## Modularity
The Phoenix operating system is actually a default distribution of components:
- pxboot bootloader
- Phoenix kernel
- startd init system
- libsystem system libraries
- baseutils core program pack
- apt-lua package manager
- in graphical versions (TBD):
  - CCKit2 GUI library
  - Swift/PhoenixWM window server + desktop manager
  - pxapps (?) application suite

Because of Phoenix's modularity, a Phoenix distribution may contain any combination of components, or it may swap out some default components for alternative versions This architecture is similar to how Linux is usually distributed with the de facto glibc/GNU coreutils, but some distros opt for musl libc/BusyBox coreutils instead. Alternative packages will not be developed as first-party packages, but others may make them as desired.

Modularity is also clearly defined through the Lua module structure and the syscall layer. Libraries and programs may mix and match use of these modules, including exporting their own alternative formats to be expanded on instead of the first-party interfaces.

## POSIX compliance
Phoenix is based on a principle of "POSIX-like, but not strictly POSIX". The kernel is not designed to be POSIX compatible in any way, except for taking inspiration from it for a few syscall names. However, the userspace is intended to be POSIX-compatible. baseutils is written to be as POSIX.1-2017 compatible as possible, and the filesystem is based on the Filesystem Hierarchy Standard 3.0. (This is not strictly required of all distributions, however.)

The reasoning for this is to make the OS easy to use for those who already know Linux/UNIX systems, without having to force through concepts that don't fit the Lua ecosystem. I also explicitly chose not to follow the UNIXian "everything is a file" philosophy. While this makes some operations harder to do from basic scripts, all of the code is in scripts anyway, so I feel it isn't a huge blocker. In addition, making things be accessed through files removes the ability to use Lua concepts like tables.
