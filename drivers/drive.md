---
layout: default
title: Disk Drive
parent: Drivers
---

# `drive`
This type is used to represent a disk drive peripheral.

## Drivers that use this type
* `peripheral_drive`: Implements for disk drive peripherals.

## Properties
* `state: {isAudio: boolean, label: string?, id: number?}?`: Information about the current inserted disk, if one is available.

## Methods
* `setLabel(label: string?)`: Sets the label of the disk, if a disk is currently inserted. Throws otherwise.
* `play()`: Plays the current music disc if one is inserted. Throws otherwise.
* `stop()`: Stops the current music disc if one is inserted.
* `eject()`: Ejects the disk that is currently in the drive.
* `insert(path: string)`: On CraftOS-PC: Changes the path of the disk that is currently inserted in the drive. (Requires root)