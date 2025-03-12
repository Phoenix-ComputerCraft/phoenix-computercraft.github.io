---
layout: default
title: Demos
---

# Demos
This page lists a number of public demonstrations of the features of Phoenix in development.

## Screenshots

### APT installing packages from Ubuntu PPA
![apt ppa](demos/apt ppa.png)

### Phoenix debugger demo
![pdb](demos/pdb.png)

### CCKit2 element test
![cckit2](demos/cckit2.webp)

### YellowBox virtual machines for CraftOS
![yellowbox](demos/yellowbox.gif)

### FTP mounting over network
![ftp](demos/ftp.png)

### Installation program
![installer](demos/installer.gif)

### libcraftos running CraftOS Lua REPL
![libcraftos](demos/libcraftos.png)

### Early startmgr starting up the system
![startmgr](demos/startmgr.png)

### screenfetch on Phoenix
![screenfetch](demos/screenfetch.png)

### dpkg-lua package manager on Phoenix
![dpkg-lua](demos/dpkg-lua.png)

### pxboot boot loader
![pxboot](demos/pxboot.png)

### libsystem.graphics demo
![libsystem.graphics](demos/libsystem.graphics.png)

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
![logging](demos/logging.png)

### Internet & socket demo
![internet](demos/internet.png)

### Ping program
![ping](demos/ping.png)

### Demonstration of ANSI support
![ansi neofetch demo](demos/ansi neofetch demo.png)

### Lua REPL with multiline support
![multiline repl](demos/multiline repl.png)

### Multiple CraftOS programs ported to Phoenix
![program demo](demos/program demo.gif)

### Test of hardware API & monitor support
![monitor test](demos/monitor test.png)

### Event viewer program
![eventvwr](demos/eventvwr.gif)

### Demo of command output redirection
![ls redirection](demos/ls redirection.png)

### POSIX `cal` program
![calendar](demos/calendar.png)

## Videos

### GNU nano on Phoenix
<video width=620 height=350 controls>
<source src="demos/nano.mp4" type="video/mp4">
</video>

### Preemption demo
<video width=620 height=350 controls>
<source src="demos/preemption.mp4" type="video/mp4">
</video>
