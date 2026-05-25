set(LLVM_LINK_COMPONENTS
  Support
  TargetParser
)

add_llvm_executable(wave-sim-report wave-sim-report.cpp)

llvm_update_compile_flags(wave-sim-report)
target_link_libraries(wave-sim-report PRIVATE
  MLIRFuncDialect
  MLIRIR
  MLIRParser
  MLIRRegisterAllDialects
  MLIRSupport
  MLIRWaveAMDDialect
  MLIRWaveAMDMachineCostModel
  MLIRWaveAMDMachineDialect
  MLIRWaveDialect
  MLIRWaveMetaDialect
)

mlir_check_all_link_libraries(wave-sim-report)
