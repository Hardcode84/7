//===- WaveAMDMachineWaitcnt.cpp - WaveAMDMachine waitcnt insertion ---*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Tracks semantic completion tickets plus physical source-register tickets.
// LLVM target state supplies counter mapping and widths. CFG joins take MIN:
// a larger wait can return while an escaping ticket remains.
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "MCTargetDesc/AMDGPUMCTargetDesc.h"
#include "RegAlloc/WaveAMDRegisterLimits.h"
#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Analysis/DataFlow/DenseAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDExecIfUtils.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Dominance.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/Sequence.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/Debug.h"
#include "llvm/TargetParser/TargetParser.h"
#include <array>
#include <cassert>
#include <limits>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDTICKETWAITS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::dataflow;
using namespace mlir::wave;
using mlir::waveamdmachine::getWaitcntInfo;
using mlir::waveamdmachine::isWaveAMDMachineOp;

namespace {

//===----------------------------------------------------------------------===//
// Counter and token model
//===----------------------------------------------------------------------===//

using Counter = waveamdmachine::WaitcntCounter;
static constexpr unsigned kNumCounters =
    waveamdmachine::getMaxEnumValForWaitcntCounter() + 1;

static unsigned eventMask(waveamdmachine::WaitcntEvent event) {
  return static_cast<unsigned>(event);
}

static bool hasMultipleEvents(unsigned mask) {
  return mask && (mask & (mask - 1));
}

static unsigned vmemSourceEventMask() {
  return eventMask(waveamdmachine::WaitcntEvent::Vmem) |
         eventMask(waveamdmachine::WaitcntEvent::VmemStore) |
         eventMask(waveamdmachine::WaitcntEvent::ScratchStore);
}

static unsigned xSourceGroup(unsigned events) {
  unsigned group = 0;
  if (events & vmemSourceEventMask())
    group |= eventMask(waveamdmachine::WaitcntEvent::Vmem);
  if (events & eventMask(waveamdmachine::WaitcntEvent::Smem))
    group |= eventMask(waveamdmachine::WaitcntEvent::Smem);
  return group;
}

static bool hasMixedXGroups(unsigned mask) {
  return (mask & vmemSourceEventMask()) &&
         (mask & eventMask(waveamdmachine::WaitcntEvent::Smem));
}

using RegSpan = waveamdmachine::PhysicalRegisterSpan;

static bool overlaps(RegSpan lhs, RegSpan rhs) {
  return lhs.regClass == rhs.regClass && lhs.begin < rhs.end &&
         rhs.begin < lhs.end;
}

struct ExecSourceTag {};

// Null `id` without a source is the per-counter unknown sentinel.
struct Token {
  std::optional<RegSpan> source;
  Value id;
  unsigned events;
  unsigned position;
  Counter counter;
  bool outOfOrder;
  bool writesMemory;
  bool execSource;

  Token(Value id, Counter counter, unsigned events, unsigned position,
        bool outOfOrder, bool writesMemory)
      : id(id), events(events), position(position), counter(counter),
        outOfOrder(outOfOrder), writesMemory(writesMemory), execSource(false) {}

  Token(RegSpan source, Counter counter, unsigned events, unsigned position,
        bool outOfOrder)
      : source(source), events(events), position(position), counter(counter),
        outOfOrder(outOfOrder), writesMemory(false), execSource(false) {}

  Token(ExecSourceTag, Counter counter, unsigned events, unsigned position,
        bool outOfOrder)
      : events(events), position(position), counter(counter),
        outOfOrder(outOfOrder), writesMemory(false), execSource(true) {}

  bool isSource() const { return source.has_value() || execSource; }
  bool isUnknown() const { return !id && !isSource(); }
};

static unsigned activeEventMask(ArrayRef<Token> tokens, Counter counter);

static bool sortSourceKey(const Token &a, const Token &b) {
  if (a.execSource != b.execSource)
    return a.execSource < b.execSource;
  if (a.execSource)
    return xSourceGroup(a.events) < xSourceGroup(b.events);
  assert(a.source && b.source && "physical source key requires spans");
  if (a.source->regClass != b.source->regClass)
    return static_cast<unsigned>(a.source->regClass) <
           static_cast<unsigned>(b.source->regClass);
  if (a.source->begin != b.source->begin)
    return a.source->begin < b.source->begin;
  if (a.source->end != b.source->end)
    return a.source->end < b.source->end;
  return xSourceGroup(a.events) < xSourceGroup(b.events);
}

static bool sortKey(const Token &a, const Token &b) {
  if (a.counter != b.counter)
    return static_cast<unsigned>(a.counter) < static_cast<unsigned>(b.counter);
  if (a.isSource() != b.isSource())
    return a.isSource() < b.isSource();
  if (a.isSource())
    return sortSourceKey(a, b);
  return a.id.getAsOpaquePointer() < b.id.getAsOpaquePointer();
}

static bool sameKey(const Token &a, const Token &b) {
  if (a.counter != b.counter || a.source != b.source || a.id != b.id ||
      a.execSource != b.execSource)
    return false;
  return !a.isSource() || xSourceGroup(a.events) == xSourceGroup(b.events);
}

struct WaitRequirement {
  std::array<std::optional<unsigned>, kNumCounters> counts;

