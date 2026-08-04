//===- WaveAMDMachineScheduleModel.h - Machine scheduling policy -*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEMODEL_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEMODEL_H

#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/SmallVector.h"

#include <cstdint>
#include <memory>
#include <optional>

namespace mlir {
class Operation;
namespace func {
class FuncOp;
}
namespace waveamdmachine {
struct ArchData;
struct EventSimConfig;
struct InstructionExecutionConfig;
class InstructionScheduleModel;
} // namespace waveamdmachine

namespace wave {

waveamdmachine::InstructionExecutionConfig buildWaveAMDMachineInstructionConfig(
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, Operation *context);

struct ReadyScheduleWorkStats {
  uint64_t stateBuilds = 0;
  uint64_t memberVisits = 0;
  uint64_t projections = 0;
  uint64_t projectedNodes = 0;
  uint64_t projectionChecks = 0;
  uint64_t pressureSelections = 0;
  uint64_t pressureRejections = 0;
  uint64_t proposalSelections = 0;
  uint64_t proposalRejections = 0;
};

enum class ReadyScheduleProposalKind : uint8_t {
  // A single scheduler-selected candidate that still requires the model's
  // generic candidate admission.
  Direct,
  // A group of filler candidates. The model owns admission and ranking.
  RankedFiller,
  // Resource-stall fillers additionally require the model-owned decision to
  // open a sibling-wave overlap window.
  ResourceStallFiller,
  // A group ordered by the scheduler's generic resource preview. The model
  // owns admission and selects the final admissible candidate.
  ResourcePriority,
};

struct ReadyScheduleProposal {
  unsigned candidate = 0;
  ReadyScheduleProposalKind kind = ReadyScheduleProposalKind::Direct;
  // Lower groups are tried first. Candidates in one group form one
  // tournament: if its final winner is rejected, an earlier runner-up is not
  // revived.
  unsigned group = 0;
  // Generic scheduler score. ResourcePriority selects the highest-ranked
  // admitted candidate; pressure admission and final-prefix validation remain
  // model-owned. Other proposal kinds ignore this field.
  uint64_t rank = 0;
  // Generic baseline resource preview. ResourceStallFiller proposals in one
  // group carry identical values; other proposal kinds ignore them.
  int64_t waitSlots = 0;
  unsigned releaseSlots = 0;
};

struct ReadyScheduleDecision {
  // No candidate means retain the baseline.
  std::optional<unsigned> candidate;
  // Pressure-selection provenance and diagnostics remain model-owned. This
  // only distinguishes a generic scheduler proposal from a model discovery.
  bool selectedProposal = false;
  // A proposal tournament produced an unsafe final winner. Callers may try an
  // explicit later proposal group, but must not manufacture an implicit
  // runner-up or recurrence fallback.
  bool suppressFallback = false;
};

class ReadyRegionScheduleModel {
public:
  ReadyRegionScheduleModel(ReadyRegionScheduleModel &&);
  ReadyRegionScheduleModel &operator=(ReadyRegionScheduleModel &&);
  ~ReadyRegionScheduleModel();

  ReadyRegionScheduleModel(const ReadyRegionScheduleModel &) = delete;
  ReadyRegionScheduleModel &
  operator=(const ReadyRegionScheduleModel &) = delete;

  ReadyScheduleDecision
  selectNext(const llvm::BitVector &scheduled, unsigned baseline,
             const llvm::BitVector &legalReadyCandidates,
             ArrayRef<ReadyScheduleProposal> proposals,
             const waveamdmachine::InstructionScheduleModel &policy) const;

  ReadyScheduleWorkStats getWorkStats() const;

private:
  friend class WaveAMDMachineScheduleModel;
  struct Impl;
  explicit ReadyRegionScheduleModel(std::unique_ptr<Impl> impl);
  std::unique_ptr<Impl> impl;
};

// Owns the function liveness used by every region pressure decision.
class WaveAMDMachineScheduleModel {
public:
  static FailureOr<WaveAMDMachineScheduleModel> create(func::FuncOp func);

  WaveAMDMachineScheduleModel(WaveAMDMachineScheduleModel &&);
  WaveAMDMachineScheduleModel &operator=(WaveAMDMachineScheduleModel &&);
  ~WaveAMDMachineScheduleModel();

  WaveAMDMachineScheduleModel(const WaveAMDMachineScheduleModel &) = delete;
  WaveAMDMachineScheduleModel &
  operator=(const WaveAMDMachineScheduleModel &) = delete;

  ReadyRegionScheduleModel
  createRegion(ArrayRef<Operation *> operations,
               ArrayRef<SmallVector<unsigned, 4>> predecessors,
               ArrayRef<SmallVector<unsigned, 4>> successors) const;

private:
  struct Impl;
  explicit WaveAMDMachineScheduleModel(std::unique_ptr<Impl> impl);
  std::unique_ptr<Impl> impl;
};

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEMODEL_H
