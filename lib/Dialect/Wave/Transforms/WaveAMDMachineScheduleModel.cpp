//===- WaveAMDMachineScheduleModel.cpp - Machine scheduling policy -------===//
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
#include "mlir/Dialect/WaveAMDMachine/CostModel/CalibrationData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/Operation.h"
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
#include <utility>

namespace mlir::wave {

waveamdmachine::InstructionExecutionConfig buildWaveAMDMachineInstructionConfig(
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, Operation *context) {
  waveamdmachine::InstructionExecutionConfig stateConfig;
  stateConfig.calibration = config.calibration;
  stateConfig.counterLatencies = config.counterLatencies;
  stateConfig.valueLatencies = config.valueLatencies;
  stateConfig.issuePeriod =
      waveamdmachine::getEventSimIssuePeriod(arch, config);
  waveamdmachine::ReadyRegisterPressureLimits pressureLimits;
  func::FuncOp func = dyn_cast<func::FuncOp>(context);
  if (!func)
    func = context->getParentOfType<func::FuncOp>();
  if (func) {
    pressureLimits.sgpr =
        getRegAllocTransformBudget(func, waveamdmachine::RegClass::SGPR).limit;
    pressureLimits.vgpr =
        getRegAllocTransformBudget(func, waveamdmachine::RegClass::VGPR).limit;
    pressureLimits.agpr =
        getRegAllocTransformBudget(func, waveamdmachine::RegClass::AGPR).limit;
    FailureOr<WaveAMDRegisterLimits> targetLimits =
        getWaveAMDRegisterLimits(func);
    if (succeeded(targetLimits)) {
      pressureLimits.sgprAllocGranule = targetLimits->sgprAllocGranule;
      pressureLimits.vgprAllocGranule = targetLimits->vgprAllocGranule;
      pressureLimits.agprAllocGranule = targetLimits->agprAllocGranule;
    }
  }
  waveamdmachine::configureInstructionScheduleModel(stateConfig, arch, context,
                                                    pressureLimits);
  stateConfig.dmaIssueDelayCohortPolicy =
      waveamdmachine::DmaIssueDelayCohortPolicy::Skipped;
  return stateConfig;
}

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

struct ReadyPressureState {
  SmallVector<unsigned, 0> slotUseCounts;
  llvm::BitVector liveMembers;
  waveamdmachine::ReadyRegisterPressure pressure;
};

struct ReadyPressureProjectionState {
  explicit ReadyPressureProjectionState(const ReadyPressureState &base)
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

  const ReadyPressureState &base;
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
  const waveamdmachine::ArchData *arch = nullptr;
  WaveAMDLiveIntervalBuildResult liveness;
};

struct RegionScheduleSession::Impl {
  bool isFullBarrier(unsigned index) const {
    return isa<waveamdmachine::ClusterBarrierOp, waveamdmachine::SBarrierOp>(
        operations[index]);
  }

  bool isBarrier(unsigned index) const {
    return isa<waveamdmachine::BarrierWaitOp>(operations[index]) ||
           isFullBarrier(index);
  }

  bool isPureCompute(unsigned index) const {
    Operation *op = operations[index];
    if (!isPure(op) || isBarrier(index) ||
        waveamdmachine::getMemoryCounterKind(op) !=
            waveamdmachine::MemoryCounterKind::None)
      return false;
    waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
    return cls == waveamdmachine::SchedClass::NoInst ||
           waveamdmachine::getInstructionScheduleResourceInfo(op, cls, *arch)
               .tracked;
  }

  bool crossesSplitBarrier(const llvm::BitVector &scheduled, unsigned baseline,
                           unsigned candidate) const {
    if (candidate <= baseline)
      return false;
    for (unsigned index : llvm::seq(baseline, candidate)) {
      if (scheduled.test(index))
        continue;
      if (isa<waveamdmachine::BarrierArriveOp, waveamdmachine::BarrierWaitOp>(
              operations[index]))
        return true;
    }
    return false;
  }

