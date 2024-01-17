local file = assert(io.open("/boot/config.lua", "r"))
local data = file:read("*a")
file:close()
local rootDirectory = data:match "rootDirectory = '([^']+)'"
if not rootDirectory then error("Could not find root directory - pxboot config has been modified after installation. You will need to fix it manually.") end
local bootArgs = data:match "args (%b())"
if not bootArgs then error("Could not find boot args - pxboot config has been modified after installation. You will need to fix it manually.") end
file = assert(io.open("/boot/config.lua", "w"))
file:write("rootDirectory = '" .. rootDirectory .. "'\nbootArgs = " .. bootArgs .. "\n" .. data:gsub("menuentry[^{]+%b{}", ""))
file:close()