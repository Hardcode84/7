//===- WaveAMDRegAllocBankPromotion.cpp - Bank promotion -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocInternal.h"

#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
#include <limits>

using namespace mlir;
using namespace mlir::wave::regalloc;

namespace {

static constexpr llvm::StringLiteral kPassName = "waveamd-reg-alloc";
static constexpr llvm::StringLiteral kFixedResultsAttr =
    "waveamdmachine.regalloc_fixed_results";

struct PromotionScore {
  unsigned liveDwords = 0;
  unsigned bridgeCost = 0;
  unsigned end = 0;
};

struct BankPromotionStep {
  IntervalGroup *group = nullptr;
  const wave::WaveAMDPressureReliefPlan *plan = nullptr;
  waveamdmachine::RegClass sourceClass;
  waveamdmachine::RegClass targetClass;
};

static std::optional<waveamdmachine::RegClass>
getNextRegClass(waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return waveamdmachine::RegClass::VGPR;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return waveamdmachine::RegClass::AGPR;
  return std::nullopt;
}

static waveamdmachine::RegType getRegType(Value value,
                                          waveamdmachine::RegClass regClass) {
  auto type = cast<waveamdmachine::RegType>(value.getType());
  return waveamdmachine::RegType::get(type.getContext(), regClass,
                                      type.getWidth(), /*index=*/-1);
}

static std::optional<unsigned> getLaneIndex(IntervalGroup *group,
                                            Interval *interval) {
  for (auto [index, lane] : llvm::enumerate(group->intervals))
    if (lane == interval)
      return index;
  return std::nullopt;
}

static FailureOr<waveamdmachine::RegType>
getAssignedGroupRegType(Value value, IntervalGroup *group,
                        waveamdmachine::RegClass regClass,
                        Inventory &inventory) {
  if (!group || !group->assignedBase)
    return mlir::emitError(value.getLoc(), kPassName)
           << " promoted value has no assigned register";
  Interval *interval = inventory.intervalFor.lookup(value);
  std::optional<unsigned> laneIndex = getLaneIndex(group, interval);
  if (!laneIndex)
    return mlir::emitError(value.getLoc(), kPassName)
           << " promoted value is not in assigned group";
  auto type = cast<waveamdmachine::RegType>(value.getType());
  return waveamdmachine::RegType::get(type.getContext(), regClass,
                                      type.getWidth(),
                                      *group->assignedBase + *laneIndex);
}

static void setRegClass(Value value, waveamdmachine::RegClass regClass) {
  value.setType(getRegType(value, regClass));
}

static bool hasRegClass(Value value, waveamdmachine::RegClass regClass) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  return type && type.getRegClass() == regClass;
}

static unsigned getBudget(RegisterBudgets budgets,
                          waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return budgets.sgpr;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return budgets.vgpr;
  if (regClass == waveamdmachine::RegClass::AGPR)
    return budgets.agpr;
  return 0;
}

static bool intervalsOverlap(Interval *lhs, Interval *rhs) {
  return lhs->start <= rhs->end && rhs->start <= lhs->end;
}

static bool hasIntervalPayload(const Interval &interval) {
  return !interval.values.empty() || interval.reserved || interval.plannedTemp;
}

static bool hasIntervalPayload(const Interval *interval) {
  return interval && hasIntervalPayload(*interval);
}

static bool
isAllowedKernargPreloadValue(waveamdmachine::RegType type, unsigned phys,
                             const wave::WaveAMDKernelEntryRegs &regs) {
  if (type.getRegClass() != waveamdmachine::RegClass::SGPR)
    return false;
  unsigned begin = phys;
  unsigned end = begin + type.getWidth();
  unsigned preloadBegin = regs.kernargSegmentPtrWidth;
  unsigned preloadEnd = preloadBegin + regs.kernargPreloadDwords;
  return preloadBegin <= begin && end <= preloadEnd;
}

static bool
isAllowedReservedVGPRValue(Operation *def, waveamdmachine::RegType type,
                           unsigned phys,
                           const wave::WaveAMDKernelEntryRegs &regs) {
  return type.getRegClass() == waveamdmachine::RegClass::VGPR &&
         isa<waveamdmachine::VWorkitemIdXOp>(def) &&
         phys == regs.workitemIdXVGPR;
}

static bool
isAllowedReservedWorkgroupId(Operation *def, unsigned phys,
                             const wave::WaveAMDKernelEntryRegs &regs) {
  if (isa<waveamdmachine::SWorkgroupIdXOp>(def))
    return phys == regs.workgroupIdSGPR(0);
  if (isa<waveamdmachine::SWorkgroupIdYOp>(def))
    return phys == regs.workgroupIdSGPR(1);
  if (isa<waveamdmachine::SWorkgroupIdZOp>(def))
    return phys == regs.workgroupIdSGPR(2);
  return false;
}

static bool
isAllowedReservedSGPRValue(Operation *def, waveamdmachine::RegType type,
                           unsigned phys,
                           const wave::WaveAMDKernelEntryRegs &regs) {
  if (type.getRegClass() != waveamdmachine::RegClass::SGPR)
    return false;
  if (isa<waveamdmachine::KernargPreloadOp>(def))
    return isAllowedKernargPreloadValue(type, phys, regs);
  return isAllowedReservedWorkgroupId(def, phys, regs);
}

static bool
canValueOverlapReservedLane(Value value, unsigned phys,
                            const wave::WaveAMDKernelEntryRegs &regs) {
  auto type = cast<waveamdmachine::RegType>(value.getType());
  Operation *def = value.getDefiningOp();
  if (!def || type.getIndex() < 0)
    return false;
  unsigned index = static_cast<unsigned>(type.getIndex());
  unsigned width = static_cast<unsigned>(type.getWidth());
  if (phys < index || phys - index >= width)
    return false;
  return isAllowedReservedVGPRValue(def, type, phys, regs) ||
         isAllowedReservedSGPRValue(def, type, index, regs);
}

static bool canOverlapReservedLane(Interval *lane, unsigned phys,
                                   const wave::WaveAMDKernelEntryRegs &regs) {
  return !lane->values.empty() && llvm::all_of(lane->values, [&](Value value) {
    return canValueOverlapReservedLane(value, phys, regs);
  });
}

static bool
canOverlapFixedPlannedTemp(Interval *lane, Interval *otherLane, unsigned phys,
                           const wave::WaveAMDKernelEntryRegs &regs) {
  if (!lane->plannedTemp)
    return false;
  if (lane->type.getIndex() < 0 || lane->type.getIndex() != phys)
    return false;
  if (canOverlapReservedLane(otherLane, phys, regs))
    return true;
  if (otherLane->reserved)
    return true;
  if (!otherLane->plannedTemp)
    return false;
  return lane->type.getIndex() == otherLane->type.getIndex();
}

static bool lanesCanOverlap(Interval *lane, Interval *otherLane, unsigned phys,
                            const wave::WaveAMDKernelEntryRegs &regs) {
  if (canOverlapFixedPlannedTemp(lane, otherLane, phys, regs) ||
      canOverlapFixedPlannedTemp(otherLane, lane, phys, regs))
    return true;
  if (lane->reserved && canOverlapReservedLane(otherLane, phys, regs))
    return true;
  if (otherLane->reserved && canOverlapReservedLane(lane, phys, regs))
    return true;
  return false;
}

static bool laneBlocksPhys(Interval *lane, Interval *otherLane, unsigned phys,
                           const wave::WaveAMDKernelEntryRegs &regs) {
  if (!hasIntervalPayload(otherLane))
    return false;
  if (lanesCanOverlap(lane, otherLane, phys, regs))
    return false;
  return intervalsOverlap(lane, otherLane);
}

struct AssignedLaneRef {
  IntervalGroup *group = nullptr;
  Interval *lane = nullptr;
  unsigned phys = 0;
  unsigned start = 0;
  unsigned end = 0;
};

