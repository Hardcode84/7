//===- WaveMachineWaitcnt.cpp - WaveMachine waitcnt insertion ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Token-based waitcnt insertion for WaveMachine IR.
//
// The pass tracks in-flight memory operations through SSA "memory tokens" as
// described in `docs/AMDGPUExplicitWaveProgrammingModel.md` ("Memory Tokens").
// Each token's identity is an SSA `Value`: a memory op's register result, its
// explicit `!wavemachine.mem.token` result when it has one, or a block /
// region argument that a branch propagates from one of those. Token-derivation
// ops (`wavemachine.after`, `wavemachine.token_join`, `wavemachine.barrier`'s
// deps) produce a fresh value-token whose drain position is the MIN of the
// joined source positions.
//
// At each program point the lattice carries a sorted list of
// `(value, counter, position)` entries, one per in-flight token. `position`
// counts the *newer* same-counter issues queued behind that token:
// `vmcnt(position)` is the exact wait that drains it. Per-counter "unknown"
// sentinels (`value == nullptr`) cover tokens whose defining block does not
// dominate the current program point.
//
// Transfer rules (per op):
//   * memory-producing op: bump positions of *same-counter* tokens, then
//     insert a fresh `(result-value, counter, 0)` entry for every
//     memory-relevant result (register and explicit MemToken). The token's
//     identity is the result `Value` itself, so a consumer reading that
//     value finds its TokenState directly without any external map;
//   * token-joining op (`wavemachine.after` / `wavemachine.token_join` /
//     `wavemachine.barrier` with dependencies): the result value's
//     TokenState is the per-counter MIN of the operand values' TokenStates.
//     No new memory event is recorded;
//   * consumer op: for each operand value, demand the wait its TokenState
//     entry requires per counter. Aggregate per-counter requirements by
//     MIN of positions (the tightest count that drains every required
//     token), emit `s_waitcnt`/`s_waitcnt_vscnt` ahead of the op, and drop
//     drained tokens from the lattice;
//   * control-flow ops (`RegionBranchOpInterface`,
//     `RegionBranchTerminatorOpInterface`, `BranchOpInterface`) pass
//     operands to successors instead of reading them, so they do NOT
//     consume tokens locally. The dataflow framework's block/region
//     transfer hooks handle the operand-to-successor token remapping.
//
// CFG transfer rules (`visitBlockTransfer` /
// `visitRegionBranchControlFlowTransfer`):
//   * for every branch-operand -> successor-value pair, create a new
//     TokenState keyed on the destination value, carrying the operand's
//     position. This is the only way block args / region args get a
//     position;
//   * tokens whose defining block does not dominate the successor
//     "escape" and collapse into a single per-counter unknown sentinel
//     at the minimum escaping position;
//   * merging two predecessor states takes the elementwise MIN over
//     positions per `(counter, value)` pair. MIN is the tight bound:
//     `vmcnt(N)` drains a token correctly on every path where the
//     runtime position is at-or-above `N`, so the smallest position
//     observed across paths is the safest static wait.
//
// `wavemachine.s_endpgm` implicitly waits `vscnt(0)` so the kernel does
// not return with VMEM stores still in flight.
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Analysis/DataFlow/DenseAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveMachine/IR/WaveMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Dominance.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"
#include "llvm/TargetParser/TargetParser.h"
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDTICKETWAITS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::dataflow;
using namespace mlir::wave;

namespace {

//===----------------------------------------------------------------------===//
// Counter and token model
//===----------------------------------------------------------------------===//

enum class Counter : unsigned { Vmem = 0, Lgkm = 1, Vscnt = 2 };
static constexpr unsigned kNumCounters = 3;
static constexpr unsigned kSaturatePosition = 63;

// One reaching token entry. Sorted by (counter, id) to keep merge O(n)
// and lookup O(log n). `id` is the SSA `Value` whose runtime ready-ness
// this token tracks; the null Value is a per-counter "unknown" sentinel.
struct Token {
  Value id;
  Counter counter;
  unsigned position;

  bool isUnknown() const { return !id; }
};

static bool sortKey(const Token &a, const Token &b) {
  if (a.counter != b.counter)
    return static_cast<unsigned>(a.counter) < static_cast<unsigned>(b.counter);
  return a.id.getAsOpaquePointer() < b.id.getAsOpaquePointer();
}

static bool sameKey(const Token &a, const Token &b) {
  return a.counter == b.counter && a.id == b.id;
}

// Required wait per counter computed at a consumer op.
struct WaitRequirement {
  std::optional<unsigned> vmcnt;
  std::optional<unsigned> lgkmcnt;
  std::optional<unsigned> vscnt;

