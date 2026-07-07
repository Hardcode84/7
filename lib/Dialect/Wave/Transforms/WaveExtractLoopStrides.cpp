//===- WaveExtractLoopStrides.cpp - expose loop-carried strides -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringSet.h"

#include <algorithm>
#include <array>
#include <optional>
#include <string>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEEXTRACTLOOPSTRIDES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct NamedBinding {
  std::string name;
  Value value;
};

struct BoundExpr {
  sym::ExprHandle expr;
  SmallVector<sym::PredHandle> assumptions;
  SmallVector<std::string> names;
  SmallVector<Value> bindings;
};

struct ExpandedIndexExpr {
  sym::ExprHandle expr;
  SmallVector<sym::PredHandle> assumptions;
  SmallVector<std::string> names;
  SmallVector<Value> bindings;
  SmallVector<Operation *> producers;
};

struct LoopStrideCandidate {
  PtrAddOp ptrAdd;
  IndexExprOp indexExpr;
  SmallVector<Operation *> deadProducers;
  BoundExpr base;
  BoundExpr stride;
};

struct CyclicOffsetPattern {
  int64_t scale = 1;
  int64_t modulus = 0;
};

struct CyclicOffsetLoopMatch {
  ExpandedIndexExpr expanded;
  std::string ivName;
  CyclicOffsetPattern pattern;
};

struct CyclicOffsetCarryShape {
  int64_t increment = 0;
  int64_t ring = 0;
};

struct LoopCyclicOffsetCandidate {
  IndexExprOp indexExpr;
  SmallVector<Operation *> deadProducers;
  BoundExpr base;
  int64_t increment = 0;
  int64_t ring = 0;
};

struct OffsetCarryCandidate {
  BinaryOp update;
  Value init;
  Value stride;
  BlockArgument arg;
  unsigned index = 0;
};

struct LoopOffsetCarryCandidate {
  SmallVector<OffsetCarryCandidate> carries;
};

static IndexExprOp createIndexExpr(IRRewriter &rewriter, Location loc,
                                   MLIRContext *ctx, const BoundExpr &expr,
                                   IRMapping *map);

static bool isDefinedInside(Operation *scope, Value value) {
  if (Operation *def = value.getDefiningOp())
    return scope->isAncestor(def);
  BlockArgument arg = dyn_cast<BlockArgument>(value);
  if (!arg)
    return false;
  Region *region = arg.getOwner()->getParent();
  while (region) {
    Operation *parent = region->getParentOp();
    if (!parent)
      return false;
    if (parent == scope)
      return true;
    region = parent->getParentRegion();
  }
  return false;
}

static void collectFreeSymbols(sym::ExprHandle expr,
                               llvm::DenseSet<StringRef> &symbols) {
  sym::walkSymbolNames(expr, [&](StringRef name) { symbols.insert(name); });
}

static bool hasSymbol(sym::ExprHandle expr, StringRef needle) {
  bool found = false;
  sym::walkSymbolNames(expr, [&](StringRef name) {
    if (name == needle)
      found = true;
  });
  return found;
}

static std::string uniqueName(llvm::StringSet<> &used, StringRef stem) {
  std::string base = stem.str();
  std::string name = base;
  unsigned suffix = 0;
  while (used.contains(name))
    name = (Twine(base) + "_" + Twine(++suffix)).str();
  used.insert(name);
  return name;
}

static void collectUsedNames(const ExpandedIndexExpr &expr,
                             llvm::StringSet<> &used) {
  for (StringRef name : expr.names)
    used.insert(name);
}

static FailureOr<sym::ExprHandle>
symbolForValue(sym::Store &store, Value value, StringRef stem,
               llvm::StringSet<> &used, SmallVectorImpl<NamedBinding> &extra) {
  if (std::optional<int64_t> constant = getConstantIntValue(value))
    return sym::composeExprInt(store, *constant);

  std::string name = uniqueName(used, stem);
  FailureOr<sym::ExprHandle> expr = sym::composeExprSym(store, name);
  if (failed(expr))
    return failure();
  extra.push_back({name, value});
  return *expr;
}

static FailureOr<sym::ExprHandle> symbolExpr(sym::Store &store,
                                             StringRef name) {
  return sym::composeExprSym(store, name);
}

static FailureOr<sym::ExprHandle>
simplifyExpanded(sym::Store &store, sym::ExprHandle expr,
                 ArrayRef<sym::PredHandle> assumptions);

struct ExpansionState {
  SmallVector<NamedBinding> bindings;
  SmallVector<Operation *> producers;
  SmallVector<sym::PredHandle> assumptions;
  llvm::DenseMap<Value, StringRef> byValue;
  llvm::SmallPtrSet<Operation *, 4> seenProducers;
  llvm::StringMap<Value> reserved;
  llvm::StringMap<Value> emitted;
};

static LogicalResult appendExpandedBinding(ExpansionState &state,
                                           StringRef name, Value value) {
  auto [it, inserted] = state.emitted.try_emplace(name, value);
  if (!inserted && it->second != value)
    return failure();
  if (inserted)
    state.bindings.push_back({name.str(), value});
  return success();
}

static void recordProducer(ExpansionState &state, Operation *op) {
  if (state.seenProducers.insert(op).second)
    state.producers.push_back(op);
}

static FailureOr<sym::ExprHandle> bindExpandedValue(Value value, StringRef stem,
                                                    sym::Store &store,
                                                    ExpansionState &state) {
  StringRef mapped =
      reserveIndexExprBindingName(stem, value, state.reserved, state.byValue);
  if (failed(appendExpandedBinding(state, mapped, value)))
    return failure();
  return symbolExpr(store, mapped);
}

static std::optional<int64_t> getSExtI64(const APInt &value) {
  if (!value.isSignedIntN(64))
    return std::nullopt;
  return value.getSExtValue();
}

static bool isFullSignedRange(const ConstantIntRanges &range) {
  unsigned width = range.smin().getBitWidth();
  if (width == 0)
    return true;
  return range.smin() == APInt::getSignedMinValue(width) &&
         range.smax() == APInt::getSignedMaxValue(width);
}

static std::optional<ConstantIntRanges>
finiteSignedRange(DataFlowSolver &solver, Value value) {
  const dataflow::IntegerValueRangeLattice *lattice =
      solver.lookupState<dataflow::IntegerValueRangeLattice>(value);
  if (!lattice)
    return std::nullopt;
  IntegerValueRange ivr = lattice->getValue();
  if (ivr.isUninitialized())
    return std::nullopt;
  ConstantIntRanges range = ivr.getValue();
  if (isFullSignedRange(range))
    return std::nullopt;
  return range;
}

static std::optional<std::pair<int64_t, int64_t>>
finiteSignedI64Range(DataFlowSolver &solver, Value value) {
  std::optional<ConstantIntRanges> range = finiteSignedRange(solver, value);
  if (!range)
    return std::nullopt;
  std::optional<int64_t> lo = getSExtI64(range->smin());
  std::optional<int64_t> hi = getSExtI64(range->smax());
  if (!lo || !hi)
    return std::nullopt;
  return std::pair<int64_t, int64_t>{*lo, *hi};
}

static unsigned elementStorageBitWidth(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  return ConstantIntRanges::getStorageBitwidth(type);
}

static bool fitsSignedWidth(__int128 value, unsigned bits) {
  if (bits == 0)
    return false;
  __int128 min = -(__int128{1} << (bits - 1));
  __int128 max = (__int128{1} << (bits - 1)) - 1;
  return value >= min && value <= max;
}

