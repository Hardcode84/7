# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

add_library(wave_runtime SHARED wave_runtime.cpp)

set_target_properties(wave_runtime PROPERTIES
  POSITION_INDEPENDENT_CODE ON
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
  )

# Headerless, no LLVM/MLIR deps - just the C++ stdlib.
target_compile_features(wave_runtime PRIVATE cxx_std_17)
