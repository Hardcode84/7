//===- WaveAMDMachineScheduleModel.cpp - Machine scheduling model --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineScheduleModel.h"

#include "RegAlloc/WaveAMDRegAllocTransformState.h"
#include "RegAlloc/WaveAMDRegLiveIntervals.h"
#include "RegAlloc/WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/Support/ErrorHandling.h"

#include <algorithm>
#include <array>
#include <cassert>
#include <limits>
#include <optional>
#include <utility>

namespace mlir::wave {

static constexpr uint64_t kMaxFlatWorkgroupSize = 1024;

struct WorkgroupShape {
  std::array<uint32_t, 3> dims = {1, 1, 1};
  uint64_t flatSize = 1;
};

static FailureOr<unsigned>
parsePositiveUnsignedAttr(func::FuncOp func, StringRef name, Attribute raw) {
  IntegerAttr attr = dyn_cast<IntegerAttr>(raw);
  if (!attr)
    return func.emitError("Wave AMD machine schedule model ")
           << name << " must be an integer attribute";
  const APInt &value = attr.getValue();
  if (value.isZero() ||
      (!attr.getType().isUnsignedInteger() && value.isNegative()))
    return func.emitError("Wave AMD machine schedule model ")
           << name << " must be positive";
  if (value.getActiveBits() > std::numeric_limits<unsigned>::digits)
    return func.emitError("Wave AMD machine schedule model ")
           << name << " exceeds unsigned range";
  return static_cast<unsigned>(value.getZExtValue());
}

static FailureOr<WorkgroupShape>
parseWorkgroupShape(func::FuncOp func, StringRef name, Attribute raw) {
  DenseI32ArrayAttr attr = dyn_cast<DenseI32ArrayAttr>(raw);
  if (!attr)
    return func.emitError("Wave AMD machine schedule model ")
           << name << " must be a dense i32 array";
  if (attr.empty() || attr.size() > 3)
    return func.emitError("Wave AMD machine schedule model ")
           << name << " must have one to three dimensions";

  WorkgroupShape shape;
  for (auto [axis, dim] : llvm::enumerate(attr.asArrayRef())) {
    if (dim <= 0)
      return func.emitError("Wave AMD machine schedule model ")
             << name << " dimensions must be positive";
    uint64_t dimension = static_cast<uint64_t>(dim);
    if (shape.flatSize > std::numeric_limits<uint64_t>::max() / dimension)
      return func.emitError("Wave AMD machine schedule model ")
             << name << " product overflows uint64";
    shape.dims[axis] = static_cast<uint32_t>(dim);
    shape.flatSize *= dimension;
  }
  if (shape.flatSize > kMaxFlatWorkgroupSize)
    return func.emitError("Wave AMD machine schedule model ")
           << name << " exceeds target flat workgroup limit 1024";
  return shape;
}

static LogicalResult
mergeWorkgroupShapeAttr(func::FuncOp func, StringRef name, Attribute raw,
                        std::optional<WorkgroupShape> &shape) {
  if (!raw)
    return success();
  FailureOr<WorkgroupShape> candidate = parseWorkgroupShape(func, name, raw);
  if (failed(candidate))
    return failure();
  if (shape && shape->dims != candidate->dims)
    return func.emitError("Wave AMD machine schedule model conflicting ")
           << "workgroup shapes";
  shape = *candidate;
  return success();
}

static LogicalResult
mergeWorkgroupWaveCountAttr(func::FuncOp func, unsigned wavefrontSize,
                            Attribute raw,
                            std::optional<unsigned> &explicitWaves) {
  if (!raw)
    return success();
  FailureOr<unsigned> candidate =
      parsePositiveUnsignedAttr(func, "wave.waves_per_workgroup", raw);
  if (failed(candidate))
    return failure();
  if (*candidate > kMaxFlatWorkgroupSize / wavefrontSize)
    return func.emitError("Wave AMD machine schedule model ")
           << "wave.waves_per_workgroup exceeds target workgroup limit";
  if (explicitWaves && *explicitWaves != *candidate)
    return func.emitError("Wave AMD machine schedule model conflicting ")
           << "wave.waves_per_workgroup attributes";
  explicitWaves = *candidate;
  return success();
}

static FailureOr<std::optional<unsigned>>
resolveWorkgroupWaveCohort(func::FuncOp func, unsigned wavefrontSize) {
  std::optional<WorkgroupShape> shape;
  std::optional<unsigned> explicitWaves;
  for (Operation *op = func; op; op = op->getParentOp()) {
    for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
      if (failed(mergeWorkgroupShapeAttr(func, name, op->getAttr(name), shape)))
        return failure();
    }
    if (failed(mergeWorkgroupWaveCountAttr(
            func, wavefrontSize, op->getAttr("wave.waves_per_workgroup"),
            explicitWaves)))
      return failure();
  }

  if (!shape)
    return explicitWaves;
  unsigned derivedWaves = static_cast<unsigned>(
      llvm::divideCeil(shape->flatSize, static_cast<uint64_t>(wavefrontSize)));
  if (explicitWaves && *explicitWaves != derivedWaves)
    return func.emitError("Wave AMD machine schedule model ")
           << "wave.waves_per_workgroup conflicts with workgroup shape";
  return std::optional<unsigned>(explicitWaves.value_or(derivedWaves));
}

static FailureOr<unsigned> resolveTargetWaveCount(func::FuncOp func,
                                                  unsigned maxWavesPerEU) {
  std::optional<unsigned> targetWaves;
  for (Operation *op = func; op; op = op->getParentOp()) {
    Attribute raw = op->getAttr("waveamdmachine.target_waves");
    if (!raw)
      continue;
    FailureOr<unsigned> candidate =
        parsePositiveUnsignedAttr(func, "waveamdmachine.target_waves", raw);
    if (failed(candidate))
      return failure();
    if (*candidate > maxWavesPerEU)
      return func.emitError("Wave AMD machine schedule model ")
             << "waveamdmachine.target_waves exceeds target wave capacity";
    if (targetWaves && *targetWaves != *candidate)
      return func.emitError("Wave AMD machine schedule model conflicting ")
             << "waveamdmachine.target_waves attributes";
    targetWaves = *candidate;
  }
  return targetWaves.value_or(1);
}

