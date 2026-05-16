get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(translation_libs GLOBAL PROPERTY MLIR_TRANSLATION_LIBS)

set(LLVM_LINK_COMPONENTS
  Support
)

add_llvm_executable(wave-translate wave-translate.cpp)

llvm_update_compile_flags(wave-translate)
target_link_libraries(wave-translate PRIVATE
  ${dialect_libs}
  ${translation_libs}
  MLIRIR
  MLIRParser
  MLIRPass
  MLIRSupport
  MLIRTargetWave
  MLIRTranslateLib
)

mlir_check_all_link_libraries(wave-translate)
