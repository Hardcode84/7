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
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/Support/ErrorHandling.h"

#include <algorithm>
#include <cassert>
#include <limits>
#include <optional>
#include <utility>

namespace mlir::wave {

waveamdmachine::InstructionExecutionConfig buildWaveAMDMachineInstructionConfig(
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, Operation *context) {
  waveamdmachine::InstructionExecutionConfig stateConfig(config.wavefrontSize);
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
  // Skipped waves expose queue and barrier stalls hidden by the delay span.
  stateConfig.dmaIssueDelayCohortPolicy =
      waveamdmachine::DmaIssueDelayCohortPolicy::Skipped;
  return stateConfig;
}

class ReadyScheduleState {
public:
  SmallVector<unsigned, 0> slotUseCounts;
  llvm::BitVector liveMembers;
  waveamdmachine::ReadyRegisterPressure pressure;
  const llvm::BitVector *scheduled = nullptr;
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
  const waveamdmachine::ArchData *arch = nullptr;
};

struct RegionScheduleSession::Impl {
  const ReadyScheduleState &getState(const llvm::BitVector &scheduled) const {
    if (cachedState && cachedScheduled == scheduled)
      return *cachedState;
    cachedScheduled = scheduled;
    cachedState.emplace();
    ReadyScheduleState &state = *cachedState;
    state.scheduled = &cachedScheduled;
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

  llvm::BitVector
  projectCandidate(const llvm::BitVector &scheduled, unsigned candidate,
                   SmallVectorImpl<unsigned> &projectedNodes) const {
    llvm::BitVector projected = scheduled;
    projected.set(candidate);
    projectedNodes.push_back(candidate);
    // Ready no-inst nodes drain before ranking; projection only unlocks heirs.
    for (unsigned next = 0; next < projectedNodes.size(); ++next) {
      for (unsigned node : successors[projectedNodes[next]]) {
        ++work.projectionChecks;
        if (!noInstructions.test(node) || projected.test(node) ||
            !llvm::all_of(predecessors[node], [&](unsigned predecessor) {
              return projected.test(predecessor);
            }))
          continue;
        projected.set(node);
        projectedNodes.push_back(node);
      }
    }
    return projected;
  }

  void recordProjectedTransitions(const llvm::BitVector &projected,
                                  ArrayRef<unsigned> projectedNodes,
                                  const ReadyScheduleState &state,
                                  DenseMap<unsigned, int> &slotDeltas) const {
    llvm::SmallPtrSet<Value, 16> visited;
    for (unsigned node : projectedNodes) {
      Operation *op = operations[node];
      for (Value operand : op->getOperands())
        recordTransition(operand, projected, state, slotDeltas, visited);
      for (Value result : op->getResults())
        recordTransition(result, projected, state, slotDeltas, visited);
    }
  }

  waveamdmachine::ReadyRegisterPressure
  applySlotDeltas(const ReadyScheduleState &state,
                  const DenseMap<unsigned, int> &slotDeltas) const {
    waveamdmachine::ReadyRegisterPressure projected = state.pressure;
    for (auto [slot, delta] : slotDeltas) {
      int oldCount = static_cast<int>(state.slotUseCounts[slot]);
      int newCount = oldCount + delta;
      assert(newCount >= 0 && "ready pressure slot count underflow");
      if (oldCount == 0 && newCount != 0)
        addReadyPressureSlot(projected, slotClasses[slot], 1);
      else if (oldCount != 0 && newCount == 0)
        addReadyPressureSlot(projected, slotClasses[slot], -1);
    }
    return projected;
  }

  bool isLive(const ReadyPressureMember &member,
              const llvm::BitVector &scheduled) const {
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

  void recordTransition(Value value, const llvm::BitVector &projected,
                        const ReadyScheduleState &state,
                        DenseMap<unsigned, int> &slotDeltas,
                        llvm::SmallPtrSetImpl<Value> &visited) const {
    if (!visited.insert(value).second)
      return;
    DenseMap<Value, unsigned>::const_iterator memberIt =
        memberByValue.find(value);
    if (memberIt == memberByValue.end())
      return;
    unsigned memberIndex = memberIt->second;
    const ReadyPressureMember &member = members[memberIndex];
    bool before = state.liveMembers.test(memberIndex);
    bool after = isLive(member, projected);
    if (before == after)
      return;
    int delta = after ? 1 : -1;
    for (unsigned slot : llvm::seq(member.slot, member.slot + member.width))
      slotDeltas[slot] += delta;
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
    DenseMap<Operation *, unsigned>::const_iterator defIt =
        def ? nodes.find(def) : nodes.end();
    if (defIt != nodes.end())
      member.defNode = defIt->second;
    else
      member.availableBeforeRegion = start <= regionStart;
    member.liveAfterRegion = end > regionEnd;
    collectMemberUseNodes(member, value, nodes);
    if ((!member.availableBeforeRegion &&
         member.defNode == std::numeric_limits<unsigned>::max()) ||
        (!member.liveAfterRegion && member.useNodes.empty()))
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
    if (!member.liveAfterRegion)
      end = *llvm::max_element(member.useNodes) + 1;
    assert(start < end && "ready pressure member has empty lifetime");
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
             events[last].position == events[first].position)
        applyPressureEvent(events[last++], slotUseCounts, pressure);
      updatePressureCeiling(pressure);
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
  waveamdmachine::ReadyRegisterPressureCeiling pressureCeiling;
};

FailureOr<WaveAMDMachineScheduleModel>
WaveAMDMachineScheduleModel::create(func::FuncOp func,
                                    const waveamdmachine::ArchData &arch) {
  FailureOr<WaveAMDLiveIntervalBuildResult> liveness =
      buildAllocatedWaveAMDLiveIntervals(
          func, WaveAMDLiveIntervalOrderOverride{},
          WaveAMDLiveIntervalAliasPolicy::Conservative);
  if (failed(liveness))
    return failure();
  auto impl = std::make_unique<Impl>();
  impl->liveness = std::move(*liveness);
  impl->arch = &arch;
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

const ReadyScheduleState &
RegionScheduleSession::getReadyState(const llvm::BitVector &scheduled) const {
  return impl->getState(scheduled);
}

waveamdmachine::ReadyRegisterPressure
RegionScheduleSession::getReadyPressure(const ReadyScheduleState &state) const {
  assert(impl->cachedState && &state == &*impl->cachedState &&
         "ready state belongs to another session");
  return state.pressure;
}

waveamdmachine::ReadyCandidateMetrics
RegionScheduleSession::getReadyCandidateMetrics(
    unsigned candidate, const ReadyScheduleState &state) const {
  assert(impl->cachedState && &state == &*impl->cachedState &&
         "ready state belongs to another session");
  assert(state.scheduled && "ready state has no schedule");
  SmallVector<unsigned, 4> projectedNodes;
  llvm::BitVector projectedSchedule =
      impl->projectCandidate(*state.scheduled, candidate, projectedNodes);
  ++impl->work.projections;
  impl->work.projectedNodes += projectedNodes.size();
  DenseMap<unsigned, int> slotDeltas;
  impl->recordProjectedTransitions(projectedSchedule, projectedNodes, state,
                                   slotDeltas);
  waveamdmachine::ReadyRegisterPressure projected =
      impl->applySlotDeltas(state, slotDeltas);
  waveamdmachine::ReadyRegisterPressure delta = {
      projected.sgpr - state.pressure.sgpr,
      projected.vgpr - state.pressure.vgpr,
      projected.agpr - state.pressure.agpr};
  return {delta, impl->pressureCeiling};
}

ReadyScheduleWorkStats RegionScheduleSession::getWorkStats() const {
  return impl->work;
}

} // namespace mlir::wave
