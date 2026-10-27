# Transformers: The Game (PSP) - PC Port

A work-in-progress recomp of the PSP version of *Transformers: The Game* (2007),
with the goal of a native PC executable that supports real-time editing.

> **Status:** early research. The build pipeline works, but the game is not playable yet.

## Legal

This repository contains **no game code, assets, or executables**. You must supply
your own legally obtained copy of the game. This project is for educational, research,
and preservation purposes. *Transformers* is a trademark of Hasbro; the game is
© Activision. This project is not affiliated with either company.

## Supported version

| Field     | Value                                      |
|-----------|--------------------------------------------|
| Disc ID   | ULUS-10274 (USA)                           |
| Version   | 1.02                                       |
| BOOT.BIN  | SHA-1 `483eee94516b0c29823805c88438ad87dd9e56ef` |

Other regions and versions will be rejected by the builder.

## Building (Windows)

1. Install [Visual Studio](https://visualstudio.microsoft.com/) (Community is free) or the
   Build Tools, with the **Desktop development with C++** workload. This includes CMake.
2. Optional: a standalone [CMake](https://cmake.org/download/) on your PATH also works.
3. Download this repository (green **Code** button, then **Download ZIP**) and unzip it.
4. Double-click `build.bat` and select your ISO, or drag your ISO onto `build.bat`.
5. The executable appears in the `bin` folder.

## How it works

`build.bat` mounts your ISO, checks it is the supported version, copies the game files
into `game_data\`, then compiles the source in `src\` into `bin\TransformersPC.exe`.

## Contributing

Never commit files from the game. The `.gitignore` blocks the common ones, but check
`git status` before every commit.
