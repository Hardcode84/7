//===- MultiWaveExecutionState.cpp - Shared CU timing state ---------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/MultiWaveExecutionState.h"

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Operation.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/Sequence.h"

#include <algorithm>
#include <cassert>

namespace mlir::waveamdmachine {

static bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         WaveAMDMachineDialect::getDialectNamespace();
}

static InstructionResourceKind resourceForPipe(InstructionPipeKind kind) {
  switch (kind) {
  case InstructionPipeKind::None:
    return InstructionResourceKind::None;
  case InstructionPipeKind::VALU:
    return InstructionResourceKind::ValuPipe;
  case InstructionPipeKind::SALU:
    return InstructionResourceKind::SaluPipe;
  case InstructionPipeKind::XDL:
    return InstructionResourceKind::XdlPipe;
  }
  llvm_unreachable("bad instruction pipe kind");
}

struct MultiWaveCandidate {
  int64_t cycle = 0;
  unsigned wave = 0;
  unsigned simd = 0;
  unsigned roundRobinRank = 0;
};

static bool isEarlier(const MultiWaveCandidate &lhs,
                      const MultiWaveCandidate &rhs) {
  if (lhs.cycle != rhs.cycle)
    return lhs.cycle < rhs.cycle;
  if (lhs.simd != rhs.simd)
    return lhs.simd < rhs.simd;
  if (lhs.roundRobinRank != rhs.roundRobinRank)
    return lhs.roundRobinRank < rhs.roundRobinRank;
  return lhs.wave < rhs.wave;
}

bool areWavePlacementsValid(const ArchData &arch,
                            ArrayRef<WavePlacement> placements) {
  if (placements.empty())
    return false;
  size_t maxPlacements =
      static_cast<size_t>(arch.simdsPerCU) * arch.wavesPerSIMD;
  if (placements.size() > maxPlacements)
    return false;

  llvm::SmallDenseSet<uint64_t, 16> seen;
  for (WavePlacement placement : placements) {
    if (placement.simd >= static_cast<unsigned>(arch.simdsPerCU) ||
        placement.slot >= static_cast<unsigned>(arch.wavesPerSIMD))
      return false;
    uint64_t key = static_cast<uint64_t>(placement.simd) * arch.wavesPerSIMD +
                   placement.slot;
    if (!seen.insert(key).second)
      return false;
  }
  return true;
}

SmallVector<WavePlacement> getFullCUWavePlacements(const ArchData &arch,
                                                   unsigned wavesPerSIMD) {
  SmallVector<WavePlacement> placements;
  if (wavesPerSIMD == 0 ||
      wavesPerSIMD > static_cast<unsigned>(arch.wavesPerSIMD))
    return placements;
  placements.reserve(static_cast<size_t>(arch.simdsPerCU) * wavesPerSIMD);
  for (unsigned simd :
       llvm::seq<unsigned>(0, static_cast<unsigned>(arch.simdsPerCU)))
    for (unsigned slot : llvm::seq<unsigned>(0, wavesPerSIMD))
      placements.push_back({simd, slot});
  return placements;
}

MultiWaveExecutionState::MultiWaveExecutionState(
    const ArchData &arch, ArrayRef<WavePlacement> placements,
    InstructionExecutionConfig config)
    : placements(placements.begin(), placements.end()),
      resources(arch, placements.size(),
                InstructionExecutionState::getResourceCapacities(config)),
      arch(&arch) {
  assert(areWavePlacementsValid(arch, placements) &&
         "invalid resident wave placements");
  waves.reserve(placements.size());
  for ([[maybe_unused]] WavePlacement placement : placements)
    waves.emplace_back(arch, config);
  roundRobinCursor.assign(static_cast<unsigned>(arch.simdsPerCU), 0);
}

WavePlacement MultiWaveExecutionState::getPlacement(unsigned wave) const {
  assert(wave < placements.size() && "wave index out of range");
  return placements[wave];
}

int64_t MultiWaveExecutionState::getCurrentCycle(unsigned wave) const {
  assert(wave < waves.size() && "wave index out of range");
  return waves[wave].getCurrentCycle();
}

void MultiWaveExecutionState::rendezvous() {
  int64_t cycle = 0;
  for (const InstructionExecutionState &wave : waves)
    cycle = std::max(cycle, wave.getCurrentCycle());
  for (InstructionExecutionState &wave : waves)
    wave.advanceToCycle(cycle);
}

int64_t MultiWaveExecutionState::getValueReadyCycle(unsigned wave,
                                                    Value value) const {
  assert(wave < waves.size() && "wave index out of range");
  return waves[wave].getValueReadyCycle(value);
}

