//===- WaveAMDRegAllocBankPromotion.cpp - Bank promotion -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocInternal.h"

#include "llvm/Support/raw_ostream.h"

using namespace mlir;
using namespace mlir::wave::regalloc;

namespace {

static unsigned alignDown(unsigned value, unsigned granule) {
  return (value / granule) * granule;
}

class BankPromotionCandidate final
    : public wave::WaveAMDPressureReliefCandidate {
public:
  BankPromotionCandidate(IntervalGroup *group,
                         waveamdmachine::RegClass sourceClass,
                         waveamdmachine::RegClass targetClass,
                         PromotionScore score, const BankPromotionHooks &hooks)
      : hooks(hooks), group(group), score(score), sourceClass(sourceClass),
        targetClass(targetClass) {}

  StringRef getProviderName() const override { return "bank-promotion"; }

  wave::WaveAMDPressureReliefCost getCost() const override {
    wave::WaveAMDPressureReliefCost cost;
    cost.loopWeightedOps = score.bridgeCost;
    return cost;
  }

  unsigned getReliefDwords() const override { return score.liveDwords; }

  bool reducesPressureFailure(
      const wave::WaveAMDPressureFailure &failure) const override {
    if (!failure.combinedVGPRAGPR)
      return getReliefDwords() != 0;
    if (sourceClass != waveamdmachine::RegClass::VGPR ||
        targetClass != waveamdmachine::RegClass::AGPR)
      return false;
    unsigned relief = getReliefDwords();
    if (relief == 0 || relief > failure.liveDwords)
      return false;
    unsigned newAGPRLive = failure.combinedAGPRLiveDwords + relief;
    unsigned newVGPRLimit = 0;
    if (newAGPRLive < failure.combinedVGPRFamilyLimit)
      newVGPRLimit =
          alignDown(failure.combinedVGPRFamilyLimit - newAGPRLive, 4);
    unsigned oldOverage = failure.liveDwords > failure.limit
                              ? failure.liveDwords - failure.limit
                              : 0;
    unsigned newVGPRLive = failure.liveDwords - relief;
    unsigned newOverage =
        newVGPRLive > newVGPRLimit ? newVGPRLive - newVGPRLimit : 0;
    return newOverage < oldOverage;
  }

  IntervalGroup *getGroup() const { return group; }
  waveamdmachine::RegClass getSourceClass() const { return sourceClass; }
  waveamdmachine::RegClass getTargetClass() const { return targetClass; }
  PromotionScore getScore() const { return score; }

protected:
  void printExtra(llvm::raw_ostream &os) const override {
    os << ", from=" << hooks.getRegClassName(sourceClass)
       << ", to=" << hooks.getRegClassName(targetClass)
       << ", end=" << score.end;
  }

  void setExtraDiagnosticAttrs(Builder &builder,
                               NamedAttrList &attrs) const override {
    attrs.set("bridge_cost", builder.getI64IntegerAttr(score.bridgeCost));
    attrs.set("end", builder.getI64IntegerAttr(score.end));
    attrs.set("from",
              builder.getStringAttr(hooks.getRegClassName(sourceClass)));
    attrs.set("to", builder.getStringAttr(hooks.getRegClassName(targetClass)));
  }

private:
  const BankPromotionHooks &hooks;
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
                        Inventory &inventory, BankPromotionHooks hooks)
      : groups(groups), budgets(budgets), regs(regs), inventory(inventory),
        hooks(hooks), request(request), position(position) {}

  StringRef getName() const override { return "bank-promotion"; }

  LogicalResult collectCandidates(
      const wave::WaveAMDPressureReliefQuery &query,
      wave::WaveAMDPressureReliefCandidateList &candidates) const override {
    (void)query;
    for (IntervalGroup *group : groups)
      collect(group, candidates);
    collect(request, candidates);
    return success();
  }

  LogicalResult
  materialize(const wave::WaveAMDPressureReliefCandidate &candidate,
              OpBuilder &builder) const override {
    std::unique_ptr<wave::WaveAMDPressureReliefPlan> plan =
        createPlan(candidate);
    if (!plan)
      return failure();
    applyPlan(*plan);
    return materializePlan(*plan, builder);
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

  LogicalResult materializePlan(const wave::WaveAMDPressureReliefPlan &plan,
                                OpBuilder &builder) const override {
    const BankPromotionPlan &promotion =
        static_cast<const BankPromotionPlan &>(plan);
    assert(hooks.materialize && "bank promotion materializer missing");
    return hooks.materialize(promotion.getGroup(), inventory, builder);
  }

  bool isBetterCandidate(
      const wave::WaveAMDPressureReliefCandidate &lhs,
      const wave::WaveAMDPressureReliefCandidate &rhs) const override {
    const BankPromotionCandidate &lhsPromotion =
        static_cast<const BankPromotionCandidate &>(lhs);
    const BankPromotionCandidate &rhsPromotion =
        static_cast<const BankPromotionCandidate &>(rhs);
    return hooks.isBetterPromotionScore(lhsPromotion.getScore(),
                                        rhsPromotion.getScore());
  }

private:
  void collect(IntervalGroup *group,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    if (!group || !hooks.isLiveAt(group, position) ||
        !hooks.canPromote(group, budgets))
      return;
    if (!hooks.canFitPromotionTarget(group, groups, budgets, regs))
      return;
    std::optional<waveamdmachine::RegClass> target =
        hooks.getNextRegClass(group->storageClass);
    assert(target && "canPromote checked promotion target");
    candidates.push_back(std::make_unique<BankPromotionCandidate>(
        group, group->storageClass, *target,
        hooks.getPromotionScore(group, position, inventory), hooks));
  }

  ArrayRef<IntervalGroup *> groups;
  RegisterBudgets budgets;
  const wave::WaveAMDKernelEntryRegs &regs;
  Inventory &inventory;
  BankPromotionHooks hooks;
  IntervalGroup *request = nullptr;
  unsigned position = 0;
};

} // namespace

std::unique_ptr<wave::WaveAMDPressureReliefProvider>
mlir::wave::regalloc::createBankPromotionProvider(
    ArrayRef<IntervalGroup *> groups, IntervalGroup *request, unsigned position,
    RegisterBudgets budgets, Inventory &inventory,
    const BankPromotionHooks &hooks) {
  return std::make_unique<BankPromotionProvider>(groups, request, position,
                                                 budgets, inventory.entryRegs,
                                                 inventory, hooks);
}
