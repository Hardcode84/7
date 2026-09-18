//===- WaveExtractLoopStrides.cpp - expose loop-carried strides -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WavePointerAdd.h"
#include "WaveSignedRange.h"
#include "WaveSymbolicValueAnalysis.h"

#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/LoopInvariantCodeMotionUtils.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringSet.h"

#include <optional>
#include <string>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEEXTRACTLOOPSTRIDES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static constexpr int64_t u32Max = (int64_t{1} << 32) - 1;
static constexpr StringLiteral kRematerializationAlternativeAttr =
    "wave.rematerialization_alternative";
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
  sym::ExprHandle materializationExpr;
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
  bool canAnchor = false;
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

struct CyclicOffsetMember {
  IndexExprOp indexExpr;
  int64_t delta = 0;
  bool retainRematerializedAlternative = false;
};

struct LoopCyclicOffsetCandidate {
  SmallVector<CyclicOffsetMember> members;
  SmallVector<Operation *> producers;
  SmallVector<Operation *> deadProducers;
  BoundExpr base;
  BoundExpr proof;
  BoundExpr increment;
  int64_t ring = 0;
  bool canAnchor = false;
};

struct LoopMemoryOffsetCandidate {
  BoundExpr base;
  BoundExpr increment;
  PtrAddOp ptrAdd;
  int64_t ring = 0;
};

using MaterializationAlternatives = llvm::SmallPtrSet<Operation *, 4>;

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

static Value createOffsetExpr(IRRewriter &rewriter, Location loc,
                              const BoundExpr &expr, Type offsetType);

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

static void collectUsedNames(const BoundExpr &expr, llvm::StringSet<> &used) {
  for (StringRef name : expr.names)
    used.insert(name);
}

static sym::ExprHandle symbolForValue(sym::Store &store, Value value,
                                      StringRef stem, llvm::StringSet<> &used,
                                      SmallVectorImpl<NamedBinding> &extra) {
  if (std::optional<int64_t> constant = getConstantIntValue(value))
    return sym::composeExprInt(store, *constant);

  std::string name = uniqueName(used, stem);
  sym::ExprHandle expr = sym::composeExprSym(store, name);
  extra.push_back({name, value});
  return expr;
}

static sym::ExprHandle symbolExpr(sym::Store &store, StringRef name) {
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
  bool modelWrappingIntegerArithmetic = false;
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
  if (op.hasNoSignedWrap() ||
      hasAddressArithmeticNoOverflowAssumption(op.getOperation()))
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
wrapSignedIntegerExpr(sym::Store &store, sym::ExprHandle expr, unsigned bits) {
  // Preserve signed fixed-width overflow in the symbolic expression.
  if (bits == 0 || bits >= 63)
    return failure();
  FailureOr<sym::ExprHandle> bias =
      sym::composeExprInt(store, int64_t{1} << (bits - 1));
  FailureOr<sym::ExprHandle> modulus =
      sym::composeExprInt(store, int64_t{1} << bits);
  if (failed(bias) || failed(modulus))
    return failure();
  FailureOr<sym::ExprHandle> biased =
      sym::composeExprBinary(store, expr, sym::ExprBinaryOp::Add, *bias);
  FailureOr<sym::ExprHandle> wrapped =
      succeeded(biased) ? sym::composeExprBinary(
                              store, *biased, sym::ExprBinaryOp::Mod, *modulus)
                        : FailureOr<sym::ExprHandle>(failure());
  if (failed(wrapped))
    return failure();
  return sym::composeExprBinary(store, *wrapped, sym::ExprBinaryOp::Sub, *bias);
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
  bool noSignedOverflow = rangeProvesNoSignedOverflow(op, solver);
  if (!kind || (!state.modelWrappingIntegerArithmetic && !noSignedOverflow))
    return bindExpandedValue(op.getResult(), stem, store, state);

  FailureOr<sym::ExprHandle> lhs =
      expandValueExpr(op.getLhs(), stem, loop, store, solver, state, depth);
  FailureOr<sym::ExprHandle> rhs =
      expandValueExpr(op.getRhs(), stem, loop, store, solver, state, depth);
  if (failed(lhs) || failed(rhs))
    return failure();
  FailureOr<sym::ExprHandle> mathematical =
      sym::composeExprBinary(store, *lhs, *kind, *rhs);
  if (failed(mathematical) || noSignedOverflow)
    return mathematical;
  FailureOr<sym::ExprHandle> wrapped = wrapSignedIntegerExpr(
      store, *mathematical, elementStorageBitWidth(op.getType()));
  return succeeded(wrapped)
             ? *wrapped
             : bindExpandedValue(op.getResult(), stem, store, state);
}

static FailureOr<sym::ExprHandle>
expandShiftLeftExpr(BinaryOp op, StringRef stem, scf::ForOp loop,
                    sym::Store &store, DataFlowSolver &solver,
                    ExpansionState &state, unsigned depth) {
  bool noSignedOverflow = rangeProvesNoSignedOverflow(op, solver);
  if (!state.modelWrappingIntegerArithmetic && !noSignedOverflow)
    return bindExpandedValue(op.getResult(), stem, store, state);
  std::optional<int64_t> shift = getConstantIntValue(op.getRhs());
  if (!shift || *shift < 0 || *shift >= 63)
    return bindExpandedValue(op.getResult(), stem, store, state);
  FailureOr<sym::ExprHandle> lhs =
      expandValueExpr(op.getLhs(), stem, loop, store, solver, state, depth);
  sym::ExprHandle scale = sym::composeExprInt(store, int64_t{1} << *shift);
  if (failed(lhs))
    return failure();
  FailureOr<sym::ExprHandle> mathematical =
      sym::composeExprBinary(store, *lhs, sym::ExprBinaryOp::Mul, scale);
  if (failed(mathematical) || noSignedOverflow)
    return mathematical;
  FailureOr<sym::ExprHandle> wrapped = wrapSignedIntegerExpr(
      store, *mathematical, elementStorageBitWidth(op.getType()));
  return succeeded(wrapped)
             ? *wrapped
             : bindExpandedValue(op.getResult(), stem, store, state);
}

static FailureOr<sym::ExprHandle>
expandNonnegativeRemainderExpr(BinaryOp op, StringRef stem, scf::ForOp loop,
                               sym::Store &store, DataFlowSolver &solver,
                               ExpansionState &state, unsigned depth) {
  std::optional<int64_t> divisor = getConstantIntValue(op.getRhs());
  std::optional<std::pair<int64_t, int64_t>> dividend =
      finiteSignedI64Range(solver, op.getLhs());
  if (!divisor || *divisor <= 0 || !dividend || dividend->first < 0)
    return bindExpandedValue(op.getResult(), stem, store, state);

  FailureOr<sym::ExprHandle> lhs =
      expandValueExpr(op.getLhs(), stem, loop, store, solver, state, depth);
  if (failed(lhs))
    return failure();
  FailureOr<sym::ExprHandle> modulus = sym::composeExprInt(store, *divisor);
  if (failed(modulus))
    return failure();
  return sym::composeExprBinary(store, *lhs, sym::ExprBinaryOp::Mod, *modulus);
}

static FailureOr<sym::ExprHandle>
expandBinaryExpr(BinaryOp op, StringRef stem, scf::ForOp loop,
                 sym::Store &store, DataFlowSolver &solver,
                 ExpansionState &state, unsigned depth) {
  if (op.getKind() == BinaryKind::ShLI)
    return expandShiftLeftExpr(op, stem, loop, store, solver, state, depth);
  if (op.getKind() == BinaryKind::RemSI || op.getKind() == BinaryKind::RemUI)
    return expandNonnegativeRemainderExpr(op, stem, loop, store, solver, state,
                                          depth);
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
    sym::ExprHandle target = symbolExpr(store, name);

    FailureOr<sym::ExprHandle> replacement =
        expandValueExpr(value, name, loop, store, solver, state, /*depth=*/0);
    if (failed(replacement))
      return failure();
    substitutions.push_back({target, *replacement});
  }

  sym::ExprHandle substituted =
      sym::substituteExpr(store, op.getExpr().getValue(), substitutions);

  SmallVector<sym::PredHandle> assumptions;
  appendIndexExprPredicates(op, assumptions);
  FailureOr<SmallVector<sym::PredHandle>> substitutedAssumptions =
      substituteIndexExprPredicates(store, assumptions, substitutions);
  if (failed(substitutedAssumptions))
    return failure();
  llvm::append_range(state.assumptions, *substitutedAssumptions);
  return substituted;
}