static FailureOr<waveamdmachine::ReadyRegisterPressureLimits>
buildReadyPressureLimits(func::FuncOp func,
                         const WaveAMDRegisterLimits &targetLimits,
                         unsigned targetWaves) {
  waveamdmachine::ReadyRegisterPressureLimits limits;
  limits.sgpr =
      getRegAllocTransformBudget(func, waveamdmachine::RegClass::SGPR).limit;
  limits.vgpr =
      getRegAllocTransformBudget(func, waveamdmachine::RegClass::VGPR).limit;
  limits.agpr =
      getRegAllocTransformBudget(func, waveamdmachine::RegClass::AGPR).limit;
  limits.sgprAllocGranule = targetLimits.sgprAllocGranule;
  limits.vgprAllocGranule = targetLimits.vgprAllocGranule;
  limits.agprAllocGranule = targetLimits.agprAllocGranule;
  if (limits.sgprAllocGranule == 0 || limits.vgprAllocGranule == 0 ||
      limits.agprAllocGranule == 0)
    return func.emitError(
        "Wave AMD machine schedule model has invalid allocation granules");
  if (targetLimits.agprCountsAgainstVGPRs) {
    limits.vgprFamily = getMaxWaveAMDRegisterBudgetForWaves(
        targetLimits.maxVGPRsForWaves, targetWaves);
    if (limits.vgprFamily == 0)
      return func.emitError(
          "Wave AMD machine schedule model has no VGPR-family budget");
  }
  return limits;
}

class ReadyScheduleState {
public:
  SmallVector<unsigned, 0> slotUseCounts;
  llvm::BitVector liveMembers;
  waveamdmachine::ReadyRegisterPressure pressure;
};

namespace {

struct ReadyPressureMember {
  SmallVector<unsigned, 4> useNodes;
  Value value;
  unsigned slot = 0;
  unsigned width = 0;
  unsigned defNode = std::numeric_limits<unsigned>::max();
  waveamdmachine::RegClass regClass = waveamdmachine::RegClass::VGPR;
  bool availableBeforeRegion = false;
  bool liveAfterRegion = false;
};

struct ReadyPressureProjectionState {
  explicit ReadyPressureProjectionState(const ReadyScheduleState &base)
      : base(base), pressure(base.pressure) {}

  unsigned getSlotUseCount(unsigned slot) const {
    auto override = slotUseCountOverrides.find(slot);
    return override == slotUseCountOverrides.end() ? base.slotUseCounts[slot]
                                                   : override->second;
  }

  void setSlotUseCount(unsigned slot, unsigned count) {
    slotUseCountOverrides[slot] = count;
  }

  bool isMemberLive(unsigned member) const {
    auto override = liveMemberOverrides.find(member);
    return override == liveMemberOverrides.end() ? base.liveMembers.test(member)
                                                 : override->second;
  }

  void setMemberLive(unsigned member, bool live) {
    liveMemberOverrides[member] = live;
  }

  const ReadyScheduleState &base;
  llvm::SmallDenseMap<unsigned, unsigned, 16> slotUseCountOverrides;
  llvm::SmallDenseMap<unsigned, bool, 16> liveMemberOverrides;
  waveamdmachine::ReadyRegisterPressure pressure;
};

struct ReadyPressureProjectionSchedule {
  explicit ReadyPressureProjectionSchedule(const llvm::BitVector &base)
      : base(base) {}

  bool test(unsigned node) const {
    return base.test(node) || projected.contains(node);
  }

  void set(unsigned node) {
    bool inserted = projected.insert(node).second;
    assert(inserted && "ready pressure projection repeats a node");
  }

  const llvm::BitVector &base;
  llvm::SmallDenseSet<unsigned, 16> projected;
};

struct ReadyPressureProjection {
  waveamdmachine::ReadyRegisterPressure finalDelta;
  waveamdmachine::ReadyRegisterPressure peakDelta;
  int64_t vgprFamilyPeakDelta = 0;
  unsigned autoDrainedNodes = 0;
};

struct ReadyPressureSlotTransitions {
  unsigned births = 0;
  unsigned deaths = 0;
};

static void
addReadyPressureSlot(waveamdmachine::ReadyRegisterPressure &pressure,
                     waveamdmachine::RegClass regClass, int64_t delta) {
  switch (regClass) {
  case waveamdmachine::RegClass::SGPR:
    pressure.sgpr += delta;
    return;
  case waveamdmachine::RegClass::VGPR:
    pressure.vgpr += delta;
    return;
  case waveamdmachine::RegClass::AGPR:
    pressure.agpr += delta;
    return;
  case waveamdmachine::RegClass::SCC:
  case waveamdmachine::RegClass::VCC:
    llvm_unreachable("flags do not have ready-pressure slots");
  }
  llvm_unreachable("unknown ready-pressure register class");
}

} // namespace

struct WaveAMDMachineScheduleModel::Impl {
  WaveAMDLiveIntervalBuildResult liveness;
  waveamdmachine::ReadyRegisterPressureLimits pressureLimits;
  const waveamdmachine::ArchData *arch = nullptr;
  unsigned targetWaveCount = 1;
  unsigned readyPressureWaveCohort = 1;
  unsigned wavefrontSize = 64;
};

