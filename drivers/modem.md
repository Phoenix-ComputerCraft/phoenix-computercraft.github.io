---
layout: default
title: Modem
parent: Drivers
---

# `modem`
This type represents a modem peripheral. Modems are often used by the system in other components (such as local networking), so they may be locked by another process doing I/O. Opening channels is handled per-process, so closing a channel does not guarantee it will actually close on the real modem; however, it does guarantee the process will no longer receive events for that channel.

## Drivers that use this type
* `peripheral_modem`: Implements for local modem peripherals.

## Metadata
* `wireless: boolean`: Whether the modem is wireless

## Properties
* `remainingChannels: number`: The number of additional channels that may be opened on this modem (assuming the limit is 128)

## Methods
* `open(channel: number)`: Opens a channel for use. `devlisten` must have been called on this device to receive events.
* `isOpen(channel: number)`: Returns whether the channel is currently open.
* `close(channel: number)`: Closes the channel, stopping events on that channel.
* `closeAll()`: Closes all open channels.
* `transmit(channel: number, replyChannel: number?, payload: any)`: Sends a message on the specified channel.

## Events
* `modem_message`: Sent when a message is received on an open channel.
  * `device: string`: The path of the device that received the message
  * `channel: number`: The channel the message was sent on
  * `replyChannel: number`: The reply channel to use as indicated by the sender
  * `message: any`: The message payload
  * `distance: number`: The distance between the sender and receiver, in blocks
* `device_added`: Sent when a new device is added to the network. (Wired only)
  * `device: string`: The path of the new device
* `device_removed`: Sent when a device is removed from the network. (Wired only)
  * `device: string`: The path of the removed device