struct AssignedLaneBucket {
  SmallVector<AssignedLaneRef, 4> lanes;
  SmallVector<unsigned, 4> prefixMaxEnds;

  void add(AssignedLaneRef ref) {
    auto it = std::lower_bound(lanes.begin(), lanes.end(), ref.start,
                               [](const AssignedLaneRef &lhs, unsigned start) {
                                 return lhs.start < start;
                               });
    size_t index = it - lanes.begin();
    lanes.insert(it, ref);
    prefixMaxEnds.insert(prefixMaxEnds.begin() + index, ref.end);

    unsigned maxEnd = index == 0 ? 0 : prefixMaxEnds[index - 1];
    for (size_t i : llvm::seq<size_t>(index, lanes.size())) {
      maxEnd = std::max(maxEnd, lanes[i].end);
      prefixMaxEnds[i] = maxEnd;
    }
  }

  std::pair<size_t, size_t> getCandidateRange(Interval *lane) const {
    auto lastIt =
        std::upper_bound(lanes.begin(), lanes.end(), lane->end,
                         [](unsigned end, const AssignedLaneRef &ref) {
                           return end < ref.start;
                         });
    size_t last = lastIt - lanes.begin();
    auto firstIt = std::lower_bound(prefixMaxEnds.begin(),
                                    prefixMaxEnds.begin() + last, lane->start);
    return {static_cast<size_t>(firstIt - prefixMaxEnds.begin()), last};
  }
};

struct AssignedRegisterClassIndex {
  SmallVector<AssignedLaneBucket, 0> buckets;

  AssignedLaneBucket &get(unsigned phys) {
    if (phys >= buckets.size())
      buckets.resize(phys + 1);
    return buckets[phys];
  }

  const AssignedLaneBucket *lookup(unsigned phys) const {
    if (phys >= buckets.size())
      return nullptr;
    return &buckets[phys];
  }
};

struct AssignedRegisterIndex {
  AssignedRegisterClassIndex sgpr;
  AssignedRegisterClassIndex vgpr;
  AssignedRegisterClassIndex agpr;
};

static AssignedRegisterClassIndex *
getAssignedClassIndex(AssignedRegisterIndex &index,
                      waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return &index.sgpr;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return &index.vgpr;
  if (regClass == waveamdmachine::RegClass::AGPR)
    return &index.agpr;
  return nullptr;
}

static const AssignedRegisterClassIndex *
getAssignedClassIndex(const AssignedRegisterIndex &index,
                      waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return &index.sgpr;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return &index.vgpr;
  if (regClass == waveamdmachine::RegClass::AGPR)
    return &index.agpr;
  return nullptr;
}

static bool hasAssignedLanePayload(Interval *lane) {
  return hasIntervalPayload(lane);
}

static void addAssignedLane(AssignedRegisterIndex &index, IntervalGroup *group,
                            unsigned laneIndex) {
  if (!group->assignedBase)
    return;
  Interval *lane = group->intervals[laneIndex];
  if (!hasAssignedLanePayload(lane))
    return;
  AssignedRegisterClassIndex *classIndex =
      getAssignedClassIndex(index, group->storageClass);
  if (!classIndex)
    return;
  unsigned phys = *group->assignedBase + laneIndex;
  classIndex->get(phys).add({group, lane, phys, lane->start, lane->end});
}

static void addAssignedGroup(AssignedRegisterIndex &index,
                             IntervalGroup *group) {
  if (!group || !group->assignedBase)
    return;
  for (unsigned laneIndex : llvm::seq<unsigned>(0, group->intervals.size()))
    addAssignedLane(index, group, laneIndex);
}

static AssignedRegisterIndex
buildAssignedRegisterIndex(ArrayRef<IntervalGroup *> assigned) {
  AssignedRegisterIndex index;
  for (IntervalGroup *group : assigned)
    addAssignedGroup(index, group);
  return index;
}

static bool laneConflictsWithGroup(Interval *lane, unsigned phys,
                                   const AssignedLaneRef &other,
                                   const wave::WaveAMDKernelEntryRegs &regs) {
  if (other.group == lane->group || other.phys != phys)
    return false;
  return laneBlocksPhys(lane, other.lane, phys, regs);
}

static bool
laneConflictsWithAssigned(Interval *lane, unsigned phys, IntervalGroup *group,
                          const AssignedRegisterIndex &assigned,
                          const wave::WaveAMDKernelEntryRegs &regs) {
  const AssignedRegisterClassIndex *classIndex =
      getAssignedClassIndex(assigned, group->storageClass);
  if (!classIndex)
    return false;
  const AssignedLaneBucket *bucket = classIndex->lookup(phys);
  if (!bucket)
    return false;

  auto [first, last] = bucket->getCandidateRange(lane);
  for (size_t i : llvm::seq<size_t>(first, last)) {
    const AssignedLaneRef &other = bucket->lanes[i];
    if (laneConflictsWithGroup(lane, phys, other, regs))
      return true;
  }
  return false;
}

static bool baseFits(IntervalGroup *group, unsigned base,
                     const AssignedRegisterIndex &assigned,
                     const wave::WaveAMDKernelEntryRegs &regs) {
  for (auto [laneIndex, lane] : llvm::enumerate(group->intervals)) {
    if (!hasAssignedLanePayload(lane))
      continue;
    if (laneConflictsWithAssigned(lane, base + laneIndex, group, assigned,
                                  regs))
      return false;
  }
  return true;
}

static std::optional<unsigned>
findFreeBase(IntervalGroup *group, RegisterBudgets budgets,
             ArrayRef<IntervalGroup *> assigned,
             const wave::WaveAMDKernelEntryRegs &regs) {
  AssignedRegisterIndex index = buildAssignedRegisterIndex(assigned);
  unsigned width = group->intervals.size();
  unsigned budget = getBudget(budgets, group->storageClass);
  if (width == 0 || width > budget)
    return std::nullopt;
  unsigned align = std::max<unsigned>(1, llvm::PowerOf2Ceil(width));
  for (unsigned base = 0; base <= budget - width; base += align)
    if (baseFits(group, base, index, regs))
      return base;
  return std::nullopt;
}

static bool isLiveAt(Interval *interval, unsigned position) {
  if (!hasIntervalPayload(interval))
    return false;
  return interval->start <= position && position <= interval->end;
}

static bool isLiveAt(IntervalGroup *group, unsigned position) {
  return group && llvm::any_of(group->intervals, [&](Interval *lane) {
           return isLiveAt(lane, position);
         });
}

static unsigned getGroupEnd(IntervalGroup *group) {
  unsigned end = 0;
  for (Interval *lane : group->intervals)
    if (hasIntervalPayload(lane))
      end = std::max(end, lane->end);
  return end;
}

static unsigned getGroupLiveDwords(IntervalGroup *group, unsigned position) {
  unsigned live = 0;
  for (Interval *lane : group->intervals)
    if (isLiveAt(lane, position))
      ++live;
  return live;
}

static waveamdmachine::MMAOpInterface getMFMA(Operation *op) {
  waveamdmachine::MMAOpInterface mma =
      dyn_cast_if_present<waveamdmachine::MMAOpInterface>(op);
  if (!mma || !op->hasTrait<OpTrait::waveamdmachine::MFMAOp>())
    return {};
  return mma;
}

static bool isMFMAInputUse(waveamdmachine::MMAOpInterface mfma,
                           OpOperand &use) {
  return &use == &mfma.getAMutable() || &use == &mfma.getBMutable();
}

static bool isMFMAAccumulatorUse(waveamdmachine::MMAOpInterface mfma,
                                 OpOperand &use) {
  return &use == &mfma.getAccMutable();
}

static bool canMFMAAccumulateInAGPR(waveamdmachine::MMAOpInterface mfma) {
  waveamdmachine::RegType resultType =
      dyn_cast<waveamdmachine::RegType>(mfma.getAccResult().getType());
  return resultType &&
         resultType.getRegClass() == waveamdmachine::RegClass::AGPR;
}

