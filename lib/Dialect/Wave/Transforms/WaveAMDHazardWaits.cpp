//===- WaveAMDHazardWaits.cpp - WaveAMD hazard waits ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Driver runs after regalloc. Dense forward dataflow tracks LGKM
// pending counts and SSA-value hazards through CFG and region edges.
// Regalloc can insert VALU copies, so production pipelines run this
// pass after allocation.
//
// Design notes: `docs/HazardMitigationDesign.md`.

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "WaveAMDHardwareResources.h"
#include "mlir/Analysis/DataFlow/DenseAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInstrInfo.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Dominance.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Support/Timing.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/MathExtras.h"

#include <array>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDHAZARDREPAIR
#define GEN_PASS_DEF_WAVEAMDHAZARDWAITS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::dataflow;
using mlir::waveamdmachine::getWaitcntInfo;
using mlir::waveamdmachine::isWaveAMDMachineOp;

namespace {

struct HazardRepairStageTimingManager {
  HazardRepairStageTimingManager() {
    applyDefaultTimingManagerCLOptions(manager);
  }

  DefaultTimingManager manager;
};

static DefaultTimingManager &getHazardRepairStageTimingManager() {
  static HazardRepairStageTimingManager timing;
  return timing.manager;
}

struct HazardRepairStageTiming {
  HazardRepairStageTiming() {
    rootScope = getHazardRepairStageTimingManager().getRootScope();
    stageScope = rootScope.nest("wave_hazard_repair_stages");
  }

  TimingScope nest(StringRef name) { return stageScope.nest(name); }

  TimingScope rootScope;
  TimingScope stageScope;
};

namespace amdgpu_compat {
namespace SNop {

inline unsigned getBitWidth(const llvm::MCSubtargetInfo &STI) {
  llvm::AMDGPU::IsaVersion Version = llvm::AMDGPU::getIsaVersion(STI.getCPU());
  if (Version.Major >= 12)
    return 7;
  if (Version.Major >= 8)
    return 4;
  return 3;
}

inline unsigned getMaxCount(const llvm::MCSubtargetInfo &STI) {
  return 1u << getBitWidth(STI);
}

inline unsigned encodeCount(unsigned Count) {
  assert(Count > 0 && "S_NOP count must be non-zero");
  return Count - 1;
}

} // namespace SNop
} // namespace amdgpu_compat

static Value createImm(OpBuilder &builder, Location loc, int64_t value) {
  return waveamdmachine::ImmOp::create(
      builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
      static_cast<uint64_t>(value));
}

static void insertNoops(OpBuilder &builder, Location loc, unsigned count,
                        const llvm::MCSubtargetInfo &sti) {
  unsigned maxCount = amdgpu_compat::SNop::getMaxCount(sti);
  while (count > 0) {
    unsigned chunk = std::min(count, maxCount);
    count -= chunk;
    waveamdmachine::SNopOp::create(
        builder, loc,
        createImm(builder, loc, amdgpu_compat::SNop::encodeCount(chunk)));
  }
}

static FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>>
createSubtargetInfo(Operation *op,
                    StringRef passName = "waveamd-insert-hazard-waits") {
  return waveamdmachine::createAMDGPUMCSubtargetInfo(op, passName);
}

static bool isVMEMStore(Operation &op) {
  return op.hasTrait<OpTrait::waveamdmachine::VMEMStoreOp>();
}

static bool emitsNoMachineInst(Operation &op) {
  return op.hasTrait<OpTrait::waveamdmachine::NoMachineInst>();
}

static bool isCDNA3Family(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 && isa.Minor == 4;
}

static bool isCDNA4Family(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 && isa.Minor == 5;
}

static unsigned getValuWriteSGPRVmemReadLatency() { return 5; }

static unsigned
getValuWriteExecConsumerLatency(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 ? 4 : 0;
}

struct HazardConfig {
  const waveamdmachine::ArchData *arch;
  llvm::AMDGPU::IsaVersion isaVersion;
  unsigned defaultLgkmcnt;
  unsigned valuDep1;

  // Wait states between `s_mov_m0` and the next op reading `m0`.
  // One pipeline slot on every AMDGPU ISA that exposes M0; see
  // GCNHazardRecognizer.cpp's setreg / m0-write hazard checks.
  unsigned m0PipelineDelay;

  // LDS DMA must capture M0 before the next scalar M0 write on CDNA4.
  unsigned m0DmaCaptureDelay;

  unsigned valuWriteVGPRMfmaLatency;
  unsigned valuWriteVGPRReadlaneLatency;
  unsigned valuWriteVGPRPermlane32SwapLatency;
  unsigned valuWriteSGPRValuReadLatency;
  unsigned valuWriteSGPRVmemReadLatency;
  unsigned valuWriteExecConsumerLatency;
  unsigned transForwardingWaitStates;
  bool hasDelayAlu;
  bool lgkmWaitNeedsValuGap;
  bool hasTransForwardingHazard;
  bool hasTransCoexecutionHazard;
  bool hasWmmaCoexecutionHazard;
  bool hasScratchBaseForwardingHazard;
  bool legacyWaitCounters;
};

static HazardConfig makeHazardConfig(const llvm::MCSubtargetInfo &sti) {
  llvm::AMDGPU::IsaVersion isaVersion =
      llvm::AMDGPU::getIsaVersion(sti.getCPU());
  const waveamdmachine::ArchData *arch =
      waveamdmachine::isArchSupported(isaVersion)
          ? &waveamdmachine::getArchData(isaVersion)
          : nullptr;
  bool legacyWaitCounters = !llvm::AMDGPU::isGFX12Plus(sti);
  waveamdmachine::InstructionIssueSlotHazardConfig issueHazards =
      waveamdmachine::getInstructionIssueSlotHazardConfig(isaVersion);
  return HazardConfig{
      /*arch=*/arch,
      /*isaVersion=*/isaVersion,
      /*defaultLgkmcnt=*/
      legacyWaitCounters
          ? llvm::AMDGPU::decodeLgkmcnt(
                isaVersion, llvm::AMDGPU::getWaitcntBitMask(isaVersion))
          : 0,
      /*valuDep1=*/
      waveamdmachine::encodeSDelayAluVALU(1),
      /*m0PipelineDelay=*/1,
      /*m0DmaCaptureDelay=*/isCDNA4Family(isaVersion) ? 1u : 0u,
      /*valuWriteVGPRMfmaLatency=*/
      waveamdmachine::getValuWriteVGPRMfmaHazardLatency(),
      /*valuWriteVGPRReadlaneLatency=*/
      issueHazards.valuWriteVGPRScalarRead,
      /*valuWriteVGPRPermlane32SwapLatency=*/
      issueHazards.valuWriteVGPRPermlane32Swap,
      /*valuWriteSGPRValuReadLatency=*/
      issueHazards.valuWriteSGPRValuRead,
      /*valuWriteSGPRVmemReadLatency=*/getValuWriteSGPRVmemReadLatency(),
      /*valuWriteExecConsumerLatency=*/
      getValuWriteExecConsumerLatency(isaVersion),
      /*transForwardingWaitStates=*/issueHazards.transWriteVGPRValuRead,
      /*hasDelayAlu=*/llvm::AMDGPU::isGFX11Plus(sti),
      /*lgkmWaitNeedsValuGap=*/
      legacyWaitCounters && !isCDNA4Family(isaVersion),
      /*hasTransForwardingHazard=*/
      isCDNA3Family(isaVersion) || isCDNA4Family(isaVersion),
      /*hasTransCoexecutionHazard=*/
      arch && arch->hasTransCoexecutionHazard,
      /*hasWmmaCoexecutionHazard=*/arch && arch->hasWmmaCoexecutionHazard,
      /*hasScratchBaseForwardingHazard=*/
      arch && arch->hasScratchBaseForwardingHazard,
      /*legacyWaitCounters=*/legacyWaitCounters,
  };
}

// Insert `count` `s_nop`s right before `op`.
static void insertSNopMitigation(Operation &op, unsigned count, OpBuilder &b,
                                 const llvm::MCSubtargetInfo &sti) {
  b.setInsertionPoint(&op);
  insertNoops(b, op.getLoc(), count, sti);
}

static void insertVNopMitigation(Operation &op, unsigned count, OpBuilder &b) {
  b.setInsertionPoint(&op);
  while (count--)
    waveamdmachine::VNopOp::create(b, op.getLoc());
}

static void insertScratchBaseWait(Operation &op, OpBuilder &b) {
  b.setInsertionPoint(&op);
  waveamdmachine::SWaitAluOp::create(b, op.getLoc(), /*va_vdst=*/IntegerAttr(),
                                     /*vm_vsrc=*/IntegerAttr(),
                                     /*sa_sdst=*/b.getI32IntegerAttr(0),
                                     /*va_sdst=*/b.getI32IntegerAttr(0));
}

// Emit the VALU-after-LGKM mitigation right before `op`: `s_delay_alu`
// on gfx11+, plain `s_nop 0` otherwise.
static void insertValuMitigation(Operation &op, OpBuilder &b,
                                 const HazardConfig &cfg,
                                 const llvm::MCSubtargetInfo &sti) {
  b.setInsertionPoint(&op);
  if (cfg.hasDelayAlu) {
    waveamdmachine::SDelayAluOp::create(
        b, op.getLoc(), createImm(b, op.getLoc(), cfg.valuDep1));
    return;
  }
  insertNoops(b, op.getLoc(), /*count=*/1, sti);
}

static std::optional<unsigned> getLgkmWaitLimit(Operation &op) {
  auto wait = dyn_cast<waveamdmachine::SWaitcntOp>(op);
  if (!wait)
    return std::nullopt;
  std::optional<uint32_t> lg = wait.getLgkmcnt();
  if (!lg)
    return std::nullopt;
  return *lg;
}

static bool isControlFlowOp(Operation *op) {
  return isa<BranchOpInterface, RegionBranchOpInterface,
             RegionBranchTerminatorOpInterface>(op);
}

struct ValueHazards {
  unsigned m0 = 0;
  unsigned mfmaStore = 0;
  unsigned permlane32Swap = 0;

  bool empty() const {
    return m0 == 0 && mfmaStore == 0 && permlane32Swap == 0;
  }

  bool operator==(const ValueHazards &rhs) const {
    return m0 == rhs.m0 && mfmaStore == rhs.mfmaStore &&
           permlane32Swap == rhs.permlane32Swap;
  }

  bool operator!=(const ValueHazards &rhs) const { return !(*this == rhs); }

  bool joinWith(ValueHazards rhs) {
    unsigned nextM0 = std::max(m0, rhs.m0);
    unsigned nextMfmaStore = std::max(mfmaStore, rhs.mfmaStore);
    unsigned nextPermlane32Swap = std::max(permlane32Swap, rhs.permlane32Swap);
    bool changed = nextM0 != m0 || nextMfmaStore != mfmaStore ||
                   nextPermlane32Swap != permlane32Swap;
    m0 = nextM0;
    mfmaStore = nextMfmaStore;
    permlane32Swap = nextPermlane32Swap;
    return changed;
  }

  void advance(unsigned count) {
    m0 = m0 > count ? m0 - count : 0;
    mfmaStore = mfmaStore > count ? mfmaStore - count : 0;
    permlane32Swap = permlane32Swap > count ? permlane32Swap - count : 0;
  }
};

struct RegSpan {
  waveamdmachine::RegClass regClass;
  int64_t begin = 0;
  int64_t end = 0;

  bool operator==(const RegSpan &rhs) const {
    return regClass == rhs.regClass && begin == rhs.begin && end == rhs.end;
  }
};

enum class PhysicalHazardKind : uint8_t {
  MfmaWrite,
  MfmaSrcCRead,
  TransWriteVGPR,
  ValuWriteVGPR,
  ValuWriteSGPR,
  StoreWriteData,
};

struct PhysicalHazard {
  RegSpan span;
  PhysicalHazardKind kind;
  unsigned limit = 0;
  unsigned remaining = 0;
  unsigned mfmaPasses = 0;

  bool operator==(const PhysicalHazard &rhs) const {
    return span == rhs.span && kind == rhs.kind && limit == rhs.limit &&
           remaining == rhs.remaining && mfmaPasses == rhs.mfmaPasses;
  }
};

enum class CoexecHazardKind : uint8_t {
  TransDef,
  TransUse,
  WmmaDef,
  WmmaUse,
};

struct CoexecHazard {
  RegSpan span;
  CoexecHazardKind kind;
  unsigned wmmaRemaining = 0;
  unsigned valuRemaining = 0;

  bool operator==(const CoexecHazard &rhs) const {
    return span == rhs.span && kind == rhs.kind &&
           wmmaRemaining == rhs.wmmaRemaining &&
           valuRemaining == rhs.valuRemaining;
  }
};

struct HazardState {
  unsigned lgkmToValu = 0;
  unsigned lgkmPending = 0;
  unsigned m0DmaCapture = 0;
  DenseMap<Value, ValueHazards> values;
  SmallVector<PhysicalHazard, 16> physical;
  SmallVector<CoexecHazard, 16> coexec;
  std::array<unsigned, 2> scratchBase = {};
  unsigned valuWriteVcc = 0;
  unsigned execWriteHazard = 0;

