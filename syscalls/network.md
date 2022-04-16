---
layout: default
title: Networking
parent: System Calls
---

# Networking
These syscalls provide networking capabilities, including both local computer connections as well as external HTTP/WebSocket connections.

## `connect(options: table|string): Handle?`
Creates a connection to a remote resource using the specified options table or URI.

The following URI schemes are built-in:
* `http`/`https`: Internet HTTP requests
* `ws`/`wss`: Internet WebSocket connections
* `rednet[+protocol]`: Rednet I/O (does not negotiate a connection)
* `psp`: Phoenix Socket Protocol connections

Other schemes may be implemented in kernel modules.

### Arguments
1. `options`: Either a string with a URI (no options), or a table with any of the following elements:
  * `url: string`: The URI to connect to (required)
  * `encoding: "utf8" | "utf-8" | "binary"`: HTTP/WS: Encoding to use when transferring data (defaults to `"binary"`)
  * `headers: {[string] = string}`: HTTP/WS: Any headers to send in the request
  * `method: string`: HTTP: The method to use when connecting (defaults to `"GET"`)
  * `redirect: boolean`: HTTP: Whether to automatically redirect responses that indicate a redirect (defaults to `true`)
  * `device: string`: Rednet/PSP: The path to the device to use to establish the connection (usually a modem), or `nil` to use all modems (note: if this path points to multiple devices, all are used)

### Return Values
A handle object that can be used to send/receive data, or `nil` + an error if the handle could not be created. The handle is not guaranteed to be ready to send/receive data immediately, however, so the `status` method should be checked before using.

### Errors
This syscall may throw an error if:
* The URI specified is malformed.
* The scheme in the URI is not supported.
* The device is not present.
* The device is not a valid modem.

## `listen(uri: string)`
Starts listening for connections on the specified URI, using the protocol, IP, and port indicated in the URI. For PSP connections, the IP is used to determine the device to listen on - if this is `0.0.0.0`, then all connections are accepted.

When a request is received, a `network_request` event is sent with the URI of the listener, the IP of the other computer (if available), and a handle to the connection. Listening will continue until `unlisten` is called with the same URI.

The following URI schemes are built-in:
* `http`/`https`: Internet HTTP requests (CraftOS-PC only)
* `ws`/`wss`: Internet WebSocket connections (CraftOS-PC only)
* `psp`: Phoenix Socket Protocol connections

Other schemes may be implemented in kernel modules.

### Arguments
1. `uri`: The URI to listen on. The path portion is ignored.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The URI specified is malformed.
* The scheme in the URI is not supported.
* The computer does not own the IP in the URI.
* The computer is already using the IP/port specified.

## `unlisten(uri: string)`
Stops listening on a URI previously passed to `listen`. This does not close any handles that are in use.

### Arguments
1. `uri`: The URI to listen on. The path portion is ignored.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The computer is not listening on the specified URI.

## `ipconfig(device: string, info: table?): table`
Returns a table with information about the current PIP configuration for the specified modem, and optionally sets new options (requires root).

### Arguments
1. `device`: The path to the modem to operate on
2. `info`: If provided, a table of configuration options to set on the device, in the same format as the returned table

### Return Values
A table of PIP configuration entries. These are the currently used members:
* `ip: string`: The IP address of the modem. No IP is indicated with an empty string. (When setting, this may also be a 32-bit number representing the IP in big-endian format.)
* `netmask: number`: The subnet mask expressed as a number of bits, as in CIDR notation. No subnet mask is indicated with a value of `0`. (When setting, this may also be an IP-formatted address string.)
* `up: boolean`: Whether the link is currently up. If a link is down, no Phoenix networking protocols will be serviced on this device. (This allows user applications to manually manage the protocols instead, if required.)

### Errors
This syscall may throw an error if:
* The device is not present.
* The device is not a valid modem.
* A non-root user attempted to set configurations.

## `routelist(num: number?): table?`
Returns a list of route entries in the specified route table.

### Arguments
1. `num`: The table number to check as an integer starting at 0 (default 1)

### Return Values
A list of route entries with the following fields:
* `source: string`: The bottom end of the source IP range.
* `sourceNetmask: number`: The source subnet mask. For a single IP, this is 32. For all IPs (`default`), this is 0.
* `action: string`: The action to take on the message. Valid values:
  * `"unicast"`: Send all messages to the specified destination.
  * `"broadcast"`: Broadcast the message to all destinations on the device.
  * `"local"`: Send the message to a known destination on a local network.
  * `"unreachable"`: Send a Destination Unreachable message back to the sender.
  * `"prohibit"`: Send a Prohibit message back to the sender.
  * `"blackhole"`: Ignore the message altogether.
* `device: string?`: The device path to send the message to.
* `destination: string?`: The destination IP to forward to.

If the specified table does not exist, this will return `nil`.

### Errors
This syscall does not throw any errors.

## `routeadd(options: table)`
Adds a new route to the specified route table. If the table does not exist, it will be created.

### Arguments
1. `options`: A table with options for the route entry, as specified in the return value section for `routelist`. It can also contain a `table` entry, which is a number specifying the table index to insert into (integer starting at 0; defaults to 1). The actions `"unicast"` and `"broadcast"` both require `device`; `"unicast"` also requires `destination`.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* A non-root user attempted to add routes.
* A route already exists with the same IP and netmask.
* The device (if specified) is not present.
* The device (if specified) is not a valid modem.

## `routedel(source: string, num: number?)`
Removes the specified route from the specified table.

### Arguments
1. `source`: The source IP address to remove in CIDR notation (e.g. `192.168.0.0/16`)
2. `num`: The table number to modify as an integer starting at 0 (default 1)

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* A non-root user attempted to remove routes.

## `arplist(device: string): {[string] = number}`
Returns the list of known IP to computer ID mappings for the specified device.

### Arguments
1. `device`: The path to the modem to query for.

### Return Values
A key-value table of mappings from IP addresses to computer IDs.

### Errors
This syscall may throw an error if:
* The device is not present.
* The device is not a valid modem.

## `arpadd(device: string, ip: string, id: number)`
Adds a computer ID mapping for the specified IP on the requested device.

### Arguments
1. `device`: The path to the modem to add for.
2. `ip`: The IP address of the target computer.
3. `id`: The computer ID of the target computer.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The current user is not root.
* The device is not present.
* The device is not a valid modem.
* A mapping already exists for the specified IP.

## `arpdel(device: string, ip: string)`
Removes the computer ID mapping for the specified IP on the requested device.

### Arguments
1. `device`: The path to the modem to remove for.
2. `ip`: The IP address of the computer to remove.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The current user is not root.
* The device is not present.
* The device is not a valid modem.

## `netcontrol(ip: string, type: string, err: string?)`
Sends a control message to the specified IP address.

### Arguments
1. `ip`: The IP address to send to
2. `type`: The message type to send. See [the network documentation](/docs/network.html#message-control-protocol) for more information.
3. `err`: An optional error message to send if necessary.

### Return Values
This syscall does not return anything.

### Errors
This syscall may throw an error if:
* The current user is not root.

## `netevent(state: boolean?): boolean`
Returns the current state of network event reporting in the current process, and toggles it if desired. This allows listening to events such as control messages, PSP messages, send failures, etc.

### Arguments
1. `state`: If specified, whether to send general network events to the current process

### Return Values
The current state of network event reporting.

### Errors
This syscall may throw an error if:
* The current user is not root.

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
1. `data...`: The values to write. Values that are not strings will be converted with `tostring`, unless otherwise specified by the handle type.

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