static bool fitsSignedWidth(std::pair<__int128, __int128> range,
                            unsigned bits) {
  return fitsSignedWidth(range.first, bits) &&
         fitsSignedWidth(range.second, bits);
}

static std::pair<__int128, __int128> addRange(std::pair<int64_t, int64_t> lhs,
                                              std::pair<int64_t, int64_t> rhs) {
  return {__int128(lhs.first) + rhs.first, __int128(lhs.second) + rhs.second};
}

static std::pair<__int128, __int128> subRange(std::pair<int64_t, int64_t> lhs,
                                              std::pair<int64_t, int64_t> rhs) {
  return {__int128(lhs.first) - rhs.second, __int128(lhs.second) - rhs.first};
}

static std::pair<__int128, __int128> mulRange(std::pair<int64_t, int64_t> lhs,
                                              std::pair<int64_t, int64_t> rhs) {
  std::array<__int128, 4> products{
      __int128(lhs.first) * rhs.first, __int128(lhs.first) * rhs.second,
      __int128(lhs.second) * rhs.first, __int128(lhs.second) * rhs.second};
  return {*std::min_element(products.begin(), products.end()),
          *std::max_element(products.begin(), products.end())};
}

static std::optional<std::pair<__int128, __int128>>
shlRange(BinaryOp op, std::pair<int64_t, int64_t> lhs) {
  std::optional<int64_t> shift = getConstantIntValue(op.getRhs());
  if (!shift || *shift < 0 || *shift >= 63)
    return std::nullopt;
  __int128 scale = __int128{1} << *shift;
  return std::pair<__int128, __int128>{__int128(lhs.first) * scale,
                                       __int128(lhs.second) * scale};
}

static std::optional<std::pair<__int128, __int128>>
resultRange(BinaryOp op, std::pair<int64_t, int64_t> lhs,
            std::pair<int64_t, int64_t> rhs) {
  switch (op.getKind()) {
  case BinaryKind::AddI:
    return addRange(lhs, rhs);
  case BinaryKind::SubI:
    return subRange(lhs, rhs);
  case BinaryKind::MulI:
    return mulRange(lhs, rhs);
  case BinaryKind::ShLI:
    return shlRange(op, lhs);
  default:
    return std::nullopt;
  }
}

static bool rangeProvesNoSignedOverflow(BinaryOp op, DataFlowSolver &solver) {
  if (op.hasNoSignedWrap())
    return true;

  unsigned bits = elementStorageBitWidth(op.getResult().getType());
  if (bits == 0 || bits > 64)
    return false;

  std::optional<std::pair<int64_t, int64_t>> lhs =
      finiteSignedI64Range(solver, op.getLhs());
  std::optional<std::pair<int64_t, int64_t>> rhs =
      finiteSignedI64Range(solver, op.getRhs());
  if (!lhs || !rhs)
    return false;

  std::optional<std::pair<__int128, __int128>> range =
      resultRange(op, *lhs, *rhs);
  return range && fitsSignedWidth(*range, bits);
}

static std::optional<sym::ExprBinaryOp> convertBinaryKind(BinaryKind kind) {
  switch (kind) {
  case BinaryKind::AddI:
    return sym::ExprBinaryOp::Add;
  case BinaryKind::SubI:
    return sym::ExprBinaryOp::Sub;
  case BinaryKind::MulI:
    return sym::ExprBinaryOp::Mul;
  default:
    return std::nullopt;
  }
}

static FailureOr<sym::ExprHandle>
expandValueExpr(Value value, StringRef stem, scf::ForOp loop, sym::Store &store,
                DataFlowSolver &solver, ExpansionState &state,
                unsigned depth = 0);

static FailureOr<sym::ExprHandle>
expandBinaryExpr(BinaryOp op, StringRef stem, scf::ForOp loop,
                 sym::Store &store, DataFlowSolver &solver,
                 ExpansionState &state, unsigned depth);

static FailureOr<sym::ExprHandle>
expandOrdinaryBinaryExpr(BinaryOp op, StringRef stem, scf::ForOp loop,
                         sym::Store &store, DataFlowSolver &solver,
                         ExpansionState &state, unsigned depth) {
  std::optional<sym::ExprBinaryOp> kind = convertBinaryKind(op.getKind());
  if (!kind || !rangeProvesNoSignedOverflow(op, solver))
    return bindExpandedValue(op.getResult(), stem, store, state);

  FailureOr<sym::ExprHandle> lhs =
      expandValueExpr(op.getLhs(), stem, loop, store, solver, state, depth);
  FailureOr<sym::ExprHandle> rhs =
      expandValueExpr(op.getRhs(), stem, loop, store, solver, state, depth);
  if (failed(lhs) || failed(rhs))
    return failure();
  return sym::composeExprBinary(store, *lhs, *kind, *rhs);
}

static FailureOr<sym::ExprHandle>
expandShiftLeftExpr(BinaryOp op, StringRef stem, scf::ForOp loop,
                    sym::Store &store, DataFlowSolver &solver,
                    ExpansionState &state, unsigned depth) {
  if (!rangeProvesNoSignedOverflow(op, solver))
    return bindExpandedValue(op.getResult(), stem, store, state);
  std::optional<int64_t> shift = getConstantIntValue(op.getRhs());
  if (!shift || *shift < 0 || *shift >= 63)
    return bindExpandedValue(op.getResult(), stem, store, state);
  FailureOr<sym::ExprHandle> lhs =
      expandValueExpr(op.getLhs(), stem, loop, store, solver, state, depth);
  FailureOr<sym::ExprHandle> scale =
      sym::composeExprInt(store, int64_t{1} << *shift);
  if (failed(lhs) || failed(scale))
    return failure();
  return sym::composeExprBinary(store, *lhs, sym::ExprBinaryOp::Mul, *scale);
}

static FailureOr<sym::ExprHandle>
expandBinaryExpr(BinaryOp op, StringRef stem, scf::ForOp loop,
                 sym::Store &store, DataFlowSolver &solver,
                 ExpansionState &state, unsigned depth) {
  if (op.getKind() == BinaryKind::ShLI)
    return expandShiftLeftExpr(op, stem, loop, store, solver, state, depth);
  return expandOrdinaryBinaryExpr(op, stem, loop, store, solver, state, depth);
}

static FailureOr<sym::ExprHandle>
expandIndexExpr(IndexExprOp op, scf::ForOp loop, sym::Store &store,
                DataFlowSolver &solver, ExpansionState &state);

static FailureOr<sym::ExprHandle>
expandValueExpr(Value value, StringRef stem, scf::ForOp loop, sym::Store &store,
                DataFlowSolver &solver, ExpansionState &state, unsigned depth) {
  if (depth > 8)
    return bindExpandedValue(value, stem, store, state);
  if (std::optional<int64_t> constant = getConstantIntValue(value))
    return sym::composeExprInt(store, *constant);
  if (!isDefinedInside(loop, value))
    return bindExpandedValue(value, stem, store, state);

  if (AssumeOp assume = value.getDefiningOp<AssumeOp>()) {
    recordProducer(state, assume);
    return expandValueExpr(assume.getValue(), assume.getName(), loop, store,
                           solver, state, depth + 1);
  }
  if (IndexExprOp producer = value.getDefiningOp<IndexExprOp>()) {
    recordProducer(state, producer);
    return expandIndexExpr(producer, loop, store, solver, state);
  }
  if (BinaryOp binary = value.getDefiningOp<BinaryOp>()) {
    recordProducer(state, binary);
    return expandBinaryExpr(binary, stem, loop, store, solver, state,
                            depth + 1);
  }
  return bindExpandedValue(value, stem, store, state);
}

