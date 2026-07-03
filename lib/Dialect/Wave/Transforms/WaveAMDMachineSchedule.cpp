//===- WaveAMDMachineSchedule.cpp - WaveAMDMachine scheduler ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// Scheduler design:
// - Split funcs into straight-line local regions. Control flow, waitcnt,
//   barriers, priority changes, nested regions, and unknown effects bound them.
// - Legal motion follows SSA and explicit mem-token edges. Memory ops without
//   a token edge are independent for this pass.
// - Candidate orders are deterministic permutations of one region. Loop-carried
//   recurrence edges are diagnostics, not intra-iteration ordering constraints.
// - Cost policy ranks legal candidates. Hard register caps gate candidates;
//   explicit multi-wave targets add occupancy pressure ranking.

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "RegAlloc/WaveAMDRegAllocPrep.h"
#include "WaveAMDHardwareResources.h"
#include "WaveAMDMachineScheduleInternal.h"
#include "WaveAMDMachineScheduleSupport.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"

#include <algorithm>
#include <array>
#include <limits>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMACHINESCHEDULE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

static bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         waveamdmachine::WaveAMDMachineDialect::getDialectNamespace();
}

static bool isKnownMemoryOp(Operation *op) {
  if (auto info = dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo().isIssuer();
  return false;
}

static bool hasUnknownMemoryEffects(Operation *op) {
  if (isKnownMemoryOp(op))
    return false;
  MemoryEffectOpInterface iface = dyn_cast<MemoryEffectOpInterface>(op);
  if (!iface)
    return false;
  SmallVector<MemoryEffects::EffectInstance> effects;
  iface.getEffects(effects);
  return !effects.empty();
}

static bool isBarrierPipelineHardBoundary(Operation *op) {
  if (!isWaveAMDMachineOp(op))
    return true;
  if (op->hasTrait<OpTrait::IsTerminator>())
    return true;
  if (op->getNumRegions() != 0)
    return true;
  if (op->hasTrait<traits::WaitcntOp>())
    return true;
  if (op->hasTrait<traits::WritesExecOp>())
    return true;
  if (isa<waveamdmachine::LabelOp, waveamdmachine::SBarrierOp,
          waveamdmachine::SSetprioOp, waveamdmachine::SCBranchExeczOp,
          waveamdmachine::SCBranchScc0Op, waveamdmachine::SCBranchScc1Op,
          waveamdmachine::SGetregShaderCyclesOp, waveamdmachine::SNopOp,
          waveamdmachine::WaitOp, waveamdmachine::SDelayAluOp,
          waveamdmachine::SAndSaveexecB32Op, waveamdmachine::SAndn2ExecB32Op,
          waveamdmachine::SAndSaveexecB64Op, waveamdmachine::SAndn2ExecB64Op,
          waveamdmachine::SMovExecLoOp, waveamdmachine::SMovExecB64Op,
          waveamdmachine::SEndpgmOp, waveamdmachine::SSetpcB64Op>(op))
    return true;
  return hasUnknownMemoryEffects(op);
}

static bool isInsideExecIf(Operation *op) {
  for (Operation *parent = op->getParentOp(); parent;
       parent = parent->getParentOp())
    if (isa<waveamdmachine::ExecIfOp>(parent))
      return true;
  return false;
}

enum BarrierPipelineClass : unsigned {
  BPCNone = 0,
  BPCMFMA = 1u << 0,
  BPCDSRead = 1u << 1,
  BPCDSWrite = 1u << 2,
  BPCLdsDma = 1u << 3,
  BPCLdsDmaProducer = 1u << 4,
  BPCVMemRead = 1u << 5,
  BPCVMemWrite = 1u << 6,
  BPCSMem = 1u << 7,
  BPCSALU = 1u << 8,
  BPCVALU = 1u << 9,
  BPCBarrier = 1u << 10,
};

struct BarrierPipelineWindow {
  ScheduleRegion region;
};

struct BarrierPipelineStage {
  unsigned mask = BPCNone;
  unsigned maxMatches = 0;
};

struct BarrierPipelineDescriptor {
  SmallVector<BarrierPipelineStage, 16> stages;
  StringRef name;
  bool preserveDsReadWriterOrder = false;
};

static bool hasPipelineClass(unsigned classes, unsigned mask) {
  return (classes & mask) != 0;
}

static unsigned classifyComputePipelineOp(Operation *op) {
  unsigned classes = BPCNone;
  if (op->hasTrait<traits::MFMAOp>())
    classes |= BPCMFMA;
  if (op->hasTrait<traits::SALUOp>())
    classes |= BPCSALU;
  if (op->hasTrait<traits::VALUOp>() && !op->hasTrait<traits::MFMAOp>() &&
      !isKnownMemoryOp(op))
    classes |= BPCVALU;
  return classes;
}

static unsigned classifyMemoryPipelineOp(Operation *op,
                                         const NodeMetrics &metrics) {
  unsigned classes = BPCNone;
  if (op->hasTrait<traits::LDSLoadOp>())
    classes |= BPCDSRead;
  if (op->hasTrait<traits::LDSStoreOp>())
    classes |= BPCDSWrite;
  if (waveamdmachine::isLdsDmaIssuer(op))
    classes |= BPCLdsDma;
  if (metrics.reachesLdsDma || metrics.ldsDma)
    classes |= BPCLdsDmaProducer;
  if (op->hasTrait<traits::VMEMLoadOp>())
    classes |= BPCVMemRead;
  if (op->hasTrait<traits::VMEMStoreOp>())
    classes |= BPCVMemWrite;
  if (op->hasTrait<traits::SMEMLoadOp>())
    classes |= BPCSMem;
  return classes;
}

static unsigned classifyBarrierPipelineOp(Operation *op,
                                          const NodeMetrics &metrics) {
  if (isa<waveamdmachine::SBarrierOp>(op))
    return BPCBarrier;
  return classifyComputePipelineOp(op) | classifyMemoryPipelineOp(op, metrics);
}

static bool isMemoryPipelineClass(unsigned classes) {
  static constexpr unsigned memoryMask =
      BPCDSRead | BPCDSWrite | BPCLdsDma | BPCVMemRead | BPCVMemWrite | BPCSMem;
  return hasPipelineClass(classes, memoryMask);
}

static bool hasResource(ArrayRef<wave::HardwareResourceKind> resources,
                        wave::HardwareResourceKind resource) {
  return llvm::is_contained(resources, resource);
}

static bool resourceEffectsConflict(Operation *candidate, Operation *crossed) {
  wave::HardwareResourceEffects candidateEffects =
      wave::getHardwareResourceEffects(candidate);
  wave::HardwareResourceEffects crossedEffects =
      wave::getHardwareResourceEffects(crossed);
  for (wave::HardwareResourceKind resource : candidateEffects.reads)
    if (hasResource(crossedEffects.writes, resource))
      return true;
  for (wave::HardwareResourceKind resource : candidateEffects.writes)
    if (hasResource(crossedEffects.reads, resource) ||
        hasResource(crossedEffects.writes, resource))
      return true;
  return false;
}

static bool hasMemTokenOperandOrResult(Operation *op) {
  for (Value operand : op->getOperands())
    if (isa<waveamdmachine::MemTokenType>(operand.getType()))
      return true;
  for (Value result : op->getResults())
    if (isa<waveamdmachine::MemTokenType>(result.getType()))
      return true;
  return false;
}

static bool collectBarrierPipelineWindow(func::FuncOp func,
                                         waveamdmachine::SBarrierOp barrier,
                                         ScheduleSearchLimits limits,
                                         BarrierPipelineWindow &window) {
  if (isInsideExecIf(barrier))
    return false;

  SmallVector<Operation *, 16> left;
  for (Operation *op = barrier->getPrevNode();
       op && !isBarrierPipelineHardBoundary(op); op = op->getPrevNode())
    left.push_back(op);
  std::reverse(left.begin(), left.end());

  SmallVector<Operation *, 16> right;
  for (Operation *op = barrier->getNextNode();
       op && !isBarrierPipelineHardBoundary(op); op = op->getNextNode())
    right.push_back(op);

  if (right.empty())
    return false;

  ScheduleRegion region;
  region.func = func;
  region.first = left.empty() ? barrier.getOperation() : left.front();
  region.last = right.back();
  region.opCount = static_cast<unsigned>(left.size() + 1 + right.size());
  region.ops.append(left.begin(), left.end());
  region.ops.push_back(barrier);
  region.ops.append(right.begin(), right.end());
  window.region = std::move(region);
  return !exceedsScheduleRegionLimit(window.region, limits);
}

static bool isBarrierPipelineComputeOp(Operation *op) {
  return isWaveAMDMachineOp(op) && op->hasTrait<traits::MFMAOp>() &&
         op->getNumRegions() == 0 && !op->hasTrait<traits::WritesExecOp>() &&
         !hasUnknownMemoryEffects(op);
}

static bool isPotentialLdsDmaProducer(Operation *op) {
  if (isBarrierPipelineHardBoundary(op))
    return false;
  if (op->hasTrait<traits::ReadsExecOp>())
    return false;
  if (op->hasTrait<traits::MFMAOp>())
    return false;
  if (waveamdmachine::isLdsDmaIssuer(op))
    return true;
  if (isKnownMemoryOp(op))
    return false;
  return !hasUnknownMemoryEffects(op);
}

static bool allClusterOpsReachLdsDma(const ScheduleRegion &region,
                                     unsigned clusterBegin,
                                     unsigned clusterEnd) {
  llvm::SmallPtrSet<Operation *, 16> clusterSet;
  for (unsigned index = clusterBegin; index <= clusterEnd; ++index)
    clusterSet.insert(region.ops[index]);

  llvm::SmallPtrSet<Operation *, 16> needed;
  SmallVector<Operation *, 16> worklist;
  for (unsigned index = clusterBegin; index <= clusterEnd; ++index) {
    Operation *op = region.ops[index];
    if (!waveamdmachine::isLdsDmaIssuer(op))
      continue;
    needed.insert(op);
    worklist.push_back(op);
  }

  while (!worklist.empty()) {
    Operation *op = worklist.pop_back_val();
    for (Value operand : op->getOperands()) {
      Operation *def = operand.getDefiningOp();
      if (!def || !clusterSet.contains(def))
        continue;
      if (needed.insert(def).second)
        worklist.push_back(def);
    }
  }

  return needed.size() == clusterSet.size();
}

static bool isWaitBarrierHoistCandidate(Operation *op) {
  if (waveamdmachine::isLdsDmaIssuer(op))
    return false;
  if (!isPotentialLdsDmaProducer(op))
    return false;
  return !hasMemTokenOperandOrResult(op);
}

static bool operandsAvailableBefore(Operation *op, Operation *insertBefore) {
  for (Value operand : op->getOperands()) {
    Operation *def = operand.getDefiningOp();
    if (!def || def->getBlock() != op->getBlock())
      continue;
    if (!def->isBeforeInBlock(insertBefore))
      return false;
  }
  return true;
}

static bool canMoveBefore(Operation *op, Operation *insertBefore) {
  if (op->getBlock() != insertBefore->getBlock())
    return false;
  if (!insertBefore->isBeforeInBlock(op))
    return false;
  for (Operation *crossed = insertBefore; crossed != op;
       crossed = crossed->getNextNode()) {
    if (resourceEffectsConflict(op, crossed))
      return false;
  }
  return true;
}

static bool
collectLeadingLdsDmaProducerPrefix(waveamdmachine::SBarrierOp barrier,
                                   SmallVectorImpl<Operation *> &prefix,
                                   Operation *&ldsDma) {
  ldsDma = nullptr;
  for (Operation *op = barrier->getNextNode();
       op && !isBarrierPipelineHardBoundary(op); op = op->getNextNode()) {
    if (waveamdmachine::isLdsDmaIssuer(op)) {
      ldsDma = op;
      return !prefix.empty();
    }
    if (!isWaitBarrierHoistCandidate(op))
      return false;
    prefix.push_back(op);
  }
  return false;
}

static void
collectProducerSlice(Operation *op,
                     const llvm::SmallPtrSetImpl<Operation *> &scope,
                     llvm::SmallPtrSetImpl<Operation *> &needed) {
  for (Value operand : op->getOperands()) {
    Operation *def = operand.getDefiningOp();
    if (!def || !scope.contains(def))
      continue;
    if (!needed.insert(def).second)
      continue;
    collectProducerSlice(def, scope, needed);
  }
}

static bool tryWaitBarrierLdsDmaPrefixHoist(waveamdmachine::SBarrierOp barrier,
                                            ScheduleSearchLimits limits) {
  auto wait = dyn_cast_or_null<waveamdmachine::WaitOp>(barrier->getPrevNode());
  if (!wait)
    return false;

  SmallVector<Operation *, 16> prefix;
  Operation *ldsDma = nullptr;
  if (!collectLeadingLdsDmaProducerPrefix(barrier, prefix, ldsDma))
    return false;
  unsigned windowOps = static_cast<unsigned>(prefix.size() + 3);
  if (limits.maxRegionOps >= 0 &&
      windowOps > static_cast<unsigned>(limits.maxRegionOps))
    return false;

  llvm::SmallPtrSet<Operation *, 16> prefixSet;
  for (Operation *op : prefix)
    prefixSet.insert(op);
  llvm::SmallPtrSet<Operation *, 16> needed;
  collectProducerSlice(ldsDma, prefixSet, needed);

  bool changed = false;
  for (Operation *op : prefix) {
    if (!needed.contains(op))
      continue;
    if (!operandsAvailableBefore(op, wait))
      continue;
    if (!canMoveBefore(op, wait))
      continue;
    op->moveBefore(wait);
    changed = true;
  }
  return changed;
}

struct LdsDmaAnchorWindow {
  unsigned computeBegin = 0;
  unsigned barrier = 0;
  unsigned clusterEnd = 0;
};

static std::optional<unsigned>
findSingleBarrierClass(ArrayRef<unsigned> classes) {
  std::optional<unsigned> barrier;
  for (auto [node, cls] : llvm::enumerate(classes)) {
    if (!hasPipelineClass(cls, BPCBarrier))
      continue;
    if (barrier)
      return std::nullopt;
    barrier = static_cast<unsigned>(node);
  }
  return barrier;
}

static unsigned findComputeSuffixBegin(const ScheduleRegion &region,
                                       unsigned barrier) {
  unsigned computeBegin = barrier;
  while (computeBegin > 0 &&
         isBarrierPipelineComputeOp(region.ops[computeBegin - 1]))
    --computeBegin;
  return computeBegin;
}

static std::optional<unsigned>
findLdsDmaProducerClusterEnd(const ScheduleRegion &region, unsigned barrier) {
  std::optional<unsigned> clusterEnd;
  for (unsigned index = barrier + 1; index < region.ops.size(); ++index) {
    Operation *op = region.ops[index];
    if (!isPotentialLdsDmaProducer(op))
      break;
    if (waveamdmachine::isLdsDmaIssuer(op))
      clusterEnd = index;
  }
  return clusterEnd;
}

static std::optional<LdsDmaAnchorWindow>
findLdsDmaAnchorWindow(const ScheduleRegion &region,
                       ArrayRef<unsigned> classes) {
  std::optional<unsigned> barrier = findSingleBarrierClass(classes);
  if (!barrier || *barrier == 0 || *barrier + 1 >= region.ops.size())
    return std::nullopt;

  unsigned computeBegin = findComputeSuffixBegin(region, *barrier);
  if (computeBegin == *barrier)
    return std::nullopt;

  std::optional<unsigned> clusterEnd =
      findLdsDmaProducerClusterEnd(region, *barrier);
  if (!clusterEnd)
    return std::nullopt;
  if (!allClusterOpsReachLdsDma(region, *barrier + 1, *clusterEnd))
    return std::nullopt;
  return LdsDmaAnchorWindow{computeBegin, *barrier, *clusterEnd};
}

static unsigned getCounterMask(waveamdmachine::MemoryCounterKind kind) {
  switch (kind) {
  case waveamdmachine::MemoryCounterKind::None:
    return 0;
  case waveamdmachine::MemoryCounterKind::Vmem:
    return 1u << 0;
  case waveamdmachine::MemoryCounterKind::Lgkm:
    return 1u << 1;
  case waveamdmachine::MemoryCounterKind::Vscnt:
    return 1u << 2;
  }
  llvm_unreachable("unknown memory counter kind");
}

static bool isCounterMaskPassthrough(Operation *op) {
  return op->hasTrait<traits::TupleAliasOp>() ||
         isa<waveamdmachine::CopyTupleOp>(op) ||
         op->hasTrait<traits::TokenJoinOp>();
}

static unsigned getValueCounterMask(Value value,
                                    llvm::SmallPtrSetImpl<Operation *> &seen) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return 0;
  if (!seen.insert(def).second)
    return 0;

  unsigned mask = getCounterMask(waveamdmachine::getMemoryCounterKind(def));
  if (mask != 0)
    return mask;

  if (isCounterMaskPassthrough(def)) {
    for (Value operand : def->getOperands())
      mask |= getValueCounterMask(operand, seen);
  }
  return mask;
}

