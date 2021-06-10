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

# CMake interactive build debugging. Seems that set_break() does not work unless
# ${SEL4_CMAKE_TOOL_DIR}/helpers/cmakerepl has a *.cmake suffix
include("${SEL4_CMAKE_TOOL_DIR}/helpers/debug.cmake")

# platform settings
include("${SEL4_CMAKE_TOOL_DIR}/helpers/application_settings.cmake")
correct_platform_strings()

# Add the seL4 kernel.
find_package(seL4 REQUIRED)
sel4_configure_platform_settings()

# Include lots of helpers from tools/seL4/cmake-tool/helpers.
include("${SEL4_CMAKE_TOOL_DIR}/common.cmake")

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

if (SDK_USE_CAMKES)

    set(
        SDK_SEL4_CAMKES_GLOBAL_COMPS_DIR
        "${CMAKE_CURRENT_LIST_DIR}/libs/sel4_global_components"
    )

    list(APPEND CMAKE_MODULE_PATH
        "${CMAKE_CURRENT_LIST_DIR}/tools/camkes"
        "${CMAKE_CURRENT_LIST_DIR}/capdl"
        "${SDK_SEL4_CAMKES_GLOBAL_COMPS_DIR}"
    )

    find_package(camkes-tool REQUIRED)
    find_package(global-components REQUIRED)

    # For CMake to work properly, a project must be defined here.
    project(camkes-system C CXX ASM)

    camkes_tool_setup_camkes_build_environment()

    include("${SDK_SEL4_CAMKES_GLOBAL_COMPS_DIR}/global-connectors.cmake")

    # We do not enable anything from the global components by default. Any
    # project that needs them must either cherry-pick things or call
    # global_components_import_project().

endif()
