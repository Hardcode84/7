//===- WaveAMDRegAllocMemorySpillDiagnostics.h ----------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCMEMORYSPILLDIAGNOSTICS_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCMEMORYSPILLDIAGNOSTICS_H

#include "WaveAMDRegAllocInternal.h"

#include <cassert>
#include <cstdint>
#include <optional>
#include <string>
#include <utility>

namespace mlir::wave::regalloc {

struct MemorySpillRejectStats {
  unsigned eligible = 0;
  unsigned fixed = 0;
  unsigned memoryIssuer = 0;
  unsigned noUse = 0;
  unsigned nonPromotable = 0;
  unsigned temp = 0;
  unsigned total = 0;
};

enum class MemorySpillRejectKind : uint8_t {
  Eligible,
  Fixed,
  MemoryIssuer,
  NoUse,
  NonPromotable,
  Temp,
};

inline bool memorySpillRejectGroupLiveAt(IntervalGroup *group,
                                         unsigned position) {
  if (!group || group->plannedPressureRelief)
    return false;
  for (Interval *lane : group->intervals)
    if (lane->start <= position && position <= lane->end)
      return true;
  return false;
}

inline bool groupHasTempValue(IntervalGroup *group) {
  if (!group)
    return false;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      if (Operation *def = value.getDefiningOp())
        if (isRegAllocTempOp(def))
          return true;
  return false;
}

inline bool groupHasMemoryIssuerValue(IntervalGroup *group) {
  if (!group)
    return false;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      if (isMemoryIssuerOp(value.getDefiningOp()))
        return true;
  return false;
}

inline bool groupHasNonTempUse(IntervalGroup *group) {
  if (!group)
    return false;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      for (OpOperand &use : value.getUses())
        if (!isRegAllocTempOp(use.getOwner()))
          return true;
  return false;
}

inline bool shouldInspectMemorySpillReject(IntervalGroup *group,
                                           unsigned position) {
  if (!memorySpillRejectGroupLiveAt(group, position))
    return false;
  return group->storageClass == waveamdmachine::RegClass::VGPR &&
         group->preferredClass == waveamdmachine::RegClass::VGPR;
}

inline MemorySpillRejectKind getMemorySpillUseRejectKind(IntervalGroup *group,
                                                         unsigned position) {
  assert(hasLiveMemorySpillLane(group, position) &&
         "caller handles non-live spill lanes");
  if (groupHasMemoryIssuerValue(group))
    return MemorySpillRejectKind::MemoryIssuer;
  if (!groupHasNonTempUse(group))
    return MemorySpillRejectKind::NoUse;
  return MemorySpillRejectKind::Eligible;
}

inline MemorySpillRejectKind getMemorySpillRejectKind(IntervalGroup *group,
                                                      unsigned position) {
  if (group->reserved || isFixedRegisterGroup(group))
    return MemorySpillRejectKind::Fixed;
  if (groupHasTempValue(group))
    return MemorySpillRejectKind::Temp;
  if (group->nonPromotable || !hasLiveMemorySpillLane(group, position))
    return MemorySpillRejectKind::NonPromotable;
  return getMemorySpillUseRejectKind(group, position);
}

inline void incrementMemorySpillReject(MemorySpillRejectStats &stats,
                                       MemorySpillRejectKind kind) {
  switch (kind) {
  case MemorySpillRejectKind::Eligible:
    ++stats.eligible;
    break;
  case MemorySpillRejectKind::Fixed:
    ++stats.fixed;
    break;
  case MemorySpillRejectKind::MemoryIssuer:
    ++stats.memoryIssuer;
    break;
  case MemorySpillRejectKind::NoUse:
    ++stats.noUse;
    break;
  case MemorySpillRejectKind::NonPromotable:
    ++stats.nonPromotable;
    break;
  case MemorySpillRejectKind::Temp:
    ++stats.temp;
    break;
  }
}

inline void classifyMemorySpillReject(IntervalGroup *group, unsigned position,
                                      MemorySpillRejectStats &stats) {
  if (!shouldInspectMemorySpillReject(group, position))
    return;
  ++stats.total;
  incrementMemorySpillReject(stats, getMemorySpillRejectKind(group, position));
}

inline MemorySpillRejectStats
getMemorySpillRejectStats(ArrayRef<IntervalGroup *> groups,
                          IntervalGroup *request, unsigned position) {
  MemorySpillRejectStats stats;
  classifyMemorySpillReject(request, position, stats);
  for (IntervalGroup *group : groups)
    classifyMemorySpillReject(group, position, stats);
  return stats;
}

inline void addMemorySpillRejectMetric(
    wave::WaveAMDPressureReliefProviderDiagnostic &diagnostic, StringRef name,
    unsigned count) {
  if (count == 0)
    return;
  diagnostic.integerMetrics.push_back(
      {name.str(), static_cast<int64_t>(count)});
}

inline void appendMemorySpillRejectDetailField(std::string &message,
                                               bool &first, StringRef name,
                                               unsigned count) {
  if (count == 0)
    return;
  if (first) {
    message = "memory spill reject detail: ";
    first = false;
  } else {
    message += ", ";
  }
  message += name.str();
  message += "=";
  message += std::to_string(count);
}

inline void addMemorySpillRejectDetailDiagnostic(
    SmallVectorImpl<wave::WaveAMDPressureReliefProviderDiagnostic> &diagnostics,
    const MemorySpillRejectStats &stats) {
  if (stats.total == 0)
    return;

  wave::WaveAMDPressureReliefProviderDiagnostic diagnostic;
  addMemorySpillRejectMetric(diagnostic, "temp", stats.temp);
  addMemorySpillRejectMetric(diagnostic, "non_promotable", stats.nonPromotable);
  addMemorySpillRejectMetric(diagnostic, "memory_issuer", stats.memoryIssuer);
  addMemorySpillRejectMetric(diagnostic, "fixed", stats.fixed);
  addMemorySpillRejectMetric(diagnostic, "no_use", stats.noUse);
  addMemorySpillRejectMetric(diagnostic, "eligible", stats.eligible);
  addMemorySpillRejectMetric(diagnostic, "total", stats.total);

  bool first = true;
  appendMemorySpillRejectDetailField(diagnostic.message, first, "temp",
                                     stats.temp);
  appendMemorySpillRejectDetailField(diagnostic.message, first,
                                     "non_promotable", stats.nonPromotable);
  appendMemorySpillRejectDetailField(diagnostic.message, first, "memory_issuer",
                                     stats.memoryIssuer);
  appendMemorySpillRejectDetailField(diagnostic.message, first, "fixed",
                                     stats.fixed);
  appendMemorySpillRejectDetailField(diagnostic.message, first, "no_use",
                                     stats.noUse);
  appendMemorySpillRejectDetailField(diagnostic.message, first, "eligible",
                                     stats.eligible);
  appendMemorySpillRejectDetailField(diagnostic.message, first, "total",
                                     stats.total);
  diagnostics.push_back(std::move(diagnostic));
}

inline void addMemorySpillRejectReasonDiagnostic(
    SmallVectorImpl<wave::WaveAMDPressureReliefProviderDiagnostic> &diagnostics,
    std::optional<StringRef> reason) {
  if (!reason)
    return;
  wave::WaveAMDPressureReliefProviderDiagnostic diagnostic;
  diagnostic.message = "memory spill rejected candidates: ";
  diagnostic.message += reason->str();
  diagnostic.stringMetrics.push_back({"memory_spill_reject", reason->str()});
  diagnostics.push_back(std::move(diagnostic));
}

inline void collectMemorySpillRejectDiagnostics(
    SmallVectorImpl<wave::WaveAMDPressureReliefProviderDiagnostic> &diagnostics,
    ArrayRef<IntervalGroup *> groups, IntervalGroup *request, unsigned position,
    std::optional<StringRef> reason) {
  addMemorySpillRejectReasonDiagnostic(diagnostics, reason);
  addMemorySpillRejectDetailDiagnostic(
      diagnostics, getMemorySpillRejectStats(groups, request, position));
}

} // namespace mlir::wave::regalloc

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCMEMORYSPILLDIAGNOSTICS_H