struct RegionScheduleSession::Impl {
  const ReadyScheduleState &getState(const llvm::BitVector &scheduled) const {
    if (cachedState && cachedScheduled == scheduled)
      return *cachedState;
    cachedScheduled = scheduled;
    cachedState.emplace();
    ReadyScheduleState &state = *cachedState;
    state.slotUseCounts.resize(slotClasses.size());
    state.liveMembers.resize(members.size());
    ++work.stateBuilds;
    work.memberVisits += members.size();
    for (auto [memberIndex, member] : llvm::enumerate(members)) {
      if (!isLive(member, scheduled))
        continue;
      state.liveMembers.set(memberIndex);
      for (unsigned slot : llvm::seq(member.slot, member.slot + member.width))
        if (state.slotUseCounts[slot]++ == 0)
          addReadyPressureSlot(state.pressure, member.regClass, 1);
    }
    return state;
  }

  ReadyPressureProjection getProjection(const llvm::BitVector &scheduled,
                                        ArrayRef<unsigned> sequence,
                                        const ReadyScheduleState &state) const {
    ++work.projections;
    ReadyPressureProjectionSchedule projectedSchedule(scheduled);
    ReadyPressureProjectionState projectedState(state);
    waveamdmachine::ReadyRegisterPressure peak = state.pressure;
    int64_t vgprFamilyPeak = state.pressure.vgpr + state.pressure.agpr;
    unsigned projectedNodeCount = 0;
    auto replay = [&](unsigned node) {
      ++projectedNodeCount;
      DenseMap<unsigned, ReadyPressureSlotTransitions> slotTransitions;
      recordProjectedTransitions(projectedSchedule, node, projectedState,
                                 slotTransitions);
      applySlotTransitions(projectedState, slotTransitions, /*births=*/true);
      peak.sgpr = std::max(peak.sgpr, projectedState.pressure.sgpr);
      peak.vgpr = std::max(peak.vgpr, projectedState.pressure.vgpr);
      peak.agpr = std::max(peak.agpr, projectedState.pressure.agpr);
      vgprFamilyPeak =
          std::max(vgprFamilyPeak,
                   projectedState.pressure.vgpr + projectedState.pressure.agpr);
      applySlotTransitions(projectedState, slotTransitions, /*births=*/false);
    };
    for (unsigned candidate : sequence)
      projectCandidate(projectedSchedule, candidate, replay);
    work.projectedNodes += projectedNodeCount;
    return {{projectedState.pressure.sgpr - state.pressure.sgpr,
             projectedState.pressure.vgpr - state.pressure.vgpr,
             projectedState.pressure.agpr - state.pressure.agpr},
            {peak.sgpr - state.pressure.sgpr, peak.vgpr - state.pressure.vgpr,
             peak.agpr - state.pressure.agpr},
            vgprFamilyPeak - state.pressure.vgpr - state.pressure.agpr,
            projectedNodeCount - static_cast<unsigned>(sequence.size())};
  }

  waveamdmachine::ReadyCandidateMetrics
  getSequenceMetrics(const llvm::BitVector &scheduled,
                     ArrayRef<unsigned> sequence,
                     const ReadyScheduleState &state) const {
    ReadyPressureProjection projection =
        getProjection(scheduled, sequence, state);
    return {projection.finalDelta, projection.peakDelta,
            projection.vgprFamilyPeakDelta, pressureCeiling,
            projection.autoDrainedNodes};
  }

  waveamdmachine::ReadyCandidateMetrics
  getCandidateMetrics(const llvm::BitVector &scheduled, unsigned candidate,
                      const ReadyScheduleState &state) const {
    return getSequenceMetrics(scheduled, ArrayRef<unsigned>(candidate), state);
  }

  std::pair<waveamdmachine::ReadyCandidateMetrics,
            waveamdmachine::ReadyCandidateMetrics>
  getOrderMetrics(const llvm::BitVector &scheduled, unsigned candidate,
                  unsigned baseline, const ReadyScheduleState &state) const {
    std::array<unsigned, 2> candidateFirst = {candidate, baseline};
    std::array<unsigned, 2> baselineFirst = {baseline, candidate};
    return {getSequenceMetrics(scheduled, candidateFirst, state),
            getSequenceMetrics(scheduled, baselineFirst, state)};
  }

  std::pair<waveamdmachine::ReadyCandidateMetrics,
            waveamdmachine::ReadyCandidateMetrics>
  getFullPrefixMetrics(const llvm::BitVector &scheduled, unsigned candidate,
                       unsigned baseline,
                       const ReadyScheduleState &state) const {
    assert(baseline <= candidate && "ready candidate precedes baseline");
    SmallVector<unsigned, 16> originalPrefix;
    SmallVector<unsigned, 16> movedPrefix;
    movedPrefix.push_back(candidate);
    for (unsigned index : llvm::seq(baseline, candidate + 1)) {
      if (scheduled.test(index) || noInstructions.test(index))
        continue;
      originalPrefix.push_back(index);
      if (index != candidate)
        movedPrefix.push_back(index);
    }
    assert(!originalPrefix.empty() && originalPrefix.back() == candidate &&
           "ready candidate missing from original prefix");
    return {getSequenceMetrics(scheduled, movedPrefix, state),
            getSequenceMetrics(scheduled, originalPrefix, state)};
  }

  bool hasSafeFullPrefix(
      const llvm::BitVector &scheduled, unsigned candidate, unsigned baseline,
      const ReadyScheduleState &state,
      const waveamdmachine::InstructionScheduleModel &policy) const {
    if (candidate <= baseline)
      return true;
    std::pair<waveamdmachine::ReadyCandidateMetrics,
              waveamdmachine::ReadyCandidateMetrics>
        metrics = getFullPrefixMetrics(scheduled, candidate, baseline, state);
    return policy.canSelectReadyFullPrefix(state.pressure, metrics.first,
                                           metrics.second);
  }

