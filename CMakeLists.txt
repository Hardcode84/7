# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

cmake_minimum_required(VERSION 3.31)

project(wave-mlir LANGUAGES C CXX)

get_property(WAVE_IS_MULTI_CONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT WAVE_IS_MULTI_CONFIG AND "${CMAKE_BUILD_TYPE}" STREQUAL "")
  message(FATAL_ERROR
    "CMAKE_BUILD_TYPE is required for single-config generators. "
    "Pass -DCMAKE_BUILD_TYPE=Release.")
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Locate the LLVM/MLIR install.
#
# Precedence:
#   1. LLVM_INSTALL_DIR cache variable (-DLLVM_INSTALL_DIR=...)
#   2. LLVM_INSTALL_DIR environment variable
#   3. ${CMAKE_SOURCE_DIR}/build/llvm-install (populated by
#      build_tools/build_llvm.py)
if(NOT DEFINED LLVM_INSTALL_DIR)
  if(DEFINED ENV{LLVM_INSTALL_DIR})
    set(LLVM_INSTALL_DIR "$ENV{LLVM_INSTALL_DIR}"
        CACHE PATH "LLVM/MLIR install prefix")
  else()
    set(LLVM_INSTALL_DIR "${CMAKE_SOURCE_DIR}/build/llvm-install"
        CACHE PATH "LLVM/MLIR install prefix")
  endif()
endif()
list(PREPEND CMAKE_PREFIX_PATH "${LLVM_INSTALL_DIR}")

find_package(LLVM CONFIG)
find_package(MLIR CONFIG)
find_package(Clang CONFIG)
if(NOT LLVM_FOUND OR NOT MLIR_FOUND OR NOT Clang_FOUND)
  message(FATAL_ERROR
    "Could not find LLVM/MLIR/Clang at '${LLVM_INSTALL_DIR}'.\n"
    "Build it first:\n"
    "    python build_tools/build_llvm.py\n"
    "Or point at an existing install:\n"
    "    cmake -S . -B build -DCMAKE_BUILD_TYPE=Release "
    "-DLLVM_INSTALL_DIR=/path/to/llvm-install")
endif()
find_program(WAVE_LLD_EXECUTABLE ld.lld
  HINTS "${LLVM_INSTALL_DIR}/bin"
  NO_DEFAULT_PATH)
if(NOT WAVE_LLD_EXECUTABLE)
  message(FATAL_ERROR
    "Could not find ld.lld at '${LLVM_INSTALL_DIR}/bin'. Rebuild LLVM with "
    "`-DLLVM_ENABLE_PROJECTS=...;lld`.")
endif()

message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
message(STATUS "Using MLIRConfig.cmake in: ${MLIR_DIR}")
message(STATUS "Using ClangConfig.cmake in: ${Clang_DIR}")

set(WAVE_LLVM_INSTALL_STAMP "${LLVM_INSTALL_DIR}/.wave-mlir-commit")
if(EXISTS "${WAVE_LLVM_INSTALL_STAMP}")
  set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS
               "${WAVE_LLVM_INSTALL_STAMP}")
  file(READ "${WAVE_LLVM_INSTALL_STAMP}" WAVE_LLVM_INSTALL_COMMIT)
  string(STRIP "${WAVE_LLVM_INSTALL_COMMIT}" WAVE_LLVM_INSTALL_COMMIT)
else()
  set(WAVE_LLVM_INSTALL_COMMIT "external")
endif()
if(WAVE_LLVM_INSTALL_COMMIT STREQUAL "")
  set(WAVE_LLVM_INSTALL_COMMIT "unknown")
endif()
message(STATUS "Using LLVM install stamp: ${WAVE_LLVM_INSTALL_COMMIT}")
add_compile_definitions(WAVE_LLVM_INSTALL_COMMIT="${WAVE_LLVM_INSTALL_COMMIT}")

list(APPEND CMAKE_MODULE_PATH "${MLIR_CMAKE_DIR}")
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")

include(TableGen)
include(AddLLVM)
include(AddMLIR)
enable_testing()

# Treat all warnings as errors. `HandleLLVMOptions` routes
# `LLVM_ENABLE_WERROR` through `-Werror` on gcc/clang and `/WX` on
# MSVC, so set it before the include and let the upstream machinery
# pick the right spelling. `-Wall -Wextra` are already part of the
# default warning set HandleLLVMOptions installs.
set(LLVM_ENABLE_WERROR ON CACHE BOOL
  "Treat compiler warnings as errors (delegates to HandleLLVMOptions)")

# Match LLVM's GCC false-positive policy; HandleLLVMOptions consumes these.
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 15.0)
    set(USE_NO_UNINITIALIZED ON)
  else()
    set(USE_NO_MAYBE_UNINITIALIZED ON)
  endif()
endif()

include(HandleLLVMOptions)