static unsigned getValueCounterMask(Value value) {
  llvm::SmallPtrSet<Operation *, 8> seen;
  return getValueCounterMask(value, seen);
}

static llvm::DenseMap<Value, unsigned>
getLoopCarryCounterMasks(waveamdmachine::UniformLoopOp loop) {
  llvm::DenseMap<Value, unsigned> masks;
  waveamdmachine::ContinueIfOp terminator = cast<waveamdmachine::ContinueIfOp>(
      loop.getBody().front().getTerminator());
  for (auto [arg, carry] : llvm::zip_equal(
           loop.getBody().front().getArguments(), terminator.getCarries())) {
    unsigned mask = getValueCounterMask(carry);
    if (mask != 0)
      masks[arg] = mask;
  }
  return masks;
}

static unsigned
getLoopCarriedCounterMask(Value value,
                          const llvm::DenseMap<Value, unsigned> &carryMasks,
                          llvm::SmallPtrSetImpl<Operation *> &seen) {
  if (BlockArgument arg = dyn_cast<BlockArgument>(value))
    return carryMasks.lookup(arg);

  Operation *def = value.getDefiningOp();
  if (!def || !seen.insert(def).second)
    return 0;

  unsigned mask = 0;
  if (isCounterMaskPassthrough(def)) {
    for (Value operand : def->getOperands())
      mask |= getLoopCarriedCounterMask(operand, carryMasks, seen);
  }
  return mask;
}

