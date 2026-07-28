//===- InstructionExecutionState.h - Single-wave issue state ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_INSTRUCTIONEXECUTIONSTATE_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_INSTRUCTIONEXECUTIONSTATE_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionResourceState.h"
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
class SWaitcntOp;
class SWaitcntSplitOp;

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

struct InstructionStallComponent {
  InstructionStallKind kind = InstructionStallKind::None;
  int64_t cycles = 0;
  InstructionResourceKind resource = InstructionResourceKind::None;
  InstructionResourceScope scope = InstructionResourceScope::Wave;
};

struct InstructionStall {
  InstructionStallKind kind = InstructionStallKind::None;
  int64_t cycles = 0;
  SmallVector<InstructionStallComponent, 4> components;
};

struct InstructionCommitResult {
  InstructionStall stall;
  InstructionStall priorityStall;
  InstructionStall computePriorityStall;
  int64_t issueCycle = 0;
  int64_t nextIssueCycle = 0;
  int64_t valueReadyCycle = 0;
  int64_t tokenReadyCycle = 0;
};

enum class DmaIssueDelayCohortPolicy : uint8_t { Delayed, Skipped };

struct ReadyRegisterPressure {
  int64_t sgpr = 0;
  int64_t vgpr = 0;
  int64_t agpr = 0;
};

struct ReadyRegisterPressureCeiling {
  unsigned sgpr = 0;
  unsigned vgpr = 0;
  unsigned agpr = 0;
  unsigned vgprFamily = 0;
};

struct ReadyCandidateMetrics {
  ReadyRegisterPressure pressureDelta;
  ReadyRegisterPressureCeiling pressureCeiling;
};

struct ReadyRegisterPressureLimits {
  unsigned sgpr = 0;
  unsigned vgpr = 0;
  unsigned agpr = 0;
  unsigned vgprFamily = 0;
  unsigned sgprAllocGranule = 0;
  unsigned vgprAllocGranule = 0;
  unsigned agprAllocGranule = 0;
};

struct InstructionExecutionConfig;

class InstructionScheduleModel {
public:
  bool canPreserveDmaIssueLead() const { return issueStreams > 1; }
  bool requiresStrictBarrierTokenReorder() const { return issueStreams == 1; }
  bool shouldBlockStallFillerMemoryResource() const {
    return issueStreams == 1;
  }
  bool shouldPrioritizeSteadyStateProducer() const { return issueStreams == 1; }
  bool shouldSelectResourceStallFiller(unsigned waitSlots,
                                       unsigned releaseSlots,
                                       ReadyRegisterPressure current,
                                       const ReadyCandidateMetrics &next) const;
  bool canSelectReadyCandidate(ReadyRegisterPressure current,
                               const ReadyCandidateMetrics &candidate,
                               const ReadyCandidateMetrics &baseline) const;
  bool canSelectReadyFiller(ReadyRegisterPressure current,
                            const ReadyCandidateMetrics &candidate,
                            const ReadyCandidateMetrics &baseline) const;
  bool shouldPreferReadyPressure(ReadyRegisterPressure current,
                                 const ReadyCandidateMetrics &candidate,
                                 const ReadyCandidateMetrics &selected) const;
  bool shouldPreferReadyFiller(ReadyRegisterPressure current,
                               const ReadyCandidateMetrics &candidate,
                               const ReadyCandidateMetrics &selected) const;

private:
  friend void
  configureInstructionScheduleModel(InstructionExecutionConfig &config,
                                    const ArchData &arch, Operation *context,
                                    ReadyRegisterPressureLimits pressureLimits);

  ReadyRegisterPressureLimits pressureLimits;
  unsigned issueStreams = 1;
};

struct InstructionExecutionConfig {
  const CalibrationData *calibration = nullptr;
  MemoryCounterLatencies counterLatencies;
  MemoryValueLatencies valueLatencies;
  int issuePeriod = 0;
  bool enablePipeBackpressure = false;
  bool smoothLdsDmaIssue = false;
  unsigned ldsDmaIssueWaveStreams = 1;
  unsigned valuMaxInFlight = 0;
  unsigned saluMaxInFlight = 0;
  unsigned xdlMaxInFlight = 0;
  InstructionScheduleModel scheduleModel;
  DmaIssueDelayCohortPolicy dmaIssueDelayCohortPolicy =
      DmaIssueDelayCohortPolicy::Delayed;
};

