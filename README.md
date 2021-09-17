# Lite XL - Simplified

A lightweight text editor written in Lua, adapted from [lite-xl]. Makes it easier to build
on different platforms if you're having trouble with meson.

Will always be rebased off upstream [lite-xl]; will never deviate far.

Quickstart:

`git clone git@github.com:adamharrison/lite-xl-simplified.git --shallow-submodules --recurse-submodules && `.

## Supporting Libraries

The 4 supporting libraries of lite are now git submodules. These **must** be pulled in with: 
`git submodule update --remote --init --depth=1` after cloning the repository, or by the above clone command.

SDL2 should be installed as normal on Mac and Linux, or under msys. (You can use your
package manager). Alternatively, you can supply your system libraries on the command line
like so, to build from your system:

./build.sh `pkg-config lua5.4 freetype2 libpcre2-8 --cflags` `pkg-config lua5.4 freetype2 libpcre2-8 --libs`

## Building

**On Windows, if building using cmd.exe**, you should place `SDLmain.lib`, `SDL.lib`,
`SDL.dll` into the main folder project directory, before running a build. You can retrieve
these [here](https://www.libsdl.org/release/SDL2-devel-2.0.16-VC.zip). They're located under
lib/x64.

**To build**, simply run `build.sh`; this should function on Mac, Linux and MSYS command line.
**If you're running on windows on the command line; you should use `build.cmd`.**

If you desperately want better build times, you can speed up builds by specifying a `ccache`
CC variable (e.g. `CC='ccache gcc' ./build.sh`). After the first build, these builds should
be quite quick (on my machine, building from scratch moves from 1 second to about .1 seconds).

## Cross Compiling

### Linux to Windows

From Linux, to compile a windows executable, all you need to do is:

`CC=i686-w64-mingw32-gcc AR=i686-w64-mingw32-gcc-ar SDL_CONFIG=/usr/local/cross-tools/i686-w64-mingw32/bin/sdl2-config ./build.sh`

As long as you've compiled SDL with your mingw compiler (`sudo apt-get install mingw-w64`). You can compile SDL by going to the
`lib/SDL` folder, and running:

`CC=i686-w64-mingw32-gcc ./configure --host=i686-w64-mingw32 && make && sudo make install`

### Linux to MacOS

From linux, to compile a mac executable, you can use (OSXCross)[https://github.com/tpoechtrager/osxcross].

`CC=o32-clang AR=o32-llvm-ar SDL_CONFIG=/usr/local/cross-tools/i386-apple-darwinXX/bin/sdl2-config ./build.sh`

You can compile SDL by going to the `lib/SDL` folder and running:

`CC=o32-clang ./configure --host=i386-apple-darwinXX && make && sudo make install`

### Linux to Webassembly

To compile to webassembly, install emscripten, and simply go to the main folder, and 

`SDL_CONFIG="$EMSDK/upstream/emscripten/system/bin/sdl2-config" AR=emar CC=emcc ./build.sh -o index.html -s ASYNCIFY -s USE_SDL=2 --preload-file data -s INITIAL_MEMORY=134217728 --shell-file resources/lite-xl.html`

### Linux to Android

To compile to Android, see [here](https://developer.android.com/ndk/guides/other_build_systems). Call `sudo apt-get install android-tools-adb android-tools-fastboot`.
Notably, download the [NDK](https://developer.android.com/ndk/downloads), find the ISA of the device you want to target. My phone is `ARMv7`, which is a 32-bit ARM architecture. 
So, I'd set `$NDK` to the folder where the NDK was extracted and do the following:

```
AR=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-ar CC=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi31-clang ./build.sh
```
  

You can compile SDL by going to the `lib/SDL` folder and running:

```
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
export TARGET=armv7a-linux-androideabi
export API=31
export AR=$TOOLCHAIN/bin/llvm-ar
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export AS=$CC
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip
./configure --host=$TARGET && make && sudo make install
```



## Licenses

This project is free software; you can redistribute it and/or modify it under
the terms of the MIT license. Dependencies are licensed under various open
source licenses.  See [LICENSE] for details.

[lite-xl]:                    https://github.com/lite-xl/lite-xl
[LICENSE]:                    LICENSE
