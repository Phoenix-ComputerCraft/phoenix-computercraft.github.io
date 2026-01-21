local url = "https://phoenix.madefor.cc/packages/"

if not term then error("This program requires CraftOS. Use the components program to add and remove components.") end
term.setPaletteColor(colors.orange, 0xD06018)
term.setPaletteColor(colors.white, 0xD8D8D8)

local width, height = term.getSize()
local nextLine
local coros = {}
local restoreCursor
local running = true
local pkginfo = {}

local mainScreen = window.create(term.current(), 1, 1, width, height)

local lastStatus
local function drawStatus(status)
    mainScreen.setCursorPos(3, height)
    mainScreen.setBackgroundColor(colors.white)
    mainScreen.setTextColor(colors.black)
    mainScreen.clearLine()
    mainScreen.write(status)
    lastStatus = status
end

local function clearScreen(status)
    mainScreen.setBackgroundColor(colors.orange)
    mainScreen.setTextColor(colors.white)
    mainScreen.clear()
    mainScreen.setCursorBlink(false)
    mainScreen.setCursorPos(3, 2)
    mainScreen.write("Phoenix Setup")
    mainScreen.setCursorPos(1, 3)
    mainScreen.write(("\x8C"):rep(16))
    drawStatus(status)
    nextLine = 5
    coros = {}
    restoreCursor = nil
end

local function label(text)
    local win = window.create(mainScreen, 3, nextLine, width - 4, height - nextLine, false)
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
    mainScreen.setBackgroundColor(colors.orange)
    mainScreen.setTextColor(colors.white)
    mainScreen.setCursorPos(3, nextLine)
    mainScreen.write("\x9C" .. ("\x8C"):rep(width - 6))
    mainScreen.setBackgroundColor(colors.white)
    mainScreen.setTextColor(colors.orange)
    mainScreen.write("\x93")
    for i = 1, h do
        mainScreen.setCursorPos(mainScreen.getCursorPos() - 1, nextLine + i)
        mainScreen.write("\x95")
    end
    mainScreen.setBackgroundColor(colors.orange)
    mainScreen.setTextColor(colors.white)
    for i = 1, h do
        mainScreen.setCursorPos(3, nextLine + i)
        mainScreen.write("\x95")
    end
    mainScreen.setCursorPos(3, nextLine + h + 1)
    mainScreen.write("\x8D" .. ("\x8C"):rep(width - 6) .. "\x8E")
    local y, w = nextLine + 1, width - 7
    local outer = window.create(mainScreen, 4, y, w, h)
    outer.setBackgroundColor(colors.orange)
    outer.clear()
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
            mainScreen.setCursorPos(w + 4, y)
            mainScreen.blit(scrollPos > 1 and "\30" or " ", "0", "1")
            mainScreen.setCursorPos(w + 4, y + h - 1)
            mainScreen.blit(scrollPos < th - h and "\31" or " ", "0", "1")
        end
    end)
    nextLine = nextLine + h + 2
end end

local function inputBox(callback, default, replace)
    mainScreen.setBackgroundColor(colors.orange)
    mainScreen.setTextColor(colors.white)
    mainScreen.setCursorPos(3, nextLine)
    mainScreen.write("\x9C" .. ("\x8C"):rep(width - 6))
    mainScreen.setBackgroundColor(colors.white)
    mainScreen.setTextColor(colors.orange)
    mainScreen.write("\x93")
    mainScreen.setCursorPos(mainScreen.getCursorPos() - 1, nextLine + 1)
    mainScreen.write("\x95")
    mainScreen.setBackgroundColor(colors.orange)
    mainScreen.setTextColor(colors.white)
    mainScreen.setCursorPos(3, nextLine + 1)
    mainScreen.write("\x95")
    mainScreen.setCursorPos(3, nextLine + 2)
    mainScreen.write("\x8D" .. ("\x8C"):rep(width - 6) .. "\x8E")
    local win = window.create(mainScreen, 4, nextLine + 1, width - 6, 1)
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

