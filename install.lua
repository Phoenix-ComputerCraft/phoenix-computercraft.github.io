local url = "https://phoenix.madefor.cc/packages/"

term.setPaletteColor(colors.orange, 0xD06018)
term.setPaletteColor(colors.white, 0xD8D8D8)

local width, height = term.getSize()
local nextLine
local coros = {}
local restoreCursor
local running = true
local pkginfo = {}

local function drawStatus(status)
    term.setCursorPos(3, height)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
    term.clearLine()
    term.write(status)
end

local function clearScreen(status)
    term.setBackgroundColor(colors.orange)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorBlink(false)
    term.setCursorPos(2, 2)
    term.write("Phoenix Setup")
    term.setCursorPos(1, 3)
    term.write(("\x8C"):rep(15))
    drawStatus(status)
    nextLine = 5
    coros = {}
    restoreCursor = nil
end

local function label(text)
    local win = window.create(term.current(), 3, nextLine, width - 4, height - nextLine, false)
    win.setBackgroundColor(colors.orange)
    win.setTextColor(colors.white)
    win.clear()
    local old = term.redirect(win)
    local th = print((text:gsub("* ", "\7 ")))
    term.redirect(old)
    win.reposition(3, nextLine, width - 4, th)
    win.setVisible(true)
    nextLine = nextLine + th + 1
end

local function textBox(h) return function(text)
    h = h or height - nextLine - 3
    term.setBackgroundColor(colors.orange)
    term.setTextColor(colors.white)
    term.setCursorPos(3, nextLine)
    term.write("\x9C" .. ("\x8C"):rep(width - 6))
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.orange)
    term.write("\x93")
    for i = 1, h do
        term.setCursorPos(term.getCursorPos() - 1, nextLine + i)
        term.write("\x95")
    end
    term.setBackgroundColor(colors.orange)
    term.setTextColor(colors.white)
    for i = 1, h do
        term.setCursorPos(3, nextLine + i)
        term.write("\x95")
    end
    term.setCursorPos(3, nextLine + h + 1)
    term.write("\x8D" .. ("\x8C"):rep(width - 6) .. "\x8E")
    local y, w = nextLine + 1, width - 7
    local outer = window.create(term.current(), 4, y, w, h)
    local inner = window.create(outer, 1, 1, w, 9000)
    inner.setBackgroundColor(colors.orange)
    inner.setTextColor(colors.white)
    inner.clear()
    local old = term.redirect(inner)
    local th = print(text)
    term.redirect(old)
    inner.reposition(1, 1, w, th)
    coros[#coros+1] = coroutine.create(function()
        local scrollPos = 1
        while true do
            local ev = table.pack(os.pullEvent())
            local dir
            if ev[1] == "key" then
                if ev[2] == keys.up then dir = -1
                elseif ev[2] == keys.down then dir = 1 end
            elseif ev[1] == "mouse_scroll" and ev[3] >= 4 and ev[3] < 4 + w and ev[4] >= y and ev[4] < y + h then
                dir = ev[2]
            end
            if dir and (scrollPos + dir >= 1 and scrollPos + dir <= th - h) then
                scrollPos = scrollPos + dir
                inner.reposition(1, 2 - scrollPos)
            end
            term.setCursorPos(w + 4, y)
            term.blit(scrollPos > 1 and "\30" or " ", "0", "1")
            term.setCursorPos(w + 4, y + h - 1)
            term.blit(scrollPos < th - h and "\31" or " ", "0", "1")
        end
    end)
    nextLine = nextLine + h + 2
end end

