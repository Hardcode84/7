//===- WaveSymbolicValueAnalysis.h - Private symbolic SSA engine -*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVESYMBOLICVALUEANALYSIS_H
#define MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVESYMBOLICVALUEANALYSIS_H

#include "../IR/WaveIndexExpr.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/Transforms/SymbolicValue.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/ScopeExit.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/MathExtras.h"
#include <algorithm>
#include <array>
#include <cassert>
#include <limits>
#include <optional>
#include <string>

namespace mlir::wave::detail {

static inline StringRef symbolName(const SymbolicOffsetBinding &binding) {
  StringRef name = sym::ExprView(binding.name).getSymbolName();
  assert(!name.empty() && "symbolic offset binding must have a name");
  return name;
}

static inline FailureOr<bool>
queryProvesTrue(FailureOr<sym::CheckResult> query) {
  if (failed(query))
    return failure();
  return *query == sym::CheckResult::True;
}

static inline FailureOr<sym::PredHandle> composeEqual(sym::Analysis &analysis,
                                                      sym::ExprHandle lhs,
                                                      sym::ExprHandle rhs) {
  return analysis.compare(lhs, sym::PredCmpOp::Eq, rhs);
}

static inline FailureOr<bool>
checkCompletePredicate(sym::Analysis &analysis,
                       ArrayRef<sym::PredHandle> predicates) {
  for (sym::PredHandle predicate : predicates) {
    FailureOr<bool> proven = queryProvesTrue(analysis.check(predicate));
    if (failed(proven))
      return failure();
    if (!*proven)
      return false;
  }
  return true;
}

static inline FailureOr<bool> checkIntegerValidity(sym::Analysis &analysis,
                                                   sym::ExprHandle expr) {
  if (sym::isIntegerValued(expr))
    return true;
  FailureOr<sym::ExprHandle> integral = analysis.composeFloor(expr);
  if (failed(integral))
    return failure();
  FailureOr<sym::PredHandle> integer = composeEqual(analysis, expr, *integral);
  if (failed(integer))
    return failure();
  std::array<sym::PredHandle, 1> predicates{*integer};
  return checkCompletePredicate(analysis, predicates);
}

// Preserve serialized predicate order and duplicates during remapping.
static inline FailureOr<SmallVector<sym::PredHandle>>
substituteGeneratedPredicates(sym::Store &store,
                              ArrayRef<sym::PredHandle> assumptions,
                              ArrayRef<sym::ExprSubstitution> substitutions) {
  if (substitutions.empty())
    return SmallVector<sym::PredHandle>(assumptions);

  SmallVector<sym::PredHandle> remapped;
  remapped.reserve(assumptions.size());
  for (sym::PredHandle assumption : assumptions) {
    FailureOr<sym::PredHandle> result =
        sym::substitutePred(store, assumption, substitutions);
    if (failed(result))
      return failure();
    remapped.push_back(*result);
  }
  return remapped;
}

static inline bool isSymbolicValueType(Type type, bool allowI64Integers) {
  if (type.isIndex())
    return true;
  if (auto intType = dyn_cast<IntegerType>(type))
    return intType.isSignless() &&
           (intType.getWidth() == 32 ||
            (allowI64Integers && intType.getWidth() == 64));
  if (auto simdType = dyn_cast<SimdType>(type)) {
    Type element = simdType.getElementType();
    return element.isIndex() || element.isInteger(32) ||
           (allowI64Integers && element.isInteger(64));
  }
  return false;
}

static inline bool isSignlessI32StorageType(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  auto intType = dyn_cast<IntegerType>(type);
  return intType && intType.isSignless() && intType.getWidth() == 32;
}

static inline std::optional<int64_t> getPacketElementCount(Type type) {
  SimdType simd = dyn_cast<SimdType>(type);
  if (!simd)
    return std::nullopt;
  VectorType vector = dyn_cast<VectorType>(simd.getElementType());
  if (vector)
    return vector.getNumElements();
  return 1;
}

static inline Value getPackedElementAlias(Value source, int64_t index,
                                          Type resultType) {
  PackOp pack = source.getDefiningOp<PackOp>();
  if (!pack)
    return {};

  int64_t offset = 0;
  for (Value input : pack.getInputs()) {
    std::optional<int64_t> elements = getPacketElementCount(input.getType());
    if (!elements)
      return {};
    if (offset == index && input.getType() == resultType)
      return input;
    offset += *elements;
    if (offset > index)
      return {};
  }
  return {};
}

static inline Value getExtractedPackAlias(Value value) {
  ExtractOp extract = value.getDefiningOp<ExtractOp>();
  if (!extract)
    return {};
  return getPackedElementAlias(extract.getSource(), extract.getIndex(),
                               value.getType());
}

static inline Value getDirectRedistributeAlias(Value value) {
  RedistributeOp redistribute = value.getDefiningOp<RedistributeOp>();
  if (!redistribute || redistribute.getSource().getType() != value.getType() ||
      !isIdentityRedistribution(redistribute.getRelation()))
    return {};
  return redistribute.getSource();
}

static inline FailureOr<std::optional<int64_t>>
getRedistributedSourceIndex(RedistributionAttr relation,
                            int64_t destinationIndex, sym::Store &store) {
  if (!isItemLocalRedistribution(relation))
    return std::optional<int64_t>{};

  FailureOr<sym::ExprHandle> slot = sym::composeExprSym(store, "slot");
  FailureOr<sym::ExprHandle> index =
      sym::composeExprInt(store, destinationIndex);
  if (failed(slot) || failed(index))
    return failure();
  std::array<sym::ExprSubstitution, 1> substitutions{
      sym::ExprSubstitution{*slot, *index}};
  FailureOr<sym::ExprHandle> sourceSlot =
      sym::substituteExpr(store, relation.getSourceSlot(), substitutions);
  if (failed(sourceSlot))
    return failure();
  sourceSlot = sym::simplifyExpr(store, *sourceSlot);
  if (failed(sourceSlot))
    return failure();
  std::optional<int64_t> sourceIndex = sym::getIntegerLiteralValue(*sourceSlot);
  if (!sourceIndex || *sourceIndex < 0)
    return std::optional<int64_t>{};
  return std::optional<int64_t>{*sourceIndex};
}

static inline FailureOr<Value>
getExtractedRedistributeAlias(Value value, sym::Store &store) {
  ExtractOp extract = value.getDefiningOp<ExtractOp>();
  if (!extract)
    return Value{};
  RedistributeOp redistribute =
      extract.getSource().getDefiningOp<RedistributeOp>();
  if (!redistribute)
    return Value{};

  FailureOr<std::optional<int64_t>> sourceIndex = getRedistributedSourceIndex(
      redistribute.getRelation(), extract.getIndex(), store);
  if (failed(sourceIndex))
    return failure();
  if (!*sourceIndex)
    return Value{};
  Value source = redistribute.getSource();
  if (**sourceIndex == 0 && source.getType() == value.getType())
    return source;
  return getPackedElementAlias(source, **sourceIndex, value.getType());
}

static inline FailureOr<Value> getSymbolicAlias(Value value,
                                                sym::Store &store) {
  if (Value source = getDirectRedistributeAlias(value))
    return source;
  if (Value source = getExtractedPackAlias(value))
    return source;
  return getExtractedRedistributeAlias(value, store);
}

static inline FailureOr<Value> peelSymbolicAliases(Value value,
                                                   sym::Store &store) {
  while (true) {
    FailureOr<Value> source = getSymbolicAlias(value, store);
    if (failed(source))
      return failure();
    if (!*source)
      break;
    value = *source;
  }
  return value;
}

static inline LogicalResult
appendSignedRangeAssumption(sym::Store &store, StringRef name, int64_t lo,
                            int64_t hi,
                            SmallVectorImpl<sym::PredHandle> &assumptions) {
  FailureOr<sym::PredHandle> range = sym::rangeAssumption(store, name, lo, hi);
  if (failed(range))
    return failure();
  if (!llvm::is_contained(assumptions, *range))
    assumptions.push_back(*range);
  return success();
}

static inline LogicalResult appendSignedI32StorageRangeAssumption(
    sym::Store &store, StringRef name,
    SmallVectorImpl<sym::PredHandle> &assumptions) {
  return appendSignedRangeAssumption(store, name, -(int64_t{1} << 31),
                                     (int64_t{1} << 31) - 1, assumptions);
}

static inline bool isSymbolicBinaryOp(BinaryOp op, bool allowI64Integers) {
  return isSymbolicValueType(op.getResult().getType(), allowI64Integers) &&
         isSymbolicValueType(op.getLhs().getType(), allowI64Integers) &&
         isSymbolicValueType(op.getRhs().getType(), allowI64Integers);
}

struct BooleanSelectComparison {
  SelectOp select;
  Value carrier;
  bool trueResult;
  bool falseResult;
};

static inline FailureOr<std::optional<BooleanSelectComparison>>
matchBooleanSelectComparison(arith::CmpIPredicate predicate, Value lhs,
                             Value rhs, sym::Store &store) {
  bool isEqual = predicate == arith::CmpIPredicate::eq;
  if (!isEqual && predicate != arith::CmpIPredicate::ne)
    return std::optional<BooleanSelectComparison>{};

  FailureOr<Value> peeledLhs = peelSymbolicAliases(lhs, store);
  if (failed(peeledLhs))
    return failure();
  SelectOp select = peeledLhs->getDefiningOp<SelectOp>();
  Value carrier = lhs;
  Value compared = rhs;
  if (!select) {
    FailureOr<Value> peeledRhs = peelSymbolicAliases(rhs, store);
    if (failed(peeledRhs))
      return failure();
    select = peeledRhs->getDefiningOp<SelectOp>();
    carrier = rhs;
    compared = lhs;
  }
  if (!select)
    return std::optional<BooleanSelectComparison>{};

  std::optional<int64_t> trueValue =
      getSplatOrConstantInt(select.getTrueValue());
  std::optional<int64_t> falseValue =
      getSplatOrConstantInt(select.getFalseValue());
  std::optional<int64_t> comparedValue = getSplatOrConstantInt(compared);
  if (!trueValue || !falseValue || !comparedValue)
    return std::optional<BooleanSelectComparison>{};

  return std::optional<BooleanSelectComparison>{BooleanSelectComparison{
      select, carrier, isEqual == (*trueValue == *comparedValue),
      isEqual == (*falseValue == *comparedValue)}};
}

using SignedI64Range = std::pair<int64_t, int64_t>;

static inline unsigned elementStorageBitWidth(Type type);

static inline std::optional<SignedI64Range> getSignedStorageRange(Type type) {
  unsigned bits = elementStorageBitWidth(type);
  if (bits == 0 || bits > 64)
    return std::nullopt;
  if (bits == 64)
    return SignedI64Range{std::numeric_limits<int64_t>::min(),
                          std::numeric_limits<int64_t>::max()};
  return SignedI64Range{-(int64_t{1} << (bits - 1)),
                        (int64_t{1} << (bits - 1)) - 1};
}

static inline std::optional<SignedI64Range>
getKnownWorkitemRange(WorkitemIdOp workitem) {
  FunctionOpInterface function =
      workitem->getParentOfType<FunctionOpInterface>();
  if (!function)
    return std::nullopt;
  DenseI32ArrayAttr shape;
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr candidate =
        function->getAttrOfType<DenseI32ArrayAttr>(name);
    if (!candidate)
      continue;
    if (shape && shape != candidate)
      return std::nullopt;
    shape = candidate;
  }
  unsigned axis = static_cast<unsigned>(workitem.getAxis());
  if (!shape || shape.size() != 3 || axis >= shape.size() ||
      shape.asArrayRef()[axis] <= 0)
    return std::nullopt;
  return SignedI64Range{0, int64_t(shape.asArrayRef()[axis]) - 1};
}

