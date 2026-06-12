add_mlir_dialect_library(MLIRWaveTransforms
  WaveAMDABILowering.cpp
  WaveAMDDecomposeMemTuples.cpp
  WaveAMDFormFusedInt.cpp
  WaveAMDHardwareResources.cpp
  WaveAMDHazardWaits.cpp
  WaveAMDLinearizeExecIf.cpp
  WaveAMDMachine.cpp
  WaveAMDMachineIndexExpr.cpp
  WaveAMDMachineLoadStore.cpp
  WaveAMDMachineLoopCarryPlan.cpp
  WaveAMDMachineScfFor.cpp
  WaveAMDMachineSchedule.cpp
  WaveAMDMachineScheduleBeam.cpp
  WaveAMDMachineScheduleReport.cpp
  WaveAMDMachineScheduleSupport.cpp
  WaveAMDMachineWaitcnt.cpp
  WaveAMDMetadata.cpp
  WaveAMDNarrowWideInt.cpp
  WaveAMDPreserveHardwareRegs.cpp
  WaveAMDRegAlloc.cpp
  WaveAMDRegAllocBankPromotion.cpp
  WaveAMDRegAllocLDS.cpp
  WaveAMDRegAllocPrep.cpp
  WaveAMDRegAllocVerification.cpp
  WaveAMDRegisterLimits.cpp
  WaveAMDRegLiveIntervals.cpp
  WaveAMDRegPressureRelief.cpp
  WaveAMDResourceInfo.cpp
  WaveAttachGPUBinary.cpp
  WaveCoalesceMemory.cpp
  WaveCombinePointerOffsets.cpp
  WaveExtractLoopStrides.cpp
  WaveFormPackedMath.cpp
  WaveGenerateIndexExprs.cpp
  WaveMetaSpecialize.cpp
  WaveNormalizePointerOffsets.cpp
  WaveSetTargetAttr.cpp
  WaveSimplifyIndexExprs.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Wave

  DEPENDS
  MLIRWaveTransformsIncGen

  LINK_COMPONENTS

  AMDGPUUtils
  TargetParser

  LINK_LIBS PUBLIC
  MLIRAnalysis
  MLIRArithDialect
  MLIRFuncDialect
  MLIRFuncTransforms
  MLIRGPUDialect
  MLIRIR
  MLIRPass
  MLIRROCDLDialect
  MLIRSCFDialect
  MLIRSCFTransforms
  MLIRTransformUtils
  MLIRUBDialect
  MLIRWaveAMDDialect
  MLIRWaveAMDMachineCostModel
  MLIRWaveAMDMachineDialect
  MLIRWaveDialect
  MLIRWaveMetaDialect
  )

target_include_directories(obj.MLIRWaveTransforms
  PRIVATE
  ${LLVM_MAIN_SRC_DIR}/lib/Target/AMDGPU
  ${LLVM_BINARY_DIR}/lib/Target/AMDGPU
  )
