set(LLVM_LINK_COMPONENTS
  Support
  TargetParser
)

add_llvm_executable(wave-instruction-state-report
  wave-instruction-state-report.cpp
)

llvm_update_compile_flags(wave-instruction-state-report)
target_link_libraries(wave-instruction-state-report PRIVATE
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

mlir_check_all_link_libraries(wave-instruction-state-report)
