---
layout: default
title: Generic Inventory
parent: Drivers
---

# `inventory`
This type represents a generic inventory peripheral.

## Drivers that use this type
* `peripheral_inventory`: Implements for networked inventories.

## Properties
* `size: number {get}`: The number of slots in the inventory
* `items: [{name: string, count: number, nbt: string?}] {get}`: The basic contents of the inventory

## Methods
* `detail(slot: number): ItemDetail?`: Reads extended item detail for a single slot.
* `limit(slot: number): number`: Returns the maximum number of items that can be stored in the inventory at the specified slot.
* `push(to: string, slot: number[, limit: number[, toSlot: number]]): number`: Transfers items in a slot in this inventory to another inventory.
  * `to`: The ID, path, or UUID of the other inventory. This inventory must be on the same network, meaning they must be siblings in the device tree. Trying to use an inventory that is not on the same network will throw an error. If a device ID is specified, only a device on the same network is used.
  * `slot`: The slot to take items from.
  * `limit`: The maximum number of items to move; defaults to the whole slot.
  * `toSlot`: The destination slot to put items in; defaults to the first slot available.
  * Returns the number of items moved.
* `pull(from: string, slot: number[, limit: number[, toSlot: number]]): number`: Transfers items in a slot in another inventory to this inventory.
  * `from`: The ID, path, or UUID of the other inventory. This inventory must be on the same network, meaning they must be siblings in the device tree. Trying to use an inventory that is not on the same network will throw an error. If a device ID is specified, only a device on the same network is used.
  * `slot`: The slot to take items from.
  * `limit`: The maximum number of items to move; defaults to the whole slot.
  * `toSlot`: The destination slot to put items in; defaults to the first slot available.
  * Returns the number of items moved.

### `ItemDetail` definition
```ts
type ItemDetail = {
    name: string,
    count: number,
    nbt?: string,
    displayName: string,
    maxCount: number,
    damage?: number,
    maxDamage?: number,
    durability?: number,
    lore?: [string],
    enchantments?: [{name: string, level: number, displayName: string}],
    unbreakable?: boolean
}
```