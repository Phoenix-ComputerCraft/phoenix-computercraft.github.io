---
layout: default
title: Computer
parent: Drivers
---

# `computer`
This type is used to represent a computer node.

## Drivers that use this type
* `root`: Implements for the root (local) computer.
* `peripheral_computer`: Implements for networked computers.

## Metadata
* `id: number`: The ID of the computer

## Properties
* `isOn: boolean {get}`: Whether the computer is currently on
* `label: string? {get set?}`: The label of the computer
  * Read-only on all computers except ones implemented by `root`

## Methods
* `turnOn()`: Turns the computer on. (Requires root)
* `shutdown()`: Shuts down the computer. (Requires root)
  * This syscall never returns if used on the root computer.
* `reboot()`: Reboots the computer. (Requires root)
  * This syscall never returns if used on the root computer.

## Events (`root` only)
* `device_added`: Sent when a new device is added to the computer.
  * `device: string`: The path of the new device
* `device_removed`: Sent when a device is removed from the computer.
  * `device: string`: The path of the removed device