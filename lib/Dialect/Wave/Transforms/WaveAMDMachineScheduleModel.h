//===- WaveAMDMachineScheduleModel.h - Machine scheduling model -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEMODEL_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEMODEL_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLFunctionalExtras.h"
#include "llvm/ADT/SmallVector.h"

#include <cstdint>
#include <memory>
#include <optional>

namespace mlir {
class Operation;
namespace func {
class FuncOp;
}
namespace waveamdmachine {
struct ArchData;
struct EventSimConfig;
} // namespace waveamdmachine

namespace wave {

struct ReadyScheduleWorkStats {
  uint64_t stateBuilds = 0;
  uint64_t memberVisits = 0;
  uint64_t projections = 0;
  uint64_t projectedNodes = 0;
  uint64_t projectionChecks = 0;
  uint64_t pressureSelections = 0;
  uint64_t pressureRejections = 0;
  uint64_t proposalSelections = 0;
  uint64_t proposalRejections = 0;
};

enum class ReadyScheduleProposalKind : uint8_t {
  Direct,
  RankedFiller,
  ComputeResource,
  Latency,
  GenericStallFiller,
};

enum class ReadyScheduleStallKind : uint8_t {
  None,
  Cycle,
  MemoryToken,
  InstructionHazard,
};

struct ReadyScheduleStallFacts {
  int64_t issueCycle = 0;
  waveamdmachine::MemoryIssueResourceMask blockedMemoryResources = 0;
  waveamdmachine::InstructionStallKind reason =
      waveamdmachine::InstructionStallKind::None;
  ReadyScheduleStallKind kind = ReadyScheduleStallKind::None;
};

struct ReadyScheduleIssueFacts {
  int64_t operandWaitCycles = 0;
  int64_t memoryWaitCycles = 0;
  int64_t functionalUnitWaitCycles = 0;
  int64_t issueWaitCycles = 0;
  int64_t cuIssueWaitCycles = 0;
  int64_t cmaIssueWaitCycles = 0;
  int64_t coexecWindowWaitCycles = 0;
  int64_t issueCycle = 0;
  unsigned hazardWaitInstructions = 0;
};

struct ReadyScheduleCandidateIssueFacts {
  int64_t nextIssueCycle = 0;
  unsigned issues = 0;
  bool realInstruction = false;
  bool stalls = false;
};

enum class ReadyScheduleTimeline : uint8_t { Local, Steady };
enum class ReadySchedulePhase : uint8_t { Normal, ResumeBaseline };

struct ReadyScheduleDynamicIssueFacts {
  ReadyScheduleIssueFacts issue;
  waveamdmachine::InstructionScheduleResourcePreview resource;
  int64_t nextIssueCycle = 0;
  unsigned issues = 0;
  bool realInstruction = false;
  bool priorityStall = false;
};

using ReadyScheduleDynamicIssueProvider =
    llvm::function_ref<FailureOr<ReadyScheduleDynamicIssueFacts>(
        unsigned, ReadyScheduleTimeline)>;

struct ReadyScheduleProjectionFacts {
  SmallVector<waveamdmachine::InstructionStallComponent, 8> stalls;
  int64_t cycles = 0;
};

// Session builds candidate orders; providers return dynamic facts only.
using ReadyScheduleIssueProvider =
    llvm::function_ref<FailureOr<ReadyScheduleCandidateIssueFacts>(unsigned)>;
using ReadyScheduleProjectionProvider =
    llvm::function_ref<FailureOr<ReadyScheduleProjectionFacts>(
        ArrayRef<unsigned>)>;

struct RecurrenceScheduleBaselineFacts {
  SmallVector<unsigned, 16> order;
};

struct RecurrenceScheduleProjectionFacts {
  int64_t modelCycles = 0;
  int64_t resourceCycles = 0;
};

// Session owns admission; providers return neutral scheduler facts.
using RecurrenceScheduleBaselineProvider =
    llvm::function_ref<FailureOr<RecurrenceScheduleBaselineFacts>()>;
using RecurrenceScheduleProjectionProvider =
    llvm::function_ref<FailureOr<RecurrenceScheduleProjectionFacts>(
        ArrayRef<unsigned>, ArrayRef<unsigned>)>;

struct RecurrenceScheduleDecision {
  std::optional<unsigned> candidate;
  unsigned movedCount = 0;
  bool activated = false;
};

struct SingleWaveScheduleBuildRequest {
  ArrayRef<unsigned> steadyStateOrder;
  unsigned steadyStateIterations = 0;
  bool replaySteadyState = false;
};

// Opaque token keeps model policy independent of scheduler-owned state.
struct SingleWaveScheduleCandidateFacts {
  SmallVector<unsigned, 16> order;
  unsigned resultToken = 0;
  unsigned recurrenceModelMoves = 0;
  bool success = false;
};

using SingleWaveScheduleBuildProvider =
    llvm::function_ref<FailureOr<SingleWaveScheduleCandidateFacts>(
        const SingleWaveScheduleBuildRequest &)>;

struct SingleWaveScheduleRefinementStats {
  unsigned steadyStateIterations = 0;
  unsigned steadyStateRefinements = 0;
  unsigned recurrenceModelMoves = 0;
};

struct SingleWaveScheduleDecision {
  std::optional<SingleWaveScheduleRefinementStats> refinementStats;
  unsigned resultToken = 0;
  bool modelFailed = false;
};

struct ReadyScheduleResourceFacts {
  waveamdmachine::InstructionScheduleResourcePreview baseline;
  waveamdmachine::InstructionScheduleResourcePreview candidate;
  bool baselinePriorityStall = false;
  bool candidatePriorityStall = false;
  bool prioritize = false;
};

using ReadyScheduleResourceFactsProvider =
    llvm::function_ref<FailureOr<ReadyScheduleResourceFacts>(unsigned)>;

struct ReadyScheduleLatencyFacts {
  bool baselinePriorityStall = false;
  bool candidatePriorityStall = false;
};

struct ReadyScheduleFillerFacts {
  ReadyScheduleStallFacts stall;
  int64_t candidateNextIssueCycle = 0;
  bool candidateRealInstruction = false;
  bool candidateStalls = false;
};

struct ReadyScheduleProposal {
  unsigned candidate = 0;
  ReadyScheduleProposalKind kind = ReadyScheduleProposalKind::Direct;
  unsigned group = 0;
  ReadyScheduleResourceFacts resource;
  ReadyScheduleLatencyFacts latency;
  ReadyScheduleFillerFacts filler;
};

enum class ReadyScheduleSelectionKind : uint8_t {
  Baseline,
  Pressure,
  Proposal,
  ResourcePriority,
  ResourceStallFiller,
  LatencyPriority,
  GenericStallFiller,
  MemoryTokenConsumer,
  BarrierPairFiller,
  VmemPrefetch,
  LongLatencyVmemPrefetch,
  DmaPostBarrierFiller,
  SteadyStateProducer,
  SteadyStateFiller,
};

struct ReadyScheduleDecision {
  std::optional<unsigned> candidate;
  bool suppressFallback = false;
  ReadyScheduleSelectionKind kind = ReadyScheduleSelectionKind::Baseline;
  // Bookkeeping requested by the selected model action. Callers apply these
  // facts without reclassifying or reconsidering the candidate.
  bool resumeBaseline = false;
  bool filledStall = false;
  bool filledBarrierMemoryStall = false;
};

class RegionScheduleSession {
public:
  RegionScheduleSession(RegionScheduleSession &&);
  RegionScheduleSession &operator=(RegionScheduleSession &&);
  ~RegionScheduleSession();

