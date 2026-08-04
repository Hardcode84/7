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
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Dominance.h"
#include "mlir/Interfaces/CallInterfaces.h"
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

namespace machine_traits = OpTrait::waveamdmachine;

//===----------------------------------------------------------------------===//
// Counter and token model
//===----------------------------------------------------------------------===//

using Counter = waveamdmachine::WaitcntCounter;
static constexpr unsigned kNumCounters =
    waveamdmachine::getMaxEnumValForWaitcntCounter() + 1;
using ExpertCounter = waveamdmachine::ExpertCounter;
using ExpertEvent = waveamdmachine::ExpertEvent;
static constexpr unsigned kNumExpertCounters =
    waveamdmachine::getMaxEnumValForExpertCounter() + 1;

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

struct ExpertToken {
  std::optional<RegSpan> source;
  ExpertEvent event;
  unsigned position;
  ExpertCounter counter;

  ExpertToken(RegSpan source, ExpertCounter counter, unsigned position)
      : source(source), event(ExpertEvent::None), position(position),
        counter(counter) {}

  ExpertToken(ExpertEvent event, ExpertCounter counter, unsigned position)
      : event(event), position(position), counter(counter) {}

  bool isEventMarker() const { return !source; }
};

static bool sortExpertKey(const ExpertToken &lhs, const ExpertToken &rhs) {
  if (lhs.counter != rhs.counter)
    return static_cast<unsigned>(lhs.counter) <
           static_cast<unsigned>(rhs.counter);
  if (lhs.isEventMarker() != rhs.isEventMarker())
    return lhs.isEventMarker();
  if (lhs.isEventMarker())
    return static_cast<unsigned>(lhs.event) < static_cast<unsigned>(rhs.event);
  assert(lhs.source && rhs.source && "expert source key requires spans");
  if (lhs.source->regClass != rhs.source->regClass)
    return static_cast<unsigned>(lhs.source->regClass) <
           static_cast<unsigned>(rhs.source->regClass);
  if (lhs.source->begin != rhs.source->begin)
    return lhs.source->begin < rhs.source->begin;
  return lhs.source->end < rhs.source->end;
}

static bool sameExpertKey(const ExpertToken &lhs, const ExpertToken &rhs) {
  if (lhs.counter != rhs.counter || lhs.isEventMarker() != rhs.isEventMarker())
    return false;
  if (lhs.isEventMarker())
    return lhs.event == rhs.event;
  return lhs.source == rhs.source;
}

struct ExpertWaitRequirement {
  std::array<std::optional<unsigned>, kNumExpertCounters> counts;

  bool hasWait() const {
    return llvm::any_of(counts, [](const std::optional<unsigned> &count) {
      return count.has_value();
    });
  }

  std::optional<unsigned> get(ExpertCounter counter) const {
    return counts[static_cast<unsigned>(counter)];
  }

  void requireDrain(ExpertCounter counter, unsigned position) {
    std::optional<unsigned> &slot = counts[static_cast<unsigned>(counter)];
    if (!slot || position < *slot)
      slot = position;
  }
};

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

static bool requiresZeroWait(Counter counter, unsigned activeEvents) {
  if (counter == Counter::Km)
    return (activeEvents & eventMask(waveamdmachine::WaitcntEvent::Smem)) ||
           hasMultipleEvents(activeEvents);
  if (counter == Counter::Lgkm)
    return hasMultipleEvents(activeEvents);
  if (counter == Counter::X)
    return hasMixedXGroups(activeEvents);
  return false;
}

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

static bool sameTokenState(const Token &a, const Token &b) {
  return sameKey(a, b) && a.events == b.events && a.position == b.position &&
         a.outOfOrder == b.outOfOrder && a.writesMemory == b.writesMemory;
}

static bool sameExpertTokenState(const ExpertToken &a, const ExpertToken &b) {
  return sameExpertKey(a, b) && a.position == b.position;
}

template <typename T, typename Equal>
static bool sameTokenSequence(ArrayRef<T> lhs, ArrayRef<T> rhs, Equal equal) {
  if (lhs.size() != rhs.size())
    return false;
  for (auto [a, b] : llvm::zip(lhs, rhs))
    if (!equal(a, b))
      return false;
  return true;
}

struct WaitState {
  // Sorted by counter and source/value key; each key appears once.
  SmallVector<Token, 4> tokens;
  SmallVector<ExpertToken, 4> expertTokens;

