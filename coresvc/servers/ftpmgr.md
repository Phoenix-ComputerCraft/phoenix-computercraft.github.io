---
layout: default
title: ftpmgr
parent: Servers
grand_parent: Core Services
---

# ftpmgr
ftpmgr hosts an RFC 959-compliant File Transfer Protocol (FTP) server over PSP sockets. It has support for multiple users using either usermgr logins or custom users, and each user can be confined to their own root directory.

## Requirements
- libsystem
- ftp (included with ftpmgr)

## Usage
Install the `ftp` package. Then configure `/etc/ftpmgr.conf` with any required users. Finally, start the manager with `sudo startctl start ftpmgr`. To run on startup, run `sudo startctl install ftpmgr`.

## Configuration
ftpmgr's configuration is stored at `/etc/ftpmgr.conf`. This is a [TOML](https://toml.io) file with the parameters for the server host, as well as info about each user that can connect to the server.

The following root options are available:
- `ip`: The IP address to serve on. "0.0.0.0" indicates any IP/interface.
- `port`: The port to serve the command stream on. FTP standard is 21.
- `passivePortRange`: The range of ports to reserve for passive connections. This is an array of two ports, inclusive.
- `allUsers`: Set this to allow any user registered on the system to log in.

Each user is configured as a subtable under `users`. The following options are available for each user:
- `systemUser`: The Phoenix username to run the server as.
- `useSystemLogin`: Whether to use usermgr to authenticate logins.
- `allowWrite`: Whether to allow the user to write files.
- `root`: The filesystem root visible to the user.
- `password`: The password for the user (plaintext!). It is highly recommended to use `passwordHash` instead for security.
- `passwordHash`: The hash of the password + salt in SHA-256. Overrides `password`.
- `passwordSalt`: The salt applied to the end of the password before hashing.

A user named `anonymous` is used when no login details are provided. This user must not have a password set.

Users can be authenticated in one of four ways:
- No password: This is used when `useSystemLogin` is `false`, and no password is set. Users will not need to enter a password.
- System login: This is used when `useSystemLogin` is `true`. usermgr and its user database will be used to authenticate users.
- Plaintext password: This is used when `useSystemLogin` is `false`, and `password` is set but not `passwordHash`. The password sent will be compared to `password` directly. This is insecure in case of breach - use `passwordHash` instead.
- Hashed password: This is used when `useSystemLogin` is `false`, and `passwordHash` is set. The password will have `passwordSalt` appended at the end before running through a pass of SHA-256. Then that hash is compared with `passwordHash`. This is the recommended way to store passwords without usermgr.

Here is an example configuration:

```toml
ip = "0.0.0.0"
port = 21
passivePortRange = [65000, 65535]
allUsers = true

[users.root]
    # leave default parameters

[users.anonymous]
    systemUser = "ftp-user"
    allowWrite = false
    useSystemLogin = false
    root = "/var/ftp"

[users.virtual-secure]
    systemUser = "virtual"
    passwordHash = "05bb25e9186d1014c5eb723edb0bf17987e6fe1b9eaeae5c88f217d1b3024b23"
    passwordSalt = "12345678"
    allowWrite = true
    root = "/"
```
