//===- EventSimulator.h - Event-driven machine timeline --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_EVENTSIMULATOR_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_EVENTSIMULATOR_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Support/LLVM.h"
#include "llvm/ADT/SmallVector.h"

#include <cstdint>

namespace mlir {
class Operation;
namespace func {
class FuncOp;
} // namespace func
} // namespace mlir

namespace mlir::waveamdmachine {

struct ArchData;
class CalibrationData;

struct EventSimConfig {
  int waveSize = 0;
  int64_t tripCountOverride = -1;
  const CalibrationData *calibration = nullptr;
  bool recordTimeline = false;
  bool completePendingLdsDmaCounters = false;
  int cmaIssueInterval = 0;
  MemoryCounterLatencies counterLatencies;
  MemoryValueLatencies valueLatencies;
};

enum class EventSimCounter : uint8_t {
  None,
  Vmem,
  Lgkm,
  Vscnt,
};

enum class EventSimEventKind : uint8_t {
  OpIssued,
  ValueReady,
  CounterDrained,
  WaveCompleted,
};

struct EventSimEvent {
  int64_t cycle = 0;
  EventSimEventKind kind = EventSimEventKind::OpIssued;
  Operation *op = nullptr;
  FunctionalUnit fu = FunctionalUnit::None;
  EventSimCounter counter = EventSimCounter::None;
};

struct EventSimResult {
  int64_t totalCycles = 0;
  int64_t issuedOps = 0;
  int64_t completedCycle = 0;
  SmallVector<EventSimEvent> events;
};

bool isEventSimCmaClass(SchedClass cls);

int getEventSimIssuePeriod(const ArchData &arch, const EventSimConfig &config);

int getEventSimCmaIssueInterval(const ArchData &arch,
                                const EventSimConfig &config);

unsigned getEventSimCmaIssueCapacity(const ArchData &arch);

unsigned getEventSimCmaIssueCount(Operation *op, SchedClass cls,
                                  unsigned issues);

LogicalResult simulateEventTimeline(func::FuncOp func, const ArchData &arch,
                                    const EventSimConfig &config,
                                    EventSimResult &out);

LogicalResult simulateEventTimeline(ArrayRef<Operation *> ops,
                                    const ArchData &arch,
                                    const EventSimConfig &config,
                                    EventSimResult &out);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_EVENTSIMULATOR_H