static FailureOr<ExpandedIndexExpr>
expandIndexExpr(IndexExprOp op, scf::ForOp loop, sym::Store &store,
                DataFlowSolver &solver, bool modelWrapping = false) {
  ExpansionState state;
  state.modelWrappingIntegerArithmetic = modelWrapping;
  for (auto [nameAttr, value] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    state.reserved[name] = value;
  }

  FailureOr<sym::ExprHandle> materializationExpr =
      expandIndexExpr(op, loop, store, solver, state);
  if (failed(materializationExpr))
    return failure();
  FailureOr<sym::ExprHandle> expr =
      simplifyExpanded(store, *materializationExpr, state.assumptions);
  if (failed(expr))
    return failure();

  ExpandedIndexExpr out;
  out.expr = *expr;
  out.materializationExpr = *materializationExpr;
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

static FailureOr<sym::ExprHandle> simplifyExpanded(sym::Analysis &analysis,
                                                   sym::ExprHandle expr) {
  FailureOr<sym::ExprHandle> expanded = analysis.expand(expr);
  if (failed(expanded))
    return failure();
  return analysis.simplify(*expanded);
}

static FailureOr<sym::ExprHandle>
simplifyExpanded(sym::Store &store, sym::ExprHandle expr,
                 ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, assumptions);
  if (failed(analysis))
    return failure();
  return simplifyExpanded(**analysis, expr);
}

static FailureOr<sym::ExprHandle>
simplifyExpandedForMaterialization(sym::Store &store, sym::ExprHandle expr,
                                   ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> simplified =
      simplifyExpanded(store, expr, assumptions);
  if (failed(simplified))
    return failure();
  return shouldUseSimplifiedIndexExpr(*simplified, expr) ? *simplified : expr;
}

static FailureOr<BoundExpr> buildBaseExpr(const ExpandedIndexExpr &expanded,
                                          StringRef ivName, scf::ForOp loop,
                                          sym::Store &store) {
  llvm::StringSet<> used;
  collectUsedNames(expanded, used);

  sym::ExprHandle iv = sym::composeExprSym(store, ivName);
  SmallVector<NamedBinding> extra;
  sym::ExprHandle lower = symbolForValue(
      store, loop.getLowerBound(), (Twine(ivName) + "_lb").str(), used, extra);

  sym::ExprHandle substituted =
      sym::substituteExpr(store, expanded.materializationExpr, {{iv, lower}});
  FailureOr<SmallVector<sym::PredHandle>> substitutedAssumptions =
      substituteIndexExprPredicates(store, expanded.assumptions, {{iv, lower}});
  if (failed(substitutedAssumptions))
    return failure();
  FailureOr<sym::ExprHandle> simplified = simplifyExpandedForMaterialization(
      store, substituted, *substitutedAssumptions);
  if (failed(simplified))
    return failure();
  return bindLiveExpr(expanded, *simplified, ivName, *substitutedAssumptions,
                      extra);
}

struct StrideProof {
  sym::ExprHandle proof;
  sym::ExprHandle materialization;
};

static FailureOr<StrideProof>
buildStrideProof(sym::Analysis &analysis, const ExpandedIndexExpr &expanded,
                 sym::ExprHandle iv, sym::ExprHandle step) {
  std::optional<sym::ExprHandle> proof =
      analysis.finiteDifference(expanded.expr, iv, step);
  if (!proof || analysis.integerValued(*proof) != sym::CheckResult::True)
    return failure();

  FailureOr<sym::ExprHandle> ivPlusStep =
      analysis.compose(iv, sym::ExprBinaryOp::Add, step);
  if (failed(ivPlusStep))
    return failure();
  FailureOr<sym::ExprHandle> shifted =
      analysis.substitute(expanded.materializationExpr, {{iv, *ivPlusStep}});
  FailureOr<sym::ExprHandle> current =
      analysis.substitute(expanded.materializationExpr, {{iv, iv}});
  if (failed(shifted) || failed(current))
    return failure();
  FailureOr<sym::ExprHandle> materialization =
      analysis.compose(*shifted, sym::ExprBinaryOp::Sub, *current);
  if (failed(materialization) ||
      analysis.equivalent(*proof, *materialization) != sym::CheckResult::True)
    return failure();
  return StrideProof{*proof, *materialization};
}

static FailureOr<sym::ExprHandle>
selectAnchoredStride(sym::Analysis &analysis, const ExpandedIndexExpr &expanded,
                     StringRef ivName, sym::ExprHandle iv, sym::ExprHandle step,
                     const StrideProof &proof) {
  FailureOr<sym::ExprHandle> zero = analysis.composeInteger(0);
  if (failed(zero))
    return failure();
  FailureOr<sym::ExprHandle> atStep =
      analysis.substitute(expanded.materializationExpr, {{iv, step}});
  FailureOr<sym::ExprHandle> atZero =
      analysis.substitute(expanded.materializationExpr, {{iv, *zero}});
  if (failed(atStep) || failed(atZero))
    return failure();
  FailureOr<sym::ExprHandle> anchored =
      analysis.compose(*atStep, sym::ExprBinaryOp::Sub, *atZero);
  if (failed(anchored))
    return failure();
  if (hasSymbol(*anchored, ivName))
    return proof.materialization;
  if (analysis.equivalent(proof.proof, *anchored) != sym::CheckResult::True)
    return proof.materialization;
  return shouldUseSimplifiedIndexExpr(*anchored, proof.materialization)
             ? *anchored
             : proof.materialization;
}

static sym::ExprHandle selectSimplifiedStride(sym::Analysis &analysis,
                                              const StrideProof &proof,
                                              sym::ExprHandle stride) {
  if (FailureOr<sym::ExprHandle> simplified = analysis.simplify(stride);
      succeeded(simplified) &&
      shouldUseSimplifiedIndexExpr(*simplified, stride))
    stride = *simplified;
  if (shouldUseSimplifiedIndexExpr(proof.proof, proof.materialization) &&
      shouldUseSimplifiedIndexExpr(proof.proof, stride))
    stride = proof.proof;
  return stride;
}

static FailureOr<sym::ExprHandle>
selectStrideExpr(sym::Analysis &analysis, const ExpandedIndexExpr &expanded,
                 StringRef ivName, sym::ExprHandle iv, sym::ExprHandle step,
                 const StrideProof &proof) {
  FailureOr<sym::ExprHandle> stride =
      selectAnchoredStride(analysis, expanded, ivName, iv, step, proof);
  if (failed(stride))
    return failure();
  return selectSimplifiedStride(analysis, proof, *stride);
}

static FailureOr<BoundExpr> buildStrideExpr(const ExpandedIndexExpr &expanded,
                                            StringRef ivName, scf::ForOp loop,
                                            sym::Store &store) {
  llvm::StringSet<> used;
  collectUsedNames(expanded, used);

  sym::ExprHandle iv = sym::composeExprSym(store, ivName);
  SmallVector<NamedBinding> extra;
  sym::ExprHandle step = symbolForValue(
      store, loop.getStep(), (Twine(ivName) + "_step").str(), used, extra);

  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, expanded.assumptions);
  if (failed(analysis))
    return failure();
  FailureOr<StrideProof> proof =
      buildStrideProof(**analysis, expanded, iv, step);
  if (failed(proof))
    return failure();
  FailureOr<sym::ExprHandle> stride =
      selectStrideExpr(**analysis, expanded, ivName, iv, step, *proof);
  if (failed(stride))
    return failure();
  (*analysis).reset();
  if (sym::getIntegerLiteralValue(*stride) == int64_t{0})
    return failure();
  return bindLiveExpr(expanded, *stride, ivName, expanded.assumptions, extra);
}

static FailureOr<BoundExpr>
buildModularStrideExpr(const ExpandedIndexExpr &expanded, StringRef ivName,
                       scf::ForOp loop, sym::Store &store, int64_t ring) {
  llvm::StringSet<> used;
  collectUsedNames(expanded, used);
  sym::ExprHandle iv = sym::composeExprSym(store, ivName);
  SmallVector<NamedBinding> extra;
  sym::ExprHandle step = symbolForValue(
      store, loop.getStep(), (Twine(ivName) + "_step").str(), used, extra);

  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, expanded.assumptions);
  if (failed(analysis))
    return failure();
  FailureOr<sym::ExprHandle> nextIV =
      (*analysis)->compose(iv, sym::ExprBinaryOp::Add, step);
  if (failed(nextIV))
    return failure();
  sym::ExprHandle next =
      (*analysis)->substitute(expanded.materializationExpr, {{iv, *nextIV}});
  sym::ExprHandle current =
      (*analysis)->substitute(expanded.materializationExpr, {{iv, iv}});
  FailureOr<sym::ExprHandle> difference =
      (*analysis)->compose(next, sym::ExprBinaryOp::Sub, current);
  if (failed(difference))
    return failure();
  FailureOr<sym::ExprHandle> wrapped = (*analysis)->compose(
      *difference, sym::ExprBinaryOp::Mod, (*analysis)->composeInteger(ring));
  if (failed(wrapped))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      simplifyExpanded(**analysis, *wrapped);
  if (failed(simplified) || hasSymbol(*simplified, ivName) ||
      sym::getIntegerLiteralValue(*simplified) == int64_t{0})
    return failure();
  return bindLiveExpr(expanded, *simplified, ivName, expanded.assumptions,
                      extra);
}

