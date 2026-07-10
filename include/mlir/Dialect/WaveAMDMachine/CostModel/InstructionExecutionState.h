//===- InstructionExecutionState.h - Single-wave issue state ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_INSTRUCTIONEXECUTIONSTATE_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_INSTRUCTIONEXECUTIONSTATE_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/TargetParser/AMDGPUTargetParser.h"

#include <algorithm>
#include <array>
#include <cstdint>
#include <optional>

namespace mlir {
class Operation;
} // namespace mlir

namespace mlir::waveamdmachine {

struct ArchData;
class CalibrationData;

enum class InstructionStallKind : uint8_t {
  None,
  IssueBackpressure,
  OperandValue,
  MemoryValue,
  MemoryToken,
  Waitcnt,
  InstructionHazard,
  M0ReadWrite,
  StoreWriteData,
};

enum class InstructionPipeKind : uint8_t {
  None,
  VALU,
  SALU,
  XDL,
};

enum class InstructionWaitCounterKind : uint8_t {
  None,
  Vmem,
  Lgkm,
  Vscnt,
  Expcnt,
};

enum class InstructionEventClass : uint8_t {
  None,
  VmemLoad,
  VmemStore,
  LdsDs,
  Smem,
  Export,
};

struct InstructionStallComponent {
  InstructionStallKind kind = InstructionStallKind::None;
  int64_t cycles = 0;
};

struct InstructionStall {
  InstructionStallKind kind = InstructionStallKind::None;
  int64_t cycles = 0;
  SmallVector<InstructionStallComponent, 4> components;
};

struct InstructionCommitResult {
  InstructionStall stall;
  int64_t issueCycle = 0;
  int64_t nextIssueCycle = 0;
  int64_t valueReadyCycle = 0;
  int64_t tokenReadyCycle = 0;
};

struct InstructionExecutionConfig {
  const CalibrationData *calibration = nullptr;
  MemoryCounterLatencies counterLatencies;
  MemoryValueLatencies valueLatencies;
  int issuePeriod = 0;
  bool enablePipeBackpressure = false;
  unsigned valuMaxInFlight = 0;
  unsigned saluMaxInFlight = 0;
  unsigned xdlMaxInFlight = 0;
};

bool isInstructionExecutionStateArchSupported(
    const llvm::AMDGPU::IsaVersion &isa);

struct StoreWriteDataHazard {
  Value data;
  unsigned latency = 0;
};

struct InstructionIssueSlotHazardConfig {
  unsigned valuWriteVGPRScalarRead = 0;
  unsigned valuWriteSGPRValuRead = 0;
  unsigned transWriteVGPRValuRead = 0;

  bool empty() const {
    return valuWriteVGPRScalarRead == 0 && valuWriteSGPRValuRead == 0 &&
           transWriteVGPRValuRead == 0;
  }
};

std::optional<StoreWriteDataHazard>
getStoreWriteDataHazard(Operation *op, const llvm::AMDGPU::IsaVersion &isa);
InstructionIssueSlotHazardConfig
getInstructionIssueSlotHazardConfig(const llvm::AMDGPU::IsaVersion &isa);
bool waitsForMemoryTokenDepsBeforeIssue(Operation *op);
llvm::StringRef getInstructionStallKindName(InstructionStallKind kind);
llvm::StringRef getInstructionPipeKindName(InstructionPipeKind kind);
llvm::StringRef
getInstructionWaitCounterKindName(InstructionWaitCounterKind kind);
llvm::StringRef getInstructionEventClassName(InstructionEventClass eventClass);

struct InstructionExecutionState {
  InstructionExecutionState(const ArchData &arch,
                            InstructionExecutionConfig config = {});

  FailureOr<InstructionStall> query(Operation *op) const;
  FailureOr<InstructionCommitResult> commit(Operation *op);

  int64_t getCurrentCycle() const { return currentCycle; }
  int64_t getValueReadyCycle(Value value) const;
  void bindValue(Value result, Value source);
  void bindValue(Value result, ArrayRef<Value> sources);
  unsigned getPendingMemoryEventCount(InstructionWaitCounterKind kind) const;
  unsigned getPipeInFlightCount(InstructionPipeKind kind) const;

private:
  using EventId = uint64_t;
  static constexpr unsigned kWaitCounterCount = 4;
  static constexpr unsigned kPipeCount = 3;

  struct PendingEvent {
    Operation *op = nullptr;
    EventId id = 0;
    int64_t retireCycle = 0;
    InstructionWaitCounterKind counter = InstructionWaitCounterKind::None;
    InstructionEventClass eventClass = InstructionEventClass::None;
  };

