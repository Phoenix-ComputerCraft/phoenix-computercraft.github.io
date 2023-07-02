---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
title: Home
---

# Phoenix

Welcome to the home page for the Phoenix operating system.

Phoenix is the next-generation modular operating system for ComputerCraft. It introduces a brand-new way to interact with CC, adding many services from modern systems such as preemptive multitasking, filesystem permissions, virtual device trees, and much more. Phoenix entirely replaces CraftOS, giving programs a clean slate free from the legacy APIs and odd syntaxes that plague CraftOS, while still providing the same ease of use as CraftOS's APIs. In addition, it includes a graphical user interface with support for rich applications, allowing a full desktop OS experience inside ComputerCraft.

This site is home to the following first-party components of the default Phoenix distribution:
- Phoenix kernel
- pxboot bootloader
- libsystem library
- libcraftos library
- baseutils program package
- coresvc service package
- startmgr init system
- Swift/PhoenixWM window manager

**This site is a work-in-progress.** All information listed here is *pre-release* info, and may be subject to change at any time. It may also be inaccurate with the current state of Phoenix.

## Try
You can try Phoenix right now without installing it to test its features. This will run it in a virtual system which won't save any changes to your disk. To use it, run the following command in your ComputerCraft computer:

```
wget run https://phoenix.madefor.cc/try.lua
```

The login for the live demo is `phoenix`, password `phoenix`, no caps. The computer's files are mounted in `/root` for quick access to the real filesystem.

## Install
Phoenix can be installed using the following command:

```
wget run https://phoenix.madefor.cc/install.lua
```

The installer will guide you through the steps necessary to install Phoenix, including creating the primary user and selecting components to install. Be aware that the full installation will not fit on a default computer - when using Phoenix in-game (i.e. not in an emulator), make sure to deselect optional components, or raise the computer storage limit to at least 2 MB.
