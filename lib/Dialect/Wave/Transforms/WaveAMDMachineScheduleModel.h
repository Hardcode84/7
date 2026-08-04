//===- WaveAMDMachineScheduleModel.h - Machine scheduling model -*- C++ -*-===//
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

namespace mlir {
class Operation;
namespace func {
class FuncOp;
}
namespace waveamdmachine {
struct ArchData;
struct EventSimConfig;
struct InstructionExecutionConfig;
struct ReadyCandidateMetrics;
struct ReadyRegisterPressure;
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
};

class ReadyScheduleState;

class RegionScheduleSession {
public:
  RegionScheduleSession(RegionScheduleSession &&);
  RegionScheduleSession &operator=(RegionScheduleSession &&);
  ~RegionScheduleSession();

  RegionScheduleSession(const RegionScheduleSession &) = delete;
  RegionScheduleSession &operator=(const RegionScheduleSession &) = delete;

  const ReadyScheduleState &
  getReadyState(const llvm::BitVector &scheduled) const;
  waveamdmachine::ReadyRegisterPressure
  getReadyPressure(const ReadyScheduleState &state) const;
  waveamdmachine::ReadyCandidateMetrics
  getReadyCandidateMetrics(unsigned candidate,
                           const ReadyScheduleState &state) const;
  ReadyScheduleWorkStats getWorkStats() const;

private:
  friend class WaveAMDMachineScheduleModel;
  struct Impl;
  explicit RegionScheduleSession(std::unique_ptr<Impl> impl);
  std::unique_ptr<Impl> impl;
};

class WaveAMDMachineScheduleModel {
public:
  static FailureOr<WaveAMDMachineScheduleModel>
  create(func::FuncOp func, const waveamdmachine::ArchData &arch);

  WaveAMDMachineScheduleModel(WaveAMDMachineScheduleModel &&);
  WaveAMDMachineScheduleModel &operator=(WaveAMDMachineScheduleModel &&);
  ~WaveAMDMachineScheduleModel();

  WaveAMDMachineScheduleModel(const WaveAMDMachineScheduleModel &) = delete;
  WaveAMDMachineScheduleModel &
  operator=(const WaveAMDMachineScheduleModel &) = delete;

  // Session borrows operations and graph topology.
  RegionScheduleSession
  createRegionSession(ArrayRef<Operation *> operations,
                      ArrayRef<SmallVector<unsigned, 4>> predecessors,
                      ArrayRef<SmallVector<unsigned, 4>> successors,
                      llvm::BitVector noInstructions) const;

private:
  struct Impl;
  explicit WaveAMDMachineScheduleModel(std::unique_ptr<Impl> impl);
  std::unique_ptr<Impl> impl;
};

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEMODEL_H
