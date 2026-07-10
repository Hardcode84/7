//===- OpClassifier.cpp - wave.amd.machine -> SchedClass ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/Operation.h"
#include "llvm/ADT/TypeSwitch.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

namespace mlir::waveamdmachine {

namespace traits = ::mlir::OpTrait::waveamdmachine;

// Default arm of the TypeSwitch: VALU trait catches the v_* tail
// (cmp / mov / readfirstlane / workitem / mbcnt). Anything else
// hard-fails in debug builds and warns + falls back in release.
static SchedClass fallbackClassify(Operation *op) {
  if (op->hasTrait<traits::VALUOp>())
    return SchedClass::Write32Bit;
#ifndef NDEBUG
  op->emitError("classifyOp: unmapped wave.amd.machine op: ")
      << op->getName().stripDialect();
  llvm_unreachable("classifyOp: unmapped op");
#else
  llvm::errs() << "waveamdmachine: unmapped op '"
               << op->getName().stripDialect()
               << "', falling back to Write32Bit\n";
  return SchedClass::Write32Bit;
#endif
}

static WaitcntInfo getWaitcntInfo(Operation *op) {
  if (WaitcntInfoOpInterface info = dyn_cast<WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo();
  return {};
}

static bool issuesLdsWaitcnt(Operation *op) {
  return getWaitcntInfo(op).event == WaitcntEvent::Lds;
}

static SchedClass classifyMappedOp(Operation *op) {
  // Trait pre-filter for two large categories: ops that do not advance
  // instruction-distance hazards and the full VMEM load/store family.
  if (op->hasTrait<traits::NoMachineInst>())
    return SchedClass::NoInst;
  if (op->hasTrait<traits::VMEMLoadOp>() || op->hasTrait<traits::VMEMStoreOp>())
    return SchedClass::WriteVMEM;
  if (issuesLdsWaitcnt(op))
    return SchedClass::WriteLDS;

  // Type-driven dispatch for the rest. Lists are exhaustive over
  // the current dialect; new ops trigger the fallback path which
  // hard-fails in debug builds.
  // clang-format off
  return llvm::TypeSwitch<Operation *, SchedClass>(op)
      .Case<MfmaF32_16x16x16_F16Op, MfmaF32_16x16x16_BF16Op,
            MfmaF32_16x16x32_F16Op, MfmaF32_16x16x32_BF16Op,
            MfmaScaleF32_16x16x128_F4F4Op>(
          [](auto) { return SchedClass::Write4PassMAI; })
      .Case<MfmaF32_32x32x16_F16Op, MfmaF32_32x32x16_BF16Op>(
          [](auto) { return SchedClass::Write8PassMAI; })
      .Case<WmmaF32_16x16x16_F16Op, WmmaF32_16x16x16_BF16Op,
            WmmaI32_16x16x16_IU8Op>(
          [](auto) { return SchedClass::Write16PassWMMA; })
      // Scalar memory (s_load_*).
      .Case<SLoadB32Op, SLoadB64Op, SLoadB128Op>(
          [](auto) { return SchedClass::WriteSMEM; })
      // Structural pseudos: emit no real instruction. Region terminators
      // only carry structured-control operands; actual branches come from
      // codegen lowering, not from this op directly.
      .Case<LabelOp, AfterOp, ContinueIfOp, YieldOp, UniformIfOp,
            UniformLoopOp>(
          [](auto) { return SchedClass::NoInst; })
      // Barrier.
      .Case<BarrierWaitOp, SBarrierOp>(
          [](auto) { return SchedClass::WriteBarrier; })
      // Branches / control flow / endpgm. UniformLoopOp + ContinueIfOp
      // are NoInst above -- region-structural, real branches come from
      // codegen lowering. Loop body cost is dataflow-handled via
      // RegionBranchOpInterface; a static walk charges the loop op 0.
      .Case<SCBranchScc0Op, SCBranchScc1Op, SCBranchExeczOp,
            SSetpcB64Op, SEndpgmOp>(
          [](auto) { return SchedClass::WriteBranch; })
      // 64-bit VALU expansions (charged differently from 32-bit).
      .Case<VAddU64Op, VAddU64U32Op, VMovB64TupleOp, VMulU64Op, VXorB64Op,
            VLshlrevB64Op, VLshrrevB64Op, VAshrrevI64Op>(
          [](auto) { return SchedClass::Write64Bit; })
      .Case<CopyTupleOp>([](CopyTupleOp op) {
        auto type = cast<RegType>(op.getResult().getType());
        if (type.getRegClass() == RegClass::SGPR)
          return SchedClass::WriteSALU;
        return SchedClass::Write32Bit;
      })
      .Case<VFmaF32Op>(
          [](auto) { return SchedClass::WriteFloatFMA; })
      .Case<VCvtF16F32Op, VCvtF32F16Op, VCvtF32U32Op, VCvtU32F32Op,
            VCvtPkRtzF16F32Op, VCvtPkF16F32Op, VCvtPkBF16F32Op,
            VPkAddF16Op, VPkMulF16Op, VPkFmaF16Op, VPkAddF32Op,
            VPkMulF32Op, VPkFmaF32Op, VAdd3U32Op,
            VLshlAddU32Op, VAddLshlU32Op, VAndOrB32Op, VOr3B32Op,
            VXadU32Op, VPermB32Op, VBitOp3B32Op, VMadI32I24Op,
            VMadU32U24Op, VFfbhU32Op, VFfblB32Op, VMulHiU32Op,
            VAshrrevI32Op>(
          [](auto) { return SchedClass::Write32Bit; })
      .Case<VExpF32Op, VRcpF32Op, VRcpIFlagF32Op>(
          [](auto) { return SchedClass::WriteTrans32; })
      // Scalar ALU pipe: arithmetic, shifts, compares, moves, exec
      // manipulation, nop, delay_alu. Scalar 64-bit add/mul/shl
      // still run on the SALU pipe.
      .Case<SAddI32Op, SAddM0I32Op, SAddU64Op, SAddU64U32Op, SAndB32Op,
            SAndn2ExecB32Op, SAndn2ExecB64Op, SAndSaveexecB32Op,
            SAndSaveexecB64Op,
            SCmpEqI32Op, SCmpLgI32Op, SCmpGtI32Op, SCmpGeI32Op, SCmpLtI32Op,
            SCmpLeI32Op, SCmpEqU32Op, SCmpLgU32Op, SCmpGtU32Op, SCmpGeU32Op,
            SCmpLtU32Op, SCmpLeU32Op, SCSelectB32Op, SDelayAluOp, SLshlB32Op,
            SLshlB64Op, SLshrB32Op, SLshrB64Op, SAshrI32Op, SAshrI64Op,
            SMovB32Op, SMovB32TupleOp, SMovB32ValueOp, SMovB64ImmOp,
            SMovExecB64Op, SMovExecLoOp, SMovM0Op, SMovVccB32Op, SMulI32Op,
            SMulHiU32Op, SMulU64Op, SNopOp, SSleepOp, SFf1I32B32Op,
            SFf1I32B64Op,
            SFlbitI32B32Op, SFlbitI32B64Op, SOrB32Op, SReadVccB32Op,
            SSetprioOp, SGetregShaderCyclesOp, SXorB32Op, SXorB64Op>(
          [](auto) { return SchedClass::WriteSALU; })
      .Default([](Operation *op) {
        if (op->hasTrait<traits::VALUOp>())
          return SchedClass::Write32Bit;
        return SchedClass::NumSchedClasses;
      });
  // clang-format on
}

SchedClass classifyOp(Operation *op) {
  SchedClass cls = classifyMappedOp(op);
  if (cls != SchedClass::NumSchedClasses)
    return cls;
  return fallbackClassify(op);
}

bool hasSchedClassMapping(Operation *op) {
  return classifyMappedOp(op) != SchedClass::NumSchedClasses;
}

} // namespace mlir::waveamdmachine
