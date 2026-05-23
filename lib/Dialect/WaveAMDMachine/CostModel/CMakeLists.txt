add_mlir_library(MLIRWaveAMDMachineCostModel
  ArchData.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/WaveAMDMachine/CostModel

  LINK_LIBS PUBLIC
  LLVMSupport
  )