  bool hasSamePhysicalHazards(const HazardState &rhs) const {
    return physical.size() == rhs.physical.size() &&
           llvm::all_of(physical, [&](const PhysicalHazard &hazard) {
             return llvm::is_contained(rhs.physical, hazard);
           });
  }

  bool hasSameCoexecHazards(const HazardState &rhs) const {
    return coexec.size() == rhs.coexec.size() &&
           llvm::all_of(coexec, [&](const CoexecHazard &hazard) {
             return llvm::is_contained(rhs.coexec, hazard);
           });
  }

  bool operator==(const HazardState &rhs) const {
    return lgkmToValu == rhs.lgkmToValu && lgkmPending == rhs.lgkmPending &&
           m0DmaCapture == rhs.m0DmaCapture && values == rhs.values &&
           hasSamePhysicalHazards(rhs) && hasSameCoexecHazards(rhs) &&
           scratchBase == rhs.scratchBase && valuWriteVcc == rhs.valuWriteVcc &&
           execWriteHazard == rhs.execWriteHazard;
  }

  static bool joinMax(unsigned &lhs, unsigned rhs) {
    unsigned next = std::max(lhs, rhs);
    bool changed = next != lhs;
    lhs = next;
    return changed;
  }

  bool joinPhysicalHazard(const PhysicalHazard &hazard) {
    for (PhysicalHazard &existing : physical) {
      if (!(existing.span == hazard.span) || existing.kind != hazard.kind)
        continue;
      bool changed = joinMax(existing.limit, hazard.limit);
      changed |= joinMax(existing.remaining, hazard.remaining);
      changed |= joinMax(existing.mfmaPasses, hazard.mfmaPasses);
      return changed;
    }
    physical.push_back(hazard);
    return true;
  }

  bool joinCoexecHazard(const CoexecHazard &hazard) {
    for (CoexecHazard &existing : coexec) {
      if (!(existing.span == hazard.span) || existing.kind != hazard.kind)
        continue;
      bool changed = joinMax(existing.wmmaRemaining, hazard.wmmaRemaining);
      changed |= joinMax(existing.valuRemaining, hazard.valuRemaining);
      return changed;
    }
    coexec.push_back(hazard);
    return true;
  }

  bool joinWith(const HazardState &rhs) {
    bool changed = false;
    changed |= joinMax(lgkmToValu, rhs.lgkmToValu);
    changed |= joinMax(lgkmPending, rhs.lgkmPending);
    changed |= joinMax(m0DmaCapture, rhs.m0DmaCapture);
    for (auto [value, hazards] : rhs.values) {
      if (hazards.empty())
        continue;
      changed |= values[value].joinWith(hazards);
    }
    for (const PhysicalHazard &hazard : rhs.physical)
      changed |= joinPhysicalHazard(hazard);
    for (const CoexecHazard &hazard : rhs.coexec)
      changed |= joinCoexecHazard(hazard);
    for (auto [lhs, incoming] : llvm::zip(scratchBase, rhs.scratchBase))
      changed |= joinMax(lhs, incoming);
    changed |= joinMax(valuWriteVcc, rhs.valuWriteVcc);
    changed |= joinMax(execWriteHazard, rhs.execWriteHazard);
    return changed;
  }
};

class HazardLattice : public AbstractDenseLattice {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(HazardLattice)

  using AbstractDenseLattice::AbstractDenseLattice;

  const HazardState &get() const { return state; }

  ChangeResult joinWith(const HazardState &incoming) {
    return state.joinWith(incoming) ? ChangeResult::Change
                                    : ChangeResult::NoChange;
  }

  ChangeResult join(const AbstractDenseLattice &rhs) override {
    return joinWith(static_cast<const HazardLattice &>(rhs).state);
  }

  ChangeResult reset() {
    bool changed = state.lgkmToValu || state.lgkmPending ||
                   state.m0DmaCapture || !state.values.empty() ||
                   !state.physical.empty() || !state.coexec.empty() ||
                   llvm::any_of(state.scratchBase,
                                [](unsigned value) { return value != 0; }) ||
                   state.valuWriteVcc || state.execWriteHazard;
    state = HazardState();
    return changed ? ChangeResult::Change : ChangeResult::NoChange;
  }

  void print(raw_ostream &os) const override {
    os << "lgkm=" << state.lgkmToValu << " pending=" << state.lgkmPending
       << " m0-dma=" << state.m0DmaCapture << " values=" << state.values.size()
       << " physical=" << state.physical.size()
       << " coexec=" << state.coexec.size() << " vcc=" << state.valuWriteVcc
       << " exec=" << state.execWriteHazard;
  }

private:
  HazardState state;
};

static void mergeValueHazards(HazardState &state, Value value,
                              ValueHazards hazards) {
  if (hazards.empty())
    return;
  state.values[value].joinWith(hazards);
}

static ValueHazards lookupValueHazards(const HazardState &state, Value value) {
  auto it = state.values.find(value);
  return it == state.values.end() ? ValueHazards() : it->second;
}

static void advanceValueHazards(HazardState &state, unsigned count = 1) {
  if (count == 0)
    return;
  SmallVector<Value> expired;
  for (auto &entry : state.values) {
    entry.second.advance(count);
    if (entry.second.empty())
      expired.push_back(entry.first);
  }
  for (Value value : expired)
    state.values.erase(value);
}

static std::optional<RegSpan> getAllocatedRegSpan(Value value) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || type.getIndex() < 0)
    return std::nullopt;
  return RegSpan{type.getRegClass(), type.getIndex(),
                 type.getIndex() + type.getWidth()};
}

static RegSpan toRegSpan(const waveamdmachine::PhysicalRegisterSpan &span) {
  return RegSpan{span.regClass, span.begin, span.end};
}

static bool overlaps(RegSpan lhs, RegSpan rhs) {
  return lhs.regClass == rhs.regClass && lhs.begin < rhs.end &&
         rhs.begin < lhs.end;
}

static bool isVGPRSpan(RegSpan span) {
  return span.regClass == waveamdmachine::RegClass::VGPR;
}

static bool isSGPRSpan(RegSpan span) {
  return span.regClass == waveamdmachine::RegClass::SGPR;
}

static bool hasSGPRDef(Operation *op) {
  if (llvm::any_of(op->getResults(), [](Value result) {
        std::optional<RegSpan> span = getAllocatedRegSpan(result);
        return span && isSGPRSpan(*span);
      }))
    return true;
  waveamdmachine::FixedPhysicalRegisterDefsOpInterface fixedDefs =
      dyn_cast<waveamdmachine::FixedPhysicalRegisterDefsOpInterface>(op);
  if (!fixedDefs)
    return false;
  return llvm::any_of(fixedDefs.getFixedPhysicalRegisterDefs(),
                      [](const waveamdmachine::PhysicalRegisterSpan &span) {
                        return span.regClass == waveamdmachine::RegClass::SGPR;
                      });
}

static void mergePhysicalHazard(HazardState &state, PhysicalHazard hazard) {
  if (hazard.remaining == 0)
    return;
  for (PhysicalHazard &existing : state.physical) {
    if (!(existing.span == hazard.span) || existing.kind != hazard.kind)
      continue;
    existing.limit = std::max(existing.limit, hazard.limit);
    existing.remaining = std::max(existing.remaining, hazard.remaining);
    existing.mfmaPasses = std::max(existing.mfmaPasses, hazard.mfmaPasses);
    return;
  }
  state.physical.push_back(hazard);
}

static void mergeCoexecHazard(HazardState &state, CoexecHazard hazard) {
  if (hazard.wmmaRemaining == 0 && hazard.valuRemaining == 0)
    return;
  for (CoexecHazard &existing : state.coexec) {
    if (!(existing.span == hazard.span) || existing.kind != hazard.kind)
      continue;
    existing.wmmaRemaining =
        std::max(existing.wmmaRemaining, hazard.wmmaRemaining);
    existing.valuRemaining =
        std::max(existing.valuRemaining, hazard.valuRemaining);
    return;
  }
  state.coexec.push_back(hazard);
}

static void advancePhysicalHazards(HazardState &state, unsigned count = 1) {
  if (count == 0)
    return;
  SmallVector<PhysicalHazard, 16> kept;
  kept.reserve(state.physical.size());
  for (PhysicalHazard hazard : state.physical) {
    hazard.remaining = hazard.remaining > count ? hazard.remaining - count : 0;
    if (hazard.remaining)
      kept.push_back(hazard);
  }
  state.physical = std::move(kept);
  state.valuWriteVcc =
      state.valuWriteVcc > count ? state.valuWriteVcc - count : 0;
  state.execWriteHazard =
      state.execWriteHazard > count ? state.execWriteHazard - count : 0;
}

static void advanceCoexecHazards(HazardState &state, unsigned count = 1) {
  if (count == 0)
    return;
  SmallVector<CoexecHazard, 16> kept;
  kept.reserve(state.coexec.size());
  for (CoexecHazard hazard : state.coexec) {
    hazard.wmmaRemaining =
        hazard.wmmaRemaining > count ? hazard.wmmaRemaining - count : 0;
    hazard.valuRemaining =
        hazard.valuRemaining > count ? hazard.valuRemaining - count : 0;
    if (hazard.wmmaRemaining || hazard.valuRemaining)
      kept.push_back(hazard);
  }
  state.coexec = std::move(kept);
}

static void advanceScratchBaseHazards(HazardState &state, unsigned count = 1) {
  for (unsigned &remaining : state.scratchBase)
    remaining = remaining > count ? remaining - count : 0;
}

static void advanceHazards(HazardState &state, unsigned count = 1,
                           bool advanceLgkm = true) {
  if (advanceLgkm)
    state.lgkmToValu = state.lgkmToValu > count ? state.lgkmToValu - count : 0;
  state.m0DmaCapture =
      state.m0DmaCapture > count ? state.m0DmaCapture - count : 0;
  advanceValueHazards(state, count);
  advancePhysicalHazards(state, count);
}

static unsigned waitForHazardAge(const PhysicalHazard &hazard,
                                 unsigned required) {
  assert(hazard.limit >= hazard.remaining && "malformed hazard age");
  unsigned elapsed = hazard.limit - hazard.remaining;
  return required > elapsed ? required - elapsed : 0;
}

static void propagateValueHazards(ArrayRef<Value> sources, ValueRange targets,
                                  HazardState &state) {
  for (auto [source, target] : llvm::zip(sources, targets))
    mergeValueHazards(state, target, lookupValueHazards(state, source));
}

static void collectValues(OperandRange values, SmallVectorImpl<Value> &out) {
  llvm::append_range(out, values);
}

static void collectValues(SuccessorOperands values,
                          SmallVectorImpl<Value> &out) {
  for (unsigned i = 0, e = values.size(); i < e; ++i)
    if (Value value = values[i])
      out.push_back(value);
}

static void propagateBranchOperands(Operation *terminator, Block *successor,
                                    HazardState &state) {
  auto branch = dyn_cast<BranchOpInterface>(terminator);
  if (!branch)
    return;
  for (auto [idx, target] : llvm::enumerate(terminator->getSuccessors())) {
    if (target != successor)
      continue;
    SmallVector<Value> sources;
    collectValues(branch.getSuccessorOperands(idx), sources);
    propagateValueHazards(sources, successor->getArguments(), state);
  }
}

static void propagateRegionOperands(RegionBranchOpInterface branch,
                                    std::optional<unsigned> regionFrom,
                                    std::optional<unsigned> regionTo,
                                    HazardState &state) {
  RegionSuccessor successor =
      regionTo ? RegionSuccessor(&branch->getRegion(*regionTo))
               : RegionSuccessor(branch.getOperation());

  SmallVector<Value> sources;
  if (regionFrom) {
    Operation *term = branch->getRegion(*regionFrom).front().getTerminator();
    if (auto regionTerm = dyn_cast<RegionBranchTerminatorOpInterface>(term))
      collectValues(regionTerm.getSuccessorOperands(successor), sources);
  } else {
    collectValues(branch.getEntrySuccessorOperands(successor), sources);
  }
  propagateValueHazards(sources, branch.getSuccessorInputs(successor), state);
}

static void inheritNoInstOperandHazards(Operation *op, HazardState &state) {
  if (!emitsNoMachineInst(*op) || op->getNumResults() == 0)
    return;
  ValueHazards joined;
  for (Value operand : op->getOperands())
    joined.joinWith(lookupValueHazards(state, operand));
  for (Value result : op->getResults())
    mergeValueHazards(state, result, joined);
}

static bool isMFMA(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::MFMAOp>();
}

static bool isXdlWmma(Operation *op, const HazardConfig &cfg) {
  if (!cfg.arch || !op->hasTrait<OpTrait::waveamdmachine::WMMAOp>())
    return false;
  waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
  return waveamdmachine::isSchedClassSupported(*cfg.arch, cls) &&
         waveamdmachine::funit(*cfg.arch, cls) ==
             waveamdmachine::FunctionalUnit::MFMA_XDL;
}

