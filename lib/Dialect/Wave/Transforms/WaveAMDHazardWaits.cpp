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
#include "mlir/Analysis/DataFlow/DenseAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/TargetParser/TargetParser.h"
#include "llvm/TargetParser/Triple.h"
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDHAZARDWAITS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::dataflow;

namespace {

//===----------------------------------------------------------------------===//
// Vendored AMDGPU hazard-delay encodings.
//
// Mirrors `llvm::AMDGPU::SNop` and `llvm::AMDGPU::SDelayAlu`, introduced
// upstream on the wave-dsl branch in commit 6490bb708b51 ("[mlir][wave]
// Share AMDGPU hazard delay encodings") but not yet merged into
// llvm/llvm-project main. When that commit lands, delete this block and
// replace `amdgpu_compat::` with `llvm::AMDGPU::` at the call sites below.
//===----------------------------------------------------------------------===//
namespace amdgpu_compat {
namespace SDelayAlu {

enum class DelayType { None, VALU, TRANS32, SALU };

inline unsigned encodeDelay(DelayType Type, unsigned Count) {
  switch (Type) {
  case DelayType::None:
    return 0;
  case DelayType::VALU:
    assert(Count < 5 && "VALU dependency id must fit s_delay_alu");
    return Count;
  case DelayType::TRANS32:
    assert(Count < 4 && "TRANS32 dependency id must fit s_delay_alu");
    return Count + 4;
  case DelayType::SALU:
    assert(Count < 4 && "SALU cycle id must fit s_delay_alu");
    return Count + 8;
  }
  llvm_unreachable("unknown s_delay_alu delay type");
}

inline unsigned encode(DelayType Type0, unsigned Count0, unsigned Skip = 0,
                       DelayType Type1 = DelayType::None, unsigned Count1 = 0) {
  unsigned Encoded = encodeDelay(Type0, Count0);
  unsigned Second = encodeDelay(Type1, Count1);
  if (!Second)
    return Encoded;
  assert(Skip < 8 && "skip count must fit s_delay_alu");
  return Encoded | (Skip << 4) | (Second << 7);
}

} // namespace SDelayAlu

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
createSubtargetInfo(Operation *op) {
  FailureOr<waveamdmachine::AMDGPUTarget> target =
      waveamdmachine::getAMDGPUTarget(op, "waveamd-insert-hazard-waits");
  if (failed(target))
    return failure();

  static llvm::once_flag initializeBackendOnce;
  llvm::call_once(initializeBackendOnce, []() {
    llvm::InitializeAllTargetInfos();
    llvm::InitializeAllTargetMCs();
  });

  llvm::Triple triple(target->triple);
  std::string error;
  const llvm::Target *llvmTarget =
      llvm::TargetRegistry::lookupTarget(triple, error);
  if (!llvmTarget)
    return op->emitError("failed to lookup AMDGPU target: ") << error;

  std::unique_ptr<llvm::MCSubtargetInfo> sti(
      llvmTarget->createMCSubtargetInfo(triple, target->chip, /*Features=*/""));
  if (!sti)
    return op->emitError("unsupported AMDGPU target: ")
           << target->triple << "--" << target->chip;
  if (llvm::AMDGPU::getIsaVersion(target->chip).Major == 0)
    return op->emitError("unsupported AMDGPU target: ")
           << target->triple << "--" << target->chip;
  return sti;
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

static unsigned getMfmaStoreLatency(const llvm::AMDGPU::IsaVersion &isa) {
  if (isCDNA3Family(isa))
    return 7;
  if (isCDNA4Family(isa))
    return 8;
  return 8;
}

static unsigned getMfmaSrcABLatency(const llvm::AMDGPU::IsaVersion &isa) {
  if (isCDNA3Family(isa))
    return 7;
  if (isCDNA4Family(isa))
    return 8;
  return 8;
}

static unsigned getMfmaSrcCOverlapLatency(const llvm::AMDGPU::IsaVersion &isa) {
  if (isCDNA3Family(isa))
    return 5;
  if (isCDNA4Family(isa))
    return 6;
  return 6;
}

static unsigned getMfmaSrcCReadWarLatency(const llvm::AMDGPU::IsaVersion &isa) {
  return isCDNA3Family(isa) || isCDNA4Family(isa) ? 3 : 0;
}

static unsigned getValuWriteVGPRMfmaLatency() { return 2; }

static unsigned
getValuWriteVGPRReadlaneLatency(const llvm::AMDGPU::IsaVersion &isa) {
  return isCDNA3Family(isa) || isCDNA4Family(isa) ? 1 : 0;
}

static unsigned
getValuWriteSGPRValuReadLatency(const llvm::AMDGPU::IsaVersion &isa) {
  return isCDNA3Family(isa) || isCDNA4Family(isa) ? 2 : 0;
}

static unsigned getValuWriteSGPRVmemReadLatency() { return 5; }

static unsigned
getValuWriteExecMfmaLatency(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 ? 4 : 0;
}

struct HazardConfig {
  bool hasDelayAlu;
  llvm::AMDGPU::IsaVersion isaVersion;
  unsigned defaultLgkmcnt;
  unsigned valuDep1;

  // Wait states between `s_mov_m0` and the next op reading `m0`.
  // One pipeline slot on every AMDGPU ISA that exposes M0; see
  // GCNHazardRecognizer.cpp's setreg / m0-write hazard checks.
  unsigned m0PipelineDelay;

  // 4-pass XDL write -> VMEM/VALU: CDNA3 Table 37 = 7, CDNA4 Table 38 = 8.
  unsigned mfmaResultLatency;
  // Mirrors LLVM AMDGPU GCNHazardRecognizer CDNA post-RA waits.
  unsigned mfmaSrcABLatency;
  unsigned mfmaSrcCOverlapLatency;
  unsigned mfmaSrcCReadWarLatency;
  unsigned valuWriteVGPRMfmaLatency;
  unsigned valuWriteVGPRReadlaneLatency;
  unsigned valuWriteSGPRValuReadLatency;
  unsigned valuWriteSGPRVmemReadLatency;
  unsigned valuWriteExecMfmaLatency;
};

// Insert `count` `s_nop`s right before `op`.
static void insertSNopMitigation(Operation &op, unsigned count, OpBuilder &b,
                                 const llvm::MCSubtargetInfo &sti) {
  b.setInsertionPoint(&op);
  insertNoops(b, op.getLoc(), count, sti);
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

  bool empty() const { return m0 == 0 && mfmaStore == 0; }

  bool joinWith(ValueHazards rhs) {
    unsigned nextM0 = std::max(m0, rhs.m0);
    unsigned nextMfmaStore = std::max(mfmaStore, rhs.mfmaStore);
    bool changed = nextM0 != m0 || nextMfmaStore != mfmaStore;
    m0 = nextM0;
    mfmaStore = nextMfmaStore;
    return changed;
  }

  void advance(unsigned count) {
    m0 = m0 > count ? m0 - count : 0;
    mfmaStore = mfmaStore > count ? mfmaStore - count : 0;
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
  ValuWriteVGPR,
  ValuWriteSGPR,
  StoreWriteData,
};

struct PhysicalHazard {
  RegSpan span;
  PhysicalHazardKind kind;
  unsigned limit = 0;
  unsigned remaining = 0;
};

struct HazardState {
  unsigned lgkmToValu = 0;
  unsigned lgkmPending = 0;
  DenseMap<Value, ValueHazards> values;
  SmallVector<PhysicalHazard, 16> physical;
  unsigned valuWriteVcc = 0;
  unsigned execToMfma = 0;

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
      return changed;
    }
    physical.push_back(hazard);
    return true;
  }

  bool joinWith(const HazardState &rhs) {
    bool changed = false;
    changed |= joinMax(lgkmToValu, rhs.lgkmToValu);
    changed |= joinMax(lgkmPending, rhs.lgkmPending);
    for (auto [value, hazards] : rhs.values) {
      if (hazards.empty())
        continue;
      changed |= values[value].joinWith(hazards);
    }
    for (const PhysicalHazard &hazard : rhs.physical)
      changed |= joinPhysicalHazard(hazard);
    changed |= joinMax(valuWriteVcc, rhs.valuWriteVcc);
    changed |= joinMax(execToMfma, rhs.execToMfma);
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
                   !state.values.empty() || !state.physical.empty() ||
                   state.valuWriteVcc || state.execToMfma;
    state = HazardState();
    return changed ? ChangeResult::Change : ChangeResult::NoChange;
  }

  void print(raw_ostream &os) const override {
    os << "lgkm=" << state.lgkmToValu << " pending=" << state.lgkmPending
       << " values=" << state.values.size()
       << " physical=" << state.physical.size() << " vcc=" << state.valuWriteVcc
       << " exec=" << state.execToMfma;
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
  for (auto &entry : llvm::make_early_inc_range(state.values)) {
    entry.second.advance(count);
    if (entry.second.empty())
      state.values.erase(entry.first);
  }
}

static std::optional<RegSpan> getAllocatedRegSpan(Value value) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || type.getIndex() < 0)
    return std::nullopt;
  return RegSpan{type.getRegClass(), type.getIndex(),
                 type.getIndex() + type.getWidth()};
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

static void mergePhysicalHazard(HazardState &state, PhysicalHazard hazard) {
  if (hazard.remaining == 0)
    return;
  for (PhysicalHazard &existing : state.physical) {
    if (!(existing.span == hazard.span) || existing.kind != hazard.kind)
      continue;
    existing.limit = std::max(existing.limit, hazard.limit);
    existing.remaining = std::max(existing.remaining, hazard.remaining);
    return;
  }
  state.physical.push_back(hazard);
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
  state.execToMfma = state.execToMfma > count ? state.execToMfma - count : 0;
}

static void advanceHazards(HazardState &state, unsigned count = 1,
                           bool advanceLgkm = true) {
  if (advanceLgkm)
    state.lgkmToValu = state.lgkmToValu > count ? state.lgkmToValu - count : 0;
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
               : RegionSuccessor::parent();

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

static bool isLegacyVALU(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::VALUOp>() && !isMFMA(op);
}

static bool isVMEM(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::VMEMLoadOp>() ||
         op->hasTrait<OpTrait::waveamdmachine::VMEMStoreOp>();
}

static waveamdmachine::WaitcntInfo getWaitcntInfo(Operation *op) {
  if (waveamdmachine::WaitcntInfoOpInterface info =
          dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo();
  return {};
}

static bool issuesLdsWaitcnt(Operation *op) {
  return getWaitcntInfo(op).event == waveamdmachine::WaitcntEvent::Lds;
}

static bool isMfmaResultHazardConsumer(Operation *op) {
  return isVMEM(op) || issuesLdsWaitcnt(op) || isLegacyVALU(op);
}

struct StoreWriteDataHazard {
  Value data;
  unsigned latency;
};

static bool isSGPROffset(Value value) {
  waveamdmachine::RegType regType =
      dyn_cast<waveamdmachine::RegType>(value.getType());
  return regType && regType.getRegClass() == waveamdmachine::RegClass::SGPR;
}

static Value getWideBufferStoreSoffset(Operation *op) {
  if (waveamdmachine::BufferStoreB96Op store =
          dyn_cast<waveamdmachine::BufferStoreB96Op>(op))
    return store.getSoffset();
  if (waveamdmachine::BufferStoreB128Op store =
          dyn_cast<waveamdmachine::BufferStoreB128Op>(op))
    return store.getSoffset();
  return {};
}

static unsigned
getStoreWriteDataLatency(Operation *op,
                         const llvm::AMDGPU::IsaVersion &isaVersion) {
  if (!isCDNA3Family(isaVersion) && !isCDNA4Family(isaVersion))
    return 1;
  // LLVM gfx940-family keeps a shorter measured window for SGPR SOFFSET.
  if (Value soffset = getWideBufferStoreSoffset(op);
      soffset && isSGPROffset(soffset))
    return 1;
  return 2;
}

static std::optional<StoreWriteDataHazard>
getStoreWriteDataHazard(Operation *op,
                        const llvm::AMDGPU::IsaVersion &isaVersion) {
  if (!llvm::isa<
          waveamdmachine::GlobalStoreB96Op, waveamdmachine::GlobalStoreB128Op,
          waveamdmachine::GlobalStoreB96Addr64Op,
          waveamdmachine::GlobalStoreB128Addr64Op,
          waveamdmachine::BufferStoreB96Op, waveamdmachine::BufferStoreB128Op>(
          op))
    return std::nullopt;
  return StoreWriteDataHazard{op->getOperand(1),
                              getStoreWriteDataLatency(op, isaVersion)};
}

static unsigned getVGPRWriteHazardLimit(const HazardConfig &cfg) {
  return std::max(cfg.valuWriteVGPRMfmaLatency,
                  cfg.valuWriteVGPRReadlaneLatency);
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
  if (operandIndex != 2)
    return waitForHazardAge(hazard, cfg.mfmaSrcABLatency);
  if (use == hazard.span)
    return 0;
  return waitForHazardAge(hazard, cfg.mfmaSrcCOverlapLatency);
}

static unsigned getNonMfmaUseWait(Operation *op, RegSpan use,
                                  const PhysicalHazard &hazard,
                                  const HazardConfig &cfg) {
  if (hazard.kind == PhysicalHazardKind::MfmaWrite &&
      isMfmaResultHazardConsumer(op))
    return waitForHazardAge(hazard, cfg.mfmaResultLatency);

  if (hazard.kind == PhysicalHazardKind::ValuWriteVGPR &&
      isa<waveamdmachine::VReadfirstlaneB32Op>(op))
    return waitForHazardAge(hazard, cfg.valuWriteVGPRReadlaneLatency);

  if (hazard.kind == PhysicalHazardKind::ValuWriteSGPR && isSGPRSpan(use)) {
    if (isVMEM(op))
      return waitForHazardAge(hazard, cfg.valuWriteSGPRVmemReadLatency);
    if (isLegacyVALU(op))
      return waitForHazardAge(hazard, cfg.valuWriteSGPRValuReadLatency);
  }

  return 0;
}

static unsigned getPhysicalUseWait(Operation *op, unsigned operandIndex,
                                   RegSpan use, const PhysicalHazard &hazard,
                                   const HazardConfig &cfg) {
  if (!overlaps(use, hazard.span))
    return 0;
  if (isMFMA(op))
    return getMfmaUseWait(operandIndex, use, hazard, cfg);
  return getNonMfmaUseWait(op, use, hazard, cfg);
}

static unsigned getPhysicalDefWait(Operation *op, RegSpan def,
                                   const PhysicalHazard &hazard,
                                   const HazardConfig &cfg) {
  if (!overlaps(def, hazard.span))
    return 0;

  if (hazard.kind == PhysicalHazardKind::MfmaWrite &&
      isMfmaResultHazardConsumer(op))
    return waitForHazardAge(hazard, cfg.mfmaResultLatency);

  if (hazard.kind == PhysicalHazardKind::MfmaSrcCRead && isLegacyVALU(op))
    return waitForHazardAge(hazard, cfg.mfmaSrcCReadWarLatency);

  if (hazard.kind == PhysicalHazardKind::StoreWriteData &&
      op->hasTrait<OpTrait::waveamdmachine::VALUOp>() && isVGPRSpan(def))
    return waitForHazardAge(hazard, hazard.limit);

  return 0;
}

static unsigned getOperandPhysicalWait(Operation *op, const HazardState &state,
                                       const HazardConfig &cfg) {
  unsigned wait = 0;
  for (auto [operandIndex, operand] : llvm::enumerate(op->getOperands())) {
    std::optional<RegSpan> span = getAllocatedRegSpan(operand);
    if (!span)
      continue;
    for (const PhysicalHazard &hazard : state.physical)
      wait = std::max(wait,
                      getPhysicalUseWait(op, operandIndex, *span, hazard, cfg));
  }
  return wait;
}

static unsigned getResultPhysicalWait(Operation *op, const HazardState &state,
                                      const HazardConfig &cfg) {
  unsigned wait = 0;
  for (Value result : op->getResults()) {
    std::optional<RegSpan> span = getAllocatedRegSpan(result);
    if (!span)
      continue;
    for (const PhysicalHazard &hazard : state.physical)
      wait = std::max(wait, getPhysicalDefWait(op, *span, hazard, cfg));
  }
  return wait;
}

static unsigned getVccReadWait(Operation *op, const HazardState &state) {
  if (!op->hasTrait<OpTrait::waveamdmachine::VALUOp>())
    return 0;
  for (Value operand : op->getOperands()) {
    auto type = dyn_cast<waveamdmachine::RegType>(operand.getType());
    if (type && type.getRegClass() == waveamdmachine::RegClass::VCC)
      return state.valuWriteVcc;
  }
  return 0;
}

static unsigned getRequiredPhysicalWait(Operation *op, const HazardState &state,
                                        const HazardConfig &cfg) {
  if (isControlFlowOp(op))
    return 0;

  unsigned wait = 0;
  if (isMFMA(op))
    wait = std::max(wait, state.execToMfma);
  wait = std::max(wait, getOperandPhysicalWait(op, state, cfg));
  wait = std::max(wait, getResultPhysicalWait(op, state, cfg));
  return std::max(wait, getVccReadWait(op, state));
}

static void addPhysicalHazard(HazardState &state, RegSpan span,
                              PhysicalHazardKind kind, unsigned limit) {
  mergePhysicalHazard(state,
                      PhysicalHazard{/*span=*/span, /*kind=*/kind,
                                     /*limit=*/limit, /*remaining=*/limit});
}

static void addProducedMfmaPhysicalHazards(Operation *op, HazardState &state,
                                           const HazardConfig &cfg) {
  for (Value result : op->getResults())
    if (std::optional<RegSpan> span = getAllocatedRegSpan(result))
      addPhysicalHazard(state, *span, PhysicalHazardKind::MfmaWrite,
                        cfg.mfmaResultLatency);
  if (!cfg.mfmaSrcCReadWarLatency)
    return;
  waveamdmachine::MMAOpInterface mma =
      dyn_cast<waveamdmachine::MMAOpInterface>(op);
  if (!mma)
    return;
  if (std::optional<RegSpan> span = getAllocatedRegSpan(mma.getAcc()))
    addPhysicalHazard(state, *span, PhysicalHazardKind::MfmaSrcCRead,
                      cfg.mfmaSrcCReadWarLatency);
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

static bool isCopiedVccCompareSGPRResult(Operation *op, unsigned resultIndex) {
  if (resultIndex != 0)
    return false;
  return isa<waveamdmachine::VCmpEqU32VccOp, waveamdmachine::VCmpNeU32VccOp,
             waveamdmachine::VCmpLtU32VccOp, waveamdmachine::VCmpLeU32VccOp,
             waveamdmachine::VCmpGtU32VccOp, waveamdmachine::VCmpGeU32VccOp,
             waveamdmachine::VCmpLtI32VccOp, waveamdmachine::VCmpLeI32VccOp,
             waveamdmachine::VCmpGtI32VccOp, waveamdmachine::VCmpGeI32VccOp>(
      op);
}

static void addProducedValuPhysicalHazards(Operation *op, HazardState &state,
                                           const HazardConfig &cfg) {
  if (op->hasTrait<OpTrait::waveamdmachine::WritesExecOp>())
    state.execToMfma = std::max(state.execToMfma, cfg.valuWriteExecMfmaLatency);
  for (auto [resultIndex, result] : llvm::enumerate(op->getResults())) {
    if (isCopiedVccCompareSGPRResult(op, resultIndex))
      continue;
    addProducedValuRegHazard(result, state, cfg);
  }
}

static void addProducedStorePhysicalHazards(Operation *op, HazardState &state,
                                            const HazardConfig &cfg) {
  std::optional<StoreWriteDataHazard> hazard =
      getStoreWriteDataHazard(op, cfg.isaVersion);
  if (!hazard)
    return;
  if (std::optional<RegSpan> span = getAllocatedRegSpan(hazard->data))
    addPhysicalHazard(state, *span, PhysicalHazardKind::StoreWriteData,
                      hazard->latency);
}

static void addProducedPhysicalHazards(Operation *op, HazardState &state,
                                       const HazardConfig &cfg) {
  if (isMFMA(op)) {
    addProducedMfmaPhysicalHazards(op, state, cfg);
    return;
  }
  if (isLegacyVALU(op))
    addProducedValuPhysicalHazards(op, state, cfg);
  addProducedStorePhysicalHazards(op, state, cfg);
}

static void addProducedHazards(Operation *op, HazardState &state,
                               const HazardConfig &cfg) {
  if (isa<waveamdmachine::SMovM0Op>(op)) {
    for (Value result : op->getResults())
      mergeValueHazards(state, result,
                        {/*m0=*/cfg.m0PipelineDelay,
                         /*mfmaStore=*/0});
  }
  if (op->hasTrait<OpTrait::waveamdmachine::MFMAOp>()) {
    for (Value result : op->getResults())
      mergeValueHazards(state, result,
                        {/*m0=*/0,
                         /*mfmaStore=*/cfg.mfmaResultLatency});
  }
  addProducedPhysicalHazards(op, state, cfg);
}

static unsigned getMaxTrackedLgkmPending(const HazardConfig &cfg) {
  return cfg.defaultLgkmcnt + 1;
}

static void addPendingLgkmIssue(Operation *op, HazardState &state,
                                const HazardConfig &cfg) {
  waveamdmachine::WaitcntInfo info = getWaitcntInfo(op);
  if (info.counter != waveamdmachine::WaitcntCounter::Lgkm || !info.issueCount)
    return;
  unsigned maxTrackedPending = getMaxTrackedLgkmPending(cfg);
  state.lgkmPending = std::min(
      maxTrackedPending,
      state.lgkmPending + std::min(info.issueCount, maxTrackedPending));
}

static void applyLgkmWait(Operation *op, HazardState &state,
                          const HazardConfig &cfg) {
  std::optional<unsigned> limit = getLgkmWaitLimit(*op);
  if (!limit || *limit >= cfg.defaultLgkmcnt)
    return;
  bool drained = state.lgkmPending > *limit;
  state.lgkmPending = std::min(state.lgkmPending, *limit);
  if (drained)
    state.lgkmToValu = std::max(state.lgkmToValu, 1u);
}

static void transferHazards(Operation *op, HazardState &state,
                            const HazardConfig &cfg) {
  bool controlFlow = isControlFlowOp(op);
  if (!emitsNoMachineInst(*op))
    advanceHazards(state, /*count=*/1, /*advanceLgkm=*/!controlFlow);

  if (controlFlow)
    return;

  inheritNoInstOperandHazards(op, state);
  addProducedHazards(op, state, cfg);
  addPendingLgkmIssue(op, state, cfg);
  applyLgkmWait(op, state, cfg);
}

static unsigned getRequiredSsaWait(Operation *op, const HazardState &state) {
  if (isControlFlowOp(op))
    return 0;
  unsigned wait = 0;
  bool vmemStore = isVMEMStore(*op);
  for (Value operand : op->getOperands()) {
    ValueHazards hazards = lookupValueHazards(state, operand);
    if (isa<waveamdmachine::M0Type>(operand.getType()))
      wait = std::max(wait, hazards.m0);
    if (vmemStore)
      wait = std::max(wait, hazards.mfmaStore);
  }
  return wait;
}

static bool needsValuMitigation(Operation *op, const HazardState &state) {
  return state.lgkmToValu && op->hasTrait<OpTrait::waveamdmachine::VALUOp>();
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

struct WaveAMDHazardWaitsPass
    : public wave::impl::WaveAMDHazardWaitsBase<WaveAMDHazardWaitsPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    OpBuilder builder(root->getContext());
    FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
        createSubtargetInfo(root);
    if (failed(sti))
      return signalPassFailure();
    llvm::AMDGPU::IsaVersion isaVersion =
        llvm::AMDGPU::getIsaVersion((*sti)->getCPU());
    HazardConfig cfg{
        llvm::AMDGPU::isGFX11Plus(**sti),
        isaVersion,
        llvm::AMDGPU::decodeLgkmcnt(
            isaVersion, llvm::AMDGPU::getWaitcntBitMask(isaVersion)),
        amdgpu_compat::SDelayAlu::encode(
            amdgpu_compat::SDelayAlu::DelayType::VALU, 1),
        /*m0PipelineDelay=*/1,
        /*mfmaResultLatency=*/getMfmaStoreLatency(isaVersion),
        /*mfmaSrcABLatency=*/getMfmaSrcABLatency(isaVersion),
        /*mfmaSrcCOverlapLatency=*/getMfmaSrcCOverlapLatency(isaVersion),
        /*mfmaSrcCReadWarLatency=*/getMfmaSrcCReadWarLatency(isaVersion),
        /*valuWriteVGPRMfmaLatency=*/getValuWriteVGPRMfmaLatency(),
        /*valuWriteVGPRReadlaneLatency=*/
        getValuWriteVGPRReadlaneLatency(isaVersion),
        /*valuWriteSGPRValuReadLatency=*/
        getValuWriteSGPRValuReadLatency(isaVersion),
        /*valuWriteSGPRVmemReadLatency=*/getValuWriteSGPRVmemReadLatency(),
        /*valuWriteExecMfmaLatency=*/getValuWriteExecMfmaLatency(isaVersion),
    };
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
      if (op->getName().getDialectNamespace() ==
          waveamdmachine::WaveAMDMachineDialect::getDialectNamespace())
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

  LogicalResult processFunction(func::FuncOp func, OpBuilder &builder,
                                const HazardConfig &cfg,
                                const llvm::MCSubtargetInfo &sti) {
    if (failed(wave::failIfWaveAMDRegAllocOverflowed(
            func, "waveamd-insert-hazard-waits")))
      return failure();
    if (failed(validateInput(func)))
      return failure();

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
