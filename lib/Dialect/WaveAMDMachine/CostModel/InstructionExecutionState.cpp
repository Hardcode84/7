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
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/Operation.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/Support/ErrorHandling.h"

#include <algorithm>
#include <array>
#include <cassert>
#include <limits>

namespace mlir::waveamdmachine {

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

static bool isaEq(const llvm::AMDGPU::IsaVersion &lhs,
                  const llvm::AMDGPU::IsaVersion &rhs) {
  return lhs.Major == rhs.Major && lhs.Minor == rhs.Minor &&
         lhs.Stepping == rhs.Stepping;
}

static bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         WaveAMDMachineDialect::getDialectNamespace();
}

static bool isMemToken(Value value) {
  return isa<MemTokenType>(value.getType());
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

static WaitcntInfo getWaitcntInfo(Operation *op) {
  if (WaitcntInfoOpInterface info = dyn_cast<WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo();
  return {};
}

static int getConfiguredLatency(const ArchData &arch, SchedClass cls,
                                const CalibrationData *calibration) {
  if (!calibration)
    return getLatency(arch, cls);
  return getCalibratedLatency(arch, cls, *calibration);
}

static InstructionEventClass getVmemEventClass(WaitcntCounter counter) {
  return counter == WaitcntCounter::Vscnt ? InstructionEventClass::VmemStore
                                          : InstructionEventClass::VmemLoad;
}

static InstructionWaitCounterKind toInstructionCounter(MemoryCounterKind kind) {
  switch (kind) {
  case MemoryCounterKind::Vmem:
    return InstructionWaitCounterKind::Vmem;
  case MemoryCounterKind::Lgkm:
    return InstructionWaitCounterKind::Lgkm;
  case MemoryCounterKind::Vscnt:
    return InstructionWaitCounterKind::Vscnt;
  case MemoryCounterKind::None:
    return InstructionWaitCounterKind::None;
  }
  llvm_unreachable("bad memory counter");
}

static InstructionEventClass toInstructionEventClass(Operation *op) {
  WaitcntInfo info = getWaitcntInfo(op);
  switch (info.event) {
  case WaitcntEvent::Vmem:
  case WaitcntEvent::Flat:
    return getVmemEventClass(info.counter);
  case WaitcntEvent::VmemStore:
  case WaitcntEvent::ScratchStore:
    return InstructionEventClass::VmemStore;
  case WaitcntEvent::Lds:
  case WaitcntEvent::Gds:
  case WaitcntEvent::Message:
    return InstructionEventClass::LdsDs;
  case WaitcntEvent::Smem:
    return InstructionEventClass::Smem;
  case WaitcntEvent::None:
    return InstructionEventClass::None;
  }
  llvm_unreachable("bad waitcnt event");
}

static unsigned getIssueCount(Operation *op) {
  WaitcntInfo info = getWaitcntInfo(op);
  return std::max(1u, info.issueCount);
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
  case InstructionWaitCounterKind::None:
    break;
  }
  llvm_unreachable("counter has no queue");
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
  llvm::SmallSet<uint64_t, 8> seen;
  for (uint64_t id : events)
    seen.insert(id);
  for (uint64_t id : appended)
    if (seen.insert(id).second)
      events.push_back(id);
}

static void addComponent(InstructionStall &stall, InstructionStallKind kind,
                         int64_t cycles) {
  if (cycles <= 0)
    return;
  stall.components.push_back({kind, cycles});
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
  return isaEq(isa, {9, 4, 2}) || isaEq(isa, {9, 5, 0}) || isa.Major == 11;
}

bool waitsForMemoryTokenDepsBeforeIssue(Operation *op) {
  if (!hasMemoryTokenOperand(op))
    return false;
  if (isa<SBarrierOp, BarrierArriveOp>(op))
    return true;
  if (op->hasTrait<traits::LDSDmaOp>())
    return true;
  if (op->hasTrait<traits::VMEMStoreOp>() || op->hasTrait<traits::LDSStoreOp>())
    return true;
  return false;
}

llvm::StringRef getInstructionStallKindName(InstructionStallKind kind) {
  switch (kind) {
  case InstructionStallKind::None:
    return "none";
  case InstructionStallKind::IssueBackpressure:
    return "issue_backpressure";
  case InstructionStallKind::OperandValue:
    return "operand_value";
  case InstructionStallKind::MemoryValue:
    return "memory_value";
  case InstructionStallKind::MemoryToken:
    return "memory_token";
  case InstructionStallKind::Waitcnt:
    return "waitcnt";
  case InstructionStallKind::InstructionHazard:
    return "instruction_hazard";
  case InstructionStallKind::M0ReadWrite:
    return "m0_read_write";
  case InstructionStallKind::StoreWriteData:
    return "store_write_data";
  }
  llvm_unreachable("bad stall kind");
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

llvm::StringRef
getInstructionWaitCounterKindName(InstructionWaitCounterKind kind) {
  switch (kind) {
  case InstructionWaitCounterKind::None:
    return "none";
  case InstructionWaitCounterKind::Vmem:
    return "vmem";
  case InstructionWaitCounterKind::Lgkm:
    return "lgkm";
  case InstructionWaitCounterKind::Vscnt:
    return "vscnt";
  case InstructionWaitCounterKind::Expcnt:
    return "expcnt";
  }
  llvm_unreachable("bad wait counter kind");
}

llvm::StringRef getInstructionEventClassName(InstructionEventClass eventClass) {
  switch (eventClass) {
  case InstructionEventClass::None:
    return "none";
  case InstructionEventClass::VmemLoad:
    return "vmem_load";
  case InstructionEventClass::VmemStore:
    return "vmem_store";
  case InstructionEventClass::LdsDs:
    return "lds_ds";
  case InstructionEventClass::Smem:
    return "smem";
  case InstructionEventClass::Export:
    return "export";
  }
  llvm_unreachable("bad event class");
}

InstructionExecutionState::InstructionExecutionState(
    const ArchData &arch, InstructionExecutionConfig config)
    : config(config), arch(arch),
      issueSlotHazardConfig(getInstructionIssueSlotHazardConfig(arch.isa)) {}

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
    op->emitOpError("instruction execution state supports gfx942, gfx950, "
                    "and RDNA3 only");
    return failure();
  }
  if (!isWaveAMDMachineOp(op)) {
    op->emitOpError("instruction execution state expects a waveamdmachine op");
    return failure();
  }
  InstructionDesc desc = describe(op);
  return query(op, desc);
}