static bool isPermlane32Swap(Operation *op) {
  return isa<waveamdmachine::VPermlane32SwapB32TupleOp>(op);
}

static bool isExecWriteHazardConsumer(Operation *op) {
  return isMFMA(op) || isPermlane32Swap(op);
}

static unsigned getMfmaPassCount(Operation *op) {
  switch (waveamdmachine::classifyOp(op)) {
  case waveamdmachine::SchedClass::Write2PassMAI:
    return 2;
  case waveamdmachine::SchedClass::Write4PassMAI:
    return 4;
  case waveamdmachine::SchedClass::Write8PassMAI:
    return 8;
  case waveamdmachine::SchedClass::Write16PassMAI:
    return 16;
  default:
    op->emitError("MFMA op lacks MAI schedule class");
    llvm::report_fatal_error("MFMA op lacks MAI schedule class");
  }
}

static unsigned getHazardMfmaPassCount(const PhysicalHazard &hazard) {
  assert(hazard.mfmaPasses && "MFMA hazard must carry pass count");
  return hazard.mfmaPasses;
}

static unsigned getXdlResultLatency(unsigned passes, const HazardConfig &cfg) {
  return waveamdmachine::getXdlResultHazardLatency(cfg.isaVersion, passes);
}

static unsigned getXdlSrcCOverlapLatency(unsigned passes,
                                         const HazardConfig &cfg) {
  return waveamdmachine::getXdlSrcCOverlapHazardLatency(cfg.isaVersion, passes);
}

static unsigned getXdlSrcCExactLatency(unsigned passes,
                                       const HazardConfig &cfg) {
  return waveamdmachine::getXdlSrcCExactHazardLatency(cfg.isaVersion, passes);
}

static unsigned getXdlSrcCReadWarLatency(unsigned passes,
                                         const HazardConfig &cfg) {
  if (!isCDNA3Family(cfg.isaVersion) && !isCDNA4Family(cfg.isaVersion))
    return 0;
  return passes == 2 ? 1 : passes - 1;
}

static bool isLegacyVALU(Operation *op, const HazardConfig &cfg) {
  return op->hasTrait<OpTrait::waveamdmachine::VALUOp>() && !isMFMA(op) &&
         !isXdlWmma(op, cfg);
}

static bool isTransOp(Operation *op, const HazardConfig &cfg) {
  if (!isLegacyVALU(op, cfg))
    return false;
  return waveamdmachine::classifyOp(op) ==
         waveamdmachine::SchedClass::WriteTrans32;
}

static bool isVALUForCoexecution(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::VALUOp>() ||
         op->hasTrait<OpTrait::waveamdmachine::LDSDmaOp>();
}

static bool isCoexecutableVALU(Operation *op, const HazardConfig &cfg) {
  return isVALUForCoexecution(op) && !isTransOp(op, cfg) &&
         !op->hasTrait<OpTrait::waveamdmachine::WMMAOp>() &&
         !op->hasTrait<OpTrait::waveamdmachine::LDSDmaOp>();
}

static bool isVMEM(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::VMEMLoadOp>() ||
         op->hasTrait<OpTrait::waveamdmachine::VMEMStoreOp>();
}

struct HazardOpInfo {
  std::optional<waveamdmachine::StoreWriteDataHazard> storeWriteData;
  std::optional<unsigned> lgkmWaitLimit;
  waveamdmachine::WaitcntInfo waitcnt;
  waveamdmachine::SchedClass schedClass =
      waveamdmachine::SchedClass::NumSchedClasses;
  unsigned instructionIssueCount = 1;
  unsigned mfmaPasses = 0;
  bool noMachineInst = false;
  bool controlFlow = false;
  bool mfma = false;
  bool legacyValu = false;
  bool trans = false;
  bool xdlWmma = false;
  bool valuForCoexec = false;
  bool coexecValu = false;
  bool sgprWrite = false;
  bool scratchMemory = false;
  bool vmem = false;
  bool vmemStore = false;
  bool execWriteConsumer = false;
  bool valu = false;
  bool writesExec = false;
  bool xdlResultConsumer = false;
  bool readFirstLane = false;
  bool permlane32Swap = false;
  bool copiedVccCompare = false;
  bool ldsDmaIssue = false;
};

using HazardOpInfoMap = DenseMap<Operation *, HazardOpInfo>;

static const HazardOpInfo *lookupHazardOpInfo(Operation *op,
                                              const HazardOpInfoMap *infos) {
  if (!infos)
    return nullptr;
  auto it = infos->find(op);
  assert(it != infos->end() && "missing hazard operation info");
  return &it->second;
}

static bool isLdsDmaIssue(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::LDSDmaOp>();
}

static bool isCachedLegacyVALU(Operation *op, const HazardConfig &cfg,
                               const HazardOpInfo *info) {
  return info ? info->legacyValu : isLegacyVALU(op, cfg);
}

static bool isCachedVALU(Operation *op, const HazardOpInfo *info) {
  return info ? info->valu : op->hasTrait<OpTrait::waveamdmachine::VALUOp>();
}

static bool isCachedXdlResultConsumer(Operation *op, const HazardOpInfo *info) {
  return info ? info->xdlResultConsumer
              : waveamdmachine::isXdlResultHazardConsumer(op);
}

static bool isCachedReadFirstLane(Operation *op, const HazardOpInfo *info) {
  return info ? info->readFirstLane
              : isa<waveamdmachine::VReadfirstlaneB32Op>(op);
}

static bool isCachedPermlane32Swap(Operation *op, const HazardOpInfo *info) {
  return info ? info->permlane32Swap : isPermlane32Swap(op);
}

static unsigned getVGPRWriteHazardLimit(const HazardConfig &cfg) {
  return std::max({cfg.valuWriteVGPRMfmaLatency,
                   cfg.valuWriteVGPRReadlaneLatency,
                   cfg.valuWriteVGPRPermlane32SwapLatency});
}

static unsigned getSGPRWriteHazardLimit(const HazardConfig &cfg) {
  return std::max(cfg.valuWriteSGPRValuReadLatency,
                  cfg.valuWriteSGPRVmemReadLatency);
}

static unsigned getMfmaUseWait(unsigned operandIndex, RegSpan use,
                               const PhysicalHazard &hazard,
                               const HazardConfig &cfg) {
  if (hazard.kind == PhysicalHazardKind::ValuWriteVGPR)
    return waitForHazardAge(hazard, cfg.valuWriteVGPRMfmaLatency);
  if (hazard.kind != PhysicalHazardKind::MfmaWrite)
    return 0;
  unsigned passes = getHazardMfmaPassCount(hazard);
  if (operandIndex != 2)
    return waitForHazardAge(hazard, getXdlResultLatency(passes, cfg));
  if (use == hazard.span)
    return waitForHazardAge(hazard, getXdlSrcCExactLatency(passes, cfg));
  return waitForHazardAge(hazard, getXdlSrcCOverlapLatency(passes, cfg));
}

static unsigned getTransForwardingUseWait(Operation *op, RegSpan use,
                                          const PhysicalHazard &hazard,
                                          const HazardConfig &cfg,
                                          const HazardOpInfo *info) {
  if (hazard.kind != PhysicalHazardKind::TransWriteVGPR)
    return 0;
  bool legacyValu = isCachedLegacyVALU(op, cfg, info);
  bool trans = info ? info->trans : isTransOp(op, cfg);
  if (!isVGPRSpan(use) || !legacyValu || trans)
    return 0;
  return waitForHazardAge(hazard, cfg.transForwardingWaitStates);
}

static unsigned getValuWriteSGPRUseWait(Operation *op, RegSpan use,
                                        const PhysicalHazard &hazard,
                                        const HazardConfig &cfg,
                                        const HazardOpInfo *info) {
  if (hazard.kind != PhysicalHazardKind::ValuWriteSGPR || !isSGPRSpan(use))
    return 0;
  if (info ? info->vmem : isVMEM(op))
    return waitForHazardAge(hazard, cfg.valuWriteSGPRVmemReadLatency);
  if (isCachedLegacyVALU(op, cfg, info))
    return waitForHazardAge(hazard, cfg.valuWriteSGPRValuReadLatency);
  return 0;
}

static unsigned getNonMfmaUseWait(Operation *op, RegSpan use,
                                  const PhysicalHazard &hazard,
                                  const HazardConfig &cfg,
                                  const HazardOpInfo *info) {
  if (hazard.kind == PhysicalHazardKind::MfmaWrite &&
      isCachedXdlResultConsumer(op, info))
    return waitForHazardAge(
        hazard, getXdlResultLatency(getHazardMfmaPassCount(hazard), cfg));

  if (hazard.kind == PhysicalHazardKind::ValuWriteVGPR &&
      isCachedReadFirstLane(op, info))
    return waitForHazardAge(hazard, cfg.valuWriteVGPRReadlaneLatency);

  if (hazard.kind == PhysicalHazardKind::ValuWriteVGPR &&
      isCachedPermlane32Swap(op, info))
    return waitForHazardAge(hazard, cfg.valuWriteVGPRPermlane32SwapLatency);

  if (unsigned wait = getTransForwardingUseWait(op, use, hazard, cfg, info))
    return wait;

  return getValuWriteSGPRUseWait(op, use, hazard, cfg, info);
}

static unsigned getPhysicalUseWait(Operation *op, unsigned operandIndex,
                                   RegSpan use, const PhysicalHazard &hazard,
                                   const HazardConfig &cfg,
                                   const HazardOpInfo *info) {
  if (!overlaps(use, hazard.span))
    return 0;
  if (info ? info->mfma : isMFMA(op))
    return getMfmaUseWait(operandIndex, use, hazard, cfg);
  return getNonMfmaUseWait(op, use, hazard, cfg, info);
}

static unsigned getPhysicalDefWait(Operation *op, RegSpan def,
                                   const PhysicalHazard &hazard,
                                   const HazardConfig &cfg,
                                   const HazardOpInfo *info) {
  if (!overlaps(def, hazard.span))
    return 0;

  if (hazard.kind == PhysicalHazardKind::MfmaWrite &&
      isCachedXdlResultConsumer(op, info))
    return waitForHazardAge(
        hazard, getXdlResultLatency(getHazardMfmaPassCount(hazard), cfg));

  if (hazard.kind == PhysicalHazardKind::MfmaSrcCRead &&
      isCachedLegacyVALU(op, cfg, info))
    return waitForHazardAge(
        hazard, getXdlSrcCReadWarLatency(getHazardMfmaPassCount(hazard), cfg));

  if (hazard.kind == PhysicalHazardKind::StoreWriteData &&
      isCachedVALU(op, info) && isVGPRSpan(def))
    return waitForHazardAge(hazard, hazard.limit);

  return 0;
}

static unsigned getOperandPhysicalWait(Operation *op, const HazardState &state,
                                       const HazardConfig &cfg,
                                       const HazardOpInfo *info) {
  unsigned wait = 0;
  for (auto [operandIndex, operand] : llvm::enumerate(op->getOperands())) {
    std::optional<RegSpan> span = getAllocatedRegSpan(operand);
    if (!span)
      continue;
    for (const PhysicalHazard &hazard : state.physical)
      wait = std::max(
          wait, getPhysicalUseWait(op, operandIndex, *span, hazard, cfg, info));
  }
  return wait;
}

static unsigned getResultPhysicalWait(Operation *op, const HazardState &state,
                                      const HazardConfig &cfg,
                                      const HazardOpInfo *info) {
  unsigned wait = 0;
  for (Value result : op->getResults()) {
    std::optional<RegSpan> span = getAllocatedRegSpan(result);
    if (!span)
      continue;
    for (const PhysicalHazard &hazard : state.physical)
      wait = std::max(wait, getPhysicalDefWait(op, *span, hazard, cfg, info));
  }
  return wait;
}

static unsigned getVccReadWait(Operation *op, const HazardState &state,
                               const HazardOpInfo *info) {
  if (!(info ? info->valu : op->hasTrait<OpTrait::waveamdmachine::VALUOp>()))
    return 0;
  for (Value operand : op->getOperands()) {
    auto type = dyn_cast<waveamdmachine::RegType>(operand.getType());
    if (type && type.getRegClass() == waveamdmachine::RegClass::VCC)
      return state.valuWriteVcc;
  }
  return 0;
}

static unsigned getRequiredPhysicalWait(Operation *op, const HazardState &state,
                                        const HazardConfig &cfg,
                                        const HazardOpInfo *info = nullptr) {
  if (info ? info->controlFlow : isControlFlowOp(op))
    return 0;

  unsigned wait = 0;
  if (info ? info->execWriteConsumer : isExecWriteHazardConsumer(op))
    wait = std::max(wait, state.execWriteHazard);
  wait = std::max(wait, getOperandPhysicalWait(op, state, cfg, info));
  wait = std::max(wait, getResultPhysicalWait(op, state, cfg, info));
  return std::max(wait, getVccReadWait(op, state, info));
}

