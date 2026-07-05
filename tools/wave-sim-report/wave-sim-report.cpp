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
#include "mlir/Dialect/WaveAMDMachine/CostModel/CalibrationData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
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
    funcName("func", llvm::cl::desc("Function to simulate"),
             llvm::cl::init(""));

static llvm::cl::opt<std::string>
    archName("arch", llvm::cl::desc("gfx target, overrides module attr"),
             llvm::cl::init(""));

static llvm::cl::opt<int>
    waveSize("wave-size",
             llvm::cl::desc("wavefront width for issue timing; 0 uses arch"),
             llvm::cl::init(0));

static llvm::cl::opt<int64_t>
    tripCount("trip-count",
              llvm::cl::desc("override all uniform_loop trip counts"),
              llvm::cl::init(-1));

static llvm::cl::opt<bool> timeline("timeline",
                                    llvm::cl::desc("print event timeline"),
                                    llvm::cl::init(false));

static llvm::cl::opt<bool>
    opLatencies("op-latencies",
                llvm::cl::desc("print flattened op class/latency table"),
                llvm::cl::init(false));

static llvm::cl::opt<std::string>
    calibrationFile("calibration-file",
                    llvm::cl::desc("JSON latency calibration overlay"),
                    llvm::cl::init(""));

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

static llvm::cl::opt<int>
    cmaIssueInterval("cma-issue-interval",
                     llvm::cl::desc("override CMA issue interval; -1 uses "
                                    "issue period"),
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

static bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         WaveAMDMachineDialect::getDialectNamespace();
}

static unsigned getIssueCount(Operation *op) {
  if (isa<DsLoadTupleB32Op, GlobalLoadTupleB32Op, BufferLoadTupleB32Op>(op))
    return cast<RegType>(op->getResult(0).getType()).getWidth();
  if (isa<DsStoreTupleB32Op>(op))
    return cast<RegType>(op->getOperand(1).getType()).getWidth();
  return 1;
}

static int64_t getTripCount(UniformLoopOp loop) {
  if (tripCount >= 0)
    return tripCount;
  IntegerAttr trip =
      loop->getAttrOfType<IntegerAttr>("waveamdmachine.trip_count");
  if (!trip)
    return 1;
  return std::max<int64_t>(0, trip.getInt());
}

static void appendBlockOps(Block &block, SmallVectorImpl<Operation *> &ops);

static void appendOp(Operation *op, SmallVectorImpl<Operation *> &ops) {
  if (UniformLoopOp loop = dyn_cast<UniformLoopOp>(op)) {
    Block &body = loop.getBody().front();
    for (int64_t i = 0, e = getTripCount(loop); i < e; ++i)
      appendBlockOps(body, ops);
    return;
  }
  if (isWaveAMDMachineOp(op))
    ops.push_back(op);
}

static void appendBlockOps(Block &block, SmallVectorImpl<Operation *> &ops) {
  for (Operation &op : block)
    appendOp(&op, ops);
}

static SmallVector<Operation *> flattenOps(func::FuncOp func) {
  SmallVector<Operation *> ops;
  for (Block &block : func.getBody())
    appendBlockOps(block, ops);
  return ops;
}

static void printEvent(const EventSimEvent &event) {
  llvm::outs() << eventKindName(event.kind) << " cycle=" << event.cycle;
  if (event.fu != FunctionalUnit::None)
    llvm::outs() << " fu=" << getFunctionalUnitName(event.fu);
  if (event.counter != EventSimCounter::None)
    llvm::outs() << " counter=" << counterName(event.counter);
  if (event.op)
    llvm::outs() << " op=" << event.op->getName().getStringRef();
  llvm::outs() << "\n";
}

static bool isValidLatencyOverride(int value) { return value >= -1; }

static bool validateLatencyOverrides() {
  return isValidLatencyOverride(vmemCounterLatency) &&
         isValidLatencyOverride(vscntCounterLatency) &&
         isValidLatencyOverride(smemCounterLatency) &&
         isValidLatencyOverride(ldsCounterLatency) &&
         isValidLatencyOverride(vmemValueLatency) &&
         isValidLatencyOverride(smemValueLatency) &&
         isValidLatencyOverride(ldsValueLatency) &&
         isValidLatencyOverride(cmaIssueInterval);
}

static bool validateWaveSize() {
  return waveSize == 0 || waveSize == 32 || waveSize == 64;
}

static bool loadCalibration(std::optional<CalibrationData> &calibration) {
  if (calibrationFile.empty())
    return true;
  llvm::Expected<CalibrationData> loaded =
      CalibrationData::loadFromFile(calibrationFile);
  if (!loaded) {
    llvm::errs() << "failed to load calibration: "
                 << llvm::toString(loaded.takeError()) << "\n";
    return false;
  }
  calibration = std::move(*loaded);
  return true;
}

