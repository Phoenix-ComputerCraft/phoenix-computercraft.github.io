---
layout: default
title: system.keys
parent: libsystem
---

# system.keys
The keys module assigns names to the keycode constants that Phoenix sends in
 key events, and adds a few functions to make using them easier.  This module
 uses the same names as the CraftOS `keys` API, so porting programs should be
 trivial.


## `getName(id: number): string|nil`
Returns the name for the specified keycode.

### Arguments
1. `id`: The keycode to check

### Return Values
The name (which is a key in `keys`), or `nil` if the code is invalid

## `getCharacter(id: number): string|nil`
Returns a printable representation of the keycode if available.

### Arguments
1. `id`: The keycode to check

### Return Values
The keycode's character (in lowercase), or `nil` if the code doesn't have a printable representation

