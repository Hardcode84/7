add_mlir_dialect_library(MLIRWaveAMDMachineDialect
  WaveAMDMachine.cpp
  WaveAMDMachineInstrInfo.cpp
  WaveAMDMachineTarget.cpp
  WaveAMDMachineWaitcntInfo.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/WaveAMDMachine

  DEPENDS
  MLIRWaveAMDMachineEnumsIncGen
  MLIRWaveAMDMachineInterfacesIncGen
  MLIRWaveAMDMachineOpsIncGen
  MLIRWaveAMDMachineTargetEnumsIncGen
  MLIRWaveAMDMachineWaitEnumsIncGen

  LINK_COMPONENTS

  AMDGPUDesc
  AMDGPUInfo
  AMDGPUUtils
  TargetParser

  LINK_LIBS PUBLIC
  MLIRControlFlowInterfaces
  MLIRInferIntRangeCommon
  MLIRInferIntRangeInterface
  MLIRIR
  )

target_include_directories(obj.MLIRWaveAMDMachineDialect
  SYSTEM PRIVATE
  ${LLVM_MAIN_SRC_DIR}/lib/Target/AMDGPU
  ${LLVM_BINARY_DIR}/lib/Target/AMDGPU
  )
