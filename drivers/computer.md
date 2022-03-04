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

## Properties
* `isOn: boolean`: Whether the computer is currently on
* `id: number`: The ID of the computer
* `label: string?`: The label of the computer

## Methods
* `turnOn()`: Turns the computer on.
* `shutdown()`: Shuts down the computer. (Requires root)
  * This syscall never returns if used on the root computer.
* `reboot()`: Reboots the computer. (Requires root)
  * This syscall never returns if used on the root computer.
* `setLabel(label: string?)`: Sets the label on the computer.
  * Only effective on the root computer.