static inline bool isNonnegativeHardwareId(Value value) {
  return value.getDefiningOp<WorkgroupIdOp>() ||
         value.getDefiningOp<ClusterIdOp>() ||
         value.getDefiningOp<ClusterWorkgroupIdOp>() ||
         value.getDefiningOp<ClusterWorkgroupMaxIdOp>();
}

// Return only range contracts owned by the leaf definition.
static inline std::optional<SignedI64Range>
getAtomicLeafSemanticRange(Value value) {
  if (AssumeOp assume = value.getDefiningOp<AssumeOp>())
    return getAtomicLeafSemanticRange(assume.getValue());

  if (ReadFirstOp readFirst = value.getDefiningOp<ReadFirstOp>()) {
    // Transfer only Assume-chain and terminal intrinsic facts through
    // read_first.
    Value source = readFirst.getSource();
    while (AssumeOp assume = source.getDefiningOp<AssumeOp>())
      source = assume.getValue();
    return getAtomicLeafSemanticRange(source);
  }

  if (LaneIdOp lane = value.getDefiningOp<LaneIdOp>()) {
    auto type = cast<SimdType>(lane.getResult().getType());
    return SignedI64Range{0, int64_t{type.getWidth()} - 1};
  }

  if (WorkitemIdOp workitem = value.getDefiningOp<WorkitemIdOp>()) {
    if (std::optional<SignedI64Range> known = getKnownWorkitemRange(workitem))
      return known;
    return SignedI64Range{0, std::numeric_limits<int32_t>::max()};
  }

  if (isNonnegativeHardwareId(value))
    return SignedI64Range{0, std::numeric_limits<int32_t>::max()};

  return std::nullopt;
}

