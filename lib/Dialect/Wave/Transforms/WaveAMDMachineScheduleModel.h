//===- WaveAMDMachineScheduleModel.h - Machine scheduling policy -*- C++
//-*-===//
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

waveamdmachine::InstructionExecutionConfig buildWaveAMDMachineInstructionConfig(
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, Operation *context);

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
  // A single scheduler-selected candidate that still requires the model's
  // generic candidate admission.
  Direct,
  // A group of filler candidates. The model owns admission and ranking.
  RankedFiller,
  // A ready compute candidate described by raw execution and resource facts.
  // The model owns baseline eligibility, candidate compatibility, stall versus
  // priority classification, admission, and ranking.
  ComputeResource,
  // A raw ready candidate for latency prioritization. The session owns target
  // latency, barrier, memory-crossing, admission, and ranking policy.
  Latency,
  // A raw candidate for filling an already classified issue stall. The
  // session owns target/resource/memory compatibility and final admission.
  GenericStallFiller,
};

enum class ReadyScheduleStallKind : uint8_t {
  None,
  Cycle,
  MemoryToken,
  InstructionHazard,
};

struct ReadyScheduleStallFacts {
  ReadyScheduleStallKind kind = ReadyScheduleStallKind::None;
  int64_t issueCycle = 0;
  waveamdmachine::MemoryIssueResourceMask blockedMemoryResources = 0;
  waveamdmachine::InstructionStallKind reason =
      waveamdmachine::InstructionStallKind::None;
};

struct ReadyScheduleIssueFacts {
  int64_t operandWaitCycles = 0;
  int64_t memoryWaitCycles = 0;
  int64_t functionalUnitWaitCycles = 0;
  int64_t issueWaitCycles = 0;
  int64_t cuIssueWaitCycles = 0;
  int64_t cmaIssueWaitCycles = 0;
  int64_t coexecWindowWaitCycles = 0;
  unsigned hazardWaitInstructions = 0;
  int64_t issueCycle = 0;
};

struct ReadyScheduleResourceFacts {
  waveamdmachine::InstructionScheduleResourcePreview baseline;
  waveamdmachine::InstructionScheduleResourcePreview candidate;
  bool baselinePriorityStall = false;
  bool candidatePriorityStall = false;
  bool prioritize = false;
};

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
  // Lower groups are tried first. Candidates in one group form one
  // tournament: if its final winner is rejected, an earlier runner-up is not
  // revived.
  unsigned group = 0;
  // Only ComputeResource consumes these raw facts.
  ReadyScheduleResourceFacts resource;
  // Only Latency consumes these raw facts.
  ReadyScheduleLatencyFacts latency;
  // Only GenericStallFiller consumes these raw facts.
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
};

struct ReadyScheduleDecision {
  // No candidate means retain the baseline.
  std::optional<unsigned> candidate;
  // Pressure-selection provenance and diagnostics remain model-owned. This
  // only distinguishes a generic scheduler proposal from a model discovery.
  bool selectedProposal = false;
  // A proposal tournament produced an unsafe final winner. Callers may try an
  // explicit later proposal group, but must not manufacture an implicit
  // runner-up or recurrence fallback.
  bool suppressFallback = false;
  // Model-owned selection provenance. The scheduler may use this for
  // bookkeeping, but not to reconsider the choice.
  ReadyScheduleSelectionKind kind = ReadyScheduleSelectionKind::Baseline;
};

class RegionScheduleSession {
public:
  RegionScheduleSession(RegionScheduleSession &&);
  RegionScheduleSession &operator=(RegionScheduleSession &&);
  ~RegionScheduleSession();

  RegionScheduleSession(const RegionScheduleSession &) = delete;
  RegionScheduleSession &operator=(const RegionScheduleSession &) = delete;

  ReadyScheduleDecision
  selectNext(const llvm::BitVector &scheduled, unsigned baseline,
             const llvm::BitVector &legalReadyCandidates,
             ArrayRef<ReadyScheduleProposal> proposals,
             const waveamdmachine::InstructionScheduleModel &policy) const;

  ReadyScheduleDecision selectComputeResource(
      const llvm::BitVector &scheduled, unsigned baseline,
      const llvm::BitVector &legalReadyCandidates,
      ArrayRef<ReadyScheduleProposal> rawProposals,
      const waveamdmachine::InstructionScheduleModel &policy) const;

  llvm::BitVector getComputeResourceCandidates(
      const llvm::BitVector &scheduled, unsigned baseline,
      const llvm::BitVector &legalReadyCandidates) const;

  bool supportsLatencyPriority(bool enabled) const;
  llvm::BitVector getLatencyCandidates(
      const llvm::BitVector &scheduled, unsigned baseline,
      const llvm::BitVector &legalReadyCandidates, bool baselinePriorityStall,
      const waveamdmachine::InstructionScheduleModel &policy) const;

  llvm::BitVector getGenericStallFillerCandidates(
      const llvm::BitVector &scheduled, unsigned baseline,
      const llvm::BitVector &legalReadyCandidates,
      const ReadyScheduleStallFacts &stall,
      const waveamdmachine::InstructionScheduleModel &policy) const;

  ReadyScheduleStallFacts classifyStall(unsigned baseline,
                                        const ReadyScheduleIssueFacts &issue,
                                        bool blockMemoryResource) const;
  ReadyScheduleStallFacts
  classifyStall(unsigned baseline, const ReadyScheduleIssueFacts &issue,
                const waveamdmachine::InstructionScheduleModel &policy) const;

  ReadyScheduleWorkStats getWorkStats() const;

private:
  friend class WaveAMDMachineScheduleModel;
  struct Impl;
  explicit RegionScheduleSession(std::unique_ptr<Impl> impl);
  std::unique_ptr<Impl> impl;
};

// Owns the function liveness used by every region pressure decision.
class WaveAMDMachineScheduleModel {
public:
  static FailureOr<WaveAMDMachineScheduleModel> create(func::FuncOp func);

  WaveAMDMachineScheduleModel(WaveAMDMachineScheduleModel &&);
  WaveAMDMachineScheduleModel &operator=(WaveAMDMachineScheduleModel &&);
  ~WaveAMDMachineScheduleModel();

  WaveAMDMachineScheduleModel(const WaveAMDMachineScheduleModel &) = delete;
  WaveAMDMachineScheduleModel &
  operator=(const WaveAMDMachineScheduleModel &) = delete;

  RegionScheduleSession createRegionSession(
      ArrayRef<Operation *> operations,
      ArrayRef<SmallVector<unsigned, 4>> predecessors,
      ArrayRef<SmallVector<unsigned, 4>> successors,
      ArrayRef<waveamdmachine::MemoryCounterKind> memoryKinds,
      ArrayRef<SmallVector<waveamdmachine::MemoryCounterKind, 4>>
          fillerMemoryKinds,
      ArrayRef<unsigned> memoryNodes,
      const llvm::BitVector &computeRecurrenceCritical,
      const waveamdmachine::EventSimConfig &config) const;

private:
  struct Impl;
  explicit WaveAMDMachineScheduleModel(std::unique_ptr<Impl> impl);
  std::unique_ptr<Impl> impl;
};

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEMODEL_H
