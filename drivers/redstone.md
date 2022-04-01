---
layout: default
title: Redstone
parent: Drivers
---

# `redstone`
This type is used to represent a single side of a device that can input/output redstone signals.

## Drivers that use this type
* `root_redstone`: Implements for the main computer through the CC `redstone` API.

## Properties
* `input: number|nil {get}`: The current redstone level being input from 1-15, or `nil` if there is none
* `output: number|nil {get set}`: The current redstone level being output from 1-15, or `nil` if there is none
* `bundledInput: number|nil {get}`: The current bundled redstone signal being input, as a 16-bit bitmask (`nil` if unavailable)
* `bundledOutput: number|nil {get set}`: The current redstone level being output, as a 16-bit bitmask (`nil` if unavailable)
