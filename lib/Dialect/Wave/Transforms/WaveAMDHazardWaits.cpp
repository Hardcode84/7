//===- WaveAMDHazardWaits.cpp - WaveAMD hazard waits ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Driver: flat pre-order walk over every waveamdmachine op in the
// function (including ops nested in region-bearing ops like
// `uniform_loop`). Two hazard categories run over the same walk:
//
//   - `LinearState`: a pending counter raised by a producer in the
//     walk, decremented by each counted op, consumed by the matching
//     consumer. VALU-after-LGKM uses this shape. The walk is
//     straight-line: cross-block control flow (joins, back-edges) is
//     NOT modelled, so a producer in one branch and consumer after the
//     join can be miscounted. Today's selector keeps these in the
//     same region, so it works in practice.
//
//   - `SsaEdge`: each consumer queries its operands backward via the
//     SSA def-use chain (see `findProducer`). Same-block edges are
//     precise; block-argument edges resolved via a single
//     `BranchOpInterface` hop and `RegionBranchOpInterface`
//     entry/back-edge/exit carries are also handled (so loop-carried
//     producers are traced through `uniform_loop`). The query is
//     idempotent under the loop replay because previously-inserted
//     `s_nop`s count toward the gap. M0-after-`s_mov_m0` and
//     VMEM-store-after-MFMA use this shape.
//
// Design notes: `docs/HazardMitigationDesign.md`.

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/TargetParser/TargetParser.h"
#include "llvm/TargetParser/Triple.h"
#include <functional>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDHAZARDWAITS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

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
  auto module = dyn_cast<ModuleOp>(op);
  if (!module)
    module = op->getParentOfType<ModuleOp>();
  if (!module)
    return op->emitError("waveamd-insert-hazard-waits requires a module");
  auto target = module->getAttrOfType<StringAttr>("waveamdmachine.target");
  if (!target)
    return module.emitError("waveamd-insert-hazard-waits requires a "
                            "waveamdmachine.target attribute");
  StringRef cpu = target.getValue();
  std::pair<StringRef, StringRef> split = cpu.rsplit("--");
  if (!split.second.empty())
    cpu = split.second;

  static llvm::once_flag initializeBackendOnce;
  llvm::call_once(initializeBackendOnce, []() {
    llvm::InitializeAllTargetInfos();
    llvm::InitializeAllTargetMCs();
  });

  llvm::Triple triple("amdgcn-amd-amdhsa");
  std::string error;
  const llvm::Target *llvmTarget =
      llvm::TargetRegistry::lookupTarget(triple, error);
  if (!llvmTarget)
    return op->emitError("failed to lookup AMDGPU target: ") << error;

  std::unique_ptr<llvm::MCSubtargetInfo> sti(
      llvmTarget->createMCSubtargetInfo(triple, cpu, /*Features=*/""));
  if (!sti)
    return module.emitError("unsupported AMDGPU target: ") << target.getValue();
  if (llvm::AMDGPU::getIsaVersion(cpu).Major == 0)
    return module.emitError("unsupported AMDGPU target: ") << target.getValue();
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

// Two execution shapes:
//   - `LinearState`: pending counter raised by a producer, decremented
//     by each counted op, consumed by the matching consumer. Right
//     for hazards with no SSA edge (VALU-after-LGKM-wait: `s_waitcnt`
//     mutates a global counter that every following VALU op sees).
//   - `SsaEdge`: on each consumer, walk back to the producer via the
//     SSA def-use chain and measure the distance in counted ops. Right
//     for hazards where the producer's result feeds a specific
//     consumer operand (M0-after-`s_mov_m0`, MFMA-result-as-VMEM-store).
enum class HazardCategory { LinearState, SsaEdge };

