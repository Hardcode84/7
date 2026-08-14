//===- WaveMemoryAddress.cpp - Wave memory address utilities ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveMemoryAddress.h"

#include "WaveIndexExpr.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/CheckedArithmetic.h"

#include <array>

using namespace mlir;
using namespace mlir::wave;

namespace {

static void appendUnique(SmallVectorImpl<sym::PredHandle> &predicates,
                         sym::PredHandle predicate) {
  if (!llvm::is_contained(predicates, predicate))
    predicates.push_back(predicate);
}

static FailureOr<sym::PredHandle>
composeEqual(sym::Store &store, sym::ExprHandle lhs, sym::ExprHandle rhs) {
  return sym::composePredCmp(store, lhs, sym::PredCmpOp::Eq, rhs);
}

static FailureOr<std::unique_ptr<sym::Analysis>>
createTransactionAnalysis(sym::Store &store,
                          ArrayRef<sym::ExprHandle> expressions,
                          ArrayRef<sym::PredHandle> facts) {
  SmallVector<sym::PredHandle> relevant =
      selectIndexExprAnalysisFacts(expressions, {}, facts);
  return createClosedIndexExprAnalysis(store, relevant);
}

static FailureOr<sym::ExactDivideResult>
proveExactDivide(sym::Store &store, sym::ExprHandle expression, int64_t divisor,
                 ArrayRef<sym::PredHandle> facts) {
  FailureOr<std::unique_ptr<sym::Analysis>> structural =
      createClosedIndexExprAnalysis(store, {});
  if (failed(structural))
    return failure();
  sym::ExactDivideResult result =
      (*structural)->tryExactDivide(expression, divisor);
  if (result.status == sym::ExactDivideStatus::Proven ||
      result.status == sym::ExactDivideStatus::NotExact)
    return result;
  std::array<sym::ExprHandle, 1> expressions{expression};
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      createTransactionAnalysis(store, expressions, facts);
  if (failed(analysis))
    return failure();
  return (*analysis)->tryExactDivide(expression, divisor);
}

static SmallVector<PtrAddOp> collectPtrAddChain(PtrAddOp op) {
  SmallVector<PtrAddOp> chain;
  for (PtrAddOp current = op; current;
       current = current.getBase().getDefiningOp<PtrAddOp>())
    chain.push_back(current);
  return chain;
}

static FailureOr<sym::ExprHandle> scaleAndAdd(sym::Store &store,
                                              sym::ExprHandle sum,
                                              sym::ExprHandle offset,
                                              int64_t elementBits) {
  sym::ExprHandle scale = sym::composeExprInt(store, elementBits);
  FailureOr<sym::ExprHandle> term =
      sym::composeExprBinary(store, offset, sym::ExprBinaryOp::Mul, scale);
  if (failed(term))
    return failure();
  return sym::composeExprBinary(store, sum, sym::ExprBinaryOp::Add, *term);
}

static FailureOr<sym::ExprHandle>
importOffset(sym::Store &store, const SymbolicOffset &offset,
             indexing::IndexMap &map, llvm::StringMap<Value> &reserved,
             llvm::DenseMap<Value, StringRef> &names) {
  SmallVector<sym::ExprSubstitution> substitutions;
  for (const SymbolicOffsetBinding &binding : offset.bindings) {
    StringRef requested = sym::ExprView(binding.name).getSymbolName();
    if (requested.empty())
      return failure();
    auto existing = llvm::find_if(map.inputs, [&](const auto &input) {
      return input.value == binding.value;
    });
    sym::ExprHandle variable;
    if (existing != map.inputs.end()) {
      if (existing->kind != binding.kind)
        return failure();
      variable = existing->variable;
    } else {
      StringRef name = reserveIndexExprBindingName(
          requested, binding.value, reserved, names, /*renameSeparator=*/"");
      variable =
          name == requested ? binding.name : sym::composeExprSym(store, name);
      map.inputs.push_back(
          {variable, std::nullopt, binding.value, binding.kind});
    }
    substitutions.push_back({binding.name, variable});
  }
  FailureOr<SmallVector<sym::PredHandle>> facts =
      substituteIndexExprPredicates(store, offset.assumptions, substitutions);
  if (failed(facts))
    return failure();
  for (sym::PredHandle fact : *facts)
    appendUnique(map.facts, fact);
  return substitutions.empty()
             ? offset.expr
             : sym::substituteExpr(store, offset.expr, substitutions);
}

struct AlignedInputNames {
  llvm::StringMap<Value> reserved;
  llvm::DenseMap<Value, StringRef> names;
};

static LogicalResult collectAlignedInputNames(const indexing::IndexMap &map,
                                              AlignedInputNames &names) {
  for (const indexing::IndexMap::Input &input : map.inputs) {
    StringRef name = sym::ExprView(input.variable).getSymbolName();
    if (name.empty() || names.reserved.contains(name) ||
        (input.value && names.names.contains(input.value)))
      return failure();
    names.reserved.try_emplace(name, input.value);
    if (input.value)
      names.names.try_emplace(input.value, name);
  }
  return success();
}

static FailureOr<sym::ExprHandle>
alignInput(sym::Store &store, indexing::IndexMap &domain,
           const indexing::IndexMap::Input &input, AlignedInputNames &names) {
  if (!input.value)
    return failure();
  auto existing = llvm::find_if(domain.inputs, [&](const auto &candidate) {
    return candidate.value == input.value;
  });
  if (existing != domain.inputs.end()) {
    if (existing->kind != input.kind)
      return failure();
    existing->materializable |= input.materializable;
    return existing->variable;
  }
  StringRef requested = sym::ExprView(input.variable).getSymbolName();
  StringRef name = reserveIndexExprBindingName(requested, input.value,
                                               names.reserved, names.names,
                                               /*renameSeparator=*/"");
  sym::ExprHandle created =
      name == requested ? input.variable : sym::composeExprSym(store, name);
  domain.inputs.push_back(
      {created, input.extent, input.value, input.kind, input.materializable});
  return created;
}

static FailureOr<
    std::pair<indexing::IndexMap, SmallVector<sym::ExprSubstitution>>>
alignInputs(sym::Store &store, const indexing::IndexMap &lhs,
            const indexing::IndexMap &rhs) {
  indexing::IndexMap domain = lhs;
  AlignedInputNames names;
  if (failed(collectAlignedInputNames(domain, names)))
    return failure();
  SmallVector<sym::ExprSubstitution> substitutions;
  for (const auto &input : rhs.inputs) {
    if (llvm::any_of(rhs.definitions, [&](const auto &definition) {
          return definition.target == input.variable;
        }))
      continue;
    FailureOr<sym::ExprHandle> replacement =
        alignInput(store, domain, input, names);
    if (failed(replacement))
      return failure();
    substitutions.push_back({input.variable, *replacement});
  }
  return std::make_pair(std::move(domain), std::move(substitutions));
}

static DenseI32ArrayAttr getConsistentWorkgroupShape(func::FuncOp func) {
  DenseI32ArrayAttr shape;
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr candidate = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (!candidate)
      continue;
    if (shape && shape != candidate)
      return {};
    shape = candidate;
  }
  return shape;
}

static FailureOr<sym::PredHandle>
materializePredicate(sym::Store &store, const indexing::IndexMap &map,
                     sym::PredHandle predicate) {
  FailureOr<sym::ExprHandle> value =
      indexing::materialize(store, map, sym::asExpr(predicate));
  std::optional<sym::PredHandle> material =
      failed(value) ? std::nullopt : sym::asPred(*value);
  return material ? FailureOr<sym::PredHandle>(*material)
                  : FailureOr<sym::PredHandle>(failure());
}

static LogicalResult appendMaterializedRequirements(
    sym::Store &store, const indexing::IndexMap &source,
    ArrayRef<sym::PredHandle> predicates, indexing::IndexMap &target) {
  for (sym::PredHandle predicate : predicates) {
    FailureOr<sym::PredHandle> material =
        materializePredicate(store, source, predicate);
    if (failed(material))
      return failure();
    appendUnique(target.requirements, *material);
  }
  return success();
}

static LogicalResult
appendGuardedPredicates(sym::Store &store, sym::PredHandle inactive,
                        ArrayRef<sym::PredHandle> predicates,
                        SmallVectorImpl<sym::PredHandle> &target, bool unique) {
  for (sym::PredHandle predicate : predicates) {
    sym::PredHandle implication =
        sym::composePredOr(store, inactive, predicate);
    if (unique)
      appendUnique(target, implication);
    else
      target.push_back(implication);
  }
  return success();
}

} // namespace

bool mlir::wave::supportsFullWaveOwnershipRemap(Operation *anchor,
                                                int64_t waveWidth) {
  func::FuncOp func = anchor->getParentOfType<func::FuncOp>();
  if (!func || waveWidth <= 0)
    return false;
  DenseI32ArrayAttr shape = getConsistentWorkgroupShape(func);
  if (!shape || shape.size() != 3 || shape.asArrayRef()[0] <= 0 ||
      shape.asArrayRef()[0] % waveWidth)
    return false;
  for (Operation *parent = anchor->getParentOp(); parent && parent != func;
       parent = parent->getParentOp())
    if (isa<WhereOp>(parent))
      return false;
  return true;
}

bool mlir::wave::hasOnlyCoordinateLaneInputs(
    const indexing::IndexMap &map, sym::ExprHandle block, sym::ExprHandle slot,
    std::optional<sym::ExprHandle> item) {
  for (const indexing::IndexMap::Input &input : map.inputs) {
    if (input.kind != SymbolicOffsetBindingKind::Lane)
      continue;
    bool defined = llvm::any_of(map.definitions,
                                [&](const sym::ExprSubstitution &definition) {
                                  return definition.target == input.variable;
                                });
    if (defined || input.variable == block || input.variable == slot ||
        (item && input.variable == *item))
      continue;
    return false;
  }
  return true;
}

FailureOr<bool> mlir::wave::proveGuardedMemoryAddress(
    sym::Store &store, const indexing::IndexMap &map, sym::PredHandle active,
    ArrayRef<sym::PredHandle> guarded, ArrayRef<sym::PredHandle> activity,
    indexing::CheckMemo *memo) {
  FailureOr<sym::PredHandle> materialActive =
      materializePredicate(store, map, active);
  if (failed(materialActive))
    return failure();
  sym::PredHandle inactive = sym::composePredNot(store, *materialActive);
  indexing::IndexMap proofMap = map;
  proofMap.requirements.clear();
  if (failed(appendMaterializedRequirements(store, map, activity, proofMap)))
    return failure();
  SmallVector<sym::PredHandle> goals;
  if (failed(appendGuardedPredicates(store, inactive, map.requirements,
                                     proofMap.requirements, /*unique=*/true)) ||
      failed(appendGuardedPredicates(store, inactive, guarded, goals,
                                     /*unique=*/false)))
    return failure();
  FailureOr<sym::CheckResult> proven =
      memo ? indexing::check(store, proofMap, goals, *memo)
           : indexing::check(store, proofMap, goals);
  return failed(proven) ? FailureOr<bool>(failure())
                        : FailureOr<bool>(*proven == sym::CheckResult::True);
}

FailureOr<bool> mlir::wave::proveMemoryTransactionAddressHoistable(
    sym::Store &, const MemoryTransaction &, const MemoryTransactionAddress &,
    indexing::CheckMemo &) {
  return true;
}

struct TruncatingRemainder {
  sym::ExprHandle numerator, denominator, scale, residual, quotient;
  bool floored = false;
};

static std::optional<int64_t> getIntegralLiteral(sym::ExprHandle expression) {
  if (std::optional<int64_t> integer = sym::getIntegerLiteralValue(expression))
    return integer;
  std::optional<sym::RationalLiteral> rational =
      sym::ExprView(expression).getRational();
  return rational && rational->denominator == 1
             ? std::optional<int64_t>(rational->numerator)
             : std::nullopt;
}

static FailureOr<sym::ExprHandle>
buildProduct(sym::Store &store, int64_t coefficient,
             ArrayRef<sym::MulFactor> factors) {
  FailureOr<sym::ExprHandle> result = sym::composeExprInt(store, coefficient);
  for (sym::MulFactor factor : factors) {
    if (failed(result) || factor.exponent < 0)
      return failure();
    for (int32_t power = 0; power < factor.exponent; ++power)
      result = sym::composeExprBinary(store, *result, sym::ExprBinaryOp::Mul,
                                      factor.base);
  }
  return result;
}

static bool containsDynamicReciprocal(sym::ExprHandle expression);

static bool addContainsDynamicReciprocal(sym::ExprView view) {
  if (containsDynamicReciprocal(view.getAddConstant()))
    return true;
  for (uint32_t index = 0; index < view.getAddTermCount(); ++index) {
    sym::AddTerm term = view.getAddTerm(index);
    if (containsDynamicReciprocal(term.coefficient) ||
        containsDynamicReciprocal(term.term))
      return true;
  }
  return false;
}

static bool multiplyContainsDynamicReciprocal(sym::ExprView view) {
  if (containsDynamicReciprocal(view.getMulCoefficient()))
    return true;
  for (uint32_t index = 0; index < view.getMulFactorCount(); ++index) {
    sym::MulFactor factor = view.getMulFactor(index);
    if (factor.exponent < 0 && !sym::getIntegerLiteralValue(factor.base))
      return true;
    if (containsDynamicReciprocal(factor.base))
      return true;
  }
  return false;
}

static bool containsDynamicReciprocal(sym::ExprHandle expression) {
  sym::ExprView view(expression);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return addContainsDynamicReciprocal(view);
  case sym::ExprKind::Mul:
    return multiplyContainsDynamicReciprocal(view);
  case sym::ExprKind::Mod:
    return containsDynamicReciprocal(view.getBinaryLhs()) ||
           containsDynamicReciprocal(view.getBinaryRhs());
  default:
    return false;
  }
}

static FailureOr<sym::ExprHandle>
multiplyDistributedSum(sym::Store &store, sym::ExprView sum,
                       sym::ExprHandle factor) {
  if (sum.getKind() != sym::ExprKind::Add)
    return failure();
  FailureOr<sym::ExprHandle> result = sym::composeExprBinary(
      store, sum.getAddConstant(), sym::ExprBinaryOp::Mul, factor);
  for (uint32_t index = 0; index < sum.getAddTermCount(); ++index) {
    sym::AddTerm term = sum.getAddTerm(index);
    FailureOr<sym::ExprHandle> coefficient = sym::composeExprBinary(
        store, term.coefficient, sym::ExprBinaryOp::Mul, factor);
    FailureOr<sym::ExprHandle> scaled =
        failed(coefficient)
            ? FailureOr<sym::ExprHandle>(failure())
            : sym::composeExprBinary(store, *coefficient,
                                     sym::ExprBinaryOp::Mul, term.term);
    if (failed(result) || failed(scaled))
      return failure();
    result =
        sym::composeExprBinary(store, *result, sym::ExprBinaryOp::Add, *scaled);
  }
  return failed(result) ? result : sym::simplifyExpr(store, *result);
}

struct OuterTrunc {
  SmallVector<sym::MulFactor> factors;
  sym::ExprHandle trunc;
  int64_t coefficient = 1;
};

struct TruncatingTerm {
  SmallVector<sym::MulFactor> outerFactors;
  sym::AddTerm addend;
  sym::ExprHandle trunc;
  sym::ExprHandle quotient;
  int64_t signedCoefficient;
  bool floored;
};

struct RemainderOperands {
  sym::ExprHandle numerator;
  sym::ExprHandle denominator;
  sym::ExprHandle scale;
};

static std::optional<OuterTrunc> matchMultipliedTrunc(sym::ExprView term) {
  std::optional<int64_t> coefficient =
      getIntegralLiteral(term.getMulCoefficient());
  if (!coefficient)
    return std::nullopt;
  OuterTrunc result;
  result.coefficient = *coefficient;
  for (uint32_t index = 0; index < term.getMulFactorCount(); ++index) {
    sym::MulFactor factor = term.getMulFactor(index);
    if (factor.exponent <= 0)
      return std::nullopt;
    sym::ExprKind kind = sym::ExprView(factor.base).getKind();
    if (kind != sym::ExprKind::Trunc && kind != sym::ExprKind::Floor) {
      result.factors.push_back(factor);
      continue;
    }
    if (result.trunc || factor.exponent != 1)
      return std::nullopt;
    result.trunc = factor.base;
  }
  return result.trunc ? std::optional<OuterTrunc>(std::move(result))
                      : std::nullopt;
}

static std::optional<OuterTrunc> matchOuterTrunc(sym::ExprHandle expression) {
  sym::ExprKind kind = sym::ExprView(expression).getKind();
  if (kind == sym::ExprKind::Trunc || kind == sym::ExprKind::Floor)
    return OuterTrunc{{}, expression, 1};
  if (kind != sym::ExprKind::Mul)
    return std::nullopt;
  return matchMultipliedTrunc(sym::ExprView(expression));
}

static std::optional<TruncatingTerm> matchTruncatingTerm(sym::AddTerm addend) {
  std::optional<int64_t> addCoefficient =
      getIntegralLiteral(addend.coefficient);
  std::optional<OuterTrunc> outer = matchOuterTrunc(addend.term);
  if (!addCoefficient || !outer)
    return std::nullopt;
  std::optional<int64_t> signedCoefficient =
      llvm::checkedMul(*addCoefficient, outer->coefficient);
  if (!signedCoefficient || *signedCoefficient >= 0)
    return std::nullopt;
  sym::ExprView trunc(outer->trunc);
  return TruncatingTerm{std::move(outer->factors),
                        addend,
                        outer->trunc,
                        trunc.getUnaryArg(),
                        *signedCoefficient,
                        trunc.getKind() == sym::ExprKind::Floor};
}

static FailureOr<std::optional<RemainderOperands>>
buildFlooredRemainderOperands(sym::Store &store, sym::ExprView argument,
                              TruncatingTerm &term) {
  FailureOr<sym::ExprHandle> numerator = failure();
  FailureOr<sym::ExprHandle> denominator = failure();
  for (sym::MulFactor &outer : term.outerFactors) {
    SmallVector<sym::MulFactor> candidate{{outer.base, 1}};
    FailureOr<sym::ExprHandle> candidateDenominator =
        buildProduct(store, 1, candidate);
    FailureOr<sym::ExprHandle> candidateNumerator =
        failed(candidateDenominator)
            ? FailureOr<sym::ExprHandle>(failure())
            : multiplyDistributedSum(store, argument, *candidateDenominator);
    if (failed(candidateNumerator) ||
        containsDynamicReciprocal(*candidateNumerator))
      continue;
    numerator = candidateNumerator;
    denominator = candidateDenominator;
    --outer.exponent;
    break;
  }
  if (failed(numerator) ||
      term.signedCoefficient == std::numeric_limits<int64_t>::min())
    return std::optional<RemainderOperands>{};
  llvm::erase_if(term.outerFactors,
                 [](sym::MulFactor factor) { return factor.exponent == 0; });
  FailureOr<sym::ExprHandle> scale =
      buildProduct(store, -term.signedCoefficient, term.outerFactors);
  if (failed(scale))
    return failure();
  return std::optional<RemainderOperands>{
      RemainderOperands{*numerator, *denominator, *scale}};
}

