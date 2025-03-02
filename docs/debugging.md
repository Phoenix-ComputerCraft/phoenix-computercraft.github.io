---
layout: default
title: Debugging
parent: Documentation
---

# Debugging
Phoenix 0.0.8 adds a new debugging subsystem, allowing programs to be debugged with advanced features such as stepping, breakpoints, variable introspection, and more. The `pdb` package includes multiple options for debugging your programs in real-time.

## `pdb`: The Phoenix Debugger
`pdb` is a program included in the `pdb` package (`sudo apt install pdb`, or installed through `sudo components`), which provides a command-line interface for debugging a program. If you're familiar with the `gdb` GNU debugger, you'll feel right at home using `pdb`.

