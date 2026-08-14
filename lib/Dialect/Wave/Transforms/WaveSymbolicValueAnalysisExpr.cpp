//===- WaveSymbolicValueAnalysisExpr.cpp - Wave symbolic SSA engine
//---------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveSymbolicValueAnalysis.h"

namespace mlir::wave::detail {

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildSignedForInductionExpr(
    BlockArgument arg, scf::ForOp loop, int64_t step, bool &skip,
    const ProducerProofContext &context) {
  FailureOr<InductionBounds> bounds = buildInductionBounds(
      arg, loop, skip, /*importDefinitionFacts=*/true, context);
  if (failed(bounds))
    return failure();
  FailureOr<sym::ExprHandle> stepExpr = sym::composeExprInt(store, step);
  FailureOr<sym::ExprHandle> next =
      succeeded(stepExpr)
          ? sym::composeExprBinary(store, bounds->induction,
                                   sym::ExprBinaryOp::Add, *stepExpr)
          : FailureOr<sym::ExprHandle>(failure());
  FailureOr<sym::ExprHandle> wrappedNext =
      succeeded(next) ? buildSignedFixedWidthValue(
                            *next, elementStorageBitWidth(arg.getType()))
                      : FailureOr<sym::ExprHandle>(failure());
  if (failed(stepExpr) || failed(next) || failed(wrappedNext))
    return failure();
  if (failed(appendLoopRangeAssumptions(bounds->induction, bounds->lower,
                                        bounds->upper, *next, *wrappedNext)))
    return failure();
  return bounds->induction;
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildForInductionExpr(
    BlockArgument arg, bool &skip, const ProducerProofContext &context) {
  scf::ForOp loop = getExactForInductionVarOwner(arg);
  if (!loop) {
    skip = true;
    return failure();
  }
  std::optional<int64_t> step = getConstantIntValue(loop.getStep());
  if (!step || *step <= 0) {
    skip = true;
    return failure();
  }
  if (loop.getUnsignedCmp())
    return buildUnsignedForInductionExpr(arg, loop, *step, skip, context);
  return buildSignedForInductionExpr(arg, loop, *step, skip, context);
}

FailureOr<SymbolicValueBuilder::ExactCastShape>
SymbolicValueBuilder::getExactCastShape(Value input, Type resultType,
                                        bool &skip) {
  Type sourceType = input.getType();
  if (!isSymbolicValueType(sourceType, allowI64Integers) ||
      !isSymbolicValueType(resultType, allowI64Integers)) {
    skip = true;
    return failure();
  }
  auto sourceSimd = dyn_cast<SimdType>(sourceType);
  auto resultSimd = dyn_cast<SimdType>(resultType);
  if (static_cast<bool>(sourceSimd) != static_cast<bool>(resultSimd) ||
      (sourceSimd && sourceSimd.getWidth() != resultSimd.getWidth())) {
    skip = true;
    return failure();
  }
  unsigned sourceBits = elementStorageBitWidth(sourceType);
  unsigned resultBits = elementStorageBitWidth(resultType);
  if (sourceBits == 0 || sourceBits > 64 || resultBits == 0 ||
      resultBits > 64) {
    skip = true;
    return failure();
  }
  return ExactCastShape{sourceBits, resultBits};
}

LogicalResult SymbolicValueBuilder::appendNonNegativeCastAssumption(
    Operation *producer, sym::ExprHandle source, bool &skip,
    const ProducerProofContext &context) {
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  if (failed(zero))
    return failure();
  FailureOr<sym::PredHandle> atLeastZero =
      sym::composePredCmp(store, source, sym::PredCmpOp::Ge, *zero);
  if (failed(atLeastZero))
    return failure();
  if (llvm::is_contained(offset.assumptions, *atLeastZero))
    return success();
  std::array<sym::PredHandle, 1> assumption{*atLeastZero};
  return appendRequiredAssumptions(assumption, producer, skip, context);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildWidenedIndexCast(
    sym::ExprHandle source, unsigned sourceBits, bool unsignedExtension,
    bool nonNegative) {
  if (!unsignedExtension || nonNegative)
    return source;
  return buildUnsignedFixedWidthValue(source, sourceBits);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildNarrowedIndexCast(
    Operation *producer, sym::ExprHandle source, unsigned resultBits,
    const ProducerProofContext &context) {
  int64_t signedMin = -(int64_t{1} << (resultBits - 1));
  int64_t signedMax = (int64_t{1} << (resultBits - 1)) - 1;
  FailureOr<sym::ExprHandle> lower = sym::composeExprInt(store, signedMin);
  FailureOr<sym::ExprHandle> upper = sym::composeExprInt(store, signedMax);
  FailureOr<sym::PredHandle> atLeastLower =
      failed(lower)
          ? FailureOr<sym::PredHandle>(failure())
          : sym::composePredCmp(store, source, sym::PredCmpOp::Ge, *lower);
  FailureOr<sym::PredHandle> atMostUpper =
      failed(upper)
          ? FailureOr<sym::PredHandle>(failure())
          : sym::composePredCmp(store, source, sym::PredCmpOp::Le, *upper);
  if (failed(atLeastLower) || failed(atMostUpper))
    return failure();
  std::array<sym::PredHandle, 2> exactRange{*atLeastLower, *atMostUpper};
  FailureOr<bool> exact = provePredicates(exactRange, producer, context);
  if (failed(exact))
    return failure();
  if (*exact)
    return source;
  return buildSignedFixedWidthValue(source, resultBits);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildExactIndexCast(
    Operation *producer, Value input, Type resultType, bool unsignedExtension,
    bool nonNegative, bool &skip, const ProducerProofContext &context) {
  FailureOr<ExactCastShape> shape = getExactCastShape(input, resultType, skip);
  if (failed(shape))
    return failure();

  FailureOr<sym::ExprHandle> source =
      buildExpr(input, skip, /*allowLeaf=*/true, context);
  if (skip || failed(source))
    return failure();

  if (unsignedExtension && nonNegative) {
    // Guarded `nneg` must already hold globally.
    if (failed(
            appendNonNegativeCastAssumption(producer, *source, skip, context)))
      return failure();
  }

  if (shape->resultBits == shape->sourceBits)
    return *source;

  if (shape->resultBits > shape->sourceBits)
    return buildWidenedIndexCast(*source, shape->sourceBits, unsignedExtension,
                                 nonNegative);
  return buildNarrowedIndexCast(producer, *source, shape->resultBits, context);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildExactWaveIntegerCast(
    CastOp cast, bool &skip, const ProducerProofContext &context) {
  if (!isStructurallySymbolicIntegerCast(cast, allowI64Integers)) {
    skip = true;
    return failure();
  }

  unsigned sourceBits = elementStorageBitWidth(cast.getSource().getType());
  unsigned resultBits = elementStorageBitWidth(cast.getResult().getType());
  bool unsignedExtension = false;
  if (resultBits > sourceBits) {
    std::optional<DictionaryAttr> policy = cast.getPolicy();
    auto extension = policy ? dyn_cast_or_null<CastExtensionPolicyAttr>(
                                  policy->get("extension"))
                            : CastExtensionPolicyAttr();
    if (!extension)
      return failure();
    unsignedExtension = extension.getValue() == CastExtension::Zero;
  }
  return buildExactIndexCast(cast.getOperation(), cast.getSource(),
                             cast.getResult().getType(), unsignedExtension,
                             /*nonNegative=*/false, skip, context);
}

std::optional<SymbolicValueBuilder::LoopCarriedUpdate>
SymbolicValueBuilder::getLoopCarriedUpdate(BlockArgument arg) {
  if (arg.getArgNumber() == 0)
    return std::nullopt;
  if (!isSymbolicValueType(arg.getType(), allowI64Integers))
    return std::nullopt;
  scf::ForOp loop = dyn_cast_or_null<scf::ForOp>(arg.getOwner()->getParentOp());
  if (!loop)
    return std::nullopt;
  if (arg.getOwner() != loop.getBody())
    return std::nullopt;

  unsigned index = arg.getArgNumber() - 1;
  if (index >= loop.getInitArgs().size())
    return std::nullopt;
  std::optional<int64_t> step = getConstantIntValue(loop.getStep());
  if (!step)
    return std::nullopt;
  if (*step <= 0)
    return std::nullopt;

  // Follow only the scf.for argument's incoming SSA edges.
  scf::YieldOp yield = cast<scf::YieldOp>(loop.getBody()->getTerminator());
  BinaryOp update = yield.getOperand(index).getDefiningOp<BinaryOp>();
  if (!update)
    return std::nullopt;
  if (!canBuildBinary(update))
    return std::nullopt;
  return LoopCarriedUpdate{loop, update, index};
}

std::optional<std::pair<Value, bool>>
SymbolicValueBuilder::getRecurrenceStride(BlockArgument arg, BinaryOp update) {
  if (update.getKind() == BinaryKind::AddI) {
    if (update.getLhs() == arg)
      return std::pair<Value, bool>{update.getRhs(), false};
    if (update.getRhs() == arg)
      return std::pair<Value, bool>{update.getLhs(), false};
    return std::nullopt;
  }
  if (update.getKind() != BinaryKind::SubI)
    return std::nullopt;
  if (update.getLhs() != arg)
    return std::nullopt;
  return std::pair<Value, bool>{update.getRhs(), true};
}

std::optional<SymbolicValueBuilder::LoopCarriedRecurrence>
SymbolicValueBuilder::matchLoopCarriedRecurrence(BlockArgument arg) {
  std::optional<LoopCarriedUpdate> carried = getLoopCarriedUpdate(arg);
  if (!carried)
    return std::nullopt;
  std::optional<std::pair<Value, bool>> stride =
      getRecurrenceStride(arg, carried->update);
  if (!stride)
    return std::nullopt;
  if (!carried->loop.isDefinedOutsideOfLoop(stride->first))
    return std::nullopt;
  if (stride->first.getType() != arg.getType())
    return std::nullopt;
  return LoopCarriedRecurrence{carried->loop, carried->update,
                               carried->loop.getInitArgs()[carried->index],
                               stride->first, stride->second};
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildRecurrenceIteration(
    LoopCarriedRecurrence recurrence, bool &skip,
    const ProducerProofContext &context) {
  FailureOr<sym::ExprHandle> induction =
      buildExpr(recurrence.loop.getInductionVar(), skip, true, context);
  if (failedOrSkipped(induction, skip))
    return failure();
  FailureOr<sym::ExprHandle> lower =
      buildExpr(recurrence.loop.getLowerBound(), skip, true, context);
  if (failedOrSkipped(lower, skip))
    return failure();
  FailureOr<sym::ExprHandle> iteration =
      sym::composeExprBinary(store, *induction, sym::ExprBinaryOp::Sub, *lower);
  if (failed(iteration))
    return failure();

  int64_t step = *getConstantIntValue(recurrence.loop.getStep());
  if (step == 1)
    return iteration;
  FailureOr<sym::ExprHandle> stepExpr = sym::composeExprInt(store, step);
  if (failed(stepExpr))
    return failure();
  FailureOr<sym::ExprHandle> quotient = sym::composeExprBinary(
      store, *iteration, sym::ExprBinaryOp::Div, *stepExpr);
  if (failed(quotient))
    return failure();
  return sym::composeExprFloor(store, *quotient);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildRecurrenceStride(
    LoopCarriedRecurrence recurrence, bool &skip,
    const ProducerProofContext &context) {
  FailureOr<sym::ExprHandle> stride =
      buildExpr(recurrence.stride, skip, true, context);
  if (failedOrSkipped(stride, skip))
    return failure();
  if (!recurrence.subtractStride)
    return stride;
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  if (failed(zero))
    return failure();
  return sym::composeExprBinary(store, *zero, sym::ExprBinaryOp::Sub, *stride);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildLoopCarriedRecurrence(
    LoopCarriedRecurrence recurrence, bool &skip,
    const ProducerProofContext &context) {
  FailureOr<sym::ExprHandle> init =
      buildExpr(recurrence.init, skip, true, context);
  if (failedOrSkipped(init, skip))
    return failure();
  FailureOr<sym::ExprHandle> iteration =
      buildRecurrenceIteration(recurrence, skip, context);
  if (failed(iteration))
    return failure();
  FailureOr<sym::ExprHandle> stride =
      buildRecurrenceStride(recurrence, skip, context);
  if (failed(stride))
    return failure();
  FailureOr<sym::ExprHandle> displacement = sym::composeExprBinary(
      store, *iteration, sym::ExprBinaryOp::Mul, *stride);
  if (failed(displacement))
    return failure();
  FailureOr<sym::ExprHandle> mathematical = sym::composeExprBinary(
      store, *init, sym::ExprBinaryOp::Add, *displacement);
  if (failed(mathematical))
    return failure();

  // Repeated fixed-width add/sub wraps exactly once around the closed form.
  // NSW instead makes the unbounded signed recurrence exact.
  if (recurrence.update.hasNoSignedWrap()) {
    if (failed(appendNoSignedWrapResultRange(recurrence.update, *mathematical,
                                             skip, context)))
      return failure();
    return *mathematical;
  }
  if (!modelWrappingArithmetic) {
    skip = true;
    return failure();
  }
  return buildSignedFixedWidthValue(
      *mathematical,
      elementStorageBitWidth(recurrence.update.getResult().getType()));
}

SymbolicValueBuilder::StateMark SymbolicValueBuilder::markState() const {
  return {offset.bindings.size(),
          offset.assumptions.size(),
          offset.materializations.size(),
          offset.laneWidth,
          nextRawSymbol,
          ssaFactsByValue};
}

void SymbolicValueBuilder::rollbackState(const StateMark &mark) {
  offset.bindings.resize(mark.bindings);
  offset.assumptions.resize(mark.assumptions);
  offset.materializations.resize(mark.materializations);
  offset.laneWidth = mark.laneWidth;
  nextRawSymbol = mark.nextRawSymbol;

  bindingByName.clear();
  nameByValue.clear();
  for (const SymbolicOffsetBinding &binding : offset.bindings) {
    StringRef name = symbolName(binding);
    auto [it, inserted] = bindingByName.try_emplace(name, binding.value);
    (void)inserted;
    nameByValue[binding.value] = it->getKey();
  }
  requiredExprByValue.clear();
  leafExprByValue.clear();
  predicateByValue.clear();
  ssaFactsByValue = mark.ssaFacts;
}

bool SymbolicValueBuilder::rejectsCompoundLeaf(Value value, bool allowLeaf,
                                               bool allowCompoundLeaf) {
  return fullyMergeAssumes && !allowSSAIntermediateLeaves && allowLeaf &&
         !allowCompoundLeaf && !isClosedPacketLeaf(value);
}

bool SymbolicValueBuilder::canBindLeaf(Value value, bool allowLeaf) {
  return allowLeaf && (!fullyMergeAssumes || buildingPredicate ||
                       allowSSAIntermediateLeaves || isClosedPacketLeaf(value));
}

bool SymbolicValueBuilder::importsLeafDefinitionFacts(Value value) {
  return !fullyMergeAssumes || isIrreducibleIndexPacketLeaf(value) ||
         value.getDefiningOp<AssumeOp>();
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::bindOrSkip(Value value, bool &skip, bool allowLeaf,
                                 bool allowCompoundLeaf) {
  // A recognized Wave binary may remain an exact SSA leaf when symbolic
  // expansion fails. Poison-producing inputs do not invalidate that identity:
  // poison can refine to the value carried by the leaf. An unclassified
  // compound producer is still not an opaque proof boundary.
  if (rejectsCompoundLeaf(value, allowLeaf, allowCompoundLeaf)) {
    skip = true;
    return failure();
  }
  // In-memory packets retain exact SSA identity when an inner producer
  // cannot expand; only relations above the leaf remain available.
  if (canBindLeaf(value, allowLeaf))
    return bindSymbol(value, skip, importsLeafDefinitionFacts(value));
  skip = true;
  return failure();
}

bool SymbolicValueBuilder::isClosedPacketLeaf(Value value) {
  return isIrreducibleIndexPacketLeaf(value);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildFullyMergedAssumeExpr(
    Value value, AssumeOp assume, bool &skip,
    const ProducerProofContext &context) {
  bool childSkip = false;
  FailureOr<sym::ExprHandle> expr =
      buildExpr(assume.getValue(), childSkip, /*allowLeaf=*/true, context);
  if (!childSkip && failed(expr))
    return failure();
  if (childSkip) {
    // Do not turn a failed merge of the Assume source into an opaque
    // producer binding.  The caller must keep the entire root in raw SSA.
    skip = true;
    return failure();
  }
  if (failed(appendAssumePredicatesForExpr(assume, *expr)))
    return failure();
  return *expr;
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildAtomicAssumeExpr(Value value, AssumeOp assume,
                                            bool &skip, bool allowLeaf) {
  FailureOr<sym::ExprHandle> expr = bindOrSkip(value, skip, allowLeaf);
  if (failedOrSkipped(expr, skip))
    return expr;
  if (failed(appendAssumePredicatesForExpr(assume, *expr)))
    return failure();
  return *expr;
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildExpandedAssumeExpr(
    Value value, AssumeOp assume, bool &skip, bool allowLeaf,
    const ProducerProofContext &context) {
  bool childSkip = false;
  FailureOr<sym::ExprHandle> expr =
      buildExpr(assume.getValue(), childSkip, allowLeaf, context);
  if (!childSkip && failed(expr))
    return failure();
  if (childSkip)
    return bindOrSkip(value, skip, allowLeaf);
  if (failed(appendAssumePredicatesForExpr(assume, *expr)))
    return failure();
  return *expr;
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildAssumeExpr(Value value, AssumeOp assume, bool &skip,
                                      bool allowLeaf,
                                      const ProducerProofContext &context) {
  // The exact-result policy binds only this dominating Assume result. Its
  // source remains visible in IR, and its predicates stay attached to this
  // result's SSA lineage.
  if (assumeRootPolicy == AssumeRootPolicy::BindExactResult && allowLeaf)
    return bindSymbol(value, skip, /*importDefinitionFacts=*/true);

  // Full packet analysis follows the complete defining tree and remaps this
  // result's predicates onto that expression.
  if (fullyMergeAssumes)
    return buildFullyMergedAssumeExpr(value, assume, skip, context);

  FailureOr<bool> hasAssumeSourceRoot = hasSymbolicRoot(assume.getValue());
  if (failed(hasAssumeSourceRoot))
    return failure();
  if (!*hasAssumeSourceRoot)
    return buildAtomicAssumeExpr(value, assume, skip, allowLeaf);
  return buildExpandedAssumeExpr(value, assume, skip, allowLeaf, context);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildSplatExpr(SplatOp splat, bool &skip, bool allowLeaf,
                                     const ProducerProofContext &context) {
  if (auto simd = dyn_cast<SimdType>(splat.getType()))
    offset.laneWidth =
        std::max(offset.laneWidth, static_cast<unsigned>(simd.getWidth()));
  StateMark mark = markState();
  // Fully merged Splats may terminate at a closed SSA leaf.
  bool allowSourceLeaf = allowLeaf || fullyMergeAssumes;
  bool childSkip = false;
  FailureOr<sym::ExprHandle> expr =
      buildExpr(splat.getSource(), childSkip, allowSourceLeaf, context);
  if (!childSkip)
    return expr;
  rollbackState(mark);
  return bindOrSkip(splat.getSource(), skip, allowSourceLeaf);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildBinaryExpr(Value value, BinaryOp binary, bool &skip,
                                      bool allowLeaf,
                                      const ProducerProofContext &context) {
  StateMark mark = markState();
  bool childSkip = false;
  FailureOr<sym::ExprHandle> expr = buildBinary(binary, childSkip, context);
  if (!childSkip) {
    if (failed(expr)) {
      if (allowSSAIntermediateLeaves && allowLeaf) {
        rollbackState(mark);
        return bindOrSkip(value, skip, allowLeaf,
                          /*allowCompoundLeaf=*/true);
      }
      binary.emitError("failed to compose symbolic binary operation");
    } else {
      offset.materializations.push_back({value, *expr});
    }
    return expr;
  }
  rollbackState(mark);
  return bindOrSkip(value, skip, allowLeaf, /*allowCompoundLeaf=*/true);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildSelectExpr(Value value, SelectOp select, bool &skip,
                                      bool allowLeaf,
                                      const ProducerProofContext &context) {
  StateMark mark = markState();
  bool childSkip = false;
  FailureOr<sym::ExprHandle> expr = buildSelect(select, childSkip, context);
  if (!childSkip)
    return expr;
  rollbackState(mark);
  return bindOrSkip(value, skip, allowLeaf);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildIndexExpr(IndexExprOp op) {
  FailureOr<SymbolicOffset> symbolic = getIndexExprSymbolicOffset(op);
  if (failed(symbolic))
    return failure();
  return appendOffset(op.getResult(), *symbolic);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildBinary(BinaryOp op, bool &skip,
                                  const ProducerProofContext &context) {
  if (!canBuildBinary(op)) {
    skip = true;
    return failure();
  }
  FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>> operands =
      buildBinaryOperands(op, skip, context);
  if (skip || failed(operands))
    return failure();
  return buildNonWrappingBinary(op, *operands, skip, context);
}

bool SymbolicValueBuilder::isDivRemKind(BinaryKind kind) {
  constexpr std::array kinds{BinaryKind::DivSI, BinaryKind::DivUI,
                             BinaryKind::RemSI, BinaryKind::RemUI};
  return llvm::is_contained(kinds, kind);
}

bool SymbolicValueBuilder::isShiftKind(BinaryKind kind) {
  constexpr std::array kinds{BinaryKind::ShLI, BinaryKind::ShRUI,
                             BinaryKind::ShRSI};
  return llvm::is_contained(kinds, kind);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::composeShiftLeft(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    bool &skip) {
  std::optional<int64_t> shift = sym::getIntegerLiteralValue(operands.second);
  unsigned bits = elementStorageBitWidth(op.getResult().getType());
  if (!shift || *shift < 0 || bits == 0 ||
      *shift >= std::min<unsigned>(bits, 63)) {
    skip = true;
    return failure();
  }
  FailureOr<sym::ExprHandle> scale =
      sym::composeExprInt(store, int64_t{1} << *shift);
  if (failed(scale))
    return failure();
  return sym::composeExprBinary(store, operands.first, sym::ExprBinaryOp::Mul,
                                *scale);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildNoUnsignedWrapMathematical(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    sym::ExprHandle unsignedLhs, sym::ExprHandle unsignedRhs, unsigned bits) {
  if (op.getKind() == BinaryKind::ShLI) {
    std::optional<int64_t> shift = sym::getIntegerLiteralValue(operands.second);
    if (!shift || *shift < 0 || *shift >= bits)
      return failure();
    FailureOr<sym::ExprHandle> scale =
        sym::composeExprInt(store, int64_t{1} << *shift);
    if (failed(scale))
      return failure();
    return sym::composeExprBinary(store, unsignedLhs, sym::ExprBinaryOp::Mul,
                                  *scale);
  }
  std::optional<sym::ExprBinaryOp> kind = convertBinaryKind(op.getKind());
  if (!kind)
    return failure();
  return sym::composeExprBinary(store, unsignedLhs, *kind, unsignedRhs);
}

LogicalResult SymbolicValueBuilder::appendNoUnsignedWrapRelation(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    sym::ExprHandle result, bool &skip, const ProducerProofContext &context) {
  if (!op.hasNoUnsignedWrap())
    return success();

  unsigned bits = elementStorageBitWidth(op.getResult().getType());
  if (bits == 0 || bits >= 63) {
    skip = true;
    return failure();
  }

  FailureOr<sym::ExprHandle> unsignedResult =
      buildUnsignedFixedWidthValue(result, bits);
  FailureOr<sym::ExprHandle> unsignedLhs =
      buildUnsignedFixedWidthValue(operands.first, bits);
  FailureOr<sym::ExprHandle> unsignedRhs =
      buildUnsignedFixedWidthValue(operands.second, bits);
  if (failed(unsignedResult) || failed(unsignedLhs) || failed(unsignedRhs))
    return failure();

  FailureOr<sym::ExprHandle> mathematical = buildNoUnsignedWrapMathematical(
      op, operands, *unsignedLhs, *unsignedRhs, bits);
  if (failed(mathematical))
    return failure();
  FailureOr<sym::PredHandle> exact = sym::composePredCmp(
      store, *unsignedResult, sym::PredCmpOp::Eq, *mathematical);
  if (failed(exact))
    return failure();
  std::array<sym::PredHandle, 1> assumption{*exact};
  return appendRequiredAssumptions(assumption, op.getOperation(), skip,
                                   context);
}

LogicalResult SymbolicValueBuilder::appendNoSignedWrapResultRange(
    BinaryOp op, sym::ExprHandle mathematical, bool &skip,
    const ProducerProofContext &context) {
  if (!op.hasNoSignedWrap())
    return success();
  unsigned bits = elementStorageBitWidth(op.getResult().getType());
  if (bits == 0) {
    skip = true;
    return failure();
  }
  std::optional<SignedI64Range> range =
      getSignedStorageRange(op.getResult().getType());
  if (!range) {
    skip = true;
    return failure();
  }
  SmallVector<sym::PredHandle, 2> assumptions;
  if (failed(appendExprSignedRangeAssumption(store, mathematical, *range,
                                             assumptions)))
    return failure();
  return appendRequiredAssumptions(assumptions, op.getOperation(), skip,
                                   context);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildMathematicalArithmetic(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    bool &skip) {
  if (op.getKind() == BinaryKind::ShLI)
    return composeShiftLeft(op, operands, skip);
  std::optional<sym::ExprBinaryOp> kind = convertBinaryKind(op.getKind());
  if (!kind)
    return failure();
  return sym::composeExprBinary(store, operands.first, *kind, operands.second);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildArithmeticResult(
    BinaryOp op, sym::ExprHandle mathematical, bool &skip) {
  if (op.hasNoSignedWrap() || assumeAddressArithmeticNoOverflow)
    return mathematical;
  if (modelWrappingArithmetic && (isWrappingArithmeticKind(op.getKind()) ||
                                  op.getKind() == BinaryKind::ShLI)) {
    FailureOr<sym::ExprHandle> wrapped = buildSignedFixedWidthValue(
        mathematical, elementStorageBitWidth(op.getResult().getType()));
    if (failed(wrapped))
      skip = true;
    return wrapped;
  }
  skip = true;
  return failure();
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildArithmetic(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    bool &skip, const ProducerProofContext &context) {
  FailureOr<sym::ExprHandle> mathematical =
      buildMathematicalArithmetic(op, operands, skip);
  if (skip || failed(mathematical))
    return failure();

  // NSW admits the mathematical expression as a total extension on every
  // defined execution; other integer arithmetic keeps bit-pattern semantics.
  FailureOr<sym::ExprHandle> result =
      buildArithmeticResult(op, *mathematical, skip);
  if (failed(result) ||
      failed(appendNoSignedWrapResultRange(op, *mathematical, skip, context)) ||
      failed(
          appendNoUnsignedWrapRelation(op, operands, *result, skip, context)))
    return failure();
  return *result;
}

bool SymbolicValueBuilder::isArithmeticKind(BinaryKind kind) {
  constexpr std::array kinds{BinaryKind::AddI, BinaryKind::SubI,
                             BinaryKind::MulI, BinaryKind::ShLI};
  return llvm::is_contained(kinds, kind);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildNonWrappingBinary(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    bool &skip, const ProducerProofContext &context) {
  if (isArithmeticKind(op.getKind()))
    return buildArithmetic(op, operands, skip, context);
  switch (op.getKind()) {
  case BinaryKind::DivSI:
    return buildSignedDiv(op, operands, skip, context);
  case BinaryKind::DivUI:
    return buildUnsignedDiv(op, operands, skip, context);
  case BinaryKind::RemSI:
  case BinaryKind::RemUI:
    return buildRemainder(op, operands, skip, context);
  case BinaryKind::ShRUI:
    return buildUnsignedShiftRight(op, operands, skip);
  case BinaryKind::AndI:
    return buildAnd(operands);
  default:
    return buildPlainBinary(op, operands, skip);
  }
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildUnsigned64Value(sym::ExprHandle mathematical) {
  FailureOr<sym::ExprHandle> limbBase =
      sym::composeExprInt(store, int64_t{1} << 32);
  if (failed(limbBase))
    return failure();
  FailureOr<sym::ExprHandle> low = sym::composeExprBinary(
      store, mathematical, sym::ExprBinaryOp::Mod, *limbBase);
  FailureOr<sym::ExprHandle> quotient = sym::composeExprBinary(
      store, mathematical, sym::ExprBinaryOp::Div, *limbBase);
  if (failed(low) || failed(quotient))
    return failure();
  FailureOr<sym::ExprHandle> highFloor =
      sym::composeExprFloor(store, *quotient);
  if (failed(highFloor))
    return failure();
  FailureOr<sym::ExprHandle> high = sym::composeExprBinary(
      store, *highFloor, sym::ExprBinaryOp::Mod, *limbBase);
  if (failed(high))
    return failure();
  FailureOr<sym::ExprHandle> scaledHigh =
      sym::composeExprBinary(store, *high, sym::ExprBinaryOp::Mul, *limbBase);
  if (failed(scaledHigh))
    return failure();
  return sym::composeExprBinary(store, *low, sym::ExprBinaryOp::Add,
                                *scaledHigh);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildUnsignedFixedWidthValue(sym::ExprHandle mathematical,
                                                   unsigned bitWidth) {
  if (bitWidth > 0 && bitWidth < 63) {
    FailureOr<sym::ExprHandle> modulus =
        sym::composeExprInt(store, int64_t{1} << bitWidth);
    if (failed(modulus))
      return failure();
    return sym::composeExprBinary(store, mathematical, sym::ExprBinaryOp::Mod,
                                  *modulus);
  }
  if (bitWidth != 64)
    return failure();
  return buildUnsigned64Value(mathematical);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildSignedHighLimb(sym::ExprHandle highFloor,
                                          sym::ExprHandle limbBase,
                                          sym::ExprHandle signBit) {
  FailureOr<sym::ExprHandle> highUnsigned = sym::composeExprBinary(
      store, highFloor, sym::ExprBinaryOp::Mod, limbBase);
  if (failed(highUnsigned))
    return failure();
  FailureOr<sym::ExprHandle> biasedHigh = sym::composeExprBinary(
      store, *highUnsigned, sym::ExprBinaryOp::Add, signBit);
  if (failed(biasedHigh))
    return failure();
  FailureOr<sym::ExprHandle> wrappedHigh = sym::composeExprBinary(
      store, *biasedHigh, sym::ExprBinaryOp::Mod, limbBase);
  if (failed(wrappedHigh))
    return failure();
  return sym::composeExprBinary(store, *wrappedHigh, sym::ExprBinaryOp::Sub,
                                signBit);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildSigned64Value(sym::ExprHandle mathematical) {
  FailureOr<sym::ExprHandle> limbBase =
      sym::composeExprInt(store, int64_t{1} << 32);
  FailureOr<sym::ExprHandle> signBit =
      sym::composeExprInt(store, int64_t{1} << 31);
  if (failed(limbBase) || failed(signBit))
    return failure();
  FailureOr<sym::ExprHandle> low = sym::composeExprBinary(
      store, mathematical, sym::ExprBinaryOp::Mod, *limbBase);
  FailureOr<sym::ExprHandle> quotient = sym::composeExprBinary(
      store, mathematical, sym::ExprBinaryOp::Div, *limbBase);
  if (failed(low) || failed(quotient))
    return failure();
  FailureOr<sym::ExprHandle> highFloor =
      sym::composeExprFloor(store, *quotient);
  FailureOr<sym::ExprHandle> high =
      succeeded(highFloor)
          ? buildSignedHighLimb(*highFloor, *limbBase, *signBit)
          : FailureOr<sym::ExprHandle>(failure());
  if (failed(high))
    return failure();
  FailureOr<sym::ExprHandle> scaledHigh =
      sym::composeExprBinary(store, *high, sym::ExprBinaryOp::Mul, *limbBase);
  if (failed(scaledHigh))
    return failure();
  return sym::composeExprBinary(store, *low, sym::ExprBinaryOp::Add,
                                *scaledHigh);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildNarrowSignedValue(sym::ExprHandle mathematical,
                                             unsigned bitWidth) {
  if (bitWidth == 0 || bitWidth >= 63)
    return failure();
  FailureOr<sym::ExprHandle> bias =
      sym::composeExprInt(store, int64_t{1} << (bitWidth - 1));
  FailureOr<sym::ExprHandle> modulus =
      sym::composeExprInt(store, int64_t{1} << bitWidth);
  if (failed(bias) || failed(modulus))
    return failure();
  FailureOr<sym::ExprHandle> biased = sym::composeExprBinary(
      store, mathematical, sym::ExprBinaryOp::Add, *bias);
  if (failed(biased))
    return failure();
  FailureOr<sym::ExprHandle> wrapped =
      sym::composeExprBinary(store, *biased, sym::ExprBinaryOp::Mod, *modulus);
  if (failed(wrapped))
    return failure();
  return sym::composeExprBinary(store, *wrapped, sym::ExprBinaryOp::Sub, *bias);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildSignedFixedWidthValue(sym::ExprHandle mathematical,
                                                 unsigned bitWidth) {
  if (bitWidth == 64)
    return buildSigned64Value(mathematical);
  return buildNarrowSignedValue(mathematical, bitWidth);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::buildSelect(SelectOp op, bool &skip,
                                  const ProducerProofContext &context) {
  if (!isStructurallySymbolicSelect(op, allowI64Integers)) {
    skip = true;
    return failure();
  }

  FailureOr<sym::PredHandle> condition =
      buildSelectCondition(op, skip, context);
  if (skip || failed(condition))
    return failure();
  FailureOr<sym::ExprHandle> trueValue =
      buildConditionalExprArm(op.getTrueValue(), skip, context);
  if (skip || failed(trueValue))
    return failure();
  FailureOr<sym::ExprHandle> falseValue =
      buildConditionalExprArm(op.getFalseValue(), skip, context);
  if (skip || failed(falseValue))
    return failure();
  FailureOr<sym::PredHandle> defaultCondition = sym::composePredTrue(store);
  if (failed(defaultCondition))
    return failure();
  std::array<sym::PiecewiseCase, 2> cases{
      sym::PiecewiseCase{*trueValue, *condition},
      sym::PiecewiseCase{*falseValue, *defaultCondition}};
  return sym::composeExprPiecewise(store, cases);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildConditionalExprArm(
    Value value, bool &skip, const ProducerProofContext &context) {
  ProducerProofContext armContext = context.forConditionalArm();
  return buildExpr(value, skip, /*allowLeaf=*/true, armContext);
}

FailureOr<sym::PredHandle> SymbolicValueBuilder::buildConditionalPredicateArm(
    Value value, bool &skip, const ProducerProofContext &context) {
  ProducerProofContext armContext = context.forConditionalArm();
  return buildPredicateExpr(value, skip, armContext);
}

FailureOr<sym::PredHandle> SymbolicValueBuilder::buildSelectCondition(
    SelectOp op, bool &skip, const ProducerProofContext &context) {
  return buildPredicateExpr(op.getCondition(), skip, context);
}

FailureOr<sym::PredHandle>
SymbolicValueBuilder::buildCmpPredicate(CmpIOp op, bool &skip,
                                        const ProducerProofContext &context) {
  return buildCmpPredicate(op.getPredicate(), op.getLhs(), op.getRhs(), skip,
                           context);
}

FailureOr<std::optional<sym::PredHandle>>
SymbolicValueBuilder::buildBooleanSelectComparison(
    arith::CmpIPredicate predicate, Value lhs, Value rhs, bool &skip,
    const ProducerProofContext &context) {
  FailureOr<std::optional<BooleanSelectComparison>> match =
      matchBooleanSelectComparison(predicate, lhs, rhs, store);
  if (failed(match))
    return failure();
  if (!*match)
    return std::optional<sym::PredHandle>{};
  FailureOr<sym::PredHandle> recovered =
      buildBooleanSelectComparison(**match, skip, context);
  if (failed(recovered))
    return failure();
  return std::optional<sym::PredHandle>{*recovered};
}

FailureOr<sym::PredHandle> SymbolicValueBuilder::buildBooleanSelectComparison(
    BooleanSelectComparison match, bool &skip,
    const ProducerProofContext &context) {
  if (match.trueResult == match.falseResult)
    return match.trueResult ? sym::composePredTrue(store)
                            : sym::composePredFalse(store);
  FailureOr<sym::PredHandle> condition =
      buildPredicateExpr(match.select.getCondition(), skip, context);
  if (failedOrSkipped(condition, skip))
    return failure();
  appendSSAFacts(match.carrier, getSSAFacts(match.select.getCondition()));
  if (match.trueResult)
    return condition;
  return sym::composePredNot(store, *condition);
}

FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>>
SymbolicValueBuilder::buildComparisonOperands(
    Value lhsValue, Value rhsValue, bool &skip,
    const ProducerProofContext &context) {
  FailureOr<sym::ExprHandle> lhs = buildExpr(lhsValue, skip, true, context);
  if (failedOrSkipped(lhs, skip))
    return failure();
  FailureOr<sym::ExprHandle> rhs = buildExpr(rhsValue, skip, true, context);
  if (failedOrSkipped(rhs, skip))
    return failure();
  return std::pair<sym::ExprHandle, sym::ExprHandle>{*lhs, *rhs};
}

FailureOr<SymbolicValueBuilder::BuiltComparison>
SymbolicValueBuilder::prepareComparison(
    arith::CmpIPredicate predicate, Value lhsValue, Value rhsValue,
    std::pair<sym::ExprHandle, sym::ExprHandle> operands, bool &skip) {
  if (std::optional<sym::PredCmpOp> converted =
          convertSignedCmpPredicate(predicate))
    return BuiltComparison{operands.first, operands.second, *converted};
  std::optional<sym::PredCmpOp> converted =
      convertUnsignedCmpPredicate(predicate);
  unsigned lhsBits = elementStorageBitWidth(lhsValue.getType());
  unsigned rhsBits = elementStorageBitWidth(rhsValue.getType());
  if (!converted || lhsBits == 0 || lhsBits != rhsBits) {
    skip = true;
    return failure();
  }
  FailureOr<sym::ExprHandle> lhs =
      buildUnsignedFixedWidthValue(operands.first, lhsBits);
  FailureOr<sym::ExprHandle> rhs =
      buildUnsignedFixedWidthValue(operands.second, rhsBits);
  if (failed(lhs) || failed(rhs))
    return failure();
  return BuiltComparison{*lhs, *rhs, *converted};
}

FailureOr<sym::PredHandle> SymbolicValueBuilder::buildCmpPredicate(
    arith::CmpIPredicate predicate, Value lhsValue, Value rhsValue, bool &skip,
    const ProducerProofContext &context) {
  FailureOr<std::optional<sym::PredHandle>> select =
      buildBooleanSelectComparison(predicate, lhsValue, rhsValue, skip,
                                   context);
  if (failed(select))
    return failure();
  if (*select)
    return **select;

  FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>> operands =
      buildComparisonOperands(lhsValue, rhsValue, skip, context);
  if (failed(operands))
    return failure();
  FailureOr<BuiltComparison> comparison =
      prepareComparison(predicate, lhsValue, rhsValue, *operands, skip);
  if (failed(comparison))
    return failure();
  return sym::composePredCmp(store, comparison->lhs, comparison->predicate,
                             comparison->rhs);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildPlainBinary(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    bool &skip) {
  std::optional<sym::ExprBinaryOp> kind = convertBinaryKind(op.getKind());
  if (!kind) {
    skip = true;
    return failure();
  }
  return sym::composeExprBinary(store, operands.first, *kind, operands.second);
}

std::optional<sym::ExprBinaryOp>
SymbolicValueBuilder::convertBinaryKind(BinaryKind kind) {
  switch (kind) {
  case BinaryKind::AddI:
    return sym::ExprBinaryOp::Add;
  case BinaryKind::SubI:
    return sym::ExprBinaryOp::Sub;
  case BinaryKind::MulI:
    return sym::ExprBinaryOp::Mul;
  case BinaryKind::XOrI:
    return sym::ExprBinaryOp::Xor;
  case BinaryKind::AndI:
    return sym::ExprBinaryOp::And;
  case BinaryKind::OrI:
    return sym::ExprBinaryOp::Or;
  default:
    return std::nullopt;
  }
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildUnsignedShiftRight(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    bool &skip) {
  std::optional<int64_t> shift = sym::getIntegerLiteralValue(operands.second);
  unsigned bits = elementStorageBitWidth(op.getResult().getType());
  if (!shift || *shift < 0 || bits == 0 ||
      *shift >= std::min<unsigned>(bits, 63)) {
    skip = true;
    return failure();
  }
  if (*shift == 0)
    return operands.first;
  FailureOr<sym::ExprHandle> unsignedLhs =
      buildUnsignedFixedWidthValue(operands.first, bits);
  FailureOr<sym::ExprHandle> rhs =
      sym::composeExprInt(store, int64_t{1} << *shift);
  if (failed(unsignedLhs) || failed(rhs))
    return failure();
  FailureOr<sym::ExprHandle> div =
      sym::composeExprBinary(store, *unsignedLhs, sym::ExprBinaryOp::Div, *rhs);
  if (failed(div))
    return failure();
  return sym::composeExprFloor(store, *div);
}

FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>>
SymbolicValueBuilder::buildBinaryOperands(BinaryOp op, bool &skip,
                                          const ProducerProofContext &context) {
  FailureOr<sym::ExprHandle> lhs = buildExpr(op.getLhs(), skip, true, context);
  if (skip || failed(lhs))
    return failure();
  FailureOr<sym::ExprHandle> rhs = buildExpr(op.getRhs(), skip, true, context);
  if (skip || failed(rhs))
    return failure();
  return std::pair<sym::ExprHandle, sym::ExprHandle>{*lhs, *rhs};
}

FailureOr<bool>
SymbolicValueBuilder::provePredicates(ArrayRef<sym::PredHandle> predicates,
                                      Operation *producer,
                                      const ProducerProofContext &context) {
  SmallVector<sym::PredHandle, 8> prerequisites(offset.assumptions.begin(),
                                                offset.assumptions.end());
  for (Value operand : producer->getOperands())
    for (sym::PredHandle fact : getSSAFacts(operand))
      if (!llvm::is_contained(prerequisites, fact))
        prerequisites.push_back(fact);
  // The explicit retained-arm context may suppress poison from that exact
  // Select operand. It owns no Assume facts and is never exported.
  if (context.retainedArm)
    prerequisites.push_back(context.retainedArm->guard);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      createClosedIndexExprAnalysis(store, prerequisites);
  if (failed(analysis))
    return failure();
  return checkCompletePredicate(**analysis, predicates);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildUnsignedDiv(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    bool &skip, const ProducerProofContext &context) {
  unsigned bits = elementStorageBitWidth(op.getResult().getType());
  // Reject unconstrained u64 wrap instead of expanding pathological limbs.
  if (bits == 0 || bits >= 64) {
    skip = true;
    return failure();
  }
  FailureOr<sym::ExprHandle> lhs =
      buildUnsignedFixedWidthValue(operands.first, bits);
  FailureOr<sym::ExprHandle> rhs =
      buildUnsignedFixedWidthValue(operands.second, bits);
  if (failed(lhs) || failed(rhs))
    return failure();
  std::optional<int64_t> divisor = sym::getIntegerLiteralValue(*rhs);
  if (!divisor)
    return bindSymbol(op.getResult(), skip,
                      /*importDefinitionFacts=*/false);
  if (*divisor == 0)
    return sym::composeExprInt(store, 0);
  FailureOr<sym::ExprHandle> div =
      sym::composeExprBinary(store, *lhs, sym::ExprBinaryOp::Div, *rhs);
  if (failed(div))
    return failure();
  FailureOr<sym::ExprHandle> quotient = sym::composeExprFloor(store, *div);
  if (failed(quotient))
    return failure();
  return buildSignedFixedWidthValue(*quotient, bits);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildUnsignedRemainder(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    bool &skip, const ProducerProofContext &context) {
  unsigned bits = elementStorageBitWidth(op.getResult().getType());
  if (bits == 0 || bits >= 64) {
    skip = true;
    return failure();
  }
  FailureOr<sym::ExprHandle> lhs =
      buildUnsignedFixedWidthValue(operands.first, bits);
  FailureOr<sym::ExprHandle> rhs =
      buildUnsignedFixedWidthValue(operands.second, bits);
  if (failed(lhs) || failed(rhs))
    return failure();
  std::optional<int64_t> divisor = sym::getIntegerLiteralValue(*rhs);
  if (!divisor)
    return bindSymbol(op.getResult(), skip,
                      /*importDefinitionFacts=*/false);
  if (*divisor == 0)
    return sym::composeExprInt(store, 0);
  FailureOr<sym::ExprHandle> result =
      sym::composeExprBinary(store, *lhs, sym::ExprBinaryOp::Mod, *rhs);
  if (failed(result))
    return failure();
  return buildSignedFixedWidthValue(*result, bits);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildSignedRemainder(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    bool &skip, const ProducerProofContext &context) {
  std::optional<int64_t> divisor = sym::getIntegerLiteralValue(operands.second);
  if (!divisor)
    return bindSymbol(op.getResult(), skip,
                      /*importDefinitionFacts=*/false);
  if (*divisor == 0)
    return sym::composeExprInt(store, 0);
  FailureOr<sym::ExprHandle> quotient = buildSignedQuotient(operands);
  FailureOr<sym::ExprHandle> product =
      failed(quotient)
          ? FailureOr<sym::ExprHandle>(failure())
          : sym::composeExprBinary(store, operands.second,
                                   sym::ExprBinaryOp::Mul, *quotient);
  return failed(product)
             ? FailureOr<sym::ExprHandle>(failure())
             : sym::composeExprBinary(store, operands.first,
                                      sym::ExprBinaryOp::Sub, *product);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildRemainder(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    bool &skip, const ProducerProofContext &context) {
  if (op.getKind() == BinaryKind::RemUI)
    return buildUnsignedRemainder(op, operands, skip, context);
  return buildSignedRemainder(op, operands, skip, context);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildSignedQuotient(
    const std::pair<sym::ExprHandle, sym::ExprHandle> &operands) {
  FailureOr<sym::ExprHandle> ratio = sym::composeExprBinary(
      store, operands.first, sym::ExprBinaryOp::Div, operands.second);
  return failed(ratio) ? FailureOr<sym::ExprHandle>(failure())
                       : sym::composeExprTrunc(store, *ratio);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildSignedDiv(
    BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
    bool &skip, const ProducerProofContext &context) {
  std::optional<int64_t> divisor = sym::getIntegerLiteralValue(operands.second);
  if (!divisor)
    return bindSymbol(op.getResult(), skip,
                      /*importDefinitionFacts=*/false);
  if (*divisor == 0)
    return sym::composeExprInt(store, 0);
  FailureOr<sym::ExprHandle> quotient = buildSignedQuotient(operands);
  if (failed(quotient))
    return failure();
  unsigned bits = elementStorageBitWidth(op.getResult().getType());
  return bits == 0 ? FailureOr<sym::ExprHandle>(failure())
                   : buildSignedFixedWidthValue(*quotient, bits);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::buildAnd(
    const std::pair<sym::ExprHandle, sym::ExprHandle> &operands) {
  return sym::composeExprBinary(store, operands.first, sym::ExprBinaryOp::And,
                                operands.second);
}

LogicalResult SymbolicValueBuilder::appendRequiredAssumptions(
    ArrayRef<sym::PredHandle> assumptions, Operation *producer, bool &skip,
    const ProducerProofContext &context) {
  if (!context.requireProof) {
    llvm::append_range(offset.assumptions, assumptions);
    return success();
  }

  // A producer can consume only facts carried by its direct operands. The
  // retained true-arm guard is an additional definedness condition, never
  // an owner or transport for an Assume fact.
  FailureOr<bool> proved = provePredicates(assumptions, producer, context);
  if (failed(proved))
    return failure();
  if (!*proved) {
    skip = true;
    return failure();
  }
  return success();
}

LogicalResult SymbolicValueBuilder::appendSSAAssumptions(
    Value carrier, ArrayRef<sym::PredHandle> assumptions) {
  appendSSAFacts(carrier, assumptions);
  return success();
}

LogicalResult
SymbolicValueBuilder::appendAssumePredicatesForExpr(AssumeOp assume,
                                                    sym::ExprHandle expr) {
  FailureOr<sym::ExprHandle> target =
      sym::composeExprSym(store, assume.getName());
  if (failed(target))
    return failure();

  SmallVector<sym::PredHandle, 4> predicates;
  for (Attribute attr : assume.getAssumptions())
    predicates.push_back(cast<PredAttr>(attr).getValue());
  std::array<sym::ExprSubstitution, 1> substitutions{
      sym::ExprSubstitution{*target, expr}};
  FailureOr<SmallVector<sym::PredHandle>> remapped =
      substituteGeneratedPredicates(store, predicates, substitutions);
  if (failed(remapped))
    return failure();
  return appendSSAAssumptions(assume.getResult(), *remapped);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::bindSymbol(Value value, bool &skip,
                                 bool importDefinitionFacts) {
  std::optional<SymbolicOffsetBindingKind> kind =
      classifyBindingType(value.getType());
  if (!kind) {
    skip = true;
    return failure();
  }

  auto valueIt = nameByValue.find(value);
  if (valueIt != nameByValue.end())
    return sym::composeExprSym(store, valueIt->second);

  std::string name = freshName();
  FailureOr<sym::ExprHandle> expr = sym::composeExprSym(store, name);
  if (failed(expr))
    return failure();
  if (*kind == SymbolicOffsetBindingKind::Lane)
    offset.laneWidth = std::max(
        offset.laneWidth, unsigned(cast<SimdType>(value.getType()).getWidth()));
  auto [it, inserted] = bindingByName.try_emplace(name, value);
  (void)inserted;
  nameByValue[value] = it->getKey();
  offset.bindings.push_back({*expr, value, *kind});
  if (failed(
          appendSymbolAssumptions(value, it->getKey(), importDefinitionFacts)))
    return failure();
  return *expr;
}

LogicalResult
SymbolicValueBuilder::appendSymbolDefinitionAssumptions(Value value,
                                                        StringRef name) {
  SmallVector<sym::PredHandle, 4> assumptions;
  appendAssumePredicates(store, value, name, assumptions);
  if (ReadFirstOp readFirst = value.getDefiningOp<ReadFirstOp>())
    appendAssumePredicates(store, readFirst.getSource(), name, assumptions);
  return appendSSAAssumptions(value, assumptions);
}

LogicalResult
SymbolicValueBuilder::appendSymbolRangeAssumption(Value value, StringRef name) {
  if (std::optional<SignedI64Range> semanticRange =
          getAtomicLeafSemanticRange(value))
    return appendSignedRangeAssumption(store, name, semanticRange->first,
                                       semanticRange->second,
                                       offset.assumptions);
  if (assumeI32StorageRange && isSignlessI32StorageType(value.getType()))
    return appendSignedI32StorageRangeAssumption(store, name,
                                                 offset.assumptions);
  return success();
}

LogicalResult
SymbolicValueBuilder::appendSymbolAssumptions(Value value, StringRef name,
                                              bool importDefinitionFacts) {
  // Assume facts belong to this SSA result; storage and intrinsic ranges are
  // total properties of the bound value.
  if (importDefinitionFacts &&
      failed(appendSymbolDefinitionAssumptions(value, name)))
    return failure();
  return appendSymbolRangeAssumption(value, name);
}

std::optional<SymbolicOffsetBindingKind>
SymbolicValueBuilder::classifyBindingType(Type type) {
  if (type.isIndex())
    return SymbolicOffsetBindingKind::Uniform;
  if (auto intType = dyn_cast<IntegerType>(type)) {
    if (!intType.isSignless())
      return std::nullopt;
    return SymbolicOffsetBindingKind::Uniform;
  }
  if (auto simdType = dyn_cast<SimdType>(type)) {
    Type element = simdType.getElementType();
    if (element.isIndex() || element.isInteger(32) ||
        (allowI64Integers && element.isInteger(64)))
      return SymbolicOffsetBindingKind::Lane;
  }
  return std::nullopt;
}

LogicalResult SymbolicValueBuilder::appendSymbolSubstitution(
    sym::ExprHandle source, StringRef replacementName,
    SmallVectorImpl<sym::ExprSubstitution> &substitutions) {
  FailureOr<sym::ExprHandle> replacement =
      sym::composeExprSym(store, replacementName);
  if (failed(replacement))
    return failure();
  substitutions.push_back({source, *replacement});
  return success();
}

void SymbolicValueBuilder::appendNewOffsetBinding(
    const SymbolicOffsetBinding &binding, const SymbolicOffset &symbolic) {
  StringRef name = symbolName(binding);
  auto [it, inserted] = bindingByName.try_emplace(name, binding.value);
  (void)inserted;
  nameByValue[binding.value] = it->getKey();
  offset.bindings.push_back(binding);
  offset.laneWidth = std::max(offset.laneWidth, symbolic.laneWidth);
}

LogicalResult SymbolicValueBuilder::appendFreshOffsetBinding(
    const SymbolicOffsetBinding &binding, const SymbolicOffset &symbolic,
    SmallVectorImpl<sym::ExprSubstitution> &substitutions) {
  std::string fresh = freshName(symbolName(binding));
  auto [freshIt, inserted] = bindingByName.try_emplace(fresh, binding.value);
  (void)inserted;
  nameByValue[binding.value] = freshIt->getKey();
  FailureOr<sym::ExprHandle> replacement =
      sym::composeExprSym(store, freshIt->getKey());
  if (failed(replacement))
    return failure();
  offset.bindings.push_back({*replacement, binding.value, binding.kind});
  offset.laneWidth = std::max(offset.laneWidth, symbolic.laneWidth);
  substitutions.push_back({binding.name, *replacement});
  return success();
}

LogicalResult SymbolicValueBuilder::appendNamedOffsetBinding(
    const SymbolicOffsetBinding &binding, const SymbolicOffset &symbolic,
    SmallVectorImpl<sym::ExprSubstitution> &substitutions) {
  StringRef name = symbolName(binding);
  auto valueIt = nameByValue.find(binding.value);
  if (valueIt != nameByValue.end())
    return appendSymbolSubstitution(binding.name, valueIt->second,
                                    substitutions);

  auto existing = bindingByName.find(name);
  if (existing == bindingByName.end()) {
    appendNewOffsetBinding(binding, symbolic);
    return success();
  }
  if (existing->second == binding.value)
    return success();
  return appendFreshOffsetBinding(binding, symbolic, substitutions);
}

FailureOr<sym::ExprHandle> SymbolicValueBuilder::appendOffsetExpr(
    Value carrier, const SymbolicOffset &symbolic,
    ArrayRef<sym::ExprSubstitution> substitutions) {
  if (substitutions.empty()) {
    if (failed(appendSSAAssumptions(carrier, symbolic.assumptions)))
      return failure();
    return symbolic.expr;
  }
  FailureOr<SmallVector<sym::PredHandle>> assumptions =
      substituteGeneratedPredicates(store, symbolic.assumptions, substitutions);
  if (failed(assumptions))
    return failure();
  if (failed(appendSSAAssumptions(carrier, *assumptions)))
    return failure();
  return sym::substituteExpr(store, symbolic.expr, substitutions);
}

FailureOr<sym::ExprHandle>
SymbolicValueBuilder::appendOffset(Value carrier,
                                   const SymbolicOffset &symbolic) {
  SmallVector<sym::ExprSubstitution> substitutions;
  for (const SymbolicOffsetBinding &binding : symbolic.bindings)
    if (failed(appendNamedOffsetBinding(binding, symbolic, substitutions)))
      return failure();
  return appendOffsetExpr(carrier, symbolic, substitutions);
}

std::string SymbolicValueBuilder::freshName(StringRef stem) {
  return getFreshIndexExprBindingName(stem, bindingByName, nextRawSymbol);
}
} // namespace mlir::wave::detail

namespace mlir::wave {

FailureOr<std::optional<SymbolicOffset>>
buildSymbolicIntegerPacket(Value value, WaveDialect &dialect) {
  auto buildCandidate = [&](detail::AssumeRootPolicy assumePolicy,
                            bool allowIntermediateLeaves) {
    // In-memory packets permit i64 bindings forbidden by wave.index_expr.
    detail::SymbolicValueBuilder builder(
        dialect, /*allowI64Integers=*/true,
        /*assumeI32StorageRange=*/true, /*expandIndexExprRoot=*/true,
        /*foldWaveConstants=*/true, /*modelWrappingArithmetic=*/true,
        /*fullyMergeAssumes=*/true, assumePolicy);
    builder.enableExactIntegerCasts();
    if (allowIntermediateLeaves)
      builder.enableSSAIntermediateLeaves();
    return builder.buildAllowingRootLeaf(value);
  };

  if (detail::isAtomicAssumeResultCandidate(value)) {
    FailureOr<std::optional<SymbolicOffset>> exact =
        buildCandidate(detail::AssumeRootPolicy::BindExactResult,
                       /*allowIntermediateLeaves=*/false);
    if (failed(exact) || *exact)
      return exact;
  }

  return buildCandidate(detail::AssumeRootPolicy::ExpandSource,
                        /*allowIntermediateLeaves=*/true);
}

FailureOr<std::optional<SymbolicPredicate>>
buildSymbolicMaskPredicate(Value value, WaveDialect &dialect) {
  auto build = [&](bool retainGuardedRoot) {
    detail::SymbolicValueBuilder builder(
        dialect, /*allowI64Integers=*/false,
        /*assumeI32StorageRange=*/true, /*expandIndexExprRoot=*/true,
        /*foldWaveConstants=*/true, /*modelWrappingArithmetic=*/true,
        /*fullyMergeAssumes=*/true, detail::AssumeRootPolicy::BindExactResult);
    builder.enableExactIntegerCasts();
    builder.enableSSAIntermediateLeaves();
    return retainGuardedRoot ? builder.buildPredicateRetainingGuardedRoot(value)
                             : builder.buildPredicate(value);
  };
  FailureOr<std::optional<SymbolicPredicate>> guarded = build(true);
  if (failed(guarded) || *guarded)
    return guarded;
  return build(false);
}

} // namespace mlir::wave
