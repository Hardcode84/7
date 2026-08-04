//===- InstructionExecutionState.cpp - Single-wave issue state ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.h"

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/CalibrationData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Operation.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"

#include <algorithm>
#include <array>
#include <cassert>
#include <limits>
#include <optional>
#include <utility>

namespace mlir::waveamdmachine {

static bool tracksInstructionScheduleResource(FunctionalUnit unit) {
  switch (unit) {
  case FunctionalUnit::VALU:
  case FunctionalUnit::SALU:
  case FunctionalUnit::MFMA_XDL:
  case FunctionalUnit::TRANS:
    return true;
  default:
    return false;
  }
}

InstructionScheduleResourceInfo
getInstructionScheduleResourceInfo(Operation *op, SchedClass cls,
                                   const ArchData &arch) {
  InstructionScheduleResourceInfo info;
  if (cls == SchedClass::NoInst)
    return info;
  info.realInstruction = true;
  info.functionalUnit = funit(arch, cls);
  info.issueSlots = getInstructionIssueCount(op, arch.isa);
  info.tracked = tracksInstructionScheduleResource(info.functionalUnit);
  info.usesMfmaCoissue = usesMfmaCoissueResource(op, cls, arch);
  if (info.tracked)
    info.releaseSlots = std::max(1, getResourceCycles(arch, cls));
  return info;
}

InstructionScheduleResourcePreview InstructionScheduleResourceState::preview(
    const InstructionScheduleResourceInfo &info) const {
  InstructionScheduleResourcePreview result;
  result.functionalUnit = info.functionalUnit;
  if (!info.tracked)
    return result;

  result.releaseSlots = info.releaseSlots;
  size_t index = static_cast<size_t>(result.functionalUnit);
  int64_t readySlot = readyAt[index];
  if (trackMfmaCoissue && info.usesMfmaCoissue)
    readySlot = std::max(readySlot, mfmaCoissueReadyAt);
  result.waitSlots = std::max<int64_t>(0, readySlot - currentSlot);
  return result;
}

void InstructionScheduleResourceState::commit(
    const InstructionScheduleResourceInfo &info) {
  if (!info.realInstruction)
    return;
  InstructionScheduleResourcePreview resource = preview(info);
  int64_t issueSlot = currentSlot + resource.waitSlots;
  if (!info.tracked) {
    // Resource scheduling does not cross compute-island boundaries.
    currentSlot = issueSlot + info.issueSlots;
    readyAt.fill(currentSlot);
    mfmaCoissueReadyAt = currentSlot;
    return;
  }
  size_t index = static_cast<size_t>(resource.functionalUnit);
  unsigned releaseSlots = std::max(info.releaseSlots, info.issueSlots);
  readyAt[index] = issueSlot + releaseSlots;
  if (trackMfmaCoissue && info.usesMfmaCoissue)
    mfmaCoissueReadyAt = issueSlot + releaseSlots;
  currentSlot = issueSlot + info.issueSlots;
}

unsigned getTargetWaveCount(Operation *context) {
  for (Operation *op = context; op; op = op->getParentOp()) {
    IntegerAttr targetWaves =
        op->getAttrOfType<IntegerAttr>("waveamdmachine.target_waves");
    if (!targetWaves || targetWaves.getInt() <= 0)
      continue;
    return static_cast<unsigned>(targetWaves.getValue().getLimitedValue(
        std::numeric_limits<unsigned>::max()));
  }
  return 1;
}

static std::optional<uint64_t> flattenWorkgroupShape(DenseI32ArrayAttr shape) {
  if (shape.empty() || shape.size() > 3)
    return std::nullopt;
  uint64_t flat = 1;
  for (int32_t dim : shape.asArrayRef()) {
    if (dim <= 0 || flat > std::numeric_limits<uint64_t>::max() /
                               static_cast<uint64_t>(dim))
      return std::nullopt;
    flat *= static_cast<uint64_t>(dim);
  }
  return flat;
}

static std::optional<unsigned> getWorkgroupWaveCount(Operation *context) {
  std::optional<uint64_t> flatWorkgroupSize;
  std::optional<unsigned> explicitWaves;
  for (Operation *op = context; op; op = op->getParentOp()) {
    for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
      DenseI32ArrayAttr shape = op->getAttrOfType<DenseI32ArrayAttr>(name);
      if (!shape)
        continue;
      std::optional<uint64_t> candidate = flattenWorkgroupShape(shape);
      if (!candidate || (flatWorkgroupSize && *flatWorkgroupSize != *candidate))
        return std::nullopt;
      flatWorkgroupSize = candidate;
    }

    IntegerAttr waves =
        op->getAttrOfType<IntegerAttr>("wave.waves_per_workgroup");
    if (!waves)
      continue;
    if (waves.getInt() <= 0)
      return std::nullopt;
    unsigned candidate = static_cast<unsigned>(
        waves.getValue().getLimitedValue(std::numeric_limits<unsigned>::max()));
    if (explicitWaves && *explicitWaves != candidate)
      return std::nullopt;
    explicitWaves = candidate;
  }

