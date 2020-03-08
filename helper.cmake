cmake_minimum_required(VERSION 3.7.2)

#-------------------------------------------------------------------------------
macro(use_sdk_sel4_camkes)

    # internal helper variable
    set(SEL4_CMAKE_TOOL_DIR "${SDK_SEL4_CAMKES_DIR}/tools/seL4/cmake-tool")

    # module search paths
    list(APPEND CMAKE_MODULE_PATH
        ${SEL4_CMAKE_TOOL_DIR}/helpers
        ${SDK_SEL4_CAMKES_DIR}/tools/camkes
        ${SDK_SEL4_CAMKES_DIR}/kernel
        ${SDK_SEL4_CAMKES_DIR}/tools/seL4/elfloader-tool
        ${SDK_SEL4_CAMKES_DIR}/capdl
        # seL4 and CAmkES libs
        ${SDK_SEL4_CAMKES_DIR}/libs/musllibc
        ${SDK_SEL4_CAMKES_DIR}/libs/sel4runtime
        ${SDK_SEL4_CAMKES_DIR}/libs/sel4_util_libs
        ${SDK_SEL4_CAMKES_DIR}/libs/sel4_libs
        ${SDK_SEL4_CAMKES_DIR}/libs/sel4_project_libs
    )

    # for CMake to work properly, a project must be defined
    project(camkes C CXX ASM)

    # CMake interactive build debugging. Seems that set_break() does not work
    # unless ${SEL4_CMAKE_TOOL_DIR}/helpers/cmakerepl is renamed to have a
    # *.camkes suffic
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

endmacro()