static bool canDefineAGPR(Value value) {
  if (isa<BlockArgument>(value))
    return true;
  Operation *def = value.getDefiningOp();
  if (!def)
    return false;
  return isa<waveamdmachine::UninitOp, waveamdmachine::UniformLoopOp>(def) ||
         getMFMA(def);
}

static bool canConsumeAGPR(OpOperand &use) {
  Operation *user = use.getOwner();
  if (waveamdmachine::MMAOpInterface mfma = getMFMA(user)) {
    if (isMFMAInputUse(mfma, use))
      return true;
    if (isMFMAAccumulatorUse(mfma, use))
      return canMFMAAccumulateInAGPR(mfma);
  }
  if (isa<waveamdmachine::UniformLoopOp, waveamdmachine::ContinueIfOp>(user))
    return true;
  if (isa<waveamdmachine::VAccvgprReadB32TupleOp>(user))
    return use.getOperandNumber() == 0;
  return false;
}

static SmallVector<Value> getGroupValues(IntervalGroup *group) {
  llvm::SmallDenseSet<Value, 8> seen;
  SmallVector<Value> values;
  for (Interval *lane : group->intervals) {
    for (Value value : lane->values) {
      if (seen.insert(value).second)
        values.push_back(value);
    }
  }
  return values;
}

static bool groupContainsBlockArgument(IntervalGroup *group) {
  for (Value value : getGroupValues(group))
    if (isa<BlockArgument>(value))
      return true;
  return false;
}

static bool groupHasNonPromotableLane(IntervalGroup *group) {
  for (Interval *lane : group->intervals)
    if (lane->nonPromotable)
      return true;
  return false;
}

static bool hasTempAGPRWriteUse(IntervalGroup *group) {
  for (Value value : getGroupValues(group)) {
    for (OpOperand &use : value.getUses()) {
      auto write =
          dyn_cast<waveamdmachine::VAccvgprWriteB32TupleOp>(use.getOwner());
      if (write && use.getOperandNumber() == 0 && isRegAllocTempOp(write))
        return true;
    }
  }
  return false;
}

static bool canPromoteToVGPR(IntervalGroup *group) {
  if (group->intervals.size() != 1)
    return false;
  return !groupContainsBlockArgument(group);
}

static bool canPromoteToAGPR(IntervalGroup *group, RegisterBudgets budgets) {
  if (budgets.agprCountsAgainstVGPRs && budgets.combinedPlacementVGPRLimit)
    return false;
  return !hasTempAGPRWriteUse(group);
}

static bool canPromote(IntervalGroup *group, RegisterBudgets budgets) {
  if (group->nonPromotable || isFixedRegisterGroup(group))
    return false;
  if (groupHasNonPromotableLane(group))
    return false;
  std::optional<waveamdmachine::RegClass> next =
      getNextRegClass(group->storageClass);
  if (!next || getBudget(budgets, *next) < group->intervals.size())
    return false;
  if (*next == waveamdmachine::RegClass::VGPR)
    return canPromoteToVGPR(group);
  if (*next == waveamdmachine::RegClass::AGPR)
    return canPromoteToAGPR(group, budgets);
  return false;
}

static bool canFitPromotionTarget(IntervalGroup *group,
                                  ArrayRef<IntervalGroup *> assigned,
                                  RegisterBudgets budgets,
                                  const wave::WaveAMDKernelEntryRegs &regs) {
  std::optional<waveamdmachine::RegClass> next =
      getNextRegClass(group->storageClass);
  if (!next)
    return false;
  waveamdmachine::RegClass original = group->storageClass;
  std::optional<unsigned> originalBase = group->assignedBase;
  group->storageClass = *next;
  group->assignedBase.reset();
  bool fits = findFreeBase(group, budgets, assigned, regs).has_value();
  group->storageClass = original;
  group->assignedBase = originalBase;
  return fits;
}

static bool valueInGroup(Value value, IntervalGroup *group,
                         Inventory &inventory) {
  Interval *interval = inventory.intervalFor.lookup(value);
  return interval && interval->group == group;
}

static unsigned getBridgeWeight(Operation *op) {
  unsigned depth = getLoopDepth(op);
  if (depth == 0)
    return 1;
  return 1u << std::min<unsigned>(depth * 4, 20);
}

static bool isTupleAliasOp(Operation *op) {
  return isa_and_nonnull<waveamdmachine::TupleToElementsOp,
                         waveamdmachine::TupleFromElementsOp>(op);
}

static bool canRebankTupleAliasValue(Value value, IntervalGroup *group,
                                     Inventory &inventory) {
  if (!isa<waveamdmachine::RegType>(value.getType()))
    return false;
  return valueInGroup(value, group, inventory);
}

static bool canRebankTupleAliasOp(Operation *op, IntervalGroup *group,
                                  Inventory &inventory) {
  if (!isTupleAliasOp(op))
    return false;
  if (!llvm::all_of(op->getOperands(), [&](Value value) {
        return canRebankTupleAliasValue(value, group, inventory);
      }))
    return false;
  return llvm::all_of(op->getResults(), [&](Value value) {
    return canRebankTupleAliasValue(value, group, inventory);
  });
}

static bool canConsumeAGPRAfterPromotion(OpOperand &use, IntervalGroup *group,
                                         Inventory &inventory) {
  if (canConsumeAGPR(use))
    return true;

  Operation *user = use.getOwner();
  if (isTupleAliasOp(user))
    return canRebankTupleAliasOp(user, group, inventory);

  if (waveamdmachine::MMAOpInterface mfma = getMFMA(user))
    if (isMFMAAccumulatorUse(mfma, use))
      return valueInGroup(mfma.getAccResult(), group, inventory);

  return false;
}

static unsigned estimateAGPRBridgeCost(IntervalGroup *group,
                                       Inventory &inventory) {
  unsigned cost = 0;
  for (Value value : getGroupValues(group)) {
    Operation *def = value.getDefiningOp();
    if (def && !canDefineAGPR(value) &&
        !canRebankTupleAliasOp(def, group, inventory))
      cost += getBridgeWeight(def);
    for (OpOperand &use : value.getUses()) {
      if (isa<waveamdmachine::VAccvgprWriteB32TupleOp>(use.getOwner()))
        continue;
      if (!canConsumeAGPRAfterPromotion(use, group, inventory))
        cost += getBridgeWeight(use.getOwner());
    }
  }
  return cost;
}

static unsigned estimateSGPRBridgeCost(IntervalGroup *group) {
  unsigned cost = 0;
  for (Value value : getGroupValues(group)) {
    ++cost;
    cost += llvm::range_size(value.getUses());
  }
  return cost;
}

static unsigned estimatePromotionBridgeCost(IntervalGroup *group,
                                            Inventory &inventory) {
  std::optional<waveamdmachine::RegClass> next =
      getNextRegClass(group->storageClass);
  if (!next)
    return std::numeric_limits<unsigned>::max();
  if (*next == waveamdmachine::RegClass::AGPR)
    return estimateAGPRBridgeCost(group, inventory);
  if (*next == waveamdmachine::RegClass::VGPR)
    return estimateSGPRBridgeCost(group);
  return std::numeric_limits<unsigned>::max();
}

static PromotionScore getPromotionScore(IntervalGroup *group, unsigned position,
                                        Inventory &inventory) {
  return {getGroupLiveDwords(group, position),
          estimatePromotionBridgeCost(group, inventory), getGroupEnd(group)};
}

static bool isBetterPromotionScore(PromotionScore lhs, PromotionScore rhs) {
  if (lhs.bridgeCost != rhs.bridgeCost)
    return lhs.bridgeCost < rhs.bridgeCost;
  if (lhs.liveDwords != rhs.liveDwords)
    return lhs.liveDwords > rhs.liveDwords;
  return lhs.end > rhs.end;
}

