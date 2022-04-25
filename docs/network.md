---
layout: default
title: Networking
parent: Documentation
---

# Networking
Phoenix's network stack attempts to simplify the API for network connections both in-game and online, while also adding more flexible and standard options for local connections. All connections pass through the `connect` syscall, which takes a standard URI and uses the scheme to determine how to connect to the remote system, whether local or online. Kernel modules have the ability to add additional schemes, allowing for more protocol support using the same interface.

## Rednet support
Phoenix includes built-in support for Rednet to allow basic backwards compatibility with CraftOS. To communicate over Rednet, call `connect` with a scheme in the form `rednet[+protocol]` and an IP in the `0.0.0.0/8` range, which represents the target computer's ID. (Example: `rednet://0.0.0.4` = ID 4, `rednet+dns://0.0.2.56` = ID 168 with `dns` protocol.) The special IP `255.255.255.255` can be used to broadcast to all computers, as well as listen to messages from all computers.

The returned handle will be ready to send and receive Rednet messages using the modem specified (or all if none was specified). Because Rednet is a connectionless protocol, the handle will always remain open (until closed) and can never error. Incoming messages are converted to strings automatically unless reading with the `"*a"` mode, but outgoing messages remain as-is.

## Kernel protocols
The Phoenix kernel implements a number of protocols that establish a full networking stack up to the transport layer. These protocols are documented here.

Each of the following protocols uses a basic table format to hold data in transit. A message at each layer is contained in a table with at least three basic members:
* `PhoenixNetworking`: Always set to `true` to indicate this message is part of the Phoenix network stack.
* `type`: A string that stores the type/protocol of the packet.
* `payload`: A value (usually a table) with the contents of the message.

Protocols also define their own members outside the common members here.

Channel numbers in the modem API are used in PSP (see below) for port numbers. However, for protocols that do not use ports (such as address resolution), channel 0 should be used. This channel is not allowed in PSP.

### Phoenix Link Protocol (PLP)
Phoenix uses a protocol similar to Rednet to transfer data between two computers. This implements the Link layer of the TCP/IP model. PLP has the type `"link"`, and has the following members:
* `source`: The ID of the sending computer.
* `destination`: The ID of the receiving computer. If unspecified, this is a broadcast message.

### Address resolution protocol
To resolve IP addresses to computer IDs, and to check for IP collisions, an address resolution protocol is used. This protocol is separate from the TCP/IP ARP standard, but functions the same. It has the type `"arp"`, and has the following members:
* `source`: The ID of the sending computer.
* `sourceIP`: The IP address of the sending computer as a string.
* `destination`: The ID of the receiving computer, if known.
* `destinationIP`: The IP address of the receiving computer as a string.
* `reply`: `false` if this is a request, `true` if this is a reply.

This protocol has no `payload` field.

To request an ID for an IP address, send a message with `reply` set to `false`, and `destination` set to `nil` on channel 0. To reply, set `reply` to `true`, fill in all information, and send back on channel 0.

The source IP may be omitted in requests if unknown. In that case, the destination IP will be omitted in the reply. The destination IP MUST be sent in a request (as this is how the IP is resolved), and the source MUST be sent in a reply.

### Phoenix Internet Protocol (PIP)
The Phoenix Internet Protocol (PIP) is used to manage connections between independent networks. It is based on IPv4, and uses IPv4 addresses to identify computers. This implements the Internet layer of the TCP/IP model. It has the type `"internet"`, and has the following members:
* `source`: The IP address of the sending computer as a string.
* `destination`: The IP address of the receiving computer as a string.
* `messageID`: A unique identifier for the message. Duplicate messages with the same ID should be discarded.
* `hopsLeft`: A number that indicates the number of times the message should be passed along routers until being discarded. This should be decremented by one each time it's passed through a router, and if it becomes zero, the packet should be discarded and a control message with a `"timeout"` error should be sent back to the original sender.

### Message control protocol
This protocol is used inside a PIP packet to indicate control messages about the PIP connection. It has the type `"control"`, and has the following members:
* `messageType`: The type of message that is being sent. This may be one of the following values:
  * `"ping"`: Indicates a ping request, and should be replied to with a subsequent `pong` message
  * `"pong"`: Indicates a reply to a previous `ping` request.
  * `"unreachable"`: Indicates a previous message was unable to be sent to the destination.
  * `"timeout"`: Indicates a previous message was rerouted too many times and was rejected.
* `error`: If set, contains additional information on why the message was sent.

The payload contains the PIP message that triggered the control message, if present.

### Phoenix Socket Protocol (PSP)
The Phoenix Socket Protocol (PSP) provides a reliable bidirectional socket connection between two computers. PSP is based on TCP, and is the main protocol exposed to user programs. This implements the Transport layer of the TCP/IP model. It has the type `"socket"`, and has the following members:
* `sequence`: The sequence number of the current message.
* `acknowledgement`: If set, indicates the message was received, and records the next sequence number the system is expecting (last sequence + 1).
* `windowSize`: The number of subsequent messages the other computer may send before it must wait for a window size update.
* `synchronize`: If set to `true`, indicates synchronization of the sequence number.
* `final`: If set to `true`, indicates the connection is now closing.
* `reset`: If set to `true`, indicates the connection is being reset.

Ports are not stored in the PSP message; rather, they are implemented through modem channels. Port 0 is reserved for non-PSP applications, and is thus illegal to use in PSP communications.

Connections are handled the same way as TCP: the client sends a `synchronize` message with an initial sequence number; the server replies with a `synchronize` message with an `acknowledgement` number that is one more than the initial number; and the client sends a plain `acknowledgement` message with `synchronize` unset and no payload. To close, the initiator sends a `final` message to the other end; the server sends back an acknowledgement; the server then sends its own `final` message; and the client sends back its own acknowledgement.

## User protocols
In addition to the kernel-defined protocols, the default Phoenix distribution implements a number of application layer protocols for things such as dynamic IP assignment, hostname lookup, and file transfer.
