---
layout: default
title: Speaker
parent: Drivers
---

# `speaker`
This type represents a speaker peripheral. See [the CC:T docs](https://tweaked.cc/peripheral/speaker.html) for more information on the methods.

## Drivers that use this type
* `peripheral_speaker`: Implements for networked speakers.

## Methods
* `playNote(instrument: string[, volume: number[, pitch: number]]): boolean`: Plays a note block note on the speaker.
* `playSound(name: string[, volume: number[, speed: number]]): boolean`: Plays a sound event on the speaker.
* `playAudio(audio: [number][, volume: number]): boolean`: Plays PCM audio on the speaker.
* `stop()`: Stop any sounds playing on the speaker.

## Events
* `speaker_audio_empty`: Sent when the `playAudio` buffer is emptied.
  * `device: string`: The path of the speaker that sent the event