  if (!flatWorkgroupSize)
    return explicitWaves;
  FailureOr<unsigned> wavefront = getAMDGPUWavefrontSize(
      context, "waveamd-machine-instruction-schedule-model");
  if (failed(wavefront) || *wavefront == 0)
    return std::nullopt;
  uint64_t derivedWaves = llvm::divideCeil(*flatWorkgroupSize, *wavefront);
  if (derivedWaves > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  unsigned result = static_cast<unsigned>(derivedWaves);
  if (explicitWaves && *explicitWaves != result)
    return std::nullopt;
  return explicitWaves.value_or(result);
}

void configureInstructionScheduleModel(
    InstructionExecutionConfig &config, const ArchData &arch,
    Operation *context, ReadyRegisterPressureLimits pressureLimits) {
  unsigned targetWaveCount = getTargetWaveCount(context);
  config.ldsDmaIssueWaveStreams =
      std::min(targetWaveCount, static_cast<unsigned>(arch.wavesPerSIMD));
  config.scheduleModel.issueStreams = config.ldsDmaIssueWaveStreams;
  config.scheduleModel.readyPressureWaveCohort =
      getWorkgroupWaveCount(context).value_or(
          config.scheduleModel.issueStreams);
  config.scheduleModel.enableCoexecWindow =
      config.scheduleModel.readyPressureWaveCohort > 1;
  config.scheduleModel.pressureLimits = pressureLimits;
  int64_t issuePeriod = config.issuePeriod > 0
                            ? config.issuePeriod
                            : std::max(1, arch.simdIssuePeriod);
  if (arch.ldsDmaIssueQueueDepth > 0 && arch.ldsDmaIssueLatency > 0) {
    int64_t serviceInterval =
        arch.ldsDmaIssueLatency / arch.ldsDmaIssueQueueDepth;
    config.scheduleModel.ldsDmaIssueLead =
        serviceInterval / issuePeriod * issuePeriod;
  }
  if (arch.agprCountsAgainstVGPRs) {
    unsigned familyLimit = static_cast<unsigned>(arch.vgprFileSize) /
                           config.ldsDmaIssueWaveStreams;
    config.scheduleModel.pressureLimits.vgprFamily =
        familyLimit / static_cast<unsigned>(arch.vgprAllocGranule) *
        static_cast<unsigned>(arch.vgprAllocGranule);
  }
  // Sibling resident waves supply issue spacing absent at one-wave occupancy.
  config.smoothLdsDmaIssue = config.ldsDmaIssueWaveStreams == 1;
}

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

static bool isMemToken(Value value) {
  return isa<MemTokenType>(value.getType());
}

static bool dropsTokenCompletion(Operation *op) {
  return op->hasTrait<traits::CompletionFreeTokenOp>();
}

static bool isCDNA3Or4(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 && (isa.Minor == 4 || isa.Minor == 5);
}

static bool isCDNA4(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 && isa.Minor == 5;
}

static std::optional<RegClass> getRegClass(Value value) {
  if (RegType type = dyn_cast<RegType>(value.getType()))
    return type.getRegClass();
  return std::nullopt;
}

static bool hasRegClass(ValueRange values, RegClass regClass) {
  return llvm::any_of(
      values, [&](Value value) { return getRegClass(value) == regClass; });
}

static bool hasOnlyRegClass(ValueRange values, RegClass regClass) {
  bool found = false;
  for (Value value : values) {
    std::optional<RegClass> valueClass = getRegClass(value);
    if (!valueClass)
      continue;
    if (*valueClass != regClass)
      return false;
    found = true;
  }
  return found;
}

static bool isLegacyVALU(Operation *op) {
  return op->hasTrait<traits::VALUOp>() && !op->hasTrait<traits::MFMAOp>();
}

static unsigned getMfmaPassCount(SchedClass cls) {
  switch (cls) {
  case SchedClass::Write2PassMAI:
    return 2;
  case SchedClass::Write4PassMAI:
    return 4;
  case SchedClass::Write8PassMAI:
    return 8;
  case SchedClass::Write16PassMAI:
    return 16;
  default:
    return 0;
  }
}

static unsigned issueSlotsUntil(uint64_t readyAt, uint64_t currentIssueSlot) {
  if (readyAt <= currentIssueSlot)
    return 0;
  return static_cast<unsigned>(readyAt - currentIssueSlot);
}

static bool isSGPROffset(Value value) {
  RegType regType = dyn_cast<RegType>(value.getType());
  return regType && regType.getRegClass() == RegClass::SGPR;
}

static Value getWideBufferStoreSoffset(Operation *op) {
  if (BufferStoreB96Op store = dyn_cast<BufferStoreB96Op>(op))
    return store.getSoffset();
  if (BufferStoreB128Op store = dyn_cast<BufferStoreB128Op>(op))
    return store.getSoffset();
  return {};
}

static bool isWideStoreWriteDataOp(Operation *op) {
  return isa<GlobalStoreB96Op, GlobalStoreB128Op, GlobalStoreB96Addr64Op,
             GlobalStoreB128Addr64Op, BufferStoreB96Op, BufferStoreB128Op>(op);
}

static bool
reachesStoreWriteData(Value value,
                      llvm::SmallPtrSetImpl<Operation *> &seenAliases) {
  for (OpOperand &use : value.getUses()) {
    Operation *user = use.getOwner();
    if (use.getOperandNumber() == 1 && isWideStoreWriteDataOp(user))
      return true;
    if (!user->hasTrait<traits::NoMachineInst>() ||
        !seenAliases.insert(user).second)
      continue;
    for (Value result : user->getResults())
      if (reachesStoreWriteData(result, seenAliases))
        return true;
  }
  return false;
}

static bool producesStoreWriteData(Operation *op) {
  if (!op->hasTrait<traits::VALUOp>())
    return false;
  llvm::SmallPtrSet<Operation *, 8> seenAliases;
  return llvm::any_of(op->getResults(), [&](Value result) {
    return reachesStoreWriteData(result, seenAliases);
  });
}

static int getConfiguredLatency(const ArchData &arch, SchedClass cls,
                                const CalibrationData *calibration) {
  if (!calibration)
    return getLatency(arch, cls);
  return getCalibratedLatency(arch, cls, *calibration);
}

static InstructionWaitCounterKind toInstructionCounter(MemoryCounterKind kind) {
  switch (kind) {
  case MemoryCounterKind::Vmem:
    return InstructionWaitCounterKind::Vmem;
  case MemoryCounterKind::Lgkm:
    return InstructionWaitCounterKind::Lgkm;
  case MemoryCounterKind::Vscnt:
    return InstructionWaitCounterKind::Vscnt;
  case MemoryCounterKind::Async:
    return InstructionWaitCounterKind::Async;
  case MemoryCounterKind::Tensor:
    return InstructionWaitCounterKind::Tensor;
  case MemoryCounterKind::None:
    return InstructionWaitCounterKind::None;
  }
  llvm_unreachable("bad memory counter");
}

static constexpr std::array<std::pair<WaitcntEvent, InstructionEventClass>, 12>
    eventClasses = {
        {{WaitcntEvent::Vmem, InstructionEventClass::VmemLoad},
         {WaitcntEvent::Flat, InstructionEventClass::VmemLoad},
         {WaitcntEvent::VmemStore, InstructionEventClass::VmemStore},
         {WaitcntEvent::ScratchStore, InstructionEventClass::VmemStore},
         {WaitcntEvent::Lds, InstructionEventClass::LdsDs},
         {WaitcntEvent::Gds, InstructionEventClass::LdsDs},
         {WaitcntEvent::Message, InstructionEventClass::Message},
         {WaitcntEvent::SccWrite, InstructionEventClass::Message},
         {WaitcntEvent::Smem, InstructionEventClass::Smem},
         {WaitcntEvent::Async, InstructionEventClass::Async},
         {WaitcntEvent::Tensor, InstructionEventClass::Tensor},
         {WaitcntEvent::None, InstructionEventClass::None}}};

static InstructionEventClass toInstructionEventClass(Operation *op) {
  WaitcntInfo info = getWaitcntInfo(op);
  auto it = llvm::find_if(eventClasses, [&](const auto &mapping) {
    return mapping.first == info.event;
  });
  if (it == eventClasses.end())
    llvm_unreachable("unsupported wait event");
  return it->second;
}

static int64_t saturatingAdd(int64_t lhs, int64_t rhs) {
  assert(lhs >= 0 && rhs >= 0 && "expected non-negative cycle counts");
  if (lhs > std::numeric_limits<int64_t>::max() - rhs)
    return std::numeric_limits<int64_t>::max();
  return lhs + rhs;
}

static int64_t saturatingMultiply(int64_t lhs, int64_t rhs) {
  assert(lhs >= 0 && rhs >= 0 && "expected non-negative cycle counts");
  if (lhs != 0 && rhs > std::numeric_limits<int64_t>::max() / lhs)
    return std::numeric_limits<int64_t>::max();
  return lhs * rhs;
}

static int64_t getDmaIssueDelayNopSpan(int64_t cycles, int64_t issuePeriod) {
  constexpr int64_t maxNopCycles = 16;
  int64_t fullChunks = cycles / maxNopCycles;
  int64_t remainder = cycles % maxNopCycles;
  int64_t span =
      saturatingMultiply(fullChunks, std::max(maxNopCycles, issuePeriod));
  if (remainder != 0)
    span = saturatingAdd(span, std::max(remainder, issuePeriod));
  return span;
}

static int64_t getLdsDmaServiceInterval(const ArchData &arch,
                                        int64_t issuePeriod,
                                        unsigned waveStreams) {
  if (arch.ldsDmaIssueQueueDepth <= 0 || arch.ldsDmaIssueLatency <= 0)
    return 0;
  int64_t serviceWidth =
      saturatingMultiply(arch.ldsDmaIssueQueueDepth, std::max(1u, waveStreams));
  int64_t interval = arch.ldsDmaIssueLatency / serviceWidth;
  return std::max(issuePeriod, interval / issuePeriod * issuePeriod);
}

static bool hasMemoryTokenOperand(Operation *op) {
  for (Value operand : op->getOperands())
    if (isMemToken(operand))
      return true;
  return false;
}

static bool consumesM0ThroughHazard(Operation *op) {
  bool hasM0Operand = llvm::any_of(op->getOperands(), [](Value operand) {
    return isa<M0Type>(operand.getType());
  });
  if (!hasM0Operand)
    return false;
  if (op->hasTrait<traits::LDSDmaOp>())
    return true;
  return isa<DsLoadAddTidB32Op, DsStoreAddTidB32Op>(op);
}

static bool writesM0ThroughHazard(Operation *op) {
  return isa<M0WriteHazardOpInterface>(op);
}

static constexpr std::array<InstructionPipeKind,
                            static_cast<size_t>(
                                FunctionalUnit::NumFunctionalUnits)>
    kPipeForFU = {
        /*VALU=*/InstructionPipeKind::VALU,
        /*SALU=*/InstructionPipeKind::SALU,
        /*VMEM=*/InstructionPipeKind::None,
        /*LGKM=*/InstructionPipeKind::None,
        /*MFMA_XDL=*/InstructionPipeKind::XDL,
        /*TRANS=*/InstructionPipeKind::VALU,
        /*BRANCH=*/InstructionPipeKind::SALU,
        /*EXPORT=*/InstructionPipeKind::None,
        /*None=*/InstructionPipeKind::None,
};

static InstructionPipeKind pipeForFunctionalUnit(FunctionalUnit fu) {
  size_t index = static_cast<size_t>(fu);
  if (index >= kPipeForFU.size())
    llvm_unreachable("bad functional unit");
  return kPipeForFU[index];
}

static InstructionPipeKind pipeFor(const ArchData &arch, SchedClass cls) {
  if (cls == SchedClass::NoInst || cls == SchedClass::WaitcntPseudo)
    return InstructionPipeKind::None;
  return pipeForFunctionalUnit(funit(arch, cls));
}

static unsigned counterIndex(InstructionWaitCounterKind kind) {
  switch (kind) {
  case InstructionWaitCounterKind::Vmem:
    return 0;
  case InstructionWaitCounterKind::Lgkm:
    return 1;
  case InstructionWaitCounterKind::Vscnt:
    return 2;
  case InstructionWaitCounterKind::Expcnt:
    return 3;
  case InstructionWaitCounterKind::Tensor:
    return 4;
  case InstructionWaitCounterKind::Async:
    return 5;
  case InstructionWaitCounterKind::None:
    break;
  }
  llvm_unreachable("counter has no queue");
}

static InstructionResourceKind resourceForPipe(InstructionPipeKind kind) {
  switch (kind) {
  case InstructionPipeKind::VALU:
    return InstructionResourceKind::ValuPipe;
  case InstructionPipeKind::SALU:
    return InstructionResourceKind::SaluPipe;
  case InstructionPipeKind::XDL:
    return InstructionResourceKind::XdlPipe;
  case InstructionPipeKind::None:
    return InstructionResourceKind::None;
  }
  llvm_unreachable("bad pipe kind");
}

static unsigned pipeIndex(InstructionPipeKind kind) {
  switch (kind) {
  case InstructionPipeKind::VALU:
    return 0;
  case InstructionPipeKind::SALU:
    return 1;
  case InstructionPipeKind::XDL:
    return 2;
  case InstructionPipeKind::None:
    break;
  }
  llvm_unreachable("pipe has no queue");
}

static constexpr std::array<MemoryIssueResource, kMemoryIssueResourceCount>
    kMemoryIssueResources = {
        MemoryIssueResource::VmemLoad,     MemoryIssueResource::VmemStore,
        MemoryIssueResource::LdsDmaAccept, MemoryIssueResource::Lds,
        MemoryIssueResource::Smem,
};

static unsigned memoryIssueIndex(MemoryIssueResource resource) {
  switch (resource) {
  case MemoryIssueResource::VmemLoad:
    return 0;
  case MemoryIssueResource::VmemStore:
    return 1;
  case MemoryIssueResource::LdsDmaAccept:
    return 2;
  case MemoryIssueResource::Lds:
    return 3;
  case MemoryIssueResource::Smem:
    return 4;
  }
  llvm_unreachable("bad memory issue resource");
}

static unsigned maxInFlightForPipe(const InstructionExecutionConfig &config,
                                   InstructionPipeKind pipe) {
  if (!config.enablePipeBackpressure)
    return 0;
  switch (pipe) {
  case InstructionPipeKind::VALU:
    return config.valuMaxInFlight;
  case InstructionPipeKind::SALU:
    return config.saluMaxInFlight;
  case InstructionPipeKind::XDL:
    return config.xdlMaxInFlight;
  case InstructionPipeKind::None:
    return 0;
  }
  llvm_unreachable("bad pipe kind");
}

static unsigned maxInFlightForMemoryIssue(const ArchData &arch,
                                          MemoryIssueResource resource) {
  if (resource == MemoryIssueResource::LdsDmaAccept)
    return static_cast<unsigned>(arch.ldsDmaIssueQueueDepth);
  return 0;
}

static int64_t memoryIssueLatency(const ArchData &arch,
                                  MemoryIssueResource resource) {
  if (resource == MemoryIssueResource::LdsDmaAccept)
    return arch.ldsDmaIssueLatency;
  return 0;
}

static void appendUniqueEvents(SmallVectorImpl<uint64_t> &events,
                               ArrayRef<uint64_t> appended) {
  llvm::SmallDenseSet<uint64_t, 16> seen;
  seen.reserve(events.size() + appended.size());
  for (uint64_t id : events)
    seen.insert(id);
  for (uint64_t id : appended)
    if (seen.insert(id).second)
      events.push_back(id);
}

static void
addComponent(InstructionStall &stall, InstructionStallKind kind, int64_t cycles,
             InstructionResourceKind resource = InstructionResourceKind::None,
             InstructionResourceScope scope = InstructionResourceScope::Wave) {
  if (cycles <= 0)
    return;
  stall.components.push_back({kind, cycles, resource, scope});
  if (cycles > stall.cycles) {
    stall.cycles = cycles;
    stall.kind = kind;
  }
}

} // namespace

std::optional<StoreWriteDataHazard>
getStoreWriteDataHazard(Operation *op, const llvm::AMDGPU::IsaVersion &isa) {
  if (!isWideStoreWriteDataOp(op))
    return std::nullopt;
  unsigned latency = 1;
  if (isCDNA3Or4(isa)) {
    Value soffset = getWideBufferStoreSoffset(op);
    // SGPR SOFFSET shortens the measured gfx94x/gfx95x window.
    latency = soffset && isSGPROffset(soffset) ? 1 : 2;
  }
  return StoreWriteDataHazard{op->getOperand(1), latency};
}

InstructionIssueSlotHazardConfig
getInstructionIssueSlotHazardConfig(const llvm::AMDGPU::IsaVersion &isa) {
  if (isCDNA3Or4(isa))
    return {/*valuWriteVGPRScalarRead=*/1,
            /*valuWriteVGPRMfmaRead=*/getValuWriteVGPRMfmaHazardLatency(),
            /*valuWriteVGPRPermlane32Swap=*/
            VPermlane32SwapB32TupleOp::isSupportedOnIsa(isa) ? 2u : 0u,
            /*valuWriteSGPRValuRead=*/2,
            /*transWriteVGPRValuRead=*/1};
  return {};
}

unsigned getValuWriteVGPRMfmaHazardLatency() { return 2; }

unsigned getXdlResultHazardLatency(const llvm::AMDGPU::IsaVersion &isa,
                                   unsigned passes) {
  if (isa.Major == 9 && isa.Minor == 4)
    return passes + 3;
  if (isa.Major == 9 && isa.Minor == 5)
    return passes + 3 + (passes != 2);
  return 8;
}

unsigned getXdlSrcCOverlapHazardLatency(const llvm::AMDGPU::IsaVersion &isa,
                                        unsigned passes) {
  if (isa.Major == 9 && isa.Minor == 4)
    return passes + 1;
  if (isa.Major == 9 && isa.Minor == 5)
    return passes + 2;
  return 6;
}

unsigned getXdlSrcCExactHazardLatency(const llvm::AMDGPU::IsaVersion &isa,
                                      unsigned passes) {
  if (isa.Major == 9 && (isa.Minor == 4 || isa.Minor == 5) && passes == 2)
    return 2;
  return 0;
}

