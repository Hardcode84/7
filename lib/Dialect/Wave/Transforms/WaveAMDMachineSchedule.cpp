//===- WaveAMDMachineSchedule.cpp - WaveAMDMachine scheduler ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// Scheduler design:
// - Split funcs into straight-line local regions. Control flow, waitcnt,
//   barriers, priority changes, nested regions, and unknown effects bound them.
// - Legal motion follows SSA and explicit mem-token edges. Memory ops without
//   a token edge are independent for this pass.
// - Candidate orders are deterministic permutations of one region. Loop-carried
//   recurrence edges are diagnostics, not intra-iteration ordering constraints.
// - Cost policy ranks legal candidates. Rewrite only applies a selected
//   non-original order; selection may prefer pressure over cycles.

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDMachineScheduleSupport.h"
#include "WaveAMDRegAllocPrep.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/IR/BuiltinOps.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMACHINESCHEDULE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static bool isValidLatencyOverride(int value) { return value >= -1; }

struct WaveAMDMachineSchedulePass
    : public wave::impl::WaveAMDMachineScheduleBase<
          WaveAMDMachineSchedulePass> {
  using WaveAMDMachineScheduleBase::WaveAMDMachineScheduleBase;

  LogicalResult configureModel(ModuleOp mod,
                               waveamdmachine::EventSimConfig &modelConfig) {
    if (modelWaves <= 0) {
      mod.emitError() << "model-waves must be positive";
      return failure();
    }
    if (modelSimds <= 0) {
      mod.emitError() << "model-simds must be positive";
      return failure();
    }
    if (modelStartDelay < 0) {
      mod.emitError() << "model-start-delay must be non-negative";
      return failure();
    }
    if (!isValidLatencyOverride(modelVmemValueLatency) ||
        !isValidLatencyOverride(modelSmemValueLatency) ||
        !isValidLatencyOverride(modelLdsValueLatency)) {
      mod.emitError() << "model value latencies must be -1 or non-negative";
      return failure();
    }
    modelConfig.waves = modelWaves;
    modelConfig.simds = modelSimds;
    modelConfig.startDelay = modelStartDelay;
    modelConfig.valueLatencies.vmemLoad = modelVmemValueLatency;
    modelConfig.valueLatencies.smemLoad = modelSmemValueLatency;
    modelConfig.valueLatencies.lds = modelLdsValueLatency;
    return success();
  }

  LogicalResult configurePressureBudgets(ModuleOp mod,
                                         ArchResolution archResolution,
                                         RegisterPressureBudgets &budgets) {
    if (failed(validatePressureOptions(mod, archResolution)))
      return failure();
    copyPressureBudgets(budgets);
    if (failed(applyDerivedCriticalBudget(archResolution, budgets)))
      return failure();
    budgets.selectionEnabled =
        pressureAwareSelection &&
        (hasHardBudget(budgets) || hasCriticalBudget(budgets));
    return success();
  }

  LogicalResult validatePressureOptions(ModuleOp mod,
                                        ArchResolution archResolution) {
    if (pressureVgprBudget < -1 || pressureSgprBudget < -1 ||
        pressureCriticalVgprBudget < -1 || pressureCriticalSgprBudget < -1 ||
        pressureTargetWaves < -1) {
      mod.emitError() << "pressure budgets must be -1 or non-negative";
      return failure();
    }
    if (pressureTargetWaves > 0 && archResolution.arch &&
        pressureTargetWaves > archResolution.arch->wavesPerSIMD) {
      mod.emitError() << "pressure-target-waves exceeds target wave capacity";
      return failure();
    }
    return success();
  }

  void copyPressureBudgets(RegisterPressureBudgets &budgets) {
    budgets.hardVGPR = pressureVgprBudget;
    budgets.hardSGPR = pressureSgprBudget;
    budgets.criticalVGPR = pressureCriticalVgprBudget;
    budgets.criticalSGPR = pressureCriticalSgprBudget;
  }

  LogicalResult applyDerivedCriticalBudget(ArchResolution archResolution,
                                           RegisterPressureBudgets &budgets) {
    if (!(pressureAwareSelection && budgets.criticalVGPR < 0 &&
          pressureTargetWaves >= 0 && archResolution.arch))
      return success();
    FailureOr<int> derived =
        deriveCriticalVGPRBudget(*archResolution.arch, pressureTargetWaves);
    if (failed(derived))
      return failure();
    budgets.criticalVGPR = *derived;
    return success();
  }

  void runOnOperation() override {
    ModuleOp mod = getOperation();
    ArchResolution archResolution = resolveArch(mod);
    waveamdmachine::EventSimConfig modelConfig;
    if (failed(configureModel(mod, modelConfig)))
      return signalPassFailure();
    RegisterPressureBudgets pressureBudgets;
    if (failed(configurePressureBudgets(mod, archResolution, pressureBudgets)))
      return signalPassFailure();
    CandidateRequest candidate =
        getCandidateRequest(StringRef(scoreOrder), scoreRegion);
    bool emitScores = printScore || candidate.requested;
    bool runScheduler = printCandidates || applySchedule;
    bool measurePressure = emitScores || runScheduler;
    StringRef scoreFuncName(scoreFunc);
    WalkResult walkResult = mod.walk([&](func::FuncOp func) {
      if (failed(processFunction(func, archResolution, modelConfig,
                                 pressureBudgets, candidate, scoreFuncName,
                                 emitScores, runScheduler, measurePressure)))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if (walkResult.wasInterrupted())
      return signalPassFailure();
  }

  LogicalResult
  processFunction(func::FuncOp func, ArchResolution archResolution,
                  const waveamdmachine::EventSimConfig &modelConfig,
                  const RegisterPressureBudgets &pressureBudgets,
                  const CandidateRequest &candidate, StringRef scoreFuncName,
                  bool emitScores, bool runScheduler, bool measurePressure) {
    if (func.isExternal())
      return success();
    if (measurePressure && failed(wave::prepareWaveAMDRegAllocIR(func)))
      return failure();
    SmallVector<ScheduleRegion> regions = collectScheduleRegions(func);
    for (const ScheduleRegion &region : regions)
      processRegion(region, archResolution, modelConfig, pressureBudgets,
                    candidate, scoreFuncName, emitScores, runScheduler);
    return success();
  }

  void processRegion(const ScheduleRegion &region,
                     ArchResolution archResolution,
                     const waveamdmachine::EventSimConfig &modelConfig,
                     const RegisterPressureBudgets &pressureBudgets,
                     const CandidateRequest &candidate, StringRef scoreFuncName,
                     bool emitScores, bool runScheduler) {
    bool scoreCandidate =
        candidate.requested &&
        shouldScoreCandidate(region, scoreFuncName, scoreRegion);
    DependenceGraph graph;
    if (printDeps || scoreCandidate || runScheduler)
      graph = buildDependenceGraph(region);
    if (printRegions)
      printRegion(region);
    if (printDeps)
      printDependences(region, graph);
    if (emitScores)
      printRegionScores(region, graph, archResolution, modelConfig,
                        pressureBudgets, candidate, scoreCandidate);
    if (runScheduler)
      processScheduler(region, graph, archResolution, modelConfig,
                       pressureBudgets);
  }

  void processScheduler(const ScheduleRegion &region,
                        const DependenceGraph &graph,
                        ArchResolution archResolution,
                        const waveamdmachine::EventSimConfig &modelConfig,
                        const RegisterPressureBudgets &pressureBudgets) {
    ScheduleDecision decision = evaluateScheduleCandidates(
        region, graph, archResolution, modelConfig, pressureBudgets);
    bool willApply =
        applySchedule && shouldApplyDecision(decision, pressureBudgets);
    if (printCandidates) {
      printCandidateDiagnostics(region, decision, pressureBudgets);
      printScheduleDecision(region, decision, willApply);
    }
    if (willApply)
      applyScheduleOrder(region, decision.candidates[decision.selected].order);
  }
};

} // namespace