static unsigned
getLoopCarriedCounterMask(Value value,
                          const llvm::DenseMap<Value, unsigned> &carryMasks) {
  llvm::SmallPtrSet<Operation *, 8> seen;
  return getLoopCarriedCounterMask(value, carryMasks, seen);
}

static unsigned
getLoopCarriedValueUseMask(Operation *op,
                           const llvm::DenseMap<Value, unsigned> &carryMasks) {
  if (isa<waveamdmachine::SBarrierOp>(op))
    return 0;

  unsigned mask = 0;
  for (Value operand : op->getOperands()) {
    if (isa<waveamdmachine::MemTokenType>(operand.getType()))
      continue;
    mask |= getLoopCarriedCounterMask(operand, carryMasks);
  }
  return mask;
}

static unsigned getLoopCarriedBarrierTokenMask(
    Operation *op, const llvm::DenseMap<Value, unsigned> &carryMasks) {
  if (!isa<waveamdmachine::SBarrierOp>(op))
    return 0;

  unsigned mask = 0;
  for (Value operand : op->getOperands()) {
    if (!isa<waveamdmachine::MemTokenType>(operand.getType()))
      continue;
    mask |= getLoopCarriedCounterMask(operand, carryMasks);
  }
  return mask;
}

static bool drainsLoopCarriedCounterBeforeValueUse(
    const ScheduleRegion &region, ArrayRef<unsigned> order,
    const llvm::DenseMap<Value, unsigned> &carryMasks) {
  SmallVector<unsigned, 16> suffixUseMasks(order.size() + 1, 0);
  for (int64_t i = static_cast<int64_t>(order.size()) - 1; i >= 0; --i) {
    Operation *op = region.ops[order[i]];
    suffixUseMasks[i] =
        suffixUseMasks[i + 1] | getLoopCarriedValueUseMask(op, carryMasks);
  }

  for (auto [ordinal, node] : llvm::enumerate(order)) {
    Operation *op = region.ops[node];
    unsigned barrierMask = getLoopCarriedBarrierTokenMask(op, carryMasks);
    if ((barrierMask & suffixUseMasks[ordinal + 1]) != 0)
      return true;
  }
  return false;
}