static std::optional<sym::RationalLiteral>
getRationalCoefficient(sym::ExprHandle expression) {
  if (std::optional<int64_t> integer = sym::getIntegerLiteralValue(expression))
    return sym::RationalLiteral{*integer, 1};
  return sym::ExprView(expression).getRational();
}

static void splitProductFactors(sym::ExprView argument,
                                SmallVectorImpl<sym::MulFactor> &numerator,
                                SmallVectorImpl<sym::MulFactor> &denominator) {
  for (uint32_t index = 0; index < argument.getMulFactorCount(); ++index) {
    sym::MulFactor factor = argument.getMulFactor(index);
    if (factor.exponent > 0) {
      numerator.push_back(factor);
      continue;
    }
    if (factor.exponent < 0) {
      factor.exponent = -factor.exponent;
      denominator.push_back(factor);
    }
  }
}

static bool
consumeDenominatorFactors(SmallVectorImpl<sym::MulFactor> &outerFactors,
                          ArrayRef<sym::MulFactor> denominatorFactors) {
  for (sym::MulFactor denominator : denominatorFactors) {
    auto outer = llvm::find_if(outerFactors, [&](sym::MulFactor factor) {
      return factor.base == denominator.base;
    });
    if (outer == outerFactors.end() || outer->exponent < denominator.exponent)
      return false;
    outer->exponent -= denominator.exponent;
  }
  llvm::erase_if(outerFactors,
                 [](sym::MulFactor factor) { return factor.exponent == 0; });
  return true;
}

static FailureOr<std::optional<RemainderOperands>>
buildProductRemainderOperands(sym::Store &store, sym::ExprView argument,
                              TruncatingTerm &term) {
  std::optional<sym::RationalLiteral> coefficient =
      getRationalCoefficient(argument.getMulCoefficient());
  if (!coefficient || coefficient->denominator <= 0)
    return std::optional<RemainderOperands>{};
  SmallVector<sym::MulFactor> numeratorFactors;
  SmallVector<sym::MulFactor> denominatorFactors;
  splitProductFactors(argument, numeratorFactors, denominatorFactors);
  if (denominatorFactors.empty() ||
      !consumeDenominatorFactors(term.outerFactors, denominatorFactors) ||
      term.signedCoefficient % coefficient->denominator != 0)
    return std::optional<RemainderOperands>{};
  int64_t scaleCoefficient = term.signedCoefficient / coefficient->denominator;
  if (scaleCoefficient == std::numeric_limits<int64_t>::min())
    return std::optional<RemainderOperands>{};
  FailureOr<sym::ExprHandle> numerator =
      buildProduct(store, coefficient->numerator, numeratorFactors);
  FailureOr<sym::ExprHandle> denominator =
      buildProduct(store, coefficient->denominator, denominatorFactors);
  FailureOr<sym::ExprHandle> scale =
      buildProduct(store, -scaleCoefficient, term.outerFactors);
  if (failed(numerator) || failed(denominator) || failed(scale))
    return failure();
  return std::optional<RemainderOperands>{
      RemainderOperands{*numerator, *denominator, *scale}};
}

static FailureOr<std::optional<RemainderOperands>>
buildRemainderOperands(sym::Store &store, TruncatingTerm &term) {
  sym::ExprView argument(term.quotient);
  if (term.floored && argument.getKind() == sym::ExprKind::Add)
    return buildFlooredRemainderOperands(store, argument, term);
  if (argument.getKind() != sym::ExprKind::Mul)
    return std::optional<RemainderOperands>{};
  return buildProductRemainderOperands(store, argument, term);
}

static FailureOr<bool> matchesSignedTerm(sym::Store &store,
                                         const TruncatingTerm &term,
                                         const RemainderOperands &operands,
                                         sym::ExprHandle signedTerm) {
  FailureOr<sym::ExprHandle> expected = sym::composeExprBinary(
      store, operands.scale, sym::ExprBinaryOp::Mul, operands.denominator);
  if (succeeded(expected))
    expected = sym::composeExprBinary(store, *expected, sym::ExprBinaryOp::Mul,
                                      term.trunc);
  if (succeeded(expected))
    expected = sym::composeExprNeg(store, *expected);
  if (failed(expected))
    return failure();
  FailureOr<sym::ExprHandle> simplifiedExpected =
      sym::simplifyExpr(store, *expected);
  FailureOr<sym::ExprHandle> simplifiedSignedTerm =
      sym::simplifyExpr(store, signedTerm);
  if (failed(simplifiedExpected) || failed(simplifiedSignedTerm))
    return failure();
  return *simplifiedExpected == *simplifiedSignedTerm;
}

static FailureOr<sym::ExprHandle>
buildRemainderResidual(sym::Store &store, sym::ExprHandle expression,
                       const RemainderOperands &operands,
                       sym::ExprHandle signedTerm) {
  FailureOr<sym::ExprHandle> positive = sym::composeExprBinary(
      store, operands.scale, sym::ExprBinaryOp::Mul, operands.numerator);
  FailureOr<sym::ExprHandle> group =
      failed(positive)
          ? FailureOr<sym::ExprHandle>(failure())
          : sym::composeExprBinary(store, *positive, sym::ExprBinaryOp::Add,
                                   signedTerm);
  FailureOr<sym::ExprHandle> residual =
      failed(group) ? FailureOr<sym::ExprHandle>(failure())
                    : sym::composeExprBinary(store, expression,
                                             sym::ExprBinaryOp::Sub, *group);
  return failed(residual) ? residual : sym::simplifyExpr(store, *residual);
}

static FailureOr<std::optional<TruncatingRemainder>>
matchTruncatingRemainder(sym::Store &store, sym::ExprHandle expression) {
  sym::ExprView sum(expression);
  if (sum.getKind() != sym::ExprKind::Add)
    return std::optional<TruncatingRemainder>{};
  for (uint32_t index = 0; index < sum.getAddTermCount(); ++index) {
    std::optional<TruncatingTerm> term =
        matchTruncatingTerm(sum.getAddTerm(index));
    if (!term)
      continue;
    FailureOr<std::optional<RemainderOperands>> operands =
        buildRemainderOperands(store, *term);
    if (failed(operands))
      return failure();
    if (!*operands)
      continue;
    FailureOr<sym::ExprHandle> signedTerm =
        sym::composeExprBinary(store, term->addend.coefficient,
                               sym::ExprBinaryOp::Mul, term->addend.term);
    if (failed(signedTerm))
      return failure();
    FailureOr<bool> matched =
        matchesSignedTerm(store, *term, **operands, *signedTerm);
    if (failed(matched))
      return failure();
    if (!*matched)
      continue;
    FailureOr<sym::ExprHandle> residual =
        buildRemainderResidual(store, expression, **operands, *signedTerm);
    if (failed(residual))
      return failure();
    return std::optional<TruncatingRemainder>{TruncatingRemainder{
        (**operands).numerator, (**operands).denominator, (**operands).scale,
        *residual, term->quotient, term->floored}};
  }
  return std::optional<TruncatingRemainder>{};
}

struct MemoryTransactionAddressMaterializer::Impl {
  struct CachedExpr {
    sym::ExprHandle expression;
    SmallVector<sym::PredHandle, 8> facts;
    SmallVector<StringRef, 4> names;
    SmallVector<Value, 4> values;
    Type type;
    Value result;
  };
  struct CachedBase {
    Value selector;
    SmallVector<Value, 2> bases;
    Value result;
  };
  struct CachedCast {
    Value base;
    Type type;
    Value result;
  };
  struct CachedPointer {
    Value base;
    Value offset;
    Type type;
    Value result;
  };
  struct SplitOffset {
    sym::ExprHandle residual;
    int64_t constant = 0;
  };
  struct ExpressionInputs {
    SmallVector<sym::PredHandle, 8> facts;
    SmallVector<StringRef, 4> names;
    SmallVector<Value, 4> values;
    Type type;
  };
  struct PreparedOffset {
    const MemoryTransaction *transaction;
    sym::ExprHandle original;
    SplitOffset split;
    SmallVector<sym::PredHandle, 8> facts;
    SmallVector<StringRef, 4> names;
    SmallVector<Value, 4> values;
    Type type;
    bool shared = false;
  };

  Impl(IRRewriter &rewriter, Operation *anchor, Location location,
       sym::Store &store, int64_t waveWidth)
      : rewriter(rewriter), anchor(anchor), location(location), store(store),
        waveWidth(waveWidth) {}

  static bool sameFacts(ArrayRef<sym::PredHandle> lhs,
                        ArrayRef<sym::PredHandle> rhs) {
    return lhs.size() == rhs.size() &&
           llvm::all_of(lhs, [&](sym::PredHandle fact) {
             return llvm::is_contained(rhs, fact);
           });
  }

  static bool dropsMaterialInput(const MemoryTransaction &transaction,
                                 sym::ExprHandle expression,
                                 sym::ExprHandle candidate) {
    llvm::DenseSet<StringRef> original;
    llvm::DenseSet<StringRef> simplified;
    collectIndexExprRequiredSymbols(expression, {}, original);
    collectIndexExprRequiredSymbols(candidate, {}, simplified);
    return llvm::any_of(transaction.map.inputs, [&](const auto &input) {
      StringRef name = sym::ExprView(input.variable).getSymbolName();
      return input.materializable && original.contains(name) &&
             !simplified.contains(name);
    });
  }

  FailureOr<sym::ExprHandle>
  simplifyMaterialExpr(const MemoryTransaction &transaction,
                       ArrayRef<sym::PredHandle> facts,
                       sym::ExprHandle expression) {
    std::array<sym::ExprHandle, 1> expressions{expression};
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        createTransactionAnalysis(store, expressions, facts);
    // Simplification is optional; the original expression is exact.
    if (failed(analysis))
      return expression;
    FailureOr<sym::ExprHandle> simplified = (*analysis)->simplify(expression);
    if (failed(simplified))
      return anchor->emitOpError("failed to simplify material expression");
    return dropsMaterialInput(transaction, expression, *simplified)
               ? expression
               : *simplified;
  }

  FailureOr<ExpressionInputs>
  collectExpressionInputs(const MemoryTransaction &transaction,
                          ArrayRef<sym::PredHandle> candidates,
                          sym::ExprHandle expression, bool diagnoseMissing) {
    llvm::DenseSet<StringRef> live;
    collectIndexExprRequiredSymbols(expression, {}, live);
    llvm::DenseSet<StringRef> missing = live;
    ExpressionInputs inputs;
    for (const indexing::IndexMap::Input &binding : transaction.map.inputs) {
      StringRef name = sym::ExprView(binding.variable).getSymbolName();
      if (!live.contains(name) || !binding.value)
        continue;
      inputs.names.push_back(name);
      inputs.values.push_back(binding.value);
      missing.erase(name);
    }
    if (!missing.empty()) {
      if (diagnoseMissing)
        anchor->emitOpError()
            << "cannot materialize index expression: symbolic binding '"
            << *missing.begin() << "' has no dominating SSA value";
      return failure();
    }
    inputs.facts = filterIndexExprPredicatesBySymbols(candidates, live);
    inputs.type = getIndexExprResultType(anchor->getContext(), inputs.values);
    return inputs;
  }

  Value findCachedExpression(sym::ExprHandle expression,
                             const ExpressionInputs &inputs) {
    for (const CachedExpr &entry : expressions)
      if (entry.expression == expression && entry.type == inputs.type &&
          entry.names == inputs.names && entry.values == inputs.values &&
          sameFacts(entry.facts, inputs.facts))
        return entry.result;
    return {};
  }

  Value createMaterialExpr(sym::ExprHandle expression, ExpressionInputs inputs,
                           bool cache) {
    Value result =
        IndexExprOp::create(
            rewriter, location, inputs.type,
            ExprAttr::get(anchor->getContext(), expression),
            getIndexExprPredArrayAttr(anchor->getContext(), inputs.facts),
            rewriter.getStrArrayAttr(inputs.names), inputs.values)
            .getResult();
    if (cache)
      expressions.push_back({expression, std::move(inputs.facts),
                             std::move(inputs.names), std::move(inputs.values),
                             inputs.type, result});
    return result;
  }

  static std::optional<arith::CmpIPredicate>
  getCmpPredicate(sym::PredCmpOp predicate) {
    switch (predicate) {
    case sym::PredCmpOp::Eq:
      return arith::CmpIPredicate::eq;
    case sym::PredCmpOp::Ne:
      return arith::CmpIPredicate::ne;
    case sym::PredCmpOp::Lt:
      return arith::CmpIPredicate::slt;
    case sym::PredCmpOp::Le:
      return arith::CmpIPredicate::sle;
    case sym::PredCmpOp::Gt:
      return arith::CmpIPredicate::sgt;
    case sym::PredCmpOp::Ge:
      return arith::CmpIPredicate::sge;
    }
    return std::nullopt;
  }

  Value createPredicateConstant(Type expressionType, bool value) {
    if (auto simd = dyn_cast<SimdType>(expressionType))
      return ConstantOp::create(
          rewriter, location,
          MaskType::get(rewriter.getContext(), simd.getWidth()),
          rewriter.getBoolAttr(value));
    return arith::ConstantIntOp::create(rewriter, location, value, 1);
  }

  Value createIndexConstant(Type type, int64_t value) {
    Type elementType = type;
    if (auto simd = dyn_cast<SimdType>(type))
      elementType = simd.getElementType();
    IntegerAttr attribute = elementType.isIndex()
                                ? rewriter.getIndexAttr(value)
                                : rewriter.getIntegerAttr(elementType, value);
    return ConstantOp::create(rewriter, location, type, attribute);
  }

  Value createSelect(Value condition, Value trueValue, Value falseValue) {
    if (isa<MaskType>(condition.getType()))
      return SelectOp::create(rewriter, location, trueValue.getType(),
                              condition, trueValue, falseValue);
    return arith::SelectOp::create(rewriter, location, condition, trueValue,
                                   falseValue);
  }

  static bool isIntegerLike(Type type) {
    return isa<IntegerType, IndexType>(type);
  }

  Value convertSimdInteger(Value value, SimdType source, SimdType target) {
    if (target.getWidth() != source.getWidth() ||
        !isIntegerLike(target.getElementType()) ||
        !isIntegerLike(source.getElementType()))
      return {};
    return CastOp::create(rewriter, location, target, CastKind::IntConvert,
                          value, DictionaryAttr());
  }

  Value splatInteger(Value value, SimdType target) {
    Value scalar = value;
    if (scalar.getType() != target.getElementType()) {
      if (!isIntegerLike(scalar.getType()) ||
          !isIntegerLike(target.getElementType()))
        return {};
      scalar = CastOp::create(rewriter, location, target.getElementType(),
                              CastKind::IntConvert, scalar, DictionaryAttr());
    }
    return SplatOp::create(rewriter, location, target, scalar);
  }

  Value conformToType(Value value, Type type) {
    if (value.getType() == type)
      return value;
    auto targetSimd = dyn_cast<SimdType>(type);
    auto sourceSimd = dyn_cast<SimdType>(value.getType());
    if (targetSimd && sourceSimd)
      return convertSimdInteger(value, sourceSimd, targetSimd);
    if (!targetSimd && !sourceSimd && isIntegerLike(type) &&
        isIntegerLike(value.getType()))
      return CastOp::create(rewriter, location, type, CastKind::IntConvert,
                            value, DictionaryAttr());
    if (!targetSimd || sourceSimd)
      return {};
    return splatInteger(value, targetSimd);
  }

  FailureOr<Value> materializeComparison(const MemoryTransaction &transaction,
                                         sym::PredView view,
                                         sym::PredHandle active,
                                         Type expressionType) {
    std::optional<arith::CmpIPredicate> comparison =
        getCmpPredicate(*view.getCmpOp());
    FailureOr<Value> lhs =
        materializeExpr(transaction, view.getCmpLhs(), active);
    FailureOr<Value> rhs =
        materializeExpr(transaction, view.getCmpRhs(), active);
    if (!comparison || failed(lhs) || failed(rhs))
      return failure();
    Value typedLhs = conformToType(*lhs, expressionType);
    Value typedRhs = conformToType(*rhs, expressionType);
    if (!typedLhs || !typedRhs)
      return failure();
    if (auto simd = dyn_cast<SimdType>(expressionType))
      return CmpIOp::create(
                 rewriter, location,
                 MaskType::get(rewriter.getContext(), simd.getWidth()),
                 *comparison, typedLhs, typedRhs)
          .getResult();
    return arith::CmpIOp::create(rewriter, location, *comparison, typedLhs,
                                 typedRhs)
        .getResult();
  }

  FailureOr<Value> materializeNegation(const MemoryTransaction &transaction,
                                       sym::PredView view,
                                       sym::PredHandle active,
                                       Type expressionType) {
    FailureOr<Value> argument = materializePredicate(
        transaction, view.getUnaryArg(), active, expressionType);
    if (failed(argument))
      return failure();
    Value falseValue = createPredicateConstant(expressionType, false);
    Value trueValue = createPredicateConstant(expressionType, true);
    return createSelect(*argument, falseValue, trueValue);
  }

  FailureOr<Value> materializeLogic(const MemoryTransaction &transaction,
                                    sym::PredView view, sym::PredHandle active,
                                    Type expressionType) {
    bool isAnd = view.getKind() == sym::PredKind::And;
    Value result = createPredicateConstant(expressionType, isAnd);
    for (uint32_t index = 0; index < view.getLogicArgCount(); ++index) {
      FailureOr<Value> argument = materializePredicate(
          transaction, view.getLogicArg(index), active, expressionType);
      if (failed(argument))
        return failure();
      Value constant = createPredicateConstant(expressionType, !isAnd);
      result = isAnd ? createSelect(result, *argument, constant)
                     : createSelect(result, constant, *argument);
    }
    return result;
  }

