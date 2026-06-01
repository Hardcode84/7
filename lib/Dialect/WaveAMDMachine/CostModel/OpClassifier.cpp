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

SchedClass classifyOp(Operation *op) {
  // Trait pre-filter for two large categories: anything that emits
  // no asm (pseudos, preloaded reg projections, s_waitcnt) and the
  // full VMEM load/store family.
  if (op->hasTrait<traits::NoMachineInst>())
    return SchedClass::NoInst;
  if (op->hasTrait<traits::VMEMLoadOp>() || op->hasTrait<traits::VMEMStoreOp>())
    return SchedClass::WriteVMEM;

  // Type-driven dispatch for the rest. Lists are exhaustive over
  // the current dialect; new ops trigger the fallback path which
  // hard-fails in debug builds.
  // clang-format off
  return llvm::TypeSwitch<Operation *, SchedClass>(op)
      // MFMA. Both 16x16x{16,32} map to Write4PassMAI per LLVM
      // SISchedule.td on gfx942/gfx950.
      .Case<MfmaF32_16x16x16_F16Op, MfmaF32_16x16x32_F16Op>(
          [](auto) { return SchedClass::Write4PassMAI; })
      .Case<WmmaF32_16x16x16_F16Op, WmmaI32_16x16x16_IU8Op>(
          [](auto) { return SchedClass::Write16PassWMMA; })
      // LDS (ds_* family).
      .Case<DsLoadB16Op, DsLoadB32Op, DsLoadB64Op, DsLoadB96Op, DsLoadB128Op,
            DsLoadTupleB32Op, DsStoreB16Op, DsStoreB32Op, DsStoreB64Op,
            DsStoreB96Op, DsStoreB128Op, DsStoreTupleB32Op>(
          [](auto) { return SchedClass::WriteLDS; })
      // Scalar memory (s_load_*).
      .Case<SLoadB32Op, SLoadB64Op, SLoadB128Op>(
          [](auto) { return SchedClass::WriteSMEM; })
      // Structural pseudos: emit no real instruction. ContinueIfOp
      // is a region terminator -- the actual branch comes from
      // codegen lowering, not from this op directly.
      .Case<LabelOp, MakeBufferRsrcOp, AfterOp, ContinueIfOp, UniformLoopOp>(
          [](auto) { return SchedClass::NoInst; })
      // Barrier.
      .Case<SBarrierOp>(
          [](auto) { return SchedClass::WriteBarrier; })
      // Branches / control flow / endpgm. UniformLoopOp + ContinueIfOp
      // are NoInst above -- region-structural, real branches come from
      // codegen lowering. Loop body cost is dataflow-handled via
      // RegionBranchOpInterface; a static walk charges the loop op 0.
      .Case<SCBranchScc0Op, SCBranchScc1Op, SCBranchExeczOp,
            SSetpcB64Op, SEndpgmOp>(
          [](auto) { return SchedClass::WriteBranch; })
      // 64-bit VALU expansions (charged differently from 32-bit).
      .Case<VAddU64Op, VMulU64Op, VLshlrevB64Op>(
          [](auto) { return SchedClass::Write64Bit; })
      .Case<VCvtF16F32Op, VCvtF32F16Op, VCvtPkRtzF16F32Op, VPkAddF16Op,
            VPkMulF16Op, VPkFmaF16Op, VAdd3U32Op, VLshlAddU32Op,
            VAddLshlU32Op, VAndOrB32Op, VOr3B32Op, VXadU32Op, VMadI32I24Op,
            VMadU32U24Op>(
          [](auto) { return SchedClass::Write32Bit; })
      .Case<VExpF32Op, VRcpF32Op>(
          [](auto) { return SchedClass::WriteTrans32; })
      // Scalar ALU pipe: arithmetic, shifts, compares, moves, exec
      // manipulation, nop, delay_alu. Scalar 64-bit add/mul/shl
      // still run on the SALU pipe.
      .Case<SAddI32Op, SAddU64Op, SAddU64U32Op, SAndB32Op, SAndn2ExecB32Op,
            SAndSaveexecB32Op, SCmpLgU32Op, SCmpLtI32Op, SCSelectB32Op,
            SDelayAluOp, SLshlB32Op, SLshlB64Op, SLshrB32Op, SMovB32Op,
            SMovB32TupleOp, SMovB32ValueOp, SMovB64ImmOp, SMovExecLoOp,
            SMovM0Op, SMovVccB32Op, SMulI32Op, SMulU64Op, SNopOp,
            SReadVccB32Op, SSetprioOp, SGetregShaderCyclesOp, SXorB32Op>(
          [](auto) { return SchedClass::WriteSALU; })
      .Default(fallbackClassify);
  // clang-format on
}

} // namespace mlir::waveamdmachine