local function inputBox(callback, default, replace)
    term.setBackgroundColor(colors.orange)
    term.setTextColor(colors.white)
    term.setCursorPos(3, nextLine)
    term.write("\x9C" .. ("\x8C"):rep(width - 6))
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.orange)
    term.write("\x93")
    term.setCursorPos(term.getCursorPos() - 1, nextLine + 1)
    term.write("\x95")
    term.setBackgroundColor(colors.orange)
    term.setTextColor(colors.white)
    term.setCursorPos(3, nextLine + 1)
    term.write("\x95")
    term.setCursorPos(3, nextLine + 2)
    term.write("\x8D" .. ("\x8C"):rep(width - 6) .. "\x8E")
    local win = window.create(term.current(), 4, nextLine + 1, width - 6, 1)
    win.setBackgroundColor(colors.orange)
    win.setTextColor(colors.white)
    win.clear()
    win.setCursorBlink(true)
    restoreCursor = win.restoreCursor
    coros[#coros+1] = coroutine.create(function()
        local coro = coroutine.create(read)
        local old = term.redirect(win)
        local yield = table.pack(coroutine.resume(coro, replace, nil, nil, default))
        while coroutine.status(coro) == "suspended" do
            term.redirect(old)
            yield = table.pack(coroutine.yield(table.unpack(yield, 1, yield.n)))
            old = term.redirect(win)
            win.restoreCursor()
            yield = table.pack(coroutine.resume(coro, table.unpack(yield, 1, yield.n)))
        end
        term.redirect(old)
        if not yield[1] then error(yield[2]) end
        return callback(yield[2])
    end)
    nextLine = nextLine + 4
end

local function progressBar()
    term.setBackgroundColor(colors.orange)
    term.setTextColor(colors.white)
    term.setCursorPos(3, nextLine)
    term.write("\x9C" .. ("\x8C"):rep(width - 6))
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.orange)
    term.write("\x93")
    term.setCursorPos(term.getCursorPos() - 1, nextLine + 1)
    term.write("\x95")
    term.setBackgroundColor(colors.orange)
    term.setTextColor(colors.white)
    term.setCursorPos(3, nextLine + 1)
    term.write("\x95")
    term.setCursorPos(3, nextLine + 2)
    term.write("\x8D" .. ("\x8C"):rep(width - 6) .. "\x8E")
    local win = window.create(term.current(), 4, nextLine + 1, width - 6, 1)
    win.setBackgroundColor(colors.orange)
    win.setTextColor(colors.white)
    win.clear()
    nextLine = nextLine + 4
    return function(progress)
        win.setCursorPos(1, 1)
        win.setBackgroundColor(colors.orange)
        win.clearLine()
        win.setBackgroundColor(colors.white)
        win.write((" "):rep(progress * (width - 6)))
    end
end

local function keyMap(actions)
    coros[#coros+1] = coroutine.create(function()
        while true do
            local event, key = os.pullEvent()
            if event == "key" and actions[key] then actions[key](key) end
        end
    end)
end

local function run()
    running = true
    for _, v in ipairs(coros) do coroutine.resume(v) end
    while running do
        if restoreCursor then restoreCursor() end
        local ev = table.pack(os.pullEvent())
        -- We ignore filters here as it adds unnecessary complexity. Be careful not to use them!
        for _, v in ipairs(coros) do coroutine.resume(v, table.unpack(ev, 1, ev.n)) end
    end
end

local screens = {}

function screens.message(state, message, next)
    clearScreen("ENTER=Back")
    label(message)
    keyMap {[keys.enter] = function() running = false end}
    run()
    return next(state)
end

function screens.loading(state)
    clearScreen("Downloading package list...")
    label("Please wait while Setup initializes.")
    local handle, err = http.get(url .. "Packages")
    if not handle then return screens.message(state, "An error occurred while initializing Setup: Could not download package list: " .. err .. "\n\nSetup cannot continue. Press ENTER to exit.", function() end) end
    local pkg
    for line in handle.readLine do
        local k, v = line:match("^([%w%-]+):%s*(.+)$")
        if k then
            if k == "Package" then
                pkg = v
                pkginfo[pkg] = {}
            elseif k == "Size" then pkginfo[pkg].pkgsize = tonumber(v)
            elseif k == "Installed-Size" then pkginfo[pkg].filesize = tonumber(v) * 1024 end
        end
    end
    handle.close()
    return screens.welcome(state)
end

function screens.welcome(state)
    local next
    clearScreen("ENTER=Continue  Q=Quit")
    label[[
Welcome to the setup program for Phoenix. You will be guided through the steps necessary to install this software.

  * To install Phoenix now, press ENTER.
  * To quit setup without installing, press F5.
]]
    keyMap {
        [keys.enter] = function() next, running = true, false end,
        [keys.q] = function() next, running = false, false end
    }
    run()
    if next then return screens.readme(state)
    else return false end
end

