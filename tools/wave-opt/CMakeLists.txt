set(LLVM_LINK_COMPONENTS
  Support
)

add_llvm_executable(wave-opt wave-opt.cpp)
wave_strip_release_executable(wave-opt)

llvm_update_compile_flags(wave-opt)
target_link_libraries(wave-opt PRIVATE
  MLIRArithDialect
  MLIRArithToLLVM
  MLIRArithTransforms
  MLIRControlFlowDialect
  MLIRControlFlowToLLVM
  MLIRConvertToLLVMPass
  MLIRFuncDialect
  MLIRFuncInlinerExtension
  MLIRFuncToLLVM
  MLIRGPUDialect
  MLIRGPUToGPURuntimeTransforms
  MLIRLinalgTransformOps
  MLIRLLVMDialect
  MLIRLLVMIRTransforms
  MLIRMemRefDialect
  MLIRMemRefToLLVM
  MLIROptLib
  MLIRReconcileUnrealizedCasts
  MLIRROCDLDialect
  MLIRSCFDialect
  MLIRSCFToControlFlow
  MLIRTargetWave
  MLIRTransformDialect
  MLIRTransformDialectTransforms
  MLIRTransforms
  MLIRUBDialect
  MLIRUBToLLVM
  MLIRWaveAMDDialect
  MLIRWaveAMDMachineDialect
  MLIRWaveDialect
  MLIRWaveMetaDialect
  MLIRWaveToLLVM
  MLIRWaveTransforms
)

mlir_check_all_link_libraries(wave-opt)
