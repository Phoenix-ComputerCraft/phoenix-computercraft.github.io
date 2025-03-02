---
layout: default
title: Event system
parent: Documentation
---

# Event system
Phoenix's event system is a bit different from CraftOS's events. Like CraftOS, events are stored in a queue that are pushed to each process when they yield. However, event parameters are now stored in a key-value table instead of unpacked as multiple return values. This makes it easier for developers to quickly grab the parameters they need, and makes code more readable. An event is only sent through two values: the type of the event (a string), and a table with the parameters. For example, a timer event might return `"timer", {id = 0}`.

Since threads may yield for reasons other than waiting for events (syscalls, preemption), events are only passed when the thread yields with `event` as the first parameter. Each process has its own event queue, and all threads in a process share the event queue. Any thread may wait for an event, and multiple threads may wait at the same time. If multiple threads are waiting for an event, each thread will get the same event when one is passed.

There are a few different types of events that Phoenix may send.

## CraftOS events
These events are converted from system events that the computer sends and filtered to the right process(es). They hold the same data that the ComputerCraft events do (potentially with additional metadata added), with names for each parameter.

Here's the mappings for each event that's directly exposed to the user. Each parameter column lists the new name of the parameter that is in that position in CraftOS. If an event has a variable number of parameters, the last parameter is a table with the rest of the parameters.

| Event type         | Parameter 1 | Parameter 2 | Parameter 3 | Parameter 4 | Parameter 5 | Additional parameters |
|--------------------|-------------|-------------|-------------|-------------|-------------|-----------------------|
| `alarm`            | `id`        |             |             |             |             |                       |
| `char`             | `character` |             |             |             |             |                       |
| `computer_command` | `args`...   |             |             |             |             |                       |
| `disk` (call `hardware.listen` first) | `device` |           |             |           | |                       |
| `disk_eject` (call `hardware.listen` first) | `device`       |             |         | | |                       |
| `http_failure` => `handle_status_change` | `id` |            |             |           | | {::nomarkdown}<ul><li><code>status</code>: The new status of the handle</li></ul>{:/} |
| `http_success` => `handle_status_change` | `id` |            |             |           | | {::nomarkdown}<ul><li><code>status</code>: The new status of the handle</li></ul>{:/} |
| `key`              | `keycode`   | `isRepeat`  |             |             |             | {::nomarkdown}<ul><li><code>ctrlHeld</code>: Whether Control is held</li><li><code>altHeld</code>: Whether Alt is held</li><li><code>shiftHeld</code>: Whether Shift is held</li></ul>{:/} |
| `key_up`           | `keycode`   |             |             |             |             | {::nomarkdown}<ul><li><code>ctrlHeld</code>: Whether Control is held</li><li><code>altHeld</code>: Whether Alt is held</li><li><code>shiftHeld</code>: Whether Shift is held</li></ul>{:/} |
| `modem_message` (call `hardware.listen` first) | `device`    | `channel`   | `replyChannel` | `message` | `distance` | |
| `monitor_resize` (call `hardware.listen` first) | `device`   |             |             |             |             | |
| `mouse_click`      | `button`    | `x`         | `y`         |             |             | {::nomarkdown}<ul><li><code>buttonMask</code>: Bitmask of all buttons currently down</li><li><code>device</code>: If sent on a monitor, the device it was sent on</li></ul>{:/} |
| `mouse_drag`       | `button`    | `x`         | `y`         |             |             | {::nomarkdown}<ul><li><code>buttonMask</code>: Bitmask of all buttons currently down</li><li><code>device</code>: If sent on a monitor, the device it was sent on</li></ul>{:/} |
| `mouse_up`         | `button`    | `x`         | `y`         |             |             | {::nomarkdown}<ul><li><code>buttonMask</code>: Bitmask of all buttons currently down</li><li><code>device</code>: If sent on a monitor, the device it was sent on</li></ul>{:/} |
| `mouse_scroll`     | `direction` | `x`         | `y`         |             |             | {::nomarkdown}<ul><li><code>device</code>: If sent on a monitor, the device it was sent on</li></ul>{:/} |
| `paste`            | `text`      |             |             |             |             |                       |
| `peripheral` => `device_added` (call `hardware.listen` first) | `device`   |       | | | |                       |
| `peripheral_detach` => `device_removed` (call `hardware.listen` first)| `device` | | | | |                       |
| `redstone`         |             |             |             |             |             |                       |
| `rednet_message` => `handle_data_ready` | `id` |             |             |           | |                       |
| `speaker_audio_empty` | `device` |             |             |             |             |                       |
| `task_complete`    | `id`        | `success`   | `results`...|             |             |                       |
| `term_resize`      |             |             |             |             |             |                       |
| `timer`            | `id`        |             |             |             |             |                       |
| `turtle_inventory` |             |             |             |             |             |                       |
| `websocket_closed` => `handle_status_changed`  | `id`        |             |         | | | {::nomarkdown}<ul><li><code>status</code>: The new status of the handle</li></ul>{:/} |
| `websocket_failure` => `handle_status_changed` | `id`        |             |         | | | {::nomarkdown}<ul><li><code>status</code>: The new status of the handle</li></ul>{:/} |
| `websocket_success` => `handle_status_changed` | `id`        |             |         | | | {::nomarkdown}<ul><li><code>status</code>: The new status of the handle</li></ul>{:/} |
| `websocket_message` => `handle_data_ready`     | `id`        |             |         | | |                       |