static FailureOr<Value>
materializeAGPRDef(Value value, waveamdmachine::RegType agprType,
                   bool sourceNeedsTemp,
                   const wave::WaveAMDPressureReliefPlan &plan,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder) {
  if (hasRegClass(value, waveamdmachine::RegClass::AGPR)) {
    value.setType(agprType);
    return value;
  }
  if (isa<BlockArgument>(value)) {
    value.setType(agprType);
    return value;
  }
  Operation *def = value.getDefiningOp();
  if (canDefineAGPR(value)) {
    value.setType(agprType);
    return value;
  }
  if (sourceNeedsTemp) {
    auto sourceType = cast<waveamdmachine::RegType>(value.getType());
    FailureOr<waveamdmachine::RegType> tempType =
        consumePressureReliefTempRegType(plan, context,
                                         sourceType.getRegClass(),
                                         sourceType.getWidth(), def);
    if (failed(tempType))
      return failure();
    value.setType(*tempType);
  }
  builder.setInsertionPointAfter(def);
  auto write = waveamdmachine::VAccvgprWriteB32TupleOp::create(
      builder, def->getLoc(), agprType, value);
  write->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
  return write.getResult();
}

static bool rebankTupleToElements(waveamdmachine::TupleToElementsOp split,
                                  waveamdmachine::RegClass regClass) {
  waveamdmachine::RegType tupleType =
      cast<waveamdmachine::RegType>(split.getTuple().getType());
  if (tupleType.getRegClass() != regClass || tupleType.getIndex() < 0)
    return false;
  unsigned offset = 0;
  for (Value element : split.getElements()) {
    auto elementType = dyn_cast<waveamdmachine::RegType>(element.getType());
    if (!elementType)
      return true;
    unsigned width = static_cast<unsigned>(elementType.getWidth());
    if (offset + width > static_cast<unsigned>(tupleType.getWidth()))
      return true;
    element.setType(
        waveamdmachine::RegType::get(tupleType.getContext(), regClass, width,
                                     tupleType.getIndex() + offset));
    offset += width;
  }
  return true;
}

static bool rebankTupleFromElements(waveamdmachine::TupleFromElementsOp join,
                                    waveamdmachine::RegClass regClass) {
  auto resultType =
      dyn_cast<waveamdmachine::RegType>(join.getTuple().getType());
  if (!resultType || join.getElements().empty())
    return false;
  auto firstType =
      dyn_cast<waveamdmachine::RegType>(join.getElements().front().getType());
  if (firstType && firstType.getRegClass() == regClass &&
      firstType.getIndex() >= 0)
    join.getTuple().setType(waveamdmachine::RegType::get(
        resultType.getContext(), regClass, resultType.getWidth(),
        firstType.getIndex()));
  return true;
}

static void rebankTupleAliasResults(Operation *op,
                                    waveamdmachine::RegClass regClass) {
  if (auto split = dyn_cast<waveamdmachine::TupleToElementsOp>(op))
    if (rebankTupleToElements(split, regClass))
      return;
  if (auto join = dyn_cast<waveamdmachine::TupleFromElementsOp>(op))
    if (rebankTupleFromElements(join, regClass))
      return;
  for (Value value : op->getResults())
    setRegClass(value, regClass);
}

static bool hasTupleAliasResultClass(Operation *op,
                                     waveamdmachine::RegClass regClass) {
  if (!isTupleAliasOp(op))
    return false;
  return llvm::all_of(op->getResults(), [&](Value value) {
    return hasRegClass(value, regClass);
  });
}

static void collectTupleAliasesToRebank(IntervalGroup *group,
                                        Inventory &inventory,
                                        SmallVectorImpl<Operation *> &aliases) {
  llvm::SmallDenseSet<Operation *, 8> seen;
  for (Value value : getGroupValues(group)) {
    if (Operation *def = value.getDefiningOp())
      if (canRebankTupleAliasOp(def, group, inventory) &&
          seen.insert(def).second)
        aliases.push_back(def);
    for (OpOperand &use : value.getUses()) {
      Operation *user = use.getOwner();
      if (canRebankTupleAliasOp(user, group, inventory) &&
          seen.insert(user).second)
        aliases.push_back(user);
    }
  }
}

static void rebankPromotedTupleAliases(IntervalGroup *group,
                                       Inventory &inventory,
                                       waveamdmachine::RegClass regClass) {
  SmallVector<Operation *> aliases;
  collectTupleAliasesToRebank(group, inventory, aliases);
  llvm::sort(aliases, [&](Operation *lhs, Operation *rhs) {
    return inventory.positions.lookup(lhs) < inventory.positions.lookup(rhs);
  });
  for (Operation *op : aliases)
    rebankTupleAliasResults(op, regClass);
}

static FailureOr<Value>
getAGPRReplacement(Value value, IntervalGroup *group,
                   DenseMap<Value, Value> &replacements, Inventory &inventory,
                   const wave::WaveAMDPressureReliefPlan &plan,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder) {
  if (Value existing = replacements.lookup(value))
    return existing;
  FailureOr<waveamdmachine::RegType> agprType = getAssignedGroupRegType(
      value, group, waveamdmachine::RegClass::AGPR, inventory);
  if (failed(agprType))
    return failure();
  if (Operation *def = value.getDefiningOp())
    if (canRebankTupleAliasOp(def, group, inventory)) {
      value.setType(*agprType);
      rebankTupleAliasResults(def, waveamdmachine::RegClass::AGPR);
      replacements[value] = value;
      return value;
    }
  bool sourceNeedsTemp = !isa<BlockArgument>(value) && !canDefineAGPR(value);
  FailureOr<Value> replacement = materializeAGPRDef(
      value, *agprType, sourceNeedsTemp, plan, context, builder);
  if (failed(replacement))
    return failure();
  replacements[value] = *replacement;
  return *replacement;
}

static bool
foldAGPRWriteIntoReplacement(waveamdmachine::VAccvgprWriteB32TupleOp write,
                             Value agpr) {
  if (write.getResult() == agpr)
    return false;
  auto writeType = cast<waveamdmachine::RegType>(write.getResult().getType());
  DenseI64ArrayAttr fixedResults =
      write->getAttrOfType<DenseI64ArrayAttr>(kFixedResultsAttr);
  bool authoredFixed =
      fixedResults && llvm::is_contained(fixedResults.asArrayRef(), int64_t{0});
  if (writeType.getIndex() >= 0 && authoredFixed)
    agpr.setType(writeType);
  for (OpOperand &use : write.getResult().getUses()) {
    Operation *user = use.getOwner();
    waveamdmachine::MMAOpInterface mfma = getMFMA(user);
    if (!mfma || !isMFMAAccumulatorUse(mfma, use))
      continue;
    mfma.getAccResult().setType(agpr.getType());
    mfma.setAcc(agpr);
  }
  write.getResult().replaceAllUsesWith(agpr);
  return true;
}

static FailureOr<Value>
createAGPRReadForUse(Value agpr, Operation *user,
                     const wave::WaveAMDPressureReliefPlan &plan,
                     wave::WaveAMDPressureReliefMaterializationContext &context,
                     OpBuilder &builder) {
  builder.setInsertionPoint(user);
  waveamdmachine::RegType agprType =
      cast<waveamdmachine::RegType>(agpr.getType());
  FailureOr<waveamdmachine::RegType> readType =
      consumePressureReliefTempRegType(plan, context,
                                       waveamdmachine::RegClass::VGPR,
                                       agprType.getWidth(), user);
  if (failed(readType))
    return failure();
  auto read = waveamdmachine::VAccvgprReadB32TupleOp::create(
      builder, user->getLoc(), *readType, agpr);
  read->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
  return read.getResult();
}