// Strictly between `from` and `to` in the same block: machine-inst
// count, skipping ops tagged `NoMachineInst`. Caller must ensure
// `from` precedes `to` in the same block.
static unsigned countMachineInstsBetween(Operation *from, Operation *to) {
  assert(from->getBlock() == to->getBlock() &&
         "countMachineInstsBetween requires same-block operands");
  unsigned count = 0;
  for (Operation *cur = from->getNextNode(); cur && cur != to;
       cur = cur->getNextNode()) {
    if (!emitsNoMachineInst(*cur))
      ++count;
  }
  return count;
}

// Machine-inst count from the start of `block` up to (but not
// including) `op`. Used by cross-block edge resolution.
static unsigned countFromBlockEntry(Block *block, Operation *op) {
  unsigned count = 0;
  for (Operation &cur : *block) {
    if (&cur == op)
      break;
    if (!emitsNoMachineInst(cur))
      ++count;
  }
  return count;
}

// Result of resolving a producer for an `SsaEdge` consumer operand.
struct SsaEdgeResult {
  Operation *producer;
  unsigned gap;
};

// Successor index of `target` in `terminator`, or nullopt if
// `target` is not a successor.
static std::optional<unsigned> findSuccessorIndex(Operation *terminator,
                                                  Block *target) {
  for (unsigned i = 0, e = terminator->getNumSuccessors(); i < e; ++i) {
    if (terminator->getSuccessor(i) == target)
      return i;
  }
  return std::nullopt;
}

// Resolve a single block-arg predecessor edge to a producer. Returns
// the producer + cumulative gap (producer-to-terminator + terminator +
// `entryToAnchor`), or `nullopt` if the edge is unanalyzable (multi-hop)
// or carries a non-producer value.
static std::optional<SsaEdgeResult>
resolvePredEdge(BranchOpInterface branchOp, unsigned succIdx, unsigned argIdx,
                unsigned entryToAnchor,
                function_ref<bool(Operation &)> isProducer) {
  SuccessorOperands succOps = branchOp.getSuccessorOperands(succIdx);
  if (argIdx >= succOps.size())
    return std::nullopt;
  Value forwarded = succOps[argIdx];
  if (!forwarded)
    return std::nullopt;
  Operation *fwdDef = forwarded.getDefiningOp();
  Operation *terminator = branchOp.getOperation();
  if (!fwdDef || fwdDef->getBlock() != terminator->getBlock())
    return std::nullopt;
  if (!isProducer(*fwdDef))
    return std::nullopt;
  unsigned defToTerm = countMachineInstsBetween(fwdDef, terminator);
  unsigned termGap = emitsNoMachineInst(*terminator) ? 0 : 1;
  return SsaEdgeResult{fwdDef, defToTerm + termGap + entryToAnchor};
}

// Forwarded value + the op that performs the forwarding. The op is
// either the parent `RegionBranchOpInterface` op (entry from parent)
// or a `RegionBranchTerminatorOpInterface` (back-edge or exit). Used
// as the anchor for the recursive walk on the source side; the gap on
// the destination side is added by the caller.
struct RegionBranchSource {
  Value value;
  Operation *sourceOp;
};

// Append every (operand, terminator) pair from terminators inside
// `parentOp`'s regions whose successor list contains `wantedSucc`.
// `extract(succ, ops)` maps a matched successor to the operand chosen
// at the appropriate index.
template <typename ExtractFn>
static void collectFromTerminators(Operation *parentOp,
                                   function_ref<bool(RegionSuccessor)> matches,
                                   ExtractFn extract,
                                   SmallVectorImpl<RegionBranchSource> &out) {
  for (Region &region : parentOp->getRegions()) {
    for (Block &b : region) {
      auto term =
          dyn_cast<RegionBranchTerminatorOpInterface>(b.getTerminator());
      if (!term)
        continue;
      SmallVector<RegionSuccessor> succs;
      SmallVector<Attribute> constOperands(term->getNumOperands(), Attribute());
      term.getSuccessorRegions(constOperands, succs);
      for (RegionSuccessor &succ : succs) {
        if (!matches(succ))
          continue;
        MutableOperandRange ops = term.getMutableSuccessorOperands(succ);
        extract(ops, term.getOperation(), out);
      }
    }
  }
}