include_directories(SYSTEM ${LLVM_INCLUDE_DIRS})
include_directories(SYSTEM ${MLIR_INCLUDE_DIRS})
include_directories(${PROJECT_SOURCE_DIR}/include)
include_directories(${PROJECT_BINARY_DIR}/include)

set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/bin)
set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/lib)

function(wave_strip_release_executable target)
  if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    target_link_options(${target} PRIVATE
      "$<$<CONFIG:Release>:LINKER:--strip-all>")
  endif()
endfunction()

# Wave transforms and the AMDGPU target translation reach into AMDGPU's
# internal headers (SIDefines, AMDGPUMCTargetDesc, ...) which aren't part
# of the public MLIR/LLVM install. Point at the llvm-project source and
# build trees provided by build_tools/build_llvm.py; override if you
# bootstrapped LLVM elsewhere.
set(WAVE_LLVM_PROJECT_SRC_DIR
    "${CMAKE_SOURCE_DIR}/build/_deps/llvm-project"
    CACHE PATH "llvm-project source directory (AMDGPU internal headers)")
set(WAVE_LLVM_PROJECT_BUILD_DIR
    "${CMAKE_SOURCE_DIR}/build/llvm-build"
    CACHE PATH "llvm-project build directory (AMDGPU TableGen output)")
if(NOT LLVM_EXTERNAL_LIT AND EXISTS "${WAVE_LLVM_PROJECT_BUILD_DIR}/bin/llvm-lit")
  set(LLVM_EXTERNAL_LIT "${WAVE_LLVM_PROJECT_BUILD_DIR}/bin/llvm-lit"
      CACHE STRING "Command used to spawn lit" FORCE)
endif()
if(LLVM_EXTERNAL_LIT)
  file(MAKE_DIRECTORY "${LLVM_RUNTIME_OUTPUT_INTDIR}")
  if(UNIX)
    # llvm-lit finds its Python package relative to the real script path.
    set(WAVE_LLVM_LIT_WRAPPER "${LLVM_RUNTIME_OUTPUT_INTDIR}/llvm-lit")
    file(REMOVE "${WAVE_LLVM_LIT_WRAPPER}")
    file(WRITE "${WAVE_LLVM_LIT_WRAPPER}"
      "#!/bin/sh\nexec \"${LLVM_EXTERNAL_LIT}\" \"\$@\"\n")
    file(CHMOD "${WAVE_LLVM_LIT_WRAPPER}"
      PERMISSIONS
        OWNER_READ OWNER_WRITE OWNER_EXECUTE
        GROUP_READ GROUP_EXECUTE
        WORLD_READ WORLD_EXECUTE)
  else()
    execute_process(
      COMMAND "${CMAKE_COMMAND}" -E create_symlink
              "${LLVM_EXTERNAL_LIT}" "${LLVM_RUNTIME_OUTPUT_INTDIR}/llvm-lit")
  endif()
endif()

# The imported CMakeLists reference these names directly.
set(LLVM_MAIN_SRC_DIR "${WAVE_LLVM_PROJECT_SRC_DIR}/llvm")
set(LLVM_BINARY_DIR "${WAVE_LLVM_PROJECT_BUILD_DIR}")

add_subdirectory(third_party)
add_subdirectory(include)
add_subdirectory(lib)
add_subdirectory(runtime)
add_subdirectory(tools)
add_subdirectory(wavec)

option(WAVE_ENABLE_PYTHON_BINDINGS
  "Build the Wave/WaveAMD MLIR Python bindings."
  "${MLIR_ENABLE_BINDINGS_PYTHON}")
if(WAVE_ENABLE_PYTHON_BINDINGS)
  if(NOT MLIR_ENABLE_BINDINGS_PYTHON)
    message(FATAL_ERROR
      "WAVE_ENABLE_PYTHON_BINDINGS=ON requires the underlying MLIR install "
      "to be built with -DMLIR_ENABLE_BINDINGS_PYTHON=ON (rerun "
      "build_tools/build_llvm.py --python-bindings).")
  endif()
  # `add_mlir_python_modules` expects `MLIR_BINARY_DIR` to point at the
  # tree where the staged python package is written. We use the wave-mlir
  # build dir so everything lives under `build/python_packages/...`.
  set(MLIR_BINARY_DIR "${CMAKE_BINARY_DIR}")
  include(MLIRDetectPythonEnv)
  mlir_configure_python_dev_packages()
  if(NOT MLIR_PYTHON_PACKAGE_PREFIX)
    set(MLIR_PYTHON_PACKAGE_PREFIX "mlir" CACHE STRING "" FORCE)
  endif()
  if(NOT MLIR_BINDINGS_PYTHON_INSTALL_PREFIX)
    set(MLIR_BINDINGS_PYTHON_INSTALL_PREFIX
        "python_packages/wave_mlir/${MLIR_PYTHON_PACKAGE_PREFIX}"
        CACHE STRING "" FORCE)
  endif()
  add_subdirectory(python)
endif()

add_subdirectory(test)