  bool hasWait() const { return vmcnt || lgkmcnt || vscnt; }

  std::optional<unsigned> &slotFor(Counter c) {
    switch (c) {
    case Counter::Vmem:
      return vmcnt;
    case Counter::Lgkm:
      return lgkmcnt;
    case Counter::Vscnt:
      return vscnt;
    }
    llvm_unreachable("bad counter");
  }

  // The wait that satisfies all required tokens of `counter`. AMDGPU's
  // `s_waitcnt cnt(N)` drains tokens whose position is >= N, so the
  // tight bound is the MIN over required positions.
  void requireDrain(Counter counter, unsigned position) {
    auto &slot = slotFor(counter);
    if (!slot || position < *slot)
      slot = position;
  }
};

//===----------------------------------------------------------------------===//
// Lattice payload
//===----------------------------------------------------------------------===//

struct WaitState {
  // Reaching tokens, sorted by (counter, id). Each (counter, id) pair
  // appears at most once.
  SmallVector<Token, 4> tokens;

  bool operator==(const WaitState &rhs) const {
    if (tokens.size() != rhs.tokens.size())
      return false;
    for (auto [a, b] : llvm::zip(tokens, rhs.tokens))
      if (!sameKey(a, b) || a.position != b.position)
        return false;
    return true;
  }

  bool operator!=(const WaitState &rhs) const { return !(*this == rhs); }
};

class WaitLattice : public AbstractDenseLattice {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(WaitLattice)

  using AbstractDenseLattice::AbstractDenseLattice;

  const WaitState &get() const { return state; }
  WaitState &mutate() { return state; }

  ChangeResult joinWith(const WaitState &incoming);

  ChangeResult join(const AbstractDenseLattice &rhs) override {
    return joinWith(static_cast<const WaitLattice &>(rhs).state);
  }

  ChangeResult reset() {
    if (state.tokens.empty())
      return ChangeResult::NoChange;
    state.tokens.clear();
    return ChangeResult::Change;
  }

