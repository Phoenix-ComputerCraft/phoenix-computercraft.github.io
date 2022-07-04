---
layout: default
title: system.framebuffer
parent: libsystem
---

# system.framebuffer
The framebuffer library provides functions to make "window" and "framebuffer"
 objects.  These objects imitate a Terminal object (as returned by
 @{system.terminal.openterm}) or GFXTerminal object (as returned by
 @{system.terminal.opengfx}) that may or may not draw to a parent object.
 Windows and framebuffers may be used as parents to other windows and
 framebuffers, in addition to the root terminal object.

 A framebuffer object holds its own state, can be redrawn onto the parent
 terminal even if the parent is changed, can be removed from the parent and
 used independently, and its contents can be accessed from code. A window
 object simply changes the coordinates of writing methods, and is entirely
 dependent on the parent.

 The type of object returned by each function is dependent on the parent
 passed in. If a Terminal object is passed, a Terminal object is created; if a
 GFXTerminal object is passed, a GFXTerminal object is created. When creating
 a framebuffer with no parent, the @{empty} fields are used to specify the type.


## `window(parent: Terminal|GFXTerminal, x: number, y: number, width: number, height: number): Terminal|GFXTerminal`
Creates a new window object.

### Arguments
1. `parent`: The parent object to render to
2. `x`: The X coordinate in the parent to start at
3. `y`: The Y coordinate in the parent to start at
4. `width`: The width of the window
5. `height`: The height of the window

### Return Values
The new window object

## `framebuffer(parent: Terminal|GFXTerminal, wx: number|nil, wy: number|nil, w: number, h: number, visible: boolean?): Terminal|GFXTerminal`
Creates a new framebuffer object.

### Arguments
1. `parent`: The parent object to render to, or a member of <a href="framebuffer.html#empty">empty</a> to not use a parent
2. `wx`: The X coordinate in the parent to start at (`nil` if there's no parent)
3. `wy`: The Y coordinate in the parent to start at (`nil` if there's no parent)
4. `w`: The width of the framebuffer
5. `h`: The height of the framebuffer
6. `visible`: Whether the window should be visible upon creation (optional)

### Return Values
The new framebuffer object

## `empty`
Empty objects for use when creating framebuffers with no parents.

### Fields
- `text`: Used to create a text mode Terminal framebuffer
- `graphics`: Used to create a graphics mode GFXTerminal framebuffer

