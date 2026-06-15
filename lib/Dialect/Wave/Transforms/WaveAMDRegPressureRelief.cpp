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

using namespace mlir;

namespace mlir::wave {

WaveAMDPressureReliefBudget::~WaveAMDPressureReliefBudget() = default;
WaveAMDPressureReliefCandidate::~WaveAMDPressureReliefCandidate() = default;
WaveAMDPressureReliefPlan::~WaveAMDPressureReliefPlan() = default;
WaveAMDPressureReliefProvider::~WaveAMDPressureReliefProvider() = default;

std::optional<int64_t> WaveAMDPressureReliefBudget::getLimit() const {
  return std::nullopt;
}

std::optional<int64_t> WaveAMDPressureReliefBudget::getUsed() const {
  return std::nullopt;
}

void WaveAMDPressureReliefBudget::print(llvm::raw_ostream &os) const {
  os << "{name=" << getName();
  if (std::optional<int64_t> limit = getLimit())
    os << ", limit=" << *limit;
  if (std::optional<int64_t> used = getUsed())
    os << ", used=" << *used;
  os << "}";
}

DictionaryAttr
WaveAMDPressureReliefBudget::getDiagnosticAttr(Builder &builder) const {
  NamedAttrList attrs;
  attrs.set("name", builder.getStringAttr(getName()));
  if (std::optional<int64_t> limit = getLimit())
    attrs.set("limit", builder.getI64IntegerAttr(*limit));
  if (std::optional<int64_t> used = getUsed())
    attrs.set("used", builder.getI64IntegerAttr(*used));
  setExtraDiagnosticAttrs(builder, attrs);
  return builder.getDictionaryAttr(attrs);
}

void WaveAMDPressureReliefBudget::setExtraDiagnosticAttrs(
    Builder &builder, NamedAttrList &attrs) const {}

std::optional<StringRef>
WaveAMDPressureReliefCandidate::getRejectReason() const {
  return std::nullopt;
}

bool WaveAMDPressureReliefCandidate::isLegal() const {
  return !getRejectReason();
}

bool WaveAMDPressureReliefCandidate::reducesPressureFailure(
    const WaveAMDPressureFailure &) const {
  return getReliefDwords() != 0;
}

void WaveAMDPressureReliefCandidate::print(llvm::raw_ostream &os,
                                           bool selected) const {
  os << "{provider=" << getProviderName() << ", relief=" << getReliefDwords()
     << ", cost=" << formatWaveAMDPressureReliefCost(getCost());
  if (std::optional<StringRef> reason = getRejectReason())
    os << ", reject=" << *reason;
  printExtra(os);
  if (selected)
    os << ", selected";
  os << "}";
}

DictionaryAttr
WaveAMDPressureReliefCandidate::getDiagnosticAttr(Builder &builder,
                                                  bool selected) const {
  NamedAttrList attrs;
  attrs.set("cost",
            builder.getStringAttr(formatWaveAMDPressureReliefCost(getCost())));
  attrs.set("legal", builder.getBoolAttr(isLegal()));
  attrs.set("provider", builder.getStringAttr(getProviderName()));
  if (std::optional<StringRef> reason = getRejectReason())
    attrs.set("reject_reason", builder.getStringAttr(*reason));
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

void WaveAMDPressureReliefProvider::applyPlan(
    const WaveAMDPressureReliefPlan &) const {}

LogicalResult WaveAMDPressureReliefProvider::materializePlan(
    const WaveAMDPressureReliefPlan &, OpBuilder &) const {
  return failure();
}

LogicalResult WaveAMDPressureReliefProvider::materializePlans(
    ArrayRef<const WaveAMDPressureReliefPlan *> plans,
    OpBuilder &builder) const {
  for (const WaveAMDPressureReliefPlan *plan : plans)
    if (failed(materializePlan(*plan, builder)))
      return failure();
  return success();
}

void WaveAMDPressureReliefProvider::notifyNoCandidate() const {}

void WaveAMDPressureReliefProvider::notifyPlanApplied() const {}

static int64_t getTotalCost(WaveAMDPressureReliefCost cost) {
  return cost.materializationOps + cost.loopWeightedOps + cost.latencyPenalty +
         cost.instabilityPenalty;
}

bool isBetterWaveAMDPressureReliefCandidate(
    const WaveAMDPressureReliefCandidate &lhs,
    const WaveAMDPressureReliefCandidate &rhs) {
  if (lhs.isLegal() != rhs.isLegal())
    return lhs.isLegal();

  int64_t lhsCost = getTotalCost(lhs.getCost());
  int64_t rhsCost = getTotalCost(rhs.getCost());
  if (lhsCost != rhsCost)
    return lhsCost < rhsCost;

  if (lhs.getReliefDwords() != rhs.getReliefDwords())
    return lhs.getReliefDwords() > rhs.getReliefDwords();

  return lhs.getProviderName() < rhs.getProviderName();
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
    const WaveAMDPressureReliefCandidate &candidate, bool selected) {
  std::string out;
  llvm::raw_string_ostream os(out);
  candidate.print(os, selected);
  return out;
}

std::string formatWaveAMDPressureReliefCandidates(
    ArrayRef<std::unique_ptr<WaveAMDPressureReliefCandidate>> candidates,
    std::optional<unsigned> selected) {
  std::string out;
  llvm::raw_string_ostream os(out);
  os << "[";
  llvm::interleaveComma(
      llvm::seq<size_t>(0, candidates.size()), os, [&](size_t index) {
        os << formatWaveAMDPressureReliefCandidate(
            *candidates[index], selected && *selected == index);
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
    std::optional<unsigned> selected) {
  SmallVector<Attribute> attrs;
  for (auto [index, candidate] : llvm::enumerate(candidates))
    attrs.push_back(
        candidate->getDiagnosticAttr(builder, selected && *selected == index));
  return builder.getArrayAttr(attrs);
}

} // namespace mlir::wave