static void dropLoopCarriedCounterDrainCandidates(
    const ScheduleRegion &region, SmallVectorImpl<OrderCandidate> &candidates) {
  waveamdmachine::UniformLoopOp loop =
      region.first->getParentOfType<waveamdmachine::UniformLoopOp>();
  if (!loop || candidates.size() <= 1)
    return;

  llvm::DenseMap<Value, unsigned> carryMasks = getLoopCarryCounterMasks(loop);
  if (carryMasks.empty())
    return;

  candidates.erase(
      llvm::remove_if(llvm::drop_begin(candidates),
                      [&](OrderCandidate &c) {
                        return drainsLoopCarriedCounterBeforeValueUse(
                            region, c.order, carryMasks);
                      }),
      candidates.end());
}

static SmallVector<unsigned, 16> getIdentityOrder(unsigned size) {
  SmallVector<unsigned, 16> order;
  order.reserve(size);
  for (unsigned index = 0; index < size; ++index)
    order.push_back(index);
  return order;
}

static unsigned countClass(ArrayRef<unsigned> classes, unsigned mask) {
  return llvm::count_if(
      classes, [mask](unsigned cls) { return hasPipelineClass(cls, mask); });
}

static unsigned maxClassLatency(ArrayRef<unsigned> classes,
                                ArrayRef<NodeMetrics> metrics, unsigned mask) {
  int latency = 0;
  for (auto [index, cls] : llvm::enumerate(classes))
    if (hasPipelineClass(cls, mask))
      latency = std::max(latency, metrics[index].latency);
  return static_cast<unsigned>(latency);
}

static unsigned computeDsReadSeed(ArrayRef<unsigned> classes,
                                  ArrayRef<NodeMetrics> metrics,
                                  const waveamdmachine::ArchData &arch) {
  unsigned dsReads = countClass(classes, BPCDSRead);
  if (dsReads == 0)
    return 0;
  unsigned seed = std::max(waveamdmachine::getEventSimCmaIssueCapacity(arch),
                           maxClassLatency(classes, metrics, BPCDSRead));
  return std::min(dsReads, seed);
}

static unsigned computeMfmaChunk(unsigned mfmaCount, unsigned memoryCount) {
  if (mfmaCount == 0)
    return 0;
  if (memoryCount == 0)
    return mfmaCount;
  return std::max(1u, mfmaCount / (memoryCount + 1));
}

static void appendStage(SmallVectorImpl<BarrierPipelineStage> &stages,
                        unsigned mask, unsigned maxMatches) {
  if (maxMatches == 0)
    return;
  stages.push_back({mask, maxMatches});
}

static void appendMfmaMemoryDescriptor(
    SmallVectorImpl<BarrierPipelineDescriptor> &descriptors, StringRef name,
    unsigned memoryMask, unsigned mfmaLead, unsigned memoryCount,
    unsigned mfmaCount) {
  BarrierPipelineDescriptor descriptor;
  descriptor.name = name;
  appendStage(descriptor.stages, BPCBarrier, 1);
  appendStage(descriptor.stages, BPCMFMA, mfmaLead);
  appendStage(descriptor.stages, memoryMask, memoryCount);
  appendStage(descriptor.stages, BPCMFMA, mfmaCount);
  descriptors.push_back(std::move(descriptor));
}

static void
appendDmaDescriptors(SmallVectorImpl<BarrierPipelineDescriptor> &descriptors,
                     ArrayRef<unsigned> classes) {
  unsigned mfmaCount = countClass(classes, BPCMFMA);
  unsigned producerCount = countClass(classes, BPCLdsDmaProducer);
  if (mfmaCount == 0 || producerCount == 0)
    return;

  appendMfmaMemoryDescriptor(descriptors, "barrier_pipeline_mfma_lds_dma",
                             BPCLdsDmaProducer, mfmaCount, producerCount,
                             mfmaCount);
  appendMfmaMemoryDescriptor(
      descriptors, "barrier_pipeline_mfma_lds_dma_split", BPCLdsDmaProducer,
      computeMfmaChunk(mfmaCount, countClass(classes, BPCLdsDma)),
      producerCount, mfmaCount);
  appendMfmaMemoryDescriptor(descriptors, "barrier_pipeline_lds_dma_mfma",
                             BPCLdsDmaProducer, 0, producerCount, mfmaCount);
}

static void appendDsReadMfmaDescriptor(
    SmallVectorImpl<BarrierPipelineDescriptor> &descriptors,
    ArrayRef<unsigned> classes, ArrayRef<NodeMetrics> metrics,
    const waveamdmachine::ArchData &arch) {
  unsigned dsReads = countClass(classes, BPCDSRead);
  unsigned mfmas = countClass(classes, BPCMFMA);
  if (dsReads == 0 || mfmas == 0)
    return;

  BarrierPipelineDescriptor descriptor;
  descriptor.name = "barrier_pipeline_ds_read_mfma";
  appendStage(descriptor.stages, BPCBarrier, 1);
  unsigned seed = computeDsReadSeed(classes, metrics, arch);
  appendStage(descriptor.stages, BPCDSRead, seed);
  unsigned remainingDs = dsReads - seed;
  unsigned pairs = std::max(remainingDs, mfmas);
  for (unsigned index = 0; index < pairs; ++index) {
    appendStage(descriptor.stages, BPCMFMA, 1);
    appendStage(descriptor.stages, BPCDSRead, 1);
  }
  descriptors.push_back(std::move(descriptor));
}