  FailureOr<Value> materializePiecewise(const MemoryTransaction &transaction,
                                        sym::PredHandle predicate,
                                        sym::PredHandle active,
                                        Type expressionType) {
    sym::ExprView expression(sym::asExpr(predicate));
    Value result;
    for (uint32_t index = expression.getPiecewiseCaseCount(); index-- > 0;) {
      sym::PiecewiseCase arm = expression.getPiecewiseCase(index);
      std::optional<sym::PredHandle> armValue = sym::asPred(arm.value);
      if (!armValue)
        return failure();
      FailureOr<Value> value =
          materializePredicate(transaction, *armValue, active, expressionType);
      FailureOr<Value> condition = materializePredicate(
          transaction, arm.condition, active, expressionType);
      if (failed(value) || failed(condition))
        return failure();
      result = result ? createSelect(*condition, *value, result) : *value;
    }
    return result ? FailureOr<Value>(result) : FailureOr<Value>(failure());
  }

  FailureOr<Value> materializePredicate(const MemoryTransaction &transaction,
                                        sym::PredHandle predicate,
                                        sym::PredHandle active,
                                        Type expressionType) {
    sym::PredView view(predicate);
    switch (view.getKind()) {
    case sym::PredKind::True:
      return createPredicateConstant(expressionType, true);
    case sym::PredKind::False:
      return createPredicateConstant(expressionType, false);
    case sym::PredKind::Cmp:
      return materializeComparison(transaction, view, active, expressionType);
    case sym::PredKind::Not:
      return materializeNegation(transaction, view, active, expressionType);
    case sym::PredKind::And:
    case sym::PredKind::Or:
      return materializeLogic(transaction, view, active, expressionType);
    case sym::PredKind::Piecewise:
      return materializePiecewise(transaction, predicate, active,
                                  expressionType);
    default:
      return failure();
    }
  }

  FailureOr<Value> materializePredicate(const MemoryTransaction &transaction,
                                        sym::PredHandle predicate,
                                        sym::PredHandle active) {
    SmallVector<sym::PredHandle> candidates(transaction.map.facts.begin(),
                                            transaction.map.facts.end());
    if (active)
      appendUnique(candidates, active);
    FailureOr<ExpressionInputs> inputs =
        collectExpressionInputs(transaction, candidates, sym::asExpr(predicate),
                                /*diagnoseMissing=*/true);
    if (failed(inputs))
      return failure();
    return materializePredicate(transaction, predicate, active, inputs->type);
  }

  FailureOr<bool> proveNonnegative(ArrayRef<sym::PredHandle> facts,
                                   sym::ExprHandle expression) {
    FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
    FailureOr<sym::PredHandle> nonnegative =
        failed(zero)
            ? FailureOr<sym::PredHandle>(failure())
            : sym::composePredCmp(store, expression, sym::PredCmpOp::Ge, *zero);
    if (failed(nonnegative))
      return failure();
    std::array<sym::ExprHandle, 1> goals{sym::asExpr(*nonnegative)};
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        createTransactionAnalysis(store, goals, facts);
    // Without a proof, retain the general signed lowering.
    if (failed(analysis))
      return false;
    return (*analysis)->check(*nonnegative) == sym::CheckResult::True;
  }

  FailureOr<Value> materializeModulo(const MemoryTransaction &transaction,
                                     sym::ExprView expression,
                                     sym::PredHandle active, Type resultType,
                                     ArrayRef<sym::PredHandle> facts) {
    FailureOr<bool> divisorNonnegative =
        proveNonnegative(facts, expression.getBinaryRhs());
    if (failed(divisorNonnegative) || !*divisorNonnegative)
      return anchor->emitOpError(
          "cannot lower symbolic modulo with a possibly negative divisor");
    FailureOr<Value> lhs =
        materializeExpr(transaction, expression.getBinaryLhs(), active);
    FailureOr<Value> rhs =
        materializeExpr(transaction, expression.getBinaryRhs(), active);
    if (failed(lhs) || failed(rhs))
      return failure();
    Value typedLhs = conformToType(*lhs, resultType);
    Value typedRhs = conformToType(*rhs, resultType);
    if (!typedLhs || !typedRhs)
      return failure();
    FailureOr<bool> dividendNonnegative =
        proveNonnegative(facts, expression.getBinaryLhs());
    if (failed(dividendNonnegative))
      return failure();
    BinaryKind kind =
        *dividendNonnegative ? BinaryKind::RemUI : BinaryKind::RemSI;
    Value remainder = BinaryOp::create(rewriter, location, resultType, kind,
                                       typedLhs, typedRhs);
    if (*dividendNonnegative)
      return remainder;
    return adjustSignedRemainder(resultType, remainder, typedRhs);
  }

  Value adjustSignedRemainder(Type resultType, Value remainder, Value divisor) {
    Value zero = createIndexConstant(resultType, 0);
    Value negative;
    if (auto simd = dyn_cast<SimdType>(resultType))
      negative =
          CmpIOp::create(rewriter, location,
                         MaskType::get(rewriter.getContext(), simd.getWidth()),
                         arith::CmpIPredicate::slt, remainder, zero);
    else
      negative = arith::CmpIOp::create(
          rewriter, location, arith::CmpIPredicate::slt, remainder, zero);
    Value adjusted = BinaryOp::create(rewriter, location, resultType,
                                      BinaryKind::AddI, remainder, divisor);
    return createSelect(negative, adjusted, remainder);
  }

  FailureOr<std::optional<Value>>
  materializeScaledModulo(const MemoryTransaction &transaction,
                          sym::ExprHandle expression, sym::PredHandle active,
                          Type resultType, ArrayRef<sym::PredHandle> facts) {
    sym::ExprView scaled(expression);
    int64_t scale = 1;
    sym::ExprHandle modulo = expression;
    if (scaled.getKind() == sym::ExprKind::Mul) {
      std::optional<int64_t> coefficient =
          sym::getIntegerLiteralValue(scaled.getMulCoefficient());
      if (!coefficient || scaled.getMulFactorCount() != 1)
        return std::optional<Value>{};
      sym::MulFactor factor = scaled.getMulFactor(0);
      if (factor.exponent != 1)
        return std::optional<Value>{};
      scale = *coefficient;
      modulo = factor.base;
    }
    sym::ExprView mod(modulo);
    if (mod.getKind() != sym::ExprKind::Mod ||
        sym::getIntegerLiteralValue(mod.getBinaryRhs()))
      return std::optional<Value>{};
    FailureOr<Value> remainder =
        materializeModulo(transaction, mod, active, resultType, facts);
    if (failed(remainder))
      return failure();
    if (scale == 1)
      return std::optional<Value>{*remainder};
    Value factor = createIndexConstant(resultType, scale);
    return std::optional<Value>{BinaryOp::create(
        rewriter, location, resultType, BinaryKind::MulI, *remainder, factor)};
  }

  bool addContainsDynamicTrunc(sym::ExprView view) {
    FailureOr<std::optional<TruncatingRemainder>> remainder =
        ::matchTruncatingRemainder(store, view.getHandle());
    if (succeeded(remainder) && *remainder &&
        ::containsDynamicReciprocal((*remainder)->quotient))
      return true;
    for (uint32_t index = 0; index < view.getAddTermCount(); ++index)
      if (containsDynamicTrunc(view.getAddTerm(index).term))
        return true;
    return false;
  }

  bool multiplyContainsDynamicTrunc(sym::ExprView view) {
    for (uint32_t index = 0; index < view.getMulFactorCount(); ++index)
      if (containsDynamicTrunc(view.getMulFactor(index).base))
        return true;
    return false;
  }

  bool containsDynamicTrunc(sym::ExprHandle expression) {
    sym::ExprView view(expression);
    if (view.getKind() == sym::ExprKind::Trunc &&
        ::containsDynamicReciprocal(view.getUnaryArg()))
      return true;
    if (view.getKind() == sym::ExprKind::Add)
      return addContainsDynamicTrunc(view);
    if (view.getKind() == sym::ExprKind::Mul)
      return multiplyContainsDynamicTrunc(view);
    if (view.getKind() == sym::ExprKind::Mod)
      return containsDynamicTrunc(view.getBinaryLhs()) ||
             containsDynamicTrunc(view.getBinaryRhs());
    return false;
  }

  FailureOr<Value>
  materializeArithmeticLeaf(const MemoryTransaction &transaction,
                            sym::ExprHandle expression, Type resultType,
                            ArrayRef<sym::PredHandle> facts) {
    SmallVector<sym::PredHandle, 8> materialFacts(facts);
    Type elementType = resultType;
    if (auto simd = dyn_cast<SimdType>(elementType))
      elementType = simd.getElementType();
    if (elementType.isInteger(32)) {
      FailureOr<std::optional<sym::ExprHandle>> wrapped =
          matchSignedI32Value(expression);
      if (failed(wrapped))
        return failure();
      if (*wrapped) {
        constexpr int64_t lo = -(int64_t{1} << 31);
        constexpr int64_t hi = (int64_t{1} << 31) - 1;
        sym::PredHandle lower =
            sym::composePredCmp(store, expression, sym::PredCmpOp::Ge,
                                sym::composeExprInt(store, lo));
        sym::PredHandle upper =
            sym::composePredCmp(store, expression, sym::PredCmpOp::Le,
                                sym::composeExprInt(store, hi));
        sym::PredHandle range = sym::composePredAnd(store, lower, upper);
        if (!llvm::is_contained(materialFacts, range))
          materialFacts.push_back(range);
      }
    }
    FailureOr<ExpressionInputs> inputs = collectExpressionInputs(
        transaction, materialFacts, expression, /*diagnoseMissing=*/true);
    if (failed(inputs))
      return failure();
    Value leaf =
        createMaterialExpr(expression, std::move(*inputs), /*cache=*/false);
    Value result = conformToType(leaf, resultType);
    return result ? FailureOr<Value>(result) : FailureOr<Value>(failure());
  }

  FailureOr<Value>
  materializeDynamicArithmetic(const MemoryTransaction &transaction,
                               sym::ExprHandle expression, Type resultType,
                               ArrayRef<sym::PredHandle> facts, bool cache) {
    if (std::optional<int64_t> literal =
            sym::getIntegerLiteralValue(expression))
      return createIndexConstant(resultType, *literal);
    FailureOr<ExpressionInputs> inputs = collectExpressionInputs(
        transaction, facts, expression, /*diagnoseMissing=*/true);
    if (failed(inputs))
      return failure();
    inputs->type = resultType;
    if (cache)
      if (Value cached = findCachedExpression(expression, *inputs))
        return cached;
    FailureOr<Value> result = materializeDynamicArithmeticImpl(
        transaction, expression, resultType, facts, cache);
    if (succeeded(result) && cache)
      expressions.push_back({expression, std::move(inputs->facts),
                             std::move(inputs->names),
                             std::move(inputs->values), inputs->type, *result});
    return result;
  }

  Value createIntegerBinary(Type type, BinaryKind kind, Value lhs, Value rhs) {
    return BinaryOp::create(rewriter, location, type, kind, lhs, rhs);
  }

  FailureOr<Value>
  materializeRemainderExpression(const MemoryTransaction &transaction,
                                 const TruncatingRemainder &remainder,
                                 Type resultType,
                                 ArrayRef<sym::PredHandle> facts, bool cache) {
    if (remainder.floored) {
      for (sym::ExprHandle operand :
           {remainder.numerator, remainder.denominator}) {
        FailureOr<bool> nonnegative = proveNonnegative(facts, operand);
        if (failed(nonnegative) || !*nonnegative)
          return failure();
      }
    }
    FailureOr<Value> numerator = materializeDynamicArithmetic(
        transaction, remainder.numerator, resultType, facts, cache);
    FailureOr<Value> denominator = materializeDynamicArithmetic(
        transaction, remainder.denominator, resultType, facts, cache);
    FailureOr<Value> scale = materializeDynamicArithmetic(
        transaction, remainder.scale, resultType, facts, cache);
    FailureOr<Value> residual = materializeDynamicArithmetic(
        transaction, remainder.residual, resultType, facts, cache);
    if (failed(numerator) || failed(denominator) || failed(scale) ||
        failed(residual))
      return failure();
    Value rem = createIntegerBinary(resultType, BinaryKind::RemSI, *numerator,
                                    *denominator);
    Value scaled =
        createIntegerBinary(resultType, BinaryKind::MulI, *scale, rem);
    return createIntegerBinary(resultType, BinaryKind::AddI, *residual, scaled);
  }

  FailureOr<Value> materializeDynamicAdd(const MemoryTransaction &transaction,
                                         sym::ExprView view, Type resultType,
                                         ArrayRef<sym::PredHandle> facts,
                                         bool cache) {
    FailureOr<std::optional<TruncatingRemainder>> remainder =
        ::matchTruncatingRemainder(store, view.getHandle());
    if (failed(remainder))
      return failure();
    if (*remainder)
      return materializeRemainderExpression(transaction, **remainder,
                                            resultType, facts, cache);
    std::optional<int64_t> constant =
        sym::getIntegerLiteralValue(view.getAddConstant());
    if (!constant)
      return failure();
    Value result = createIndexConstant(resultType, *constant);
    for (uint32_t index = 0; index < view.getAddTermCount(); ++index) {
      sym::AddTerm addend = view.getAddTerm(index);
      std::optional<int64_t> coefficient =
          sym::getIntegerLiteralValue(addend.coefficient);
      FailureOr<Value> term = materializeDynamicArithmetic(
          transaction, addend.term, resultType, facts, cache);
      if (!coefficient || failed(term))
        return failure();
      Value scaled =
          *coefficient == 1
              ? *term
              : createIntegerBinary(
                    resultType, BinaryKind::MulI,
                    createIndexConstant(resultType, *coefficient), *term);
      result =
          createIntegerBinary(resultType, BinaryKind::AddI, result, scaled);
    }
    return result;
  }

  FailureOr<Value>
  materializeDynamicProduct(const MemoryTransaction &transaction,
                            sym::ExprView view, Type resultType,
                            ArrayRef<sym::PredHandle> facts, bool cache) {
    std::optional<int64_t> coefficient =
        sym::getIntegerLiteralValue(view.getMulCoefficient());
    if (!coefficient)
      return failure();
    Value result = createIndexConstant(resultType, *coefficient);
    for (uint32_t index = 0; index < view.getMulFactorCount(); ++index) {
      sym::MulFactor factor = view.getMulFactor(index);
      if (factor.exponent < 0)
        return failure();
      FailureOr<Value> value = materializeDynamicArithmetic(
          transaction, factor.base, resultType, facts, cache);
      if (failed(value))
        return failure();
      for (int32_t power = 0; power < factor.exponent; ++power)
        result =
            createIntegerBinary(resultType, BinaryKind::MulI, result, *value);
    }
    return result;
  }

  FailureOr<Value>
  materializeDynamicModulo(const MemoryTransaction &transaction,
                           sym::ExprView view, Type resultType,
                           ArrayRef<sym::PredHandle> facts, bool cache) {
    Type elementType = resultType;
    if (auto simd = dyn_cast<SimdType>(elementType))
      elementType = simd.getElementType();
    if (elementType.isInteger(32) &&
        sym::getIntegerLiteralValue(view.getBinaryRhs()) == (int64_t{1} << 32))
      return materializeDynamicArithmetic(transaction, view.getBinaryLhs(),
                                          resultType, facts, cache);
    FailureOr<Value> lhs = materializeDynamicArithmetic(
        transaction, view.getBinaryLhs(), resultType, facts, cache);
    FailureOr<Value> rhs = materializeDynamicArithmetic(
        transaction, view.getBinaryRhs(), resultType, facts, cache);
    FailureOr<bool> nonnegative = proveNonnegative(facts, view.getBinaryLhs());
    if (failed(lhs) || failed(rhs) || failed(nonnegative))
      return failure();
    BinaryKind kind = *nonnegative ? BinaryKind::RemUI : BinaryKind::RemSI;
    Value remainder = createIntegerBinary(resultType, kind, *lhs, *rhs);
    return *nonnegative ? FailureOr<Value>(remainder)
                        : FailureOr<Value>(adjustSignedRemainder(
                              resultType, remainder, *rhs));
  }

  FailureOr<Value>
  materializeDynamicQuotient(const MemoryTransaction &transaction,
                             sym::ExprView view, Type resultType,
                             ArrayRef<sym::PredHandle> facts, bool cache) {
    sym::ExprView argument(view.getUnaryArg());
    if (argument.getKind() != sym::ExprKind::Mul)
      return failure();
    std::optional<sym::RationalLiteral> coefficient =
        getRationalCoefficient(argument.getMulCoefficient());
    if (!coefficient)
      return failure();
    Value numerator = createIndexConstant(resultType, coefficient->numerator);
    Value denominator =
        createIndexConstant(resultType, coefficient->denominator);
    bool hasDynamicDenominator = false;
    for (uint32_t index = 0; index < argument.getMulFactorCount(); ++index) {
      sym::MulFactor factor = argument.getMulFactor(index);
      FailureOr<Value> value = materializeDynamicArithmetic(
          transaction, factor.base, resultType, facts, cache);
      if (failed(value))
        return failure();
      int64_t power = std::abs(static_cast<int64_t>(factor.exponent));
      for (int64_t iteration = 0; iteration < power; ++iteration) {
        if (factor.exponent < 0)
          denominator = createIntegerBinary(resultType, BinaryKind::MulI,
                                            denominator, *value);
        else
          numerator = createIntegerBinary(resultType, BinaryKind::MulI,
                                          numerator, *value);
      }
      hasDynamicDenominator |=
          factor.exponent < 0 && !sym::getIntegerLiteralValue(factor.base);
    }
    if (!hasDynamicDenominator)
      return failure();
    return createIntegerBinary(resultType, BinaryKind::DivSI, numerator,
                               denominator);
  }

  FailureOr<Value> materializeDynamicArithmeticImpl(
      const MemoryTransaction &transaction, sym::ExprHandle expression,
      Type resultType, ArrayRef<sym::PredHandle> facts, bool cache) {
    sym::ExprView view(expression);
    if (!containsDynamicTrunc(expression))
      return materializeArithmeticLeaf(transaction, expression, resultType,
                                       facts);
    if (view.getKind() == sym::ExprKind::Add)
      return materializeDynamicAdd(transaction, view, resultType, facts, cache);
    if (view.getKind() == sym::ExprKind::Mul)
      return materializeDynamicProduct(transaction, view, resultType, facts,
                                       cache);
    if (view.getKind() == sym::ExprKind::Mod)
      return materializeDynamicModulo(transaction, view, resultType, facts,
                                      cache);
    if (view.getKind() == sym::ExprKind::Trunc)
      return materializeDynamicQuotient(transaction, view, resultType, facts,
                                        cache);
    return failure();
  }

