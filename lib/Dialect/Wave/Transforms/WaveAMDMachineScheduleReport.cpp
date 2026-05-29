//===- WaveAMDMachineScheduleReport.cpp - Scheduler diagnostics -----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDMachineScheduleSupport.h"
#include "WaveAMDRegAllocPrep.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/IRMapping.h"
#include "llvm/ADT/ScopeExit.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMACHINESCHEDULEREPORT
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct ReportControls {
  CandidateRequest candidate;
  bool emitScores = false;
  bool emitCandidates = false;
  bool emitClasses = false;
  bool prepareForPressure = false;
  bool anyOutput = false;
};

struct WaveAMDMachineScheduleReportPass
    : public wave::impl::WaveAMDMachineScheduleReportBase<
          WaveAMDMachineScheduleReportPass> {
  using WaveAMDMachineScheduleReportBase::WaveAMDMachineScheduleReportBase;

  void runOnOperation() override {
    ReportControls controls = getReportControls();
    if (!controls.anyOutput)
      return;

    Operation *root = getOperation();
    waveamdmachine::EventSimConfig modelConfig;
    if (failed(configureReport(root, modelConfig)))
      return signalPassFailure();

    StringRef scoreFuncName(scoreFunc);
    WalkResult walkResult = root->walk([&](func::FuncOp func) {
      ArchResolution archResolution = resolveArch(func);
      RegisterPressureBudgets pressureBudgets;
      if (controls.prepareForPressure &&
          failed(configureSchedulePressureBudgets(
              func, archResolution, pressureAwareSelection, pressureVgprBudget,
              pressureSgprBudget, pressureCriticalVgprBudget,
              pressureCriticalSgprBudget, pressureTargetWavesOverride,
              pressureBudgets)))
        return WalkResult::interrupt();
      if (failed(processFunction(func, archResolution, modelConfig,
                                 pressureBudgets, controls.candidate,
                                 scoreFuncName, controls.emitScores,
                                 controls.emitCandidates, controls.emitClasses,
                                 controls.prepareForPressure)))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if (walkResult.wasInterrupted())
      return signalPassFailure();
  }

  ReportControls getReportControls() {
    ReportControls controls;
    controls.candidate =
        getCandidateRequest(StringRef(scoreOrder), scoreRegion);
    controls.emitScores = printScore || controls.candidate.requested;
    controls.emitCandidates = printCandidates;
    controls.emitClasses = printClasses;
    controls.prepareForPressure =
        controls.emitScores || controls.emitCandidates;
    controls.anyOutput = printRegions || printDeps || controls.emitScores ||
                         controls.emitCandidates || controls.emitClasses;
    return controls;
  }

  LogicalResult configureReport(Operation *root,
                                waveamdmachine::EventSimConfig &modelConfig) {
    return configureScheduleModel(root, modelWaves, modelSimds, modelStartDelay,
                                  modelVmemValueLatency, modelSmemValueLatency,
                                  modelLdsValueLatency, modelConfig);
  }

  LogicalResult
  processFunction(func::FuncOp func, ArchResolution archResolution,
                  const waveamdmachine::EventSimConfig &modelConfig,
                  const RegisterPressureBudgets &pressureBudgets,
                  const CandidateRequest &candidate, StringRef scoreFuncName,
                  bool emitScores, bool emitCandidates, bool emitClasses,
                  bool prepareForPressure) {
    if (func.isExternal())
      return success();
    if (prepareForPressure)
      printPressureBudgets(func, pressureBudgets);
    if (!prepareForPressure)
      return reportFunction(func, archResolution, modelConfig, pressureBudgets,
                            candidate, scoreFuncName, emitScores,
                            emitCandidates, emitClasses);

    IRMapping mapper;
    Operation *clonedOp = func->clone(mapper);
    llvm::scope_exit cleanup([&]() { clonedOp->destroy(); });
    func::FuncOp clonedFunc = cast<func::FuncOp>(clonedOp);
    if (failed(wave::prepareWaveAMDRegAllocIR(clonedFunc)))
      return failure();
    return reportFunction(clonedFunc, archResolution, modelConfig,
                          pressureBudgets, candidate, scoreFuncName, emitScores,
                          emitCandidates, emitClasses);
  }

  LogicalResult
  reportFunction(func::FuncOp func, ArchResolution archResolution,
                 const waveamdmachine::EventSimConfig &modelConfig,
                 const RegisterPressureBudgets &pressureBudgets,
                 const CandidateRequest &candidate, StringRef scoreFuncName,
                 bool emitScores, bool emitCandidates, bool emitClasses) {
    SmallVector<ScheduleRegion> regions = collectScheduleRegions(func);
    for (const ScheduleRegion &region : regions)
      reportRegion(region, archResolution, modelConfig, pressureBudgets,
                   candidate, scoreFuncName, emitScores, emitCandidates,
                   emitClasses);
    return success();
  }

  void reportRegion(const ScheduleRegion &region, ArchResolution archResolution,
                    const waveamdmachine::EventSimConfig &modelConfig,
                    const RegisterPressureBudgets &pressureBudgets,
                    const CandidateRequest &candidate, StringRef scoreFuncName,
                    bool emitScores, bool emitCandidates, bool emitClasses) {
    bool scoreCandidate =
        candidate.requested &&
        shouldScoreCandidate(region, scoreFuncName, scoreRegion);
    DependenceGraph graph;
    if (printDeps || scoreCandidate || emitCandidates)
      graph = buildDependenceGraph(region);
    if (printRegions)
      printRegion(region);
    if (emitClasses)
      printOpClasses(region, archResolution);
    if (printDeps)
      printDependences(region, graph);
    if (emitScores)
      printRegionScores(region, graph, archResolution, modelConfig,
                        pressureBudgets, candidate, scoreCandidate);
    if (emitCandidates)
      reportCandidates(region, graph, archResolution, modelConfig,
                       pressureBudgets);
  }

  void reportCandidates(const ScheduleRegion &region,
                        const DependenceGraph &graph,
                        ArchResolution archResolution,
                        const waveamdmachine::EventSimConfig &modelConfig,
                        const RegisterPressureBudgets &pressureBudgets) {
    ScheduleDecision decision =
        evaluateScheduleCandidates(region, graph, archResolution, modelConfig,
                                   pressureBudgets, beamSearch);
    printCandidateDiagnostics(region, decision, pressureBudgets);
    printScheduleDecision(region, decision, /*willApply=*/false);
  }
};

} // namespace