// All values that flow into block argument `arg` via region-branch
// interfaces: entry operands from the parent op (loop init) and
// back-edge operands from terminators that branch to `arg`'s region
// (continue_if carry). Empty for blocks that are not the entry block
// of a region.
static SmallVector<RegionBranchSource>
collectRegionBranchSources(BlockArgument arg) {
  SmallVector<RegionBranchSource> sources;
  Block *block = arg.getOwner();
  Region *region = block->getParent();
  if (!region || block != &region->front())
    return sources;
  Operation *parentOp = region->getParentOp();
  if (!parentOp)
    return sources;
  auto regionBranch = dyn_cast<RegionBranchOpInterface>(parentOp);
  if (!regionBranch)
    return sources;
  unsigned argIdx = arg.getArgNumber();
  RegionSuccessor regionSucc(region);
  OperandRange entryOps = regionBranch.getEntrySuccessorOperands(regionSucc);
  if (argIdx < entryOps.size())
    sources.push_back({entryOps[argIdx], parentOp});
  collectFromTerminators(
      parentOp,
      [&](RegionSuccessor succ) {
        return !succ.isParent() && succ.getSuccessor() == region;
      },
      [&](MutableOperandRange ops, Operation *term,
          SmallVectorImpl<RegionBranchSource> &out) {
        if (argIdx < ops.size())
          out.push_back({Value(ops[argIdx].get()), term});
      },
      sources);
  return sources;
}

// All values that flow into op result `v` via the
// `RegionBranchOpInterface`'s exit-to-parent terminators (the carry
// values on the iteration that branches out, mapped positionally to
// the op's results).
static SmallVector<RegionBranchSource> collectRegionResultSources(OpResult v) {
  SmallVector<RegionBranchSource> sources;
  Operation *op = v.getOwner();
  if (!isa<RegionBranchOpInterface>(op))
    return sources;
  unsigned resultIdx = v.getResultNumber();
  collectFromTerminators(
      op, [](RegionSuccessor succ) { return succ.isParent(); },
      [&](MutableOperandRange ops, Operation *term,
          SmallVectorImpl<RegionBranchSource> &out) {
        if (resultIdx < ops.size())
          out.push_back({Value(ops[resultIdx].get()), term});
      },
      sources);
  return sources;
}

// Walk backward from `v` (read at `anchor`) looking for a producer of
// `isProducer`. Handles:
//   - Same-block producer: precise.
//   - Block argument resolved via `BranchOpInterface` predecessor
//     edges (one CFG hop).
//   - Block argument of a region-entry block resolved via
//     `RegionBranchOpInterface` entry operands and any
//     `RegionBranchTerminatorOpInterface` back-edges. The recursion
//     uses a visited set so that pass-through carries (where the
//     terminator forwards the block argument unchanged) do not loop.
// Multi-hop CFG paths and unknown terminators return `nullopt`;
// predecessors that carry a non-producer value contribute no edge but
// don't fail the whole search. The result is the min gap across the
// raising predecessors / region-branch sources.
// Combine a recursive result `sub` with `destSideGap` (count from the
// source op back up to the original consumer's anchor). Keeps the
// smaller of `best` and the new combined edge.
static void mergeEdge(std::optional<SsaEdgeResult> &best,
                      std::optional<SsaEdgeResult> sub, Operation *sourceOp,
                      unsigned destSideGap) {
  if (!sub)
    return;
  unsigned termGap = emitsNoMachineInst(*sourceOp) ? 0 : 1;
  unsigned totalGap = sub->gap + termGap + destSideGap;
  if (!best || totalGap < best->gap)
    best = SsaEdgeResult{sub->producer, totalGap};
}

// Forward declarations for the mutually recursive helpers below.
static std::optional<SsaEdgeResult>
findProducerImpl(Value v, Operation *anchor,
                 function_ref<bool(Operation &)> isProducer,
                 DenseSet<Value> &visited);

