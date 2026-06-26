add_mlir_dialect_library(MLIRWaveDialect
  PARTIAL_SOURCES_INTENDED
  Wave.cpp
  WaveMemoryAddress.cpp
  WaveSymbols.cpp
  WaveTransformOps.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocTransformLoop.cpp
  ../Transforms/RegAlloc/WaveAMDRegAllocTransformState.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Wave

  DEPENDS
  MLIRWaveAttributesIncGen
  MLIRWaveEnumsIncGen
  MLIRWaveOpsIncGen
  MLIRWaveTransformOpsIncGen

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
  MLIRWaveAMDMachineCostModel
  WaveIXSimpl
  )

add_mlir_dialect_library(MLIRWaveAMDDialect
  PARTIAL_SOURCES_INTENDED
  WaveAMD.cpp
  WaveAMDABI.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Wave

  DEPENDS
  MLIRWaveAMDAttributesIncGen
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
