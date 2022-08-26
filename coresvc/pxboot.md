---
layout: default
title: pxboot
parent: Core Services
---

# pxboot
pxboot is a bootloader for ComputerCraft primarily designed for the [Phoenix operating system](https://phoenix.madefor.cc), but is also compatible with any other OS through UnBIOS or CraftOS.

It provides a boot selection menu with built-in UnBIOS support, with an extensible module system allowing custom filesystems and more. The configuration file is a plain Lua file, so it can also be generated on-the-fly with Lua code.

## Usage
pxboot is a CraftOS program that can be loaded from the shell, usually through a startup file. It expects to find a config file named `config.lua` in the same directory - if pxboot isn't loaded from the shell, it must be at `/pxboot/config.lua`. (On Phoenix systems, the config file is at `/boot/config.lua`.)

Once the config file is written, simply run pxboot and a boot selector will appear. Use the arrow keys to select an entry, and press enter to select. pxboot will follow the instructions in the entry, booting the OS.

If no config file is found, a limited shell is available with pxboot commands as well as CraftOS commands. This will allow navigation and manual booting.

## Configuration
A config file consists of variable definitions and menu entries. Variables are used to define the look and behavior of the boot screen. Menu entries consist of a list of commands followed by `;`, defining the steps to boot the OS as well as some other parameters.

### Variables
The following variables are available:
* `title`: The title text to display above the selector.
* `titlecolor`: The color of the title and description text.
* `backgroundcolor`: The color of the screen background.
* `textcolor`: The color of general text.
* `boxcolor`: The color of the box around the entries.
* `boxbackground`: The color of the box's background.
* `selectcolor`: The color of the selection bar.
* `selecttext`: The color of text in the selection bar.
* `background`: The path to a background image in NFP or BIMG format.
* `defaultentry`: The name of the default entry to select if no keys are pressed.
* `timeout`: The number of seconds until selecting the default entry.

Defining a variable is a simple Lua assignment. All colors are CraftOS colors from the `colors` API - to use custom RGB colors, call `term.setPaletteColor` in your config file. The colors will be reset before booting the OS.

### Entries
A menu entry is defined by writing `menuentry`, followed by the name of the entry in quotes, and then a list of commands wrapped in curly braces. A command consists of the command name, followed by space-separated string or table arguments, ending with a semicolon (or comma). The following commands are available:
* `description "text"`: A description to show for the entry.
* `kernel "path"`: The path to an UnBIOS kernel/BIOS to load.
* `chainloader "path"`: The path to a CraftOS program to load.
* `args "text" ["text"...]`: Arguments to the kernel or chainloader.
* `args {"text"[, "text"...]}`: Arguments to the kernel or chainloader (table form).
* `global "name" "value"`: Set a global variable before booting.
* `craftos`: Boots to CraftOS.
* `insmod "name" [{args}]`: Loads a module from the `modules` folder.

### Example
Here is a full example of a config file:

```lua
defaultentry = "Phoenix"
timeout = 5
backgroundcolor = colors.black
selectcolor = colors.orange

menuentry "Phoenix" {
    description "Boot Phoenix normally.";
    kernel "/root/boot/kernel.lua";
    args "root=/root splitkernpath=/boot/kernel.lua.d init=/bin/cash.lua";
}

menuentry "CraftOS" {
    description "Boot into CraftOS.";
    craftos;
}
```
