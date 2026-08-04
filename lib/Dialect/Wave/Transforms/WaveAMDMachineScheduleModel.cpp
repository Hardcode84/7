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

static constexpr StringLiteral kDmaIssueAfterDelayAttr =
    "waveamdmachine.dma_issue_after_delay";
static constexpr unsigned kSteadyStateFillsPerTarget = 16;
static constexpr unsigned kSingleWaveSteadyStateIterations = 4;
static constexpr unsigned kSingleWaveSteadyStateRefinementLimit = 3;
static constexpr unsigned kMultiWaveSteadyStateIterations = 4;
static constexpr unsigned kMultiWaveSteadyStateRefinementLimit = 3;

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

static waveamdmachine::UniformLoopOp
getCompleteUniformLoop(ArrayRef<Operation *> operations) {
  if (operations.empty())
    return nullptr;
  Block *block = operations.front()->getBlock();
  waveamdmachine::UniformLoopOp loop =
      dyn_cast_if_present<waveamdmachine::UniformLoopOp>(block->getParentOp());
  if (!loop)
    return nullptr;

  unsigned index = 0;
  for (Operation &op : block->without_terminator()) {
    if (index >= operations.size() || operations[index] != &op)
      return nullptr;
    ++index;
  }
  return index == operations.size() ? loop : nullptr;
}

static bool sameSingleWaveOrder(ArrayRef<unsigned> lhs,
                                ArrayRef<unsigned> rhs) {
  return lhs.size() == rhs.size() &&
         std::equal(lhs.begin(), lhs.end(), rhs.begin());
}

static bool hasSeenSingleWaveOrder(ArrayRef<SmallVector<unsigned, 16>> seen,
                                   ArrayRef<unsigned> order) {
  return llvm::any_of(seen, [&](ArrayRef<unsigned> prior) {
    return sameSingleWaveOrder(prior, order);
  });
}

static bool sameMultiWaveOrders(const MultiWaveScheduleOrders &lhs,
                                const MultiWaveScheduleOrders &rhs) {
  return llvm::all_of(llvm::seq<unsigned>(kMultiWaveScheduleClassCount),
                      [&](unsigned classId) {
                        return sameSingleWaveOrder(lhs[classId], rhs[classId]);
                      });
}

static bool hasSeenMultiWaveOrders(ArrayRef<MultiWaveScheduleOrders> seen,
                                   const MultiWaveScheduleOrders &orders) {
  return llvm::any_of(seen, [&](const MultiWaveScheduleOrders &prior) {
    return sameMultiWaveOrders(prior, orders);
  });
}

