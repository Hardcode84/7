//===- WaveAMDMachineWaitcnt.cpp - WaveAMDMachine waitcnt insertion ---*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Token-based waitcnt insertion. Each in-flight memory op is named by its
// SSA result Value (or nullptr for fire-and-forget stores). Lattice entry
// is (value, counter, event, position): position counts newer same-counter
// issues queued behind it, so `vmcnt(position)` is the exact in-order drain.
// SMEM and mixed LGKM event brackets are out-of-order, so they clamp to
// `lgkmcnt(0)`. CFG joins merge with MIN -- a wait larger than the
// path-minimum returns before the token drains. Tokens whose def block
// doesn't dominate the successor collapse to a per-counter nullptr sentinel
// at MIN of escaping positions. `s_endpgm` forces `vscnt(0)` so VMEM stores
// don't leak past kernel exit.
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Analysis/DataFlow/DenseAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
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

static unsigned eventMask(waveamdmachine::WaitcntEvent event) {
  return static_cast<unsigned>(event);
}

static bool hasMultipleEvents(unsigned mask) {
  return mask && (mask & (mask - 1));
}

static std::optional<Counter>
toCounter(waveamdmachine::WaitcntCounter counter) {
  switch (counter) {
  case waveamdmachine::WaitcntCounter::Vmem:
    return Counter::Vmem;
  case waveamdmachine::WaitcntCounter::Lgkm:
    return Counter::Lgkm;
  case waveamdmachine::WaitcntCounter::Vscnt:
    return Counter::Vscnt;
  case waveamdmachine::WaitcntCounter::None:
    return std::nullopt;
  }
  llvm_unreachable("bad waitcnt counter");
}

// Null `id` is the per-counter unknown sentinel.
struct Token {
  Value id;
  Counter counter;
  unsigned events;
  unsigned position;
  bool outOfOrder;
  bool writesMemory;

  bool isUnknown() const { return !id; }
};

static unsigned activeEventMask(ArrayRef<Token> tokens, Counter counter);

static bool sortKey(const Token &a, const Token &b) {
  if (a.counter != b.counter)
    return static_cast<unsigned>(a.counter) < static_cast<unsigned>(b.counter);
  return a.id.getAsOpaquePointer() < b.id.getAsOpaquePointer();
}

