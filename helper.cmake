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

    list(APPEND CMAKE_MODULE_PATH
        "${CMAKE_CURRENT_LIST_DIR}/tools/camkes"
        "${CMAKE_CURRENT_LIST_DIR}/capdl"
        "${CMAKE_CURRENT_LIST_DIR}/libs/camkes-vm"
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

    find_package(camkes-vm REQUIRED)
    if(KernelArchARM)
        find_package(camkes-arm-vm REQUIRED)
        function(os_sdk_import_camkes_vm)
            camkes_arm_vm_import_project()
            CAmkESAddImportPath("${CAMKES_ARM_VM_DIR}/components/VM_Arm")
            CAmkESAddCPPInclude("${CAMKES_ARM_VM_DIR}/components/VM_Arm")
        endfunction()
    elseif(KernelArchRiscV)
        function(os_sdk_import_camkes_vm)
            message(FATAL_ERROR "ToDo: support CAmkES VM for RISC-V")
        endfunction()
    elseif(KernelArchX86)
        function(os_sdk_import_camkes_vm)
            message(FATAL_ERROR "ToDo: support CAmkES VM for x86")
        endfunction()
    else()
        message(FATAL_ERROR "Unsupported KernelArch '${KernelArch}'")
    endif()

else()

    # Just configure the general platform setting. Don't import anything,
    # projects can use os_sdk_import_sel4() or cherry-pick things.
    sel4_configure_platform_settings()

endif()

# Include lots of helpers from tools/seL4/cmake-tool/helpers.
include("${SEL4_CMAKE_TOOL_DIR}/common.cmake")