static FailureOr<bool> rewritePromotedAGPRWriteUse(
    OpOperand *use, Value agpr, const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder, SmallVectorImpl<Operation *> &deadWrites) {
  auto write =
      dyn_cast<waveamdmachine::VAccvgprWriteB32TupleOp>(use->getOwner());
  if (!write)
    return false;
  if (write.getResult() == agpr)
    return true;
  if (foldAGPRWriteIntoReplacement(write, agpr)) {
    deadWrites.push_back(write);
    return true;
  }
  FailureOr<Value> read =
      createAGPRReadForUse(agpr, write, plan, context, builder);
  if (failed(read))
    return failure();
  use->set(*read);
  return true;
}

static bool rewritePromotedAGPRAliasUse(OpOperand *use, Value agpr,
                                        IntervalGroup *group,
                                        Inventory &inventory) {
  Operation *user = use->getOwner();
  if (isTupleAliasOp(user) || canRebankTupleAliasOp(user, group, inventory)) {
    use->set(agpr);
    rebankTupleAliasResults(user, waveamdmachine::RegClass::AGPR);
    return true;
  }
  if (!hasTupleAliasResultClass(user, waveamdmachine::RegClass::AGPR))
    return false;
  use->set(agpr);
  rebankTupleAliasResults(user, waveamdmachine::RegClass::AGPR);
  return true;
}

static FailureOr<bool> rewritePromotedAGPRMFMAUse(OpOperand *use, Value agpr,
                                                  IntervalGroup *group,
                                                  Inventory &inventory) {
  Operation *user = use->getOwner();
  waveamdmachine::MMAOpInterface mfma = getMFMA(user);
  if (!mfma || !isMFMAAccumulatorUse(mfma, *use) ||
      !valueInGroup(mfma.getAccResult(), group, inventory))
    return false;
  FailureOr<waveamdmachine::RegType> resultType = getAssignedGroupRegType(
      mfma.getAccResult(), group, waveamdmachine::RegClass::AGPR, inventory);
  if (failed(resultType))
    return failure();
  mfma.getAccResult().setType(*resultType);
  mfma.setAcc(agpr);
  return true;
}

static LogicalResult rewritePromotedAGPRUse(
    OpOperand *use, Value agpr, IntervalGroup *group, Inventory &inventory,
    const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder, SmallVectorImpl<Operation *> &deadWrites) {
  Operation *user = use->getOwner();
  FailureOr<bool> handledWrite = rewritePromotedAGPRWriteUse(
      use, agpr, plan, context, builder, deadWrites);
  if (failed(handledWrite))
    return failure();
  if (*handledWrite)
    return success();
  if (rewritePromotedAGPRAliasUse(use, agpr, group, inventory))
    return success();
  FailureOr<bool> handledMFMA =
      rewritePromotedAGPRMFMAUse(use, agpr, group, inventory);
  if (failed(handledMFMA))
    return failure();
  if (*handledMFMA)
    return success();
  if (canConsumeAGPR(*use)) {
    use->set(agpr);
    return success();
  }
  FailureOr<Value> read =
      createAGPRReadForUse(agpr, user, plan, context, builder);
  if (failed(read))
    return failure();
  use->set(*read);
  return success();
}

static LogicalResult rewritePromotedAGPRUses(
    Value original, Value agpr, IntervalGroup *group, Inventory &inventory,
    const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder) {
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : original.getUses())
    uses.push_back(&use);
  SmallVector<Operation *> deadWrites;
  for (OpOperand *use : uses) {
    if (use->get() != original)
      continue;
    if (failed(rewritePromotedAGPRUse(use, agpr, group, inventory, plan,
                                      context, builder, deadWrites)))
      return failure();
  }
  for (Operation *write : deadWrites)
    write->erase();
  return success();
}

static LogicalResult materializeAGPRPromotion(
    IntervalGroup *group, Inventory &inventory,
    const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder) {
  rebankPromotedTupleAliases(group, inventory, waveamdmachine::RegClass::AGPR);
  DenseMap<Value, Value> replacements;
  SmallVector<Value> values = getGroupValues(group);
  for (Value value : values) {
    FailureOr<Value> replacement = getAGPRReplacement(
        value, group, replacements, inventory, plan, context, builder);
    if (failed(replacement))
      return failure();
    if (failed(rewritePromotedAGPRUses(value, *replacement, group, inventory,
                                       plan, context, builder)))
      return failure();
  }
  return success();
}

static FailureOr<Value>
materializeVGPRDef(Value value, waveamdmachine::RegType resultType,
                   const wave::WaveAMDPressureReliefPlan &plan,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder) {
  Operation *def = value.getDefiningOp();
  auto sourceType = cast<waveamdmachine::RegType>(value.getType());
  FailureOr<waveamdmachine::RegType> tempType =
      consumePressureReliefTempRegType(plan, context, sourceType.getRegClass(),
                                       sourceType.getWidth(), def);
  if (failed(tempType))
    return failure();
  value.setType(*tempType);
  builder.setInsertionPointAfter(def);
  auto mov = waveamdmachine::VMovB32TupleOp::create(builder, def->getLoc(),
                                                    resultType, value);
  mov->setAttr("registers", builder.getI64IntegerAttr(1));
  mov->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
  return mov.getResult();
}

static FailureOr<Value>
getVGPRReplacement(Value value, waveamdmachine::RegType resultType,
                   DenseMap<Value, Value> &replacements,
                   const wave::WaveAMDPressureReliefPlan &plan,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder) {
  if (Value existing = replacements.lookup(value))
    return existing;
  FailureOr<Value> replacement =
      materializeVGPRDef(value, resultType, plan, context, builder);
  if (failed(replacement))
    return failure();
  replacements[value] = *replacement;
  return *replacement;
}

static LogicalResult rewritePromotedSGPRUses(
    Value original, Value vgpr, const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder) {
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : original.getUses())
    uses.push_back(&use);
  for (OpOperand *use : uses) {
    if (use->get() != original || use->getOwner() == vgpr.getDefiningOp())
      continue;
    builder.setInsertionPoint(use->getOwner());
    waveamdmachine::RegType originalType =
        cast<waveamdmachine::RegType>(original.getType());
    FailureOr<waveamdmachine::RegType> readType =
        consumePressureReliefTempRegType(
            plan, context, waveamdmachine::RegClass::SGPR,
            originalType.getWidth(), use->getOwner());
    if (failed(readType))
      return failure();
    auto read = waveamdmachine::VReadfirstlaneB32Op::create(
        builder, use->getOwner()->getLoc(), *readType, vgpr);
    read->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    use->set(read.getResult());
  }
  return success();
}

static LogicalResult rewritePromotedSGPRToAGPRUses(
    Value original, Value vgpr, Value agpr,
    const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder) {
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : original.getUses())
    uses.push_back(&use);
  for (OpOperand *use : uses) {
    if (use->get() != original || use->getOwner() == vgpr.getDefiningOp())
      continue;
    Operation *user = use->getOwner();
    builder.setInsertionPoint(user);
    waveamdmachine::RegType agprType =
        cast<waveamdmachine::RegType>(agpr.getType());
    FailureOr<waveamdmachine::RegType> readType =
        consumePressureReliefTempRegType(plan, context,
                                         waveamdmachine::RegClass::VGPR,
                                         agprType.getWidth(), user);
    if (failed(readType))
      return failure();
    auto read = waveamdmachine::VAccvgprReadB32TupleOp::create(
        builder, user->getLoc(), *readType, agpr);
    read->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    waveamdmachine::RegType originalType =
        cast<waveamdmachine::RegType>(original.getType());
    FailureOr<waveamdmachine::RegType> firstType =
        consumePressureReliefTempRegType(plan, context,
                                         waveamdmachine::RegClass::SGPR,
                                         originalType.getWidth(), user);
    if (failed(firstType))
      return failure();
    auto first = waveamdmachine::VReadfirstlaneB32Op::create(
        builder, user->getLoc(), *firstType, read.getResult());
    first->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    use->set(first.getResult());
  }
  return success();
}

