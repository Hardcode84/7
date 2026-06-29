//===- WaveAMDMachineScheduleSupport.h - Scheduler support ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULESUPPORT_H
#define DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULESUPPORT_H

#include "RegAlloc/WaveAMDRegLiveIntervals.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/CalibrationData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Operation.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/Support/raw_ostream.h"

#include <cstdint>
#include <optional>
#include <string>

namespace mlir::wave {

struct ScheduleRegion {
  SmallVector<Operation *, 16> ops;
  func::FuncOp func;
  Operation *first = nullptr;
  Operation *last = nullptr;
  unsigned blockOrdinal = 0;
  unsigned regionOrdinal = 0;
  unsigned opCount = 0;
  unsigned instructionOpCount = 0;
};

enum class EdgeKind {
  Ssa,
  MemToken,
  LoopCarry,
  Flag,
};

struct ScheduleEdge {
  unsigned src = 0;
  unsigned dst = 0;
  EdgeKind kind = EdgeKind::Ssa;
  bool recurrence = false;
};

struct DependenceGraph {
  SmallVector<ScheduleEdge, 32> edges;
};

struct ArchResolution {
  StringRef fallbackReason;
  const waveamdmachine::ArchData *arch = nullptr;
};

struct ScoreResult {
  StringRef fallbackReason;
  int64_t cycles = 0;
  int64_t issuedOps = 0;
  bool supported = false;
};

struct RegisterPressureBudgets {
  int hardVGPR = -1;
  int hardSGPR = -1;
  int criticalVGPR = -1;
  int criticalSGPR = -1;
  int derivedHardVGPR = -1;
  int derivedHardSGPR = -1;
  int derivedCriticalVGPR = -1;
  int derivedCriticalSGPR = -1;
  bool reportBudgets = false;
  bool selectionEnabled = false;
};

struct RegisterPressureResult {
  StringRef fallbackReason;
  int64_t hardVGPRExcess = 0;
  int64_t hardSGPRExcess = 0;
  int64_t criticalVGPRExcess = 0;
  int64_t criticalSGPRExcess = 0;
  unsigned maxVGPR = 0;
  unsigned maxSGPR = 0;
  bool supported = false;
  bool conservative = false;
};

struct CandidateMetrics {
  ScoreResult score;
  RegisterPressureResult pressure;
  int64_t originalCycleDelta = 0;
  int64_t counterBurstCycles = 0;
  int64_t hazardWaitCycles = 0;
  uint64_t orderDisplacement = 0;
};

enum class PressureEvaluation {
  None,
  Eager,
  LazyHardCap,
};

struct CandidateRequest {
  SmallVector<unsigned, 16> order;
  StringRef fallbackReason;
  bool requested = false;
  bool parsed = false;
};

struct EvaluatedCandidate {
  SmallVector<unsigned, 16> order;
  CandidateMetrics metrics;
  std::string name;
};

struct ScheduleDecision {
  SmallVector<EvaluatedCandidate, 4> candidates;
  unsigned selected = 0;
};

struct ScheduleSearchLimits {
  int64_t maxBeamWork = -1;
  int maxRegionOps = -1;
  bool emitDiagnostics = false;
  bool emitRemarks = false;
};

struct SchedulePressureContext {
  WaveAMDLiveIntervalBuildResult intervals;
  StringRef fallbackReason;
  bool supported = false;
};

SmallVector<ScheduleRegion> collectScheduleRegions(func::FuncOp func);
StringRef getEdgeKindName(EdgeKind kind);
DependenceGraph buildDependenceGraph(const ScheduleRegion &region);
void printRegion(ScheduleRegion region);
void printOpClasses(ScheduleRegion region, ArchResolution archResolution,
                    const waveamdmachine::EventSimConfig &modelConfig);
void printDependences(ScheduleRegion region, const DependenceGraph &graph);
bool exceedsScheduleRegionLimit(ScheduleRegion region,
                                ScheduleSearchLimits limits);
LogicalResult
applyFunctionScheduleSearchLimitOverrides(func::FuncOp func,
                                          ScheduleSearchLimits &limits);
void printScheduleRegionLimitSkip(ScheduleRegion region,
                                  ScheduleSearchLimits limits);
void emitScheduleRegionLimitRemark(ScheduleRegion region,
                                   ScheduleSearchLimits limits);
void emitScheduleBeamWorkRemark(ScheduleRegion region, int64_t estimatedWork,
                                ScheduleSearchLimits limits);

ArchResolution resolveArch(Operation *op);
int64_t getHardExcess(RegisterPressureResult pressure);
int64_t getCriticalExcess(RegisterPressureResult pressure);
bool hasCriticalBudget(RegisterPressureBudgets budgets);
bool hasHardBudget(RegisterPressureBudgets budgets);
SchedulePressureContext buildSchedulePressureContext(func::FuncOp func);
LogicalResult
configureScheduleModel(Operation *op, int modelWaves, int modelSimds,
                       int modelStartDelay, int modelVmemValueLatency,
                       int modelSmemValueLatency, int modelLdsValueLatency,
                       waveamdmachine::EventSimConfig &modelConfig);
LogicalResult
finalizeScheduleModel(Operation *op, ArchResolution archResolution,
                      waveamdmachine::EventSimConfig &modelConfig);
LogicalResult loadScheduleCalibration(
    Operation *op, StringRef calibrationFile,
    std::optional<waveamdmachine::CalibrationData> &calibration);
LogicalResult
validateScheduleCalibration(Operation *op, ArchResolution archResolution,
                            const waveamdmachine::EventSimConfig &modelConfig);
LogicalResult configureSchedulePressureBudgets(
    Operation *op, ArchResolution archResolution, bool pressureAwareSelection,
    int pressureVgprBudget, int pressureSgprBudget,
    int pressureCriticalVgprBudget, int pressureCriticalSgprBudget,
    int pressureTargetWavesOverride, RegisterPressureBudgets &budgets);

CandidateMetrics evaluateOps(const ScheduleRegion &region,
                             ArrayRef<Operation *> ops,
                             ArchResolution archResolution,
                             const waveamdmachine::EventSimConfig &modelConfig,
                             const RegisterPressureBudgets &budgets,
                             PressureEvaluation pressureEvaluation);
void printPressure(raw_ostream &os, const RegisterPressureResult &pressure,
                   const RegisterPressureBudgets &budgets);
bool shouldReportPressureBudgets(RegisterPressureBudgets budgets);
void printPressureBudgets(func::FuncOp func,
                          const RegisterPressureBudgets &budgets);
CandidateRequest getCandidateRequest(StringRef orderText, int scoreRegion);
bool shouldScoreCandidate(const ScheduleRegion &region, StringRef scoreFunc,
                          int scoreRegion);
CandidateMetrics evaluateCandidateRequest(
    const ScheduleRegion &region, const DependenceGraph &graph,
    const CandidateRequest &candidate, ArchResolution archResolution,
    const waveamdmachine::EventSimConfig &modelConfig,
    const RegisterPressureBudgets &budgets);
void printRegionScores(const ScheduleRegion &region,
                       const DependenceGraph &graph,
                       ArchResolution archResolution,
                       const waveamdmachine::EventSimConfig &modelConfig,
                       const RegisterPressureBudgets &budgets,
                       const CandidateRequest &candidate, bool scoreCandidate);

ScheduleDecision evaluateScheduleCandidates(
    const ScheduleRegion &region, const DependenceGraph &graph,
    ArchResolution archResolution,
    const waveamdmachine::EventSimConfig &modelConfig,
    const RegisterPressureBudgets &budgets, bool enableBeamSearch,
    ScheduleSearchLimits limits, PressureEvaluation pressureEvaluation,
    bool allowPressureUpperBound,
    const SchedulePressureContext *pressureContext);
void printOrder(raw_ostream &os, ArrayRef<unsigned> order);
void printCandidateDiagnostics(ScheduleRegion region,
                               const ScheduleDecision &decision,
                               const RegisterPressureBudgets &budgets);
void printScheduleDecision(ScheduleRegion region,
                           const ScheduleDecision &decision, bool willApply);
bool shouldApplyDecision(const ScheduleDecision &decision,
                         RegisterPressureBudgets budgets);
void applyScheduleOrder(const ScheduleRegion &region, ArrayRef<unsigned> order);

} // namespace mlir::wave

#endif // DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULESUPPORT_H
