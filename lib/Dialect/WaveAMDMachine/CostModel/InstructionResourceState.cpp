//===- InstructionResourceState.cpp - Scoped issue resources -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionResourceState.h"

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/Sequence.h"
#include "llvm/Support/ErrorHandling.h"

#include <algorithm>
#include <cassert>
#include <limits>
#include <utility>

namespace mlir::waveamdmachine {

namespace {

static size_t resourceIndex(InstructionResourceKind kind) {
  size_t index = static_cast<size_t>(kind);
  assert(index < static_cast<size_t>(InstructionResourceKind::NumResources) &&
         "resource kind out of range");
  return index;
}

static size_t simdResourceIndex(InstructionResourceKind kind) {
  switch (kind) {
  case InstructionResourceKind::SimdIssue:
    return 0;
  case InstructionResourceKind::ValuPipe:
    return 1;
  case InstructionResourceKind::SaluPipe:
    return 2;
  case InstructionResourceKind::XdlPipe:
    return 3;
  default:
    llvm_unreachable("resource is not SIMD-scoped");
  }
}

static size_t simdPairResourceIndex(InstructionResourceKind kind) {
  switch (kind) {
  case InstructionResourceKind::LdsDmaIssue:
    return 0;
  default:
    llvm_unreachable("resource is not SIMD-pair-scoped");
  }
}

static size_t cuResourceIndex(InstructionResourceKind kind) {
  switch (kind) {
  case InstructionResourceKind::CuIssue:
    return 0;
  default:
    llvm_unreachable("resource is not CU-scoped");
  }
}

static int64_t saturatingAdd(int64_t lhs, int64_t rhs) {
  assert(lhs >= 0 && rhs >= 0 && "expected non-negative cycle counts");
  if (lhs > std::numeric_limits<int64_t>::max() - rhs)
    return std::numeric_limits<int64_t>::max();
  return lhs + rhs;
}

static int64_t saturatingMultiply(int64_t lhs, int64_t rhs) {
  assert(lhs >= 0 && rhs >= 0 && "expected non-negative cycle counts");
  if (lhs != 0 && rhs > std::numeric_limits<int64_t>::max() / lhs)
    return std::numeric_limits<int64_t>::max();
  return lhs * rhs;
}

struct ReservationEvent {
  int64_t cycle = 0;
  int64_t delta = 0;
};

} // namespace

llvm::StringRef
getInstructionResourceScopeName(InstructionResourceScope scope) {
  switch (scope) {
  case InstructionResourceScope::Wave:
    return "wave";
  case InstructionResourceScope::SIMD:
    return "simd";
  case InstructionResourceScope::SIMDPair:
    return "simd_pair";
  case InstructionResourceScope::CU:
    return "cu";
  }
  llvm_unreachable("bad instruction resource scope");
}

llvm::StringRef getInstructionResourceKindName(InstructionResourceKind kind) {
  switch (kind) {
  case InstructionResourceKind::None:
    return "none";
  case InstructionResourceKind::SimdIssue:
    return "simd_issue";
  case InstructionResourceKind::CuIssue:
    return "cu_issue";
  case InstructionResourceKind::ValuPipe:
    return "valu_pipe";
  case InstructionResourceKind::SaluPipe:
    return "salu_pipe";
  case InstructionResourceKind::XdlPipe:
    return "xdl_pipe";
  case InstructionResourceKind::LdsDmaIssue:
    return "lds_dma_issue";
  case InstructionResourceKind::NumResources:
    break;
  }
  llvm_unreachable("bad instruction resource kind");
}

InstructionResourceScope
getInstructionResourceScope(InstructionResourceKind kind) {
  switch (kind) {
  case InstructionResourceKind::None:
    return InstructionResourceScope::Wave;
  case InstructionResourceKind::SimdIssue:
  case InstructionResourceKind::ValuPipe:
  case InstructionResourceKind::SaluPipe:
  case InstructionResourceKind::XdlPipe:
    return InstructionResourceScope::SIMD;
  case InstructionResourceKind::LdsDmaIssue:
    return InstructionResourceScope::SIMDPair;
  case InstructionResourceKind::CuIssue:
    return InstructionResourceScope::CU;
  case InstructionResourceKind::NumResources:
    break;
  }
  llvm_unreachable("bad instruction resource kind");
}

InstructionResourceState::InstructionResourceState(
    const ArchData &arch, unsigned waveCount,
    InstructionResourceCapacities capacities)
    : waveCount(waveCount) {
  assert(waveCount > 0 && "resource state needs one wave");
  assert(arch.simdsPerCU > 0 && "resource state needs one SIMD");
  assert(arch.simdsPerCU % 2 == 0 && "resource state needs SIMD pairs");
  simdResources.resize(static_cast<unsigned>(arch.simdsPerCU));
  simdPairResources.resize(static_cast<unsigned>(arch.simdsPerCU / 2));

  configure(InstructionResourceKind::SimdIssue, 1);
  configure(InstructionResourceKind::CuIssue,
            static_cast<unsigned>(arch.issuesPerCUPerCycle));
  configure(InstructionResourceKind::ValuPipe, capacities.valuPipe);
  configure(InstructionResourceKind::SaluPipe, capacities.saluPipe);
  configure(InstructionResourceKind::XdlPipe, capacities.xdlPipe);
  configure(InstructionResourceKind::LdsDmaIssue,
            arch.ldsDmaIssuePeriod == 0 ? 0 : 1);
}

void InstructionResourceState::configure(InstructionResourceKind kind,
                                         unsigned capacity) {
  switch (getInstructionResourceScope(kind)) {
  case InstructionResourceScope::Wave:
    llvm_unreachable("no wave-scoped issue resource");
  case InstructionResourceScope::SIMD:
    for (SIMDResourceDomain &domain : simdResources)
      domain[simdResourceIndex(kind)].capacity = capacity;
    return;
  case InstructionResourceScope::SIMDPair:
    for (SIMDPairResourceDomain &domain : simdPairResources)
      domain[simdPairResourceIndex(kind)].capacity = capacity;
    return;
  case InstructionResourceScope::CU:
    cuResources[cuResourceIndex(kind)].capacity = capacity;
    return;
  }
  llvm_unreachable("bad instruction resource scope");
}

const InstructionResourceState::ResourceCalendar &
InstructionResourceState::getCalendar(unsigned wave, WavePlacement placement,
                                      InstructionResourceKind kind) const {
  assert(wave < waveCount && "wave index out of range");
  assert(placement.simd < simdResources.size() && "SIMD index out of range");
  switch (getInstructionResourceScope(kind)) {
  case InstructionResourceScope::Wave:
    llvm_unreachable("no wave-scoped issue resource");
  case InstructionResourceScope::SIMD:
    return simdResources[placement.simd][simdResourceIndex(kind)];
  case InstructionResourceScope::SIMDPair:
    return simdPairResources[placement.simd / 2][simdPairResourceIndex(kind)];
  case InstructionResourceScope::CU:
    return cuResources[cuResourceIndex(kind)];
  }
  llvm_unreachable("bad instruction resource scope");
}

InstructionResourceState::ResourceCalendar &
InstructionResourceState::getCalendar(unsigned wave, WavePlacement placement,
                                      InstructionResourceKind kind) {
  return const_cast<ResourceCalendar &>(
      std::as_const(*this).getCalendar(wave, placement, kind));
}

bool InstructionResourceState::isEnabled(InstructionResourceKind kind) const {
  if (kind == InstructionResourceKind::None ||
      kind == InstructionResourceKind::NumResources)
    return false;
  return getCalendar(/*wave=*/0, /*placement=*/{}, kind).capacity != 0;
}

void InstructionResourceState::appendReservations(
    const InstructionResourceUse &use, int64_t issueCycle,
    SmallVectorImpl<Reservation> &reservations) {
  if (use.kind == InstructionResourceKind::None || use.count == 0 ||
      use.units == 0 || use.duration <= 0)
    return;
  assert(use.period >= 0 && "resource period below zero");
  for (unsigned index : llvm::seq<unsigned>(0, use.count)) {
    int64_t offset = saturatingAdd(
        use.offset,
        saturatingMultiply(static_cast<int64_t>(index), use.period));
    int64_t begin = saturatingAdd(issueCycle, offset);
    reservations.push_back(
        {begin, saturatingAdd(begin, use.duration), use.units});
  }
}

bool InstructionResourceState::canReserve(const ResourceCalendar &calendar,
                                          ArrayRef<Reservation> reservations) {
  if (reservations.empty())
    return true;
  if (calendar.capacity == 0)
    return false;

  SmallVector<ReservationEvent, 32> events;
  for (const Reservation &reservation : calendar.reservations) {
    events.push_back(
        {reservation.begin, static_cast<int64_t>(reservation.units)});
    events.push_back(
        {reservation.end, -static_cast<int64_t>(reservation.units)});
  }
  for (const Reservation &reservation : reservations) {
    events.push_back(
        {reservation.begin, static_cast<int64_t>(reservation.units)});
    events.push_back(
        {reservation.end, -static_cast<int64_t>(reservation.units)});
  }
  llvm::sort(events,
             [](const ReservationEvent &lhs, const ReservationEvent &rhs) {
               return lhs.cycle < rhs.cycle;
             });

  int64_t active = 0;
  for (size_t index = 0; index < events.size();) {
    int64_t cycle = events[index].cycle;
    int64_t delta = 0;
    do {
      delta += events[index].delta;
      ++index;
    } while (index < events.size() && events[index].cycle == cycle);
    active += delta;
    assert(active >= 0 && "resource reservation underflow");
    if (active > calendar.capacity)
      return false;
  }
  return true;
}

bool InstructionResourceState::hasReservation(
    const InstructionResourceUse &use) {
  return use.kind != InstructionResourceKind::None && use.duration > 0 &&
         use.count != 0 && use.units != 0;
}

LogicalResult InstructionResourceState::validateUses(
    ArrayRef<InstructionResourceUse> uses) const {
  for (const InstructionResourceUse &use : uses) {
    if (!hasReservation(use))
      continue;
    if (use.scope != getInstructionResourceScope(use.kind) ||
        !isEnabled(use.kind))
      return failure();
  }
  return success();
}

SmallVector<int64_t, 32> InstructionResourceState::getCandidateCycles(
    unsigned wave, WavePlacement placement,
    ArrayRef<InstructionResourceUse> uses, int64_t initialCycle) const {
  SmallVector<int64_t, 32> candidates = {initialCycle};
  for (const InstructionResourceUse &use : uses) {
    if (!hasReservation(use))
      continue;
    const ResourceCalendar &calendar = getCalendar(wave, placement, use.kind);
    for (unsigned index : llvm::seq<unsigned>(0, use.count)) {
      int64_t offset = saturatingAdd(
          use.offset,
          saturatingMultiply(static_cast<int64_t>(index), use.period));
      for (const Reservation &reservation : calendar.reservations) {
        if (reservation.end <= offset)
          continue;
        int64_t candidate = reservation.end - offset;
        if (candidate > initialCycle)
          candidates.push_back(candidate);
      }
    }
  }
  llvm::sort(candidates);
  candidates.erase(std::unique(candidates.begin(), candidates.end()),
                   candidates.end());
  return candidates;
}

bool InstructionResourceState::canReserveAt(
    unsigned wave, WavePlacement placement,
    ArrayRef<InstructionResourceUse> uses, int64_t cycle,
    InstructionResourceKind &blockedKind,
    InstructionResourceScope &blockedScope) const {
  std::array<SmallVector<Reservation, 4>, kResourceCount> additions;
  for (const InstructionResourceUse &use : uses)
    appendReservations(use, cycle, additions[resourceIndex(use.kind)]);

  for (size_t index = 1; index < kResourceCount; ++index) {
    if (additions[index].empty())
      continue;
    InstructionResourceKind kind = static_cast<InstructionResourceKind>(index);
    const ResourceCalendar &calendar = getCalendar(wave, placement, kind);
    if (canReserve(calendar, additions[index]))
      continue;
    blockedKind = kind;
    blockedScope = getInstructionResourceScope(kind);
    return false;
  }
  return true;
}

FailureOr<InstructionResourceQuery>
InstructionResourceState::query(unsigned wave, WavePlacement placement,
                                ArrayRef<InstructionResourceUse> uses,
                                int64_t earliestCycle) const {
  assert(earliestCycle >= 0 && "earliest cycle below zero");
  if (!llvm::any_of(uses, hasReservation))
    return InstructionResourceQuery{earliestCycle};
  if (failed(validateUses(uses)))
    return failure();

  int64_t initialCycle = std::max(earliestCycle, lastCommittedCycle);
  // Finite set: initial cycle plus existing reservation releases.
  SmallVector<int64_t, 32> candidates =
      getCandidateCycles(wave, placement, uses, initialCycle);

  InstructionResourceKind blockedKind = lastCommittedCycle > earliestCycle
                                            ? InstructionResourceKind::CuIssue
                                            : InstructionResourceKind::None;
  InstructionResourceScope blockedScope =
      getInstructionResourceScope(blockedKind);
  for (int64_t candidate : candidates)
    if (canReserveAt(wave, placement, uses, candidate, blockedKind,
                     blockedScope))
      return InstructionResourceQuery{candidate, blockedKind, blockedScope};
  return failure();
}

void InstructionResourceState::prune(int64_t cycle) {
  auto pruneDomain = [cycle](auto &domain) {
    for (ResourceCalendar &calendar : domain)
      llvm::erase_if(calendar.reservations,
                     [cycle](const Reservation &reservation) {
                       return reservation.end <= cycle;
                     });
  };
  for (SIMDResourceDomain &domain : simdResources)
    pruneDomain(domain);
  for (SIMDPairResourceDomain &domain : simdPairResources)
    pruneDomain(domain);
  pruneDomain(cuResources);
}

void InstructionResourceState::commit(unsigned wave, WavePlacement placement,
                                      ArrayRef<InstructionResourceUse> uses,
                                      int64_t issueCycle) {
  assert(issueCycle >= lastCommittedCycle && "resource timeline moved back");
  prune(issueCycle);

  std::array<SmallVector<Reservation, 4>, kResourceCount> additions;
  for (const InstructionResourceUse &use : uses)
    appendReservations(use, issueCycle, additions[resourceIndex(use.kind)]);

  for (size_t index = 1; index < kResourceCount; ++index) {
    if (additions[index].empty())
      continue;
    InstructionResourceKind kind = static_cast<InstructionResourceKind>(index);
    ResourceCalendar &calendar = getCalendar(wave, placement, kind);
    assert(canReserve(calendar, additions[index]) &&
           "committed resource use exceeds capacity");
    calendar.reservations.append(additions[index]);
  }
  lastCommittedCycle = issueCycle;
}

unsigned InstructionResourceState::getActiveReservationCount(
    InstructionResourceKind kind, unsigned wave, WavePlacement placement,
    int64_t cycle) const {
  if (!isEnabled(kind))
    return 0;
  const ResourceCalendar &calendar = getCalendar(wave, placement, kind);
  return llvm::count_if(
      calendar.reservations, [cycle](const Reservation &reservation) {
        return reservation.begin <= cycle && reservation.end > cycle;
      });
}

} // namespace mlir::waveamdmachine
