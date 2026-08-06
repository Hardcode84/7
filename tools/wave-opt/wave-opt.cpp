//===- wave-opt.cpp - Wave optimizer driver -----------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/ArithToLLVM/ArithToLLVM.h"
#include "mlir/Conversion/ControlFlowToLLVM/ControlFlowToLLVM.h"
#include "mlir/Conversion/FuncToLLVM/ConvertFuncToLLVM.h"
#include "mlir/Conversion/GPUCommon/GPUToLLVM.h"
#include "mlir/Conversion/MemRefToLLVM/MemRefToLLVM.h"
#include "mlir/Conversion/Passes.h"
#include "mlir/Conversion/UBToLLVM/UBToLLVM.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Arith/Transforms/Passes.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"
#include "mlir/Dialect/Func/Extensions/InlinerExtension.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/GPU/IR/GPUDialect.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/LLVMIR/ROCDLDialect.h"
#include "mlir/Dialect/LLVMIR/Transforms/InlinerInterfaceImpl.h"
#include "mlir/Dialect/Linalg/TransformOps/LinalgTransformOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Transform/IR/TransformDialect.h"
#include "mlir/Dialect/Transform/Transforms/Passes.h"
#include "mlir/Dialect/UB/IR/UBOps.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "mlir/Transforms/Passes.h"

#include "mlir/Conversion/WaveToLLVM/WaveToLLVM.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveMeta.h"
#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"

namespace {

class WaveOptTransformExtension
    : public mlir::transform::TransformDialectExtension<
          WaveOptTransformExtension> {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(WaveOptTransformExtension)

  using Base::Base;

  void init() { registerTransformOps<mlir::transform::MatchOp>(); }
};

} // namespace

int main(int argc, char **argv) {
  mlir::DialectRegistry registry;
  registry.insert<mlir::arith::ArithDialect, mlir::cf::ControlFlowDialect,
                  mlir::func::FuncDialect, mlir::gpu::GPUDialect,
                  mlir::LLVM::LLVMDialect, mlir::ROCDL::ROCDLDialect,
                  mlir::memref::MemRefDialect, mlir::scf::SCFDialect,
                  mlir::transform::TransformDialect, mlir::ub::UBDialect,
                  mlir::wave::WaveDialect, mlir::waveamd::WaveAMDDialect,
                  mlir::wavemeta::WaveMetaDialect,
                  mlir::waveamdmachine::WaveAMDMachineDialect>();
  mlir::arith::registerConvertArithToLLVMInterface(registry);
  mlir::cf::registerConvertControlFlowToLLVMInterface(registry);
  mlir::registerConvertFuncToLLVMInterface(registry);
  mlir::gpu::registerConvertGpuToLLVMInterface(registry);
  mlir::registerConvertMemRefToLLVMInterface(registry);
  mlir::ub::registerConvertUBToLLVMInterface(registry);
  registry.addExtensions<WaveOptTransformExtension>();
  mlir::func::registerInlinerExtension(registry);
  mlir::LLVM::registerInlinerInterface(registry);
  mlir::wave::registerConvertWaveToLLVMInterface(registry);
  registry.addExtension(
      +[](mlir::MLIRContext *ctx, mlir::transform::TransformDialect *dialect) {
        (void)dialect;
        ctx->getOrLoadDialect<mlir::wave::WaveDialect>();
        ctx->getOrLoadDialect<mlir::waveamd::WaveAMDDialect>();
        ctx->getOrLoadDialect<mlir::wavemeta::WaveMetaDialect>();
        ctx->getOrLoadDialect<mlir::waveamdmachine::WaveAMDMachineDialect>();
        ctx->getOrLoadDialect<mlir::ROCDL::ROCDLDialect>();
      });
  mlir::registerCanonicalizerPass();
  mlir::registerCSEPass();
  mlir::registerLoopInvariantCodeMotionPass();
  mlir::registerSymbolDCEPass();
  mlir::arith::registerArithIntRangeOptsPass();
  mlir::registerConvertToLLVMPass();
  mlir::registerGpuToLLVMConversionPass();
  mlir::registerReconcileUnrealizedCastsPass();
  mlir::registerSCFToControlFlowPass();
  mlir::transform::registerInterpreterPass();
  mlir::transform::registerPreloadLibraryPass();
  mlir::wave::registerWavePasses();

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Wave optimizer driver\n", registry));
}