  RegionScheduleSession(const RegionScheduleSession &) = delete;
  RegionScheduleSession &operator=(const RegionScheduleSession &) = delete;

  FailureOr<ReadyScheduleDecision>
  selectReady(ReadySchedulePhase phase, const llvm::BitVector &scheduled,
              unsigned baseline, const llvm::BitVector &legalReadyCandidates,
              bool hasSteadyState,
              const waveamdmachine::InstructionScheduleModel &policy,
              ReadyScheduleDynamicIssueProvider issueProvider,
              ReadyScheduleResourceFactsProvider resourceProvider,
              ReadyScheduleProjectionProvider projectionProvider) const;

  FailureOr<ReadyScheduleDecision>
  selectStallFiller(const llvm::BitVector &scheduled, unsigned baseline,
                    const llvm::BitVector &legalReadyCandidates,
                    const ReadyScheduleStallFacts &stall,
                    const waveamdmachine::InstructionScheduleModel &policy,
                    ReadyScheduleIssueProvider issueProvider) const;

  bool canIssueBaselineDespiteStall(
      unsigned baseline, const ReadyScheduleIssueFacts &issue,
      const waveamdmachine::InstructionScheduleModel &policy) const;

  FailureOr<RecurrenceScheduleDecision> selectRecurrence(
      unsigned baseline, const llvm::BitVector &legalReadyCandidates,
      const llvm::BitVector &scheduled, ArrayRef<unsigned> scheduledPrefix,
      RecurrenceScheduleBaselineProvider baselineProvider,
      RecurrenceScheduleProjectionProvider projectionProvider) const;

