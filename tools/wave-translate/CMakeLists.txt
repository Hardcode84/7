set(LLVM_LINK_COMPONENTS
  Support
)

add_llvm_executable(wave-translate wave-translate.cpp)
wave_strip_release_executable(wave-translate)

llvm_update_compile_flags(wave-translate)
target_link_libraries(wave-translate PRIVATE
  MLIRIR
  MLIRParser
  MLIRPass
  MLIRSupport
  MLIRTargetWave
  MLIRTranslateLib
)

mlir_check_all_link_libraries(wave-translate)
