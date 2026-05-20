# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# Wave consumes ixsimpl as a single-translation-unit amalgamation so we
# don't have to wire 13 individual sources through the dialect build.
# The vendored standalone CMakeLists is bypassed -- it pulls in test
# executables and pedantic compile flags we don't want propagated into
# the MLIR build.
add_library(WaveIXSimpl STATIC
  "${CMAKE_CURRENT_SOURCE_DIR}/ixsimpl/ixsimpl_amalg.c"
)
target_include_directories(WaveIXSimpl
  PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/ixsimpl/include"
  PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/ixsimpl/src"
)
set_target_properties(WaveIXSimpl PROPERTIES
  C_STANDARD 99
  C_STANDARD_REQUIRED ON
  C_EXTENSIONS OFF
  POSITION_INDEPENDENT_CODE ON
)

# Vendored third-party code; opt out of `-Werror` so its existing
# `-Wcast-qual` etc. warnings stay warnings, not build failures.
target_compile_options(WaveIXSimpl PRIVATE -Wno-error)
