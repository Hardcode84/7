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

static WaitcntInfo getWaitcntInfo(Operation *op) {
  if (auto info = dyn_cast<WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo();
  return {};
}

static bool isLDSCounterIssuer(Operation *op) {
  return getWaitcntInfo(op).event == WaitcntEvent::Lds;
}

static bool hasRegisterResult(Operation *op) {
  for (Value result : op->getResults())
    if (!isa<MemTokenType>(result.getType()))
      return true;
  return false;
}

static bool isLDSLoad(Operation *op) {
  WaitcntInfo info = getWaitcntInfo(op);
  return info.event == WaitcntEvent::Lds && hasRegisterResult(op);
}

static bool isSMEMLoad(Operation *op) {
  return getWaitcntInfo(op).event == WaitcntEvent::Smem;
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

static MemoryIssueKind getVmemIssueKind(WaitcntCounter counter) {
  if (counter == WaitcntCounter::Vscnt)
    return MemoryIssueKind::VmemStore;
  return MemoryIssueKind::VmemLoad;
}

static MemoryIssueKind getWaitcntIssueKind(WaitcntInfo info) {
  switch (info.event) {
  case WaitcntEvent::Vmem:
  case WaitcntEvent::Flat:
    return getVmemIssueKind(info.counter);
  case WaitcntEvent::VmemStore:
    return MemoryIssueKind::VmemStore;
  case WaitcntEvent::Lds:
  case WaitcntEvent::Gds:
  case WaitcntEvent::Message:
    return MemoryIssueKind::Lds;
  case WaitcntEvent::Smem:
    return MemoryIssueKind::Smem;
  case WaitcntEvent::None:
    return MemoryIssueKind::None;
  }
  llvm_unreachable("bad waitcnt event");
}

} // namespace

MemoryCounterKind getMemoryCounterKind(Operation *op) {
  switch (getWaitcntInfo(op).counter) {
  case WaitcntCounter::Vmem:
    return MemoryCounterKind::Vmem;
  case WaitcntCounter::Lgkm:
    return MemoryCounterKind::Lgkm;
  case WaitcntCounter::Vscnt:
    return MemoryCounterKind::Vscnt;
  case WaitcntCounter::None:
    break;
  }
  return MemoryCounterKind::None;
}

MemoryIssueKind getMemoryIssueKind(Operation *op) {
  if (op->hasTrait<traits::LDSDmaOp>() && op->hasTrait<traits::VMEMLoadOp>())
    return MemoryIssueKind::VmemLoadLds;
  return getWaitcntIssueKind(getWaitcntInfo(op));
}

bool isLdsDmaIssuer(Operation *op) { return op->hasTrait<traits::LDSDmaOp>(); }

int getMemoryCounterLatency(const ArchData &arch, Operation *op,
                            const MemoryCounterLatencies &overrides,
                            const CalibrationData *calibration) {
  SchedClass cls = classifyOp(op);
  int defaultLatency = getConfiguredLatency(arch, cls, calibration);
  if (getWaitcntInfo(op).counter == WaitcntCounter::Vmem)
    return overrideOrDefault(overrides.vmemLoad, defaultLatency);
  if (getWaitcntInfo(op).counter == WaitcntCounter::Vscnt)
    return overrideOrDefault(overrides.vmemStore, defaultLatency);
  if (isLDSCounterIssuer(op))
    return overrideOrDefault(overrides.lds, arch.ldsCounterLatency);
  if (isSMEMLoad(op))
    return overrideOrDefault(overrides.smemLoad, defaultLatency);
  llvm_unreachable("op has no memory counter timing");
}

bool hasMemoryValueLatency(Operation *op) {
  if (!hasRegisterResult(op))
    return false;
  return getWaitcntInfo(op).counter == WaitcntCounter::Vmem || isLDSLoad(op) ||
         isSMEMLoad(op);
}

int getMemoryValueLatency(const ArchData &arch, Operation *op,
                          const MemoryValueLatencies &overrides,
                          const CalibrationData *calibration) {
  return getMemoryValueLatency(arch, op, MemoryCounterLatencies{}, overrides,
                               calibration);
}

int getMemoryValueLatency(const ArchData &arch, Operation *op,
                          const MemoryCounterLatencies &counterOverrides,
                          const MemoryValueLatencies &valueOverrides,
                          const CalibrationData *calibration) {
  if (getWaitcntInfo(op).counter == WaitcntCounter::Vmem)
    return overrideOrDefault(
        valueOverrides.vmemLoad,
        getMemoryCounterLatency(arch, op, counterOverrides, calibration));
  if (isLDSLoad(op))
    return overrideOrDefault(
        valueOverrides.lds,
        getMemoryCounterLatency(arch, op, counterOverrides, calibration));
  if (isSMEMLoad(op))
    return overrideOrDefault(
        valueOverrides.smemLoad,
        getMemoryCounterLatency(arch, op, counterOverrides, calibration));
  llvm_unreachable("op has no memory value timing");
}

} // namespace mlir::waveamdmachine
