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
                    GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

                            Preamble

  The GNU General Public License is a free, copyleft license for
software and other kinds of works.

  The licenses for most software and other practical works are designed
to take away your freedom to share and change the works.  By contrast,
the GNU General Public License is intended to guarantee your freedom to
share and change all versions of a program--to make sure it remains free
software for all its users.  We, the Free Software Foundation, use the
GNU General Public License for most of our software; it applies also to
any other work released this way by its authors.  You can apply it to
your programs, too.

  When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
them if you wish), that you receive source code or can get it if you
want it, that you can change the software or use pieces of it in new
free programs, and that you know you can do these things.

  To protect your rights, we need to prevent others from denying you
these rights or asking you to surrender the rights.  Therefore, you have
certain responsibilities if you distribute copies of the software, or if
you modify it: responsibilities to respect the freedom of others.

  For example, if you distribute copies of such a program, whether
gratis or for a fee, you must pass on to the recipients the same
freedoms that you received.  You must make sure that they, too, receive
or can get the source code.  And you must show them these terms so they
know their rights.

  Developers that use the GNU GPL protect your rights with two steps:
(1) assert copyright on the software, and (2) offer you this License
giving you legal permission to copy, distribute and/or modify it.

  For the developers' and authors' protection, the GPL clearly explains
that there is no warranty for this free software.  For both users' and
authors' sake, the GPL requires that modified versions be marked as
changed, so that their problems will not be attributed erroneously to
authors of previous versions.

  Some devices are designed to deny users access to install or run
modified versions of the software inside them, although the manufacturer
can do so.  This is fundamentally incompatible with the aim of
protecting users' freedom to change the software.  The systematic
pattern of such abuse occurs in the area of products for individuals to
use, which is precisely where it is most unacceptable.  Therefore, we
have designed this version of the GPL to prohibit the practice for those
products.  If such problems arise substantially in other domains, we
stand ready to extend this provision to those domains in future versions
of the GPL, as needed to protect the freedom of users.

  Finally, every program is threatened constantly by software patents.
States should not allow patents to restrict development and use of
software on general-purpose computers, but in those that do, we wish to
avoid the special danger that patents applied to a free program could
make it effectively proprietary.  To prevent this, the GPL assures that
patents cannot be used to render the program non-free.

  The precise terms and conditions for copying, distribution and
modification follow.

                       TERMS AND CONDITIONS

  0. Definitions.

  "This License" refers to version 3 of the GNU General Public License.

  "Copyright" also means copyright-like laws that apply to other kinds of
works, such as semiconductor masks.

  "The Program" refers to any copyrightable work licensed under this
License.  Each licensee is addressed as "you".  "Licensees" and
"recipients" may be individuals or organizations.

  To "modify" a work means to copy from or adapt all or part of the work
in a fashion requiring copyright permission, other than the making of an
exact copy.  The resulting work is called a "modified version" of the
earlier work or a work "based on" the earlier work.

  A "covered work" means either the unmodified Program or a work based
on the Program.

  To "propagate" a work means to do anything with it that, without
permission, would make you directly or secondarily liable for
infringement under applicable copyright law, except executing it on a
computer or modifying a private copy.  Propagation includes copying,
distribution (with or without modification), making available to the
public, and in some countries other activities as well.

  To "convey" a work means any kind of propagation that enables other
parties to make or receive copies.  Mere interaction with a user through
a computer network, with no transfer of a copy, is not conveying.

  An interactive user interface displays "Appropriate Legal Notices"
to the extent that it includes a convenient and prominently visible
feature that (1) displays an appropriate copyright notice, and (2)
tells the user that there is no warranty for the work (except to the
extent that warranties are provided), that licensees may convey the
work under this License, and how to view a copy of this License.  If
the interface presents a list of user commands or options, such as a
menu, a prominent item in the list meets this criterion.

  1. Source Code.

  The "source code" for a work means the preferred form of the work
for making modifications to it.  "Object code" means any non-source
form of a work.

  A "Standard Interface" means an interface that either is an official
