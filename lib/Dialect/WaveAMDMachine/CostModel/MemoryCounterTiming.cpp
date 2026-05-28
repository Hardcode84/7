//===- MemoryCounterTiming.cpp - Waitcnt counter timing ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
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

static int overrideOrDefault(int overrideLatency, int defaultLatency) {
  return overrideLatency >= 0 ? overrideLatency : defaultLatency;
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
                            const MemoryCounterLatencies &overrides) {
  SchedClass cls = classifyOp(op);
  int defaultLatency = getLatency(arch, cls);
  if (op->hasTrait<traits::VMEMLoadOp>())
    return overrideOrDefault(overrides.vmemLoad, defaultLatency);
  if (op->hasTrait<traits::VMEMStoreOp>())
    return overrideOrDefault(overrides.vmemStore, defaultLatency);
  if (op->hasTrait<traits::SMEMLoadOp>())
    return overrideOrDefault(overrides.smemLoad, defaultLatency);
  if (isLDSIssuer(op))
    return overrideOrDefault(overrides.lds, defaultLatency);
  llvm_unreachable("op has no memory counter timing");
}

} // namespace mlir::waveamdmachine
