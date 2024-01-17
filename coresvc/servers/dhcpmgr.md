---
layout: default
title: dhcpmgr
parent: Servers
grand_parent: Core Services
---

# dhcpmgr
dhcpmgr is a server manager for DHCP. DHCP is a protocol for automatically configuring IP addresses on the local network. When a computer hosts a dhcpmgr server on a local network, other nearby computers can acquire a unique IP address from it automatically. Compatible clients include `dhclient` (from `netutils`) and [`netmgr`](../netmgr).

## Requirements
- libsystem

## Usage
Install `dhcpmgr`. Then configure the network parameters in `/etc/dhcpmgr.conf` (described below). Finally, start the manager with `sudo startctl start dhcpmgr`. To run on startup, run `sudo startctl install dhcpmgr`.

## Configuration
dhcpmgr's configuration is stored at `/etc/dhcpmgr.conf`. This is a [TOML](https://toml.io) file with the parameters for how to allocate addresses.
- `interface` defines the interface to host on. This can be a device path or UUID. If not set, it will pick a random interface.
- `firstaddr` and `lastaddr` define the IP range to assign. This should be in one of the private IP blocks (`10.x.x.x`, `192.168.x.x`, `172.xx.x.x`). For most networks, the first address should be `x.x.x.2`, and the last should be `x.x.x.254`, which leaves room for the DHCP host at `.1`, and the broadcast address at `.255`.
- `netmask` defines the network mask for the address. If not provided, it will be inferred from the address range.
- `gateway` defines the gateway (router) address for the network. If not provided, clients won't be able to connect to the Internet.
- `dns` defines the domain name servers to use. If not provided, clients won't be able to use domain names.
- `leasetime` defines how long a DHCP lease lasts, in seconds. Set to 0 to never expire.
- `allowrequests` determines whether a client can request its own IP address.
- `storeassignments` determines whether assignments are stored to a file on the server.
- `forcereassign` determines whether to always assign a new address when a client requests one.
- The `static` section lists forced static assignments for certain computer IDs.
- The `options` section can be used to add any extra options to the response, such as network boot parameters.

Here is an example configuration for a basic DHCP server on the `10.0.1.0/24` subnet, with some static IPs and a boot configuration:

```toml
interface = "/back"
firstaddr = "10.0.1.2"
lastaddr = "10.0.1.254"
gateway = "10.0.1.1"
dns = ["10.0.1.1"]
leasetime = 86400
allowrequests = true
storeassignments = false
forcereassign = false

[static]
    25 = "10.0.1.15"
    28 = "10.0.1.132"

[options]
    bootServers = ["10.0.1.1"]
    bootFile = "/boot.lua"
```