  ReadyScheduleStallFacts classifyStall(unsigned baseline,
                                        const ReadyScheduleIssueFacts &issue,
                                        bool blockMemoryResource) const;
  ReadyScheduleStallFacts
  classifyStall(unsigned baseline, const ReadyScheduleIssueFacts &issue,
                const waveamdmachine::InstructionScheduleModel &policy) const;

  ReadyScheduleWorkStats getWorkStats() const;

private:
  struct ReadySelectionContext;

  FailureOr<ReadyScheduleDecision>
  selectReadyOverride(const ReadySelectionContext &context) const;
  FailureOr<ReadyScheduleDecision>
  selectReadyNormal(const ReadySelectionContext &context) const;
  FailureOr<ReadyScheduleDecision>
  selectReadySteady(const ReadySelectionContext &context) const;
  FailureOr<ReadyScheduleDecision> selectReadySteadyProducer(
      const ReadySelectionContext &context,
      const ReadyScheduleDynamicIssueFacts &baselineIssue) const;
  FailureOr<std::optional<unsigned>> findReadySteadyProducer(
      const ReadySelectionContext &context,
      waveamdmachine::MemoryIssueResourceMask blockedResources) const;
  FailureOr<ReadyScheduleDecision> selectReadySteadyFiller(
      const ReadySelectionContext &context,
      const ReadyScheduleDynamicIssueFacts &baselineIssue) const;
  FailureOr<SmallVector<ReadyScheduleProposal, 8>>
  buildReadySteadyFillerProposals(const ReadySelectionContext &context) const;
  FailureOr<ReadyScheduleDecision>
  selectReadyMemory(const ReadySelectionContext &context) const;
  FailureOr<ReadyScheduleDecision>
  selectReadyCompute(const ReadySelectionContext &context) const;
  FailureOr<ReadyScheduleDecision>
  selectReadyLatency(const ReadySelectionContext &context) const;

  ReadyScheduleDecision
  selectNext(const llvm::BitVector &scheduled, unsigned baseline,
             const llvm::BitVector &legalReadyCandidates,
             ArrayRef<ReadyScheduleProposal> proposals,
             const waveamdmachine::InstructionScheduleModel &policy) const;

  ReadyScheduleDecision selectRankedFiller(
      const llvm::BitVector &scheduled, unsigned baseline, unsigned candidate,
      ReadyScheduleSelectionKind kind,
      const waveamdmachine::InstructionScheduleModel &policy) const;