standard defined by a recognized standards body, or, in the case of
interfaces specified for a particular programming language, one that
is widely used among developers working in that language.

  The "System Libraries" of an executable work include anything, other
than the work as a whole, that (a) is included in the normal form of
packaging a Major Component, but which is not part of that Major
Component, and (b) serves only to enable use of the work with that
Major Component, or to implement a Standard Interface for which an
implementation is available to the public in source code form.  A
"Major Component", in this context, means a major essential component
(kernel, window system, and so on) of the specific operating system
(if any) on which the executable work runs, or a compiler used to
produce the work, or an object code interpreter used to run it.

  The "Corresponding Source" for a work in object code form means all
the source code needed to generate, install, and (for an executable
work) run the object code and to modify the work, including scripts to
control those activities.  However, it does not include the work's
System Libraries, or general-purpose tools or generally available free
programs which are used unmodified in performing those activities but
which are not part of the work.  For example, Corresponding Source
includes interface definition files associated with source files for
the work, and the source code for shared libraries and dynamically
linked subprograms that the work is specifically designed to require,
such as by intimate data communication or control flow between those
subprograms and other parts of the work.

  The Corresponding Source need not include anything that users
can regenerate automatically from other parts of the Corresponding
Source.

  The Corresponding Source for a work in source code form is that
same work.

  2. Basic Permissions.

  All rights granted under this License are granted for the term of
copyright on the Program, and are irrevocable provided the stated
conditions are met.  This License explicitly affirms your unlimited
permission to run the unmodified Program.  The output from running a
covered work is covered by this License only if the output, given its
content, constitutes a covered work.  This License acknowledges your
rights of fair use or other equivalent, as provided by copyright law.

  You may make, run and propagate covered works that you do not
convey, without conditions so long as your license otherwise remains
in force.  You may convey covered works to others for the sole purpose
of having them make modifications exclusively for you, or provide you
with facilities for running those works, provided that you comply with
the terms of this License in conveying all material for which you do
not control copyright.  Those thus making or running the covered works
for you must do so exclusively on your behalf, under your direction
and control, on terms that prohibit them from making any copies of
your copyrighted material outside their relationship with you.

  Conveying under any other circumstances is permitted solely under
the conditions stated below.  Sublicensing is not allowed; section 10
makes it unnecessary.

  3. Protecting Users' Legal Rights From Anti-Circumvention Law.

  No covered work shall be deemed part of an effective technological
measure under any applicable law fulfilling obligations under article
11 of the WIPO copyright treaty adopted on 20 December 1996, or
similar laws prohibiting or restricting circumvention of such
measures.

  When you convey a covered work, you waive any legal power to forbid
circumvention of technological measures to the extent such circumvention
is effected by exercising rights under this License with respect to
the covered work, and you disclaim any intention to limit operation or
modification of the work as a means of enforcing, against the work's
users, your or third parties' legal rights to forbid circumvention of
technological measures.

  4. Conveying Verbatim Copies.

  You may convey verbatim copies of the Program's source code as you
receive it, in any medium, provided that you conspicuously and
appropriately publish on each copy an appropriate copyright notice;
keep intact all notices stating that this License and any
non-permissive terms added in accord with section 7 apply to the code;
keep intact all notices of the absence of any warranty; and give all
recipients a copy of this License along with the Program.

  You may charge any price or no price for each copy that you convey,
and you may offer support or warranty protection for a fee.

  5. Conveying Modified Source Versions.

  You may convey a work based on the Program, or the modifications to
produce it from the Program, in the form of source code under the
terms of section 4, provided that you also meet all of these conditions:

    a) The work must carry prominent notices stating that you modified
    it, and giving a relevant date.

    b) The work must carry prominent notices stating that it is
    released under this License and any conditions added under section
    7.  This requirement modifies the requirement in section 4 to
    "keep intact all notices".

    c) You must license the entire work, as a whole, under this
    License to anyone who comes into possession of a copy.  This
    License will therefore apply, along with any applicable section 7
    additional terms, to the whole of the work, and all its parts,
    regardless of how they are packaged.  This License gives no
    permission to license the work in any other way, but it does not
    invalidate such permission if you have separately received it.

    d) If the work has interactive user interfaces, each must display
    Appropriate Legal Notices; however, if the Program has interactive
    interfaces that do not display Appropriate Legal Notices, your
    work need not make them do so.

  A compilation of a covered work with other separate and independent
