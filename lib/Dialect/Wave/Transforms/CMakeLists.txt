add_mlir_dialect_library(MLIRWaveTransforms
  WaveAMDABILowering.cpp
  WaveAMDDecomposeMemTuples.cpp
  WaveAMDHazardWaits.cpp
  WaveAMDMachine.cpp
  WaveAMDMachineIndexExpr.cpp
  WaveAMDMachineLoadStore.cpp
  WaveAMDMachineScfFor.cpp
  WaveAMDMachineWaitcnt.cpp
  WaveAMDMetadata.cpp
  WaveAMDRegAlloc.cpp
  WaveAMDResourceInfo.cpp
  WaveAttachGPUBinary.cpp
  WaveToGPU.cpp
  WaveToROCDL.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Wave

  DEPENDS
  MLIRWaveTransformsIncGen

  LINK_COMPONENTS

  AMDGPUUtils
  TargetParser

  LINK_LIBS PUBLIC
  MLIRAnalysis
  MLIRArithDialect
  MLIRGPUDialect
  MLIRIR
  MLIRPass
  MLIRROCDLDialect
  MLIRSCFDialect
  MLIRTransformUtils
  MLIRWaveAMDDialect
  MLIRWaveAMDMachineDialect
  MLIRWaveDialect
  )

target_include_directories(obj.MLIRWaveTransforms
  PRIVATE
  ${LLVM_MAIN_SRC_DIR}/lib/Target/AMDGPU
  ${LLVM_BINARY_DIR}/lib/Target/AMDGPU
  )
