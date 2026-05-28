//===- WaveAMDMachineScheduleSupport.h - Scheduler support ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULESUPPORT_H
#define DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULESUPPORT_H

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Operation.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/Support/raw_ostream.h"

#include <cstdint>

namespace mlir::wave {

struct ScheduleRegion {
  func::FuncOp func;
  unsigned blockOrdinal = 0;
  unsigned regionOrdinal = 0;
  Operation *first = nullptr;
  Operation *last = nullptr;
  unsigned opCount = 0;
  SmallVector<Operation *, 16> ops;
};

enum class EdgeKind {
  Ssa,
  MemToken,
  LoopCarry,
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
  const waveamdmachine::ArchData *arch = nullptr;
  StringRef fallbackReason;
};

struct ScoreResult {
  bool supported = false;
  int64_t cycles = 0;
  int64_t issuedOps = 0;
  StringRef fallbackReason;
};

struct RegisterPressureBudgets {
  int hardVGPR = -1;
  int hardSGPR = -1;
  int criticalVGPR = -1;
  int criticalSGPR = -1;
  bool selectionEnabled = false;
};

struct RegisterPressureResult {
  bool supported = false;
  unsigned maxVGPR = 0;
  unsigned maxSGPR = 0;
  int64_t hardVGPRExcess = 0;
  int64_t hardSGPRExcess = 0;
  int64_t criticalVGPRExcess = 0;
  int64_t criticalSGPRExcess = 0;
  StringRef fallbackReason;
};

struct CandidateMetrics {
  ScoreResult score;
  RegisterPressureResult pressure;
};

struct CandidateRequest {
  bool requested = false;
  bool parsed = false;
  SmallVector<unsigned, 16> order;
  StringRef fallbackReason;
};

struct EvaluatedCandidate {
  StringRef name;
  SmallVector<unsigned, 16> order;
  CandidateMetrics metrics;
};

struct ScheduleDecision {
  SmallVector<EvaluatedCandidate, 4> candidates;
  unsigned selected = 0;
};

SmallVector<ScheduleRegion> collectScheduleRegions(func::FuncOp func);
StringRef getEdgeKindName(EdgeKind kind);
DependenceGraph buildDependenceGraph(const ScheduleRegion &region);
void printRegion(ScheduleRegion region);
void printDependences(ScheduleRegion region, const DependenceGraph &graph);

ArchResolution resolveArch(Operation *op);
int64_t getHardExcess(RegisterPressureResult pressure);
int64_t getCriticalExcess(RegisterPressureResult pressure);
bool hasCriticalBudget(RegisterPressureBudgets budgets);
bool hasHardBudget(RegisterPressureBudgets budgets);
FailureOr<int> deriveCriticalVGPRBudget(const waveamdmachine::ArchData &arch,
                                        int targetWaves);
LogicalResult
configureScheduleModel(ModuleOp mod, int modelWaves, int modelSimds,
                       int modelStartDelay, int modelVmemValueLatency,
                       int modelSmemValueLatency, int modelLdsValueLatency,
                       waveamdmachine::EventSimConfig &modelConfig);
LogicalResult configureSchedulePressureBudgets(
    ModuleOp mod, ArchResolution archResolution, bool pressureAwareSelection,
    int pressureVgprBudget, int pressureSgprBudget,
    int pressureCriticalVgprBudget, int pressureCriticalSgprBudget,
    int pressureTargetWaves, RegisterPressureBudgets &budgets);

CandidateMetrics evaluateOps(const ScheduleRegion &region,
                             ArrayRef<Operation *> ops,
                             ArchResolution archResolution,
                             const waveamdmachine::EventSimConfig &modelConfig,
                             const RegisterPressureBudgets &budgets);
void printPressure(raw_ostream &os, const RegisterPressureResult &pressure,
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

ScheduleDecision
evaluateScheduleCandidates(const ScheduleRegion &region,
                           const DependenceGraph &graph,
                           ArchResolution archResolution,
                           const waveamdmachine::EventSimConfig &modelConfig,
                           const RegisterPressureBudgets &budgets);
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
