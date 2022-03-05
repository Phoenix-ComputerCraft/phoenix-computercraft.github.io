---
layout: default
title: Printer
parent: Drivers
---

# `printer`
This type represents a printer peripheral.

## Drivers that use this type
* `peripheral_printer`: Implements for networked printers.

## Properties
* `inkLevel: number {get}`: Amount of ink left in the printer
* `paperLevel: number {get}`: Amount of paper left in the printer

## Methods
* `page(): Page?`: Creates a new page object to print to.
  * If a page is currently in progress and not closed yet, it's closed before making a new page

### `Page` class
```ts
declare class Page {
    size: {width: number, height: number}, // The size of the page (get)
    cursor: {x: number, y: number},        // The position of the cursor (get/set)
    title: string?,                        // The title of the page (get/set)
    write(text: any...),                   // Write text to the page
    close(): boolean                       // Close the page, finishing printing
}
```