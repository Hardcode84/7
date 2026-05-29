//===- WaveAMDMachineScheduleBeam.cpp - Guided beam search ----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineScheduleInternal.h"

#include "WaveAMDRegLiveIntervals.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Threading.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"

#include <algorithm>
#include <limits>
#include <optional>

using namespace mlir;

namespace mlir::wave {
namespace {

struct BeamSearchConfig {
  // Prefix pruning only. Event-sim + pressure rank completed orders.
  int64_t guideBonus = 200000;              // prefer fixed-policy prefix
  int64_t discrepancyPenalty = 50000;       // cost per guide deviation
  int64_t criticalPathWeight = 1000;        // favor long remaining chains
  int64_t latencyWeight = 100;              // favor latency hiding
  int64_t unlockWeight = 500;               // favor newly-ready successors
  int64_t memoryWeight = 80;                // tie-break toward memory paths
  int64_t matrixWeight = 80;                // tie-break toward matrix feeders
  int64_t guideDistancePenalty = 10;        // prefer earlier guide nodes
  int64_t hardPressurePenalty = 1000000;    // repair hard-cap excess
  int64_t criticalPressurePenalty = 100000; // repair occupancy excess
  int64_t pressurePeakPenalty = 10;         // tie-break on peak pressure
  unsigned width = 12;                      // states kept per depth
  unsigned branchLimit = 4;                 // ready choices expanded per state
  unsigned candidateLimit = 8;              // completed beam orders emitted
  unsigned parallelChoiceParentMin = 32;    // parents scored in parallel
  unsigned parallelStateChildMin = 32;      // next states built in parallel
};

static constexpr BeamSearchConfig kDefaultBeamSearchConfig;

struct PressureValueInfo {
  waveamdmachine::RegType type;
  bool liveOut = false;
};

struct PressureModel {
  SmallVector<PressureValueInfo, 32> values;
  SmallVector<SmallVector<unsigned, 4>, 16> uses;
  SmallVector<SmallVector<std::pair<unsigned, unsigned>, 4>, 16> uniqueUses;
  SmallVector<SmallVector<unsigned, 2>, 16> defs;
  SmallVector<unsigned, 32> initialRemainingUses;
};

struct BeamPressureState {
  SmallVector<unsigned, 32> remainingUses;
  SmallVector<uint8_t, 32> active;
  unsigned currentVGPR = 0;
  unsigned currentSGPR = 0;
  unsigned maxVGPR = 0;
  unsigned maxSGPR = 0;
};

struct PressurePreview {
  unsigned currentVGPR = 0;
  unsigned currentSGPR = 0;
  unsigned maxVGPR = 0;
  unsigned maxSGPR = 0;
};

struct BeamState {
  SmallVector<unsigned, 16> pending;
  BeamPressureState pressure;
  BitVector ready;
  BitVector scheduled;
  int64_t rank = 0;
  unsigned discrepancies = 0;
  unsigned guideOrdinal = 0;
  unsigned guideCursor = 0;
  unsigned trace = std::numeric_limits<unsigned>::max();
  unsigned depth = 0;
};

struct ReadyChoice {
  int64_t score = 0;
  int64_t hardExcess = 0;
  int64_t criticalExcess = 0;
  int64_t peakPressure = 0;
  unsigned node = 0;
  unsigned discrepancy = 0;
  unsigned guidePosition = 0;
};

struct BeamResult {
  SmallVector<unsigned, 16> order;
  int64_t rank = 0;
  unsigned discrepancies = 0;
  unsigned guideOrdinal = 0;
  unsigned maxVGPR = 0;
  unsigned maxSGPR = 0;
};

struct BeamChild {
  ReadyChoice choice;
  unsigned parent = 0;
};

struct BeamTrace {
  unsigned parent = std::numeric_limits<unsigned>::max();
  unsigned node = 0;
};

static unsigned getUnsetNode() { return std::numeric_limits<unsigned>::max(); }

static int64_t computeExcess(unsigned pressure, int budget) {
  if (budget < 0)
    return 0;
  return std::max<int64_t>(0, static_cast<int64_t>(pressure) - budget);
}

static unsigned getPressureWidth(waveamdmachine::RegType type) {
  return static_cast<unsigned>(type.getWidth());
}

static bool isVGPRPressureValue(const PressureModel &model, unsigned value) {
  return wave::isWaveAMDVGPR(model.values[value].type);
}

static void addPressure(BeamPressureState &state, const PressureModel &model,
                        unsigned value) {
  if (state.active[value])
    return;
  state.active[value] = 1;
  unsigned width = getPressureWidth(model.values[value].type);
  if (isVGPRPressureValue(model, value)) {
    state.currentVGPR += width;
    state.maxVGPR = std::max(state.maxVGPR, state.currentVGPR);
    return;
  }
  state.currentSGPR += width;
  state.maxSGPR = std::max(state.maxSGPR, state.currentSGPR);
}

static void dropPressure(BeamPressureState &state, const PressureModel &model,
                         unsigned value) {
  if (!state.active[value])
    return;
  state.active[value] = 0;
  unsigned width = getPressureWidth(model.values[value].type);
  if (isVGPRPressureValue(model, value)) {
    assert(state.currentVGPR >= width && "VGPR pressure underflow");
    state.currentVGPR -= width;
    return;
  }
  assert(state.currentSGPR >= width && "SGPR pressure underflow");
  state.currentSGPR -= width;
}

static bool isPreviewActive(const BeamPressureState &state,
                            ArrayRef<unsigned> added, unsigned value) {
  return state.active[value] || llvm::is_contained(added, value);
}

static void addPreviewPressure(PressurePreview &preview,
                               const BeamPressureState &state,
                               const PressureModel &model, unsigned value,
                               SmallVectorImpl<unsigned> &added) {
  if (isPreviewActive(state, added, value))
    return;
  added.push_back(value);
  unsigned width = getPressureWidth(model.values[value].type);
  if (isVGPRPressureValue(model, value)) {
    preview.currentVGPR += width;
    preview.maxVGPR = std::max(preview.maxVGPR, preview.currentVGPR);
    return;
  }
  preview.currentSGPR += width;
  preview.maxSGPR = std::max(preview.maxSGPR, preview.currentSGPR);
}

static void dropPreviewPressure(PressurePreview &preview,
                                const PressureModel &model, unsigned value,
                                SmallVectorImpl<unsigned> &dropped) {
  if (llvm::is_contained(dropped, value))
    return;
  dropped.push_back(value);
  unsigned width = getPressureWidth(model.values[value].type);
  if (isVGPRPressureValue(model, value)) {
    assert(preview.currentVGPR >= width && "VGPR pressure underflow");
    preview.currentVGPR -= width;
    return;
  }
  assert(preview.currentSGPR >= width && "SGPR pressure underflow");
  preview.currentSGPR -= width;
}

static int64_t getPreviewHardExcess(const PressurePreview &preview,
                                    const RegisterPressureBudgets &budgets) {
  return computeExcess(preview.maxVGPR, budgets.hardVGPR) +
         computeExcess(preview.maxSGPR, budgets.hardSGPR);
}

static int64_t
getPreviewCriticalExcess(const PressurePreview &preview,
                         const RegisterPressureBudgets &budgets) {
  return computeExcess(preview.maxVGPR, budgets.criticalVGPR) +
         computeExcess(preview.maxSGPR, budgets.criticalSGPR);
}

static int64_t getPreviewPeakPressure(const PressurePreview &preview) {
  return static_cast<int64_t>(preview.maxVGPR) +
         static_cast<int64_t>(preview.maxSGPR);
}

static BeamPressureState makeInitialPressureState(const PressureModel &model) {
  BeamPressureState state;
  state.remainingUses = model.initialRemainingUses;
  state.active.assign(model.values.size(), 0);
  return state;
}

static void applyPressureNode(BeamPressureState &state,
                              const PressureModel &model, unsigned node) {
  for (unsigned value : model.uses[node])
    addPressure(state, model, value);
  for (unsigned value : model.defs[node])
    addPressure(state, model, value);
  for (unsigned value : model.uses[node]) {
    assert(state.remainingUses[value] > 0 && "remaining use underflow");
    --state.remainingUses[value];
    if (state.remainingUses[value] == 0 && !model.values[value].liveOut)
      dropPressure(state, model, value);
  }
  for (unsigned value : model.defs[node])
    if (state.remainingUses[value] == 0 && !model.values[value].liveOut)
      dropPressure(state, model, value);
}

static PressurePreview previewPressureNode(const BeamPressureState &state,
                                           const PressureModel &model,
                                           unsigned node) {
  PressurePreview preview{state.currentVGPR, state.currentSGPR, state.maxVGPR,
                          state.maxSGPR};
  SmallVector<unsigned, 4> added;
  for (unsigned value : model.uses[node])
    addPreviewPressure(preview, state, model, value, added);
  for (unsigned value : model.defs[node])
    addPreviewPressure(preview, state, model, value, added);

  SmallVector<unsigned, 4> dropped;
  for (auto [value, count] : model.uniqueUses[node])
    if (state.remainingUses[value] == count && !model.values[value].liveOut)
      dropPreviewPressure(preview, model, value, dropped);
  for (unsigned value : model.defs[node])
    if (state.remainingUses[value] == 0 && !model.values[value].liveOut)
      dropPreviewPressure(preview, model, value, dropped);
  return preview;
}

static bool hasUseOutsideRegion(Value value,
                                const DenseSet<Operation *> &regionOps) {
  for (OpOperand &use : value.getUses())
    if (!regionOps.contains(use.getOwner()))
      return true;
  return false;
}

static std::optional<unsigned>
getPressureValue(Value value, PressureModel &model,
                 DenseMap<Value, unsigned> &valueNumbers,
                 const DenseSet<Operation *> &regionOps) {
  std::optional<waveamdmachine::RegType> type =
      wave::getTrackedWaveAMDRegType(value);
  if (!type)
    return std::nullopt;
  if (!wave::isWaveAMDSGPR(*type) && !wave::isWaveAMDVGPR(*type))
    return std::nullopt;
  auto it = valueNumbers.find(value);
  if (it != valueNumbers.end())
    return it->second;
  unsigned number = model.values.size();
  model.values.push_back({*type, hasUseOutsideRegion(value, regionOps)});
  model.initialRemainingUses.push_back(0);
  valueNumbers[value] = number;
  return number;
}

static PressureModel buildPressureModel(const ScheduleRegion &region) {
  PressureModel model;
  model.uses.resize(region.ops.size());
  model.uniqueUses.resize(region.ops.size());
  model.defs.resize(region.ops.size());

  DenseSet<Operation *> regionOps;
  for (Operation *op : region.ops)
    regionOps.insert(op);

  DenseMap<Value, unsigned> valueNumbers;
  for (auto [node, op] : llvm::enumerate(region.ops)) {
    for (Value operand : op->getOperands()) {
      std::optional<unsigned> value =
          getPressureValue(operand, model, valueNumbers, regionOps);
      if (!value)
        continue;
      model.uses[node].push_back(*value);
      ++model.initialRemainingUses[*value];
    }
    for (unsigned value : model.uses[node]) {
      auto it =
          llvm::find_if(model.uniqueUses[node],
                        [value](const std::pair<unsigned, unsigned> &entry) {
                          return entry.first == value;
                        });
      if (it == model.uniqueUses[node].end()) {
        model.uniqueUses[node].push_back({value, 1});
        continue;
      }
      ++it->second;
    }
    for (Value result : op->getResults()) {
      std::optional<unsigned> value =
          getPressureValue(result, model, valueNumbers, regionOps);
      if (value)
        model.defs[node].push_back(*value);
    }
  }
  return model;
}

static BeamState makeInitialBeamState(const GraphTables &tables,
                                      const PressureModel &pressureModel) {
  BeamState state;
  state.pending = tables.pendingPreds;
  state.ready.resize(tables.pendingPreds.size());
  state.scheduled.resize(tables.pendingPreds.size());
  state.pressure = makeInitialPressureState(pressureModel);
  for (auto [index, count] : llvm::enumerate(tables.pendingPreds))
    if (count == 0)
      state.ready.set(index);
  return state;
}

static void advanceGuideCursor(BeamState &state, ArrayRef<unsigned> guide) {
  while (state.guideCursor < guide.size() &&
         state.scheduled.test(guide[state.guideCursor]))
    ++state.guideCursor;
}

static unsigned getNextGuideNode(const BeamState &state,
                                 ArrayRef<unsigned> guide) {
  if (state.guideCursor >= guide.size())
    return getUnsetNode();
  return guide[state.guideCursor];
}

static SmallVector<unsigned, 16> buildGuidePositions(ArrayRef<unsigned> guide) {
  SmallVector<unsigned, 16> positions(guide.size(), getUnsetNode());
  for (auto [index, node] : llvm::enumerate(guide))
    positions[node] = index;
  return positions;
}

static unsigned countUnlockedSuccessors(unsigned node,
                                        const GraphTables &tables,
                                        ArrayRef<unsigned> pending) {
  unsigned unlocked = 0;
  for (unsigned succ : tables.successors[node])
    if (pending[succ] == 1)
      ++unlocked;
  return unlocked;
}

static ReadyChoice scoreReadyChoice(
    unsigned node, const BeamState &state, const GraphTables &tables,
    ArrayRef<NodeMetrics> metrics, unsigned nextGuide,
    ArrayRef<unsigned> guidePositions, const PressureModel &pressureModel,
    const RegisterPressureBudgets &budgets, const BeamSearchConfig &config) {
  ReadyChoice choice;
  choice.node = node;
  choice.discrepancy = node == nextGuide ? 0 : 1;
  choice.guidePosition = guidePositions[node];
  if (isPressureSearchEnabled(budgets)) {
    PressurePreview pressure =
        previewPressureNode(state.pressure, pressureModel, node);
    choice.hardExcess = getPreviewHardExcess(pressure, budgets);
    choice.criticalExcess = getPreviewCriticalExcess(pressure, budgets);
    choice.peakPressure = getPreviewPeakPressure(pressure);
  }

  int64_t guideScore = node == nextGuide ? config.guideBonus : 0;
  int64_t pathScore = metrics[node].criticalPath * config.criticalPathWeight;
  int64_t latencyScore =
      static_cast<int64_t>(metrics[node].latency) * config.latencyWeight;
  int64_t unlockScore = static_cast<int64_t>(countUnlockedSuccessors(
                            node, tables, state.pending)) *
                        config.unlockWeight;
  int64_t memoryScore =
      static_cast<int64_t>(memoryPriority(metrics[node])) * config.memoryWeight;
  int64_t matrixScore =
      static_cast<int64_t>(matrixPriority(metrics[node])) * config.matrixWeight;
  int64_t guideDistancePenalty =
      choice.guidePosition == getUnsetNode()
          ? 0
          : static_cast<int64_t>(choice.guidePosition) *
                config.guideDistancePenalty;
  int64_t pressurePenalty =
      choice.hardExcess * config.hardPressurePenalty +
      choice.criticalExcess * config.criticalPressurePenalty +
      choice.peakPressure * config.pressurePeakPenalty;
  choice.score = guideScore + pathScore + latencyScore + unlockScore +
                 memoryScore + matrixScore - guideDistancePenalty -
                 pressurePenalty;
  return choice;
}

static bool isBetterReadyChoice(const ReadyChoice &lhs,
                                const ReadyChoice &rhs) {
  if (lhs.hardExcess != rhs.hardExcess)
    return lhs.hardExcess < rhs.hardExcess;
  if (lhs.criticalExcess != rhs.criticalExcess)
    return lhs.criticalExcess < rhs.criticalExcess;
  if (lhs.score != rhs.score)
    return lhs.score > rhs.score;
  if (lhs.peakPressure != rhs.peakPressure)
    return lhs.peakPressure < rhs.peakPressure;
  if (lhs.discrepancy != rhs.discrepancy)
    return lhs.discrepancy < rhs.discrepancy;
  if (lhs.guidePosition != rhs.guidePosition)
    return lhs.guidePosition < rhs.guidePosition;
  return lhs.node < rhs.node;
}

static SmallVector<ReadyChoice, 8> getReadyChoices(
    const BeamState &state, const GraphTables &tables,
    ArrayRef<NodeMetrics> metrics, ArrayRef<unsigned> guide,
    ArrayRef<unsigned> guidePositions, const PressureModel &pressureModel,
    const RegisterPressureBudgets &budgets, const BeamSearchConfig &config) {
  SmallVector<ReadyChoice, 8> choices;
  unsigned nextGuide = getNextGuideNode(state, guide);
  for (unsigned node : state.ready.set_bits())
    choices.push_back(scoreReadyChoice(node, state, tables, metrics, nextGuide,
                                       guidePositions, pressureModel, budgets,
                                       config));
  llvm::sort(choices, isBetterReadyChoice);
  if (choices.size() > config.branchLimit)
    choices.resize(config.branchLimit);
  return choices;
}

static BeamState
buildNextBeamState(const BeamState &state, const ReadyChoice &choice,
                   const GraphTables &tables, ArrayRef<unsigned> guide,
                   const PressureModel &pressureModel,
                   const RegisterPressureBudgets &budgets,
                   MutableArrayRef<BeamTrace> traces, unsigned traceIndex) {
  BeamState next = state;
  unsigned node = choice.node;
  assert(traceIndex < traces.size() && "trace slot must be preallocated");
  assert(next.ready.test(node) && "selected node must be ready");
  next.ready.reset(node);
  next.scheduled.set(node);
  advanceGuideCursor(next, guide);
  next.trace = traceIndex;
  next.depth = state.depth + 1;
  traces[traceIndex] = {state.trace, node};
  next.rank += choice.score;
  next.discrepancies += choice.discrepancy;
  if (isPressureSearchEnabled(budgets))
    applyPressureNode(next.pressure, pressureModel, node);

  for (unsigned succ : tables.successors[node]) {
    assert(next.pending[succ] > 0 && "successor predecessor count underflow");
    --next.pending[succ];
    if (next.pending[succ] == 0)
      next.ready.set(succ);
  }
  return next;
}

static bool isLexicographicallyEarlier(ArrayRef<unsigned> lhs,
                                       ArrayRef<unsigned> rhs) {
  return std::lexicographical_compare(lhs.begin(), lhs.end(), rhs.begin(),
                                      rhs.end());
}

static SmallVector<unsigned, 16> buildBeamOrder(const BeamState &state,
                                                ArrayRef<BeamTrace> traces) {
  SmallVector<unsigned, 16> order;
  for (unsigned trace = state.trace; trace != getUnsetNode();
       trace = traces[trace].parent)
    order.push_back(traces[trace].node);
  std::reverse(order.begin(), order.end());
  return order;
}

static int64_t getChildPressurePenalty(const ReadyChoice &choice,
                                       const BeamSearchConfig &config) {
  return choice.hardExcess * config.hardPressurePenalty +
         choice.criticalExcess * config.criticalPressurePenalty +
         choice.peakPressure * config.pressurePeakPenalty;
}

static int64_t getBeamChildRank(const BeamChild &child,
                                ArrayRef<BeamState> parents,
                                const RegisterPressureBudgets &budgets,
                                const BeamSearchConfig &config) {
  const BeamState &parent = parents[child.parent];
  int64_t pressurePenalty = isPressureSearchEnabled(budgets)
                                ? getChildPressurePenalty(child.choice, config)
                                : 0;
  return parent.rank + child.choice.score -
         static_cast<int64_t>(parent.discrepancies + child.choice.discrepancy) *
             config.discrepancyPenalty -
         pressurePenalty;
}

static bool isLexicographicallyEarlierChild(const BeamChild &lhs,
                                            const BeamChild &rhs) {
  if (lhs.parent != rhs.parent)
    return lhs.parent < rhs.parent;
  return lhs.choice.node < rhs.choice.node;
}

static bool isBetterBeamChild(const BeamChild &lhs, const BeamChild &rhs,
                              ArrayRef<BeamState> parents,
                              const RegisterPressureBudgets &budgets,
                              const BeamSearchConfig &config) {
  if (isPressureSearchEnabled(budgets)) {
    if (lhs.choice.hardExcess != rhs.choice.hardExcess)
      return lhs.choice.hardExcess < rhs.choice.hardExcess;
    if (lhs.choice.criticalExcess != rhs.choice.criticalExcess)
      return lhs.choice.criticalExcess < rhs.choice.criticalExcess;
  }
  int64_t lhsRank = getBeamChildRank(lhs, parents, budgets, config);
  int64_t rhsRank = getBeamChildRank(rhs, parents, budgets, config);
  if (lhsRank != rhsRank)
    return lhsRank > rhsRank;
  if (isPressureSearchEnabled(budgets) &&
      lhs.choice.peakPressure != rhs.choice.peakPressure)
    return lhs.choice.peakPressure < rhs.choice.peakPressure;
  unsigned lhsDiscrepancies =
      parents[lhs.parent].discrepancies + lhs.choice.discrepancy;
  unsigned rhsDiscrepancies =
      parents[rhs.parent].discrepancies + rhs.choice.discrepancy;
  if (lhsDiscrepancies != rhsDiscrepancies)
    return lhsDiscrepancies < rhsDiscrepancies;
  if (parents[lhs.parent].guideOrdinal != parents[rhs.parent].guideOrdinal)
    return parents[lhs.parent].guideOrdinal < parents[rhs.parent].guideOrdinal;
  return isLexicographicallyEarlierChild(lhs, rhs);
}

static int64_t getBeamResultRank(const BeamResult &result,
                                 const RegisterPressureBudgets &budgets,
                                 const BeamSearchConfig &config) {
  int64_t pressurePenalty = 0;
  if (isPressureSearchEnabled(budgets)) {
    pressurePenalty = computeExcess(result.maxVGPR, budgets.hardVGPR) *
                          config.hardPressurePenalty +
                      computeExcess(result.maxSGPR, budgets.hardSGPR) *
                          config.hardPressurePenalty +
                      computeExcess(result.maxVGPR, budgets.criticalVGPR) *
                          config.criticalPressurePenalty +
                      computeExcess(result.maxSGPR, budgets.criticalSGPR) *
                          config.criticalPressurePenalty +
                      (static_cast<int64_t>(result.maxVGPR) + result.maxSGPR) *
                          config.pressurePeakPenalty;
  }
  return result.rank -
         static_cast<int64_t>(result.discrepancies) *
             config.discrepancyPenalty -
         pressurePenalty;
}

static bool isBetterBeamResult(const BeamResult &lhs, const BeamResult &rhs,
                               const RegisterPressureBudgets &budgets,
                               const BeamSearchConfig &config) {
  if (isPressureSearchEnabled(budgets)) {
    int64_t lhsHard = computeExcess(lhs.maxVGPR, budgets.hardVGPR) +
                      computeExcess(lhs.maxSGPR, budgets.hardSGPR);
    int64_t rhsHard = computeExcess(rhs.maxVGPR, budgets.hardVGPR) +
                      computeExcess(rhs.maxSGPR, budgets.hardSGPR);
    if (lhsHard != rhsHard)
      return lhsHard < rhsHard;
    int64_t lhsCritical = computeExcess(lhs.maxVGPR, budgets.criticalVGPR) +
                          computeExcess(lhs.maxSGPR, budgets.criticalSGPR);
    int64_t rhsCritical = computeExcess(rhs.maxVGPR, budgets.criticalVGPR) +
                          computeExcess(rhs.maxSGPR, budgets.criticalSGPR);
    if (lhsCritical != rhsCritical)
      return lhsCritical < rhsCritical;
  }
  int64_t lhsRank = getBeamResultRank(lhs, budgets, config);
  int64_t rhsRank = getBeamResultRank(rhs, budgets, config);
  if (lhsRank != rhsRank)
    return lhsRank > rhsRank;
  if (isPressureSearchEnabled(budgets)) {
    int64_t lhsPeak = static_cast<int64_t>(lhs.maxVGPR) + lhs.maxSGPR;
    int64_t rhsPeak = static_cast<int64_t>(rhs.maxVGPR) + rhs.maxSGPR;
    if (lhsPeak != rhsPeak)
      return lhsPeak < rhsPeak;
  }
  if (lhs.discrepancies != rhs.discrepancies)
    return lhs.discrepancies < rhs.discrepancies;
  if (lhs.guideOrdinal != rhs.guideOrdinal)
    return lhs.guideOrdinal < rhs.guideOrdinal;
  return isLexicographicallyEarlier(lhs.order, rhs.order);
}

static void pruneBeamChildren(SmallVectorImpl<BeamChild> &children,
                              ArrayRef<BeamState> parents,
                              const RegisterPressureBudgets &budgets,
                              const BeamSearchConfig &config) {
  llvm::sort(children, [&](const BeamChild &lhs, const BeamChild &rhs) {
    return isBetterBeamChild(lhs, rhs, parents, budgets, config);
  });
  if (children.size() > config.width)
    children.resize(config.width);
}

static SmallVector<BeamChild, 32> buildBeamChildren(
    MLIRContext *context, ArrayRef<BeamState> beam, const GraphTables &tables,
    ArrayRef<NodeMetrics> metrics, ArrayRef<unsigned> guide,
    ArrayRef<unsigned> guidePositions, const PressureModel &pressureModel,
    const RegisterPressureBudgets &budgets, const BeamSearchConfig &config) {
  SmallVector<SmallVector<ReadyChoice, 8>, 16> choicesByParent;
  choicesByParent.resize(beam.size());
  auto buildChoices = [&](size_t parentIndex) {
    choicesByParent[parentIndex] =
        getReadyChoices(beam[parentIndex], tables, metrics, guide,
                        guidePositions, pressureModel, budgets, config);
  };
  if (beam.size() >= config.parallelChoiceParentMin)
    parallelFor(context, 0, beam.size(), buildChoices);
  else
    for (size_t parentIndex : llvm::seq<size_t>(0, beam.size()))
      buildChoices(parentIndex);

  SmallVector<BeamChild, 32> children;
  for (auto [parentIndex, choices] : llvm::enumerate(choicesByParent))
    for (const ReadyChoice &choice : choices)
      children.push_back({choice, static_cast<unsigned>(parentIndex)});
  return children;
}

static SmallVector<BeamState, 16>
buildNextBeam(MLIRContext *context, ArrayRef<BeamState> beam,
              ArrayRef<BeamChild> children, const GraphTables &tables,
              ArrayRef<unsigned> guide, const PressureModel &pressureModel,
              const RegisterPressureBudgets &budgets,
              const BeamSearchConfig &config,
              SmallVectorImpl<BeamTrace> &traces) {
  SmallVector<BeamState, 16> nextBeam;
  nextBeam.resize(children.size());
  unsigned traceBase = traces.size();
  traces.resize(traceBase + children.size());
  auto buildState = [&](size_t childIndex) {
    const BeamChild &child = children[childIndex];
    nextBeam[childIndex] = buildNextBeamState(
        beam[child.parent], child.choice, tables, guide, pressureModel, budgets,
        traces, traceBase + childIndex);
  };
  if (children.size() >= config.parallelStateChildMin)
    parallelFor(context, 0, children.size(), buildState);
  else
    for (size_t childIndex : llvm::seq<size_t>(0, children.size()))
      buildState(childIndex);
  return nextBeam;
}

static SmallVector<BeamResult, 8>
runGuidedBeamSearch(MLIRContext *context, const GraphTables &tables,
                    ArrayRef<NodeMetrics> metrics, ArrayRef<unsigned> guide,
                    unsigned guideOrdinal, const PressureModel &pressureModel,
                    const RegisterPressureBudgets &budgets,
                    const BeamSearchConfig &config) {
  SmallVector<unsigned, 16> guidePositions = buildGuidePositions(guide);
  SmallVector<BeamState, 16> beam;
  SmallVector<BeamTrace, 64> traces;
  BeamState initial = makeInitialBeamState(tables, pressureModel);
  initial.guideOrdinal = guideOrdinal;
  beam.push_back(std::move(initial));

  for (unsigned depth : llvm::seq<unsigned>(0, guide.size())) {
    (void)depth;
    SmallVector<BeamChild, 32> children =
        buildBeamChildren(context, beam, tables, metrics, guide, guidePositions,
                          pressureModel, budgets, config);
    if (children.empty())
      break;
    pruneBeamChildren(children, beam, budgets, config);
    beam = buildNextBeam(context, beam, children, tables, guide, pressureModel,
                         budgets, config, traces);
  }

  SmallVector<BeamResult, 8> results;
  for (const BeamState &state : beam) {
    if (state.depth != guide.size())
      continue;
    results.push_back({buildBeamOrder(state, traces), state.rank,
                       state.discrepancies, state.guideOrdinal,
                       state.pressure.maxVGPR, state.pressure.maxSGPR});
  }
  llvm::sort(results, [&](const BeamResult &lhs, const BeamResult &rhs) {
    return isBetterBeamResult(lhs, rhs, budgets, config);
  });
  return results;
}

static bool hasCandidateOrder(ArrayRef<OrderCandidate> candidates,
                              ArrayRef<unsigned> order) {
  for (const OrderCandidate &candidate : candidates)
    if (sameOrder(candidate.order, order))
      return true;
  return false;
}

static bool hasBeamResultOrder(ArrayRef<BeamResult> results,
                               ArrayRef<unsigned> order) {
  for (const BeamResult &result : results)
    if (sameOrder(result.order, order))
      return true;
  return false;
}

} // namespace

void addGuidedBeamCandidates(SmallVectorImpl<OrderCandidate> &candidates,
                             const GraphTables &tables,
                             ArrayRef<NodeMetrics> metrics,
                             const ScheduleRegion &region,
                             const RegisterPressureBudgets &budgets) {
  static constexpr StringLiteral kBeamNames[] = {
      "beam_0", "beam_1", "beam_2", "beam_3",
      "beam_4", "beam_5", "beam_6", "beam_7",
  };

  if (tables.pendingPreds.size() < 3)
    return;

  PressureModel pressureModel;
  if (isPressureSearchEnabled(budgets))
    pressureModel = buildPressureModel(region);

  SmallVector<SmallVector<BeamResult, 8>, 8> perGuideResults;
  perGuideResults.resize(candidates.size());
  MLIRContext *context = region.ops.front()->getContext();
  parallelFor(context, 0, candidates.size(), [&](size_t index) {
    perGuideResults[index] =
        runGuidedBeamSearch(context, tables, metrics, candidates[index].order,
                            static_cast<unsigned>(index), pressureModel,
                            budgets, kDefaultBeamSearchConfig);
  });

  SmallVector<BeamResult, 16> results;
  for (size_t index : llvm::seq<size_t>(0, candidates.size())) {
    ArrayRef<BeamResult> guideResults = perGuideResults[index];
    for (const BeamResult &result : guideResults) {
      if (hasCandidateOrder(candidates, result.order) ||
          hasBeamResultOrder(results, result.order))
        continue;
      results.push_back(result);
    }
  }
  llvm::sort(results, [&](const BeamResult &lhs, const BeamResult &rhs) {
    return isBetterBeamResult(lhs, rhs, budgets, kDefaultBeamSearchConfig);
  });

  unsigned emitted = 0;
  for (const BeamResult &result : results) {
    if (emitted >= kDefaultBeamSearchConfig.candidateLimit ||
        emitted >= std::size(kBeamNames))
      break;
    candidates.push_back({result.order, kBeamNames[emitted]});
    ++emitted;
  }
}

} // namespace mlir::wave