static LogicalResult materializeSGPRPromotion(
    IntervalGroup *group, Inventory &inventory,
    const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder) {
  DenseMap<Value, Value> replacements;
  SmallVector<Value> values = getGroupValues(group);
  for (Value value : values) {
    if (isa<BlockArgument>(value))
      return mlir::emitError(value.getLoc(), kPassName)
             << " cannot promote block arguments before bridge insertion";
    if (cast<waveamdmachine::RegType>(value.getType()).getWidth() != 1)
      return mlir::emitError(value.getLoc(), kPassName)
             << " SGPR promotion supports only width-1 values";
    FailureOr<waveamdmachine::RegType> vgprType = getAssignedGroupRegType(
        value, group, waveamdmachine::RegClass::VGPR, inventory);
    if (failed(vgprType))
      return failure();
    FailureOr<Value> replacement = getVGPRReplacement(
        value, *vgprType, replacements, plan, context, builder);
    if (failed(replacement))
      return failure();
    if (failed(rewritePromotedSGPRUses(value, *replacement, plan, context,
                                       builder)))
      return failure();
  }
  return success();
}

static LogicalResult materializeSGPRToAGPRPromotion(
    IntervalGroup *group, Inventory &inventory,
    const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder) {
  DenseMap<Value, Value> vgprReplacements;
  DenseMap<Value, Value> agprReplacements;
  SmallVector<Value> values = getGroupValues(group);
  for (Value value : values) {
    if (isa<BlockArgument>(value))
      return mlir::emitError(value.getLoc(), kPassName)
             << " cannot promote block arguments before bridge insertion";
    if (cast<waveamdmachine::RegType>(value.getType()).getWidth() != 1)
      return mlir::emitError(value.getLoc(), kPassName)
             << " SGPR promotion supports only width-1 values";
    Operation *def = value.getDefiningOp();
    auto sourceType = cast<waveamdmachine::RegType>(value.getType());
    FailureOr<waveamdmachine::RegType> sourceTempType =
        consumePressureReliefTempRegType(plan, context,
                                         waveamdmachine::RegClass::SGPR,
                                         sourceType.getWidth(), def);
    if (failed(sourceTempType))
      return failure();
    value.setType(*sourceTempType);
    FailureOr<waveamdmachine::RegType> vgprType =
        consumePressureReliefTempRegType(plan, context,
                                         waveamdmachine::RegClass::VGPR,
                                         sourceType.getWidth(), def);
    if (failed(vgprType))
      return failure();
    builder.setInsertionPointAfter(def);
    auto mov = waveamdmachine::VMovB32TupleOp::create(builder, def->getLoc(),
                                                      *vgprType, value);
    mov->setAttr("registers", builder.getI64IntegerAttr(1));
    mov->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    Value vgpr = mov.getResult();
    vgprReplacements[value] = vgpr;
    FailureOr<waveamdmachine::RegType> agprType = getAssignedGroupRegType(
        value, group, waveamdmachine::RegClass::AGPR, inventory);
    if (failed(agprType))
      return failure();
    FailureOr<Value> agpr = materializeAGPRDef(
        vgpr, *agprType, /*sourceNeedsTemp=*/false, plan, context, builder);
    if (failed(agpr))
      return failure();
    agprReplacements[value] = *agpr;
    if (failed(rewritePromotedSGPRToAGPRUses(value, vgpr, *agpr, plan, context,
                                             builder)))
      return failure();
  }
  return success();
}

static LogicalResult materializePromotionTarget(
    IntervalGroup *group, waveamdmachine::RegClass source,
    waveamdmachine::RegClass target, Inventory &inventory,
    const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder) {
  if (source == waveamdmachine::RegClass::SGPR &&
      target == waveamdmachine::RegClass::VGPR)
    return materializeSGPRPromotion(group, inventory, plan, context, builder);
  if (source == waveamdmachine::RegClass::VGPR &&
      target == waveamdmachine::RegClass::AGPR)
    return materializeAGPRPromotion(group, inventory, plan, context, builder);
  if (source == waveamdmachine::RegClass::SGPR &&
      target == waveamdmachine::RegClass::AGPR)
    return materializeSGPRToAGPRPromotion(group, inventory, plan, context,
                                          builder);
  return mlir::emitError(builder.getUnknownLoc(), kPassName)
         << " unsupported promotion " << getRegClassName(source) << " -> "
         << getRegClassName(target);
}

static LogicalResult materializePromotionPlans(
    ArrayRef<BankPromotionStep> steps, Inventory &inventory,
    const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder) {
  SmallVector<IntervalGroup *> groups;
  DenseMap<IntervalGroup *, waveamdmachine::RegClass> initialClasses;
  DenseMap<IntervalGroup *, waveamdmachine::RegClass> currentClasses;
  for (BankPromotionStep step : steps) {
    if (!step.group)
      return mlir::emitError(builder.getUnknownLoc(), kPassName)
             << " found empty promotion plan";
    auto it = currentClasses.find(step.group);
    if (it == currentClasses.end()) {
      groups.push_back(step.group);
      initialClasses[step.group] = step.sourceClass;
      it = currentClasses.insert({step.group, step.sourceClass}).first;
    }
    if (it->second != step.sourceClass)
      return mlir::emitError(builder.getUnknownLoc(), kPassName)
             << " found non-contiguous promotion chain";
    it->second = step.targetClass;
  }
  for (IntervalGroup *group : groups) {
    waveamdmachine::RegClass source = initialClasses.lookup(group);
    waveamdmachine::RegClass target = currentClasses.lookup(group);
    if (failed(materializePromotionTarget(group, source, target, inventory,
                                          plan, context, builder)))
      return failure();
  }
  return success();
}

static unsigned getValueWidth(Value value) {
  return static_cast<unsigned>(
      cast<waveamdmachine::RegType>(value.getType()).getWidth());
}

static unsigned getValuePosition(Value value, Inventory &inventory) {
  if (Operation *def = value.getDefiningOp())
    return inventory.positions.lookup(def);
  BlockArgument arg = cast<BlockArgument>(value);
  Operation *parent = arg.getOwner()->getParentOp();
  if (isa<func::FuncOp>(parent))
    return 0;
  return inventory.positions.lookup(parent);
}

static void appendPointTemp(
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
    waveamdmachine::RegClass regClass, unsigned position, unsigned width) {
  wave::WaveAMDPressureReliefTempInterval interval;
  interval.regClass = regClass;
  interval.start = position;
  interval.end = position;
  interval.width = width;
  intervals.push_back(interval);
}

class BankPromotionCandidate final
    : public wave::WaveAMDPressureReliefCandidate {
public:
  BankPromotionCandidate(IntervalGroup *group,
                         waveamdmachine::RegClass sourceClass,
                         waveamdmachine::RegClass targetClass,
                         PromotionScore score)
      : group(group), score(score), sourceClass(sourceClass),
        targetClass(targetClass) {}

  StringRef getProviderName() const override { return "bank-promotion"; }

  wave::WaveAMDPressureReliefCost getCost() const override {
    wave::WaveAMDPressureReliefCost cost;
    cost.loopWeightedOps = score.bridgeCost;
    return cost;
  }

  unsigned getReliefDwords() const override { return score.liveDwords; }

  wave::WaveAMDPressureReliefEffect
  getPressureEffect(const wave::WaveAMDPressureFailure &) const override {
    int64_t relief = static_cast<int64_t>(getReliefDwords());
    wave::WaveAMDPressureReliefEffect effect;
    if (sourceClass == waveamdmachine::RegClass::SGPR)
      effect.sgprLiveDelta -= relief;
    if (sourceClass == waveamdmachine::RegClass::VGPR)
      effect.vgprLiveDelta -= relief;
    if (sourceClass == waveamdmachine::RegClass::AGPR)
      effect.agprLiveDelta -= relief;
    if (targetClass == waveamdmachine::RegClass::SGPR)
      effect.sgprLiveDelta += relief;
    if (targetClass == waveamdmachine::RegClass::VGPR)
      effect.vgprLiveDelta += relief;
    if (targetClass == waveamdmachine::RegClass::AGPR)
      effect.agprLiveDelta += relief;
    return effect;
  }

  IntervalGroup *getGroup() const { return group; }
  waveamdmachine::RegClass getSourceClass() const { return sourceClass; }
  waveamdmachine::RegClass getTargetClass() const { return targetClass; }
  PromotionScore getScore() const { return score; }

protected:
  void printExtra(llvm::raw_ostream &os) const override {
    os << ", from=" << getRegClassName(sourceClass)
       << ", to=" << getRegClassName(targetClass) << ", end=" << score.end;
  }

  void setExtraDiagnosticAttrs(Builder &builder,
                               NamedAttrList &attrs) const override {
    attrs.set("bridge_cost", builder.getI64IntegerAttr(score.bridgeCost));
    attrs.set("end", builder.getI64IntegerAttr(score.end));
    attrs.set("from", builder.getStringAttr(getRegClassName(sourceClass)));
    attrs.set("to", builder.getStringAttr(getRegClassName(targetClass)));
  }

private:
  IntervalGroup *group = nullptr;
  PromotionScore score;
  waveamdmachine::RegClass sourceClass;
  waveamdmachine::RegClass targetClass;
};

