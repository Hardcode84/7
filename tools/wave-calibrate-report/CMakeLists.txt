set(LLVM_LINK_COMPONENTS
  Support
  TargetParser
)

add_llvm_executable(wave-calibrate-report wave-calibrate-report.cpp)
wave_strip_release_executable(wave-calibrate-report)

llvm_update_compile_flags(wave-calibrate-report)
target_link_libraries(wave-calibrate-report PRIVATE
  MLIRWaveAMDMachineCostModel
)

mlir_check_all_link_libraries(wave-calibrate-report)