static bool sameKey(const Token &a, const Token &b) {
  return a.counter == b.counter && a.id == b.id;
}

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

  // MIN over required positions: `cnt(N)` drains everything at position >= N.
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
  // Sorted by (counter, id); each (counter, id) appears at most once.
  SmallVector<Token, 4> tokens;

  bool operator==(const WaitState &rhs) const {
    if (tokens.size() != rhs.tokens.size())
      return false;
    for (auto [a, b] : llvm::zip(tokens, rhs.tokens))
      if (!sameKey(a, b) || a.events != b.events || a.position != b.position ||
          a.outOfOrder != b.outOfOrder || a.writesMemory != b.writesMemory)
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

struct TokenAggregate {
  std::optional<unsigned> position;
  unsigned events = 0;
  bool outOfOrder = false;
  bool writesMemory = false;
};

static void mergeInto(TokenAggregate &agg, const Token &token) {
  if (!agg.position || token.position < *agg.position)
    agg.position = token.position;
  agg.events |= token.events;
  agg.outOfOrder |= token.outOfOrder;
  agg.writesMemory |= token.writesMemory;
}

// On (counter, id) collision: MIN position, OR event constraints.
static bool insertOrMin(SmallVectorImpl<Token> &tokens, Token tok) {
  auto it = llvm::lower_bound(tokens, tok, [](const Token &a, const Token &b) {
    return sortKey(a, b);
  });
  if (it != tokens.end() && sameKey(*it, tok)) {
    bool changed = false;
    if (tok.position < it->position) {
      it->position = tok.position;
      changed = true;
    }
    unsigned events = it->events | tok.events;
    if (events != it->events) {
      it->events = events;
      changed = true;
    }
    if (tok.outOfOrder && !it->outOfOrder) {
      it->outOfOrder = true;
      changed = true;
    }
    if (tok.writesMemory && !it->writesMemory) {
      it->writesMemory = true;
      changed = true;
    }
    return changed;
  }
  tokens.insert(it, tok);
  return true;
}

// On collision: overwrite. Issuers reset to position 0 across back-edges
// rather than taking MIN.
static bool insertOrReplace(SmallVectorImpl<Token> &tokens, Token tok) {
  auto it = llvm::lower_bound(tokens, tok, [](const Token &a, const Token &b) {
    return sortKey(a, b);
  });
  if (it != tokens.end() && sameKey(*it, tok)) {
    if (it->events != tok.events || it->position != tok.position ||
        it->outOfOrder != tok.outOfOrder ||
        it->writesMemory != tok.writesMemory) {
      *it = tok;
      return true;
    }
    return false;
  }
  tokens.insert(it, tok);
  return true;
}

static void bumpCounter(SmallVectorImpl<Token> &tokens, Counter counter,
                        unsigned delta) {
  for (Token &t : tokens) {
    if (t.counter != counter)
      continue;
    t.position = std::min<unsigned>(t.position + delta, kSaturatePosition);
  }
}

// `cnt(threshold)` drains position >= threshold (positions < threshold stay).
static void dropDrained(SmallVectorImpl<Token> &tokens, Counter counter,
                        unsigned threshold) {
  unsigned liveEvents = activeEventMask(tokens, counter);
  tokens.erase(
      std::remove_if(tokens.begin(), tokens.end(),
                     [&](const Token &t) {
                       if (t.counter != counter || t.position < threshold)
                         return false;
                       if (threshold == 0 || t.counter != Counter::Lgkm)
                         return true;
                       if (t.outOfOrder || hasMultipleEvents(liveEvents))
                         return false;
                       return true;
                     }),
      tokens.end());
}

static void applyWait(SmallVectorImpl<Token> &tokens,
                      const WaitRequirement &req) {
  if (req.vmcnt)
    dropDrained(tokens, Counter::Vmem, *req.vmcnt);
  if (req.lgkmcnt)
    dropDrained(tokens, Counter::Lgkm, *req.lgkmcnt);
  if (req.vscnt)
    dropDrained(tokens, Counter::Vscnt, *req.vscnt);
}

static const Token *find(ArrayRef<Token> tokens, Counter counter, Value id) {
  Token key{id, counter, 0, 0, false, false};
  auto it = llvm::lower_bound(tokens, key, [](const Token &a, const Token &b) {
    return sortKey(a, b);
  });
  if (it == tokens.end() || !sameKey(*it, key))
    return nullptr;
  return &*it;
}

static Block *definingBlock(Value id) {
  if (Operation *defOp = id.getDefiningOp())
    return defOp->getBlock();
  if (auto arg = dyn_cast<BlockArgument>(id))
    return arg.getOwner();
  return nullptr;
}

// Token def-block not dominating `target` collapses to a per-counter
// nullptr sentinel at MIN of escaping positions. Idempotent.
static void collapseEscaping(WaitState &state, Block *target,
                             DominanceInfo &dom) {
  std::array<TokenAggregate, kNumCounters> escaping = {};
  SmallVector<Token, 4> kept;
  kept.reserve(state.tokens.size());
  for (const Token &t : state.tokens) {
    Block *defBlock = t.isUnknown() ? nullptr : definingBlock(t.id);
    if (t.isUnknown() || (defBlock && dom.dominates(defBlock, target))) {
      kept.push_back(t);
      continue;
    }
    mergeInto(escaping[static_cast<unsigned>(t.counter)], t);
  }
  state.tokens = std::move(kept);
  for (unsigned i = 0; i < kNumCounters; ++i) {
    if (escaping[i].position)
      insertOrMin(state.tokens,
                  Token{Value(), static_cast<Counter>(i), escaping[i].events,
                        *escaping[i].position, escaping[i].outOfOrder,
                        escaping[i].writesMemory});
  }
}

// Bump same-counter positions, then seed position-0 entries for each
// tagged result. No tagged result -> one anonymous (nullptr) entry so
// `s_endpgm`'s vscnt drain can find untokenized stores.
static bool issue(WaitState &state, Counter counter, unsigned count,
                  unsigned events, bool outOfOrder, bool writesMemory,
                  ValueRange tagged) {
  if (count == 0)
    count = 1;
  bumpCounter(state.tokens, counter, count);
  bool changed = false;
  if (tagged.empty()) {
    changed |= insertOrReplace(state.tokens, Token{Value(), counter, events, 0,
                                                   outOfOrder, writesMemory});
  } else {
    for (Value v : tagged)
      changed |= insertOrReplace(
          state.tokens, Token{v, counter, events, 0, outOfOrder, writesMemory});
  }
  return changed;
}

// Per-counter MIN over `sources`' tokens, re-keyed under `result`.
static SmallVector<Token, 3> mergeSources(ArrayRef<Token> tokens,
                                          ValueRange sources, Value result) {
  std::array<TokenAggregate, kNumCounters> merged = {};
  for (Value src : sources) {
    for (const Token &t : tokens) {
      if (t.id != src)
        continue;
      mergeInto(merged[static_cast<unsigned>(t.counter)], t);
    }
  }
  SmallVector<Token, 3> out;
  for (unsigned i = 0; i < kNumCounters; ++i) {
    if (merged[i].position)
      out.push_back(Token{result, static_cast<Counter>(i), merged[i].events,
                          *merged[i].position, merged[i].outOfOrder,
                          merged[i].writesMemory});
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
// WaveAMDMachine op classification
//===----------------------------------------------------------------------===//

static bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         waveamdmachine::WaveAMDMachineDialect::getDialectNamespace();
}

static bool isWaitcntOp(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::WaitcntOp>();
}

static bool isTokenOnlyOp(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::TokenOp>() ||
         op->hasTrait<OpTrait::waveamdmachine::TokenJoinOp>();
}

static waveamdmachine::WaitcntInfo getWaitcntInfo(Operation *op) {
  if (auto info = dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo();
  return {};
}

static bool isMemoryIssuer(Operation *op) {
  return getWaitcntInfo(op).isIssuer();
}

static bool isMemoryWriteIssuer(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::LDSStoreOp>() ||
         op->hasTrait<OpTrait::waveamdmachine::LDSDmaOp>() ||
         op->hasTrait<OpTrait::waveamdmachine::VMEMStoreOp>();
}

static bool isReadOnlyIssuer(Operation *op) {
  return isMemoryIssuer(op) && !isMemoryWriteIssuer(op);
}

static bool isTupleMemoryOp(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::TupleMemoryOp>();
}

static bool isMemToken(Value value) {
  return isa<waveamdmachine::MemTokenType>(value.getType());
}

struct RegSpan {
  waveamdmachine::RegClass regClass;
  int64_t begin = 0;
  int64_t end = 0;
};

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

static bool emitsMachineInst(Operation *op) {
  return !op->hasTrait<OpTrait::waveamdmachine::NoMachineInst>();
}

// Operand reads here are branch arguments, not value uses; framework
// hooks remap tokens to successors instead.
static bool isControlFlowOp(Operation *op) {
  return llvm::isa<RegionBranchOpInterface, RegionBranchTerminatorOpInterface,
                   BranchOpInterface>(op);
}

enum class OpKind {
  Skip,    // s_waitcnt, control-flow: handled separately.
  Issuer,  // VMEM/SMEM/LDS load or store: drain, then issue.
  Barrier, // s_barrier: drain AND derive result tokens.
  TokenOp, // waveamdmachine.after / token_join: derive only.
  Endpgm,  // s_endpgm: implicit vscnt drain.
  Generic, // any other op: drain its operands.
};

static OpKind classifyOp(Operation *op) {
  if (isWaitcntOp(op) || isControlFlowOp(op))
    return OpKind::Skip;
  if (isMemoryIssuer(op))
    return OpKind::Issuer;
  if (llvm::isa<waveamdmachine::SBarrierOp>(op))
    return OpKind::Barrier;
  if (isTokenOnlyOp(op))
    return OpKind::TokenOp;
  if (llvm::isa<waveamdmachine::SEndpgmOp>(op))
    return OpKind::Endpgm;
  return OpKind::Generic;
}

// Both MemToken and register results tag the same issue so consumers
// can depend via either edge.
static void collectIssuerResults(Operation *op, SmallVectorImpl<Value> &out) {
  for (Value r : op->getResults())
    out.push_back(r);
}

//===----------------------------------------------------------------------===//
// IsaVersion / waitcnt encoding helpers
//===----------------------------------------------------------------------===//

static FailureOr<llvm::AMDGPU::IsaVersion> getIsaVersion(Operation *op) {
  return waveamdmachine::getAMDGPUTargetIsaVersion(
      op, "waveamd-insert-ticket-waits");
}

static unsigned activeEventMask(ArrayRef<Token> tokens, Counter counter) {
  unsigned mask = 0;
  for (const Token &token : tokens)
    if (token.counter == counter)
      mask |= token.events;
  return mask;
}

static unsigned waitPosition(const WaitState &state, const Token &token) {
  if (token.outOfOrder)
    return 0;
  if (token.counter == Counter::Lgkm &&
      hasMultipleEvents(activeEventMask(state.tokens, Counter::Lgkm)))
    return 0;
  return token.position;
}

//===----------------------------------------------------------------------===//
// Consumer-dep collection and wait computation
//===----------------------------------------------------------------------===//

static LogicalResult validateWaveAMDMachineOp(Operation *op) {
  if (!isWaveAMDMachineOp(op))
    return success();
  if (isTupleMemoryOp(op))
    return op->emitError("waveamd-insert-ticket-waits expects tuple memory "
                         "ops to be decomposed first");
  if (auto func = op->getParentOfType<func::FuncOp>();
      func && func->hasAttr(wave::WaveDialect::getKernelAttrName()) &&
      llvm::isa<waveamdmachine::ArgOp>(op))
    return op->emitError("waveamd-insert-ticket-waits expects "
                         "ABI-lowered kernel arguments");
  if (llvm::isa<waveamdmachine::SLoadB32Op, waveamdmachine::SLoadB64Op,
                waveamdmachine::SLoadB128Op>(op) &&
      !op->getAttrOfType<StringAttr>("base"))
    return op->emitError("waveamd-insert-ticket-waits expects scalar "
                         "memory loads to carry a base register attribute");
  return success();
}

static void requireValue(WaitRequirement &req, Value value,
                         const WaitState &state) {
  for (unsigned ci = 0; ci < kNumCounters; ++ci) {
    Counter c = static_cast<Counter>(ci);
    if (const Token *t = lat::find(state.tokens, c, value))
      req.requireDrain(c, waitPosition(state, *t));
  }
}

static void requireIssuerToken(WaitRequirement &req, Value value,
                               const WaitState &state, Operation *issuer) {
  if (!isReadOnlyIssuer(issuer)) {
    requireValue(req, value, state);
    return;
  }
  for (unsigned ci = 0; ci < kNumCounters; ++ci) {
    Counter c = static_cast<Counter>(ci);
    const Token *t = lat::find(state.tokens, c, value);
    if (t && t->writesMemory)
      req.requireDrain(c, waitPosition(state, *t));
  }
}

static void requireOverlappingRegisterDefs(WaitRequirement &req, Operation *op,
                                           const WaitState &state) {
  if (!emitsMachineInst(op))
    return;
  for (Value result : op->getResults()) {
    std::optional<RegSpan> resultSpan = getAllocatedRegSpan(result);
    if (!resultSpan)
      continue;
    for (const Token &t : state.tokens) {
      if (t.isUnknown())
        continue;
      std::optional<RegSpan> pendingSpan = getAllocatedRegSpan(t.id);
      if (pendingSpan && overlaps(*resultSpan, *pendingSpan))
        req.requireDrain(t.counter, waitPosition(state, t));
    }
  }
}

static bool hasSameAllocatedReg(Value lhs, Value rhs) {
  waveamdmachine::RegType lhsType =
      dyn_cast<waveamdmachine::RegType>(lhs.getType());
  waveamdmachine::RegType rhsType =
      dyn_cast<waveamdmachine::RegType>(rhs.getType());
  if (!lhsType || !rhsType)
    return false;
  return lhsType.getRegClass() == rhsType.getRegClass() &&
         lhsType.getWidth() == rhsType.getWidth() && lhsType.getIndex() >= 0 &&
         lhsType.getIndex() == rhsType.getIndex();
}

static void requireExecIfYieldCopies(WaitRequirement &req,
                                     waveamdmachine::YieldOp yield,
                                     const WaitState &state) {
  auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(yield->getParentOp());
  if (!execIf)
    return;
  for (auto [result, value] :
       llvm::zip_equal(execIf.getResults(), yield.getValues())) {
    if (isa<waveamdmachine::MemTokenType>(result.getType()))
      continue;
    if (value.getDefiningOp<waveamdmachine::UninitOp>())
      continue;
    if (hasSameAllocatedReg(result, value))
      continue;
    requireValue(req, value, state);
  }
}

static WaitRequirement computeControlFlowRequirement(Operation *op,
                                                     const WaitState &state) {
  WaitRequirement req;
  if (auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(op)) {
    requireValue(req, execIf.getCondition(), state);
    return req;
  }
  if (auto uniformIf = dyn_cast<waveamdmachine::UniformIfOp>(op)) {
    requireValue(req, uniformIf.getCondition(), state);
    return req;
  }
  if (auto yield = dyn_cast<waveamdmachine::YieldOp>(op))
    requireExecIfYieldCopies(req, yield, state);
  return req;
}

static bool isD16LowPreservedOperand(OpOperand &operand) {
  auto load = dyn_cast<waveamdmachine::BufferLoadU8D16HiOp>(operand.getOwner());
  if (!load || &operand != &load.getPreservedMutable())
    return false;
  return load.getPreserved().getDefiningOp<waveamdmachine::BufferLoadU8D16Op>();
}

static WaitRequirement computeRequirement(Operation *op,
                                          const WaitState &state) {
  if (isControlFlowOp(op))
    return computeControlFlowRequirement(op, state);
  WaitRequirement req;
  // No SSA edge from a store's token to the return path -- force vscnt
  // drain when any VMEM store is still in flight.
  if (llvm::isa<waveamdmachine::SEndpgmOp>(op)) {
    for (const Token &t : state.tokens) {
      if (t.counter == Counter::Vscnt)
        req.requireDrain(Counter::Vscnt, waitPosition(state, t));
    }
    return req;
  }
  bool issuer = isMemoryIssuer(op);
  for (OpOperand &operand : op->getOpOperands()) {
    if (isD16LowPreservedOperand(operand))
      continue;
    // Issuer `after` tokens order issue. Completion waits stay explicit.
    if (issuer && isMemToken(operand.get())) {
      requireIssuerToken(req, operand.get(), state, op);
      continue;
    }
    requireValue(req, operand.get(), state);
  }
  requireOverlappingRegisterDefs(req, op, state);
  return req;
}

static void recordIssue(Operation *op, WaitState &state) {
  waveamdmachine::WaitcntInfo info = getWaitcntInfo(op);
  std::optional<Counter> counter = toCounter(info.counter);
  if (!counter)
    return;
  SmallVector<Value, 2> results;
  collectIssuerResults(op, results);
  lat::issue(state, *counter, info.issueCount, eventMask(info.event),
             info.outOfOrder, isMemoryWriteIssuer(op), results);
}

static void deriveIssuerDependencyTokens(Operation *op, WaitState &state) {
  if (!isReadOnlyIssuer(op))
    return;

  SmallVector<Value, 2> dependencies;
  for (Value operand : op->getOperands()) {
    if (isMemToken(operand))
      dependencies.push_back(operand);
  }
  if (dependencies.empty())
    return;

  for (Value result : op->getResults()) {
    if (!isMemToken(result))
      continue;
    SmallVector<Token, 3> derived =
        lat::mergeSources(state.tokens, dependencies, result);
    for (Token t : derived)
      lat::insertOrMin(state.tokens, t);
  }
}

// Each result inherits per-counter MIN over operands. Used by s_barrier,
// waveamdmachine.after, waveamdmachine.token_join.
static void deriveResultTokens(Operation *op, WaitState &state) {
  for (Value result : op->getResults()) {
    SmallVector<Token, 3> derived =
        lat::mergeSources(state.tokens, op->getOperands(), result);
    for (Token t : derived)
      lat::insertOrMin(state.tokens, t);
  }
}

// Apply explicit waitcnt drain attrs to the state.
static void observeExistingWaitcnt(Operation *op, WaitState &state,
                                   const llvm::AMDGPU::IsaVersion &isaVer) {
  if (auto wait = llvm::dyn_cast<waveamdmachine::SWaitcntOp>(op)) {
    unsigned vmMax = llvm::AMDGPU::getVmcntBitMask(isaVer);
    unsigned lgMax = llvm::AMDGPU::getLgkmcntBitMask(isaVer);
    if (std::optional<uint32_t> vm = wait.getVmcnt(); vm && *vm < vmMax)
      lat::dropDrained(state.tokens, Counter::Vmem, *vm);
    if (std::optional<uint32_t> lg = wait.getLgkmcnt(); lg && *lg < lgMax)
      lat::dropDrained(state.tokens, Counter::Lgkm, *lg);
    return;
  }
  if (auto wait = llvm::dyn_cast<waveamdmachine::SWaitcntVscntOp>(op))
    lat::dropDrained(state.tokens, Counter::Vscnt, wait.getVscnt());
}

static void
clampSaturatedCounterFields(WaitRequirement &req,
                            const llvm::AMDGPU::IsaVersion &isaVer) {
  unsigned vmMax = llvm::AMDGPU::getVmcntBitMask(isaVer);
  unsigned lgMax = llvm::AMDGPU::getLgkmcntBitMask(isaVer);
  if (req.vmcnt && vmMax > 0 && *req.vmcnt >= vmMax)
    req.vmcnt = vmMax - 1;
  if (req.lgkmcnt && lgMax > 0 && *req.lgkmcnt >= lgMax)
    req.lgkmcnt = lgMax - 1;
}

// `emit` is a no-op during analysis, the s_waitcnt emitter during rewrite.
template <typename EmitFn>
static void applyDrain(Operation *op, WaitState &state,
                       const llvm::AMDGPU::IsaVersion &isaVer, EmitFn emit) {
  WaitRequirement req = computeRequirement(op, state);
  clampSaturatedCounterFields(req, isaVer);
  emit(op, req);
  lat::applyWait(state.tokens, req);
}

// Shared dispatch for analysis and rewrite: same state transfer, the
// only delta is the (conditional) `emit`.
template <typename EmitFn>
static void runTransfer(Operation *op, WaitState &state,
                        const llvm::AMDGPU::IsaVersion &isaVer, EmitFn emit) {
  switch (classifyOp(op)) {
  case OpKind::Skip:
    if (isWaitcntOp(op)) {
      observeExistingWaitcnt(op, state, isaVer);
      return;
    }
    applyDrain(op, state, isaVer, emit);
    return;
  case OpKind::Issuer:
    applyDrain(op, state, isaVer, emit);
    recordIssue(op, state);
    deriveIssuerDependencyTokens(op, state);
    return;
  case OpKind::Barrier:
    // Drain ahead of the fence AND seed result tokens so downstream
    // loads of the same arena depend on it.
    applyDrain(op, state, isaVer, emit);
    deriveResultTokens(op, state);
    return;
  case OpKind::TokenOp:
    deriveResultTokens(op, state);
    return;
  case OpKind::Endpgm:
  case OpKind::Generic:
    applyDrain(op, state, isaVer, emit);
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
    // Solver needs every block + CFG edge marked live or it stalls.
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
    if (failed(validateWaveAMDMachineOp(op)))
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
                 : RegionSuccessor(branch.getOperation());

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

  // Seed each successor block arg with the operand's per-counter position.
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
    // Terminator without BranchOpInterface: assume positional operands.
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

  // Re-key each operand's entries under the destination value;
  // joinWith at the successor takes MIN across predecessors.
  void propagateOperandsThrough(ValueRange operands, ValueRange destinations,
                                WaitState &state) {
    SmallVector<Token, 4> added;
    for (auto [op, dst] : llvm::zip_equal(operands, destinations)) {
      for (unsigned ci = 0; ci < kNumCounters; ++ci) {
        Counter c = static_cast<Counter>(ci);
        if (const Token *t = lat::find(state.tokens, c, op))
          added.push_back(Token{dst, c, t->events, t->position, t->outOfOrder,
                                t->writesMemory});
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

static IntegerAttr getCounterAttr(OpBuilder &builder, unsigned value) {
  return builder.getI32IntegerAttr(value);
}

static void emitWaits(OpBuilder &builder, Operation *op,
                      const WaitRequirement &req) {
  builder.setInsertionPoint(op);
  if (req.vmcnt || req.lgkmcnt) {
    waveamdmachine::SWaitcntOp::create(
        builder, op->getLoc(),
        req.vmcnt ? getCounterAttr(builder, *req.vmcnt) : IntegerAttr(),
        /*expcnt=*/IntegerAttr(),
        req.lgkmcnt ? getCounterAttr(builder, *req.lgkmcnt) : IntegerAttr());
  }
  if (req.vscnt) {
    waveamdmachine::SWaitcntVscntOp::create(
        builder, op->getLoc(), getCounterAttr(builder, *req.vscnt));
  }
}

struct WaveAMDTicketWaitsPass
    : public wave::impl::WaveAMDTicketWaitsBase<WaveAMDTicketWaitsPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    SmallVector<func::FuncOp> kernels;
    root->walk([&](func::FuncOp f) {
      if (!f.isExternal())
        kernels.push_back(f);
    });
    for (func::FuncOp func : kernels) {
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

  // Per-block local state so consecutive consumers see drains from the
  // wait we just emitted (the solver's per-op state does not).
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
    auto emit = [&](Operation *op, const WaitRequirement &req) {
      if (req.hasWait())
        emitWaits(builder, op, req);
    };
    // Control-flow ops: framework hooks computed the post-op state.
    // Refresh `local` so a downstream consumer sees the joined region
    // result. Inner regions are visited separately via collectBlocks.
    if (isControlFlowOp(op)) {
      runTransfer(op, local, isaVer, emit);
      if (auto *post =
              solver.lookupState<WaitLattice>(solver.getProgramPointAfter(op)))
        local = post->get();
      return;
    }
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
