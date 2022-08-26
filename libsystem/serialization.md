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