  bool hasWait() const {
    return llvm::any_of(counts, [](const std::optional<unsigned> &count) {
      return count.has_value();
    });
  }

  std::optional<unsigned> get(Counter counter) const {
    return counts[static_cast<unsigned>(counter)];
  }

  // MIN over required positions: `cnt(N)` drains everything at position >= N.
  void requireDrain(Counter counter, unsigned position) {
    assert(counter != Counter::None && "cannot drain absent counter");
    std::optional<unsigned> &slot = counts[static_cast<unsigned>(counter)];
    if (!slot || position < *slot)
      slot = position;
  }
};

//===----------------------------------------------------------------------===//
// Lattice payload
//===----------------------------------------------------------------------===//

struct WaitState {
  // Sorted by counter and source/value key; each key appears once.
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
    if (delta > std::numeric_limits<unsigned>::max() - t.position)
      t.position = std::numeric_limits<unsigned>::max();
    else
      t.position += delta;
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
                       if (threshold == 0 || (t.counter != Counter::Lgkm &&
                                              t.counter != Counter::X))
                         return true;
                       bool mixed = t.counter == Counter::Lgkm
                                        ? hasMultipleEvents(liveEvents)
                                        : hasMixedXGroups(liveEvents);
                       if (t.outOfOrder || mixed)
                         return false;
                       return true;
                     }),
      tokens.end());
}

static void dropXGroup(SmallVectorImpl<Token> &tokens, unsigned group,
                       unsigned threshold) {
  tokens.erase(std::remove_if(tokens.begin(), tokens.end(),
                              [&](const Token &t) {
                                return t.counter == Counter::X &&
                                       (xSourceGroup(t.events) & group) &&
                                       t.position >= threshold;
                              }),
               tokens.end());
}

static void applyWait(SmallVectorImpl<Token> &tokens,
                      const WaitRequirement &req) {
  for (unsigned i = 1; i < kNumCounters; ++i) {
    Counter counter = static_cast<Counter>(i);
    if (counter == Counter::X)
      continue;
    if (std::optional<unsigned> count = req.get(counter))
      dropDrained(tokens, counter, *count);
  }

  if (req.get(Counter::Km) == 0)
    dropXGroup(tokens, eventMask(waveamdmachine::WaitcntEvent::Smem), 0);
  bool pendingStore = llvm::any_of(
      tokens, [](const Token &t) { return t.counter == Counter::Store; });
  if (std::optional<unsigned> load = req.get(Counter::Load);
      load && !pendingStore)
    dropXGroup(tokens, eventMask(waveamdmachine::WaitcntEvent::Vmem), *load);
  if (std::optional<unsigned> xcnt = req.get(Counter::X))
    dropDrained(tokens, Counter::X, *xcnt);
}

static void clearCounter(SmallVectorImpl<Token> &tokens, Counter counter) {
  tokens.erase(
      std::remove_if(tokens.begin(), tokens.end(),
                     [&](const Token &t) { return t.counter == counter; }),
      tokens.end());
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
    if (t.isSource()) {
      kept.push_back(t);
      continue;
    }
    Block *defBlock = t.isUnknown() ? nullptr : definingBlock(t.id);
    if (t.isUnknown() || (defBlock && dom.dominates(defBlock, target))) {
      kept.push_back(t);
      continue;
    }
    mergeInto(escaping[static_cast<unsigned>(t.counter)], t);
  }
  state.tokens = std::move(kept);
  for (unsigned i = 1; i < kNumCounters; ++i) {
    if (escaping[i].position)
      insertOrMin(state.tokens,
                  Token{Value(), static_cast<Counter>(i), escaping[i].events,
                        *escaping[i].position, escaping[i].outOfOrder,
                        escaping[i].writesMemory});
  }
}

// Bump same-counter positions, then seed position-0 entries for each
// tagged result. Untagged issues share one conservative counter aggregate.
static bool issue(WaitState &state, Counter counter, unsigned count,
                  unsigned events, bool outOfOrder, bool writesMemory,
                  ValueRange tagged) {
  if (count == 0)
    count = 1;
  bumpCounter(state.tokens, counter, count);
  bool changed = false;
  if (tagged.empty()) {
    changed |= insertOrMin(state.tokens, Token{Value(), counter, events, 0,
                                               outOfOrder, writesMemory});
  } else {
    for (Value v : tagged)
      changed |= insertOrReplace(
          state.tokens, Token{v, counter, events, 0, outOfOrder, writesMemory});
  }
  return changed;
}

static bool issueSources(WaitState &state, Counter counter, unsigned count,
                         unsigned events, bool outOfOrder,
                         ArrayRef<RegSpan> sources, bool execSource) {
  if (count == 0)
    count = 1;
  bumpCounter(state.tokens, counter, count);
  bool changed = false;
  if (execSource)
    changed |= insertOrReplace(
        state.tokens, Token{ExecSourceTag{}, counter, events, 0, outOfOrder});
  for (RegSpan source : sources) {
    for (int64_t unit = source.begin; unit < source.end; ++unit)
      changed |= insertOrReplace(state.tokens,
                                 Token{RegSpan{source.regClass, unit, unit + 1},
                                       counter, events, 0, outOfOrder});
  }
  return changed;
}

