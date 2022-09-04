---
layout: default
title: Kernel modules
parent: Documentation
---

# Kernel modules
Phoenix has support for loading kernel modules, which are simple Lua scripts that are automatically loaded into the kernel at boot. These scripts allow adding extra functionality in kernel space, such as new filesystems, device drivers, and more.

To make a kernel module, simply place a Lua script in `/lib/modules`, and it will be loaded automatically on boot. To avoid automatically loading, place it in a subdirectory instead. Kernel modules must be owned by root, and cannot be world-writable - otherwise, the module will fail to load to avoid kernel code injection by unprivileged users.

Kernel modules may return a table with an API to provide to usermode programs. This API may be called through the `callmodule` syscall, which takes the module name, the function to call, and arguments. This is similar to peripheral methods, but acts on a kernel module API instead. The function will receive the current process and thread handles as the first two arguments, followed by the extra arguments passed to `callmodule`.

If the API includes an `unload` function, this will be called when the `unloadmodule` syscall is executed - this allows your module to clean itself up and remove itself from the system. It is highly recommended that all modules implement an `unload` function, as omitting it will make the module's changes to the kernel unable to be reversed. (If your module only contributes an API, and doesn't change any kernel variables, then it may not be necessary to have an `unload` function.)

Make sure to secure all usermode-accessible code (such as kernel API functions and filesystem methods) to avoid creating security vulnerabilities. For example, always use the `userModeCallback` function to call functions passed across the user-kernel boundary - otherwise, the function may be able to access kernel data without being properly privileged.

It is NOT recommended to add custom syscalls, even though the `syscall` table is writable - this is because the syscall API is not modularized, and names used in modules may overwrite syscalls implemented in newer versions of Phoenix. Instead, use the kernel module API through `callmodule`, which is guaranteed to be modularized for each module.

The following sections list some common kernel module types and how to implement them.

## Filesystems
Modules can contribute custom filesystems by adding an entry to the global `filesystems` table. This table stores filesystem classes in key-value format.

A filesystem class must implement all filesystem syscalls that are not related to mounting or `combine`. This includes the following methods:
* `open`
* `list`
* `stat`
* `remove`
* `rename`
* `mkdir`
* `chmod`
* `chown`

In addition, they must implement an `info` method that takes no arguments (except `self`) and returns three values: the name of the filesystem type, the source of the mount, and a table with any options passed when mounting.

All methods are Lua `:` methods that get `self`, plus the handle of the process that's calling the method. Each method gets the same arguments as the respective syscall, but paths are relative to the mount. (For example, if a mount is at `/media/disk`, a call to `stat("/media/disk/dir/file.txt")` will pass `dir/file.txt` to the `/media/disk` mount object.) All arguments are type-checked already, so there's no need to check the type again.

To create the filesystem, `mount` calls the filesystem class's `new` method with the process handle, source path, and options table, i.e. `filesystems[fs_type]:new(process, source, options)`. For organization, it's recommended to store the rest of the methods in the same table, and return a table with `__index = self` in a metatable, but it's also possible to return a pre-built table without adding anything else to the class table.

Here is a template for a basic filesystem module.

```lua
local myfs = {}

-- Methods
function myfs:open(process, path, mode) end
function myfs:list(process, path) end
function myfs:stat(process, path) end
function myfs:remove(process, path) end
function myfs:rename(process, from, to) end
function myfs:mkdir(process, path) end
function myfs:chmod(process, path, user, mode) end
function myfs:chown(process, path, user) end
function myfs:info() end

-- Constructor
function myfs:new(process, source, options)
    return setmetatable({}, {__index = self})
end

-- Install filesystem & return unloader
filesystems.myfs = myfs
return {
    unload = function()
        filesystems.myfs = nil
    end
}
```

## Device drivers
Device drivers add Phoenix-ized methods to ComputerCraft peripherals. A driver consists of a name, type, property list, method list, and initializer and deinitializer methods. Here is an example of a driver class:

```lua
local driver = {
    name = "root",
    type = "computer",
    properties = {
        "label",
        "id"
    },
    methods = {
        getLabel = function(node, process) end,
        setLabel = function(node, process, label) end,
        getId = function(node, process) end,
        shutdown = function(node, process) end,
        reboot = function(node, process) end
    },
    init = function(node)
        -- initialize node
    end,
    deinit = function(node)
        -- deinitialize node
    end
}
```

The `methods` list stores a key-value table of methods that can be called on the peripheral, including property getters and setters. The `type` field is used to determine what type of peripheral to bind to, so make sure this is set to the same name as the ComputerCraft peripheral. The `name` field stores the name of the driver - set this to a unique value that identifies your driver in particular.

The `init` function is called when the driver is being added to a device node. Use this function to initialize any state on the node that may be required, including display names and metadata. Conversely, `deinit` should be used to finalize the node and prepare for removal.

All methods take the node that's being operated on as the first argument. Methods also take a second argument with the process that called the method, followed by any arguments passed to the method.

To register a ComputerCraft peripheral driver, use the `registerDriver(driver)` function, which will add the driver to the driver list, allowing it to automatically load onto peripherals which match the driver's type. It also creates a `node.internalState.peripheral` table, which holds the peripheral API required to access the peripheral - use this to access the peripheral, as it allows the driver to work on modems as well as root peripherals. The `deregisterDriver(driver)` function will unload the driver from all matching devices and removes it from the driver list - use this in your `unload` function.

Here's an example of a basic device driver:

```lua
-- Create driver table
local mydriver = {
    name = "mydriver",
    type = "mydevice",
    properties = {
        "prop"
    },
    methods = {}
}

-- Implement methods
function mydriver.methods:getProp(process) return self.internalState.peripheral.call(self.id, "getProp") end
function mydriver.methods:foo(process, arg) return self.internalState.peripheral.call(self.id, "foo", arg) end

-- Init method
function mydriver:init()
    self.displayName = "My Device"
end

-- Add driver & return unloader
registerDriver(mydriver)
return {
    unload = function()
        deregisterDriver(mydriver)
    end
}
```