works, which are not by their nature extensions of the covered work,
and which are not combined with it such as to form a larger program,
in or on a volume of a storage or distribution medium, is called an
"aggregate" if the compilation and its resulting copyright are not
used to limit the access or legal rights of the compilation's users
beyond what the individual works permit.  Inclusion of a covered work
in an aggregate does not cause this License to apply to the other
parts of the aggregate.

  6. Conveying Non-Source Forms.

  You may convey a covered work in object code form under the terms
of sections 4 and 5, provided that you also convey the
machine-readable Corresponding Source under the terms of this License,
in one of these ways:

    a) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by the
    Corresponding Source fixed on a durable physical medium
    customarily used for software interchange.

    b) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by a
    written offer, valid for at least three years and valid for as
    long as you offer spare parts or customer support for that product
    model, to give anyone who possesses the object code either (1) a
    copy of the Corresponding Source for all the software in the
    product that is covered by this License, on a durable physical
    medium customarily used for software interchange, for a price no
    more than your reasonable cost of physically performing this
    conveying of source, or (2) access to copy the
    Corresponding Source from a network server at no charge.

    c) Convey individual copies of the object code with a copy of the
    written offer to provide the Corresponding Source.  This
    alternative is allowed only occasionally and noncommercially, and
    only if you received the object code with such an offer, in accord
    with subsection 6b.

    d) Convey the object code by offering access from a designated
    place (gratis or for a charge), and offer equivalent access to the
    Corresponding Source in the same way through the same place at no
    further charge.  You need not require recipients to copy the
    Corresponding Source along with the object code.  If the place to
    copy the object code is a network server, the Corresponding Source
    may be on a different server (operated by you or a third party)
    that supports equivalent copying facilities, provided you maintain
    clear directions next to the object code saying where to find the
    Corresponding Source.  Regardless of what server hosts the
    Corresponding Source, you remain obligated to ensure that it is
    available for as long as needed to satisfy these requirements.

    e) Convey the object code using peer-to-peer transmission, provided
    you inform other peers where the object code and Corresponding
    Source of the work are being offered to the general public at no
    charge under subsection 6d.

  A separable portion of the object code, whose source code is excluded
from the Corresponding Source as a System Library, need not be
included in conveying the object code work.

  A "User Product" is either (1) a "consumer product", which means any
tangible personal property which is normally used for personal, family,
or household purposes, or (2) anything designed or sold for incorporation
into a dwelling.  In determining whether a product is a consumer product,
doubtful cases shall be resolved in favor of coverage.  For a particular
product received by a particular user, "normally used" refers to a
typical or common use of that class of product, regardless of the status
of the particular user or of the way in which the particular user
actually uses, or expects or is expected to use, the product.  A product
is a consumer product regardless of whether the product has substantial
commercial, industrial or non-consumer uses, unless such uses represent
the only significant mode of use of the product.

  "Installation Information" for a User Product means any methods,
procedures, authorization keys, or other information required to install
and execute modified versions of a covered work in that User Product from
a modified version of its Corresponding Source.  The information must
suffice to ensure that the continued functioning of the modified object
code is in no case prevented or interfered with solely because
modification has been made.

  If you convey an object code work under this section in, or with, or
specifically for use in, a User Product, and the conveying occurs as
part of a transaction in which the right of possession and use of the
User Product is transferred to the recipient in perpetuity or for a
fixed term (regardless of how the transaction is characterized), the
Corresponding Source conveyed under this section must be accompanied
by the Installation Information.  But this requirement does not apply
if neither you nor any third party retains the ability to install
modified object code on the User Product (for example, the work has
been installed in ROM).

  The requirement to provide Installation Information does not include a