static void addPhysicalHazard(HazardState &state, RegSpan span,
                              PhysicalHazardKind kind, unsigned limit) {
  mergePhysicalHazard(state,
                      PhysicalHazard{/*span=*/span, /*kind=*/kind,
                                     /*limit=*/limit, /*remaining=*/limit});
}

static void addProducedMfmaPhysicalHazards(Operation *op, HazardState &state,
                                           const HazardConfig &cfg,
                                           const HazardOpInfo *info) {
  unsigned passes = info ? info->mfmaPasses : getMfmaPassCount(op);
  unsigned resultLatency = getXdlResultLatency(passes, cfg);
  for (Value result : op->getResults())
    if (std::optional<RegSpan> span = getAllocatedRegSpan(result)) {
      PhysicalHazard hazard{*span, PhysicalHazardKind::MfmaWrite, resultLatency,
                            resultLatency, passes};
      mergePhysicalHazard(state, hazard);
    }
  unsigned srcCReadWarLatency = getXdlSrcCReadWarLatency(passes, cfg);
  if (!srcCReadWarLatency)
    return;
  waveamdmachine::MMAOpInterface mma =
      dyn_cast<waveamdmachine::MMAOpInterface>(op);
  if (!mma)
    return;
  if (std::optional<RegSpan> span = getAllocatedRegSpan(mma.getAcc())) {
    PhysicalHazard hazard{*span, PhysicalHazardKind::MfmaSrcCRead,
                          srcCReadWarLatency, srcCReadWarLatency, passes};
    mergePhysicalHazard(state, hazard);
  }
}

static void addProducedValuRegHazard(Value result, HazardState &state,
                                     const HazardConfig &cfg) {
  auto type = dyn_cast<waveamdmachine::RegType>(result.getType());
  if (!type)
    return;
  if (type.getRegClass() == waveamdmachine::RegClass::VCC) {
    state.valuWriteVcc =
        std::max(state.valuWriteVcc, cfg.valuWriteSGPRValuReadLatency);
    return;
  }
  if (type.getRegClass() == waveamdmachine::RegClass::VGPR)
    mergeValueHazards(
        state, result,
        {/*m0=*/0, /*mfmaStore=*/0,
         /*permlane32Swap=*/cfg.valuWriteVGPRPermlane32SwapLatency});
  std::optional<RegSpan> span = getAllocatedRegSpan(result);
  if (!span)
    return;
  if (isVGPRSpan(*span))
    addPhysicalHazard(state, *span, PhysicalHazardKind::ValuWriteVGPR,
                      getVGPRWriteHazardLimit(cfg));
  if (isSGPRSpan(*span))
    addPhysicalHazard(state, *span, PhysicalHazardKind::ValuWriteSGPR,
                      getSGPRWriteHazardLimit(cfg));
}

static void addProducedTransRegHazard(Value result, HazardState &state,
                                      const HazardConfig &cfg) {
  if (!cfg.hasTransForwardingHazard)
    return;
  std::optional<RegSpan> span = getAllocatedRegSpan(result);
  if (!span || !isVGPRSpan(*span))
    return;
  addPhysicalHazard(state, *span, PhysicalHazardKind::TransWriteVGPR,
                    cfg.transForwardingWaitStates);
}

static bool isCopiedVccCompareSGPRResult(Operation *op, unsigned resultIndex) {
  if (resultIndex != 0)
    return false;
  return isa<waveamdmachine::VCmpEqF32VccOp, waveamdmachine::VCmpLtF32VccOp,
             waveamdmachine::VCmpLeF32VccOp, waveamdmachine::VCmpGtF32VccOp,
             waveamdmachine::VCmpGeF32VccOp, waveamdmachine::VCmpEqU32VccOp,
             waveamdmachine::VCmpNeU32VccOp, waveamdmachine::VCmpLtU32VccOp,
             waveamdmachine::VCmpLeU32VccOp, waveamdmachine::VCmpGtU32VccOp,
             waveamdmachine::VCmpGeU32VccOp, waveamdmachine::VCmpLtI32VccOp,
             waveamdmachine::VCmpLeI32VccOp, waveamdmachine::VCmpGtI32VccOp,
             waveamdmachine::VCmpGeI32VccOp>(op);
}

static HazardOpInfoMap collectHazardOpInfo(Operation *root,
                                           const HazardConfig &cfg) {
  HazardOpInfoMap infos;
  root->walk([&](Operation *op) {
    HazardOpInfo info;
    info.storeWriteData =
        waveamdmachine::getStoreWriteDataHazard(op, cfg.isaVersion);
    info.lgkmWaitLimit = getLgkmWaitLimit(*op);
    info.waitcnt = getWaitcntInfo(op);
    info.noMachineInst = emitsNoMachineInst(*op);
    info.controlFlow = isControlFlowOp(op);
    info.instructionIssueCount =
        waveamdmachine::getInstructionIssueCount(op, cfg.isaVersion);
    info.mfma = isMFMA(op);
    info.mfmaPasses = info.mfma ? getMfmaPassCount(op) : 0;
    info.legacyValu = isLegacyVALU(op, cfg);
    info.trans = isTransOp(op, cfg);
    info.xdlWmma = isXdlWmma(op, cfg);
    if (info.xdlWmma)
      info.schedClass = waveamdmachine::classifyOp(op);
    info.valuForCoexec = isVALUForCoexecution(op);
    info.coexecValu = isCoexecutableVALU(op, cfg);
    info.sgprWrite = (op->hasTrait<OpTrait::waveamdmachine::SALUOp>() ||
                      info.valuForCoexec) &&
                     hasSGPRDef(op);
    info.scratchMemory =
        op->hasTrait<OpTrait::waveamdmachine::ScratchMemoryOp>();
    info.vmem = isVMEM(op);
    info.vmemStore = isVMEMStore(*op);
    info.execWriteConsumer = isExecWriteHazardConsumer(op);
    info.valu = op->hasTrait<OpTrait::waveamdmachine::VALUOp>();
    info.writesExec = op->hasTrait<OpTrait::waveamdmachine::WritesExecOp>();
    info.xdlResultConsumer = waveamdmachine::isXdlResultHazardConsumer(op);
    info.readFirstLane = isa<waveamdmachine::VReadfirstlaneB32Op>(op);
    info.permlane32Swap = isPermlane32Swap(op);
    info.copiedVccCompare = isCopiedVccCompareSGPRResult(op, 0);
    info.ldsDmaIssue = isLdsDmaIssue(op);
    infos.try_emplace(op, info);
  });
  return infos;
}

static void addProducedValuPhysicalHazards(Operation *op, HazardState &state,
                                           const HazardConfig &cfg,
                                           const HazardOpInfo *info) {
  if (info ? info->writesExec
           : op->hasTrait<OpTrait::waveamdmachine::WritesExecOp>())
    state.execWriteHazard =
        std::max(state.execWriteHazard, cfg.valuWriteExecConsumerLatency);
  bool transOp =
      cfg.hasTransForwardingHazard && (info ? info->trans : isTransOp(op, cfg));
  for (auto [resultIndex, result] : llvm::enumerate(op->getResults())) {
    if (resultIndex == 0 &&
        (info ? info->copiedVccCompare
              : isCopiedVccCompareSGPRResult(op, resultIndex)))
      continue;
    if (transOp)
      addProducedTransRegHazard(result, state, cfg);
    addProducedValuRegHazard(result, state, cfg);
  }
}

static void addProducedStorePhysicalHazards(Operation *op, HazardState &state,
                                            const HazardConfig &cfg,
                                            const HazardOpInfo *info) {
  std::optional<waveamdmachine::StoreWriteDataHazard> hazard =
      info ? info->storeWriteData
           : waveamdmachine::getStoreWriteDataHazard(op, cfg.isaVersion);
  if (!hazard)
    return;
  if (std::optional<RegSpan> span = getAllocatedRegSpan(hazard->data))
    addPhysicalHazard(state, *span, PhysicalHazardKind::StoreWriteData,
                      hazard->latency);
}

static void addProducedPhysicalHazards(Operation *op, HazardState &state,
                                       const HazardConfig &cfg,
                                       const HazardOpInfo *info) {
  if (info ? info->mfma : isMFMA(op)) {
    addProducedMfmaPhysicalHazards(op, state, cfg, info);
    return;
  }
  if (info ? info->legacyValu : isLegacyVALU(op, cfg))
    addProducedValuPhysicalHazards(op, state, cfg, info);
  addProducedStorePhysicalHazards(op, state, cfg, info);
}

static void addProducedHazards(Operation *op, HazardState &state,
                               const HazardConfig &cfg,
                               const HazardOpInfo *info) {
  if (info ? info->ldsDmaIssue : isLdsDmaIssue(op))
    state.m0DmaCapture = std::max(state.m0DmaCapture, cfg.m0DmaCaptureDelay);
  if (auto m0Writer = dyn_cast<waveamdmachine::M0WriteHazardOpInterface>(op))
    mergeValueHazards(state, m0Writer.getM0HazardValue(),
                      {/*m0=*/cfg.m0PipelineDelay,
                       /*mfmaStore=*/0,
                       /*permlane32Swap=*/0});
  if (info ? info->mfma : op->hasTrait<OpTrait::waveamdmachine::MFMAOp>()) {
    unsigned passes = info ? info->mfmaPasses : getMfmaPassCount(op);
    unsigned resultLatency = getXdlResultLatency(passes, cfg);
    for (Value result : op->getResults())
      mergeValueHazards(state, result,
                        {/*m0=*/0,
                         /*mfmaStore=*/resultLatency,
                         /*permlane32Swap=*/0});
  }
  addProducedPhysicalHazards(op, state, cfg, info);
}

static waveamdmachine::SchedClass
getCachedSchedClass(Operation *op, const HazardOpInfo *info) {
  return info ? info->schedClass : waveamdmachine::classifyOp(op);
}

static bool isCachedXdlWmma(Operation *op, const HazardConfig &cfg,
                            const HazardOpInfo *info) {
  return info ? info->xdlWmma : isXdlWmma(op, cfg);
}

static bool isCachedVALUForCoexecution(Operation *op,
                                       const HazardOpInfo *info) {
  return info ? info->valuForCoexec : isVALUForCoexecution(op);
}

static bool isCachedCoexecutableVALU(Operation *op, const HazardConfig &cfg,
                                     const HazardOpInfo *info) {
  return info ? info->coexecValu : isCoexecutableVALU(op, cfg);
}

static bool isCachedSGPRWrite(Operation *op, const HazardOpInfo *info) {
  if (info)
    return info->sgprWrite;
  return (op->hasTrait<OpTrait::waveamdmachine::SALUOp>() ||
          isVALUForCoexecution(op)) &&
         hasSGPRDef(op);
}

static bool isCachedScratchMemory(Operation *op, const HazardOpInfo *info) {
  return info ? info->scratchMemory
              : op->hasTrait<OpTrait::waveamdmachine::ScratchMemoryOp>();
}

static unsigned getCachedInstructionIssueCount(Operation *op,
                                               const HazardConfig &cfg,
                                               const HazardOpInfo *info) {
  return info ? info->instructionIssueCount
              : waveamdmachine::getInstructionIssueCount(op, cfg.isaVersion);
}

static unsigned getWmmaVALUWaitSlots(Operation *op, const HazardConfig &cfg,
                                     const HazardOpInfo *info) {
  int latency =
      waveamdmachine::getLatency(*cfg.arch, getCachedSchedClass(op, info));
  // LLVM hazard category 6 maps latency 4 to one coexecution slot.
  if (latency == 4)
    return 1;
  return llvm::divideCeil(static_cast<unsigned>(latency), 2u);
}

static void addCoexecSpan(HazardState &state, Value value,
                          CoexecHazardKind kind, unsigned wmmaRemaining,
                          unsigned valuRemaining) {
  std::optional<RegSpan> span = getAllocatedRegSpan(value);
  if (!span)
    return;
  mergeCoexecHazard(state,
                    CoexecHazard{*span, kind, wmmaRemaining, valuRemaining});
}

static void addProducedCoexecHazards(Operation *op, HazardState &state,
                                     const HazardConfig &cfg,
                                     const HazardOpInfo *info) {
  bool trans = info ? info->trans : isTransOp(op, cfg);
  if (cfg.hasTransCoexecutionHazard && trans) {
    for (Value result : op->getResults())
      addCoexecSpan(state, result, CoexecHazardKind::TransDef,
                    /*wmmaRemaining=*/0, /*valuRemaining=*/1);
    for (Value operand : op->getOperands())
      addCoexecSpan(state, operand, CoexecHazardKind::TransUse,
                    /*wmmaRemaining=*/0, /*valuRemaining=*/1);
  }

  if (!cfg.hasWmmaCoexecutionHazard || !isCachedXdlWmma(op, cfg, info))
    return;
  waveamdmachine::MMAOpInterface mma = cast<waveamdmachine::MMAOpInterface>(op);
  unsigned valuRemaining = getWmmaVALUWaitSlots(op, cfg, info);
  addCoexecSpan(state, mma.getAccResult(), CoexecHazardKind::WmmaDef,
                /*wmmaRemaining=*/valuRemaining + 1, valuRemaining);
  addCoexecSpan(state, mma.getA(), CoexecHazardKind::WmmaUse,
                /*wmmaRemaining=*/0, valuRemaining);
  addCoexecSpan(state, mma.getB(), CoexecHazardKind::WmmaUse,
                /*wmmaRemaining=*/0, valuRemaining);
}