  void print(raw_ostream &os) const override {
    os << "tokens=" << state.tokens.size();
  }

private:
  WaitState state;
};

//===----------------------------------------------------------------------===//
// Lattice helpers (mutators on WaitState)
//===----------------------------------------------------------------------===//

namespace lat {

// Insert `tok` keeping `tokens` sorted; if a matching (counter, id) is
// already present, take MIN of positions. Returns whether anything
// changed.
static bool insertOrMin(SmallVectorImpl<Token> &tokens, Token tok) {
  auto it = llvm::lower_bound(tokens, tok, [](const Token &a, const Token &b) {
    return sortKey(a, b);
  });
  if (it != tokens.end() && sameKey(*it, tok)) {
    if (tok.position < it->position) {
      it->position = tok.position;
      return true;
    }
    return false;
  }
  tokens.insert(it, tok);
  return true;
}

// Insert `tok` keeping `tokens` sorted; if a matching (counter, id) is
// already present, replace the position with `tok.position` (used by
// issuers, where the static op's re-issue across a back-edge resets
// the position to zero rather than taking MIN). Returns whether
// anything changed.
static bool insertOrReplace(SmallVectorImpl<Token> &tokens, Token tok) {
  auto it = llvm::lower_bound(tokens, tok, [](const Token &a, const Token &b) {
    return sortKey(a, b);
  });
  if (it != tokens.end() && sameKey(*it, tok)) {
    if (it->position != tok.position) {
      it->position = tok.position;
      return true;
    }
    return false;
  }
  tokens.insert(it, tok);
  return true;
}

// Bump positions of every same-counter entry by `delta`, saturating
// at `kSaturatePosition`.
static void bumpCounter(SmallVectorImpl<Token> &tokens, Counter counter,
                        unsigned delta) {
  for (Token &t : tokens) {
    if (t.counter != counter)
      continue;
    t.position = std::min<unsigned>(t.position + delta, kSaturatePosition);
  }
}

// Drop entries that an `s_waitcnt cnt(threshold)` for `counter` would
// drain. AMDGPU semantics: positions strictly above the threshold drain
// (positions <= threshold remain pending).
static void dropDrained(SmallVectorImpl<Token> &tokens, Counter counter,
                        unsigned threshold) {
  tokens.erase(std::remove_if(tokens.begin(), tokens.end(),
                              [&](const Token &t) {
                                return t.counter == counter &&
                                       t.position >= threshold;
                              }),
               tokens.end());
}

// Drop entries with positions strictly greater than `threshold` for
// any counter listed in `req`.
static void applyWait(SmallVectorImpl<Token> &tokens,
                      const WaitRequirement &req) {
  if (req.vmcnt)
    dropDrained(tokens, Counter::Vmem, *req.vmcnt);
  if (req.lgkmcnt)
    dropDrained(tokens, Counter::Lgkm, *req.lgkmcnt);
  if (req.vscnt)
    dropDrained(tokens, Counter::Vscnt, *req.vscnt);
}

// Find a Token entry by (counter, id). Returns nullptr if not present.
static const Token *find(ArrayRef<Token> tokens, Counter counter, Value id) {
  Token key{id, counter, 0};
  auto it = llvm::lower_bound(tokens, key, [](const Token &a, const Token &b) {
    return sortKey(a, b);
  });
  if (it == tokens.end() || !sameKey(*it, key))
    return nullptr;
  return &*it;
}

// The block that defines `id`'s value, or nullptr if `id` has no
// owning block (e.g. anonymous tokens).
static Block *definingBlock(Value id) {
  if (Operation *defOp = id.getDefiningOp())
    return defOp->getBlock();
  if (auto arg = dyn_cast<BlockArgument>(id))
    return arg.getOwner();
  return nullptr;
}

// Concrete tokens whose defining block does not dominate `target`
// "escape": they cannot be named at the target program point. Collapse
// every escaping token into a per-counter unknown sentinel at the MIN
// of the escaping positions (the tightest wait that would have drained
// any of the originals). Idempotent: re-running collapses unknowns
// already in place.
static void collapseEscaping(WaitState &state, Block *target,
                             DominanceInfo &dom) {
  std::array<std::optional<unsigned>, kNumCounters> minPos = {};
  SmallVector<Token, 4> kept;
  kept.reserve(state.tokens.size());
  for (const Token &t : state.tokens) {
    Block *defBlock = t.isUnknown() ? nullptr : definingBlock(t.id);
    if (t.isUnknown() || (defBlock && dom.dominates(defBlock, target))) {
      kept.push_back(t);
      continue;
    }
    unsigned slot = static_cast<unsigned>(t.counter);
    if (!minPos[slot] || t.position < *minPos[slot])
      minPos[slot] = t.position;
  }
  state.tokens = std::move(kept);
  for (unsigned i = 0; i < kNumCounters; ++i) {
    if (minPos[i])
      insertOrMin(state.tokens,
                  Token{Value(), static_cast<Counter>(i), *minPos[i]});
  }
}

// Issue a memory op: bump same-counter positions by `count`, then
// install / reset this op's own entry(ies) at position 0 for every
// `tagged` result value (registers and explicit mem.tokens). All
// tagged values share the same hardware queue position.
//
// If the op has no tagged result (e.g. a fire-and-forget store with no
// SSA token), still record one anonymous entry (`id == nullptr`) so the
// implicit `s_endpgm` vscnt drain can find it. Anonymous entries
// collapse to a single per-counter slot at the newest issued position
// (position 0), which is exactly what a "drain everything" wait needs
// (`vscnt(0)` drains the FIFO in full regardless of how many anonymous
// stores it contains).
static bool issue(WaitState &state, Counter counter, unsigned count,
                  ValueRange tagged) {
  if (count == 0)
    count = 1;
  bumpCounter(state.tokens, counter, count);
  bool changed = false;
  if (tagged.empty()) {
    changed |= insertOrReplace(state.tokens, Token{Value(), counter, 0});
  } else {
    for (Value v : tagged)
      changed |= insertOrReplace(state.tokens, Token{v, counter, 0});
  }
  return changed;
}

// Compute the MIN position per counter over the source values' Token
// entries. Returns one Token per counter that has any source entry.
static SmallVector<Token, 3> mergeSources(ArrayRef<Token> tokens,
                                          ValueRange sources, Value result) {
  std::array<std::optional<unsigned>, kNumCounters> pos = {};
  for (Value src : sources) {
    for (const Token &t : tokens) {
      if (t.id != src)
        continue;
      unsigned slot = static_cast<unsigned>(t.counter);
      if (!pos[slot] || t.position < *pos[slot])
        pos[slot] = t.position;
    }
  }
  SmallVector<Token, 3> out;
  for (unsigned i = 0; i < kNumCounters; ++i) {
    if (pos[i])
      out.push_back(Token{result, static_cast<Counter>(i), *pos[i]});
  }
  return out;
}

} // namespace lat

ChangeResult WaitLattice::joinWith(const WaitState &incoming) {
  bool changed = false;
  for (const Token &tok : incoming.tokens)
    changed |= lat::insertOrMin(state.tokens, tok);
  return changed ? ChangeResult::Change : ChangeResult::NoChange;
}

//===----------------------------------------------------------------------===//
// WaveMachine op classification
//===----------------------------------------------------------------------===//

static bool isWaveMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         wavemachine::WaveMachineDialect::getDialectNamespace();
}