static FailureOr<sym::ExprHandle>
expandIndexExpr(IndexExprOp op, scf::ForOp loop, sym::Store &store,
                DataFlowSolver &solver, ExpansionState &state) {
  SmallVector<sym::ExprSubstitution> substitutions;
  for (auto [nameAttr, value] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    FailureOr<sym::ExprHandle> target = symbolExpr(store, name);
    if (failed(target))
      return failure();

    FailureOr<sym::ExprHandle> replacement =
        expandValueExpr(value, name, loop, store, solver, state, /*depth=*/0);
    if (failed(replacement))
      return failure();
    substitutions.push_back({*target, *replacement});
  }

  FailureOr<sym::ExprHandle> substituted =
      sym::substituteExpr(store, op.getExpr().getValue(), substitutions);
  if (failed(substituted))
    return failure();

  SmallVector<sym::PredHandle> assumptions;
  appendIndexExprPredicates(op, assumptions);
  FailureOr<SmallVector<sym::PredHandle>> substitutedAssumptions =
      substituteIndexExprPredicates(store, assumptions, substitutions);
  if (failed(substitutedAssumptions))
    return failure();
  llvm::append_range(state.assumptions, *substitutedAssumptions);
  return simplifyExpanded(store, *substituted, state.assumptions);
}

static FailureOr<ExpandedIndexExpr> expandIndexExpr(IndexExprOp op,
                                                    scf::ForOp loop,
                                                    sym::Store &store,
                                                    DataFlowSolver &solver) {
  ExpansionState state;
  for (auto [nameAttr, value] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    state.reserved[name] = value;
  }

  FailureOr<sym::ExprHandle> expr =
      expandIndexExpr(op, loop, store, solver, state);
  if (failed(expr))
    return failure();

  ExpandedIndexExpr out;
  out.expr = *expr;
  out.assumptions = std::move(state.assumptions);
  for (const NamedBinding &binding : state.bindings) {
    out.names.push_back(binding.name);
    out.bindings.push_back(binding.value);
  }
  out.producers = std::move(state.producers);
  return out;
}

static void collectOriginalBindings(const ExpandedIndexExpr &expanded,
                                    StringRef ivName,
                                    SmallVectorImpl<NamedBinding> &out) {
  for (auto [name, binding] : llvm::zip(expanded.names, expanded.bindings)) {
    if (name == ivName)
      continue;
    out.push_back({name, binding});
  }
}

static FailureOr<BoundExpr> bindLiveExpr(const ExpandedIndexExpr &expanded,
                                         sym::ExprHandle expr, StringRef ivName,
                                         ArrayRef<sym::PredHandle> assumptions,
                                         ArrayRef<NamedBinding> extraBindings) {
  if (hasSymbol(expr, ivName))
    return failure();

  llvm::DenseSet<StringRef> freeSymbols;
  collectFreeSymbols(expr, freeSymbols);
  SmallVector<sym::PredHandle> liveAssumptions =
      filterIndexExprPredicatesBySymbols(assumptions, freeSymbols);

  SmallVector<NamedBinding> available;
  collectOriginalBindings(expanded, ivName, available);
  llvm::append_range(available, extraBindings);

  BoundExpr out;
  llvm::StringSet<> consumed;
  for (const NamedBinding &binding : available) {
    if (!freeSymbols.count(binding.name))
      continue;
    out.names.push_back(binding.name);
    out.bindings.push_back(binding.value);
    consumed.insert(binding.name);
  }
  for (StringRef symbol : freeSymbols)
    if (!consumed.contains(symbol))
      return failure();

  out.expr = expr;
  out.assumptions = std::move(liveAssumptions);
  return out;
}

static FailureOr<sym::ExprHandle>
simplifyExpanded(sym::Store &store, sym::ExprHandle expr,
                 ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> expanded = sym::expandExpr(store, expr);
  if (failed(expanded))
    return failure();
  if (assumptions.empty())
    return sym::simplifyExpr(store, *expanded);
  return sym::simplifyExpr(store, *expanded, assumptions);
}

static FailureOr<BoundExpr> buildBaseExpr(const ExpandedIndexExpr &expanded,
                                          StringRef ivName, scf::ForOp loop,
                                          sym::Store &store) {
  llvm::StringSet<> used;
  collectUsedNames(expanded, used);

  FailureOr<sym::ExprHandle> iv = sym::composeExprSym(store, ivName);
  SmallVector<NamedBinding> extra;
  FailureOr<sym::ExprHandle> lower = symbolForValue(
      store, loop.getLowerBound(), (Twine(ivName) + "_lb").str(), used, extra);
  if (failed(iv) || failed(lower))
    return failure();

  FailureOr<sym::ExprHandle> substituted =
      sym::substituteExpr(store, expanded.expr, {{*iv, *lower}});
  if (failed(substituted))
    return failure();
  FailureOr<SmallVector<sym::PredHandle>> substitutedAssumptions =
      substituteIndexExprPredicates(store, expanded.assumptions,
                                    {{*iv, *lower}});
  if (failed(substitutedAssumptions))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      simplifyExpanded(store, *substituted, *substitutedAssumptions);
  if (failed(simplified))
    return failure();
  return bindLiveExpr(expanded, *simplified, ivName, *substitutedAssumptions,
                      extra);
}

static FailureOr<BoundExpr> buildStrideExpr(const ExpandedIndexExpr &expanded,
                                            StringRef ivName, scf::ForOp loop,
                                            sym::Store &store) {
  llvm::StringSet<> used;
  collectUsedNames(expanded, used);

  FailureOr<sym::ExprHandle> iv = sym::composeExprSym(store, ivName);
  SmallVector<NamedBinding> extra;
  FailureOr<sym::ExprHandle> step = symbolForValue(
      store, loop.getStep(), (Twine(ivName) + "_step").str(), used, extra);
  if (failed(iv) || failed(step))
    return failure();

  FailureOr<sym::ExprHandle> nextIv =
      sym::composeExprBinary(store, *iv, sym::ExprBinaryOp::Add, *step);
  if (failed(nextIv))
    return failure();

  FailureOr<sym::ExprHandle> next =
      sym::substituteExpr(store, expanded.expr, {{*iv, *nextIv}});
  if (failed(next))
    return failure();
  FailureOr<sym::ExprHandle> diff = sym::composeExprBinary(
      store, *next, sym::ExprBinaryOp::Sub, expanded.expr);
  if (failed(diff))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      simplifyExpanded(store, *diff, expanded.assumptions);
  if (failed(simplified))
    return failure();
  if (sym::getIntegerLiteralValue(*simplified) == int64_t{0})
    return failure();
  return bindLiveExpr(expanded, *simplified, ivName, expanded.assumptions,
                      extra);
}

static bool isPowerOfTwo(int64_t value) {
  return value > 0 && (value & (value - 1)) == 0;
}