static unsigned getCoexecValueWait(Value value, const HazardState &state,
                                   CoexecHazardKind kind,
                                   unsigned CoexecHazard::*remainingField) {
  std::optional<RegSpan> span = getAllocatedRegSpan(value);
  if (!span)
    return 0;
  unsigned wait = 0;
  for (const CoexecHazard &hazard : state.coexec)
    if (hazard.kind == kind && overlaps(*span, hazard.span))
      wait = std::max(wait, hazard.*remainingField);
  return wait;
}

static unsigned getCoexecValuesWait(ValueRange values, const HazardState &state,
                                    CoexecHazardKind kind,
                                    unsigned CoexecHazard::*remainingField) {
  unsigned wait = 0;
  for (Value value : values)
    wait =
        std::max(wait, getCoexecValueWait(value, state, kind, remainingField));
  return wait;
}

static unsigned getTransCoexecWait(Operation *op, const HazardState &state,
                                   const HazardConfig &cfg,
                                   const HazardOpInfo *info) {
  if (!cfg.hasTransCoexecutionHazard || !isCachedVALUForCoexecution(op, info) ||
      (info ? info->trans : isTransOp(op, cfg)))
    return 0;

  return std::max(
      getCoexecValuesWait(op->getOperands(), state, CoexecHazardKind::TransDef,
                          &CoexecHazard::valuRemaining),
      getCoexecValuesWait(op->getResults(), state, CoexecHazardKind::TransUse,
                          &CoexecHazard::valuRemaining));
}

static unsigned getWmmaCoexecWait(Operation *op, const HazardState &state,
                                  const HazardConfig &cfg,
                                  const HazardOpInfo *info) {
  if (!cfg.hasWmmaCoexecutionHazard)
    return 0;

  unsigned wait = 0;
  if (isCachedXdlWmma(op, cfg, info)) {
    waveamdmachine::MMAOpInterface mma =
        cast<waveamdmachine::MMAOpInterface>(op);
    return std::max(
        getCoexecValueWait(mma.getA(), state, CoexecHazardKind::WmmaDef,
                           &CoexecHazard::wmmaRemaining),
        getCoexecValueWait(mma.getB(), state, CoexecHazardKind::WmmaDef,
                           &CoexecHazard::wmmaRemaining));
  }

  if (!isCachedCoexecutableVALU(op, cfg, info))
    return 0;
  wait =
      getCoexecValuesWait(op->getOperands(), state, CoexecHazardKind::WmmaDef,
                          &CoexecHazard::valuRemaining);
  wait = std::max(wait, getCoexecValuesWait(op->getResults(), state,
                                            CoexecHazardKind::WmmaDef,
                                            &CoexecHazard::valuRemaining));
  wait = std::max(wait, getCoexecValuesWait(op->getResults(), state,
                                            CoexecHazardKind::WmmaUse,
                                            &CoexecHazard::valuRemaining));
  return wait;
}

static unsigned getRequiredCoexecVNops(Operation *op, const HazardState &state,
                                       const HazardConfig &cfg,
                                       const HazardOpInfo *info = nullptr) {
  if (info ? info->controlFlow : isControlFlowOp(op))
    return 0;
  return std::max(getTransCoexecWait(op, state, cfg, info),
                  getWmmaCoexecWait(op, state, cfg, info));
}

static void addProducedScratchBaseHazards(Operation *op, HazardState &state,
                                          const HazardConfig &cfg,
                                          const HazardOpInfo *info) {
  if (!cfg.hasScratchBaseForwardingHazard || !isCachedSGPRWrite(op, info))
    return;
  unsigned limit = waveamdmachine::getScratchBaseForwardingSGPRWriteLimit();
  std::array<waveamdmachine::PhysicalRegisterSpan, 2> bases =
      waveamdmachine::getFlatScratchBaseSGPRSpans();
  auto addSpan = [&](RegSpan span) {
    for (auto [index, base] : llvm::enumerate(bases))
      if (overlaps(span, toRegSpan(base)))
        state.scratchBase[index] = limit;
  };
  for (Value result : op->getResults())
    if (std::optional<RegSpan> span = getAllocatedRegSpan(result))
      addSpan(*span);
  waveamdmachine::FixedPhysicalRegisterDefsOpInterface fixedDefs =
      dyn_cast<waveamdmachine::FixedPhysicalRegisterDefsOpInterface>(op);
  if (!fixedDefs)
    return;
  for (const waveamdmachine::PhysicalRegisterSpan &span :
       fixedDefs.getFixedPhysicalRegisterDefs())
    addSpan(toRegSpan(span));
}

static bool needsScratchBaseWait(Operation *op, const HazardState &state,
                                 const HazardConfig &cfg,
                                 const HazardOpInfo *info = nullptr) {
  return cfg.hasScratchBaseForwardingHazard &&
         isCachedScratchMemory(op, info) &&
         llvm::any_of(state.scratchBase,
                      [](unsigned remaining) { return remaining != 0; });
}

static void applySWaitAlu(Operation *op, HazardState &state) {
  waveamdmachine::SWaitAluOp wait = dyn_cast<waveamdmachine::SWaitAluOp>(op);
  if (!wait)
    return;
  if (wait.getVaVdst() == 0) {
    llvm::erase_if(state.physical, [](const PhysicalHazard &hazard) {
      return hazard.kind == PhysicalHazardKind::TransWriteVGPR ||
             hazard.kind == PhysicalHazardKind::ValuWriteVGPR;
    });
  }
  if (wait.getVaSdst() == 0)
    llvm::erase_if(state.physical, [](const PhysicalHazard &hazard) {
      return hazard.kind == PhysicalHazardKind::ValuWriteSGPR;
    });
  if (wait.getSaSdst() == 0 && wait.getVaSdst() == 0)
    state.scratchBase.fill(0);
}

static unsigned getMaxTrackedLgkmPending(const HazardConfig &cfg) {
  return cfg.defaultLgkmcnt + 1;
}

static void addPendingLgkmIssue(Operation *op, HazardState &state,
                                const HazardConfig &cfg,
                                const HazardOpInfo *opInfo) {
  if (!cfg.legacyWaitCounters)
    return;
  waveamdmachine::WaitcntInfo info =
      opInfo ? opInfo->waitcnt : getWaitcntInfo(op);
  if (waveamdmachine::getLegacyWaitcntCounter(info.event) !=
          waveamdmachine::WaitcntCounter::Lgkm ||
      !info.issueCount)
    return;
  unsigned maxTrackedPending = getMaxTrackedLgkmPending(cfg);
  state.lgkmPending = std::min(
      maxTrackedPending,
      state.lgkmPending + std::min(info.issueCount, maxTrackedPending));
}

static void applyLgkmWait(Operation *op, HazardState &state,
                          const HazardConfig &cfg, const HazardOpInfo *info) {
  std::optional<unsigned> limit =
      info ? info->lgkmWaitLimit : getLgkmWaitLimit(*op);
  if (!limit || *limit >= cfg.defaultLgkmcnt)
    return;
  bool drained = state.lgkmPending > *limit;
  state.lgkmPending = std::min(state.lgkmPending, *limit);
  if (drained && cfg.lgkmWaitNeedsValuGap)
    state.lgkmToValu = std::max(state.lgkmToValu, 1u);
}

static void transferHazards(Operation *op, HazardState &state,
                            const HazardConfig &cfg,
                            const HazardOpInfo *info = nullptr) {
  bool controlFlow = info ? info->controlFlow : isControlFlowOp(op);
  if (!(info ? info->noMachineInst : emitsNoMachineInst(*op))) {
    advanceHazards(state, /*count=*/1, /*advanceLgkm=*/!controlFlow);
    unsigned issueCount = getCachedInstructionIssueCount(op, cfg, info);
    if (isCachedVALUForCoexecution(op, info))
      advanceCoexecHazards(state, issueCount);
    if (isCachedSGPRWrite(op, info))
      advanceScratchBaseHazards(state, issueCount);
  }

  if (controlFlow)
    return;

  inheritNoInstOperandHazards(op, state);
  applySWaitAlu(op, state);
  addProducedHazards(op, state, cfg, info);
  addProducedCoexecHazards(op, state, cfg, info);
  addProducedScratchBaseHazards(op, state, cfg, info);
  addPendingLgkmIssue(op, state, cfg, info);
  applyLgkmWait(op, state, cfg, info);
}

static unsigned getRequiredSsaWait(Operation *op, const HazardState &state,
                                   const HazardOpInfo *info = nullptr) {
  if (info ? info->controlFlow : isControlFlowOp(op))
    return 0;
  unsigned wait = isa<waveamdmachine::M0WriteHazardOpInterface>(op)
                      ? state.m0DmaCapture
                      : 0;
  bool vmemStore = info ? info->vmemStore : isVMEMStore(*op);
  bool permlane32Swap = isCachedPermlane32Swap(op, info);
  for (Value operand : op->getOperands()) {
    ValueHazards hazards = lookupValueHazards(state, operand);
    if (isa<waveamdmachine::M0Type>(operand.getType()))
      wait = std::max(wait, hazards.m0);
    if (vmemStore)
      wait = std::max(wait, hazards.mfmaStore);
    if (permlane32Swap)
      wait = std::max(wait, hazards.permlane32Swap);
  }
  return wait;
}

static bool needsValuMitigation(Operation *op, const HazardState &state,
                                const HazardOpInfo *info = nullptr) {
  return state.lgkmToValu &&
         (info ? info->valu : op->hasTrait<OpTrait::waveamdmachine::VALUOp>());
}

using HazardWaitMap = DenseMap<Operation *, unsigned>;

struct BlockHazardTrace {
  HazardWaitMap waits;
  DenseMap<Operation *, HazardState> before;
  unsigned totalWaits = 0;
};

static unsigned getRequiredMitigation(Operation *op, HazardState &state,
                                      const HazardConfig &cfg,
                                      const HazardOpInfo *info) {
  unsigned count = 0;
  unsigned wait = std::max(getRequiredSsaWait(op, state, info),
                           getRequiredPhysicalWait(op, state, cfg, info));
  if (wait) {
    count += wait;
    advanceHazards(state, wait);
  }
  if (needsValuMitigation(op, state, info)) {
    ++count;
    advanceHazards(state);
  }
  unsigned vnops = getRequiredCoexecVNops(op, state, cfg, info);
  if (vnops) {
    count += vnops;
    advanceHazards(state, vnops);
    advanceCoexecHazards(state, vnops);
  }
  if (needsScratchBaseWait(op, state, cfg, info)) {
    ++count;
    advanceHazards(state);
    state.scratchBase.fill(0);
  }
  return count;
}

static BlockHazardTrace computeBlockHazardTrace(Block &block,
                                                const HazardConfig &cfg,
                                                const HazardOpInfoMap *infos) {
  HazardState state;
  BlockHazardTrace trace;
  for (Operation &op : block) {
    const HazardOpInfo *info = lookupHazardOpInfo(&op, infos);
    trace.before.try_emplace(&op, state);
    unsigned wait = getRequiredMitigation(&op, state, cfg, info);
    if (wait) {
      trace.waits[&op] = wait;
      trace.totalWaits += wait;
    }
    transferHazards(&op, state, cfg, info);
  }
  return trace;
}

static bool touchesBlockedSingletonReg(Operation *op) {
  if (llvm::any_of(op->getOperands(), [](Value value) {
        return wave::getHardwareResourceForValue(value).has_value();
      }))
    return true;
  return llvm::any_of(op->getResults(), [](Value value) {
    std::optional<wave::HardwareResourceKind> kind =
        wave::getHardwareResourceForValue(value);
    if (!kind)
      return false;
    return *kind != wave::HardwareResourceKind::SCC || !value.use_empty();
  });
}

static bool definesLoopCarry(Operation *op) {
  return llvm::any_of(op->getResults(), [](Value result) {
    return llvm::any_of(result.getUsers(), [&](Operation *user) {
      waveamdmachine::ContinueIfOp terminator =
          dyn_cast<waveamdmachine::ContinueIfOp>(user);
      return terminator && llvm::is_contained(terminator.getCarries(), result);
    });
  });
}

static bool isRepairCandidate(Operation *op) {
  if (emitsNoMachineInst(*op) || !isPure(op) ||
      isa<waveamdmachine::MMAOpInterface>(op))
    return false;
  if (!op->hasTrait<OpTrait::waveamdmachine::VALUOp>() &&
      !op->hasTrait<OpTrait::waveamdmachine::SALUOp>())
    return false;
  // Post-greedy repair may not move carry defs; backedges reuse registers.
  if (definesLoopCarry(op))
    return false;
  return !touchesBlockedSingletonReg(op);
}