  bool canUseStallFiller(const llvm::BitVector &scheduled, unsigned baseline,
                         unsigned candidate) const {
    assert(candidate < fillerMemoryKinds.size() &&
           "missing filler memory kinds");
    auto memory = llvm::lower_bound(memoryNodes, baseline);
    for (; memory != memoryNodes.end() && *memory < candidate; ++memory) {
      unsigned index = *memory;
      if (scheduled.test(index))
        continue;
      waveamdmachine::MemoryCounterKind kind = memoryKinds[index];
      if (kind != waveamdmachine::MemoryCounterKind::None &&
          llvm::is_contained(fillerMemoryKinds[candidate], kind))
        return false;
    }
    return true;
  }

  int getLatency(unsigned index) const {
    waveamdmachine::SchedClass cls =
        waveamdmachine::classifyOp(operations[index]);
    if (cls == waveamdmachine::SchedClass::NoInst)
      return 0;
    if (config.calibration)
      return waveamdmachine::getCalibratedLatency(*arch, cls,
                                                  *config.calibration);
    return waveamdmachine::getLatency(*arch, cls);
  }

  void initializeComputeIslands() {
    computeIslandEnds.resize(operations.size());
    unsigned end = operations.size();
    for (unsigned index : llvm::reverse(llvm::seq<unsigned>(
             0, static_cast<unsigned>(operations.size())))) {
      if (!isPureCompute(index))
        end = index;
      computeIslandEnds[index] = end;
    }
  }

  const ReadyPressureState &getState(const llvm::BitVector &scheduled) const {
    if (cachedState && cachedScheduled == scheduled)
      return *cachedState;
    cachedScheduled = scheduled;
    cachedState.emplace();
    ReadyPressureState &state = *cachedState;
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
                                        const ReadyPressureState &state) const {
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
                     const ReadyPressureState &state) const {
    ReadyPressureProjection projection =
        getProjection(scheduled, sequence, state);
    return {projection.finalDelta, projection.peakDelta,
            projection.vgprFamilyPeakDelta, pressureCeiling,
            projection.autoDrainedNodes};
  }

  waveamdmachine::ReadyCandidateMetrics
  getCandidateMetrics(const llvm::BitVector &scheduled, unsigned candidate,
                      const ReadyPressureState &state) const {
    return getSequenceMetrics(scheduled, ArrayRef<unsigned>(candidate), state);
  }

  std::pair<waveamdmachine::ReadyCandidateMetrics,
            waveamdmachine::ReadyCandidateMetrics>
  getOrderMetrics(const llvm::BitVector &scheduled, unsigned candidate,
                  unsigned baseline, const ReadyPressureState &state) const {
    std::array<unsigned, 2> candidateFirst = {candidate, baseline};
    std::array<unsigned, 2> baselineFirst = {baseline, candidate};
    return {getSequenceMetrics(scheduled, candidateFirst, state),
            getSequenceMetrics(scheduled, baselineFirst, state)};
  }

