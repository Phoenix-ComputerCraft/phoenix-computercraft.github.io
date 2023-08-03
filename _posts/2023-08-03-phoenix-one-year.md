---
layout: post
title:  "Phoenix, One Year Later"
---

# Phoenix, One Year Later
Nearly one year ago today, I released the initial public alpha version of Phoenix. Phoenix was the result of over a year of development and a lot of learning on my part, and aimed to redefine the meaning of "operating systems" in ComputerCraft. A year later, Phoenix remains the most advanced ComputerCraft operating system architecture to date, and today it becomes even more advanced, with nearly 100 new features and fixes, including 5 new packages. However, development over the past year has been much slower than I had anticipated.

## A Year of Progress...?
In [the initial announcement post](/blog/2022/08/25/announcing-public-alpha.html), I said the following:

> I plan to update the Phoenix public alpha every week or two until it reaches a decently well-working state, mainly for bugfixes and completing features that aren't complete now. After that, I may take a break to work on new features or the graphical portion of the OS.

This was only kept up for *one update*. 0.0.2 was released two weeks after 0.0.1 with important bug fixes, but it wasn't until January - four months later - that the next update was released. And after that, there were no more updates until today's release of 0.0.4.

There were a couple of factors that led to changing this release schedule:

- I realized that the amount of work that needed to be done wasn't actually enough to justify complete updates all the time. Things like the kernel were mostly done, and anything added would be on an as-needed basis. The largest gaps were in baseutils, missing most POSIX utilities and lacking many `cash` features.
- I also started to lose some motivation to keep working on those parts. Despite not being too difficult for me to do, writing each and every single baseutils command is tedious, and wasn't really feeling fun enough to me. I started Phoenix as a project for fun, to see what I could make, but spending hours and hours every day copying the POSIX standard isn't very fun.
- Right after releasing Phoenix 0.0.2, I started working on lots of new projects, the biggest one being [my programmable sound generator/synthesizer](https://mcjack123.github.io/PSG/). This took up most of my free time, so I didn't have much left to work on Phoenix.
- Finally, I had a lot of schoolwork piled on top, so my free time was already being cut short a bit.

These all led to a very slow release schedule over the past year. Now, I'm not working on this for anyone but myself, so I'm not apologizing or anything for being slow. However, I don't want to break promises, so I won't be making any more promises about scheduling - my development cycle is too chaotic for that sort of thing, and I'd rather not try to bend my life around to fit some pointless goal.

## Phoenix 0.0.4
With today's post comes a brand new release of Phoenix and utilities. This version packs a huge number of changes (nearly 100!), with many new packages to enhance your experience (and fill your disk drive). As with previous releases, it's recommended that you reinstall the OS to ensure that no old parts are left behind. However, you can also upgrade the system at your own risk - but due to a bug in the previous version, this is not as simple as a single `sudo update` like last time.

- **You will need to run `sudo curl -R https://phoenix.madefor.cc/hotfixes/0.0.3-process-run.lua` to update the system.** This will run the updater once it finishes.
- `/etc/fstab` has been updated since the last version - replace it (`Y`) if you haven't made any changes that you want to keep.
- `/boot/config.lua` was also updated - do **not** replace it (`N`) when prompted.
- Package startmgr may fail to install the first time due to some rearranged files - if it fails, run `sudo update` again, and it should succeed afterward.

Here are the most notable features in this release:

### Spanning filesystems
The headlining feature of Phoenix 0.0.4, and possibly a killer feature of Phoenix as a whole, is the new `spanfs` package and filesystem type. Span filesystems combine multiple disks into one virtual drive that you can write files to, and the files will be split across the disks to fill the space. Spans are also called "JBOD"s, or "just a bunch of disks". Often times, this is mislabeled as a "RAID" setup - while there are RAID configurations that can combine storage space, they usually have some redundancy, or require the same size disk.

In practice, this means that you can have disks that store more than the limit for disk sizes in CC. For instance, you can combine 8 computers in disk drives to get a total disk size of 8 MB (7 if the running computer isn't used for the index). This is of great importance for an operating system that is getting ever closer to requiring more than one computer's worth of space. Spans make it possible for you to install the full set of packages (over 1.5 MB) on a single computer.

The `spanfs` package includes all the modules and tools required to set up and use span filesystems. In addition, the installer now prompts to set up a span for the root filesystem, which is required to install more than 1 MB of packages on a default computer.

### initrd images + tablefs booting
Phoenix 0.0.4 includes enhanced support for booting from tablefs-formatted image files. In particular, a new `initrd` kernel argument allows loading an image file as the initial root filesystem. This image can then execute whatever tasks are required to mount and boot the real root filesystem. This is necessary for `spanfs`-booted systems, as the `spanfs` module isn't included in the default kernel.

The `initrd-utils` package includes a number of tools to set up an initrd image from the current system, using hook programs to add required files into the image. This package is automatically installed on `spanfs`-root systems, and is used to create the initrd to boot the span.

If you've been on the home page within the last month or so, you may have noticed that there's now a new "Try" section with the ability to run Phoenix completely in memory. This uses the initrd functionality to boot a full kernel and install image from the internet, allowing you to use a full Phoenix install without having to modify your current system.

### New command line reading
libsystem 0.1.3 now includes a new function with an enhanced routine to read text from the console. This function supports both history and completion, which are two features that users (and I) have been requesting for a long time. The new reader function is implemented into both `cash` and `lua`, with cash supporting both history and program/file completion, while lua only supports history. cash history is also already saved on disk, so previous commands should already be available in the history.

### Manual pages
baseutils 0.2 includes a new `man` program, which displays Markdown-formatted manual pages from `/usr/share/man`. While non-system packages will include their own manual pages in the package, system packages like the kernel and libsystem are kept in a separate `phoenix-docs` package to save space on minimal installs. However, at the moment, documentation is slightly lacking for many parts of the system, but I hope to have that smoothened out in due time.

### And much more
There's plenty of additional little changes scattered across the system, including lots of new baseutils utilities, a port of migeyel's CCryptoLib encryption library, a disk automounter service, and more. Check out the [changelog](/docs/changelog.html) for a full list of changes.

## Future Plans, Take 2
As I alluded to earlier in the post, the future of Phoenix is not clearly set. I've always led myself through this project with no expectation of timing to avoid "crunch time" or any sort of stress that would make me not enjoy working on it. Phoenix is my passion project, and I don't want to have any strict timetables or deadlines to meet that would make it feel more like a job.

However, I understand that seeing a project with little to no updates for over half a year can make you think that it's dead. I'm hoping to publish updates a little more regularly in the future - I've had changes ready to push since April, but I never ended up committing to a new version until now. Instead, I want to continue pushing smaller but regular updates, no matter how little there is to show for it.

Even though I want to avoid making any promises, I will make one large promise about release scheduling: **If I don't release an update to Phoenix for a year, I will make the OS fully free and open-source.** In the unfortunate event that I do end up having to abandon the project, I will release all of the source components to the public. I don't want to leave my code locked behind a private repository or restrictive license forever, so I will guarantee that the code **will** eventually go public.

As for where I go from here: I think I'm about satisfied with the state of the core system, so development will now be moving towards the GUI portion with CCKit2. This part is going to be very time consuming to start, so there may not be larger updates for quite a while. Alongside that, I'll probably implement some more POSIX utilities in baseutils, and start working on APT, as well as a few more manager programs, and maybe a new filesystem or two. I'll also be implementing fixes to bugs as they appear, and hopefully not waiting six months to push them to users.

Regardless of scheduling concerns, I'm proud of the state of Phoenix so far, and I'm happy with what progress I have made. It's been really cool to watch this project evolve from a tiny experiment on preemptive multitasking into a full POSIX-like operating system, and I can't wait to see my full vision come into fruition.
