# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set(LLVM_LINK_COMPONENTS
  Support
  TargetParser
)

add_llvm_executable(wave-target-info
  wave-target-info.cpp
)

llvm_update_compile_flags(wave-target-info)
target_link_libraries(wave-target-info PRIVATE
  MLIRWaveAMDMachineDialect
)

mlir_check_all_link_libraries(wave-target-info)