  bool isPressureCandidate(const llvm::BitVector &scheduled, unsigned baseline,
                           const llvm::BitVector &legalReadyCandidates,
                           unsigned candidate) const {
    if (candidate <= baseline || !legalReadyCandidates.test(candidate) ||
        scheduled.test(candidate))
      return false;
    Operation *op = operations[candidate];
    if (!isPure(op) ||
        isa<waveamdmachine::BarrierWaitOp, waveamdmachine::ClusterBarrierOp,
            waveamdmachine::SBarrierOp>(op))
      return false;
    if (waveamdmachine::getMemoryCounterKind(op) !=
        waveamdmachine::MemoryCounterKind::None)
      return false;
    waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
    if (cls == waveamdmachine::SchedClass::NoInst)
      return true;
    return waveamdmachine::getInstructionScheduleResourceInfo(op, cls, *arch,
                                                              wavefrontSize)
        .tracked;
  }

  std::optional<unsigned> selectPressureCandidate(
      const llvm::BitVector &scheduled, unsigned baseline,
      const llvm::BitVector &legalReadyCandidates,
      const ReadyScheduleState &state,
      const waveamdmachine::ReadyCandidateMetrics &baselineMetrics,
      const waveamdmachine::InstructionScheduleModel &policy) const {
    waveamdmachine::ReadyCandidateMetrics winnerMetrics = baselineMetrics;
    unsigned winnerIndex = baseline;
    std::optional<unsigned> winner;
    for (int candidate = legalReadyCandidates.find_first(); candidate >= 0;
         candidate = legalReadyCandidates.find_next(candidate)) {
      unsigned index = candidate;
      if (!isPressureCandidate(scheduled, baseline, legalReadyCandidates,
                               index))
        continue;
      waveamdmachine::ReadyCandidateMetrics candidateMetrics =
          getCandidateMetrics(scheduled, index, state);
      std::pair<waveamdmachine::ReadyCandidateMetrics,
                waveamdmachine::ReadyCandidateMetrics>
          order = getOrderMetrics(scheduled, index, winnerIndex, state);
      if (!policy.shouldPreferReadyPressure(state.pressure, candidateMetrics,
                                            order.first, order.second,
                                            winnerMetrics))
        continue;
      winnerMetrics = candidateMetrics;
      winnerIndex = index;
      winner = index;
    }
    return winner;
  }

  struct ProposalWinner {
    std::optional<waveamdmachine::ReadyCandidateMetrics> metrics;
    std::optional<unsigned> candidate;
    uint64_t rank = 0;
  };

  static void setProposalWinner(
      unsigned candidate,
      const waveamdmachine::ReadyCandidateMetrics &candidateMetrics,
      uint64_t rank, ProposalWinner &winner) {
    winner.metrics = candidateMetrics;
    winner.candidate = candidate;
    winner.rank = rank;
  }

  static void considerDirectProposal(
      const ReadyScheduleProposal &proposal,
      const waveamdmachine::ReadyCandidateMetrics &candidateMetrics,
      const waveamdmachine::ReadyCandidateMetrics &candidateFirst,
      const ReadyScheduleState &state,
      const waveamdmachine::ReadyCandidateMetrics &baselineMetrics,
      const waveamdmachine::InstructionScheduleModel &policy,
      ProposalWinner &winner) {
    if (!policy.canSelectReadyCandidate(state.pressure, candidateFirst,
                                        baselineMetrics))
      return;
    setProposalWinner(proposal.candidate, candidateMetrics, proposal.rank,
                      winner);
  }

  static void considerResourcePriorityProposal(
      const ReadyScheduleProposal &proposal,
      const waveamdmachine::ReadyCandidateMetrics &candidateMetrics,
      const waveamdmachine::ReadyCandidateMetrics &candidateFirst,
      const ReadyScheduleState &state,
      const waveamdmachine::ReadyCandidateMetrics &baselineMetrics,
      const waveamdmachine::InstructionScheduleModel &policy,
      ProposalWinner &winner) {
    if (winner.candidate && proposal.rank <= winner.rank)
      return;
    if (!policy.canSelectReadyCandidate(state.pressure, candidateFirst,
                                        baselineMetrics))
      return;
    setProposalWinner(proposal.candidate, candidateMetrics, proposal.rank,
                      winner);
  }

  static void considerFillerProposal(
      const ReadyScheduleProposal &proposal,
      const waveamdmachine::ReadyCandidateMetrics &candidateMetrics,
      const waveamdmachine::ReadyCandidateMetrics &candidateFirst,
      const ReadyScheduleState &state,
      const waveamdmachine::ReadyCandidateMetrics &baselineMetrics,
      const waveamdmachine::InstructionScheduleModel &policy,
      ProposalWinner &winner) {
    if (!policy.canSelectReadyFiller(state.pressure, candidateMetrics,
                                     candidateFirst, baselineMetrics))
      return;
    if (winner.metrics &&
        !policy.shouldPreferReadyFiller(state.pressure, candidateMetrics,
                                        *winner.metrics))
      return;
    setProposalWinner(proposal.candidate, candidateMetrics, proposal.rank,
                      winner);
  }

  static void considerProposal(
      const ReadyScheduleProposal &proposal,
      const waveamdmachine::ReadyCandidateMetrics &candidateMetrics,
      const waveamdmachine::ReadyCandidateMetrics &candidateFirst,
      const ReadyScheduleState &state,
      const waveamdmachine::ReadyCandidateMetrics &baselineMetrics,
      const waveamdmachine::InstructionScheduleModel &policy,
      ProposalWinner &winner) {
    switch (proposal.kind) {
    case ReadyScheduleProposalKind::Direct:
      return considerDirectProposal(proposal, candidateMetrics, candidateFirst,
                                    state, baselineMetrics, policy, winner);
    case ReadyScheduleProposalKind::ResourcePriority:
      return considerResourcePriorityProposal(proposal, candidateMetrics,
                                              candidateFirst, state,
                                              baselineMetrics, policy, winner);
    case ReadyScheduleProposalKind::RankedFiller:
    case ReadyScheduleProposalKind::ResourceStallFiller:
      return considerFillerProposal(proposal, candidateMetrics, candidateFirst,
                                    state, baselineMetrics, policy, winner);
    }
    llvm_unreachable("unknown ready proposal kind");
  }

