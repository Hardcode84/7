add_mlir_translation_library(MLIRTargetWave
  AMDGPU.cpp
  TranslateRegistration.cpp
  WaveCompileKernels.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Target/Wave

  DEPENDS
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
  MLIRROCDLDialect
  MLIRROCDLTarget
  MLIRSupport
  MLIRTranslateLib
  MLIRWaveDialect
  MLIRWaveMachineDialect
  MLIRWaveTransforms
  lldCommon
  lldELF
  )

target_include_directories(obj.MLIRTargetWave
  PRIVATE
  ${LLVM_MAIN_SRC_DIR}/lib/Target/AMDGPU
  ${LLVM_BINARY_DIR}/lib/Target/AMDGPU
  )