function screens.readme(state)
    local next
    clearScreen("ENTER=Continue  TAB=Back  Q=Quit")
    label("Please read the following important information before installing.")
    textBox() [[
Welcome to Phoenix, the next generation operating system for ComputerCraft. Phoenix adds many advanced features to ComputerCraft, including preemptive multitasking, a UNIX-like environment, custom filesystems with support for permissions, a cleaner library API, and much more.

Phoenix requires about 800 kB of space for a basic installation. It is recommended to install it on a fresh computer, on an emulator such as CraftOS-PC, or after increasing the maximum computer storage space.

Phoenix does not support preemptive multitasking on LuaJIT platforms, including CraftOS-PC Accelerated, due to some limitations in LuaJIT. Make sure to disable preemptive multitasking after installing by adding "preemptive=false" to the boot arguments in /boot/config.lua.

The Phoenix operating system is currently ALPHA SOFTWARE. There will be a lot of bugs in the software, and many features are missing or incomplete. Please help fix these bugs by reporting them at https://github.com/Phoenix-ComputerCraft/issues.

For more information on Phoenix, as well as documentation on APIs, see https://phoenix.madefor.cc.
]]
    keyMap {
        [keys.enter] = function() next, running = true, false end,
        [keys.tab] = function() next, running = false, false end,
        [keys.q] = function() running = false end
    }
    run()
    if next then return screens.license(state)
    elseif next == false then return screens.welcome(state)
    else return false end
end

function screens.license(state)
    local next
    clearScreen("F=Agree  Q=Decline  TAB=Back  \24\25=Scroll")
    label("You must agree to the following license agreement to install Phoenix.")
    textBox() [[
# PHOENIX OPERATING SYSTEM PRE-RELEASE END-USER LICENSE AGREEMENT

__*IMPORTANT: PLEASE READ THIS DOCUMENT IN ITS ENTIRETY*__

This End-User License Agreement (hereinafter, "Agreement") creates a legally binding Agreement between you, as an end user of our services (hereinafter, "End User"), and JackMacWindows (hereinafter, "Developer"). You will be referred to through second-person pronouns such as "your" and "yours." We, the Developer, will be referred to with pronouns such as "us," "our," and "ours." Collectively, you and the Developer may be referred to as the "Parties" and individually as "Party."

This license governs the use of all software products as part of the Phoenix operating system (hereinafter, "Software"), specifically:

- "Phoenix" kernel
- "startmgr" initialization system
- "libsystem" library
- "libcraftos" library
- "baseutils" programs (excluding "cash")
- "usermgr" program

By accessing, downloading, installing, or otherwise using our Software in any way, you agree to be bound by this Agreement in its entirety. If you do not agree, you must cease use of the Software immediately.

### SOFTWARE LICENSE
When you lawfully access the Software, whether through purchase or other lawful means, we grant you, subject to all of the terms and conditions of this Agreement, a non-exclusive, non-transferable, limited, revocable personal license to use the Software ("License"). This License may not be used for any business or commercial purposes. This License may not be transferred to any third parties without express, lawful, written permission from the Developer and this License terminates upon your cessation of use of the Software.

This License shall be applicable to all lawful End Users of the Software, unless a separate written agreement has been executed between you and the Developer.

### RESTRICTIONS
The License provided hereunder is subject to the following additional restrictions:

a) You agree not redistribute or reproduce the Software, in whole or in part, to any other party.
b) You are granted permission to modify the Software; however, you agree to not distribute or disclose derivative works to any other party.

### ADDITIONAL TERMS
Additional terms may be applicable to the Parties' relationship with each other, such as the Developer Terms & Conditions or Terms of Use, the Developer Privacy Policy, and any other such written agreements governing your relationship with us. Nothing contained herein is intended to restrict the terms of any other written agreement. Instead, all relevant documents shall be construed as broadly as possible.

### INTELLECTUAL PROPERTY
You agree that the Software, Developer website and all services provided by the Developer are the property of the Developer, including all copyrights, trademarks, trade secrets, patents, and other intellectual property ("Developer IP"). You agree that the Developer owns all right, title and interest in and to the Developer IP and that you will not use the Developer IP for any unlawful or infringing purpose. You agree not to reproduce or distribute the Developer IP in any way, including electronically or via registration of any new trademarks, trade names, service marks or Uniform Resource Locators (URLs), without express written permission from the Developer.

### REVERSE ENGINEERING & SECURITY
You agree not to undertake any of the following actions:

a) Violate the security of the Software through any unauthorized access, circumvention of encryption or other security tools, data mining or interference to any host, user or network;  
b) Copy or otherwise distribute copies of the Software unlawfully, such as through any peer-to-peer network or other intellectual property circumvention tool.

### INDEMNIFICATION
You agree to defend and indemnify the Developer and any of its affiliates (if applicable) and hold us harmless against any and all legal claims and demands, including reasonable attorney's fees, which may arise from or relate to your use or misuse of the Software, your breach of this Agreement, or your conduct or actions. You agree that the Developer shall be able to select its own legal counsel and may participate in its own defense, if the Developer wishes.

### SERVICE INTERRUPTIONS
The Developer may need to interrupt access to the Software to perform maintenance or emergency services on a scheduled or unscheduled basis. You agree that your access to the Software may be affected by unanticipated or unscheduled downtime, for any reason, but that the Developer shall have no liability for any damage or loss caused as a result of such downtime.

### NO WARRANTIES
You agree that your use of the Software is at your sole and exclusive risk and that the Software is provided on "As Is" basis. The Developer hereby expressly disclaims any and all express or implied warranties of any kind, including, but not limited to the implied warranty of fitness for a particular purpose and the implied warranty of merchantability. The Developer makes no warranties that the Software will meet your needs or that access to the Software will be uninterrupted or error-free. The Developer also makes no warranties as to the reliability or accuracy of any information contained within the Software. You agree that any damage that may occur to you, through your computer system, or as a result of loss of your data from your use of the Software is your sole responsibility and that the Developer is not liable for any such damage or loss.

### LIMITATION ON LIABILITY
The Developer is not liable for any damages that may occur to you as a result of your use of the Software, to the fullest extent permitted by law. The maximum liability of the Developer arising from or relating to this Agreement is limited to the greater of one hundred ($100) US Dollars or the amount you paid to the Developer in the last six (6) months. This section applies to any and all claims by you, including, but not limited to, lost profits or revenues, consequential or punitive damages, negligence, strict liability, fraud, or torts of any kind.

### DISPUTE RESOLUTION & GOVERNING LAW
All disputes will be resolved as provided for in the Terms & Conditions or Terms of Service. Should Developer not have a live version of any Terms document or any other provisions in any user-facing document covering dispute resolution and governing law, the laws of Michigan shall govern any matter or dispute relating to or arising from this EULA or the Developer's relationship with End User.

### ASSIGNMENT
This Agreement, or the rights granted hereunder, may not be assigned, sold, leased or otherwise transferred in whole or part by you. Should this Agreement, or the rights granted hereunder, be assigned, sold, leased or otherwise transferred by the Developer, the rights and liabilities of the Developer will bind and inure to any assignees, administrators, successors, and executors.

### HEADINGS FOR CONVENIENCE ONLY
Headings of parts and sub-parts under this Agreement are for convenience and organization, only. Headings shall not affect the meaning of any provisions of this Agreement.

### NO AGENCY, PARTNERSHIP OR JOINT VENTURE
No agency, partnership, or joint venture has been created between the Parties as a result of this Agreement. No Party has any authority to bind the other to third parties.

### FORCE MAJEURE
The Developer is not liable for any failure to perform due to causes beyond its reasonable control including, but not limited to, acts of God, acts of civil authorities, acts of military authorities, riots, embargoes, acts of nature and natural disasters, and other acts which may be due to unforeseen circumstances.

### ELECTRONIC COMMUNICATIONS PERMITTED
Electronic communications are permitted to both Parties under this Agreement, including e-mail or online chat over the Discord platform. For any questions or concerns, please email us at the following address: jackmacwindowslinux@gmail.com, or contact us on Discord at the following username: JackMacWindows#9776.



This product contains portions from Recrafted, cash and json.lua, which are licensed under the MIT license.

Copyright (c) 2020-2022 JackMacWindows
Copyright (c) 2022 Ocawesome101 (libcraftos.init)
Copyright (c) 2020 rxi (libsystem.serialization.json)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

The LibDeflate component is licensed under the zlib license.

(C) 2018-2021 Haoqian He

This software is provided 'as-is', without any express or implied warranty.  In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
]]
    keyMap {
        [keys.f] = function() next, running = true, false end,
        [keys.tab] = function() next, running = false, false end,
        [keys.q] = function() running = false end
    }
    run()
    if next then return screens.rootdir(state)
    elseif next == false then return screens.readme(state)
    else return false end
