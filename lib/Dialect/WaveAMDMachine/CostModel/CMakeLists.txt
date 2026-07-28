add_mlir_library(MLIRWaveAMDMachineCostModel
  ArchData.cpp
  CalibrationData.cpp
  EventSimulator.cpp
  FunctionalUnit.cpp
  InstructionExecutionState.cpp
  InstructionResourceState.cpp
  LatencyTable.cpp
  MemoryCounterTiming.cpp
  MultiWaveExecutionState.cpp
  OpClassifier.cpp
  SchedClass.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/WaveAMDMachine/CostModel

  DEPENDS
  MLIRWaveAMDMachineCostModelEnumsIncGen

  LINK_LIBS PUBLIC
  LLVMSupport
  MLIRAnalysis
  MLIRFuncDialect
  MLIRIR
  MLIRWaveAMDMachineDialect
  )