class BankPromotionPlan final : public wave::WaveAMDPressureReliefPlan {
public:
  BankPromotionPlan(IntervalGroup *group, waveamdmachine::RegClass sourceClass,
                    waveamdmachine::RegClass targetClass, unsigned reliefDwords)
      : group(group), reliefDwords(reliefDwords), sourceClass(sourceClass),
        targetClass(targetClass) {}

  wave::WaveAMDPressureReliefProviderKind getProviderKind() const override {
    return wave::WaveAMDPressureReliefProviderKind::BankPromotion;
  }

  StringRef getProviderName() const override { return "bank-promotion"; }
  unsigned getReliefDwords() const override { return reliefDwords; }

  IntervalGroup *getGroup() const { return group; }
  waveamdmachine::RegClass getSourceClass() const { return sourceClass; }
  waveamdmachine::RegClass getTargetClass() const { return targetClass; }

private:
  IntervalGroup *group = nullptr;
  unsigned reliefDwords = 0;
  waveamdmachine::RegClass sourceClass;
  waveamdmachine::RegClass targetClass;
};

class BankPromotionProvider final : public wave::WaveAMDPressureReliefProvider {
public:
  BankPromotionProvider(ArrayRef<IntervalGroup *> groups,
                        IntervalGroup *request, unsigned position,
                        RegisterBudgets budgets,
                        const wave::WaveAMDKernelEntryRegs &regs,
                        Inventory &inventory)
      : groups(groups), budgets(budgets), regs(regs), inventory(inventory),
        request(request), position(position) {}

  StringRef getName() const override { return "bank-promotion"; }
  wave::WaveAMDPressureReliefProviderKind getKind() const override {
    return wave::WaveAMDPressureReliefProviderKind::BankPromotion;
  }

  LogicalResult collectCandidates(
      const wave::WaveAMDPressureReliefQuery &query,
      wave::WaveAMDPressureReliefCandidateList &candidates) const override {
    for (IntervalGroup *group : groups)
      collect(group, candidates, query.failure);
    collect(request, candidates, query.failure);
    return success();
  }

  std::unique_ptr<wave::WaveAMDPressureReliefPlan> createPlan(
      const wave::WaveAMDPressureReliefCandidate &candidate) const override {
    const BankPromotionCandidate &promotion =
        static_cast<const BankPromotionCandidate &>(candidate);
    return std::make_unique<BankPromotionPlan>(
        promotion.getGroup(), promotion.getSourceClass(),
        promotion.getTargetClass(), promotion.getReliefDwords());
  }

  void applyPlan(const wave::WaveAMDPressureReliefPlan &plan) const override {
    const BankPromotionPlan &promotion =
        static_cast<const BankPromotionPlan &>(plan);
    IntervalGroup *group = promotion.getGroup();
    assert(group && "pressure relief plan must reference a group");
    group->storageClass = promotion.getTargetClass();
  }

  void collectPlanTempIntervals(
      const wave::WaveAMDPressureReliefPlan &plan,
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals)
      const override {
    const BankPromotionPlan &promotion =
        static_cast<const BankPromotionPlan &>(plan);
    IntervalGroup *group = promotion.getGroup();
    if (!group)
      return;
    waveamdmachine::RegClass source = promotion.getSourceClass();
    waveamdmachine::RegClass target = promotion.getTargetClass();
    if (source == waveamdmachine::RegClass::SGPR &&
        target == waveamdmachine::RegClass::VGPR) {
      collectSGPRToVGPRTemps(group, intervals);
      return;
    }
    if (source == waveamdmachine::RegClass::VGPR &&
        target == waveamdmachine::RegClass::AGPR) {
      collectVGPRToAGPRTemps(group, intervals);
      return;
    }
    if (source == waveamdmachine::RegClass::SGPR &&
        target == waveamdmachine::RegClass::AGPR)
      collectSGPRToAGPRTemps(group, intervals);
  }

  LogicalResult
  materializePlan(const wave::WaveAMDPressureReliefPlan &plan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder) const override {
    const BankPromotionPlan &promotion =
        static_cast<const BankPromotionPlan &>(plan);
    BankPromotionStep step{promotion.getGroup(), &plan,
                           promotion.getSourceClass(),
                           promotion.getTargetClass()};
    return materializePromotionPlans(ArrayRef(step), inventory, plan, context,
                                     builder);
  }

  struct PlanTempStream {
    const wave::WaveAMDPressureReliefPlan *plan = nullptr;
    SmallVector<wave::WaveAMDPressureReliefTempInterval, 8> temps;
    SmallVector<bool, 8> consumed;
  };

  class PlanGroupMaterializationContext final
      : public wave::WaveAMDPressureReliefMaterializationContext {
  public:
    PlanGroupMaterializationContext(
        const BankPromotionProvider &provider,
        ArrayRef<BankPromotionStep> steps,
        wave::WaveAMDPressureReliefMaterializationContext &delegate,
        const Inventory &inventory)
        : delegate(delegate), inventory(inventory) {
      for (BankPromotionStep step : steps) {
        streams.push_back({});
        PlanTempStream &stream = streams.back();
        stream.plan = step.plan;
        provider.collectPlanTempIntervals(*step.plan, stream.temps);
        stream.consumed.resize(stream.temps.size());
      }
    }

    FailureOr<wave::WaveAMDPressureReliefTempAssignment>
    consumeTempAssignment(const wave::WaveAMDPressureReliefPlan &plan,
                          waveamdmachine::RegClass regClass, unsigned width,
                          Operation *diagOp) override {
      PlanTempStream *stream =
          findMatchingStream(&plan, regClass, width, diagOp);
      if (!stream)
        stream = findMatchingStream(nullptr, regClass, width, diagOp);
      if (!stream) {
        if (allConsumed())
          return diagOp->emitError(kPassName)
                 << " materialized more pressure-relief temps than planned";
        return diagOp->emitError(kPassName)
               << " materialized pressure-relief temp does not match plan";
      }
      FailureOr<wave::WaveAMDPressureReliefTempAssignment> assignment =
          delegate.consumeTempAssignment(*stream->plan, regClass, width,
                                         diagOp);
      if (failed(assignment))
        return failure();
      return assignment;
    }

  private:
    bool matchesPosition(const wave::WaveAMDPressureReliefTempInterval &temp,
                         Operation *diagOp) const {
      DenseMap<Operation *, unsigned>::const_iterator it =
          inventory.positions.find(diagOp);
      if (it == inventory.positions.end())
        return true;
      return temp.start <= it->second && it->second <= temp.end;
    }

    bool matches(const PlanTempStream &stream, unsigned index,
                 waveamdmachine::RegClass regClass, unsigned width,
                 Operation *diagOp) const {
      if (stream.consumed[index])
        return false;
      const wave::WaveAMDPressureReliefTempInterval &temp = stream.temps[index];
      return temp.regClass == regClass && temp.width == width &&
             matchesPosition(temp, diagOp);
    }

    PlanTempStream *
    findMatchingStream(const wave::WaveAMDPressureReliefPlan *plan,
                       waveamdmachine::RegClass regClass, unsigned width,
                       Operation *diagOp) {
      for (PlanTempStream &stream : streams) {
        if (plan && stream.plan != plan)
          continue;
        for (unsigned index : llvm::seq<unsigned>(0, stream.temps.size())) {
          if (!matches(stream, index, regClass, width, diagOp))
            continue;
          stream.consumed[index] = true;
          return &stream;
        }
      }
      return nullptr;
    }

    bool allConsumed() const {
      for (const PlanTempStream &stream : streams)
        for (bool consumed : stream.consumed)
          if (!consumed)
            return false;
      return true;
    }

    wave::WaveAMDPressureReliefMaterializationContext &delegate;
    const Inventory &inventory;
    SmallVector<PlanTempStream, 4> streams;
  };