void configureInstructionScheduleModel(
    InstructionExecutionConfig &config, const ArchData &arch,
    Operation *context, ReadyRegisterPressureLimits pressureLimits = {});
unsigned getTargetWaveCount(Operation *context);

bool isInstructionExecutionStateArchSupported(
    const llvm::AMDGPU::IsaVersion &isa);

struct StoreWriteDataHazard {
  Value data;
  unsigned latency = 0;
};

struct InstructionIssueSlotHazardConfig {
  unsigned valuWriteVGPRScalarRead = 0;
  unsigned valuWriteVGPRMfmaRead = 0;
  unsigned valuWriteVGPRPermlane32Swap = 0;
  unsigned valuWriteSGPRValuRead = 0;
  unsigned transWriteVGPRValuRead = 0;

  bool empty() const {
    return valuWriteVGPRScalarRead == 0 && valuWriteVGPRMfmaRead == 0 &&
           valuWriteVGPRPermlane32Swap == 0 && valuWriteSGPRValuRead == 0 &&
           transWriteVGPRValuRead == 0;
  }
};

std::optional<StoreWriteDataHazard>
getStoreWriteDataHazard(Operation *op, const llvm::AMDGPU::IsaVersion &isa);
InstructionIssueSlotHazardConfig
getInstructionIssueSlotHazardConfig(const llvm::AMDGPU::IsaVersion &isa);
unsigned getValuWriteVGPRMfmaHazardLatency();
unsigned getXdlResultHazardLatency(const llvm::AMDGPU::IsaVersion &isa,
                                   unsigned passes);
unsigned getXdlSrcCOverlapHazardLatency(const llvm::AMDGPU::IsaVersion &isa,
                                        unsigned passes);
unsigned getXdlSrcCExactHazardLatency(const llvm::AMDGPU::IsaVersion &isa,
                                      unsigned passes);
bool isXdlResultHazardConsumer(Operation *op);
bool waitsForMemoryTokenDepsBeforeIssue(Operation *op);
llvm::StringRef getInstructionStallKindName(InstructionStallKind kind);
llvm::StringRef getInstructionPipeKindName(InstructionPipeKind kind);

struct InstructionExecutionState {
  InstructionExecutionState(const ArchData &arch,
                            InstructionExecutionConfig config = {});

  FailureOr<InstructionStall> query(Operation *op) const;
  FailureOr<InstructionCommitResult> commit(Operation *op);