bool isXdlResultHazardConsumer(Operation *op) {
  return op->hasTrait<traits::VMEMLoadOp>() ||
         op->hasTrait<traits::VMEMStoreOp>() ||
         getWaitcntInfo(op).event == WaitcntEvent::Lds || isLegacyVALU(op);
}

bool isInstructionExecutionStateArchSupported(
    const llvm::AMDGPU::IsaVersion &isa) {
  return isaEq(isa, {9, 4, 2}) || isaEq(isa, {9, 5, 0}) || isa.Major == 11 ||
         isaEq(isa, getGfx1250IsaVersion());
}

bool waitsForMemoryTokenDepsBeforeIssue(Operation *op) {
  if (!hasMemoryTokenOperand(op))
    return false;
  if (isa<ClusterBarrierOp, SBarrierOp, SBarrierSignalIsFirstOp,
          SBarrierSignalOp, BarrierArriveOp>(op))
    return true;
  if (op->hasTrait<traits::LDSDmaOp>())
    return true;
  if (op->hasTrait<traits::VMEMStoreOp>() || op->hasTrait<traits::LDSStoreOp>())
    return true;
  return false;
}

llvm::StringRef getInstructionStallKindName(InstructionStallKind kind) {
  static constexpr std::array<llvm::StringLiteral, 10> names = {
      "none",
      "issue_backpressure",
      "operand_value",
      "memory_value",
      "memory_token",
      "waitcnt",
      "instruction_hazard",
      "m0_read_write",
      "store_write_data",
      "coexec_window"};
  static_assert(static_cast<unsigned>(InstructionStallKind::CoexecWindow) + 1 ==
                names.size());
  unsigned index = static_cast<unsigned>(kind);
  assert(index < names.size() && "bad stall kind");
  return names[index];
}

llvm::StringRef getInstructionPipeKindName(InstructionPipeKind kind) {
  switch (kind) {
  case InstructionPipeKind::None:
    return "none";
  case InstructionPipeKind::VALU:
    return "valu";
  case InstructionPipeKind::SALU:
    return "salu";
  case InstructionPipeKind::XDL:
    return "xdl";
  }
  llvm_unreachable("bad pipe kind");
}

InstructionExecutionState::InstructionExecutionState(
    const ArchData &arch, InstructionExecutionConfig config)
    : config(config), arch(arch),
      issueSlotHazardConfig(getInstructionIssueSlotHazardConfig(arch.isa)) {}

static bool canUseReadyRegisterClass(int64_t current, int64_t delta,
                                     unsigned limit) {
  if (delta <= 0)
    return true;
  return limit != 0 && current + delta <= static_cast<int64_t>(limit);
}

static unsigned getReadyRegisterPressureLimit(unsigned limit,
                                              unsigned allocGranule) {
  if (allocGranule == 0)
    return limit;
  unsigned alignedLimit = limit - limit % allocGranule;
  return alignedLimit > allocGranule ? alignedLimit - allocGranule : 0;
}

static unsigned getReadyRegisterPressureCeiling(unsigned limit,
                                                unsigned allocGranule,
                                                unsigned baseline) {
  return std::max(getReadyRegisterPressureLimit(limit, allocGranule), baseline);
}

static bool canUseReadyCandidate(ReadyRegisterPressure current,
                                 const ReadyCandidateMetrics &candidate,
                                 const ReadyRegisterPressureLimits &limits) {
  unsigned sgprLimit = getReadyRegisterPressureCeiling(
      limits.sgpr, limits.sgprAllocGranule, candidate.pressureCeiling.sgpr);
  unsigned vgprLimit = getReadyRegisterPressureCeiling(
      limits.vgpr, limits.vgprAllocGranule, candidate.pressureCeiling.vgpr);
  unsigned agprLimit = getReadyRegisterPressureCeiling(
      limits.agpr, limits.agprAllocGranule, candidate.pressureCeiling.agpr);
  if (!canUseReadyRegisterClass(current.sgpr, candidate.pressurePeakDelta.sgpr,
                                sgprLimit))
    return false;
  if (!canUseReadyRegisterClass(current.vgpr, candidate.pressurePeakDelta.vgpr,
                                vgprLimit) ||
      !canUseReadyRegisterClass(current.agpr, candidate.pressurePeakDelta.agpr,
                                agprLimit))
    return false;
  if (limits.vgprFamily == 0)
    return true;
  unsigned familyGranule =
      std::max(limits.vgprAllocGranule, limits.agprAllocGranule);
  unsigned familyLimit = getReadyRegisterPressureCeiling(
      limits.vgprFamily, familyGranule, candidate.pressureCeiling.vgprFamily);
  return canUseReadyRegisterClass(current.vgpr + current.agpr,
                                  candidate.vgprFamilyPeakDelta, familyLimit);
}

bool InstructionScheduleModel::shouldSelectResourceStallFiller(
    unsigned waitSlots, unsigned releaseSlots, ReadyRegisterPressure current,
    const ReadyCandidateMetrics &next) const {
  if (issueStreams <= 1 || waitSlots == 0)
    return false;
  unsigned siblingOverlap = 0;
  if (issueStreams > 1 && releaseSlots > 1) {
    if (canUseReadyCandidate(current, next, pressureLimits))
      siblingOverlap =
          releaseSlots - llvm::divideCeil(releaseSlots, issueStreams);
    else
      siblingOverlap = std::min(releaseSlots - 1, issueStreams - 1);
  }
  return waitSlots > siblingOverlap;
}

bool InstructionScheduleModel::canFillStall(
    InstructionStallKind stall, FunctionalUnit candidate,
    bool usesMfmaCoissueResource) const {
  if (stall != InstructionStallKind::CoexecWindow)
    return true;
  return candidate == FunctionalUnit::VALU && !usesMfmaCoissueResource;
}

bool InstructionScheduleModel::canSelectStallFiller(
    InstructionStallKind stall, FunctionalUnit candidate,
    bool usesMfmaCoissueResource, bool candidateRealInstruction,
    bool candidateStalls, bool hasIssueDeadline,
    int64_t candidateNextIssueCycle, int64_t stallIssueCycle) const {
  if (!candidateRealInstruction || candidateStalls ||
      !canFillStall(stall, candidate, usesMfmaCoissueResource))
    return false;
  return !hasIssueDeadline || candidateNextIssueCycle <= stallIssueCycle;
}

InstructionCoexecutionModel InstructionScheduleModel::applyCoexecutionPolicy(
    InstructionCoexecutionModel model) const {
  return enableCoexecWindow ? model : InstructionCoexecutionModel{};
}

bool InstructionScheduleModel::canIssueLdsDmaDuringLead(
    int64_t resourceWait, bool dependenciesReady) const {
  return issueStreams > 1 && ldsDmaIssueLead != 0 && resourceWait > 0 &&
         resourceWait <= ldsDmaIssueLead && dependenciesReady;
}

bool InstructionScheduleModel::shouldPrioritizeLongLatency(
    bool enabled, int64_t candidateLatency, int64_t baselineLatency) const {
  // LLVM latency preference; cache policy is orthogonal.
  return enabled && baselineLatency > 0 &&
         candidateLatency > 10 * baselineLatency;
}

bool InstructionScheduleModel::shouldPrioritizeLatency(
    int64_t candidateLatency, int64_t baselineLatency) const {
  return baselineLatency > 0 &&
         candidateLatency >= 2 * std::max<int64_t>(1, baselineLatency);
}

ReadyResourceCandidateKind
InstructionScheduleModel::classifyReadyResourceCandidate(
    FunctionalUnit blocked, int64_t waitSlots, unsigned releaseSlots,
    FunctionalUnit candidate, int64_t candidateWaitSlots,
    unsigned candidateReleaseSlots, unsigned selectedReleaseSlots) const {
  if (candidateReleaseSlots == 0 || candidateWaitSlots != 0)
    return ReadyResourceCandidateKind::None;
  if (waitSlots != 0)
    return ReadyResourceCandidateKind::StallFiller;
  if (candidate == blocked || candidateReleaseSlots <= releaseSlots ||
      candidateReleaseSlots <= selectedReleaseSlots)
    return ReadyResourceCandidateKind::None;
  return ReadyResourceCandidateKind::Priority;
}

struct ReadyRegisterPressureScore {
  uint64_t maximum = 0;
  uint64_t total = 0;
};

static constexpr uint64_t kReadyPressureScoreScale = uint64_t{1} << 20;

static void addReadyRegisterPressureScore(int64_t pressure, unsigned limit,
                                          ReadyRegisterPressureScore &score) {
  if (limit == 0)
    return;
  uint64_t used = static_cast<uint64_t>(std::max<int64_t>(pressure, 0));
  uint64_t normalized = used * kReadyPressureScoreScale / limit;
  score.maximum = std::max(score.maximum, normalized);
  score.total += normalized;
}

static ReadyRegisterPressureScore
getReadyRegisterPressureScore(ReadyRegisterPressure current,
                              const ReadyCandidateMetrics &candidate,
                              const ReadyRegisterPressureLimits &limits) {
  ReadyRegisterPressureScore score;
  unsigned sgprLimit = getReadyRegisterPressureCeiling(
      limits.sgpr, limits.sgprAllocGranule, candidate.pressureCeiling.sgpr);
  unsigned vgprLimit = getReadyRegisterPressureCeiling(
      limits.vgpr, limits.vgprAllocGranule, candidate.pressureCeiling.vgpr);
  unsigned agprLimit = getReadyRegisterPressureCeiling(
      limits.agpr, limits.agprAllocGranule, candidate.pressureCeiling.agpr);
  addReadyRegisterPressureScore(current.sgpr + candidate.pressureDelta.sgpr,
                                sgprLimit, score);
  if (limits.vgprFamily != 0) {
    unsigned familyGranule =
        std::max(limits.vgprAllocGranule, limits.agprAllocGranule);
    unsigned familyLimit = getReadyRegisterPressureCeiling(
        limits.vgprFamily, familyGranule, candidate.pressureCeiling.vgprFamily);
    addReadyRegisterPressureScore(current.vgpr + current.agpr +
                                      candidate.pressureDelta.vgpr +
                                      candidate.pressureDelta.agpr,
                                  familyLimit, score);
    if (vgprLimit < familyLimit)
      addReadyRegisterPressureScore(current.vgpr + candidate.pressureDelta.vgpr,
                                    vgprLimit, score);
    if (agprLimit < familyLimit)
      addReadyRegisterPressureScore(current.agpr + candidate.pressureDelta.agpr,
                                    agprLimit, score);
    return score;
  }
  addReadyRegisterPressureScore(current.vgpr + candidate.pressureDelta.vgpr,
                                vgprLimit, score);
  addReadyRegisterPressureScore(current.agpr + candidate.pressureDelta.agpr,
                                agprLimit, score);
  return score;
}

static bool improvesOverBudgetReadyRegisterClass(int64_t current,
                                                 int64_t candidateDelta,
                                                 int64_t selectedDelta,
                                                 unsigned limit,
                                                 unsigned allocGranule) {
  if (limit == 0)
    return false;
  int64_t selectedPressure = current + selectedDelta;
  return candidateDelta < 0 &&
         selectedPressure > static_cast<int64_t>(getReadyRegisterPressureLimit(
                                limit, allocGranule)) &&
         current + candidateDelta < selectedPressure;
}

