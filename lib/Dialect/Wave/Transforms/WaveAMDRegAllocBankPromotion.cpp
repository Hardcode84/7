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

  IntervalGroup *getGroup() const { return group; }
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

class BankPromotionProvider final : public wave::WaveAMDPressureReliefProvider {
public:
  BankPromotionProvider(ArrayRef<IntervalGroup *> groups,
                        IntervalGroup *request, unsigned position,
                        const RegisterBudgets &budgets,
                        const wave::WaveAMDKernelEntryRegs &regs,
                        Inventory &inventory, const BankPromotionHooks &hooks)
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
    (void)builder;
    const BankPromotionCandidate &promotion =
        static_cast<const BankPromotionCandidate &>(candidate);
    IntervalGroup *group = promotion.getGroup();
    assert(group && "pressure relief candidate must reference a group");
    group->storageClass = promotion.getTargetClass();
    return success();
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
  const RegisterBudgets &budgets;
  const wave::WaveAMDKernelEntryRegs &regs;
  Inventory &inventory;
  const BankPromotionHooks &hooks;
  IntervalGroup *request = nullptr;
  unsigned position = 0;
};

} // namespace

FailureOr<bool> mlir::wave::regalloc::applyBankPromotionProvider(
    func::FuncOp func, ArrayRef<IntervalGroup *> groups, IntervalGroup *request,
    unsigned position, RegisterBudgets budgets, Inventory &inventory,
    const BankPromotionHooks &hooks) {
  BankPromotionProvider provider(groups, request, position, budgets,
                                 inventory.entryRegs, inventory, hooks);
  wave::WaveAMDPressureReliefCandidateList candidates;
  wave::WaveAMDPressureReliefQuery query;
  query.scope = func;
  if (failed(provider.collectCandidates(query, candidates)))
    return failure();
  if (candidates.empty())
    return false;

  unsigned selected = 0;
  for (size_t index : llvm::seq<size_t>(1, candidates.size()))
    if (provider.isBetterCandidate(*candidates[index], *candidates[selected]))
      selected = index;

  OpBuilder builder(func.getContext());
  if (failed(provider.materialize(*candidates[selected], builder)))
    return failure();
  return true;
}
