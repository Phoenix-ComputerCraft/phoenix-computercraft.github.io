---
layout: default
title: libsystem
has_children: true
---

# libsystem
libsystem is the default system library for Phoenix. It provides convenient library functions for interacting with the kernel and other useful routines. libsystem attempts to implement all of the functionality of CraftOS in a new API that's cleaner and more in-line with Phoenix's design.

## Installation
Simply copy all Lua files into `/lib/system`, or copy a built `libsystem.a` to `/lib`.

## Usage
Load any module in this library with `local module = require "system.module"`. See the pages below for more information on how to use each module.
