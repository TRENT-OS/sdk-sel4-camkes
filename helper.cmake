#
# sel4 build system wrapper
#
# Copyright (C) 2019-2020, Hensoldt Cyber GmbH
#

cmake_minimum_required(VERSION 3.7.2)

# The entity that calls us is supposed to set SDK_SEL4_CAMKES_DIR. If it is
# missing, we set it up here, because the macros below need it. Unfortunately,
# there is still no CMAKE_CURRENT_MACRO_LIST_DIR that works like the
# CMAKE_CURRENT_FUNCTION_LIST_DIR that CMake 3.17 added, this would be very
# handy here to avoid depending on helper variables.
if(NOT SDK_SEL4_CAMKES_DIR)
    message(WARNING "SDK_SEL4_CAMKES_DIR not set, will set it now")
    set(SDK_SEL4_CAMKES_DIR  "${CMAKE_CURRENT_LIST_DIR}")
endif()


#-------------------------------------------------------------------------------
# this is a macro, because any changes shall affect the caller's scope
macro(setup_sel4_build_system)

    # internal helper variables
    set(SEL4_CMAKE_TOOL_DIR "${SDK_SEL4_CAMKES_DIR}/tools/seL4/cmake-tool")

    list(APPEND CMAKE_MODULE_PATH
        "${SEL4_CMAKE_TOOL_DIR}/helpers"

        "${SDK_SEL4_CAMKES_DIR}/kernel"
        "${SDK_SEL4_CAMKES_DIR}/libs/musllibc"
        "${SDK_SEL4_CAMKES_DIR}/libs/sel4runtime"
        "${SDK_SEL4_CAMKES_DIR}/libs/sel4_util_libs"
        "${SDK_SEL4_CAMKES_DIR}/libs/sel4_libs"
        "${SDK_SEL4_CAMKES_DIR}/libs/sel4_projects_libs"
        "${SDK_SEL4_CAMKES_DIR}/libs/projects_libs"
        "${SDK_SEL4_CAMKES_DIR}/tools/seL4/elfloader-tool"
    )

    # CMake interactive build debugging. Seems that set_break() does not work
    # unless ${SEL4_CMAKE_TOOL_DIR}/helpers/cmakerepl has a *.cmake suffix
    include("${SEL4_CMAKE_TOOL_DIR}/helpers/debug.cmake")

    # platform settings
    include("${SEL4_CMAKE_TOOL_DIR}/helpers/application_settings.cmake")
    correct_platform_strings()

    # add sel4 kernel
    find_package(seL4 REQUIRED)
    sel4_configure_platform_settings()

    # include lots of helpers from tools/seL4/cmake-tool/helpers
    include("${SEL4_CMAKE_TOOL_DIR}/common.cmake")

    # the sel4 build system needs this to be defined, it can't find it
    # automatically because we use a different layout in the SDK
    set(
        NANOPB_SRC_ROOT_FOLDER
        "${SDK_SEL4_CAMKES_DIR}/tools/nanopb"
        CACHE
        INTERNAL
        ""
    )

endmacro()


#-------------------------------------------------------------------------------
# This is a macro, because any changes shall affect the caller's scope. Calling
# setup_sel4_build_system() is required before this is called to add the CAmkES
# features on top.
macro(setup_sel4_camkes_build_system)

    list(APPEND CMAKE_MODULE_PATH
        "${SDK_SEL4_CAMKES_DIR}/tools/camkes"
        "${SDK_SEL4_CAMKES_DIR}/capdl"
        "${SDK_SEL4_CAMKES_DIR}/libs/sel4_global_components"
    )

    find_package(camkes-tool REQUIRED)
    find_package(global-components REQUIRED)

    # for CMake to work properly, a project must be defined here
    project(camkes-system C CXX ASM)

    camkes_tool_setup_camkes_build_environment()

    # we do not enable the global-components by default, any project that needs
    # them must call global_components_import_project() then.

endmacro()
