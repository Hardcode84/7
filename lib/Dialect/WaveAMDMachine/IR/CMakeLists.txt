add_mlir_dialect_library(MLIRWaveAMDMachineDialect
  WaveAMDMachine.cpp
  WaveAMDMachineInstrInfo.cpp
  WaveAMDMachineTarget.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/WaveAMDMachine

  DEPENDS
  MLIRWaveAMDMachineEnumsIncGen
  MLIRWaveAMDMachineInterfacesIncGen
  MLIRWaveAMDMachineOpsIncGen

  LINK_COMPONENTS
  TargetParser

  LINK_LIBS PUBLIC
  MLIRControlFlowInterfaces
  MLIRInferIntRangeCommon
  MLIRInferIntRangeInterface
  MLIRIR
  )
