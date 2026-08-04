//===- MultiWaveExecutionState.h - Shared CU timing state -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MULTIWAVEEXECUTIONSTATE_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MULTIWAVEEXECUTIONSTATE_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.h"

#include <memory>

namespace mlir::waveamdmachine {

bool areWavePlacementsValid(const ArchData &arch,
                            ArrayRef<WavePlacement> placements);
SmallVector<WavePlacement> getFullCUWavePlacements(const ArchData &arch,
                                                   unsigned wavesPerSIMD);

class MultiWaveExecutionState {
public:
  MultiWaveExecutionState(const ArchData &arch,
                          ArrayRef<WavePlacement> placements,
                          InstructionExecutionConfig config);
  MultiWaveExecutionState(const MultiWaveExecutionState &other);
  MultiWaveExecutionState &operator=(const MultiWaveExecutionState &) = delete;

  unsigned getWaveCount() const { return waves.size(); }
  WavePlacement getPlacement(unsigned wave) const;
  unsigned getWaveCohort(unsigned wave, unsigned cohortCount) const;
  int64_t getCurrentCycle(unsigned wave) const;
  void rendezvous();
  int64_t getValueReadyCycle(unsigned wave, Value value) const;
  void bindValue(unsigned wave, Value result, Value source);
  void bindValue(unsigned wave, Value result, ArrayRef<Value> sources);
  const InstructionScheduleModel &getScheduleModel() const;
  unsigned getPendingMemoryEventCount(unsigned wave,
                                      InstructionWaitCounterKind kind) const;
  unsigned getPipeInFlightCount(unsigned wave, InstructionPipeKind kind) const;

  FailureOr<unsigned> selectWave(ArrayRef<Operation *> candidates) const;
  FailureOr<bool> wouldStall(unsigned wave, Operation *op) const;
  FailureOr<InstructionStall> queryAfterIssueOpportunity(unsigned wave,
                                                         Operation *op) const;
  FailureOr<InstructionStall> query(unsigned wave, Operation *op) const;
  FailureOr<InstructionCommitResult> commit(unsigned wave, Operation *op);

private:
  FailureOr<int64_t> getIssueOpportunityCycle(unsigned wave) const;
  unsigned getRoundRobinRank(unsigned wave) const;

  SmallVector<WavePlacement, 8> placements;
  SmallVector<InstructionExecutionState, 8> waves;
  SmallVector<unsigned, 4> roundRobinCursor;
  InstructionResourceState resources;
  const ArchData *arch = nullptr;
};

class MultiWaveCohortExecutionState {
public:
  MultiWaveCohortExecutionState(const MultiWaveExecutionState &state,
                                ArrayRef<unsigned> waves);
  MultiWaveCohortExecutionState(const MultiWaveCohortExecutionState &other);
  MultiWaveCohortExecutionState &
  operator=(const MultiWaveCohortExecutionState &other);
  MultiWaveCohortExecutionState(MultiWaveCohortExecutionState &&) = default;
  MultiWaveCohortExecutionState &
  operator=(MultiWaveCohortExecutionState &&) = default;

  FailureOr<InstructionCommitResult> commit(Operation *op);
  int64_t getCurrentCycle() const;
  void bindValue(Value result, Value source);
  void bindValue(Value result, ArrayRef<Value> sources);
  const InstructionScheduleModel &getScheduleModel() const;
  bool hasSharedResourceState() const { return true; }
  void setState(std::unique_ptr<MultiWaveExecutionState> newState);
  std::unique_ptr<MultiWaveExecutionState> takeState();

private:
  SmallVector<unsigned, 4> waves;
  std::unique_ptr<MultiWaveExecutionState> state;
};

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MULTIWAVEEXECUTIONSTATE_H
