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
if(NOT LLVM_FOUND OR NOT MLIR_FOUND)
  message(FATAL_ERROR
    "Could not find LLVM/MLIR at '${LLVM_INSTALL_DIR}'.\n"
    "Build it first:\n"
    "    python build_tools/build_llvm.py\n"
    "Or point at an existing install:\n"
    "    cmake -S . -B build -DLLVM_INSTALL_DIR=/path/to/llvm-install")
endif()

message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
message(STATUS "Using MLIRConfig.cmake in: ${MLIR_DIR}")

set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/bin)
set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/lib)