static std::optional<int64_t> matchIVPlusConstant(sym::ExprHandle expr,
                                                  StringRef ivName) {
  sym::ExprView view(expr);
  if (view.getKind() == sym::ExprKind::Symbol && view.getSymbolName() == ivName)
    return 0;

  if (view.getKind() != sym::ExprKind::Add || view.getAddTermCount() != 1)
    return std::nullopt;

  std::optional<int64_t> constant =
      sym::getIntegerLiteralValue(view.getAddConstant());
  if (!constant)
    return std::nullopt;

  sym::AddTerm term = view.getAddTerm(0);
  std::optional<int64_t> coefficient =
      sym::getIntegerLiteralValue(term.coefficient);
  if (!coefficient || *coefficient != 1)
    return std::nullopt;

  sym::ExprView termView(term.term);
  if (termView.getKind() != sym::ExprKind::Symbol ||
      termView.getSymbolName() != ivName)
    return std::nullopt;
  return *constant;
}

static std::optional<CyclicOffsetPattern>
matchScaledModOfIV(sym::ExprHandle modExpr, int64_t scale, StringRef ivName) {
  if (scale <= 0)
    return std::nullopt;
  sym::ExprView view(modExpr);
  if (view.getKind() != sym::ExprKind::Mod)
    return std::nullopt;
  if (!matchIVPlusConstant(view.getBinaryLhs(), ivName))
    return std::nullopt;

  std::optional<int64_t> modulus =
      sym::getIntegerLiteralValue(view.getBinaryRhs());
  if (!modulus || *modulus <= 1)
    return std::nullopt;
  if (__int128(scale) * *modulus > std::numeric_limits<int64_t>::max())
    return std::nullopt;

  CyclicOffsetPattern pattern;
  pattern.scale = scale;
  pattern.modulus = *modulus;
  return pattern;
}

static FailureOr<sym::ExprHandle>
scaleExpr(sym::Store &store, sym::ExprHandle expr, int64_t scale) {
  if (scale == 1)
    return expr;
  FailureOr<sym::ExprHandle> coeff = sym::composeExprInt(store, scale);
  if (failed(coeff))
    return failure();
  return sym::composeExprBinary(store, *coeff, sym::ExprBinaryOp::Mul, expr);
}

static FailureOr<bool>
baseFitsCyclicUpdate(sym::Store &store, sym::ExprHandle expr,
                     sym::ExprHandle cyclicTerm, int64_t scale,
                     StringRef ivName, ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> diff =
      sym::composeExprBinary(store, expr, sym::ExprBinaryOp::Sub, cyclicTerm);
  if (failed(diff))
    return failure();
  FailureOr<sym::ExprHandle> base = simplifyExpanded(store, *diff, assumptions);
  if (failed(base))
    return failure();
  if (hasSymbol(*base, ivName))
    return false;
  if (sym::getIntegerLiteralValue(*base) == int64_t{0})
    return true;

  llvm::DenseSet<StringRef> freeSymbols;
  collectFreeSymbols(*base, freeSymbols);
  SmallVector<sym::PredHandle> liveAssumptions =
      filterIndexExprPredicatesBySymbols(assumptions, freeSymbols);
  return sym::inferNonNegativeUpperBound(store, *base, liveAssumptions,
                                         scale - 1)
      .has_value();
}

static FailureOr<std::optional<CyclicOffsetPattern>>
acceptCyclicTerm(sym::Store &store, sym::ExprHandle expr,
                 sym::ExprHandle cyclicTerm,
                 std::optional<CyclicOffsetPattern> pattern, StringRef ivName,
                 ArrayRef<sym::PredHandle> assumptions) {
  if (!pattern)
    return std::optional<CyclicOffsetPattern>{};
  FailureOr<bool> baseOk = baseFitsCyclicUpdate(
      store, expr, cyclicTerm, pattern->scale, ivName, assumptions);
  if (failed(baseOk))
    return failure();
  if (!*baseOk)
    return std::optional<CyclicOffsetPattern>{};
  return pattern;
}

static FailureOr<std::optional<CyclicOffsetPattern>>
matchModCyclicOffsetPattern(sym::Store &store, sym::ExprHandle expr,
                            StringRef ivName,
                            ArrayRef<sym::PredHandle> assumptions) {
  return acceptCyclicTerm(store, expr, expr,
                          matchScaledModOfIV(expr, /*scale=*/1, ivName), ivName,
                          assumptions);
}

static FailureOr<std::optional<CyclicOffsetPattern>>
matchMulCyclicOffsetPattern(sym::Store &store, sym::ExprHandle expr,
                            StringRef ivName,
                            ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  std::optional<int64_t> coefficient =
      sym::getIntegerLiteralValue(view.getMulCoefficient());
  if (!coefficient || view.getMulFactorCount() != 1)
    return std::optional<CyclicOffsetPattern>{};

  sym::MulFactor factor = view.getMulFactor(0);
  if (factor.exponent != 1)
    return std::optional<CyclicOffsetPattern>{};
  return acceptCyclicTerm(store, expr, expr,
                          matchScaledModOfIV(factor.base, *coefficient, ivName),
                          ivName, assumptions);
}

static FailureOr<std::optional<CyclicOffsetPattern>>
matchAddCyclicOffsetTerm(sym::Store &store, sym::ExprHandle expr,
                         sym::AddTerm term, StringRef ivName,
                         ArrayRef<sym::PredHandle> assumptions) {
  std::optional<int64_t> coefficient =
      sym::getIntegerLiteralValue(term.coefficient);
  if (!coefficient)
    return std::optional<CyclicOffsetPattern>{};
  std::optional<CyclicOffsetPattern> pattern =
      matchScaledModOfIV(term.term, *coefficient, ivName);
  if (!pattern)
    return std::optional<CyclicOffsetPattern>{};
  FailureOr<sym::ExprHandle> cyclicTerm =
      scaleExpr(store, term.term, pattern->scale);
  if (failed(cyclicTerm))
    return failure();
  return acceptCyclicTerm(store, expr, *cyclicTerm, pattern, ivName,
                          assumptions);
}

static FailureOr<std::optional<CyclicOffsetPattern>>
matchAddCyclicOffsetPattern(sym::Store &store, sym::ExprHandle expr,
                            StringRef ivName,
                            ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    FailureOr<std::optional<CyclicOffsetPattern>> pattern =
        matchAddCyclicOffsetTerm(store, expr, view.getAddTerm(i), ivName,
                                 assumptions);
    if (failed(pattern))
      return failure();
    if (*pattern)
      return *pattern;
  }
  return std::optional<CyclicOffsetPattern>{};
}

static FailureOr<std::optional<CyclicOffsetPattern>>
matchCyclicOffsetPattern(sym::Store &store, sym::ExprHandle expr,
                         StringRef ivName,
                         ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  if (view.getKind() == sym::ExprKind::Mod)
    return matchModCyclicOffsetPattern(store, expr, ivName, assumptions);
  if (view.getKind() == sym::ExprKind::Mul)
    return matchMulCyclicOffsetPattern(store, expr, ivName, assumptions);
  if (view.getKind() == sym::ExprKind::Add)
    return matchAddCyclicOffsetPattern(store, expr, ivName, assumptions);
  return std::optional<CyclicOffsetPattern>{};
}