-- selections: false = unselected, true = selected default, "R" = required
local function selectionBox(h, selections, callback, didSelect)
    h = h or height - nextLine - 3
    local nsel = 0
    for _ in pairs(selections) do nsel = nsel + 1 end
    mainScreen.setBackgroundColor(colors.orange)
    mainScreen.setTextColor(colors.white)
    mainScreen.setCursorPos(3, nextLine)
    mainScreen.write("\x9C" .. ("\x8C"):rep(width - 6))
    mainScreen.setBackgroundColor(colors.white)
    mainScreen.setTextColor(colors.orange)
    mainScreen.write("\x93")
    for i = 1, h do
        mainScreen.setCursorPos(mainScreen.getCursorPos() - 1, nextLine + i)
        mainScreen.write("\x95")
    end
    mainScreen.setBackgroundColor(colors.orange)
    mainScreen.setTextColor(colors.white)
    for i = 1, h do
        mainScreen.setCursorPos(3, nextLine + i)
        mainScreen.write("\x95")
    end
    mainScreen.setCursorPos(3, nextLine + h + 1)
    mainScreen.write("\x8D" .. ("\x8C"):rep(width - 6) .. "\x8E")
    local y, w = nextLine + 1, width - 7
    local outer = window.create(mainScreen, 4, y, w, h)
    outer.setBackgroundColor(colors.orange)
    outer.clear()
    local inner = window.create(outer, 1, 1, w, nsel)
    inner.setBackgroundColor(colors.orange)
    inner.setTextColor(colors.white)
    inner.clear()
    local lines = {}
    local nl, selected = 1, 1
    for k, v in pairs(selections) do
        inner.setCursorPos(1, nl)
        inner.write((v and (v == "R" and "[-] " or "[\xD7] ") or "[ ] ") .. k)
        lines[nl] = {k, not not v}
        nl = nl + 1
    end
    mainScreen.setCursorPos(w + 4, y + h - 1)
    mainScreen.blit(1 < nsel - h + 1 and "\31" or " ", "0", "1")
    inner.setCursorPos(2, selected)
    inner.setCursorBlink(true)
    restoreCursor = inner.restoreCursor
    coros[#coros+1] = coroutine.create(function()
        local scrollPos = 1
        while true do
            local ev = table.pack(os.pullEvent())
            local dir
            if ev[1] == "key" then
                if ev[2] == keys.up then dir = -1
                elseif ev[2] == keys.down then dir = 1
                elseif ev[2] == keys.space and selections[lines[selected][1]] ~= "R" then
                    lines[selected][2] = not lines[selected][2]
                    inner.setCursorPos(2, selected)
                    inner.write(lines[selected][2] and "\xD7" or " ")
                    if didSelect and didSelect(lines[selected][1], lines[selected][2]) then
                        for i, v in ipairs(lines) do
                            local vv = selections[v[1]] == "R" and "R" or v[2]
                            inner.setCursorPos(2, i)
                            inner.write((vv and (vv == "R" and "-" or "\xD7") or " "))
                        end
                    end
                    inner.setCursorPos(2, selected)
                elseif ev[2] == keys.enter then
                    local s = {}
                    for _, v in ipairs(lines) do s[v[1]] = selections[v[1]] == "R" or v[2] end
                    callback(s)
                end
            elseif ev[1] == "mouse_scroll" and ev[3] >= 4 and ev[3] < 4 + w and ev[4] >= y and ev[4] < y + h then
                dir = ev[2]
            end
            if dir and (selected + dir >= 1 and selected + dir <= nsel) then
                selected = selected + dir
                if selected - scrollPos < 0 or selected - scrollPos >= h then
                    scrollPos = scrollPos + dir
                    inner.reposition(1, 2 - scrollPos)
                end
                inner.setCursorPos(2, selected)
            end
            mainScreen.setCursorPos(w + 4, y)
            mainScreen.blit(scrollPos > 1 and "\30" or " ", "0", "1")
            mainScreen.setCursorPos(w + 4, y + h - 1)
            mainScreen.blit(scrollPos < nsel - h + 1 and "\31" or " ", "0", "1")
            inner.restoreCursor()
        end
    end)
    nextLine = nextLine + h + 2
end

