# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

cmake_minimum_required(VERSION 3.31)

project(wave-mlir LANGUAGES C CXX)

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
find_package(LLD CONFIG)
if(NOT LLVM_FOUND OR NOT MLIR_FOUND)
  message(FATAL_ERROR
    "Could not find LLVM/MLIR at '${LLVM_INSTALL_DIR}'.\n"
    "Build it first:\n"
    "    python build_tools/build_llvm.py\n"
    "Or point at an existing install:\n"
    "    cmake -S . -B build -DLLVM_INSTALL_DIR=/path/to/llvm-install")
endif()
if(NOT LLD_FOUND)
  message(FATAL_ERROR
    "Could not find LLD at '${LLVM_INSTALL_DIR}'. The wave-compile-kernels "
    "pass links lld in-process; rebuild LLVM with `-DLLVM_ENABLE_PROJECTS=...;lld`.")
endif()

message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
message(STATUS "Using MLIRConfig.cmake in: ${MLIR_DIR}")

list(APPEND CMAKE_MODULE_PATH "${MLIR_CMAKE_DIR}")
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")

include(TableGen)
include(AddLLVM)
include(AddMLIR)

# Treat all warnings as errors. `HandleLLVMOptions` routes
# `LLVM_ENABLE_WERROR` through `-Werror` on gcc/clang and `/WX` on
# MSVC, so set it before the include and let the upstream machinery
# pick the right spelling. `-Wall -Wextra` are already part of the
# default warning set HandleLLVMOptions installs.
set(LLVM_ENABLE_WERROR ON CACHE BOOL
  "Treat compiler warnings as errors (delegates to HandleLLVMOptions)")

include(HandleLLVMOptions)

include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${MLIR_INCLUDE_DIRS})
include_directories(${PROJECT_SOURCE_DIR}/include)
include_directories(${PROJECT_BINARY_DIR}/include)

set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/bin)
set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/lib)

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

# The imported CMakeLists reference these names directly.
set(LLVM_MAIN_SRC_DIR "${WAVE_LLVM_PROJECT_SRC_DIR}/llvm")
set(LLVM_BINARY_DIR "${WAVE_LLVM_PROJECT_BUILD_DIR}")

add_subdirectory(third_party)
add_subdirectory(include)
add_subdirectory(lib)
add_subdirectory(runtime)
add_subdirectory(tools)

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