  static void
  assertConsistentProposalGroup(const ReadyScheduleProposal &groupInfo,
                                const ReadyScheduleProposal &proposal) {
    assert(groupInfo.kind == proposal.kind &&
           "ready proposal group mixes selection policies");
    assert((proposal.kind != ReadyScheduleProposalKind::ResourceStallFiller ||
            (proposal.waitSlots == groupInfo.waitSlots &&
             proposal.releaseSlots == groupInfo.releaseSlots)) &&
           "resource filler group mixes baseline previews");
  }

  std::optional<unsigned> selectProposalGroupCandidate(
      unsigned group, const ReadyScheduleProposal &groupInfo,
      const llvm::BitVector &scheduled, unsigned baseline,
      const ReadyScheduleState &state,
      const waveamdmachine::ReadyCandidateMetrics &baselineMetrics,
      ArrayRef<ReadyScheduleProposal> proposals,
      const waveamdmachine::InstructionScheduleModel &policy) const {
    ProposalWinner winner;
    for (const ReadyScheduleProposal &proposal : proposals) {
      if (proposal.group != group)
        continue;
      assertConsistentProposalGroup(groupInfo, proposal);
      unsigned candidate = proposal.candidate;
      if (candidate >= operations.size() || candidate == baseline ||
          scheduled.test(candidate))
        continue;
      waveamdmachine::ReadyCandidateMetrics candidateMetrics =
          getCandidateMetrics(scheduled, candidate, state);
      std::pair<waveamdmachine::ReadyCandidateMetrics,
                waveamdmachine::ReadyCandidateMetrics>
          order = getOrderMetrics(scheduled, candidate, baseline, state);
      considerProposal(proposal, candidateMetrics, order.first, state,
                       baselineMetrics, policy, winner);
    }
    return winner.candidate;
  }

  static SmallVector<unsigned, 8>
  getProposalGroups(ArrayRef<ReadyScheduleProposal> proposals) {
    SmallVector<unsigned, 8> groups;
    for (const ReadyScheduleProposal &proposal : proposals)
      if (!llvm::is_contained(groups, proposal.group))
        groups.push_back(proposal.group);
    llvm::sort(groups);
    return groups;
  }

  static const ReadyScheduleProposal &
  getProposalGroupInfo(unsigned group,
                       ArrayRef<ReadyScheduleProposal> proposals) {
    ArrayRef<ReadyScheduleProposal>::iterator groupInfo = llvm::find_if(
        proposals, [group](const ReadyScheduleProposal &proposal) {
          return proposal.group == group;
        });
    assert(groupInfo != proposals.end() && "missing ready proposal group");
    return *groupInfo;
  }

  static bool shouldEvaluateProposalGroup(
      const ReadyScheduleProposal &groupInfo, const ReadyScheduleState &state,
      const waveamdmachine::ReadyCandidateMetrics &baselineMetrics,
      const waveamdmachine::InstructionScheduleModel &policy) {
    return groupInfo.kind != ReadyScheduleProposalKind::ResourceStallFiller ||
           policy.shouldSelectResourceStallFiller(
               groupInfo.waitSlots, groupInfo.releaseSlots, state.pressure,
               baselineMetrics);
  }

  template <typename Replay>
  void projectCandidate(ReadyPressureProjectionSchedule &projected,
                        unsigned candidate, Replay &&replay) const {
    assert(!projected.test(candidate) &&
           "ready pressure sequence repeats a node");
    projected.set(candidate);
    replay(candidate);
    SmallVector<unsigned, 4> readyNoInsts;
    auto unlockNoInsts = [&](unsigned source) {
      for (unsigned node : successors[source]) {
        ++work.projectionChecks;
        if (!noInstructions.test(node) || projected.test(node) ||
            !llvm::all_of(predecessors[node], [&](unsigned dependency) {
              return projected.test(dependency);
            }))
          continue;
        auto insertion = llvm::lower_bound(readyNoInsts, node);
        if (insertion == readyNoInsts.end() || *insertion != node)
          readyNoInsts.insert(insertion, node);
      }
    };
    unlockNoInsts(candidate);
    while (!readyNoInsts.empty()) {
      unsigned node = readyNoInsts.front();
      readyNoInsts.erase(readyNoInsts.begin());
      projected.set(node);
      replay(node);
      unlockNoInsts(node);
    }
  }

  void recordProjectedTransitions(
      const ReadyPressureProjectionSchedule &projected, unsigned node,
      ReadyPressureProjectionState &state,
      DenseMap<unsigned, ReadyPressureSlotTransitions> &slotTransitions) const {
    llvm::SmallPtrSet<Value, 16> visited;
    Operation *op = operations[node];
    for (Value operand : op->getOperands())
      recordTransition(operand, projected, state, slotTransitions,
                       /*definition=*/false, visited);
    for (Value result : op->getResults())
      recordTransition(result, projected, state, slotTransitions,
                       /*definition=*/true, visited);
  }

  void applySlotTransitions(
      ReadyPressureProjectionState &state,
      const DenseMap<unsigned, ReadyPressureSlotTransitions> &slotTransitions,
      bool births) const {
    for (auto [slot, transitions] : slotTransitions) {
      int delta = births ? static_cast<int>(transitions.births)
                         : -static_cast<int>(transitions.deaths);
      int oldCount = static_cast<int>(state.getSlotUseCount(slot));
      int newCount = oldCount + delta;
      assert(newCount >= 0 && "ready pressure slot count underflow");
      if (oldCount == 0 && newCount != 0)
        addReadyPressureSlot(state.pressure, slotClasses[slot], 1);
      else if (oldCount != 0 && newCount == 0)
        addReadyPressureSlot(state.pressure, slotClasses[slot], -1);
      state.setSlotUseCount(slot, static_cast<unsigned>(newCount));
    }
  }