static void appendWriteReadMfmaDescriptor(
    SmallVectorImpl<BarrierPipelineDescriptor> &descriptors,
    ArrayRef<unsigned> classes, ArrayRef<NodeMetrics> metrics,
    const waveamdmachine::ArchData &arch) {
  unsigned dsReads = countClass(classes, BPCDSRead);
  unsigned dsWrites = countClass(classes, BPCDSWrite);
  unsigned vmemReads = countClass(classes, BPCVMemRead);
  unsigned mfmas = countClass(classes, BPCMFMA);
  if ((dsWrites == 0 && vmemReads == 0) || mfmas == 0)
    return;

  BarrierPipelineDescriptor descriptor;
  descriptor.name = "barrier_pipeline_write_read_mfma";
  appendStage(descriptor.stages, BPCBarrier, 1);
  unsigned burst =
      std::max(1u, waveamdmachine::getEventSimCmaIssueCapacity(arch));
  if (dsReads != 0) {
    descriptor.name = "barrier_pipeline_write_read_ds_mfma";
    descriptor.preserveDsReadWriterOrder = true;
    appendStage(descriptor.stages, BPCDSWrite, dsWrites);
    appendStage(descriptor.stages, BPCVMemRead, vmemReads);
    unsigned seed = computeDsReadSeed(classes, metrics, arch);
    appendStage(descriptor.stages, BPCDSRead, seed);
    unsigned remainingDs = dsReads - seed;
    unsigned pairs = std::max(remainingDs, mfmas);
    for (unsigned index = 0; index < pairs; ++index) {
      appendStage(descriptor.stages, BPCMFMA, 1);
      appendStage(descriptor.stages, BPCDSRead, 1);
    }
    descriptors.push_back(std::move(descriptor));
    return;
  }

  unsigned vmemBursts = (vmemReads + burst - 1) / burst;
  unsigned pairs = std::max({dsWrites, vmemBursts, mfmas});
  for (unsigned index = 0; index < pairs; ++index) {
    appendStage(descriptor.stages, BPCDSWrite, 1);
    appendStage(descriptor.stages, BPCVMemRead, burst);
    appendStage(descriptor.stages, BPCMFMA, 1);
  }
  descriptors.push_back(std::move(descriptor));
}

static SmallVector<BarrierPipelineDescriptor, 4>
buildBarrierPipelineDescriptors(ArrayRef<unsigned> classes,
                                ArrayRef<NodeMetrics> metrics,
                                const waveamdmachine::ArchData &arch,
                                bool enableMemoryPipelines) {
  SmallVector<BarrierPipelineDescriptor, 4> descriptors;
  appendDmaDescriptors(descriptors, classes);
  if (enableMemoryPipelines) {
    appendDsReadMfmaDescriptor(descriptors, classes, metrics, arch);
    appendWriteReadMfmaDescriptor(descriptors, classes, metrics, arch);
  }
  return descriptors;
}

static bool stageMatches(unsigned node, const BarrierPipelineStage &stage,
                         ArrayRef<unsigned> classes) {
  return hasPipelineClass(classes[node], stage.mask);
}

static bool hasUnscheduledStageMatch(const BarrierPipelineStage &stage,
                                     ArrayRef<unsigned> classes,
                                     const llvm::BitVector &scheduled) {
  for (auto [node, cls] : llvm::enumerate(classes))
    if (!scheduled.test(static_cast<unsigned>(node)) &&
        hasPipelineClass(cls, stage.mask))
      return true;
  return false;
}

static std::optional<unsigned>
findReadyStageMatch(ArrayRef<unsigned> ready, const BarrierPipelineStage &stage,
                    ArrayRef<unsigned> classes) {
  for (auto [readyIndex, node] : llvm::enumerate(ready))
    if (stageMatches(node, stage, classes))
      return static_cast<unsigned>(readyIndex);
  return std::nullopt;
}

static bool reachesUnscheduledStageMatchThroughNoInst(
    unsigned node, const GraphTables &tables, const BarrierPipelineStage &stage,
    ArrayRef<unsigned> classes, const llvm::BitVector &scheduled,
    const llvm::BitVector &noInst, llvm::BitVector &visited) {
  if (!visited.test(node))
    visited.set(node);
  for (unsigned succ : tables.successors[node]) {
    if (scheduled.test(succ))
      continue;
    if (stageMatches(succ, stage, classes))
      return true;
    if (noInst[succ] && !visited.test(succ) &&
        reachesUnscheduledStageMatchThroughNoInst(succ, tables, stage, classes,
                                                  scheduled, noInst, visited))
      return true;
  }
  return false;
}

static std::optional<unsigned> findReadyNoInstStageDependency(
    ArrayRef<unsigned> ready, const GraphTables &tables,
    const BarrierPipelineStage &stage, ArrayRef<unsigned> classes,
    const llvm::BitVector &scheduled, const llvm::BitVector &noInst) {
  for (auto [readyIndex, node] : llvm::enumerate(ready)) {
    if (!noInst[node])
      continue;
    llvm::BitVector visited(classes.size());
    if (reachesUnscheduledStageMatchThroughNoInst(node, tables, stage, classes,
                                                  scheduled, noInst, visited))
      return static_cast<unsigned>(readyIndex);
  }
  return std::nullopt;
}

static void scheduleReadyNode(unsigned readyIndex, const GraphTables &tables,
                              SmallVectorImpl<unsigned> &pending,
                              SmallVectorImpl<unsigned> &ready,
                              llvm::BitVector &scheduled,
                              SmallVectorImpl<unsigned> &order) {
  unsigned node = ready[readyIndex];
  ready.erase(ready.begin() + readyIndex);
  scheduled.set(node);
  order.push_back(node);
  for (unsigned succ : tables.successors[node]) {
    assert(pending[succ] > 0 && "successor predecessor count underflow");
    --pending[succ];
    if (pending[succ] == 0)
      ready.push_back(succ);
  }
  llvm::sort(ready);
}

static bool tryScheduleBarrierPipelineStage(
    const GraphTables &tables, const llvm::BitVector &noInst,
    ArrayRef<unsigned> classes, const BarrierPipelineStage &stage,
    SmallVectorImpl<unsigned> &pending, SmallVectorImpl<unsigned> &ready,
    llvm::BitVector &scheduled, SmallVectorImpl<unsigned> &order,
    unsigned &stageMatchesEmitted) {
  if (std::optional<unsigned> readyIndex =
          findReadyStageMatch(ready, stage, classes)) {
    scheduleReadyNode(*readyIndex, tables, pending, ready, scheduled, order);
    ++stageMatchesEmitted;
    return true;
  }

  if (!hasUnscheduledStageMatch(stage, classes, scheduled))
    return false;

  if (std::optional<unsigned> readyIndex = findReadyNoInstStageDependency(
          ready, tables, stage, classes, scheduled, noInst)) {
    scheduleReadyNode(*readyIndex, tables, pending, ready, scheduled, order);
    return true;
  }

  scheduleReadyNode(/*readyIndex=*/0, tables, pending, ready, scheduled, order);
  return true;
}