static FailureOr<Value>
createCyclicOffsetUpdate(IRRewriter &rewriter, Location loc, MLIRContext *ctx,
                         sym::Store &store, Value current, int64_t increment,
                         int64_t ring) {
  FailureOr<sym::ExprHandle> offset = sym::composeExprSym(store, "offset");
  FailureOr<sym::ExprHandle> step = sym::composeExprInt(store, increment);
  FailureOr<sym::ExprHandle> ringExpr = sym::composeExprInt(store, ring);
  if (failed(offset) || failed(step) || failed(ringExpr))
    return failure();

  FailureOr<sym::ExprHandle> sum =
      sym::composeExprBinary(store, *offset, sym::ExprBinaryOp::Add, *step);
  if (failed(sum))
    return failure();
  FailureOr<sym::ExprHandle> wrapped =
      sym::composeExprBinary(store, *sum, sym::ExprBinaryOp::Mod, *ringExpr);
  if (failed(wrapped))
    return failure();
  FailureOr<sym::ExprHandle> simplified = simplifyExpanded(store, *wrapped, {});
  if (failed(simplified))
    return failure();

  BoundExpr update;
  update.expr = *simplified;
  update.names.push_back("offset");
  update.bindings.push_back(current);
  return createIndexExpr(rewriter, loc, ctx, update, nullptr).getResult();
}

static std::optional<std::string> findIVBinding(const ExpandedIndexExpr &expr,
                                                Value iv) {
  for (auto [name, binding] : llvm::zip(expr.names, expr.bindings))
    if (binding == iv)
      return name;
  return std::nullopt;
}

static bool isImmediateBodyOp(scf::ForOp loop, Operation *op) {
  return op->getBlock() == loop.getBody();
}

static bool canRewritePtrAddInLoop(scf::ForOp loop, PtrAddOp ptrAdd) {
  if (!isImmediateBodyOp(loop, ptrAdd))
    return false;
  if (ptrAdd->use_empty())
    return false;
  return !isDefinedInside(loop, ptrAdd.getBase());
}

static IndexExprOp getLoopLocalOffsetExpr(scf::ForOp loop, PtrAddOp ptrAdd) {
  IndexExprOp indexExpr = ptrAdd.getOffset().getDefiningOp<IndexExprOp>();
  if (!indexExpr || !isImmediateBodyOp(loop, indexExpr))
    return {};
  if (!indexExpr.getResult().hasOneUse())
    return {};
  return indexExpr;
}

static bool hasLoopLocalNonIVBinding(scf::ForOp loop,
                                     const ExpandedIndexExpr &indexExpr) {
  for (Value binding : indexExpr.bindings) {
    if (binding == loop.getInductionVar())
      continue;
    if (isDefinedInside(loop, binding))
      return true;
  }
  return false;
}

static bool areAllUsersSkipped(Operation *op,
                               const llvm::SmallPtrSetImpl<Operation *> &skip) {
  for (Value result : op->getResults())
    for (Operation *user : result.getUsers())
      if (!skip.contains(user))
        return false;
  return true;
}

static void collectDeadProducers(scf::ForOp loop, IndexExprOp indexExpr,
                                 ArrayRef<Operation *> producers,
                                 SmallVectorImpl<Operation *> &dead) {
  llvm::SmallPtrSet<Operation *, 8> skip;
  skip.insert(indexExpr);

  bool changed = true;
  while (changed) {
    changed = false;
    for (Operation *producer : producers) {
      if (skip.contains(producer) || !isImmediateBodyOp(loop, producer))
        continue;
      if (!areAllUsersSkipped(producer, skip))
        continue;
      skip.insert(producer);
      dead.push_back(producer);
      changed = true;
    }
  }
}

static LogicalResult buildCandidate(scf::ForOp loop, PtrAddOp ptrAdd,
                                    sym::Store &store, DataFlowSolver &solver,
                                    LoopStrideCandidate &candidate,
                                    bool &matched) {
  matched = false;
  if (!canRewritePtrAddInLoop(loop, ptrAdd))
    return success();

  IndexExprOp indexExpr = getLoopLocalOffsetExpr(loop, ptrAdd);
  if (!indexExpr)
    return success();

  FailureOr<ExpandedIndexExpr> expanded =
      expandIndexExpr(indexExpr, loop, store, solver);
  if (failed(expanded))
    return failure();
  std::optional<std::string> ivName =
      findIVBinding(*expanded, loop.getInductionVar());
  if (!ivName)
    return success();
  if (hasLoopLocalNonIVBinding(loop, *expanded))
    return success();

  FailureOr<BoundExpr> base = buildBaseExpr(*expanded, *ivName, loop, store);
  FailureOr<BoundExpr> stride =
      buildStrideExpr(*expanded, *ivName, loop, store);
  if (failed(base) || failed(stride))
    return success();

  candidate.ptrAdd = ptrAdd;
  candidate.indexExpr = indexExpr;
  collectDeadProducers(loop, indexExpr, expanded->producers,
                       candidate.deadProducers);
  candidate.base = std::move(*base);
  candidate.stride = std::move(*stride);
  matched = true;
  return success();
}

static bool canRewriteCyclicOffsetInLoop(scf::ForOp loop,
                                         IndexExprOp indexExpr) {
  if (!isImmediateBodyOp(loop, indexExpr))
    return false;
  if (indexExpr->use_empty())
    return false;
  return indexExpr.getResult().getType().isIndex();
}

static FailureOr<std::optional<CyclicOffsetLoopMatch>>
matchCyclicOffsetInLoop(scf::ForOp loop, IndexExprOp indexExpr,
                        sym::Store &store, DataFlowSolver &solver) {
  FailureOr<ExpandedIndexExpr> expanded =
      expandIndexExpr(indexExpr, loop, store, solver);
  if (failed(expanded))
    return failure();
  std::optional<std::string> ivName =
      findIVBinding(*expanded, loop.getInductionVar());
  if (!ivName)
    return std::optional<CyclicOffsetLoopMatch>{};
  if (hasLoopLocalNonIVBinding(loop, *expanded))
    return std::optional<CyclicOffsetLoopMatch>{};

  FailureOr<std::optional<CyclicOffsetPattern>> pattern =
      matchCyclicOffsetPattern(store, expanded->expr, *ivName,
                               expanded->assumptions);
  if (failed(pattern))
    return failure();
  if (!*pattern)
    return std::optional<CyclicOffsetLoopMatch>{};

  CyclicOffsetLoopMatch match;
  match.expanded = std::move(*expanded);
  match.ivName = std::move(*ivName);
  match.pattern = **pattern;
  return std::optional<CyclicOffsetLoopMatch>(std::move(match));
}

static std::optional<CyclicOffsetCarryShape>
computeCyclicOffsetCarryShape(scf::ForOp loop, CyclicOffsetPattern pattern) {
  std::optional<int64_t> step = getConstantIntValue(loop.getStep());
  if (!step || *step <= 0)
    return std::nullopt;
  __int128 increment = __int128(pattern.scale) * *step;
  __int128 ring = __int128(pattern.scale) * pattern.modulus;
  if (increment <= 0 || increment > std::numeric_limits<int64_t>::max() ||
      ring > std::numeric_limits<int64_t>::max())
    return std::nullopt;

  CyclicOffsetCarryShape shape;
  shape.increment = static_cast<int64_t>(increment);
  shape.ring = static_cast<int64_t>(ring);
  if (!isPowerOfTwo(shape.ring))
    return std::nullopt;
  return shape;
}