static bool
improvesOverBudgetReadyPressure(ReadyRegisterPressure current,
                                const ReadyCandidateMetrics &candidate,
                                const ReadyCandidateMetrics &selected,
                                const ReadyRegisterPressureLimits &limits) {
  if (improvesOverBudgetReadyRegisterClass(
          current.sgpr, candidate.pressureDelta.sgpr,
          selected.pressureDelta.sgpr, limits.sgpr, limits.sgprAllocGranule))
    return true;
  if (improvesOverBudgetReadyRegisterClass(
          current.vgpr, candidate.pressureDelta.vgpr,
          selected.pressureDelta.vgpr, limits.vgpr, limits.vgprAllocGranule) ||
      improvesOverBudgetReadyRegisterClass(
          current.agpr, candidate.pressureDelta.agpr,
          selected.pressureDelta.agpr, limits.agpr, limits.agprAllocGranule))
    return true;
  if (limits.vgprFamily != 0) {
    unsigned familyGranule =
        std::max(limits.vgprAllocGranule, limits.agprAllocGranule);
    return improvesOverBudgetReadyRegisterClass(
        current.vgpr + current.agpr,
        candidate.pressureDelta.vgpr + candidate.pressureDelta.agpr,
        selected.pressureDelta.vgpr + selected.pressureDelta.agpr,
        limits.vgprFamily, familyGranule);
  }
  return false;
}

static bool canUseReadyRegisterClassAgainstBaseline(int64_t current,
                                                    int64_t candidatePeakDelta,
                                                    int64_t baselinePeakDelta,
                                                    unsigned limit,
                                                    unsigned allocGranule) {
  int64_t candidatePressure = current + candidatePeakDelta;
  int64_t baselinePressure = current + baselinePeakDelta;
  int64_t ceiling = std::max<int64_t>(
      getReadyRegisterPressureLimit(limit, allocGranule), baselinePressure);
  return candidatePressure <= ceiling;
}

static bool canUseReadyRegisterClassAgainstOriginalCeiling(
    int64_t current, int64_t candidatePeakDelta, int64_t baselinePeakDelta,
    unsigned originalCeiling, unsigned limit, unsigned allocGranule) {
  int64_t candidatePressure = current + candidatePeakDelta;
  int64_t baselinePressure = current + baselinePeakDelta;
  int64_t ceiling = std::max<int64_t>(
      std::max(getReadyRegisterPressureLimit(limit, allocGranule),
               originalCeiling),
      baselinePressure);
  return candidatePressure <= ceiling;
}

static bool
canUseReadyCandidateAgainstBaseline(ReadyRegisterPressure current,
                                    const ReadyCandidateMetrics &candidate,
                                    const ReadyCandidateMetrics &baseline,
                                    const ReadyRegisterPressureLimits &limits) {
  if (!canUseReadyRegisterClassAgainstBaseline(
          current.sgpr, candidate.pressurePeakDelta.sgpr,
          baseline.pressurePeakDelta.sgpr, limits.sgpr,
          limits.sgprAllocGranule))
    return false;
  if (!canUseReadyRegisterClassAgainstBaseline(
          current.vgpr, candidate.pressurePeakDelta.vgpr,
          baseline.pressurePeakDelta.vgpr, limits.vgpr,
          limits.vgprAllocGranule) ||
      !canUseReadyRegisterClassAgainstBaseline(
          current.agpr, candidate.pressurePeakDelta.agpr,
          baseline.pressurePeakDelta.agpr, limits.agpr,
          limits.agprAllocGranule))
    return false;
  if (limits.vgprFamily != 0) {
    unsigned familyGranule =
        std::max(limits.vgprAllocGranule, limits.agprAllocGranule);
    return canUseReadyRegisterClassAgainstBaseline(
        current.vgpr + current.agpr, candidate.vgprFamilyPeakDelta,
        baseline.vgprFamilyPeakDelta, limits.vgprFamily, familyGranule);
  }
  return true;
}

static bool canUseReadySGPRCandidateOrder(
    ReadyRegisterPressure current,
    const ReadyCandidateMetrics &candidateThenBaseline,
    const ReadyCandidateMetrics &baselineThenCandidate,
    const ReadyCandidateMetrics &baseline, unsigned limit) {
  if (!canUseReadyRegisterClassAgainstBaseline(
          current.sgpr, candidateThenBaseline.pressurePeakDelta.sgpr,
          baselineThenCandidate.pressurePeakDelta.sgpr, limit, 0))
    return false;
  return candidateThenBaseline.autoDrainedNodes <= baseline.autoDrainedNodes ||
         canUseReadyRegisterClassAgainstBaseline(
             current.sgpr, candidateThenBaseline.pressurePeakDelta.sgpr,
             baseline.pressurePeakDelta.sgpr, limit, 0);
}

static bool raisesOverBudgetReadyRegisterClass(unsigned pressureCeiling,
                                               int64_t peakDelta,
                                               unsigned limit,
                                               unsigned allocGranule) {
  return pressureCeiling > getReadyRegisterPressureLimit(limit, allocGranule) &&
         peakDelta > 0;
}

bool InstructionScheduleModel::shouldPreferReadyPressure(
    ReadyRegisterPressure current, const ReadyCandidateMetrics &candidate,
    const ReadyCandidateMetrics &candidateThenSelected,
    const ReadyCandidateMetrics &selectedThenCandidate,
    const ReadyCandidateMetrics &selected) const {
  // Pressure ordering protects the target issue-stream occupancy contract.
  // The workgroup cohort remains the policy for filler balancing below.
  if (issueStreams <= 1) {
    int64_t selectedPeak = current.sgpr + selected.pressurePeakDelta.sgpr;
    if (pressureLimits.sgpr == 0 ||
        selectedPeak <= static_cast<int64_t>(pressureLimits.sgpr) ||
        !canUseReadySGPRCandidateOrder(current, candidateThenSelected,
                                       selectedThenCandidate, selected,
                                       pressureLimits.sgpr))
      return false;
    if (candidate.pressurePeakDelta.sgpr != selected.pressurePeakDelta.sgpr)
      return candidate.pressurePeakDelta.sgpr < selected.pressurePeakDelta.sgpr;
    return candidate.pressureDelta.sgpr < selected.pressureDelta.sgpr;
  }
  ReadyCandidateMetrics reserved = candidate;
  reserved.pressureDelta.sgpr +=
      std::max<int64_t>(0, selected.pressureDelta.sgpr);
  reserved.pressureDelta.vgpr +=
      std::max<int64_t>(0, selected.pressureDelta.vgpr);
  reserved.pressureDelta.agpr +=
      std::max<int64_t>(0, selected.pressureDelta.agpr);
  reserved.pressurePeakDelta.sgpr =
      std::max(candidate.pressurePeakDelta.sgpr,
               candidate.pressureDelta.sgpr + selected.pressurePeakDelta.sgpr);
  reserved.pressurePeakDelta.vgpr =
      std::max(candidate.pressurePeakDelta.vgpr,
               candidate.pressureDelta.vgpr + selected.pressurePeakDelta.vgpr);
  reserved.pressurePeakDelta.agpr =
      std::max(candidate.pressurePeakDelta.agpr,
               candidate.pressureDelta.agpr + selected.pressurePeakDelta.agpr);
  int64_t candidateFinalFamily =
      candidate.pressureDelta.vgpr + candidate.pressureDelta.agpr;
  reserved.vgprFamilyPeakDelta =
      std::max(candidate.vgprFamilyPeakDelta,
               candidateFinalFamily + selected.vgprFamilyPeakDelta);
  bool candidateFits = canUseReadyCandidate(current, reserved, pressureLimits);
  bool selectedFits = canUseReadyCandidate(current, selected, pressureLimits);
  if (candidateFits != selectedFits)
    return candidateFits;
  ReadyRegisterPressureScore candidatePressure =
      getReadyRegisterPressureScore(current, reserved, pressureLimits);
  ReadyRegisterPressureScore selectedPressure =
      getReadyRegisterPressureScore(current, selected, pressureLimits);
  if (candidateFits && selectedFits &&
      improvesOverBudgetReadyPressure(current, candidate, selected,
                                      pressureLimits)) {
    uint64_t candidateBalance = candidatePressure.total;
    uint64_t selectedBalance = selectedPressure.total;
    unsigned sgprLimit = getReadyRegisterPressureLimit(
        pressureLimits.sgpr, pressureLimits.sgprAllocGranule);
    if (current.sgpr > static_cast<int64_t>(sgprLimit)) {
      candidateBalance += candidatePressure.maximum;
      selectedBalance += selectedPressure.maximum;
    }
    if (candidateBalance != selectedBalance)
      return candidateBalance < selectedBalance;
  }
  if (candidatePressure.maximum != selectedPressure.maximum)
    return candidatePressure.maximum < selectedPressure.maximum;
  return false;
}

bool InstructionScheduleModel::canSelectReadyCandidate(
    ReadyRegisterPressure current,
    const ReadyCandidateMetrics &candidateThenBaseline,
    const ReadyCandidateMetrics &baseline) const {
  // Admission protects the target occupancy contract. The workgroup cohort
  // still controls how admitted candidates are ranked and balanced below.
  if (issueStreams <= 1)
    return canUseReadyRegisterClassAgainstBaseline(
        current.sgpr, candidateThenBaseline.pressurePeakDelta.sgpr,
        baseline.pressurePeakDelta.sgpr, pressureLimits.sgpr, 0);
  bool fits =
      canUseReadyCandidate(current, candidateThenBaseline, pressureLimits);
  if (!fits)
    return fits;
  return canUseReadyCandidateAgainstBaseline(current, candidateThenBaseline,
                                             baseline, pressureLimits);
}

bool InstructionScheduleModel::canSelectReadyFullPrefix(
    ReadyRegisterPressure current,
    const ReadyCandidateMetrics &candidateThenBaseline,
    const ReadyCandidateMetrics &baseline) const {
  if (!canUseReadyRegisterClassAgainstOriginalCeiling(
          current.sgpr, candidateThenBaseline.pressurePeakDelta.sgpr,
          baseline.pressurePeakDelta.sgpr,
          candidateThenBaseline.pressureCeiling.sgpr, pressureLimits.sgpr,
          pressureLimits.sgprAllocGranule))
    return false;
  if (!canUseReadyRegisterClassAgainstOriginalCeiling(
          current.vgpr, candidateThenBaseline.pressurePeakDelta.vgpr,
          baseline.pressurePeakDelta.vgpr,
          candidateThenBaseline.pressureCeiling.vgpr, pressureLimits.vgpr,
          pressureLimits.vgprAllocGranule) ||
      !canUseReadyRegisterClassAgainstOriginalCeiling(
          current.agpr, candidateThenBaseline.pressurePeakDelta.agpr,
          baseline.pressurePeakDelta.agpr,
          candidateThenBaseline.pressureCeiling.agpr, pressureLimits.agpr,
          pressureLimits.agprAllocGranule))
    return false;
  if (pressureLimits.vgprFamily == 0)
    return true;
  unsigned familyGranule = std::max(pressureLimits.vgprAllocGranule,
                                    pressureLimits.agprAllocGranule);
  return canUseReadyRegisterClassAgainstOriginalCeiling(
      current.vgpr + current.agpr, candidateThenBaseline.vgprFamilyPeakDelta,
      baseline.vgprFamilyPeakDelta,
      candidateThenBaseline.pressureCeiling.vgprFamily,
      pressureLimits.vgprFamily, familyGranule);
}