static bool isSMEMLoadTrait(Operation *op) {
  return op->hasTrait<OpTrait::wavemachine::SMEMLoadOp>();
}

static bool isVMEMLoad(Operation *op) {
  return op->hasTrait<OpTrait::wavemachine::VMEMLoadOp>();
}

static bool isVMEMStore(Operation *op) {
  return op->hasTrait<OpTrait::wavemachine::VMEMStoreOp>();
}

static bool isWaitcntOp(Operation *op) {
  return op->hasTrait<OpTrait::wavemachine::WaitcntOp>();
}

static bool isTokenOnlyOp(Operation *op) {
  return op->hasTrait<OpTrait::wavemachine::TokenOp>() ||
         op->hasTrait<OpTrait::wavemachine::TokenJoinOp>();
}

static bool isMemoryIssuer(Operation *op) {
  return isSMEMLoadTrait(op) || isVMEMLoad(op) || isVMEMStore(op);
}

// Ops that pass operands to a successor region/block instead of
// consuming them locally. Their operand reads are not value uses, so
// they must not trigger waitcnt emission: the token rides along the
// branch/region operand and is consumed by the eventual reader in the
// successor. The framework's `visitBlockTransfer` and
// `visitRegionBranchControlFlowTransfer` perform the actual token
// propagation; we just abstain from doing anything with the operands
// here.
static bool isControlFlowOp(Operation *op) {
  return llvm::isa<RegionBranchOpInterface, RegionBranchTerminatorOpInterface,
                   BranchOpInterface>(op);
}

// Coarse classification of how `transferOp` / `rewriteOp` should treat
// each op. Lets the dispatch logic stay below the lizard CCN cap.
enum class OpKind {
  Skip,    // s_waitcnt, control-flow: handled by callers separately.
  Wait,    // wavemachine.wait: drain operand tokens.
  Issuer,  // VMEM/SMEM/LDS load or store: drain operand tokens, then issue.
  Barrier, // s_barrier: drain operand tokens AND derive result tokens.
  TokenOp, // wavemachine.after / token_join: derive result tokens only.
  Endpgm,  // s_endpgm: implicit vscnt drain.
  Generic, // any other op: drain its operand tokens.
};

static OpKind classifyOp(Operation *op) {
  if (isWaitcntOp(op) || isControlFlowOp(op))
    return OpKind::Skip;
  if (llvm::isa<wavemachine::WaitOp>(op))
    return OpKind::Wait;
  if (isMemoryIssuer(op))
    return OpKind::Issuer;
  if (llvm::isa<wavemachine::SBarrierOp>(op))
    return OpKind::Barrier;
  if (isTokenOnlyOp(op))
    return OpKind::TokenOp;
  if (llvm::isa<wavemachine::SEndpgmOp>(op))
    return OpKind::Endpgm;
  return OpKind::Generic;
}

// AMDGPU tuple loads/stores expand into one hardware issue per dword.
// The counter advances by N (not 1) for a width-N tuple, so a downstream
// `vmcnt(N-1)` is wrong: the last dword is still pending. We bump per
// expansion to match the hardware queue.
static unsigned getIssueCount(Operation *op) {
  if (isa<wavemachine::DsLoadTupleB32Op, wavemachine::GlobalLoadTupleB32Op,
          wavemachine::BufferLoadTupleB32Op>(op))
    return cast<wavemachine::RegType>(op->getResult(0).getType()).getWidth();
  if (isa<wavemachine::DsStoreTupleB32Op>(op))
    return cast<wavemachine::RegType>(op->getOperand(1).getType()).getWidth();
  return 1;
}

static Counter counterOf(Operation *op) {
  if (isVMEMLoad(op))
    return Counter::Vmem;
  if (isVMEMStore(op))
    return Counter::Vscnt;
  return Counter::Lgkm;
}

// Result Values an issuer tags with its token id. For ops that produce
// SSA `MemToken` we include those; we also include register results so
// a consumer reading the loaded value picks up the dependency without
// having to thread the token operand through explicitly.
static void collectIssuerResults(Operation *op, SmallVectorImpl<Value> &out) {
  for (Value r : op->getResults())
    out.push_back(r);
}

