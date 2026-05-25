//===- wave-sim-report.cpp - Event simulator report ----------------------===//
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
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/InitAllDialects.h"
#include "mlir/Parser/Parser.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/TargetParser.h"

#include <algorithm>

using namespace mlir;
using namespace mlir::waveamdmachine;

static llvm::cl::opt<std::string> inputFile(llvm::cl::Positional,
                                            llvm::cl::Required,
                                            llvm::cl::desc("<input mlir>"));

static llvm::cl::opt<std::string>
    funcName("func", llvm::cl::desc("Function to simulate"),
             llvm::cl::init(""));

static llvm::cl::opt<std::string>
    archName("arch", llvm::cl::desc("gfx target, overrides module attr"),
             llvm::cl::init(""));

static llvm::cl::opt<int> waves("waves", llvm::cl::desc("waves to simulate"),
                                llvm::cl::init(1));

static llvm::cl::opt<int>
    simds("simds", llvm::cl::desc("SIMDs to distribute waves across"),
          llvm::cl::init(1));

static llvm::cl::opt<int>
    startDelay("start-delay",
               llvm::cl::desc("cycle delay between consecutive waves"),
               llvm::cl::init(0));

static llvm::cl::opt<bool> timeline("timeline",
                                    llvm::cl::desc("print event timeline"),
                                    llvm::cl::init(false));

static const ArchData *resolveArch(llvm::StringRef name) {
  llvm::StringRef cpu = name;
  std::pair<llvm::StringRef, llvm::StringRef> split = cpu.rsplit("--");
  if (!split.second.empty())
    cpu = split.second;
  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(cpu);
  if (isa.Major == 0 || !isArchSupported(isa))
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

static llvm::StringRef eventKindName(EventSimEventKind kind) {
  switch (kind) {
  case EventSimEventKind::OpIssued:
    return "issue";
  case EventSimEventKind::ValueReady:
    return "value_ready";
  case EventSimEventKind::CounterDrained:
    return "counter_drained";
  case EventSimEventKind::WaveCompleted:
    return "wave_completed";
  }
  llvm_unreachable("bad event kind");
}

static llvm::StringRef counterName(EventSimCounter counter) {
  switch (counter) {
  case EventSimCounter::None:
    return "none";
  case EventSimCounter::Vmem:
    return "vmem";
  case EventSimCounter::Lgkm:
    return "lgkm";
  case EventSimCounter::Vscnt:
    return "vscnt";
  }
  llvm_unreachable("bad counter");
}

static void printEvent(const EventSimEvent &event) {
  llvm::outs() << eventKindName(event.kind) << " cycle=" << event.cycle
               << " wave=" << event.wave << " simd=" << event.simd;
  if (event.fu != FunctionalUnit::None)
    llvm::outs() << " fu=" << getFunctionalUnitName(event.fu);
  if (event.counter != EventSimCounter::None)
    llvm::outs() << " counter=" << counterName(event.counter);
  if (event.op)
    llvm::outs() << " op=" << event.op->getName().getStringRef();
  llvm::outs() << "\n";
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

  EventSimConfig config;
  config.waves = std::max(1, waves.getValue());
  config.simds = std::max(1, simds.getValue());
  config.startDelay = std::max(0, startDelay.getValue());
  config.recordTimeline = timeline.getValue();

  EventSimResult result;
  if (failed(simulateEventTimeline(func, *arch, config, result)))
    return 1;

  llvm::outs() << "func: " << func.getName() << "\n";
  llvm::outs() << "arch: " << arch->name << "\n";
  llvm::outs() << "waves: " << config.waves << "\n";
  llvm::outs() << "simds: " << config.simds << "\n";
  llvm::outs() << "start_delay: " << config.startDelay << "\n";
  llvm::outs() << "total_cycles: " << result.totalCycles << "\n";
  llvm::outs() << "issued_ops: " << result.issuedOps << "\n";
  for (size_t i = 0; i < result.waveCompletedCycles.size(); ++i)
    llvm::outs() << "wave_" << i
                 << "_completed: " << result.waveCompletedCycles[i] << "\n";
  if (timeline)
    for (const EventSimEvent &event : result.events)
      printEvent(event);
  return 0;
}

int main(int argc, char **argv) {
  llvm::InitLLVM x(argc, argv);
  llvm::cl::ParseCommandLineOptions(
      argc, argv, "Print event-driven WaveAMDMachine simulation report.\n");

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
