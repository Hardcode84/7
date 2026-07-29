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

#include <array>
#include <utility>

namespace mlir::waveamdmachine {

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

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

static constexpr std::array<std::pair<WaitcntEvent, MemoryIssueResourceMask>, 9>
    waitcntIssueResources = {
        {{WaitcntEvent::Vmem,
          getMemoryIssueResourceMask(MemoryIssueResource::VmemLoad)},
         {WaitcntEvent::Flat,
          getMemoryIssueResourceMask(MemoryIssueResource::VmemLoad)},
         {WaitcntEvent::VmemStore,
          getMemoryIssueResourceMask(MemoryIssueResource::VmemStore)},
         {WaitcntEvent::ScratchStore,
          getMemoryIssueResourceMask(MemoryIssueResource::VmemStore)},
         {WaitcntEvent::Lds,
          getMemoryIssueResourceMask(MemoryIssueResource::Lds)},
         {WaitcntEvent::Gds,
          getMemoryIssueResourceMask(MemoryIssueResource::Lds)},
         {WaitcntEvent::Message,
          getMemoryIssueResourceMask(MemoryIssueResource::Lds)},
         {WaitcntEvent::Smem,
          getMemoryIssueResourceMask(MemoryIssueResource::Smem)},
         {WaitcntEvent::None, 0}}};

static MemoryIssueResourceMask getWaitcntIssueResources(Operation *op) {
  WaitcntInfo info = getWaitcntInfo(op);
  if (info.event == WaitcntEvent::Async || info.event == WaitcntEvent::Tensor) {
    MemoryIssueResourceMask resources =
        getMemoryIssueResourceMask(MemoryIssueResource::Lds);
    if (op->hasTrait<traits::VMEMLoadOp>())
      resources |= getMemoryIssueResourceMask(MemoryIssueResource::VmemLoad);
    if (op->hasTrait<traits::VMEMStoreOp>())
      resources |= getMemoryIssueResourceMask(MemoryIssueResource::VmemStore);
    return resources;
  }
  if (info.event == WaitcntEvent::None && op->hasTrait<traits::VMEMLoadOp>())
    return getMemoryIssueResourceMask(MemoryIssueResource::VmemLoad);
  if (info.event == WaitcntEvent::None && op->hasTrait<traits::VMEMStoreOp>())
    return getMemoryIssueResourceMask(MemoryIssueResource::VmemStore);
  auto it = llvm::find_if(waitcntIssueResources, [&](const auto &mapping) {
    return mapping.first == info.event;
  });
  if (it == waitcntIssueResources.end())
    llvm_unreachable("unsupported wait event");
  return it->second;
}

} // namespace

MemoryCounterKind getMemoryCounterKind(Operation *op) {
  WaitcntEvent event = getWaitcntInfo(op).event;
  if (event == WaitcntEvent::Async)
    return MemoryCounterKind::Async;
  if (event == WaitcntEvent::Tensor)
    return MemoryCounterKind::Tensor;
  static constexpr std::array<std::pair<WaitcntCounter, MemoryCounterKind>, 3>
      counterKinds = {{{WaitcntCounter::Vmem, MemoryCounterKind::Vmem},
                       {WaitcntCounter::Lgkm, MemoryCounterKind::Lgkm},
                       {WaitcntCounter::Vscnt, MemoryCounterKind::Vscnt}}};
  WaitcntCounter counter = getLegacyWaitcntCounter(event);
  if (counter == WaitcntCounter::None)
    return MemoryCounterKind::None;
  auto it = llvm::find_if(counterKinds, [&](const auto &mapping) {
    return mapping.first == counter;
  });
  if (it == counterKinds.end())
    llvm_unreachable("expected legacy counter");
  return it->second;
}

MemoryIssueResourceMask getMemoryIssueResources(Operation *op) {
  MemoryIssueResourceMask resources = getWaitcntIssueResources(op);
  if (op->hasTrait<traits::LDSDmaOp>() && op->hasTrait<traits::VMEMLoadOp>())
    resources |= getMemoryIssueResourceMask(MemoryIssueResource::LdsDmaAccept);
  return resources;
}

bool isLdsDmaIssuer(Operation *op) { return op->hasTrait<traits::LDSDmaOp>(); }

int getMemoryCounterLatency(const ArchData &arch, Operation *op,
                            const MemoryCounterLatencies &overrides,
                            const CalibrationData *calibration) {
  SchedClass cls = classifyOp(op);
  int defaultLatency = getConfiguredLatency(arch, cls, calibration);
  WaitcntEvent event = getWaitcntInfo(op).event;
  if (event == WaitcntEvent::Vmem || event == WaitcntEvent::Flat)
    return overrideOrDefault(overrides.vmemLoad, defaultLatency);
  if (event == WaitcntEvent::VmemStore || event == WaitcntEvent::ScratchStore)
    return overrideOrDefault(overrides.vmemStore, defaultLatency);
  if (event == WaitcntEvent::Async || event == WaitcntEvent::Tensor)
    return defaultLatency;
  if (isLDSCounterIssuer(op))
    return overrideOrDefault(overrides.lds, arch.ldsCounterLatency == 0
                                                ? defaultLatency
                                                : arch.ldsCounterLatency);
  if (isSMEMLoad(op))
    return overrideOrDefault(overrides.smemLoad, defaultLatency);
  llvm_unreachable("op has no memory counter timing");
}

bool hasMemoryValueLatency(Operation *op) {
  if (!hasRegisterResult(op))
    return false;
  WaitcntEvent event = getWaitcntInfo(op).event;
  return event == WaitcntEvent::Vmem || event == WaitcntEvent::Flat ||
         isLDSLoad(op) || isSMEMLoad(op);
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
  WaitcntEvent event = getWaitcntInfo(op).event;
  if (event == WaitcntEvent::Vmem || event == WaitcntEvent::Flat)
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