static LogicalResult
buildCyclicOffsetCandidate(scf::ForOp loop, IndexExprOp indexExpr,
                           sym::Store &store, DataFlowSolver &solver,
                           LoopCyclicOffsetCandidate &candidate,
                           bool &matched) {
  matched = false;
  if (!canRewriteCyclicOffsetInLoop(loop, indexExpr))
    return success();

  FailureOr<std::optional<CyclicOffsetLoopMatch>> match =
      matchCyclicOffsetInLoop(loop, indexExpr, store, solver);
  if (failed(match))
    return failure();
  if (!*match)
    return success();

  CyclicOffsetLoopMatch &cyclic = **match;
  std::optional<CyclicOffsetCarryShape> shape =
      computeCyclicOffsetCarryShape(loop, cyclic.pattern);
  if (!shape)
    return success();

  FailureOr<BoundExpr> base =
      buildBaseExpr(cyclic.expanded, cyclic.ivName, loop, store);
  if (failed(base))
    return success();

  candidate.indexExpr = indexExpr;
  collectDeadProducers(loop, indexExpr, cyclic.expanded.producers,
                       candidate.deadProducers);
  candidate.base = std::move(*base);
  candidate.increment = shape->increment;
  candidate.ring = shape->ring;
  matched = true;
  return success();
}

static FailureOr<std::optional<LoopStrideCandidate>>
findCandidate(scf::ForOp loop, sym::Store &store, DataFlowSolver &solver) {
  for (Operation &op : loop.getBody()->without_terminator()) {
    PtrAddOp ptrAdd = dyn_cast<PtrAddOp>(&op);
    if (!ptrAdd)
      continue;
    LoopStrideCandidate candidate;
    bool matched = false;
    if (failed(buildCandidate(loop, ptrAdd, store, solver, candidate, matched)))
      return failure();
    if (matched)
      return std::optional<LoopStrideCandidate>(std::move(candidate));
  }
  return std::optional<LoopStrideCandidate>{};
}

static FailureOr<std::optional<LoopCyclicOffsetCandidate>>
findCyclicOffsetCandidate(scf::ForOp loop, sym::Store &store,
                          DataFlowSolver &solver) {
  for (Operation &op : loop.getBody()->without_terminator()) {
    IndexExprOp indexExpr = dyn_cast<IndexExprOp>(&op);
    if (!indexExpr)
      continue;
    LoopCyclicOffsetCandidate candidate;
    bool matched = false;
    if (failed(buildCyclicOffsetCandidate(loop, indexExpr, store, solver,
                                          candidate, matched)))
      return failure();
    if (matched)
      return std::optional<LoopCyclicOffsetCandidate>(std::move(candidate));
  }
  return std::optional<LoopCyclicOffsetCandidate>{};
}

static Type getOffsetElementType(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    return simd.getElementType();
  return type;
}

static bool isIntegerOffsetCarryType(Type type) {
  Type elementType = getOffsetElementType(type);
  return elementType.isIndex() || isa<IntegerType>(elementType);
}

static bool hasOnlyYieldUse(Value value, scf::YieldOp yield) {
  if (!value.hasOneUse())
    return false;
  return *value.getUsers().begin() == yield.getOperation();
}

static Value getAdditiveStride(BlockArgument arg, BinaryOp update) {
  if (update.getKind() != BinaryKind::AddI)
    return {};
  if (update.getLhs() == arg)
    return update.getRhs();
  if (update.getRhs() == arg)
    return update.getLhs();
  return {};
}

static bool hasUnitStep(scf::ForOp loop) {
  std::optional<int64_t> step = getConstantIntValue(loop.getStep());
  return step && *step == 1;
}

static bool isOffsetCarryArgForLoop(scf::ForOp loop, BlockArgument arg) {
  Type elementType = getOffsetElementType(arg.getType());
  return isIntegerOffsetCarryType(arg.getType()) &&
         elementType == loop.getInductionVar().getType();
}

static BinaryOp getYieldedUpdate(scf::ForOp loop, unsigned index) {
  scf::YieldOp yield = cast<scf::YieldOp>(loop.getBody()->getTerminator());
  BinaryOp update = yield.getOperand(index).getDefiningOp<BinaryOp>();
  if (!update || !isImmediateBodyOp(loop, update))
    return {};
  if (!hasOnlyYieldUse(update.getResult(), yield))
    return {};
  return update;
}

static Value getLoopInvariantAdditiveStride(scf::ForOp loop, BlockArgument arg,
                                            BinaryOp update) {
  Value stride = getAdditiveStride(arg, update);
  if (!stride || isDefinedInside(loop, stride))
    return {};
  return stride;
}

static LogicalResult buildOffsetCarryCandidate(scf::ForOp loop, unsigned index,
                                               OffsetCarryCandidate &candidate,
                                               bool &matched) {
  matched = false;
  if (!hasUnitStep(loop))
    return success();
  if (!loop.getResult(index).use_empty())
    return success();

  BlockArgument arg = loop.getRegionIterArgs()[index];
  if (!isOffsetCarryArgForLoop(loop, arg))
    return success();

  BinaryOp update = getYieldedUpdate(loop, index);
  if (!update)
    return success();

  Value stride = getLoopInvariantAdditiveStride(loop, arg, update);
  if (!stride)
    return success();
  if (getOffsetElementType(stride.getType()) !=
      getOffsetElementType(arg.getType()))
    return success();

  candidate.update = update;
  candidate.init = loop.getInitArgs()[index];
  candidate.stride = stride;
  candidate.arg = arg;
  candidate.index = index;
  matched = true;
  return success();
}

static FailureOr<std::optional<LoopOffsetCarryCandidate>>
findOffsetCarryCandidate(scf::ForOp loop) {
  LoopOffsetCarryCandidate candidate;
  for (unsigned index : llvm::seq<unsigned>(0, loop.getNumResults())) {
    OffsetCarryCandidate offsetCarry;
    bool matched = false;
    if (failed(buildOffsetCarryCandidate(loop, index, offsetCarry, matched)))
      return failure();
    if (matched)
      candidate.carries.push_back(offsetCarry);
  }
  if (candidate.carries.empty())
    return std::optional<LoopOffsetCarryCandidate>{};
  return std::optional<LoopOffsetCarryCandidate>(std::move(candidate));
}

static bool isScalarOffset(Type type) {
  return isIntegerOffsetCarryType(type) && !isa<SimdType>(type);
}

static bool needsSimdOffset(Type resultType, Type baseType, Type offsetType) {
  return isa<SimdType>(resultType) && isa<PtrType>(baseType) &&
         isScalarOffset(offsetType);
}

static Type getSimdOffsetType(Type resultType, Type offsetType) {
  if (!offsetType.isIndex() && !offsetType.isInteger(32))
    return {};
  auto resultSimd = cast<SimdType>(resultType);
  return SimdType::get(resultType.getContext(), offsetType,
                       resultSimd.getWidth());
}

static IndexExprOp createIndexExpr(IRRewriter &rewriter, Location loc,
                                   MLIRContext *ctx, const BoundExpr &expr,
                                   IRMapping *map = nullptr) {
  SmallVector<StringRef> nameRefs;
  SmallVector<Value> bindings;
  for (StringRef name : expr.names)
    nameRefs.push_back(name);
  for (Value binding : expr.bindings)
    bindings.push_back(map ? map->lookupOrDefault(binding) : binding);
  Type type = getIndexExprResultType(ctx, bindings);
  return IndexExprOp::create(rewriter, loc, type, ExprAttr::get(ctx, expr.expr),
                             getIndexExprPredArrayAttr(ctx, expr.assumptions),
                             rewriter.getStrArrayAttr(nameRefs), bindings);
}

