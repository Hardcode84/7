# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set(LLVM_LINK_COMPONENTS
  AMDGPUDesc
  AMDGPUInfo
  AMDGPUUtils
  MC
  Support
  TargetParser
)

add_llvm_executable(wave-target-info
  wave-target-info.cpp
)
wave_strip_release_executable(wave-target-info)

llvm_update_compile_flags(wave-target-info)
add_dependencies(wave-target-info
  MLIRWaveAMDMachineCostModelEnumsIncGen
)
target_link_libraries(wave-target-info PRIVATE
  MLIRWaveAMDMachineDialect
)

target_include_directories(wave-target-info
  PRIVATE
  ${LLVM_MAIN_SRC_DIR}/lib/Target/AMDGPU
  ${LLVM_BINARY_DIR}/lib/Target/AMDGPU
)

mlir_check_all_link_libraries(wave-target-info)
