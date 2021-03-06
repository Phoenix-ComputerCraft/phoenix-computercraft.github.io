---
layout: default
title: Interfacing with peripherals
parent: Documentation
---

# Interfacing with peripherals
CraftOS uses the `peripheral` API to interact with local peripherals that are connected either directly or through a wired modem. Phoenix takes this a step further by introducing a virtual device tree that organizes local, remote, and virtual peripherals by how they're connected.

## Device tree
The device tree is made up of nodes that represent each device, whether that's a local or remote peripheral, or a virtual device registered by a driver or kernel extension. A node contains a physical ID, a UUID (which may or may not be randomized), a type and driver name, a user-readable name, a lock to allow mutual exclusion, any metadata that the driver would like to include, a list of methods that may be called on the underlying device, and a list of children devices that the node owns. They may also optionally contain a list of property names, which can be retrieved through a corresponding `get<Property>` method. Nodes may have any number of children, including zero.

All devices in Phoenix are placed under a root which represents the computer (`/`). The root is registered as a computer peripheral, and supports all of the same methods as any other computer peripheral. By default, the root has six children corresponding to each side of the computer. Any side that does not have a peripheral attached is omitted from the tree. If a wired modem is attached on any side, that side's node's list of children will contain all of the peripherals attached to the modem, provided through the modem driver.

Virtual devices (including remote peripherals) are placed in subtrees under the root, separate from the local peripheral nodes. Drivers that create virtual devices are expected to place all device nodes in their own subtree under the root; e.g. a remote peripheral driver called `remote-peripheral` should place a provider named `computer-12` under `/remote-peripheral/computer-12`. Drivers should **NOT** try to modify the trees named for peripheral sides or `/redstone` - these are managed by the system/root driver.

There are three ways to address a device when using hardware syscalls. Devices may be addressed by their path (`/left/monitor_0`), always starting with a `/`, or their UUID. Devices may also be referenced by physical ID (`monitor_0`), but since these are not guaranteed to be unique, it's recommended to use the path or UUID instead to ensure the correct device is being addressed. If a duplicate physical ID is used, the first device discovered or attached will be used - if both/all were present at startup, the order is nondeterministic. The `devlookup` syscall allows finding all device paths that use the specified physical ID.

## Hardware API
The syscalls starting with `dev` are used to interact with devices. These give access to devices to normal processes. For more information on these syscalls, see [the hardware syscall docs](../syscalls/hardware).

## Kernel driver API
The kernel contains an API named `hardware` that allows access to the driver subsystem for kernel modules to use. These functions provide the ability to add and remove devices, as well as to call a function whenever a device is attached under a certain parent or with an ID matching a pattern.

Kernel modules do not have access to the event system, so for drivers that need access to events outside peripheral notifications (e.g. network responses), it is recommended that they create a new process with `fork` to run any part of the driver that needs events, then use the kernel module communication syscalls to transfer any data necessary to the driver.

Device methods take the device node as the first argument, the process executing the method as the second, and any additional arguments after.