static FailureOr<Value> createPtrAdd(IRRewriter &rewriter, Location loc,
                                     Type resultType, Value base,
                                     Value offset) {
  if (needsSimdOffset(resultType, base.getType(), offset.getType())) {
    Type offsetType = getSimdOffsetType(resultType, offset.getType());
    if (!offsetType)
      return failure();
    Value simdOffset = SplatOp::create(rewriter, loc, offsetType, offset);
    return PtrAddOp::create(rewriter, loc, resultType, base, simdOffset)
        .getResult();
  }
  return PtrAddOp::create(rewriter, loc, resultType, base, offset).getResult();
}

static LogicalResult cloneBodyWithCarriedPointer(IRRewriter &rewriter,
                                                 scf::ForOp src, scf::ForOp dst,
                                                 LoopStrideCandidate candidate,
                                                 Value strideValue) {
  Block &srcBody = *src.getBody();
  Block &dstBody = *dst.getBody();
  Value ptrCarry = dstBody.getArgument(srcBody.getNumArguments());

  IRMapping map;
  map.map(srcBody.getArgument(0), dstBody.getArgument(0));
  for (auto [oldArg, newArg] :
       llvm::zip(src.getRegionIterArgs(), dst.getRegionIterArgs().drop_back()))
    map.map(oldArg, newArg);
  map.map(candidate.ptrAdd.getResult(), ptrCarry);

  rewriter.setInsertionPointToStart(&dstBody);
  for (Operation &op : srcBody.without_terminator()) {
    if (&op == candidate.indexExpr.getOperation() ||
        &op == candidate.ptrAdd.getOperation())
      continue;
    if (llvm::is_contained(candidate.deadProducers, &op))
      continue;
    rewriter.clone(op, map);
  }

  SmallVector<Value> yielded;
  scf::YieldOp srcYield = cast<scf::YieldOp>(srcBody.getTerminator());
  for (Value value : srcYield.getOperands())
    yielded.push_back(map.lookupOrDefault(value));

  FailureOr<Value> nextPtr = createPtrAdd(rewriter, candidate.ptrAdd.getLoc(),
                                          candidate.ptrAdd.getType(), ptrCarry,
                                          map.lookupOrDefault(strideValue));
  if (failed(nextPtr))
    return failure();
  yielded.push_back(*nextPtr);
  scf::YieldOp::create(rewriter, srcYield.getLoc(), yielded);
  return success();
}

static LogicalResult cloneBodyWithCarriedCyclicOffset(
    IRRewriter &rewriter, scf::ForOp src, scf::ForOp dst,
    LoopCyclicOffsetCandidate candidate, sym::Store &store) {
  Block &srcBody = *src.getBody();
  Block &dstBody = *dst.getBody();
  Value offsetCarry = dstBody.getArgument(srcBody.getNumArguments());

  IRMapping map;
  map.map(srcBody.getArgument(0), dstBody.getArgument(0));
  for (auto [oldArg, newArg] :
       llvm::zip(src.getRegionIterArgs(), dst.getRegionIterArgs().drop_back()))
    map.map(oldArg, newArg);
  map.map(candidate.indexExpr.getResult(), offsetCarry);

  rewriter.setInsertionPointToStart(&dstBody);
  for (Operation &op : srcBody.without_terminator()) {
    if (&op == candidate.indexExpr.getOperation())
      continue;
    if (llvm::is_contained(candidate.deadProducers, &op))
      continue;
    rewriter.clone(op, map);
  }

  SmallVector<Value> yielded;
  scf::YieldOp srcYield = cast<scf::YieldOp>(srcBody.getTerminator());
  for (Value value : srcYield.getOperands())
    yielded.push_back(map.lookupOrDefault(value));

  FailureOr<Value> nextOffset = createCyclicOffsetUpdate(
      rewriter, candidate.indexExpr.getLoc(), src->getContext(), store,
      offsetCarry, candidate.increment, candidate.ring);
  if (failed(nextOffset))
    return failure();
  yielded.push_back(*nextOffset);
  scf::YieldOp::create(rewriter, srcYield.getLoc(), yielded);
  return success();
}

static bool hasNonUpdateUse(OffsetCarryCandidate &candidate) {
  for (Operation *user : candidate.arg.getUsers())
    if (user != candidate.update.getOperation())
      return true;
  return false;
}

static Type getScaledStrideType(const OffsetCarryCandidate &candidate) {
  if (isa<SimdType>(candidate.stride.getType()))
    return candidate.arg.getType();
  return getOffsetElementType(candidate.arg.getType());
}

static Value createOffsetTrip(IRRewriter &rewriter, scf::ForOp loop) {
  Value iv = loop.getInductionVar();
  if (std::optional<int64_t> lower = getConstantIntValue(loop.getLowerBound()))
    if (*lower == 0)
      return iv;
  return BinaryOp::create(rewriter, loop.getLoc(), iv.getType(),
                          BinaryKind::SubI, iv, loop.getLowerBound());
}

static Value createOffsetCarryValue(IRRewriter &rewriter, Location loc,
                                    const OffsetCarryCandidate &candidate,
                                    Value trip) {
  Type scaledType = getScaledStrideType(candidate);
  Value scaled = BinaryOp::create(rewriter, loc, scaledType, BinaryKind::MulI,
                                  candidate.stride, trip);
  return BinaryOp::create(rewriter, loc, candidate.arg.getType(),
                          BinaryKind::AddI, candidate.init, scaled);
}

static LogicalResult cloneBodyWithoutOffsetCarries(
    IRRewriter &rewriter, scf::ForOp src, scf::ForOp dst,
    LoopOffsetCarryCandidate candidate, const llvm::BitVector &removed,
    ArrayRef<unsigned> newIndex) {
  Block &srcBody = *src.getBody();
  Block &dstBody = *dst.getBody();

  IRMapping map;
  map.map(src.getInductionVar(), dst.getInductionVar());
  for (auto [oldIndex, oldArg] : llvm::enumerate(src.getRegionIterArgs())) {
    if (removed.test(oldIndex))
      continue;
    map.map(oldArg, dst.getRegionIterArgs()[newIndex[oldIndex]]);
  }

  llvm::SmallPtrSet<Operation *, 8> skippedUpdates;
  rewriter.setInsertionPointToStart(&dstBody);
  Value trip;
  for (OffsetCarryCandidate &carry : candidate.carries) {
    skippedUpdates.insert(carry.update.getOperation());
    if (!hasNonUpdateUse(carry))
      continue;
    if (!trip)
      trip = createOffsetTrip(rewriter, dst);
    Value current =
        createOffsetCarryValue(rewriter, carry.update.getLoc(), carry, trip);
    map.map(carry.arg, current);
  }

  for (Operation &op : srcBody.without_terminator()) {
    if (skippedUpdates.contains(&op))
      continue;
    rewriter.clone(op, map);
  }

  SmallVector<Value> yielded;
  scf::YieldOp srcYield = cast<scf::YieldOp>(srcBody.getTerminator());
  for (auto [index, value] : llvm::enumerate(srcYield.getOperands())) {
    if (removed.test(index))
      continue;
    yielded.push_back(map.lookupOrDefault(value));
  }
  scf::YieldOp::create(rewriter, srcYield.getLoc(), yielded);
  return success();
}