// `v` is defined by `def`. If `def` itself is a producer, return the
// edge. Otherwise, if `def` is a `RegionBranchOpInterface` op,
// recurse through its exit-to-parent terminators (the consumer reads
// a value carried out of the loop). Same-block constraint applies.
static std::optional<SsaEdgeResult>
findProducerThroughDef(Operation *def, Value v, Operation *anchor,
                       function_ref<bool(Operation &)> isProducer,
                       DenseSet<Value> &visited) {
  if (def->getBlock() != anchor->getBlock())
    return std::nullopt;
  if (isProducer(*def))
    return SsaEdgeResult{def, countMachineInstsBetween(def, anchor)};
  OpResult res = dyn_cast<OpResult>(v);
  if (!res || !isa<RegionBranchOpInterface>(def))
    return std::nullopt;
  unsigned defToAnchor = countMachineInstsBetween(def, anchor);
  std::optional<SsaEdgeResult> best;
  for (const RegionBranchSource &src : collectRegionResultSources(res))
    mergeEdge(best,
              findProducerImpl(src.value, src.sourceOp, isProducer, visited),
              src.sourceOp, defToAnchor);
  return best;
}

// `blockArg` is a region-entry block argument. Try each
// `BranchOpInterface` predecessor (one CFG hop) and each
// region-branch source (loop init from parent + back-edge from
// `continue_if`-style terminators).
static std::optional<SsaEdgeResult>
findProducerThroughBlockArg(BlockArgument blockArg, Operation *anchor,
                            function_ref<bool(Operation &)> isProducer,
                            DenseSet<Value> &visited) {
  Block *block = blockArg.getOwner();
  unsigned argIdx = blockArg.getArgNumber();
  unsigned entryToAnchor = countFromBlockEntry(block, anchor);
  std::optional<SsaEdgeResult> best;
  for (Block *pred : block->getPredecessors()) {
    auto branchOp = dyn_cast<BranchOpInterface>(pred->getTerminator());
    if (!branchOp)
      return std::nullopt;
    std::optional<unsigned> succIdx =
        findSuccessorIndex(pred->getTerminator(), block);
    if (!succIdx)
      return std::nullopt;
    std::optional<SsaEdgeResult> edge =
        resolvePredEdge(branchOp, *succIdx, argIdx, entryToAnchor, isProducer);
    if (!edge)
      continue;
    if (!best || edge->gap < best->gap)
      best = edge;
  }
  for (const RegionBranchSource &src : collectRegionBranchSources(blockArg))
    mergeEdge(best,
              findProducerImpl(src.value, src.sourceOp, isProducer, visited),
              src.sourceOp, entryToAnchor);
  return best;
}

static std::optional<SsaEdgeResult>
findProducerImpl(Value v, Operation *anchor,
                 function_ref<bool(Operation &)> isProducer,
                 DenseSet<Value> &visited) {
  if (!visited.insert(v).second)
    return std::nullopt;
  if (Operation *def = v.getDefiningOp())
    return findProducerThroughDef(def, v, anchor, isProducer, visited);
  return findProducerThroughBlockArg(cast<BlockArgument>(v), anchor, isProducer,
                                     visited);
}

static std::optional<SsaEdgeResult>
findProducer(Value v, Operation *anchor,
             function_ref<bool(Operation &)> isProducer) {
  DenseSet<Value> visited;
  return findProducerImpl(v, anchor, isProducer, visited);
}

using MitigateFn = std::function<unsigned(
    Operation &op, unsigned pending, OpBuilder &builder,
    const HazardConfig &cfg, const llvm::MCSubtargetInfo &sti)>;

using UpdateFn = std::function<unsigned(Operation &op, unsigned pending,
                                        const HazardConfig &cfg)>;

struct HazardKind {
  StringRef name;
  HazardCategory category;
  // Run at every op. Inserts mitigation if pending is non-zero and the
  // op consumes the hazard; returns updated pending.
  MitigateFn mitigate;
  // Run at every op, after mitigation. Producers raise pending;
  // counted ops decrement (counter kinds) or pass through (flag kinds).
  UpdateFn update;
  // True iff the loop-replay walk should be seeded with this kind's
  // final state. Only linear wait-state hazards persist across the
  // replay; edge-count hazards reset to 0.
  bool persistInReplay;
};

