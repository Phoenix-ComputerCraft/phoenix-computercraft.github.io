---
layout: default
title: system.expect
parent: libsystem
---

# system.expect
The expect module provides error checking functions for other libraries.

## `expect(index: number, value: any, ...: string): any`
Check that a numbered argument matches the expected type(s).  If the type
 doesn't match, throw an error.
 This function supports custom types by checking the __name metaproperty.

### Arguments
1. `index`: The index of the argument to check
2. `value`: The value to check
3. `...`: The types to check for

### Return Values
`value`

## `field(tbl: any, key: any, ...: string): any`
Check that a key in a table matches the expected type(s).  If the type
 doesn't match, throw an error.
 This function supports custom types by checking the __name metaproperty.

### Arguments
1. `tbl`: The table (or other indexable value) to search through
2. `key`: The key of the table to check
3. `...`: The types to check for

### Return Values
The indexed value in the table

## `range(num: number[, min: number = -math.huge][, max: number = math.huge]): number`
Check that a number is between the specified minimum and maximum values.  If
 the number is out of bounds, throw an error.

### Arguments
1. `num`: The number to check
2. `min`: The minimum value of the number (inclusive) (defaults to -math.huge)
3. `max`: The maximum value of the number (inclusive) (defaults to math.huge)

### Return Values
`num`