static inline LogicalResult
appendExprSignedRangeAssumption(sym::Store &store, sym::ExprHandle expr,
                                SignedI64Range range,
                                SmallVectorImpl<sym::PredHandle> &assumptions) {
  FailureOr<sym::ExprHandle> lower = sym::composeExprInt(store, range.first);
  FailureOr<sym::ExprHandle> upper = sym::composeExprInt(store, range.second);
  FailureOr<sym::PredHandle> atLeast =
      failed(lower)
          ? FailureOr<sym::PredHandle>(failure())
          : sym::composePredCmp(store, expr, sym::PredCmpOp::Ge, *lower);
  FailureOr<sym::PredHandle> atMost =
      failed(upper)
          ? FailureOr<sym::PredHandle>(failure())
          : sym::composePredCmp(store, expr, sym::PredCmpOp::Le, *upper);
  FailureOr<sym::PredHandle> bounded =
      failed(atLeast) || failed(atMost)
          ? FailureOr<sym::PredHandle>(failure())
          : sym::composePredAnd(store, *atLeast, *atMost);
  if (failed(bounded))
    return failure();
  if (!llvm::is_contained(assumptions, *bounded))
    assumptions.push_back(*bounded);
  return success();
}

static inline unsigned elementStorageBitWidth(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  // Preserve Wave's fixed-width 64-bit index semantics in the packet.
  if (type.isIndex())
    return 64;
  return ConstantIntRanges::getStorageBitwidth(type);
}

static inline bool isStructurallySymbolicIntegerCast(CastOp op,
                                                     bool allowI64Integers) {
  return op.getKind() == CastKind::IntConvert &&
         isSymbolicValueType(op.getSource().getType(), allowI64Integers) &&
         isSymbolicValueType(op.getResult().getType(), allowI64Integers);
}

