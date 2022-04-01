---
layout: default
title: Generic Fluid Storage
parent: Drivers
---

# `fluid_storage`
This type represents a generic fluid storage peripheral.

## Drivers that use this type
* `peripheral_fluid_storage`: Implements for networked fluid storage blocks.

## Properties
* `tanks: [{name: string, amount: number}] {get}`: A list of tanks in the peripheral with their contents

## Methods
* `push(to: string[, limit: number[, name: string]]): number`: Transfers fluid from this tank into another one.
  * `to`: The ID, path, or UUID of the other tank. This tank must be on the same network, meaning they must be siblings in the device tree. Trying to use a tank that is not on the same network will throw an error. If a device ID is specified, only a device on the same network is used.
  * `limit`: The maximum amount of fluid to move; defaults to the whole tank.
  * `name`: The type of fluid to move; defaults to an arbitrary choice.
  * Returns the amount of fluid moved.
* `pull(from: string[, limit: number[, name: string]]): number`: Transfers fluid from another tank into this one.
  * `from`: The ID, path, or UUID of the other tank. This tank must be on the same network, meaning they must be siblings in the device tree. Trying to use a tank that is not on the same network will throw an error. If a device ID is specified, only a device on the same network is used.
  * `limit`: The maximum amount of fluid to move; defaults to the whole tank.
  * `name`: The type of fluid to move; defaults to an arbitrary choice.
  * Returns the amount of fluid moved.