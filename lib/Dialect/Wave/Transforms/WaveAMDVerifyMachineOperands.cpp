//===- WaveAMDVerifyMachineOperands.cpp - Machine operand legality --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInstrInfo.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/TargetParser/TargetParser.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDVERIFYMACHINEOPERANDS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static LogicalResult
verifyMachineOperandOp(Operation *op,
                       const llvm::AMDGPU::IsaVersion &isaVersion,
                       StringRef targetChip) {
  waveamdmachine::OperandLegalityOpInterface legality =
      dyn_cast<waveamdmachine::OperandLegalityOpInterface>(op);
  if (!legality)
    return success();

  if (isa<waveamdmachine::VMulLoU32Op>(op))
    return waveamdmachine::requireVMulU32OperandLegality(
        op, "v_mul_lo_u32", isaVersion, targetChip,
        waveamdmachine::isSamePhysicalReg);
  if (isa<waveamdmachine::VMulHiU32Op>(op))
    return waveamdmachine::requireVMulU32OperandLegality(
        op, "v_mul_hi_u32", isaVersion, targetChip,
        waveamdmachine::isSamePhysicalReg);

  return waveamdmachine::requireOperandLegality(
      op, op->getName().stripDialect(), legality.getOperandLegality(),
      isaVersion, targetChip, waveamdmachine::isSamePhysicalReg);
}

struct WaveAMDVerifyMachineOperandsPass
    : public wave::impl::WaveAMDVerifyMachineOperandsBase<
          WaveAMDVerifyMachineOperandsPass> {
  void runOnOperation() override {
    ModuleOp root = getOperation();
    FailureOr<waveamdmachine::AMDGPUTarget> target =
        waveamdmachine::getAMDGPUTarget(root,
                                        "waveamd-verify-machine-operands");
    if (failed(target))
      return signalPassFailure();

    llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(target->chip);
    if (isa.Major == 0) {
      root.emitError("unsupported AMDGPU target: ")
          << target->triple << "--" << target->chip;
      return signalPassFailure();
    }

    WalkResult result = root.walk([&](Operation *op) {
      if (failed(verifyMachineOperandOp(op, isa, target->chip)))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if (result.wasInterrupted())
      signalPassFailure();
  }
};

} // namespace