requirement to continue to provide support service, warranty, or updates
for a work that has been modified or installed by the recipient, or for
the User Product in which it has been modified or installed.  Access to a
network may be denied when the modification itself materially and
adversely affects the operation of the network or violates the rules and
protocols for communication across the network.

  Corresponding Source conveyed, and Installation Information provided,
in accord with this section must be in a format that is publicly
documented (and with an implementation available to the public in
source code form), and must require no special password or key for
unpacking, reading or copying.

  7. Additional Terms.

  "Additional permissions" are terms that supplement the terms of this
License by making exceptions from one or more of its conditions.
Additional permissions that are applicable to the entire Program shall
be treated as though they were included in this License, to the extent
that they are valid under applicable law.  If additional permissions
apply only to part of the Program, that part may be used separately
under those permissions, but the entire Program remains governed by
this License without regard to the additional permissions.

  When you convey a copy of a covered work, you may at your option
remove any additional permissions from that copy, or from any part of
it.  (Additional permissions may be written to require their own
removal in certain cases when you modify the work.)  You may place
additional permissions on material, added by you to a covered work,
for which you have or can give appropriate copyright permission.

  Notwithstanding any other provision of this License, for material you
add to a covered work, you may (if authorized by the copyright holders of
that material) supplement the terms of this License with terms:

    a) Disclaiming warranty or limiting liability differently from the
    terms of sections 15 and 16 of this License; or

    b) Requiring preservation of specified reasonable legal notices or
    author attributions in that material or in the Appropriate Legal
    Notices displayed by works containing it; or

    c) Prohibiting misrepresentation of the origin of that material, or
    requiring that modified versions of such material be marked in
    reasonable ways as different from the original version; or

    d) Limiting the use for publicity purposes of names of licensors or
    authors of the material; or

    e) Declining to grant rights under trademark law for use of some
    trade names, trademarks, or service marks; or

    f) Requiring indemnification of licensors and authors of that
    material by anyone who conveys the material (or modified versions of
    it) with contractual assumptions of liability to the recipient, for
    any liability that these contractual assumptions directly impose on
    those licensors and authors.

  All other non-permissive additional terms are considered "further
restrictions" within the meaning of section 10.  If the Program as you
received it, or any part of it, contains a notice stating that it is
governed by this License along with a term that is a further
restriction, you may remove that term.  If a license document contains
a further restriction but permits relicensing or conveying under this
License, you may add to a covered work material governed by the terms
of that license document, provided that the further restriction does
not survive such relicensing or conveying.

  If you add terms to a covered work in accord with this section, you
must place, in the relevant source files, a statement of the
additional terms that apply to those files, or a notice indicating
where to find the applicable terms.

  Additional terms, permissive or non-permissive, may be stated in the
form of a separately written license, or stated as exceptions;
the above requirements apply either way.

  8. Termination.

  You may not propagate or modify a covered work except as expressly
provided under this License.  Any attempt otherwise to propagate or
modify it is void, and will automatically terminate your rights under
this License (including any patent licenses granted under the third
paragraph of section 11).

  However, if you cease all violation of this License, then your
license from a particular copyright holder is reinstated (a)
provisionally, unless and until the copyright holder explicitly and
finally terminates your license, and (b) permanently, if the copyright
holder fails to notify you of the violation by some reasonable means
prior to 60 days after the cessation.

  Moreover, your license from a particular copyright holder is
reinstated permanently if the copyright holder notifies you of the
violation by some reasonable means, this is the first time you have
received notice of violation of this License (for any work) from that
copyright holder, and you cure the violation prior to 30 days after
your receipt of the notice.

  Termination of your rights under this section does not terminate the
licenses of parties who have received copies or rights from you under
this License.  If your rights have been terminated and not permanently
reinstated, you do not qualify to receive new licenses for the same
material under section 10.

  9. Acceptance Not Required for Having Copies.

  You are not required to accept this License in order to receive or