//===----------------------------------------------------------------------===//
// IsaVersion / waitcnt encoding helpers
//===----------------------------------------------------------------------===//

static FailureOr<llvm::AMDGPU::IsaVersion> getIsaVersion(Operation *op) {
  auto module = dyn_cast<ModuleOp>(op);
  if (!module)
    module = op->getParentOfType<ModuleOp>();
  if (!module)
    return op->emitError("waveamd-insert-ticket-waits requires a module");
  auto target = module->getAttrOfType<StringAttr>("wavemachine.target");
  if (!target)
    return module.emitError("waveamd-insert-ticket-waits requires a "
                            "wavemachine.target attribute");
  StringRef cpu = target.getValue();
  std::pair<StringRef, StringRef> split = cpu.rsplit("--");
  if (!split.second.empty())
    cpu = split.second;
  llvm::AMDGPU::IsaVersion version = llvm::AMDGPU::getIsaVersion(cpu);
  if (version.Major == 0)
    return module.emitError("unsupported AMDGPU target: ") << target.getValue();
  return version;
}

static wavemachine::ImmType getImmType(MLIRContext *ctx) {
  return wavemachine::ImmType::get(ctx);
}

static Value createImm(OpBuilder &builder, Location loc, int64_t value) {
  return wavemachine::ImmOp::create(builder, loc,
                                    getImmType(builder.getContext()),
                                    builder.getI64IntegerAttr(value));
}

static std::optional<unsigned> getImmediate(Value value) {
  if (auto op = value.getDefiningOp<wavemachine::ImmOp>())
    return static_cast<unsigned>(op.getValue());
  return std::nullopt;
}

//===----------------------------------------------------------------------===//
// Consumer-dep collection and wait computation
//===----------------------------------------------------------------------===//

// Validate WaveMachine-specific preconditions before analysis runs.
static LogicalResult validateWaveMachineOp(Operation *op) {
  if (!isWaveMachineOp(op))
    return success();
  if (auto func = op->getParentOfType<func::FuncOp>();
      func && func->hasAttr("wave.kernel") && llvm::isa<wavemachine::ArgOp>(op))
    return op->emitError("waveamd-insert-ticket-waits expects "
                         "ABI-lowered kernel arguments");
  if (llvm::isa<wavemachine::SLoadB32Op, wavemachine::SLoadB64Op,
                wavemachine::SLoadB128Op>(op) &&
      !op->getAttrOfType<StringAttr>("base"))
    return op->emitError("waveamd-insert-ticket-waits expects scalar "
                         "memory loads to carry a base register attribute");
  return success();
}

// Compute the required wait at a consumer op by looking up each operand
// in the lattice's Token set and demanding the tightest per-counter
// drain.
static WaitRequirement computeRequirement(Operation *op,
                                          const WaitState &state) {
  WaitRequirement req;
  // s_endpgm is the unique "drain VMEM stores before kernel exit" hook:
  // there is no SSA edge from a store's token to the return path, so
  // we force a vscnt drain here when any VMEM store is in flight.
  if (llvm::isa<wavemachine::SEndpgmOp>(op)) {
    for (const Token &t : state.tokens) {
      if (t.counter == Counter::Vscnt)
        req.requireDrain(Counter::Vscnt, t.position);
    }
    return req;
  }
  for (Value operand : op->getOperands()) {
    for (unsigned ci = 0; ci < kNumCounters; ++ci) {
      Counter c = static_cast<Counter>(ci);
      if (const Token *t = lat::find(state.tokens, c, operand))
        req.requireDrain(c, t->position);
    }
  }
  return req;
}

// Bump same-counter positions and add this op's freshly-produced token
// entry(ies) at position 0 (or one anonymous nullptr entry for stores
// with no SSA result).
static void recordIssue(Operation *op, WaitState &state) {
  SmallVector<Value, 2> results;
  collectIssuerResults(op, results);
  lat::issue(state, counterOf(op), getIssueCount(op), results);
}

// For each op result, install a fresh entry whose per-counter position
// is the MIN over the operands' Token entries. Used by `s_barrier`,
// `wavemachine.after`, and `wavemachine.token_join`.
static void deriveResultTokens(Operation *op, WaitState &state) {
  for (Value result : op->getResults()) {
    SmallVector<Token, 3> derived =
        lat::mergeSources(state.tokens, op->getOperands(), result);
    for (Token t : derived)
      lat::insertOrMin(state.tokens, t);
  }
}