bool InstructionScheduleModel::canSelectReadyFiller(
    ReadyRegisterPressure current, const ReadyCandidateMetrics &candidate,
    const ReadyCandidateMetrics &candidateThenBaseline,
    const ReadyCandidateMetrics &baseline) const {
  if (readyPressureWaveCohort <= 1)
    return canSelectReadyCandidate(current, candidateThenBaseline, baseline);
  if (raisesOverBudgetReadyRegisterClass(
          candidate.pressureCeiling.sgpr, candidate.pressurePeakDelta.sgpr,
          pressureLimits.sgpr, pressureLimits.sgprAllocGranule))
    return false;
  if (pressureLimits.vgprFamily != 0) {
    unsigned familyGranule = std::max(pressureLimits.vgprAllocGranule,
                                      pressureLimits.agprAllocGranule);
    if (raisesOverBudgetReadyRegisterClass(
            candidate.pressureCeiling.vgprFamily, candidate.vgprFamilyPeakDelta,
            pressureLimits.vgprFamily, familyGranule))
      return false;
  }
  return canSelectReadyCandidate(current, candidateThenBaseline, baseline);
}

bool InstructionScheduleModel::shouldPreferReadyFiller(
    ReadyRegisterPressure current, const ReadyCandidateMetrics &candidate,
    const ReadyCandidateMetrics &selected) const {
  if (readyPressureWaveCohort <= 1)
    return false;
  if (pressureLimits.vgprFamily != 0) {
    int64_t candidateFamily =
        candidate.pressureDelta.vgpr + candidate.pressureDelta.agpr;
    int64_t selectedFamily =
        selected.pressureDelta.vgpr + selected.pressureDelta.agpr;
    if (candidateFamily != selectedFamily)
      return candidateFamily < selectedFamily;
  }
  ReadyRegisterPressureScore candidatePressure =
      getReadyRegisterPressureScore(current, candidate, pressureLimits);
  ReadyRegisterPressureScore selectedPressure =
      getReadyRegisterPressureScore(current, selected, pressureLimits);
  if (candidatePressure.maximum != selectedPressure.maximum)
    return candidatePressure.maximum < selectedPressure.maximum;
  return false;
}

InstructionResourceCapacities InstructionExecutionState::getResourceCapacities(
    const InstructionExecutionConfig &config) {
  if (!config.enablePipeBackpressure)
    return {};
  return {config.valuMaxInFlight, config.saluMaxInFlight,
          config.xdlMaxInFlight};
}

unsigned InstructionExecutionState::getPendingMemoryEventCount(
    InstructionWaitCounterKind kind) const {
  if (kind == InstructionWaitCounterKind::None)
    return 0;
  unsigned count = 0;
  for (EventId id : waitQueues[counterIndex(kind)])
    if (hasPendingEvent(id, currentCycle))
      ++count;
  return count;
}

int64_t InstructionExecutionState::getValueReadyCycle(Value value) const {
  DenseMap<Value, int64_t>::const_iterator it = valueReadyAt.find(value);
  if (it == valueReadyAt.end())
    return currentCycle;
  return it->second;
}

void InstructionExecutionState::bindValue(Value result, Value source) {
  bindValue(result, ArrayRef<Value>(source));
}

void InstructionExecutionState::bindValue(Value result,
                                          ArrayRef<Value> sources) {
  int64_t ready = currentCycle;
  SmallVector<EventId, 4> tokenDeps;
  std::optional<EventId> sourceValueEvent;
  IssueSlotHazards hazards;

  for (Value source : sources) {
    ready = std::max(ready, getValueReadyCycle(source));

    DenseMap<Value, EventId>::const_iterator valueEventIt =
        valueEvent.find(source);
    if (valueEventIt != valueEvent.end())
      sourceValueEvent = valueEventIt->second;

    DenseMap<Value, SmallVector<EventId, 4>>::const_iterator tokenIt =
        tokenEvents.find(source);
    if (tokenIt != tokenEvents.end())
      appendUniqueEvents(tokenDeps, tokenIt->second);

    DenseMap<Value, IssueSlotHazards>::const_iterator hazardIt =
        issueSlotHazards.find(source);
    if (hazardIt != issueSlotHazards.end())
      hazards.join(hazardIt->second);
  }

  // Exact source-C forwarding requires one complete register alias.
  if (sources.size() != 1 || result.getType() != sources.front().getType())
    hazards.mfmaSrcCExactReadyAt = 0;

  valueReadyAt[result] = ready;
  if (sourceValueEvent)
    valueEvent[result] = *sourceValueEvent;
  else
    valueEvent.erase(result);

  if (!tokenDeps.empty())
    tokenEvents[result] = std::move(tokenDeps);
  else
    tokenEvents.erase(result);

  if (!hazards.empty())
    issueSlotHazards[result] = hazards;
  else
    issueSlotHazards.erase(result);
}

unsigned InstructionExecutionState::getPipeInFlightCount(
    InstructionPipeKind kind) const {
  if (kind == InstructionPipeKind::None)
    return 0;
  unsigned count = 0;
  for (int64_t ready : pipeQueues[pipeIndex(kind)])
    if (ready > currentCycle)
      ++count;
  return count;
}

FailureOr<InstructionStall>
InstructionExecutionState::query(Operation *op) const {
  if (!isInstructionExecutionStateArchSupported(arch.isa)) {
    op->emitOpError(
        "instruction execution state supports gfx942, gfx950, RDNA3, and "
        "gfx1250 only");
    return failure();
  }
  if (!isWaveAMDMachineOp(op)) {
    op->emitOpError("instruction execution state expects a waveamdmachine op");
    return failure();
  }
  FailureOr<InstructionDesc> desc = describe(op);
  if (failed(desc))
    return failure();
  return query(op, *desc);
}

static unsigned getIssueHazardWait(const InstructionStall &stall) {
  unsigned wait = 0;
  for (const InstructionStallComponent &component : stall.components)
    if (component.kind == InstructionStallKind::InstructionHazard ||
        component.kind == InstructionStallKind::M0ReadWrite ||
        component.kind == InstructionStallKind::StoreWriteData)
      wait = std::max<unsigned>(wait, component.cycles);
  return wait;
}

FailureOr<InstructionCommitResult>
InstructionExecutionState::commit(Operation *op) {
  return commitWithResources(op, /*resourceState=*/nullptr, /*wave=*/0,
                             /*placement=*/{});
}

static LogicalResult validateCommitOp(Operation *op, const ArchData &arch) {
  if (!isInstructionExecutionStateArchSupported(arch.isa)) {
    op->emitOpError(
        "instruction execution state supports gfx942, gfx950, RDNA3, and "
        "gfx1250 only");
    return failure();
  }
  if (!isWaveAMDMachineOp(op)) {
    op->emitOpError("instruction execution state expects a waveamdmachine op");
    return failure();
  }
  return success();
}

void InstructionExecutionState::advanceToCycle(int64_t cycle) {
  assert(cycle >= currentCycle && "wave timeline moved back");
  currentCycle = cycle;
  pruneRetiredEvents(currentCycle);
}

void InstructionExecutionState::consumeCoexecutionWait(
    const InstructionDesc &desc) {
  if (desc.coexecution.waitsForWindow && coexecWindowSlots != 0)
    coexecWindowSlots = 0;
}

void InstructionExecutionState::commitCoexecution(const InstructionDesc &desc) {
  if (desc.coexecution.filledSlots != 0) {
    coexecWindowSlots -=
        std::min(coexecWindowSlots, desc.coexecution.filledSlots);
    coexecProducerRun = 0;
    return;
  }
  if (desc.coexecution.openedSlots == 0) {
    coexecProducerRun = 0;
    return;
  }
  ++coexecProducerRun;
  if (coexecProducerRun < desc.coexecution.producerBurst)
    return;
  coexecWindowSlots = desc.coexecution.openedSlots;
  coexecProducerRun = 0;
}

FailureOr<InstructionCommitResult>
InstructionExecutionState::commitWithResources(
    Operation *op, InstructionResourceState *resourceState, unsigned wave,
    WavePlacement placement) {
  if (failed(validateCommitOp(op, arch)))
    return failure();

  FailureOr<InstructionDesc> desc = describe(op);
  if (failed(desc))
    return failure();
  FailureOr<InstructionStall> queried =
      queryWithResources(op, *desc, resourceState, wave, placement);
  if (failed(queried))
    return failure();

  currentCycle += queried->cycles;
  pruneRetiredEvents(currentCycle);
  currentIssueSlot += getIssueHazardWait(*queried);
  consumeCoexecutionWait(*desc);

  InstructionCommitResult result;
  result.stall = *queried;
  result.priorityStall = *queried;
  result.computePriorityStall = *queried;
  result.issueCycle = currentCycle;

  if (desc->noMachineInst) {
    result.valueReadyCycle = commitNoMachineInst(op);
    commitM0(*desc);
    commitStoreData(*desc);
    result.nextIssueCycle = currentCycle;
    result.tokenReadyCycle = tokenReadyCycle(op);
    return result;
  }

  SmallVector<EventId, 4> newEvents =
      commitMemoryEvents(op, *desc, result.issueCycle);
  if (desc->ldsDmaIssue && config.smoothLdsDmaIssue && !resourceState)
    nextLdsDmaIssueCycle =
        saturatingAdd(result.issueCycle,
                      getLdsDmaServiceInterval(arch, getIssuePeriod(),
                                               config.ldsDmaIssueWaveStreams));
  int64_t valueReadyCycle = getResultReadyCycle(op, *desc, result.issueCycle);
  commitResults(op, *desc, result.issueCycle, newEvents);
  if (resourceState) {
    SmallVector<InstructionResourceUse, 6> uses =
        getResourceUses(op, *desc, *resourceState);
    resourceState->commit(wave, placement, uses, result.issueCycle);
    commitMemoryIssue(*desc, result.issueCycle);
  } else {
    commitPipe(desc->pipe, valueReadyCycle);
    if (desc->mfmaCoissueResource)
      mfmaCoissueReadyCycle =
          saturatingAdd(result.issueCycle, desc->resourceDuration);
    commitMemoryIssue(*desc, result.issueCycle);
  }
  currentIssueSlot += desc->issueSlots;
  commitCoexecution(*desc);
  commitIssueSlotHazards(op, *desc);
  commitM0(*desc);
  commitStoreData(*desc);

  currentCycle = saturatingAdd(result.issueCycle, getInstructionSpan(*desc));
  pruneRetiredEvents(currentCycle);
  result.nextIssueCycle = currentCycle;
  result.valueReadyCycle = valueReadyCycle;
  result.tokenReadyCycle = getTokenReadyCycle(op, newEvents);
  return result;
}

