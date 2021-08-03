cmake_minimum_required(VERSION 3.16)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/stm32_gcc.cmake)

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
# Check and get the proper toolchain
set(DOWNLOADS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/downloads")
set(TOOLS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/tools")
option(COMPILER_VERSION_CHECK "Ensure the compiler matches the expected version" ON)
include("${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/arm-none-eabi-checks.cmake")
# Set Toolchain
set(STM32_TOOLCHAIN_PATH ${CMAKE_CURRENT_SOURCE_DIR}/tools/gcc-arm-none-eabi-latest)

project(stm32-fetch-cube C ASM)

stm32_fetch_cube(L0)

find_package(CMSIS COMPONENTS STM32L053C8 REQUIRED)

set(PROJECT_SOURCES
    main.c
)

add_executable(stm32-fetch-l0 ${PROJECT_SOURCES})
target_link_libraries(stm32-fetch-l0 CMSIS::STM32::L053C8 STM32::NoSys)
stm32_print_size_of_target(stm32-fetch-l0)