// Decode an existing `s_waitcnt`'s immediate and apply it to the state.
static void observeExistingWaitcnt(Operation *op, WaitState &state,
                                   const llvm::AMDGPU::IsaVersion &isaVer) {
  if (llvm::isa<wavemachine::SWaitcntOp>(op)) {
    auto imm = getImmediate(op->getOperand(0));
    if (!imm)
      return;
    unsigned vm = 0, exp = 0, lg = 0;
    llvm::AMDGPU::decodeWaitcnt(isaVer, *imm, vm, exp, lg);
    unsigned vmMax = llvm::AMDGPU::getVmcntBitMask(isaVer);
    unsigned lgMax = llvm::AMDGPU::getLgkmcntBitMask(isaVer);
    if (vm < vmMax)
      lat::dropDrained(state.tokens, Counter::Vmem, vm);
    if (lg < lgMax)
      lat::dropDrained(state.tokens, Counter::Lgkm, lg);
    return;
  }
  if (llvm::isa<wavemachine::SWaitcntVscntOp>(op)) {
    if (auto imm = getImmediate(op->getOperand(0)))
      lat::dropDrained(state.tokens, Counter::Vscnt, *imm);
  }
}

// Drain operand tokens at `op` and hand the computed requirement to
// `emit` (a no-op during analysis, the real `s_waitcnt` emitter
// during rewrite).
template <typename EmitFn>
static void applyDrain(Operation *op, WaitState &state, EmitFn emit) {
  WaitRequirement req = computeRequirement(op, state);
  emit(op, req);
  lat::applyWait(state.tokens, req);
}

// Per-op state transfer. Both `TokenWaitAnalysis::transferOp` (analysis
// pass) and `WaveAMDTicketWaitsPass::rewriteOp` (post-fixpoint rewriter)
// dispatch through here so the lattice update and the conditional wait
// emission share a single case table.
template <typename EmitFn>
static void runTransfer(Operation *op, WaitState &state,
                        const llvm::AMDGPU::IsaVersion &isaVer, EmitFn emit) {
  switch (classifyOp(op)) {
  case OpKind::Skip:
    if (isWaitcntOp(op))
      observeExistingWaitcnt(op, state, isaVer);
    // Control-flow ops are pass-throughs at this level; the framework
    // hooks remap operands to successors.
    return;
  case OpKind::Issuer:
    applyDrain(op, state, emit);
    recordIssue(op, state);
    return;
  case OpKind::Barrier:
    // Drain operands ahead of the cross-wave fence AND seed result
    // tokens so downstream loads of the same arena depend on it.
    applyDrain(op, state, emit);
    deriveResultTokens(op, state);
    return;
  case OpKind::TokenOp:
    // after / token_join: result carries the per-counter MIN of
    // operand positions. No memory event, nothing to drain.
    deriveResultTokens(op, state);
    return;
  case OpKind::Wait:
  case OpKind::Endpgm:
  case OpKind::Generic:
    applyDrain(op, state, emit);
    return;
  }
}

//===----------------------------------------------------------------------===//
// Token analysis
//===----------------------------------------------------------------------===//

class TokenWaitAnalysis : public DenseForwardDataFlowAnalysis<WaitLattice> {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(TokenWaitAnalysis)

  TokenWaitAnalysis(DataFlowSolver &solver, DominanceInfo &dom,
                    const llvm::AMDGPU::IsaVersion &isaVer)
      : DenseForwardDataFlowAnalysis(solver), dom(dom), isaVer(isaVer) {}

  LogicalResult initialize(Operation *top) override {
    // Mark every block and CFG edge live so the solver actually runs.
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
    return DenseForwardDataFlowAnalysis<WaitLattice>::initialize(top);
  }

  void setToEntryState(WaitLattice *lattice) override {
    propagateIfChanged(lattice, lattice->reset());
  }

  LogicalResult visitOperation(Operation *op, const WaitLattice &before,
                               WaitLattice *after) override {
    if (failed(validateWaveMachineOp(op)))
      return failure();

    WaitState next = before.get();
    transferOp(op, next);
    propagateIfChanged(after, after->joinWith(next));
    markCFGSuccessorsLive(op, next);
    return success();
  }

  void visitBlockTransfer(Block *block, ProgramPoint *point, Block *predecessor,
                          const WaitLattice &before,
                          WaitLattice *after) override {
    WaitState next = before.get();
    propagateBranchOperands(predecessor->getTerminator(), block, next);
    lat::collapseEscaping(next, block, dom);
    propagateIfChanged(after, after->joinWith(next));
  }

