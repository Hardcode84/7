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
#include "mlir/Dialect/WaveAMDMachine/CostModel/CalibrationData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
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

static constexpr StringLiteral kDmaIssueAfterDelayAttr =
    "waveamdmachine.dma_issue_after_delay";
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

static bool sameResourcePreview(
    const waveamdmachine::InstructionScheduleResourcePreview &lhs,
    const waveamdmachine::InstructionScheduleResourcePreview &rhs) {
  return lhs.waitSlots == rhs.waitSlots &&
         lhs.releaseSlots == rhs.releaseSlots &&
         lhs.functionalUnit == rhs.functionalUnit;
}

static bool sameStallFacts(const ReadyScheduleStallFacts &lhs,
                           const ReadyScheduleStallFacts &rhs) {
  return lhs.issueCycle == rhs.issueCycle &&
         lhs.blockedMemoryResources == rhs.blockedMemoryResources &&
         lhs.reason == rhs.reason && lhs.kind == rhs.kind;
}

} // namespace

static int64_t
getProjectedMemoryWaitCycles(const ReadyScheduleProjectionFacts &projection);
static int64_t getProjectedIssueBackpressureCycles(
    const ReadyScheduleProjectionFacts &projection);

struct WaveAMDMachineScheduleModel::Impl {
  WaveAMDLiveIntervalBuildResult liveness;
  waveamdmachine::ReadyRegisterPressureLimits pressureLimits;
  const waveamdmachine::ArchData *arch = nullptr;
  unsigned targetWaveCount = 1;
  unsigned readyPressureWaveCohort = 1;
  unsigned wavefrontSize = 64;
};

struct RegionScheduleSession::Impl {
  explicit Impl(unsigned wavefrontSize) : config(wavefrontSize) {}

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
           waveamdmachine::getInstructionScheduleResourceInfo(op, cls, *arch,
                                                              wavefrontSize)
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
    ArrayRef<unsigned>::iterator memory =
        llvm::lower_bound(memoryNodes, baseline);
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
    assert(nodeIndices && "missing region node indices");
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
        llvm::DenseMap<Operation *, unsigned>::const_iterator it =
            nodeIndices->find(user);
        if (it == nodeIndices->end())
          continue;
        if (noInstructions.test(it->second)) {
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
    if (node != candidate && !noInstructions.test(node) && !isPure(op))
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
    return !noInstructions.test(index);
  }

