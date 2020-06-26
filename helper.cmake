#
# sel4 build system wrapper
#
# Copyright (C) 2019-2020, Hensoldt Cyber GmbH
#

cmake_minimum_required(VERSION 3.7.2)

#-------------------------------------------------------------------------------
# we can't use CMAKE_CURRENT_LIST_DIR in a function/macro, because that will
# give us the dir of the file that is invoking the function/macro. Until we
# have CmMake 3.17 which provides CMAKE_CURRENT_FUNCTION_LIST_DIR, the work
# around is creating a global variable here with the directory and then use
# this in the function below.
set(SEL4_CAMKES_SDK_DIR "${CMAKE_CURRENT_LIST_DIR}")


#-------------------------------------------------------------------------------
# this is a macro, because any changes shall affect the caller's scope
macro(setup_sel4_build_system)

    # internal helper variables
    set(SEL4_CMAKE_TOOL_DIR "${SEL4_CAMKES_SDK_DIR}/tools/seL4/cmake-tool")

    list(APPEND CMAKE_MODULE_PATH
        "${SEL4_CMAKE_TOOL_DIR}/helpers"

        "${SEL4_CAMKES_SDK_DIR}/kernel"
        "${SEL4_CAMKES_SDK_DIR}/libs/musllibc"
        "${SEL4_CAMKES_SDK_DIR}/libs/sel4runtime"
        "${SEL4_CAMKES_SDK_DIR}/libs/sel4_util_libs"
        "${SEL4_CAMKES_SDK_DIR}/libs/sel4_libs"
        "${SEL4_CAMKES_SDK_DIR}/libs/sel4_projects_libs"
        "${SEL4_CAMKES_SDK_DIR}/libs/projects_libs"
        "${SEL4_CAMKES_SDK_DIR}/tools/seL4/elfloader-tool"
    )

    # CMake interactive build debugging. Seems that set_break() does not work
    # unless ${SEL4_CMAKE_TOOL_DIR}/helpers/cmakerepl has a
    # *.cmake suffix
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
        "${SEL4_CAMKES_SDK_DIR}/tools/nanopb"
        CACHE
        INTERNAL
        ""
    )

endmacro()

#-------------------------------------------------------------------------------
# Add Data61's global components (and esp. global-connectors) to the include path
macro(setup_sel4_global_components)

    find_file(GLOBAL_COMPONENTS_PATH
        seL4-connectors.cmake
        PATHS
            "${SEL4_CAMKES_SDK_DIR}/libs/sel4_global_components"
            CMAKE_FIND_ROOT_PATH_BOTH)

    mark_as_advanced(FORCE GLOBAL_COMPONENTS_PATH)

    if("${GLOBAL_COMPONENTS_PATH}" STREQUAL "GLOBAL_COMPONENTS_PATH-NOTFOUND")
        message(FATAL_ERROR "Failed to find global-components.cmake. Consider cmake -DGLOBAL_COMPONENTS_PATH=/path/to/global-components.cmake")
    endif()

    include(${GLOBAL_COMPONENTS_PATH})

endmacro()

#-------------------------------------------------------------------------------
# This is a macro, because any changes shall affect the caller's scope. Calling
# setup_sel4_build_system() is required before this is called to add the CAmkES
# features on top.
macro(setup_sel4_camkes_build_system)

    list(APPEND CMAKE_MODULE_PATH
        "${SEL4_CAMKES_SDK_DIR}/tools/camkes"
        "${SEL4_CAMKES_SDK_DIR}/capdl"
    )

    find_package(camkes-tool REQUIRED)

    # for CMake to work properly, a project must be defined here
    project(camkes-system C CXX ASM)

    camkes_tool_setup_camkes_build_environment()

endmacro()