  void visitRegionBranchControlFlowTransfer(RegionBranchOpInterface branch,
                                            std::optional<unsigned> regionFrom,
                                            std::optional<unsigned> regionTo,
                                            const WaitLattice &before,
                                            WaitLattice *after) override {
    WaitState next = before.get();
    RegionSuccessor successor =
        regionTo ? RegionSuccessor(&branch->getRegion(*regionTo))
                 : RegionSuccessor::parent();

    SmallVector<Value> sources;
    if (regionFrom) {
      Operation *term = branch->getRegion(*regionFrom).front().getTerminator();
      if (auto regionTerm = dyn_cast<RegionBranchTerminatorOpInterface>(term))
        llvm::append_range(sources, regionTerm.getSuccessorOperands(successor));
    } else {
      llvm::append_range(sources, branch.getEntrySuccessorOperands(successor));
    }
    propagateOperandsThrough(sources, branch.getSuccessorInputs(successor),
                             next);

    Block *targetBlock =
        regionTo ? &branch->getRegion(*regionTo).front() : branch->getBlock();
    if (targetBlock)
      lat::collapseEscaping(next, targetBlock, dom);
    propagateIfChanged(after, after->joinWith(next));
  }

private:
  void transferOp(Operation *op, WaitState &state) {
    auto noop = [](Operation *, const WaitRequirement &) {};
    runTransfer(op, state, isaVer, noop);
  }

  void markCFGSuccessorsLive(Operation *op, const WaitState &state) {
    if (op->getNumSuccessors() == 0)
      return;
    Block *source = op->getBlock();
    if (!source)
      return;
    for (Block *successor : op->getSuccessors()) {
      WaitState next = state;
      propagateBranchOperands(op, successor, next);
      lat::collapseEscaping(next, successor, dom);
      auto *blockState = getLattice(getProgramPointBefore(successor));
      propagateIfChanged(blockState, blockState->joinWith(next));
      auto *blockLive =
          getOrCreate<Executable>(getProgramPointBefore(successor));
      propagateIfChanged(blockLive, blockLive->setToLive());
      auto *edgeLive =
          getOrCreate<Executable>(getLatticeAnchor<CFGEdge>(source, successor));
      propagateIfChanged(edgeLive, edgeLive->setToLive());
    }
  }

  // Take a predecessor's exit state and propagate it through a
  // CFG-style branch into `successor`. Each branch operand seeds the
  // successor's block arg with a fresh Token entry keyed on the block
  // arg's `Value`, carrying the operand's per-counter position.
  void propagateBranchOperands(Operation *term, Block *successor,
                               WaitState &state) {
    if (auto branch = dyn_cast<BranchOpInterface>(term)) {
      bool mapped = false;
      for (auto [idx, target] : llvm::enumerate(term->getSuccessors())) {
        if (target != successor)
          continue;
        SuccessorOperands operands = branch.getSuccessorOperands(idx);
        unsigned limit =
            std::min<unsigned>(operands.size(), successor->getNumArguments());
        SmallVector<Value, 4> srcs, dsts;
        for (unsigned i = 0; i < limit; ++i) {
          srcs.push_back(operands[i]);
          dsts.push_back(successor->getArgument(i));
        }
        propagateOperandsThrough(srcs, dsts, state);
        mapped = true;
      }
      if (mapped)
        return;
    }
    // Fallback: single-successor terminator with positional operands.
    if (term->getNumSuccessors() == 1 && term->getSuccessor(0) == successor &&
        term->getNumOperands() >= successor->getNumArguments()) {
      SmallVector<Value, 4> srcs, dsts;
      for (auto [i, arg] : llvm::enumerate(successor->getArguments())) {
        srcs.push_back(term->getOperand(i));
        dsts.push_back(arg);
      }
      propagateOperandsThrough(srcs, dsts, state);
    }
  }

  // Map operand values to successor values: for each pair, every
  // (counter, operand-position) entry is duplicated under the
  // destination value's key. The merge at the successor (via
  // `joinWith`) then takes MIN across predecessors.
  void propagateOperandsThrough(ValueRange operands, ValueRange destinations,
                                WaitState &state) {
    SmallVector<Token, 4> added;
    for (auto [op, dst] : llvm::zip_equal(operands, destinations)) {
      for (unsigned ci = 0; ci < kNumCounters; ++ci) {
        Counter c = static_cast<Counter>(ci);
        if (const Token *t = lat::find(state.tokens, c, op))
          added.push_back(Token{dst, c, t->position});
      }
    }
    for (const Token &t : added)
      lat::insertOrMin(state.tokens, t);
  }

  DominanceInfo &dom;
  const llvm::AMDGPU::IsaVersion &isaVer;
};