  template <typename Schedule>
  bool isLive(const ReadyPressureMember &member,
              const Schedule &scheduled) const {
    bool available = member.availableBeforeRegion;
    if (member.defNode != std::numeric_limits<unsigned>::max())
      available = scheduled.test(member.defNode);
    if (!available)
      return false;
    if (member.liveAfterRegion)
      return true;
    return llvm::any_of(member.useNodes,
                        [&](unsigned use) { return !scheduled.test(use); });
  }

  void recordTransition(
      Value value, const ReadyPressureProjectionSchedule &projected,
      ReadyPressureProjectionState &state,
      DenseMap<unsigned, ReadyPressureSlotTransitions> &slotTransitions,
      bool definition, llvm::SmallPtrSetImpl<Value> &visited) const {
    if (!visited.insert(value).second)
      return;
    auto memberIt = memberByValue.find(value);
    if (memberIt == memberByValue.end())
      return;
    unsigned memberIndex = memberIt->second;
    const ReadyPressureMember &member = members[memberIndex];
    bool before = state.isMemberLive(memberIndex);
    bool after = isLive(member, projected);
    if (before == after) {
      if (!before && definition)
        for (unsigned slot :
             llvm::seq(member.slot, member.slot + member.width)) {
          ++slotTransitions[slot].births;
          ++slotTransitions[slot].deaths;
        }
      return;
    }
    state.setMemberLive(memberIndex, after);
    for (unsigned slot : llvm::seq(member.slot, member.slot + member.width)) {
      ReadyPressureSlotTransitions &transitions = slotTransitions[slot];
      if (after)
        ++transitions.births;
      else
        ++transitions.deaths;
    }
  }

  static void
  collectMemberUseNodes(ReadyPressureMember &member, Value value,
                        const DenseMap<Operation *, unsigned> &nodes) {
    for (OpOperand &use : value.getUses()) {
      DenseMap<Operation *, unsigned>::const_iterator useIt =
          nodes.find(use.getOwner());
      if (useIt != nodes.end() &&
          !llvm::is_contained(member.useNodes, useIt->second))
        member.useNodes.push_back(useIt->second);
    }
  }

  static std::optional<ReadyPressureMember>
  buildMember(Value value, unsigned offset, unsigned start, unsigned end,
              waveamdmachine::RegClass regClass,
              const DenseMap<Operation *, unsigned> &nodes,
              unsigned regionStart, unsigned regionEnd) {
    if (end < regionStart || start > regionEnd)
      return std::nullopt;
    ReadyPressureMember member;
    member.value = value;
    member.regClass = regClass;
    member.slot = offset;
    member.width = cast<waveamdmachine::RegType>(value.getType()).getWidth();
    Operation *def = value.getDefiningOp();
    auto defIt = def ? nodes.find(def) : nodes.end();
    if (defIt != nodes.end())
      member.defNode = defIt->second;
    else
      member.availableBeforeRegion = start <= regionStart;
    member.liveAfterRegion = end > regionEnd;
    collectMemberUseNodes(member, value, nodes);
    if (member.defNode == std::numeric_limits<unsigned>::max() &&
        (!member.availableBeforeRegion ||
         (!member.liveAfterRegion && member.useNodes.empty())))
      return std::nullopt;
    return member;
  }

  void appendInterval(const WaveAMDLiveInterval &interval,
                      waveamdmachine::RegClass regClass,
                      const DenseMap<Operation *, unsigned> &nodes,
                      unsigned regionStart, unsigned regionEnd) {
    if (interval.values.empty())
      return;
    SmallVector<ReadyPressureMember, 4> intervalMembers;
    for (auto [value, offset, start, end] :
         llvm::zip(interval.values, interval.slotOffsets, interval.valueStarts,
                   interval.valueEnds)) {
      std::optional<ReadyPressureMember> member = buildMember(
          value, offset, start, end, regClass, nodes, regionStart, regionEnd);
      if (member)
        intervalMembers.push_back(std::move(*member));
    }
    if (intervalMembers.empty())
      return;
    unsigned intervalBase = slotClasses.size();
    slotClasses.resize(intervalBase + interval.type.getWidth(), regClass);
    for (ReadyPressureMember &member : intervalMembers) {
      member.slot += intervalBase;
      memberByValue[member.value] = members.size();
      members.push_back(std::move(member));
    }
  }

  void appendIntervals(ArrayRef<WaveAMDLiveInterval> intervals,
                       waveamdmachine::RegClass regClass,
                       const DenseMap<Operation *, unsigned> &nodes,
                       unsigned regionStart, unsigned regionEnd) {
    for (const WaveAMDLiveInterval &interval : intervals)
      appendInterval(interval, regClass, nodes, regionStart, regionEnd);
  }

  struct PressureEvent {
    unsigned position;
    unsigned slot;
    int delta;
  };

  static void appendPressureEvents(const ReadyPressureMember &member,
                                   unsigned regionSize,
                                   SmallVectorImpl<PressureEvent> &events) {
    unsigned start = member.availableBeforeRegion ? 0 : member.defNode + 1;
    unsigned end = regionSize + 1;
    if (!member.liveAfterRegion && member.useNodes.empty())
      end = start;
    else if (!member.liveAfterRegion)
      end = *llvm::max_element(member.useNodes) + 1;
    assert(start <= end && "ready pressure member has reversed lifetime");
    for (unsigned slot : llvm::seq(member.slot, member.slot + member.width)) {
      events.push_back({start, slot, 1});
      events.push_back({end, slot, -1});
    }
  }