  FailureOr<std::optional<sym::ExprHandle>>
  matchSignedI32Value(sym::ExprHandle expression) {
    constexpr int64_t bias = int64_t{1} << 31;
    constexpr int64_t modulus = int64_t{1} << 32;
    sym::ExprView outer(expression);
    if (outer.getKind() != sym::ExprKind::Add ||
        sym::getIntegerLiteralValue(outer.getAddConstant()) != -bias ||
        outer.getAddTermCount() != 1)
      return std::optional<sym::ExprHandle>{};
    sym::AddTerm term = outer.getAddTerm(0);
    if (sym::getIntegerLiteralValue(term.coefficient) != 1)
      return std::optional<sym::ExprHandle>{};
    sym::ExprView wrapped(term.term);
    if (wrapped.getKind() != sym::ExprKind::Mod ||
        sym::getIntegerLiteralValue(wrapped.getBinaryRhs()) != modulus)
      return std::optional<sym::ExprHandle>{};
    FailureOr<sym::ExprHandle> biasExpr = sym::composeExprInt(store, bias);
    if (failed(biasExpr))
      return failure();
    FailureOr<sym::ExprHandle> value = sym::composeExprBinary(
        store, wrapped.getBinaryLhs(), sym::ExprBinaryOp::Sub, *biasExpr);
    if (failed(value))
      return failure();
    return std::optional<sym::ExprHandle>{*value};
  }

  bool isI32Input(const MemoryTransaction &transaction,
                  sym::ExprHandle expression) {
    auto input = llvm::find_if(
        transaction.map.inputs, [&](const indexing::IndexMap::Input &input) {
          return input.value && input.variable == expression;
        });
    if (input == transaction.map.inputs.end())
      return false;
    Type type = input->value.getType();
    if (auto simd = dyn_cast<SimdType>(type))
      type = simd.getElementType();
    return type.isInteger(32);
  }

  FailureOr<bool>
  canMaterializeRemainderI32(const MemoryTransaction &transaction,
                             const TruncatingRemainder &remainder) {
    FailureOr<std::optional<sym::ExprHandle>> numerator =
        matchSignedI32Value(remainder.numerator);
    FailureOr<std::optional<sym::ExprHandle>> denominator =
        matchSignedI32Value(remainder.denominator);
    bool fixedNumerator =
        succeeded(numerator) &&
        (*numerator || isI32Input(transaction, remainder.numerator));
    bool fixedDenominator =
        succeeded(denominator) &&
        (*denominator || isI32Input(transaction, remainder.denominator));
    return fixedNumerator && fixedDenominator &&
           !containsDynamicTrunc(remainder.residual) &&
           !containsDynamicTrunc(remainder.scale);
  }

  FailureOr<bool> canMaterializeAddI32(const MemoryTransaction &transaction,
                                       sym::ExprView view) {
    FailureOr<std::optional<TruncatingRemainder>> remainder =
        ::matchTruncatingRemainder(store, view.getHandle());
    if (failed(remainder))
      return failure();
    if (*remainder)
      return canMaterializeRemainderI32(transaction, **remainder);
    for (uint32_t index = 0; index < view.getAddTermCount(); ++index) {
      FailureOr<bool> term =
          canMaterializeDynamicI32(transaction, view.getAddTerm(index).term);
      if (failed(term) || !*term)
        return term;
    }
    return true;
  }

  FailureOr<bool> canMaterializeProductI32(const MemoryTransaction &transaction,
                                           sym::ExprView view) {
    for (uint32_t index = 0; index < view.getMulFactorCount(); ++index) {
      FailureOr<bool> factor =
          canMaterializeDynamicI32(transaction, view.getMulFactor(index).base);
      if (failed(factor) || !*factor)
        return factor;
    }
    return true;
  }

  FailureOr<bool>
  canMaterializeQuotientI32(const MemoryTransaction &transaction,
                            sym::ExprView view) {
    sym::ExprView argument(view.getUnaryArg());
    if (argument.getKind() != sym::ExprKind::Mul)
      return false;
    bool dynamicDenominator = false;
    for (uint32_t index = 0; index < argument.getMulFactorCount(); ++index) {
      sym::MulFactor factor = argument.getMulFactor(index);
      FailureOr<std::optional<sym::ExprHandle>> fixed =
          matchSignedI32Value(factor.base);
      if (failed(fixed) || (!*fixed && !isI32Input(transaction, factor.base)))
        return false;
      dynamicDenominator |= factor.exponent < 0;
    }
    return dynamicDenominator;
  }

  FailureOr<bool> canMaterializeDynamicI32(const MemoryTransaction &transaction,
                                           sym::ExprHandle expression) {
    if (!containsDynamicTrunc(expression))
      return true;
    sym::ExprView view(expression);
    if (view.getKind() == sym::ExprKind::Mod) {
      if (sym::getIntegerLiteralValue(view.getBinaryRhs()) !=
          (int64_t{1} << 32))
        return false;
      return canMaterializeDynamicI32(transaction, view.getBinaryLhs());
    }
    if (view.getKind() == sym::ExprKind::Add)
      return canMaterializeAddI32(transaction, view);
    if (view.getKind() == sym::ExprKind::Mul)
      return canMaterializeProductI32(transaction, view);
    if (view.getKind() == sym::ExprKind::Trunc)
      return canMaterializeQuotientI32(transaction, view);
    return false;
  }

  void rememberExpression(sym::ExprHandle expression, ExpressionInputs inputs,
                          Value result) {
    expressions.push_back({expression, std::move(inputs.facts),
                           std::move(inputs.names), std::move(inputs.values),
                           inputs.type, result});
  }

  Type getSimdExpressionType(Type type) {
    return isa<SimdType>(type)
               ? type
               : Type(SimdType::get(anchor->getContext(), type, waveWidth));
  }

  std::pair<sym::ExprHandle, bool>
  unwrapU32Expression(sym::ExprHandle expression) {
    sym::ExprView view(expression);
    if (view.getKind() == sym::ExprKind::Mod &&
        sym::getIntegerLiteralValue(view.getBinaryRhs()) == (int64_t{1} << 32))
      return {view.getBinaryLhs(), true};
    return {expression, false};
  }

  Type getNarrowDynamicType(Type type) {
    Type i32 = rewriter.getI32Type();
    if (auto simd = dyn_cast<SimdType>(type))
      return SimdType::get(anchor->getContext(), i32, simd.getWidth());
    return i32;
  }

  FailureOr<Value> conformWrappedU32(Value value, Type resultType) {
    Type i32 = rewriter.getI32Type();
    if (auto simd = dyn_cast<SimdType>(resultType))
      i32 = SimdType::get(anchor->getContext(), i32, simd.getWidth());
    Value result = conformToType(value, i32);
    return result ? FailureOr<Value>(result) : FailureOr<Value>(failure());
  }

  FailureOr<Value> materializeDynamicExpression(
      const MemoryTransaction &transaction, sym::ExprHandle expression,
      sym::PredHandle active, ArrayRef<sym::PredHandle> candidates,
      ExpressionInputs inputs) {
    Type resultType = getSimdExpressionType(inputs.type);
    auto [arithmetic, wrapsU32] = unwrapU32Expression(expression);
    FailureOr<bool> narrow = canMaterializeDynamicI32(transaction, expression);
    if (failed(narrow))
      return failure();
    if (*narrow)
      resultType = getNarrowDynamicType(resultType);
    FailureOr<Value> result = materializeDynamicArithmetic(
        transaction, arithmetic, resultType, candidates, !active);
    if (failed(result))
      return anchor->emitOpError(
          "failed to lower dynamic truncating index quotient");
    if (wrapsU32)
      result = conformWrappedU32(*result, resultType);
    if (failed(result))
      return failure();
    if (!active)
      rememberExpression(expression, std::move(inputs), *result);
    return *result;
  }

  FailureOr<Value> materializePredicateExpression(
      const MemoryTransaction &transaction, sym::ExprHandle expression,
      sym::PredHandle predicate, sym::PredHandle active,
      ExpressionInputs inputs) {
    FailureOr<Value> condition =
        materializePredicate(transaction, predicate, active, inputs.type);
    if (failed(condition))
      return anchor->emitOpError("failed to lower symbolic predicate");
    Value zero = createIndexConstant(inputs.type, 0);
    Value one = createIndexConstant(inputs.type, 1);
    Value result = createSelect(*condition, one, zero);
    if (!active)
      rememberExpression(expression, std::move(inputs), result);
    return result;
  }

  FailureOr<std::optional<Value>> materializeModuloExpression(
      const MemoryTransaction &transaction, sym::ExprHandle expression,
      sym::PredHandle active, ArrayRef<sym::PredHandle> candidates,
      ExpressionInputs &inputs) {
    FailureOr<std::optional<Value>> modulo =
        materializeScaledModulo(transaction, expression, active,
                                getSimdExpressionType(inputs.type), candidates);
    if (failed(modulo))
      return failure();
    if (!*modulo)
      return std::optional<Value>{};
    Value result = **modulo;
    if (!result)
      return failure();
    if (!active)
      rememberExpression(expression, std::move(inputs), result);
    return std::optional<Value>{result};
  }

  FailureOr<Value> materializePreparedExpression(
      const MemoryTransaction &transaction, sym::ExprHandle expression,
      sym::PredHandle active, ArrayRef<sym::PredHandle> candidates,
      ExpressionInputs inputs) {
    if (!active)
      if (Value cached = findCachedExpression(expression, inputs))
        return cached;
    FailureOr<std::optional<Value>> modulo = materializeModuloExpression(
        transaction, expression, active, candidates, inputs);
    if (failed(modulo))
      return failure();
    if (*modulo)
      return **modulo;
    if (containsDynamicTrunc(expression))
      return materializeDynamicExpression(transaction, expression, active,
                                          candidates, std::move(inputs));
    if (std::optional<sym::PredHandle> predicate = sym::asPred(expression))
      return materializePredicateExpression(transaction, expression, *predicate,
                                            active, std::move(inputs));
    return createMaterialExpr(expression, std::move(inputs), !active);
  }

  FailureOr<Value> materializeExpr(const MemoryTransaction &transaction,
                                   sym::ExprHandle expression,
                                   sym::PredHandle active,
                                   sym::ExprHandle *canonical = nullptr) {
    SmallVector<sym::PredHandle> candidates(transaction.map.facts.begin(),
                                            transaction.map.facts.end());
    if (active)
      appendUnique(candidates, active);
    auto exactInput = llvm::find_if(
        transaction.map.inputs, [&](const indexing::IndexMap::Input &input) {
          return input.value && input.variable == expression &&
                 input.materializable;
        });
    if (exactInput != transaction.map.inputs.end()) {
      FailureOr<ExpressionInputs> inputs = collectExpressionInputs(
          transaction, candidates, expression, /*diagnoseMissing=*/true);
      if (failed(inputs))
        return failure();
      return createMaterialExpr(expression, std::move(*inputs), !active);
    }
    FailureOr<sym::ExprHandle> simplified =
        simplifyMaterialExpr(transaction, candidates, expression);
    if (failed(simplified))
      return failure();
    expression = *simplified;
    if (canonical)
      *canonical = expression;
    if (std::optional<int64_t> literal =
            sym::getIntegerLiteralValue(expression))
      return ConstantOp::create(rewriter, location, rewriter.getIndexType(),
                                rewriter.getIndexAttr(*literal))
          .getResult();

    FailureOr<ExpressionInputs> inputs = collectExpressionInputs(
        transaction, candidates, expression, /*diagnoseMissing=*/true);
    if (failed(inputs))
      return failure();
    return materializePreparedExpression(transaction, expression, active,
                                         candidates, std::move(*inputs));
  }

  FailureOr<SplitOffset> splitOffset(const MemoryTransaction &transaction,
                                     sym::ExprHandle expression) {
    std::array<sym::ExprHandle, 1> expressions{expression};
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        createTransactionAnalysis(store, expressions, transaction.map.facts);
    // Constant extraction is optional; preserve the complete expression.
    if (failed(analysis))
      return SplitOffset{expression, 0};
    FailureOr<sym::ExprHandle> simplified = (*analysis)->simplify(expression);
    sym::ExprHandle material =
        succeeded(simplified) &&
                !dropsMaterialInput(transaction, expression, *simplified)
            ? *simplified
            : expression;
    FailureOr<std::optional<sym::SplitAdditiveConstant>> split =
        (*analysis)->splitAdditiveConstant(material);
    if (failed(split))
      return failure();
    if (!*split)
      return SplitOffset{material, 0};
    return SplitOffset{(**split).residual, (**split).constant};
  }

  static bool matchesPreparedOffset(const PreparedOffset &lhs,
                                    const PreparedOffset &rhs) {
    return lhs.split.residual == rhs.split.residual && lhs.type == rhs.type &&
           lhs.names == rhs.names && lhs.values == rhs.values &&
           sameFacts(lhs.facts, rhs.facts);
  }

  void markSharedPreparedOffsets(PreparedOffset &entry) {
    for (PreparedOffset &existing : preparedOffsets) {
      if (!matchesPreparedOffset(existing, entry))
        continue;
      existing.shared = true;
      entry.shared = true;
    }
  }

  LogicalResult prepare(const MemoryTransaction &transaction,
                        const MemoryTransactionAddress &address) {
    FailureOr<SplitOffset> split =
        splitOffset(transaction, address.elementOffset);
    if (failed(split))
      return failure();
    FailureOr<ExpressionInputs> inputs = collectExpressionInputs(
        transaction, transaction.map.facts, split->residual,
        /*diagnoseMissing=*/false);
    if (failed(inputs))
      return failure();
    PreparedOffset entry{&transaction,
                         address.elementOffset,
                         *split,
                         std::move(inputs->facts),
                         std::move(inputs->names),
                         std::move(inputs->values),
                         inputs->type};
    markSharedPreparedOffsets(entry);
    preparedOffsets.push_back(std::move(entry));
    return success();
  }

  Value findCachedBase(Value selector, ArrayRef<Value> bases) {
    for (const CachedBase &entry : selectedBases)
      if (entry.selector == selector && entry.bases == bases)
        return entry.result;
    return {};
  }

  Value selectSimdBase(Value selector, ArrayRef<Value> bases, SimdType simd) {
    Value base;
    for (auto indexed : llvm::enumerate(bases)) {
      Value candidate = indexed.value();
      if (!isa<SimdType>(candidate.getType()))
        candidate =
            SplatOp::create(rewriter, location,
                            SimdType::get(rewriter.getContext(),
                                          candidate.getType(), simd.getWidth()),
                            candidate);
      if (!base) {
        base = candidate;
        continue;
      }
      Value ordinal =
          ConstantOp::create(rewriter, location, selector.getType(),
                             rewriter.getIndexAttr(indexed.index()));
      Value selected =
          CmpIOp::create(rewriter, location,
                         MaskType::get(rewriter.getContext(), simd.getWidth()),
                         arith::CmpIPredicate::eq, selector, ordinal);
      base = SelectOp::create(rewriter, location, candidate.getType(), selected,
                              candidate, base);
    }
    return base;
  }

  Value selectScalarBase(Value selector, ArrayRef<Value> bases) {
    Value base = bases.front();
    for (auto indexed : llvm::enumerate(bases)) {
      if (indexed.index() == 0)
        continue;
      Value ordinal =
          arith::ConstantIndexOp::create(rewriter, location, indexed.index());
      Value selected = arith::CmpIOp::create(
          rewriter, location, arith::CmpIPredicate::eq, selector, ordinal);
      base = arith::SelectOp::create(rewriter, location, selected,
                                     indexed.value(), base);
    }
    return base;
  }

  Value selectDynamicBase(Value selector, ArrayRef<Value> bases,
                          sym::PredHandle active) {
    Value base = active ? Value{} : findCachedBase(selector, bases);
    if (base)
      return base;
    if (auto simd = dyn_cast<SimdType>(selector.getType()))
      base = selectSimdBase(selector, bases, simd);
    else
      base = selectScalarBase(selector, bases);
    if (!active)
      selectedBases.push_back({selector, SmallVector<Value>(bases), base});
    return base;
  }

  FailureOr<Value> selectBase(const MemoryTransaction &transaction,
                              const MemoryTransactionAddress &address,
                              sym::PredHandle active) {
    sym::ExprHandle canonicalSelector;
    FailureOr<Value> selector = materializeExpr(
        transaction, address.baseSelector, active, &canonicalSelector);
    if (failed(selector))
      return failure();
    std::optional<int64_t> literal =
        sym::getIntegerLiteralValue(canonicalSelector);
    if (!literal)
      return selectDynamicBase(*selector, address.bases, active);
    if (*literal < 0 || *literal >= static_cast<int64_t>(address.bases.size()))
      return failure();
    return address.bases[*literal];
  }

  Value findCachedCast(Value base, Type type) {
    for (const CachedCast &entry : casts)
      if (entry.base == base && entry.type == type)
        return entry.result;
    return {};
  }

  FailureOr<Value> castBaseToByte(Value base, sym::PredHandle active) {
    std::optional<PtrType> pointer = getWavePointerType(base.getType());
    if (!pointer)
      return failure();
    Type bytePointer = PtrType::get(rewriter.getContext(), rewriter.getI8Type(),
                                    pointer->getAddressSpace());
    Type byteBaseType = bytePointer;
    if (auto simd = dyn_cast<SimdType>(base.getType()))
      byteBaseType =
          SimdType::get(rewriter.getContext(), bytePointer, simd.getWidth());
    Value cast = active ? Value{} : findCachedCast(base, byteBaseType);
    if (!cast) {
      cast = PtrCastOp::create(rewriter, location, byteBaseType, base);
      if (!active)
        casts.push_back({base, byteBaseType, cast});
    }
    return cast;
  }

  FailureOr<Value> castBaseToUnit(Value base, int64_t unitBits,
                                  sym::PredHandle active) {
    FailureOr<std::optional<int64_t>> baseUnitBits =
        getMemoryPointerElementBits(base.getType());
    if (failed(baseUnitBits) || !*baseUnitBits || unitBits <= 0)
      return failure();
    if (**baseUnitBits == unitBits)
      return base;
    if (unitBits != 8)
      return failure();
    return castBaseToByte(base, active);
  }

  SplitOffset findPreparedSplit(const MemoryTransaction &transaction,
                                sym::ExprHandle offset,
                                sym::PredHandle active) {
    SplitOffset split{offset, 0};
    if (active)
      return split;
    for (const PreparedOffset &entry : preparedOffsets) {
      if (entry.transaction != &transaction || !(entry.original == offset))
        continue;
      if (entry.shared)
        split = entry.split;
      break;
    }
    return split;
  }

  Value findCachedPointer(Value base, Value offset, Type type) {
    for (const CachedPointer &entry : pointers)
      if (entry.base == base && entry.offset == offset && entry.type == type)
        return entry.result;
    return {};
  }