static bool
validateCalibrationArch(const ArchData &arch,
                        const std::optional<CalibrationData> &calibration) {
  if (!calibration || calibration->matchesArch(arch))
    return true;
  llvm::errs() << "calibration arch " << calibration->arch
               << " does not match target " << arch.name << "\n";
  return false;
}

static int getConfiguredLatency(const ArchData &arch, SchedClass cls,
                                const CalibrationData *calibration) {
  if (!calibration)
    return getLatency(arch, cls);
  return getCalibratedLatency(arch, cls, *calibration);
}

static EventSimConfig buildConfig(const CalibrationData *calibration) {
  EventSimConfig config;
  config.waveSize = waveSize.getValue();
  config.tripCountOverride = std::max<int64_t>(-1, tripCount.getValue());
  config.calibration = calibration;
  config.recordTimeline = timeline.getValue();
  config.counterLatencies.vmemLoad = vmemCounterLatency;
  config.counterLatencies.vmemStore = vscntCounterLatency;
  config.counterLatencies.smemLoad = smemCounterLatency;
  config.counterLatencies.lds = ldsCounterLatency;
  config.valueLatencies.vmemLoad = vmemValueLatency;
  config.valueLatencies.smemLoad = smemValueLatency;
  config.valueLatencies.lds = ldsValueLatency;
  config.cmaIssueInterval = cmaIssueInterval;
  return config;
}

static void printOpLatencies(func::FuncOp func, const ArchData &arch,
                             const MemoryCounterLatencies &counterLatencies,
                             const MemoryValueLatencies &valueLatencies,
                             const CalibrationData *calibration) {
  SmallVector<Operation *> ops = flattenOps(func);
  llvm::outs() << "op_latencies:\n";
  for (auto [idx, op] : llvm::enumerate(ops)) {
    SchedClass cls = classifyOp(op);
    FunctionalUnit fu =
        cls == SchedClass::NoInst ? FunctionalUnit::None : funit(arch, cls);
    llvm::outs() << "  op_index=" << idx
                 << " op=" << op->getName().getStringRef()
                 << " class=" << getSchedClassName(cls)
                 << " fu=" << getFunctionalUnitName(fu)
                 << " latency=" << getConfiguredLatency(arch, cls, calibration);
    if (getMemoryCounterKind(op) != MemoryCounterKind::None) {
      llvm::outs() << " counter_latency="
                   << getMemoryCounterLatency(arch, op, counterLatencies,
                                              calibration);
    }
    if (hasMemoryValueLatency(op))
      llvm::outs() << " value_latency="
                   << getMemoryValueLatency(arch, op, valueLatencies,
                                            calibration);
    llvm::outs() << " issues=" << getIssueCount(op);
    if (op->hasTrait<::mlir::OpTrait::waveamdmachine::WaitcntOp>())
      llvm::outs() << " waitcnt=1";
    llvm::outs() << "\n";
  }
}

static void printSimulationReport(func::FuncOp func, const ArchData &arch,
                                  const EventSimConfig &config,
                                  const EventSimResult &result) {
  llvm::outs() << "func: " << func.getName() << "\n";
  llvm::outs() << "arch: " << arch.name << "\n";
  if (config.waveSize != 0)
    llvm::outs() << "wave_size: " << config.waveSize << "\n";
  if (config.tripCountOverride >= 0)
    llvm::outs() << "trip_count_override: " << config.tripCountOverride << "\n";
  llvm::outs() << "total_cycles: " << result.totalCycles << "\n";
  llvm::outs() << "issued_ops: " << result.issuedOps << "\n";
  llvm::outs() << "completed: " << result.completedCycle << "\n";
}

static void printOptionalReports(func::FuncOp func, const ArchData &arch,
                                 const EventSimConfig &config,
                                 const EventSimResult &result) {
  if (opLatencies)
    printOpLatencies(func, arch, config.counterLatencies, config.valueLatencies,
                     config.calibration);
  if (timeline)
    for (const EventSimEvent &event : result.events)
      printEvent(event);
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
  if (!validateLatencyOverrides()) {
    llvm::errs() << "latency/interval overrides must be -1 or non-negative\n";
    return 1;
  }
  if (!validateWaveSize()) {
    llvm::errs() << "wave-size must be 0, 32, or 64\n";
    return 1;
  }
  std::optional<CalibrationData> calibration;
  if (!loadCalibration(calibration))
    return 1;
  if (!validateCalibrationArch(*arch, calibration))
    return 1;

  EventSimConfig config = buildConfig(calibration ? &*calibration : nullptr);

  EventSimResult result;
  if (failed(simulateEventTimeline(func, *arch, config, result)))
    return 1;

  printSimulationReport(func, *arch, config, result);
  printOptionalReports(func, *arch, config, result);
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