  void applyPressureEvent(const PressureEvent &event,
                          SmallVectorImpl<unsigned> &slotUseCounts,
                          waveamdmachine::ReadyRegisterPressure &pressure) {
    unsigned &count = slotUseCounts[event.slot];
    if (event.delta > 0) {
      if (count++ == 0)
        addReadyPressureSlot(pressure, slotClasses[event.slot], 1);
      return;
    }
    assert(count > 0 && "ready pressure slot count underflow");
    if (--count == 0)
      addReadyPressureSlot(pressure, slotClasses[event.slot], -1);
  }

  void
  updatePressureCeiling(const waveamdmachine::ReadyRegisterPressure &pressure) {
    pressureCeiling.sgpr =
        std::max(pressureCeiling.sgpr, static_cast<unsigned>(pressure.sgpr));
    pressureCeiling.vgpr =
        std::max(pressureCeiling.vgpr, static_cast<unsigned>(pressure.vgpr));
    pressureCeiling.agpr =
        std::max(pressureCeiling.agpr, static_cast<unsigned>(pressure.agpr));
    pressureCeiling.vgprFamily =
        std::max(pressureCeiling.vgprFamily,
                 static_cast<unsigned>(pressure.vgpr + pressure.agpr));
  }

  void initializePressureCeiling() {
    SmallVector<PressureEvent, 16> events;
    for (const ReadyPressureMember &member : members)
      appendPressureEvents(member, operations.size(), events);
    llvm::sort(events, [](PressureEvent lhs, PressureEvent rhs) {
      return lhs.position < rhs.position;
    });

    SmallVector<unsigned, 0> slotUseCounts(slotClasses.size());
    waveamdmachine::ReadyRegisterPressure pressure;
    for (unsigned first = 0; first < events.size();) {
      unsigned last = first;
      while (last < events.size() &&
             events[last].position == events[first].position) {
        if (events[last].delta > 0)
          applyPressureEvent(events[last], slotUseCounts, pressure);
        ++last;
      }
      updatePressureCeiling(pressure);
      for (unsigned index = first; index < last; ++index)
        if (events[index].delta < 0)
          applyPressureEvent(events[index], slotUseCounts, pressure);
      first = last;
    }
  }

  void initialize(const WaveAMDLiveIntervalBuildResult &liveness) {
    DenseMap<Operation *, unsigned> nodes;
    for (auto [index, op] : llvm::enumerate(operations))
      nodes[op] = index;
    if (operations.empty())
      return;
    DenseMap<Operation *, unsigned>::const_iterator first =
        liveness.positions.find(operations.front());
    DenseMap<Operation *, unsigned>::const_iterator last =
        liveness.positions.find(operations.back());
    if (first == liveness.positions.end() || last == liveness.positions.end())
      return;
    unsigned regionStart = std::min(first->second, last->second);
    unsigned regionEnd = std::max(first->second, last->second);
    appendIntervals(liveness.intervals.sgprs, waveamdmachine::RegClass::SGPR,
                    nodes, regionStart, regionEnd);
    appendIntervals(liveness.intervals.vgprs, waveamdmachine::RegClass::VGPR,
                    nodes, regionStart, regionEnd);
    appendIntervals(liveness.intervals.agprs, waveamdmachine::RegClass::AGPR,
                    nodes, regionStart, regionEnd);
    initializePressureCeiling();
  }

  DenseMap<Value, unsigned> memberByValue;
  SmallVector<ReadyPressureMember, 0> members;
  SmallVector<waveamdmachine::RegClass, 0> slotClasses;
  mutable std::optional<ReadyScheduleState> cachedState;
  mutable llvm::BitVector cachedScheduled;
  llvm::BitVector noInstructions;
  mutable ReadyScheduleWorkStats work;
  ArrayRef<Operation *> operations;
  ArrayRef<SmallVector<unsigned, 4>> predecessors;
  ArrayRef<SmallVector<unsigned, 4>> successors;
  const waveamdmachine::ArchData *arch = nullptr;
  waveamdmachine::ReadyRegisterPressureCeiling pressureCeiling;
  unsigned wavefrontSize = 64;
};

FailureOr<WaveAMDMachineScheduleModel>
WaveAMDMachineScheduleModel::create(func::FuncOp func,
                                    const waveamdmachine::ArchData &arch,
                                    unsigned wavefrontSize) {
  assert((wavefrontSize == 32 || wavefrontSize == 64) &&
         "invalid verified wavefront size");
  FailureOr<WaveAMDRegisterLimits> targetLimits =
      getWaveAMDRegisterLimits(func);
  if (failed(targetLimits))
    return failure();
  unsigned maxWavesPerEU = std::min(static_cast<unsigned>(arch.wavesPerSIMD),
                                    targetLimits->maxWavesPerEU);
  if (maxWavesPerEU == 0)
    return func.emitError(
        "Wave AMD machine schedule model has zero target wave capacity");
  FailureOr<unsigned> targetWaves = resolveTargetWaveCount(func, maxWavesPerEU);
  FailureOr<std::optional<unsigned>> workgroupWaves =
      resolveWorkgroupWaveCohort(func, wavefrontSize);
  if (failed(targetWaves) || failed(workgroupWaves))
    return failure();
  FailureOr<waveamdmachine::ReadyRegisterPressureLimits> pressureLimits =
      buildReadyPressureLimits(func, *targetLimits, *targetWaves);
  if (failed(pressureLimits))
    return failure();
  FailureOr<WaveAMDLiveIntervalBuildResult> liveness =
      buildAllocatedWaveAMDLiveIntervals(
          func, WaveAMDLiveIntervalOrderOverride{},
          WaveAMDLiveIntervalAliasPolicy::Conservative);
  if (failed(liveness))
    return failure();
  auto impl = std::make_unique<Impl>();
  impl->liveness = std::move(*liveness);
  impl->pressureLimits = *pressureLimits;
  impl->arch = &arch;
  impl->targetWaveCount = *targetWaves;
  impl->readyPressureWaveCohort = workgroupWaves->value_or(*targetWaves);
  impl->wavefrontSize = wavefrontSize;
  return WaveAMDMachineScheduleModel(std::move(impl));
}

