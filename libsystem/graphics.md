---
layout: default
title: system.graphics
parent: libsystem
---

# system.graphics
The graphics module provides functions to draw primitive geometry on a locked
 terminal object.  It supports both text and graphics mode terminals.
 The state of text terminals is preserved, so using these functions doesn't
 change the cursor position or colors.


## `drawPixel(term: Terminal|GFXTerminal, x: number, y: number, color: number)`
Draws a single pixel on screen.

### Arguments
1. `term`: The terminal to draw on
2. `x`: The X coordinate to draw at
3. `y`: The Y coordinate to draw at
4. `color`: The color to draw with

### Return Values
This function does not return anything.

## `drawLine(term: Terminal|GFXTerminal, x1: number, y1: number, x2: number, y2: number, color: number)`
Draws a line between two points.

### Arguments
1. `term`: The terminal to draw on
2. `x1`: The start X coordinate to draw at
3. `y1`: The start Y coordinate to draw at
4. `x2`: The end X coordinate to draw at
5. `y2`: The end Y coordinate to draw at
6. `color`: The color to draw with

### Return Values
This function does not return anything.

## `drawBox(term: Terminal|GFXTerminal, x: number, y: number, width: number, height: number, color: number)`
Draws an outlined rectangle on screen.

### Arguments
1. `term`: The terminal to draw on
2. `x`: The upper-left X coordinate to draw at
3. `y`: The upper-left Y coordinate to draw at
4. `width`: The width of the rectangle
5. `height`: The height of the rectangle
6. `color`: The color to draw with

### Return Values
This function does not return anything.

## `drawFilledBox(term: Terminal|GFXTerminal, x: number, y: number, width: number, height: number, color: number)`
Draws a filled rectangle on screen.

### Arguments
1. `term`: The terminal to draw on
2. `x`: The upper-left X coordinate to draw at
3. `y`: The upper-left Y coordinate to draw at
4. `width`: The width of the rectangle
5. `height`: The height of the rectangle
6. `color`: The color to draw with

### Return Values
This function does not return anything.

## `drawCircle(term: Terminal|GFXTerminal, x: number, y: number, width: number, height: number, color: number[, startAngle: number = 0][, arcCircumference: number = 2*math.pi])`
Draws an outlined circle (or arc) on screen.

### Arguments
1. `term`: The terminal to draw on
2. `x`: The upper-left X coordinate to draw at
3. `y`: The upper-left Y coordinate to draw at
4. `width`: The width of the circle
5. `height`: The height of the circle
6. `color`: The color to draw with
7. `startAngle`: The angle to start from in radians (starting at the right side) (defaults to 0)
8. `arcCircumference`: The amount of the arc to draw in radians (defaults to 2*math.pi)

### Return Values
This function does not return anything.

## `drawFilledTriangle(term: Terminal|GFXTerminal, x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, color: number)`
Draws a filled triangle on screen.

### Arguments
1. `term`: The terminal to draw on
2. `x1`: The first X coordinate to draw at
3. `y1`: The first Y coordinate to draw at
4. `x2`: The second X coordinate to draw at
5. `y2`: The second Y coordinate to draw at
6. `x3`: The third X coordinate to draw at
7. `y3`: The third Y coordinate to draw at
8. `color`: The color to draw with

### Return Values
This function does not return anything.

## `drawImage(term: Terminal|GFXTerminal, x: number, y: number, image: number)`
Draws an image on screen.  The image may be either a valid graphics mode
 pixel region (using either string or table rows), or a blit table with
 {text, text color, background color} table rows (text mode only).

### Arguments
1. `term`: The terminal to draw on
2. `x`: The X coordinate to draw at
3. `y`: The Y coordinate to draw at
4. `image`: The image to draw

### Return Values
This function does not return anything.

