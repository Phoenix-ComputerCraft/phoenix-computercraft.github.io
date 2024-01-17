---
layout: default
title: netmgr
parent: Core Services
---

# netmgr
netmgr is a manager program that automatically configures the network on startup. It supports both DHCP and static assignments, with gateway and DNS configuration as well as IPs.

## Requirements
- libsystem

## Usage
Install the `netmgr` package. Then configure `/etc/network.conf` (described below) with the networking information required. Finally, start the manager with `sudo startctl start netmgr`. To run on startup, run `sudo startctl install netmgr`.

## Configuration
netmgr's configuration is stored at `/etc/network.conf`. This is a [TOML](https://toml.io) file with entries for each network interface to configure. The name may be either the exact path of the device (with leading slash), or the UUID of the device. An `auto` entry is used for any interface that doesn't have its own config.

Each entry must have an `acquire` field, which indicates how to acquire an IP address. This can be `"none"` (skip configuration) `"dhcp"`, `"dhcp-static"`, or `"static"`. `dhcp-static` only needs `address`. `static` needs `address`, `netmask` (if not in the address), and `gateway` if required. A `dns` array can be used to set DNS servers. See the template file for more information on the full format.

Here is an example configuration file:

```toml
## /etc/network.conf
[auto]
    acquire = "dhcp"

["/lo"]
    acquire = "static"
    address = "127.0.0.1/24"
```
