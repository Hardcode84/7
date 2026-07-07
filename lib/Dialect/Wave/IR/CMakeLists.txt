add_mlir_dialect_library(MLIRWaveDialect
  PARTIAL_SOURCES_INTENDED
  Wave.cpp
  WaveAMDABI.cpp
  WaveMemoryAddress.cpp
  WaveSymbols.cpp
  WaveTransformOps.cpp
  ../Transforms/WaveAMDExecIfUtils.cpp
  ../Transforms/WaveAMDHardwareResources.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocLDSPlanning.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocPrep.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocScratchPlanning.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocAGPRRelief.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocLDSRelief.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocRematRelief.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocSGPRToVGPRRelief.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocScratchRelief.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocTransformLoop.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocTransformState.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocTransformUtils.cpp
  ../Transforms/RegAlloc/WaveAMDRegisterLimits.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Wave

  DEPENDS
  MLIRWaveAMDAttributesIncGen
  MLIRWaveAMDEnumsIncGen
  MLIRWaveAMDOpsIncGen
  MLIRWaveAttributesIncGen
  MLIRWaveEnumsIncGen
  MLIRWaveOpsIncGen
  MLIRWaveTransformOpsIncGen

  LINK_COMPONENTS

  AMDGPUDesc
  AMDGPUInfo
  AMDGPUUtils
  TargetParser

  LINK_LIBS PUBLIC
  MLIRArithDialect
  MLIRFuncDialect
  MLIRGPUDialect
  MLIRInferIntRangeCommon
  MLIRInferIntRangeInterface
  MLIRIR
  MLIRSCFDialect
  MLIRSideEffectInterfaces
  MLIRTransformDialect
  MLIRTransformDialectInterfaces
  MLIRViewLikeInterface
  MLIRWaveAMDMachineCostModel
  MLIRWaveAMDMachineDialect
  WaveIXSimpl
  )

target_include_directories(obj.MLIRWaveDialect
  PRIVATE
  ${LLVM_MAIN_SRC_DIR}/lib/Target/AMDGPU
  ${LLVM_BINARY_DIR}/lib/Target/AMDGPU
  )

add_mlir_dialect_library(MLIRWaveAMDDialect
  PARTIAL_SOURCES_INTENDED
  WaveAMD.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Wave

  DEPENDS
  MLIRWaveAMDAttributesIncGen
  MLIRWaveAMDEnumsIncGen
  MLIRWaveAMDOpsIncGen

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRSideEffectInterfaces
  MLIRWaveDialect
  )

add_mlir_dialect_library(MLIRWaveMetaDialect
  PARTIAL_SOURCES_INTENDED
  WaveMeta.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Wave

  DEPENDS
  MLIRWaveMetaOpsIncGen

  LINK_LIBS PUBLIC
  MLIRArithDialect
  MLIRControlFlowInterfaces
  MLIRIR
  MLIRSideEffectInterfaces
  )