Some events aren't directly exposed in Phoenix:
- `http_check`: The `checkurl` syscall only allows synchronous checking, so `http_check` is automatically consumed while running and not sent to the program.
- `terminate`: `terminate` events are converted to `SIGINT` signals, and are not sent as events.

Events related to networking (`http_*`, `websocket_*`, `rednet_message`) are converted to new `handle_status_changed` and `handle_data_ready` events for use with the networking system. These only send the ID of handles that changed, and the status if changed - use the handle itself to extract any additional data required. Events related to devices are only sent to processes which call the `devlisten` syscall (`hardware.listen` when using libsystem), and the `device` field replaces the side, pointing to the path or UUID of the device the event applies to.

### Key event keycodes
Unlike CraftOS, Phoenix exposes a keycode set that is public and consistent, and using hard-coded constants is not discouraged (though it is recommended to use `libsystem`'s `keys` library for ease of use & reading). Keycodes are automatically converted from CraftOS codes to Phoenix codes in the kernel - it is not necessary to attempt to load the CraftOS `keys` API from your program, and in fact those codes will not work at all.

Phoenix's keycode set uses lowercase (if applicable) ASCII codes for keys with a printable representation, and unprintable keys are organized in groups in the upper byte range. The complete keycode set is listed below, assuming US QWERTY layout.

<details>
<summary>Complete keycode table</summary>
<table>
<tr><th>Code</th><th>Key name</th><th><code>keys</code> name</th></tr>
<tr><td><code>0x08</code></td><td>Backspace</td><td><code>keys.backspace</code></td></tr>
<tr><td><code>0x09</code></td><td>Tab</td><td><code>keys.tab</code></td></tr>
<tr><td><code>0x0A</code></td><td>Enter/return</td><td><code>keys.enter</code></td></tr>
<tr><td><code>0x1B</code></td><td>Escape (reserved)</td><td>none</td></tr>
<tr><td><code>0x20</code></td><td>Space Bar</td><td><code>keys.space</code></td></tr>
<tr><td><code>0x27</code></td><td>Apostrophe/quote</td><td><code>keys.apostrophe</code></td></tr>
<tr><td><code>0x2C</code></td><td>Comma/left angle bracket</td><td><code>keys.comma</code></td></tr>
<tr><td><code>0x2D</code></td><td>Minus/underscore</td><td><code>keys.minus</code></td></tr>
<tr><td><code>0x2E</code></td><td>Period/right angle bracket</td><td><code>keys.period</code></td></tr>
<tr><td><code>0x2F</code></td><td>Slash/question mark</td><td><code>keys.slash</code></td></tr>
<tr><td><code>0x30</code></td><td>Zero/right parenthesis</td><td><code>keys.zero</code></td></tr>
<tr><td><code>0x31</code></td><td>One/exclamation mark</td><td><code>keys.one</code></td></tr>
<tr><td><code>0x32</code></td><td>Two/at symbol</td><td><code>keys.two</code></td></tr>
<tr><td><code>0x33</code></td><td>Three/hash</td><td><code>keys.three</code></td></tr>
<tr><td><code>0x34</code></td><td>Four/dollar sign</td><td><code>keys.four</code></td></tr>
<tr><td><code>0x35</code></td><td>Five/percent sign</td><td><code>keys.five</code></td></tr>
<tr><td><code>0x36</code></td><td>Six/caret</td><td><code>keys.six</code></td></tr>
<tr><td><code>0x37</code></td><td>Seven/ampersand</td><td><code>keys.seven</code></td></tr>
<tr><td><code>0x38</code></td><td>Eight/asterisk</td><td><code>keys.eight</code></td></tr>
<tr><td><code>0x39</code></td><td>Nine/left parenthesis</td><td><code>keys.nine</code></td></tr>
<tr><td><code>0x3B</code></td><td>Semicolon/colon</td><td><code>keys.semicolon</code></td></tr>
<tr><td><code>0x3D</code></td><td>Equals/plus</td><td><code>keys.equals</code></td></tr>
<tr><td><code>0x5B</code></td><td>Left bracket/left curly brace</td><td><code>keys.leftBracket</code></td></tr>
<tr><td><code>0x5C</code></td><td>Backslash/pipe</td><td><code>keys.backslash</code></td></tr>
<tr><td><code>0x5D</code></td><td>Right bracket/right curly brace</td><td><code>keys.rightBracket</code></td></tr>
<tr><td><code>0x60</code></td><td>Backtick (grave)/tilde</td><td><code>keys.grave</code></td></tr>
<tr><td><code>0x61</code></td><td>A</td><td><code>keys.a</code></td></tr>
<tr><td><code>0x62</code></td><td>B</td><td><code>keys.b</code></td></tr>
<tr><td><code>0x63</code></td><td>C</td><td><code>keys.c</code></td></tr>
<tr><td><code>0x64</code></td><td>D</td><td><code>keys.d</code></td></tr>
<tr><td><code>0x65</code></td><td>E</td><td><code>keys.e</code></td></tr>
<tr><td><code>0x66</code></td><td>F</td><td><code>keys.f</code></td></tr>
<tr><td><code>0x67</code></td><td>G</td><td><code>keys.g</code></td></tr>
<tr><td><code>0x68</code></td><td>H</td><td><code>keys.h</code></td></tr>
<tr><td><code>0x69</code></td><td>I</td><td><code>keys.i</code></td></tr>
<tr><td><code>0x6A</code></td><td>J</td><td><code>keys.j</code></td></tr>
<tr><td><code>0x6B</code></td><td>K</td><td><code>keys.k</code></td></tr>
<tr><td><code>0x6C</code></td><td>L</td><td><code>keys.l</code></td></tr>
<tr><td><code>0x6D</code></td><td>M</td><td><code>keys.m</code></td></tr>
<tr><td><code>0x6E</code></td><td>N</td><td><code>keys.n</code></td></tr>
<tr><td><code>0x6F</code></td><td>O</td><td><code>keys.o</code></td></tr>
<tr><td><code>0x70</code></td><td>P</td><td><code>keys.p</code></td></tr>
<tr><td><code>0x71</code></td><td>Q</td><td><code>keys.q</code></td></tr>
<tr><td><code>0x72</code></td><td>R</td><td><code>keys.r</code></td></tr>
<tr><td><code>0x73</code></td><td>S</td><td><code>keys.s</code></td></tr>
<tr><td><code>0x74</code></td><td>T</td><td><code>keys.t</code></td></tr>
<tr><td><code>0x75</code></td><td>U</td><td><code>keys.u</code></td></tr>
<tr><td><code>0x76</code></td><td>V</td><td><code>keys.v</code></td></tr>
<tr><td><code>0x77</code></td><td>W</td><td><code>keys.w</code></td></tr>
<tr><td><code>0x78</code></td><td>X</td><td><code>keys.x</code></td></tr>
<tr><td><code>0x79</code></td><td>Y</td><td><code>keys.y</code></td></tr>
<tr><td><code>0x7A</code></td><td>Z</td><td><code>keys.z</code></td></tr>
<tr><td><code>0x7F</code></td><td>Delete</td><td><code>keys.delete</code></td></tr>
<tr><td><code>0x80</code></td><td>Insert</td><td><code>keys.insert</code></td></tr>
<tr><td><code>0x81</code></td><td>F1</td><td><code>keys.f1</code></td></tr>
<tr><td><code>0x82</code></td><td>F2</td><td><code>keys.f2</code></td></tr>
<tr><td><code>0x83</code></td><td>F3</td><td><code>keys.f3</code></td></tr>
<tr><td><code>0x84</code></td><td>F4</td><td><code>keys.f4</code></td></tr>
<tr><td><code>0x85</code></td><td>F5</td><td><code>keys.f5</code></td></tr>
<tr><td><code>0x86</code></td><td>F6</td><td><code>keys.f6</code></td></tr>
<tr><td><code>0x87</code></td><td>F7</td><td><code>keys.f7</code></td></tr>
<tr><td><code>0x88</code></td><td>F8</td><td><code>keys.f8</code></td></tr>
<tr><td><code>0x89</code></td><td>F9</td><td><code>keys.f9</code></td></tr>
<tr><td><code>0x8A</code></td><td>F10</td><td><code>keys.f10</code></td></tr>
<tr><td><code>0x8B</code></td><td>F11</td><td><code>keys.f11</code></td></tr>
<tr><td><code>0x8C</code></td><td>F12</td><td><code>keys.f12</code></td></tr>
<tr><td><code>0x8D</code></td><td>F13</td><td><code>keys.f13</code></td></tr>
<tr><td><code>0x8E</code></td><td>F14</td><td><code>keys.f14</code></td></tr>
<tr><td><code>0x8F</code></td><td>F15</td><td><code>keys.f15</code></td></tr>
<tr><td><code>0x90</code></td><td>F16</td><td><code>keys.f16</code></td></tr>
<tr><td><code>0x91</code></td><td>F17</td><td><code>keys.f17</code></td></tr>
<tr><td><code>0x92</code></td><td>F18</td><td><code>keys.f18</code></td></tr>
<tr><td><code>0x93</code></td><td>F19</td><td><code>keys.f19</code></td></tr>
<tr><td><code>0x94</code></td><td>F20</td><td><code>keys.f20</code></td></tr>
<tr><td><code>0x95</code></td><td>F21</td><td><code>keys.f21</code></td></tr>
<tr><td><code>0x96</code></td><td>F22</td><td><code>keys.f22</code></td></tr>
<tr><td><code>0x97</code></td><td>F23</td><td><code>keys.f23</code></td></tr>
<tr><td><code>0x98</code></td><td>F24</td><td><code>keys.f24</code></td></tr>
<tr><td><code>0x99</code></td><td>F25</td><td><code>keys.f25</code></td></tr>
<tr><td><code>0x9A</code></td><td>Convert (Japanese)</td><td><code>keys.convert</code></td></tr>
<tr><td><code>0x9B</code></td><td>No Convert (Japanese)</td><td><code>keys.noconvert</code></td></tr>
<tr><td><code>0x9C</code></td><td>Kana (Japanese)</td><td><code>keys.kana</code></td></tr>
<tr><td><code>0x9D</code></td><td>Kanji (Japanese)</td><td><code>keys.kanji</code></td></tr>
<tr><td><code>0x9E</code></td><td>Yen</td><td><code>keys.yen</code></td></tr>
<tr><td><code>0x9F</code></td><td>Num Pad Decimal</td><td><code>keys.numPadDecimal</code></td></tr>
<tr><td><code>0xA0</code></td><td>Num Pad 0</td><td><code>keys.numPad0</code></td></tr>
<tr><td><code>0xA1</code></td><td>Num Pad 1</td><td><code>keys.numPad1</code></td></tr>
<tr><td><code>0xA2</code></td><td>Num Pad 2</td><td><code>keys.numPad2</code></td></tr>
<tr><td><code>0xA3</code></td><td>Num Pad 3</td><td><code>keys.numPad3</code></td></tr>
<tr><td><code>0xA4</code></td><td>Num Pad 4</td><td><code>keys.numPad4</code></td></tr>
<tr><td><code>0xA5</code></td><td>Num Pad 5</td><td><code>keys.numPad5</code></td></tr>
<tr><td><code>0xA6</code></td><td>Num Pad 6</td><td><code>keys.numPad6</code></td></tr>
<tr><td><code>0xA7</code></td><td>Num Pad 7</td><td><code>keys.numPad7</code></td></tr>
<tr><td><code>0xA8</code></td><td>Num Pad 8</td><td><code>keys.numPad8</code></td></tr>
<tr><td><code>0xA9</code></td><td>Num Pad 9</td><td><code>keys.numPad9</code></td></tr>
<tr><td><code>0xAA</code></td><td>Num Pad Add</td><td><code>keys.numPadAdd</code></td></tr>
<tr><td><code>0xAB</code></td><td>Num Pad Subtract</td><td><code>keys.numPadSubtract</code></td></tr>
<tr><td><code>0xAC</code></td><td>Num Pad Multiply</td><td><code>keys.numPadMultiply</code></td></tr>
<tr><td><code>0xAD</code></td><td>Num Pad Divide</td><td><code>keys.numPadDivide</code></td></tr>
<tr><td><code>0xAE</code></td><td>Num Pad Equals</td><td><code>keys.numPadEquals</code></td></tr>
<tr><td><code>0xAF</code></td><td>Num Pad Enter</td><td><code>keys.numPadEnter</code></td></tr>
<tr><td><code>0xB0</code></td><td>Left Control</td><td><code>keys.leftCtrl</code></td></tr>
<tr><td><code>0xB1</code></td><td>Right Control</td><td><code>keys.rightCtrl</code></td></tr>
<tr><td><code>0xB2</code></td><td>Left Alt (Option)</td><td><code>keys.leftAlt</code></td></tr>
<tr><td><code>0xB3</code></td><td>Right Alt (Option)</td><td><code>keys.rightAlt</code></td></tr>
<tr><td><code>0xB4</code></td><td>Left Shift</td><td><code>keys.leftShift</code></td></tr>
<tr><td><code>0xB5</code></td><td>Right Shift</td><td><code>keys.rightShift</code></td></tr>
<tr><td><code>0xB6</code></td><td>Left Super (Windows/Command)</td><td><code>keys.leftSuper</code></td></tr>
<tr><td><code>0xB7</code></td><td>Right Super (Windows/Command)</td><td><code>keys.rightSuper</code></td></tr>
<tr><td><code>0xB8</code></td><td>Caps Lock</td><td><code>keys.capsLock</code></td></tr>
<tr><td><code>0xB9</code></td><td>Num Lock</td><td><code>keys.numLock</code></td></tr>
<tr><td><code>0xBA</code></td><td>Scroll Lock</td><td><code>keys.scrollLock</code></td></tr>
<tr><td><code>0xBB</code></td><td>Print Screen</td><td><code>keys.printScreen</code></td></tr>
<tr><td><code>0xBC</code></td><td>Pause</td><td><code>keys.pause</code></td></tr>
<tr><td><code>0xBD</code></td><td>Menu</td><td><code>keys.menu</code></td></tr>
<tr><td><code>0xBE</code></td><td>Stop</td><td><code>keys.stop</code></td></tr>
<tr><td><code>0xBF</code></td><td>Ax</td><td><code>keys.ax</code></td></tr>
<tr><td><code>0xC0</code></td><td>Up</td><td><code>keys.up</code></td></tr>
<tr><td><code>0xC1</code></td><td>Down</td><td><code>keys.down</code></td></tr>
<tr><td><code>0xC2</code></td><td>Left</td><td><code>keys.left</code></td></tr>
<tr><td><code>0xC3</code></td><td>Right</td><td><code>keys.right</code></td></tr>
<tr><td><code>0xC4</code></td><td>Page Up</td><td><code>keys.pageUp</code></td></tr>
<tr><td><code>0xC5</code></td><td>Page Down</td><td><code>keys.pageDown</code></td></tr>
<tr><td><code>0xC6</code></td><td>Home</td><td><code>keys.home</code></td></tr>
<tr><td><code>0xC7</code></td><td>End</td><td><code>keys.end</code></td></tr>
<tr><td><code>0xC8</code></td><td>Circumflex</td><td><code>keys.circumflex</code></td></tr>
<tr><td><code>0xC9</code></td><td>At</td><td><code>keys.at</code></td></tr>
<tr><td><code>0xCA</code></td><td>Colon</td><td><code>keys.colon</code></td></tr>
<tr><td><code>0xCB</code></td><td>Underscore</td><td><code>keys.underscore</code></td></tr>
</table>
</details>

## Phoenix events
These events are generated by various parts of the kernel, and are not directly associated with any underlying CraftOS event. They are sent through `coroutine.yield()` like any other event. This list also includes events that can be triggered by both CraftOS events and Phoenix routines.

| Event type               | Description | Parameters |
|--------------------------|-------------|------------|
| `debug_break`            | Sent when a breakpoint added by this process is triggered. | {::nomarkdown}<ul><li><code>process</code>: The ID of the process that hit the breakpoint</li><li><code>thread</code>: The ID of the thread that hit the breakpoint</li><li><code>breakpoint</code>: The breakpoint that was hit (<code>nil</code> if this was triggered by the <code>debug_break</code> syscall)</li></ul>{:/} |
| `debug_exec_result`      | Sent when a function triggered by `debug_exec` finishes. | {::nomarkdown}<ul><li><code>process</code>: The ID of the process triggering this event</li><li><code>thread</code>: The ID of the thread triggering this event</li><li><code>ok</code>: Whether the function exited without error</li><li><code>error</code>: If the function errored, the error message triggered</li><li><code>n</code>: The number of return values</li><li>Array items: All return values from the function.</li></ul>{:/} |
| `device_added`           | Sent when a device is added as a child of a device with events enabled. | {::nomarkdown}<ul><li><code>device</code>: The path of the device that was added</li></ul>{:/} |
| `device_removed`         | Sent when a device's child is removed. | {::nomarkdown}<ul><li><code>device</code>: The path of the device that was removed</li></ul>{:/} |  
| `fsevent`                | Sent when a process calls `fsevent` on a path, and that path is modified. | {::nomarkdown}<ul><li><code>path</code>: The path that was modified</li><li><code>event</code>: The type of modification that was done, which is one of the options listed below</li><li><code>name</code>: If the path refers to a directory and the modification was done on an entry inside the directory, the file name that was modified</li><li><code>process</code>: The ID of the process that triggered the event</li></ul>{:/} |
| `handle_data_ready`      | Sent when a connected network handle receives more data. | {::nomarkdown}<ul><li><code>id</code>: The ID of the handle that has more data</li></ul>{:/} |
| `handle_status_change`   | Sent when the status of a network handle changes. | {::nomarkdown}<ul><li><code>id</code>: The ID of the handle that changed status</li><li><code>status</code>: The new status of the handle</li><li><code>error</code>: If the status is <code>error</code>, the error message associated with the status</li></ul>{:/} |
| `network_event`          | Sent when a control network message is received after a `netevent` call. | A copy of the control message |
| `network_request`        | Sent when a listening PSP socket receives a new connection. | {::nomarkdown}<ul><li><code>uri</code>: The URI passed to the <code>listen</code> call that received the connection</li><li><code>ip</code>: The IP of the remote client</li><li><code>handle</code>: The handle for the connection</li></ul>{:/} |
| `process_complete`       | Sent when a child process exits. | {::nomarkdown}<ul><li><code>id</code>: The ID of the process that exited</li><li><code>thread</code>: The ID of the last thread that exited</li><li><code>value</code>: If the last thread exited successfully, the value that the thread returned</li><li><code>n</code>: The number of return values from the last thread</li><li><code>error</code>: If the last thread errored, the error that it threw</li><li><code>traceback</code>: A traceback if the thread errored</li><li>Additional return values are in integer keys.</li></ul>{:/} |
| `remote_event`           | Sent when another process posts a remote event, explained below. | See below |
| `syslog`                 | Sent when a message is posted to an opened log. | A copy of the `options` table passed to the corresponding `syslog` call |
| `syslog_close`           | Sent when an opened log is removed from the system. | {::nomarkdown}<ul><li><code>id</code>: The ID of the log that was closed</li></ul>{:/} |
| `tty_event`              | Sent when a TTY created with `mktty` has its contents updated. | {::nomarkdown}<ul><li><code>id</code>: The ID of the TTY that was modified</li></ul>{:/} |

### Filesystem event types
| Event               | File? | Dir?  | Description |
|---------------------|-------|-------|-------------|
| `open`              |   x   |       | Triggered when the target file is opened in write or append mode. |
| `open_child`        |       |   x   | Triggered when the target directory has a file opened in write or append mode. |
| `remove`            |   x   |   x   | Triggered when the target file or directory is removed. |
| `remove_child`      |       |   x   | Triggered when the target directory has a child removed. |
| `rename_from`       |   x   |   x   | Triggered when the target file or directory is being renamed. |
| `rename_from_child` |       |   x   | Triggered when the target directory has a child renamed. |
| `rename_to`         |       |       | Triggered when the target path has been replaced with a renamed file or directory. |
| `rename_to_child`   |       |   x   | Triggered when the target directory has a new child from a rename. |
| `mkdir`             |       |       | Triggered when the target path now exists and is a directory. |
| `mkdir_child`       |       |   x   | Triggered when the target directory has a new child directory. |
| `link`              |       |       | Triggered when the target path now exists and is a link. |
| `link_child`        |       |   x   | Triggered when the target directory has a new child link. |
| `mkfifo`            |       |       | Triggered when the target path now exists and is a FIFO. |
| `mkfifo_child`      |       |   x   | Triggered when the target directory has a new child FIFO. |

## Signals
Signals are the most basic type of IPC in Phoenix. They do not have any metadata associated with them, and are only used to send a trigger to a process that will be executed immediately. The event type is `"signal"`, and the parameters contains a single field called `signal` with the signal sent. A signal is sent to a process through the `kill` syscall, taking the PID of the target process and the signal to send. A signal may be any number, but the system only uses the signals listed below. Signals may only be sent to processes running as the same user as the sender, unless the sender is running as root.

For most signals, they are simply sent as events to the process. However, processes can also have a function called whenever a signal is sent to the process. This will cause the signal to not be added to the event queue. Many of the built-in signals have handlers attached by default - notably, the ones that kill the process. Processes can replace or remove these handlers (or handlers for other signals) through the `signal` syscall.

In the case of `SIGABRT`, an additional parameter is added to the signal: `error`. This parameter is passed when an uncaught error occurs, and is also passed to the handler function if one is installed. This allows the process to add a global error handler to the process that can transform the error message as needed. By default, this simply calls `debug.traceback` on the message and prints it to the system log, as well as sending the message to standard error.

| ID | POSIX name | libsystem name | Built-in triggers     | Default action |
|----|------------|----------------|-----------------------|----------------|
| 1  | `SIGHUP`   | `hangup`       | Terminal disconnected | Terminate      |
| 2  | `SIGINT`   | `interrupt`    | ^C is pressed         | Terminate      |
| 3  | `SIGQUIT`  | `quit`         | ^\\ is pressed        | Terminate w/traceback |
| 6  | `SIGABRT`  | `abort`        | Uncaught error occurs | Terminate w/traceback |
| 9  | `SIGKILL`  | `kill`         |                       | Kill (cannot be overridden) |
| 10 | `SIGUSR1`  | `user1`        |                       | Ignore         |
| 12 | `SIGUSR2`  | `user2`        |                       | Ignore         |
| 13 | `SIGPIPE`  | `pipe`         | Pipe breaks           | Terminate      |
| 15 | `SIGTERM`  | `terminate`    |                       | Terminate      |
| 18 | `SIGCONT`  | `continue`     | Process continued     | Ignore         |
| 19 | `SIGSTOP`  | `stop`         | ^Z is pressed         | Stop           |
| 21 | `SIGTTIN`  | `bg_input`     | Input from background | Stop           |
| 22 | `SIGTTOU`  | `bg_output`    | Output from background| Stop           |

## Remote events
Remote events are the primary method of IPC in Phoenix. A remote event is sent with the type `"remote_event"`, and can be sent from any process to any process. A remote event may contain any data as the payload, as well as an independent type. The parameter table contains the following fields:
* `sender`: The PID of the process that sent the event.
* `type`: The type of event as reported by the sender.
* `data`: The parameter sent to the process.