  int64_t getCurrentCycle() const { return currentCycle; }
  int64_t getValueReadyCycle(Value value) const;
  void bindValue(Value result, Value source);
  void bindValue(Value result, ArrayRef<Value> sources);
  const InstructionScheduleModel &getScheduleModel() const {
    return config.scheduleModel;
  }
  bool hasSharedResourceState() const { return false; }
  unsigned getPendingMemoryEventCount(InstructionWaitCounterKind kind) const;
  unsigned getPipeInFlightCount(InstructionPipeKind kind) const;

private:
  friend class MultiWaveExecutionState;
  void advanceToCycle(int64_t cycle);
  using EventId = uint64_t;
  static constexpr unsigned kWaitCounterCount =
      getMaxEnumValForInstructionWaitCounterKind();
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
    int64_t instructionSpan = 0;
    int64_t resourceDuration = 0;
    uint64_t issueSlots = 1;
    unsigned instructionIssueCount = 1;
    unsigned counterIssueCount = 0;
    unsigned storeDataHazardLatency = 0;
    unsigned mfmaPasses = 0;
    InstructionPipeKind pipe = InstructionPipeKind::None;
    MemoryIssueResourceMask memoryIssueResources = 0;
    InstructionWaitCounterKind counter = InstructionWaitCounterKind::None;
    InstructionEventClass eventClass = InstructionEventClass::None;
    bool noMachineInst = false;
    bool waitcnt = false;
    bool legacyVALU = false;
    bool trans = false;
    bool mfmaCoissueResource = false;
    bool laneRead = false;
    bool ldsDmaIssue = false;
    bool m0Writer = false;
    bool m0Consumer = false;
    bool storeDataProducer = false;
    bool waitsForTokenDeps = false;
    bool hasMemoryValue = false;
    bool resultReadyAtEnd = false;
  };

  struct IssueSlotHazards {
    uint64_t valuWriteVGPRScalarReadyAt = 0;
    uint64_t valuWriteVGPRMfmaReadyAt = 0;
    uint64_t valuWriteVGPRPermlane32SwapReadyAt = 0;
    uint64_t transWriteVGPRReadyAt = 0;
    uint64_t valuWriteVCCReadyAt = 0;
    uint64_t mfmaResultReadyAt = 0;
    uint64_t mfmaSrcCOverlapReadyAt = 0;
    uint64_t mfmaSrcCExactReadyAt = 0;

    bool empty() const {
      return valuWriteVGPRScalarReadyAt == 0 && valuWriteVGPRMfmaReadyAt == 0 &&
             valuWriteVGPRPermlane32SwapReadyAt == 0 &&
             transWriteVGPRReadyAt == 0 && valuWriteVCCReadyAt == 0 &&
             mfmaResultReadyAt == 0 && mfmaSrcCOverlapReadyAt == 0 &&
             mfmaSrcCExactReadyAt == 0;
    }

    void join(const IssueSlotHazards &rhs) {
      valuWriteVGPRScalarReadyAt =
          std::max(valuWriteVGPRScalarReadyAt, rhs.valuWriteVGPRScalarReadyAt);
      valuWriteVGPRMfmaReadyAt =
          std::max(valuWriteVGPRMfmaReadyAt, rhs.valuWriteVGPRMfmaReadyAt);
      valuWriteVGPRPermlane32SwapReadyAt =
          std::max(valuWriteVGPRPermlane32SwapReadyAt,
                   rhs.valuWriteVGPRPermlane32SwapReadyAt);
      transWriteVGPRReadyAt =
          std::max(transWriteVGPRReadyAt, rhs.transWriteVGPRReadyAt);
      valuWriteVCCReadyAt =
          std::max(valuWriteVCCReadyAt, rhs.valuWriteVCCReadyAt);
      mfmaResultReadyAt = std::max(mfmaResultReadyAt, rhs.mfmaResultReadyAt);
      mfmaSrcCOverlapReadyAt =
          std::max(mfmaSrcCOverlapReadyAt, rhs.mfmaSrcCOverlapReadyAt);
      mfmaSrcCExactReadyAt =
          std::max(mfmaSrcCExactReadyAt, rhs.mfmaSrcCExactReadyAt);
    }
  };

  FailureOr<InstructionDesc> describe(Operation *op) const;
  static InstructionResourceCapacities
  getResourceCapacities(const InstructionExecutionConfig &config);
  SmallVector<InstructionResourceUse, 6>
  getResourceUses(Operation *op, const InstructionDesc &desc,
                  const InstructionResourceState &resourceState) const;
  void
  appendIssueResourceUses(unsigned count, int64_t offset, int64_t period,
                          SmallVectorImpl<InstructionResourceUse> &uses) const;
  void
  appendPipeResourceUse(Operation *op, const InstructionDesc &desc,
                        const InstructionResourceState &resourceState,
                        SmallVectorImpl<InstructionResourceUse> &uses) const;
  void appendMfmaCoissueResourceUse(
      const InstructionDesc &desc,
      const InstructionResourceState &resourceState,
      SmallVectorImpl<InstructionResourceUse> &uses) const;
  void
  appendLdsResourceUses(const InstructionDesc &desc,
                        const InstructionResourceState &resourceState,
                        int64_t issuePeriod,
                        SmallVectorImpl<InstructionResourceUse> &uses) const;
  void appendDmaIssueResourceUses(
      Operation *op, SmallVectorImpl<InstructionResourceUse> &uses) const;
  void configureDmaIssueDelay(Operation *op, InstructionDesc &desc) const;
  FailureOr<InstructionStall> query(Operation *op,
                                    const InstructionDesc &desc) const;
  FailureOr<InstructionStall>
  queryWithResources(Operation *op, const InstructionDesc &desc,
                     const InstructionResourceState *resourceState,
                     unsigned wave, WavePlacement placement) const;
  LogicalResult addDependencyStalls(Operation *op, const InstructionDesc &desc,
                                    InstructionStall &stall) const;
  void addLocalMemoryIssueStalls(const InstructionDesc &desc,
                                 InstructionStall &stall) const;
  void addLocalResourceStalls(const InstructionDesc &desc,
                              InstructionStall &stall) const;
  LogicalResult
  addSharedResourceStall(Operation *op, const InstructionDesc &desc,
                         const InstructionResourceState &resourceState,
                         unsigned wave, WavePlacement placement,
                         InstructionStall &stall) const;
  FailureOr<InstructionCommitResult>
  commitWithResources(Operation *op, InstructionResourceState *resourceState,
                      unsigned wave, WavePlacement placement);
  FailureOr<int64_t> waitcntReadyCycle(Operation *op, int64_t cycle) const;
  FailureOr<int64_t> waitcntReadyCycle(SWaitcntOp wait, int64_t cycle) const;
  FailureOr<int64_t> waitcntReadyCycle(SWaitcntSplitOp wait,
                                       int64_t cycle) const;
  LogicalResult
  combineCounterReadyCycle(int64_t &ready, InstructionWaitCounterKind kind,
                           std::optional<uint32_t> limit, int64_t cycle,
                           ArrayRef<InstructionEventClass> eventClasses) const;
  FailureOr<int64_t>
  counterReadyCycle(InstructionWaitCounterKind kind, unsigned limit,
                    int64_t cycle,
                    ArrayRef<InstructionEventClass> eventClasses = {}) const;
  int64_t operandReadyCycle(Operation *op,
                            InstructionStallKind &stallKind) const;
  int64_t issueReadyCycle(Operation *op, InstructionStallKind &stallKind) const;
  void addIssueHazards(Operation *op, const InstructionDesc &desc,
                       InstructionStall &stall) const;
  unsigned issueSlotHazardWait(Operation *op,
                               const InstructionDesc &desc) const;
  uint64_t mfmaOperandReadyAt(Operation *op, const InstructionDesc &desc,
                              unsigned operandIndex,
                              const IssueSlotHazards &hazards) const;
  unsigned mfmaIssueSlotHazardWait(Operation *op, const InstructionDesc &desc,
                                   unsigned operandIndex,
                                   const IssueSlotHazards &hazards) const;
  unsigned legacyValuIssueSlotHazardWait(Value operand,
                                         const InstructionDesc &desc,
                                         const IssueSlotHazards &hazards) const;
  unsigned
  permlane32SwapIssueSlotHazardWait(Operation *op,
                                    const IssueSlotHazards &hazards) const;
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
  int64_t commitNoMachineInst(Operation *op);
  SmallVector<EventId, 4> commitMemoryEvents(Operation *op,
                                             const InstructionDesc &desc,
                                             int64_t issueCycle);
  void commitResults(Operation *op, const InstructionDesc &desc,
                     int64_t issueCycle, ArrayRef<EventId> newEvents);
  void commitPipe(InstructionPipeKind pipe, int64_t readyCycle);
  void commitMemoryIssue(const InstructionDesc &desc, int64_t issueCycle);
  void commitIssueSlotHazards(Operation *op, const InstructionDesc &desc);
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
  int64_t nextLdsDmaIssueCycle = 0;
  int64_t mfmaCoissueReadyCycle = 0;
  uint64_t currentIssueSlot = 0;
  EventId nextEventId = 1;
  unsigned storeDataGap = 0;
  bool m0DmaCaptureGapArmed = false;
  bool m0GapArmed = false;
};

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_INSTRUCTIONEXECUTIONSTATE_H