end

function screens.rootdir(state)
    local next, path
    clearScreen("ENTER=Continue  TAB=Back  Q=Quit")
    label("Please enter the path to the desired root directory. This is where all files will be stored while running Phoenix.")
    inputBox(function(p) path, next, running = p, true, false end, state.rootdir or "/root")
    keyMap {
        [keys.tab] = function() next, running = false, false end,
        [keys.q] = function() running = false end
    }
    run()
    state.rootdir = path
    if next then return screens.username(state)
    elseif next == false then return screens.license(state)
    else return false end
end

function screens.username(state)
    local next, path
    clearScreen("ENTER=Continue  TAB=Back  Q=Quit")
    label("Please enter the username for the primary user account. More users may be created after installation.")
    inputBox(function(p) path, next, running = p, true, false end, state.username)
    keyMap {
        [keys.tab] = function() next, running = false, false end,
        [keys.q] = function() running = false end
    }
    run()
    state.username = path
    if next then return screens.password(state)
    elseif next == false then return screens.rootdir(state)
    else return false end
end

function screens.password(state)
    local next, path
    clearScreen("ENTER=Continue  TAB=Back  Q=Quit")
    label("Please enter the password for the primary user account.")
    inputBox(function(p) path, next, running = p, true, false end, state.password, "\7")
    keyMap {
        [keys.tab] = function() next, running = false, false end,
        [keys.q] = function() running = false end
    }
    run()
    state.password = path
    if next then return screens.components(state)
    elseif next == false then return screens.username(state)
    else return false end
end

function screens.components(state)
    local next
    clearScreen("ENTER=Continue  SPACE=Toggle  TAB=Back  Q=Quit")
    label("Select any additional components to install from the list below.")
    -- TODO: Actually add components here
    textBox() "<No components available>"
    keyMap {
        [keys.enter] = function() next, running = true, false end,
        [keys.tab] = function() next, running = false, false end,
        [keys.q] = function() running = false end
    }
    run()
    state.components = {
        "phoenix",
        "libsystem",
        "libcraftos",
        "baseutils",
        "pxboot",
        "startmgr",
        "usermgr",
        "ar",
        "sha2",
        "tar",
        "muxzcat",
        "libdeflate",
        "diff",
        "dpkg",
    }
    if next then return screens.confirm(state)
    elseif next == false then return screens.password(state)
    else return false end
end

function screens.confirm(state)
    local dlsize = pkginfo["stage2-tarball"].filesize
    local instsize = 0
    for _, v in ipairs(state.components) do
        dlsize = dlsize + pkginfo[v].pkgsize
        instsize = instsize + pkginfo[v].filesize
    end
    local required, space = math.max(dlsize, instsize), fs.getFreeSpace(state.rootdir)
    if space < required then
        return screens.message(state, "The selected components require " .. math.ceil(required / 1024) .. "kiB of space, but only " .. math.ceil(space / 1024) .. "kiB is available. Please deselect some components or delete files to make space.", screens.components)
    end
    local details = ("Root directory: %s\nPrimary user: %s\nDownload size: %dkiB\nInstalled size: %dkiB\nComponents:\n"):format(state.rootdir, state.username, math.floor((dlsize - pkginfo["stage2-tarball"].filesize + pkginfo["stage2-tarball"].pkgsize) / 1024), math.floor(instsize / 1024))
    for _, k in pairs(state.components) do details = details .. "\7 " .. k .. "\n" end
    local next
    clearScreen("ENTER=Install  TAB=Back  Q=Quit")
    label[[
The following settings will be used to install Phoenix.

  * To install Phoenix, press ENTER.
  * To adjust any settings, press F1 to go back.]]
    textBox()(details)
    keyMap {
        [keys.enter] = function() next, running = true, false end,
        [keys.tab] = function() next, running = false, false end,
        [keys.q] = function() running = false end
    }
    run()
    if next then return screens.download(state)
    elseif next == false then return screens.components(state)
    else return false end
end