  struct BufferAddressFields {
    sym::ExprHandle uniform;
    sym::ExprHandle lane;
  };

  struct BufferAddressSum {
    sym::ExprHandle expression;
    sym::ExprHandle scale;
  };

  FailureOr<bool> isLaneAddressExpr(const MemoryTransaction &transaction,
                                    sym::ExprHandle expression) {
    llvm::DenseSet<StringRef> required;
    collectIndexExprRequiredSymbols(expression, {}, required);
    for (StringRef name : required) {
      auto input = llvm::find_if(
          transaction.map.inputs, [&](const indexing::IndexMap::Input &entry) {
            return sym::ExprView(entry.variable).getSymbolName() == name;
          });
      if (input == transaction.map.inputs.end() || !input->value)
        return anchor->emitOpError()
               << "cannot classify address field: symbolic binding '" << name
               << "' has no dominating SSA value";
      if (isa<SimdType>(input->value.getType()))
        return true;
    }
    return false;
  }

  std::optional<BufferAddressSum>
  matchBufferAddressSum(sym::ExprHandle expression) {
    sym::ExprView modulo(expression);
    if (modulo.getKind() != sym::ExprKind::Mod ||
        sym::getIntegerLiteralValue(modulo.getBinaryRhs()) !=
            (int64_t{1} << 32))
      return std::nullopt;
    BufferAddressSum result{modulo.getBinaryLhs(), {}};
    sym::ExprView sum(result.expression);
    if (sum.getKind() == sym::ExprKind::Mul) {
      if (sum.getMulFactorCount() != 1 || sum.getMulFactor(0).exponent != 1 ||
          !sym::getIntegerLiteralValue(sum.getMulCoefficient()))
        return std::nullopt;
      result.scale = sum.getMulCoefficient();
      result.expression = sum.getMulFactor(0).base;
      sum = sym::ExprView(result.expression);
    }
    return sum.getKind() == sym::ExprKind::Add
               ? std::optional<BufferAddressSum>(result)
               : std::nullopt;
  }

  FailureOr<sym::ExprHandle> scaleBufferAddressExpr(sym::ExprHandle value,
                                                    sym::ExprHandle coefficient,
                                                    sym::ExprHandle scale) {
    sym::ExprHandle result = value;
    for (sym::ExprHandle factor : {coefficient, scale}) {
      if (!factor)
        continue;
      FailureOr<sym::ExprHandle> product =
          sym::composeExprBinary(store, factor, sym::ExprBinaryOp::Mul, result);
      if (failed(product))
        return failure();
      result = *product;
    }
    return result;
  }

  LogicalResult appendBufferAddressField(sym::ExprHandle value,
                                         sym::ExprHandle &field) {
    if (!field) {
      field = value;
      return success();
    }
    FailureOr<sym::ExprHandle> sum =
        sym::composeExprBinary(store, field, sym::ExprBinaryOp::Add, value);
    if (failed(sum))
      return failure();
    field = *sum;
    return success();
  }

  LogicalResult appendClassifiedBufferExpr(const MemoryTransaction &transaction,
                                           sym::ExprHandle expression,
                                           sym::ExprHandle coefficient,
                                           sym::ExprHandle scale,
                                           BufferAddressFields &fields) {
    FailureOr<sym::ExprHandle> value =
        scaleBufferAddressExpr(expression, coefficient, scale);
    if (failed(value))
      return failure();
    if (sym::getIntegerLiteralValue(*value) == 0)
      return success();
    FailureOr<bool> lane = isLaneAddressExpr(transaction, *value);
    if (failed(lane))
      return failure();
    return appendBufferAddressField(*value,
                                    *lane ? fields.lane : fields.uniform);
  }

  LogicalResult appendBufferAddressSum(const MemoryTransaction &transaction,
                                       sym::ExprHandle expression,
                                       sym::ExprHandle scale,
                                       BufferAddressFields &fields) {
    sym::ExprView view(expression);
    if (view.getKind() != sym::ExprKind::Add)
      return appendClassifiedBufferExpr(transaction, expression, {}, scale,
                                        fields);
    if (failed(appendClassifiedBufferExpr(transaction, view.getAddConstant(),
                                          {}, scale, fields)))
      return failure();
    for (uint32_t index = 0; index < view.getAddTermCount(); ++index) {
      sym::AddTerm term = view.getAddTerm(index);
      if (failed(appendClassifiedBufferExpr(transaction, term.term,
                                            term.coefficient, scale, fields)))
        return failure();
    }
    return success();
  }

  LogicalResult simplifyBufferAddressField(sym::ExprHandle &field) {
    if (!field)
      return success();
    FailureOr<sym::ExprHandle> simplified = sym::simplifyExpr(store, field);
    if (failed(simplified))
      return failure();
    field =
        getIntegralLiteral(*simplified) == 0 ? sym::ExprHandle{} : *simplified;
    return success();
  }

  LogicalResult simplifyBufferAddressFields(BufferAddressFields &fields) {
    if (failed(simplifyBufferAddressField(fields.uniform)))
      return failure();
    return simplifyBufferAddressField(fields.lane);
  }

  FailureOr<BufferAddressFields>
  wrapBufferAddressFields(BufferAddressFields fields) {
    FailureOr<sym::ExprHandle> modulus =
        sym::composeExprInt(store, int64_t{1} << 32);
    if (failed(modulus))
      return failure();
    FailureOr<sym::ExprHandle> uniform = sym::composeExprBinary(
        store, fields.uniform, sym::ExprBinaryOp::Mod, *modulus);
    FailureOr<sym::ExprHandle> lane = sym::composeExprBinary(
        store, fields.lane, sym::ExprBinaryOp::Mod, *modulus);
    if (failed(uniform) || failed(lane))
      return failure();
    fields.uniform = *uniform;
    fields.lane = *lane;
    return fields;
  }

  LogicalResult appendTruncatingBufferSum(const MemoryTransaction &transaction,
                                          const BufferAddressSum &sum,
                                          const TruncatingRemainder &remainder,
                                          BufferAddressFields &fields) {
    FailureOr<sym::ExprHandle> group = sym::composeExprBinary(
        store, sum.expression, sym::ExprBinaryOp::Sub, remainder.residual);
    FailureOr<sym::ExprHandle> simplified =
        failed(group) ? FailureOr<sym::ExprHandle>(failure())
                      : sym::simplifyExpr(store, *group);
    if (failed(simplified) ||
        failed(appendBufferAddressSum(transaction, remainder.residual,
                                      sum.scale, fields)))
      return failure();
    return appendClassifiedBufferExpr(transaction, *simplified, {}, sum.scale,
                                      fields);
  }

  FailureOr<std::optional<BufferAddressFields>>
  finalizeBufferAddressFields(BufferAddressFields fields) {
    if (failed(simplifyBufferAddressFields(fields)))
      return failure();
    if (!fields.uniform || !fields.lane)
      return std::optional<BufferAddressFields>{};
    FailureOr<BufferAddressFields> wrapped = wrapBufferAddressFields(fields);
    if (failed(wrapped))
      return failure();
    fields = *wrapped;
    if (failed(simplifyBufferAddressFields(fields)))
      return failure();
    return fields.uniform && fields.lane
               ? FailureOr<std::optional<BufferAddressFields>>(
                     std::optional<BufferAddressFields>(fields))
               : FailureOr<std::optional<BufferAddressFields>>(
                     std::optional<BufferAddressFields>{});
  }

  FailureOr<std::optional<BufferAddressFields>>
  splitBufferAddressFields(const MemoryTransaction &transaction,
                           sym::ExprHandle expression) {
    std::optional<BufferAddressSum> sum = matchBufferAddressSum(expression);
    if (!sum)
      return std::optional<BufferAddressFields>{};
    FailureOr<std::optional<TruncatingRemainder>> remainder =
        ::matchTruncatingRemainder(store, sum->expression);
    if (failed(remainder))
      return failure();
    BufferAddressFields fields;
    if (*remainder && failed(appendTruncatingBufferSum(transaction, *sum,
                                                       **remainder, fields)))
      return failure();
    if (!*remainder && failed(appendBufferAddressSum(
                           transaction, sum->expression, sum->scale, fields)))
      return failure();
    return finalizeBufferAddressFields(fields);
  }

  FailureOr<Value>
  materializeUniformAddressExpr(const MemoryTransaction &transaction,
                                sym::ExprHandle expression,
                                sym::PredHandle active) {
    SmallVector<sym::PredHandle> candidates(transaction.map.facts.begin(),
                                            transaction.map.facts.end());
    if (active)
      appendUnique(candidates, active);
    FailureOr<ExpressionInputs> inputs = collectExpressionInputs(
        transaction, candidates, expression, /*diagnoseMissing=*/true);
    if (failed(inputs) || isa<SimdType>(inputs->type))
      return failure();
    sym::ExprView view(expression);
    if (isU32Modulo(view)) {
      FailureOr<Value> result = materializeDynamicArithmetic(
          transaction, view.getBinaryLhs(), rewriter.getI32Type(), candidates,
          !active);
      if (failed(result))
        return anchor->emitOpError(
            "failed to lower uniform fixed-width address arithmetic");
      return *result;
    }
    if (!containsDynamicTrunc(expression)) {
      Value cached =
          active ? Value{} : findCachedExpression(expression, *inputs);
      return cached ? cached
                    : createMaterialExpr(expression, std::move(*inputs),
                                         /*cache=*/!active);
    }
    FailureOr<Value> result = materializeDynamicArithmetic(
        transaction, expression, rewriter.getI32Type(), candidates, !active);
    if (failed(result))
      return anchor->emitOpError(
          "failed to lower uniform dynamic address arithmetic");
    return *result;
  }

  static bool isU32Modulo(sym::ExprView view) {
    return view.getKind() == sym::ExprKind::Mod &&
           sym::getIntegerLiteralValue(view.getBinaryRhs()) ==
               (int64_t{1} << 32);
  }

  Value extendBufferOffset(Value base, Value offset) {
    std::optional<PtrType> pointerType = getWavePointerType(base.getType());
    Type offsetType = offset.getType();
    Type offsetElement = offsetType;
    if (auto simd = dyn_cast<SimdType>(offsetType))
      offsetElement = simd.getElementType();
    if (!pointerType ||
        !isa<waveamd::BufferAddressSpaceAttr>(pointerType->getAddressSpace()) ||
        !offsetElement.isInteger(32))
      return offset;
    Type indexType = rewriter.getIndexType();
    if (auto simd = dyn_cast<SimdType>(offsetType))
      indexType =
          SimdType::get(rewriter.getContext(), indexType, simd.getWidth());
    DictionaryAttr policy = rewriter.getDictionaryAttr(rewriter.getNamedAttr(
        "extension", CastExtensionPolicyAttr::get(rewriter.getContext(),
                                                  CastExtension::Zero)));
    return CastOp::create(rewriter, location, indexType, CastKind::IntConvert,
                          offset, policy);
  }

  Type getPointerOffsetType(Value base, Value offset) {
    Type type = base.getType();
    if (auto simd = dyn_cast<SimdType>(offset.getType()))
      if (!isa<SimdType>(type))
        type = SimdType::get(base.getContext(), type, simd.getWidth());
    return type;
  }

  Value createPointerOffset(Value base, Value offset, Type type,
                            sym::PredHandle active) {
    Value pointer = active ? Value{} : findCachedPointer(base, offset, type);
    if (!pointer) {
      pointer = PtrAddOp::create(rewriter, location, type, base, offset);
      if (!active)
        pointers.push_back({base, offset, type, pointer});
    }
    return pointer;
  }

  FailureOr<Value> appendPointerOffset(const MemoryTransaction &transaction,
                                       Value base, sym::ExprHandle expression,
                                       sym::PredHandle active, bool uniform) {
    FailureOr<Value> materialized =
        uniform ? materializeUniformAddressExpr(transaction, expression, active)
                : materializeExpr(transaction, expression, active);
    if (failed(materialized))
      return failure();
    Value offset = extendBufferOffset(base, *materialized);
    Type type = getPointerOffsetType(base, offset);
    return createPointerOffset(base, offset, type, active);
  }

  FailureOr<Value>
  materializeResidualPointer(const MemoryTransaction &transaction, Value base,
                             sym::ExprHandle residual, sym::PredHandle active) {
    std::optional<int64_t> literal = sym::getIntegerLiteralValue(residual);
    if (literal && *literal == 0)
      return base;
    std::optional<PtrType> pointerType = getWavePointerType(base.getType());
    if (pointerType &&
        isa<waveamd::BufferAddressSpaceAttr>(pointerType->getAddressSpace()) &&
        containsDynamicTrunc(residual)) {
      FailureOr<std::optional<BufferAddressFields>> fields =
          splitBufferAddressFields(transaction, residual);
      if (failed(fields))
        return failure();
      if (*fields) {
        FailureOr<Value> uniform = appendPointerOffset(
            transaction, base, (**fields).uniform, active, /*uniform=*/true);
        if (failed(uniform))
          return failure();
        return appendPointerOffset(transaction, *uniform, (**fields).lane,
                                   active, /*uniform=*/false);
      }
    }
    return appendPointerOffset(transaction, base, residual, active,
                               /*uniform=*/false);
  }

  Value addConstantOffset(Value base, int64_t constant) {
    if (constant == 0)
      return base;
    Value delta =
        ConstantOp::create(rewriter, location, rewriter.getIndexType(),
                           rewriter.getIndexAttr(constant));
    return PtrAddOp::create(rewriter, location, base.getType(), base, delta)
        .getResult();
  }

  FailureOr<Value> materialize(const MemoryTransaction &transaction,
                               const MemoryTransactionAddress &address,
                               sym::PredHandle active) {
    if (address.bases.empty())
      return failure();
    FailureOr<Value> selected = selectBase(transaction, address, active);
    if (failed(selected))
      return failure();
    FailureOr<Value> base = castBaseToUnit(*selected, address.unitBits, active);
    if (failed(base))
      return failure();
    SplitOffset split =
        findPreparedSplit(transaction, address.elementOffset, active);
    FailureOr<Value> common =
        materializeResidualPointer(transaction, *base, split.residual, active);
    if (failed(common))
      return failure();
    return addConstantOffset(*common, split.constant);
  }

  IRRewriter &rewriter;
  Operation *anchor;
  Location location;
  sym::Store &store;
  int64_t waveWidth;
  SmallVector<CachedExpr, 8> expressions;
  SmallVector<CachedBase, 2> selectedBases;
  SmallVector<CachedCast, 2> casts;
  SmallVector<CachedPointer, 8> pointers;
  SmallVector<PreparedOffset, 8> preparedOffsets;
};

MemoryTransactionAddressMaterializer::MemoryTransactionAddressMaterializer(
    IRRewriter &rewriter, Operation *anchor, Location location,
    sym::Store &store, int64_t waveWidth)
    : impl(std::make_unique<Impl>(rewriter, anchor, location, store,
                                  waveWidth)) {}

MemoryTransactionAddressMaterializer::~MemoryTransactionAddressMaterializer() =
    default;

FailureOr<Value> MemoryTransactionAddressMaterializer::materializeExpr(
    const MemoryTransaction &transaction, sym::ExprHandle expression,
    sym::PredHandle active) {
  return impl->materializeExpr(transaction, expression, active);
}

FailureOr<Value> MemoryTransactionAddressMaterializer::materializePredicate(
    const MemoryTransaction &transaction, sym::PredHandle predicate,
    sym::PredHandle active) {
  return impl->materializePredicate(transaction, predicate, active);
}

LogicalResult MemoryTransactionAddressMaterializer::prepare(
    const MemoryTransaction &transaction,
    const MemoryTransactionAddress &address) {
  return impl->prepare(transaction, address);
}

FailureOr<Value> MemoryTransactionAddressMaterializer::materialize(
    const MemoryTransaction &transaction,
    const MemoryTransactionAddress &address, sym::PredHandle active) {
  return impl->materialize(transaction, address, active);
}

FailureOr<std::optional<int64_t>>
mlir::wave::getMemoryPointerElementBits(Type type) {
  std::optional<PtrType> pointer = getWavePointerType(type);
  if (!pointer)
    return std::optional<int64_t>{};
  Type elementType = pointer->getElementType();
  if (!elementType)
    return std::optional<int64_t>{int64_t{8}};
  if (auto vector = dyn_cast<VectorType>(elementType)) {
    Type scalar = vector.getElementType();
    if (!scalar.isIntOrFloat())
      return std::optional<int64_t>{};
    std::optional<int64_t> bits =
        llvm::checkedMul(vector.getNumElements(),
                         static_cast<int64_t>(scalar.getIntOrFloatBitWidth()));
    return bits ? FailureOr<std::optional<int64_t>>(
                      std::optional<int64_t>{*bits})
                : FailureOr<std::optional<int64_t>>(failure());
  }
  if (!elementType.isIntOrFloat())
    return std::optional<int64_t>{};
  return std::optional<int64_t>{
      static_cast<int64_t>(elementType.getIntOrFloatBitWidth())};
}