static HazardKind makeValuLgkmHazard() {
  return HazardKind{
      "valu-after-lgkm-wait",
      HazardCategory::LinearState,
      [](Operation &op, unsigned pending, OpBuilder &b, const HazardConfig &cfg,
         const llvm::MCSubtargetInfo &sti) -> unsigned {
        if (!pending || !op.hasTrait<OpTrait::waveamdmachine::VALUOp>())
          return pending;
        insertValuMitigation(op, b, cfg, sti);
        return 0;
      },
      [](Operation &op, unsigned pending, const HazardConfig &cfg) -> unsigned {
        if (!isa<waveamdmachine::SWaitcntOp>(op))
          return pending;
        std::optional<bool> next = recomputePendingLgkm(op, cfg);
        return next ? (*next ? 1u : 0u) : pending;
      },
      /*persistInReplay=*/true,
  };
}

// SsaEdge mitigate: for each hazard-bearing operand on `op`, walk
// back to the producer and emit `requiredGap - currentGap` NOPs if
// the gap isn't already saturated. Re-running this on the same op
// (e.g. on the loop replay) is idempotent because previously
// inserted `s_nop`s themselves count as machine instructions.
//
// Multi-operand consumers (none exist today but the contract is
// here for clarity): the first operand whose edge needs mitigation
// emits the NOPs; subsequent edges see the now-saturated gap and
// skip. If two operands legitimately need different gap sizes, this
// would under-mitigate -- handle that when the case arises.
static unsigned mitigateSsaEdge(Operation &op, OpBuilder &b,
                                const llvm::MCSubtargetInfo &sti,
                                unsigned requiredGap,
                                function_ref<bool(Type)> operandTypeFilter,
                                function_ref<bool(Operation &)> isProducer) {
  for (Value v : op.getOperands()) {
    if (operandTypeFilter && !operandTypeFilter(v.getType()))
      continue;
    auto result = findProducer(v, &op, isProducer);
    if (!result || result->gap >= requiredGap)
      continue;
    insertSNopMitigation(op, requiredGap - result->gap, b, sti);
    return 0;
  }
  return 0;
}

static HazardKind makeM0Hazard() {
  return HazardKind{
      "m0-after-s-mov-m0",
      HazardCategory::SsaEdge,
      [](Operation &op, unsigned, OpBuilder &b, const HazardConfig &cfg,
         const llvm::MCSubtargetInfo &sti) -> unsigned {
        return mitigateSsaEdge(
            op, b, sti, cfg.m0PipelineDelay,
            [](Type t) { return isa<waveamdmachine::M0Type>(t); },
            [](Operation &p) { return isa<waveamdmachine::SMovM0Op>(p); });
      },
      // SsaEdge: no per-op state to advance.
      [](Operation &, unsigned, const HazardConfig &) -> unsigned { return 0; },
      /*persistInReplay=*/false,
  };
}

static HazardKind makeMfmaStoreHazard() {
  return HazardKind{
      "vmem-store-after-mfma",
      HazardCategory::SsaEdge,
      [](Operation &op, unsigned, OpBuilder &b, const HazardConfig &cfg,
         const llvm::MCSubtargetInfo &sti) -> unsigned {
        if (!isVMEMStore(op))
          return 0;
        return mitigateSsaEdge(
            op, b, sti, cfg.mfmaResultLatency,
            // The MFMA result is the only VGPR-typed operand that
            // carries this hazard, but the producer match alone is
            // enough -- filter accepts every operand.
            /*operandTypeFilter=*/nullptr, [](Operation &p) {
              return p.hasTrait<OpTrait::waveamdmachine::MFMAOp>();
            });
      },
      [](Operation &, unsigned, const HazardConfig &) -> unsigned { return 0; },
      /*persistInReplay=*/false,
  };
}