  struct InstructionDesc {
    int64_t latency = 0;
    int64_t memoryCounterLatency = 0;
    int64_t memoryValueLatency = 0;
    unsigned issueCount = 1;
    unsigned storeDataHazardLatency = 0;
    InstructionPipeKind pipe = InstructionPipeKind::None;
    MemoryIssueResourceMask memoryIssueResources = 0;
    InstructionWaitCounterKind counter = InstructionWaitCounterKind::None;
    InstructionEventClass eventClass = InstructionEventClass::None;
    bool noMachineInst = false;
    bool waitcnt = false;
    bool legacyVALU = false;
    bool trans = false;
    bool laneRead = false;
    bool m0Writer = false;
    bool m0Consumer = false;
    bool storeDataProducer = false;
    bool waitsForTokenDeps = false;
    bool hasMemoryValue = false;
  };

  struct IssueSlotHazards {
    uint64_t valuWriteVGPRReadyAt = 0;
    uint64_t transWriteVGPRReadyAt = 0;
    uint64_t valuWriteVCCReadyAt = 0;

    bool empty() const {
      return valuWriteVGPRReadyAt == 0 && transWriteVGPRReadyAt == 0 &&
             valuWriteVCCReadyAt == 0;
    }

    void join(const IssueSlotHazards &rhs) {
      valuWriteVGPRReadyAt =
          std::max(valuWriteVGPRReadyAt, rhs.valuWriteVGPRReadyAt);
      transWriteVGPRReadyAt =
          std::max(transWriteVGPRReadyAt, rhs.transWriteVGPRReadyAt);
      valuWriteVCCReadyAt =
          std::max(valuWriteVCCReadyAt, rhs.valuWriteVCCReadyAt);
    }
  };

  InstructionDesc describe(Operation *op) const;
  FailureOr<InstructionStall> query(Operation *op,
                                    const InstructionDesc &desc) const;
  FailureOr<int64_t> waitcntReadyCycle(Operation *op, int64_t cycle) const;
  FailureOr<int64_t> counterReadyCycle(InstructionWaitCounterKind kind,
                                       unsigned limit, int64_t cycle) const;
  int64_t operandReadyCycle(Operation *op,
                            InstructionStallKind &stallKind) const;
  unsigned issueSlotHazardWait(Operation *op,
                               const InstructionDesc &desc) const;
  int64_t tokenReadyCycle(Operation *op) const;
  int64_t pipeReadyCycle(InstructionPipeKind pipe, int64_t cycle) const;
  int64_t memoryIssueReadyCycle(MemoryIssueResource resource,
                                unsigned issueCount, int64_t cycle) const;
  int64_t memoryIssueReadyCycle(MemoryIssueResourceMask resources,
                                unsigned issueCount, int64_t cycle) const;
  int64_t getIssuePeriod() const;
  int64_t getInstructionSpan(const InstructionDesc &desc) const;
  int64_t getResultReadyCycle(Operation *op, const InstructionDesc &desc,
                              int64_t issueCycle) const;
  int64_t getTokenReadyCycle(Operation *op, ArrayRef<EventId> newEvents) const;
  void commitNoMachineInst(Operation *op);
  SmallVector<EventId, 4> commitMemoryEvents(Operation *op,
                                             const InstructionDesc &desc,
                                             int64_t issueCycle);
  void commitResults(Operation *op, const InstructionDesc &desc,
                     int64_t issueCycle, ArrayRef<EventId> newEvents);
  void commitPipe(InstructionPipeKind pipe, int64_t readyCycle);
  void commitMemoryIssue(const InstructionDesc &desc, int64_t issueCycle);
  void commitIssueSlotHazards(Operation *op, const InstructionDesc &desc);
  void commitIssueSlotAliases(Operation *op);
  void commitIssueSlotProducer(Operation *op, const InstructionDesc &desc);
  void commitM0(const InstructionDesc &desc);
  void commitStoreData(const InstructionDesc &desc);
  void pruneRetiredEvents(int64_t cycle);
  SmallVector<EventId, 4> collectTokenDeps(Operation *op) const;
  bool hasPendingEvent(EventId id, int64_t cycle) const;

  DenseMap<Value, int64_t> valueReadyAt;
  DenseMap<Value, IssueSlotHazards> issueSlotHazards;
  DenseMap<Value, EventId> valueEvent;
  DenseMap<Value, SmallVector<EventId, 4>> tokenEvents;
  DenseMap<EventId, PendingEvent> events;
  std::array<SmallVector<EventId, 8>, kWaitCounterCount> waitQueues;
  std::array<SmallVector<int64_t, 8>, kPipeCount> pipeQueues;
  std::array<SmallVector<int64_t, 8>, kMemoryIssueResourceCount>
      memoryIssueQueues;
  InstructionExecutionConfig config;
  const ArchData &arch;
  InstructionIssueSlotHazardConfig issueSlotHazardConfig;
  int64_t currentCycle = 0;
  uint64_t currentIssueSlot = 0;
  EventId nextEventId = 1;
  unsigned storeDataGap = 0;
  bool m0GapArmed = false;
};

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_INSTRUCTIONEXECUTIONSTATE_H
