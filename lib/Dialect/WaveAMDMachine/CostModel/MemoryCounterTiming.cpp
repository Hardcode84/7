//===- MemoryCounterTiming.cpp - Waitcnt counter timing ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/CalibrationData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/Operation.h"
#include "llvm/Support/ErrorHandling.h"

namespace mlir::waveamdmachine {

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

static bool isLDSIssuer(Operation *op) {
  return isa<DsLoadB32Op, DsLoadB64Op, DsLoadB96Op, DsLoadB128Op,
             DsLoadTupleB32Op, DsStoreB32Op, DsStoreB64Op, DsStoreB96Op,
             DsStoreB128Op, DsStoreTupleB32Op>(op);
}

static bool isLDSLoad(Operation *op) {
  return isa<DsLoadB32Op, DsLoadB64Op, DsLoadB96Op, DsLoadB128Op,
             DsLoadTupleB32Op>(op);
}

static bool isSMEMLoad(Operation *op) {
  return isa<SLoadB32Op, SLoadB64Op, SLoadB128Op>(op);
}

static bool hasRegisterResult(Operation *op) {
  for (Value result : op->getResults())
    if (!isa<MemTokenType>(result.getType()))
      return true;
  return false;
}

static int overrideOrDefault(int overrideLatency, int defaultLatency) {
  return overrideLatency >= 0 ? overrideLatency : defaultLatency;
}

static int getConfiguredLatency(const ArchData &arch, SchedClass cls,
                                const CalibrationData *calibration) {
  if (!calibration)
    return getLatency(arch, cls);
  return getCalibratedLatency(arch, cls, *calibration);
}

} // namespace

MemoryCounterKind getMemoryCounterKind(Operation *op) {
  if (op->hasTrait<traits::VMEMLoadOp>())
    return MemoryCounterKind::Vmem;
  if (op->hasTrait<traits::VMEMStoreOp>())
    return MemoryCounterKind::Vscnt;
  if (op->hasTrait<traits::SMEMLoadOp>() || isLDSIssuer(op))
    return MemoryCounterKind::Lgkm;
  return MemoryCounterKind::None;
}

int getMemoryCounterLatency(const ArchData &arch, Operation *op,
                            const MemoryCounterLatencies &overrides,
                            const CalibrationData *calibration) {
  SchedClass cls = classifyOp(op);
  int defaultLatency = getConfiguredLatency(arch, cls, calibration);
  if (op->hasTrait<traits::VMEMLoadOp>())
    return overrideOrDefault(overrides.vmemLoad, defaultLatency);
  if (op->hasTrait<traits::VMEMStoreOp>())
    return overrideOrDefault(overrides.vmemStore, defaultLatency);
  if (isLDSIssuer(op))
    return overrideOrDefault(overrides.lds, defaultLatency);
  if (op->hasTrait<traits::SMEMLoadOp>())
    return overrideOrDefault(overrides.smemLoad, defaultLatency);
  llvm_unreachable("op has no memory counter timing");
}

bool hasMemoryValueLatency(Operation *op) {
  if (!hasRegisterResult(op))
    return false;
  return op->hasTrait<traits::VMEMLoadOp>() || isLDSLoad(op) || isSMEMLoad(op);
}

int getMemoryValueLatency(const ArchData &arch, Operation *op,
                          const MemoryValueLatencies &overrides,
                          const CalibrationData *calibration) {
  SchedClass cls = classifyOp(op);
  int defaultLatency = getConfiguredLatency(arch, cls, calibration);
  if (op->hasTrait<traits::VMEMLoadOp>())
    return overrideOrDefault(overrides.vmemLoad, defaultLatency);
  if (isLDSLoad(op))
    return overrideOrDefault(overrides.lds, defaultLatency);
  if (isSMEMLoad(op))
    return overrideOrDefault(overrides.smemLoad, defaultLatency);
  llvm_unreachable("op has no memory value timing");
}

} // namespace mlir::waveamdmachine