static Operation *getAncestorInBlock(Operation *op, Block *block) {
  for (Operation *ancestor = op; ancestor; ancestor = ancestor->getParentOp())
    if (ancestor->getBlock() == block)
      return ancestor;
  return nullptr;
}

static void restoreCandidatePosition(Operation *candidate,
                                     Operation *restoreBefore,
                                     Operation *restoreAfter, Block *block) {
  if (restoreBefore)
    candidate->moveBefore(restoreBefore);
  else if (restoreAfter)
    candidate->moveAfter(restoreAfter);
  else
    candidate->moveBefore(block, block->end());
}

static bool hasRejoinedHazardTrace(Operation *next, Operation *rejoinBefore,
                                   bool &canRejoin, bool targetImproved,
                                   bool candidateClear,
                                   const HazardState &state,
                                   const BlockHazardTrace &oldTrace) {
  canRejoin |= next == rejoinBefore;
  if (!canRejoin || !next || !targetImproved || !candidateClear)
    return false;
  auto beforeIt = oldTrace.before.find(next);
  assert(beforeIt != oldTrace.before.end() && "missing rejoin hazard state");
  return state == beforeIt->second;
}

static bool movedHazardsAccepted(Operation *startOp, HazardState state,
                                 Operation *candidate, Operation *target,
                                 Operation *rejoinBefore,
                                 unsigned oldTargetWait,
                                 const BlockHazardTrace &oldTrace,
                                 const HazardConfig &cfg,
                                 const HazardOpInfoMap *infos) {
  bool targetImproved = false;
  bool candidateClear = false;
  bool canRejoin = false;
  for (Operation *op = startOp; op; op = op->getNextNode()) {
    const HazardOpInfo *info = lookupHazardOpInfo(op, infos);
    unsigned wait = getRequiredMitigation(op, state, cfg, info);
    if (wait > oldTrace.waits.lookup(op))
      return false;
    if (op == target)
      targetImproved = wait < oldTargetWait;
    if (op == candidate)
      candidateClear = wait == 0;
    transferHazards(op, state, cfg, info);
    Operation *next = op->getNextNode();
    if (hasRejoinedHazardTrace(next, rejoinBefore, canRejoin, targetImproved,
                               candidateClear, state, oldTrace))
      return true;
  }
  return targetImproved && candidateClear;
}

struct RepairCandidate {
  Operation *op = nullptr;
  unsigned ordinal = 0;
  unsigned targetBegin = 0;
  unsigned targetEnd = 0;
};

static bool canMoveCandidateTo(const RepairCandidate &candidate,
                               unsigned targetOrdinal) {
  return candidate.op != nullptr && candidate.ordinal != targetOrdinal &&
         targetOrdinal >= candidate.targetBegin &&
         targetOrdinal < candidate.targetEnd;
}

static Operation *getMovedRepairStart(Operation *candidate,
                                      Operation *restoreBefore,
                                      Operation *target,
                                      bool candidateAfterTarget) {
  if (candidateAfterTarget || restoreBefore == target)
    return candidate;
  return restoreBefore;
}

static bool tryMoveRepairCandidate(const RepairCandidate &candidateInfo,
                                   Operation *target, unsigned targetOrdinal,
                                   const BlockHazardTrace &oldTrace,
                                   const HazardConfig &cfg,
                                   const HazardOpInfoMap *infos) {
  if (!canMoveCandidateTo(candidateInfo, targetOrdinal))
    return false;

  Operation *candidate = candidateInfo.op;
  bool candidateAfterTarget = targetOrdinal < candidateInfo.ordinal;
  auto beforeIt =
      oldTrace.before.find(candidateAfterTarget ? target : candidate);
  assert(beforeIt != oldTrace.before.end() && "missing hazard prefix state");
  HazardState prefixState = beforeIt->second;
  Operation *restoreBefore = candidate->getNextNode();
  Operation *restoreAfter = candidate->getPrevNode();
  unsigned oldTargetWait = oldTrace.waits.lookup(target);
  candidate->moveBefore(target);

  Operation *startOp = getMovedRepairStart(candidate, restoreBefore, target,
                                           candidateAfterTarget);
  Operation *rejoinBefore =
      candidateAfterTarget ? restoreBefore : target->getNextNode();
  bool accept =
      movedHazardsAccepted(startOp, prefixState, candidate, target,
                           rejoinBefore, oldTargetWait, oldTrace, cfg, infos);
  if (!accept)
    restoreCandidatePosition(candidate, restoreBefore, restoreAfter,
                             candidate->getBlock());
  return accept;
}

static bool operandsDominateTarget(Operation *candidate, Operation *target,
                                   DominanceInfo &dom) {
  return llvm::all_of(candidate->getOperands(), [&](Value operand) {
    return dom.dominates(operand, target);
  });
}

static bool resultsRemainDominated(Operation *candidate, Operation *target,
                                   DominanceInfo &dom) {
  for (Value result : candidate->getResults())
    for (Operation *user : result.getUsers())
      if (user != target && !dom.properlyDominates(target, user))
        return false;
  return true;
}

static bool hazardsDoNotIncrease(const BlockHazardTrace &before,
                                 const BlockHazardTrace &after) {
  for (auto [op, wait] : after.waits)
    if (wait > before.waits.lookup(op))
      return false;
  return true;
}

static bool canPullIntoRegion(Operation *parent) {
  return parent && parent->getBlock() && !isa<LoopLikeOpInterface>(parent) &&
         !parent->hasTrait<OpTrait::IsIsolatedFromAbove>();
}

static bool touchesM0(Operation *op) {
  wave::HardwareResourceEffects effects = wave::getHardwareResourceEffects(op);
  return llvm::is_contained(effects.reads, wave::HardwareResourceKind::M0) ||
         llvm::is_contained(effects.writes, wave::HardwareResourceKind::M0);
}

static bool hasOnlyDeadAuxiliaryResourceResults(Operation *op) {
  wave::HardwareResourceEffects effects = wave::getHardwareResourceEffects(op);
  for (wave::HardwareResourceKind kind : effects.writes) {
    if (kind == wave::HardwareResourceKind::M0)
      continue;
    bool hasResult = false;
    for (Value result : op->getResults()) {
      if (wave::getHardwareResourceForValue(result) != kind)
        continue;
      hasResult = true;
      if (!result.use_empty())
        return false;
    }
    if (!hasResult)
      return false;
  }
  return true;
}

static Operation *getSingleUseM0Consumer(Operation *writer) {
  auto m0Writer = dyn_cast<waveamdmachine::M0WriteHazardOpInterface>(writer);
  if (!m0Writer)
    return nullptr;
  Value m0 = m0Writer.getM0HazardValue();
  if (!m0.hasOneUse())
    return nullptr;
  Operation *consumer = *m0.user_begin();
  if (consumer->getBlock() != writer->getBlock() ||
      !writer->isBeforeInBlock(consumer))
    return nullptr;
  return consumer;
}

static unsigned countMachineOpsBetween(Operation *begin, Operation *end) {
  unsigned count = 0;
  for (Operation *op = begin->getNextNode(); op && op != end;
       op = op->getNextNode())
    if (!emitsNoMachineInst(*op))
      ++count;
  return count;
}

static bool canCrossBlockPrefix(Operation *nested) {
  for (Operation &op : *nested->getBlock()) {
    if (&op == nested)
      return true;
    if (!emitsNoMachineInst(op) || touchesM0(&op))
      return false;
  }
  llvm_unreachable("nested operation missing from parent block");
}

static Operation *findM0RegionHoistPoint(Operation *writer, Operation *consumer,
                                         const HazardConfig &cfg,
                                         DominanceInfo &dom) {
  unsigned gap = countMachineOpsBetween(writer, consumer);
  if (gap >= cfg.m0PipelineDelay)
    return nullptr;
  if (!hasOnlyDeadAuxiliaryResourceResults(writer))
    return nullptr;

  Operation *nested = writer;
  while (gap < cfg.m0PipelineDelay) {
    if (!canCrossBlockPrefix(nested))
      return nullptr;
    Operation *parent = nested->getBlock()->getParentOp();
    if (!canPullIntoRegion(parent) || touchesM0(parent) ||
        !operandsDominateTarget(writer, parent, dom))
      return nullptr;
    nested = parent;
    if (!emitsNoMachineInst(*parent))
      ++gap;
  }
  return nested;
}

static void hoistM0WritesAcrossRegions(Operation *root, const HazardConfig &cfg,
                                       DominanceInfo &dom) {
  SmallVector<Operation *> writers;
  root->walk([&](waveamdmachine::M0WriteHazardOpInterface writer) {
    writers.push_back(writer.getOperation());
  });
  for (Operation *writer : writers) {
    Operation *consumer = getSingleUseM0Consumer(writer);
    if (!consumer)
      continue;
    Operation *insertBefore =
        findM0RegionHoistPoint(writer, consumer, cfg, dom);
    if (insertBefore)
      writer->moveBefore(insertBefore);
  }
}

static bool canPullOuterRepairCandidate(Operation *candidate, Operation *target,
                                        DominanceInfo &dom) {
  Operation *parent = target->getBlock()->getParentOp();
  if (!canPullIntoRegion(parent))
    return false;
  if (candidate->getBlock() != parent->getBlock())
    return false;
  if (!candidate->isBeforeInBlock(parent))
    return false;
  if (!dom.properlyDominates(candidate, target))
    return false;
  if (llvm::none_of(candidate->getResults(), [&](Value result) {
        return llvm::is_contained(target->getOperands(), result);
      }))
    return false;
  return operandsDominateTarget(candidate, target, dom) &&
         resultsRemainDominated(candidate, target, dom);
}

static bool tryPullOuterRepairCandidate(Operation *candidate, Operation *target,
                                        const BlockHazardTrace &targetTrace,
                                        const HazardConfig &cfg,
                                        const HazardOpInfoMap *infos,
                                        DominanceInfo &dom) {
  if (!canPullOuterRepairCandidate(candidate, target, dom))
    return false;

  Block *sourceBlock = candidate->getBlock();
  BlockHazardTrace sourceTrace =
      computeBlockHazardTrace(*sourceBlock, cfg, infos);
  Operation *restoreBefore = candidate->getNextNode();
  Operation *restoreAfter = candidate->getPrevNode();
  unsigned oldTargetWait = targetTrace.waits.lookup(target);
  candidate->moveBefore(target);

  BlockHazardTrace movedTargetTrace =
      computeBlockHazardTrace(*target->getBlock(), cfg, infos);
  BlockHazardTrace movedSourceTrace =
      computeBlockHazardTrace(*sourceBlock, cfg, infos);
  bool accept = movedTargetTrace.waits.lookup(target) < oldTargetWait &&
                movedTargetTrace.waits.lookup(candidate) == 0 &&
                hazardsDoNotIncrease(targetTrace, movedTargetTrace) &&
                hazardsDoNotIncrease(sourceTrace, movedSourceTrace);
  if (!accept)
    restoreCandidatePosition(candidate, restoreBefore, restoreAfter,
                             sourceBlock);
  return accept;
}

static void
collectOuterRepairCandidates(Block &block,
                             SmallVectorImpl<Operation *> &candidates) {
  Operation *parent = block.getParentOp();
  if (!canPullIntoRegion(parent))
    return;
  for (Operation *op = parent->getPrevNode(); op; op = op->getPrevNode())
    if (isRepairCandidate(op))
      candidates.push_back(op);
}

struct RepairBlockIndex {
  SmallVector<Operation *, 16> ops;
  SmallVector<RepairCandidate, 16> localCandidates;
  SmallVector<Operation *, 16> outerCandidates;
  SmallVector<unsigned, 8> waitOrdinals;
  DenseMap<Operation *, unsigned> ordinals;
};

static RepairCandidate
indexRepairCandidate(Operation *candidate,
                     const DenseMap<Operation *, unsigned> &ordinals,
                     unsigned blockSize) {
  unsigned targetBegin = 0;
  unsigned targetEnd = blockSize;
  for (Value operand : candidate->getOperands()) {
    Operation *def = operand.getDefiningOp();
    if (!def || def->getBlock() != candidate->getBlock())
      continue;
    auto defIt = ordinals.find(def);
    assert(defIt != ordinals.end() && "missing candidate operand ordinal");
    targetBegin = std::max(targetBegin, defIt->second + 1);
  }
  for (Value result : candidate->getResults()) {
    for (Operation *user : result.getUsers()) {
      Operation *ancestor = getAncestorInBlock(user, candidate->getBlock());
      if (!ancestor)
        continue;
      auto userIt = ordinals.find(ancestor);
      assert(userIt != ordinals.end() && "missing candidate user ordinal");
      targetEnd = std::min(targetEnd, userIt->second + 1);
    }
  }
  auto candidateIt = ordinals.find(candidate);
  assert(candidateIt != ordinals.end() && "missing candidate ordinal");
  return RepairCandidate{candidate, candidateIt->second, targetBegin,
                         targetEnd};
}

