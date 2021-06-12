#
# seL4 build system wrapper
#
# Copyright (C) 2019-2021, HENSOLDT Cyber GmbH
#

cmake_minimum_required(VERSION 3.17.3)

# Setup internal helper variables.
set(SEL4_CMAKE_TOOL_DIR "${CMAKE_CURRENT_LIST_DIR}/tools/seL4/cmake-tool")

list(APPEND CMAKE_MODULE_PATH
    "${SEL4_CMAKE_TOOL_DIR}/helpers"
    "${CMAKE_CURRENT_LIST_DIR}/kernel"
    "${CMAKE_CURRENT_LIST_DIR}/libs/musllibc"
    "${CMAKE_CURRENT_LIST_DIR}/libs/sel4runtime"
    "${CMAKE_CURRENT_LIST_DIR}/libs/sel4_util_libs"
    "${CMAKE_CURRENT_LIST_DIR}/libs/sel4_libs"
    "${CMAKE_CURRENT_LIST_DIR}/libs/sel4_projects_libs"
    "${CMAKE_CURRENT_LIST_DIR}/libs/projects_libs"
    "${CMAKE_CURRENT_LIST_DIR}/tools/seL4/elfloader-tool"
)

# The seL4 default build system uses a different folder, adapt the paths.
set(
    NANOPB_SRC_ROOT_FOLDER
    "${CMAKE_CURRENT_LIST_DIR}/tools/nanopb"
    CACHE
    INTERNAL
    "NanoPB location"
)

set(
    OPENSBI_PATH
    "${CMAKE_CURRENT_LIST_DIR}/tools/opensbi"
    CACHE
    STRING
    "OpenSBI location")

macro(os_sdk_import_sel4)
    enable_language(C CXX ASM)
    sel4_import_kernel()
    elfloader_import_project()
    # this must be called before importing libsel4()
    musllibc_setup_build_environment_with_sel4runtime()
    sel4_import_libsel4()
    util_libs_import_libraries()
    sel4_libs_import_libraries()
    projects_libs_import_libraries()
    sel4_projects_libs_import_libraries()
endmacro()

# CMake interactive build debugging. Seems that set_break() does not work unless
# ${SEL4_CMAKE_TOOL_DIR}/helpers/cmakerepl has a *.cmake suffix
include("${SEL4_CMAKE_TOOL_DIR}/helpers/debug.cmake")

# platform settings
include("${SEL4_CMAKE_TOOL_DIR}/helpers/application_settings.cmake")
correct_platform_strings()

find_package("seL4" REQUIRED)
find_package("sel4runtime" REQUIRED)
find_package("musllibc" REQUIRED)
find_package("util_libs" REQUIRED)
find_package("seL4_libs" REQUIRED)
find_package("projects_libs" REQUIRED)
find_package("sel4_projects_libs" REQUIRED)
find_package("elfloader-tool" REQUIRED)

if(SDK_USE_CAMKES)

    #================================================================
    # RISC-V tweaking start
    #================================================================

    if(PLATFORM MATCHES "^(spike|spike64|spike32)$")
    # spike does not have a timer
    set(Sel4testHaveTimer ON CACHE BOOL "" FORCE)
    endif()


    if(PLATFORM MATCHES "^(migv)$")
    # migv does not have a FPU
    set(Sel4testHaveFPU OFF CACHE BOOL "" FORCE)
    # migv has cache - currently sel4test cache tests only exist for ARM platform
    # and cache doesn't work on MiG-V 1.0 Evaluation Board
    set(Sel4testHaveCache OFF CACHE BOOL "" FORCE)
    endif()

    # select specific test in sel4test native
    # set(LibSel4TestPrinterRegex "PREEMPT_REVOKE" CACHE STRING "A POSIX regex pattern used to filter tests")
    # set(LibSel4TestPrinterRegex "SCHED0021" CACHE STRING "A POSIX regex pattern used to filter tests")

    #set(KernelPrinting OFF CACHE BOOL "" FORCE)
    set(KernelPrinting ON CACHE BOOL "" FORCE)

    #set(KernelDebugBuild OFF CACHE BOOL "" FORCE)
    set(KernelDebugBuild ON CACHE BOOL "" FORCE)

    #set(ElfloaderHashInstructions "hash_sha" CACHE STRING "" FORCE)
    set(ElfloaderHashInstructions "hash_none" CACHE STRING "" FORCE)


    if(PLATFORM MATCHES "^(spike|spike32|hifive|polarfire)$")

        message("############### config hack: QEMU/${PLATFORM}")
        set(KernelRiscVSBI "OpenSBI" CACHE BOOL "" FORCE) # use SBI provided by platform

    elseif(PLATFORM STREQUAL "migv")

        message("############### config hack: MiG-V")
        set(KernelRiscVSBI "ROM" CACHE BOOL "" FORCE) # use SBI provided by platform
        #set(IMAGE_START_ADDR 0x01000000) # run kernel from internal SRAM
        set(IMAGE_START_ADDR 0x41000000) # run kernel from external SDRAM at +2MiByte

    endif()

    #================================================================
    # RISC-V tweaking end
    #================================================================

    list(APPEND CMAKE_MODULE_PATH
        "${CMAKE_CURRENT_LIST_DIR}/tools/camkes"
        "${CMAKE_CURRENT_LIST_DIR}/capdl"
        "${CMAKE_CURRENT_LIST_DIR}/libs/sel4_global_components"
    )

    find_package("camkes-tool" REQUIRED)
    find_package("global-components" REQUIRED)

    enable_language(C CXX ASM)
    camkes_tool_setup_camkes_build_environment()
    sel4_projects_libs_import_libraries()

    # Provide just the connectors from the global component, but no components,
    # because this may cause name conflicts. Any project that needs them must
    # either cherry-pick things or call global_components_import_project().
    include("${GLOBAL_COMPONENTS_DIR}/global-connectors.cmake")

else()

    # Just configure the general platform setting. Don't import anything,
    # projects can use os_sdk_import_sel4() or cherry-pick things.
    sel4_configure_platform_settings()

endif()


# Include lots of helpers from tools/seL4/cmake-tool/helpers.
include("${SEL4_CMAKE_TOOL_DIR}/common.cmake")
