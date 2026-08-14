# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

add_llvm_executable(wave-symbols-test wave-symbols-test.cpp)
llvm_update_compile_flags(wave-symbols-test)
target_include_directories(wave-symbols-test
  PRIVATE
  ${CMAKE_SOURCE_DIR}/lib/Dialect/Wave/IR
)
target_link_libraries(wave-symbols-test
  PRIVATE
  MLIRWaveDialect
  MLIRWaveTransforms
  WaveCAPI
)
mlir_check_all_link_libraries(wave-symbols-test)
