# This file is part of iNavFlight/inav project. Licensed under the GPLv3.0.

get_filename_component(STM32_CMAKE_DIR ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)
list(APPEND CMAKE_MODULE_PATH ${STM32_CMAKE_DIR})

include(gcc)

function(host_uname_machine var)
    # We need to call uname -m manually, since at the point
    # this file is included CMAKE_HOST_SYSTEM_PROCESSOR is
    # empty because we haven't called project() yet.
    execute_process(COMMAND uname -m
        OUTPUT_STRIP_TRAILING_WHITESPACE
        OUTPUT_VARIABLE machine)

    set(${var} ${machine} PARENT_SCOPE)
endfunction()

function(arm_none_eabi_gcc_install)
    set(dist "")
    if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
        set(dist ${arm_none_eabi_win32})
    elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux" OR CMAKE_HOST_SYSTEM_NAME STREQUAL "FreeBSD")
        if(NOT CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
            message("-- no compiler binaries available for ${CMAKE_HOST_SYSTEM_NAME}, using Linux binaries as a fallback")
        endif()
        host_uname_machine(machine)
        # Linux returns x86_64, FreeBSD returns amd64
        if(machine STREQUAL "x86_64" OR machine STREQUAL "amd64")
            set(dist ${arm_none_eabi_linux_amd64})
        elseif(machine STREQUAL "aarch64")
            set(dist ${arm_none_eabi_linux_aarch64})
        else()
            message("-- no precompiled ${arm_none_eabi_triplet} toolchain for machine ${machine}")
        endif()
    elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
        set(dist ${arm_none_eabi_gcc_macos})
    endif()

    if(dist STREQUAL "")
        message(FATAL_ERROR "could not install ${arm_none_eabi_triplet}-gcc automatically")
    endif()
    list(GET dist 0 dist_suffix)
    list(GET dist 1 dist_checksum)
    set(dist_url "${arm_none_eabi_base_url}-${dist_suffix}")
    string(REPLACE "/" ";" url_parts ${dist_url})
    list(LENGTH url_parts n)
    math(EXPR last "${n} - 1")
    list(GET url_parts ${last} basename)
    set(output "${DOWNLOADS_DIR}/${basename}")
    message("-- downloading ${arm_none_eabi_triplet}-gcc ${arm_none_eabi_gcc_version} from ${dist_url}")
    file(DOWNLOAD ${dist_url} ${output}
        INACTIVITY_TIMEOUT 30
        STATUS status
        SHOW_PROGRESS
        EXPECTED_HASH MD5=${dist_checksum}
        TLS_VERIFY ON
    )
    list(GET status 0 status_code)
    if(NOT status_code EQUAL 0)
        list(GET status 1 status_message)
        message(FATAL_ERROR "error downloading ${basename}: ${status_message}")
    endif()
    message("-- extracting ${basename}")
    file(ARCHIVE_EXTRACT INPUT ${output} DESTINATION ${TOOLS_DIR})
    file(GLOB gcc-dir ${TOOLS_DIR}/gcc-arm-none-eabi-*)
    file(COPY ${gcc-dir}/. DESTINATION ${TOOLS_DIR}/gcc-arm-none-eabi-latest/.)
endfunction()

function(arm_none_eabi_gcc_check)
    gcc_get_version(version
        TRIPLET ${arm_none_eabi_triplet}
        PROGRAM_NAME prog
        PROGRAM_PATH prog_path
    )
    if(NOT version)
        message("-- could not find ${prog}")
        arm_none_eabi_gcc_install()
        return()
    endif()
    message("-- found ${prog} ${version} at ${prog_path}")
    if(COMPILER_VERSION_CHECK AND NOT arm_none_eabi_gcc_version STREQUAL version)
        message("-- expecting ${prog} version ${arm_none_eabi_gcc_version}, but got version ${version} instead")
        arm_none_eabi_gcc_install()
        return()
    endif()
endfunction()

arm_none_eabi_gcc_check()
