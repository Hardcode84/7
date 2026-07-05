//===- WaveAMDMachineScheduleEligibility.h ----------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEELIGIBILITY_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEELIGIBILITY_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/Operation.h"

#include <array>

namespace mlir::wave {

static inline bool isWaveAMDMachineOpForScheduling(Operation *op) {
  return op->getName().getDialectNamespace() ==
         waveamdmachine::WaveAMDMachineDialect::getDialectNamespace();
}

static inline bool isSupportedSchedulerPseudo(Operation *op) {
  return isa<
      waveamdmachine::ArgOp, waveamdmachine::KernargPreloadOp,
      waveamdmachine::UninitOp, waveamdmachine::ImmOp, waveamdmachine::TokenOp,
      waveamdmachine::TokenJoinOp, waveamdmachine::AfterOp,
      waveamdmachine::BarrierInitOp, waveamdmachine::SWorkgroupIdXOp,
      waveamdmachine::SWorkgroupIdYOp, waveamdmachine::SWorkgroupIdZOp,
      waveamdmachine::VWorkitemIdXOp, waveamdmachine::TupleToElementsOp,
      waveamdmachine::TupleFromElementsOp, waveamdmachine::UpdateTupleOp>(op);
}

static inline bool isSupportedSchedulerSALU(Operation *op) {
  return isa<waveamdmachine::SAddI32Op, waveamdmachine::SAddM0I32Op,
             waveamdmachine::SAddU64Op, waveamdmachine::SAddU64U32Op,
             waveamdmachine::SAndB32Op, waveamdmachine::SAndn2ExecB32Op,
             waveamdmachine::SAndn2ExecB64Op, waveamdmachine::SAndSaveexecB32Op,
             waveamdmachine::SAndSaveexecB64Op, waveamdmachine::SCmpEqI32Op,
             waveamdmachine::SCmpLgI32Op, waveamdmachine::SCmpGtI32Op,
             waveamdmachine::SCmpGeI32Op, waveamdmachine::SCmpLtI32Op,
             waveamdmachine::SCmpLeI32Op, waveamdmachine::SCmpEqU32Op,
             waveamdmachine::SCmpLgU32Op, waveamdmachine::SCmpGtU32Op,
             waveamdmachine::SCmpGeU32Op, waveamdmachine::SCmpLtU32Op,
             waveamdmachine::SCmpLeU32Op, waveamdmachine::SCSelectB32Op,
             waveamdmachine::SLshlB32Op, waveamdmachine::SLshlB64Op,
             waveamdmachine::SLshrB32Op, waveamdmachine::SLshrB64Op,
             waveamdmachine::SAshrI32Op, waveamdmachine::SAshrI64Op,
             waveamdmachine::SMovB32Op, waveamdmachine::SMovB32TupleOp,
             waveamdmachine::SMovB32ValueOp, waveamdmachine::SMovB64ImmOp,
             waveamdmachine::SMovExecB64Op, waveamdmachine::SMovExecLoOp,
             waveamdmachine::SMovM0Op, waveamdmachine::SMovVccB32Op,
             waveamdmachine::SMulI32Op, waveamdmachine::SMulHiU32Op,
             waveamdmachine::SMulU64Op, waveamdmachine::SFf1I32B32Op,
             waveamdmachine::SFf1I32B64Op, waveamdmachine::SFlbitI32B32Op,
             waveamdmachine::SFlbitI32B64Op, waveamdmachine::SOrB32Op,
             waveamdmachine::SReadVccB32Op,
             waveamdmachine::SGetregShaderCyclesOp, waveamdmachine::SXorB32Op,
             waveamdmachine::SXorB64Op, waveamdmachine::CopyTupleOp>(op);
}

static inline bool isSupportedSchedulerClass(waveamdmachine::SchedClass cls) {
  using waveamdmachine::SchedClass;
  static constexpr std::array<SchedClass, 20> kSupportedClasses = {
      SchedClass::Write32Bit,        SchedClass::Write64Bit,
      SchedClass::WriteFloatFMA,     SchedClass::WriteDouble,
      SchedClass::WriteTrans32,      SchedClass::WriteSFPU,
      SchedClass::Write2PassMAI,     SchedClass::Write4PassMAI,
      SchedClass::Write8PassMAI,     SchedClass::Write16PassMAI,
      SchedClass::WriteXDL2PassWMMA, SchedClass::WriteXDL4PassWMMA,
      SchedClass::Write4PassWMMA,    SchedClass::Write8PassWMMA,
      SchedClass::Write16PassWMMA,   SchedClass::WriteVMEM,
      SchedClass::WriteSMEM,         SchedClass::WriteLDS,
      SchedClass::WriteBarrier,      SchedClass::WriteExport};
  for (SchedClass supported : kSupportedClasses)
    if (cls == supported)
      return true;
  return false;
}

static inline bool isSupportedSchedulerRegionMember(Operation *op) {
  if (!isWaveAMDMachineOpForScheduling(op))
    return false;
  if (op->getNumRegions() != 0 || op->hasTrait<OpTrait::IsTerminator>())
    return false;
  if (!waveamdmachine::hasSchedClassMapping(op))
    return false;

  waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
  switch (cls) {
  case waveamdmachine::SchedClass::NoInst:
    return isSupportedSchedulerPseudo(op);
  case waveamdmachine::SchedClass::WriteSALU:
    return isSupportedSchedulerSALU(op);
  default:
    return isSupportedSchedulerClass(cls);
  }
}

} // namespace mlir::wave

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEELIGIBILITY_H
