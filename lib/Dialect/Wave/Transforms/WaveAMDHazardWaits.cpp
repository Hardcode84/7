//===- WaveAMDHazardWaits.cpp - WaveAMD hazard waits ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Driver runs after regalloc. Dense forward dataflow tracks the LGKM
// pending bit and SSA-value hazards through CFG and region edges.
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

static std::optional<unsigned> getImmediate(Value value) {
  Operation *def = value.getDefiningOp();
  if (!def || !isa<waveamdmachine::ImmOp>(def))
    return std::nullopt;
  return static_cast<unsigned>(
      def->getAttrOfType<IntegerAttr>("value").getInt());
}

static bool isVMEMStore(Operation &op) {
  return op.hasTrait<OpTrait::waveamdmachine::VMEMStoreOp>();
}

static bool emitsNoMachineInst(Operation &op) {
  return op.hasTrait<OpTrait::waveamdmachine::NoMachineInst>();
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

  // Wait states between an MFMA result becoming readable and a
  // VMEM store consuming it. Conservative worst-case from
  // GCNHazardRecognizer.cpp's MFMA latency tables; per-variant
  // tightening (gfx950 has more granular cases) is left to a
  // future pass that knows the MFMA shape.
  unsigned mfmaResultLatency;
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

// Decode `op` (an `s_waitcnt`) and return the new value of the LGKM
// pending flag, or `nullopt` if the immediate isn't statically known
// (the existing pending value should be kept).
static std::optional<bool> recomputePendingLgkm(Operation &op,
                                                const HazardConfig &cfg) {
  auto imm = getImmediate(op.getOperand(0));
  if (!imm)
    return std::nullopt;
  unsigned vm = 0, exp = 0, lg = 0;
  llvm::AMDGPU::decodeWaitcnt(cfg.isaVersion, *imm, vm, exp, lg);
  return cfg.hasDelayAlu ? lg != cfg.defaultLgkmcnt : true;
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

struct HazardState {
  bool lgkmPending = false;
  DenseMap<Value, ValueHazards> values;

  bool joinWith(const HazardState &rhs) {
    bool changed = false;
    if (rhs.lgkmPending && !lgkmPending) {
      lgkmPending = true;
      changed = true;
    }
    for (auto [value, hazards] : rhs.values) {
      if (hazards.empty())
        continue;
      changed |= values[value].joinWith(hazards);
    }
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
    bool changed = state.lgkmPending || !state.values.empty();
    state = HazardState();
    return changed ? ChangeResult::Change : ChangeResult::NoChange;
  }

  void print(raw_ostream &os) const override {
    os << "lgkm=" << state.lgkmPending << " values=" << state.values.size();
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
}

static void transferHazards(Operation *op, HazardState &state,
                            const HazardConfig &cfg) {
  bool controlFlow = isControlFlowOp(op);
  if (!controlFlow && state.lgkmPending &&
      op->hasTrait<OpTrait::waveamdmachine::VALUOp>())
    state.lgkmPending = false;

  if (!emitsNoMachineInst(*op))
    advanceValueHazards(state);

  if (controlFlow)
    return;

  inheritNoInstOperandHazards(op, state);
  addProducedHazards(op, state, cfg);

  if (isa<waveamdmachine::SWaitcntOp>(op)) {
    std::optional<bool> next = recomputePendingLgkm(*op, cfg);
    if (next)
      state.lgkmPending = *next;
  }
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
  return state.lgkmPending && op->hasTrait<OpTrait::waveamdmachine::VALUOp>();
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
    markCFGSuccessorsLive(op, next);
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
      advanceValueHazards(next);
    propagateRegionOperands(branch, regionFrom, regionTo, next);
    propagateIfChanged(after, after->joinWith(next));
  }

private:
  void markCFGSuccessorsLive(Operation *op, const HazardState &state) {
    if (op->getNumSuccessors() == 0)
      return;
    Block *source = op->getBlock();
    if (!source)
      return;
    for (Block *successor : op->getSuccessors()) {
      HazardState next = state;
      propagateBranchOperands(op, successor, next);
      HazardLattice *blockState = getLattice(getProgramPointBefore(successor));
      propagateIfChanged(blockState, blockState->joinWith(next));
      auto *blockLive =
          getOrCreate<Executable>(getProgramPointBefore(successor));
      propagateIfChanged(blockLive, blockLive->setToLive());
      auto *edgeLive =
          getOrCreate<Executable>(getLatticeAnchor<CFGEdge>(source, successor));
      propagateIfChanged(edgeLive, edgeLive->setToLive());
    }
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
    HazardConfig cfg{
        llvm::AMDGPU::isGFX11Plus(**sti),
        llvm::AMDGPU::getIsaVersion((*sti)->getCPU()),
        /*defaultLgkmcnt=*/0,
        amdgpu_compat::SDelayAlu::encode(
            amdgpu_compat::SDelayAlu::DelayType::VALU, 1),
        /*m0PipelineDelay=*/1,
        /*mfmaResultLatency=*/8,
    };
    cfg.defaultLgkmcnt = llvm::AMDGPU::decodeLgkmcnt(
        cfg.isaVersion, llvm::AMDGPU::getWaitcntBitMask(cfg.isaVersion));
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

    unsigned ssaWait = getRequiredSsaWait(op, local);
    if (ssaWait) {
      insertSNopMitigation(*op, ssaWait, builder, sti);
      advanceValueHazards(local, ssaWait);
    }

    if (needsValuMitigation(op, local)) {
      insertValuMitigation(*op, builder, cfg, sti);
      advanceValueHazards(local);
      local.lgkmPending = false;
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