static inline bool isStructurallySymbolicBinaryOp(BinaryOp op,
                                                  bool allowI64Integers) {
  if (!isSymbolicBinaryOp(op, allowI64Integers))
    return false;
  constexpr std::array supported{
      BinaryKind::AddI,  BinaryKind::SubI,  BinaryKind::MulI,
      BinaryKind::ShLI,  BinaryKind::XOrI,  BinaryKind::OrI,
      BinaryKind::ShRUI, BinaryKind::AndI,  BinaryKind::DivSI,
      BinaryKind::DivUI, BinaryKind::RemSI, BinaryKind::RemUI};
  return llvm::is_contained(supported, op.getKind());
}

static inline std::optional<sym::PredCmpOp>
convertSignedCmpPredicate(arith::CmpIPredicate predicate) {
  switch (predicate) {
  case arith::CmpIPredicate::eq:
    return sym::PredCmpOp::Eq;
  case arith::CmpIPredicate::ne:
    return sym::PredCmpOp::Ne;
  case arith::CmpIPredicate::slt:
    return sym::PredCmpOp::Lt;
  case arith::CmpIPredicate::sle:
    return sym::PredCmpOp::Le;
  case arith::CmpIPredicate::sgt:
    return sym::PredCmpOp::Gt;
  case arith::CmpIPredicate::sge:
    return sym::PredCmpOp::Ge;
  default:
    return std::nullopt;
  }
}

static inline std::optional<sym::PredCmpOp>
convertUnsignedCmpPredicate(arith::CmpIPredicate predicate) {
  switch (predicate) {
  case arith::CmpIPredicate::ult:
    return sym::PredCmpOp::Lt;
  case arith::CmpIPredicate::ule:
    return sym::PredCmpOp::Le;
  case arith::CmpIPredicate::ugt:
    return sym::PredCmpOp::Gt;
  case arith::CmpIPredicate::uge:
    return sym::PredCmpOp::Ge;
  default:
    return std::nullopt;
  }
}

static inline bool isStructurallySymbolicSelect(SelectOp op,
                                                bool allowI64Integers) {
  if (!isSymbolicValueType(op.getType(), allowI64Integers) ||
      !isSymbolicValueType(op.getTrueValue().getType(), allowI64Integers) ||
      !isSymbolicValueType(op.getFalseValue().getType(), allowI64Integers))
    return false;
  Type conditionType = op.getCondition().getType();
  return isa<MaskType>(conditionType) || conditionType.isInteger(1);
}

static inline bool isCallableEntryArgument(Value value) {
  auto argument = dyn_cast<BlockArgument>(value);
  if (!argument)
    return false;
  Block *block = argument.getOwner();
  return block->isEntryBlock() &&
         isa<FunctionOpInterface>(block->getParentOp());
}

static inline scf::ForOp getExactForInductionVarOwner(BlockArgument argument) {
  scf::ForOp loop = scf::getForInductionVarOwner(argument);
  if (!loop || argument != loop.getInductionVar())
    return {};
  return loop;
}

static inline bool isIndexPacketIntrinsicLeaf(Value value) {
  return value.getDefiningOp<LaneIdOp>() ||
         value.getDefiningOp<SubgroupIdOp>() ||
         value.getDefiningOp<WorkitemIdOp>() ||
         value.getDefiningOp<WorkgroupIdOp>() ||
         value.getDefiningOp<ClusterIdOp>() ||
         value.getDefiningOp<ClusterWorkgroupIdOp>() ||
         value.getDefiningOp<ClusterWorkgroupMaxIdOp>();
}

static inline bool isAtomicIndexPacketLeaf(Value value) {
  if (ReadFirstOp readFirst = value.getDefiningOp<ReadFirstOp>()) {
    Value source = readFirst.getSource();
    while (AssumeOp assume = source.getDefiningOp<AssumeOp>())
      source = assume.getValue();
    return isCallableEntryArgument(source) ||
           isIndexPacketIntrinsicLeaf(source);
  }
  return isIndexPacketIntrinsicLeaf(value);
}

static inline bool isIrreducibleIndexPacketLeaf(Value value) {
  return isCallableEntryArgument(value) || isAtomicIndexPacketLeaf(value);
}

enum class AssumeRootPolicy { ExpandSource, BindExactResult };

static inline bool isAtomicAssumeResultCandidate(Value value) {
  if (value.getDefiningOp<AssumeOp>())
    return true;
  SplatOp splat = value.getDefiningOp<SplatOp>();
  return splat && splat.getSource().getDefiningOp<AssumeOp>();
}

class SymbolicValueBuilder {
public:
  explicit SymbolicValueBuilder(
      WaveDialect &dialect, bool allowI64Integers = false,
      bool assumeI32StorageRange = false, bool expandIndexExprRoot = false,
      bool foldWaveConstants = false, bool modelWrappingArithmetic = false,
      bool fullyMergeAssumes = false,
      AssumeRootPolicy assumeRootPolicy = AssumeRootPolicy::ExpandSource,
      bool assumeAddressArithmeticNoOverflow = false)
      : dialect(dialect), store(dialect.getSymbolStore()),
        allowI64Integers(allowI64Integers),
        assumeI32StorageRange(assumeI32StorageRange),
        expandIndexExprRoot(expandIndexExprRoot),
        foldWaveConstants(foldWaveConstants),
        modelWrappingArithmetic(modelWrappingArithmetic),
        fullyMergeAssumes(fullyMergeAssumes),
        assumeAddressArithmeticNoOverflow(assumeAddressArithmeticNoOverflow),
        assumeRootPolicy(assumeRootPolicy) {}