FailureOr<InstructionCommitResult>
InstructionExecutionState::commit(Operation *op) {
  if (!isInstructionExecutionStateArchSupported(arch.isa)) {
    op->emitOpError("instruction execution state supports gfx942, gfx950, "
                    "and RDNA3 only");
    return failure();
  }
  if (!isWaveAMDMachineOp(op)) {
    op->emitOpError("instruction execution state expects a waveamdmachine op");
    return failure();
  }

  InstructionDesc desc = describe(op);
  FailureOr<InstructionStall> queried = query(op, desc);
  if (failed(queried))
    return failure();

  currentCycle += queried->cycles;
  pruneRetiredEvents(currentCycle);

  unsigned issueHazardWait = 0;
  for (const InstructionStallComponent &component : queried->components)
    if (component.kind == InstructionStallKind::InstructionHazard ||
        component.kind == InstructionStallKind::M0ReadWrite ||
        component.kind == InstructionStallKind::StoreWriteData)
      issueHazardWait = std::max<unsigned>(issueHazardWait, component.cycles);
  currentIssueSlot += issueHazardWait;

  InstructionCommitResult result;
  result.stall = *queried;
  result.issueCycle = currentCycle;

  if (desc.noMachineInst) {
    result.valueReadyCycle = commitNoMachineInst(op);
    commitM0(desc);
    commitStoreData(desc);
    result.nextIssueCycle = currentCycle;
    result.tokenReadyCycle = tokenReadyCycle(op);
    return result;
  }

  SmallVector<EventId, 4> newEvents =
      commitMemoryEvents(op, desc, result.issueCycle);
  int64_t valueReadyCycle = getResultReadyCycle(op, desc, result.issueCycle);
  commitResults(op, desc, result.issueCycle, newEvents);
  commitPipe(desc.pipe, valueReadyCycle);
  commitMemoryIssue(desc, result.issueCycle);
  currentIssueSlot += desc.issueSlots;
  commitIssueSlotHazards(op, desc);
  commitM0(desc);
  commitStoreData(desc);

  currentCycle = saturatingAdd(result.issueCycle, getInstructionSpan(desc));
  pruneRetiredEvents(currentCycle);
  result.nextIssueCycle = currentCycle;
  result.valueReadyCycle = valueReadyCycle;
  result.tokenReadyCycle = getTokenReadyCycle(op, newEvents);
  return result;
}