static bool buildBarrierPipelineOrder(const GraphTables &tables,
                                      const llvm::BitVector &noInst,
                                      ArrayRef<unsigned> classes,
                                      const BarrierPipelineDescriptor &desc,
                                      SmallVectorImpl<unsigned> &order) {
  SmallVector<unsigned, 16> pending = tables.pendingPreds;
  SmallVector<unsigned, 16> ready;
  for (auto [node, count] : llvm::enumerate(pending))
    if (count == 0)
      ready.push_back(static_cast<unsigned>(node));

  llvm::BitVector scheduled(classes.size());
  unsigned stageIndex = 0;
  unsigned stageMatchesEmitted = 0;
  while (order.size() < classes.size()) {
    if (ready.empty())
      return false;

    bool scheduledNode = false;
    while (stageIndex < desc.stages.size()) {
      const BarrierPipelineStage &stage = desc.stages[stageIndex];
      if (stageMatchesEmitted >= stage.maxMatches) {
        ++stageIndex;
        stageMatchesEmitted = 0;
        continue;
      }

      if (tryScheduleBarrierPipelineStage(tables, noInst, classes, stage,
                                          pending, ready, scheduled, order,
                                          stageMatchesEmitted)) {
        scheduledNode = true;
        break;
      }

      ++stageIndex;
      stageMatchesEmitted = 0;
    }

    if (!scheduledNode)
      scheduleReadyNode(/*readyIndex=*/0, tables, pending, ready, scheduled,
                        order);
  }
  return true;
}

static bool isDsReadWriterClass(unsigned cls) {
  return hasPipelineClass(cls, BPCDSWrite | BPCLdsDma | BPCVMemRead);
}

static bool isDsReadClass(unsigned cls) {
  return hasPipelineClass(cls, BPCDSRead);
}

static bool isDsReadWriterPair(unsigned lhsClass, unsigned rhsClass) {
  return (isDsReadClass(lhsClass) && isDsReadWriterClass(rhsClass)) ||
         (isDsReadWriterClass(lhsClass) && isDsReadClass(rhsClass));
}

static bool preservesDsReadWriterOrder(ArrayRef<unsigned> order,
                                       ArrayRef<unsigned> classes) {
  SmallVector<unsigned, 16> position(classes.size());
  for (auto [ordinal, node] : llvm::enumerate(order))
    position[node] = static_cast<unsigned>(ordinal);

  for (auto [lhs, lhsClass] : llvm::enumerate(classes))
    for (unsigned rhs = static_cast<unsigned>(lhs) + 1; rhs < classes.size();
         ++rhs)
      if (isDsReadWriterPair(lhsClass, classes[rhs]) &&
          position[lhs] > position[rhs])
        return false;
  return true;
}

static bool appendUniqueCandidate(SmallVectorImpl<OrderCandidate> &candidates,
                                  OrderCandidate candidate) {
  if (candidate.order.empty())
    return false;
  for (const OrderCandidate &existing : candidates)
    if (sameOrder(existing.order, candidate.order))
      return false;
  candidates.push_back(std::move(candidate));
  return true;
}

static void appendIndexRange(SmallVectorImpl<unsigned> &order, unsigned begin,
                             unsigned end) {
  for (unsigned index = begin; index < end; ++index)
    order.push_back(index);
}

static void buildLdsDmaAnchorOrder(const LdsDmaAnchorWindow &window,
                                   unsigned regionSize, unsigned anchor,
                                   SmallVectorImpl<unsigned> &order) {
  unsigned computeEnd = window.barrier;
  unsigned clusterBegin = window.barrier + 1;
  unsigned computeSplit = window.computeBegin + anchor;
  appendIndexRange(order, 0, window.computeBegin);
  appendIndexRange(order, window.computeBegin, computeSplit);
  order.push_back(window.barrier);
  appendIndexRange(order, clusterBegin, window.clusterEnd + 1);
  appendIndexRange(order, computeSplit, computeEnd);
  appendIndexRange(order, window.clusterEnd + 1, regionSize);
}

static void buildPostBarrierComputeOrder(const LdsDmaAnchorWindow &window,
                                         unsigned regionSize,
                                         unsigned computeBeforeCluster,
                                         SmallVectorImpl<unsigned> &order) {
  unsigned computeEnd = window.barrier;
  unsigned clusterBegin = window.barrier + 1;
  unsigned computeSplit = window.computeBegin + computeBeforeCluster;
  appendIndexRange(order, 0, window.computeBegin);
  order.push_back(window.barrier);
  appendIndexRange(order, window.computeBegin, computeSplit);
  appendIndexRange(order, clusterBegin, window.clusterEnd + 1);
  appendIndexRange(order, computeSplit, computeEnd);
  appendIndexRange(order, window.clusterEnd + 1, regionSize);
}

static void
addLdsDmaAnchorCandidates(SmallVectorImpl<OrderCandidate> &candidates,
                          const ScheduleRegion &region,
                          ArrayRef<unsigned> classes) {
  std::optional<LdsDmaAnchorWindow> window =
      findLdsDmaAnchorWindow(region, classes);
  if (!window)
    return;

  unsigned computeSize = window->barrier - window->computeBegin;
  static constexpr std::array<unsigned, 5> anchors = {0, 4, 8, 16, 24};
  for (unsigned anchor : anchors) {
    if (anchor >= computeSize)
      continue;

    OrderCandidate hoist;
    hoist.name = "barrier_pipeline_lds_dma_anchor_" + std::to_string(anchor);
    buildLdsDmaAnchorOrder(*window, region.ops.size(), anchor, hoist.order);
    appendUniqueCandidate(candidates, std::move(hoist));

    OrderCandidate split;
    split.name =
        "barrier_pipeline_lds_dma_post_compute_" + std::to_string(anchor);
    buildPostBarrierComputeOrder(*window, region.ops.size(), anchor,
                                 split.order);
    appendUniqueCandidate(candidates, std::move(split));
  }

  OrderCandidate allCompute;
  allCompute.name = "barrier_pipeline_lds_dma_post_compute_all";
  buildPostBarrierComputeOrder(*window, region.ops.size(), computeSize,
                               allCompute.order);
  appendUniqueCandidate(candidates, std::move(allCompute));
}

