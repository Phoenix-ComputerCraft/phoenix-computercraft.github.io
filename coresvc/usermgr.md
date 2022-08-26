---
layout: default
title: usermgr
parent: Core Services
---

# usermgr
A user management and authentication service for Phoenix. This package provides the usermgr service, a library for interfacing with usermgr, and a set of standard programs for user authentication and modification.

## Requirements
- libsystem
- [sha2](https://github.com/Egor-Skriptunoff/pure_lua_SHA)

## Installation
Simply copy `libexec/usermgr.lua` to `/usr/libexec`, `lib/usermgr.lua` to `/usr/lib`, and all programs in `bin` to `/usr/bin`. In addition, make sure to set the setuser bit on `login`, `passwd`, `su`, and `sudo` (using `chmod +s /usr/bin/<program>`).

If you use startmgr, copy `etc/startmgr/system/usermgr.service` and `etc/startmgr/system/login.service` to `/etc/startmgr/system` as well, and add `usermgr` and/or `login` to your `startup` service requirements.

## Usage
### Service
Once started, the usermgr service will listen for remote events using the `usermgr` service name. Messages are sent using a simple request-response protocol: the program sends a `usermgr.request.*` event with the message name, with a table containing any parameters as the event data (including username, password, etc.). The server will respond with a `usermgr.response.*` event with the same type, and the parameter will be a table containing a `result` field with the result of the call (usually a boolean or `nil`), and an `error` field with either `nil` or an error message.

Note: Authentication is only allowed when the calling process is root. This is to mitigate potential security risks from syscall interception, which allows an attacker to forge a success response from the service. Do not attempt to authenticate as a normal user, as the user can make a simple program to make another program accept any password for any user. Using the setuser bit avoids this attack, as setuser requires calling `exec`, which kills user code that may be intercepting syscalls.

### Library
The `usermgr` library is the preferred way to interact with the usermgr service. This library automatically handles checking permissions, managing the request/response flow, and verifying arguments.

See the API docs in the file for more information on how to use it.

### Programs
The usermgr package comes with some standard UNIX utilities for managing users.

#### login
The login program provides a basic login prompt for users. It handles basic username/password input, automatically handles password changing when expired, and shows the MOTD at `/etc/motd` if present. A service file is provided to automatically start this program on startup, and is recommended when running a multiuser system.

#### su/sudo
The su and sudo programs are used like the standard UNIX programs of the same name. su allows switching to another user using their password, and sudo allows switching to another user using the current user's password according to a set of access rules. The `/etc/sudoers` file is used to configure these permissions; see the Linux man pages for `sudoers` for more info on the format of this file.

#### passwd
The passwd program is used to change the password for a user. When running as root, the user's old password is not required; otherwise, the password is checked before changing it. Options for changing the password expiration information are provided.

#### useradd/usermod/userdel
These programs are used to create, edit, and delete users from the user database, respectively. See the help output for each program for more information.

## Config files
### `/etc/passwd`
This file stores basic information about each user, including name, home directory, and shell. It is stored using standard UNIX `passwd` format, with each user on a line of 7 fields split with `:`.

### `/etc/shadow`
This file stores the password information for each user. It is stored in the same format as `/etc/passwd`, but with 9 fields instead of 7.

### `/etc/sudoers`
This file stores information about what users can use sudo to execute which commands. It is stored in the same format as a real-world `sudoers` file.

### `/etc/motd`
This file stores the MOTD for the login program, and may be omitted if it's not needed. It's a plain text file that's simply printed to the screen.

### `/etc/default/useradd`
This file stores the default configuration for the useradd program, if present. It's a key-value list of strings, with a capitalized name followed by `=` and a value.

### `/etc/skel`
This directory is the default location for the user home skeleton. Files here are copied into new home directories when useradd is called with the `-m` option.