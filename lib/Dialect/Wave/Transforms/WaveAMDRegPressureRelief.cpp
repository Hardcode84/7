//===- WaveAMDRegPressureRelief.cpp - Reg pressure relief -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegPressureRelief.h"

#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <limits>

using namespace mlir;

namespace mlir::wave {

WaveAMDPressureReliefCandidate::~WaveAMDPressureReliefCandidate() = default;
WaveAMDPressureReliefPlan::~WaveAMDPressureReliefPlan() = default;
WaveAMDPressureReliefMaterializationContext::
    ~WaveAMDPressureReliefMaterializationContext() = default;
WaveAMDPressureReliefProvider::~WaveAMDPressureReliefProvider() = default;

std::optional<StringRef>
WaveAMDPressureReliefCandidate::getRejectReason() const {
  return std::nullopt;
}

bool WaveAMDPressureReliefCandidate::isLegal() const {
  return !getRejectReason();
}

WaveAMDPressureReliefEffect WaveAMDPressureReliefCandidate::getPressureEffect(
    const WaveAMDPressureFailure &) const {
  WaveAMDPressureReliefEffect effect;
  effect.vgprLiveDelta = -static_cast<int64_t>(getReliefDwords());
  return effect;
}

static bool hasPressureEffect(WaveAMDPressureReliefEffect effect) {
  return effect.sgprLiveDelta != 0 || effect.vgprLiveDelta != 0 ||
         effect.agprLiveDelta != 0;
}

static unsigned applyLiveDelta(unsigned value, int64_t delta) {
  if (delta < 0) {
    uint64_t magnitude = static_cast<uint64_t>(-delta);
    if (magnitude >= value)
      return 0;
    return value - static_cast<unsigned>(magnitude);
  }
  uint64_t widened = static_cast<uint64_t>(value) + delta;
  return widened > std::numeric_limits<unsigned>::max()
             ? std::numeric_limits<unsigned>::max()
             : static_cast<unsigned>(widened);
}

static unsigned getPressureOverage(unsigned liveDwords, unsigned limit) {
  if (liveDwords <= limit)
    return 0;
  return liveDwords - limit;
}

static unsigned alignDownTo(unsigned value, unsigned granule) {
  return (value / granule) * granule;
}

struct CombinedPressureProgress {
  unsigned overage = 0;
  unsigned granuleDebt = 0;
};

static CombinedPressureProgress
getCombinedPressureProgress(const WaveAMDPressureFailure &failure,
                            WaveAMDPressureReliefEffect effect) {
  unsigned agprLive =
      applyLiveDelta(failure.combinedAGPRLiveDwords, effect.agprLiveDelta);
  unsigned vgprLive = applyLiveDelta(failure.liveDwords, effect.vgprLiveDelta);
  unsigned rawVGPRLimit = 0;
  if (agprLive < failure.combinedVGPRFamilyLimit)
    rawVGPRLimit = failure.combinedVGPRFamilyLimit - agprLive;
  unsigned alignedVGPRLimit = alignDownTo(rawVGPRLimit, 4);
  unsigned overage = getPressureOverage(vgprLive, alignedVGPRLimit);
  if (overage == 0)
    return {0, 0};
  unsigned hiddenCapacity = rawVGPRLimit - alignedVGPRLimit;
  return {overage, 4 - hiddenCapacity};
}

static bool isBetterCombinedPressureProgress(CombinedPressureProgress lhs,
                                             CombinedPressureProgress rhs) {
  if (lhs.overage != rhs.overage)
    return lhs.overage < rhs.overage;
  return lhs.granuleDebt < rhs.granuleDebt;
}

bool WaveAMDPressureReliefCandidate::reducesPressureFailure(
    const WaveAMDPressureFailure &failure) const {
  return waveAMDPressureReliefEffectReducesFailure(failure,
                                                   getPressureEffect(failure));
}

void WaveAMDPressureReliefCandidate::print(
    llvm::raw_ostream &os, bool selected,
    const WaveAMDPressureFailure *failure) const {
  os << "{provider=" << getProviderName() << ", relief=" << getReliefDwords()
     << ", cost=" << formatWaveAMDPressureReliefCost(getCost());
  if (std::optional<StringRef> reason = getRejectReason())
    os << ", reject=" << *reason;
  if (failure)
    os << ", reduces_failure="
       << (reducesPressureFailure(*failure) ? "true" : "false");
  printExtra(os);
  if (selected)
    os << ", selected";
  os << "}";
}

DictionaryAttr WaveAMDPressureReliefCandidate::getDiagnosticAttr(
    Builder &builder, bool selected,
    const WaveAMDPressureFailure *failure) const {
  NamedAttrList attrs;
  attrs.set("cost",
            builder.getStringAttr(formatWaveAMDPressureReliefCost(getCost())));
  attrs.set("legal", builder.getBoolAttr(isLegal()));
  attrs.set("provider", builder.getStringAttr(getProviderName()));
  if (std::optional<StringRef> reason = getRejectReason())
    attrs.set("reject_reason", builder.getStringAttr(*reason));
  if (failure)
    attrs.set("reduces_failure",
              builder.getBoolAttr(reducesPressureFailure(*failure)));
  attrs.set("relief_dwords", builder.getI64IntegerAttr(getReliefDwords()));
  if (selected)
    attrs.set("selected", builder.getBoolAttr(true));
  setExtraDiagnosticAttrs(builder, attrs);
  return builder.getDictionaryAttr(attrs);
}

void WaveAMDPressureReliefCandidate::printExtra(llvm::raw_ostream &os) const {}

void WaveAMDPressureReliefCandidate::setExtraDiagnosticAttrs(
    Builder &builder, NamedAttrList &attrs) const {}

bool WaveAMDPressureReliefProvider::isBetterCandidate(
    const WaveAMDPressureReliefCandidate &lhs,
    const WaveAMDPressureReliefCandidate &rhs) const {
  return isBetterWaveAMDPressureReliefCandidate(lhs, rhs);
}

std::unique_ptr<WaveAMDPressureReliefPlan>
WaveAMDPressureReliefProvider::createPlan(
    const WaveAMDPressureReliefCandidate &) const {
  return nullptr;
}

std::optional<StringRef>
WaveAMDPressureReliefProvider::getRejectReason() const {
  return std::nullopt;
}

void WaveAMDPressureReliefProvider::applyPlan(
    const WaveAMDPressureReliefPlan &) const {}

void WaveAMDPressureReliefProvider::collectPlanTempIntervals(
    const WaveAMDPressureReliefPlan &,
    SmallVectorImpl<WaveAMDPressureReliefTempInterval> &) const {}

bool WaveAMDPressureReliefProvider::ownsPlan(
    const WaveAMDPressureReliefPlan &plan) const {
  return plan.getProviderKind() == getKind();
}

LogicalResult WaveAMDPressureReliefProvider::materializePlan(
    const WaveAMDPressureReliefPlan &,
    WaveAMDPressureReliefMaterializationContext &, OpBuilder &) const {
  return failure();
}

LogicalResult WaveAMDPressureReliefProvider::materializePlans(
    ArrayRef<const WaveAMDPressureReliefPlan *> plans,
    WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder) const {
  for (const WaveAMDPressureReliefPlan *plan : plans)
    if (failed(materializePlan(*plan, context, builder)))
      return failure();
  return success();
}

void WaveAMDPressureReliefProvider::emitRemarks() const {}

void WaveAMDPressureReliefProvider::notifyAttemptStarted() const {}

void WaveAMDPressureReliefProvider::notifyNoCandidate() const {}

void WaveAMDPressureReliefProvider::notifyPlanApplied() const {}

static int64_t getPrimaryCost(WaveAMDPressureReliefCost cost) {
  return cost.materializationOps + cost.loopWeightedOps;
}

bool isBetterWaveAMDPressureReliefCandidate(
    const WaveAMDPressureReliefCandidate &lhs,
    const WaveAMDPressureReliefCandidate &rhs) {
  if (lhs.isLegal() != rhs.isLegal())
    return lhs.isLegal();

  WaveAMDPressureReliefCost lhsCost = lhs.getCost();
  WaveAMDPressureReliefCost rhsCost = rhs.getCost();
  int64_t lhsPrimaryCost = getPrimaryCost(lhsCost);
  int64_t rhsPrimaryCost = getPrimaryCost(rhsCost);
  if (lhsPrimaryCost != rhsPrimaryCost)
    return lhsPrimaryCost < rhsPrimaryCost;

  if (lhsCost.instabilityPenalty != rhsCost.instabilityPenalty)
    return lhsCost.instabilityPenalty < rhsCost.instabilityPenalty;

  if (lhsCost.latencyPenalty != rhsCost.latencyPenalty)
    return lhsCost.latencyPenalty < rhsCost.latencyPenalty;

  if (lhs.getReliefDwords() != rhs.getReliefDwords())
    return lhs.getReliefDwords() > rhs.getReliefDwords();

  return lhs.getProviderName() < rhs.getProviderName();
}

WaveAMDPressureReliefEffect
combineWaveAMDPressureReliefEffects(WaveAMDPressureReliefEffect lhs,
                                    WaveAMDPressureReliefEffect rhs) {
  lhs.sgprLiveDelta += rhs.sgprLiveDelta;
  lhs.vgprLiveDelta += rhs.vgprLiveDelta;
  lhs.agprLiveDelta += rhs.agprLiveDelta;
  return lhs;
}

bool waveAMDPressureReliefEffectProgressesFailure(
    const WaveAMDPressureFailure &failure,
    WaveAMDPressureReliefEffect currentEffect,
    WaveAMDPressureReliefEffect candidateEffect) {
  if (!hasPressureEffect(candidateEffect))
    return false;
  if (!failure.combinedVGPRAGPR)
    return waveAMDPressureReliefEffectReducesFailure(failure, candidateEffect);
  CombinedPressureProgress current =
      getCombinedPressureProgress(failure, currentEffect);
  CombinedPressureProgress next = getCombinedPressureProgress(
      failure,
      combineWaveAMDPressureReliefEffects(currentEffect, candidateEffect));
  return isBetterCombinedPressureProgress(next, current);
}

bool isBetterWaveAMDPressureReliefEffect(const WaveAMDPressureFailure &failure,
                                         WaveAMDPressureReliefEffect lhs,
                                         WaveAMDPressureReliefEffect rhs) {
  if (!failure.combinedVGPRAGPR) {
    bool lhsProgress = waveAMDPressureReliefEffectReducesFailure(failure, lhs);
    bool rhsProgress = waveAMDPressureReliefEffectReducesFailure(failure, rhs);
    return lhsProgress && !rhsProgress;
  }
  return isBetterCombinedPressureProgress(
      getCombinedPressureProgress(failure, lhs),
      getCombinedPressureProgress(failure, rhs));
}

bool waveAMDPressureReliefEffectReducesFailure(
    const WaveAMDPressureFailure &failure, WaveAMDPressureReliefEffect effect) {
  if (!hasPressureEffect(effect))
    return false;
  if (!failure.combinedVGPRAGPR) {
    if (failure.regClass == "SGPR")
      return effect.sgprLiveDelta < 0;
    if (failure.regClass == "VGPR")
      return effect.vgprLiveDelta < 0;
    if (failure.regClass == "AGPR")
      return effect.agprLiveDelta < 0;
    return false;
  }
  CombinedPressureProgress oldProgress =
      getCombinedPressureProgress(failure, WaveAMDPressureReliefEffect{});
  CombinedPressureProgress newProgress =
      getCombinedPressureProgress(failure, effect);
  return newProgress.overage < oldProgress.overage;
}

bool waveAMDPressureReliefEffectSolvesFailure(
    const WaveAMDPressureFailure &failure, WaveAMDPressureReliefEffect effect) {
  if (!failure.combinedVGPRAGPR)
    return waveAMDPressureReliefEffectReducesFailure(failure, effect);
  return getCombinedPressureProgress(failure, effect).overage == 0;
}

std::string
formatWaveAMDPressureInterval(const WaveAMDPressureIntervalRef &interval) {
  std::string out;
  llvm::raw_string_ostream os(out);
  os << "{start=" << interval.start << ", end=" << interval.end
     << ", width=" << interval.width << ", values=[";
  llvm::interleaveComma(
      llvm::seq<size_t>(0, interval.valuePositions.size()), os, [&](size_t i) {
        os << interval.valuePositions[i] << "." << interval.resultIndices[i]
           << "+" << interval.slotOffsets[i];
      });
  os << "]}";
  return out;
}

std::string
formatWaveAMDPressureIntervals(ArrayRef<WaveAMDPressureIntervalRef> intervals) {
  std::string out;
  llvm::raw_string_ostream os(out);
  os << "[";
  llvm::interleaveComma(intervals, os,
                        [&](const WaveAMDPressureIntervalRef &interval) {
                          os << formatWaveAMDPressureInterval(interval);
                        });
  os << "]";
  return out;
}

std::string
formatWaveAMDPressureReliefCost(const WaveAMDPressureReliefCost &cost) {
  std::string out;
  llvm::raw_string_ostream os(out);
  os << "{ops=" << cost.materializationOps
     << ", loop_ops=" << cost.loopWeightedOps
     << ", latency=" << cost.latencyPenalty
     << ", instability=" << cost.instabilityPenalty << "}";
  return out;
}

std::string formatWaveAMDPressureReliefCandidate(
    const WaveAMDPressureReliefCandidate &candidate, bool selected,
    const WaveAMDPressureFailure *failure) {
  std::string out;
  llvm::raw_string_ostream os(out);
  candidate.print(os, selected, failure);
  return out;
}

std::string formatWaveAMDPressureReliefCandidates(
    ArrayRef<std::unique_ptr<WaveAMDPressureReliefCandidate>> candidates,
    std::optional<unsigned> selected, const WaveAMDPressureFailure *failure) {
  std::string out;
  llvm::raw_string_ostream os(out);
  os << "[";
  llvm::interleaveComma(
      llvm::seq<size_t>(0, candidates.size()), os, [&](size_t index) {
        os << formatWaveAMDPressureReliefCandidate(
            *candidates[index], selected && *selected == index, failure);
      });
  os << "]";
  return out;
}

DictionaryAttr
getWaveAMDPressureIntervalAttr(Builder &builder,
                               const WaveAMDPressureIntervalRef &interval) {
  return builder.getDictionaryAttr({
      builder.getNamedAttr("end", builder.getI64IntegerAttr(interval.end)),
      builder.getNamedAttr("result_indices", builder.getDenseI64ArrayAttr(
                                                 interval.resultIndices)),
      builder.getNamedAttr("slot_offsets",
                           builder.getDenseI64ArrayAttr(interval.slotOffsets)),
      builder.getNamedAttr("start", builder.getI64IntegerAttr(interval.start)),
      builder.getNamedAttr("value_positions", builder.getDenseI64ArrayAttr(
                                                  interval.valuePositions)),
      builder.getNamedAttr("width", builder.getI64IntegerAttr(interval.width)),
  });
}

ArrayAttr getWaveAMDPressureIntervalArrayAttr(
    Builder &builder, ArrayRef<WaveAMDPressureIntervalRef> intervals) {
  SmallVector<Attribute> attrs;
  for (const WaveAMDPressureIntervalRef &interval : intervals)
    attrs.push_back(getWaveAMDPressureIntervalAttr(builder, interval));
  return builder.getArrayAttr(attrs);
}

ArrayAttr getWaveAMDPressureReliefCandidateArrayAttr(
    Builder &builder,
    ArrayRef<std::unique_ptr<WaveAMDPressureReliefCandidate>> candidates,
    std::optional<unsigned> selected, const WaveAMDPressureFailure *failure) {
  SmallVector<Attribute> attrs;
  for (auto [index, candidate] : llvm::enumerate(candidates))
    attrs.push_back(candidate->getDiagnosticAttr(
        builder, selected && *selected == index, failure));
  return builder.getArrayAttr(attrs);
}

} // namespace mlir::wave