static RepairBlockIndex buildRepairBlockIndex(Block &block,
                                              const BlockHazardTrace &trace) {
  RepairBlockIndex index;
  for (auto [ordinal, op] : llvm::enumerate(block)) {
    index.ops.push_back(&op);
    index.ordinals[&op] = ordinal;
    if (trace.waits.lookup(&op))
      index.waitOrdinals.push_back(ordinal);
  }
  for (Operation *op : index.ops)
    if (isRepairCandidate(op))
      index.localCandidates.push_back(
          indexRepairCandidate(op, index.ordinals, index.ops.size()));
  collectOuterRepairCandidates(block, index.outerCandidates);
  return index;
}

struct CandidateOrdinalRange {
  unsigned begin = 0;
  unsigned end = 0;
};

static CandidateOrdinalRange
getCandidateOrdinalRange(const RepairBlockIndex &index,
                         unsigned targetOrdinal) {
  auto targetIt = llvm::lower_bound(index.waitOrdinals, targetOrdinal);
  assert(targetIt != index.waitOrdinals.end() && *targetIt == targetOrdinal &&
         "repair target must have a wait");
  unsigned begin = targetIt == index.waitOrdinals.begin() ? 0 : targetIt[-1];
  ++targetIt;
  unsigned end =
      targetIt == index.waitOrdinals.end() ? index.ops.size() : *targetIt + 1;
  return CandidateOrdinalRange{begin, end};
}

static bool tryLocalRepairCandidates(Operation *target, unsigned targetOrdinal,
                                     const RepairBlockIndex &index,
                                     const BlockHazardTrace &trace,
                                     const HazardConfig &cfg,
                                     const HazardOpInfoMap *infos) {
  CandidateOrdinalRange range = getCandidateOrdinalRange(index, targetOrdinal);
  auto begin =
      llvm::lower_bound(index.localCandidates, range.begin,
                        [](const RepairCandidate &candidate, unsigned ordinal) {
                          return candidate.ordinal < ordinal;
                        });
  auto end =
      llvm::lower_bound(index.localCandidates, range.end,
                        [](const RepairCandidate &candidate, unsigned ordinal) {
                          return candidate.ordinal < ordinal;
                        });
  for (auto candidate = begin; candidate != end; ++candidate)
    if (tryMoveRepairCandidate(*candidate, target, targetOrdinal, trace, cfg,
                               infos))
      return true;
  return false;
}

static bool
tryOuterRepairCandidates(Operation *target, const RepairBlockIndex &index,
                         const BlockHazardTrace &trace, const HazardConfig &cfg,
                         const HazardOpInfoMap *infos, DominanceInfo &dom) {
  for (Operation *candidate : index.outerCandidates)
    if (tryPullOuterRepairCandidate(candidate, target, trace, cfg, infos, dom))
      return true;
  return false;
}

struct RepairStepResult {
  bool moved = false;
  bool stop = false;
};

static RepairStepResult
tryRepairHazardOp(Operation *op, const RepairBlockIndex &index,
                  const BlockHazardTrace &trace, const HazardConfig &cfg,
                  const HazardOpInfoMap *infos, DominanceInfo &dom,
                  unsigned &moves, unsigned maxMoves) {
  if (!trace.waits.lookup(op))
    return {};
  auto ordinalIt = index.ordinals.find(op);
  assert(ordinalIt != index.ordinals.end() && "missing repair target ordinal");
  bool moved =
      tryLocalRepairCandidates(op, ordinalIt->second, index, trace, cfg, infos);
  if (!moved)
    moved = tryOuterRepairCandidates(op, index, trace, cfg, infos, dom);
  if (!moved)
    return {};
  if (++moves > maxMoves) {
    op->getBlock()->getParentOp()->emitWarning(
        "waveamd-hazard-repair did not converge");
    return {/*moved=*/true, /*stop=*/true};
  }
  return {/*moved=*/true, /*stop=*/false};
}

static bool repairBlock(Block &block, const HazardConfig &cfg,
                        const HazardOpInfoMap *infos, DominanceInfo &dom) {
  bool changed = false;
  unsigned moves = 0;
  BlockHazardTrace trace = computeBlockHazardTrace(block, cfg, infos);
  unsigned maxMoves = trace.totalWaits;
  while (true) {
    bool progress = false;
    RepairBlockIndex index = buildRepairBlockIndex(block, trace);

    for (Operation *op : index.ops) {
      RepairStepResult result =
          tryRepairHazardOp(op, index, trace, cfg, infos, dom, moves, maxMoves);
      if (!result.moved)
        continue;
      changed = true;
      progress = true;
      if (result.stop)
        return changed;
      break;
    }
    if (!progress)
      break;
    trace = computeBlockHazardTrace(block, cfg, infos);
  }
  return changed;
}

class HazardAnalysis : public DenseForwardDataFlowAnalysis<HazardLattice> {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(HazardAnalysis)

  HazardAnalysis(DataFlowSolver &solver, const HazardConfig &cfg)
      : DenseForwardDataFlowAnalysis(solver), cfg(cfg) {}

  LogicalResult initialize(Operation *top) override {
    auto markRegions = [&](Operation *op) {
      for (Region &region : op->getRegions()) {
        for (Block &block : region) {
          auto *blockLive =
              getOrCreate<Executable>(getProgramPointBefore(&block));
          propagateIfChanged(blockLive, blockLive->setToLive());
          Operation *term = block.getTerminator();
          if (!term)
            continue;
          for (Block *successor : term->getSuccessors()) {
            auto *edgeLive = getOrCreate<Executable>(
                getLatticeAnchor<CFGEdge>(&block, successor));
            propagateIfChanged(edgeLive, edgeLive->setToLive());
          }
        }
      }
    };
    markRegions(top);
    top->walk(markRegions);
    return DenseForwardDataFlowAnalysis<HazardLattice>::initialize(top);
  }

  void setToEntryState(HazardLattice *lattice) override {
    propagateIfChanged(lattice, lattice->reset());
  }

  LogicalResult visitOperation(Operation *op, const HazardLattice &before,
                               HazardLattice *after) override {
    HazardState next = before.get();
    transferHazards(op, next, cfg);
    propagateIfChanged(after, after->joinWith(next));
    return success();
  }

  void visitBlockTransfer(Block *block, ProgramPoint *point, Block *predecessor,
                          const HazardLattice &before,
                          HazardLattice *after) override {
    HazardState next = before.get();
    propagateBranchOperands(predecessor->getTerminator(), block, next);
    propagateIfChanged(after, after->joinWith(next));
  }

  void visitRegionBranchControlFlowTransfer(RegionBranchOpInterface branch,
                                            std::optional<unsigned> regionFrom,
                                            std::optional<unsigned> regionTo,
                                            const HazardLattice &before,
                                            HazardLattice *after) override {
    HazardState next = before.get();
    if (!regionFrom && !emitsNoMachineInst(*branch))
      advanceHazards(next, /*count=*/1, /*advanceLgkm=*/false);
    propagateRegionOperands(branch, regionFrom, regionTo, next);
    propagateIfChanged(after, after->joinWith(next));
  }

  const HazardConfig &cfg;
};

struct WaveAMDHazardRepairPass
    : public wave::impl::WaveAMDHazardRepairBase<WaveAMDHazardRepairPass> {
  using WaveAMDHazardRepairBase::WaveAMDHazardRepairBase;

  void runOnOperation() override {
    HazardRepairStageTiming timing;
    TimingScope setupTiming = timing.nest("hazard_repair_setup");
    Operation *root = getOperation();
    FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
        createSubtargetInfo(root, "waveamd-hazard-repair");
    if (failed(sti))
      return signalPassFailure();

    HazardConfig cfg = makeHazardConfig(**sti);
    DominanceInfo dom(root);
    setupTiming.stop();

    TimingScope hoistTiming = timing.nest("hazard_repair_hoist_m0");
    if (hoistM0AcrossRegions)
      hoistM0WritesAcrossRegions(root, cfg, dom);
    hoistTiming.stop();

    TimingScope collectTiming = timing.nest("hazard_repair_collect_op_info");
    HazardOpInfoMap infos = collectHazardOpInfo(root, cfg);
    collectTiming.stop();

    TimingScope blocksTiming = timing.nest("hazard_repair_blocks");
    root->walk(
        [&](Block *block) { (void)repairBlock(*block, cfg, &infos, dom); });
  }
};

struct WaveAMDHazardWaitsPass
    : public wave::impl::WaveAMDHazardWaitsBase<WaveAMDHazardWaitsPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    OpBuilder builder(root->getContext());
    FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
        createSubtargetInfo(root);
    if (failed(sti))
      return signalPassFailure();
    HazardConfig cfg = makeHazardConfig(**sti);
    SmallVector<func::FuncOp> kernels;
    root->walk([&](func::FuncOp f) {
      if (!f.isExternal())
        kernels.push_back(f);
    });
    for (func::FuncOp func : kernels)
      if (failed(processFunction(func, builder, cfg, **sti)))
        return signalPassFailure();
  }