run a copy of the Program.  Ancillary propagation of a covered work
occurring solely as a consequence of using peer-to-peer transmission
to receive a copy likewise does not require acceptance.  However,
nothing other than this License grants you permission to propagate or
modify any covered work.  These actions infringe copyright if you do
not accept this License.  Therefore, by modifying or propagating a
covered work, you indicate your acceptance of this License to do so.

  10. Automatic Licensing of Downstream Recipients.

  Each time you convey a covered work, the recipient automatically
receives a license from the original licensors, to run, modify and
propagate that work, subject to this License.  You are not responsible
for enforcing compliance by third parties with this License.

  An "entity transaction" is a transaction transferring control of an
organization, or substantially all assets of one, or subdividing an
organization, or merging organizations.  If propagation of a covered
work results from an entity transaction, each party to that
transaction who receives a copy of the work also receives whatever
licenses to the work the party's predecessor in interest had or could
give under the previous paragraph, plus a right to possession of the
Corresponding Source of the work from the predecessor in interest, if
the predecessor has it or can get it with reasonable efforts.

  You may not impose any further restrictions on the exercise of the
rights granted or affirmed under this License.  For example, you may
not impose a license fee, royalty, or other charge for exercise of
rights granted under this License, and you may not initiate litigation
(including a cross-claim or counterclaim in a lawsuit) alleging that
any patent claim is infringed by making, using, selling, offering for
sale, or importing the Program or any portion of it.

  11. Patents.

  A "contributor" is a copyright holder who authorizes use under this
License of the Program or a work on which the Program is based.  The
work thus licensed is called the contributor's "contributor version".

  A contributor's "essential patent claims" are all patent claims
owned or controlled by the contributor, whether already acquired or
hereafter acquired, that would be infringed by some manner, permitted
by this License, of making, using, or selling its contributor version,
but do not include claims that would be infringed only as a
consequence of further modification of the contributor version.  For
purposes of this definition, "control" includes the right to grant
patent sublicenses in a manner consistent with the requirements of
this License.

  Each contributor grants you a non-exclusive, worldwide, royalty-free
patent license under the contributor's essential patent claims, to
make, use, sell, offer for sale, import and otherwise run, modify and
propagate the contents of its contributor version.

  In the following three paragraphs, a "patent license" is any express
agreement or commitment, however denominated, not to enforce a patent
(such as an express permission to practice a patent or covenant not to
sue for patent infringement).  To "grant" such a patent license to a
party means to make such an agreement or commitment not to enforce a
patent against the party.

  If you convey a covered work, knowingly relying on a patent license,
and the Corresponding Source of the work is not available for anyone
to copy, free of charge and under the terms of this License, through a
publicly available network server or other readily accessible means,
then you must either (1) cause the Corresponding Source to be so
available, or (2) arrange to deprive yourself of the benefit of the
patent license for this particular work, or (3) arrange, in a manner
consistent with the requirements of this License, to extend the patent
license to downstream recipients.  "Knowingly relying" means you have
actual knowledge that, but for the patent license, your conveying the
covered work in a country, or your recipient's use of the covered work
in a country, would infringe one or more identifiable patents in that
country that you have reason to believe are valid.

  If, pursuant to or in connection with a single transaction or
arrangement, you convey, or propagate by procuring conveyance of, a
covered work, and grant a patent license to some of the parties
receiving the covered work authorizing them to use, propagate, modify
or convey a specific copy of the covered work, then the patent license
you grant is automatically extended to all recipients of the covered
work and works based on it.

  A patent license is "discriminatory" if it does not include within
the scope of its coverage, prohibits the exercise of, or is
conditioned on the non-exercise of one or more of the rights that are
specifically granted under this License.  You may not convey a covered
work if you are a party to an arrangement with a third party that is
in the business of distributing software, under which you make payment
to the third party based on the extent of your activity of conveying
the work, and under which the third party grants, to any of the
parties who would receive the covered work from you, a discriminatory
patent license (a) in connection with copies of the covered work
conveyed by you (or copies made from those copies), or (b) primarily
for and in connection with specific products or compilations that
contain the covered work, unless you entered into that arrangement,
or that patent license was granted, prior to 28 March 2007.

  Nothing in this License shall be construed as excluding or limiting