static bool isPowerOfTwo(int64_t value) {
  return value > 0 && (value & (value - 1)) == 0;
}

static std::optional<int64_t> matchIVPlusConstant(sym::Analysis &analysis,
                                                  sym::ExprHandle expr,
                                                  StringRef ivName) {
  FailureOr<sym::ExprHandle> iv = analysis.composeSymbol(ivName);
  if (failed(iv))
    return std::nullopt;
  std::optional<sym::AffineDecomposition> decomposition =
      analysis.affineDecompose(expr, *iv);
  if (!decomposition ||
      sym::getIntegerLiteralValue(decomposition->coefficient) != int64_t{1})
    return std::nullopt;
  return sym::getIntegerLiteralValue(decomposition->residual);
}

static std::optional<CyclicOffsetPattern>
matchScaledModOfIV(sym::Analysis &analysis, sym::ExprHandle modExpr,
                   int64_t scale, StringRef ivName) {
  if (scale <= 0)
    return std::nullopt;
  sym::ExprView view(modExpr);
  if (view.getKind() != sym::ExprKind::Mod)
    return std::nullopt;
  if (!matchIVPlusConstant(analysis, view.getBinaryLhs(), ivName))
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
scaleExpr(sym::Analysis &analysis, sym::ExprHandle expr, int64_t scale) {
  if (scale == 1)
    return expr;
  FailureOr<sym::ExprHandle> coeff = analysis.composeInteger(scale);
  if (failed(coeff))
    return failure();
  return analysis.compose(*coeff, sym::ExprBinaryOp::Mul, expr);
}

static FailureOr<bool> baseFitsCyclicUpdate(sym::Analysis &analysis,
                                            sym::ExprHandle expr,
                                            sym::ExprHandle cyclicTerm,
                                            int64_t scale, StringRef ivName) {
  FailureOr<sym::ExprHandle> diff =
      analysis.compose(expr, sym::ExprBinaryOp::Sub, cyclicTerm);
  if (failed(diff))
    return failure();
  FailureOr<sym::ExprHandle> base = simplifyExpanded(analysis, *diff);
  if (failed(base))
    return failure();
  if (hasSymbol(*base, ivName))
    return false;
  if (sym::getIntegerLiteralValue(*base) == int64_t{0})
    return true;

  std::optional<sym::InferredRange> range = analysis.range(*base);
  if (!range || !range->lower || !range->upper)
    return false;
  return sym::compareEndpointToInteger(*range->lower, 0) >= 0 &&
         sym::compareEndpointToInteger(*range->upper, scale - 1) <= 0 &&
         sym::ceilEndpoint(*range->upper).has_value();
}

static FailureOr<std::optional<CyclicOffsetPattern>>
acceptCyclicTerm(sym::Analysis &analysis, sym::ExprHandle expr,
                 sym::ExprHandle cyclicTerm,
                 std::optional<CyclicOffsetPattern> pattern, StringRef ivName) {
  if (!pattern)
    return std::optional<CyclicOffsetPattern>{};
  FailureOr<bool> baseOk =
      baseFitsCyclicUpdate(analysis, expr, cyclicTerm, pattern->scale, ivName);
  if (failed(baseOk))
    return failure();
  pattern->canAnchor = *baseOk;
  return pattern;
}

static FailureOr<std::optional<CyclicOffsetPattern>>
matchModCyclicOffsetPattern(sym::Analysis &analysis, sym::ExprHandle expr,
                            StringRef ivName) {
  return acceptCyclicTerm(
      analysis, expr, expr,
      matchScaledModOfIV(analysis, expr, /*scale=*/1, ivName), ivName);
}

static FailureOr<std::optional<CyclicOffsetPattern>>
matchMulCyclicOffsetPattern(sym::Analysis &analysis, sym::ExprHandle expr,
                            StringRef ivName) {
  sym::ExprView view(expr);
  std::optional<int64_t> coefficient =
      sym::getIntegerLiteralValue(view.getMulCoefficient());
  if (!coefficient || view.getMulFactorCount() != 1)
    return std::optional<CyclicOffsetPattern>{};

  sym::MulFactor factor = view.getMulFactor(0);
  if (factor.exponent != 1)
    return std::optional<CyclicOffsetPattern>{};
  return acceptCyclicTerm(
      analysis, expr, expr,
      matchScaledModOfIV(analysis, factor.base, *coefficient, ivName), ivName);
}

static FailureOr<std::optional<CyclicOffsetPattern>>
matchAddCyclicOffsetTerm(sym::Analysis &analysis, sym::ExprHandle expr,
                         sym::AddTerm term, StringRef ivName) {
  std::optional<int64_t> coefficient =
      sym::getIntegerLiteralValue(term.coefficient);
  if (!coefficient)
    return std::optional<CyclicOffsetPattern>{};
  std::optional<CyclicOffsetPattern> pattern =
      matchScaledModOfIV(analysis, term.term, *coefficient, ivName);
  if (!pattern)
    return std::optional<CyclicOffsetPattern>{};
  FailureOr<sym::ExprHandle> cyclicTerm =
      scaleExpr(analysis, term.term, pattern->scale);
  if (failed(cyclicTerm))
    return failure();
  return acceptCyclicTerm(analysis, expr, *cyclicTerm, pattern, ivName);
}

static FailureOr<std::optional<CyclicOffsetPattern>>
matchAddCyclicOffsetPattern(sym::Analysis &analysis, sym::ExprHandle expr,
                            StringRef ivName) {
  sym::ExprView view(expr);
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    FailureOr<std::optional<CyclicOffsetPattern>> pattern =
        matchAddCyclicOffsetTerm(analysis, expr, view.getAddTerm(i), ivName);
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
  if (view.getKind() != sym::ExprKind::Mod &&
      view.getKind() != sym::ExprKind::Mul &&
      view.getKind() != sym::ExprKind::Add)
    return std::optional<CyclicOffsetPattern>{};
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, assumptions);
  if (failed(analysis))
    return std::optional<CyclicOffsetPattern>{};
  if (view.getKind() == sym::ExprKind::Mod)
    return matchModCyclicOffsetPattern(**analysis, expr, ivName);
  if (view.getKind() == sym::ExprKind::Mul)
    return matchMulCyclicOffsetPattern(**analysis, expr, ivName);
  return matchAddCyclicOffsetPattern(**analysis, expr, ivName);
}

static FailureOr<Value>
createCyclicOffsetUpdate(IRRewriter &rewriter, Location loc, sym::Store &store,
                         Value current, const BoundExpr &increment,
                         int64_t ring) {
  llvm::StringSet<> used;
  collectUsedNames(increment, used);
  std::string offsetName = uniqueName(used, "offset");
  FailureOr<sym::ExprHandle> offset = sym::composeExprSym(store, offsetName);
  FailureOr<sym::ExprHandle> ringExpr = sym::composeExprInt(store, ring);
  if (failed(offset) || failed(ringExpr))
    return failure();

  FailureOr<sym::ExprHandle> sum = sym::composeExprBinary(
      store, *offset, sym::ExprBinaryOp::Add, increment.expr);
  if (failed(sum))
    return failure();
  FailureOr<sym::ExprHandle> wrapped =
      sym::composeExprBinary(store, *sum, sym::ExprBinaryOp::Mod, *ringExpr);
  if (failed(wrapped))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      simplifyExpandedForMaterialization(store, *wrapped, {});
  if (failed(simplified))
    return failure();

  BoundExpr update;
  update.expr = *simplified;
  update.assumptions = increment.assumptions;
  update.names.push_back(offsetName);
  update.bindings.push_back(current);
  llvm::append_range(update.names, increment.names);
  llvm::append_range(update.bindings, increment.bindings);
  return createOffsetExpr(rewriter, loc, update, current.getType());
}

static Value stripAssumes(Value value) {
  while (AssumeOp assume = value.getDefiningOp<AssumeOp>())
    value = assume.getValue();
  return value;
}

static std::optional<std::string> findIVBinding(const ExpandedIndexExpr &expr,
                                                Value iv) {
  for (auto [name, binding] : llvm::zip(expr.names, expr.bindings))
    if (stripAssumes(binding) == iv)
      return name;
  return std::nullopt;
}

static bool isImmediateBodyOp(scf::ForOp loop, Operation *op) {
  return op->getBlock() == loop.getBody();
}

static bool canRewritePtrAddInLoop(scf::ForOp loop, PtrAddOp ptrAdd) {
  if (!isImmediateBodyOp(loop, ptrAdd))
    return false;
  return !ptrAdd->use_empty();
}