namespace {

static FailureOr<std::optional<sym::ExprHandle>>
decodePointerOffset(sym::Store &store, Value value, indexing::IndexMap &map,
                    llvm::StringMap<Value> &reserved,
                    llvm::DenseMap<Value, StringRef> &names) {
  if (IndexExprOp index = value.getDefiningOp<IndexExprOp>()) {
    FailureOr<SymbolicOffset> decoded = getIndexExprSymbolicOffset(index);
    if (failed(decoded))
      return failure();
    FailureOr<sym::ExprHandle> imported =
        importOffset(store, *decoded, map, reserved, names);
    return failed(imported)
               ? FailureOr<std::optional<sym::ExprHandle>>(failure())
               : FailureOr<std::optional<sym::ExprHandle>>(
                     std::optional<sym::ExprHandle>{*imported});
  }
  std::optional<int64_t> literal = getConstantIntValue(value);
  if (!literal)
    return std::optional<sym::ExprHandle>{};
  FailureOr<sym::ExprHandle> constant = sym::composeExprInt(store, *literal);
  return failed(constant) ? FailureOr<std::optional<sym::ExprHandle>>(failure())
                          : FailureOr<std::optional<sym::ExprHandle>>(
                                std::optional<sym::ExprHandle>{*constant});
}

static FailureOr<bool>
accumulatePointerOffset(sym::Store &store, PtrAddOp add, MemoryAddress &address,
                        llvm::StringMap<Value> &reserved,
                        llvm::DenseMap<Value, StringRef> &names) {
  FailureOr<std::optional<int64_t>> bits =
      getMemoryPointerElementBits(add.getBase().getType());
  if (failed(bits))
    return failure();
  if (!*bits)
    return false;
  FailureOr<std::optional<sym::ExprHandle>> offset =
      decodePointerOffset(store, add.getOffset(), address.map, reserved, names);
  if (failed(offset))
    return failure();
  if (!*offset)
    return false;
  FailureOr<sym::ExprHandle> sum =
      scaleAndAdd(store, address.bitOffset, **offset, **bits);
  if (failed(sum))
    return failure();
  address.bitOffset = *sum;
  return true;
}

struct AlignedAddressProof {
  indexing::IndexMap map;
  sym::PredHandle rhsActive;
};

static FailureOr<AlignedAddressProof>
alignAddressProof(sym::Store &store, const MemoryAddress &lhs,
                  const MemoryAddress &rhs) {
  FailureOr<std::pair<indexing::IndexMap, SmallVector<sym::ExprSubstitution>>>
      aligned = alignInputs(store, lhs.map, rhs.map);
  if (failed(aligned))
    return failure();
  indexing::IndexMap rhsMap = rhs.map;
  rhsMap.exprs = {rhs.owner, rhs.bitOffset};
  FailureOr<indexing::IndexMap> pulled = indexing::pullback(
      store, rhsMap, aligned->first, aligned->second, "address_rhs");
  FailureOr<sym::PredHandle> concreteActive =
      materializePredicate(store, rhs.map, rhs.active);
  FailureOr<sym::PredHandle> rhsActive =
      failed(concreteActive)
          ? FailureOr<sym::PredHandle>(failure())
          : sym::substitutePred(store, *concreteActive, aligned->second);
  if (failed(pulled) || failed(rhsActive) || pulled->exprs.size() != 2)
    return failure();
  return AlignedAddressProof{std::move(*pulled), *rhsActive};
}

struct AddressDeltaGoals {
  std::array<sym::PredHandle, 2> guarded;
  std::array<sym::PredHandle, 1> activity;
};

static FailureOr<AddressDeltaGoals>
composeAddressDeltaGoals(sym::Store &store, const MemoryAddress &lhs,
                         const AlignedAddressProof &rhs, int64_t expectedBits) {
  FailureOr<sym::ExprHandle> expected =
      sym::composeExprInt(store, expectedBits);
  FailureOr<sym::ExprHandle> difference = sym::composeExprBinary(
      store, lhs.bitOffset, sym::ExprBinaryOp::Sub, rhs.map.exprs[1]);
  FailureOr<sym::PredHandle> owner =
      composeEqual(store, lhs.owner, rhs.map.exprs[0]);
  FailureOr<sym::PredHandle> delta =
      failed(difference) || failed(expected)
          ? FailureOr<sym::PredHandle>(failure())
          : composeEqual(store, *difference, *expected);
  FailureOr<sym::PredHandle> activity =
      composeEqual(store, sym::asExpr(lhs.active), sym::asExpr(rhs.rhsActive));
  if (failed(owner) || failed(delta) || failed(activity))
    return failure();
  return AddressDeltaGoals{{*owner, *delta}, {*activity}};
}

} // namespace

FailureOr<std::optional<MemoryAddress>>
mlir::wave::normalizeMemoryAddress(Value ptr, WaveDialect &dialect) {
  if (!isWavePointerLikeType(ptr.getType()))
    return std::optional<MemoryAddress>{};
  sym::Store &store = dialect.getSymbolStore();
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  FailureOr<sym::PredHandle> active = sym::composePredTrue(store);
  if (failed(zero) || failed(active))
    return failure();
  MemoryAddress address{{}, ptr, *zero, *zero, *active};
  llvm::StringMap<Value> reserved;
  llvm::DenseMap<Value, StringRef> names;
  if (PtrAddOp ptrAdd = ptr.getDefiningOp<PtrAddOp>()) {
    SmallVector<PtrAddOp> chain = collectPtrAddChain(ptrAdd);
    for (PtrAddOp add : llvm::reverse(chain)) {
      FailureOr<bool> accumulated =
          accumulatePointerOffset(store, add, address, reserved, names);
      if (failed(accumulated))
        return failure();
      if (!*accumulated)
        return std::optional<MemoryAddress>{};
    }
    address.base = chain.back().getBase();
  }
  address.map.exprs = {address.owner, address.bitOffset};
  return std::optional<MemoryAddress>{std::move(address)};
}

FailureOr<std::optional<CheckedIndexExpr>>
mlir::wave::getMemoryAddressElementOffset(WaveDialect &dialect,
                                          const MemoryAddress &address,
                                          int64_t elementBits) {
  if (elementBits <= 0)
    return failure();
  sym::Store &store = dialect.getSymbolStore();
  sym::PredHandle inactive = sym::composePredNot(store, address.active);
  indexing::IndexMap proofMap = address.map;
  proofMap.requirements.clear();
  if (failed(appendGuardedPredicates(store, inactive, address.map.requirements,
                                     proofMap.requirements,
                                     /*unique=*/true)))
    return failure();
  std::array<sym::PredHandle, 1> active{address.active};
  FailureOr<sym::ExactDivideResult> divided = indexing::tryExactDivide(
      store, proofMap, address.bitOffset, elementBits, active);
  if (failed(divided))
    return failure();
  if (divided->status != sym::ExactDivideStatus::Proven)
    return std::optional<CheckedIndexExpr>{};
  indexing::IndexMap map = address.map;
  map.exprs = {divided->quotient};
  return std::optional<CheckedIndexExpr>{
      CheckedIndexExpr{std::move(map), divided->quotient}};
}

FailureOr<bool> mlir::wave::proveMemoryAddressElementDelta(
    WaveDialect &dialect, const MemoryAddress &lhs, const MemoryAddress &rhs,
    int64_t expectedElements, int64_t elementBits) {
  if (lhs.base != rhs.base)
    return false;
  std::optional<int64_t> expectedBits =
      elementBits > 0 ? llvm::checkedMul(expectedElements, elementBits)
                      : std::nullopt;
  if (!expectedBits)
    return failure();
  sym::Store &store = dialect.getSymbolStore();
  FailureOr<AlignedAddressProof> aligned = alignAddressProof(store, lhs, rhs);
  if (failed(aligned))
    return failure();
  FailureOr<AddressDeltaGoals> goals =
      composeAddressDeltaGoals(store, lhs, *aligned, *expectedBits);
  if (failed(goals))
    return failure();
  return proveGuardedMemoryAddress(store, aligned->map, lhs.active,
                                   goals->guarded, goals->activity);
}

namespace {

static const indexing::IndexMap::Input *
findTransactionInput(const indexing::IndexMap &map, sym::ExprHandle variable) {
  auto found = llvm::find_if(map.inputs, [&](const auto &input) {
    return input.variable == variable;
  });
  return found == map.inputs.end() ? nullptr : &*found;
}

static FailureOr<sym::ExprHandle>
freshTransactionCoordinate(sym::Store &store, const indexing::IndexMap &map,
                           StringRef scope, sym::ExprHandle source) {
  StringRef sourceName = sym::ExprView(source).getSymbolName();
  if (scope.empty() || sourceName.empty())
    return failure();
  std::string stem = (Twine(scope) + "_" + sourceName).str();
  std::string name = stem;
  for (unsigned suffix = 0;
       llvm::any_of(map.inputs,
                    [&](const auto &input) {
                      return sym::ExprView(input.variable).getSymbolName() ==
                             name;
                    });
       ++suffix)
    name = (Twine(stem) + "_" + Twine(suffix + 1)).str();
  return sym::composeExprSym(store, name);
}

static FailureOr<sym::ExprHandle> composeIntBinary(sym::Store &store,
                                                   sym::ExprHandle lhs,
                                                   sym::ExprBinaryOp operation,
                                                   int64_t rhs) {
  FailureOr<sym::ExprHandle> value = sym::composeExprInt(store, rhs);
  return failed(value) ? FailureOr<sym::ExprHandle>(failure())
                       : sym::composeExprBinary(store, lhs, operation, *value);
}

static FailureOr<sym::ExprHandle>
composeElementOffset(sym::Store &store, sym::ExprHandle bitOffset,
                     int64_t elementBits) {
  FailureOr<sym::ExprHandle> divisor = sym::composeExprInt(store, elementBits);
  FailureOr<sym::ExprHandle> ratio =
      failed(divisor) ? FailureOr<sym::ExprHandle>(failure())
                      : sym::composeExprBinary(
                            store, bitOffset, sym::ExprBinaryOp::Div, *divisor);
  return failed(ratio) ? FailureOr<sym::ExprHandle>(failure())
                       : sym::composeExprFloor(store, *ratio);
}

struct ScaledModulo {
  int64_t scale;
  sym::ExprHandle wrapped, modulus;
};

static std::optional<ScaledModulo>
matchScaledModulo(sym::ExprHandle expression) {
  sym::ExprView scaled(expression);
  int64_t scale = 1;
  sym::ExprHandle modulo = expression;
  if (scaled.getKind() == sym::ExprKind::Mul) {
    std::optional<int64_t> coefficient =
        sym::getIntegerLiteralValue(scaled.getMulCoefficient());
    if (!coefficient || *coefficient <= 0 || scaled.getMulFactorCount() != 1)
      return std::nullopt;
    sym::MulFactor factor = scaled.getMulFactor(0);
    if (factor.exponent != 1)
      return std::nullopt;
    scale = *coefficient;
    modulo = factor.base;
  }
  sym::ExprView wrapped(modulo);
  if (wrapped.getKind() != sym::ExprKind::Mod)
    return std::nullopt;
  return ScaledModulo{scale, modulo, wrapped.getBinaryRhs()};
}

static LogicalResult addTransactionGoal(sym::Store &store,
                                        SmallVectorImpl<sym::PredHandle> &goals,
                                        sym::ExprHandle lhs,
                                        sym::PredCmpOp operation,
                                        sym::ExprHandle rhs) {
  goals.push_back(sym::composePredCmp(store, lhs, operation, rhs));
  return success();
}

static FailureOr<indexing::IndexMap>
pullbackTransactionAt(sym::Store &store, const indexing::IndexMap &source,
                      const indexing::IndexMap &domain,
                      ArrayRef<sym::ExprSubstitution> fixed, StringRef scope) {
  SmallVector<sym::ExprSubstitution> substitutions;
  for (const auto &input : source.inputs) {
    if (llvm::any_of(source.definitions, [&](const auto &definition) {
          return definition.target == input.variable;
        }))
      continue;
    auto selected = llvm::find_if(fixed, [&](const auto &substitution) {
      return substitution.target == input.variable;
    });
    substitutions.push_back({input.variable, selected == fixed.end()
                                                 ? input.variable
                                                 : selected->replacement});
  }
  return indexing::pullback(store, source, domain, substitutions, scope);
}

static LogicalResult mergeTransactionInputs(indexing::IndexMap &target,
                                            const indexing::IndexMap &source) {
  for (const indexing::IndexMap::Input &input : source.inputs) {
    auto existing = llvm::find_if(target.inputs, [&](const auto &candidate) {
      return candidate.variable == input.variable;
    });
    if (existing != target.inputs.end()) {
      if (existing->extent != input.extent || existing->value != input.value ||
          existing->kind != input.kind)
        return failure();
      existing->materializable |= input.materializable;
    } else {
      target.inputs.push_back(input);
    }
  }
  return success();
}

static LogicalResult
mergeTransactionDefinitions(indexing::IndexMap &target,
                            const indexing::IndexMap &source) {
  for (const sym::ExprSubstitution &definition : source.definitions) {
    auto existing = llvm::find_if(target.definitions, [&](const auto &entry) {
      return entry.target == definition.target;
    });
    if (existing != target.definitions.end() &&
        !(existing->replacement == definition.replacement))
      return failure();
    if (existing == target.definitions.end())
      target.definitions.push_back(definition);
  }
  return success();
}

static LogicalResult mergeTransactionMap(indexing::IndexMap &target,
                                         const indexing::IndexMap &source) {
  if (failed(mergeTransactionInputs(target, source)))
    return failure();
  for (sym::PredHandle fact : source.facts)
    appendUnique(target.facts, fact);
  for (sym::PredHandle requirement : source.requirements)
    appendUnique(target.requirements, requirement);
  return mergeTransactionDefinitions(target, source);
}

// A layout may evaluate an access map at a different item or slot. Facts that
// materialize to the execution-point fact are already available; only facts
// changed by the pullback are induced domain obligations.
static LogicalResult
requirePulledBackTransactionDomain(sym::Store &store, indexing::IndexMap &map,
                                   const indexing::IndexMap &executionPoint) {
  SmallVector<sym::PredHandle> executionFacts;
  executionFacts.reserve(executionPoint.facts.size());
  for (sym::PredHandle fact : executionPoint.facts) {
    FailureOr<sym::PredHandle> material =
        materializePredicate(store, executionPoint, fact);
    if (failed(material))
      return failure();
    appendUnique(executionFacts, *material);
  }
  for (sym::PredHandle fact : map.facts) {
    FailureOr<sym::PredHandle> material =
        materializePredicate(store, map, fact);
    if (failed(material))
      return failure();
    if (!llvm::is_contained(executionFacts, *material))
      appendUnique(map.requirements, *material);
  }
  map.facts.clear();
  return success();
}

static const indexing::IndexMap::Input *
getProjectionExecution(const MemoryTransaction &transaction,
                       const MemoryTransactionProjection &projection) {
  const indexing::IndexMap::Input *execution =
      findTransactionInput(transaction.map, projection.executionItem);
  if (!execution || execution->kind != SymbolicOffsetBindingKind::Lane ||
      findTransactionInput(transaction.map, projection.readFirstParameter) ||
      transaction.addresses.size() != 1)
    return nullptr;
  return execution;
}

struct TransactionProjectionMaps {
  indexing::IndexMap material;
  indexing::IndexMap proof;
};

static TransactionProjectionMaps
createProjectionMaps(const MemoryTransaction &transaction,
                     const MemoryTransactionProjection &projection,
                     const indexing::IndexMap::Input &execution) {
  indexing::IndexMap material = transaction.map;
  material.inputs.push_back({projection.readFirstParameter,
                             execution.extent,
                             {},
                             SymbolicOffsetBindingKind::Uniform});
  indexing::IndexMap proof = material;
  proof.definitions.push_back(
      {projection.readFirstParameter, projection.readFirstOrigin});
  return {std::move(material), std::move(proof)};
}

static SmallVector<sym::ExprSubstitution, 8>
collectProjectionSubstitutions(const MemoryTransaction &transaction,
                               const MemoryTransactionProjection &projection,
                               sym::ExprHandle zero) {
  SmallVector<sym::ExprSubstitution, 8> substitutions;
  for (const indexing::IndexMap::Input &input : transaction.map.inputs) {
    // Read-first changes concrete lane bindings, not the internal coordinates
    // or definitions introduced while composing the transaction map.
    if (input.kind != SymbolicOffsetBindingKind::Lane || !input.value ||
        llvm::any_of(transaction.map.definitions, [&](const auto &definition) {
          return definition.target == input.variable;
        }))
      continue;
    substitutions.push_back(
        {input.variable, input.variable == projection.executionItem
                             ? projection.readFirstParameter
                             : zero});
  }
  return substitutions;
}

static FailureOr<sym::ExprHandle>
projectTransactionExpr(sym::Store &store, sym::ExprHandle expression,
                       ArrayRef<sym::ExprSubstitution> substitutions) {
  FailureOr<sym::ExprHandle> projected =
      sym::substituteExpr(store, expression, substitutions);
  if (succeeded(projected))
    projected = sym::simplifyExpr(store, *projected);
  return projected;
}

static FailureOr<std::array<sym::ExprHandle, 4>>
projectTransactionTuple(sym::Store &store,
                        ArrayRef<sym::ExprSubstitution> substitutions,
                        const std::array<sym::ExprHandle, 4> &tuple) {
  std::array<sym::ExprHandle, 4> projected;
  for (auto [source, target] : llvm::zip(tuple, projected)) {
    FailureOr<sym::ExprHandle> value =
        projectTransactionExpr(store, source, substitutions);
    if (failed(value))
      return failure();
    target = *value;
  }
  return projected;
}

static FailureOr<SmallVector<sym::PredHandle, 8>>
projectTransactionFacts(sym::Store &store,
                        ArrayRef<sym::ExprSubstitution> substitutions,
                        ArrayRef<sym::PredHandle> facts) {
  SmallVector<sym::PredHandle, 8> projectedFacts;
  for (sym::PredHandle fact : facts) {
    FailureOr<sym::PredHandle> projected =
        sym::substitutePred(store, fact, substitutions);
    FailureOr<sym::ExprHandle> simplified =
        failed(projected) ? FailureOr<sym::ExprHandle>(failure())
                          : sym::simplifyExpr(store, sym::asExpr(*projected));
    std::optional<sym::PredHandle> predicate =
        failed(simplified) ? std::nullopt : sym::asPred(*simplified);
    if (!predicate)
      return failure();
    appendUnique(projectedFacts, *predicate);
  }
  return projectedFacts;
}

static LogicalResult
appendProjectionGoals(sym::Store &store, ArrayRef<sym::ExprHandle> source,
                      ArrayRef<sym::ExprHandle> projected, sym::ExprHandle zero,
                      sym::ExprHandle one, ArrayRef<sym::PredHandle> facts,
                      SmallVectorImpl<sym::PredHandle> &goals) {
  for (auto [lhs, rhs] : llvm::zip(source, projected))
    if (failed(addTransactionGoal(store, goals, lhs, sym::PredCmpOp::Eq, rhs)))
      return failure();
  if (failed(addTransactionGoal(store, goals, projected[0], sym::PredCmpOp::Eq,
                                zero)) ||
      failed(addTransactionGoal(store, goals, projected[2], sym::PredCmpOp::Eq,
                                one)))
    return failure();
  for (sym::PredHandle fact : facts)
    appendUnique(goals, fact);
  return success();
}

static void commitTransactionProjection(
    MemoryTransaction &transaction, indexing::IndexMap materialMap,
    ArrayRef<sym::ExprHandle> projected, sym::ExprHandle elementOffset,
    ArrayRef<sym::PredHandle> projectedFacts) {
  transaction.map = std::move(materialMap);
  for (sym::PredHandle fact : projectedFacts)
    appendUnique(transaction.map.facts, fact);
  MemoryTransactionAddress &address = transaction.addresses.front();
  address.owner = projected[0];
  address.baseSelector = projected[1];
  transaction.activity = projected[2];
  address.bitOffset = projected[3];
  address.elementOffset = elementOffset;
}

static FailureOr<bool>
checkTransactionProjection(sym::Store &store, const indexing::IndexMap &map,
                           ArrayRef<sym::PredHandle> goals,
                           indexing::CheckMemo &memo) {
  FailureOr<sym::CheckResult> checked =
      indexing::check(store, map, goals, memo);
  return failed(checked) ? FailureOr<bool>(failure())
                         : FailureOr<bool>(*checked == sym::CheckResult::True);
}

static FailureOr<bool>
projectTransaction(MemoryTransaction &transaction,
                   const MemoryTransactionProjection &projection,
                   sym::Store &store, indexing::CheckMemo &memo) {
  const indexing::IndexMap::Input *execution =
      getProjectionExecution(transaction, projection);
  if (!execution)
    return failure();
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  FailureOr<sym::ExprHandle> one = sym::composeExprInt(store, 1);
  if (failed(zero) || failed(one))
    return failure();
  TransactionProjectionMaps maps =
      createProjectionMaps(transaction, projection, *execution);
  SmallVector<sym::ExprSubstitution, 8> substitutions =
      collectProjectionSubstitutions(transaction, projection, *zero);
  MemoryTransactionAddress &address = transaction.addresses.front();
  std::array<sym::ExprHandle, 4> tuple{address.owner, address.baseSelector,
                                       transaction.activity, address.bitOffset};
  FailureOr<std::array<sym::ExprHandle, 4>> projected =
      projectTransactionTuple(store, substitutions, tuple);
  FailureOr<sym::ExprHandle> elementOffset =
      projectTransactionExpr(store, address.elementOffset, substitutions);
  FailureOr<SmallVector<sym::PredHandle, 8>> projectedFacts =
      projectTransactionFacts(store, substitutions, transaction.map.facts);
  if (failed(projected) || failed(elementOffset) || failed(projectedFacts))
    return failure();
  SmallVector<sym::PredHandle, 8> goals;
  if (failed(appendProjectionGoals(store, tuple, *projected, *zero, *one,
                                   *projectedFacts, goals)))
    return failure();
  FailureOr<bool> checked =
      checkTransactionProjection(store, maps.proof, goals, memo);
  if (failed(checked))
    return failure();
  if (!*checked)
    return false;
  commitTransactionProjection(transaction, std::move(maps.material), *projected,
                              *elementOffset, *projectedFacts);
  return true;
}

struct TransactionWindowExpressions {
  sym::ExprHandle zero;
  sym::ExprHandle byte;
  sym::ExprHandle reconstructed;
  sym::ExprHandle last;
  sym::ExprHandle reconstructedLast;
  sym::PredHandle active;
};

static FailureOr<TransactionWindowExpressions>
composeTransactionWindowExpressions(const MemoryTransaction &transaction,
                                    int64_t bytes, sym::Store &store) {
  const MemoryTransactionAddress &address = transaction.addresses.front();
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  if (failed(zero))
    return failure();
  FailureOr<sym::ExprHandle> byte =
      composeElementOffset(store, address.bitOffset, 8);
  if (failed(byte))
    return failure();
  FailureOr<sym::ExprHandle> reconstructed =
      composeIntBinary(store, *byte, sym::ExprBinaryOp::Mul, 8);
  if (failed(reconstructed))
    return failure();
  FailureOr<sym::ExprHandle> last =
      composeIntBinary(store, *byte, sym::ExprBinaryOp::Add, bytes - 1);
  if (failed(last))
    return failure();
  FailureOr<sym::ExprHandle> modulus =
      sym::composeExprInt(store, int64_t{1} << 32);
  if (failed(modulus))
    return failure();
  FailureOr<sym::ExprHandle> reconstructedLast =
      sym::composeExprBinary(store, *last, sym::ExprBinaryOp::Mod, *modulus);
  FailureOr<sym::PredHandle> active = sym::composePredCmp(
      store, transaction.activity, sym::PredCmpOp::Ne, *zero);
  if (failed(reconstructedLast) || failed(active))
    return failure();
  return TransactionWindowExpressions{
      *zero, *byte, *reconstructed, *last, *reconstructedLast, *active};
}

static LogicalResult
appendTransactionWindowGoals(sym::Store &store,
                             const MemoryTransactionAddress &address,
                             const TransactionWindowExpressions &expressions,
                             SmallVectorImpl<sym::PredHandle> &goals) {
  if (failed(addTransactionGoal(store, goals, address.bitOffset,
                                sym::PredCmpOp::Eq,
                                expressions.reconstructed)) ||
      failed(addTransactionGoal(store, goals, expressions.byte,
                                sym::PredCmpOp::Ge, expressions.zero)))
    return failure();
  // A transaction window is representable exactly when its last byte is
  // unchanged by the canonical u32 address reconstruction.  This states the
  // no-wrap contract in the same modular algebra as the address map.
  return addTransactionGoal(store, goals, expressions.reconstructedLast,
                            sym::PredCmpOp::Eq, expressions.last);
}

static FailureOr<bool>
checkTransactionWindow(const MemoryTransaction &transaction, int64_t bytes,
                       sym::Store &store, indexing::CheckMemo &memo) {
  if (bytes <= 0 || transaction.addresses.size() != 1)
    return failure();
  const MemoryTransactionAddress &address = transaction.addresses.front();
  if (address.unitBits <= 0 || address.unitBits % 8)
    return failure();
  FailureOr<TransactionWindowExpressions> expressions =
      composeTransactionWindowExpressions(transaction, bytes, store);
  if (failed(expressions))
    return failure();
  SmallVector<sym::PredHandle, 2> goals;
  if (failed(appendTransactionWindowGoals(store, address, *expressions, goals)))
    return failure();
  indexing::IndexMap activeMap = transaction.map;
  appendUnique(activeMap.facts, expressions->active);
  FailureOr<sym::CheckResult> checked =
      indexing::check(store, activeMap, goals, memo);
  return failed(checked) ? FailureOr<bool>(failure())
                         : FailureOr<bool>(*checked == sym::CheckResult::True);
}

class MemoryTransactionPlanner {
public:
  MemoryTransactionPlanner(sym::Store &store, MemoryTransactionRequest request,
                           indexing::CheckMemo &memo)
      : store(store), request(std::move(request)), memo(memo),
        access(this->request.access), layout(this->request.layout) {}

