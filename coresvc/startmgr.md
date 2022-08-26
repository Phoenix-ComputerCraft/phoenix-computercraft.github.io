---
layout: default
title: startmgr
parent: Core Services
---

# startmgr
startmgr is the de facto init system for Phoenix. It includes a service manager with automatic dependency resolution, as well as built-in timer management. It uses plain Lua files for all service information, and creating a service is as simple as writing a Lua file with a `start` function.

## Requirements
- libsystem

## Installation
To install startmgr on Phoenix, place `init.lua` in `/sbin`, `startmgr.lua` in `/lib`, and `startctl.lua` and `shutdown.lua` in `/bin`. Then ensure Phoenix is configured to use `/sbin/init` as the init program in the bootloader - this is the default if none is specified in boot arguments. Finally, reboot and startmgr should now be the init system.

## Usage
Once installed, the `startctl` program may be used to control the service manager.

## Writing services
A service file is a Lua script that's executed when reloading the service manager. It's run with a basic Lua environment, with some additional tables to place configuration data in. The file should define at least one function that will be called to trigger the service or timer. Since it's a normal script, it may do anything required to set up the service, such as call `require` to load libraries, use local variables to store state, and execute system calls.

### The `unit` table
A global table named `unit` is used to configure information about the service itself, and its relationships with other services. The following members are available:
- `description`: A string containing a brief description of the service. This is the name that will be shown to the user, including on the console and in logs.
- `wants`: A table of service names that the service will also start when starting itself. If any of these services fail to start, the service will continue to start itself.
- `requires`: Similar to `wants`, but if any service in the list does not start successfully, this service will fail as well.
- `requisites`: Similar to `requires`, but does not start the service itself - this service will not run unless all of these are already running.
- `bindsTo`: Similar to `requires`, but *also* stops this service if any listed service stops.
- `partOf`: A table of services that will automatically stop this service if they stop. This differs from `bindsTo` by not automatically starting or requiring the other services.
- `upholds`: Similar to `wants`, but automatically restarts any services if they stop for any reason.
- `conflicts`: A table of services that will block starting this service if they are running.
- `before`: A list of services that this service should start *before* (i.e. the listed services should start *after* this service).
- `after`: A list of services that this service should start *after* (i.e. the listed services should start *before* this service).

### The `install` table
A global table named `install` is used to configure what actions are taken when the service is `install`ed (and `uninstall`ed). The following members are available:
- `wantedBy`: A table of services that will have this service added to their `wants` list. When that service starts, this service will also start.
- `requiredBy`: Similar to `wantedBy`, but adds to the `required` list instead.
- `also`: A table of services to install or uninstall alongside this one.

### The `service` table
A global table named `service` is used to configure information about the service itself, primarily revolving around timeouts. The following members are available:
- `pid`: A table of process IDs that the service started. This is used to keep track of child processes in the service manager, including exit statuses and other events. When you start a process, its PID should be placed in this table so it can be properly managed. When the process exits, its PID is automatically removed from the table, so there's no need to clean it up yourself.
- `restart`: A string selecting when the service should automatically restart. Restarts are triggered when the last registered PID exits, and relies on that process's exit status.
  - `no`: Never restart the service.
  - `always`: Always restart the service when it stops.
  - `on-success`: Only restart the service when it exits successfully.
  - `on-failure`: Only restart the service when it exits with a failure.
  - `on-abnormal`: Only restart the service when it exits abnormally (including timeouts and errors).
  - `on-abort`: Only restart the service when it throws an error.
  - `on-watchdog`: Only restart the service when a watchdog timeout occurs.
- `restartTime`: The amount of time to wait before restarting the service, in seconds.
- `startTimeout`: The amount of time to wait for the `start` function to complete, in seconds.
- `stopTimeout`: The amount of time to wait for the `stop` function to complete, in seconds.
- `abortTimeout`: The amount of time to wait for the `stop` function to complete when aborting from watchdog timeout, in seconds.
- `maximumTime`: The maximum amount of time to run the service for until stopping it, in seconds.
- `watchdogTime`: The maximum amount of time to wait for a watchdog event from a process, in seconds.

### The `timer` table
A global table named `timer` is used to configure timer properties for the service. By default, the timer is disabled, so there's no need to change it for services that don't use timers. The following members are available:
- `bootTime`: The amount of time to wait after system start until starting this service, in seconds.
- `startupTime`: The amount of time to wait after starting the service manager until starting this service, in seconds. This differs from `bootTime` when on multi-user systems, as there may be a service manager for each logged in user, with their own startup times (whereas `bootTime` only triggers for the system manager).
- `loadTime`: The amount of time to wait after loading the service until starting this service, in seconds. This differs from `startupTime` as it resets when the service manager reloads services.
- `period`: The default amount of time to wait until triggering the timer again, in seconds. This may be modified by the `trigger` return value.
- `accuracy`: The maximum amount of time to allow the timer period to drift by, in seconds. The timer manager may not trigger immediately when due to save CPU time, and this setting controls how much time is acceptable. The minimum value of all services determines the period to check timers. Defaults to 60 seconds.

### The `startmgr` API
Aside from the configuration tables, startmgr also exports a `startmgr` API for use in the script. This API is identical to the `startmgr` library for other processes, but calls the methods directly instead of going through remote events. See the docs for the `startmgr` library for more information on how to use it.

### Functions
The actions of a service are defined by a few functions in the script. These functions are called when triggering certain events on the service, whether from user input or from automatic processes elsewhere. These functions must be global functions, and will be stored in the service manager after the script exits until reloading the service files.

#### `start(): boolean`
The `start` function is called when starting the service, and is used to start any processes or calls that are required to get the service started. It takes no parameters, and returns a boolean value specifying whether the service started successfully. For basic services, this consists of a call to `process.start` with the path to the service executable, storing the resulting PID in `service.pid[1]`. If this function is missing, the service will not be able to start (this is acceptable for timer-only services).

#### `stop(aborted: boolean): boolean`
The `stop` function is called when stopping the service, and is used to gracefully halt and clean up the service. It takes one parameter, a boolean specifying whether this is coming from a watchdog timeout, and returns a boolean value specifying whether the service stopped successfully. For basic services, this consists of a call to `ipc.kill` with `service.pid[1]` and an appropriate signal for the process (usually `SIGINT`, `SIGHUP`, or `SIGTERM`). If this function is missing, the service manager will send `SIGHUP` (`SIGABRT` when aborting) to all processes in `service.pid`.

#### `reload(): boolean`
The `reload` function is called when a user requests the service to reload its configuration, and is used to send a signal to the service to reload itself. It takes no parameters, and returns a boolean value specifying whether the config was reloaded successfully. If this function is missing, a reload operation on the service will always succeed with a warning.

#### `trigger(): number?`
The `trigger` function is called whenever the timer is triggered. It takes no parameters, and returns an optional number of seconds until triggering the timer again. If it returns `nil`, then `timer.period` will be used instead. If this function is missing, the timer will attempt to start the service instead.

#### `success()`
The `success` function is called whenever the service stops successfully, and is used for any post-run cleanup. It takes no arguments and returns no values. If this function is missing, it will not be called.

#### `failure()`
The `failure` function is called whenever the service stops unsuccessfully, and is used for any post-run cleanup. It takes no arguments and returns no values. If this function is missing, it will not be called.