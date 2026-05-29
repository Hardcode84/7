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
// - Cost policy ranks legal candidates. Hard register caps gate candidates;
//   explicit multi-wave targets add occupancy pressure ranking.

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

static PressureEvaluation
getSchedulePressureEvaluation(RegisterPressureBudgets budgets) {
  if (!budgets.selectionEnabled)
    return PressureEvaluation::None;
  if (hasCriticalBudget(budgets))
    return PressureEvaluation::Eager;
  return PressureEvaluation::LazyHardCap;
}

struct WaveAMDMachineSchedulePass
    : public wave::impl::WaveAMDMachineScheduleBase<
          WaveAMDMachineSchedulePass> {
  using WaveAMDMachineScheduleBase::WaveAMDMachineScheduleBase;

  void runOnOperation() override {
    Operation *root = getOperation();
    waveamdmachine::EventSimConfig modelConfig;
    if (failed(configureScheduleModel(root, modelWaves, modelSimds,
                                      modelStartDelay, modelVmemValueLatency,
                                      modelSmemValueLatency,
                                      modelLdsValueLatency, modelConfig)))
      return signalPassFailure();
    if (!applySchedule)
      return;
    WalkResult walkResult = root->walk([&](func::FuncOp func) {
      ArchResolution archResolution = resolveArch(func);
      RegisterPressureBudgets pressureBudgets;
      if (failed(configureSchedulePressureBudgets(
              func, archResolution, pressureAwareSelection, pressureVgprBudget,
              pressureSgprBudget, pressureCriticalVgprBudget,
              pressureCriticalSgprBudget, pressureTargetWavesOverride,
              pressureBudgets)))
        return WalkResult::interrupt();
      if (failed(processFunction(func, archResolution, modelConfig,
                                 pressureBudgets)))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if (walkResult.wasInterrupted())
      return signalPassFailure();
  }

  LogicalResult
  processFunction(func::FuncOp func, ArchResolution archResolution,
                  const waveamdmachine::EventSimConfig &modelConfig,
                  const RegisterPressureBudgets &pressureBudgets) {
    if (func.isExternal())
      return success();
    if (failed(wave::prepareWaveAMDRegAllocIR(func)))
      return failure();
    SmallVector<ScheduleRegion> regions = collectScheduleRegions(func);
    for (const ScheduleRegion &region : regions)
      processRegion(region, archResolution, modelConfig, pressureBudgets);
    return success();
  }

  void processRegion(const ScheduleRegion &region,
                     ArchResolution archResolution,
                     const waveamdmachine::EventSimConfig &modelConfig,
                     const RegisterPressureBudgets &pressureBudgets) {
    DependenceGraph graph = buildDependenceGraph(region);
    processScheduler(region, graph, archResolution, modelConfig,
                     pressureBudgets);
  }

  void processScheduler(const ScheduleRegion &region,
                        const DependenceGraph &graph,
                        ArchResolution archResolution,
                        const waveamdmachine::EventSimConfig &modelConfig,
                        const RegisterPressureBudgets &pressureBudgets) {
    ScheduleDecision decision = evaluateScheduleCandidates(
        region, graph, archResolution, modelConfig, pressureBudgets, beamSearch,
        getSchedulePressureEvaluation(pressureBudgets),
        /*allowPressureUpperBound=*/true);
    bool willApply =
        applySchedule && shouldApplyDecision(decision, pressureBudgets);
    if (willApply)
      applyScheduleOrder(region, decision.candidates[decision.selected].order);
  }
};

} // namespace
