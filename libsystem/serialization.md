---
layout: default
title: system.serialization
parent: libsystem
---

# system.serialization
The serialization module provides functions for serializing and deserializing
 objects in multiple formats, as well as some miscellaneous encoding types.

# serialization.base64


## `serialization.base64.encode(str: string): string`
Encodes a binary string into Base64.

### Arguments
1. `str`: The string to encode

### Return Values
The string's representation in Base64

## `serialization.base64.decode(str: string): string`
Decodes a Base64 string to binary.

### Arguments
1. `str`: The Base64 to decode

### Return Values
The decoded data

# serialization.json


## `serialization.json.encode(val: any): string`
Serializes an arbitrary Lua object into a JSON string.

### Arguments
1. `val`: The value to encode

### Return Values
The JSON representation of the object

## `serialization.json.decode(str: string): any`
Parses a JSON string and returns a Lua value represented by the string.

### Arguments
1. `str`: The JSON string to decode

### Return Values
The Lua value from the JSON

## `serialization.json.save(val: any, path: string)`
Saves a Lua value to a JSON file.

### Arguments
1. `val`: The value to save
2. `path`: The path to the file to save

### Return Values
This function does not return anything.

## `serialization.json.load(path: string): any`
Loads a JSON file into a Lua value.

### Arguments
1. `path`: The path to the file to load

### Return Values
The loaded value

# serialization.lua


## `serialization.lua.encode(val: any, opts: {minified=boolean,allow_functions=boolean}?): string`
Serializes an arbitrary Lua object into a serialized Lua string.

### Arguments
1. `val`: The value to encode
2. `opts`: Any options to specify while encoding (optional)

### Return Values
The serialized Lua representation of the object

## `serialization.lua.decode(str: string, opts: {allow_functions=boolean}?): any`
Parses a serialized Lua string and returns a Lua value represented by the string.

### Arguments
1. `str`: The serialized Lua string to decode
2. `opts`: Any options to specify while decoding (optional)

### Return Values
The Lua value from the serialized Lua

## `serialization.lua.save(val: any, path: string, opts: {minified=boolean,allow_functions=boolean}?)`
Saves a Lua value to a serialized Lua file.

### Arguments
1. `val`: The value to save
2. `path`: The path to the file to save
3. `opts`: Any options to specify while encoding (optional)

### Return Values
This function does not return anything.

## `serialization.lua.load(path: string, opts: {allow_functions=boolean}?): any`
Loads a serialized Lua file into a Lua value.

### Arguments
1. `path`: The path to the file to load
2. `opts`: Any options to specify while decoding (optional)

### Return Values
The loaded value