any implied license or other defenses to infringement that may
otherwise be available to you under applicable patent law.

  12. No Surrender of Others' Freedom.

  If conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot convey a
covered work so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you may
not convey it at all.  For example, if you agree to terms that obligate you
to collect a royalty for further conveying from those to whom you convey
the Program, the only way you could satisfy both those terms and this
License would be to refrain entirely from conveying the Program.

  13. Use with the GNU Affero General Public License.

  Notwithstanding any other provision of this License, you have
permission to link or combine any covered work with a work licensed
under version 3 of the GNU Affero General Public License into a single
combined work, and to convey the resulting work.  The terms of this
License will continue to apply to the part which is the covered work,
but the special requirements of the GNU Affero General Public License,
section 13, concerning interaction through a network will apply to the
combination as such.

  14. Revised Versions of this License.

  The Free Software Foundation may publish revised and/or new versions of
the GNU General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

  Each version is given a distinguishing version number.  If the
Program specifies that a certain numbered version of the GNU General
Public License "or any later version" applies to it, you have the
option of following the terms and conditions either of that numbered
version or of any later version published by the Free Software
Foundation.  If the Program does not specify a version number of the
GNU General Public License, you may choose any version ever published
by the Free Software Foundation.

  If the Program specifies that a proxy can decide which future
versions of the GNU General Public License can be used, that proxy's
public statement of acceptance of a version permanently authorizes you
to choose that version for the Program.

  Later license versions may give you additional or different
permissions.  However, no additional obligations are imposed on any
author or copyright holder as a result of your choosing to follow a
later version.

  15. Disclaimer of Warranty.

  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

  16. Limitation of Liability.

  IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

  17. Interpretation of Sections 15 and 16.

  If the disclaimer of warranty and limitation of liability provided
above cannot be given local legal effect according to their terms,
reviewing courts shall apply local law that most closely approximates
an absolute waiver of all civil liability in connection with the
Program, unless a warranty or assumption of liability accompanies a
copy of the Program in return for a fee.

                     END OF TERMS AND CONDITIONS

            How to Apply These Terms to Your New Programs

  If you develop a new program, and you want it to be of the greatest
possible use to the public, the best way to achieve this is to make it
free software which everyone can redistribute and change under these terms.

  To do so, attach the following notices to the program.  It is safest
to attach them to the start of each source file to most effectively
state the exclusion of warranty; and each file should have at least
the "copyright" line and a pointer to where the full notice is found.

    Phoenix Kernel
    Copyright (C) 2026  JackMacWindows

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

Also add information on how to contact you by electronic and paper mail.

  If the program does terminal interaction, make it output a short
notice like this when it starts in an interactive mode:

    Phoenix Kernel  Copyright (C) 2026  JackMacWindows
    This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
    This is free software, and you are welcome to redistribute it
    under certain conditions; type `show c' for details.

The hypothetical commands `show w' and `show c' should show the appropriate
parts of the General Public License.  Of course, your program's commands
might be different; for a GUI interface, you would use an "about box".

  You should also get your employer (if you work as a programmer) or school,
if any, to sign a "copyright disclaimer" for the program, if necessary.
For more information on this, and how to apply and follow the GNU GPL, see
<https://www.gnu.org/licenses/>.

  The GNU General Public License does not permit incorporating your program
into proprietary programs.  If your program is a subroutine library, you
may consider it more useful to permit linking proprietary applications with
the library.  If this is what you want to do, use the GNU Lesser General
Public License instead of this License.  But first, please read
<https://www.gnu.org/licenses/why-not-lgpl.html>.

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
    file.write("if not fs.exists('" .. fs.combine(state.rootdir, "install_config.lua") .. "') then local file = fs.open('startup.lua', 'w') file.write('sleep(0) " .. (_VERSION == "Lua 5.1" and "_G._ENV = _G " or "") .. "shell.run(\"" .. fs.combine(state.rootdir, "boot/pxboot.lua") .. "\")') file.close() return shell.run('/startup.lua') else fs.delete('startup.lua') end")
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
