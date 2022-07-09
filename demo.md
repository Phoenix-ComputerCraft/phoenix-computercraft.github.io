---
layout: default
title: Demos
---

# Demos
This page lists a number of public demonstrations of the features of Phoenix in development.

## Screenshots

### libcraftos running CraftOS Lua REPL
![libcraftos](https://cdn.discordapp.com/attachments/477911902152949771/994959107545112636/unknown.png)

### Early startmgr starting up the system
![startmgr](https://cdn.discordapp.com/attachments/477911902152949771/993292084377301002/unknown.png)

### screenfetch on Phoenix
![screenfetch](https://cdn.discordapp.com/attachments/477911902152949771/993046072022810684/unknown.png)

### dpkg-lua package manager on Phoenix
![dpkg-lua](https://cdn.discordapp.com/attachments/477911902152949771/993003455486627872/unknown.png)

### pxboot boot loader
![pxboot](https://cdn.discordapp.com/attachments/477911902152949771/986714956567285880/unknown.png)

### libsystem.graphics demo
![libsystem.graphics](https://cdn.discordapp.com/attachments/477911902152949771/980861011785551922/unknown.png)

Code:
```lua
local terminal = require "system.terminal"
local graphics = require "system.graphics"

local term = terminal.opengfx()
graphics.drawFilledTriangle(term, 10, 10, 40, 10, 25, 40, terminal.colors.red)
graphics.drawFilledTriangle(term, 41, 10, 26, 40, 56, 40, terminal.colors.blue)
graphics.drawFilledTriangle(term, 80, 20, 140, 50, 100, 80, terminal.colors.green)
graphics.drawCircle(term, 50, 120, 50, 30, terminal.colors.orange)
```

### Logging module demo
![logging](https://cdn.discordapp.com/attachments/477911902152949771/973819710707757086/unknown.png)

### Internet & socket demo
![internet](https://cdn.discordapp.com/attachments/477911902152949771/973702254584553502/unknown.png)

### Ping program
![ping](https://cdn.discordapp.com/attachments/477911902152949771/966424960363008091/unknown.png)

### Demonstration of ANSI support
![ansi neofetch demo](https://cdn.discordapp.com/attachments/477911902152949771/955183610535743498/unknown.png)

### Lua REPL with multiline support
![multiline repl](https://cdn.discordapp.com/attachments/477911902152949771/914202298715111424/unknown.png)

### Multiple CraftOS programs ported to Phoenix
![program demo](https://cdn.discordapp.com/attachments/477911902152949771/953901459567677471/2021-11-14_01.13.32.gif)

### Test of hardware API & monitor support
![monitor test](https://cdn.discordapp.com/attachments/477911902152949771/950997676051279922/unknown.png)

### Event viewer program
![eventvwr](https://cdn.discordapp.com/attachments/477911902152949771/931482311134949406/2022-01-14_04.37.27.gif)

### Demo of command output redirection
![ls redirection](https://cdn.discordapp.com/attachments/477911902152949771/916236655852134420/unknown.png)

### POSIX `cal` program
![calendar](https://cdn.discordapp.com/attachments/477911902152949771/915499419590332416/unknown.png)

## Videos

### GNU nano on Phoenix
<video width=620 height=350 controls>
<source src="https://cdn.discordapp.com/attachments/477911902152949771/992756737809592430/2022-07-02_07-39-14.mp4" type="video/mp4">
</video>

### Preemption demo
<video width=620 height=350 controls>
<source src="https://cdn.discordapp.com/attachments/477911902152949771/914712682396000306/2021-11-28_21-55-10.mp4" type="video/mp4">
</video>