InstructionExecutionState::InstructionDesc
InstructionExecutionState::describe(Operation *op) const {
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

  SchedClass cls = classifyOp(op);
  desc.noMachineInst = cls == SchedClass::NoInst;
  desc.legacyVALU = isLegacyVALU(op);
  desc.trans = cls == SchedClass::WriteTrans32;
  desc.laneRead = desc.legacyVALU &&
                  hasRegClass(op->getOperands(), RegClass::VGPR) &&
                  hasOnlyRegClass(op->getResults(), RegClass::SGPR);
  desc.pipe = pipeFor(arch, cls);
  desc.issueCount = getIssueCount(op);
  desc.issueSlots = desc.issueCount;
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
  InstructionStall stall;

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

  int64_t pipeReady = pipeReadyCycle(desc.pipe, currentCycle);
  addComponent(stall, InstructionStallKind::IssueBackpressure,
               pipeReady - currentCycle);

  int64_t memoryIssueReady = memoryIssueReadyCycle(
      desc.memoryIssueResources, desc.issueCount, currentCycle);
  addComponent(stall, InstructionStallKind::IssueBackpressure,
               memoryIssueReady - currentCycle);

  addIssueHazards(op, desc, stall);

  return stall;
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
  if (regClass == RegClass::VCC)
    wait = std::max(
        wait, issueSlotsUntil(hazards.valuWriteVCCReadyAt, currentIssueSlot));
  return wait;
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
  }
  return wait;
}

FailureOr<int64_t>
InstructionExecutionState::waitcntReadyCycle(Operation *op,
                                             int64_t cycle) const {
  if (SWaitcntVscntOp wait = dyn_cast<SWaitcntVscntOp>(op))
    return counterReadyCycle(InstructionWaitCounterKind::Vscnt, wait.getVscnt(),
                             cycle);

  if (SWaitcntOp wait = dyn_cast<SWaitcntOp>(op)) {
    int64_t ready = cycle;
    if (std::optional<uint32_t> vmcnt = wait.getVmcnt()) {
      FailureOr<int64_t> counterReady =
          counterReadyCycle(InstructionWaitCounterKind::Vmem, *vmcnt, cycle);
      if (failed(counterReady))
        return failure();
      ready = std::max(ready, *counterReady);
    }
    if (std::optional<uint32_t> lgkmcnt = wait.getLgkmcnt()) {
      FailureOr<int64_t> counterReady =
          counterReadyCycle(InstructionWaitCounterKind::Lgkm, *lgkmcnt, cycle);
      if (failed(counterReady)) {
        op->emitOpError("nonzero lgkmcnt with pending SMEM event is "
                        "unsupported by instruction execution state");
        return failure();
      }
      ready = std::max(ready, *counterReady);
    }
    if (std::optional<uint32_t> expcnt = wait.getExpcnt()) {
      FailureOr<int64_t> counterReady =
          counterReadyCycle(InstructionWaitCounterKind::Expcnt, *expcnt, cycle);
      if (failed(counterReady))
        return failure();
      ready = std::max(ready, *counterReady);
    }
    return ready;
  }

  return cycle;
}

FailureOr<int64_t> InstructionExecutionState::counterReadyCycle(
    InstructionWaitCounterKind kind, unsigned limit, int64_t cycle) const {
  SmallVector<const PendingEvent *, 8> pending;
  for (EventId id : waitQueues[counterIndex(kind)]) {
    DenseMap<EventId, PendingEvent>::const_iterator it = events.find(id);
    if (it == events.end() || it->second.retireCycle <= cycle)
      continue;
    if (kind == InstructionWaitCounterKind::Lgkm && limit != 0 &&
        it->second.eventClass == InstructionEventClass::Smem)
      return failure();
    pending.push_back(&it->second);
  }

  if (pending.size() <= limit)
    return cycle;
  llvm::sort(pending, [](const PendingEvent *lhs, const PendingEvent *rhs) {
    if (lhs->retireCycle != rhs->retireCycle)
      return lhs->retireCycle < rhs->retireCycle;
    return lhs->id < rhs->id;
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
  return static_cast<int64_t>(desc.issueCount) * getIssuePeriod();
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
         (static_cast<int64_t>(desc.issueCount) - 1) * getIssuePeriod() +
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
  for (unsigned issue : llvm::seq<unsigned>(0, desc.issueCount)) {
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
    for (unsigned issue : llvm::seq<unsigned>(0, desc.issueCount)) {
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
      if (desc.trans)
        hazards.transWriteVGPRReadyAt =
            currentIssueSlot + issueSlotHazardConfig.transWriteVGPRValuRead;
    }
    if (regClass == RegClass::VCC)
      issueSlotHazards[result].valuWriteVCCReadyAt =
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