  FailureOr<std::optional<SymbolicOffset>> build(Value value);

  FailureOr<std::optional<SymbolicOffset>> buildAllowingRootLeaf(Value value);

  FailureOr<std::optional<SymbolicPredicate>> buildPredicate(Value value);

  FailureOr<std::optional<SymbolicPredicate>>
  buildPredicateRetainingGuardedRoot(Value value);

  FailureOr<bool> canExpand(Value value);

  void enableExactIntegerCasts();
  void enableSSAIntermediateLeaves();

private:
  using SSAFactMap = llvm::DenseMap<Value, SmallVector<sym::PredHandle, 2>>;

  struct RetainedSelectArmDomain {
    Value selectResult;
    Value activeValue;
    sym::PredHandle guard;
  };

  struct ProducerProofContext {
    bool requireProof = false;
    std::optional<RetainedSelectArmDomain> retainedArm;

    static ProducerProofContext forPredicate() { return {true, std::nullopt}; }

    static ProducerProofContext forRetainedArm(SelectOp select,
                                               sym::PredHandle guard) {
      return {true, RetainedSelectArmDomain{select.getResult(),
                                            select.getTrueValue(), guard}};
    }

    ProducerProofContext forConditionalArm() const {
      ProducerProofContext result = *this;
      result.requireProof = true;
      return result;
    }

    bool canUseCache() const { return !requireProof; }
  };

  struct RetainedSelectProof {
    SelectOp select;
    sym::PredHandle guard;
    sym::PredHandle activePredicate;
  };

  struct BuiltPredicateRoot {
    sym::PredHandle predicate;
    std::optional<RetainedSelectProof> retained;
  };

  static bool isRetainedGuardedRoot(Value value, bool retainGuardedRoot);

  ArrayRef<sym::PredHandle> getSSAFacts(Value value) const;

  void appendSSAFact(Value value, sym::PredHandle fact);

  void appendSSAFacts(Value value, ArrayRef<sym::PredHandle> facts);

  void propagateSSAOperandFacts(Value value);

  SmallVector<sym::PredHandle, 8> getSSAValueDomain(Value value) const;

  void discardSkippedPredicate();

  FailureOr<bool>
  validateActiveGuardedPredicate(const RetainedSelectProof &proof);

  FailureOr<bool> validateBuiltPredicate(const BuiltPredicateRoot &root);

  FailureOr<sym::PredHandle> canonicalizePredicate(Value value,
                                                   sym::PredHandle predicate);

  FailureOr<sym::PredHandle>
  canonicalizeBuiltPredicate(const BuiltPredicateRoot &root);

  SymbolicPredicate makeSymbolicPredicate(Value value,
                                          sym::PredHandle predicate);

  FailureOr<std::optional<SymbolicPredicate>>
  buildPredicate(Value value, bool retainGuardedRoot);

  struct LoopCarriedRecurrence {
    scf::ForOp loop;
    BinaryOp update;
    Value init;
    Value stride;
    bool subtractStride = false;
  };

  struct LoopCarriedUpdate {
    scf::ForOp loop;
    BinaryOp update;
    unsigned index;
  };

  static bool isWrappingArithmeticKind(BinaryKind kind);

  bool canBuildBinary(BinaryOp op);

  static bool isMaskSelect(SelectOp select);

  template <typename T>
  static bool failedOrSkipped(const FailureOr<T> &value, bool skip) {
    return skip || failed(value);
  }

  FailureOr<BuiltPredicateRoot> buildPredicateRoot(Value value, bool &skip);

  FailureOr<BuiltPredicateRoot> buildGuardedRootPredicate(SelectOp select,
                                                          bool &skip);

  FailureOr<sym::PredHandle>
  buildSelectPredicate(SelectOp select, bool &skip,
                       const ProducerProofContext &context);

  FailureOr<sym::PredHandle>
  buildPredicateExpr(Value value, bool &skip,
                     const ProducerProofContext &context);

  FailureOr<sym::PredHandle>
  buildPredicateExprImpl(Value value, bool &skip,
                         const ProducerProofContext &context);

  FailureOr<sym::ExprHandle> simplifyPacketExpr(sym::ExprHandle expr);

  FailureOr<bool> validatePacketExpr(sym::ExprHandle expr);

  FailureOr<std::optional<SymbolicOffset>>
  finishBuiltOffset(sym::ExprHandle expr);

  FailureOr<std::optional<SymbolicOffset>>
  buildExpandedRoot(Value value, bool allowRootLeaf, bool hasRoot);

  FailureOr<std::optional<SymbolicOffset>> buildRootLeaf(Value value);

  bool shouldAllowRootLeaf(Value value, bool allowRootLeaf, bool hasRoot) const;