function screens.download(state)
    clearScreen("")
    label "Downloading components..."
    local progress = progressBar()
    local total = 1
    for _ in pairs(state.components) do total = total + 1 end
    local n = 0
    fs.makeDir(fs.combine(state.rootdir, "tmp/pkg"))
    for _, k in ipairs(state.components) do
        drawStatus("Downloading: " .. k)
        local handle, err = http.get(url .. k .. ".deb", nil, true)
        if not handle then
            sleep(0)
            return screens.message(state, "An error occurred while downloading the " .. k .. " component. Installation cannot continue.\n\nPress ENTER to exit.\n\nError message: " .. err, function() return false end)
        end
        local file, err = fs.open(fs.combine(state.rootdir, "tmp/pkg/" .. k .. ".deb"), "wb")
        if not file then
            handle.close()
            sleep(0)
            return screens.message(state, "An error occurred while saving the " .. k .. " component. Installation cannot continue.\n\nPress ENTER to exit.\n\nError message: " .. err, function() return false end)
        end
        file.write(handle.readAll())
        handle.close()
        file.close()
        n = n + 1
        progress(n / total)
    end
    drawStatus("Downloading: base system")
    local handle, err = http.get(url .. "stage2.tar", nil, true)
    if not handle then
        sleep(0)
        return screens.message(state, "An error occurred while downloading the base system component. Installation cannot continue.\n\nPress ENTER to exit.\n\nError message: " .. err, function() return false end)
    end
    state.stage2 = handle.readAll()
    handle.close()
    progress(1)
    return screens.install_stage1(state)
end

function screens.install_stage1(state)
    clearScreen("Parsing tarball...")
    label "Extracting base system..."
    local progress = progressBar()
    local files = {}
    local pos = 1
    local total = 2
    while pos < #state.stage2 do
        local path = state.stage2:sub(pos, pos + 99):gsub("%z+$", "")
        if path == "" then break end
        local size = tonumber(state.stage2:sub(pos + 124, pos + 135):gsub("[^0-7]", ""), 8)
        local type = tonumber(state.stage2:sub(pos + 156, pos + 156):gsub("%D", ""), 10)
        if type == 0 then
            files[path] = state.stage2:sub(pos + 512, pos + size + 511)
            total = total + 1
        end
        pos = pos + 512 + math.ceil(size / 512) * 512
    end
    state.stage2 = nil
    local n = 1
    progress(n / total)
    for k, v in pairs(files) do
        drawStatus("Extracting: " .. k)
        local file, err = fs.open(fs.combine(state.rootdir, k), "wb")
        if not file then
            sleep(0)
            return screens.message(state, "An error occurred while extracting " .. k .. ". Installation cannot continue.\n\nPress ENTER to exit.\n\nError message: " .. err, function() return false end)
        end
        file.write(v)
        file.close()
        n = n + 1
        progress(n / total)
    end
    drawStatus("Saving configuration...")
    local file, err = fs.open(fs.combine(state.rootdir, "install_config.lua"), "w")
    if not file then
        sleep(0)
        return screens.message(state, "An error occurred while saving the config. Installation cannot continue.\n\nPress ENTER to exit.\n\nError message: " .. err, function() return false end)
    end
    file.write("return ")
    file.write(textutils.serialize(state))
    file.close()
    file = fs.open("startup.lua", "w")
    file.write("if not fs.exists('" .. fs.combine(state.rootdir, "install_config.lua") .. "') then local file = fs.open('startup.lua', 'w') file.write('shell.run(\"" .. fs.combine(state.rootdir, "boot/pxboot.lua") .. "\")') file.close() return shell.run('/startup.lua') else fs.delete('startup.lua') end")
    file.close()
    progress(1)
    return screens.reboot(state)
end

function screens.reboot(state)
    clearScreen("Please Wait...")
    label "The first portion of setup has completed. Installation will continue in the new Phoenix system. The system will reboot in 5 seconds."
    local progress = progressBar()
    for i = 1, 5 do
        progress(i / 5)
        sleep(1)
    end
    -- I lied. We're not rebooting, just booting into UnBIOS. Sorry not sorry.
    shell.run(fs.combine(state.rootdir, "boot/unbios.lua"), fs.combine(state.rootdir, "boot/kernel.lua"), "root=" .. state.rootdir, "init=/install_stage2.lua")
    -- If this fails, it's an error.
    return screens.message(state, "An error occurred while rebooting. Installation cannot continue.\n\nPress ENTER to exit.", function() return false end)
end

screens.loading{}

term.setPaletteColor(colors.orange, term.nativePaletteColor(colors.orange))
term.setPaletteColor(colors.white, term.nativePaletteColor(colors.white))
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1, 1)