static bool hasClassInRange(ArrayRef<unsigned> classes, unsigned begin,
                            unsigned end, unsigned mask) {
  for (unsigned index = begin; index < end; ++index)
    if (hasPipelineClass(classes[index], mask))
      return true;
  return false;
}

static void buildBarrierDsReadPrefetchOrder(unsigned barrier,
                                            ArrayRef<unsigned> prefetched,
                                            unsigned regionSize,
                                            SmallVectorImpl<unsigned> &order) {
  appendIndexRange(order, 0, barrier);
  order.append(prefetched.begin(), prefetched.end());
  order.push_back(barrier);
  for (unsigned index = barrier + 1; index < regionSize; ++index)
    if (!llvm::is_contained(prefetched, index))
      order.push_back(index);
}

static bool canPrefetchBeforeBarrier(unsigned node, unsigned barrier,
                                     const DependenceGraph &graph,
                                     ArrayRef<unsigned> prefetched) {
  for (const ScheduleEdge &edge : graph.edges) {
    if (edge.recurrence || edge.dst != node)
      continue;
    if (edge.src < barrier || llvm::is_contained(prefetched, edge.src))
      continue;
    return false;
  }
  return true;
}

static bool hasBarrierDsReadPrefetchShape(ArrayRef<unsigned> classes,
                                          unsigned barrier) {
  if (barrier == 0 || barrier + 1 >= classes.size())
    return false;
  if (!hasClassInRange(classes, 0, barrier, BPCDSWrite | BPCVMemRead))
    return false;
  return hasClassInRange(classes, barrier + 1, classes.size(), BPCMFMA);
}

static void addBarrierDsReadPrefetchCandidate(
    SmallVectorImpl<OrderCandidate> &candidates, ArrayRef<unsigned> classes,
    const DependenceGraph &graph, const waveamdmachine::ArchData &arch) {
  std::optional<unsigned> barrier = findSingleBarrierClass(classes);
  if (!barrier || !hasBarrierDsReadPrefetchShape(classes, *barrier))
    return;

  unsigned burst =
      std::max(1u, waveamdmachine::getEventSimCmaIssueCapacity(arch));
  SmallVector<unsigned, 4> prefetched;
  for (unsigned index = *barrier + 1; index < classes.size(); ++index) {
    if (!hasPipelineClass(classes[index], BPCDSRead))
      continue;
    if (!canPrefetchBeforeBarrier(index, *barrier, graph, prefetched))
      continue;
    prefetched.push_back(index);
    if (prefetched.size() >= burst)
      break;
  }
  if (prefetched.empty())
    return;

  OrderCandidate candidate;
  candidate.name = "barrier_pipeline_ds_read_prefetch";
  buildBarrierDsReadPrefetchOrder(*barrier, prefetched, classes.size(),
                                  candidate.order);
  appendUniqueCandidate(candidates, std::move(candidate));
}

static SmallVector<OrderCandidate, 4> buildBarrierPipelineCandidates(
    const ScheduleRegion &region, const DependenceGraph &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &modelConfig,
    bool enableMemoryPipelines) {
  GraphTables tables = buildGraphTables(region, graph);
  SmallVector<NodeMetrics, 16> metrics =
      computeNodeMetrics(region, tables, arch, modelConfig);

  SmallVector<unsigned, 16> classes;
  classes.reserve(region.ops.size());
  llvm::BitVector noInst(region.ops.size());
  bool sawMfma = false;
  bool sawMemory = false;
  for (auto [index, op] : llvm::enumerate(region.ops)) {
    unsigned cls = classifyBarrierPipelineOp(op, metrics[index]);
    classes.push_back(cls);
    if (op->hasTrait<traits::NoMachineInst>())
      noInst.set(static_cast<unsigned>(index));
    sawMfma |= hasPipelineClass(cls, BPCMFMA);
    sawMemory |= isMemoryPipelineClass(cls);
  }
  if (!sawMfma || !sawMemory)
    return {};

  SmallVector<OrderCandidate, 4> candidates;
  candidates.push_back({getIdentityOrder(region.ops.size()), "original"});
  addLdsDmaAnchorCandidates(candidates, region, classes);
  addBarrierDsReadPrefetchCandidate(candidates, classes, graph, arch);
  for (const BarrierPipelineDescriptor &descriptor :
       buildBarrierPipelineDescriptors(classes, metrics, arch,
                                       enableMemoryPipelines)) {
    OrderCandidate candidate;
    candidate.name = descriptor.name.str();
    if (!buildBarrierPipelineOrder(tables, noInst, classes, descriptor,
                                   candidate.order))
      continue;
    if (descriptor.preserveDsReadWriterOrder &&
        !preservesDsReadWriterOrder(candidate.order, classes))
      continue;
    appendUniqueCandidate(candidates, std::move(candidate));
  }
  dropLoopCarriedCounterDrainCandidates(region, candidates);
  return candidates;
}

static bool
tryBarrierPipelineSchedule(func::FuncOp func,
                           waveamdmachine::SBarrierOp barrier,
                           ArchResolution archResolution,
                           const waveamdmachine::EventSimConfig &modelConfig,
                           const RegisterPressureBudgets &pressureBudgets,
                           PressureEvaluation pressureEvaluation,
                           const SchedulePressureContext *pressureContext,
                           ScheduleSearchLimits searchLimits) {
  if (!archResolution.arch)
    return false;

  BarrierPipelineWindow window;
  if (!collectBarrierPipelineWindow(func, barrier, searchLimits, window))
    return false;

  DependenceGraph graph = buildDependenceGraph(window.region);
  SmallVector<OrderCandidate, 4> candidates = buildBarrierPipelineCandidates(
      window.region, graph, *archResolution.arch, modelConfig,
      /*enableMemoryPipelines=*/true);
  if (candidates.size() <= 1)
    return false;

  PressureEvaluation pipelinePressure =
      pressureEvaluation == PressureEvaluation::None
          ? PressureEvaluation::None
          : PressureEvaluation::Eager;
  ScheduleDecision decision = evaluateScheduleOrderCandidates(
      window.region, graph, candidates, archResolution, modelConfig,
      pressureBudgets, pipelinePressure, /*allowPressureUpperBound=*/false,
      pressureContext);
  if (!shouldApplyDecision(decision, pressureBudgets))
    return false;

  applyScheduleOrder(window.region,
                     decision.candidates[decision.selected].order);
  return true;
}