  unsigned getIssueSlots(unsigned index) const {
    if (!isRealInstruction(index))
      return 0;
    waveamdmachine::SchedClass cls =
        waveamdmachine::classifyOp(operations[index]);
    return waveamdmachine::getInstructionScheduleResourceInfo(
               operations[index], cls, *arch, wavefrontSize)
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

  FailureOr<bool> canMoveMemoryTokenConsumer(
      unsigned baseline, unsigned candidate,
      const waveamdmachine::InstructionScheduleModel &policy,
      ReadyScheduleProjectionProvider projectionProvider) const {
    SmallVector<unsigned, 2> original{baseline, candidate};
    FailureOr<ReadyScheduleProjectionFacts> originalProjection =
        projectionProvider(original);
    if (failed(originalProjection))
      return failure();
    SmallVector<unsigned, 2> moved{candidate, baseline};
    FailureOr<ReadyScheduleProjectionFacts> movedProjection =
        projectionProvider(moved);
    if (failed(movedProjection))
      return failure();

    int64_t originalMemory = getProjectedMemoryWaitCycles(*originalProjection);
    int64_t movedMemory = getProjectedMemoryWaitCycles(*movedProjection);
    int64_t originalIssue =
        getProjectedIssueBackpressureCycles(*originalProjection);
    int64_t movedIssue = getProjectedIssueBackpressureCycles(*movedProjection);
    bool strict =
        (dmaIssueTiming || policy.requiresStrictBarrierTokenReorder()) &&
        isBarrier(candidate);
    if (strict)
      return movedMemory < originalMemory ||
             (movedMemory == originalMemory && movedIssue < originalIssue);
    return movedMemory <= originalMemory && movedIssue <= originalIssue;
  }

  FailureOr<std::optional<unsigned>> findMemoryTokenConsumer(
      const llvm::BitVector &scheduled, unsigned baseline,
      const llvm::BitVector &legalReadyCandidates,
      const waveamdmachine::InstructionScheduleModel &policy,
      ReadyScheduleProjectionProvider projectionProvider) const {
    // Ready comes from explicit graph edges; wait state never creates legality.
    for (unsigned candidate :
         llvm::seq(baseline + 1, static_cast<unsigned>(operations.size()))) {
      if (!legalReadyCandidates.test(candidate) ||
          !waveamdmachine::waitsForMemoryTokenDepsBeforeIssue(
              operations[candidate]))
        continue;
      if (findBarrierPairFiller(legalReadyCandidates, scheduled, candidate) !=
              operations.size() ||
          (isFullBarrier(baseline) && isFullBarrier(candidate)))
        return std::optional<unsigned>{};
      if (!canUseStallFiller(scheduled, baseline, candidate))
        continue;
      FailureOr<bool> canMove = canMoveMemoryTokenConsumer(
          baseline, candidate, policy, projectionProvider);
      if (failed(canMove))
        return failure();
      if (*canMove)
        return std::optional<unsigned>(candidate);
    }
    return std::optional<unsigned>{};
  }

  struct VmemPrefetchCandidate {
    llvm::BitVector chain;
    unsigned node = 0;
    unsigned head = 0;
    unsigned consumer = 0;
  };

  bool isVmemPrefetchCandidate(const llvm::BitVector &scheduled,
                               unsigned baseline, unsigned candidate) const {
    return candidate != operations.size() &&
           waveamdmachine::hasMemoryValueLatency(operations[candidate]) &&
           canUseStallFiller(scheduled, baseline, candidate);
  }

  FailureOr<std::optional<VmemPrefetchCandidate>>
  buildVmemPrefetchCandidate(const llvm::BitVector &scheduled,
                             unsigned baseline,
                             const llvm::BitVector &legalReadyCandidates,
                             ReadyScheduleIssueProvider issueProvider) const {
    unsigned candidate = findNextVmemValue(baseline, scheduled);
    if (!isVmemPrefetchCandidate(scheduled, baseline, candidate))
      return std::optional<VmemPrefetchCandidate>{};

    VmemPrefetchCandidate result;
    result.chain.resize(operations.size());
    result.node = candidate;
    if (!collectPrefetchChain(candidate, candidate, baseline, scheduled,
                              result.chain))
      return std::optional<VmemPrefetchCandidate>{};
    int head = result.chain.find_first();
    if (head < 0 || !legalReadyCandidates.test(head))
      return std::optional<VmemPrefetchCandidate>{};
    FailureOr<ReadyScheduleCandidateIssueFacts> headIssue = issueProvider(head);
    if (failed(headIssue))
      return failure();
    if (headIssue->stalls)
      return std::optional<VmemPrefetchCandidate>{};

    result.head = head;
    result.consumer = findFirstRealDataConsumer(candidate, scheduled);
    if (result.consumer == operations.size() || result.consumer <= candidate)
      return std::optional<VmemPrefetchCandidate>{};
    return std::optional<VmemPrefetchCandidate>(std::move(result));
  }

  FailureOr<std::optional<ReadyScheduleSelectionKind>> classifyVmemPrefetch(
      const VmemPrefetchCandidate &candidate, const llvm::BitVector &scheduled,
      unsigned baseline, bool prioritizeLongLatencyVmem,
      const waveamdmachine::InstructionScheduleModel &policy,
      ReadyScheduleProjectionProvider projectionProvider) const {
    int64_t memoryLatency = waveamdmachine::getMemoryValueLatency(
        *arch, operations[candidate.node], config.counterLatencies,
        config.valueLatencies, config.calibration);
    if (policy.shouldPrioritizeLongLatency(prioritizeLongLatencyVmem,
                                           memoryLatency, getLatency(baseline)))
      return std::optional<ReadyScheduleSelectionKind>(
          ReadyScheduleSelectionKind::LongLatencyVmemPrefetch);
    if (hasPrefetchSlack(baseline, candidate.node, candidate.consumer,
                         candidate.chain, scheduled))
      return std::optional<ReadyScheduleSelectionKind>{};

    SmallVector<unsigned, 32> nextFirst = buildPrefetchProjectionOrder(
        baseline, candidate.chain, candidate.consumer,
        /*prefetchFirst=*/false, scheduled);
    FailureOr<ReadyScheduleProjectionFacts> nextFirstProjection =
        projectionProvider(nextFirst);
    if (failed(nextFirstProjection))
      return failure();
    SmallVector<unsigned, 32> prefetchFirst = buildPrefetchProjectionOrder(
        baseline, candidate.chain, candidate.consumer,
        /*prefetchFirst=*/true, scheduled);
    FailureOr<ReadyScheduleProjectionFacts> prefetchFirstProjection =
        projectionProvider(prefetchFirst);
    if (failed(prefetchFirstProjection))
      return failure();
    if (prefetchFirstProjection->cycles >= nextFirstProjection->cycles)
      return std::optional<ReadyScheduleSelectionKind>{};
    return std::optional<ReadyScheduleSelectionKind>(
        ReadyScheduleSelectionKind::VmemPrefetch);
  }

  bool fillsReservedStall(const ReadyScheduleStallFacts &stall,
                          const ReadyScheduleCandidateIssueFacts &issue) const {
    if (stall.kind == ReadyScheduleStallKind::None || !issue.realInstruction ||
        issue.stalls)
      return false;
    if (stall.kind == ReadyScheduleStallKind::Cycle &&
        issue.nextIssueCycle > stall.issueCycle)
      return false;
    int64_t reserveCycles =
        static_cast<int64_t>(issue.issues) *
        waveamdmachine::getEventSimIssuePeriod(*arch, config);
    return issue.nextIssueCycle + reserveCycles <= stall.issueCycle;
  }

  FailureOr<std::optional<unsigned>>
  findDmaPostBarrierFiller(const llvm::BitVector &scheduled, unsigned baseline,
                           const llvm::BitVector &legalReadyCandidates,
                           const ReadyScheduleStallFacts &stall,
                           ReadyScheduleIssueProvider issueProvider) const {
    if (!dmaIssueTiming ||
        !isa<waveamdmachine::DmaIssueDelayOp>(operations[baseline]))
      return std::optional<unsigned>{};
    unsigned barrier = findFirstUnscheduledBarrier(scheduled, baseline + 1);
    if (barrier == operations.size())
      return std::optional<unsigned>{};
    unsigned memory = findFirstUnscheduledMemory(scheduled, barrier + 1);
    if (memory == operations.size())
      return std::optional<unsigned>{};
    for (unsigned candidate :
         llvm::seq(memory + 1, static_cast<unsigned>(operations.size()))) {
      if (!isPostBarrierFillerCandidate(candidate, legalReadyCandidates,
                                        scheduled))
        continue;
      FailureOr<ReadyScheduleCandidateIssueFacts> issue =
          issueProvider(candidate);
      if (failed(issue))
        return failure();
      if (fillsReservedStall(stall, *issue))
        return std::optional<unsigned>(candidate);
    }
    return std::optional<unsigned>{};
  }

  FailureOr<SmallVector<ReadyScheduleProposal, 8>>
  buildGenericStallFillerProposals(
      const llvm::BitVector &scheduled, unsigned baseline,
      const llvm::BitVector &legalReadyCandidates,
      const ReadyScheduleStallFacts &stall,
      const waveamdmachine::InstructionScheduleModel &policy,
      ReadyScheduleIssueProvider issueProvider) const {
    SmallVector<ReadyScheduleProposal, 8> proposals;
    for (int ready = legalReadyCandidates.find_first(); ready >= 0;
         ready = legalReadyCandidates.find_next(ready)) {
      unsigned candidate = ready;
      if (candidate == baseline || scheduled.test(candidate) ||
          !isGenericStallFillerCompatible(scheduled, baseline, candidate, stall,
                                          policy))
        continue;
      FailureOr<ReadyScheduleCandidateIssueFacts> issue =
          issueProvider(candidate);
      if (failed(issue))
        return failure();
      ReadyScheduleProposal proposal{
          candidate, ReadyScheduleProposalKind::GenericStallFiller,
          /*group=*/0};
      proposal.filler = {stall, issue->nextIssueCycle, issue->realInstruction,
                         issue->stalls};
      proposals.push_back(proposal);
    }
    return proposals;
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

  waveamdmachine::MemoryIssueResourceMask
  getBlockedMemoryResources(unsigned baseline,
                            const ReadyScheduleIssueFacts &issue,
                            bool blockMemoryResource) const {
    if (!blockMemoryResource || issue.functionalUnitWaitCycles == 0)
      return 0;
    waveamdmachine::MemoryIssueResourceMask blocked =
        waveamdmachine::getMemoryIssueResources(operations[baseline]);
    if (blocked != 0 &&
        operations[baseline]->hasTrait<OpTrait::waveamdmachine::LDSDmaOp>())
      blocked |= waveamdmachine::getMemoryIssueResourceMask(
          waveamdmachine::MemoryIssueResource::Lds);
    return blocked;
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

  bool isComputeRecurrenceCandidate(const llvm::BitVector &scheduled,
                                    unsigned baseline,
                                    unsigned candidate) const {
    return computeRecurrenceCritical->test(candidate) &&
           isPureCompute(candidate) &&
           !crossesSplitBarrier(scheduled, baseline, candidate);
  }

  void
  assertValidReadySelection(const llvm::BitVector &scheduled, unsigned baseline,
                            const llvm::BitVector &legalReadyCandidates) const {
    assert(scheduled.size() == operations.size() &&
           legalReadyCandidates.size() == operations.size() &&
           baseline < operations.size() && "invalid ready selection");
  }

  void assertValidComputeResourceSelection(
      const llvm::BitVector &scheduled, unsigned baseline,
      const llvm::BitVector &legalReadyCandidates) const {
    assertValidReadySelection(scheduled, baseline, legalReadyCandidates);
    assert(computeRecurrenceCritical && "missing compute recurrence facts");
  }

  SmallVector<unsigned, 8> getLocalComputeResourceCandidates(
      const llvm::BitVector &scheduled, unsigned baseline,
      const llvm::BitVector &legalReadyCandidates) const {
    SmallVector<unsigned, 8> candidates;
    unsigned islandEnd = computeIslandEnds[baseline];
    for (int ready = legalReadyCandidates.find_next(baseline);
         ready >= 0 && static_cast<unsigned>(ready) < islandEnd;
         ready = legalReadyCandidates.find_next(ready)) {
      unsigned candidate = ready;
      if (!scheduled.test(candidate))
        candidates.push_back(candidate);
    }
    return candidates;
  }

  SmallVector<unsigned, 8> getRecurrenceComputeResourceCandidates(
      const llvm::BitVector &scheduled, unsigned baseline,
      const llvm::BitVector &legalReadyCandidates) const {
    SmallVector<unsigned, 8> candidates;
    for (int ready = legalReadyCandidates.find_next(baseline); ready >= 0;
         ready = legalReadyCandidates.find_next(ready)) {
      unsigned candidate = ready;
      if (!scheduled.test(candidate) &&
          isComputeRecurrenceCandidate(scheduled, baseline, candidate))
        candidates.push_back(candidate);
    }
    return candidates;
  }

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
    ReadyScheduleSelectionKind kind = ReadyScheduleSelectionKind::Proposal;
  };

  static ReadyScheduleSelectionKind
  getProposalSelectionKind(const ProposalWinner &winner) {
    return winner.kind;
  }

  static void setProposalWinner(
      unsigned candidate,
      const waveamdmachine::ReadyCandidateMetrics &candidateMetrics,
      uint64_t rank, ReadyScheduleSelectionKind kind, ProposalWinner &winner) {
    winner.metrics = candidateMetrics;
    winner.candidate = candidate;
    winner.rank = rank;
    winner.kind = kind;
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
    setProposalWinner(proposal.candidate, candidateMetrics, /*rank=*/0,
                      ReadyScheduleSelectionKind::Proposal, winner);
  }

  static void considerFillerProposal(
      const ReadyScheduleProposal &proposal,
      const waveamdmachine::ReadyCandidateMetrics &candidateMetrics,
      const waveamdmachine::ReadyCandidateMetrics &candidateFirst,
      const ReadyScheduleState &state,
      const waveamdmachine::ReadyCandidateMetrics &baselineMetrics,
      const waveamdmachine::InstructionScheduleModel &policy,
      ReadyScheduleSelectionKind kind, ProposalWinner &winner) {
    if (!policy.canSelectReadyFiller(state.pressure, candidateMetrics,
                                     candidateFirst, baselineMetrics))
      return;
    if (winner.metrics &&
        !policy.shouldPreferReadyFiller(state.pressure, candidateMetrics,
                                        *winner.metrics))
      return;
    setProposalWinner(proposal.candidate, candidateMetrics, /*rank=*/0, kind,
                      winner);
  }

  static void considerComputeResourceProposal(
      const ReadyScheduleProposal &proposal,
      waveamdmachine::ReadyResourceCandidateKind resourceKind,
      const waveamdmachine::ReadyCandidateMetrics &candidateMetrics,
      const waveamdmachine::ReadyCandidateMetrics &candidateFirst,
      const ReadyScheduleState &state,
      const waveamdmachine::ReadyCandidateMetrics &baselineMetrics,
      const waveamdmachine::InstructionScheduleModel &policy,
      ProposalWinner &winner) {
    if (resourceKind == waveamdmachine::ReadyResourceCandidateKind::Priority) {
      uint64_t rank = proposal.resource.candidate.releaseSlots;
      if (winner.candidate && rank <= winner.rank)
        return;
      if (!policy.canSelectReadyCandidate(state.pressure, candidateFirst,
                                          baselineMetrics))
        return;
      setProposalWinner(proposal.candidate, candidateMetrics, rank,
                        ReadyScheduleSelectionKind::ResourcePriority, winner);
      return;
    }
    assert(resourceKind ==
               waveamdmachine::ReadyResourceCandidateKind::StallFiller &&
           "invalid compute resource candidate");
    if (!policy.canSelectReadyFiller(state.pressure, candidateMetrics,
                                     candidateFirst, baselineMetrics))
      return;
    if (winner.metrics &&
        !policy.shouldPreferReadyFiller(state.pressure, candidateMetrics,
                                        *winner.metrics))
      return;
    setProposalWinner(proposal.candidate, candidateMetrics, /*rank=*/0,
                      ReadyScheduleSelectionKind::ResourceStallFiller, winner);
  }

  static void considerProposal(
      const ReadyScheduleProposal &proposal,
      waveamdmachine::ReadyResourceCandidateKind resourceKind,
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
    case ReadyScheduleProposalKind::RankedFiller:
      return considerFillerProposal(
          proposal, candidateMetrics, candidateFirst, state, baselineMetrics,
          policy, ReadyScheduleSelectionKind::Proposal, winner);
    case ReadyScheduleProposalKind::ComputeResource:
      return considerComputeResourceProposal(
          proposal, resourceKind, candidateMetrics, candidateFirst, state,
          baselineMetrics, policy, winner);
    case ReadyScheduleProposalKind::Latency:
      return considerFillerProposal(
          proposal, candidateMetrics, candidateFirst, state, baselineMetrics,
          policy, ReadyScheduleSelectionKind::LatencyPriority, winner);
    case ReadyScheduleProposalKind::GenericStallFiller:
      return considerFillerProposal(
          proposal, candidateMetrics, candidateFirst, state, baselineMetrics,
          policy, ReadyScheduleSelectionKind::GenericStallFiller, winner);
    }
    llvm_unreachable("unknown ready proposal kind");
  }

  static void
  assertConsistentResourceGroup(const ReadyScheduleProposal &groupInfo,
                                const ReadyScheduleProposal &proposal) {
    assert(sameResourcePreview(proposal.resource.baseline,
                               groupInfo.resource.baseline) &&
           proposal.resource.baselinePriorityStall ==
               groupInfo.resource.baselinePriorityStall &&
           proposal.resource.prioritize == groupInfo.resource.prioritize &&
           "resource group mixes baseline facts");
  }

  static void
  assertConsistentLatencyGroup(const ReadyScheduleProposal &groupInfo,
                               const ReadyScheduleProposal &proposal) {
    assert(proposal.latency.baselinePriorityStall ==
               groupInfo.latency.baselinePriorityStall &&
           "latency group mixes baseline facts");
  }

  static void
  assertConsistentStallFillerGroup(const ReadyScheduleProposal &groupInfo,
                                   const ReadyScheduleProposal &proposal) {
    assert(sameStallFacts(proposal.filler.stall, groupInfo.filler.stall) &&
           "stall filler group mixes baseline facts");
  }

  static void
  assertConsistentProposalGroup(const ReadyScheduleProposal &groupInfo,
                                const ReadyScheduleProposal &proposal) {
    assert(groupInfo.kind == proposal.kind &&
           "ready proposal group mixes selection policies");
    switch (proposal.kind) {
    case ReadyScheduleProposalKind::Direct:
    case ReadyScheduleProposalKind::RankedFiller:
      return;
    case ReadyScheduleProposalKind::ComputeResource:
      return assertConsistentResourceGroup(groupInfo, proposal);
    case ReadyScheduleProposalKind::Latency:
      return assertConsistentLatencyGroup(groupInfo, proposal);
    case ReadyScheduleProposalKind::GenericStallFiller:
      return assertConsistentStallFillerGroup(groupInfo, proposal);
    }
    llvm_unreachable("unknown ready proposal kind");
  }

  static waveamdmachine::ReadyResourceCandidateKind classifyResourceCandidate(
      const ReadyScheduleProposal &proposal,
      const waveamdmachine::InstructionScheduleModel &policy) {
    const ReadyScheduleResourceFacts &resource = proposal.resource;
    return policy.classifyReadyResourceCandidate(
        resource.baseline.functionalUnit, resource.baseline.waitSlots,
        resource.baseline.releaseSlots, resource.candidate.functionalUnit,
        resource.candidate.waitSlots, resource.candidate.releaseSlots,
        /*selectedReleaseSlots=*/0);
  }

  bool isLatencyCompatible(
      const llvm::BitVector &scheduled, unsigned baseline, unsigned candidate,
      const waveamdmachine::InstructionScheduleModel &policy) const {
    return !isBarrier(candidate) &&
           canUseStallFiller(scheduled, baseline, candidate) &&
           policy.shouldPrioritizeLatency(getLatency(candidate),
                                          getLatency(baseline));
  }

  bool isLatencyCandidate(
      const ReadyScheduleProposal &proposal, const llvm::BitVector &scheduled,
      unsigned baseline, unsigned candidate,
      const waveamdmachine::InstructionScheduleModel &policy) const {
    return !proposal.latency.candidatePriorityStall &&
           isLatencyCompatible(scheduled, baseline, candidate, policy);
  }

  bool isGenericStallFillerCompatible(
      const llvm::BitVector &scheduled, unsigned baseline, unsigned candidate,
      const ReadyScheduleStallFacts &stall,
      const waveamdmachine::InstructionScheduleModel &policy) const {
    Operation *candidateOp = operations[candidate];
    if (stall.kind == ReadyScheduleStallKind::None ||
        (isFullBarrier(baseline) && isFullBarrier(candidate)) ||
        !canUseStallFiller(scheduled, baseline, candidate) ||
        (stall.blockedMemoryResources &
         waveamdmachine::getMemoryIssueResources(candidateOp)) != 0)
      return false;
    waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(candidateOp);
    waveamdmachine::InstructionScheduleResourceInfo resource =
        waveamdmachine::getInstructionScheduleResourceInfo(
            candidateOp, cls, *arch, wavefrontSize);
    return policy.canFillStall(stall.reason, resource.functionalUnit,
                               resource.usesMfmaCoissue);
  }

  bool isGenericStallFillerCandidate(
      const ReadyScheduleProposal &proposal, const llvm::BitVector &scheduled,
      unsigned baseline, unsigned candidate,
      const waveamdmachine::InstructionScheduleModel &policy) const {
    const ReadyScheduleFillerFacts &filler = proposal.filler;
    if (!isGenericStallFillerCompatible(scheduled, baseline, candidate,
                                        filler.stall, policy) ||
        !filler.candidateRealInstruction || filler.candidateStalls)
      return false;
    return filler.stall.kind != ReadyScheduleStallKind::Cycle ||
           filler.candidateNextIssueCycle <= filler.stall.issueCycle;
  }

  struct ProposalCandidateClassification {
    waveamdmachine::ReadyResourceCandidateKind resourceKind =
        waveamdmachine::ReadyResourceCandidateKind::None;
    bool eligible = true;
  };

  static ProposalCandidateClassification classifyComputeResourceProposal(
      const ReadyScheduleProposal &proposal,
      const waveamdmachine::InstructionScheduleModel &policy) {
    waveamdmachine::ReadyResourceCandidateKind resourceKind =
        classifyResourceCandidate(proposal, policy);
    bool eligible =
        resourceKind != waveamdmachine::ReadyResourceCandidateKind::None &&
        !proposal.resource.candidatePriorityStall;
    return {resourceKind, eligible};
  }

  ProposalCandidateClassification classifyProposalCandidate(
      const ReadyScheduleProposal &proposal, const llvm::BitVector &scheduled,
      unsigned baseline, unsigned candidate,
      const waveamdmachine::InstructionScheduleModel &policy) const {
    switch (proposal.kind) {
    case ReadyScheduleProposalKind::Direct:
    case ReadyScheduleProposalKind::RankedFiller:
      return {};
    case ReadyScheduleProposalKind::ComputeResource:
      return classifyComputeResourceProposal(proposal, policy);
    case ReadyScheduleProposalKind::Latency:
      return {
          {},
          isLatencyCandidate(proposal, scheduled, baseline, candidate, policy)};
    case ReadyScheduleProposalKind::GenericStallFiller:
      return {{},
              isGenericStallFillerCandidate(proposal, scheduled, baseline,
                                            candidate, policy)};
    }
    llvm_unreachable("unknown ready proposal kind");
  }

  ProposalWinner selectProposalGroupCandidate(
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
      ProposalCandidateClassification classification =
          classifyProposalCandidate(proposal, scheduled, baseline, candidate,
                                    policy);
      if (!classification.eligible)
        continue;
      waveamdmachine::ReadyCandidateMetrics candidateMetrics =
          getCandidateMetrics(scheduled, candidate, state);
      std::pair<waveamdmachine::ReadyCandidateMetrics,
                waveamdmachine::ReadyCandidateMetrics>
          order = getOrderMetrics(scheduled, candidate, baseline, state);
      considerProposal(proposal, classification.resourceKind, candidateMetrics,
                       order.first, state, baselineMetrics, policy, winner);
    }
    return winner;
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

  bool shouldEvaluateLatencyGroup(const ReadyScheduleProposal &groupInfo,
                                  unsigned baseline) const {
    return isa_and_nonnull<waveamdmachine::UniformLoopOp>(
               operations[baseline]->getBlock()->getParentOp()) &&
           !groupInfo.latency.baselinePriorityStall && getLatency(baseline) > 0;
  }

  static bool shouldEvaluateComputeResourceGroup(
      const ReadyScheduleProposal &groupInfo, const ReadyScheduleState &state,
      const waveamdmachine::ReadyCandidateMetrics &baselineMetrics,
      const waveamdmachine::InstructionScheduleModel &policy) {
    const ReadyScheduleResourceFacts &resource = groupInfo.resource;
    if (resource.baselinePriorityStall || resource.baseline.releaseSlots == 0 ||
        (resource.baseline.waitSlots == 0 && !resource.prioritize))
      return false;
    if (resource.baseline.waitSlots == 0 || resource.prioritize)
      return true;
    return policy.shouldSelectResourceStallFiller(
        resource.baseline.waitSlots, resource.baseline.releaseSlots,
        state.pressure, baselineMetrics);
  }

  bool shouldEvaluateProposalGroup(
      const ReadyScheduleProposal &groupInfo, unsigned baseline,
      const ReadyScheduleState &state,
      const waveamdmachine::ReadyCandidateMetrics &baselineMetrics,
      const waveamdmachine::InstructionScheduleModel &policy) const {
    switch (groupInfo.kind) {
    case ReadyScheduleProposalKind::Direct:
    case ReadyScheduleProposalKind::RankedFiller:
    case ReadyScheduleProposalKind::GenericStallFiller:
      return true;
    case ReadyScheduleProposalKind::ComputeResource:
      return shouldEvaluateComputeResourceGroup(groupInfo, state,
                                                baselineMetrics, policy);
    case ReadyScheduleProposalKind::Latency:
      return shouldEvaluateLatencyGroup(groupInfo, baseline);
    }
    llvm_unreachable("unknown ready proposal kind");
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
  SmallVector<unsigned, 16> computeIslandEnds;
  waveamdmachine::EventSimConfig config;
  mutable std::optional<ReadyScheduleState> cachedState;
  mutable llvm::BitVector cachedScheduled;
  llvm::BitVector noInstructions;
  mutable ReadyScheduleWorkStats work;
  ArrayRef<Operation *> operations;
  ArrayRef<SmallVector<unsigned, 4>> predecessors;
  ArrayRef<SmallVector<unsigned, 4>> successors;
  ArrayRef<waveamdmachine::MemoryCounterKind> memoryKinds;
  ArrayRef<SmallVector<waveamdmachine::MemoryCounterKind, 4>> fillerMemoryKinds;
  ArrayRef<unsigned> memoryNodes;
  const llvm::DenseMap<Operation *, unsigned> *nodeIndices = nullptr;
  const llvm::BitVector *computeRecurrenceCritical = nullptr;
  const waveamdmachine::ArchData *arch = nullptr;
  waveamdmachine::ReadyRegisterPressureCeiling pressureCeiling;
  unsigned wavefrontSize = 64;
  bool dmaIssueTiming = false;
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

static void assertRegionScheduleFactSizes(
    ArrayRef<Operation *> operations,
    ArrayRef<SmallVector<unsigned, 4>> predecessors,
    ArrayRef<SmallVector<unsigned, 4>> successors,
    const llvm::BitVector &noInstructions,
    ArrayRef<waveamdmachine::MemoryCounterKind> memoryKinds,
    ArrayRef<SmallVector<waveamdmachine::MemoryCounterKind, 4>>
        fillerMemoryKinds,
    const llvm::BitVector &computeRecurrenceCritical) {
  assert(predecessors.size() == operations.size() &&
         successors.size() == operations.size() &&
         noInstructions.size() == operations.size() &&
         memoryKinds.size() == operations.size() &&
         fillerMemoryKinds.size() == operations.size() &&
         computeRecurrenceCritical.size() == operations.size() &&
         "region schedule facts have different sizes");
}

static void assertRegionMemoryNodes(ArrayRef<Operation *> operations,
                                    ArrayRef<unsigned> memoryNodes) {
  assert(
      llvm::is_sorted(memoryNodes) &&
      llvm::all_of(memoryNodes,
                   [&](unsigned node) { return node < operations.size(); }) &&
      "invalid region memory nodes");
}

static void assertSingleBlockRegion(ArrayRef<Operation *> operations) {
  if (operations.empty())
    return;
  Block *block = operations.front()->getBlock();
  assert(llvm::all_of(operations,
                      [&](Operation *op) { return op->getBlock() == block; }) &&
         "region schedule session crosses a block boundary");
}

RegionScheduleSession WaveAMDMachineScheduleModel::createRegionSession(
    const RegionScheduleGraphFacts &facts, llvm::BitVector noInstructions,
    const waveamdmachine::EventSimConfig &config) const {
  assertRegionScheduleFactSizes(facts.operations, facts.predecessors,
                                facts.successors, noInstructions,
                                facts.memoryKinds, facts.fillerMemoryKinds,
                                facts.computeRecurrenceCritical);
  assertRegionMemoryNodes(facts.operations, facts.memoryNodes);
  assert(config.wavefrontSize == impl->wavefrontSize &&
         "region schedule config uses another wavefront size");
  assertSingleBlockRegion(facts.operations);
  auto region =
      std::make_unique<RegionScheduleSession::Impl>(impl->wavefrontSize);
  region->operations = facts.operations;
  region->predecessors = facts.predecessors;
  region->successors = facts.successors;
  region->noInstructions = std::move(noInstructions);
  region->memoryKinds = facts.memoryKinds;
  region->fillerMemoryKinds = facts.fillerMemoryKinds;
  region->memoryNodes = facts.memoryNodes;
  region->nodeIndices = &facts.nodeIndices;
  region->computeRecurrenceCritical = &facts.computeRecurrenceCritical;
  region->config = config;
  region->arch = impl->arch;
  region->wavefrontSize = impl->wavefrontSize;
  if (!facts.operations.empty()) {
    Block *block = facts.operations.front()->getBlock();
    region->dmaIssueTiming =
        isa_and_nonnull<waveamdmachine::UniformLoopOp>(block->getParentOp()) &&
        llvm::any_of(block->without_terminator(), [](Operation &op) {
          return isa<waveamdmachine::DmaIssueDelayOp>(op);
        });
  }
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
      return {*pressureWinner, /*suppressFallback=*/false,
              ReadyScheduleSelectionKind::Pressure};
    }
    ++impl->work.pressureRejections;
  }

  bool rejectedProposalWinner = false;
  for (unsigned group : Impl::getProposalGroups(proposals)) {
    const ReadyScheduleProposal &groupInfo =
        Impl::getProposalGroupInfo(group, proposals);
    if (!impl->shouldEvaluateProposalGroup(groupInfo, baseline, state,
                                           baselineMetrics, policy))
      continue;
    Impl::ProposalWinner winner = impl->selectProposalGroupCandidate(
        group, groupInfo, scheduled, baseline, state, baselineMetrics,
        proposals, policy);
    if (!winner.candidate)
      continue;
    if (impl->hasSafeFullPrefix(scheduled, *winner.candidate, baseline, state,
                                policy)) {
      ++impl->work.proposalSelections;
      return {*winner.candidate, /*suppressFallback=*/false,
              Impl::getProposalSelectionKind(winner)};
    }
    ++impl->work.proposalRejections;
    rejectedProposalWinner = true;
  }
  return {std::nullopt, /*suppressFallback=*/rejectedProposalWinner,
          ReadyScheduleSelectionKind::Baseline};
}

static ReadyScheduleDecision
selectRankedFiller(const RegionScheduleSession &session,
                   const llvm::BitVector &scheduled, unsigned baseline,
                   unsigned candidate, ReadyScheduleSelectionKind kind,
                   const waveamdmachine::InstructionScheduleModel &policy) {
  llvm::BitVector noDiscoveries(scheduled.size());
  ReadyScheduleProposal proposal{candidate,
                                 ReadyScheduleProposalKind::RankedFiller,
                                 /*group=*/0};
  ReadyScheduleDecision decision =
      session.selectNext(scheduled, baseline, noDiscoveries, proposal, policy);
  if (decision.candidate)
    decision.kind = kind;
  return decision;
}

static FailureOr<ReadyScheduleDecision> selectComputeResourceGroup(
    const RegionScheduleSession &session, const llvm::BitVector &scheduled,
    unsigned baseline, ArrayRef<unsigned> candidates,
    const waveamdmachine::InstructionScheduleModel &policy,
    ReadyScheduleResourceFactsProvider getResourceFacts) {
  SmallVector<ReadyScheduleProposal, 8> proposals;
  for (unsigned candidate : candidates) {
    FailureOr<ReadyScheduleResourceFacts> facts = getResourceFacts(candidate);
    if (failed(facts))
      return failure();
    ReadyScheduleProposal proposal{
        candidate, ReadyScheduleProposalKind::ComputeResource, /*group=*/0};
    proposal.resource = *facts;
    proposals.push_back(proposal);
  }
  llvm::BitVector noDiscoveries(scheduled.size());
  return session.selectNext(scheduled, baseline, noDiscoveries, proposals,
                            policy);
}

FailureOr<ReadyScheduleDecision> RegionScheduleSession::selectComputeResource(
    const llvm::BitVector &scheduled, unsigned baseline,
    const llvm::BitVector &legalReadyCandidates,
    const waveamdmachine::InstructionScheduleModel &policy,
    ReadyScheduleResourceFactsProvider getResourceFacts) const {
  impl->assertValidComputeResourceSelection(scheduled, baseline,
                                            legalReadyCandidates);
  if (!impl->isPureCompute(baseline))
    return ReadyScheduleDecision{};
  SmallVector<unsigned, 8> localCandidates =
      impl->getLocalComputeResourceCandidates(scheduled, baseline,
                                              legalReadyCandidates);
  if (!localCandidates.empty()) {
    FailureOr<ReadyScheduleDecision> local = selectComputeResourceGroup(
        *this, scheduled, baseline, localCandidates, policy, getResourceFacts);
    if (failed(local) || local->candidate || local->suppressFallback)
      return local;
  }
  SmallVector<unsigned, 8> recurrenceCandidates =
      impl->getRecurrenceComputeResourceCandidates(scheduled, baseline,
                                                   legalReadyCandidates);
  if (recurrenceCandidates.empty())
    return ReadyScheduleDecision{};
  return selectComputeResourceGroup(*this, scheduled, baseline,
                                    recurrenceCandidates, policy,
                                    getResourceFacts);
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
    if (candidate != baseline && !scheduled.test(candidate) &&
        impl->isLatencyCompatible(scheduled, baseline, candidate, policy))
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
  impl->assertValidReadySelection(scheduled, baseline, legalReadyCandidates);
  FailureOr<std::optional<unsigned>> token = impl->findMemoryTokenConsumer(
      scheduled, baseline, legalReadyCandidates, policy, projectionProvider);
  if (failed(token))
    return failure();
  if (*token) {
    ReadyScheduleDecision decision = selectRankedFiller(
        *this, scheduled, baseline, **token,
        ReadyScheduleSelectionKind::MemoryTokenConsumer, policy);
    if (decision.candidate)
      return decision;
  }

  unsigned barrierFiller =
      impl->findBarrierPairFiller(legalReadyCandidates, scheduled, baseline);
  if (barrierFiller != impl->operations.size()) {
    ReadyScheduleDecision decision = selectRankedFiller(
        *this, scheduled, baseline, barrierFiller,
        ReadyScheduleSelectionKind::BarrierPairFiller, policy);
    if (decision.candidate)
      return decision;
  }

  FailureOr<std::optional<Impl::VmemPrefetchCandidate>> prefetch =
      impl->buildVmemPrefetchCandidate(scheduled, baseline,
                                       legalReadyCandidates, issueProvider);
  if (failed(prefetch))
    return failure();
  if (!*prefetch)
    return ReadyScheduleDecision{};
  FailureOr<std::optional<ReadyScheduleSelectionKind>> kind =
      impl->classifyVmemPrefetch(**prefetch, scheduled, baseline,
                                 prioritizeLongLatencyVmem, policy,
                                 projectionProvider);
  if (failed(kind))
    return failure();
  if (!*kind)
    return ReadyScheduleDecision{};
  return selectRankedFiller(*this, scheduled, baseline, (**prefetch).head,
                            **kind, policy);
}

FailureOr<ReadyScheduleDecision> RegionScheduleSession::selectStallFiller(
    const llvm::BitVector &scheduled, unsigned baseline,
    const llvm::BitVector &legalReadyCandidates,
    const ReadyScheduleStallFacts &stall,
    const waveamdmachine::InstructionScheduleModel &policy,
    ReadyScheduleIssueProvider issueProvider) const {
  impl->assertValidReadySelection(scheduled, baseline, legalReadyCandidates);
  FailureOr<std::optional<unsigned>> dma = impl->findDmaPostBarrierFiller(
      scheduled, baseline, legalReadyCandidates, stall, issueProvider);
  if (failed(dma))
    return failure();
  if (*dma) {
    ReadyScheduleDecision decision = selectRankedFiller(
        *this, scheduled, baseline, **dma,
        ReadyScheduleSelectionKind::DmaPostBarrierFiller, policy);
    if (decision.candidate)
      return decision;
  }

  FailureOr<SmallVector<ReadyScheduleProposal, 8>> proposals =
      impl->buildGenericStallFillerProposals(scheduled, baseline,
                                             legalReadyCandidates, stall,
                                             policy, issueProvider);
  if (failed(proposals))
    return failure();
  llvm::BitVector noDiscoveries(impl->operations.size());
  return selectNext(scheduled, baseline, noDiscoveries, *proposals, policy);
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

static bool hasReadyScheduleCycleWait(const ReadyScheduleIssueFacts &issue) {
  return issue.operandWaitCycles != 0 || issue.functionalUnitWaitCycles != 0 ||
         issue.issueWaitCycles != 0 || issue.cuIssueWaitCycles != 0 ||
         issue.cmaIssueWaitCycles != 0;
}

ReadyScheduleStallFacts
RegionScheduleSession::classifyStall(unsigned baseline,
                                     const ReadyScheduleIssueFacts &issue,
                                     bool blockMemoryResource) const {
  assert(baseline < impl->operations.size() && "invalid stall baseline");
  ReadyScheduleStallFacts stall;
  if (issue.memoryWaitCycles != 0)
    stall.kind = ReadyScheduleStallKind::MemoryToken;
  else if (issue.coexecWindowWaitCycles != 0) {
    stall.reason = waveamdmachine::InstructionStallKind::CoexecWindow;
    stall.kind = ReadyScheduleStallKind::Cycle;
  } else if (hasReadyScheduleCycleWait(issue)) {
    stall.blockedMemoryResources =
        impl->getBlockedMemoryResources(baseline, issue, blockMemoryResource);
    stall.kind = ReadyScheduleStallKind::Cycle;
  } else if (issue.hazardWaitInstructions != 0)
    stall.kind = ReadyScheduleStallKind::InstructionHazard;
  if (stall.kind != ReadyScheduleStallKind::None)
    stall.issueCycle = issue.issueCycle;
  return stall;
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