// Per-counter MIN over `sources`' tokens, re-keyed under `result`.
static SmallVector<Token, 3> mergeSources(ArrayRef<Token> tokens,
                                          ValueRange sources, Value result) {
  std::array<TokenAggregate, kNumCounters> merged = {};
  for (Value src : sources) {
    for (const Token &t : tokens) {
      if (t.isSource() || t.id != src)
        continue;
      mergeInto(merged[static_cast<unsigned>(t.counter)], t);
    }
  }
  SmallVector<Token, 3> out;
  for (unsigned i = 1; i < kNumCounters; ++i) {
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

static bool isWaitcntOp(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::WaitcntOp>();
}

static bool isTokenOnlyOp(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::TokenOp>() ||
         op->hasTrait<OpTrait::waveamdmachine::TokenJoinOp>();
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

static std::optional<RegSpan> getAllocatedRegSpan(Value value) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || type.getIndex() < 0)
    return std::nullopt;
  return RegSpan{type.getRegClass(), type.getIndex(),
                 type.getIndex() + type.getWidth()};
}

static std::optional<unsigned> getExecIfEmissionSGPRCount(func::FuncOp func) {
  if (IntegerAttr count =
          func->getAttrOfType<IntegerAttr>("waveamdmachine.sgpr_count"))
    return static_cast<unsigned>(count.getInt());

  unsigned sgprCount = wave::getWaveAMDReservedSGPRs(func);
  func.walk([&](Operation *op) {
    for (Value result : op->getResults()) {
      std::optional<RegSpan> span = getAllocatedRegSpan(result);
      if (span && span->regClass == waveamdmachine::RegClass::SGPR)
        sgprCount = std::max(sgprCount, static_cast<unsigned>(span->end));
    }
  });
  FailureOr<unsigned> minimum =
      wave::getWaveAMDMinReportedSGPRs(func, "waveamd-insert-ticket-waits");
  if (failed(minimum))
    return std::nullopt;
  sgprCount = std::max(sgprCount, *minimum);
  return wave::getWaveAMDExecIfReservedSGPRCount(func, sgprCount);
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
  Skip,              // s_waitcnt, control-flow: handled separately.
  Issuer,            // VMEM/SMEM/LDS load or store: drain, then issue.
  Barrier,           // s_barrier: drain AND derive result tokens.
  CompletionNeutral, // No new event; forward dependency completion.
  CompletionFree,    // Issue order only; no drain or completion transfer.
  TokenOp,           // waveamdmachine.after / token_join: derive only.
  Endpgm,            // s_endpgm: implicit full drain.
  Generic,           // any other op: drain its operands.
};

static OpKind classifyOp(Operation *op) {
  if (isWaitcntOp(op) || isControlFlowOp(op))
    return OpKind::Skip;
  if (llvm::isa<waveamdmachine::GlobalAtomicAddAcqRelU32Op>(op))
    return OpKind::Barrier;
  if (isMemoryIssuer(op))
    return OpKind::Issuer;
  if (llvm::isa<waveamdmachine::SBarrierOp>(op))
    return OpKind::Barrier;
  if (op->hasTrait<OpTrait::waveamdmachine::CompletionNeutralTokenOp>())
    return OpKind::CompletionNeutral;
  if (op->hasTrait<OpTrait::waveamdmachine::CompletionFreeTokenOp>())
    return OpKind::CompletionFree;
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
// Target wait-counter model
//===----------------------------------------------------------------------===//

struct WaitTarget {
  std::optional<unsigned> execIfSaveBase;
  llvm::AMDGPU::IsaVersion isa;
  waveamdmachine::WaitCounterFamily family =
      waveamdmachine::WaitCounterFamily::Legacy;
  bool waitXcnt = false;
  bool requiresNopBeforeDeallocVGPRs = true;
};

static FailureOr<WaitTarget> getWaitTarget(Operation *op) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      waveamdmachine::createAMDGPUMCSubtargetInfo(
          op, "waveamd-insert-ticket-waits");
  if (failed(sti))
    return failure();
  WaitTarget target{std::nullopt, llvm::AMDGPU::getIsaVersion((*sti)->getCPU()),
                    llvm::AMDGPU::isGFX12Plus(**sti)
                        ? waveamdmachine::WaitCounterFamily::Gfx12Split
                        : waveamdmachine::WaitCounterFamily::Legacy,
                    (**sti).hasFeature(llvm::AMDGPU::FeatureWaitXcnt),
                    !(**sti).hasFeature(llvm::AMDGPU::FeatureGFX1250Insts)};
  if (auto func = dyn_cast<func::FuncOp>(op)) {
    std::optional<unsigned> sgprCount = getExecIfEmissionSGPRCount(func);
    if (sgprCount)
      target.execIfSaveBase = wave::getWaveAMDExecIfSaveBase(func, *sgprCount);
  }
  return target;
}

static std::optional<RegSpan> getExecIfSaveSpan(waveamdmachine::ExecIfOp execIf,
                                                const WaitTarget &target) {
  if (!target.execIfSaveBase)
    return std::nullopt;

  SmallVector<waveamdmachine::ExecIfOp, 4> nesting;
  for (Operation *op = execIf; op; op = op->getParentOp())
    if (auto nested = dyn_cast<waveamdmachine::ExecIfOp>(op))
      nesting.push_back(nested);

  unsigned cursor = 0;
  unsigned saveSlot = 0;
  unsigned width = 1;
  for (waveamdmachine::ExecIfOp nested : llvm::reverse(nesting)) {
    width = wave::getWaveAMDExecIfMaskDwords(nested);
    saveSlot = wave::alignWaveAMDExecIfSaveSlot(cursor, width);
    cursor = saveSlot + width;
  }
  return RegSpan{waveamdmachine::RegClass::SGPR,
                 *target.execIfSaveBase + saveSlot,
                 *target.execIfSaveBase + saveSlot + width};
}

static unsigned getLegacyCounterMax(Counter counter,
                                    const llvm::AMDGPU::IsaVersion &isa) {
  switch (counter) {
  case Counter::Vmem:
    return llvm::AMDGPU::getVmcntBitMask(isa);
  case Counter::Lgkm:
    return llvm::AMDGPU::getLgkmcntBitMask(isa);
  case Counter::Vscnt: {
    unsigned storeMax = llvm::AMDGPU::getStorecntBitMask(isa);
    return storeMax ? storeMax : llvm::AMDGPU::getVmcntBitMask(isa);
  }
  default:
    llvm_unreachable("expected legacy wait counter");
  }
}

static unsigned getSplitCounterMax(Counter counter,
                                   const llvm::AMDGPU::IsaVersion &isa) {
  switch (counter) {
  case Counter::Store:
    return llvm::AMDGPU::getStorecntBitMask(isa);
  case Counter::Load:
    return llvm::AMDGPU::getLoadcntBitMask(isa);
  case Counter::Ds:
    return llvm::AMDGPU::getDscntBitMask(isa);
  case Counter::Km:
    return llvm::AMDGPU::getKmcntBitMask(isa);
  case Counter::X:
    return llvm::AMDGPU::getXcntBitMask(isa);
  case Counter::Tensor:
    return waveamdmachine::getAMDGPUTensorcntBitMask(isa);
  default:
    llvm_unreachable("expected split wait counter");
  }
}

static unsigned getCounterMax(Counter counter,
                              const llvm::AMDGPU::IsaVersion &isa) {
  if (counter == Counter::None)
    return 0;
  if (counter == Counter::Vmem || counter == Counter::Lgkm ||
      counter == Counter::Vscnt)
    return getLegacyCounterMax(counter, isa);
  return getSplitCounterMax(counter, isa);
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
  unsigned activeEvents = activeEventMask(state.tokens, token.counter);
  if ((token.counter == Counter::Lgkm && hasMultipleEvents(activeEvents)) ||
      (token.counter == Counter::X && hasMixedXGroups(activeEvents)))
    return 0;
  return token.position;
}

//===----------------------------------------------------------------------===//
// Consumer-dep collection and wait computation
//===----------------------------------------------------------------------===//

static LogicalResult validateWaitOpFamily(Operation *op,
                                          const WaitTarget &target) {
  bool split = target.family == waveamdmachine::WaitCounterFamily::Gfx12Split;
  if (split &&
      llvm::isa<waveamdmachine::SWaitcntOp, waveamdmachine::SWaitcntVscntOp>(
          op))
    return op->emitError("legacy wait-counter op unsupported on target");
  if (!split && llvm::isa<waveamdmachine::SWaitcntSplitOp>(op))
    return op->emitError("split wait-counter op unsupported on target");
  return success();
}

static LogicalResult validateWaitLoweringPreconditions(Operation *op) {
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

static LogicalResult validateWaitEvent(Operation *op,
                                       const WaitTarget &target) {
  waveamdmachine::WaitcntInfo info = getWaitcntInfo(op);
  if (info.isIssuer() && !waveamdmachine::getWaitcntCounterMapping(
                             info.event, target.family, target.waitXcnt))
    return op->emitError() << waveamdmachine::stringifyWaitcntEvent(info.event)
                           << " wait event unsupported on target";
  return success();
}

static LogicalResult validateWaveAMDMachineOp(Operation *op,
                                              const WaitTarget &target) {
  if (!isWaveAMDMachineOp(op))
    return success();
  if (failed(validateWaitOpFamily(op, target)))
    return failure();
  if (failed(validateWaitLoweringPreconditions(op)))
    return failure();
  return validateWaitEvent(op, target);
}

static void requireValue(WaitRequirement &req, Value value,
                         const WaitState &state) {
  for (unsigned ci = 1; ci < kNumCounters; ++ci) {
    Counter c = static_cast<Counter>(ci);
    if (c == Counter::X)
      continue;
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
  for (unsigned ci = 1; ci < kNumCounters; ++ci) {
    Counter c = static_cast<Counter>(ci);
    if (c == Counter::X)
      continue;
    const Token *t = lat::find(state.tokens, c, value);
    if (t && t->writesMemory)
      req.requireDrain(c, waitPosition(state, *t));
  }
}

static void requireOverlappingRegisterDef(WaitRequirement &req, RegSpan def,
                                          const WaitState &state) {
  for (const Token &t : state.tokens) {
    std::optional<RegSpan> pendingSpan;
    if (t.isSource())
      pendingSpan = t.source;
    else if (!t.isUnknown())
      pendingSpan = getAllocatedRegSpan(t.id);
    if (pendingSpan && overlaps(def, *pendingSpan))
      req.requireDrain(t.counter, waitPosition(state, t));
  }
}

static void requireOverlappingRegisterDefs(WaitRequirement &req, Operation *op,
                                           const WaitState &state) {
  if (!emitsMachineInst(op))
    return;
  for (Value result : op->getResults())
    if (std::optional<RegSpan> span = getAllocatedRegSpan(result))
      requireOverlappingRegisterDef(req, *span, state);
  auto fixedDefs =
      dyn_cast<waveamdmachine::FixedPhysicalRegisterDefsOpInterface>(op);
  if (!fixedDefs)
    return;
  for (RegSpan span : fixedDefs.getFixedPhysicalRegisterDefs())
    requireOverlappingRegisterDef(req, span, state);
}

static void requireExecDef(WaitRequirement &req, const WaitState &state) {
  for (const Token &t : state.tokens)
    if (t.execSource)
      req.requireDrain(t.counter, waitPosition(state, t));
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

static void requireExecIfYieldTransition(WaitRequirement &req,
                                         waveamdmachine::YieldOp yield,
                                         const WaitState &state) {
  auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(yield->getParentOp());
  if (!execIf)
    return;
  requireExecDef(req, state);
  for (auto [result, value] :
       llvm::zip_equal(execIf.getResults(), yield.getValues())) {
    if (isa<waveamdmachine::MemTokenType>(result.getType()))
      continue;
    if (value.getDefiningOp<waveamdmachine::UninitOp>())
      continue;
    if (hasSameAllocatedReg(result, value))
      continue;
    requireValue(req, value, state);
    if (std::optional<RegSpan> span = getAllocatedRegSpan(result))
      requireOverlappingRegisterDef(req, *span, state);
  }
}

static WaitRequirement computeControlFlowRequirement(Operation *op,
                                                     const WaitState &state,
                                                     const WaitTarget &target) {
  WaitRequirement req;
  if (auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(op)) {
    requireValue(req, execIf.getCondition(), state);
    if (std::optional<RegSpan> save = getExecIfSaveSpan(execIf, target))
      requireOverlappingRegisterDef(req, *save, state);
  } else if (auto uniformIf = dyn_cast<waveamdmachine::UniformIfOp>(op))
    requireValue(req, uniformIf.getCondition(), state);
  else if (auto yield = dyn_cast<waveamdmachine::YieldOp>(op))
    requireExecIfYieldTransition(req, yield, state);
  if (op->hasTrait<OpTrait::waveamdmachine::WritesExecOp>())
    requireExecDef(req, state);
  return req;
}

static bool isD16LowPreservedOperand(OpOperand &operand) {
  auto load = dyn_cast<waveamdmachine::BufferLoadU8D16HiOp>(operand.getOwner());
  if (!load || &operand != &load.getPreservedMutable())
    return false;
  return load.getPreserved().getDefiningOp<waveamdmachine::BufferLoadU8D16Op>();
}

static WaitRequirement computeRequirement(Operation *op, const WaitState &state,
                                          const WaitTarget &target) {
  if (isControlFlowOp(op))
    return computeControlFlowRequirement(op, state, target);
  WaitRequirement req;
  if (llvm::isa<waveamdmachine::SEndpgmOp>(op))
    return req;
  bool issuer = isMemoryIssuer(op);
  for (OpOperand &operand : op->getOpOperands()) {
    if (isD16LowPreservedOperand(operand))
      continue;
    if (isMemToken(operand.get()) && isa<waveamdmachine::DmaIssueDelayOp>(op))
      continue;
    // Issuer `after` tokens order issue. Completion waits stay explicit.
    if (issuer && isMemToken(operand.get())) {
      requireIssuerToken(req, operand.get(), state, op);
      continue;
    }
    requireValue(req, operand.get(), state);
  }
  requireOverlappingRegisterDefs(req, op, state);
  if (op->hasTrait<OpTrait::waveamdmachine::WritesExecOp>())
    requireExecDef(req, state);
  return req;
}

static void collectIssuerSources(Operation *op,
                                 SmallVectorImpl<RegSpan> &sources) {
  for (Value operand : op->getOperands())
    if (std::optional<RegSpan> span = getAllocatedRegSpan(operand))
      sources.push_back(*span);

  if (auto load = dyn_cast<waveamdmachine::SLoadB32Op>(op)) {
    if (std::optional<RegSpan> span =
            waveamdmachine::parseSGPRRegisterSpan(load.getBase()))
      sources.push_back(*span);
  } else if (auto load = dyn_cast<waveamdmachine::SLoadB64Op>(op)) {
    if (std::optional<RegSpan> span =
            waveamdmachine::parseSGPRRegisterSpan(load.getBase()))
      sources.push_back(*span);
  } else if (auto load = dyn_cast<waveamdmachine::SLoadB128Op>(op)) {
    if (std::optional<RegSpan> span =
            waveamdmachine::parseSGPRRegisterSpan(load.getBase()))
      sources.push_back(*span);
  }
}

static bool isVmemSourceEvent(waveamdmachine::WaitcntEvent event) {
  return event == waveamdmachine::WaitcntEvent::Vmem ||
         event == waveamdmachine::WaitcntEvent::VmemStore ||
         event == waveamdmachine::WaitcntEvent::ScratchStore;
}

static bool isSmemSourceEvent(waveamdmachine::WaitcntEvent event) {
  return event == waveamdmachine::WaitcntEvent::Smem;
}

static void applyImplicitXGroupSwitch(Operation *op, WaitState &state,
                                      const WaitTarget &target) {
  if (!target.waitXcnt || !isMemoryIssuer(op))
    return;
  waveamdmachine::WaitcntEvent event = getWaitcntInfo(op).event;
  if (isVmemSourceEvent(event))
    lat::dropXGroup(state.tokens, eventMask(waveamdmachine::WaitcntEvent::Smem),
                    0);
  else if (isSmemSourceEvent(event))
    lat::dropXGroup(state.tokens, eventMask(waveamdmachine::WaitcntEvent::Vmem),
                    0);
}

static void recordIssue(Operation *op, WaitState &state,
                        const WaitTarget &target) {
  waveamdmachine::WaitcntInfo info = getWaitcntInfo(op);
  std::optional<waveamdmachine::WaitcntCounterMapping> mapping =
      waveamdmachine::getWaitcntCounterMapping(info.event, target.family,
                                               target.waitXcnt);
  if (!mapping)
    return;
  SmallVector<Value, 2> results;
  collectIssuerResults(op, results);
  lat::issue(state, mapping->completion, info.issueCount, eventMask(info.event),
             info.outOfOrder, isMemoryWriteIssuer(op), results);
  if (mapping->source == Counter::None)
    return;

  SmallVector<RegSpan, 4> sources;
  collectIssuerSources(op, sources);
  lat::issueSources(state, mapping->source, info.issueCount,
                    eventMask(info.event), info.outOfOrder, sources,
                    isVmemSourceEvent(info.event));
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

// Fences and token-forwarding ops inherit per-counter operand minima.
static void deriveResultTokens(Operation *op, WaitState &state) {
  for (Value result : op->getResults()) {
    SmallVector<Token, 3> derived =
        lat::mergeSources(state.tokens, op->getOperands(), result);
    for (Token t : derived)
      lat::insertOrMin(state.tokens, t);
  }
}

static bool implicitlyDrainsXcnt(Operation *op) {
  if (llvm::isa<waveamdmachine::ExecIfOp, waveamdmachine::UniformIfOp,
                waveamdmachine::ContinueIfOp, waveamdmachine::SCBranchExeczOp,
                waveamdmachine::SCBranchScc0Op, waveamdmachine::SCBranchScc1Op,
                BranchOpInterface>(op))
    return true;
  if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op))
    return static_cast<bool>(loop.getEntryCond());
  return llvm::isa<waveamdmachine::BarrierArriveOp,
                   waveamdmachine::BarrierWaitOp, waveamdmachine::SBarrierOp,
                   waveamdmachine::SEndpgmOp, waveamdmachine::SGetregHwIdOp,
                   waveamdmachine::SGetregShaderCyclesOp,
                   waveamdmachine::SSendmsgDeallocVgprsOp,
                   waveamdmachine::SSetpcB64Op, waveamdmachine::SSetVgprMsbOp>(
      op);
}

static void observeExistingWaitcnt(Operation *op, WaitState &state,
                                   const WaitTarget &target) {
  WaitRequirement observed;
  if (auto wait = llvm::dyn_cast<waveamdmachine::SWaitcntOp>(op)) {
    unsigned vmMax = getCounterMax(Counter::Vmem, target.isa);
    unsigned lgMax = getCounterMax(Counter::Lgkm, target.isa);
    if (std::optional<uint32_t> vm = wait.getVmcnt(); vm && *vm < vmMax)
      observed.requireDrain(Counter::Vmem, *vm);
    if (std::optional<uint32_t> lg = wait.getLgkmcnt(); lg && *lg < lgMax)
      observed.requireDrain(Counter::Lgkm, *lg);
  }
  if (auto wait = llvm::dyn_cast<waveamdmachine::SWaitcntVscntOp>(op)) {
    observed.requireDrain(Counter::Vscnt, wait.getVscnt());
  }
  if (auto wait = llvm::dyn_cast<waveamdmachine::SWaitcntSplitOp>(op)) {
    const std::array<std::pair<Counter, std::optional<uint32_t>>, 6> counts = {{
        {Counter::Load, wait.getLoadcnt()},
        {Counter::Store, wait.getStorecnt()},
        {Counter::Ds, wait.getDscnt()},
        {Counter::Km, wait.getKmcnt()},
        {Counter::X, wait.getXcnt()},
        {Counter::Tensor, wait.getTensorcnt()},
    }};
    for (auto [counter, count] : counts)
      if (count)
        observed.requireDrain(counter, *count);
  }
  lat::applyWait(state.tokens, observed);
}

static void clampSaturatedCounterFields(WaitRequirement &req,
                                        const WaitTarget &target) {
  for (unsigned i = 1; i < kNumCounters; ++i) {
    Counter counter = static_cast<Counter>(i);
    std::optional<unsigned> &count = req.counts[i];
    unsigned max = getCounterMax(counter, target.isa);
    // VSCNT max is a valid partial drain on legacy targets.
    if (counter == Counter::Vscnt) {
      if (count && *count > max)
        count = max;
      continue;
    }
    if (count && max > 0 && *count >= max)
      count = max - 1;
  }
}

// `emit` is a no-op during analysis, the s_waitcnt emitter during rewrite.
template <typename EmitFn>
static void applyDrain(Operation *op, WaitState &state,
                       const WaitTarget &target, EmitFn emit) {
  WaitRequirement req = computeRequirement(op, state, target);
  clampSaturatedCounterFields(req, target);
  emit(op, req);
  lat::applyWait(state.tokens, req);
}

static void applyImplicitXDrain(Operation *op, WaitState &state,
                                const WaitTarget &target) {
  if (target.waitXcnt && implicitlyDrainsXcnt(op))
    lat::clearCounter(state.tokens, Counter::X);
}

// Shared dispatch for analysis and rewrite: same state transfer, the
// only delta is the (conditional) `emit`.
template <typename EmitFn>
static void runTransfer(Operation *op, WaitState &state,
                        const WaitTarget &target, EmitFn emit) {
  switch (classifyOp(op)) {
  case OpKind::Skip:
    if (isWaitcntOp(op)) {
      observeExistingWaitcnt(op, state, target);
      return;
    }
    applyDrain(op, state, target, emit);
    break;
  case OpKind::Issuer:
    applyDrain(op, state, target, emit);
    applyImplicitXGroupSwitch(op, state, target);
    recordIssue(op, state, target);
    deriveIssuerDependencyTokens(op, state);
    break;
  case OpKind::Barrier:
    // Drain ahead of the fence AND seed result tokens so downstream
    // loads of the same arena depend on it.
    applyDrain(op, state, target, emit);
    applyImplicitXGroupSwitch(op, state, target);
    deriveResultTokens(op, state);
    break;
  case OpKind::CompletionNeutral:
    deriveResultTokens(op, state);
    break;
  case OpKind::CompletionFree:
    break;
  case OpKind::TokenOp:
    deriveResultTokens(op, state);
    break;
  case OpKind::Endpgm:
    state.tokens.clear();
    return;
  case OpKind::Generic:
    applyDrain(op, state, target, emit);
    break;
  }
  // Def hazards precede the instruction's implicit X drain.
  applyImplicitXDrain(op, state, target);
}

//===----------------------------------------------------------------------===//
// Token analysis
//===----------------------------------------------------------------------===//

class TokenWaitAnalysis : public DenseForwardDataFlowAnalysis<WaitLattice> {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(TokenWaitAnalysis)

  TokenWaitAnalysis(DataFlowSolver &solver, DominanceInfo &dom,
                    const WaitTarget &target)
      : DenseForwardDataFlowAnalysis(solver), dom(dom), target(target) {}

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
    if (failed(validateWaveAMDMachineOp(op, target)))
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

    if (regionTo && target.waitXcnt &&
        implicitlyDrainsXcnt(branch.getOperation()))
      lat::clearCounter(next.tokens, Counter::X);
    Block *targetBlock =
        regionTo ? &branch->getRegion(*regionTo).front() : branch->getBlock();
    if (targetBlock)
      lat::collapseEscaping(next, targetBlock, dom);
    propagateIfChanged(after, after->joinWith(next));
  }

private:
  void transferOp(Operation *op, WaitState &state) {
    auto noop = [](Operation *, const WaitRequirement &) {};
    runTransfer(op, state, target, noop);
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
      for (unsigned ci = 1; ci < kNumCounters; ++ci) {
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
  const WaitTarget &target;
};

//===----------------------------------------------------------------------===//
// Rewrite step
//===----------------------------------------------------------------------===//

static IntegerAttr getCounterAttr(OpBuilder &builder, unsigned value) {
  return builder.getI32IntegerAttr(value);
}

static void emitWaits(OpBuilder &builder, Operation *op,
                      const WaitRequirement &req, const WaitTarget &target) {
  builder.setInsertionPoint(op);
  if (target.family == waveamdmachine::WaitCounterFamily::Gfx12Split) {
    auto attr = [&](Counter counter) -> IntegerAttr {
      std::optional<unsigned> count = req.get(counter);
      return count ? getCounterAttr(builder, *count) : IntegerAttr();
    };
    waveamdmachine::SWaitcntSplitOp::create(
        builder, op->getLoc(), attr(Counter::Load), attr(Counter::Store),
        attr(Counter::Ds), attr(Counter::Km), attr(Counter::X),
        attr(Counter::Tensor));
    return;
  }

  std::optional<unsigned> vmcnt = req.get(Counter::Vmem);
  std::optional<unsigned> lgkmcnt = req.get(Counter::Lgkm);
  if (vmcnt || lgkmcnt) {
    waveamdmachine::SWaitcntOp::create(
        builder, op->getLoc(),
        vmcnt ? getCounterAttr(builder, *vmcnt) : IntegerAttr(),
        /*expcnt=*/IntegerAttr(),
        lgkmcnt ? getCounterAttr(builder, *lgkmcnt) : IntegerAttr());
  }
  if (std::optional<unsigned> vscnt = req.get(Counter::Vscnt)) {
    waveamdmachine::SWaitcntVscntOp::create(builder, op->getLoc(),
                                            getCounterAttr(builder, *vscnt));
  }
}

static void noteAllocatedVGPR(Value value, unsigned &count) {
  waveamdmachine::RegType type =
      dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR ||
      type.getIndex() < 0)
    return;
  unsigned end = static_cast<unsigned>(type.getIndex() + type.getWidth());
  count = std::max(count, end);
}

static unsigned getAllocatedVGPRCount(func::FuncOp func) {
  unsigned count = 0;
  func.walk([&](Operation *op) {
    for (Value value : llvm::concat<Value>(op->getOperands(), op->getResults()))
      noteAllocatedVGPR(value, count);
    for (Region &region : op->getRegions())
      for (Block &block : region)
        for (BlockArgument arg : block.getArguments())
          noteAllocatedVGPR(arg, count);
  });
  return count;
}

static FailureOr<bool>
isVGPRLimited(func::FuncOp func, const llvm::AMDGPU::IsaVersion &isaVersion) {
  if (!func->hasAttr(wave::WaveDialect::getKernelAttrName()) ||
      !waveamdmachine::SSendmsgDeallocVgprsOp::isSupportedOnIsa(isaVersion))
    return false;
  FailureOr<wave::WaveAMDRegisterLimits> limits =
      wave::getWaveAMDRegisterLimits(func);
  if (failed(limits))
    return failure();
  assert(limits->maxWavesPerEU < limits->maxVGPRsForWaves.size() &&
         "maximum-wave VGPR budget missing");
  unsigned maxOccupancyVGPRs = limits->maxVGPRsForWaves[limits->maxWavesPerEU];
  return getAllocatedVGPRCount(func) > maxOccupancyVGPRs;
}

static bool hasPendingEvent(const WaitState &state, Counter counter,
                            waveamdmachine::WaitcntEvent event) {
  return (activeEventMask(state.tokens, counter) & eventMask(event)) != 0;
}

static bool canDeallocVGPRs(const WaitState &state, const WaitTarget &target) {
  Counter storeCounter =
      target.family == waveamdmachine::WaitCounterFamily::Gfx12Split
          ? Counter::Store
          : Counter::Vscnt;
  return llvm::any_of(state.tokens,
                      [&](const Token &token) {
                        return token.counter == storeCounter;
                      }) &&
         !hasPendingEvent(state, storeCounter,
                          waveamdmachine::WaitcntEvent::ScratchStore);
}

static void emitVGPRDealloc(OpBuilder &builder, Operation *endpgm,
                            const WaitTarget &target) {
  builder.setInsertionPoint(endpgm);
  if (target.requiresNopBeforeDeallocVGPRs) {
    Value zero = waveamdmachine::ImmOp::create(
        builder, endpgm->getLoc(),
        waveamdmachine::ImmType::get(builder.getContext()), 0);
    waveamdmachine::SNopOp::create(builder, endpgm->getLoc(), zero);
  }
  waveamdmachine::SSendmsgDeallocVgprsOp::create(builder, endpgm->getLoc());
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
    FailureOr<WaitTarget> target = getWaitTarget(func);
    if (failed(target))
      return failure();
    FailureOr<bool> vgprLimited = isVGPRLimited(func, target->isa);
    if (failed(vgprLimited))
      return failure();

    DominanceInfo dom(func);
    DataFlowSolver solver;
    loadBaselineAnalyses(solver);
    solver.load<TokenWaitAnalysis>(dom, *target);
    if (failed(solver.initializeAndRun(func)))
      return failure();

    rewriteWithSolver(func, solver, *target, *vgprLimited);
    return success();
  }

  // Per-block local state so consecutive consumers see drains from the
  // wait we just emitted (the solver's per-op state does not).
  void rewriteWithSolver(func::FuncOp func, DataFlowSolver &solver,
                         const WaitTarget &target, bool vgprLimited) {
    OpBuilder builder(func.getContext());
    SmallVector<Block *> blocks;
    collectBlocks(func.getBody(), blocks);
    for (Block *block : blocks)
      rewriteBlock(block, solver, target, vgprLimited, builder);
  }

  void rewriteBlock(Block *block, DataFlowSolver &solver,
                    const WaitTarget &target, bool vgprLimited,
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
      rewriteOp(op, local, solver, target, vgprLimited, builder);
  }

  void rewriteOp(Operation *op, WaitState &local, DataFlowSolver &solver,
                 const WaitTarget &target, bool vgprLimited,
                 OpBuilder &builder) {
    auto emit = [&](Operation *op, const WaitRequirement &req) {
      if (req.hasWait())
        emitWaits(builder, op, req, target);
    };
    if (vgprLimited && llvm::isa<waveamdmachine::SEndpgmOp>(op) &&
        canDeallocVGPRs(local, target))
      emitVGPRDealloc(builder, op, target);

    // Control-flow ops: framework hooks computed the post-op state.
    // Refresh `local` so a downstream consumer sees the joined region
    // result. Inner regions are visited separately via collectBlocks.
    if (isControlFlowOp(op)) {
      runTransfer(op, local, target, emit);
      if (auto *post =
              solver.lookupState<WaitLattice>(solver.getProgramPointAfter(op)))
        local = post->get();
      return;
    }
    runTransfer(op, local, target, emit);
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