WaveAMDMachineScheduleModel::WaveAMDMachineScheduleModel(
    std::unique_ptr<Impl> impl)
    : impl(std::move(impl)) {}
WaveAMDMachineScheduleModel::WaveAMDMachineScheduleModel(
    WaveAMDMachineScheduleModel &&) = default;
WaveAMDMachineScheduleModel &WaveAMDMachineScheduleModel::operator=(
    WaveAMDMachineScheduleModel &&) = default;
WaveAMDMachineScheduleModel::~WaveAMDMachineScheduleModel() = default;

waveamdmachine::InstructionExecutionConfig
WaveAMDMachineScheduleModel::buildInstructionConfig(
    const waveamdmachine::EventSimConfig &config) const {
  assert(config.wavefrontSize == impl->wavefrontSize &&
         "instruction config uses another wavefront size");
  waveamdmachine::InstructionExecutionConfig stateConfig(config.wavefrontSize);
  stateConfig.calibration = config.calibration;
  stateConfig.counterLatencies = config.counterLatencies;
  stateConfig.valueLatencies = config.valueLatencies;
  stateConfig.issuePeriod =
      waveamdmachine::getEventSimIssuePeriod(*impl->arch, config);
  waveamdmachine::configureInstructionScheduleModel(
      stateConfig, *impl->arch, impl->targetWaveCount,
      impl->readyPressureWaveCohort, impl->pressureLimits);
  // Skipped waves expose queue and barrier stalls hidden by the delay span.
  stateConfig.dmaIssueDelayCohortPolicy =
      waveamdmachine::DmaIssueDelayCohortPolicy::Skipped;
  return stateConfig;
}

unsigned WaveAMDMachineScheduleModel::getTargetWaveCount() const {
  return impl->targetWaveCount;
}

RegionScheduleSession WaveAMDMachineScheduleModel::createRegionSession(
    ArrayRef<Operation *> operations,
    ArrayRef<SmallVector<unsigned, 4>> predecessors,
    ArrayRef<SmallVector<unsigned, 4>> successors,
    llvm::BitVector noInstructions) const {
  assert(predecessors.size() == operations.size() &&
         successors.size() == operations.size() &&
         noInstructions.size() == operations.size() &&
         "invalid region schedule facts");
  auto region = std::make_unique<RegionScheduleSession::Impl>();
  region->operations = operations;
  region->predecessors = predecessors;
  region->successors = successors;
  region->noInstructions = std::move(noInstructions);
  region->arch = impl->arch;
  region->wavefrontSize = impl->wavefrontSize;
  region->initialize(impl->liveness);
  return RegionScheduleSession(std::move(region));
}

RegionScheduleSession::RegionScheduleSession(std::unique_ptr<Impl> impl)
    : impl(std::move(impl)) {}
RegionScheduleSession::RegionScheduleSession(RegionScheduleSession &&) =
    default;
RegionScheduleSession &
RegionScheduleSession::operator=(RegionScheduleSession &&) = default;
RegionScheduleSession::~RegionScheduleSession() = default;

ReadyScheduleDecision RegionScheduleSession::selectNext(
    const llvm::BitVector &scheduled, unsigned baseline,
    const llvm::BitVector &legalReadyCandidates,
    ArrayRef<ReadyScheduleProposal> proposals,
    const waveamdmachine::InstructionScheduleModel &policy) const {
  assert(scheduled.size() == impl->operations.size() &&
         legalReadyCandidates.size() == impl->operations.size() &&
         baseline < impl->operations.size() && "invalid ready selection");
  const ReadyScheduleState &state = impl->getState(scheduled);
  waveamdmachine::ReadyCandidateMetrics baselineMetrics =
      impl->getCandidateMetrics(scheduled, baseline, state);
  std::optional<unsigned> pressureWinner =
      impl->selectPressureCandidate(scheduled, baseline, legalReadyCandidates,
                                    state, baselineMetrics, policy);
  if (pressureWinner) {
    if (impl->hasSafeFullPrefix(scheduled, *pressureWinner, baseline, state,
                                policy)) {
      ++impl->work.pressureSelections;
      return {*pressureWinner, /*selectedProposal=*/false,
              /*suppressFallback=*/false};
    }
    ++impl->work.pressureRejections;
  }

  bool rejectedProposalWinner = false;
  for (unsigned group : Impl::getProposalGroups(proposals)) {
    const ReadyScheduleProposal &groupInfo =
        Impl::getProposalGroupInfo(group, proposals);
    if (!Impl::shouldEvaluateProposalGroup(groupInfo, state, baselineMetrics,
                                           policy))
      continue;
    std::optional<unsigned> winner = impl->selectProposalGroupCandidate(
        group, groupInfo, scheduled, baseline, state, baselineMetrics,
        proposals, policy);
    if (!winner)
      continue;
    if (impl->hasSafeFullPrefix(scheduled, *winner, baseline, state, policy)) {
      ++impl->work.proposalSelections;
      return {*winner, /*selectedProposal=*/true,
              /*suppressFallback=*/false};
    }
    ++impl->work.proposalRejections;
    rejectedProposalWinner = true;
  }
  return {std::nullopt, /*selectedProposal=*/false,
          /*suppressFallback=*/rejectedProposalWinner};
}

ReadyScheduleWorkStats RegionScheduleSession::getWorkStats() const {
  return impl->work;
}

} // namespace mlir::wave
