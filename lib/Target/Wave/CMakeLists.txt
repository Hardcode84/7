# Copy the wave compilation pipeline library next to the build's bin/
# dir so binaries and the share/ tree form a single movable unit
# ($<bindir>/../share/wave-mlir/pipelines/pipelines.mlir). Installs
# land at $prefix/share/wave-mlir/pipelines/pipelines.mlir, preserving
# the same relative layout.
set(_wave_pipeline_src
  "${CMAKE_CURRENT_SOURCE_DIR}/pipelines/pipelines.mlir")
set(_wave_pipeline_staged
  "${CMAKE_BINARY_DIR}/share/wave-mlir/pipelines/pipelines.mlir")
add_custom_command(
  OUTPUT "${_wave_pipeline_staged}"
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${_wave_pipeline_src}" "${_wave_pipeline_staged}"
  DEPENDS "${_wave_pipeline_src}"
  COMMENT "Copying Wave compilation pipeline library"
  VERBATIM)
add_custom_target(MLIRTargetWaveDefaultPipeline
  ALL DEPENDS "${_wave_pipeline_staged}")
install(FILES "${_wave_pipeline_src}"
  DESTINATION share/wave-mlir/pipelines
  COMPONENT MLIRTargetWave)

add_mlir_translation_library(MLIRTargetWave
  AMDGPU.cpp
  TranslateRegistration.cpp
  WaveCompileKernels.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Target/Wave

  DEPENDS
  MLIRTargetWaveDefaultPipeline
  MLIRWaveTransformsIncGen

  LINK_COMPONENTS
  AMDGPUAsmParser
  AMDGPUDesc
  AMDGPUInfo
  AMDGPUUtils
  MC
  MCParser
  Support
  TargetParser

  LINK_LIBS PUBLIC
  MLIRArithDialect
  MLIRFuncDialect
  MLIRGPUDialect
  MLIRIR
  MLIRParser
  MLIRROCDLDialect
  MLIRSupport
  MLIRTransformDialect
  MLIRTransformDialectTransforms
  MLIRTranslateLib
  MLIRUBDialect
  MLIRWaveDialect
  MLIRWaveAMDMachineDialect
  MLIRWaveTransforms
  )

target_include_directories(obj.MLIRTargetWave
  PRIVATE
  ${LLVM_MAIN_SRC_DIR}/lib/Target/AMDGPU
  ${LLVM_BINARY_DIR}/lib/Target/AMDGPU
  )

# Path from the binary's directory to the staged pipeline library.
# `runWaveAMDMachinePipeline` resolves this against
# `llvm::sys::fs::getMainExecutable(...)` at runtime; an absolute
# `WAVE_PIPELINES_DIR` env var overrides. Production installs that
# reshape the layout can pass a different default at configure time.
target_compile_definitions(obj.MLIRTargetWave
  PRIVATE
  "WAVE_DEFAULT_PIPELINE_REL=\"../share/wave-mlir/pipelines/pipelines.mlir\""
  "WAVE_DEFAULT_LLD_REL=\"../llvm-install/bin/ld.lld\""
  )