//===----------------------------------------------------------------------===//
// Rewrite step
//===----------------------------------------------------------------------===//

// Emit the s_waitcnt op(s) implied by `req` immediately before `op`.
static void emitWaits(OpBuilder &builder, Operation *op,
                      const WaitRequirement &req,
                      const llvm::AMDGPU::IsaVersion &isaVer) {
  builder.setInsertionPoint(op);
  if (req.vmcnt || req.lgkmcnt) {
    unsigned encoded =
        llvm::AMDGPU::encodeWaitcnt(isaVer, req.vmcnt.value_or(~0u),
                                    /*expcnt=*/~0u, req.lgkmcnt.value_or(~0u));
    wavemachine::SWaitcntOp::create(builder, op->getLoc(),
                                    createImm(builder, op->getLoc(), encoded));
  }
  if (req.vscnt) {
    wavemachine::SWaitcntVscntOp::create(
        builder, op->getLoc(), createImm(builder, op->getLoc(), *req.vscnt));
  }
}

struct WaveAMDTicketWaitsPass
    : public wave::impl::WaveAMDTicketWaitsBase<WaveAMDTicketWaitsPass> {
  void runOnOperation() override {
    ModuleOp module = getOperation();
    for (func::FuncOp func : module.getOps<func::FuncOp>()) {
      if (failed(runOnFunc(func)))
        return signalPassFailure();
    }
  }

  LogicalResult runOnFunc(func::FuncOp func) {
    FailureOr<llvm::AMDGPU::IsaVersion> isaVersion = getIsaVersion(func);
    if (failed(isaVersion))
      return failure();

    DominanceInfo dom(func);
    DataFlowSolver solver;
    loadBaselineAnalyses(solver);
    solver.load<TokenWaitAnalysis>(dom, *isaVersion);
    if (failed(solver.initializeAndRun(func)))
      return failure();

    rewriteWithSolver(func, solver, *isaVersion);
    return success();
  }

  // After the dataflow converges we walk every op in order, ask the
  // solver for the state immediately before it, compute the wait it
  // demands, and emit `s_waitcnt`(s) ahead of it. We keep a local copy
  // of the state inside each block so consecutive consumers of the
  // same token see the drain effect from the wait we just emitted (the
  // solver's per-op state does not).
  void rewriteWithSolver(func::FuncOp func, DataFlowSolver &solver,
                         const llvm::AMDGPU::IsaVersion &isaVer) {
    OpBuilder builder(func.getContext());
    SmallVector<Block *> blocks;
    collectBlocks(func.getBody(), blocks);
    for (Block *block : blocks)
      rewriteBlock(block, solver, isaVer, builder);
  }

  void rewriteBlock(Block *block, DataFlowSolver &solver,
                    const llvm::AMDGPU::IsaVersion &isaVer,
                    OpBuilder &builder) {
    auto *blockLat =
        solver.lookupState<WaitLattice>(solver.getProgramPointBefore(block));
    WaitState local;
    if (blockLat)
      local = blockLat->get();

    SmallVector<Operation *> ops;
    for (Operation &op : *block)
      ops.push_back(&op);

    for (Operation *op : ops)
      rewriteOp(op, local, solver, isaVer, builder);
  }

  void rewriteOp(Operation *op, WaitState &local, DataFlowSolver &solver,
                 const llvm::AMDGPU::IsaVersion &isaVer, OpBuilder &builder) {
    // Control-flow ops do not consume tokens locally; the framework's
    // region- and block-transfer hooks compute the post-op state for
    // us. Refresh `local` from the solver so a downstream consumer in
    // this same block (e.g. `v_add %x, %r` reading a `scf.if` result)
    // sees the joined region state. Inner regions are walked
    // separately by `collectBlocks`, so we don't need to descend here.
    if (isControlFlowOp(op)) {
      if (auto *post =
              solver.lookupState<WaitLattice>(solver.getProgramPointAfter(op)))
        local = post->get();
      return;
    }
    auto emit = [&](Operation *op, const WaitRequirement &req) {
      if (req.hasWait())
        emitWaits(builder, op, req, isaVer);
    };
    // Share the case table with the analysis pass: same state transfer,
    // the only delta is the (conditional) `emit`.
    runTransfer(op, local, isaVer, emit);
  }

  static void collectBlocks(Region &region, SmallVectorImpl<Block *> &blocks) {
    for (Block &block : region) {
      blocks.push_back(&block);
      for (Operation &op : block)
        for (Region &nested : op.getRegions())
          collectBlocks(nested, blocks);
    }
  }
};

} // namespace