void MultiWaveExecutionState::bindValue(unsigned wave, Value result,
                                        Value source) {
  assert(wave < waves.size() && "wave index out of range");
  waves[wave].bindValue(result, source);
}

void MultiWaveExecutionState::bindValue(unsigned wave, Value result,
                                        ArrayRef<Value> sources) {
  assert(wave < waves.size() && "wave index out of range");
  waves[wave].bindValue(result, sources);
}

unsigned MultiWaveExecutionState::getPendingMemoryEventCount(
    unsigned wave, InstructionWaitCounterKind kind) const {
  assert(wave < waves.size() && "wave index out of range");
  return waves[wave].getPendingMemoryEventCount(kind);
}

unsigned
MultiWaveExecutionState::getPipeInFlightCount(unsigned wave,
                                              InstructionPipeKind kind) const {
  assert(wave < waves.size() && "wave index out of range");
  return resources.getActiveReservationCount(
      resourceForPipe(kind), wave, placements[wave], getCurrentCycle(wave));
}

unsigned MultiWaveExecutionState::getRoundRobinRank(unsigned wave) const {
  assert(arch->waveIssueArbitration == WaveIssueArbitration::RoundRobin &&
         "unsupported wave issue arbitration");
  WavePlacement placement = placements[wave];
  unsigned cursor = roundRobinCursor[placement.simd];
  return (placement.slot + arch->wavesPerSIMD - cursor) % arch->wavesPerSIMD;
}

FailureOr<unsigned>
MultiWaveExecutionState::selectWave(ArrayRef<Operation *> candidates) const {
  assert(candidates.size() == waves.size() && "one candidate per wave");
  std::optional<MultiWaveCandidate> best;
  for (unsigned wave : llvm::seq<unsigned>(getWaveCount())) {
    Operation *op = candidates[wave];
    if (!op)
      continue;
    FailureOr<InstructionStall> stall = query(wave, op);
    if (failed(stall))
      return failure();
    WavePlacement placement = placements[wave];
    MultiWaveCandidate candidate{getCurrentCycle(wave) + stall->cycles, wave,
                                 placement.simd, getRoundRobinRank(wave)};
    if (!best || isEarlier(candidate, *best))
      best = candidate;
  }
  if (!best)
    return failure();
  return best->wave;
}

FailureOr<bool> MultiWaveExecutionState::wouldStall(unsigned wave,
                                                    Operation *op) const {
  FailureOr<InstructionStall> stall = query(wave, op);
  if (failed(stall))
    return failure();
  FailureOr<int64_t> opportunity = getIssueOpportunityCycle(wave);
  if (failed(opportunity))
    return failure();
  return getCurrentCycle(wave) + stall->cycles > *opportunity;
}

FailureOr<int64_t>
MultiWaveExecutionState::getIssueOpportunityCycle(unsigned wave) const {
  assert(wave < waves.size() && "wave index out of range");
  SmallVector<InstructionResourceUse, 2> uses;
  int64_t issuePeriod = waves[wave].getIssuePeriod();
  waves[wave].appendIssueResourceUses(/*count=*/1, /*offset=*/0, issuePeriod,
                                      uses);
  FailureOr<InstructionResourceQuery> query = resources.query(
      wave, placements[wave], uses, waves[wave].getCurrentCycle());
  if (failed(query))
    return failure();
  return query->readyCycle;
}

FailureOr<InstructionStall>
MultiWaveExecutionState::query(unsigned wave, Operation *op) const {
  if (wave >= waves.size()) {
    op->emitOpError("wave index out of range");
    return failure();
  }
  if (!isInstructionExecutionStateArchSupported(arch->isa)) {
    op->emitOpError("instruction execution state supports gfx942, gfx950, "
                    "and RDNA3 only");
    return failure();
  }
  if (!isWaveAMDMachineOp(op)) {
    op->emitOpError("instruction execution state expects a waveamdmachine op");
    return failure();
  }
  InstructionExecutionState::InstructionDesc desc = waves[wave].describe(op);
  return waves[wave].queryWithResources(op, desc, &resources, wave,
                                        placements[wave]);
}

FailureOr<InstructionCommitResult>
MultiWaveExecutionState::commit(unsigned wave, Operation *op) {
  if (wave >= waves.size()) {
    op->emitOpError("wave index out of range");
    return failure();
  }
  FailureOr<InstructionCommitResult> result =
      waves[wave].commitWithResources(op, &resources, wave, placements[wave]);
  if (failed(result) || classifyOp(op) == SchedClass::NoInst)
    return result;
  WavePlacement placement = placements[wave];
  roundRobinCursor[placement.simd] = (placement.slot + 1) % arch->wavesPerSIMD;
  return result;
}

} // namespace mlir::waveamdmachine