  FailureOr<std::optional<MemoryTransaction>> plan() {
    FailureOr<bool> initialized = initializePlan();
    if (failed(initialized))
      return failure();
    if (!*initialized)
      return std::optional<MemoryTransaction>{};
    if (failed(composePlan()))
      return failure();
    FailureOr<bool> checked = proveByteAddress();
    if (failed(checked))
      return failure();
    if (!*checked)
      return std::optional<MemoryTransaction>{};
    FailureOr<MemoryTransaction> result = materializeResult();
    if (failed(result))
      return failure();
    FailureOr<bool> finalized = finalizeResult(*result);
    if (failed(finalized))
      return failure();
    return *finalized
               ? FailureOr<std::optional<MemoryTransaction>>(
                     std::optional<MemoryTransaction>{std::move(*result)})
               : FailureOr<std::optional<MemoryTransaction>>(
                     std::optional<MemoryTransaction>{});
  }

private:
  LogicalResult validateRequest() {
    if (access.bases.empty() || access.slotCount <= 0 ||
        access.elementBits <= 0 || layout.width <= 0)
      return failure();
    groupCount =
        layout.groupCount ? layout.groupCount : access.slotCount / layout.width;
    if (groupCount <= 0 || groupCount * layout.width > access.slotCount)
      return failure();
    return success();
  }

  LogicalResult createCoordinates() {
    FailureOr<sym::ExprHandle> createdGroup =
        layout.group ? FailureOr<sym::ExprHandle>(layout.group)
                     : sym::composeExprSym(store, "group");
    FailureOr<sym::ExprHandle> createdWithin =
        layout.within ? FailureOr<sym::ExprHandle>(layout.within)
                      : sym::composeExprSym(store, "within");
    FailureOr<sym::ExprHandle> createdZero = sym::composeExprInt(store, 0);
    if (failed(createdGroup) || failed(createdWithin) || failed(createdZero))
      return failure();
    group = *createdGroup;
    within = *createdWithin;
    zero = *createdZero;
    return success();
  }

  LogicalResult
  renameCoordinate(indexing::IndexMap &coordinateNames,
                   sym::ExprHandle &coordinate,
                   SmallVectorImpl<sym::ExprSubstitution> &renames) {
    sym::ExprHandle requested = coordinate;
    if (findTransactionInput(coordinateNames, requested)) {
      FailureOr<sym::ExprHandle> fresh = freshTransactionCoordinate(
          store, coordinateNames, "transaction", requested);
      if (failed(fresh))
        return failure();
      coordinate = *fresh;
      renames.push_back({requested, coordinate});
    }
    coordinateNames.inputs.push_back({coordinate, std::nullopt, {}});
    return success();
  }

  LogicalResult
  remapLayoutField(sym::ExprHandle &expression,
                   ArrayRef<sym::ExprSubstitution> coordinateRenames) {
    if (!expression || coordinateRenames.empty())
      return success();
    FailureOr<sym::ExprHandle> remapped =
        sym::substituteExpr(store, expression, coordinateRenames);
    if (failed(remapped))
      return failure();
    expression = *remapped;
    return success();
  }

  LogicalResult
  remapLayoutCoordinates(ArrayRef<sym::ExprSubstitution> coordinateRenames) {
    if (failed(remapLayoutField(layout.accessItem, coordinateRenames)))
      return failure();
    if (failed(remapLayoutField(layout.pointItem, coordinateRenames)))
      return failure();
    if (failed(remapLayoutField(layout.slot, coordinateRenames)))
      return failure();
    if (failed(remapLayoutField(layout.originItem, coordinateRenames)))
      return failure();
    if (failed(remapLayoutField(layout.originSlot, coordinateRenames)))
      return failure();
    if (failed(remapLayoutField(layout.displacement, coordinateRenames)))
      return failure();
    return remapLayoutField(layout.verifiedBitOffset, coordinateRenames);
  }

  LogicalResult composeSlot() {
    FailureOr<sym::ExprHandle> groupBase =
        composeIntBinary(store, group, sym::ExprBinaryOp::Mul, layout.width);
    if (layout.slot) {
      slot = layout.slot;
      return success();
    }
    if (failed(groupBase))
      return failure();
    FailureOr<sym::ExprHandle> created = sym::composeExprBinary(
        store, *groupBase, sym::ExprBinaryOp::Add, within);
    if (failed(created))
      return failure();
    slot = *created;
    return success();
  }

  LogicalResult initializeCoordinates() {
    if (failed(createCoordinates()))
      return failure();
    indexing::IndexMap coordinateNames = access.address.map;
    SmallVector<sym::ExprSubstitution, 2> coordinateRenames;
    if (failed(renameCoordinate(coordinateNames, group, coordinateRenames)))
      return failure();
    if (failed(renameCoordinate(coordinateNames, within, coordinateRenames)))
      return failure();
    if (failed(remapLayoutCoordinates(coordinateRenames)))
      return failure();
    return composeSlot();
  }

  FailureOr<bool> initializeItemLayout() {
    item = access.item.value_or(sym::ExprHandle{});
    if ((layout.accessItem || layout.pointItem || layout.originItem) && !item)
      return false;
    layout.accessItem = layout.accessItem ? layout.accessItem : item;
    layout.pointItem = layout.pointItem ? layout.pointItem : item;
    layout.originItem = layout.originItem ? layout.originItem : item;
    if (layout.originSlot)
      return true;
    std::array<sym::ExprSubstitution, 1> atOrigin{
        sym::ExprSubstitution{within, zero}};
    FailureOr<sym::ExprHandle> origin =
        sym::substituteExpr(store, slot, atOrigin);
    if (failed(origin))
      return failure();
    layout.originSlot = *origin;
    return true;
  }

  void addCoordinate(
      sym::ExprHandle variable, std::optional<int64_t> extent, Value value = {},
      SymbolicOffsetBindingKind kind = SymbolicOffsetBindingKind::Lane) {
    if (variable && !findTransactionInput(domain, variable))
      domain.inputs.push_back({variable, extent, value, kind});
  }

  bool isAccessCoordinate(sym::ExprHandle variable) const {
    return variable == access.block || variable == access.slot ||
           (item && variable == item);
  }

  LogicalResult createDomain() {
    const indexing::IndexMap::Input *blockInput =
        findTransactionInput(access.address.map, access.block);
    addCoordinate(access.block, blockInput ? blockInput->extent : std::nullopt,
                  blockInput ? blockInput->value : Value{},
                  blockInput ? blockInput->kind
                             : SymbolicOffsetBindingKind::Lane);
    if (item) {
      const indexing::IndexMap::Input *itemInput =
          findTransactionInput(access.address.map, item);
      if (!itemInput)
        return failure();
      itemExtent = itemInput->extent;
      addCoordinate(item, itemExtent, access.itemValue, itemInput->kind);
    }
    addCoordinate(group, groupCount, {}, SymbolicOffsetBindingKind::Uniform);
    addCoordinate(within, layout.width, {}, SymbolicOffsetBindingKind::Uniform);
    for (const indexing::IndexMap::Input &input : access.address.map.inputs)
      if (!isAccessCoordinate(input.variable) &&
          !findTransactionInput(domain, input.variable))
        domain.inputs.push_back(input);
    return success();
  }

  LogicalResult retainExecutingItemFacts() {
    if (!item || layout.accessItem == item)
      return success();
    StringRef slotName = sym::ExprView(access.slot).getSymbolName();
    if (slotName.empty())
      return failure();
    for (sym::PredHandle fact : access.address.map.facts) {
      FailureOr<sym::ExprHandle> concrete =
          indexing::materialize(store, access.address.map, sym::asExpr(fact));
      std::optional<sym::PredHandle> predicate =
          failed(concrete) ? std::nullopt : sym::asPred(*concrete);
      if (!predicate)
        return failure();
      bool slotDependent = false;
      sym::walkSymbolNames(*concrete, [&](StringRef name) {
        slotDependent |= name == slotName;
      });
      if (!slotDependent)
        appendUnique(domain.facts, *predicate);
    }
    return success();
  }

  SmallVector<sym::ExprSubstitution> mapAccess(sym::ExprHandle mappedItem,
                                               sym::ExprHandle mappedSlot) {
    SmallVector<sym::ExprSubstitution> substitutions;
    substitutions.reserve(access.address.map.inputs.size());
    for (const indexing::IndexMap::Input &input : access.address.map.inputs) {
      if (llvm::any_of(access.address.map.definitions,
                       [&](const auto &definition) {
                         return definition.target == input.variable;
                       }))
        continue;
      sym::ExprHandle replacement = input.variable;
      if (input.variable == access.slot)
        replacement = mappedSlot;
      else if (item && input.variable == item)
        replacement = mappedItem;
      substitutions.push_back({input.variable, replacement});
    }
    return substitutions;
  }

  struct ProofOrigin {
    sym::ExprHandle item;
    sym::ExprHandle slot;
  };

  FailureOr<ProofOrigin> getProofOrigin() {
    ProofOrigin origin{layout.originItem, layout.originSlot};
    if (!item || !layout.pointItem)
      return origin;
    std::array<sym::ExprSubstitution, 1> supplier{
        sym::ExprSubstitution{item, layout.pointItem}};
    FailureOr<sym::ExprHandle> mappedItem =
        sym::substituteExpr(store, origin.item, supplier);
    FailureOr<sym::ExprHandle> mappedSlot =
        sym::substituteExpr(store, origin.slot, supplier);
    if (failed(mappedItem) || failed(mappedSlot))
      return failure();
    return ProofOrigin{*mappedItem, *mappedSlot};
  }

  LogicalResult transportRemappedPointFacts() {
    if (!item || layout.accessItem == item)
      return success();
    // The execution point supplies facts. A remapped logical point must prove
    // every additional fact induced by the ownership permutation; retaining
    // those facts as assumptions would make an out-of-domain remap circular.
    SmallVector<sym::PredHandle> inducedFacts;
    for (sym::PredHandle fact : points.facts)
      if (!llvm::is_contained(domain.facts, fact))
        appendUnique(inducedFacts, fact);
    points.facts = domain.facts;
    for (sym::PredHandle fact : inducedFacts)
      appendUnique(points.requirements, fact);
    return success();
  }

  LogicalResult ensureDisplacement() {
    if (layout.displacement)
      return success();
    FailureOr<sym::ExprHandle> displacement = composeIntBinary(
        store, within, sym::ExprBinaryOp::Mul, access.elementBits);
    if (failed(displacement))
      return failure();
    layout.displacement = *displacement;
    return success();
  }

  LogicalResult pullbackAccessMaps() {
    FailureOr<ProofOrigin> proofOrigin = getProofOrigin();
    if (failed(proofOrigin))
      return failure();
    SmallVector<sym::ExprSubstitution> pointSubstitutions =
        mapAccess(layout.accessItem, slot);
    SmallVector<sym::ExprSubstitution> proofSubstitutions =
        mapAccess(proofOrigin->item, proofOrigin->slot);
    SmallVector<sym::ExprSubstitution> materialSubstitutions =
        mapAccess(layout.originItem, layout.originSlot);
    indexing::IndexMap addressMap = access.address.map;
    addressMap.exprs = {access.address.owner, access.baseSelector,
                        access.activity, access.address.bitOffset};
    FailureOr<indexing::IndexMap> pointMap = indexing::pullback(
        store, addressMap, domain, pointSubstitutions, "point");
    FailureOr<indexing::IndexMap> proofMap = indexing::pullback(
        store, addressMap, domain, proofSubstitutions, "proof_origin");
    FailureOr<indexing::IndexMap> materialMap = indexing::pullback(
        store, addressMap, domain, materialSubstitutions, "material_origin");
    if (failed(pointMap) || failed(proofMap) || failed(materialMap) ||
        pointMap->exprs.size() != 4 || proofMap->exprs.size() != 4 ||
        materialMap->exprs.size() != 4)
      return failure();
    points = std::move(*pointMap);
    proofOrigins = std::move(*proofMap);
    materialOrigin = std::move(*materialMap);
    if (failed(transportRemappedPointFacts()))
      return failure();
    return ensureDisplacement();
  }

  LogicalResult createMaterialProofMap() {
    SmallVector<sym::ExprSubstitution, 1> materialProjection{
        {access.block, zero}};
    FailureOr<indexing::IndexMap> material = pullbackTransactionAt(
        store, materialOrigin, domain, materialProjection, "material");
    if (failed(material) || proofOrigins.exprs.size() != 4 ||
        material->exprs.size() != 4)
      return failure();
    materialMap = std::move(*material);
    if (failed(
            requirePulledBackTransactionDomain(store, proofOrigins, points)) ||
        failed(requirePulledBackTransactionDomain(store, materialMap, points)))
      return failure();
    proofMap = points;
    proofMap.exprs.clear();
    if (failed(mergeTransactionMap(proofMap, proofOrigins)))
      return failure();
    return mergeTransactionMap(proofMap, materialMap);
  }

