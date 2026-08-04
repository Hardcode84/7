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
};

struct ReadyScheduleDecision {
  std::optional<unsigned> candidate;
  bool suppressFallback = false;
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

  FailureOr<ReadyScheduleDecision>
  selectStallFiller(const llvm::BitVector &scheduled, unsigned baseline,
                    const llvm::BitVector &legalReadyCandidates,
                    const ReadyScheduleStallFacts &stall,
                    const waveamdmachine::InstructionScheduleModel &policy,
                    ReadyScheduleIssueProvider issueProvider) const;

  bool canIssueBaselineDespiteStall(
      unsigned baseline, const ReadyScheduleIssueFacts &issue,
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

struct RegionScheduleGraphFacts {
  ArrayRef<Operation *> operations;
  ArrayRef<SmallVector<unsigned, 4>> predecessors;
  ArrayRef<SmallVector<unsigned, 4>> successors;
  ArrayRef<waveamdmachine::MemoryCounterKind> memoryKinds;
  ArrayRef<SmallVector<waveamdmachine::MemoryCounterKind, 4>> fillerMemoryKinds;
  ArrayRef<unsigned> memoryNodes;
  const llvm::DenseMap<Operation *, unsigned> &nodeIndices;
  const llvm::BitVector &computeRecurrenceCritical;
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