  void appendRootSSAFacts(Value value);

  FailureOr<std::optional<SymbolicOffset>> build(Value value,
                                                 bool allowRootLeaf);

  FailureOr<bool> hasSymbolicRoot(Value value);

  bool hasExactCastSymbolicRoot(Value value);

  FailureOr<bool> hasSplatSymbolicRoot(SplatOp splat);

  bool hasBlockArgumentSymbolicRoot(Value value);

  FailureOr<bool> hasProducerSymbolicRoot(Value value);

  FailureOr<bool> hasSymbolicRootImpl(Value value);

  FailureOr<sym::ExprHandle> buildExpr(Value value, bool &skip, bool allowLeaf,
                                       const ProducerProofContext &context);

  static FailureOr<std::optional<sym::ExprHandle>>
  optionalExpr(FailureOr<sym::ExprHandle> expr);

  FailureOr<std::optional<sym::ExprHandle>>
  buildExactCastExpr(Value value, bool &skip,
                     const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildProducerExpr(Value value, bool &skip, bool allowLeaf,
                    const ProducerProofContext &context);

  FailureOr<sym::ExprHandle> buildExprImpl(Value value, bool &skip,
                                           bool allowLeaf,
                                           const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildLeafOrRecurrence(Value value, bool &skip, bool allowLeaf,
                        const ProducerProofContext &context);

  struct InductionBounds {
    sym::ExprHandle induction, lower, upper;
  };

  FailureOr<InductionBounds>
  buildInductionBounds(BlockArgument arg, scf::ForOp loop, bool &skip,
                       bool importDefinitionFacts,
                       const ProducerProofContext &context);

  LogicalResult appendLoopRangeAssumptions(sym::ExprHandle induction,
                                           sym::ExprHandle lower,
                                           sym::ExprHandle upper,
                                           sym::ExprHandle next,
                                           sym::ExprHandle unwrappedNext);

  struct UnsignedLoopValues {
    sym::ExprHandle induction, lower, upper, next, unwrappedNext;
  };

  FailureOr<InductionBounds>
  buildUnsignedLoopBounds(const InductionBounds &bounds, unsigned bitWidth);

  FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>>
  buildUnsignedLoopSuccessor(sym::ExprHandle mathematicalInduction,
                             sym::ExprHandle unsignedInduction, int64_t step,
                             unsigned bitWidth);

  FailureOr<UnsignedLoopValues>
  buildUnsignedLoopValues(const InductionBounds &bounds, int64_t step,
                          unsigned bitWidth);

  FailureOr<sym::ExprHandle>
  buildUnsignedForInductionExpr(BlockArgument arg, scf::ForOp loop,
                                int64_t step, bool &skip,
                                const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildSignedForInductionExpr(BlockArgument arg, scf::ForOp loop, int64_t step,
                              bool &skip, const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildForInductionExpr(BlockArgument arg, bool &skip,
                        const ProducerProofContext &context);

  struct ExactCastShape {
    unsigned sourceBits, resultBits;
  };

  FailureOr<ExactCastShape> getExactCastShape(Value input, Type resultType,
                                              bool &skip);

  LogicalResult
  appendNonNegativeCastAssumption(Operation *producer, sym::ExprHandle source,
                                  bool &skip,
                                  const ProducerProofContext &context);

  FailureOr<sym::ExprHandle> buildWidenedIndexCast(sym::ExprHandle source,
                                                   unsigned sourceBits,
                                                   bool unsignedExtension,
                                                   bool nonNegative);

  FailureOr<sym::ExprHandle>
  buildNarrowedIndexCast(Operation *producer, sym::ExprHandle source,
                         unsigned resultBits,
                         const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildExactIndexCast(Operation *producer, Value input, Type resultType,
                      bool unsignedExtension, bool nonNegative, bool &skip,
                      const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildExactWaveIntegerCast(CastOp cast, bool &skip,
                            const ProducerProofContext &context);

  std::optional<LoopCarriedUpdate> getLoopCarriedUpdate(BlockArgument arg);

  static std::optional<std::pair<Value, bool>>
  getRecurrenceStride(BlockArgument arg, BinaryOp update);

  std::optional<LoopCarriedRecurrence>
  matchLoopCarriedRecurrence(BlockArgument arg);

  FailureOr<sym::ExprHandle>
  buildRecurrenceIteration(LoopCarriedRecurrence recurrence, bool &skip,
                           const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildRecurrenceStride(LoopCarriedRecurrence recurrence, bool &skip,
                        const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildLoopCarriedRecurrence(LoopCarriedRecurrence recurrence, bool &skip,
                             const ProducerProofContext &context);

  struct StateMark {
    size_t bindings;
    size_t assumptions;
    size_t materializations;
    unsigned laneWidth;
    unsigned nextRawSymbol;
    SSAFactMap ssaFacts;
  };

  StateMark markState() const;

  void rollbackState(const StateMark &mark);

  bool rejectsCompoundLeaf(Value value, bool allowLeaf, bool allowCompoundLeaf);

  bool canBindLeaf(Value value, bool allowLeaf);

  bool importsLeafDefinitionFacts(Value value);

  FailureOr<sym::ExprHandle> bindOrSkip(Value value, bool &skip, bool allowLeaf,
                                        bool allowCompoundLeaf = false);

  bool isClosedPacketLeaf(Value value);

  FailureOr<sym::ExprHandle>
  buildFullyMergedAssumeExpr(Value value, AssumeOp assume, bool &skip,
                             const ProducerProofContext &context);

  FailureOr<sym::ExprHandle> buildAtomicAssumeExpr(Value value, AssumeOp assume,
                                                   bool &skip, bool allowLeaf);

  FailureOr<sym::ExprHandle>
  buildExpandedAssumeExpr(Value value, AssumeOp assume, bool &skip,
                          bool allowLeaf, const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildAssumeExpr(Value value, AssumeOp assume, bool &skip, bool allowLeaf,
                  const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildSplatExpr(SplatOp splat, bool &skip, bool allowLeaf,
                 const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildBinaryExpr(Value value, BinaryOp binary, bool &skip, bool allowLeaf,
                  const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildSelectExpr(Value value, SelectOp select, bool &skip, bool allowLeaf,
                  const ProducerProofContext &context);

  FailureOr<sym::ExprHandle> buildIndexExpr(IndexExprOp op);

  FailureOr<sym::ExprHandle> buildBinary(BinaryOp op, bool &skip,
                                         const ProducerProofContext &context);

  static bool isDivRemKind(BinaryKind kind);

  static bool isShiftKind(BinaryKind kind);

  FailureOr<sym::ExprHandle>
  composeShiftLeft(BinaryOp op,
                   const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
                   bool &skip);

  FailureOr<sym::ExprHandle> buildNoUnsignedWrapMathematical(
      BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
      sym::ExprHandle unsignedLhs, sym::ExprHandle unsignedRhs, unsigned bits);

  LogicalResult appendNoUnsignedWrapRelation(
      BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
      sym::ExprHandle result, bool &skip, const ProducerProofContext &context);

  LogicalResult
  appendNoSignedWrapResultRange(BinaryOp op, sym::ExprHandle mathematical,
                                bool &skip,
                                const ProducerProofContext &context);

  FailureOr<sym::ExprHandle> buildMathematicalArithmetic(
      BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
      bool &skip);

  FailureOr<sym::ExprHandle>
  buildArithmeticResult(BinaryOp op, sym::ExprHandle mathematical, bool &skip);

  FailureOr<sym::ExprHandle>
  buildArithmetic(BinaryOp op,
                  const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
                  bool &skip, const ProducerProofContext &context);

  static bool isArithmeticKind(BinaryKind kind);

  FailureOr<sym::ExprHandle> buildNonWrappingBinary(
      BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
      bool &skip, const ProducerProofContext &context);

  FailureOr<sym::ExprHandle> buildUnsigned64Value(sym::ExprHandle mathematical);

  FailureOr<sym::ExprHandle>
  buildUnsignedFixedWidthValue(sym::ExprHandle mathematical, unsigned bitWidth);

  FailureOr<sym::ExprHandle> buildSignedHighLimb(sym::ExprHandle highFloor,
                                                 sym::ExprHandle limbBase,
                                                 sym::ExprHandle signBit);

  FailureOr<sym::ExprHandle> buildSigned64Value(sym::ExprHandle mathematical);

  FailureOr<sym::ExprHandle>
  buildNarrowSignedValue(sym::ExprHandle mathematical, unsigned bitWidth);

  FailureOr<sym::ExprHandle>
  buildSignedFixedWidthValue(sym::ExprHandle mathematical, unsigned bitWidth);

  FailureOr<sym::ExprHandle> buildSelect(SelectOp op, bool &skip,
                                         const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildConditionalExprArm(Value value, bool &skip,
                          const ProducerProofContext &context);

  FailureOr<sym::PredHandle>
  buildConditionalPredicateArm(Value value, bool &skip,
                               const ProducerProofContext &context);

  FailureOr<sym::PredHandle>
  buildSelectCondition(SelectOp op, bool &skip,
                       const ProducerProofContext &context);

  FailureOr<sym::PredHandle>
  buildCmpPredicate(CmpIOp op, bool &skip, const ProducerProofContext &context);

  FailureOr<std::optional<sym::PredHandle>>
  buildBooleanSelectComparison(arith::CmpIPredicate predicate, Value lhs,
                               Value rhs, bool &skip,
                               const ProducerProofContext &context);

  FailureOr<sym::PredHandle>
  buildBooleanSelectComparison(BooleanSelectComparison match, bool &skip,
                               const ProducerProofContext &context);

  struct BuiltComparison {
    sym::ExprHandle lhs, rhs;
    sym::PredCmpOp predicate;
  };

  FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>>
  buildComparisonOperands(Value lhsValue, Value rhsValue, bool &skip,
                          const ProducerProofContext &context);

  FailureOr<BuiltComparison> prepareComparison(
      arith::CmpIPredicate predicate, Value lhsValue, Value rhsValue,
      std::pair<sym::ExprHandle, sym::ExprHandle> operands, bool &skip);

  FailureOr<sym::PredHandle>
  buildCmpPredicate(arith::CmpIPredicate predicate, Value lhsValue,
                    Value rhsValue, bool &skip,
                    const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildPlainBinary(BinaryOp op,
                   const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
                   bool &skip);

  static std::optional<sym::ExprBinaryOp> convertBinaryKind(BinaryKind kind);

  FailureOr<sym::ExprHandle> buildUnsignedShiftRight(
      BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
      bool &skip);

  FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>>
  buildBinaryOperands(BinaryOp op, bool &skip,
                      const ProducerProofContext &context);

  FailureOr<bool> provePredicates(ArrayRef<sym::PredHandle> predicates,
                                  Operation *producer,
                                  const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildUnsignedDiv(BinaryOp op,
                   const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
                   bool &skip, const ProducerProofContext &context);

  FailureOr<sym::ExprHandle> buildUnsignedRemainder(
      BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
      bool &skip, const ProducerProofContext &context);

  FailureOr<sym::ExprHandle> buildSignedRemainder(
      BinaryOp op, const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
      bool &skip, const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildRemainder(BinaryOp op,
                 const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
                 bool &skip, const ProducerProofContext &context);

  FailureOr<sym::ExprHandle> buildSignedQuotient(
      const std::pair<sym::ExprHandle, sym::ExprHandle> &operands);

  FailureOr<sym::ExprHandle>
  buildSignedDiv(BinaryOp op,
                 const std::pair<sym::ExprHandle, sym::ExprHandle> &operands,
                 bool &skip, const ProducerProofContext &context);

  FailureOr<sym::ExprHandle>
  buildAnd(const std::pair<sym::ExprHandle, sym::ExprHandle> &operands);

  LogicalResult appendRequiredAssumptions(ArrayRef<sym::PredHandle> assumptions,
                                          Operation *producer, bool &skip,
                                          const ProducerProofContext &context);

  LogicalResult appendSSAAssumptions(Value carrier,
                                     ArrayRef<sym::PredHandle> assumptions);

  LogicalResult appendAssumePredicatesForExpr(AssumeOp assume,
                                              sym::ExprHandle expr);

  FailureOr<sym::ExprHandle> bindSymbol(Value value, bool &skip,
                                        bool importDefinitionFacts = true);

  LogicalResult appendSymbolDefinitionAssumptions(Value value, StringRef name);

  LogicalResult appendSymbolRangeAssumption(Value value, StringRef name);

  LogicalResult appendSymbolAssumptions(Value value, StringRef name,
                                        bool importDefinitionFacts);

  std::optional<SymbolicOffsetBindingKind> classifyBindingType(Type type);

  LogicalResult appendSymbolSubstitution(
      sym::ExprHandle source, StringRef replacementName,
      SmallVectorImpl<sym::ExprSubstitution> &substitutions);

  void appendNewOffsetBinding(const SymbolicOffsetBinding &binding,
                              const SymbolicOffset &symbolic);

  LogicalResult appendFreshOffsetBinding(
      const SymbolicOffsetBinding &binding, const SymbolicOffset &symbolic,
      SmallVectorImpl<sym::ExprSubstitution> &substitutions);

  LogicalResult appendNamedOffsetBinding(
      const SymbolicOffsetBinding &binding, const SymbolicOffset &symbolic,
      SmallVectorImpl<sym::ExprSubstitution> &substitutions);

  FailureOr<sym::ExprHandle>
  appendOffsetExpr(Value carrier, const SymbolicOffset &symbolic,
                   ArrayRef<sym::ExprSubstitution> substitutions);

  FailureOr<sym::ExprHandle> appendOffset(Value carrier,
                                          const SymbolicOffset &symbolic);

  std::string freshName(StringRef stem = "raw");

  SymbolicOffset offset;
  SSAFactMap ssaFactsByValue;
  llvm::DenseMap<Value, sym::ExprHandle> requiredExprByValue;
  llvm::DenseMap<Value, sym::ExprHandle> leafExprByValue;
  llvm::DenseMap<Value, sym::PredHandle> predicateByValue;
  llvm::DenseMap<Value, bool> symbolicRootByValue;
  llvm::DenseSet<Value> activeExprValues;
  llvm::DenseSet<Value> activePredicateValues;
  llvm::DenseSet<Value> activeSymbolicRootValues;
  llvm::DenseMap<Value, StringRef> nameByValue;
  llvm::StringMap<Value> bindingByName;
  WaveDialect &dialect;
  sym::Store &store;
  Value rootValue;
  bool allowI64Integers = false;
  bool assumeI32StorageRange = false;
  bool expandIndexExprRoot = false;
  bool foldWaveConstants = false;
  bool modelWrappingArithmetic = false;
  bool fullyMergeAssumes = false;
  bool exactIntegerCasts = false;
  bool assumeAddressArithmeticNoOverflow = false;
  bool allowSSAIntermediateLeaves = false;
  bool buildingPredicate = false;
  AssumeRootPolicy assumeRootPolicy = AssumeRootPolicy::ExpandSource;
  unsigned nextRawSymbol = 0;
};

} // namespace mlir::wave::detail

#endif // MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVESYMBOLICVALUEANALYSIS_H