FailureOr<InstructionExecutionState::InstructionDesc>
InstructionExecutionState::describe(Operation *op) const {
  SchedClass cls = classifyOp(op);
  if (!isSchedClassSupported(arch, cls)) {
    op->emitOpError() << getSchedClassName(cls) << " is unsupported on "
                      << arch.name;
    return failure();
  }

  InstructionDesc desc;
  desc.waitcnt = op->hasTrait<traits::WaitcntOp>();
  desc.ldsDmaIssue = op->hasTrait<traits::LDSDmaOp>();
  desc.m0Writer = writesM0ThroughHazard(op);
  desc.m0Consumer = consumesM0ThroughHazard(op);
  if (std::optional<StoreWriteDataHazard> hazard =
          getStoreWriteDataHazard(op, arch.isa))
    desc.storeDataHazardLatency = hazard->latency;
  if (storeDataGap)
    desc.storeDataProducer = producesStoreWriteData(op);
  desc.waitsForTokenDeps = waitsForMemoryTokenDepsBeforeIssue(op);

  desc.noMachineInst = cls == SchedClass::NoInst;
  desc.legacyVALU = isLegacyVALU(op);
  desc.trans = cls == SchedClass::WriteTrans32;
  desc.laneRead = desc.legacyVALU &&
                  hasRegClass(op->getOperands(), RegClass::VGPR) &&
                  hasOnlyRegClass(op->getResults(), RegClass::SGPR);
  desc.pipe = pipeFor(arch, cls);
  desc.resourceDuration = getResourceCycles(arch, cls);
  desc.mfmaCoissueResource = usesMfmaCoissueResource(op, cls, arch);
  desc.instructionIssueCount = getInstructionIssueCount(op, arch.isa);
  desc.coexecution = config.scheduleModel.applyCoexecutionPolicy(
      getInstructionCoexecutionModel(op, cls, arch));
  desc.counterIssueCount = getWaitcntInfo(op).issueCount;
  desc.issueSlots = desc.instructionIssueCount;
  if (op->hasTrait<traits::MFMAOp>())
    desc.mfmaPasses = getMfmaPassCount(cls);
  desc.latency = getConfiguredLatency(arch, cls, config.calibration);
  configureDmaIssueDelay(op, desc);
  desc.memoryIssueResources = getMemoryIssueResources(op);

  MemoryCounterKind memoryCounter = getMemoryCounterKind(op);
  desc.counter = toInstructionCounter(memoryCounter);
  desc.eventClass = toInstructionEventClass(op);
  if (memoryCounter != MemoryCounterKind::None) {
    desc.memoryCounterLatency = getMemoryCounterLatency(
        arch, op, config.counterLatencies, config.calibration);
    desc.hasMemoryValue = hasMemoryValueLatency(op);
    if (desc.hasMemoryValue) {
      desc.memoryValueLatency =
          getMemoryValueLatency(arch, op, config.counterLatencies,
                                config.valueLatencies, config.calibration);
    }
  }
  return desc;
}

SmallVector<InstructionResourceUse, 6>
InstructionExecutionState::getResourceUses(
    Operation *op, const InstructionDesc &desc,
    const InstructionResourceState &resourceState) const {
  SmallVector<InstructionResourceUse, 6> uses;
  if (desc.noMachineInst)
    return uses;

  int64_t issuePeriod = getIssuePeriod();
  if (isa<DmaIssueDelayOp>(op))
    appendDmaIssueResourceUses(op, uses);
  else
    appendIssueResourceUses(desc.instructionIssueCount, /*offset=*/0,
                            issuePeriod, uses);

  appendPipeResourceUse(op, desc, resourceState, uses);
  appendMfmaCoissueResourceUse(desc, resourceState, uses);
  appendLdsResourceUses(desc, resourceState, issuePeriod, uses);
  return uses;
}

void InstructionExecutionState::appendPipeResourceUse(
    Operation *op, const InstructionDesc &desc,
    const InstructionResourceState &resourceState,
    SmallVectorImpl<InstructionResourceUse> &uses) const {
  // Delay result span is control flow, not SALU pipe occupancy.
  if (isa<DmaIssueDelayOp>(op) || desc.resourceDuration <= 0)
    return;
  InstructionResourceKind pipe = resourceForPipe(desc.pipe);
  if (!resourceState.isEnabled(pipe))
    return;
  uses.push_back({pipe, getInstructionResourceScope(pipe), /*units=*/1,
                  /*count=*/1, /*offset=*/0, /*period=*/0,
                  desc.resourceDuration});
}

void InstructionExecutionState::appendMfmaCoissueResourceUse(
    const InstructionDesc &desc, const InstructionResourceState &resourceState,
    SmallVectorImpl<InstructionResourceUse> &uses) const {
  if (!desc.mfmaCoissueResource || desc.resourceDuration <= 0 ||
      !resourceState.isEnabled(InstructionResourceKind::MfmaCoissue))
    return;
  uses.push_back({InstructionResourceKind::MfmaCoissue,
                  InstructionResourceScope::SIMD, /*units=*/1, /*count=*/1,
                  /*offset=*/0, /*period=*/0, desc.resourceDuration});
}

void InstructionExecutionState::appendLdsResourceUses(
    const InstructionDesc &desc, const InstructionResourceState &resourceState,
    int64_t issuePeriod, SmallVectorImpl<InstructionResourceUse> &uses) const {
  bool usesLds = hasMemoryIssueResource(desc.memoryIssueResources,
                                        MemoryIssueResource::Lds) ||
                 hasMemoryIssueResource(desc.memoryIssueResources,
                                        MemoryIssueResource::LdsDmaAccept);
  if (usesLds && resourceState.isEnabled(InstructionResourceKind::LdsIssue)) {
    uses.push_back({InstructionResourceKind::LdsIssue,
                    InstructionResourceScope::SIMDPair, /*units=*/1,
                    desc.instructionIssueCount, /*offset=*/0, issuePeriod,
                    arch.ldsIssuePeriod});
  }

  if (hasMemoryIssueResource(desc.memoryIssueResources,
                             MemoryIssueResource::LdsDmaAccept) &&
      resourceState.isEnabled(InstructionResourceKind::LdsDmaIssue)) {
    uses.push_back({InstructionResourceKind::LdsDmaIssue,
                    InstructionResourceScope::SIMDPair, /*units=*/1,
                    desc.instructionIssueCount, /*offset=*/0, issuePeriod,
                    arch.ldsDmaIssuePeriod});
  }
}

void InstructionExecutionState::appendIssueResourceUses(
    unsigned count, int64_t offset, int64_t period,
    SmallVectorImpl<InstructionResourceUse> &uses) const {
  uses.push_back({InstructionResourceKind::SimdIssue,
                  InstructionResourceScope::SIMD, /*units=*/1, count, offset,
                  period, getIssuePeriod()});
  if (arch.issuesPerCUPerCycle != 0)
    uses.push_back({InstructionResourceKind::CuIssue,
                    InstructionResourceScope::CU, /*units=*/1, count, offset,
                    period, /*duration=*/1});
}

void InstructionExecutionState::appendDmaIssueResourceUses(
    Operation *op, SmallVectorImpl<InstructionResourceUse> &uses) const {
  DmaIssueDelayOp delay = cast<DmaIssueDelayOp>(op);
  bool skipped =
      delay.getSkipCondition() &&
      config.dmaIssueDelayCohortPolicy == DmaIssueDelayCohortPolicy::Skipped;
  int64_t issuePeriod = getIssuePeriod();
  if (delay.getSkipCondition())
    appendIssueResourceUses(/*count=*/1, /*offset=*/0, /*period=*/0, uses);
  if (skipped)
    return;

  constexpr int64_t maxNopCycles = 16;
  int64_t cycles = delay.getCyclesAttr().getInt();
  unsigned nopCount =
      static_cast<unsigned>((cycles + maxNopCycles - 1) / maxNopCycles);
  int64_t nopOffset = delay.getSkipCondition() ? issuePeriod : 0;
  // s_nop blocks its wave; only emitted branch/NOPs reserve issue.
  appendIssueResourceUses(nopCount, nopOffset,
                          std::max(maxNopCycles, issuePeriod), uses);
}

void InstructionExecutionState::configureDmaIssueDelay(
    Operation *op, InstructionDesc &desc) const {
  DmaIssueDelayOp delay = dyn_cast<DmaIssueDelayOp>(op);
  if (!delay)
    return;
  bool skipped =
      delay.getSkipCondition() &&
      config.dmaIssueDelayCohortPolicy == DmaIssueDelayCohortPolicy::Skipped;
  int64_t cycles = delay.getCyclesAttr().getInt();
  int64_t issuePeriod = getIssuePeriod();
  desc.latency = 0;
  desc.resultReadyAtEnd = true;
  if (skipped) {
    desc.issueSlots = 1;
    desc.instructionSpan = issuePeriod;
    return;
  }
  desc.issueSlots =
      static_cast<uint64_t>(cycles) + (delay.getSkipCondition() ? 1 : 0);
  desc.instructionSpan = getDmaIssueDelayNopSpan(cycles, issuePeriod);
  if (delay.getSkipCondition())
    desc.instructionSpan = saturatingAdd(issuePeriod, desc.instructionSpan);
}

FailureOr<InstructionStall>
InstructionExecutionState::query(Operation *op,
                                 const InstructionDesc &desc) const {
  return queryWithResources(op, desc, /*resourceState=*/nullptr, /*wave=*/0,
                            /*placement=*/{});
}

FailureOr<InstructionStall> InstructionExecutionState::queryWithResources(
    Operation *op, const InstructionDesc &desc,
    const InstructionResourceState *resourceState, unsigned wave,
    WavePlacement placement) const {
  InstructionStall stall;
  if (failed(addDependencyStalls(op, desc, stall)))
    return failure();

  // Coexecution is a model stall; scheduling only supplies compatible fillers.
  if (desc.coexecution.waitsForWindow && coexecWindowSlots != 0)
    addComponent(stall, InstructionStallKind::CoexecWindow,
                 saturatingMultiply(coexecWindowSlots, getIssuePeriod()));

  if (resourceState) {
    addLocalMemoryIssueStalls(desc, stall);
    addIssueHazards(op, desc, stall);
  } else {
    addLocalResourceStalls(desc, stall);
    addIssueHazards(op, desc, stall);
    return stall;
  }

  if (failed(addSharedResourceStall(op, desc, *resourceState, wave, placement,
                                    stall)))
    return failure();
  return stall;
}

LogicalResult InstructionExecutionState::addDependencyStalls(
    Operation *op, const InstructionDesc &desc, InstructionStall &stall) const {
  if (!op->hasTrait<traits::NoMachineInst>()) {
    InstructionStallKind operandKind = InstructionStallKind::OperandValue;
    int64_t operandsReady = issueReadyCycle(op, operandKind);
    addComponent(stall, operandKind, operandsReady - currentCycle);
  }

  if (desc.waitsForTokenDeps) {
    int64_t tokenReady = tokenReadyCycle(op);
    addComponent(stall, InstructionStallKind::MemoryToken,
                 tokenReady - currentCycle);
  }

  if (desc.waitcnt) {
    FailureOr<int64_t> waitReady = waitcntReadyCycle(op, currentCycle);
    if (failed(waitReady))
      return failure();
    addComponent(stall, InstructionStallKind::Waitcnt,
                 *waitReady - currentCycle);
  }
  return success();
}

void InstructionExecutionState::addLocalMemoryIssueStalls(
    const InstructionDesc &desc, InstructionStall &stall) const {
  int64_t memoryIssueReady = memoryIssueReadyCycle(
      desc.memoryIssueResources, desc.instructionIssueCount, currentCycle);
  addComponent(stall, InstructionStallKind::IssueBackpressure,
               memoryIssueReady - currentCycle);
}

void InstructionExecutionState::addLocalResourceStalls(
    const InstructionDesc &desc, InstructionStall &stall) const {
  int64_t pipeReady = pipeReadyCycle(desc.pipe, currentCycle);
  addComponent(stall, InstructionStallKind::IssueBackpressure,
               pipeReady - currentCycle);

  if (desc.mfmaCoissueResource)
    addComponent(stall, InstructionStallKind::IssueBackpressure,
                 mfmaCoissueReadyCycle - currentCycle,
                 InstructionResourceKind::MfmaCoissue,
                 InstructionResourceScope::SIMD);

  addLocalMemoryIssueStalls(desc, stall);

  if (desc.ldsDmaIssue && config.smoothLdsDmaIssue)
    addComponent(stall, InstructionStallKind::IssueBackpressure,
                 nextLdsDmaIssueCycle - currentCycle);
}

