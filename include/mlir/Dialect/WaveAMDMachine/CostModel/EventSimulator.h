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
  int waves = 1;
  int simds = 1;
  int startDelay = 0;
  int64_t tripCountOverride = -1;
  const CalibrationData *calibration = nullptr;
  bool recordTimeline = false;
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
  int wave = 0;
  int simd = 0;
  Operation *op = nullptr;
  FunctionalUnit fu = FunctionalUnit::None;
  EventSimCounter counter = EventSimCounter::None;
};

struct EventSimResult {
  int64_t totalCycles = 0;
  int64_t issuedOps = 0;
  SmallVector<int64_t> waveCompletedCycles;
  SmallVector<EventSimEvent> events;
};

LogicalResult simulateEventTimeline(func::FuncOp func, const ArchData &arch,
                                    const EventSimConfig &config,
                                    EventSimResult &out);

LogicalResult simulateEventTimeline(ArrayRef<Operation *> ops,
                                    const ArchData &arch,
                                    const EventSimConfig &config,
                                    EventSimResult &out);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_EVENTSIMULATOR_H
