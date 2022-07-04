---
layout: default
title: system.pretty
parent: libsystem
---

# system.pretty
Provides a "pretty printer", for rendering data structures in an
aesthetically pleasing manner.

In order to display something using @{pretty}, you build up a series of
@{Doc|documents}. These behave a little bit like strings; you can concatenate
them together and then print them to the screen.

However, documents also allow you to control how they should be printed. There
are several functions (such as @{nest} and @{group}) which allow you to control
the "layout" of the document. When you come to display the document, the 'best'
(most compact) layout is used.

The structure of this module is based on [A Prettier Printer][prettier].

[prettier]: https://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf "A Prettier Printer"


