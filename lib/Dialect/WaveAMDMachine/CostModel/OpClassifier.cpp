//===- OpClassifier.cpp - wave.amd.machine -> SchedClass ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/Operation.h"
#include "llvm/ADT/TypeSwitch.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

#include <algorithm>

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

static bool issuesLdsWaitcnt(Operation *op) {
  return getWaitcntInfo(op).event == WaitcntEvent::Lds;
}

static bool isClusterIdentityRead(Operation *op) {
  return isa<SClusterIdXOp, SClusterIdYOp, SClusterIdZOp,
             SClusterWorkgroupIdXOp, SClusterWorkgroupIdYOp,
             SClusterWorkgroupIdZOp, SClusterWorkgroupMaxIdXOp,
             SClusterWorkgroupMaxIdYOp, SClusterWorkgroupMaxIdZOp>(op);
}

static bool isBarrierClassOp(Operation *op) {
  return isa<BarrierWaitOp, ClusterBarrierOp, SBarrierSignalIsFirstOp,
             SBarrierSignalOp, SBarrierWaitOp, SBarrierOp>(op);
}

static SchedClass classifyMappedOp(Operation *op) {
  // Traits cover no-inst and memory families.
  if (op->hasTrait<traits::NoMachineInst>())
    return SchedClass::NoInst;
  if (op->hasTrait<traits::TensorMemoryOp>())
    return SchedClass::WriteTDM;
  if (op->hasTrait<traits::VMEMLoadOp>() || op->hasTrait<traits::VMEMStoreOp>())
    return SchedClass::WriteVMEM;
  if (issuesLdsWaitcnt(op))
    return SchedClass::WriteLDS;
  if (isClusterIdentityRead(op))
    return SchedClass::WriteSALU;
  if (isBarrierClassOp(op))
    return SchedClass::WriteBarrier;

  // Type-driven dispatch for the rest. Lists are exhaustive over
  // the current dialect; new ops trigger the fallback path which
  // hard-fails in debug builds.
  // clang-format off
  return llvm::TypeSwitch<Operation *, SchedClass>(op)
      .Case<MfmaF32_16x16x16_F16Op, MfmaF32_16x16x16_BF16Op,
            MfmaF32_16x16x32_F16Op, MfmaF32_16x16x32_BF16Op,
            MfmaScaleF32_16x16x128_F4F4Op>(
          [](auto) { return SchedClass::Write4PassMAI; })
      .Case<MfmaF32_32x32x16_F16Op, MfmaF32_32x32x16_BF16Op,
            MfmaScaleF32_32x32x64_F4F4Op>(
          [](auto) { return SchedClass::Write8PassMAI; })
      .Case<WmmaF32_16x16x16_F16Op, WmmaF32_16x16x16_BF16Op,
            WmmaI32_16x16x16_IU8Op>(
          [](auto) { return SchedClass::Write16PassWMMA; })
      .Case<WmmaF32_16x16x32_F16Op, WmmaF32_16x16x32_BF16Op>(
          [](auto) { return SchedClass::WriteXDL2PassWMMA; })
      // Scalar memory (s_load_*).
      .Case<SLoadB32Op, SLoadB64Op, SLoadB128Op>(
          [](auto) { return SchedClass::WriteSMEM; })
      // Structural pseudos: emit no real instruction. Region terminators
      // only carry structured-control operands; actual branches come from
      // codegen lowering, not from this op directly.
      .Case<LabelOp, AfterOp, ContinueIfOp, YieldOp, ExecIfOp, UniformIfOp,
            UniformLoopOp>(
          [](auto) { return SchedClass::NoInst; })
      .Case<SWaitAluOp>(
          [](auto) { return SchedClass::WaitcntPseudo; })
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
      .Case<VNopOp, VCvtF16F32Op, VCvtF32F16Op, VCvtF32U32Op, VCvtU32F32Op,
            VCvtPkRtzF16F32Op, VCvtPkF16F32Op, VCvtPkBF16F32Op,
            VPkAddF16Op, VPkMulF16Op, VPkFmaF16Op, VPkAddF32Op,
            VPkMulF32Op, VPkFmaF32Op, VAdd3U32Op, VBfeU32Op,
            VLshlAddU32Op, VAddLshlU32Op, VAndOrB32Op, VOr3B32Op,
            VXadU32Op, VPermB32Op, VBitOp3B32Op, VMadI32I24Op,
            VMadU32U24Op, VFfbhU32Op, VFfblB32Op, VMulHiU32Op,
            VAshrrevI32Op>(
          [](auto) { return SchedClass::Write32Bit; })
      .Case<VExpF32Op, VRcpF32Op, VRcpIFlagF32Op>(
          [](auto) { return SchedClass::WriteTrans32; })
      // Scalar arithmetic, bitwise, shifts, compares, and moves use SALU.
      .Case<SAddI32Op, SAddM0I32Op, SAddU64Op, SAddU64U32Op, DmaIssueDelayOp,
            SAndB32Op, SAndB64Op,
            SAndn2ExecB32Op, SAndn2ExecB64Op, SAndSaveexecB32Op,
            SAndSaveexecB64Op,
            SCmpEqI32Op, SCmpLgI32Op, SCmpGtI32Op, SCmpGeI32Op, SCmpLtI32Op,
            SCmpLeI32Op, SCmpEqU32Op, SCmpEqU32BarrierSeedOp, SCmpLgU32Op,
            SCmpGtU32Op, SCmpGeU32Op, SCmpLtU32Op, SCmpLeU32Op,
            SCmpEqU64Op, SCmpLgU64Op, SCSelectB32Op,
            SDelayAluOp, SLshlB32Op, SLshlB64Op, SLshrB32Op, SLshrB64Op,
            SAshrI32Op, SAshrI64Op, SMovB32Op, SMovB32TupleOp, SMovB32ValueOp,
            SMovB64ImmOp, SMovExecB64Op, SMovExecLoOp, SMovM0Op, SMovVccB32Op,
            SMulI32Op, SMulHiU32Op, SMulU64Op, SNopOp, SSleepOp, SFf1I32B32Op,
            SFf1I32B64Op,
            SFlbitI32B32Op, SFlbitI32B64Op, SOrB32Op, SOrB64Op,
            SReadVccB32Op,
            SSendmsgDeallocVgprsOp, SSetprioOp, SSetprioIncWgOp,
            SGetregShaderCyclesOp, SGetregHwIdOp, SSetSchedulingModeOp,
            SXorB32Op, SXorB64Op>(
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

unsigned getInstructionIssueCount(Operation *op,
                                  const llvm::AMDGPU::IsaVersion &targetIsa) {
  if (!isa<InstructionIssueOpInterface>(op))
    return 1;
  InstructionIssueOpInterface info = cast<InstructionIssueOpInterface>(op);
  unsigned declaredIssues = info.getInstructionIssueCount(targetIsa);
  if (!isa<TDMLoadOp, TDMStoreOp>(op))
    return std::max(1u, declaredIssues);
  SchedClass cls = classifyOp(op);
  const ArchData &arch = getArchData(targetIsa);
  unsigned llvmIssues =
      isSchedClassSupported(arch, cls) ? getIssueCount(arch, cls) : 1;
  return std::max({1u, declaredIssues, llvmIssues});
}

bool usesMfmaCoissueResource(Operation *op, SchedClass cls,
                             const ArchData &arch) {
  if (!arch.hasMfmaCoissueRestriction)
    return false;
  if (op->hasTrait<traits::MFMAOp>() || cls == SchedClass::WriteTrans32)
    return true;
  return isa<VPkAddF16Op, VPkMulF16Op, VPkFmaF16Op, VPkAddF32Op, VPkMulF32Op,
             VPkFmaF32Op>(op);
}

InstructionCoexecutionModel
getInstructionCoexecutionModel(Operation *op, SchedClass cls,
                               const ArchData &arch) {
  InstructionCoexecutionModel model;
  if (arch.mfmaValuCoexecWindowSlots == 0 ||
      arch.mfmaValuCoexecProducerBurst == 0)
    return model;

  unsigned issues = getInstructionIssueCount(op, arch.isa);
  unsigned release =
      std::max<unsigned>(issues, std::max(1, getResourceCycles(arch, cls)));
  if (op->hasTrait<traits::MFMAOp>()) {
    unsigned window = static_cast<unsigned>(arch.mfmaValuCoexecWindowSlots);
    if (release <= window)
      return model;
    model.openedSlots = window;
    model.producerBurst =
        static_cast<unsigned>(arch.mfmaValuCoexecProducerBurst);
    model.waitsForWindow = true;
    return model;
  }
  // TRANS keeps its native resource duration; its separate model cost describes
  // how much of an MFMA coexecution window the issued work occupies.
  if (cls == SchedClass::WriteTrans32 &&
      arch.mfmaTransCoexecSlotsPerIssue != 0) {
    model.filledSlots =
        release * static_cast<unsigned>(arch.mfmaTransCoexecSlotsPerIssue);
    return model;
  }
  if (usesMfmaCoissueResource(op, cls, arch) || !op->hasTrait<traits::VALUOp>())
    return model;
  model.filledSlots = release;
  return model;
}

bool hasSchedClassMapping(Operation *op) {
  return classifyMappedOp(op) != SchedClass::NumSchedClasses;
}

} // namespace mlir::waveamdmachine
