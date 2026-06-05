get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)

set(LLVM_LINK_COMPONENTS
  Support
  TargetParser
)

add_llvm_executable(wavec wavec.cpp)

llvm_update_compile_flags(wavec)
target_link_libraries(wavec PRIVATE
  clangBasic
  clangFrontend
  clangLex
  ${dialect_libs}
  MLIRIR
  MLIRParser
  MLIRRegisterAllDialects
  MLIRSupport
  MLIRTargetWave
  MLIRWaveAMDDialect
  MLIRWaveAMDMachineDialect
  MLIRWaveDialect
  MLIRWaveMetaDialect
  wavefront
  wavefront_lower
)
set_target_properties(wavec PROPERTIES
  CXX_STANDARD 17
  CXX_STANDARD_REQUIRED ON
  RUNTIME_OUTPUT_DIRECTORY "${LLVM_RUNTIME_OUTPUT_INTDIR}"
)

mlir_check_all_link_libraries(wavec)
