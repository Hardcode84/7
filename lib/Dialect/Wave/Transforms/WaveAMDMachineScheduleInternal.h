//===- WaveAMDMachineScheduleInternal.h - Scheduler internals ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEINTERNAL_H
#define DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEINTERNAL_H

#include "WaveAMDMachineScheduleSupport.h"

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Support/LLVM.h"

#include <string>

namespace mlir::wave {

struct GraphTables {
  SmallVector<SmallVector<unsigned, 4>, 16> successors;
  SmallVector<unsigned, 16> pendingPreds;
};

struct NodeMetrics {
  int64_t criticalPath = 0;
  int latency = 0;
  waveamdmachine::FunctionalUnit fu = waveamdmachine::FunctionalUnit::None;
  unsigned issueCount = 0;
  unsigned issueSlots = 0;
  unsigned cmaIssueCount = 0;
  bool noInst = false;
  bool memory = false;
  bool reachesMemory = false;
  bool cmaIssue = false;
  bool reachesCmaIssue = false;
  bool ldsDma = false;
  bool reachesLdsDma = false;
  bool salu = false;
  bool valu = false;
};

enum class SchedulePolicy {
  CriticalPath,
  MemoryEarly,
};

struct OrderCandidate {
  SmallVector<unsigned, 16> order;
  std::string name;
};

GraphTables buildGraphTables(const ScheduleRegion &region,
                             const DependenceGraph &graph);
SmallVector<NodeMetrics, 16>
computeNodeMetrics(const ScheduleRegion &region, const GraphTables &tables,
                   const waveamdmachine::ArchData &arch,
                   const waveamdmachine::EventSimConfig &modelConfig);
int memoryPriority(const NodeMetrics &metrics);
bool buildListOrder(const GraphTables &tables, ArrayRef<NodeMetrics> metrics,
                    SchedulePolicy policy, SmallVectorImpl<unsigned> &order);
bool sameOrder(ArrayRef<unsigned> lhs, ArrayRef<unsigned> rhs);
bool isPressureSearchEnabled(const RegisterPressureBudgets &budgets);
int64_t estimateGuidedBeamSearchWork(unsigned guideCount, unsigned nodeCount);
void addGuidedBeamCandidates(SmallVectorImpl<OrderCandidate> &candidates,
                             const GraphTables &tables,
                             ArrayRef<NodeMetrics> metrics,
                             const ScheduleRegion &region,
                             const RegisterPressureBudgets &budgets,
                             unsigned guideCount);
ScheduleDecision evaluateScheduleOrderCandidates(
    const ScheduleRegion &region, const DependenceGraph &graph,
    ArrayRef<OrderCandidate> candidates, ArchResolution archResolution,
    const waveamdmachine::EventSimConfig &modelConfig,
    const RegisterPressureBudgets &budgets,
    PressureEvaluation pressureEvaluation, bool allowPressureUpperBound,
    const SchedulePressureContext *pressureContext);

} // namespace mlir::wave

#endif // DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESCHEDULEINTERNAL_H
