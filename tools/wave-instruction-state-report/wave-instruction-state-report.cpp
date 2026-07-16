//===- wave-instruction-state-report.cpp - State-model report -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveMeta.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/InitAllDialects.h"
#include "mlir/Parser/Parser.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/TargetParser.h"

#include <algorithm>
#include <optional>

using namespace mlir;
using namespace mlir::waveamdmachine;

static llvm::cl::opt<std::string> inputFile(llvm::cl::Positional,
                                            llvm::cl::Required,
                                            llvm::cl::desc("<input mlir>"));

static llvm::cl::opt<std::string>
    funcName("func", llvm::cl::desc("Function to inspect"), llvm::cl::init(""));

static llvm::cl::opt<std::string>
    archName("arch", llvm::cl::desc("gfx target, overrides module attr"),
             llvm::cl::init(""));

static llvm::cl::opt<int>
    issuePeriod("issue-period",
                llvm::cl::desc("override single-unit issue period"),
                llvm::cl::init(0));

static llvm::cl::opt<DmaIssueDelayCohortPolicy> dmaIssueDelayCohort(
    "dma-issue-delay-cohort",
    llvm::cl::desc("conditional DMA issue delay path"),
    llvm::cl::values(clEnumValN(DmaIssueDelayCohortPolicy::Delayed, "delayed",
                                "execute the delay"),
                     clEnumValN(DmaIssueDelayCohortPolicy::Skipped, "skipped",
                                "take the skip branch")),
    llvm::cl::init(DmaIssueDelayCohortPolicy::Delayed));

static llvm::cl::opt<int> vmemCounterLatency(
    "vmem-counter-latency",
    llvm::cl::desc("override VMEM-load waitcnt counter latency"),
    llvm::cl::init(-1));

static llvm::cl::opt<int> vscntCounterLatency(
    "vscnt-counter-latency",
    llvm::cl::desc("override VMEM-store waitcnt counter latency"),
    llvm::cl::init(-1));

static llvm::cl::opt<int> smemCounterLatency(
    "smem-counter-latency",
    llvm::cl::desc("override SMEM-load waitcnt counter latency"),
    llvm::cl::init(-1));

static llvm::cl::opt<int>
    ldsCounterLatency("lds-counter-latency",
                      llvm::cl::desc("override LDS waitcnt counter latency"),
                      llvm::cl::init(-1));

static llvm::cl::opt<int>
    vmemValueLatency("vmem-value-latency",
                     llvm::cl::desc("override VMEM-load value-ready latency"),
                     llvm::cl::init(-1));

static llvm::cl::opt<int>
    smemValueLatency("smem-value-latency",
                     llvm::cl::desc("override SMEM-load value-ready latency"),
                     llvm::cl::init(-1));

static llvm::cl::opt<int>
    ldsValueLatency("lds-value-latency",
                    llvm::cl::desc("override LDS-load value-ready latency"),
                    llvm::cl::init(-1));

static llvm::cl::opt<bool> enablePipeBackpressure(
    "pipe-backpressure", llvm::cl::desc("enable VALU/SALU/XDL in-flight caps"),
    llvm::cl::init(false));

static llvm::cl::opt<unsigned>
    valuMaxInFlight("valu-max-in-flight", llvm::cl::desc("VALU in-flight cap"),
                    llvm::cl::init(0));

static llvm::cl::opt<unsigned>
    saluMaxInFlight("salu-max-in-flight", llvm::cl::desc("SALU in-flight cap"),
                    llvm::cl::init(0));

static llvm::cl::opt<unsigned>
    xdlMaxInFlight("xdl-max-in-flight", llvm::cl::desc("XDL in-flight cap"),
                   llvm::cl::init(0));

static const ArchData *resolveArch(llvm::StringRef name) {
  llvm::StringRef cpu = name;
  if (name.contains("--")) {
    std::optional<AMDGPUTarget> target = parseAMDGPUTargetAttr(name);
    if (!target)
      return nullptr;
    cpu = target->chip;
  }

  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(cpu);
  if (isa.Major == 0 || !isInstructionExecutionStateArchSupported(isa))
    return nullptr;

  if (isa.Major == 11)
    return &getArchData({11, 0, 0});
  if (!isArchSupported(isa))
    return nullptr;
  return &getArchData(isa);
}

static const ArchData *resolveModuleArch(ModuleOp mod) {
  if (!archName.empty())
    return resolveArch(archName);
  StringAttr target = mod->getAttrOfType<StringAttr>("waveamdmachine.target");
  if (!target)
    return nullptr;
  return resolveArch(target.getValue());
}

static func::FuncOp selectFunc(ModuleOp mod) {
  if (!funcName.empty()) {
    for (func::FuncOp func : mod.getOps<func::FuncOp>())
      if (func.getName() == funcName)
        return func;
    return nullptr;
  }
  for (func::FuncOp func : mod.getOps<func::FuncOp>())
    return func;
  return nullptr;
}

static bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         WaveAMDMachineDialect::getDialectNamespace();
}

static void appendBlockOps(Block &block, SmallVectorImpl<Operation *> &ops);

static void appendOp(Operation *op, SmallVectorImpl<Operation *> &ops) {
  if (isWaveAMDMachineOp(op))
    ops.push_back(op);
  for (Region &region : op->getRegions())
    for (Block &block : region)
      appendBlockOps(block, ops);
}

static void appendBlockOps(Block &block, SmallVectorImpl<Operation *> &ops) {
  for (Operation &op : block)
    appendOp(&op, ops);
}

static SmallVector<Operation *> collectOps(func::FuncOp func) {
  SmallVector<Operation *> ops;
  for (Block &block : func.getBody())
    appendBlockOps(block, ops);
  return ops;
}

static bool isValidLatencyOverride(int value) { return value >= -1; }

static bool validateOptions() {
  return issuePeriod >= 0 && isValidLatencyOverride(vmemCounterLatency) &&
         isValidLatencyOverride(vscntCounterLatency) &&
         isValidLatencyOverride(smemCounterLatency) &&
         isValidLatencyOverride(ldsCounterLatency) &&
         isValidLatencyOverride(vmemValueLatency) &&
         isValidLatencyOverride(smemValueLatency) &&
         isValidLatencyOverride(ldsValueLatency);
}

static InstructionExecutionConfig buildConfig() {
  InstructionExecutionConfig config;
  config.issuePeriod = issuePeriod;
  config.counterLatencies.vmemLoad = vmemCounterLatency;
  config.counterLatencies.vmemStore = vscntCounterLatency;
  config.counterLatencies.smemLoad = smemCounterLatency;
  config.counterLatencies.lds = ldsCounterLatency;
  config.valueLatencies.vmemLoad = vmemValueLatency;
  config.valueLatencies.smemLoad = smemValueLatency;
  config.valueLatencies.lds = ldsValueLatency;
  config.enablePipeBackpressure = enablePipeBackpressure;
  config.valuMaxInFlight = valuMaxInFlight;
  config.saluMaxInFlight = saluMaxInFlight;
  config.xdlMaxInFlight = xdlMaxInFlight;
  config.dmaIssueDelayCohortPolicy = dmaIssueDelayCohort;
  return config;
}

static void printStall(const InstructionStall &stall) {
  llvm::outs() << "stall=" << getInstructionStallKindName(stall.kind)
               << " cycles=" << stall.cycles << " components=";
  if (stall.components.empty()) {
    llvm::outs() << "none";
    return;
  }
  for (auto [index, component] : llvm::enumerate(stall.components)) {
    if (index != 0)
      llvm::outs() << ",";
    llvm::outs() << getInstructionStallKindName(component.kind) << ":"
                 << component.cycles;
  }
}

static void printPendingCounters(const InstructionExecutionState &state) {
  llvm::outs()
      << " pending_vmem="
      << state.getPendingMemoryEventCount(InstructionWaitCounterKind::Vmem)
      << " pending_lgkm="
      << state.getPendingMemoryEventCount(InstructionWaitCounterKind::Lgkm)
      << " pending_vscnt="
      << state.getPendingMemoryEventCount(InstructionWaitCounterKind::Vscnt);
}

static int report(ModuleOp mod) {
  const ArchData *arch = resolveModuleArch(mod);
  if (!arch) {
    llvm::errs() << "unsupported or missing arch\n";
    return 1;
  }
  func::FuncOp func = selectFunc(mod);
  if (!func) {
    llvm::errs() << "function not found\n";
    return 1;
  }
  if (!validateOptions()) {
    llvm::errs() << "latency overrides must be -1 or non-negative; "
                    "issue-period must be non-negative\n";
    return 1;
  }

  InstructionExecutionState state(*arch, buildConfig());
  SmallVector<Operation *> ops = collectOps(func);

  llvm::outs() << "func: " << func.getName() << "\n";
  llvm::outs() << "arch: " << arch->name << "\n";
  for (auto [index, op] : llvm::enumerate(ops)) {
    FailureOr<InstructionStall> stall = state.query(op);
    if (failed(stall)) {
      llvm::errs() << "failed to query op_index=" << index
                   << " op=" << op->getName().getStringRef() << "\n";
      return 1;
    }
    llvm::outs() << "query op_index=" << index
                 << " cycle=" << state.getCurrentCycle()
                 << " op=" << op->getName().getStringRef() << " ";
    printStall(*stall);
    llvm::outs() << "\n";

    FailureOr<InstructionCommitResult> commit = state.commit(op);
    if (failed(commit)) {
      llvm::errs() << "failed to commit op_index=" << index
                   << " op=" << op->getName().getStringRef() << "\n";
      return 1;
    }
    llvm::outs() << "commit op_index=" << index
                 << " issue=" << commit->issueCycle
                 << " next=" << commit->nextIssueCycle
                 << " value_ready=" << commit->valueReadyCycle
                 << " token_ready=" << commit->tokenReadyCycle;
    printPendingCounters(state);
    llvm::outs() << "\n";
  }
  return 0;
}

int main(int argc, char **argv) {
  llvm::InitLLVM x(argc, argv);
  llvm::cl::ParseCommandLineOptions(
      argc, argv, "Print WaveAMDMachine instruction execution state.\n");

  DialectRegistry registry;
  registerAllDialects(registry);
  registry.insert<wave::WaveDialect, waveamd::WaveAMDDialect,
                  wavemeta::WaveMetaDialect,
                  waveamdmachine::WaveAMDMachineDialect>();
  MLIRContext context(registry);

  llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>> file =
      llvm::MemoryBuffer::getFileOrSTDIN(inputFile);
  if (!file) {
    llvm::errs() << "failed to open input: " << file.getError().message()
                 << "\n";
    return 1;
  }

  llvm::SourceMgr sourceMgr;
  sourceMgr.AddNewSourceBuffer(std::move(*file), llvm::SMLoc());
  OwningOpRef<ModuleOp> mod = parseSourceFile<ModuleOp>(sourceMgr, &context);
  if (!mod)
    return 1;
  return report(*mod);
}
