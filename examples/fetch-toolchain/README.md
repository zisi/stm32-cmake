### Set up to fetch the proper tool-chain

In order to fetch the proper tool-chain the following parameters must be adjusted in `CMakeLists.txt`:

```cmake
# Set Toolchain triplet
set(STM32_TARGET_TRIPLET "arm-none-eabi")
# Keep version in sync with the distribution files below
set(arm_none_eabi_gcc_version "9.3.1")
set(arm_none_eabi_base_url "https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update")
# suffix and checksum
set(arm_none_eabi_win32 "win32.zip" 184b3397414485f224e7ba950989aab6)
set(arm_none_eabi_linux_amd64 "x86_64-linux.tar.bz2" 2b9eeccc33470f9d3cda26983b9d2dc6)
set(arm_none_eabi_linux_aarch64 "aarch64-linux.tar.bz2" 000b0888cbe7b171e2225b29be1c327c)
set(arm_none_eabi_gcc_macos "mac.tar.bz2" 75a171beac35453fd2f0f48b3cb239c3)
```

### Attribution
The CMake modules for fetching the tool-chain is part of [iNavFlight/inav](https://github.com/iNavFlight/inav) project.
