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

SmallVector<WavePlacement> getFullCUWavePlacements(const ArchData &arch,
                                                   Operation *context) {
  return getFullCUWavePlacements(arch, getTargetWaveCount(context));
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

MultiWaveExecutionState::MultiWaveExecutionState(
    const MultiWaveExecutionState &other)
    : placements(other.placements.begin(), other.placements.end()),
      resources(other.resources), arch(other.arch) {
  waves.reserve(other.waves.size());
  for (const InstructionExecutionState &wave : other.waves)
    waves.emplace_back(wave);
  llvm::append_range(roundRobinCursor, other.roundRobinCursor);
}

static bool areCohortWavesValid(const MultiWaveExecutionState &state,
                                ArrayRef<unsigned> waves) {
  llvm::SmallDenseSet<unsigned, 8> seen;
  return !waves.empty() && llvm::all_of(waves, [&](unsigned wave) {
    return wave < state.getWaveCount() && seen.insert(wave).second;
  });
}

MultiWaveCohortExecutionState::MultiWaveCohortExecutionState(
    const MultiWaveExecutionState &state, ArrayRef<unsigned> waves)
    : waves(waves.begin(), waves.end()),
      state(std::make_unique<MultiWaveExecutionState>(state)) {
  assert(areCohortWavesValid(state, waves) && "invalid multi-wave cohort");
}

MultiWaveCohortExecutionState::MultiWaveCohortExecutionState(
    const MultiWaveCohortExecutionState &other)
    : MultiWaveCohortExecutionState(*other.state, other.waves) {}

MultiWaveCohortExecutionState &MultiWaveCohortExecutionState::operator=(
    const MultiWaveCohortExecutionState &other) {
  state = std::make_unique<MultiWaveExecutionState>(*other.state);
  waves = other.waves;
  return *this;
}

FailureOr<InstructionCommitResult>
MultiWaveCohortExecutionState::commit(Operation *op) {
  SmallVector<Operation *, 8> candidates(state->getWaveCount(), nullptr);
  for (unsigned wave : waves)
    candidates[wave] = op;

  std::optional<InstructionCommitResult> first;
  while (llvm::any_of(candidates,
                      [](Operation *candidate) { return candidate; })) {
    FailureOr<unsigned> wave = state->selectWave(candidates);
    if (failed(wave))
      return failure();
    FailureOr<InstructionStall> stall =
        state->queryAfterIssueOpportunity(*wave, op);
    if (failed(stall))
      return failure();
    FailureOr<InstructionCommitResult> result = state->commit(*wave, op);
    if (failed(result))
      return failure();
    if (!first) {
      result->stall = std::move(*stall);
      first = *result;
    }
    candidates[*wave] = nullptr;
  }
  if (!first)
    return failure();
  return *first;
}

int64_t MultiWaveCohortExecutionState::getCurrentCycle() const {
  int64_t cycle = state->getCurrentCycle(waves.front());
  for (unsigned wave : ArrayRef<unsigned>(waves).drop_front())
    cycle = std::min(cycle, state->getCurrentCycle(wave));
  return cycle;
}

void MultiWaveCohortExecutionState::bindValue(Value result, Value source) {
  for (unsigned wave : waves)
    state->bindValue(wave, result, source);
}

void MultiWaveCohortExecutionState::bindValue(Value result,
                                              ArrayRef<Value> sources) {
  for (unsigned wave : waves)
    state->bindValue(wave, result, sources);
}

const InstructionScheduleModel &
MultiWaveCohortExecutionState::getScheduleModel() const {
  return state->getScheduleModel();
}

void MultiWaveCohortExecutionState::setState(
    std::unique_ptr<MultiWaveExecutionState> newState) {
  assert(newState && areCohortWavesValid(*newState, waves) &&
         "invalid multi-wave cohort state");
  state = std::move(newState);
}

std::unique_ptr<MultiWaveExecutionState>
MultiWaveCohortExecutionState::takeState() {
  assert(state && "missing multi-wave state");
  return std::move(state);
}

WavePlacement MultiWaveExecutionState::getPlacement(unsigned wave) const {
  assert(wave < placements.size() && "wave index out of range");
  return placements[wave];
}

unsigned MultiWaveExecutionState::getWaveCohort(unsigned wave,
                                                unsigned cohortCount) const {
  assert(cohortCount != 0 && "cohort count must be nonzero");
  WavePlacement placement = getPlacement(wave);
  unsigned ordinal = placements.size() > static_cast<size_t>(arch->simdsPerCU)
                         ? placement.slot
                         : placement.simd;
  return ordinal % cohortCount;
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

const InstructionScheduleModel &
MultiWaveExecutionState::getScheduleModel() const {
  assert(!waves.empty() && "multi-wave state has no waves");
  return waves.front().getScheduleModel();
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
  FailureOr<InstructionStall> stall = queryAfterIssueOpportunity(wave, op);
  return failed(stall) ? FailureOr<bool>(failure()) : stall->cycles != 0;
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
MultiWaveExecutionState::queryAfterIssueOpportunity(unsigned wave,
                                                    Operation *op) const {
  FailureOr<InstructionStall> raw = query(wave, op);
  FailureOr<int64_t> opportunity = getIssueOpportunityCycle(wave);
  if (failed(raw) || failed(opportunity))
    return failure();

  int64_t covered = std::max<int64_t>(0, *opportunity - getCurrentCycle(wave));
  InstructionStall stall;
  for (InstructionStallComponent component : raw->components) {
    component.cycles = std::max<int64_t>(0, component.cycles - covered);
    if (component.cycles == 0)
      continue;
    stall.components.push_back(component);
    if (component.cycles > stall.cycles) {
      stall.kind = component.kind;
      stall.cycles = component.cycles;
    }
  }
  return stall;
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