LogicalResult InstructionExecutionState::addSharedResourceStall(
    Operation *op, const InstructionDesc &desc,
    const InstructionResourceState &resourceState, unsigned wave,
    WavePlacement placement, InstructionStall &stall) const {
  SmallVector<InstructionResourceUse, 6> uses =
      getResourceUses(op, desc, resourceState);
  int64_t resourceEarliest = saturatingAdd(currentCycle, stall.cycles);
  FailureOr<InstructionResourceQuery> resource =
      resourceState.query(wave, placement, uses, resourceEarliest);
  if (failed(resource)) {
    op->emitOpError("resource reservation exceeds modeled capacity");
    return failure();
  }
  if (resource->readyCycle > resourceEarliest)
    addComponent(stall, InstructionStallKind::IssueBackpressure,
                 resource->readyCycle - currentCycle, resource->kind,
                 resource->scope);
  return success();
}

void InstructionExecutionState::addIssueHazards(Operation *op,
                                                const InstructionDesc &desc,
                                                InstructionStall &stall) const {
  if ((desc.m0Consumer && m0GapArmed) ||
      (desc.m0Writer && m0DmaCaptureGapArmed))
    addComponent(stall, InstructionStallKind::M0ReadWrite, 1);
  if (desc.storeDataProducer && storeDataGap)
    addComponent(stall, InstructionStallKind::StoreWriteData, storeDataGap);
  addComponent(stall, InstructionStallKind::InstructionHazard,
               issueSlotHazardWait(op, desc));
}

uint64_t InstructionExecutionState::mfmaOperandReadyAt(
    Operation *op, const InstructionDesc &desc, unsigned operandIndex,
    const IssueSlotHazards &hazards) const {
  if (!desc.mfmaPasses)
    return isXdlResultHazardConsumer(op) ? hazards.mfmaResultReadyAt : 0;
  if (operandIndex != 2)
    return hazards.mfmaResultReadyAt;
  return hazards.mfmaSrcCExactReadyAt ? hazards.mfmaSrcCExactReadyAt
                                      : hazards.mfmaSrcCOverlapReadyAt;
}

unsigned InstructionExecutionState::mfmaIssueSlotHazardWait(
    Operation *op, const InstructionDesc &desc, unsigned operandIndex,
    const IssueSlotHazards &hazards) const {
  unsigned wait = issueSlotsUntil(
      mfmaOperandReadyAt(op, desc, operandIndex, hazards), currentIssueSlot);
  if (desc.mfmaPasses)
    wait = std::max(wait, issueSlotsUntil(hazards.valuWriteVGPRMfmaReadyAt,
                                          currentIssueSlot));
  return wait;
}

unsigned InstructionExecutionState::legacyValuIssueSlotHazardWait(
    Value operand, const InstructionDesc &desc,
    const IssueSlotHazards &hazards) const {
  if (!desc.legacyVALU || issueSlotHazardConfig.empty())
    return 0;
  unsigned wait = 0;
  std::optional<RegClass> regClass = getRegClass(operand);
  if (regClass == RegClass::VGPR) {
    if (!desc.trans)
      wait = std::max(wait, issueSlotsUntil(hazards.transWriteVGPRReadyAt,
                                            currentIssueSlot));
    if (desc.laneRead)
      wait = std::max(wait, issueSlotsUntil(hazards.valuWriteVGPRScalarReadyAt,
                                            currentIssueSlot));
  }
  if (regClass == RegClass::SGPR || regClass == RegClass::VCC)
    wait = std::max(
        wait, issueSlotsUntil(hazards.valuWriteSGPRReadyAt, currentIssueSlot));
  return wait;
}

unsigned InstructionExecutionState::permlane32SwapIssueSlotHazardWait(
    Operation *op, const IssueSlotHazards &hazards) const {
  if (!isa<VPermlane32SwapB32TupleOp>(op))
    return 0;
  return issueSlotsUntil(hazards.valuWriteVGPRPermlane32SwapReadyAt,
                         currentIssueSlot);
}

unsigned InstructionExecutionState::issueSlotHazardWait(
    Operation *op, const InstructionDesc &desc) const {
  unsigned wait = 0;
  for (auto [operandIndex, operand] : llvm::enumerate(op->getOperands())) {
    DenseMap<Value, IssueSlotHazards>::const_iterator it =
        issueSlotHazards.find(operand);
    if (it == issueSlotHazards.end())
      continue;
    wait = std::max(
        wait, mfmaIssueSlotHazardWait(op, desc, operandIndex, it->second));
    wait = std::max(wait,
                    legacyValuIssueSlotHazardWait(operand, desc, it->second));
    wait = std::max(wait, permlane32SwapIssueSlotHazardWait(op, it->second));
  }
  return wait;
}

LogicalResult InstructionExecutionState::combineCounterReadyCycle(
    int64_t &ready, InstructionWaitCounterKind kind,
    std::optional<uint32_t> limit, int64_t cycle,
    ArrayRef<InstructionEventClass> eventClasses) const {
  if (!limit)
    return success();
  FailureOr<int64_t> counterReady =
      counterReadyCycle(kind, *limit, cycle, eventClasses);
  if (failed(counterReady))
    return failure();
  ready = std::max(ready, *counterReady);
  return success();
}

FailureOr<int64_t>
InstructionExecutionState::waitcntReadyCycle(SWaitcntOp wait,
                                             int64_t cycle) const {
  int64_t ready = cycle;
  if (failed(combineCounterReadyCycle(ready, InstructionWaitCounterKind::Vmem,
                                      wait.getVmcnt(), cycle, {})))
    return failure();
  if (failed(combineCounterReadyCycle(ready, InstructionWaitCounterKind::Lgkm,
                                      wait.getLgkmcnt(), cycle, {}))) {
    wait.emitOpError(
        "nonzero lgkmcnt with pending SMEM event is unsupported by "
        "instruction execution state");
    return failure();
  }
  if (failed(combineCounterReadyCycle(ready, InstructionWaitCounterKind::Expcnt,
                                      wait.getExpcnt(), cycle, {})))
    return failure();
  return ready;
}

FailureOr<int64_t>
InstructionExecutionState::waitcntReadyCycle(SWaitcntSplitOp wait,
                                             int64_t cycle) const {
  if (wait.getXcnt()) {
    wait.emitOpError("xcnt is unsupported by instruction execution state");
    return failure();
  }

  static constexpr std::array<InstructionEventClass, 1> loadEvents = {
      InstructionEventClass::VmemLoad};
  static constexpr std::array<InstructionEventClass, 1> storeEvents = {
      InstructionEventClass::VmemStore};
  static constexpr std::array<InstructionEventClass, 1> dsEvents = {
      InstructionEventClass::LdsDs};
  static constexpr std::array<InstructionEventClass, 2> kmEvents = {
      InstructionEventClass::Smem, InstructionEventClass::Message};
  static constexpr std::array<InstructionEventClass, 1> asyncEvents = {
      InstructionEventClass::Async};
  static constexpr std::array<InstructionEventClass, 1> tensorEvents = {
      InstructionEventClass::Tensor};

  int64_t ready = cycle;
  if (failed(combineCounterReadyCycle(ready, InstructionWaitCounterKind::Vmem,
                                      wait.getLoadcnt(), cycle, loadEvents)) ||
      failed(combineCounterReadyCycle(ready, InstructionWaitCounterKind::Vscnt,
                                      wait.getStorecnt(), cycle,
                                      storeEvents)) ||
      failed(combineCounterReadyCycle(ready, InstructionWaitCounterKind::Lgkm,
                                      wait.getDscnt(), cycle, dsEvents)))
    return failure();
  if (failed(combineCounterReadyCycle(ready, InstructionWaitCounterKind::Lgkm,
                                      wait.getKmcnt(), cycle, kmEvents))) {
    wait.emitOpError("nonzero kmcnt with pending SMEM event is unsupported by "
                     "instruction execution state");
    return failure();
  }
  if (failed(combineCounterReadyCycle(ready, InstructionWaitCounterKind::Async,
                                      wait.getAsynccnt(), cycle, asyncEvents)))
    return failure();
  if (failed(combineCounterReadyCycle(ready, InstructionWaitCounterKind::Tensor,
                                      wait.getTensorcnt(), cycle,
                                      tensorEvents)))
    return failure();
  return ready;
}

FailureOr<int64_t>
InstructionExecutionState::waitcntReadyCycle(Operation *op,
                                             int64_t cycle) const {
  if (SWaitcntVscntOp wait = dyn_cast<SWaitcntVscntOp>(op))
    return counterReadyCycle(InstructionWaitCounterKind::Vscnt, wait.getVscnt(),
                             cycle);
  if (SWaitcntOp wait = dyn_cast<SWaitcntOp>(op))
    return waitcntReadyCycle(wait, cycle);
  if (SWaitcntSplitOp wait = dyn_cast<SWaitcntSplitOp>(op))
    return waitcntReadyCycle(wait, cycle);
  return cycle;
}

FailureOr<int64_t> InstructionExecutionState::counterReadyCycle(
    InstructionWaitCounterKind kind, unsigned limit, int64_t cycle,
    ArrayRef<InstructionEventClass> eventClasses) const {
  SmallVector<const PendingEvent *, 8> pending;
  for (EventId id : waitQueues[counterIndex(kind)]) {
    DenseMap<EventId, PendingEvent>::const_iterator it = events.find(id);
    if (it == events.end() || it->second.retireCycle <= cycle)
      continue;
    if (!eventClasses.empty() &&
        !llvm::is_contained(eventClasses, it->second.eventClass))
      continue;
    if (kind == InstructionWaitCounterKind::Lgkm && limit != 0 &&
        it->second.eventClass == InstructionEventClass::Smem)
      return failure();
    pending.push_back(&it->second);
  }

  if (pending.size() <= limit)
    return cycle;
  llvm::sort(pending, [](const PendingEvent *lhs, const PendingEvent *rhs) {
    return std::pair(lhs->retireCycle, lhs->id) <
           std::pair(rhs->retireCycle, rhs->id);
  });
  return pending[pending.size() - limit - 1]->retireCycle;
}

int64_t InstructionExecutionState::operandReadyCycle(
    Operation *op, InstructionStallKind &stallKind) const {
  int64_t ready = currentCycle;
  stallKind = InstructionStallKind::OperandValue;
  for (auto [operandIndex, operand] : llvm::enumerate(op->getOperands())) {
    if (isMemToken(operand))
      continue;
    DenseMap<Value, IssueSlotHazards>::const_iterator hazardIt =
        issueSlotHazards.find(operand);
    bool exactMfmaSrcC = op->hasTrait<traits::MFMAOp>() && operandIndex == 2 &&
                         hazardIt != issueSlotHazards.end() &&
                         hazardIt->second.mfmaSrcCExactReadyAt != 0;
    if (exactMfmaSrcC)
      continue;
    DenseMap<Value, int64_t>::const_iterator it = valueReadyAt.find(operand);
    if (it == valueReadyAt.end() || it->second <= ready)
      continue;
    ready = it->second;
    if (valueEvent.contains(operand))
      stallKind = InstructionStallKind::MemoryValue;
  }
  return ready;
}

int64_t InstructionExecutionState::issueReadyCycle(
    Operation *op, InstructionStallKind &stallKind) const {
  int64_t ready = operandReadyCycle(op, stallKind);
  DmaIssueDelayOp delay = dyn_cast<DmaIssueDelayOp>(op);
  if (!delay)
    return ready;
  DenseMap<Value, int64_t>::const_iterator it =
      valueReadyAt.find(delay.getDependency());
  if (it == valueReadyAt.end())
    return ready;
  IntegerAttr overlapAttr = delay.getOverlapCyclesAttr();
  int64_t overlap = overlapAttr ? overlapAttr.getInt() : 0;
  return std::max(ready, saturatingAdd(it->second, overlap));
}

int64_t InstructionExecutionState::tokenReadyCycle(Operation *op) const {
  int64_t ready = currentCycle;
  for (EventId id : collectTokenDeps(op)) {
    DenseMap<EventId, PendingEvent>::const_iterator it = events.find(id);
    if (it != events.end())
      ready = std::max(ready, it->second.retireCycle);
  }
  return ready;
}

