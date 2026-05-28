add_mlir_library(MLIRWaveAMDMachineCostModel
  ArchData.cpp
  CalibrationData.cpp
  EventSimulator.cpp
  FunctionalUnit.cpp
  LatencyTable.cpp
  MachineState.cpp
  MemoryCounterTiming.cpp
  OpClassifier.cpp
  PressureAnalysis.cpp
  RegionProfile.cpp
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
