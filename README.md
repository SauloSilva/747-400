# Boeing 747-400

## Major Overhaul of the Laminar Boeing 747-400

Thank you all for your support! This overhaul is now at the "experimental" version 1 stage. Still more todo but now has enough flight test hours under its belt to be a stable daily driver for your short and long haul needs.

**Is the 747 free?**

Yes! Of course! This project is an open source project, consisting of developers gathering from all over the world wanting to create a 747.

**What happened to the YesAviation 747?**

The YesAviation team now goes under another name, and is developing another 747 somewhere else. Everyone sends a big thank you to the former team, and wish them good luck in their endeavors.

**What are the differences between the default 747, and the Sparky 747?**

This 747 currently includes new FMOD sounds done by FT+Sim, new systems and FMC, three variants of engines coming soon, a new UV map for livery creators, and many more big changes in the future.
The github repository contains the latest versions, including the LCF model variant by Lee_Hyeon_Seo (with permission) with the existing improvements, check out the working his [A340 developements](https://forums.x-plane.org/index.php?/forums/topic/203381-3d-cockpit-for-a340/&)

Custom sounds from [FTSim+](https://k-akai.blogspot.com/) (with permission)

The general concept is to bring the aircraft as close to the real version as is achievable, please refer to original 747-400 material such as the widely distributed FCOM for details on how the aircraft functions.

**How did you acheive such high framerates?**

This overhaul converts all the existing 744 systems, along with all the numerous additions from XLua, which is single threaded and directly impacts X-Plane framerates, to XTLua, a fork of XLua which maintains general compatibility with XLua, but takes all the aircraft systems off the X-Plane flight simulation thread and makes full use of a modern multithreaded operating system (use Linux for the best results, but Microsoft Windows and macOS are also supported).

XTlua is described in more detail [here](https://forums.x-plane.org/index.php?/forums/topic/209883-xtlua-parallel-lua-for-complex-aircraft-systems/)

XTlua source is [here](https://github.com/mSparks43/XLua/tree/xTLua)

**How can I contribute**

The 744 project was licenced as CC-BY-NC 4 on the 1st of May 2019, anyone with any confusion as to what this means should review the [licence](https://creativecommons.org/licenses/by-nc/4.0/)

You can follow progress, make requests and generally chat about the 747 on the 747-400 channel on the Go Ahead discord server
[Discord](https://discord.gg/cStTXy5)

Feel free to join the conversation, fork this repository, and make the plane your own.

### Installation
Just extract the zip to your aircraft folder, with some caveats:

Windows users:
You need to manually install C++ support

https://www.microsoft.com/en-us/download/details.aspx?id=13523

And multithreading support

https://aka.ms/vs/16/release/vc_redist.x64.exe (aka.ms is a microsoft domain - linked from https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads)

In order to use this aircraft

### Troubleshooting

TODO

### Changelog:
TODO
See the [commit history](https://github.com/mSparks43/747-400/commits/master) for detailed changes.