int64_t InstructionExecutionState::pipeReadyCycle(InstructionPipeKind pipe,
                                                  int64_t cycle) const {
  unsigned maxInFlight = maxInFlightForPipe(config, pipe);
  if (pipe == InstructionPipeKind::None || maxInFlight == 0)
    return cycle;

  SmallVector<int64_t, 8> pending;
  for (int64_t ready : pipeQueues[pipeIndex(pipe)])
    if (ready > cycle)
      pending.push_back(ready);
  if (pending.size() < maxInFlight)
    return cycle;
  llvm::sort(pending);
  return pending[pending.size() - maxInFlight];
}

int64_t InstructionExecutionState::memoryIssueReadyCycle(
    MemoryIssueResource resource, unsigned issueCount, int64_t cycle) const {
  unsigned maxInFlight = maxInFlightForMemoryIssue(arch, resource);
  if (maxInFlight == 0 || memoryIssueLatency(arch, resource) <= 0)
    return cycle;

  SmallVector<int64_t, 8> pending;
  for (int64_t ready : memoryIssueQueues[memoryIssueIndex(resource)])
    if (ready > cycle)
      pending.push_back(ready);

  unsigned needed = std::min(std::max(1u, issueCount), maxInFlight);
  if (pending.size() + needed <= maxInFlight)
    return cycle;
  llvm::sort(pending);
  return pending[pending.size() + needed - maxInFlight - 1];
}

int64_t InstructionExecutionState::memoryIssueReadyCycle(
    MemoryIssueResourceMask resources, unsigned issueCount,
    int64_t cycle) const {
  int64_t ready = cycle;
  for (MemoryIssueResource resource : kMemoryIssueResources)
    if (hasMemoryIssueResource(resources, resource))
      ready =
          std::max(ready, memoryIssueReadyCycle(resource, issueCount, cycle));
  return ready;
}

int64_t InstructionExecutionState::getIssuePeriod() const {
  if (config.issuePeriod > 0)
    return config.issuePeriod;
  return std::max(1, arch.simdIssuePeriod);
}

int64_t InstructionExecutionState::getInstructionSpan(
    const InstructionDesc &desc) const {
  if (desc.instructionSpan != 0)
    return desc.instructionSpan;
  return static_cast<int64_t>(desc.instructionIssueCount) * getIssuePeriod();
}

int64_t InstructionExecutionState::getResultReadyCycle(
    Operation *op, const InstructionDesc &desc, int64_t issueCycle) const {
  if (desc.resultReadyAtEnd)
    return saturatingAdd(issueCycle, getInstructionSpan(desc));
  int64_t latency =
      desc.hasMemoryValue ? desc.memoryValueLatency : desc.latency;
  bool hasRegisterResult = llvm::any_of(
      op->getResults(), [](Value result) { return !isMemToken(result); });
  if (!hasRegisterResult)
    return issueCycle;
  return issueCycle +
         (static_cast<int64_t>(desc.instructionIssueCount) - 1) *
             getIssuePeriod() +
         std::max<int64_t>(0, latency);
}

int64_t InstructionExecutionState::getTokenReadyCycle(
    Operation *op, ArrayRef<EventId> newEvents) const {
  int64_t ready = currentCycle;
  for (EventId id : collectTokenDeps(op)) {
    DenseMap<EventId, PendingEvent>::const_iterator it = events.find(id);
    if (it != events.end())
      ready = std::max(ready, it->second.retireCycle);
  }
  for (EventId id : newEvents) {
    DenseMap<EventId, PendingEvent>::const_iterator it = events.find(id);
    if (it != events.end())
      ready = std::max(ready, it->second.retireCycle);
  }
  return ready;
}

int64_t InstructionExecutionState::commitNoMachineInst(Operation *op) {
  SmallVector<Value, 8> sources(op->operand_begin(), op->operand_end());
  if (dropsTokenCompletion(op))
    sources.clear();
  int64_t ready = currentCycle;
  for (Value result : op->getResults()) {
    bindValue(result, sources);
    if (!isMemToken(result))
      ready = std::max(ready, getValueReadyCycle(result));
  }
  return ready;
}

SmallVector<InstructionExecutionState::EventId, 4>
InstructionExecutionState::commitMemoryEvents(Operation *op,
                                              const InstructionDesc &desc,
                                              int64_t issueCycle) {
  SmallVector<EventId, 4> newEvents;
  if (desc.counter == InstructionWaitCounterKind::None)
    return newEvents;

  unsigned queue = counterIndex(desc.counter);
  for (unsigned issue : llvm::seq<unsigned>(0, desc.counterIssueCount)) {
    EventId id = nextEventId++;
    PendingEvent event;
    event.id = id;
    event.op = op;
    event.counter = desc.counter;
    event.eventClass = desc.eventClass;
    event.retireCycle = issueCycle +
                        static_cast<int64_t>(issue) * getIssuePeriod() +
                        desc.memoryCounterLatency;
    events.insert({id, event});
    waitQueues[queue].push_back(id);
    newEvents.push_back(id);
  }
  return newEvents;
}

void InstructionExecutionState::commitResults(Operation *op,
                                              const InstructionDesc &desc,
                                              int64_t issueCycle,
                                              ArrayRef<EventId> newEvents) {
  SmallVector<EventId, 4> deps = collectTokenDeps(op);
  appendUniqueEvents(deps, newEvents);

  int64_t ready = getResultReadyCycle(op, desc, issueCycle);
  for (Value result : op->getResults()) {
    int64_t resultReady = ready;
    if (desc.m0Writer && isa<M0Type>(result.getType()))
      resultReady = issueCycle;
    valueReadyAt[result] = resultReady;
    if (isMemToken(result)) {
      tokenEvents[result] = deps;
      continue;
    }
    if (!newEvents.empty())
      valueEvent[result] = newEvents.back();
  }
}

void InstructionExecutionState::commitPipe(InstructionPipeKind pipe,
                                           int64_t readyCycle) {
  if (pipe == InstructionPipeKind::None)
    return;
  pipeQueues[pipeIndex(pipe)].push_back(readyCycle);
}

void InstructionExecutionState::commitMemoryIssue(const InstructionDesc &desc,
                                                  int64_t issueCycle) {
  for (MemoryIssueResource resource : kMemoryIssueResources) {
    if (!hasMemoryIssueResource(desc.memoryIssueResources, resource))
      continue;
    int64_t latency = memoryIssueLatency(arch, resource);
    if (maxInFlightForMemoryIssue(arch, resource) == 0 || latency <= 0)
      continue;

    unsigned queue = memoryIssueIndex(resource);
    for (unsigned issue : llvm::seq<unsigned>(0, desc.instructionIssueCount)) {
      int64_t issuedAt =
          issueCycle + static_cast<int64_t>(issue) * getIssuePeriod();
      memoryIssueQueues[queue].push_back(issuedAt + latency);
    }
  }
}

void InstructionExecutionState::commitIssueSlotHazards(
    Operation *op, const InstructionDesc &desc) {
  if (desc.mfmaPasses || (desc.legacyVALU && !issueSlotHazardConfig.empty()))
    commitIssueSlotProducer(op, desc);
}

void InstructionExecutionState::commitIssueSlotProducer(
    Operation *op, const InstructionDesc &desc) {
  if (desc.mfmaPasses) {
    for (Value result : op->getResults()) {
      IssueSlotHazards &hazards = issueSlotHazards[result];
      hazards.mfmaResultReadyAt =
          currentIssueSlot +
          getXdlResultHazardLatency(arch.isa, desc.mfmaPasses);
      hazards.mfmaSrcCOverlapReadyAt =
          currentIssueSlot +
          getXdlSrcCOverlapHazardLatency(arch.isa, desc.mfmaPasses);
      hazards.mfmaSrcCExactReadyAt =
          currentIssueSlot +
          getXdlSrcCExactHazardLatency(arch.isa, desc.mfmaPasses);
    }
    return;
  }
  for (Value result : op->getResults()) {
    std::optional<RegClass> regClass = getRegClass(result);
    if (regClass == RegClass::VGPR) {
      IssueSlotHazards &hazards = issueSlotHazards[result];
      hazards.valuWriteVGPRScalarReadyAt =
          currentIssueSlot + issueSlotHazardConfig.valuWriteVGPRScalarRead;
      hazards.valuWriteVGPRMfmaReadyAt =
          currentIssueSlot + issueSlotHazardConfig.valuWriteVGPRMfmaRead;
      if (issueSlotHazardConfig.valuWriteVGPRPermlane32Swap)
        hazards.valuWriteVGPRPermlane32SwapReadyAt =
            currentIssueSlot +
            issueSlotHazardConfig.valuWriteVGPRPermlane32Swap;
      if (desc.trans)
        hazards.transWriteVGPRReadyAt =
            currentIssueSlot + issueSlotHazardConfig.transWriteVGPRValuRead;
    }
    if (regClass == RegClass::SGPR || regClass == RegClass::VCC)
      issueSlotHazards[result].valuWriteSGPRReadyAt =
          currentIssueSlot + issueSlotHazardConfig.valuWriteSGPRValuRead;
  }
}

void InstructionExecutionState::commitM0(const InstructionDesc &desc) {
  if (desc.m0Writer)
    m0GapArmed = true;
  else if (desc.waitcnt || !desc.noMachineInst)
    m0GapArmed = false;

  if (desc.ldsDmaIssue && isCDNA4(arch.isa))
    m0DmaCaptureGapArmed = true;
  else if (desc.waitcnt || !desc.noMachineInst)
    m0DmaCaptureGapArmed = false;
}

void InstructionExecutionState::commitStoreData(const InstructionDesc &desc) {
  if (desc.storeDataProducer && storeDataGap)
    storeDataGap = 0;
  else if (!desc.noMachineInst && storeDataGap)
    --storeDataGap;
  storeDataGap = std::max(storeDataGap, desc.storeDataHazardLatency);
}

void InstructionExecutionState::pruneRetiredEvents(int64_t cycle) {
  for (SmallVector<EventId, 8> &queue : waitQueues) {
    queue.erase(
        std::remove_if(queue.begin(), queue.end(),
                       [&](EventId id) { return !hasPendingEvent(id, cycle); }),
        queue.end());
  }
  for (SmallVector<int64_t, 8> &queue : pipeQueues) {
    queue.erase(std::remove_if(queue.begin(), queue.end(),
                               [&](int64_t ready) { return ready <= cycle; }),
                queue.end());
  }
  for (SmallVector<int64_t, 8> &queue : memoryIssueQueues) {
    queue.erase(std::remove_if(queue.begin(), queue.end(),
                               [&](int64_t ready) { return ready <= cycle; }),
                queue.end());
  }
}

SmallVector<InstructionExecutionState::EventId, 4>
InstructionExecutionState::collectTokenDeps(Operation *op) const {
  SmallVector<EventId, 4> deps;
  if (dropsTokenCompletion(op))
    return deps;
  for (Value operand : op->getOperands()) {
    if (!isMemToken(operand))
      continue;
    DenseMap<Value, SmallVector<EventId, 4>>::const_iterator it =
        tokenEvents.find(operand);
    if (it == tokenEvents.end())
      continue;
    appendUniqueEvents(deps, it->second);
  }
  return deps;
}

bool InstructionExecutionState::hasPendingEvent(EventId id,
                                                int64_t cycle) const {
  DenseMap<EventId, PendingEvent>::const_iterator it = events.find(id);
  return it != events.end() && it->second.retireCycle > cycle;
}

} // namespace mlir::waveamdmachine