  bool proveCyclicBounds(sym::ExprHandle inner, sym::ExprHandle modulus) {
    FailureOr<sym::PredHandle> nonnegative =
        sym::composePredCmp(store, inner, sym::PredCmpOp::Ge, zero);
    FailureOr<sym::PredHandle> belowModulus =
        sym::composePredCmp(store, inner, sym::PredCmpOp::Lt, modulus);
    FailureOr<sym::CheckResult> provenNonnegative =
        failed(nonnegative)
            ? FailureOr<sym::CheckResult>(failure())
            : indexing::check(store, proofMap, {*nonnegative}, memo);
    FailureOr<sym::CheckResult> provenBelowModulus =
        failed(belowModulus)
            ? FailureOr<sym::CheckResult>(failure())
            : indexing::check(store, proofMap, {*belowModulus}, memo);
    return succeeded(provenNonnegative) && succeeded(provenBelowModulus) &&
           *provenNonnegative == sym::CheckResult::True &&
           *provenBelowModulus == sym::CheckResult::True;
  }

  std::optional<int64_t> getCyclicSpan(const ScaledModulo &cyclic) {
    std::optional<int64_t> transactionBits =
        llvm::checkedMul(layout.width, access.elementBits);
    if (cyclic.scale <= 0 || !transactionBits ||
        *transactionBits % cyclic.scale != 0)
      return std::nullopt;
    return *transactionBits / cyclic.scale;
  }

  FailureOr<std::optional<sym::ExprHandle>>
  getCyclicWindowWidth(const ScaledModulo &cyclic) {
    std::optional<int64_t> modulus =
        sym::getIntegerLiteralValue(cyclic.modulus);
    std::optional<int64_t> span = getCyclicSpan(cyclic);
    if (!modulus || *modulus <= 0 || !span || *span <= 0 ||
        *modulus % *span != 0)
      return std::optional<sym::ExprHandle>{};
    FailureOr<sym::ExprHandle> width = sym::composeExprInt(store, *span);
    if (failed(width))
      return failure();
    return std::optional<sym::ExprHandle>{*width};
  }

  static bool isProven(const FailureOr<sym::CheckResult> &result) {
    return succeeded(result) && *result == sym::CheckResult::True;
  }

  FailureOr<bool>
  proveCyclicWindowPredicates(const ScaledModulo &cyclic,
                              const sym::ExactDivideResult &displacement,
                              sym::ExprHandle width) {
    FailureOr<sym::ExprHandle> wrappedRemainder = sym::composeExprBinary(
        store, cyclic.wrapped, sym::ExprBinaryOp::Mod, width);
    FailureOr<sym::PredHandle> aligned =
        failed(wrappedRemainder)
            ? FailureOr<sym::PredHandle>(failure())
            : sym::composePredCmp(store, *wrappedRemainder, sym::PredCmpOp::Eq,
                                  zero);
    FailureOr<sym::PredHandle> nonnegative = sym::composePredCmp(
        store, displacement.quotient, sym::PredCmpOp::Ge, zero);
    FailureOr<sym::PredHandle> inRange = sym::composePredCmp(
        store, displacement.quotient, sym::PredCmpOp::Lt, width);
    if (failed(aligned) || failed(nonnegative) || failed(inRange))
      return failure();
    FailureOr<sym::CheckResult> provenAligned =
        indexing::check(store, proofMap, {*aligned}, memo);
    FailureOr<sym::CheckResult> provenNonnegative =
        indexing::check(store, proofMap, {*nonnegative}, memo);
    FailureOr<sym::CheckResult> provenInRange =
        indexing::check(store, proofMap, {*inRange}, memo);
    return isProven(provenAligned) && isProven(provenNonnegative) &&
           isProven(provenInRange);
  }

  FailureOr<bool>
  proveAlignedCyclicWindow(const ScaledModulo &cyclic,
                           const sym::ExactDivideResult &displacement) {
    FailureOr<std::optional<sym::ExprHandle>> width =
        getCyclicWindowWidth(cyclic);
    if (failed(width))
      return failure();
    if (!*width)
      return false;
    return proveCyclicWindowPredicates(cyclic, displacement, **width);
  }

  FailureOr<std::optional<sym::ExactDivideResult>>
  getCyclicDisplacement(const ScaledModulo &cyclic) {
    std::array<sym::ExprHandle, 1> expressions{layout.displacement};
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        createTransactionAnalysis(store, expressions, proofMap.facts);
    if (failed(analysis))
      return std::optional<sym::ExactDivideResult>{};
    FailureOr<sym::ExactDivideResult> displacement =
        (*analysis)->tryExactDivide(layout.displacement, cyclic.scale);
    if (failed(displacement) ||
        displacement->status != sym::ExactDivideStatus::Proven)
      return std::optional<sym::ExactDivideResult>{};
    return std::optional<sym::ExactDivideResult>{*displacement};
  }

  FailureOr<std::optional<sym::ExprHandle>>
  composeCyclicExpectedOffset(const ScaledModulo &cyclic) {
    FailureOr<std::optional<sym::ExactDivideResult>> displacement =
        getCyclicDisplacement(cyclic);
    if (failed(displacement))
      return failure();
    if (!*displacement)
      return std::optional<sym::ExprHandle>{};
    FailureOr<sym::ExprHandle> inner =
        sym::composeExprBinary(store, cyclic.wrapped, sym::ExprBinaryOp::Add,
                               (**displacement).quotient);
    bool noWrap = succeeded(inner) && proveCyclicBounds(*inner, cyclic.modulus);
    if (!noWrap) {
      FailureOr<bool> aligned =
          proveAlignedCyclicWindow(cyclic, **displacement);
      if (failed(aligned))
        return failure();
      noWrap = *aligned;
    }
    if (!noWrap)
      return std::optional<sym::ExprHandle>{};
    FailureOr<sym::ExprHandle> wrapped =
        failed(inner)
            ? FailureOr<sym::ExprHandle>(failure())
            : sym::composeExprBinary(store, *inner, sym::ExprBinaryOp::Mod,
                                     cyclic.modulus);
    FailureOr<sym::ExprHandle> expected =
        failed(wrapped)
            ? FailureOr<sym::ExprHandle>(failure())
            : composeIntBinary(store, *wrapped, sym::ExprBinaryOp::Mul,
                               cyclic.scale);
    if (failed(expected))
      return failure();
    return std::optional<sym::ExprHandle>{*expected};
  }

  LogicalResult composeProofExpressions() {
    proofBitOffset = layout.verifiedBitOffset ? layout.verifiedBitOffset
                                              : proofOrigins.exprs[3];
    materialBitOffset = layout.verifiedBitOffset ? layout.verifiedBitOffset
                                                 : materialMap.exprs[3];
    baseSelector = materialMap.exprs[1];
    transactionActivity = materialMap.exprs[2];
    FailureOr<sym::PredHandle> active = sym::composePredCmp(
        store, transactionActivity, sym::PredCmpOp::Ne, zero);
    FailureOr<sym::ExprHandle> expectedOffset = sym::composeExprBinary(
        store, proofBitOffset, sym::ExprBinaryOp::Add, layout.displacement);
    if (std::optional<ScaledModulo> cyclic =
            matchScaledModulo(proofBitOffset)) {
      FailureOr<std::optional<sym::ExprHandle>> cyclicExpected =
          composeCyclicExpectedOffset(*cyclic);
      if (failed(cyclicExpected))
        return failure();
      if (*cyclicExpected)
        expectedOffset = **cyclicExpected;
    }
    FailureOr<sym::ExprHandle> extent =
        itemExtent ? sym::composeExprInt(store, *itemExtent)
                   : FailureOr<sym::ExprHandle>(zero);
    if (failed(active) || failed(expectedOffset) || failed(extent))
      return failure();
    transactionActive = *active;
    expected = *expectedOffset;
    itemExtentExpr = *extent;
    return success();
  }

  LogicalResult appendAddressRelationGoals() {
    if (failed(addTransactionGoal(store, commonGoals, materialMap.exprs[0],
                                  sym::PredCmpOp::Eq, zero)))
      return failure();
    if (failed(addTransactionGoal(store, commonGoals, points.exprs[1],
                                  sym::PredCmpOp::Eq, proofOrigins.exprs[1])))
      return failure();
    if (failed(addTransactionGoal(store, commonGoals, proofOrigins.exprs[1],
                                  sym::PredCmpOp::Eq, materialMap.exprs[1])))
      return failure();
    if (failed(addTransactionGoal(store, commonGoals, points.exprs[0],
                                  sym::PredCmpOp::Eq, access.block)))
      return failure();
    return addTransactionGoal(store, commonGoals, proofOrigins.exprs[0],
                              sym::PredCmpOp::Eq, access.block);
  }

  bool isBufferAccess() {
    return llvm::all_of(access.bases, [](Value base) {
      std::optional<PtrType> pointer = getWavePointerType(base.getType());
      return pointer &&
             isa<waveamd::BufferAddressSpaceAttr>(pointer->getAddressSpace());
    });
  }

  LogicalResult appendByteAlignment(bool exact, sym::ExprHandle bits,
                                    sym::ExprHandle bytes) {
    if (exact)
      return success();
    FailureOr<sym::ExprHandle> reconstructed =
        composeIntBinary(store, bytes, sym::ExprBinaryOp::Mul, 8);
    if (failed(reconstructed))
      return failure();
    return addTransactionGoal(store, commonGoals, bits, sym::PredCmpOp::Eq,
                              *reconstructed);
  }

  LogicalResult appendWrappedByteEquality(sym::ExprHandle lhs,
                                          sym::ExprHandle rhs) {
    FailureOr<sym::ExprHandle> modulus =
        sym::composeExprInt(store, int64_t{1} << 32);
    FailureOr<sym::ExprHandle> difference =
        sym::composeExprBinary(store, lhs, sym::ExprBinaryOp::Sub, rhs);
    FailureOr<sym::ExprHandle> wrappedDifference =
        failed(difference) || failed(modulus)
            ? FailureOr<sym::ExprHandle>(failure())
            : sym::composeExprBinary(store, *difference, sym::ExprBinaryOp::Mod,
                                     *modulus);
    if (failed(wrappedDifference))
      return failure();
    return addTransactionGoal(store, commonGoals, *wrappedDifference,
                              sym::PredCmpOp::Eq, zero);
  }

  LogicalResult appendBitOffsetEquality(sym::ExprHandle lhs,
                                        sym::ExprHandle rhs) {
    if (!isBufferAccess())
      return addTransactionGoal(store, commonGoals, lhs, sym::PredCmpOp::Eq,
                                rhs);

    // AMD buffer instructions consume a u32 byte offset. Check byte alignment,
    // then compare logical and transaction addresses modulo 2^32. The emitted
    // byte window is checked separately for wrapping.
    constexpr int64_t unitBits = 8;
    FailureOr<sym::ExactDivideResult> dividedLhs =
        proveExactDivide(store, lhs, unitBits, proofMap.facts);
    FailureOr<sym::ExactDivideResult> dividedRhs =
        proveExactDivide(store, rhs, unitBits, proofMap.facts);
    if (failed(dividedLhs) || failed(dividedRhs))
      return failure();
    bool exactLhs = dividedLhs->status == sym::ExactDivideStatus::Proven;
    bool exactRhs = dividedRhs->status == sym::ExactDivideStatus::Proven;
    FailureOr<sym::ExprHandle> byteLhs =
        composeElementOffset(store, lhs, unitBits);
    FailureOr<sym::ExprHandle> byteRhs =
        composeElementOffset(store, rhs, unitBits);
    if (failed(byteLhs) || failed(byteRhs))
      return failure();
    if (failed(appendByteAlignment(exactLhs, lhs, *byteLhs)) ||
        failed(appendByteAlignment(exactRhs, rhs, *byteRhs)))
      return failure();
    return appendWrappedByteEquality(*byteLhs, *byteRhs);
  }

  LogicalResult appendItemAndOffsetGoals() {
    if (!layout.bitOffsetRelationVerified &&
        failed(appendBitOffsetEquality(points.exprs[3], expected)))
      return failure();
    if (!itemExtent)
      return success();
    if (failed(addTransactionGoal(store, commonGoals, item, sym::PredCmpOp::Ge,
                                  zero)))
      return failure();
    return addTransactionGoal(store, commonGoals, item, sym::PredCmpOp::Lt,
                              itemExtentExpr);
  }

  LogicalResult appendBaseBounds() {
    FailureOr<sym::ExprHandle> baseCount =
        sym::composeExprInt(store, access.bases.size());
    if (failed(baseCount))
      return failure();
    if (failed(addTransactionGoal(store, commonGoals, baseSelector,
                                  sym::PredCmpOp::Ge, zero)))
      return failure();
    return addTransactionGoal(store, commonGoals, baseSelector,
                              sym::PredCmpOp::Lt, *baseCount);
  }

  LogicalResult appendActivityGoals() {
    if (failed(addTransactionGoal(store, activityGoals, points.exprs[2],
                                  sym::PredCmpOp::Eq, proofOrigins.exprs[2])))
      return failure();
    return addTransactionGoal(store, activityGoals, proofOrigins.exprs[2],
                              sym::PredCmpOp::Eq, transactionActivity);
  }

  LogicalResult composeProofGoals() {
    if (failed(composeProofExpressions()))
      return failure();
    if (failed(appendAddressRelationGoals()))
      return failure();
    if (failed(appendItemAndOffsetGoals()))
      return failure();
    if (failed(appendBaseBounds()))
      return failure();
    return appendActivityGoals();
  }

  FailureOr<bool> proveByteAddress() {
    // Keep the symbolic address in canonical bits and materialize exactly one
    // representation: a byte offset. Byte alignment is part of the same
    // whole-domain proof as the transaction relation.
    constexpr int64_t unitBits = 8;
    FailureOr<sym::ExactDivideResult> divided =
        proveExactDivide(store, materialBitOffset, unitBits, proofMap.facts);
    if (failed(divided))
      return failure();
    bool exact = divided->status == sym::ExactDivideStatus::Proven;
    FailureOr<sym::ExprHandle> offset =
        composeElementOffset(store, materialBitOffset, unitBits);
    if (failed(offset))
      return failure();
    if (!exact) {
      FailureOr<sym::ExprHandle> reconstructed =
          composeIntBinary(store, *offset, sym::ExprBinaryOp::Mul, unitBits);
      if (failed(reconstructed) ||
          failed(addTransactionGoal(store, commonGoals, materialBitOffset,
                                    sym::PredCmpOp::Eq, *reconstructed)))
        return failure();
    }
    elementOffset = *offset;
    return proveGuardedMemoryAddress(store, proofMap, transactionActive,
                                     commonGoals, activityGoals, &memo);
  }

  FailureOr<MemoryTransaction> materializeResult() {
    FailureOr<sym::ExprHandle> concreteOwner =
        indexing::materialize(store, proofMap, materialMap.exprs[0]);
    FailureOr<sym::ExprHandle> concreteBaseSelector =
        indexing::materialize(store, proofMap, baseSelector);
    FailureOr<sym::ExprHandle> concreteBitOffset =
        indexing::materialize(store, proofMap, materialBitOffset);
    FailureOr<sym::ExprHandle> concreteOffset =
        indexing::materialize(store, proofMap, elementOffset);
    FailureOr<sym::ExprHandle> concreteActivity =
        indexing::materialize(store, proofMap, transactionActivity);
    if (failed(concreteOwner) || failed(concreteBaseSelector) ||
        failed(concreteBitOffset) || failed(concreteOffset) ||
        failed(concreteActivity))
      return failure();
    constexpr int64_t unitBits = 8;
    MemoryTransaction result;
    result.map = std::move(proofMap);
    result.addresses.push_back({access.bases, *concreteOwner,
                                *concreteBaseSelector, *concreteBitOffset,
                                *concreteOffset, unitBits});
    result.activity = *concreteActivity;
    result.slot = slot;
    result.group = group;
    result.within = within;
    result.width = layout.width;
    return result;
  }

  FailureOr<bool> finalizeResult(MemoryTransaction &result) {
    if (request.projection) {
      FailureOr<bool> projected =
          projectTransaction(result, *request.projection, store, memo);
      if (failed(projected) || !*projected)
        return projected;
    }
    if (request.windowBytes <= 0)
      return true;
    return checkTransactionWindow(result, request.windowBytes, store, memo);
  }

  FailureOr<bool> initializePlan() {
    if (failed(validateRequest()))
      return failure();
    if (failed(initializeCoordinates()))
      return failure();
    FailureOr<bool> itemInitialized = initializeItemLayout();
    if (failed(itemInitialized) || !*itemInitialized)
      return itemInitialized;
    if (failed(createDomain()))
      return failure();
    if (failed(retainExecutingItemFacts()))
      return failure();
    return true;
  }

  LogicalResult composePlan() {
    if (failed(pullbackAccessMaps()))
      return failure();
    if (failed(createMaterialProofMap()))
      return failure();
    return composeProofGoals();
  }

  sym::Store &store;
  MemoryTransactionRequest request;
  indexing::CheckMemo &memo;
  MemoryTransactionAccess &access;
  MemoryTransactionLayout &layout;
  int64_t groupCount = 0;
  sym::ExprHandle group;
  sym::ExprHandle within;
  sym::ExprHandle zero;
  sym::ExprHandle slot;
  sym::ExprHandle item;
  std::optional<int64_t> itemExtent;
  indexing::IndexMap domain;
  indexing::IndexMap points;
  indexing::IndexMap proofOrigins;
  indexing::IndexMap materialOrigin;
  indexing::IndexMap materialMap;
  indexing::IndexMap proofMap;
  sym::ExprHandle proofBitOffset;
  sym::ExprHandle materialBitOffset;
  sym::ExprHandle baseSelector;
  sym::ExprHandle transactionActivity;
  sym::PredHandle transactionActive;
  sym::ExprHandle expected;
  sym::ExprHandle itemExtentExpr;
  sym::ExprHandle elementOffset;
  SmallVector<sym::PredHandle> commonGoals;
  SmallVector<sym::PredHandle, 2> activityGoals;
};

} // namespace

FailureOr<std::optional<MemoryTransaction>>
mlir::wave::planMemoryTransaction(sym::Store &store,
                                  MemoryTransactionRequest request,
                                  indexing::CheckMemo &memo) {
  return MemoryTransactionPlanner(store, std::move(request), memo).plan();
}
