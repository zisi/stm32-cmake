cmake_minimum_required(VERSION 3.16)

set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/stm32_gcc.cmake)

project(stm32-linker-error C ASM)
set(CMAKE_INCLUDE_CURRENT_DIR TRUE)

# Get cubeMX HAL
stm32_fetch_cube(H7)

find_package(CMSIS 1.9.0 COMPONENTS STM32H743VI_M7 REQUIRED)
find_package(HAL 1.9.0 EXACT COMPONENTS STM32H743VI_M7 REQUIRED)

add_library(base_hal INTERFACE)
target_link_libraries(base_hal INTERFACE
    HAL::STM32::H7::M7::CORTEX
    CMSIS::STM32::H743xx::M7
    STM32::NoSys
)

add_executable(stm32-linker-error
    main.c
    stm32h7xx_hal_conf.h
    system_stm32h7xx.c
    startup_stm32h743vitx.s
)
target_link_libraries(stm32-linker-error
    base_hal
    HAL::STM32::H7::M7::GPIO
    HAL::STM32::H7::M7::RCC
    HAL::STM32::H7::M7::RCCEx
    HAL::STM32::H7::M7::PWR
    HAL::STM32::H7::M7::SPI
)
stm32_add_linker_script(stm32-linker-error PRIVATE STM32H743VITX_FLASH.ld)
stm32_print_size_of_target(stm32-linker-error)
