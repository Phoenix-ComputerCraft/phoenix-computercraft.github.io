---
layout: default
title: Hardware interfaces
parent: System Calls
---

# Hardware interfaces
These syscalls provide some miscellaneous functionality to interact with the hardware of the computer.

## `shutdown()`
Shuts down the computer.

## `reboot()`
Reboots the computer.

## `computerid(): number`
Returns the computer's ID.

## `gethostname(): string`
Returns the computer's label.

## `sethostname(name: string)`
Sets the computer's label.

## `version(buildnum: boolean)`
Returns the Phoenix version or build number.

## `cchost(): string`
Returns the value of the `_HOST` variable.