  bool operator==(const WaitState &rhs) const {
    return sameTokenSequence<Token>(tokens, rhs.tokens, sameTokenState) &&
           sameTokenSequence<ExpertToken>(expertTokens, rhs.expertTokens,
                                          sameExpertTokenState);
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
    if (state.tokens.empty() && state.expertTokens.empty())
      return ChangeResult::NoChange;
    state.tokens.clear();
    state.expertTokens.clear();
    return ChangeResult::Change;
  }

  void print(raw_ostream &os) const override {
    os << "tokens=" << state.tokens.size()
       << " expert=" << state.expertTokens.size();
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
  tokens.erase(std::remove_if(tokens.begin(), tokens.end(),
                              [&](const Token &t) {
                                if (t.counter != counter ||
                                    t.position < threshold)
                                  return false;
                                if (threshold == 0)
                                  return true;
                                if (t.outOfOrder ||
                                    requiresZeroWait(t.counter, liveEvents))
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

static bool matchesIssuedEvent(const Token &token, Counter counter,
                               ValueRange ids, unsigned mask) {
  return token.counter == counter && llvm::is_contained(ids, token.id) &&
         (token.events & mask);
}

static void dropIssuedEvent(SmallVectorImpl<Token> &tokens, Counter counter,
                            ValueRange ids,
                            waveamdmachine::WaitcntEvent event) {
  unsigned mask = eventMask(event);
  std::optional<unsigned> completedPosition;
  for (Token &token : tokens)
    if (matchesIssuedEvent(token, counter, ids, mask)) {
      if (!completedPosition || token.position < *completedPosition)
        completedPosition = token.position;
      token.events &= ~mask;
    }
  tokens.erase(
      std::remove_if(tokens.begin(), tokens.end(),
                     [](const Token &token) { return token.events == 0; }),
      tokens.end());
  if (!completedPosition)
    return;
  for (Token &token : tokens)
    if (token.counter == counter && token.position > *completedPosition)
      --token.position;
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

namespace expert {

static bool insertOrMin(SmallVectorImpl<ExpertToken> &tokens,
                        ExpertToken token) {
  auto it = llvm::lower_bound(tokens, token, sortExpertKey);
  if (it != tokens.end() && sameExpertKey(*it, token)) {
    if (token.position >= it->position)
      return false;
    it->position = token.position;
    return true;
  }
  tokens.insert(it, token);
  return true;
}

static bool insertOrReplace(SmallVectorImpl<ExpertToken> &tokens,
                            ExpertToken token) {
  auto it = llvm::lower_bound(tokens, token, sortExpertKey);
  if (it != tokens.end() && sameExpertKey(*it, token)) {
    if (token.position == it->position)
      return false;
    *it = token;
    return true;
  }
  tokens.insert(it, token);
  return true;
}

static void bumpCounter(SmallVectorImpl<ExpertToken> &tokens,
                        ExpertCounter counter, unsigned delta) {
  for (ExpertToken &token : tokens) {
    if (token.counter != counter)
      continue;
    if (delta > std::numeric_limits<unsigned>::max() - token.position)
      token.position = std::numeric_limits<unsigned>::max();
    else
      token.position += delta;
  }
}

static void issue(WaitState &state, ExpertCounter counter, unsigned count,
                  ExpertEvent event, ArrayRef<RegSpan> sources) {
  if (count == 0)
    return;
  bumpCounter(state.expertTokens, counter, count);
  insertOrReplace(state.expertTokens, ExpertToken{event, counter, 0});
  for (RegSpan source : sources)
    for (int64_t unit = source.begin; unit < source.end; ++unit)
      insertOrReplace(
          state.expertTokens,
          ExpertToken{RegSpan{source.regClass, unit, unit + 1}, counter, 0});
}

static unsigned activeEventMask(ArrayRef<ExpertToken> tokens,
                                ExpertCounter counter) {
  unsigned mask = 0;
  for (const ExpertToken &token : tokens)
    if (token.counter == counter && token.isEventMarker())
      mask |= static_cast<unsigned>(token.event);
  return mask;
}

static void requireSpan(ExpertWaitRequirement &req, RegSpan span,
                        ExpertCounter counter, const WaitState &state) {
  bool mixed = hasMultipleEvents(activeEventMask(state.expertTokens, counter));
  for (const ExpertToken &token : state.expertTokens) {
    if (token.counter != counter || !token.source ||
        !overlaps(span, *token.source))
      continue;
    req.requireDrain(counter, mixed ? 0 : token.position);
  }
}

static void requireAll(ExpertWaitRequirement &req, ExpertCounter counter,
                       const WaitState &state) {
  if (llvm::any_of(state.expertTokens, [&](const ExpertToken &token) {
        return token.counter == counter;
      }))
    req.requireDrain(counter, 0);
}

static void applyCounterWait(SmallVectorImpl<ExpertToken> &tokens,
                             ExpertCounter counter, unsigned threshold) {
  tokens.erase(std::remove_if(tokens.begin(), tokens.end(),
                              [&](const ExpertToken &token) {
                                return token.counter == counter &&
                                       token.position >= threshold;
                              }),
               tokens.end());
}

static void applyWait(WaitState &state, const ExpertWaitRequirement &req) {
  for (unsigned i = 0; i < kNumExpertCounters; ++i) {
    ExpertCounter counter = static_cast<ExpertCounter>(i);
    if (std::optional<unsigned> count = req.get(counter))
      applyCounterWait(state.expertTokens, counter, *count);
  }
}

static void clear(WaitState &state) { state.expertTokens.clear(); }

} // namespace expert

ChangeResult WaitLattice::joinWith(const WaitState &incoming) {
  bool changed = false;
  for (const Token &tok : incoming.tokens)
    changed |= lat::insertOrMin(state.tokens, tok);
  for (const ExpertToken &token : incoming.expertTokens)
    changed |= expert::insertOrMin(state.expertTokens, token);
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
  BarrierIssuer,     // Barrier fence which also creates a completion ticket.
  Barrier,           // s_barrier: drain AND derive result tokens.
  CompletionNeutral, // No new event; forward dependency completion.
  CompletionFree,    // Issue order only; no drain or completion transfer.
  TokenOp,           // waveamdmachine.after / token_join: derive only.
  Call,              // callee prologue drains incoming ABI state.
  Return,            // drain callable-function state.
  Endpgm,            // s_endpgm: implicit full drain.
  Generic,           // any other op: drain its operands.
};

static std::optional<OpKind> classifyProtocolOp(Operation *op) {
  if (op->hasTrait<OpTrait::waveamdmachine::CompletionNeutralTokenOp>())
    return OpKind::CompletionNeutral;
  if (op->hasTrait<OpTrait::waveamdmachine::CompletionFreeTokenOp>())
    return OpKind::CompletionFree;
  if (isTokenOnlyOp(op))
    return OpKind::TokenOp;
  if (llvm::isa<CallOpInterface>(op))
    return OpKind::Call;
  if (llvm::isa<waveamdmachine::SSetpcB64Op>(op))
    return OpKind::Return;
  if (llvm::isa<waveamdmachine::SEndpgmOp>(op))
    return OpKind::Endpgm;
  return std::nullopt;
}

static OpKind classifyOp(Operation *op) {
  if (isWaitcntOp(op) || isControlFlowOp(op))
    return OpKind::Skip;
  if (llvm::isa<waveamdmachine::GlobalAtomicAddAcqRelU32Op>(op))
    return OpKind::Barrier;
  if (isMemoryIssuer(op) &&
      llvm::isa<waveamdmachine::SBarrierSignalIsFirstOp>(op))
    return OpKind::BarrierIssuer;
  if (isMemoryIssuer(op))
    return OpKind::Issuer;
  if (llvm::isa<waveamdmachine::ClusterBarrierOp, waveamdmachine::SBarrierOp,
                waveamdmachine::SBarrierSignalOp,
                waveamdmachine::SBarrierWaitOp>(op))
    return OpKind::Barrier;
  if (std::optional<OpKind> kind = classifyProtocolOp(op))
    return *kind;
  return OpKind::Generic;
}

static bool isExpertVALU(Operation *op) {
  return op->hasTrait<machine_traits::VALUOp>() ||
         op->hasTrait<machine_traits::ExpertVALUOp>();
}

static ExpertEvent classifyExpertVALUEvent(Operation *op) {
  if (op->hasTrait<machine_traits::MFMAOp>() ||
      op->hasTrait<machine_traits::WMMAOp>() ||
      llvm::isa<waveamdmachine::MMAOpInterface>(op))
    return ExpertEvent::Xdl;
  if (op->hasTrait<machine_traits::TransOp>())
    return ExpertEvent::Trans;
  if (op->hasTrait<machine_traits::DPMACCOp>())
    return ExpertEvent::DPMACC;
  return ExpertEvent::CSMACC;
}

static ExpertEvent classifyExpertMemoryEvent(Operation *op) {
  if (op->hasTrait<machine_traits::TensorMemoryOp>())
    return ExpertEvent::None;
  if (op->hasTrait<machine_traits::FlatMemoryOp>())
    return ExpertEvent::Flat;
  if (op->hasTrait<machine_traits::DSOp>())
    return ExpertEvent::Lds;
  if (op->hasTrait<machine_traits::VMEMLoadOp>() ||
      op->hasTrait<machine_traits::VMEMStoreOp>())
    return ExpertEvent::Vmem;
  return ExpertEvent::None;
}

static ExpertEvent classifyExpertEvent(Operation *op) {
  if (!isWaveAMDMachineOp(op) || op->hasTrait<machine_traits::NoMachineInst>())
    return ExpertEvent::None;
  if (isExpertVALU(op))
    return classifyExpertVALUEvent(op);
  return classifyExpertMemoryEvent(op);
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
  WaitTarget(const llvm::AMDGPU::IsaVersion &isa, unsigned wavefrontSize)
      : isa(isa), wavefrontSize(wavefrontSize) {}

  std::optional<unsigned> execIfSaveBase;
  llvm::AMDGPU::IsaVersion isa;
  unsigned wavefrontSize;
  waveamdmachine::WaitCounterFamily family =
      waveamdmachine::WaitCounterFamily::Legacy;
  bool waitXcnt = false;
  bool requiresNopBeforeDeallocVGPRs = true;
  bool expertScheduling = false;
};

static LogicalResult configureFunctionWaitTarget(func::FuncOp func,
                                                 bool gfx12Plus,
                                                 WaitTarget &target) {
  StringRef attrName = waveamdmachine::getExpertSchedulingModeAttrName();
  if (Attribute attr = func->getAttr(attrName)) {
    if (!isa<UnitAttr>(attr)) {
      func.emitError() << attrName << " must be a unit attribute";
      return failure();
    }
    if (!gfx12Plus || llvm::AMDGPU::DepCtr::getVaVdstBitMask() == 0 ||
        llvm::AMDGPU::DepCtr::getVmVsrcBitMask() == 0) {
      func.emitError() << attrName
                       << " requires GFX12+ expert scheduling support";
      return failure();
    }
    target.expertScheduling = true;
  }
  std::optional<unsigned> sgprCount = getExecIfEmissionSGPRCount(func);
  if (sgprCount)
    target.execIfSaveBase = wave::getWaveAMDExecIfSaveBase(func, *sgprCount);
  return success();
}

static FailureOr<WaitTarget> getWaitTarget(Operation *op) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      waveamdmachine::createAMDGPUMCSubtargetInfo(
          op, "waveamd-insert-ticket-waits");
  if (failed(sti))
    return failure();
  FailureOr<unsigned> wavefrontSize =
      waveamdmachine::getAMDGPUWavefrontSize(op, "waveamd-insert-ticket-waits");
  if (failed(wavefrontSize))
    return failure();
  WaitTarget target(llvm::AMDGPU::getIsaVersion((*sti)->getCPU()),
                    *wavefrontSize);
  bool gfx12Plus = llvm::AMDGPU::isGFX12Plus(**sti);
  target.family = gfx12Plus ? waveamdmachine::WaitCounterFamily::Gfx12Split
                            : waveamdmachine::WaitCounterFamily::Legacy;
  target.waitXcnt = (**sti).hasFeature(llvm::AMDGPU::FeatureWaitXcnt);
  target.requiresNopBeforeDeallocVGPRs =
      !(**sti).hasFeature(llvm::AMDGPU::FeatureGFX1250Insts);
  if (auto func = dyn_cast<func::FuncOp>(op))
    if (failed(configureFunctionWaitTarget(func, gfx12Plus, target)))
      return failure();
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
  case Counter::Async:
    return llvm::AMDGPU::getAsynccntBitMask(isa);
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
  if (requiresZeroWait(token.counter, activeEvents))
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

static LogicalResult validateExpertScheduling(Operation *op,
                                              const WaitTarget &target) {
  if (!target.expertScheduling)
    return success();
  for (Value value : llvm::concat<Value>(op->getOperands(), op->getResults())) {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    if (type && type.getRegClass() == waveamdmachine::RegClass::VGPR &&
        type.getIndex() < 0)
      return op->emitError(
          "expert scheduling requires allocated VGPR operands and results");
  }
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
  if (failed(validateWaitEvent(op, target)))
    return failure();
  return validateExpertScheduling(op, target);
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

static WaitRequirement
computeCallableBoundaryRequirement(const WaitState &state) {
  WaitRequirement req;
  for (Counter counter :
       {Counter::Load, Counter::Store, Counter::Ds, Counter::Km})
    if (llvm::any_of(state.tokens, [&](const Token &token) {
          return token.counter == counter;
        }))
      req.requireDrain(counter, 0);
  return req;
}

static void requireOperationOperands(WaitRequirement &req, Operation *op,
                                     const WaitState &state) {
  bool issuer = isMemoryIssuer(op) &&
                !llvm::isa<waveamdmachine::SBarrierSignalIsFirstOp>(op);
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
}

static WaitRequirement computeRequirement(Operation *op, const WaitState &state,
                                          const WaitTarget &target) {
  if (isControlFlowOp(op))
    return computeControlFlowRequirement(op, state, target);
  if (llvm::isa<waveamdmachine::SEndpgmOp>(op))
    return {};
  if (target.expertScheduling &&
      llvm::isa<CallOpInterface, waveamdmachine::SSetpcB64Op>(op))
    return computeCallableBoundaryRequirement(state);
  WaitRequirement req;
  requireOperationOperands(req, op, state);
  requireOverlappingRegisterDefs(req, op, state);
  if (op->hasTrait<OpTrait::waveamdmachine::WritesExecOp>())
    requireExecDef(req, state);
  return req;
}

static bool isVGPRSpan(RegSpan span) {
  return span.regClass == waveamdmachine::RegClass::VGPR;
}

static void requireExpertDef(ExpertWaitRequirement &req, RegSpan span,
                             const WaitState &state) {
  if (!isVGPRSpan(span))
    return;
  expert::requireSpan(req, span, ExpertCounter::VaWrite, state);
  expert::requireSpan(req, span, ExpertCounter::VaRead, state);
  expert::requireSpan(req, span, ExpertCounter::VmSource, state);
}

static ExpertWaitRequirement
computeExpertReturnRequirement(const WaitState &state) {
  ExpertWaitRequirement req;
  for (unsigned i = 0; i < kNumExpertCounters; ++i)
    expert::requireAll(req, static_cast<ExpertCounter>(i), state);
  return req;
}

static void requireExpertOperands(ExpertWaitRequirement &req, Operation *op,
                                  const WaitState &state) {
  for (Value operand : op->getOperands())
    if (std::optional<RegSpan> span = getAllocatedRegSpan(operand);
        span && isVGPRSpan(*span))
      expert::requireSpan(req, *span, ExpertCounter::VaWrite, state);
}

static void requireExpertDefinitions(ExpertWaitRequirement &req, Operation *op,
                                     const WaitState &state) {
  for (Value result : op->getResults())
    if (std::optional<RegSpan> span = getAllocatedRegSpan(result))
      requireExpertDef(req, *span, state);
  if (auto fixedDefs =
          dyn_cast<waveamdmachine::FixedPhysicalRegisterDefsOpInterface>(op))
    for (RegSpan span : fixedDefs.getFixedPhysicalRegisterDefs())
      requireExpertDef(req, span, state);
}

static ExpertWaitRequirement
computeExpertRequirement(Operation *op, const WaitState &state,
                         const WaitTarget &target) {
  ExpertWaitRequirement req;
  if (!target.expertScheduling || llvm::isa<waveamdmachine::SEndpgmOp>(op))
    return req;
  if (llvm::isa<CallOpInterface, waveamdmachine::SSetpcB64Op>(op))
    return computeExpertReturnRequirement(state);
  requireExpertOperands(req, op, state);
  requireExpertDefinitions(req, op, state);
  if (isExpertVALU(op)) {
    req.counts[static_cast<unsigned>(ExpertCounter::VaRead)].reset();
    req.counts[static_cast<unsigned>(ExpertCounter::VaWrite)].reset();
  }
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

static void applyBarrierWaitCompletion(Operation *op, WaitState &state,
                                       const WaitTarget &target) {
  auto wait = dyn_cast<waveamdmachine::SBarrierWaitOp>(op);
  if (!wait)
    return;
  auto signal = wait.getArrival()
                    .getDefiningOp<waveamdmachine::SBarrierSignalIsFirstOp>();
  if (!signal || signal.getScope() != wait.getScope())
    return;
  std::optional<waveamdmachine::WaitcntCounterMapping> mapping =
      waveamdmachine::getWaitcntCounterMapping(
          waveamdmachine::WaitcntEvent::SccWrite, target.family,
          target.waitXcnt);
  if (!mapping)
    return;
  lat::dropIssuedEvent(state.tokens, mapping->completion, signal->getResults(),
                       waveamdmachine::WaitcntEvent::SccWrite);
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

static void collectExpertSpans(ValueRange values,
                               SmallVectorImpl<RegSpan> &spans) {
  for (Value value : values) {
    std::optional<RegSpan> span = getAllocatedRegSpan(value);
    if (span && isVGPRSpan(*span))
      spans.push_back(*span);
  }
}

static bool isVALUExpertEvent(ExpertEvent event) {
  switch (event) {
  case ExpertEvent::CSMACC:
  case ExpertEvent::DPMACC:
  case ExpertEvent::Trans:
  case ExpertEvent::Xdl:
    return true;
  case ExpertEvent::None:
  case ExpertEvent::Lds:
  case ExpertEvent::Flat:
  case ExpertEvent::Vmem:
    return false;
  }
  llvm_unreachable("unknown expert scheduling event");
}

static void recordExpertIssue(Operation *op, WaitState &state,
                              const WaitTarget &target) {
  if (!target.expertScheduling)
    return;
  if (classifyOp(op) == OpKind::Barrier)
    return;
  ExpertEvent event = classifyExpertEvent(op);
  if (event == ExpertEvent::None)
    return;
  unsigned count = waveamdmachine::getInstructionIssueCount(
      op, target.isa, target.wavefrontSize);
  if (count == 0)
    return;

  SmallVector<RegSpan, 4> operands;
  collectExpertSpans(op->getOperands(), operands);
  if (!isVALUExpertEvent(event)) {
    expert::issue(state, ExpertCounter::VmSource, 1, event, operands);
    return;
  }

  SmallVector<RegSpan, 2> results;
  collectExpertSpans(op->getResults(), results);
  expert::issue(state, ExpertCounter::VaRead, count, event, operands);
  expert::issue(state, ExpertCounter::VaWrite, count, event, results);
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
  return llvm::isa<
      waveamdmachine::BarrierArriveOp, waveamdmachine::BarrierWaitOp,
      waveamdmachine::ClusterBarrierOp, waveamdmachine::SBarrierSignalIsFirstOp,
      waveamdmachine::SBarrierSignalOp, waveamdmachine::SBarrierWaitOp,
      waveamdmachine::SBarrierOp, waveamdmachine::SEndpgmOp,
      waveamdmachine::SGetregHwIdOp, waveamdmachine::SGetregShaderCyclesOp,
      waveamdmachine::SSendmsgDeallocVgprsOp, waveamdmachine::SSetpcB64Op,
      waveamdmachine::SSetVgprMsbOp>(op);
}

static unsigned getExpertCounterMax(ExpertCounter counter) {
  switch (counter) {
  case ExpertCounter::VaRead:
  case ExpertCounter::VaWrite:
    return llvm::AMDGPU::DepCtr::getVaVdstBitMask();
  case ExpertCounter::VmSource:
    return llvm::AMDGPU::DepCtr::getVmVsrcBitMask();
  }
  llvm_unreachable("unknown expert scheduling counter");
}

static void normalizeExpertWait(ExpertWaitRequirement &req) {
  std::optional<unsigned> vaRead = req.get(ExpertCounter::VaRead);
  std::optional<unsigned> vaWrite = req.get(ExpertCounter::VaWrite);
  if (vaRead || vaWrite) {
    unsigned va =
        std::min(vaRead.value_or(std::numeric_limits<unsigned>::max()),
                 vaWrite.value_or(std::numeric_limits<unsigned>::max()));
    req.counts[static_cast<unsigned>(ExpertCounter::VaRead)] = va;
    req.counts[static_cast<unsigned>(ExpertCounter::VaWrite)] = va;
  }

  for (unsigned i = 0; i < kNumExpertCounters; ++i) {
    std::optional<unsigned> &count = req.counts[i];
    if (!count)
      continue;
    unsigned max = getExpertCounterMax(static_cast<ExpertCounter>(i));
    if (*count >= max)
      count = max - 1;
  }
}

static void observeRegularWaitcnt(Operation *op, WaitState &state,
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
    const std::array<std::pair<Counter, std::optional<uint32_t>>, 7> counts = {{
        {Counter::Load, wait.getLoadcnt()},
        {Counter::Store, wait.getStorecnt()},
        {Counter::Ds, wait.getDscnt()},
        {Counter::Km, wait.getKmcnt()},
        {Counter::X, wait.getXcnt()},
        {Counter::Async, wait.getAsynccnt()},
        {Counter::Tensor, wait.getTensorcnt()},
    }};
    for (auto [counter, count] : counts)
      if (count)
        observed.requireDrain(counter, *count);
  }
  lat::applyWait(state.tokens, observed);
}

static void observeExpertWaitcnt(Operation *op, WaitState &state,
                                 const WaitTarget &target) {
  if (!target.expertScheduling)
    return;
  auto waitAlu = dyn_cast<waveamdmachine::SWaitAluOp>(op);
  if (!waitAlu)
    return;
  ExpertWaitRequirement expertWait;
  if (std::optional<uint32_t> va = waitAlu.getVaVdst()) {
    expertWait.requireDrain(ExpertCounter::VaRead, *va);
    expertWait.requireDrain(ExpertCounter::VaWrite, *va);
  }
  if (std::optional<uint32_t> vm = waitAlu.getVmVsrc())
    expertWait.requireDrain(ExpertCounter::VmSource, *vm);
  expert::applyWait(state, expertWait);
}

static void observeExistingWaitcnt(Operation *op, WaitState &state,
                                   const WaitTarget &target) {
  observeRegularWaitcnt(op, state, target);
  observeExpertWaitcnt(op, state, target);
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

// `emit` is a no-op during analysis, the wait emitter during rewrite.
template <typename EmitFn>
static void applyDrain(Operation *op, WaitState &state,
                       const WaitTarget &target, EmitFn emit) {
  WaitRequirement req = computeRequirement(op, state, target);
  ExpertWaitRequirement expertReq = computeExpertRequirement(op, state, target);
  clampSaturatedCounterFields(req, target);
  normalizeExpertWait(expertReq);
  emit(op, req, expertReq);
  lat::applyWait(state.tokens, req);
  expert::applyWait(state, expertReq);
}

static void applyImplicitXDrain(Operation *op, WaitState &state,
                                const WaitTarget &target) {
  if (target.waitXcnt && implicitlyDrainsXcnt(op))
    lat::clearCounter(state.tokens, Counter::X);
}

enum class TransferAction { Unhandled, Finish, FinishAndRecord };

template <typename EmitFn>
static TransferAction runSimpleTransfer(OpKind kind, Operation *op,
                                        WaitState &state,
                                        const WaitTarget &target, EmitFn emit) {
  switch (kind) {
  case OpKind::Skip:
    if (isWaitcntOp(op)) {
      observeExistingWaitcnt(op, state, target);
      return TransferAction::Finish;
    }
    applyDrain(op, state, target, emit);
    return TransferAction::FinishAndRecord;
  case OpKind::CompletionNeutral:
  case OpKind::TokenOp:
    deriveResultTokens(op, state);
    return TransferAction::FinishAndRecord;
  case OpKind::CompletionFree:
    return TransferAction::FinishAndRecord;
  case OpKind::Endpgm:
    state.tokens.clear();
    expert::clear(state);
    return TransferAction::Finish;
  default:
    return TransferAction::Unhandled;
  }
}

template <typename EmitFn>
static void transferCall(Operation *op, WaitState &state,
                         const WaitTarget &target, EmitFn emit) {
  applyDrain(op, state, target, emit);
  if (!target.expertScheduling)
    return;
  for (Counter counter :
       {Counter::Load, Counter::Store, Counter::Ds, Counter::Km})
    lat::clearCounter(state.tokens, counter);
  expert::clear(state);
}

// Shared dispatch for analysis and rewrite: same state transfer, the
// only delta is the (conditional) `emit`.
template <typename EmitFn>
static void runTransfer(Operation *op, WaitState &state,
                        const WaitTarget &target, EmitFn emit) {
  OpKind kind = classifyOp(op);
  TransferAction action = runSimpleTransfer(kind, op, state, target, emit);
  if (action != TransferAction::Unhandled) {
    if (action == TransferAction::FinishAndRecord) {
      recordExpertIssue(op, state, target);
      applyImplicitXDrain(op, state, target);
    }
    return;
  }

  switch (kind) {
  case OpKind::Issuer:
    applyDrain(op, state, target, emit);
    applyImplicitXGroupSwitch(op, state, target);
    recordIssue(op, state, target);
    deriveIssuerDependencyTokens(op, state);
    break;
  case OpKind::BarrierIssuer:
    applyDrain(op, state, target, emit);
    recordIssue(op, state, target);
    break;
  case OpKind::Barrier:
    // Drain ahead of the fence AND seed result tokens so downstream
    // loads of the same arena depend on it.
    applyBarrierWaitCompletion(op, state, target);
    applyDrain(op, state, target, emit);
    applyImplicitXGroupSwitch(op, state, target);
    deriveResultTokens(op, state);
    break;
  case OpKind::Call:
    transferCall(op, state, target, emit);
    break;
  case OpKind::Return:
    applyDrain(op, state, target, emit);
    expert::clear(state);
    break;
  case OpKind::Generic:
    applyDrain(op, state, target, emit);
    break;
  default:
    llvm_unreachable("simple transfer was not handled");
  }
  recordExpertIssue(op, state, target);
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
    auto noop = [](Operation *, const WaitRequirement &,
                   const ExpertWaitRequirement &) {};
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
        attr(Counter::Async), attr(Counter::Tensor));
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

static void emitExpertWait(OpBuilder &builder, Operation *op,
                           const ExpertWaitRequirement &req) {
  std::optional<unsigned> va = req.get(ExpertCounter::VaRead);
  std::optional<unsigned> vm = req.get(ExpertCounter::VmSource);
  if (!va && !vm)
    return;
  builder.setInsertionPoint(op);
  waveamdmachine::SWaitAluOp::create(
      builder, op->getLoc(), va ? getCounterAttr(builder, *va) : IntegerAttr(),
      vm ? getCounterAttr(builder, *vm) : IntegerAttr(),
      /*sa_sdst=*/IntegerAttr(), /*va_sdst=*/IntegerAttr());
}

static bool isSchedulingMode(Operation *op,
                             waveamdmachine::SchedulingMode mode) {
  auto setMode = dyn_cast_or_null<waveamdmachine::SSetSchedulingModeOp>(op);
  return setMode && setMode.getMode() == mode;
}

static bool hasEntryExpertMode(func::FuncOp func) {
  for (Operation &op : func.getBody().front()) {
    if (auto mode = dyn_cast<waveamdmachine::SSetSchedulingModeOp>(&op))
      return mode.getMode() == waveamdmachine::SchedulingMode::Expert2;
    if (isWaitcntOp(&op) ||
        op.hasTrait<OpTrait::waveamdmachine::NoMachineInst>())
      continue;
    return false;
  }
  return false;
}

static void materializeExpertModeProtocol(func::FuncOp func,
                                          OpBuilder &builder) {
  SmallVector<Operation *> calls;
  SmallVector<waveamdmachine::SSetpcB64Op> returns;
  func.walk([&](Operation *op) {
    if (isa<CallOpInterface>(op))
      calls.push_back(op);
    if (auto ret = dyn_cast<waveamdmachine::SSetpcB64Op>(op))
      returns.push_back(ret);
  });

  for (Operation *call : calls) {
    if (!isSchedulingMode(call->getPrevNode(),
                          waveamdmachine::SchedulingMode::Normal)) {
      builder.setInsertionPoint(call);
      waveamdmachine::SSetSchedulingModeOp::create(
          builder, call->getLoc(), waveamdmachine::SchedulingMode::Normal);
    }
    if (!isSchedulingMode(call->getNextNode(),
                          waveamdmachine::SchedulingMode::Expert2)) {
      builder.setInsertionPointAfter(call);
      waveamdmachine::SSetSchedulingModeOp::create(
          builder, call->getLoc(), waveamdmachine::SchedulingMode::Expert2);
    }
  }

  for (waveamdmachine::SSetpcB64Op ret : returns) {
    if (isSchedulingMode(ret->getPrevNode(),
                         waveamdmachine::SchedulingMode::Normal))
      continue;
    builder.setInsertionPoint(ret);
    waveamdmachine::SSetSchedulingModeOp::create(
        builder, ret.getLoc(), waveamdmachine::SchedulingMode::Normal);
  }

  if (hasEntryExpertMode(func))
    return;
  builder.setInsertionPointToStart(&func.getBody().front());
  waveamdmachine::SSetSchedulingModeOp::create(
      builder, func.getLoc(), waveamdmachine::SchedulingMode::Expert2);
  if (!func->hasAttr(wave::WaveDialect::getKernelAttrName())) {
    IntegerAttr zero = builder.getI32IntegerAttr(0);
    waveamdmachine::SWaitcntSplitOp::create(
        builder, func.getLoc(), zero, /*storecnt=*/IntegerAttr(), zero, zero,
        /*xcnt=*/IntegerAttr(), /*asynccnt=*/IntegerAttr(),
        /*tensorcnt=*/IntegerAttr());
    waveamdmachine::SWaitAluOp::create(builder, func.getLoc(), zero, zero,
                                       /*sa_sdst=*/IntegerAttr(),
                                       /*va_sdst=*/IntegerAttr());
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
    if (target->expertScheduling) {
      OpBuilder builder(func.getContext());
      materializeExpertModeProtocol(func, builder);
    }
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
    auto emit = [&](Operation *op, const WaitRequirement &req,
                    const ExpertWaitRequirement &expertReq) {
      if (req.hasWait())
        emitWaits(builder, op, req, target);
      if (expertReq.hasWait())
        emitExpertWait(builder, op, expertReq);
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