static void copyLoopAttrs(scf::ForOp src, scf::ForOp dst) {
  for (NamedAttribute attr : src->getAttrs())
    dst->setAttr(attr.getName(), attr.getValue());
}

static LogicalResult rewriteLoop(IRRewriter &rewriter, scf::ForOp loop,
                                 LoopStrideCandidate candidate) {
  Location loc = loop.getLoc();
  rewriter.setInsertionPoint(loop);
  IndexExprOp base = createIndexExpr(rewriter, candidate.indexExpr.getLoc(),
                                     loop->getContext(), candidate.base);
  FailureOr<Value> basePtr = createPtrAdd(
      rewriter, candidate.ptrAdd.getLoc(), candidate.ptrAdd.getType(),
      candidate.ptrAdd.getBase(), base.getResult());
  if (failed(basePtr))
    return failure();
  IndexExprOp stride = createIndexExpr(rewriter, candidate.ptrAdd.getLoc(),
                                       loop->getContext(), candidate.stride);

  SmallVector<Value> initArgs(loop.getInitArgs().begin(),
                              loop.getInitArgs().end());
  initArgs.push_back(*basePtr);
  scf::ForOp newLoop =
      scf::ForOp::create(rewriter, loc, loop.getLowerBound(),
                         loop.getUpperBound(), loop.getStep(), initArgs);
  copyLoopAttrs(loop, newLoop);
  if (failed(cloneBodyWithCarriedPointer(rewriter, loop, newLoop, candidate,
                                         stride.getResult())))
    return failure();

  rewriter.replaceOp(loop,
                     newLoop.getResults().take_front(loop.getNumResults()));
  return success();
}

static LogicalResult rewriteLoop(IRRewriter &rewriter, scf::ForOp loop,
                                 LoopCyclicOffsetCandidate candidate,
                                 sym::Store &store) {
  Location loc = loop.getLoc();
  rewriter.setInsertionPoint(loop);
  IndexExprOp base = createIndexExpr(rewriter, candidate.indexExpr.getLoc(),
                                     loop->getContext(), candidate.base);

  SmallVector<Value> initArgs(loop.getInitArgs().begin(),
                              loop.getInitArgs().end());
  initArgs.push_back(base.getResult());
  scf::ForOp newLoop =
      scf::ForOp::create(rewriter, loc, loop.getLowerBound(),
                         loop.getUpperBound(), loop.getStep(), initArgs);
  copyLoopAttrs(loop, newLoop);
  if (failed(cloneBodyWithCarriedCyclicOffset(rewriter, loop, newLoop,
                                              candidate, store)))
    return failure();

  rewriter.replaceOp(loop,
                     newLoop.getResults().take_front(loop.getNumResults()));
  return success();
}

static LogicalResult rewriteLoop(IRRewriter &rewriter, scf::ForOp loop,
                                 LoopOffsetCarryCandidate candidate) {
  llvm::BitVector removed(loop.getNumResults());
  for (const OffsetCarryCandidate &carry : candidate.carries)
    removed.set(carry.index);

  unsigned removedIndex = std::numeric_limits<unsigned>::max();
  SmallVector<unsigned> newIndex(loop.getNumResults(), removedIndex);
  SmallVector<Value> initArgs;
  for (unsigned index : llvm::seq<unsigned>(0, loop.getNumResults())) {
    if (removed.test(index))
      continue;
    newIndex[index] = initArgs.size();
    initArgs.push_back(loop.getInitArgs()[index]);
  }

  rewriter.setInsertionPoint(loop);
  scf::ForOp newLoop =
      scf::ForOp::create(rewriter, loop.getLoc(), loop.getLowerBound(),
                         loop.getUpperBound(), loop.getStep(), initArgs);
  copyLoopAttrs(loop, newLoop);
  if (failed(cloneBodyWithoutOffsetCarries(rewriter, loop, newLoop, candidate,
                                           removed, newIndex)))
    return failure();

  for (unsigned index : llvm::seq<unsigned>(0, loop.getNumResults())) {
    if (removed.test(index)) {
      assert(loop.getResult(index).use_empty() &&
             "removed offset carry result must be unused");
      continue;
    }
    loop.getResult(index).replaceAllUsesWith(
        newLoop.getResult(newIndex[index]));
  }
  rewriter.eraseOp(loop);
  return success();
}

static FailureOr<bool> rewriteOneLoop(IRRewriter &rewriter, scf::ForOp loop,
                                      sym::Store &store,
                                      DataFlowSolver &solver) {
  FailureOr<std::optional<LoopStrideCandidate>> candidate =
      findCandidate(loop, store, solver);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return false;
  if (failed(rewriteLoop(rewriter, loop, **candidate)))
    return failure();
  return true;
}

static FailureOr<bool> rewriteOneCyclicOffset(IRRewriter &rewriter,
                                              scf::ForOp loop,
                                              sym::Store &store,
                                              DataFlowSolver &solver) {
  FailureOr<std::optional<LoopCyclicOffsetCandidate>> candidate =
      findCyclicOffsetCandidate(loop, store, solver);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return false;
  if (failed(rewriteLoop(rewriter, loop, **candidate, store)))
    return failure();
  return true;
}

static FailureOr<bool> rewriteOneOffsetCarry(IRRewriter &rewriter,
                                             scf::ForOp loop) {
  FailureOr<std::optional<LoopOffsetCarryCandidate>> candidate =
      findOffsetCarryCandidate(loop);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return false;
  if (failed(rewriteLoop(rewriter, loop, **candidate)))
    return failure();
  return true;
}

static FailureOr<bool> rewriteOneStrideExtraction(IRRewriter &rewriter,
                                                  scf::ForOp loop,
                                                  WaveDialect *dialect,
                                                  DataFlowSolver &solver) {
  FailureOr<bool> rewritten =
      rewriteOneLoop(rewriter, loop, dialect->getSymbolStore(), solver);
  if (failed(rewritten) || *rewritten)
    return rewritten;

  rewritten =
      rewriteOneCyclicOffset(rewriter, loop, dialect->getSymbolStore(), solver);
  if (failed(rewritten) || *rewritten)
    return rewritten;

  return rewriteOneOffsetCarry(rewriter, loop);
}

struct WaveExtractLoopStridesPass
    : public wave::impl::WaveExtractLoopStridesBase<
          WaveExtractLoopStridesPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    WaveDialect *dialect = root->getContext()->getLoadedDialect<WaveDialect>();
    if (!dialect) {
      root->emitError("Wave dialect is not loaded");
      return signalPassFailure();
    }

    IRRewriter rewriter(root->getContext());
    bool changed = true;
    while (changed) {
      changed = false;
      DataFlowSolver solver;
      dataflow::loadBaselineAnalyses(solver);
      solver.load<dataflow::IntegerRangeAnalysis>();
      if (failed(solver.initializeAndRun(root))) {
        root->emitError(
            "IntegerRangeAnalysis failed for loop stride extraction pass");
        return signalPassFailure();
      }
      WalkResult result = root->walk([&](scf::ForOp loop) {
        FailureOr<bool> rewritten =
            rewriteOneStrideExtraction(rewriter, loop, dialect, solver);
        if (failed(rewritten)) {
          signalPassFailure();
          return WalkResult::interrupt();
        }
        if (!*rewritten)
          return WalkResult::advance();
        changed = true;
        return WalkResult::interrupt();
      });
      if (result.wasInterrupted() && !changed)
        return;
    }
  }
};

} // namespace
