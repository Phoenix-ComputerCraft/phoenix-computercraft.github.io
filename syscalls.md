---
layout: default
title: System Calls
has_children: true
---

# System Calls

The system call (syscall) is the most critical aspect of the Phoenix kernel. Syscalls are the only way a program can interact with the system. A syscall is activating by yielding the main coroutine of a thread/process with `syscall` as the first argument, and the syscall name as the second argument. Any arguments to the function are passed after the syscall name. Once processing of the syscall completes in the kernel, the values are passed when resuming the coroutine. Note that the first argument is always a boolean specifying whether the call succeeded, or an error occurred. If this boolean is `false`, the second and only other argument is a string describing the error. This is to allow a wrapper to call `error` if the call failed.

For example, here's how a program would call the `open` syscall:

```lua
local ok, file = coroutine.yield("syscall", "open", "myfile.txt", "r")
if ok then
    -- do processing on file
else
    print("Could not open file: " .. file) -- file is an error string
end
```

The default Phoenix runtime libraries include wrappers for this to make it easier to execute syscalls. If you don't want to use the libraries, it's simple to make your own wrapper. Here's a simple implementation of a syscall object that can execute syscalls like functions:

```lua
local syscall = setmetatable({}, {__index = function(self, name)
    return function(...)
        local res = table.pack(coroutine.yield("syscall", name, ...))
        if res[1] then
            return table.unpack(res, 2, res.n)
        else
            error(res[2], 2)
        end
    end
end})
local file = syscall.open("myfile.txt", "r") -- this errors if the file could not be opened
-- do processing on file
```

---

The following pages list every syscall available in the Phoenix kernel. They are grouped by the part of the system they interact with.

Note: All syscalls can throw an error if the arguments are not the right type. The error list specified by each syscall does not include this fact, so even if a syscall says it does not throw errors it may still throw when an argument is invalid.