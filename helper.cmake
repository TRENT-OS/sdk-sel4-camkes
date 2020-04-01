cmake_minimum_required(VERSION 3.7.2)

# internal helper variable
set(SEL4_CMAKE_TOOL_DIR "${CMAKE_CURRENT_LIST_DIR}/tools/seL4/cmake-tool")

# module search paths
list(APPEND CMAKE_MODULE_PATH
    ${SEL4_CMAKE_TOOL_DIR}/helpers
    ${CMAKE_CURRENT_LIST_DIR}/tools/camkes
    ${CMAKE_CURRENT_LIST_DIR}/kernel
    ${CMAKE_CURRENT_LIST_DIR}/tools/seL4/elfloader-tool
    ${CMAKE_CURRENT_LIST_DIR}/capdl
    # seL4 and CAmkES libs
    ${CMAKE_CURRENT_LIST_DIR}/libs/musllibc
    ${CMAKE_CURRENT_LIST_DIR}/libs/sel4runtime
    ${CMAKE_CURRENT_LIST_DIR}/libs/sel4_util_libs
    ${CMAKE_CURRENT_LIST_DIR}/libs/sel4_libs
    ${CMAKE_CURRENT_LIST_DIR}/libs/sel4_project_libs
)

# for CMake to work properly, a project must be defined
project(camkes C CXX ASM)

# CMake interactive build debugging. Seems that set_break() does not work
# unless ${SEL4_CMAKE_TOOL_DIR}/helpers/cmakerepl is renamed to have a *.camkes
# suffix
include(${SEL4_CMAKE_TOOL_DIR}/helpers/debug.cmake)

    # platform settings
    include(${SEL4_CMAKE_TOOL_DIR}/helpers/application_settings.cmake)
    correct_platform_strings()
    find_package(seL4 REQUIRED)
    sel4_configure_platform_settings()

    # include lots of helpers from tools/seL4/cmake-tool/helpers
include(${SEL4_CMAKE_TOOL_DIR}/common.cmake)

find_package(camkes-tool REQUIRED)
camkes_tool_setup_camkes_build_environment()