static void recordMultiWaveRecurrences(
    const MultiWaveScheduleCandidateFacts &candidate,
    std::array<bool, kMultiWaveScheduleClassCount> &used) {
  for (unsigned classId : llvm::seq<unsigned>(kMultiWaveScheduleClassCount))
    used[classId] |= candidate.recurrenceModelMoves[classId] != 0;
}

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
  struct RecurrenceProducer {
    SmallVector<unsigned, 4> consumers;
    unsigned node = 0;
  };

  struct ModeledRecurrenceOrder {
    SmallVector<unsigned, 16> order;
    llvm::BitVector moved;
  };

  struct SteadyStallTarget {
    unsigned index = 0;
    unsigned fills = 0;
  };

  static bool isMemToken(Value value) {
    return isa<waveamdmachine::MemTokenType>(value.getType());
  }

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

  unsigned findBarrierPairFiller(const llvm::BitVector &ready,
                                 const llvm::BitVector &scheduled,
                                 unsigned baseline) const {
    if (!isFullBarrier(baseline))
      return operations.size();

    unsigned filler = operations.size();
    for (unsigned index :
         llvm::seq(baseline + 1, static_cast<unsigned>(operations.size()))) {
      Operation *op = operations[index];
      if (isFullBarrier(index))
        return scheduled.test(index) ? operations.size() : filler;
      if (!isPure(op))
        return operations.size();
      if (scheduled.test(index))
        continue;
      if (filler == operations.size()) {
        if (!ready.test(index))
          return operations.size();
        filler = index;
      }
    }
    return operations.size();
  }

  unsigned findFirstRealDataConsumer(unsigned producer,
                                     const llvm::BitVector &scheduled) const {
    SmallVector<Value, 8> pending;
    for (Value result : operations[producer]->getResults())
      if (!isMemToken(result))
        pending.push_back(result);

    DenseSet<Value> seen;
    unsigned first = operations.size();
    while (!pending.empty()) {
      Value value = pending.pop_back_val();
      if (!seen.insert(value).second)
        continue;
      for (OpOperand &use : value.getUses()) {
        Operation *user = use.getOwner();
        auto it = nodeIndices.find(user);
        if (it == nodeIndices.end())
          continue;
        if (waveamdmachine::classifyOp(user) ==
            waveamdmachine::SchedClass::NoInst) {
          llvm::append_range(pending, user->getResults());
          continue;
        }
        if (!scheduled.test(it->second))
          first = std::min(first, it->second);
      }
    }
    return first;
  }

  bool collectPrefetchChain(unsigned node, unsigned candidate,
                            unsigned baseline, const llvm::BitVector &scheduled,
                            llvm::BitVector &chain) const {
    if (scheduled.test(node) || chain.test(node))
      return true;
    if (node == baseline)
      return false;
    Operation *op = operations[node];
    if (node != candidate &&
        waveamdmachine::classifyOp(op) != waveamdmachine::SchedClass::NoInst &&
        !isPure(op))
      return false;
    for (unsigned predecessor : predecessors[node])
      if (!collectPrefetchChain(predecessor, candidate, baseline, scheduled,
                                chain))
        return false;
    chain.set(node);
    return true;
  }

  unsigned findNextVmemValue(unsigned baseline,
                             const llvm::BitVector &scheduled) const {
    for (unsigned node : memoryNodes) {
      if (node <= baseline || scheduled.test(node))
        continue;
      if (memoryKinds[node] == waveamdmachine::MemoryCounterKind::Vmem)
        return node;
    }
    return operations.size();
  }

  bool isRealInstruction(unsigned index) const {
    return waveamdmachine::classifyOp(operations[index]) !=
           waveamdmachine::SchedClass::NoInst;
  }

  unsigned getIssueSlots(unsigned index) const {
    waveamdmachine::SchedClass cls =
        waveamdmachine::classifyOp(operations[index]);
    if (cls == waveamdmachine::SchedClass::NoInst)
      return 0;
    return waveamdmachine::getInstructionScheduleResourceInfo(operations[index],
                                                              cls, *arch)
        .issueSlots;
  }

  bool hasPrefetchSlack(unsigned baseline, unsigned candidate,
                        unsigned consumer, const llvm::BitVector &chain,
                        const llvm::BitVector &scheduled) const {
    int64_t issuePeriod = waveamdmachine::getEventSimIssuePeriod(*arch, config);
    int64_t slack = 0;
    for (unsigned index : llvm::seq(baseline, consumer)) {
      if (scheduled.test(index) || chain.test(index) ||
          !isRealInstruction(index))
        continue;
      slack += static_cast<int64_t>(getIssueSlots(index)) * issuePeriod;
    }
    int64_t baselineSpan =
        static_cast<int64_t>(getIssueSlots(baseline)) * issuePeriod;
    int64_t valueLatency = waveamdmachine::getMemoryValueLatency(
        *arch, operations[candidate], config.counterLatencies,
        config.valueLatencies, config.calibration);
    return slack - baselineSpan >= valueLatency;
  }

  SmallVector<unsigned, 32>
  buildPrefetchProjectionOrder(unsigned baseline, const llvm::BitVector &chain,
                               unsigned consumer, bool prefetchFirst,
                               const llvm::BitVector &scheduled) const {
    SmallVector<unsigned, 32> order;
    if (!prefetchFirst)
      order.push_back(baseline);
    for (unsigned index : llvm::seq<unsigned>(0, chain.size()))
      if (chain.test(index))
        order.push_back(index);
    if (prefetchFirst)
      order.push_back(baseline);
    for (unsigned index : llvm::seq(baseline + 1, consumer)) {
      if (chain.test(index) || scheduled.test(index))
        continue;
      order.push_back(index);
    }
    order.push_back(consumer);
    return order;
  }

  unsigned findFirstUnscheduledBarrier(const llvm::BitVector &scheduled,
                                       unsigned begin) const {
    for (unsigned index :
         llvm::seq(begin, static_cast<unsigned>(operations.size())))
      if (!scheduled.test(index) && isBarrier(index))
        return index;
    return operations.size();
  }

  unsigned findFirstUnscheduledMemory(const llvm::BitVector &scheduled,
                                      unsigned begin) const {
    for (unsigned index :
         llvm::seq(begin, static_cast<unsigned>(operations.size())))
      if (!scheduled.test(index) &&
          memoryKinds[index] != waveamdmachine::MemoryCounterKind::None)
        return index;
    return operations.size();
  }

  bool isPostBarrierFillerCandidate(unsigned index,
                                    const llvm::BitVector &ready,
                                    const llvm::BitVector &scheduled) const {
    return ready.test(index) && !scheduled.test(index) &&
           isPure(operations[index]) &&
           memoryKinds[index] == waveamdmachine::MemoryCounterKind::None;
  }

  waveamdmachine::UniformLoopOp getCompleteUniformLoop() const {
    return mlir::wave::getCompleteUniformLoop(operations);
  }

  bool isMemoryAddressUse(Operation *user, Value address) const {
    auto memory = dyn_cast<waveamdmachine::AddressFieldsOpInterface>(user);
    return memory &&
           waveamdmachine::getMemoryCounterKind(user) !=
               waveamdmachine::MemoryCounterKind::None &&
           memory.getVAddress() == address;
  }

  bool
  findMemoryAddressUse(Value value,
                       SmallVectorImpl<Value> &pendingAddressValues) const {
    for (OpOperand &use : value.getUses()) {
      Operation *user = use.getOwner();
      if (!nodeIndices.contains(user))
        continue;
      if (user->hasTrait<OpTrait::waveamdmachine::TupleAliasOp>()) {
        llvm::append_range(pendingAddressValues, user->getResults());
        continue;
      }
      if (isMemoryAddressUse(user, value))
        return true;
    }
    return false;
  }

  bool isComputeRecurrence(Value arg) const {
    auto regType = dyn_cast<waveamdmachine::RegType>(arg.getType());
    if (regType && regType.getRegClass() == waveamdmachine::RegClass::SGPR)
      return true;

    SmallVector<Value, 4> pendingAddressValues{arg};
    SmallPtrSet<Value, 16> visitedAddressValues;
    while (!pendingAddressValues.empty()) {
      Value value = pendingAddressValues.pop_back_val();
      if (!visitedAddressValues.insert(value).second)
        continue;
      if (findMemoryAddressUse(value, pendingAddressValues))
        return true;
    }
    return false;
  }

  static void
  markDependencyClosure(unsigned source,
                        ArrayRef<SmallVector<unsigned, 4>> adjacency,
                        llvm::BitVector &critical) {
    SmallVector<unsigned, 16> pending{source};
    while (!pending.empty()) {
      unsigned index = pending.pop_back_val();
      if (critical.test(index))
        continue;
      critical.set(index);
      llvm::append_range(pending, adjacency[index]);
    }
  }

  void initializeReadyCriticalSets() {
    steadyCritical.resize(operations.size());
    computeRecurrenceCritical.resize(operations.size());
    if (operations.empty())
      return;
    Block *block = operations.front()->getBlock();
    waveamdmachine::UniformLoopOp loop =
        dyn_cast_if_present<waveamdmachine::UniformLoopOp>(
            block->getParentOp());
    if (!loop)
      return;
    auto terminator =
        dyn_cast<waveamdmachine::ContinueIfOp>(block->getTerminator());
    if (!terminator)
      return;

    for (auto [arg, carry] :
         llvm::zip_equal(block->getArguments(), terminator.getCarries())) {
      Operation *def = carry.getDefiningOp();
      auto defIt = def ? nodeIndices.find(def) : nodeIndices.end();
      if (defIt == nodeIndices.end())
        continue;
      if (isMemToken(arg))
        markDependencyClosure(defIt->second, predecessors, steadyCritical);
      if (isComputeRecurrence(arg))
        markDependencyClosure(defIt->second, ssaPredecessors,
                              computeRecurrenceCritical);
    }
  }

  void collectRealRecurrenceProducers(Value value,
                                      SmallVectorImpl<unsigned> &producers,
                                      DenseSet<unsigned> &producerSet,
                                      DenseSet<Value> &seen) const {
    if (!seen.insert(value).second)
      return;
    Operation *def = value.getDefiningOp();
    if (!def)
      return;
    auto node = nodeIndices.find(def);
    if (node == nodeIndices.end())
      return;
    if (waveamdmachine::classifyOp(def) != waveamdmachine::SchedClass::NoInst) {
      if (producerSet.insert(node->second).second)
        producers.push_back(node->second);
      return;
    }
    for (Value operand : def->getOperands())
      collectRealRecurrenceProducers(operand, producers, producerSet, seen);
  }

  void collectRealRecurrenceConsumers(Value value,
                                      SmallVectorImpl<unsigned> &consumers,
                                      DenseSet<unsigned> &consumerSet,
                                      DenseSet<Value> &seen) const {
    if (!seen.insert(value).second)
      return;
    for (OpOperand &use : value.getUses()) {
      Operation *user = use.getOwner();
      auto node = nodeIndices.find(user);
      if (node == nodeIndices.end())
        continue;
      if (waveamdmachine::classifyOp(user) !=
          waveamdmachine::SchedClass::NoInst) {
        if (consumerSet.insert(node->second).second)
          consumers.push_back(node->second);
        continue;
      }
      for (Value result : user->getResults())
        collectRealRecurrenceConsumers(result, consumers, consumerSet, seen);
    }
  }

  void initializeRecurrencePlan() {
    waveamdmachine::UniformLoopOp loop = getCompleteUniformLoop();
    if (!loop)
      return;
    Block *block = operations.front()->getBlock();
    auto terminator =
        dyn_cast<waveamdmachine::ContinueIfOp>(block->getTerminator());
    if (!terminator)
      return;

    DenseMap<unsigned, unsigned> producerEntries;
    for (auto [arg, carry] :
         llvm::zip_equal(block->getArguments(), terminator.getCarries())) {
      // Token SSA remains legality; tracing joins creates false
      // self-recurrences.
      if (isMemToken(arg) || isMemToken(carry))
        continue;
      SmallVector<unsigned, 4> producers;
      SmallVector<unsigned, 4> consumers;
      DenseSet<unsigned> producerSet;
      DenseSet<unsigned> consumerSet;
      DenseSet<Value> seenProducers;
      DenseSet<Value> seenConsumers;
      collectRealRecurrenceProducers(carry, producers, producerSet,
                                     seenProducers);
      collectRealRecurrenceConsumers(arg, consumers, consumerSet,
                                     seenConsumers);
      if (consumers.empty())
        continue;
      for (unsigned producer : producers) {
        auto [it, inserted] =
            producerEntries.try_emplace(producer, recurrenceProducers.size());
        if (inserted) {
          RecurrenceProducer entry;
          entry.node = producer;
          recurrenceProducers.push_back(std::move(entry));
        }
        llvm::append_range(recurrenceProducers[it->second].consumers,
                           consumers);
      }
    }

    for (RecurrenceProducer &producer : recurrenceProducers) {
      llvm::sort(producer.consumers);
      producer.consumers.erase(
          std::unique(producer.consumers.begin(), producer.consumers.end()),
          producer.consumers.end());
    }
    llvm::sort(recurrenceProducers, [](const RecurrenceProducer &lhs,
                                       const RecurrenceProducer &rhs) {
      return lhs.node < rhs.node;
    });
  }

  const RecurrenceProducer *findRecurrenceProducer(unsigned node) const {
    auto producer =
        llvm::lower_bound(recurrenceProducers, node,
                          [](const RecurrenceProducer &entry, unsigned value) {
                            return entry.node < value;
                          });
    return producer != recurrenceProducers.end() && producer->node == node
               ? &*producer
               : nullptr;
  }

  bool crossesSplitBarrierInOrder(ArrayRef<unsigned> order, unsigned begin,
                                  unsigned end) const {
    return llvm::any_of(order.slice(begin, end - begin), [&](unsigned node) {
      return isa<waveamdmachine::BarrierArriveOp,
                 waveamdmachine::BarrierWaitOp>(operations[node]);
    });
  }

  static bool
  containsMemoryKind(ArrayRef<waveamdmachine::MemoryCounterKind> kinds,
                     waveamdmachine::MemoryCounterKind kind) {
    return kind != waveamdmachine::MemoryCounterKind::None &&
           llvm::is_contained(kinds, kind);
  }

  bool crossesSameMemoryProducerExcept(
      ArrayRef<unsigned> order, unsigned begin, unsigned end,
      ArrayRef<waveamdmachine::MemoryCounterKind> producerKinds,
      const llvm::BitVector &ignored) const {
    for (unsigned position : llvm::seq(begin, end)) {
      unsigned node = order[position];
      if (ignored.test(node))
        continue;
      if (containsMemoryKind(producerKinds, memoryKinds[node]))
        return true;
    }
    return false;
  }

  bool hasPlacedPredecessors(unsigned node,
                             const llvm::BitVector &placed) const {
    return llvm::all_of(predecessors[node], [&](unsigned predecessor) {
      return placed.test(predecessor);
    });
  }

  bool hasPlacedRecurrenceConsumers(unsigned node,
                                    const llvm::BitVector &placed) const {
    const RecurrenceProducer *producer = findRecurrenceProducer(node);
    if (!producer)
      return false;
    return llvm::all_of(producer->consumers, [&](unsigned consumer) {
      return consumer == node || placed.test(consumer);
    });
  }

  bool validateModeledRecurrenceOrder(ArrayRef<unsigned> order,
                                      const llvm::BitVector &scheduled,
                                      const llvm::BitVector &moved) const {
    llvm::BitVector placed = scheduled;
    for (unsigned node : order) {
      if (node >= placed.size() || placed.test(node))
        return false;
      if (!hasPlacedPredecessors(node, placed))
        return false;
      if (moved.test(node) && !hasPlacedRecurrenceConsumers(node, placed))
        return false;
      placed.set(node);
    }
    return placed.all();
  }

  bool indexBaselineOrder(ArrayRef<unsigned> baselineOrder,
                          const llvm::BitVector &scheduled,
                          MutableArrayRef<int> baselinePosition) const {
    for (auto [position, node] : llvm::enumerate(baselineOrder)) {
      if (node >= operations.size() || scheduled.test(node) ||
          baselinePosition[node] >= 0)
        return false;
      baselinePosition[node] = static_cast<int>(position);
    }
    return baselineOrder.size() + scheduled.count() == operations.size();
  }

  FailureOr<int>
  findLastRecurrenceRequirement(const RecurrenceProducer &producer,
                                const llvm::BitVector &scheduled,
                                ArrayRef<int> baselinePosition) const {
    int lastRequired = -1;
    for (unsigned predecessor : predecessors[producer.node]) {
      if (scheduled.test(predecessor))
        continue;
      if (baselinePosition[predecessor] < 0)
        return failure();
      lastRequired = std::max(lastRequired, baselinePosition[predecessor]);
    }
    for (unsigned consumer : producer.consumers) {
      if (consumer == producer.node || scheduled.test(consumer))
        continue;
      if (baselinePosition[consumer] < 0)
        return failure();
      lastRequired = std::max(lastRequired, baselinePosition[consumer]);
    }
    return lastRequired;
  }

  void selectInitialRecurrenceMoves(ArrayRef<unsigned> baselineOrder,
                                    const llvm::BitVector &scheduled,
                                    ArrayRef<int> baselinePosition,
                                    MutableArrayRef<int> insertionAfter,
                                    llvm::BitVector &moved) const {
    for (const RecurrenceProducer &producer : recurrenceProducers) {
      int producerPosition = baselinePosition[producer.node];
      if (scheduled.test(producer.node) || producerPosition < 0)
        continue;
      FailureOr<int> lastRequired =
          findLastRecurrenceRequirement(producer, scheduled, baselinePosition);
      if (failed(lastRequired) || *lastRequired + 1 >= producerPosition)
        continue;
      unsigned begin = static_cast<unsigned>(*lastRequired + 1);
      if (crossesSplitBarrierInOrder(baselineOrder, begin, producerPosition))
        continue;
      insertionAfter[producer.node] = *lastRequired;
      moved.set(producer.node);
    }
  }

  static SmallVector<unsigned, 8>
  collectMovedInBaselineOrder(ArrayRef<unsigned> baselineOrder,
                              const llvm::BitVector &moved) {
    SmallVector<unsigned, 8> movedInBaselineOrder;
    for (unsigned node : baselineOrder)
      if (moved.test(node))
        movedInBaselineOrder.push_back(node);
    return movedInBaselineOrder;
  }

  void
  constrainRecurrenceCounterOrder(ArrayRef<unsigned> movedInBaselineOrder,
                                  MutableArrayRef<int> insertionAfter) const {
    for (auto [position, producer] : llvm::enumerate(movedInBaselineOrder)) {
      ArrayRef<waveamdmachine::MemoryCounterKind> kinds =
          fillerMemoryKinds[producer];
      for (unsigned prior : movedInBaselineOrder.take_front(position)) {
        waveamdmachine::MemoryCounterKind priorKind = memoryKinds[prior];
        if (containsMemoryKind(kinds, priorKind))
          insertionAfter[producer] =
              std::max(insertionAfter[producer], insertionAfter[prior]);
      }
    }
  }

  void rejectRecurrenceCounterCrossings(ArrayRef<unsigned> baselineOrder,
                                        ArrayRef<unsigned> movedInBaselineOrder,
                                        ArrayRef<int> baselinePosition,
                                        ArrayRef<int> insertionAfter,
                                        llvm::BitVector &moved) const {
    // Re-run after a rejected cohort member becomes a counter boundary.
    bool changed = true;
    while (changed) {
      changed = false;
      for (unsigned producer : movedInBaselineOrder) {
        if (!moved.test(producer))
          continue;
        unsigned begin = static_cast<unsigned>(insertionAfter[producer] + 1);
        unsigned end = baselinePosition[producer];
        ArrayRef<waveamdmachine::MemoryCounterKind> kinds =
            fillerMemoryKinds[producer];
        if (begin < end && !crossesSameMemoryProducerExcept(
                               baselineOrder, begin, end, kinds, moved))
          continue;
        moved.reset(producer);
        changed = true;
      }
    }
  }

  static SmallVector<unsigned, 16> materializeModeledRecurrenceOrder(
      ArrayRef<unsigned> baselineOrder, ArrayRef<unsigned> movedInBaselineOrder,
      ArrayRef<int> insertionAfter, const llvm::BitVector &moved) {
    SmallVector<unsigned, 16> order;
    for (unsigned producer : movedInBaselineOrder)
      if (moved.test(producer) && insertionAfter[producer] < 0)
        order.push_back(producer);
    for (auto [position, node] : llvm::enumerate(baselineOrder)) {
      if (!moved.test(node))
        order.push_back(node);
      for (unsigned producer : movedInBaselineOrder)
        if (moved.test(producer) &&
            insertionAfter[producer] == static_cast<int>(position))
          order.push_back(producer);
    }
    return order;
  }

  ModeledRecurrenceOrder
  buildModeledRecurrenceOrder(ArrayRef<unsigned> baselineOrder,
                              const llvm::BitVector &scheduled) const {
    ModeledRecurrenceOrder result;
    result.moved.resize(operations.size());
    SmallVector<int, 16> baselinePosition(operations.size(), -1);
    if (!indexBaselineOrder(baselineOrder, scheduled, baselinePosition))
      return result;

    SmallVector<int, 16> insertionAfter(operations.size(), -1);
    selectInitialRecurrenceMoves(baselineOrder, scheduled, baselinePosition,
                                 insertionAfter, result.moved);
    SmallVector<unsigned, 8> movedInBaselineOrder =
        collectMovedInBaselineOrder(baselineOrder, result.moved);
    // waitcnt observes issue order within each counter.
    constrainRecurrenceCounterOrder(movedInBaselineOrder, insertionAfter);
    rejectRecurrenceCounterCrossings(baselineOrder, movedInBaselineOrder,
                                     baselinePosition, insertionAfter,
                                     result.moved);
    result.order = materializeModeledRecurrenceOrder(
        baselineOrder, movedInBaselineOrder, insertionAfter, result.moved);
    if (validateModeledRecurrenceOrder(result.order, scheduled, result.moved))
      return result;
    result.order.clear();
    result.moved.reset();
    return result;
  }

  static bool changesRecurrenceOrder(ArrayRef<unsigned> baselineOrder,
                                     const ModeledRecurrenceOrder &modeled) {
    return modeled.moved.any() && !llvm::equal(baselineOrder, modeled.order);
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
  DenseMap<Operation *, unsigned> nodeIndices;
  SmallVector<SmallVector<unsigned, 4>, 16> predecessors;
  SmallVector<SmallVector<unsigned, 4>, 16> successors;
  SmallVector<SmallVector<unsigned, 4>, 16> ssaPredecessors;
  SmallVector<waveamdmachine::MemoryCounterKind, 16> memoryKinds;
  SmallVector<SmallVector<waveamdmachine::MemoryCounterKind, 4>, 16>
      fillerMemoryKinds;
  SmallVector<unsigned, 16> memoryNodes;
  llvm::BitVector steadyCritical;
  llvm::BitVector computeRecurrenceCritical;
  SmallVector<unsigned, 16> computeIslandEnds;
  SmallVector<RecurrenceProducer, 8> recurrenceProducers;
  mutable SmallVector<unsigned, 16> recurrenceOrder;
  mutable unsigned recurrenceCursor = 0;
  mutable bool recurrenceEvaluated = false;
  mutable std::optional<SteadyStallTarget> steadyStallTarget;
  const waveamdmachine::ArchData *arch = nullptr;
  waveamdmachine::EventSimConfig config;
  bool dmaIssueTiming = false;
  bool prioritizeLongLatencyVmem = true;
  bool prioritizeComputeResources = true;
  bool prioritizeLatency = true;
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

FailureOr<unsigned> MultiWaveScheduleSession::selectClass(
    ArrayRef<MultiWaveClassScheduleFacts> classes) const {
  if (classes.size() != kMultiWaveScheduleClassCount)
    return failure();
  for (unsigned offset : llvm::seq<unsigned>(kMultiWaveScheduleClassCount)) {
    unsigned classId = (preferredClass + offset) % kMultiWaveScheduleClassCount;
    const MultiWaveClassScheduleFacts &facts = classes[classId];
    if (facts.waitingAtBarrier || facts.complete)
      continue;
    return classId;
  }
  return failure();
}

void MultiWaveScheduleSession::recordClassAdvance(unsigned classId) {
  assert(classId < kMultiWaveScheduleClassCount && "invalid multi-wave class");
  preferredClass = (classId + 1) % kMultiWaveScheduleClassCount;
}

FailureOr<SingleWaveScheduleDecision>
WaveAMDMachineScheduleModel::selectSingleWaveSchedule(
    ArrayRef<Operation *> operations,
    SingleWaveScheduleBuildProvider buildProvider) const {
  FailureOr<SingleWaveScheduleCandidateFacts> initial =
      buildProvider(SingleWaveScheduleBuildRequest{});
  if (failed(initial))
    return failure();

  SingleWaveScheduleDecision decision{initial->resultToken};
  if (!initial->success || !getCompleteUniformLoop(operations))
    return decision;

  SingleWaveScheduleCandidateFacts accepted = std::move(*initial);
  SmallVector<SmallVector<unsigned, 16>, 4> seenOrders{accepted.order};
  bool usedModeledRecurrence = accepted.recurrenceModelMoves != 0;
  unsigned refinements = 0;

  for ([[maybe_unused]] unsigned refinement :
       llvm::seq<unsigned>(kSingleWaveSteadyStateRefinementLimit)) {
    SingleWaveScheduleBuildRequest request{accepted.order,
                                           kSingleWaveSteadyStateIterations,
                                           /*replaySteadyState=*/true};
    FailureOr<SingleWaveScheduleCandidateFacts> candidate =
        buildProvider(request);
    if (failed(candidate)) {
      decision.resultToken = accepted.resultToken;
      decision.modelFailed = true;
      return decision;
    }

    ++refinements;
    if (!candidate->success) {
      decision.resultToken = candidate->resultToken;
      return decision;
    }
    usedModeledRecurrence |= candidate->recurrenceModelMoves != 0;
    if (sameSingleWaveOrder(candidate->order, accepted.order) ||
        hasSeenSingleWaveOrder(seenOrders, candidate->order))
      break;

    seenOrders.push_back(candidate->order);
    accepted = std::move(*candidate);
    decision.resultToken = accepted.resultToken;
  }

  unsigned recurrenceModelMoves = accepted.recurrenceModelMoves;
  if (usedModeledRecurrence && recurrenceModelMoves == 0)
    recurrenceModelMoves = 1;
  decision.refinementStats = SingleWaveScheduleRefinementStats{
      kSingleWaveSteadyStateIterations, refinements, recurrenceModelMoves};
  return decision;
}

FailureOr<MultiWaveScheduleDecision>
WaveAMDMachineScheduleModel::selectMultiWaveSchedule(
    std::array<ArrayRef<Operation *>, kMultiWaveScheduleClassCount> operations,
    MultiWaveScheduleBuildProvider buildProvider) const {
  FailureOr<MultiWaveScheduleCandidateFacts> initial =
      buildProvider(MultiWaveScheduleBuildRequest{});
  if (failed(initial))
    return failure();

  MultiWaveScheduleDecision decision{initial->resultToken};
  if (!llvm::all_of(operations, [](ArrayRef<Operation *> classOperations) {
        return getCompleteUniformLoop(classOperations) != nullptr;
      }))
    return decision;

  MultiWaveScheduleCandidateFacts accepted = std::move(*initial);
  SmallVector<MultiWaveScheduleOrders, 4> seenOrders{accepted.orders};
  std::array<bool, kMultiWaveScheduleClassCount> usedModeledRecurrence{};
  recordMultiWaveRecurrences(accepted, usedModeledRecurrence);
  unsigned refinements = 0;

  for ([[maybe_unused]] unsigned refinement :
       llvm::seq<unsigned>(kMultiWaveSteadyStateRefinementLimit)) {
    MultiWaveScheduleBuildRequest request{accepted.orders,
                                          kMultiWaveSteadyStateIterations,
                                          /*replaySteadyState=*/true};
    FailureOr<MultiWaveScheduleCandidateFacts> candidate =
        buildProvider(request);
    if (failed(candidate))
      return failure();

    ++refinements;
    recordMultiWaveRecurrences(*candidate, usedModeledRecurrence);
    if (sameMultiWaveOrders(accepted.orders, candidate->orders) ||
        hasSeenMultiWaveOrders(seenOrders, candidate->orders))
      break;

    seenOrders.push_back(candidate->orders);
    accepted = std::move(*candidate);
    decision.resultToken = accepted.resultToken;
  }

  MultiWaveScheduleRefinementStats stats;
  stats.steadyStateIterations = kMultiWaveSteadyStateIterations;
  stats.steadyStateRefinements = refinements;
  stats.recurrenceModelMoves = accepted.recurrenceModelMoves;
  for (unsigned classId : llvm::seq<unsigned>(kMultiWaveScheduleClassCount))
    if (usedModeledRecurrence[classId] &&
        stats.recurrenceModelMoves[classId] == 0)
      stats.recurrenceModelMoves[classId] = 1;
  decision.refinementStats = stats;
  return decision;
}

waveamdmachine::InstructionExecutionConfig
WaveAMDMachineScheduleModel::buildMultiWaveInstructionConfig(
    const waveamdmachine::EventSimConfig &config, Operation *context) const {
  waveamdmachine::InstructionExecutionConfig stateConfig =
      buildWaveAMDMachineInstructionConfig(*impl->arch, config, context);
  stateConfig.smoothLdsDmaIssue = false;
  stateConfig.enablePipeBackpressure = true;
  stateConfig.valuMaxInFlight = 1;
  stateConfig.saluMaxInFlight = 1;
  stateConfig.xdlMaxInFlight = 1;
  return stateConfig;
}

FailureOr<SmallVector<waveamdmachine::WavePlacement, 8>>
WaveAMDMachineScheduleModel::selectMultiWavePlacements(
    Operation *context) const {
  SmallVector<waveamdmachine::WavePlacement, 8> placements =
      waveamdmachine::getFullCUWavePlacements(*impl->arch, context);
  if (placements.empty())
    return failure();
  return placements;
}

unsigned WaveAMDMachineScheduleModel::getMultiWaveClass(
    const waveamdmachine::MultiWaveExecutionState &state, unsigned wave) const {
  return state.getWaveCohort(wave, kMultiWaveScheduleClassCount);
}

MultiWaveScheduleSession
WaveAMDMachineScheduleModel::createMultiWaveScheduleSession() const {
  return MultiWaveScheduleSession();
}

RegionScheduleSession WaveAMDMachineScheduleModel::createRegionSession(
    ArrayRef<Operation *> operations,
    ArrayRef<SmallVector<unsigned, 4>> predecessors,
    ArrayRef<SmallVector<unsigned, 4>> successors,
    ArrayRef<waveamdmachine::MemoryCounterKind> memoryKinds,
    ArrayRef<SmallVector<waveamdmachine::MemoryCounterKind, 4>>
        fillerMemoryKinds,
    ArrayRef<unsigned> memoryNodes,
    ArrayRef<SmallVector<unsigned, 4>> ssaPredecessors,
    const waveamdmachine::EventSimConfig &config) const {
  auto region = std::make_unique<RegionScheduleSession::Impl>();
  region->operations.assign(operations.begin(), operations.end());
  for (auto [index, op] : llvm::enumerate(operations))
    region->nodeIndices[op] = index;
  region->predecessors.assign(predecessors.begin(), predecessors.end());
  region->successors.assign(successors.begin(), successors.end());
  region->ssaPredecessors.assign(ssaPredecessors.begin(),
                                 ssaPredecessors.end());
  region->memoryKinds.assign(memoryKinds.begin(), memoryKinds.end());
  region->fillerMemoryKinds.assign(fillerMemoryKinds.begin(),
                                   fillerMemoryKinds.end());
  region->memoryNodes.assign(memoryNodes.begin(), memoryNodes.end());
  region->arch = impl->arch;
  region->config = config;
  if (!operations.empty()) {
    Block *block = operations.front()->getBlock();
    region->dmaIssueTiming =
        isa_and_nonnull<waveamdmachine::UniformLoopOp>(block->getParentOp()) &&
        llvm::any_of(block->without_terminator(), [](Operation &op) {
          return isa<waveamdmachine::DmaIssueDelayOp>(op);
        });
    assert(
        llvm::all_of(operations,
                     [&](Operation *op) { return op->getBlock() == block; }) &&
        "ready scheduling region crosses a block boundary");
  }
  region->noInstructions.resize(operations.size());
  for (auto [index, op] : llvm::enumerate(operations))
    if (waveamdmachine::classifyOp(op) == waveamdmachine::SchedClass::NoInst)
      region->noInstructions.set(index);
  region->initializeReadyCriticalSets();
  region->initializeRecurrencePlan();
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
            !filler.candidateRealInstruction ||
            !policy.canSelectStallFiller(
                filler.stall.reason, resource.coexecWindowFilledSlots,
                filler.candidateStalls,
                filler.stall.kind == ReadyScheduleStallKind::Cycle,
                filler.candidateNextIssueCycle,
                filler.candidateIssueEndCycle, filler.stall.issueCycle))
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

static bool stallsReadyIssue(const ReadyScheduleIssueFacts &issue) {
  return issue.operandWaitCycles != 0 || issue.memoryWaitCycles != 0 ||
         issue.functionalUnitWaitCycles != 0 ||
         issue.coexecWindowWaitCycles != 0 || issue.issueWaitCycles != 0 ||
         issue.cuIssueWaitCycles != 0 || issue.cmaIssueWaitCycles != 0 ||
         issue.hazardWaitInstructions != 0;
}

static bool stallsReadyPriority(const ReadyScheduleDynamicIssueFacts &issue) {
  return issue.priorityStall || issue.issue.issueWaitCycles != 0 ||
         issue.issue.cuIssueWaitCycles != 0 ||
         issue.issue.cmaIssueWaitCycles != 0;
}

static bool
stallsReadyComputePriority(const ReadyScheduleDynamicIssueFacts &issue) {
  return issue.computePriorityStall || issue.issue.issueWaitCycles != 0 ||
         issue.issue.cuIssueWaitCycles != 0 ||
         issue.issue.cmaIssueWaitCycles != 0;
}

FailureOr<ReadyScheduleDecision> RegionScheduleSession::selectReady(
    ReadySchedulePhase phase, const llvm::BitVector &scheduled,
    unsigned baseline, const llvm::BitVector &legalReadyCandidates,
    bool hasSteadyState, const waveamdmachine::InstructionScheduleModel &policy,
    ReadyScheduleDynamicIssueProvider issueProvider,
    ReadyScheduleProjectionProvider projectionProvider) const {
  assert(scheduled.size() == impl->operations.size() &&
         legalReadyCandidates.size() == impl->operations.size() &&
         baseline < impl->operations.size() && "invalid ready selection");
  llvm::BitVector noDiscoveries(impl->operations.size());

  auto getIssue = [&](unsigned candidate, ReadyScheduleTimeline timeline) {
    return issueProvider(candidate, timeline);
  };
  auto getCandidateIssue =
      [&](unsigned candidate) -> FailureOr<ReadyScheduleCandidateIssueFacts> {
    FailureOr<ReadyScheduleDynamicIssueFacts> issue =
        getIssue(candidate, ReadyScheduleTimeline::Local);
    if (failed(issue))
      return failure();
    return ReadyScheduleCandidateIssueFacts{
        issue->nextIssueCycle, issue->issues, issue->realInstruction,
        stallsReadyIssue(issue->issue)};
  };

  // Model override. The ready set is a legality fact; compatibility,
  // issueability, pressure admission, and ranking are model policy.
  llvm::BitVector overrideCandidates(impl->operations.size());
  for (int ready = legalReadyCandidates.find_first(); ready >= 0;
       ready = legalReadyCandidates.find_next(ready)) {
    unsigned candidate = ready;
    if (candidate == baseline || scheduled.test(candidate) ||
        !impl->canUseStallFiller(scheduled, baseline, candidate) ||
        impl->crossesSplitBarrier(scheduled, baseline, candidate))
      continue;
    FailureOr<ReadyScheduleDynamicIssueFacts> issue =
        getIssue(candidate, ReadyScheduleTimeline::Local);
    if (failed(issue))
      return failure();
    if (!stallsReadyIssue(issue->issue))
      overrideCandidates.set(candidate);
  }
  ReadyScheduleDecision decision =
      selectNext(scheduled, baseline, overrideCandidates, {}, policy);
  if (decision.candidate || phase == ReadySchedulePhase::ResumeBaseline)
    return decision;

  if (hasSteadyState) {
    FailureOr<ReadyScheduleDynamicIssueFacts> baselineSteady =
        getIssue(baseline, ReadyScheduleTimeline::Steady);
    if (failed(baselineSteady))
      return failure();

    bool baselineSteadyStalls = stallsReadyIssue(baselineSteady->issue);
    if (policy.shouldPrioritizeSteadyStateProducer() && baselineSteadyStalls) {
      ReadyScheduleStallFacts stall =
          classifyStall(baseline, baselineSteady->issue,
                        /*blockMemoryResource=*/true);
      std::optional<unsigned> producer;
      for (int ready = legalReadyCandidates.find_first(); ready >= 0;
           ready = legalReadyCandidates.find_next(ready)) {
        unsigned candidate = ready;
        if (candidate == baseline || scheduled.test(candidate) ||
            !impl->steadyCritical.test(candidate) ||
            impl->isBarrier(candidate) ||
            (stall.blockedMemoryResources &
             waveamdmachine::getMemoryIssueResources(
                 impl->operations[candidate])) != 0 ||
            (candidate > baseline &&
             impl->crossesSplitBarrier(scheduled, baseline, candidate)))
          continue;
        FailureOr<ReadyScheduleDynamicIssueFacts> localIssue =
            getIssue(candidate, ReadyScheduleTimeline::Local);
        FailureOr<ReadyScheduleDynamicIssueFacts> steadyIssue =
            getIssue(candidate, ReadyScheduleTimeline::Steady);
        if (failed(localIssue) || failed(steadyIssue))
          return failure();
        if (localIssue->realInstruction &&
            !stallsReadyIssue(localIssue->issue) &&
            steadyIssue->realInstruction &&
            !stallsReadyIssue(steadyIssue->issue)) {
          producer = candidate;
          break;
        }
      }
      if (producer) {
        ReadyScheduleProposal proposal{
            *producer, ReadyScheduleProposalKind::Direct, /*group=*/0};
        decision =
            selectNext(scheduled, baseline, noDiscoveries, proposal, policy);
        if (decision.candidate) {
          decision.kind = ReadyScheduleSelectionKind::SteadyStateProducer;
          return decision;
        }
      }
    }

    if (impl->steadyStallTarget && impl->steadyStallTarget->index != baseline)
      impl->steadyStallTarget.reset();
    if (!impl->steadyStallTarget && baselineSteadyStalls &&
        classifyStall(baseline, baselineSteady->issue,
                      /*blockMemoryResource=*/false)
                .kind != ReadyScheduleStallKind::None)
      impl->steadyStallTarget = Impl::SteadyStallTarget{baseline, /*fills=*/0};

    if (impl->steadyStallTarget &&
        impl->steadyStallTarget->fills < kSteadyStateFillsPerTarget) {
      SmallVector<ReadyScheduleProposal, 8> proposals;
      for (unsigned candidate : llvm::seq(
               baseline + 1, static_cast<unsigned>(impl->operations.size()))) {
        Operation *op = impl->operations[candidate];
        if (!legalReadyCandidates.test(candidate) ||
            scheduled.test(candidate) || !isPure(op) ||
            impl->memoryKinds[candidate] !=
                waveamdmachine::MemoryCounterKind::None ||
            impl->crossesSplitBarrier(scheduled, baseline, candidate))
          continue;
        FailureOr<ReadyScheduleDynamicIssueFacts> localIssue =
            getIssue(candidate, ReadyScheduleTimeline::Local);
        FailureOr<ReadyScheduleDynamicIssueFacts> steadyIssue =
            getIssue(candidate, ReadyScheduleTimeline::Steady);
        if (failed(localIssue) || failed(steadyIssue))
          return failure();
        if (!localIssue->realInstruction ||
            stallsReadyIssue(localIssue->issue) ||
            localIssue->resource.releaseSlots != 1 ||
            !steadyIssue->realInstruction ||
            stallsReadyIssue(steadyIssue->issue) ||
            steadyIssue->resource.releaseSlots != 1)
          continue;
        proposals.push_back({candidate, ReadyScheduleProposalKind::RankedFiller,
                             /*group=*/0});
      }
      decision =
          selectNext(scheduled, baseline, noDiscoveries, proposals, policy);
      if (decision.candidate) {
        ++impl->steadyStallTarget->fills;
        decision.kind = ReadyScheduleSelectionKind::SteadyStateFiller;
        decision.filledStall = baselineSteadyStalls;
        decision.filledBarrierMemoryStall =
            baselineSteadyStalls &&
            baselineSteady->issue.memoryWaitCycles != 0 &&
            impl->isBarrier(baseline);
        return decision;
      }
      impl->steadyStallTarget.reset();
    }
  }

  FailureOr<ReadyScheduleDecision> memory =
      selectMemoryReady(scheduled, baseline, legalReadyCandidates,
                        impl->prioritizeLongLatencyVmem, policy,
                        getCandidateIssue, projectionProvider);
  if (failed(memory))
    return failure();
  if (memory->candidate)
    return *memory;

  llvm::BitVector computeCandidates =
      getComputeResourceCandidates(scheduled, baseline, legalReadyCandidates);
  if (computeCandidates.any()) {
    FailureOr<ReadyScheduleDynamicIssueFacts> baselineIssue =
        getIssue(baseline, ReadyScheduleTimeline::Local);
    if (failed(baselineIssue))
      return failure();
    SmallVector<ReadyScheduleProposal, 8> proposals;
    for (int candidate = computeCandidates.find_first(); candidate >= 0;
         candidate = computeCandidates.find_next(candidate)) {
      FailureOr<ReadyScheduleDynamicIssueFacts> issue =
          getIssue(candidate, ReadyScheduleTimeline::Local);
      if (failed(issue))
        return failure();
      ReadyScheduleProposal proposal{static_cast<unsigned>(candidate),
                                     ReadyScheduleProposalKind::ComputeResource,
                                     /*group=*/0};
      proposal.resource = {baselineIssue->resource, issue->resource,
                           stallsReadyComputePriority(*baselineIssue),
                           stallsReadyPriority(*issue),
                           impl->prioritizeComputeResources};
      proposals.push_back(proposal);
    }
    decision = selectComputeResource(scheduled, baseline, legalReadyCandidates,
                                     proposals, policy);
    if (decision.candidate)
      return decision;
  }

  if (!supportsLatencyPriority(impl->prioritizeLatency))
    return ReadyScheduleDecision{};
  FailureOr<ReadyScheduleDynamicIssueFacts> baselineIssue =
      getIssue(baseline, ReadyScheduleTimeline::Local);
  if (failed(baselineIssue))
    return failure();
  llvm::BitVector latencyCandidates =
      getLatencyCandidates(scheduled, baseline, legalReadyCandidates,
                           stallsReadyPriority(*baselineIssue), policy);
  if (!latencyCandidates.any())
    return ReadyScheduleDecision{};
  SmallVector<ReadyScheduleProposal, 8> latencyProposals;
  for (int candidate = latencyCandidates.find_first(); candidate >= 0;
       candidate = latencyCandidates.find_next(candidate)) {
    FailureOr<ReadyScheduleDynamicIssueFacts> issue =
        getIssue(candidate, ReadyScheduleTimeline::Local);
    if (failed(issue))
      return failure();
    ReadyScheduleProposal proposal{static_cast<unsigned>(candidate),
                                   ReadyScheduleProposalKind::Latency,
                                   /*group=*/0};
    proposal.latency = {stallsReadyPriority(*baselineIssue),
                        stallsReadyPriority(*issue)};
    latencyProposals.push_back(proposal);
  }
  decision =
      selectNext(scheduled, baseline, noDiscoveries, latencyProposals, policy);
  if (decision.candidate)
    decision.resumeBaseline = true;
  return decision;
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

static int64_t
getProjectedMemoryWaitCycles(const ReadyScheduleProjectionFacts &projection) {
  int64_t cycles = 0;
  for (const waveamdmachine::InstructionStallComponent &stall :
       projection.stalls)
    if (stall.kind == waveamdmachine::InstructionStallKind::MemoryToken ||
        stall.kind == waveamdmachine::InstructionStallKind::Waitcnt)
      cycles += stall.cycles;
  return cycles;
}

static int64_t getProjectedIssueBackpressureCycles(
    const ReadyScheduleProjectionFacts &projection) {
  int64_t cycles = 0;
  for (const waveamdmachine::InstructionStallComponent &stall :
       projection.stalls)
    if (stall.kind == waveamdmachine::InstructionStallKind::IssueBackpressure)
      cycles += stall.cycles;
  return cycles;
}

FailureOr<ReadyScheduleDecision> RegionScheduleSession::selectMemoryReady(
    const llvm::BitVector &scheduled, unsigned baseline,
    const llvm::BitVector &legalReadyCandidates, bool prioritizeLongLatencyVmem,
    const waveamdmachine::InstructionScheduleModel &policy,
    ReadyScheduleIssueProvider issueProvider,
    ReadyScheduleProjectionProvider projectionProvider) const {
  assert(scheduled.size() == impl->operations.size() &&
         legalReadyCandidates.size() == impl->operations.size() &&
         baseline < impl->operations.size() &&
         "invalid memory ready selection");
  llvm::BitVector noDiscoveries(impl->operations.size());
  auto selectRanked = [&](unsigned candidate, ReadyScheduleSelectionKind kind) {
    ReadyScheduleProposal proposal{candidate,
                                   ReadyScheduleProposalKind::RankedFiller,
                                   /*group=*/0};
    ReadyScheduleDecision decision =
        selectNext(scheduled, baseline, noDiscoveries, proposal, policy);
    if (decision.candidate)
      decision.kind = kind;
    return decision;
  };

  // A token consumer is considered only after its explicit graph dependencies
  // made it ready. Never infer readiness from memory aliasing or wait state.
  for (unsigned candidate : llvm::seq(
           baseline + 1, static_cast<unsigned>(impl->operations.size()))) {
    if (!legalReadyCandidates.test(candidate) ||
        !waveamdmachine::waitsForMemoryTokenDepsBeforeIssue(
            impl->operations[candidate]))
      continue;
    if (impl->findBarrierPairFiller(legalReadyCandidates, scheduled,
                                    candidate) != impl->operations.size() ||
        (impl->isFullBarrier(baseline) && impl->isFullBarrier(candidate)))
      break;
    if (!impl->canUseStallFiller(scheduled, baseline, candidate))
      continue;

    SmallVector<unsigned, 2> original{baseline, candidate};
    SmallVector<unsigned, 2> moved{candidate, baseline};
    FailureOr<ReadyScheduleProjectionFacts> originalProjection =
        projectionProvider(original);
    if (failed(originalProjection))
      return failure();
    FailureOr<ReadyScheduleProjectionFacts> movedProjection =
        projectionProvider(moved);
    if (failed(movedProjection))
      return failure();

    int64_t originalMemoryWaitCycles =
        getProjectedMemoryWaitCycles(*originalProjection);
    int64_t movedMemoryWaitCycles =
        getProjectedMemoryWaitCycles(*movedProjection);
    int64_t originalIssueBackpressureCycles =
        getProjectedIssueBackpressureCycles(*originalProjection);
    int64_t movedIssueBackpressureCycles =
        getProjectedIssueBackpressureCycles(*movedProjection);
    bool strict =
        (impl->dmaIssueTiming || policy.requiresStrictBarrierTokenReorder()) &&
        impl->isBarrier(candidate);
    bool canMove =
        strict ? movedMemoryWaitCycles < originalMemoryWaitCycles ||
                     (movedMemoryWaitCycles == originalMemoryWaitCycles &&
                      movedIssueBackpressureCycles <
                          originalIssueBackpressureCycles)
               : movedMemoryWaitCycles <= originalMemoryWaitCycles &&
                     movedIssueBackpressureCycles <=
                         originalIssueBackpressureCycles;
    if (!canMove)
      continue;
    ReadyScheduleDecision decision = selectRanked(
        candidate, ReadyScheduleSelectionKind::MemoryTokenConsumer);
    if (decision.candidate)
      return decision;
    break;
  }

  unsigned barrierFiller =
      impl->findBarrierPairFiller(legalReadyCandidates, scheduled, baseline);
  if (barrierFiller != impl->operations.size()) {
    ReadyScheduleDecision decision = selectRanked(
        barrierFiller, ReadyScheduleSelectionKind::BarrierPairFiller);
    if (decision.candidate)
      return decision;
  }

  unsigned candidate = impl->findNextVmemValue(baseline, scheduled);
  if (candidate == impl->operations.size() ||
      !waveamdmachine::hasMemoryValueLatency(impl->operations[candidate]) ||
      !impl->canUseStallFiller(scheduled, baseline, candidate))
    return ReadyScheduleDecision{};

  llvm::BitVector chain(impl->operations.size());
  if (!impl->collectPrefetchChain(candidate, candidate, baseline, scheduled,
                                  chain))
    return ReadyScheduleDecision{};
  int chainHead = chain.find_first();
  if (chainHead < 0 || !legalReadyCandidates.test(chainHead))
    return ReadyScheduleDecision{};
  FailureOr<ReadyScheduleCandidateIssueFacts> headIssue =
      issueProvider(chainHead);
  if (failed(headIssue))
    return failure();
  if (headIssue->stalls)
    return ReadyScheduleDecision{};

  unsigned consumer = impl->findFirstRealDataConsumer(candidate, scheduled);
  if (consumer == impl->operations.size() || consumer <= candidate)
    return ReadyScheduleDecision{};
  int64_t memoryLatency = waveamdmachine::getMemoryValueLatency(
      *impl->arch, impl->operations[candidate], impl->config.counterLatencies,
      impl->config.valueLatencies, impl->config.calibration);
  bool longLatency = policy.shouldPrioritizeLongLatency(
      prioritizeLongLatencyVmem, memoryLatency, impl->getLatency(baseline));
  if (!longLatency) {
    if (impl->hasPrefetchSlack(baseline, candidate, consumer, chain, scheduled))
      return ReadyScheduleDecision{};
    SmallVector<unsigned, 32> nextFirst = impl->buildPrefetchProjectionOrder(
        baseline, chain, consumer, /*prefetchFirst=*/false, scheduled);
    FailureOr<ReadyScheduleProjectionFacts> nextFirstProjection =
        projectionProvider(nextFirst);
    if (failed(nextFirstProjection))
      return failure();
    SmallVector<unsigned, 32> prefetchFirst =
        impl->buildPrefetchProjectionOrder(baseline, chain, consumer,
                                           /*prefetchFirst=*/true, scheduled);
    FailureOr<ReadyScheduleProjectionFacts> prefetchFirstProjection =
        projectionProvider(prefetchFirst);
    if (failed(prefetchFirstProjection))
      return failure();
    if (prefetchFirstProjection->cycles >= nextFirstProjection->cycles)
      return ReadyScheduleDecision{};
  }

  return selectRanked(chainHead,
                      longLatency
                          ? ReadyScheduleSelectionKind::LongLatencyVmemPrefetch
                          : ReadyScheduleSelectionKind::VmemPrefetch);
}

FailureOr<ReadyScheduleDecision> RegionScheduleSession::selectStallFiller(
    const llvm::BitVector &scheduled, unsigned baseline,
    const llvm::BitVector &legalReadyCandidates,
    const ReadyScheduleStallFacts &stall,
    const waveamdmachine::InstructionScheduleModel &policy,
    ReadyScheduleIssueProvider issueProvider) const {
  assert(scheduled.size() == impl->operations.size() &&
         legalReadyCandidates.size() == impl->operations.size() &&
         baseline < impl->operations.size() &&
         "invalid stall filler selection");
  llvm::BitVector noDiscoveries(impl->operations.size());
  auto selectRanked = [&](unsigned candidate, ReadyScheduleSelectionKind kind) {
    ReadyScheduleProposal proposal{candidate,
                                   ReadyScheduleProposalKind::RankedFiller,
                                   /*group=*/0};
    ReadyScheduleDecision decision =
        selectNext(scheduled, baseline, noDiscoveries, proposal, policy);
    if (decision.candidate)
      decision.kind = kind;
    return decision;
  };

  if (impl->dmaIssueTiming &&
      isa<waveamdmachine::DmaIssueDelayOp>(impl->operations[baseline])) {
    unsigned barrier =
        impl->findFirstUnscheduledBarrier(scheduled, baseline + 1);
    if (barrier != impl->operations.size()) {
      unsigned memory =
          impl->findFirstUnscheduledMemory(scheduled, barrier + 1);
      if (memory != impl->operations.size()) {
        for (unsigned candidate : llvm::seq(
                 memory + 1, static_cast<unsigned>(impl->operations.size()))) {
          if (!impl->isPostBarrierFillerCandidate(
                  candidate, legalReadyCandidates, scheduled))
            continue;
          FailureOr<ReadyScheduleCandidateIssueFacts> issue =
              issueProvider(candidate);
          if (failed(issue))
            return failure();
          if (stall.kind == ReadyScheduleStallKind::None ||
              !issue->realInstruction || issue->stalls ||
              (stall.kind == ReadyScheduleStallKind::Cycle &&
               issue->nextIssueCycle > stall.issueCycle))
            continue;
          int64_t reserveCycles =
              static_cast<int64_t>(issue->issues) *
              waveamdmachine::getEventSimIssuePeriod(*impl->arch, impl->config);
          if (issue->nextIssueCycle + reserveCycles > stall.issueCycle)
            continue;
          ReadyScheduleDecision decision = selectRanked(
              candidate, ReadyScheduleSelectionKind::DmaPostBarrierFiller);
          if (decision.candidate)
            return decision;
          break;
        }
      }
    }
  }

  SmallVector<ReadyScheduleProposal, 8> proposals;
  if (stall.kind != ReadyScheduleStallKind::None)
    for (int ready = legalReadyCandidates.find_first(); ready >= 0;
         ready = legalReadyCandidates.find_next(ready)) {
      unsigned candidate = ready;
      if (candidate == baseline || scheduled.test(candidate) ||
          (impl->isFullBarrier(baseline) && impl->isFullBarrier(candidate)) ||
          !impl->canUseStallFiller(scheduled, baseline, candidate) ||
          (stall.blockedMemoryResources &
           waveamdmachine::getMemoryIssueResources(
               impl->operations[candidate])) != 0)
        continue;
      waveamdmachine::SchedClass cls =
          waveamdmachine::classifyOp(impl->operations[candidate]);
      waveamdmachine::InstructionScheduleResourceInfo resource =
          waveamdmachine::getInstructionScheduleResourceInfo(
              impl->operations[candidate], cls, *impl->arch);
      if (!policy.canFillStall(stall.reason,
                               resource.coexecWindowFilledSlots))
        continue;
      FailureOr<ReadyScheduleCandidateIssueFacts> issue =
          issueProvider(candidate);
      if (failed(issue))
        return failure();
      ReadyScheduleProposal proposal{
          candidate, ReadyScheduleProposalKind::GenericStallFiller,
          /*group=*/0};
      int64_t reserveCycles =
          static_cast<int64_t>(issue->issues) *
          waveamdmachine::getEventSimIssuePeriod(*impl->arch, impl->config);
      proposal.filler = {stall, issue->nextIssueCycle,
                         issue->nextIssueCycle + reserveCycles,
                         issue->realInstruction, issue->stalls};
      proposals.push_back(proposal);
    }
  return selectNext(scheduled, baseline, noDiscoveries, proposals, policy);
}

bool RegionScheduleSession::canIssueBaselineDespiteStall(
    unsigned baseline, const ReadyScheduleIssueFacts &issue,
    const waveamdmachine::InstructionScheduleModel &policy) const {
  assert(baseline < impl->operations.size() && "invalid stall baseline");
  Operation *op = impl->operations[baseline];
  bool dependenciesReady = issue.operandWaitCycles == 0 &&
                           issue.memoryWaitCycles == 0 &&
                           issue.hazardWaitInstructions == 0;
  bool preserveDmaIssueLead =
      impl->dmaIssueTiming && !op->hasAttr(kDmaIssueAfterDelayAttr) &&
      op->hasTrait<OpTrait::waveamdmachine::LDSDmaOp>() &&
      policy.canIssueLdsDmaDuringLead(issue.functionalUnitWaitCycles,
                                      dependenciesReady);
  bool emptyBarrierWait =
      isa<waveamdmachine::BarrierWaitOp>(op) && issue.memoryWaitCycles == 0;
  return preserveDmaIssueLead || emptyBarrierWait;
}

FailureOr<RecurrenceScheduleDecision> RegionScheduleSession::selectRecurrence(
    unsigned baseline, const llvm::BitVector &legalReadyCandidates,
    const llvm::BitVector &scheduled, ArrayRef<unsigned> scheduledPrefix,
    RecurrenceScheduleBaselineProvider baselineProvider,
    RecurrenceScheduleProjectionProvider projectionProvider) const {
  assert(legalReadyCandidates.size() == impl->operations.size() &&
         scheduled.size() == impl->operations.size() &&
         baseline < impl->operations.size() &&
         "invalid recurrence selection state");

  while (impl->recurrenceCursor < impl->recurrenceOrder.size() &&
         scheduled.test(impl->recurrenceOrder[impl->recurrenceCursor]))
    ++impl->recurrenceCursor;
  if (impl->recurrenceCursor < impl->recurrenceOrder.size()) {
    unsigned candidate = impl->recurrenceOrder[impl->recurrenceCursor];
    if (!legalReadyCandidates.test(candidate))
      return failure();
    return RecurrenceScheduleDecision{candidate};
  }

  if (!legalReadyCandidates.test(baseline) || impl->recurrenceEvaluated ||
      impl->recurrenceProducers.empty())
    return RecurrenceScheduleDecision{};

  // Baseline completion explores the normal ready policy through this same
  // session. Preserve the real path's sticky steady target exactly as the old
  // copied scheduler state did; pressure caches and work counters intentionally
  // remain shared.
  std::optional<Impl::SteadyStallTarget> steadyStallTarget =
      impl->steadyStallTarget;
  FailureOr<RecurrenceScheduleBaselineFacts> baselineCompletion =
      baselineProvider();
  impl->steadyStallTarget = steadyStallTarget;
  if (failed(baselineCompletion))
    return failure();
  impl->recurrenceEvaluated = true;

  Impl::ModeledRecurrenceOrder modeled =
      impl->buildModeledRecurrenceOrder(baselineCompletion->order, scheduled);
  if (!Impl::changesRecurrenceOrder(baselineCompletion->order, modeled))
    return RecurrenceScheduleDecision{};

  FailureOr<RecurrenceScheduleProjectionFacts> baselineProjection =
      projectionProvider(scheduledPrefix, baselineCompletion->order);
  FailureOr<RecurrenceScheduleProjectionFacts> modeledProjection =
      projectionProvider(scheduledPrefix, modeled.order);
  if (failed(baselineProjection) || failed(modeledProjection))
    return failure();
  int64_t baselineCycles = std::max(baselineProjection->modelCycles,
                                    baselineProjection->resourceCycles);
  int64_t modeledCycles = std::max(modeledProjection->modelCycles,
                                   modeledProjection->resourceCycles);
  if (modeledCycles >= baselineCycles || modeled.order.empty() ||
      !legalReadyCandidates.test(modeled.order.front()))
    return RecurrenceScheduleDecision{};

  unsigned movedCount = modeled.moved.count();
  impl->recurrenceOrder = std::move(modeled.order);
  impl->recurrenceCursor = 0;
  return RecurrenceScheduleDecision{impl->recurrenceOrder.front(), movedCount,
                                    /*activated=*/true};
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