static void processBarrierPipelineSchedules(
    func::FuncOp func, ArchResolution archResolution,
    const waveamdmachine::EventSimConfig &modelConfig,
    const RegisterPressureBudgets &pressureBudgets,
    PressureEvaluation pressureEvaluation,
    const SchedulePressureContext *pressureContext,
    ScheduleSearchLimits searchLimits) {
  SmallVector<waveamdmachine::SBarrierOp> barriers;
  func.walk(
      [&](waveamdmachine::SBarrierOp barrier) { barriers.push_back(barrier); });

  for (waveamdmachine::SBarrierOp barrier : barriers) {
    bool scheduled = tryBarrierPipelineSchedule(
        func, barrier, archResolution, modelConfig, pressureBudgets,
        pressureEvaluation, pressureContext, searchLimits);
    if (!scheduled)
      tryWaitBarrierLdsDmaPrefixHoist(barrier, searchLimits);
  }
}

static PressureEvaluation
getSchedulePressureEvaluation(RegisterPressureBudgets budgets) {
  if (!budgets.selectionEnabled)
    return PressureEvaluation::None;
  if (hasCriticalBudget(budgets))
    return PressureEvaluation::Eager;
  return PressureEvaluation::LazyHardCap;
}

struct WaveAMDMachineSchedulePass
    : public wave::impl::WaveAMDMachineScheduleBase<
          WaveAMDMachineSchedulePass> {
  using WaveAMDMachineScheduleBase::WaveAMDMachineScheduleBase;

  void runOnOperation() override {
    Operation *root = getOperation();
    waveamdmachine::EventSimConfig modelConfig;
    if (failed(configureScheduleModel(root, modelWaves, modelSimds,
                                      modelStartDelay, modelVmemValueLatency,
                                      modelSmemValueLatency,
                                      modelLdsValueLatency, modelConfig)))
      return signalPassFailure();
    std::optional<waveamdmachine::CalibrationData> calibration;
    if (failed(loadScheduleCalibration(root, calibrationFile, calibration)))
      return signalPassFailure();
    if (calibration)
      modelConfig.calibration = &*calibration;
    if (!applySchedule)
      return;
    ScheduleSearchLimits searchLimits{static_cast<int64_t>(maxBeamWork),
                                      maxRegionOps,
                                      /*emitDiagnostics=*/false,
                                      /*emitRemarks=*/true};
    WalkResult walkResult = root->walk([&](func::FuncOp func) {
      return processWalkFunction(func, modelConfig, searchLimits);
    });
    if (walkResult.wasInterrupted())
      return signalPassFailure();
  }

  WalkResult
  processWalkFunction(func::FuncOp func,
                      const waveamdmachine::EventSimConfig &modelConfig,
                      ScheduleSearchLimits searchLimits) {
    ArchResolution archResolution = resolveArch(func);
    if (failed(validateScheduleCalibration(func, archResolution, modelConfig)))
      return WalkResult::interrupt();
    waveamdmachine::EventSimConfig funcModelConfig = modelConfig;
    if (failed(finalizeScheduleModel(func, archResolution, funcModelConfig)))
      return WalkResult::interrupt();
    RegisterPressureBudgets pressureBudgets;
    if (failed(configureSchedulePressureBudgets(
            func, archResolution, pressureAwareSelection, pressureVgprBudget,
            pressureSgprBudget, pressureCriticalVgprBudget,
            pressureCriticalSgprBudget, pressureTargetWavesOverride,
            pressureBudgets)))
      return WalkResult::interrupt();
    ScheduleSearchLimits funcSearchLimits = searchLimits;
    if (failed(
            applyFunctionScheduleSearchLimitOverrides(func, funcSearchLimits)))
      return WalkResult::interrupt();
    if (failed(processFunction(func, archResolution, funcModelConfig,
                               pressureBudgets, funcSearchLimits)))
      return WalkResult::interrupt();
    return WalkResult::advance();
  }

  LogicalResult
  processFunction(func::FuncOp func, ArchResolution archResolution,
                  const waveamdmachine::EventSimConfig &modelConfig,
                  const RegisterPressureBudgets &pressureBudgets,
                  ScheduleSearchLimits searchLimits) {
    if (func.isExternal())
      return success();
    if (failed(wave::prepareWaveAMDRegAllocIR(func)))
      return failure();
    SmallVector<ScheduleRegion> regions = collectScheduleRegions(func);
    PressureEvaluation pressureEvaluation =
        getSchedulePressureEvaluation(pressureBudgets);
    std::optional<SchedulePressureContext> pressureContext;
    if (pressureEvaluation != PressureEvaluation::None)
      pressureContext = buildSchedulePressureContext(func);
    for (const ScheduleRegion &region : regions) {
      processRegion(region, archResolution, modelConfig, pressureBudgets,
                    pressureEvaluation,
                    pressureContext ? &*pressureContext : nullptr,
                    searchLimits);
    }
    if (barrieredLdsDmaHoist)
      processBarrierPipelineSchedules(
          func, archResolution, modelConfig, pressureBudgets,
          pressureEvaluation, pressureContext ? &*pressureContext : nullptr,
          searchLimits);
    return success();
  }

  void processRegion(const ScheduleRegion &region,
                     ArchResolution archResolution,
                     const waveamdmachine::EventSimConfig &modelConfig,
                     const RegisterPressureBudgets &pressureBudgets,
                     PressureEvaluation pressureEvaluation,
                     const SchedulePressureContext *pressureContext,
                     ScheduleSearchLimits searchLimits) {
    if (exceedsScheduleRegionLimit(region, searchLimits)) {
      if (searchLimits.emitRemarks)
        emitScheduleRegionLimitRemark(region, searchLimits);
      return;
    }
    DependenceGraph graph = buildDependenceGraph(region);
    processScheduler(region, graph, archResolution, modelConfig,
                     pressureBudgets, pressureEvaluation, pressureContext,
                     searchLimits);
  }

  void processScheduler(const ScheduleRegion &region,
                        const DependenceGraph &graph,
                        ArchResolution archResolution,
                        const waveamdmachine::EventSimConfig &modelConfig,
                        const RegisterPressureBudgets &pressureBudgets,
                        PressureEvaluation pressureEvaluation,
                        const SchedulePressureContext *pressureContext,
                        ScheduleSearchLimits searchLimits) {
    ScheduleDecision decision = evaluateScheduleCandidates(
        region, graph, archResolution, modelConfig, pressureBudgets, beamSearch,
        searchLimits, pressureEvaluation, /*allowPressureUpperBound=*/true,
        pressureContext);
    bool willApply =
        applySchedule && shouldApplyDecision(decision, pressureBudgets);
    if (willApply)
      applyScheduleOrder(region, decision.candidates[decision.selected].order);
  }
};

} // namespace
