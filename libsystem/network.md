---
layout: default
title: system.network
parent: libsystem
---

# system.network
The network module implements functions for making and hosting connections
 with local and Internet-connected computers, as well as managing the network
 stack configuration.

## `connect(options: string|table): Handle`
Creates a new connection to a remote server.

### Arguments
1. `options`: The URI to connect with, or a table of options
 (see the connect syscall docs for more information)

### Return Values
A handle to the connection

## `get(options: string|table): Handle / nil, string`
Connects to an HTTP(S) server, sends a GET request and waits for a response.

### Arguments
1. `options`: The URL to connect to, or a table of options
 (see the connect syscall docs for more information)

### Return Values
This function may return the following values:
1. The handle to the response data

Or:
1. If the connection failed
2. An error describing why the connection failed

## `getData(url: string, headers: table?): string / nil, string`
Connects to an HTTP(S) server, sends a GET request, waits for a response,
 and returns the data received after closing the connection.

### Arguments
1. `url`: The URL to connect to
2. `headers`: Any headers to send in the request (optional)

### Return Values
This function may return the following values:
1. The response data sent from the server

Or:
1. If the connection failed
2. An error describing why the connection failed

## `head(options: string|table): Handle / nil, string`
Connects to an HTTP(S) server, sends a HEAD request and waits for a response.

### Arguments
1. `options`: The URL to connect to, or a table of options
 (see the connect syscall docs for more information)

### Return Values
This function may return the following values:
1. The handle to the response data

Or:
1. If the connection failed
2. An error describing why the connection failed

## `options(options: string|table): Handle / nil, string`
Connects to an HTTP(S) server, sends an OPTIONS request and waits for a response.

### Arguments
1. `options`: The URL to connect to, or a table of options
 (see the connect syscall docs for more information)

### Return Values
This function may return the following values:
1. The handle to the response data

Or:
1. If the connection failed
2. An error describing why the connection failed

## `post(options: string|table, data: string): Handle / nil, string`
Connects to an HTTP(S) server, sends a POST request and waits for a response.

### Arguments
1. `options`: The URL to connect to, or a table of options
 (see the connect syscall docs for more information)
2. `data`: The data to send to the server

### Return Values
This function may return the following values:
1. The handle to the response data

Or:
1. If the connection failed
2. An error describing why the connection failed

## `put(options: string|table, data: string): Handle / nil, string`
Connects to an HTTP(S) server, sends a PUT request and waits for a response.

### Arguments
1. `options`: The URL to connect to, or a table of options
 (see the connect syscall docs for more information)
2. `data`: The data to send to the server

### Return Values
This function may return the following values:
1. The handle to the response data

Or:
1. If the connection failed
2. An error describing why the connection failed

## `delete(options: string|table, data: string?): Handle / nil, string`
Connects to an HTTP(S) server, sends a DELETE request and waits for a response.

### Arguments
1. `options`: The URL to connect to, or a table of options
 (see the connect syscall docs for more information)
2. `data`: The data to send to the server, if required (optional)

### Return Values
This function may return the following values:
1. The handle to the response data

Or:
1. If the connection failed
2. An error describing why the connection failed