  std::pair<waveamdmachine::ReadyCandidateMetrics,
            waveamdmachine::ReadyCandidateMetrics>
  getFullPrefixMetrics(const llvm::BitVector &scheduled, unsigned candidate,
                       unsigned baseline,
                       const ReadyPressureState &state) const {
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
      auto useIt = nodes.find(use.getOwner());
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
    auto first = liveness.positions.find(operations.front());
    auto last = liveness.positions.find(operations.back());
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

  SmallVector<Operation *, 16> operations;
  SmallVector<SmallVector<unsigned, 4>, 16> predecessors;
  SmallVector<SmallVector<unsigned, 4>, 16> successors;
  SmallVector<waveamdmachine::MemoryCounterKind, 16> memoryKinds;
  SmallVector<SmallVector<waveamdmachine::MemoryCounterKind, 4>, 16>
      fillerMemoryKinds;
  SmallVector<unsigned, 16> memoryNodes;
  llvm::BitVector computeRecurrenceCritical;
  SmallVector<unsigned, 16> computeIslandEnds;
  const waveamdmachine::ArchData *arch = nullptr;
  waveamdmachine::EventSimConfig config;
  llvm::BitVector noInstructions;
  DenseMap<Value, unsigned> memberByValue;
  SmallVector<ReadyPressureMember, 0> members;
  SmallVector<waveamdmachine::RegClass, 0> slotClasses;
  mutable std::optional<ReadyPressureState> cachedState;
  mutable llvm::BitVector cachedScheduled;
  mutable ReadyScheduleWorkStats work;
  waveamdmachine::ReadyRegisterPressureCeiling pressureCeiling;
};

FailureOr<WaveAMDMachineScheduleModel>
WaveAMDMachineScheduleModel::create(func::FuncOp func) {
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      waveamdmachine::getAMDGPUTargetIsaVersion(
          func, "Wave AMD machine schedule model");
  FailureOr<WaveAMDLiveIntervalBuildResult> liveness =
      buildAllocatedWaveAMDLiveIntervals(
          func, WaveAMDLiveIntervalOrderOverride{},
          WaveAMDLiveIntervalAliasPolicy::Conservative);
  if (failed(isa) || !waveamdmachine::isArchSupported(*isa) || failed(liveness))
    return failure();
  auto impl = std::make_unique<Impl>();
  impl->arch = &waveamdmachine::getArchData(*isa);
  impl->liveness = std::move(*liveness);
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

RegionScheduleSession WaveAMDMachineScheduleModel::createRegionSession(
    ArrayRef<Operation *> operations,
    ArrayRef<SmallVector<unsigned, 4>> predecessors,
    ArrayRef<SmallVector<unsigned, 4>> successors,
    ArrayRef<waveamdmachine::MemoryCounterKind> memoryKinds,
    ArrayRef<SmallVector<waveamdmachine::MemoryCounterKind, 4>>
        fillerMemoryKinds,
    ArrayRef<unsigned> memoryNodes,
    const llvm::BitVector &computeRecurrenceCritical,
    const waveamdmachine::EventSimConfig &config) const {
  auto region = std::make_unique<RegionScheduleSession::Impl>();
  region->operations.assign(operations.begin(), operations.end());
  region->predecessors.assign(predecessors.begin(), predecessors.end());
  region->successors.assign(successors.begin(), successors.end());
  region->memoryKinds.assign(memoryKinds.begin(), memoryKinds.end());
  region->fillerMemoryKinds.assign(fillerMemoryKinds.begin(),
                                   fillerMemoryKinds.end());
  region->memoryNodes.assign(memoryNodes.begin(), memoryNodes.end());
  region->computeRecurrenceCritical = computeRecurrenceCritical;
  region->arch = impl->arch;
  region->config = config;
  if (!operations.empty()) {
    Block *block = operations.front()->getBlock();
    assert(
        llvm::all_of(operations,
                     [&](Operation *op) { return op->getBlock() == block; }) &&
        "ready scheduling region crosses a block boundary");
  }
  region->noInstructions.resize(operations.size());
  for (auto [index, op] : llvm::enumerate(operations))
    if (waveamdmachine::classifyOp(op) == waveamdmachine::SchedClass::NoInst)
      region->noInstructions.set(index);
  region->initialize(impl->liveness);
  region->initializeComputeIslands();
  return RegionScheduleSession(std::move(region));
}

RegionScheduleSession::RegionScheduleSession(std::unique_ptr<Impl> impl)
    : impl(std::move(impl)) {}
RegionScheduleSession::RegionScheduleSession(RegionScheduleSession &&) =
    default;
RegionScheduleSession &
RegionScheduleSession::operator=(RegionScheduleSession &&) = default;
RegionScheduleSession::~RegionScheduleSession() = default;

static bool sameResourcePreview(
    const waveamdmachine::InstructionScheduleResourcePreview &lhs,
    const waveamdmachine::InstructionScheduleResourcePreview &rhs) {
  return lhs.waitSlots == rhs.waitSlots &&
         lhs.releaseSlots == rhs.releaseSlots &&
         lhs.functionalUnit == rhs.functionalUnit;
}

static bool sameStallFacts(const ReadyScheduleStallFacts &lhs,
                           const ReadyScheduleStallFacts &rhs) {
  return lhs.kind == rhs.kind && lhs.issueCycle == rhs.issueCycle &&
         lhs.blockedMemoryResources == rhs.blockedMemoryResources &&
         lhs.reason == rhs.reason;
}

ReadyScheduleDecision RegionScheduleSession::selectNext(
    const llvm::BitVector &scheduled, unsigned baseline,
    const llvm::BitVector &legalReadyCandidates,
    ArrayRef<ReadyScheduleProposal> proposals,
    const waveamdmachine::InstructionScheduleModel &policy) const {
  assert(scheduled.size() == impl->operations.size() &&
         legalReadyCandidates.size() == impl->operations.size() &&
         baseline < impl->operations.size() && "invalid ready selection");
  const ReadyPressureState &state = impl->getState(scheduled);
  waveamdmachine::ReadyCandidateMetrics baselineMetrics =
      impl->getCandidateMetrics(scheduled, baseline, state);

  auto hasSafeFullPrefix = [&](unsigned candidate) {
    if (candidate <= baseline)
      return true;
    auto metrics =
        impl->getFullPrefixMetrics(scheduled, candidate, baseline, state);
    return policy.canSelectReadyFullPrefix(state.pressure, metrics.first,
                                           metrics.second);
  };
  auto isPressureCandidate = [&](unsigned candidate) {
    if (candidate == baseline || candidate < baseline ||
        !legalReadyCandidates.test(candidate) || scheduled.test(candidate))
      return false;
    Operation *op = impl->operations[candidate];
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
    return waveamdmachine::getInstructionScheduleResourceInfo(op, cls,
                                                              *impl->arch)
        .tracked;
  };

  // Pressure relief is a model discovery, not a scheduler proposal. Select
  // the complete tournament winner before validating its changed prefix so an
  // unsafe late winner suppresses (rather than revives) a safe runner-up.
  waveamdmachine::ReadyCandidateMetrics pressureWinnerMetrics = baselineMetrics;
  unsigned pressureWinnerIndex = baseline;
  std::optional<unsigned> pressureWinner;
  for (int candidate = legalReadyCandidates.find_first(); candidate >= 0;
       candidate = legalReadyCandidates.find_next(candidate)) {
    unsigned index = candidate;
    if (!isPressureCandidate(index))
      continue;
    waveamdmachine::ReadyCandidateMetrics candidateMetrics =
        impl->getCandidateMetrics(scheduled, index, state);
    auto order =
        impl->getOrderMetrics(scheduled, index, pressureWinnerIndex, state);
    if (!policy.shouldPreferReadyPressure(state.pressure, candidateMetrics,
                                          order.first, order.second,
                                          pressureWinnerMetrics))
      continue;
    pressureWinnerMetrics = candidateMetrics;
    pressureWinnerIndex = index;
    pressureWinner = index;
  }
  if (pressureWinner) {
    if (hasSafeFullPrefix(*pressureWinner)) {
      ++impl->work.pressureSelections;
      return {*pressureWinner, /*selectedProposal=*/false,
              /*suppressFallback=*/false, ReadyScheduleSelectionKind::Pressure};
    }
    ++impl->work.pressureRejections;
  }

  SmallVector<unsigned, 8> groups;
  for (const ReadyScheduleProposal &proposal : proposals)
    if (!llvm::is_contained(groups, proposal.group))
      groups.push_back(proposal.group);
  llvm::sort(groups);

  bool rejectedProposalWinner = false;
  for (unsigned group : groups) {
    const ReadyScheduleProposal *groupInfo = nullptr;
    for (const ReadyScheduleProposal &proposal : proposals)
      if (proposal.group == group) {
        groupInfo = &proposal;
        break;
      }
    assert(groupInfo && "missing ready proposal group");
    if (groupInfo->kind == ReadyScheduleProposalKind::ComputeResource) {
      const ReadyScheduleResourceFacts &resource = groupInfo->resource;
      if (resource.baselinePriorityStall ||
          resource.baseline.releaseSlots == 0 ||
          (resource.baseline.waitSlots == 0 && !resource.prioritize))
        continue;
      if (resource.baseline.waitSlots != 0 && !resource.prioritize &&
          !policy.shouldSelectResourceStallFiller(
              resource.baseline.waitSlots, resource.baseline.releaseSlots,
              state.pressure, baselineMetrics))
        continue;
    } else if (groupInfo->kind == ReadyScheduleProposalKind::Latency) {
      if (!isa_and_nonnull<waveamdmachine::UniformLoopOp>(
              impl->operations[baseline]->getBlock()->getParentOp()) ||
          groupInfo->latency.baselinePriorityStall ||
          impl->getLatency(baseline) <= 0)
        continue;
    }

    std::optional<unsigned> winner;
    std::optional<waveamdmachine::ReadyCandidateMetrics> winnerMetrics;
    uint64_t winnerRank = 0;
    waveamdmachine::ReadyResourceCandidateKind winnerResourceKind =
        waveamdmachine::ReadyResourceCandidateKind::None;
    bool winnerLatency = false;
    bool winnerGenericStallFiller = false;
    for (const ReadyScheduleProposal &proposal : proposals) {
      if (proposal.group != group)
        continue;
      assert(groupInfo->kind == proposal.kind &&
             "ready proposal group mixes selection policies");
      assert(
          (proposal.kind != ReadyScheduleProposalKind::ComputeResource ||
           (sameResourcePreview(proposal.resource.baseline,
                                groupInfo->resource.baseline) &&
            proposal.resource.baselinePriorityStall ==
                groupInfo->resource.baselinePriorityStall &&
            proposal.resource.prioritize == groupInfo->resource.prioritize)) &&
          "resource group mixes baseline facts");
      assert((proposal.kind != ReadyScheduleProposalKind::Latency ||
              proposal.latency.baselinePriorityStall ==
                  groupInfo->latency.baselinePriorityStall) &&
             "latency group mixes baseline facts");
      assert((proposal.kind != ReadyScheduleProposalKind::GenericStallFiller ||
              sameStallFacts(proposal.filler.stall, groupInfo->filler.stall)) &&
             "stall filler group mixes baseline facts");
      unsigned candidate = proposal.candidate;
      if (candidate >= impl->operations.size() || candidate == baseline ||
          scheduled.test(candidate))
        continue;

      waveamdmachine::ReadyResourceCandidateKind resourceKind =
          waveamdmachine::ReadyResourceCandidateKind::None;
      if (proposal.kind == ReadyScheduleProposalKind::ComputeResource) {
        const ReadyScheduleResourceFacts &resource = proposal.resource;
        resourceKind = policy.classifyReadyResourceCandidate(
            resource.baseline.functionalUnit, resource.baseline.waitSlots,
            resource.baseline.releaseSlots, resource.candidate.functionalUnit,
            resource.candidate.waitSlots, resource.candidate.releaseSlots,
            /*selectedReleaseSlots=*/0);
        if (resourceKind == waveamdmachine::ReadyResourceCandidateKind::None ||
            resource.candidatePriorityStall)
          continue;
      } else if (proposal.kind == ReadyScheduleProposalKind::Latency) {
        if (impl->isBarrier(candidate) ||
            !impl->canUseStallFiller(scheduled, baseline, candidate) ||
            proposal.latency.candidatePriorityStall ||
            !policy.shouldPrioritizeLatency(impl->getLatency(candidate),
                                            impl->getLatency(baseline)))
          continue;
      } else if (proposal.kind ==
                 ReadyScheduleProposalKind::GenericStallFiller) {
        const ReadyScheduleFillerFacts &filler = proposal.filler;
        Operation *candidateOp = impl->operations[candidate];
        waveamdmachine::SchedClass cls =
            waveamdmachine::classifyOp(candidateOp);
        waveamdmachine::InstructionScheduleResourceInfo resource =
            waveamdmachine::getInstructionScheduleResourceInfo(candidateOp, cls,
                                                               *impl->arch);
        if (filler.stall.kind == ReadyScheduleStallKind::None ||
            (impl->isFullBarrier(baseline) && impl->isFullBarrier(candidate)) ||
            !impl->canUseStallFiller(scheduled, baseline, candidate) ||
            (filler.stall.blockedMemoryResources &
             waveamdmachine::getMemoryIssueResources(candidateOp)) != 0 ||
            !policy.canFillStall(filler.stall.reason, resource.functionalUnit,
                                 resource.usesMfmaCoissue) ||
            !filler.candidateRealInstruction || filler.candidateStalls ||
            (filler.stall.kind == ReadyScheduleStallKind::Cycle &&
             filler.candidateNextIssueCycle > filler.stall.issueCycle))
          continue;
      }

      waveamdmachine::ReadyCandidateMetrics candidateMetrics =
          impl->getCandidateMetrics(scheduled, candidate, state);
      auto order = impl->getOrderMetrics(scheduled, candidate, baseline, state);
      switch (proposal.kind) {
      case ReadyScheduleProposalKind::Direct:
        if (!policy.canSelectReadyCandidate(state.pressure, order.first,
                                            baselineMetrics))
          continue;
        winner = candidate;
        winnerMetrics = candidateMetrics;
        break;
      case ReadyScheduleProposalKind::RankedFiller:
        if (!policy.canSelectReadyFiller(state.pressure, candidateMetrics,
                                         order.first, baselineMetrics))
          continue;
        if (!winnerMetrics ||
            policy.shouldPreferReadyFiller(state.pressure, candidateMetrics,
                                           *winnerMetrics)) {
          winner = candidate;
          winnerMetrics = candidateMetrics;
        }
        break;
      case ReadyScheduleProposalKind::ComputeResource: {
        const ReadyScheduleResourceFacts &resource = proposal.resource;
        if (resourceKind ==
            waveamdmachine::ReadyResourceCandidateKind::Priority) {
          uint64_t rank = resource.candidate.releaseSlots;
          if ((winner && rank <= winnerRank) ||
              !policy.canSelectReadyCandidate(state.pressure, order.first,
                                              baselineMetrics))
            continue;
          winner = candidate;
          winnerMetrics = candidateMetrics;
          winnerRank = rank;
          winnerResourceKind = resourceKind;
          continue;
        }
        if (!policy.canSelectReadyFiller(state.pressure, candidateMetrics,
                                         order.first, baselineMetrics))
          continue;
        if (!winnerMetrics ||
            policy.shouldPreferReadyFiller(state.pressure, candidateMetrics,
                                           *winnerMetrics)) {
          winner = candidate;
          winnerMetrics = candidateMetrics;
          winnerResourceKind = resourceKind;
        }
        break;
      }
      case ReadyScheduleProposalKind::Latency:
        if (!policy.canSelectReadyFiller(state.pressure, candidateMetrics,
                                         order.first, baselineMetrics))
          continue;
        if (!winnerMetrics ||
            policy.shouldPreferReadyFiller(state.pressure, candidateMetrics,
                                           *winnerMetrics)) {
          winner = candidate;
          winnerMetrics = candidateMetrics;
          winnerLatency = true;
        }
        break;
      case ReadyScheduleProposalKind::GenericStallFiller:
        if (!policy.canSelectReadyFiller(state.pressure, candidateMetrics,
                                         order.first, baselineMetrics))
          continue;
        if (!winnerMetrics ||
            policy.shouldPreferReadyFiller(state.pressure, candidateMetrics,
                                           *winnerMetrics)) {
          winner = candidate;
          winnerMetrics = candidateMetrics;
          winnerGenericStallFiller = true;
        }
        break;
      }
    }
    if (!winner)
      continue;
    if (hasSafeFullPrefix(*winner)) {
      ++impl->work.proposalSelections;
      ReadyScheduleSelectionKind selection =
          ReadyScheduleSelectionKind::Proposal;
      if (winnerResourceKind ==
          waveamdmachine::ReadyResourceCandidateKind::StallFiller)
        selection = ReadyScheduleSelectionKind::ResourceStallFiller;
      else if (winnerResourceKind ==
               waveamdmachine::ReadyResourceCandidateKind::Priority)
        selection = ReadyScheduleSelectionKind::ResourcePriority;
      else if (winnerLatency)
        selection = ReadyScheduleSelectionKind::LatencyPriority;
      else if (winnerGenericStallFiller)
        selection = ReadyScheduleSelectionKind::GenericStallFiller;
      return {*winner, /*selectedProposal=*/true,
              /*suppressFallback=*/false, selection};
    }
    // The selected final winner is rejected as a unit. Do not revisit an
    // earlier candidate from this group; only the next explicit fallback
    // group may be tried.
    ++impl->work.proposalRejections;
    rejectedProposalWinner = true;
  }
  return {std::nullopt, /*selectedProposal=*/false,
          /*suppressFallback=*/rejectedProposalWinner};
}

llvm::BitVector RegionScheduleSession::getComputeResourceCandidates(
    const llvm::BitVector &scheduled, unsigned baseline,
    const llvm::BitVector &legalReadyCandidates) const {
  assert(scheduled.size() == impl->operations.size() &&
         legalReadyCandidates.size() == impl->operations.size() &&
         baseline < impl->operations.size() &&
         "invalid compute resource candidates");
  llvm::BitVector candidates(impl->operations.size());
  if (!impl->isPureCompute(baseline))
    return candidates;
  unsigned islandEnd = impl->computeIslandEnds[baseline];
  for (int ready = legalReadyCandidates.find_next(baseline); ready >= 0;
       ready = legalReadyCandidates.find_next(ready)) {
    unsigned candidate = ready;
    if (scheduled.test(candidate))
      continue;
    bool local = candidate < islandEnd;
    bool recurrence =
        impl->computeRecurrenceCritical.test(candidate) &&
        impl->isPureCompute(candidate) &&
        !impl->crossesSplitBarrier(scheduled, baseline, candidate);
    if (local || recurrence)
      candidates.set(candidate);
  }
  return candidates;
}

ReadyScheduleDecision RegionScheduleSession::selectComputeResource(
    const llvm::BitVector &scheduled, unsigned baseline,
    const llvm::BitVector &legalReadyCandidates,
    ArrayRef<ReadyScheduleProposal> rawProposals,
    const waveamdmachine::InstructionScheduleModel &policy) const {
  assert(scheduled.size() == impl->operations.size() &&
         legalReadyCandidates.size() == impl->operations.size() &&
         baseline < impl->operations.size() &&
         "invalid compute resource selection");
  llvm::BitVector candidates =
      getComputeResourceCandidates(scheduled, baseline, legalReadyCandidates);

  SmallVector<ReadyScheduleProposal, 8> local;
  SmallVector<ReadyScheduleProposal, 8> recurrence;
  unsigned islandEnd = impl->computeIslandEnds[baseline];
  for (ReadyScheduleProposal proposal : rawProposals) {
    assert(proposal.kind == ReadyScheduleProposalKind::ComputeResource &&
           "non-resource proposal in compute selection");
    unsigned candidate = proposal.candidate;
    if (candidate <= baseline || candidate >= impl->operations.size() ||
        !candidates.test(candidate) || scheduled.test(candidate))
      continue;
    proposal.group = 0;
    if (candidate < islandEnd)
      local.push_back(proposal);
    if (impl->computeRecurrenceCritical.test(candidate) &&
        impl->isPureCompute(candidate) &&
        !impl->crossesSplitBarrier(scheduled, baseline, candidate))
      recurrence.push_back(proposal);
  }

  llvm::BitVector noDiscoveries(impl->operations.size());
  ReadyScheduleDecision decision =
      selectNext(scheduled, baseline, noDiscoveries, local, policy);
  if (decision.candidate || decision.suppressFallback)
    return decision;
  return selectNext(scheduled, baseline, noDiscoveries, recurrence, policy);
}

bool RegionScheduleSession::supportsLatencyPriority(bool enabled) const {
  return enabled && !impl->operations.empty() &&
         isa_and_nonnull<waveamdmachine::UniformLoopOp>(
             impl->operations.front()->getBlock()->getParentOp());
}

llvm::BitVector RegionScheduleSession::getLatencyCandidates(
    const llvm::BitVector &scheduled, unsigned baseline,
    const llvm::BitVector &legalReadyCandidates, bool baselinePriorityStall,
    const waveamdmachine::InstructionScheduleModel &policy) const {
  assert(scheduled.size() == impl->operations.size() &&
         legalReadyCandidates.size() == impl->operations.size() &&
         baseline < impl->operations.size() && "invalid latency candidates");
  llvm::BitVector candidates(impl->operations.size());
  int baselineLatency = impl->getLatency(baseline);
  if (baselinePriorityStall || baselineLatency <= 0)
    return candidates;
  for (int ready = legalReadyCandidates.find_first(); ready >= 0;
       ready = legalReadyCandidates.find_next(ready)) {
    unsigned candidate = ready;
    if (candidate == baseline || scheduled.test(candidate) ||
        impl->isBarrier(candidate) ||
        !impl->canUseStallFiller(scheduled, baseline, candidate) ||
        !policy.shouldPrioritizeLatency(impl->getLatency(candidate),
                                        baselineLatency))
      continue;
    candidates.set(candidate);
  }
  return candidates;
}

llvm::BitVector RegionScheduleSession::getGenericStallFillerCandidates(
    const llvm::BitVector &scheduled, unsigned baseline,
    const llvm::BitVector &legalReadyCandidates,
    const ReadyScheduleStallFacts &stall,
    const waveamdmachine::InstructionScheduleModel &policy) const {
  assert(scheduled.size() == impl->operations.size() &&
         legalReadyCandidates.size() == impl->operations.size() &&
         baseline < impl->operations.size() &&
         "invalid generic stall filler candidates");
  llvm::BitVector candidates(impl->operations.size());
  if (stall.kind == ReadyScheduleStallKind::None)
    return candidates;
  for (int ready = legalReadyCandidates.find_first(); ready >= 0;
       ready = legalReadyCandidates.find_next(ready)) {
    unsigned candidate = ready;
    if (candidate == baseline || scheduled.test(candidate) ||
        (impl->isFullBarrier(baseline) && impl->isFullBarrier(candidate)) ||
        !impl->canUseStallFiller(scheduled, baseline, candidate) ||
        (stall.blockedMemoryResources & waveamdmachine::getMemoryIssueResources(
                                            impl->operations[candidate])) != 0)
      continue;
    waveamdmachine::SchedClass cls =
        waveamdmachine::classifyOp(impl->operations[candidate]);
    waveamdmachine::InstructionScheduleResourceInfo resource =
        waveamdmachine::getInstructionScheduleResourceInfo(
            impl->operations[candidate], cls, *impl->arch);
    if (!policy.canFillStall(stall.reason, resource.functionalUnit,
                             resource.usesMfmaCoissue))
      continue;
    candidates.set(candidate);
  }
  return candidates;
}

ReadyScheduleStallFacts
RegionScheduleSession::classifyStall(unsigned baseline,
                                     const ReadyScheduleIssueFacts &issue,
                                     bool blockMemoryResource) const {
  assert(baseline < impl->operations.size() && "invalid stall baseline");
  if (issue.memoryWaitCycles != 0)
    return {ReadyScheduleStallKind::MemoryToken, issue.issueCycle};
  if (issue.coexecWindowWaitCycles != 0)
    return {ReadyScheduleStallKind::Cycle, issue.issueCycle,
            /*blockedMemoryResources=*/0,
            waveamdmachine::InstructionStallKind::CoexecWindow};
  bool nonMemoryCycleWait =
      issue.operandWaitCycles != 0 || issue.functionalUnitWaitCycles != 0 ||
      issue.issueWaitCycles != 0 || issue.cuIssueWaitCycles != 0 ||
      issue.cmaIssueWaitCycles != 0;
  if (nonMemoryCycleWait) {
    waveamdmachine::MemoryIssueResourceMask blocked =
        blockMemoryResource && issue.functionalUnitWaitCycles != 0
            ? waveamdmachine::getMemoryIssueResources(
                  impl->operations[baseline])
            : waveamdmachine::MemoryIssueResourceMask{0};
    if (blocked != 0 && impl->operations[baseline]
                            ->hasTrait<OpTrait::waveamdmachine::LDSDmaOp>())
      blocked |= waveamdmachine::getMemoryIssueResourceMask(
          waveamdmachine::MemoryIssueResource::Lds);
    return {ReadyScheduleStallKind::Cycle, issue.issueCycle, blocked};
  }
  if (issue.hazardWaitInstructions != 0)
    return {ReadyScheduleStallKind::InstructionHazard, issue.issueCycle};
  return {};
}

ReadyScheduleStallFacts RegionScheduleSession::classifyStall(
    unsigned baseline, const ReadyScheduleIssueFacts &issue,
    const waveamdmachine::InstructionScheduleModel &policy) const {
  return classifyStall(baseline, issue,
                       policy.shouldBlockStallFillerMemoryResource());
}

ReadyScheduleWorkStats RegionScheduleSession::getWorkStats() const {
  return impl->work;
}

} // namespace mlir::wave