  FailureOr<ReadyScheduleDecision> selectComputeResourceGroup(
      const llvm::BitVector &scheduled, unsigned baseline,
      ArrayRef<unsigned> candidates,
      const waveamdmachine::InstructionScheduleModel &policy,
      ReadyScheduleResourceFactsProvider getResourceFacts) const;

  FailureOr<ReadyScheduleDecision> selectComputeResource(
      const llvm::BitVector &scheduled, unsigned baseline,
      const llvm::BitVector &legalReadyCandidates,
      const waveamdmachine::InstructionScheduleModel &policy,
      ReadyScheduleResourceFactsProvider getResourceFacts) const;

  bool supportsLatencyPriority(bool enabled) const;
  llvm::BitVector getLatencyCandidates(
      const llvm::BitVector &scheduled, unsigned baseline,
      const llvm::BitVector &legalReadyCandidates, bool baselinePriorityStall,
      const waveamdmachine::InstructionScheduleModel &policy) const;

  FailureOr<ReadyScheduleDecision>
  selectMemoryReady(const llvm::BitVector &scheduled, unsigned baseline,
                    const llvm::BitVector &legalReadyCandidates,
                    bool prioritizeLongLatencyVmem,
                    const waveamdmachine::InstructionScheduleModel &policy,
                    ReadyScheduleIssueProvider issueProvider,
                    ReadyScheduleProjectionProvider projectionProvider) const;

  friend class WaveAMDMachineScheduleModel;
  struct Impl;
  explicit RegionScheduleSession(std::unique_ptr<Impl> impl);
  std::unique_ptr<Impl> impl;
};

struct RegionScheduleGraphFacts {
  ArrayRef<Operation *> operations;
  ArrayRef<SmallVector<unsigned, 4>> predecessors;
  ArrayRef<SmallVector<unsigned, 4>> successors;
  ArrayRef<SmallVector<unsigned, 4>> ssaPredecessors;
  ArrayRef<waveamdmachine::MemoryCounterKind> memoryKinds;
  ArrayRef<SmallVector<waveamdmachine::MemoryCounterKind, 4>> fillerMemoryKinds;
  ArrayRef<unsigned> memoryNodes;
  const llvm::DenseMap<Operation *, unsigned> &nodeIndices;
};

class WaveAMDMachineScheduleModel {
public:
  static FailureOr<WaveAMDMachineScheduleModel>
  create(func::FuncOp func, const waveamdmachine::ArchData &arch,
         unsigned wavefrontSize);

  WaveAMDMachineScheduleModel(WaveAMDMachineScheduleModel &&);
  WaveAMDMachineScheduleModel &operator=(WaveAMDMachineScheduleModel &&);
  ~WaveAMDMachineScheduleModel();

  WaveAMDMachineScheduleModel(const WaveAMDMachineScheduleModel &) = delete;
  WaveAMDMachineScheduleModel &
  operator=(const WaveAMDMachineScheduleModel &) = delete;

  waveamdmachine::InstructionExecutionConfig
  buildInstructionConfig(const waveamdmachine::EventSimConfig &config) const;
  unsigned getTargetWaveCount() const;

  FailureOr<SingleWaveScheduleDecision>
  selectSingleWaveSchedule(ArrayRef<Operation *> operations,
                           SingleWaveScheduleBuildProvider buildProvider) const;

  // Session owns noInstructions; graph fact storage must outlive it.
  RegionScheduleSession
  createRegionSession(const RegionScheduleGraphFacts &facts,
                      llvm::BitVector noInstructions,
                      const waveamdmachine::EventSimConfig &config) const;

private:
  struct Impl;
  explicit WaveAMDMachineScheduleModel(std::unique_ptr<Impl> impl);
  std::unique_ptr<Impl> impl;
};

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEMODEL_H