// Order matters only for mitigation insertion at a single op site
// (the inserted NOPs appear in catalog order between the cursor and
// `op`). Match the legacy order (M0, MFMA-store, VALU-LGKM) so any
// future CHECK that depends on instruction-pile ordering keeps
// matching.
static SmallVector<HazardKind> buildHazardCatalog(const HazardConfig &) {
  SmallVector<HazardKind> catalog;
  catalog.push_back(makeM0Hazard());
  catalog.push_back(makeMfmaStoreHazard());
  catalog.push_back(makeValuLgkmHazard());
  return catalog;
}

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
  // True for ops that must not appear in `wave.kernel` funcs at this stage
  // (ABI lowering should have replaced them).
  static bool isUnloweredKernelArg(Operation &op, func::FuncOp func) {
    return func->hasAttr(wave::WaveDialect::getKernelAttrName()) &&
           isa<waveamdmachine::ArgOp>(op);
  }
  // True for scalar memory loads missing the required `base` attribute.
  static bool isMalformedSMEMLoad(Operation &op) {
    return isa<waveamdmachine::SLoadB32Op, waveamdmachine::SLoadB64Op,
               waveamdmachine::SLoadB128Op>(op) &&
           !op.getAttrOfType<StringAttr>("base");
  }

  // Pre-order walk over every waveamdmachine op in `func`, including
  // ops nested inside structured regions. Diagnoses malformed input.
  LogicalResult collectOps(func::FuncOp func,
                           SmallVectorImpl<Operation *> &ops) {
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

  // Drive each catalog entry over `ops`. Returns the per-kind pending
  // state after the last op; the caller uses it to decide whether a
  // loop-replay walk is required.
  static SmallVector<unsigned>
  processOnce(ArrayRef<HazardKind> catalog, ArrayRef<Operation *> ops,
              ArrayRef<unsigned> initial, OpBuilder &builder,
              const HazardConfig &cfg, const llvm::MCSubtargetInfo &sti) {
    SmallVector<unsigned> state(initial.begin(), initial.end());
    for (Operation *op : ops) {
      for (size_t i = 0, e = catalog.size(); i < e; ++i)
        state[i] = catalog[i].mitigate(*op, state[i], builder, cfg, sti);
      for (size_t i = 0, e = catalog.size(); i < e; ++i)
        state[i] = catalog[i].update(*op, state[i], cfg);
    }
    return state;
  }

  LogicalResult processFunction(func::FuncOp func, OpBuilder &builder,
                                const HazardConfig &cfg,
                                const llvm::MCSubtargetInfo &sti) {
    SmallVector<Operation *> ops;
    if (failed(collectOps(func, ops)))
      return failure();

    SmallVector<HazardKind> catalog = buildHazardCatalog(cfg);
    SmallVector<unsigned> zero(catalog.size(), 0);

    SmallVector<unsigned> finalState =
        processOnce(catalog, ops, zero, builder, cfg, sti);

    // Loop replay: a back-edge can carry a kind's pending state from
    // the body's tail back to the top, so kinds flagged
    // `persistInReplay` get a second walk seeded with their final
    // state. Edge-count hazards reset to 0 in the replay.
    if (!containsLoop(func))
      return success();
    SmallVector<unsigned> replaySeed(catalog.size(), 0);
    bool anyPersisted = false;
    for (size_t i = 0, e = catalog.size(); i < e; ++i) {
      if (catalog[i].persistInReplay && finalState[i]) {
        replaySeed[i] = finalState[i];
        anyPersisted = true;
      }
    }
    if (anyPersisted)
      processOnce(catalog, ops, replaySeed, builder, cfg, sti);
    return success();
  }

  static bool containsLoop(func::FuncOp func) {
    bool found = false;
    func.walk([&](waveamdmachine::UniformLoopOp) {
      found = true;
      return WalkResult::interrupt();
    });
    return found;
  }
};

} // namespace