static bool canCarryPtrAddInLoop(scf::ForOp loop, PtrAddOp ptrAdd) {
  return canRewritePtrAddInLoop(loop, ptrAdd) &&
         !isDefinedInside(loop, ptrAdd.getBase());
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
    if (stripAssumes(binding) == loop.getInductionVar())
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

static unsigned bitWidth(Type type) {
  if (VectorType vector = dyn_cast<VectorType>(type)) {
    Type elementType = vector.getElementType();
    if (elementType.isIntOrFloat())
      return elementType.getIntOrFloatBitWidth() * vector.getNumElements();
  }
  if (type.isIntOrFloat())
    return type.getIntOrFloatBitWidth();
  return 32;
}

static Type getPointerLikeElementType(Type type) {
  if (SimdType simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  PtrType ptr = dyn_cast<PtrType>(type);
  return ptr ? ptr.getElementType() : Type();
}

static unsigned elementSizeBytes(Type pointerLikeType) {
  Type elementType = getPointerLikeElementType(pointerLikeType);
  if (!elementType)
    return 1;
  return (bitWidth(elementType) + 7) / 8;
}

static bool isOffsetStridedPointer(Type type) {
  if (SimdType simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  PtrType ptr = dyn_cast<PtrType>(type);
  return ptr && isa<SharedAddressSpaceAttr, waveamd::BufferAddressSpaceAttr>(
                    ptr.getAddressSpace());
}

static bool isNormalizedUnitLoop(scf::ForOp loop) {
  std::optional<int64_t> lower = getConstantIntValue(loop.getLowerBound());
  std::optional<int64_t> step = getConstantIntValue(loop.getStep());
  return lower && *lower == 0 && step && *step == 1;
}

static void
appendBoundExprAssumptions(sym::Store &store, DataFlowSolver &solver,
                           const BoundExpr &expr,
                           SmallVectorImpl<sym::PredHandle> &assumptions) {
  llvm::append_range(assumptions, expr.assumptions);
  for (auto [name, binding] : llvm::zip(expr.names, expr.bindings)) {
    std::optional<ConstantIntRanges> range = finiteSignedRange(solver, binding);
    if (range)
      appendRangeAndAssumePredicates(store, binding, name, *range, assumptions);
    else
      appendAssumePredicates(store, binding, name, assumptions);
  }
}

static FailureOr<sym::ExprHandle> scaleByteExpr(sym::Analysis &analysis,
                                                sym::ExprHandle expr,
                                                int64_t byteScale) {
  if (byteScale == 1)
    return simplifyExpanded(analysis, expr);
  FailureOr<sym::ExprHandle> scale = analysis.composeInteger(byteScale);
  if (failed(scale))
    return failure();
  FailureOr<sym::ExprHandle> scaled =
      analysis.compose(expr, sym::ExprBinaryOp::Mul, *scale);
  if (failed(scaled))
    return failure();
  return simplifyExpanded(analysis, *scaled);
}

static bool fitsU32(sym::Analysis &analysis, sym::ExprHandle expr) {
  return sym::provablyInRange(analysis, expr, 0, u32Max);
}

static FailureOr<sym::ExprHandle>
buildTripCountUpperExpr(sym::Store &store, DataFlowSolver &solver,
                        scf::ForOp loop, llvm::StringSet<> &used,
                        SmallVectorImpl<sym::PredHandle> &assumptions) {
  if (std::optional<llvm::APInt> trip = loop.getStaticTripCount()) {
    if (trip->getActiveBits() > 63)
      return failure();
    return sym::composeExprInt(store,
                               static_cast<int64_t>(trip->getZExtValue()));
  }

  if (!isNormalizedUnitLoop(loop))
    return failure();

  std::string name = uniqueName(used, "ptr_trip");
  if (std::optional<int64_t> upper =
          getConstantIntValue(loop.getUpperBound())) {
    FailureOr<sym::PredHandle> range =
        sym::rangeAssumption(store, name, *upper, *upper);
    if (failed(range))
      return failure();
    assumptions.push_back(*range);
    return symbolExpr(store, name);
  }

  size_t oldSize = assumptions.size();
  std::optional<ConstantIntRanges> range =
      finiteSignedRange(solver, loop.getUpperBound());
  if (range)
    appendRangeAndAssumePredicates(store, loop.getUpperBound(), name, *range,
                                   assumptions);
  else
    appendAssumePredicates(store, loop.getUpperBound(), name, assumptions);
  if (assumptions.size() == oldSize)
    return failure();
  return symbolExpr(store, name);
}

static FailureOr<sym::ExprHandle>
buildAccumulatedByteExpr(sym::Store &store, DataFlowSolver &solver,
                         scf::ForOp loop, const BoundExpr &base,
                         const BoundExpr &stride, sym::ExprHandle baseBytes,
                         sym::ExprHandle strideBytes,
                         SmallVectorImpl<sym::PredHandle> &assumptions) {
  llvm::StringSet<> used;
  collectUsedNames(base, used);
  collectUsedNames(stride, used);
  FailureOr<sym::ExprHandle> trip =
      buildTripCountUpperExpr(store, solver, loop, used, assumptions);
  if (failed(trip))
    return failure();

  FailureOr<sym::ExprHandle> advance =
      sym::composeExprBinary(store, *trip, sym::ExprBinaryOp::Mul, strideBytes);
  if (failed(advance))
    return failure();
  FailureOr<sym::ExprHandle> total = sym::composeExprBinary(
      store, baseBytes, sym::ExprBinaryOp::Add, *advance);
  if (failed(total))
    return failure();
  return total;
}

static bool canUseOffsetStridedCarry(scf::ForOp loop,
                                     sym::ExprHandle strideBytes) {
  std::optional<int64_t> stride = sym::getIntegerLiteralValue(strideBytes);
  return stride && *stride > 0 && *stride <= u32Max &&
         isNormalizedUnitLoop(loop);
}

static FailureOr<sym::ExprHandle>
assumeAndScaleByteExpr(sym::Analysis &analysis,
                       ArrayRef<sym::PredHandle> assumptions, size_t begin,
                       sym::ExprHandle expr, int64_t byteScale) {
  if (failed(analysis.assume(assumptions.drop_front(begin))))
    return failure();
  return scaleByteExpr(analysis, expr, byteScale);
}

static bool accumulatedByteExprFitsU32(
    sym::Analysis &analysis, sym::Store &store, DataFlowSolver &solver,
    scf::ForOp loop, const BoundExpr &base, const BoundExpr &stride,
    sym::ExprHandle baseBytes, sym::ExprHandle strideBytes,
    SmallVectorImpl<sym::PredHandle> &assumptions) {
  size_t tripAssumptionBegin = assumptions.size();
  FailureOr<sym::ExprHandle> rawTotal = buildAccumulatedByteExpr(
      store, solver, loop, base, stride, baseBytes, strideBytes, assumptions);
  if (failed(rawTotal) ||
      failed(analysis.assume(
          ArrayRef(assumptions).drop_front(tripAssumptionBegin))))
    return false;
  FailureOr<sym::ExprHandle> total = simplifyExpanded(analysis, *rawTotal);
  return succeeded(total) && fitsU32(analysis, *total);
}

static bool
proveAccumulatingCarryFitsU32(sym::Store &store, DataFlowSolver &solver,
                              scf::ForOp loop, const BoundExpr &base,
                              const BoundExpr &stride, int64_t byteScale) {
  SmallVector<sym::PredHandle> baseAssumptions;
  appendBoundExprAssumptions(store, solver, base, baseAssumptions);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, baseAssumptions);
  if (failed(analysis))
    return false;
  FailureOr<sym::ExprHandle> baseBytes =
      scaleByteExpr(**analysis, base.expr, byteScale);
  if (failed(baseBytes) || !fitsU32(**analysis, *baseBytes))
    return false;

  SmallVector<sym::PredHandle> assumptions(baseAssumptions.begin(),
                                           baseAssumptions.end());
  size_t strideAssumptionBegin = assumptions.size();
  appendBoundExprAssumptions(store, solver, stride, assumptions);
  FailureOr<sym::ExprHandle> strideBytes = assumeAndScaleByteExpr(
      **analysis, assumptions, strideAssumptionBegin, stride.expr, byteScale);
  if (failed(strideBytes))
    return false;

  if (canUseOffsetStridedCarry(loop, *strideBytes))
    return true;

  std::optional<int64_t> strideLiteral =
      sym::getIntegerLiteralValue(*strideBytes);
  if (!strideLiteral || *strideLiteral < 0)
    return false;
  if (*strideLiteral == 0)
    return true;

  return accumulatedByteExprFitsU32(**analysis, store, solver, loop, base,
                                    stride, *baseBytes, *strideBytes,
                                    assumptions);
}

static bool canExtractPointerCarry(scf::ForOp loop, PtrAddOp ptrAdd,
                                   const BoundExpr &base,
                                   const BoundExpr &stride, sym::Store &store,
                                   DataFlowSolver &solver) {
  if (!isOffsetStridedPointer(ptrAdd.getType()))
    return true;
  return proveAccumulatingCarryFitsU32(
      store, solver, loop, base, stride,
      static_cast<int64_t>(elementSizeBytes(ptrAdd.getType())));
}

static LogicalResult buildCandidate(scf::ForOp loop, PtrAddOp ptrAdd,
                                    sym::Store &store, DataFlowSolver &solver,
                                    LoopStrideCandidate &candidate,
                                    bool &matched) {
  matched = false;
  if (!canCarryPtrAddInLoop(loop, ptrAdd))
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
  if (!canExtractPointerCarry(loop, ptrAdd, *base, *stride, store, solver))
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
  Type type = indexExpr.getResult().getType();
  if (SimdType simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  return type.isIndex();
}

static FailureOr<sym::ExprHandle>
wrapExprRing(sym::Store &store, int64_t modulus, sym::ExprHandle expr) {
  sym::ExprHandle ring = sym::composeExprInt(store, modulus);
  return sym::composeExprBinary(store, expr, sym::ExprBinaryOp::Mod, ring);
}

static std::optional<int64_t>
getExplicitPowerOfTwoModulus(sym::ExprHandle expr) {
  sym::ExprView view(expr);
  if (view.getKind() != sym::ExprKind::Mod)
    return std::nullopt;
  std::optional<int64_t> modulus =
      sym::getIntegerLiteralValue(view.getBinaryRhs());
  if (!modulus || *modulus <= 1 || *modulus > (int64_t{1} << 32) ||
      !isPowerOfTwo(*modulus))
    return std::nullopt;
  return modulus;
}

static bool hasGlobalPointerBase(PtrAddOp op) {
  std::optional<PtrType> ptr = getWavePointerType(op.getBase().getType());
  return ptr && isa<GlobalAddressSpaceAttr>(ptr->getAddressSpace());
}

static FailureOr<std::optional<ExpandedIndexExpr>>
buildExactIntegerCastOffset(PtrAddOp ptrAdd, WaveDialect &dialect) {
  CastOp cast = ptrAdd.getOffset().getDefiningOp<CastOp>();
  if (!cast || !mlir::wave::detail::isStructurallySymbolicIntegerCast(
                   cast, /*allowI64Integers=*/hasGlobalPointerBase(ptrAdd)))
    return std::optional<ExpandedIndexExpr>{};

  mlir::wave::detail::SymbolicValueBuilder builder(
      dialect, /*allowI64Integers=*/hasGlobalPointerBase(ptrAdd),
      /*assumeI32StorageRange=*/true,
      /*expandIndexExprRoot=*/false,
      /*foldWaveConstants=*/false,
      /*modelWrappingArithmetic=*/true,
      /*fullyMergeAssumes=*/false,
      mlir::wave::detail::AssumeRootPolicy::ExpandSource,
      hasAddressArithmeticNoOverflowAssumption(ptrAdd.getOperation()));
  builder.enableExactIntegerCasts();
  FailureOr<std::optional<SymbolicOffset>> offset =
      builder.build(ptrAdd.getOffset());
  if (failed(offset))
    return failure();
  if (!*offset)
    return std::optional<ExpandedIndexExpr>{};

  ExpandedIndexExpr expanded;
  expanded.expr = (**offset).expr;
  expanded.materializationExpr = (**offset).expr;
  expanded.assumptions = std::move((**offset).assumptions);
  for (const SymbolicOffsetBinding &binding : (**offset).bindings) {
    expanded.names.push_back(mlir::wave::detail::symbolName(binding).str());
    expanded.bindings.push_back(binding.value);
  }
  return std::optional<ExpandedIndexExpr>{std::move(expanded)};
}

static bool hasSimdBindings(ArrayRef<Value> bindings) {
  return llvm::any_of(
      bindings, [](Value value) { return isa<SimdType>(value.getType()); });
}

static FailureOr<std::optional<LoopMemoryOffsetCandidate>>
buildMemoryOffsetCandidate(scf::ForOp loop, PtrAddOp ptrAdd,
                           WaveDialect &dialect, sym::Store &store) {
  FailureOr<std::optional<ExpandedIndexExpr>> expanded =
      buildExactIntegerCastOffset(ptrAdd, dialect);
  if (failed(expanded))
    return failure();
  if (!*expanded)
    return std::optional<LoopMemoryOffsetCandidate>{};

  std::optional<int64_t> modulus =
      getExplicitPowerOfTwoModulus((**expanded).expr);
  std::optional<std::string> ivName =
      findIVBinding(**expanded, loop.getInductionVar());
  if (!modulus || !ivName || hasLoopLocalNonIVBinding(loop, **expanded))
    return std::optional<LoopMemoryOffsetCandidate>{};

  FailureOr<BoundExpr> base = buildBaseExpr(**expanded, *ivName, loop, store);
  FailureOr<BoundExpr> increment =
      buildModularStrideExpr(**expanded, *ivName, loop, store, *modulus);
  if (failed(base) || failed(increment))
    return std::optional<LoopMemoryOffsetCandidate>{};
  if (hasSimdBindings(increment->bindings))
    return std::optional<LoopMemoryOffsetCandidate>{};

  FailureOr<sym::ExprHandle> wrappedBase =
      wrapExprRing(store, *modulus, base->expr);
  if (failed(wrappedBase))
    return failure();
  base->expr = *wrappedBase;

  LoopMemoryOffsetCandidate candidate;
  candidate.ptrAdd = ptrAdd;
  candidate.base = std::move(*base);
  candidate.increment = std::move(*increment);
  candidate.ring = *modulus;
  return std::optional<LoopMemoryOffsetCandidate>{std::move(candidate)};
}

static FailureOr<std::optional<LoopMemoryOffsetCandidate>>
findMemoryOffsetCandidate(scf::ForOp loop, WaveDialect &dialect,
                          sym::Store &store) {
  for (Operation &op : loop.getBody()->without_terminator()) {
    PtrAddOp ptrAdd = dyn_cast<PtrAddOp>(&op);
    if (!ptrAdd || !canRewritePtrAddInLoop(loop, ptrAdd))
      continue;
    FailureOr<std::optional<LoopMemoryOffsetCandidate>> candidate =
        buildMemoryOffsetCandidate(loop, ptrAdd, dialect, store);
    if (failed(candidate) || *candidate)
      return candidate;
  }
  return std::optional<LoopMemoryOffsetCandidate>{};
}

static FailureOr<bool>
needsExactMemoryOffsetCanonicalization(scf::ForOp loop, WaveDialect &dialect) {
  for (Operation &op : loop.getBody()->without_terminator()) {
    PtrAddOp ptrAdd = dyn_cast<PtrAddOp>(&op);
    if (!ptrAdd || !canRewritePtrAddInLoop(loop, ptrAdd) ||
        !isDefinedInside(loop, ptrAdd.getBase()))
      continue;

    FailureOr<std::optional<ExpandedIndexExpr>> expanded =
        buildExactIntegerCastOffset(ptrAdd, dialect);
    if (failed(expanded))
      return failure();
    if (!*expanded || !getExplicitPowerOfTwoModulus((**expanded).expr) ||
        !findIVBinding(**expanded, loop.getInductionVar()))
      continue;
    if (hasLoopLocalNonIVBinding(loop, **expanded))
      return true;
  }
  return false;
}

static bool canCreateModularChoice(
    scf::ForOp loop, IndexExprOp indexExpr,
    const llvm::SmallPtrSetImpl<Operation *> &materializationAlternatives) {
  // Nested pointer carries need the original offset range proof.
  return !materializationAlternatives.contains(indexExpr) &&
         llvm::none_of(loop.getBody()->without_terminator(),
                       [](Operation &op) { return isa<scf::ForOp>(op); });
}

static LogicalResult wrapOffsetRing(sym::Store &store, int64_t modulus,
                                    sym::ExprHandle &base,
                                    sym::ExprHandle &proof) {
  FailureOr<sym::ExprHandle> wrappedBase = wrapExprRing(store, modulus, base);
  FailureOr<sym::ExprHandle> wrappedProof = wrapExprRing(store, modulus, proof);
  if (failed(wrappedBase) || failed(wrappedProof))
    return failure();
  base = *wrappedBase;
  proof = *wrappedProof;
  return success();
}

static FailureOr<bool> buildExplicitModularOffsetCarryCandidate(
    scf::ForOp loop, IndexExprOp indexExpr, sym::Store &store,
    DataFlowSolver &solver, LoopCyclicOffsetCandidate &candidate,
    const llvm::SmallPtrSetImpl<Operation *> &materializationAlternatives) {
  if (!canCreateModularChoice(loop, indexExpr, materializationAlternatives))
    return false;
  std::optional<int64_t> modulus =
      getExplicitPowerOfTwoModulus(indexExpr.getExpr().getValue());
  if (!modulus)
    return false;
  FailureOr<ExpandedIndexExpr> expanded =
      expandIndexExpr(indexExpr, loop, store, solver,
                      /*modelWrapping=*/true);
  if (failed(expanded))
    return failure();
  std::optional<std::string> ivName =
      findIVBinding(*expanded, loop.getInductionVar());
  if (!ivName || hasLoopLocalNonIVBinding(loop, *expanded))
    return false;

  FailureOr<BoundExpr> base = buildBaseExpr(*expanded, *ivName, loop, store);
  FailureOr<BoundExpr> increment =
      buildModularStrideExpr(*expanded, *ivName, loop, store, *modulus);
  if (failed(base) || failed(increment))
    return false;
  if (hasSimdBindings(increment->bindings))
    return false;

  candidate.members.push_back(
      {indexExpr, 0, /*retainRematerializedAlternative=*/true});
  llvm::append_range(candidate.producers, expanded->producers);
  candidate.base = std::move(*base);
  candidate.proof.expr = expanded->expr;
  candidate.proof.assumptions = expanded->assumptions;
  candidate.proof.names = expanded->names;
  candidate.proof.bindings = expanded->bindings;
  candidate.increment = std::move(*increment);
  candidate.ring = *modulus;
  candidate.canAnchor = true;
  // Keep base and proof in the explicit ring across subsequent loop rewrites.
  if (failed(wrapOffsetRing(store, *modulus, candidate.base.expr,
                            candidate.proof.expr)))
    return failure();
  return true;
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

static LogicalResult buildCyclicOffsetCandidate(
    scf::ForOp loop, IndexExprOp indexExpr, sym::Store &store,
    DataFlowSolver &solver, LoopCyclicOffsetCandidate &candidate, bool &matched,
    const llvm::SmallPtrSetImpl<Operation *> &materializationAlternatives) {
  matched = false;
  if (!canRewriteCyclicOffsetInLoop(loop, indexExpr))
    return success();

  FailureOr<std::optional<CyclicOffsetLoopMatch>> match =
      matchCyclicOffsetInLoop(loop, indexExpr, store, solver);
  if (failed(match))
    return failure();
  if (!*match) {
    FailureOr<bool> modularCarry = buildExplicitModularOffsetCarryCandidate(
        loop, indexExpr, store, solver, candidate, materializationAlternatives);
    if (failed(modularCarry))
      return failure();
    matched = *modularCarry;
    return success();
  }

  CyclicOffsetLoopMatch &cyclic = **match;
  std::optional<CyclicOffsetCarryShape> shape =
      computeCyclicOffsetCarryShape(loop, cyclic.pattern);
  if (!shape)
    return success();

  FailureOr<BoundExpr> base =
      buildBaseExpr(cyclic.expanded, cyclic.ivName, loop, store);
  if (failed(base))
    return success();

  candidate.members.push_back({indexExpr, 0});
  llvm::append_range(candidate.producers, cyclic.expanded.producers);
  candidate.base = std::move(*base);
  candidate.proof.expr = cyclic.expanded.expr;
  candidate.proof.assumptions = cyclic.expanded.assumptions;
  candidate.proof.names = cyclic.expanded.names;
  candidate.proof.bindings = cyclic.expanded.bindings;
  FailureOr<sym::ExprHandle> increment =
      sym::composeExprInt(store, shape->increment);
  if (failed(increment))
    return failure();
  candidate.increment.expr = *increment;
  candidate.ring = shape->ring;
  candidate.canAnchor = cyclic.pattern.canAnchor;
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

static bool haveSameBoundBindings(const BoundExpr &lhs, const BoundExpr &rhs) {
  if (lhs.names.size() != rhs.names.size())
    return false;
  for (auto [lhsName, lhsValue] : llvm::zip(lhs.names, lhs.bindings)) {
    bool found = false;
    for (auto [rhsName, rhsValue] : llvm::zip(rhs.names, rhs.bindings))
      if (lhsName == rhsName && lhsValue == rhsValue) {
        found = true;
        break;
      }
    if (!found)
      return false;
  }
  return true;
}

static FailureOr<std::optional<int64_t>>
constantExprDelta(sym::Store &store, const BoundExpr &lhs,
                  const BoundExpr &rhs) {
  if (!haveSameBoundBindings(lhs, rhs))
    return std::optional<int64_t>{};

  SmallVector<sym::PredHandle> assumptions(lhs.assumptions);
  llvm::append_range(assumptions, rhs.assumptions);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, assumptions);
  if (failed(analysis))
    return failure();
  if (std::optional<int64_t> delta =
          (*analysis)->constantDifference(lhs.expr, rhs.expr))
    return delta;
  return std::optional<int64_t>{};
}

static bool adjustCyclicOffsetMembers(LoopCyclicOffsetCandidate &group,
                                      LoopCyclicOffsetCandidate &candidate,
                                      CyclicOffsetMember &member,
                                      int64_t delta) {
  if (delta >= 0) {
    if (delta >= group.ring)
      return false;
    member.delta = delta;
    return true;
  }

  __int128 shift = -__int128(delta);
  for (const CyclicOffsetMember &existing : group.members)
    if (__int128(existing.delta) + shift >= group.ring)
      return false;
  for (CyclicOffsetMember &existing : group.members)
    existing.delta = static_cast<int64_t>(__int128(existing.delta) + shift);
  group.base = std::move(candidate.base);
  group.proof = std::move(candidate.proof);
  return true;
}

static void
appendUniqueCyclicProducers(LoopCyclicOffsetCandidate &group,
                            const LoopCyclicOffsetCandidate &candidate) {
  for (Operation *producer : candidate.producers)
    if (!llvm::is_contained(group.producers, producer))
      group.producers.push_back(producer);
}

static FailureOr<bool>
mergeCyclicOffsetCandidate(LoopCyclicOffsetCandidate &group,
                           LoopCyclicOffsetCandidate candidate,
                           sym::Store &store) {
  if (group.ring != candidate.ring)
    return false;
  FailureOr<std::optional<int64_t>> incrementDelta =
      constantExprDelta(store, candidate.increment, group.increment);
  if (failed(incrementDelta))
    return failure();
  if (!*incrementDelta || **incrementDelta != 0)
    return false;
  FailureOr<std::optional<int64_t>> delta =
      constantExprDelta(store, candidate.proof, group.proof);
  if (failed(delta))
    return failure();
  if (!*delta)
    return false;
  if (**delta < 0 && !candidate.canAnchor)
    return false;

  CyclicOffsetMember member = candidate.members.front();
  if (!adjustCyclicOffsetMembers(group, candidate, member, **delta))
    return false;
  group.members.push_back(member);
  appendUniqueCyclicProducers(group, candidate);
  return true;
}

static void collectDeadCyclicProducers(scf::ForOp loop,
                                       LoopCyclicOffsetCandidate &candidate) {
  llvm::SmallPtrSet<Operation *, 32> skip;
  for (const CyclicOffsetMember &member : candidate.members)
    skip.insert(member.indexExpr);

  bool changed = true;
  while (changed) {
    changed = false;
    for (Operation *producer : candidate.producers) {
      if (skip.contains(producer) || !isImmediateBodyOp(loop, producer))
        continue;
      if (!areAllUsersSkipped(producer, skip))
        continue;
      skip.insert(producer);
      candidate.deadProducers.push_back(producer);
      changed = true;
    }
  }
}

static LogicalResult
addCyclicOffsetCandidate(std::optional<LoopCyclicOffsetCandidate> &group,
                         SmallVectorImpl<LoopCyclicOffsetCandidate> &deferred,
                         LoopCyclicOffsetCandidate candidate,
                         sym::Store &store) {
  if (group) {
    FailureOr<bool> merged =
        mergeCyclicOffsetCandidate(*group, std::move(candidate), store);
    if (failed(merged))
      return failure();
    return success();
  }
  if (!candidate.canAnchor) {
    deferred.push_back(std::move(candidate));
    return success();
  }

  group = std::move(candidate);
  for (LoopCyclicOffsetCandidate &peer : deferred) {
    FailureOr<bool> merged =
        mergeCyclicOffsetCandidate(*group, std::move(peer), store);
    if (failed(merged))
      return failure();
  }
  deferred.clear();
  return success();
}

static FailureOr<std::optional<LoopCyclicOffsetCandidate>>
findCyclicOffsetCandidate(
    scf::ForOp loop, sym::Store &store, DataFlowSolver &solver,
    const llvm::SmallPtrSetImpl<Operation *> &materializationAlternatives) {
  std::optional<LoopCyclicOffsetCandidate> group;
  SmallVector<LoopCyclicOffsetCandidate, 0> deferred;
  for (Operation &op : loop.getBody()->without_terminator()) {
    IndexExprOp indexExpr = dyn_cast<IndexExprOp>(&op);
    if (!indexExpr)
      continue;
    LoopCyclicOffsetCandidate candidate;
    bool matched = false;
    if (failed(buildCyclicOffsetCandidate(loop, indexExpr, store, solver,
                                          candidate, matched,
                                          materializationAlternatives)))
      return failure();
    if (!matched)
      continue;
    if (failed(addCyclicOffsetCandidate(group, deferred, std::move(candidate),
                                        store)))
      return failure();
  }
  if (!group)
    return group;
  collectDeadCyclicProducers(loop, *group);
  return group;
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

static Value createOffsetExpr(IRRewriter &rewriter, Location loc,
                              const BoundExpr &expr, Type offsetType) {
  Value value = createIndexExpr(rewriter, loc, rewriter.getContext(), expr);
  Type elementShape = isa<SimdType>(value.getType())
                          ? offsetType
                          : getOffsetElementType(offsetType);
  if (value.getType() != elementShape)
    value = CastOp::create(rewriter, loc, elementShape, CastKind::IntConvert,
                           value, DictionaryAttr{});
  // IV substitution can remove every lane binding from a SIMD expression.
  if (value.getType() != offsetType)
    value = SplatOp::create(rewriter, loc, offsetType, value);
  return value;
}

static LogicalResult remapMaterializationAlternatives(
    scf::ForOp source, const IRMapping &map,
    MaterializationAlternatives &materializationAlternatives) {
  SmallVector<std::pair<Operation *, Operation *>, 4> replacements;
  WalkResult result = source->walk([&](Operation *op) {
    if (!materializationAlternatives.contains(op))
      return WalkResult::advance();
    Operation *replacement = map.lookupOrNull(op);
    if (!replacement) {
      op->emitOpError(
          "materialization alternative was not preserved by loop rewrite");
      return WalkResult::interrupt();
    }
    replacements.emplace_back(op, replacement);
    return WalkResult::advance();
  });
  if (result.wasInterrupted())
    return failure();
  for (auto [sourceOp, replacement] : replacements) {
    materializationAlternatives.erase(sourceOp);
    materializationAlternatives.insert(replacement);
  }
  return success();
}

static LogicalResult
cloneBodyWithCarriedPointer(IRRewriter &rewriter, scf::ForOp src,
                            scf::ForOp dst, LoopStrideCandidate candidate,
                            Value strideValue,
                            MaterializationAlternatives &alternatives) {
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
  return remapMaterializationAlternatives(src, map, alternatives);
}

static FailureOr<Value>
createCarriedCyclicOffsetMember(IRRewriter &rewriter, scf::ForOp src,
                                CyclicOffsetMember &member, sym::Store &store,
                                Value offsetCarry) {
  if (member.delta == 0)
    return offsetCarry;

  {
    FailureOr<sym::ExprHandle> offset = sym::composeExprSym(store, "offset");
    FailureOr<sym::ExprHandle> delta = sym::composeExprInt(store, member.delta);
    if (failed(offset) || failed(delta))
      return failure();
    FailureOr<sym::ExprHandle> shifted =
        sym::composeExprBinary(store, *offset, sym::ExprBinaryOp::Add, *delta);
    if (failed(shifted))
      return failure();
    FailureOr<sym::ExprHandle> simplified =
        simplifyExpandedForMaterialization(store, *shifted, {});
    if (failed(simplified))
      return failure();

    BoundExpr derived;
    derived.expr = *simplified;
    derived.names.push_back("offset");
    derived.bindings.push_back(offsetCarry);
    IndexExprOp derivedOffset = createIndexExpr(
        rewriter, member.indexExpr.getLoc(), src->getContext(), derived);
    return derivedOffset.getResult();
  }
}

static FailureOr<IndexExprOp>
mapCyclicOffsetMembers(IRRewriter &rewriter, scf::ForOp src,
                       LoopCyclicOffsetCandidate &candidate, sym::Store &store,
                       Value offsetCarry, IRMapping &map) {
  IndexExprOp anchor;
  for (CyclicOffsetMember &member : candidate.members) {
    if (member.delta == 0)
      anchor = member.indexExpr;
    FailureOr<Value> carried = createCarriedCyclicOffsetMember(
        rewriter, src, member, store, offsetCarry);
    if (failed(carried))
      return failure();
    map.map(member.indexExpr.getResult(), *carried);
  }
  assert(anchor && "cyclic offset group must have an anchor");
  return anchor;
}

static LogicalResult cloneCyclicOffsetBodyWithVariants(
    IRRewriter &rewriter, scf::ForOp src, LoopCyclicOffsetCandidate &candidate,
    sym::Store &store, Value offsetCarry, IRMapping &map,
    MaterializationAlternatives &alternatives) {
  Block &srcBody = *src.getBody();
  for (Operation &op : srcBody.without_terminator()) {
    auto member = llvm::find_if(
        candidate.members, [&](CyclicOffsetMember &candidateMember) {
          return candidateMember.indexExpr.getOperation() == &op;
        });
    if (member == candidate.members.end()) {
      rewriter.clone(op, map);
      continue;
    }

    FailureOr<Value> carried = createCarriedCyclicOffsetMember(
        rewriter, src, *member, store, offsetCarry);
    if (failed(carried))
      return failure();
    if (!member->retainRematerializedAlternative) {
      map.map(member->indexExpr.getResult(), *carried);
      continue;
    }

    auto rematerialized = cast<IndexExprOp>(rewriter.clone(op, map));
    rematerialized->setAttr(kRematerializationAlternativeAttr,
                            rewriter.getUnitAttr());
    alternatives.insert(rematerialized);
    SmallVector<Value, 2> choices{rematerialized.getResult(), *carried};
    auto variants =
        MaterializationVariantsOp::create(rewriter, member->indexExpr.getLoc(),
                                          rematerialized.getType(), choices);
    map.map(member->indexExpr.getResult(), variants.getResult());
  }
  return success();
}

static void cloneCyclicOffsetBody(IRRewriter &rewriter, Block &srcBody,
                                  LoopCyclicOffsetCandidate &candidate,
                                  IRMapping &map) {
  llvm::SmallPtrSet<Operation *, 32> skipped;
  for (const CyclicOffsetMember &member : candidate.members)
    skipped.insert(member.indexExpr);
  for (Operation *producer : candidate.deadProducers)
    skipped.insert(producer);
  for (Operation &op : srcBody.without_terminator()) {
    if (skipped.contains(&op))
      continue;
    rewriter.clone(op, map);
  }
}

static LogicalResult cloneBodyWithCarriedCyclicOffset(
    IRRewriter &rewriter, scf::ForOp src, scf::ForOp dst,
    LoopCyclicOffsetCandidate candidate, sym::Store &store,
    MaterializationAlternatives &alternatives) {
  Block &srcBody = *src.getBody();
  Block &dstBody = *dst.getBody();
  Value offsetCarry = dstBody.getArgument(srcBody.getNumArguments());

  IRMapping map;
  map.map(srcBody.getArgument(0), dstBody.getArgument(0));
  for (auto [oldArg, newArg] :
       llvm::zip(src.getRegionIterArgs(), dst.getRegionIterArgs().drop_back()))
    map.map(oldArg, newArg);

  rewriter.setInsertionPointToStart(&dstBody);
  bool hasVariants =
      llvm::any_of(candidate.members, [](const CyclicOffsetMember &member) {
        return member.retainRematerializedAlternative;
      });
  if (hasVariants) {
    if (failed(cloneCyclicOffsetBodyWithVariants(
            rewriter, src, candidate, store, offsetCarry, map, alternatives)))
      return failure();
  } else {
    FailureOr<IndexExprOp> anchor = mapCyclicOffsetMembers(
        rewriter, src, candidate, store, offsetCarry, map);
    if (failed(anchor))
      return failure();
    cloneCyclicOffsetBody(rewriter, srcBody, candidate, map);
  }

  SmallVector<Value> yielded;
  scf::YieldOp srcYield = cast<scf::YieldOp>(srcBody.getTerminator());
  for (Value value : srcYield.getOperands())
    yielded.push_back(map.lookupOrDefault(value));

  CyclicOffsetMember *anchor =
      llvm::find_if(candidate.members, [](const CyclicOffsetMember &member) {
        return member.delta == 0;
      });
  assert(anchor != candidate.members.end() &&
         "cyclic offset group must have an anchor");
  FailureOr<Value> nextOffset = createCyclicOffsetUpdate(
      rewriter, anchor->indexExpr.getLoc(), store, offsetCarry,
      candidate.increment, candidate.ring);
  if (failed(nextOffset))
    return failure();
  yielded.push_back(*nextOffset);
  scf::YieldOp::create(rewriter, srcYield.getLoc(), yielded);
  return remapMaterializationAlternatives(src, map, alternatives);
}

static LogicalResult cloneBodyWithMemoryOffsetVariants(
    IRRewriter &rewriter, scf::ForOp src, scf::ForOp dst,
    LoopMemoryOffsetCandidate candidate, sym::Store &store,
    MaterializationAlternatives &alternatives) {
  Block &srcBody = *src.getBody();
  Block &dstBody = *dst.getBody();
  Value offsetCarry = dstBody.getArgument(srcBody.getNumArguments());

  IRMapping map;
  map.map(src.getInductionVar(), dst.getInductionVar());
  for (auto [oldArg, newArg] :
       llvm::zip(src.getRegionIterArgs(), dst.getRegionIterArgs().drop_back()))
    map.map(oldArg, newArg);

  rewriter.setInsertionPointToStart(&dstBody);
  for (Operation &op : srcBody.without_terminator()) {
    if (&op != candidate.ptrAdd.getOperation()) {
      rewriter.clone(op, map);
      continue;
    }

    Value originalOffset = map.lookupOrDefault(candidate.ptrAdd.getOffset());
    assert(originalOffset.getType() == offsetCarry.getType() &&
           "offset carry must preserve the original type");
    SmallVector<Value, 2> choices{originalOffset, offsetCarry};
    auto variants = MaterializationVariantsOp::create(
        rewriter, candidate.ptrAdd.getLoc(), originalOffset.getType(), choices);
    IRMapping ptrMap = map;
    ptrMap.map(candidate.ptrAdd.getOffset(), variants.getResult());
    Operation *cloned = rewriter.clone(op, ptrMap);
    for (auto [source, replacement] :
         llvm::zip_equal(op.getResults(), cloned->getResults()))
      map.map(source, replacement);
  }

  SmallVector<Value> yielded;
  scf::YieldOp srcYield = cast<scf::YieldOp>(srcBody.getTerminator());
  for (Value value : srcYield.getOperands())
    yielded.push_back(map.lookupOrDefault(value));
  FailureOr<Value> nextOffset = createCyclicOffsetUpdate(
      rewriter, candidate.ptrAdd.getLoc(), store, offsetCarry,
      candidate.increment, candidate.ring);
  if (failed(nextOffset))
    return failure();
  yielded.push_back(*nextOffset);
  scf::YieldOp::create(rewriter, srcYield.getLoc(), yielded);
  return remapMaterializationAlternatives(src, map, alternatives);
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

static void eraseDefaultYield(IRRewriter &rewriter, Block &body) {
  if (body.empty())
    return;
  if (auto defaultYield = dyn_cast<scf::YieldOp>(body.back()))
    rewriter.eraseOp(defaultYield);
}

static LogicalResult cloneBodyWithoutOffsetCarries(
    IRRewriter &rewriter, scf::ForOp src, scf::ForOp dst,
    LoopOffsetCarryCandidate candidate, const llvm::BitVector &removed,
    ArrayRef<unsigned> newIndex, MaterializationAlternatives &alternatives) {
  Block &srcBody = *src.getBody();
  Block &dstBody = *dst.getBody();
  eraseDefaultYield(rewriter, dstBody);

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
  return remapMaterializationAlternatives(src, map, alternatives);
}

static void copyLoopAttrs(scf::ForOp src, scf::ForOp dst) {
  for (NamedAttribute attr : src->getAttrs())
    dst->setAttr(attr.getName(), attr.getValue());
}

static LogicalResult rewriteLoop(IRRewriter &rewriter, scf::ForOp loop,
                                 LoopMemoryOffsetCandidate candidate,
                                 sym::Store &store,
                                 MaterializationAlternatives &alternatives) {
  rewriter.setInsertionPoint(loop);
  Value base =
      createOffsetExpr(rewriter, candidate.ptrAdd.getLoc(), candidate.base,
                       candidate.ptrAdd.getOffset().getType());

  SmallVector<Value> initArgs(loop.getInitArgs().begin(),
                              loop.getInitArgs().end());
  initArgs.push_back(base);
  scf::ForOp newLoop =
      scf::ForOp::create(rewriter, loop.getLoc(), loop.getLowerBound(),
                         loop.getUpperBound(), loop.getStep(), initArgs);
  copyLoopAttrs(loop, newLoop);
  if (failed(cloneBodyWithMemoryOffsetVariants(rewriter, loop, newLoop,
                                               candidate, store, alternatives)))
    return failure();

  rewriter.replaceOp(loop,
                     newLoop.getResults().take_front(loop.getNumResults()));
  return success();
}

static LogicalResult rewriteLoop(IRRewriter &rewriter, scf::ForOp loop,
                                 LoopStrideCandidate candidate,
                                 MaterializationAlternatives &alternatives) {
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
                                         stride.getResult(), alternatives)))
    return failure();

  rewriter.replaceOp(loop,
                     newLoop.getResults().take_front(loop.getNumResults()));
  return success();
}

static LogicalResult rewriteLoop(IRRewriter &rewriter, scf::ForOp loop,
                                 LoopCyclicOffsetCandidate candidate,
                                 sym::Store &store,
                                 MaterializationAlternatives &alternatives) {
  Location loc = loop.getLoc();
  rewriter.setInsertionPoint(loop);
  CyclicOffsetMember *anchor =
      llvm::find_if(candidate.members, [](const CyclicOffsetMember &member) {
        return member.delta == 0;
      });
  assert(anchor != candidate.members.end() &&
         "cyclic offset group must have an anchor");
  IndexExprOp base = createIndexExpr(rewriter, anchor->indexExpr.getLoc(),
                                     loop->getContext(), candidate.base);

  SmallVector<Value> initArgs(loop.getInitArgs().begin(),
                              loop.getInitArgs().end());
  initArgs.push_back(base.getResult());
  scf::ForOp newLoop =
      scf::ForOp::create(rewriter, loc, loop.getLowerBound(),
                         loop.getUpperBound(), loop.getStep(), initArgs);
  copyLoopAttrs(loop, newLoop);
  if (failed(cloneBodyWithCarriedCyclicOffset(rewriter, loop, newLoop,
                                              candidate, store, alternatives)))
    return failure();

  rewriter.replaceOp(loop,
                     newLoop.getResults().take_front(loop.getNumResults()));
  return success();
}

static LogicalResult rewriteLoop(IRRewriter &rewriter, scf::ForOp loop,
                                 LoopOffsetCarryCandidate candidate,
                                 MaterializationAlternatives &alternatives) {
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
                                           removed, newIndex, alternatives)))
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

static FailureOr<bool>
rewriteOneLoop(IRRewriter &rewriter, scf::ForOp loop, sym::Store &store,
               DataFlowSolver &solver,
               MaterializationAlternatives &alternatives) {
  FailureOr<std::optional<LoopStrideCandidate>> candidate =
      findCandidate(loop, store, solver);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return false;
  if (failed(rewriteLoop(rewriter, loop, **candidate, alternatives)))
    return failure();
  return true;
}

static FailureOr<bool>
rewriteOneCyclicOffset(IRRewriter &rewriter, scf::ForOp loop, sym::Store &store,
                       DataFlowSolver &solver,
                       MaterializationAlternatives &alternatives) {
  FailureOr<std::optional<LoopCyclicOffsetCandidate>> candidate =
      findCyclicOffsetCandidate(loop, store, solver, alternatives);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return false;
  if (failed(rewriteLoop(rewriter, loop, **candidate, store, alternatives)))
    return failure();
  return true;
}

static FailureOr<bool>
rewriteOneMemoryOffset(IRRewriter &rewriter, scf::ForOp loop,
                       WaveDialect &dialect, sym::Store &store,
                       MaterializationAlternatives &alternatives) {
  FailureOr<std::optional<LoopMemoryOffsetCandidate>> candidate =
      findMemoryOffsetCandidate(loop, dialect, store);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return false;
  if (failed(rewriteLoop(rewriter, loop, **candidate, store, alternatives)))
    return failure();
  return true;
}

static FailureOr<bool>
rewriteOneOffsetCarry(IRRewriter &rewriter, scf::ForOp loop,
                      MaterializationAlternatives &alternatives) {
  FailureOr<std::optional<LoopOffsetCarryCandidate>> candidate =
      findOffsetCarryCandidate(loop);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return false;
  if (failed(rewriteLoop(rewriter, loop, **candidate, alternatives)))
    return failure();
  return true;
}

static FailureOr<bool>
rewriteOneStrideExtraction(IRRewriter &rewriter, scf::ForOp loop,
                           WaveDialect *dialect, DataFlowSolver &solver,
                           MaterializationAlternatives &alternatives) {
  FailureOr<bool> needsCanonicalization =
      needsExactMemoryOffsetCanonicalization(loop, *dialect);
  if (failed(needsCanonicalization))
    return failure();
  if (*needsCanonicalization)
    moveLoopInvariantCode(cast<LoopLikeOpInterface>(loop.getOperation()));

  FailureOr<bool> rewritten = rewriteOneLoop(
      rewriter, loop, dialect->getSymbolStore(), solver, alternatives);
  if (failed(rewritten) || *rewritten)
    return rewritten;

  rewritten = rewriteOneMemoryOffset(rewriter, loop, *dialect,
                                     dialect->getSymbolStore(), alternatives);
  if (failed(rewritten) || *rewritten)
    return rewritten;

  rewritten = rewriteOneCyclicOffset(rewriter, loop, dialect->getSymbolStore(),
                                     solver, alternatives);
  if (failed(rewritten) || *rewritten)
    return rewritten;

  return rewriteOneOffsetCarry(rewriter, loop, alternatives);
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
    MaterializationAlternatives materializationAlternatives;
    root->walk([&](IndexExprOp op) {
      if (op->hasAttr(kRematerializationAlternativeAttr))
        materializationAlternatives.insert(op);
    });
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
        FailureOr<bool> rewritten = rewriteOneStrideExtraction(
            rewriter, loop, dialect, solver, materializationAlternatives);
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
