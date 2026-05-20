get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)
get_property(extension_libs GLOBAL PROPERTY MLIR_EXTENSION_LIBS)

set(LLVM_LINK_COMPONENTS
  Support
)

add_llvm_executable(wave-opt wave-opt.cpp)

llvm_update_compile_flags(wave-opt)
target_link_libraries(wave-opt PRIVATE
  ${dialect_libs}
  ${conversion_libs}
  ${extension_libs}
  MLIROptLib
  MLIRRegisterAllDialects
  MLIRRegisterAllExtensions
  MLIRRegisterAllPasses
  MLIRTargetWave
  MLIRWaveAMDDialect
  MLIRWaveAMDMachineDialect
  MLIRWaveDialect
  MLIRWaveToLLVM
  MLIRWaveTransforms
)

mlir_check_all_link_libraries(wave-opt)