private:
  static bool isUnloweredKernelArg(Operation &op, func::FuncOp func) {
    return func->hasAttr(wave::WaveDialect::getKernelAttrName()) &&
           isa<waveamdmachine::ArgOp>(op);
  }

  static bool isMalformedSMEMLoad(Operation &op) {
    return isa<waveamdmachine::SLoadB32Op, waveamdmachine::SLoadB64Op,
               waveamdmachine::SLoadB128Op>(op) &&
           !op.getAttrOfType<StringAttr>("base");
  }

  LogicalResult validateInput(func::FuncOp func) {
    SmallVector<Operation *> ops;
    func.walk<WalkOrder::PreOrder>([&](Operation *op) {
      if (isWaveAMDMachineOp(op))
        ops.push_back(op);
    });
    for (Operation *op : ops) {
      if (isUnloweredKernelArg(*op, func))
        return op->emitError(
            "waveamd-insert-hazard-waits expects ABI-lowered kernel arguments");
      if (isMalformedSMEMLoad(*op))
        return op->emitError(
            "waveamd-insert-hazard-waits expects scalar memory loads to "
            "carry a base register attribute");
    }
    return success();
  }

  static void collectBlocks(Region &region, SmallVectorImpl<Block *> &blocks) {
    for (Block &block : region) {
      blocks.push_back(&block);
      for (Operation &op : block)
        for (Region &nested : op.getRegions())
          collectBlocks(nested, blocks);
    }
  }

  static void rewriteOp(Operation *op, HazardState &local,
                        DataFlowSolver &solver, const HazardConfig &cfg,
                        const llvm::MCSubtargetInfo &sti, OpBuilder &builder) {
    if (isControlFlowOp(op)) {
      if (auto *post = solver.lookupState<HazardLattice>(
              solver.getProgramPointAfter(op)))
        local = post->get();
      return;
    }

    unsigned wait = std::max(getRequiredSsaWait(op, local),
                             getRequiredPhysicalWait(op, local, cfg));
    if (wait) {
      insertSNopMitigation(*op, wait, builder, sti);
      advanceHazards(local, wait);
    }

    if (needsValuMitigation(op, local)) {
      insertValuMitigation(*op, builder, cfg, sti);
      advanceHazards(local);
    }

    unsigned vnops = getRequiredCoexecVNops(op, local, cfg);
    if (vnops) {
      insertVNopMitigation(*op, vnops, builder);
      advanceHazards(local, vnops);
      advanceCoexecHazards(local, vnops);
    }

    if (needsScratchBaseWait(op, local, cfg)) {
      insertScratchBaseWait(*op, builder);
      advanceHazards(local);
      local.scratchBase.fill(0);
    }

    transferHazards(op, local, cfg);
  }

  static void rewriteBlock(Block *block, DataFlowSolver &solver,
                           const HazardConfig &cfg,
                           const llvm::MCSubtargetInfo &sti,
                           OpBuilder &builder) {
    HazardState local;
    if (auto *blockLat = solver.lookupState<HazardLattice>(
            solver.getProgramPointBefore(block)))
      local = blockLat->get();

    SmallVector<Operation *> ops;
    for (Operation &op : *block)
      ops.push_back(&op);
    for (Operation *op : ops)
      rewriteOp(op, local, solver, cfg, sti, builder);
  }

  static void rewriteWithSolver(func::FuncOp func, DataFlowSolver &solver,
                                const HazardConfig &cfg,
                                const llvm::MCSubtargetInfo &sti,
                                OpBuilder &builder) {
    SmallVector<Block *> blocks;
    collectBlocks(func.getBody(), blocks);
    for (Block *block : blocks)
      rewriteBlock(block, solver, cfg, sti, builder);
  }

  struct LgkmValuGap {
    Operation *target = nullptr;
    unsigned missingSlots = 0;
  };

  static std::optional<unsigned>
  getLgkmWaitFillSlots(waveamdmachine::SWaitcntOp wait,
                       const HazardConfig &cfg) {
    if (!cfg.lgkmWaitNeedsValuGap)
      return std::nullopt;
    std::optional<unsigned> lgkm = getLgkmWaitLimit(*wait);
    if (!lgkm || *lgkm >= cfg.defaultLgkmcnt)
      return std::nullopt;
    return 1;
  }

  static bool isKnownMemoryOp(Operation *op) {
    return getWaitcntInfo(op).isIssuer();
  }

  static bool isLgkmFillerSearchBoundary(Operation *op) {
    if (!isWaveAMDMachineOp(op))
      return true;
    if (op->hasTrait<OpTrait::IsTerminator>() || op->getNumRegions() != 0)
      return true;
    if (isControlFlowOp(op))
      return true;
    if (op->hasTrait<OpTrait::waveamdmachine::WaitcntOp>())
      return true;
    if (isa<waveamdmachine::LabelOp, waveamdmachine::SBarrierSignalOp,
            waveamdmachine::SBarrierWaitOp, waveamdmachine::SBarrierOp,
            waveamdmachine::SSetprioOp, waveamdmachine::SNopOp,
            waveamdmachine::SDelayAluOp, waveamdmachine::SAndSaveexecB32Op,
            waveamdmachine::SAndn2ExecB32Op, waveamdmachine::SAndSaveexecB64Op,
            waveamdmachine::SAndn2ExecB64Op, waveamdmachine::SMovExecLoOp,
            waveamdmachine::SMovExecB64Op,
            waveamdmachine::SSendmsgDeallocVgprsOp, waveamdmachine::SEndpgmOp,
            waveamdmachine::SSetpcB64Op>(op))
      return true;
    if (isa<waveamdmachine::M0WriteHazardOpInterface>(op))
      return true;
    return isKnownMemoryOp(op);
  }

  static bool canFillLgkmValuSlot(Operation *op) {
    if (emitsNoMachineInst(*op))
      return false;
    return isa<waveamdmachine::SNopOp>(op) ||
           (isPure(op) && !op->hasTrait<OpTrait::waveamdmachine::VALUOp>());
  }

  static bool hasResource(ArrayRef<wave::HardwareResourceKind> resources,
                          wave::HardwareResourceKind resource) {
    return llvm::is_contained(resources, resource);
  }

  static bool hasDeadSCCWrite(Operation *op) {
    bool foundSCC = false;
    for (Value result : op->getResults()) {
      std::optional<wave::HardwareResourceKind> kind =
          wave::getHardwareResourceForValue(result);
      if (kind != wave::HardwareResourceKind::SCC)
        continue;
      foundSCC = true;
      if (!result.use_empty())
        return false;
    }
    return foundSCC;
  }

  static bool resourceEffectsConflict(Operation *candidate, Operation *crossed,
                                      bool ignoreDeadCandidateSCCWrites) {
    wave::HardwareResourceEffects candidateEffects =
        wave::getHardwareResourceEffects(candidate);
    wave::HardwareResourceEffects crossedEffects =
        wave::getHardwareResourceEffects(crossed);
    bool ignoreSCCWriteWrite =
        ignoreDeadCandidateSCCWrites && hasDeadSCCWrite(candidate);
    for (wave::HardwareResourceKind resource : candidateEffects.reads)
      if (hasResource(crossedEffects.writes, resource))
        return true;
    for (wave::HardwareResourceKind resource : candidateEffects.writes)
      if (hasResource(crossedEffects.reads, resource) ||
          (hasResource(crossedEffects.writes, resource) &&
           !(ignoreSCCWriteWrite &&
             resource == wave::HardwareResourceKind::SCC)))
        return true;
    return false;
  }

  static void collectAllocatedRegSpans(ValueRange values,
                                       SmallVectorImpl<RegSpan> &spans) {
    for (Value value : values)
      if (std::optional<RegSpan> span = getAllocatedRegSpan(value))
        spans.push_back(*span);
  }

  static bool physicalRegsConflict(Operation *candidate, Operation *crossed) {
    SmallVector<RegSpan, 4> candidateOperands;
    SmallVector<RegSpan, 4> candidateResults;
    SmallVector<RegSpan, 4> crossedOperands;
    SmallVector<RegSpan, 4> crossedResults;
    collectAllocatedRegSpans(candidate->getOperands(), candidateOperands);
    collectAllocatedRegSpans(candidate->getResults(), candidateResults);
    collectAllocatedRegSpans(crossed->getOperands(), crossedOperands);
    collectAllocatedRegSpans(crossed->getResults(), crossedResults);

    for (RegSpan candidateResult : candidateResults) {
      for (RegSpan crossedOperand : crossedOperands)
        if (overlaps(candidateResult, crossedOperand))
          return true;
      for (RegSpan crossedResult : crossedResults)
        if (overlaps(candidateResult, crossedResult))
          return true;
    }
    for (RegSpan candidateOperand : candidateOperands)
      for (RegSpan crossedResult : crossedResults)
        if (overlaps(candidateOperand, crossedResult))
          return true;
    return false;
  }

  static bool operandsAvailableBefore(Operation *candidate,
                                      Operation *insertBefore) {
    for (Value operand : candidate->getOperands()) {
      Operation *def = operand.getDefiningOp();
      if (!def || def->getBlock() != candidate->getBlock())
        continue;
      if (!def->isBeforeInBlock(insertBefore))
        return false;
    }
    return true;
  }

  static bool usesKnownMemoryResult(Operation *op) {
    for (Value operand : op->getOperands()) {
      Operation *def = operand.getDefiningOp();
      if (def && isKnownMemoryOp(def))
        return true;
    }
    return false;
  }

  static bool canMoveAsLgkmValuFiller(Operation *op) {
    if (isa<waveamdmachine::SNopOp>(op))
      return false;
    return canFillLgkmValuSlot(op) && !usesKnownMemoryResult(op);
  }

  static std::optional<LgkmValuGap>
  findLgkmValuGap(waveamdmachine::SWaitcntOp wait, const HazardConfig &cfg) {
    std::optional<unsigned> pending = getLgkmWaitFillSlots(wait, cfg);
    if (!pending)
      return std::nullopt;

    unsigned issued = 0;
    for (Operation *op = wait->getNextNode(); op; op = op->getNextNode()) {
      if (isLgkmFillerSearchBoundary(op))
        break;
      if (op->hasTrait<OpTrait::waveamdmachine::VALUOp>()) {
        if (issued >= *pending)
          return std::nullopt;
        return LgkmValuGap{op, *pending - issued};
      }
      if (!emitsNoMachineInst(*op) && ++issued >= *pending)
        return std::nullopt;
    }
    return std::nullopt;
  }

  static bool canMoveBefore(Operation *candidate, Operation *insertBefore,
                            bool ignoreDeadCandidateSCCWrites = false) {
    if (candidate->getBlock() != insertBefore->getBlock())
      return false;
    if (!operandsAvailableBefore(candidate, insertBefore))
      return false;

    for (Operation *crossed = insertBefore; crossed != candidate;
         crossed = crossed->getNextNode()) {
      if (resourceEffectsConflict(candidate, crossed,
                                  ignoreDeadCandidateSCCWrites))
        return false;
      if (physicalRegsConflict(candidate, crossed))
        return false;
    }
    return true;
  }

  static bool isM0Consumer(Operation *op) {
    return llvm::any_of(op->getOperands(), [](Value operand) {
      return isa<waveamdmachine::M0Type>(operand.getType());
    });
  }

  static bool isM0HoistSearchBoundary(Operation *op) {
    return isLgkmFillerSearchBoundary(op) || isM0Consumer(op);
  }

  static bool hoistOneM0Write(waveamdmachine::M0WriteHazardOpInterface writer,
                              const HazardConfig &cfg) {
    Operation *op = writer.getOperation();
    Operation *consumer = getSingleUseM0Consumer(op);
    if (!consumer)
      return false;

    unsigned gap = countMachineOpsBetween(op, consumer);
    if (gap >= cfg.m0PipelineDelay)
      return false;

    unsigned movedSlots = 0;
    unsigned missingSlots = cfg.m0PipelineDelay - gap;
    for (Operation *insertBefore = op->getPrevNode(); insertBefore;
         insertBefore = insertBefore->getPrevNode()) {
      if (isM0HoistSearchBoundary(insertBefore))
        break;
      if (!canMoveBefore(op, insertBefore,
                         /*ignoreDeadCandidateSCCWrites=*/true))
        break;
      if (!emitsNoMachineInst(*insertBefore))
        ++movedSlots;
      if (movedSlots < missingSlots)
        continue;
      op->moveBefore(insertBefore);
      return true;
    }
    return false;
  }

  static void hoistM0WritesToFillPipelineGaps(func::FuncOp func,
                                              const HazardConfig &cfg) {
    SmallVector<waveamdmachine::M0WriteHazardOpInterface> writes;
    func.walk([&](waveamdmachine::M0WriteHazardOpInterface writer) {
      writes.push_back(writer);
    });
    for (waveamdmachine::M0WriteHazardOpInterface writer : writes)
      (void)hoistOneM0Write(writer, cfg);
  }

  static Operation *findMovableLgkmFiller(Operation *target) {
    for (Operation *candidate = target->getNextNode(); candidate;
         candidate = candidate->getNextNode()) {
      if (isLgkmFillerSearchBoundary(candidate))
        break;
      if (!canMoveAsLgkmValuFiller(candidate))
        continue;
      if (canMoveBefore(candidate, target))
        return candidate;
    }
    return nullptr;
  }

  static void fillOneLgkmValuGap(waveamdmachine::SWaitcntOp wait,
                                 const HazardConfig &cfg) {
    std::optional<LgkmValuGap> gap = findLgkmValuGap(wait, cfg);
    if (!gap)
      return;
    for (unsigned i = 0; i < gap->missingSlots; ++i) {
      Operation *filler = findMovableLgkmFiller(gap->target);
      if (!filler)
        return;
      filler->moveBefore(gap->target);
    }
  }

  static void fillLgkmValuGaps(func::FuncOp func, const HazardConfig &cfg) {
    SmallVector<waveamdmachine::SWaitcntOp> waits;
    func.walk([&](waveamdmachine::SWaitcntOp wait) { waits.push_back(wait); });
    for (waveamdmachine::SWaitcntOp wait : waits)
      fillOneLgkmValuGap(wait, cfg);
  }

  static bool isSingleMemTokenBarrier(waveamdmachine::SBarrierOp barrier) {
    return barrier->getNumOperands() == 1 && barrier->getNumResults() == 1 &&
           isa<waveamdmachine::MemTokenType>(
               barrier->getOperand(0).getType()) &&
           isa<waveamdmachine::MemTokenType>(barrier->getResult(0).getType());
  }

  static bool isDefaultVmcntOnlyWait(Operation *op, const HazardConfig &cfg) {
    waveamdmachine::SWaitcntOp wait =
        dyn_cast_or_null<waveamdmachine::SWaitcntOp>(op);
    if (!wait || wait.getLgkmcnt() || wait.getExpcnt())
      return false;
    std::optional<uint32_t> vm = wait.getVmcnt();
    return vm && *vm >= llvm::AMDGPU::getVmcntBitMask(cfg.isaVersion);
  }

  static bool contractTokenOnlyBarrierDrain(waveamdmachine::SBarrierOp barrier,
                                            const HazardConfig &cfg) {
    if (!barrier->getParentOfType<waveamdmachine::UniformLoopOp>())
      return false;
    if (!isSingleMemTokenBarrier(barrier))
      return false;
    Operation *wait = barrier->getPrevNode();
    if (!isDefaultVmcntOnlyWait(wait, cfg))
      return false;

    wait->erase();
    return true;
  }

  static bool contractTokenOnlyBarrierDrains(func::FuncOp func,
                                             const HazardConfig &cfg) {
    SmallVector<waveamdmachine::SBarrierOp> barriers;
    func.walk([&](waveamdmachine::SBarrierOp barrier) {
      barriers.push_back(barrier);
    });

    bool changed = false;
    for (waveamdmachine::SBarrierOp barrier : barriers)
      changed |= contractTokenOnlyBarrierDrain(barrier, cfg);
    return changed;
  }

  LogicalResult processFunction(func::FuncOp func, OpBuilder &builder,
                                const HazardConfig &cfg,
                                const llvm::MCSubtargetInfo &sti) {
    if (failed(wave::failIfWaveAMDRegAllocOverflowed(
            func, "waveamd-insert-hazard-waits")))
      return failure();
    if (failed(validateInput(func)))
      return failure();

    (void)contractTokenOnlyBarrierDrains(func, cfg);
    fillLgkmValuGaps(func, cfg);
    hoistM0WritesToFillPipelineGaps(func, cfg);

    DataFlowSolver solver;
    loadBaselineAnalyses(solver);
    solver.load<HazardAnalysis>(cfg);
    if (failed(solver.initializeAndRun(func)))
      return failure();

    rewriteWithSolver(func, solver, cfg, sti, builder);
    return success();
  }
};

} // namespace
