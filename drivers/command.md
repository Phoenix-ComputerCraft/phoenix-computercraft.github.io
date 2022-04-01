---
layout: default
title: Command Block
parent: Drivers
---

# `command`
This type represents a command block. All commands require root access to use.

## Drivers that use this type
* `peripheral_command`: Implements for networked command blocks.

## Properties
* `command: string {get set}`: The command stored in the block

## Methods
* `run(): boolean, string?`: Run the command in the command block.