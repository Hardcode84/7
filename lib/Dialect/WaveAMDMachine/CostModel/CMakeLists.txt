add_mlir_library(MLIRWaveAMDMachineCostModel
  ArchData.cpp
  CalibrationData.cpp
  EventSimulator.cpp
  FunctionalUnit.cpp
  InstructionExecutionState.cpp
  LatencyTable.cpp
  MemoryCounterTiming.cpp
  OpClassifier.cpp
  SchedClass.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/WaveAMDMachine/CostModel

  LINK_LIBS PUBLIC
  LLVMSupport
  MLIRAnalysis
  MLIRFuncDialect
  MLIRIR
  MLIRWaveAMDMachineDialect
  )
