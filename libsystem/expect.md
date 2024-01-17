---
layout: default
title: system.expect
parent: libsystem
---

# system.expect
The expect module provides error checking functions for other libraries.

## `expect(index: number, value: any, ...: string|function(v):boolean): any`
Check that a numbered argument matches the expected type(s).  If the type
 doesn't match, throw an error.
 This function supports custom types by checking the __name metaproperty.
 Passing the result of @{expect.struct}, @{expect.array}, or @{expect.match}
 as a type parameter will use that function as a validator.

### Arguments
1. `index`: The index of the argument to check
2. `value`: The value to check
3. `...`: The types to check for

### Return Values
`value`

## `field(tbl: any, key: any, ...: string|function(v):boolean): any`
Check that a key in a table matches the expected type(s).  If the type
 doesn't match, throw an error.
 This function supports custom types by checking the __name metaproperty.
 Passing the result of @{expect.struct}, @{expect.array}, or @{expect.match}
 as a type parameter will use that function as a validator.

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

## `struct(struct: table): function(v):boolean`
Provides a special type that can check all of the fields of a table at once.

 The `struct` parameter defines the structure of the table. This is a key-
 value table, where the key is the name of the field and the value is the
 expected type(s) of the field.
 - If the value is a single string, the field must be that type.
 - If the value is a list of strings, the field must be one of those types.
 - Any type can be replaced by one of the special types as with @{expect.expect}.


### Arguments
1. `struct`: The expected structure of the table

### Return Values
A checker function, to be passed to <a href="expect.html#expect">expect.expect</a>

## `array(types: string|string[]): function(v):boolean`
Provides a special type that can check for an array.

### Arguments
1. `types`: The type(s) to check for in each member

### Return Values
A checker function, to be passed to <a href="expect.html#expect">expect.expect</a>

## `table(types: string|string[]): function(v):boolean`
Provides a special type that can check for a table with all entries.

### Arguments
1. `types`: The type(s) to check for in each member

### Return Values
A checker function, to be passed to <a href="expect.html#expect">expect.expect</a>

## `match(pattern: string): function(v):boolean`
Provides a special type that can check for a string matching a pattern.

### Arguments
1. `pattern`: The pattern to check on the string

### Return Values
A checker function, to be passed to <a href="expect.html#expect">expect.expect</a>

