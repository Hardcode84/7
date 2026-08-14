//===- WaveSymbolicValueAnalysis.cpp - Wave symbolic SSA engine
//---------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveSymbolicValueAnalysis.h"

namespace mlir::wave::detail {

FailureOr<std::optional<SymbolicOffset>>
SymbolicValueBuilder::build(Value value) {
  return build(value, /*allowRootLeaf=*/false);
}

FailureOr<std::optional<SymbolicOffset>>
SymbolicValueBuilder::buildAllowingRootLeaf(Value value) {
  return build(value, /*allowRootLeaf=*/true);
}

FailureOr<std::optional<SymbolicPredicate>>
SymbolicValueBuilder::buildPredicate(Value value) {
  return buildPredicate(value, /*retainGuardedRoot=*/false);
}

FailureOr<std::optional<SymbolicPredicate>>
SymbolicValueBuilder::buildPredicateRetainingGuardedRoot(Value value) {
  return buildPredicate(value, /*retainGuardedRoot=*/true);
}

FailureOr<bool> SymbolicValueBuilder::canExpand(Value value) {
  return hasSymbolicRoot(value);
}

void SymbolicValueBuilder::enableExactIntegerCasts() {
  exactIntegerCasts = true;
}
void SymbolicValueBuilder::enableSSAIntermediateLeaves() {
  allowSSAIntermediateLeaves = true;
}

bool SymbolicValueBuilder::isRetainedGuardedRoot(Value value,
                                                 bool retainGuardedRoot) {
  SelectOp select = value.getDefiningOp<SelectOp>();
  return retainGuardedRoot && isMaskSelect(select) &&
         getSplatOrConstantInt(select.getFalseValue()) == int64_t{0};
}

ArrayRef<sym::PredHandle> SymbolicValueBuilder::getSSAFacts(Value value) const {
  auto found = ssaFactsByValue.find(value);
  if (found == ssaFactsByValue.end())
    return {};
  return found->second;
}

void SymbolicValueBuilder::appendSSAFact(Value value, sym::PredHandle fact) {
  SmallVector<sym::PredHandle, 2> &facts = ssaFactsByValue[value];
  if (!llvm::is_contained(facts, fact))
    facts.push_back(fact);
}

void SymbolicValueBuilder::appendSSAFacts(Value value,
                                          ArrayRef<sym::PredHandle> facts) {
  for (sym::PredHandle fact : facts)
    appendSSAFact(value, fact);
}

void SymbolicValueBuilder::propagateSSAOperandFacts(Value value) {
  Operation *producer = value.getDefiningOp();
  if (!producer)
    return;
  // An IndexExpr is a complete serialization boundary. Its explicit packet
  // assumptions were attached while decoding it; binding-producer facts must
  // never be rediscovered through generic operand propagation.
  if (isa<IndexExprOp>(producer))
    return;
  for (Value operand : producer->getOperands())
    appendSSAFacts(value, getSSAFacts(operand));
}

SmallVector<sym::PredHandle, 8>
SymbolicValueBuilder::getSSAValueDomain(Value value) const {
  SmallVector<sym::PredHandle, 8> assumptions(offset.assumptions.begin(),
                                              offset.assumptions.end());
  llvm::append_range(assumptions, getSSAFacts(value));
  return assumptions;
}

void SymbolicValueBuilder::discardSkippedPredicate() {
  ssaFactsByValue.clear();
}

FailureOr<bool> SymbolicValueBuilder::validateActiveGuardedPredicate(
    const RetainedSelectProof &proof) {
  SelectOp select = proof.select;
  SmallVector<sym::PredHandle, 8> activeAssumptions(offset.assumptions.begin(),
                                                    offset.assumptions.end());
  llvm::append_range(activeAssumptions, getSSAFacts(select.getCondition()));
  llvm::append_range(activeAssumptions, getSSAFacts(select.getTrueValue()));
  activeAssumptions.push_back(proof.guard);
  std::array<sym::ExprHandle, 2> goals{sym::asExpr(proof.guard),
                                       sym::asExpr(proof.activePredicate)};
  SmallVector<sym::PredHandle> relevant =
      selectIndexExprAnalysisFacts(goals, {}, activeAssumptions);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      createClosedIndexExprAnalysis(store, relevant);
  if (failed(analysis))
    return false;
  FailureOr<bool> active =
      queryProvesTrue((**analysis).check(proof.activePredicate));
  return active;
}

FailureOr<bool>
SymbolicValueBuilder::validateBuiltPredicate(const BuiltPredicateRoot &root) {
  if (root.retained)
    return validateActiveGuardedPredicate(*root.retained);
  return true;
}

FailureOr<sym::PredHandle>
SymbolicValueBuilder::canonicalizePredicate(Value value,
                                            sym::PredHandle predicate) {
  SmallVector<sym::PredHandle, 8> valueDomain = getSSAValueDomain(value);
  std::array<sym::ExprHandle, 1> goal{sym::asExpr(predicate)};
  SmallVector<sym::PredHandle> relevantValueDomain =
      selectIndexExprAnalysisFacts(goal, {}, valueDomain);
  FailureOr<std::unique_ptr<sym::Analysis>> valueAnalysis =
      createClosedIndexExprAnalysis(store, relevantValueDomain);
  if (failed(valueAnalysis))
    return failure();
  FailureOr<sym::ExprHandle> valueSimplified =
      (*valueAnalysis)->simplify(sym::asExpr(predicate));
  if (failed(valueSimplified))
    return failure();
  std::optional<sym::PredHandle> valuePredicate = sym::asPred(*valueSimplified);
  if (!valuePredicate)
    return failure();
  sym::PredKind kind = sym::PredView(*valuePredicate).getKind();
  if (kind == sym::PredKind::True || kind == sym::PredKind::False)
    return *valuePredicate;

  SmallVector<sym::PredHandle> relevantAssumptions =
      selectIndexExprAnalysisFacts(goal, {}, offset.assumptions);
  FailureOr<std::unique_ptr<sym::Analysis>> totalAnalysis =
      createClosedIndexExprAnalysis(store, relevantAssumptions);
  if (failed(totalAnalysis))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      (*totalAnalysis)->simplify(sym::asExpr(predicate));
  if (failed(simplified))
    return failure();
  std::optional<sym::PredHandle> result = sym::asPred(*simplified);
  if (!result)
    return failure();
  return *result;
}

FailureOr<sym::PredHandle> SymbolicValueBuilder::canonicalizeBuiltPredicate(
    const BuiltPredicateRoot &root) {
  if (root.retained) {
    SelectOp select = root.retained->select;
    return canonicalizePredicate(select.getCondition(), root.retained->guard);
  }
  return canonicalizePredicate(rootValue, root.predicate);
}

SymbolicPredicate
SymbolicValueBuilder::makeSymbolicPredicate(Value value,
                                            sym::PredHandle predicate) {
  SymbolicPredicate result;
  result.bindings = std::move(offset.bindings);
  result.assumptions = std::move(offset.assumptions);
  for (sym::PredHandle fact : getSSAFacts(value))
    if (!llvm::is_contained(result.assumptions, fact))
      result.assumptions.push_back(fact);
  result.predicate = predicate;
  return result;
}

FailureOr<std::optional<SymbolicPredicate>>
SymbolicValueBuilder::buildPredicate(Value value, bool retainGuardedRoot) {
  buildingPredicate = true;
  rootValue = value;
  bool skip = false;
  bool guardedRoot = isRetainedGuardedRoot(value, retainGuardedRoot);
  FailureOr<BuiltPredicateRoot> predicate =
      guardedRoot
          ? buildGuardedRootPredicate(value.getDefiningOp<SelectOp>(), skip)
          : buildPredicateRoot(value, skip);
  if (skip) {
    discardSkippedPredicate();
    return std::optional<SymbolicPredicate>{};
  }
  if (failed(predicate))
    return failure();
  FailureOr<bool> valid = validateBuiltPredicate(*predicate);
  if (failed(valid))
    return failure();
  if (!*valid)
    return std::optional<SymbolicPredicate>{};
  FailureOr<sym::PredHandle> canonical = canonicalizeBuiltPredicate(*predicate);
  if (failed(canonical))
    return failure();
  // Keep the complete converted predicate. Downstream relation queries must
  // derive structure from this packet, not from parallel provenance data.
  return std::optional<SymbolicPredicate>{
      makeSymbolicPredicate(value, *canonical)};
}

bool SymbolicValueBuilder::isWrappingArithmeticKind(BinaryKind kind) {
  return kind == BinaryKind::AddI || kind == BinaryKind::SubI ||
         kind == BinaryKind::MulI;
}

bool SymbolicValueBuilder::canBuildBinary(BinaryOp op) {
  return isStructurallySymbolicBinaryOp(op, allowI64Integers);
}

bool SymbolicValueBuilder::isMaskSelect(SelectOp select) {
  return select && isa<MaskType>(select.getType()) &&
         (isa<MaskType>(select.getCondition().getType()) ||
          select.getCondition().getType().isInteger(1)) &&
         isa<MaskType>(select.getTrueValue().getType()) &&
         isa<MaskType>(select.getFalseValue().getType());
}

FailureOr<SymbolicValueBuilder::BuiltPredicateRoot>
SymbolicValueBuilder::buildPredicateRoot(Value value, bool &skip) {
  ProducerProofContext context = ProducerProofContext::forPredicate();
  FailureOr<sym::PredHandle> predicate =
      buildPredicateExpr(value, skip, context);
  if (failedOrSkipped(predicate, skip))
    return failure();
  return BuiltPredicateRoot{*predicate, std::nullopt};
}

FailureOr<SymbolicValueBuilder::BuiltPredicateRoot>
SymbolicValueBuilder::buildGuardedRootPredicate(SelectOp select, bool &skip) {
  ProducerProofContext guardContext = ProducerProofContext::forPredicate();
  FailureOr<sym::PredHandle> guard =
      buildPredicateExpr(select.getCondition(), skip, guardContext);
  if (failedOrSkipped(guard, skip))
    return failure();

  ProducerProofContext armContext =
      ProducerProofContext::forRetainedArm(select, *guard);
  FailureOr<sym::PredHandle> active =
      buildPredicateExpr(select.getTrueValue(), skip, armContext);
  if (failedOrSkipped(active, skip))
    return failure();
  FailureOr<sym::PredHandle> predicate =
      sym::composePredAnd(store, *guard, *active);
  if (failed(predicate))
    return failure();
  RetainedSelectProof proof{select, *guard, *active};
  return BuiltPredicateRoot{*predicate, proof};
}

FailureOr<sym::PredHandle> SymbolicValueBuilder::buildSelectPredicate(
    SelectOp select, bool &skip, const ProducerProofContext &context) {
  FailureOr<sym::PredHandle> condition =
      buildPredicateExpr(select.getCondition(), skip, context);
  if (failedOrSkipped(condition, skip))
    return failure();
  FailureOr<sym::PredHandle> truePredicate =
      buildConditionalPredicateArm(select.getTrueValue(), skip, context);
  if (failedOrSkipped(truePredicate, skip))
    return failure();
  FailureOr<sym::PredHandle> falsePredicate =
      buildConditionalPredicateArm(select.getFalseValue(), skip, context);
  if (failedOrSkipped(falsePredicate, skip))
    return failure();

  FailureOr<sym::PredHandle> activeTrue =
      sym::composePredAnd(store, *condition, *truePredicate);
  FailureOr<sym::PredHandle> notCondition =
      sym::composePredNot(store, *condition);
  if (failed(activeTrue) || failed(notCondition))
    return failure();
  FailureOr<sym::PredHandle> activeFalse =
      sym::composePredAnd(store, *notCondition, *falsePredicate);
  if (failed(activeFalse))
    return failure();
  return sym::composePredOr(store, *activeTrue, *activeFalse);
}

FailureOr<sym::PredHandle>
SymbolicValueBuilder::buildPredicateExpr(Value value, bool &skip,
                                         const ProducerProofContext &context) {
  bool cacheResult = context.canUseCache();
  if (cacheResult) {
    auto cached = predicateByValue.find(value);
    if (cached != predicateByValue.end())
      return cached->second;
  }
  if (!activePredicateValues.insert(value).second) {
    skip = true;
    return failure();
  }
  llvm::scope_exit eraseActive([&] { activePredicateValues.erase(value); });
  FailureOr<sym::PredHandle> result =
      buildPredicateExprImpl(value, skip, context);
  if (!skip && succeeded(result)) {
    propagateSSAOperandFacts(value);
    if (cacheResult)
      predicateByValue.try_emplace(value, *result);
  }
  return result;
}

FailureOr<sym::PredHandle> SymbolicValueBuilder::buildPredicateExprImpl(
    Value value, bool &skip, const ProducerProofContext &context) {
  if (CmpIOp cmp = value.getDefiningOp<CmpIOp>())
    return buildCmpPredicate(cmp, skip, context);
  if (arith::CmpIOp cmp = value.getDefiningOp<arith::CmpIOp>())
    return buildCmpPredicate(cmp.getPredicate(), cmp.getLhs(), cmp.getRhs(),
                             skip, context);
  if (std::optional<int64_t> constant = getSplatOrConstantInt(value)) {
    if (*constant == 0)
      return sym::composePredFalse(store);
    if (*constant == 1)
      return sym::composePredTrue(store);
  }
  SelectOp select = value.getDefiningOp<SelectOp>();
  if (!isMaskSelect(select)) {
    skip = true;
    return failure();
  }
  return buildSelectPredicate(select, skip, context);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::simplifyPacketExpr(sym::ExprHandle expr) {
  std::string diagnostic;
  FailureOr<sym::ExprHandle> simplified =
      offset.assumptions.empty()
          ? sym::simplifyExpr(store, expr, &diagnostic)
          : sym::simplifyExpr(store, expr, offset.assumptions, &diagnostic);
  if (failed(simplified))
    return emitError(rootValue.getLoc())
           << "failed to simplify symbolic SSA packet: " << diagnostic;
  return shouldUseSimplifiedIndexExpr(*simplified, expr) ? *simplified : expr;
}

FailureOr<bool> SymbolicValueBuilder::validatePacketExpr(sym::ExprHandle expr) {
  std::string diagnostic;
  FailureOr<std::unique_ptr<sym::Analysis>> domain =
      createClosedIndexExprAnalysis(store, offset.assumptions, &diagnostic);
  if (failed(domain) && allowSSAIntermediateLeaves)
    return false;
  if (failed(domain))
    return emitError(rootValue.getLoc())
           << "failed to create symbolic SSA packet analysis: " << diagnostic;
  if (!fullyMergeAssumes)
    return true;
  FailureOr<bool> integer = checkIntegerValidity(**domain, expr);
  if (failed(integer))
    return emitError(rootValue.getLoc())
           << "failed to query symbolic SSA packet integrality";
  return *integer;
}

FailureOr<std::optional<SymbolicOffset>>
SymbolicValueBuilder::finishBuiltOffset(sym::ExprHandle expr) {
  FailureOr<bool> valid = validatePacketExpr(expr);
  if (failed(valid))
    return failure();
  if (!*valid)
    return std::optional<SymbolicOffset>{};
  offset.expr = expr;
  return std::optional<SymbolicOffset>{std::move(offset)};
}

bool SymbolicValueBuilder::shouldAllowRootLeaf(Value value, bool allowRootLeaf,
                                               bool hasRoot) const {
  return allowRootLeaf &&
         (!hasRoot || (assumeRootPolicy == AssumeRootPolicy::BindExactResult &&
                       isAtomicAssumeResultCandidate(value)));
}

void SymbolicValueBuilder::appendRootSSAFacts(Value value) {
  for (sym::PredHandle fact : getSSAFacts(value))
    if (!llvm::is_contained(offset.assumptions, fact))
      offset.assumptions.push_back(fact);
}

FailureOr<std::optional<SymbolicOffset>>
SymbolicValueBuilder::buildExpandedRoot(Value value, bool allowRootLeaf,
                                        bool hasRoot) {
  bool skip = false;
  ProducerProofContext context;
  FailureOr<sym::ExprHandle> expr = buildExpr(
      value, skip, shouldAllowRootLeaf(value, allowRootLeaf, hasRoot), context);
  if (skip)
    return std::optional<SymbolicOffset>{};
  if (failed(expr)) {
    emitError(rootValue.getLoc()) << "failed to compose symbolic SSA packet";
    return failure();
  }
  appendRootSSAFacts(value);
  FailureOr<sym::ExprHandle> simplified = simplifyPacketExpr(*expr);
  if (failed(simplified))
    return failure();
  return finishBuiltOffset(*simplified);
}

FailureOr<std::optional<SymbolicOffset>>
SymbolicValueBuilder::buildRootLeaf(Value value) {
  bool skip = false;
  FailureOr<sym::ExprHandle> expr =
      bindSymbol(value, skip, /*importDefinitionFacts=*/false);
  if (skip)
    return std::optional<SymbolicOffset>{};
  if (failed(expr))
    return failure();
  appendRootSSAFacts(value);
  return finishBuiltOffset(*expr);
}

FailureOr<std::optional<SymbolicOffset>>
SymbolicValueBuilder::build(Value value, bool allowRootLeaf) {
  rootValue = value;
  FailureOr<bool> hasRoot = hasSymbolicRoot(value);
  if (failed(hasRoot)) {
    emitError(rootValue.getLoc()) << "failed to inspect symbolic SSA packet";
    return failure();
  }
  if (!*hasRoot && !allowRootLeaf)
    return std::optional<SymbolicOffset>{};

  StateMark mark = markState();
  FailureOr<std::optional<SymbolicOffset>> result =
      buildExpandedRoot(value, allowRootLeaf, *hasRoot);
  if (failed(result) || *result || !allowRootLeaf ||
      !allowSSAIntermediateLeaves)
    return result;

  rollbackState(mark);
  return buildRootLeaf(value);
}

FailureOr<bool> SymbolicValueBuilder::hasSymbolicRoot(Value value) {
  auto cached = symbolicRootByValue.find(value);
  if (cached != symbolicRootByValue.end())
    return cached->second;
  if (!activeSymbolicRootValues.insert(value).second)
    return false;
  llvm::scope_exit eraseActive([&] { activeSymbolicRootValues.erase(value); });
  FailureOr<bool> result = hasSymbolicRootImpl(value);
  if (failed(result))
    return failure();
  symbolicRootByValue.try_emplace(value, *result);
  return *result;
}

bool SymbolicValueBuilder::hasExactCastSymbolicRoot(Value value) {
  if (!exactIntegerCasts)
    return false;
  if (value.getDefiningOp<arith::IndexCastOp>() ||
      value.getDefiningOp<arith::IndexCastUIOp>())
    return true;
  CastOp cast = value.getDefiningOp<CastOp>();
  return cast && isStructurallySymbolicIntegerCast(cast, allowI64Integers);
}

FailureOr<bool> SymbolicValueBuilder::hasSplatSymbolicRoot(SplatOp splat) {
  FailureOr<bool> source = hasSymbolicRoot(splat.getSource());
  if (failed(source))
    return failure();
  return *source ||
         (fullyMergeAssumes && isClosedPacketLeaf(splat.getSource()));
}

bool SymbolicValueBuilder::hasBlockArgumentSymbolicRoot(Value value) {
  BlockArgument arg = dyn_cast<BlockArgument>(value);
  return arg && ((exactIntegerCasts && getExactForInductionVarOwner(arg)) ||
                 matchLoopCarriedRecurrence(arg).has_value());
}

FailureOr<bool> SymbolicValueBuilder::hasProducerSymbolicRoot(Value value) {
  if (AssumeOp assume = value.getDefiningOp<AssumeOp>()) {
    if (fullyMergeAssumes)
      return true;
    return hasSymbolicRoot(assume.getValue());
  }
  if (BinaryOp binary = value.getDefiningOp<BinaryOp>())
    return canBuildBinary(binary);
  if (SelectOp select = value.getDefiningOp<SelectOp>())
    return isStructurallySymbolicSelect(select, allowI64Integers);
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    return hasSplatSymbolicRoot(splat);
  return hasBlockArgumentSymbolicRoot(value);
}

FailureOr<bool> SymbolicValueBuilder::hasSymbolicRootImpl(Value value) {
  FailureOr<Value> alias = getSymbolicAlias(value, store);
  if (failed(alias))
    return failure();
  if (*alias)
    return hasSymbolicRoot(*alias);
  if (hasExactCastSymbolicRoot(value))
    return true;
  if (value.getDefiningOp<IndexExprOp>())
    return expandIndexExprRoot;
  return hasProducerSymbolicRoot(value);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildExpr(Value value, bool &skip, bool allowLeaf,
                                const ProducerProofContext &context) {
  bool cacheResult = context.canUseCache();
  if (cacheResult) {
    auto required = requiredExprByValue.find(value);
    if (required != requiredExprByValue.end())
      return required->second;
    if (allowLeaf) {
      auto permissive = leafExprByValue.find(value);
      if (permissive != leafExprByValue.end())
        return permissive->second;
    }
  }
  if (!activeExprValues.insert(value).second) {
    skip = true;
    return failure();
  }
  llvm::scope_exit eraseActive([&] { activeExprValues.erase(value); });
  FailureOr<sym::ExprHandle> result =
      buildExprImpl(value, skip, allowLeaf, context);
  if (!skip && succeeded(result)) {
    propagateSSAOperandFacts(value);
    if (cacheResult) {
      if (allowLeaf)
        leafExprByValue.try_emplace(value, *result);
      else
        requiredExprByValue.try_emplace(value, *result);
    }
  }
  return result;
}

FailureOr<std::optional<sym::ExprHandle>>
SymbolicValueBuilder::optionalExpr(FailureOr<sym::ExprHandle> expr) {
  if (failed(expr))
    return failure();
  return std::optional<sym::ExprHandle>{*expr};
}

FailureOr<std::optional<sym::ExprHandle>>
SymbolicValueBuilder::buildExactCastExpr(Value value, bool &skip,
                                         const ProducerProofContext &context) {
  if (!exactIntegerCasts)
    return std::optional<sym::ExprHandle>{};
  if (arith::IndexCastOp cast = value.getDefiningOp<arith::IndexCastOp>())
    return optionalExpr(buildExactIndexCast(
        cast.getOperation(), cast.getIn(), cast.getType(),
        /*unsignedExtension=*/false, /*nonNegative=*/false, skip, context));
  if (arith::IndexCastUIOp cast = value.getDefiningOp<arith::IndexCastUIOp>())
    return optionalExpr(
        buildExactIndexCast(cast.getOperation(), cast.getIn(), cast.getType(),
                            /*unsignedExtension=*/true,
                            /*nonNegative=*/cast.getNonNeg(), skip, context));
  if (CastOp cast = value.getDefiningOp<CastOp>())
    return optionalExpr(buildExactWaveIntegerCast(cast, skip, context));
  return std::optional<sym::ExprHandle>{};
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildProducerExpr(Value value, bool &skip, bool allowLeaf,
                                        const ProducerProofContext &context) {
  FailureOr<Value> alias = getSymbolicAlias(value, store);
  if (failed(alias))
    return failure();
  if (*alias)
    return buildExpr(*alias, skip, allowLeaf, context);
  if (BinaryOp binary = value.getDefiningOp<BinaryOp>())
    return buildBinaryExpr(value, binary, skip, allowLeaf, context);
  if (SelectOp select = value.getDefiningOp<SelectOp>())
    return buildSelectExpr(value, select, skip, allowLeaf, context);
  return buildLeafOrRecurrence(value, skip, allowLeaf, context);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildExprImpl(Value value, bool &skip, bool allowLeaf,
                                    const ProducerProofContext &context) {
  std::optional<int64_t> constant = foldWaveConstants
                                        ? getSplatOrConstantInt(value)
                                        : getConstantIntValue(value);
  if (constant)
    return sym::composeExprInt(store, *constant);
  if (IndexExprOp indexExpr = value.getDefiningOp<IndexExprOp>())
    return buildIndexExpr(indexExpr);
  FailureOr<std::optional<sym::ExprHandle>> exact =
      buildExactCastExpr(value, skip, context);
  if (failed(exact))
    return failure();
  if (*exact)
    return **exact;
  if (AssumeOp assume = value.getDefiningOp<AssumeOp>())
    return buildAssumeExpr(value, assume, skip, allowLeaf, context);
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    return buildSplatExpr(splat, skip, allowLeaf, context);
  return buildProducerExpr(value, skip, allowLeaf, context);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildLeafOrRecurrence(
    Value value, bool &skip, bool allowLeaf,
    const ProducerProofContext &context) {
  if (BlockArgument arg = dyn_cast<BlockArgument>(value)) {
    if (std::optional<LoopCarriedRecurrence> recurrence =
            matchLoopCarriedRecurrence(arg))
      return buildLoopCarriedRecurrence(*recurrence, skip, context);
    if (exactIntegerCasts && scf::getForInductionVarOwner(arg))
      return buildForInductionExpr(arg, skip, context);
  }
  return bindOrSkip(value, skip, allowLeaf);
}

FailureOr<SymbolicValueBuilder::InductionBounds>
SymbolicValueBuilder::buildInductionBounds(
    BlockArgument arg, scf::ForOp loop, bool &skip, bool importDefinitionFacts,
    const ProducerProofContext &context) {
  FailureOr<sym::ExprHandle> induction =
      bindSymbol(arg, skip, importDefinitionFacts);
  if (failedOrSkipped(induction, skip))
    return failure();
  FailureOr<sym::ExprHandle> lower =
      buildExpr(loop.getLowerBound(), skip, /*allowLeaf=*/true, context);
  if (failedOrSkipped(lower, skip))
    return failure();
  FailureOr<sym::ExprHandle> upper =
      buildExpr(loop.getUpperBound(), skip, /*allowLeaf=*/true, context);
  if (failedOrSkipped(upper, skip))
    return failure();
  for (Value bound : {loop.getLowerBound(), loop.getUpperBound()})
    for (sym::PredHandle fact : getSSAFacts(bound))
      if (!llvm::is_contained(offset.assumptions, fact))
        offset.assumptions.push_back(fact);
  return InductionBounds{*induction, *lower, *upper};
}

LogicalResult SymbolicValueBuilder::appendLoopRangeAssumptions(
    sym::ExprHandle induction, sym::ExprHandle lower, sym::ExprHandle upper,
    sym::ExprHandle next, sym::ExprHandle unwrappedNext) {
  FailureOr<sym::PredHandle> atLeastLower =
      sym::composePredCmp(store, induction, sym::PredCmpOp::Ge, lower);
  FailureOr<sym::PredHandle> belowUpper =
      sym::composePredCmp(store, induction, sym::PredCmpOp::Lt, upper);
  FailureOr<sym::PredHandle> successorDoesNotWrap =
      sym::composePredCmp(store, next, sym::PredCmpOp::Eq, unwrappedNext);
  if (failed(atLeastLower) || failed(belowUpper) ||
      failed(successorDoesNotWrap))
    return failure();
  offset.assumptions.push_back(*atLeastLower);
  offset.assumptions.push_back(*belowUpper);
  offset.assumptions.push_back(*successorDoesNotWrap);
  return success();
}

FailureOr<SymbolicValueBuilder::InductionBounds>
SymbolicValueBuilder::buildUnsignedLoopBounds(const InductionBounds &bounds,
                                              unsigned bitWidth) {
  FailureOr<sym::ExprHandle> induction =
      buildUnsignedFixedWidthValue(bounds.induction, bitWidth);
  FailureOr<sym::ExprHandle> lower =
      buildUnsignedFixedWidthValue(bounds.lower, bitWidth);
  FailureOr<sym::ExprHandle> upper =
      buildUnsignedFixedWidthValue(bounds.upper, bitWidth);
  if (failed(induction) || failed(lower) || failed(upper))
    return failure();
  return InductionBounds{*induction, *lower, *upper};
}

FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>>
SymbolicValueBuilder::buildUnsignedLoopSuccessor(
    sym::ExprHandle mathematicalInduction, sym::ExprHandle unsignedInduction,
    int64_t step, unsigned bitWidth) {
  FailureOr<sym::ExprHandle> stepExpr = sym::composeExprInt(store, step);
  if (failed(stepExpr))
    return failure();
  FailureOr<sym::ExprHandle> mathematicalNext = sym::composeExprBinary(
      store, mathematicalInduction, sym::ExprBinaryOp::Add, *stepExpr);
  FailureOr<sym::ExprHandle> unwrappedNext = sym::composeExprBinary(
      store, unsignedInduction, sym::ExprBinaryOp::Add, *stepExpr);
  if (failed(mathematicalNext) || failed(unwrappedNext))
    return failure();
  FailureOr<sym::ExprHandle> next =
      buildUnsignedFixedWidthValue(*mathematicalNext, bitWidth);
  if (failed(next))
    return failure();
  return std::pair<sym::ExprHandle, sym::ExprHandle>{*next, *unwrappedNext};
}

FailureOr<SymbolicValueBuilder::UnsignedLoopValues>
SymbolicValueBuilder::buildUnsignedLoopValues(const InductionBounds &bounds,
                                              int64_t step, unsigned bitWidth) {
  FailureOr<InductionBounds> unsignedBounds =
      buildUnsignedLoopBounds(bounds, bitWidth);
  if (failed(unsignedBounds))
    return failure();
  FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>> successor =
      buildUnsignedLoopSuccessor(bounds.induction, unsignedBounds->induction,
                                 step, bitWidth);
  if (failed(successor))
    return failure();
  return UnsignedLoopValues{unsignedBounds->induction, unsignedBounds->lower,
                            unsignedBounds->upper, successor->first,
                            successor->second};
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildUnsignedForInductionExpr(
    BlockArgument arg, scf::ForOp loop, int64_t step, bool &skip,
    const ProducerProofContext &context) {
  unsigned bitWidth = elementStorageBitWidth(arg.getType());
  if (bitWidth == 0 || bitWidth > 64) {
    skip = true;
    return failure();
  }
  FailureOr<InductionBounds> bounds = buildInductionBounds(
      arg, loop, skip, /*importDefinitionFacts=*/false, context);
  if (failed(bounds))
    return failure();
  FailureOr<UnsignedLoopValues> values =
      buildUnsignedLoopValues(*bounds, step, bitWidth);
  if (failed(values))
    return failure();
  if (failed(appendLoopRangeAssumptions(values->induction, values->lower,
                                        values->upper, values->next,
                                        values->unwrappedNext)))
    return failure();
  return bounds->induction;
}
} // namespace mlir::wave::detail