local function progressBar()
    mainScreen.setBackgroundColor(colors.orange)
    mainScreen.setTextColor(colors.white)
    mainScreen.setCursorPos(3, nextLine)
    mainScreen.write("\x9C" .. ("\x8C"):rep(width - 6))
    mainScreen.setBackgroundColor(colors.white)
    mainScreen.setTextColor(colors.orange)
    mainScreen.write("\x93")
    mainScreen.setCursorPos(mainScreen.getCursorPos() - 1, nextLine + 1)
    mainScreen.write("\x95")
    mainScreen.setBackgroundColor(colors.orange)
    mainScreen.setTextColor(colors.white)
    mainScreen.setCursorPos(3, nextLine + 1)
    mainScreen.write("\x95")
    mainScreen.setCursorPos(3, nextLine + 2)
    mainScreen.write("\x8D" .. ("\x8C"):rep(width - 6) .. "\x8E")
    local win = window.create(mainScreen, 4, nextLine + 1, width - 6, 1)
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

local filesDropped = {}
local function get(name)
    if http then return http.get(url .. name, nil, true) end
    local win = window.create(term.current(), 1, 1, width, height)
    win.setBackgroundColor(colors.orange)
    win.setTextColor(colors.white)
    win.clear()
    win.setCursorBlink(false)
    win.setCursorPos(3, 2)
    win.write("Phoenix Setup")
    win.setCursorPos(1, 3)
    win.write(("\x8C"):rep(16))
    win.setCursorPos(3, height)
    win.setBackgroundColor(colors.white)
    win.setTextColor(colors.black)
    win.clearLine()
    win.write(lastStatus)
    win.setBackgroundColor(colors.orange)
    win.setTextColor(colors.white)
    win.setCursorPos(3, 5)
    win.write("Please drop the file named '" .. name .. "'.")
    while not filesDropped[name] do
        local _, param = os.pullEvent("file_transfer")
        for _, file in ipairs(param.getFiles()) do
            filesDropped[file.getName()] = file
        end
    end
    mainScreen.redraw()
    return filesDropped[name]
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
    local handle, err = get("Packages")
    if not handle then return screens.message(state, "An error occurred while initializing Setup: Could not download package list: " .. err .. "\n\nSetup cannot continue. Press ENTER to exit.", function() end) end
    local pkg
    for line in handle.readLine do
        local k, v = line:match("^([%w%-]+):%s*(.+)$")
        if k then
            if k == "Package" then
                pkg = v
                pkginfo[pkg] = {}
            elseif k == "Size" then pkginfo[pkg].pkgsize = tonumber(v)
            elseif k == "Installed-Size" then pkginfo[pkg].filesize = tonumber(v) * 1024
            elseif k == "Priority" then pkginfo[pkg].priority = v
            elseif k == "Essential" then pkginfo[pkg].essential = true
            elseif k == "Depends" then
                local d = {}
                for p in v:gmatch "[^,]+" do d[p:match "[%w%-]+"] = true end
                pkginfo[pkg].depends = d
            end
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
Electronic communications are permitted to both Parties under this Agreement, including e-mail or online chat over the Discord platform. For any questions or concerns, please email us at the following address: jackmacwindowslinux@gmail.com, or contact us on Discord at the following username: jackmacwindows (formerly JackMacWindows#9776).

This software complies with part 15 of the FCC Rules. Operation is subject to the following two conditions: (1) This software may not cause harmful interference, and (2) this software must accept any interference received, including interference that may cause undesired operation.



This product contains portions from Recrafted, cash, lualzw, and json.lua, which are licensed under the MIT license.

Copyright (c) 2020-2022 JackMacWindows
Copyright (c) 2022 Ocawesome101 (libcraftos.init - https://github.com/Ocawesome101/recrafted)
Copyright (c) 2020 rxi (libsystem.serialization.json - https://github.com/rxi/json.lua)
Copyright (c) 2016 Rochet2 (baseutils compress, decompress - https://github.com/Rochet2/lualzw)

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
    if next then os.pullEvent("char") return screens.rootdir(state)
    elseif next == false then return screens.readme(state)
    else return false end
end

function screens.rootdir(state)
    local next, path
    clearScreen("ENTER=Continue  TAB=Back  F5=Quit")
    label("Please enter the path to the desired root directory. This is where all files will be stored while running Phoenix.")
    inputBox(function(p) path, next, running = p, true, false end, state.rootdir or "/root")
    keyMap {
        [keys.tab] = function() next, running = false, false end,
        [keys.f5] = function() running = false end
    }
    run()
    state.rootdir = path
    if next then return screens.luz(state)
    elseif next == false then return screens.license(state)
    else return false end
end

function screens.luz(state)
    local next, path
    clearScreen("ENTER=Skip  L=Use Luz  TAB=Back  F5=Quit")
    label("The Phoenix kernel is available as a Luz file, which is highly compressed and reduces the kernel's disk usage by ~200 kB. However, using it will increase boot times by a few seconds.\n\n \7 Press L to use the Luz-compressed kernel.\n \7 Press Enter to skip and use the full-size kernel.")
    keyMap {
        [keys.tab] = function() next, running = false, false end,
        [keys.f5] = function() running = false end,
        [keys.enter] = function() next, running = true, false end,
        [keys.l] = function() next, running = "l", false end
    }
    run()
    state.freeSpace = fs.getFreeSpace("/")
    state.spanfs_disks = nil
    if next == "l" then os.pullEvent("char") state.luz = true return screens.spanfs_intro(state)
    elseif next then return screens.spanfs_intro(state)
    elseif next == false then return screens.rootdir(state)
    else return false end
end

function screens.spanfs_intro(state)
    local next, path
    clearScreen("ENTER=Skip  S=Continue  TAB=Back  F5=Quit")
    label("Phoenix can be installed across multiple disk drives to increase the available disk space by using a span. This requires at least two connected disk drives, which cannot be removed while the OS is running.\n\n \7 Press S to set up and install to a span.\n \7 Press Enter to skip and install on the local filesystem normally.")
    keyMap {
        [keys.tab] = function() next, running = false, false end,
        [keys.f5] = function() running = false end,
        [keys.enter] = function() next, running = true, false end,
        [keys.s] = function() next, running = "s", false end
    }
    run()
    state.freeSpace = fs.getFreeSpace("/")
    state.spanfs_disks = nil
    if next == "s" then os.pullEvent("char") return screens.spanfs_name(state)
    elseif next then return screens.username(state)
    elseif next == false then return screens.luz(state)
    else return false end
end

function screens.spanfs_name(state)
    local next, path
    clearScreen("ENTER=Continue  TAB=Back  F5=Quit")
    label("Please enter a name for the span. This is used to identify the disks.")
    inputBox(function(p) path, next, running = p, true, false end, state.spanfs_name or "Phoenix")
    keyMap {
        [keys.tab] = function() next, running = false, false end,
        [keys.f5] = function() running = false end
    }
    run()
    state.spanfs_name = path
    if next then return screens.spanfs_select(state)
    elseif next == false then return screens.spanfs_intro(state)
    else return false end
end

function screens.spanfs_select(state)
    local next
    clearScreen("ENTER=Continue  SPACE=Toggle  TAB=Back  F5=Quit")
    label("Select the disk drives to include in the span. Order or IDs will not matter after installation. ALL SELECTED DISKS WILL BE ERASED.")
    local selections = {}
    for _, drive in ipairs{peripheral.find("drive")} do if drive.isDiskPresent() then selections[peripheral.getName(drive)] = false end end
    selectionBox(nil, selections, function(entries)
        state.spanfs_disks = {}
        state.freeSpace = 0
        for k, v in pairs(entries) do if v then
            if #state.spanfs_disks > 0 then state.freeSpace = state.freeSpace + fs.getCapacity(peripheral.call(k, "getMountPath")) - 500 end
            state.spanfs_disks[#state.spanfs_disks+1] = k
        end end
        next, running = true, false
    end)
    keyMap {
        [keys.tab] = function() next, running = false, false end,
        [keys.f5] = function() running = false end
    }
    run()
    if next then return screens.username(state)
    elseif next == false then return screens.spanfs_name(state)
    else return false end
end

function screens.username(state)
    local next, path
    clearScreen("ENTER=Continue  TAB=Back  F5=Quit")
    label("Please enter the username for the primary user account. More users may be created after installation.")
    inputBox(function(p) path, next, running = p, true, false end, state.username)
    keyMap {
        [keys.tab] = function() next, running = false, false end,
        [keys.f5] = function() running = false end
    }
    run()
    state.username = path
    if next then return screens.password(state)
    elseif next == false then return screens.spanfs_intro(state)
    else return false end
end

function screens.password(state)
    local next, path
    clearScreen("ENTER=Continue  TAB=Back  F5=Quit")
    label("Please enter the password for the primary user account.")
    inputBox(function(p) path, next, running = p, true, false end, state.password, "\7")
    keyMap {
        [keys.tab] = function() next, running = false, false end,
        [keys.f5] = function() running = false end
    }
    run()
    state.password = path
    if next then return screens.password2(state)
    elseif next == false then return screens.username(state)
    else return false end
end

function screens.password2(state)
    local next, path
    clearScreen("ENTER=Continue  TAB=Back  F5=Quit")
    label("Please type the password again to confirm.")
    inputBox(function(p) path, next, running = p, true, false end, "", "\7")
    keyMap {
        [keys.tab] = function() next, running = false, false end,
        [keys.f5] = function() running = false end
    }
    run()
    if next then
        if state.password ~= path then
            return screens.message(state, "The provided passwords do not match. Please try again.", screens.password)
        end
        return screens.components(state)
    elseif next == false then return screens.password(state)
    else return false end
end

function screens.components(state)
    local next
    clearScreen("ENTER=Continue  SPACE=Toggle  TAB=Back  F5=Quit")
    label("Select the components to install from the list below.\n[-] = required, [\xD7] = selected")
    local selections = {}
    for k, v in pairs(pkginfo) do if k ~= "stage2-tarball" then
        if k == "phoenix" or k == "phoenix-luz" then
            if (state.luz and k == "phoenix-luz") or (not state.luz and k == "phoenix") then selections[k] = "R" end
        elseif v.essential or v.priority == "required" or (state.spanfs_disks and (k == "initrd-utils" or k == "spanfs")) then selections[k] = "R"
        elseif v.priority == "optional" then selections[k] = false
        else selections[k] = true end
    end end
    local function updateRequirements()
        local function update(pkg)
            if selections[pkg] and pkginfo[pkg].depends then
                for k in pairs(pkginfo[pkg].depends) do
                    selections[k] = "R"
                    update(k)
                end
            end
        end
        for k, v in pairs(selections) do selections[k] = (pkginfo[k].essential or pkginfo[k].priority == "required" or (state.spanfs_disks and (k == "initrd-utils" or k == "spanfs"))) and "R" or not not v end
        for k in pairs(selections) do update(k) end
    end
    updateRequirements()
    selectionBox(nil, selections, function(entries)
        state.components = {}
        local s, nodes = {}, {}
        for k, v in pairs(entries) do if v then
            local d = {}
            for l, w in pairs(pkginfo[k].depends or {}) do d[l] = w end
            nodes[k] = d
            if not _G.next(d) then s[#s+1] = k end
        end end
        while #s > 0 do
            local n = table.remove(s)
            state.components[#state.components+1] = n
            for k, v in pairs(nodes) do
                if v[n] then
                    v[n] = nil
                    if not _G.next(v) then s[#s+1] = k end
                end
            end
        end
        next, running = true, false
    end, function(k, v) selections[k] = v updateRequirements() return true end)
    keyMap {
        [keys.tab] = function() next, running = false, false end,
        [keys.f5] = function() running = false end
    }
    run()
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
    local required, space = math.max(dlsize, instsize), state.freeSpace
    if space < required then
        return screens.message(state, "The selected components require " .. math.ceil(required / 1024) .. "kiB of space, but only " .. math.ceil(space / 1024) .. "kiB is available. Please deselect some components or delete files to make space.", screens.components)
    end
    local details = ("Root directory: %s\nUsing spanfs: %s\nPrimary user: %s\nDownload size: %dkiB\nInstalled size: %dkiB\nComponents:\n"):format(state.rootdir, state.spanfs_disks and "Yes, on " .. table.concat(state.spanfs_disks, ", ") or "No", state.username, math.floor((dlsize - pkginfo["stage2-tarball"].filesize + pkginfo["stage2-tarball"].pkgsize) / 1024), math.floor(instsize / 1024))
    for _, k in ipairs(state.components) do details = details .. "\7 " .. k .. "\n" end
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
    local total = 2
    for _ in pairs(state.components) do total = total + 1 end
    local n = 0
    fs.makeDir(fs.combine(state.rootdir, "tmp/pkg"))
    for _, k in ipairs(state.components) do
        drawStatus("Downloading: " .. k)
        local handle, err = get(k .. ".deb")
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
    local handle, err = get("stage2.tar")
    if not handle then
        sleep(0)
        return screens.message(state, "An error occurred while downloading the base system component. Installation cannot continue.\n\nPress ENTER to exit.\n\nError message: " .. err, function() return false end)
    end
    state.stage2 = handle.readAll()
    handle.close()
    progress(1 - 1 / total)
    drawStatus("Downloading: kernel")
    handle, err = get("kernel.lua")
    if not handle then
        sleep(0)
        return screens.message(state, "An error occurred while downloading the kernel component. Installation cannot continue.\n\nPress ENTER to exit.\n\nError message: " .. err, function() return false end)
    end
    state.kernel = handle.readAll()
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
    if state.spanfs_disks then
        drawStatus("Formatting span...")
        state.spanfs = ('xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'):gsub('[xy]', function (c)
            local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
            return ('%x'):format(v)
        end)
        for i, v in ipairs(state.spanfs_disks) do
            local path = peripheral.call(v, "getMountPath")
            for _, p in ipairs(fs.find(fs.combine(path, "*"))) do fs.delete(p) end
            local file, err = fs.open(fs.combine(path, ".spanfs"), "w")
            if not file then
                sleep(0)
                return screens.message(state, "An error occurred while formatting the span. Installation cannot continue.\n\nPress ENTER to exit.\n\nError message: " .. err, function() return false end)
            end
            file.writeLine(state.spanfs_name)
            file.writeLine(state.spanfs)
            file.writeLine(i-1)
            file.close()
            if i == 1 then
                local file, err = fs.open(fs.combine(path, "index"), "wb")
                if not file then
                    sleep(0)
                    return screens.message(state, "An error occurred while formatting the span. Installation cannot continue.\n\nPress ENTER to exit.\n\nError message: " .. err, function() return false end)
                end
                file.write(("<III8I8BBs2s2Bs2BI"):pack(38 + #state.spanfs_name, 0, os.time() * 1000, os.time() * 1000, 5, 5, state.spanfs_name, "root", 1, "root", 7, 0))
                file.close()
            end
        end
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
    file.write("if not fs.exists('" .. fs.combine(state.rootdir, "install_config.lua") .. "') then local file = fs.open('startup.lua', 'w') file.write('sleep(0) shell.run(\"" .. fs.combine(state.rootdir, "boot/pxboot.lua") .. "\")') file.close() return shell.run('/startup.lua') else fs.delete('startup.lua') end")
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
    local ok, err = pcall(function()
        local fn = assert(load(state.kernel, "=kernel", "t", _G))
        if _VERSION == "Lua 5.1" then _G._ENV = _G end
        -- UnBIOS by JackMacWindows
        -- This will undo most of the changes/additions made in the BIOS, but some things may remain wrapped if `debug` is unavailable
        -- To use, just place a `bios.lua` in the root of the drive, and run this program
        -- Here's a list of things that are irreversibly changed:
        -- * both `bit` and `bit32` are kept for compatibility
        -- * string metatable blocking (on old versions of CC)
        -- In addition, if `debug` is not available these things are also irreversibly changed:
        -- * old Lua 5.1 `load` function (for loading from a function)
        -- * `loadstring` prefixing (before CC:T 1.96.0)
        -- * `http.request`
        -- * `os.shutdown` and `os.reboot`
        -- * `peripheral`
        -- * `turtle.equip[Left|Right]`
        -- Licensed under the MIT license
        local old_dofile = _G.dofile
        local keptAPIs = {bit32 = true, bit = true, ccemux = true, config = true, coroutine = true, debug = true, ffi = true, fs = true, http = true, io = true, jit = true, mounter = true, os = true, periphemu = true, peripheral = true, redstone = true, rs = true, term = true, utf8 = true, _HOST = true, _CC_DEFAULT_SETTINGS = true, _CC_DISABLE_LUA51_FEATURES = true, _VERSION = true, assert = true, collectgarbage = true, error = true, gcinfo = true, getfenv = true, getmetatable = true, ipairs = true, load = true, loadstring = true, math = true, newproxy = true, next = true, pairs = true, pcall = true, rawequal = true, rawget = true, rawlen = true, rawset = true, select = true, setfenv = true, setmetatable = true, string = true, table = true, tonumber = true, tostring = true, type = true, unpack = true, xpcall = true, turtle = true, pocket = true, commands = true, _G = true, sound = true}
        local t = {}
        for k in pairs(_G) do if not keptAPIs[k] then table.insert(t, k) end end
        for _,k in ipairs(t) do _G[k] = nil end
        local native = _G.term.native()
        for _, method in ipairs { "nativePaletteColor", "nativePaletteColour", "screenshot" } do
            native[method] = _G.term[method]
        end
        _G.term = native
        if _G.http then
            _G.http.checkURL = _G.http.checkURLAsync
            _G.http.websocket = _G.http.websocketAsync
        end
        if _G.commands then _G.commands = _G.commands.native end
        if _G.turtle then _G.turtle.native, _G.turtle.craft = nil end
        local delete = {os = {"version", "pullEventRaw", "pullEvent", "run", "loadAPI", "unloadAPI", "sleep"}, http = _G.http and {"get", "post", "put", "delete", "patch", "options", "head", "trace", "listen", "checkURLAsync", "websocketAsync"}, fs = {"complete", "isDriveRoot"}}
        for k,v in pairs(delete) do for _,a in ipairs(v) do _G[k][a] = nil end end
        -- Set up TLCO
        -- This functions by crashing `rednet.run` by removing `os.pullEventRaw`. Normally
        -- this would cause `parallel` to throw an error, but we replace `error` with an
        -- empty placeholder to let it continue and return without throwing. This results
        -- in the `pcall` returning successfully, preventing the error-displaying code
        -- from running - essentially making it so that `os.shutdown` is called immediately
        -- after the new BIOS exits.
        --
        -- From there, the setup code is placed in `term.native` since it's the first
        -- thing called after `parallel` exits. This loads the new BIOS and prepares it
        -- for execution. Finally, it overwrites `os.shutdown` with the new function to
        -- allow it to be the last function called in the original BIOS, and returns.
        -- From there execution continues, calling the `term.redirect` dummy, skipping
        -- over the error-handling code (since `pcall` returned ok), and calling
        -- `os.shutdown()`. The real `os.shutdown` is re-added, and the new BIOS is tail
        -- called, which effectively makes it run as the main chunk.
        local olderror = error
        _G.error = function() end
        _G.term.redirect = function() end
        function _G.term.native()
            _G.term.native = nil
            _G.term.redirect = nil
            _G.error = olderror
            term.setBackgroundColor(32768)
            term.setTextColor(1)
            term.setCursorPos(1, 1)
            term.setCursorBlink(true)
            term.clear()
            local oldshutdown = os.shutdown
            os.shutdown = function()
                os.shutdown = oldshutdown
                return fn("root=" .. state.rootdir, "init=/install_stage2.lua")
            end
        end
        if debug then
            -- Restore functions that were overwritten in the BIOS
            -- Apparently this has to be done *after* redefining term.native
            local function restoreValue(tab, idx, name, hint)
                local i, key, value = 1, debug.getupvalue(tab[idx], hint)
                while key ~= name and not (key == nil and i > 1) do
                    key, value = debug.getupvalue(tab[idx], i)
                    i=i+1
                end
                tab[idx] = value or tab[idx]
            end
            restoreValue(_G, "loadstring", "nativeloadstring", 1)
            restoreValue(_G, "load", "nativeload", 5)
            if http then restoreValue(http, "request", "nativeHTTPRequest", 3) end
            restoreValue(os, "shutdown", "nativeShutdown", 1)
            restoreValue(os, "reboot", "nativeReboot", 1)
            if turtle then
                restoreValue(turtle, "equipLeft", "v", 1)
                restoreValue(turtle, "equipRight", "v", 1)
            end
            do
                local i, key, value = 1, debug.getupvalue(peripheral.isPresent, 2)
                while key ~= "native" and key ~= nil do
                    key, value = debug.getupvalue(peripheral.isPresent, i)
                    i=i+1
                end
                _G.peripheral = value or peripheral
            end
            -- Restore Discord plugin in CraftOS-PC
            if debug.getupvalue(old_dofile, 2) == "status" then
                local _, status = debug.getupvalue(old_dofile, 2)
                _, _G.discord = debug.getupvalue(status, 4)
            end
        end
        while true do coroutine.yield() end
    end)
    -- If this fails, it's an error.
    return screens.message(state, "An error occurred while rebooting: " .. err .. ". Installation cannot continue.\n\nPress ENTER to exit.", function() return false end)
end

screens.loading{}

term.setPaletteColor(colors.orange, term.nativePaletteColor(colors.orange))
term.setPaletteColor(colors.white, term.nativePaletteColor(colors.white))
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1, 1)
