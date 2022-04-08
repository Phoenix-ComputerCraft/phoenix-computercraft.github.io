---
layout: default
title: Networking
parent: System Calls
---

# Networking
These syscalls provide networking capabilities, including both local computer connections as well as external HTTP/WebSocket connections.

## `connect(options: table|string, device: string?): Handle?`
Creates a connection to a remote resource using the specified options table or URI.

The following URI schemes are built-in:
* `http`/`https`: Internet HTTP requests
* `ws`/`wss`: Internet WebSocket connections
* `rednet[+protocol]`: Rednet I/O (does not negotiate a connection)
* `psp`: Phoenix Socket Protocol connections

Other schemes may be implemented in kernel modules.

### Arguments
1. `options`: Either a string with a URI (no options), or a table with the following elements:
  * `url: string`: The URI to connect to (required)
  * `method: string`: For HTTP connections, the method to use when connecting (defaults to `"GET"`)
  * `encoding: "utf8" | "utf-8" | "binary"`: Encoding to use when transferring data (defaults to `"binary"`)
  * `redirect: boolean`: Whether to automatically redirect responses that indicate a redirect (defaults to `true`)
2. `device`: The path to the device to use to establish the connection (usually a modem), or `nil` to use the default. For local connections, the default is all available modems.

### Return Values
A handle object that can be used to send/receive data, or `nil` + an error if the handle could not be created. The handle is not guaranteed to be ready to send/receive data immediately, however, so the `status` method should be checked before using.

### Errors
This syscall does not throw any errors.

## `checkuri(uri: string): boolean`
Returns whether the specified URI is valid and the scheme is supported.

### Arguments
1. `uri`: The URI to check

### Return Values
Whether the URI is valid. This will always return `false` for an unsupported URI scheme. For HTTP and WebSocket URLs, this will check that the URL can be connected to as well.

### Errors
This syscall does not throw any errors.

-----

# Handles
The `connect` syscall returns a handle object for the specific protocol that was requested. These handles all contain a common set of methods, as well as some special methods that are specific to each protocol.

All handles have an `id` field, which is a number that uniquely identifies the connection. This ID is used in `handle_status_change` events to indicate which handle has changed status.

## `status(): "ready"|"connecting"|"error"|"open"|"closed", string?`
Returns the current status of the handle/connection.

### Arguments
This method does not take any arguments.

### Return Values
The current status of the handle/connection. These are the currently assigned statuses:
* `ready`: Indicates the handle is ready to send data, but a connection has not yet been established.
* `connecting`: Indicates the handle sent a connection request, and is currently awaiting a response. The handle is not ready to send or receive data.
* `error`: Indicates an error has occurred while connecting to the server, and no data has been sent or received. This handle may no longer be used. More information may be supplied in a second return value.
* `open`: Indicates the connection has been established, and data can be received (and possibly sent).
* `closed`: Indicates the connection has been closed, and no data may be sent or received. This handle may no longer be used.

### Errors
This method does not throw any errors.

## `read(mode...: string|number): string|number|nil...`
Read one or more values from the connection in a manner similar to `io.file:read`.

### Arguments
1. `mode...`: The read mode to use. This may be one of the following options:
  * `*a`: Read all data available in the connection.
  * `*l`: Read a line, excluding the final newline.
  * `*L`: Read a line, including the final newline.
  * `*n`: Read a number value if available.
  * (any number): Read the specified number of characters/bytes.
  If no arguments are specified, this defaults to `read("*l")`.

### Return Values
The values extracted from the connection. If one of the modes could not be read, the value returned for that parameter and all ones after are `nil`.

### Errors
This method may throw an error if:
* The handle is not currently open.

## `write(data...: any)`
Writes the supplied values to the connection.

### Arguments
1. `data...`: The values to write. Values that are not strings will be converted with `tostring`.

### Return Values
This method does not return anything.

### Errors
This method may throw an error if:
* The handle is not currently open or ready.

## `close()`
Closes the connection.

### Arguments
This method does not take any arguments.

### Return Values
This method does not return anything.

### Errors
This method may throw an error if:
* The connection is not currently open.

## HTTP handles
HTTP\[S\] handles have a special flow to work properly. Upon creating the handle, it will be set in the `ready` state, and no request is sent yet. The request is only sent once the `write` method is called once. After that, the `write` method will no longer function, so make sure to add all data in the request in that `write` call. Even if no data needs to be sent (e.g. `GET` method), `write` must be called exactly once, even if it's with no data.

After calling `write`, the handle will shift into `connecting` status, awaiting a response from the server. The client must wait for `status` to change to `open` before attempting to read data. After that, the handle functions like a normal read-only handle.

HTTP handles have the following additional methods:

### `responseHeaders(): {[string]: string}`
Returns the headers contained in the response.

#### Arguments
This method does not take any arguments.

#### Return Values
A key-value table of headers sent back from the server.

#### Errors
This method may throw an error if:
* The connection is not currently open.

### `responseCode(): number`
Returns the HTTP response code returned from the server.

#### Arguments
This method does not take any arguments.

#### Return Values
The response code sent from the server.

#### Errors
This method may throw an error if:
* The connection is not currently open.