  LogicalResult
  materializePlans(ArrayRef<const wave::WaveAMDPressureReliefPlan *> plans,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder) const override {
    SmallVector<IntervalGroup *, 4> groups;
    DenseMap<IntervalGroup *, SmallVector<BankPromotionStep, 4>> stepsByGroup;
    for (const wave::WaveAMDPressureReliefPlan *plan : plans) {
      const BankPromotionPlan &promotion =
          static_cast<const BankPromotionPlan &>(*plan);
      IntervalGroup *group = promotion.getGroup();
      if (!stepsByGroup.count(group))
        groups.push_back(group);
      stepsByGroup[group].push_back({group, plan, promotion.getSourceClass(),
                                     promotion.getTargetClass()});
    }

    for (IntervalGroup *group : groups) {
      SmallVector<BankPromotionStep, 4> &steps = stepsByGroup[group];
      PlanGroupMaterializationContext planContext(*this, steps, context,
                                                  inventory);
      if (failed(materializePromotionPlans(
              steps, inventory, *steps.front().plan, planContext, builder)))
        return failure();
    }
    return success();
  }

  bool isBetterCandidate(
      const wave::WaveAMDPressureReliefCandidate &lhs,
      const wave::WaveAMDPressureReliefCandidate &rhs) const override {
    const BankPromotionCandidate &lhsPromotion =
        static_cast<const BankPromotionCandidate &>(lhs);
    const BankPromotionCandidate &rhsPromotion =
        static_cast<const BankPromotionCandidate &>(rhs);
    return isBetterPromotionScore(lhsPromotion.getScore(),
                                  rhsPromotion.getScore());
  }

private:
  void collectSGPRToVGPRTemps(
      IntervalGroup *group,
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals)
      const {
    for (Value value : getGroupValues(group)) {
      unsigned width = getValueWidth(value);
      if (!isa<BlockArgument>(value))
        appendPointTemp(intervals, waveamdmachine::RegClass::SGPR,
                        getValuePosition(value, inventory), width);
      for (OpOperand &use : value.getUses())
        appendPointTemp(intervals, waveamdmachine::RegClass::SGPR,
                        inventory.positions.lookup(use.getOwner()), width);
    }
  }

  void collectVGPRToAGPRTemps(
      IntervalGroup *group,
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals)
      const {
    for (Value value : getGroupValues(group)) {
      unsigned width = getValueWidth(value);
      Operation *def = value.getDefiningOp();
      if (def && !canDefineAGPR(value) &&
          !canRebankTupleAliasOp(def, group, inventory))
        appendPointTemp(intervals, waveamdmachine::RegClass::VGPR,
                        inventory.positions.lookup(def), width);
      for (OpOperand &use : value.getUses()) {
        Operation *user = use.getOwner();
        if (isa<waveamdmachine::VAccvgprWriteB32TupleOp>(user))
          continue;
        if (canConsumeAGPRAfterPromotion(use, group, inventory))
          continue;
        appendPointTemp(intervals, waveamdmachine::RegClass::VGPR,
                        inventory.positions.lookup(user), width);
      }
    }
  }

  void collectSGPRToAGPRTemps(
      IntervalGroup *group,
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals)
      const {
    for (Value value : getGroupValues(group)) {
      unsigned width = getValueWidth(value);
      if (!isa<BlockArgument>(value)) {
        unsigned position = getValuePosition(value, inventory);
        appendPointTemp(intervals, waveamdmachine::RegClass::SGPR, position,
                        width);
        appendPointTemp(intervals, waveamdmachine::RegClass::VGPR, position,
                        width);
      }
      for (OpOperand &use : value.getUses()) {
        unsigned position = inventory.positions.lookup(use.getOwner());
        appendPointTemp(intervals, waveamdmachine::RegClass::VGPR, position,
                        width);
        appendPointTemp(intervals, waveamdmachine::RegClass::SGPR, position,
                        width);
      }
    }
  }

  void collect(IntervalGroup *group,
               wave::WaveAMDPressureReliefCandidateList &candidates,
               const wave::WaveAMDPressureFailure *failure) const {
    if (!group || !isLiveAt(group, position) || !canPromote(group, budgets))
      return;
    std::optional<waveamdmachine::RegClass> target =
        getNextRegClass(group->storageClass);
    assert(target && "canPromote checked promotion target");
    bool targetFits = canFitPromotionTarget(group, groups, budgets, regs);
    std::unique_ptr<BankPromotionCandidate> candidate =
        std::make_unique<BankPromotionCandidate>(
            group, group->storageClass, *target,
            getPromotionScore(group, position, inventory));
    if (!targetFits || !shouldKeepCandidate(*candidate, failure))
      return;
    candidates.push_back(std::move(candidate));
  }

  bool shouldKeepCandidate(const BankPromotionCandidate &candidate,
                           const wave::WaveAMDPressureFailure *failure) const {
    if (!failure)
      return true;
    if (candidate.reducesPressureFailure(*failure))
      return true;
    return hasBlockedDirectReliefPromotion(candidate.getSourceClass(),
                                           *failure);
  }

  bool hasBlockedDirectReliefPromotion(
      waveamdmachine::RegClass targetClass,
      const wave::WaveAMDPressureFailure &failure) const {
    for (IntervalGroup *group : groups)
      if (isBlockedDirectReliefPromotion(group, targetClass, failure))
        return true;
    return isBlockedDirectReliefPromotion(request, targetClass, failure);
  }

  bool isBlockedDirectReliefPromotion(
      IntervalGroup *group, waveamdmachine::RegClass targetClass,
      const wave::WaveAMDPressureFailure &failure) const {
    if (!group || !isLiveAt(group, position) || !canPromote(group, budgets))
      return false;
    std::optional<waveamdmachine::RegClass> directTarget =
        getNextRegClass(group->storageClass);
    assert(directTarget && "canPromote checked promotion target");
    if (*directTarget != targetClass)
      return false;
    BankPromotionCandidate candidate(
        group, group->storageClass, *directTarget,
        getPromotionScore(group, position, inventory));
    return candidate.reducesPressureFailure(failure) &&
           !canFitPromotionTarget(group, groups, budgets, regs);
  }

  ArrayRef<IntervalGroup *> groups;
  RegisterBudgets budgets;
  const wave::WaveAMDKernelEntryRegs &regs;
  Inventory &inventory;
  IntervalGroup *request = nullptr;
  unsigned position = 0;
};

} // namespace

std::unique_ptr<wave::WaveAMDPressureReliefProvider>
mlir::wave::regalloc::createBankPromotionProvider(
    ArrayRef<IntervalGroup *> groups, IntervalGroup *request, unsigned position,
    RegisterBudgets budgets, Inventory &inventory) {
  return std::make_unique<BankPromotionProvider>(
      groups, request, position, budgets, inventory.entryRegs, inventory);
}
