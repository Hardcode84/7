//===- WaveRedistributePlanning.cpp - packet proof planning ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveRedistributePlanning.h"

#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/MathExtras.h"

#include <algorithm>
#include <array>
#include <cassert>
#include <string>
#include <tuple>
#include <utility>
#include <vector>

using namespace mlir;
using namespace mlir::wave;

namespace {
static constexpr StringLiteral kBlock = "block";
static constexpr StringLiteral kItem = "item";
static constexpr StringLiteral kSlot = "slot";
static constexpr int64_t kMaxEnumeratedPacketPoints = int64_t{1} << 20;

static Type getPacketPayloadType(Type type) {
  return cast<SimdType>(type).getElementType();
}

static int64_t getPacketElementCount(Type type) {
  if (VectorType vector = dyn_cast<VectorType>(getPacketPayloadType(type)))
    return vector.getNumElements();
  return 1;
}

static const indexing::IndexMap::Input &getInput(const indexing::IndexMap &map,
                                                 StringRef name) {
  auto input = llvm::find_if(map.inputs, [&](const auto &candidate) {
    return sym::ExprView(candidate.variable).getSymbolName() == name;
  });
  assert(input != map.inputs.end() && "missing index-map input");
  return *input;
}

static std::array<sym::ExprHandle, 3>
getSourceCoordinates(const indexing::IndexMap &map) {
  assert(map.exprs.size() == 3 &&
         "redistribution map must carry block, item, and slot");
  return {map.exprs[0], map.exprs[1], map.exprs[2]};
}

static FailureOr<sym::ExprHandle> composeWithInt(sym::Store &store,
                                                 sym::ExprHandle lhs,
                                                 sym::ExprBinaryOp op,
                                                 int64_t rhs) {
  FailureOr<sym::ExprHandle> literal = sym::composeExprInt(store, rhs);
  if (failed(literal))
    return failure();
  return sym::composeExprBinary(store, lhs, op, *literal);
}

static FailureOr<sym::ExprHandle>
floorDiv(sym::Store &store, sym::ExprHandle value, int64_t divisor) {
  FailureOr<sym::ExprHandle> divided =
      composeWithInt(store, value, sym::ExprBinaryOp::Div, divisor);
  if (failed(divided))
    return failure();
  return sym::composeExprFloor(store, *divided);
}

static LogicalResult
appendCoordinateRequirements(sym::Store &store, sym::ExprHandle expression,
                             int64_t extent,
                             SmallVectorImpl<sym::PredHandle> &requirements) {
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  FailureOr<sym::ExprHandle> upper = sym::composeExprInt(store, extent);
  if (failed(zero) || failed(upper))
    return failure();
  if (!sym::isIntegerValued(expression)) {
    FailureOr<sym::ExprHandle> integral =
        sym::composeExprFloor(store, expression);
    FailureOr<sym::PredHandle> integer =
        failed(integral) ? FailureOr<sym::PredHandle>(failure())
                         : sym::composePredCmp(store, expression,
                                               sym::PredCmpOp::Eq, *integral);
    if (failed(integer))
      return failure();
    requirements.push_back(*integer);
  }
  for (auto [predicate, rhs] : {std::pair{sym::PredCmpOp::Ge, *zero},
                                std::pair{sym::PredCmpOp::Lt, *upper}}) {
    FailureOr<sym::PredHandle> goal =
        sym::composePredCmp(store, expression, predicate, rhs);
    if (failed(goal))
      return failure();
    requirements.push_back(*goal);
  }
  return success();
}

static FailureOr<sym::PredHandle> equal(sym::Store &store, sym::ExprHandle lhs,
                                        sym::ExprHandle rhs) {
  return sym::composePredCmp(store, lhs, sym::PredCmpOp::Eq, rhs);
}

static bool isIdentitySlotPermutation(int64_t slots, uint64_t withinMask) {
  if (!llvm::isPowerOf2_64(slots))
    return true;
  unsigned withinBits = llvm::popcount(withinMask);
  return withinMask == ((uint64_t{1} << withinBits) - 1);
}

static LogicalResult appendSlotPermutationBit(sym::Store &store,
                                              sym::ExprHandle value,
                                              unsigned logicalBit,
                                              unsigned packedBit, bool inverse,
                                              sym::ExprHandle &result) {
  unsigned sourceBit = inverse ? packedBit : logicalBit;
  unsigned resultBit = inverse ? logicalBit : packedBit;
  FailureOr<sym::ExprHandle> bit =
      floorDiv(store, value, int64_t{1} << sourceBit);
  if (succeeded(bit))
    bit = composeWithInt(store, *bit, sym::ExprBinaryOp::Mod, 2);
  if (succeeded(bit) && resultBit)
    bit = composeWithInt(store, *bit, sym::ExprBinaryOp::Mul,
                         int64_t{1} << resultBit);
  if (failed(bit))
    return failure();
  FailureOr<sym::ExprHandle> sum =
      sym::composeExprBinary(store, result, sym::ExprBinaryOp::Add, *bit);
  if (failed(sum))
    return failure();
  result = *sum;
  return success();
}

static FailureOr<sym::ExprHandle>
composeSlotPermutation(sym::Store &store, sym::ExprHandle value, int64_t slots,
                       uint64_t withinMask, bool inverse) {
  if (isIdentitySlotPermutation(slots, withinMask))
    return value;
  FailureOr<sym::ExprHandle> result = sym::composeExprInt(store, 0);
  unsigned packedBit = 0, slotBits = llvm::Log2_64(slots);
  for (bool selected : {true, false})
    for (unsigned logicalBit : llvm::seq<unsigned>(0, slotBits)) {
      if (bool(withinMask & (uint64_t{1} << logicalBit)) != selected)
        continue;
      if (failed(result) ||
          failed(appendSlotPermutationBit(store, value, logicalBit, packedBit++,
                                          inverse, *result)))
        return failure();
    }
  return result;
}

struct SlotPermutationProof {
  sym::ExprHandle variable, packed;
  sym::PredHandle exact;
};

static FailureOr<SlotPermutationProof>
buildSlotPermutationProof(sym::Store &store, int64_t slots, uint64_t withinMask,
                          StringRef symbol) {
  FailureOr<sym::ExprHandle> variable = sym::composeExprSym(store, symbol);
  FailureOr<sym::ExprHandle> packed =
      succeeded(variable)
          ? composeSlotPermutation(store, *variable, slots, withinMask, false)
          : FailureOr<sym::ExprHandle>(failure());
  FailureOr<sym::ExprHandle> inverse =
      succeeded(packed)
          ? composeSlotPermutation(store, *packed, slots, withinMask, true)
          : FailureOr<sym::ExprHandle>(failure());
  FailureOr<sym::PredHandle> exact =
      succeeded(variable) && succeeded(inverse)
          ? equal(store, *variable, *inverse)
          : FailureOr<sym::PredHandle>(failure());
  if (failed(variable) || failed(packed) || failed(exact))
    return failure();
  return SlotPermutationProof{*variable, *packed, *exact};
}

static FailureOr<bool> proveSlotPermutation(sym::Store &store, int64_t slots,
                                            uint64_t withinMask,
                                            StringRef symbol,
                                            indexing::CheckMemo &memo,
                                            std::string &diagnostic) {
  if (isIdentitySlotPermutation(slots, withinMask))
    return true;
  FailureOr<SlotPermutationProof> proof =
      buildSlotPermutationProof(store, slots, withinMask, symbol);
  if (failed(proof))
    return failure();
  indexing::IndexMap domain;
  domain.inputs = {
      {proof->variable, slots, Value(), SymbolicOffsetBindingKind::Uniform}};
  domain.exprs = {proof->packed};
  SmallVector<sym::PredHandle, 4> goals{proof->exact};
  if (failed(appendCoordinateRequirements(store, proof->packed, slots, goals)))
    return failure();
  diagnostic.clear();
  FailureOr<sym::CheckResult> result =
      indexing::check(store, domain, goals, memo, &diagnostic);
  return failed(result) ? FailureOr<bool>(failure())
                        : FailureOr<bool>(*result == sym::CheckResult::True);
}

struct CoordinateFactor {
  sym::ExprHandle group, within;
};

static FailureOr<CoordinateFactor>
factorCoordinate(sym::Store &store, sym::ExprHandle value, int64_t size) {
  FailureOr<sym::ExprHandle> group = floorDiv(store, value, size);
  FailureOr<sym::ExprHandle> within =
      composeWithInt(store, value, sym::ExprBinaryOp::Mod, size);
  if (failed(group) || failed(within))
    return failure();
  return CoordinateFactor{*group, *within};
}

static LogicalResult
appendFactorProof(sym::Store &store, sym::ExprHandle value,
                  CoordinateFactor factor, int64_t extent, int64_t size,
                  SmallVectorImpl<sym::PredHandle> &goals) {
  FailureOr<sym::ExprHandle> base =
      composeWithInt(store, factor.group, sym::ExprBinaryOp::Mul, size);
  FailureOr<sym::ExprHandle> reconstructed =
      succeeded(base) ? sym::composeExprBinary(
                            store, *base, sym::ExprBinaryOp::Add, factor.within)
                      : FailureOr<sym::ExprHandle>(failure());
  FailureOr<sym::PredHandle> exact =
      succeeded(reconstructed) ? equal(store, value, *reconstructed)
                               : FailureOr<sym::PredHandle>(failure());
  if (failed(exact) ||
      failed(appendCoordinateRequirements(
          store, factor.group, llvm::divideCeil(extent, size), goals)) ||
      failed(appendCoordinateRequirements(store, factor.within, size, goals)))
    return failure();
  goals.push_back(*exact);
  return success();
}

struct PacketBitDependencies {
  uint64_t ownerInvariant = 0;
  SmallVector<uint64_t, 6> sourceByResultBit;
};

static FailureOr<bool> isInvariantUnderSubstitution(
    sym::Store &store, const indexing::IndexMap &carrier,
    sym::ExprHandle expression, ArrayRef<sym::ExprSubstitution> substitution,
    indexing::CheckMemo &memo) {
  FailureOr<sym::ExprHandle> reference =
      sym::substituteExpr(store, expression, substitution);
  FailureOr<sym::PredHandle> same = succeeded(reference)
                                        ? equal(store, expression, *reference)
                                        : FailureOr<sym::PredHandle>(failure());
  FailureOr<sym::CheckResult> result =
      succeeded(same) ? indexing::check(store, carrier,
                                        ArrayRef<sym::PredHandle>{*same}, memo)
                      : FailureOr<sym::CheckResult>(failure());
  if (failed(result))
    return failure();
  return *result == sym::CheckResult::True;
}

static FailureOr<sym::ExprHandle> toggleCoordinateBit(sym::Store &store,
                                                      sym::ExprHandle value,
                                                      int64_t bitValue) {
  if (!bitValue)
    return value;
  FailureOr<sym::ExprHandle> quotient = floorDiv(store, value, bitValue);
  FailureOr<sym::ExprHandle> selected =
      succeeded(quotient)
          ? composeWithInt(store, *quotient, sym::ExprBinaryOp::Mod, 2)
          : FailureOr<sym::ExprHandle>(failure());
  FailureOr<sym::ExprHandle> correction =
      succeeded(selected) ? composeWithInt(store, *selected,
                                           sym::ExprBinaryOp::Mul, 2 * bitValue)
                          : FailureOr<sym::ExprHandle>(failure());
  FailureOr<sym::ExprHandle> raised =
      composeWithInt(store, value, sym::ExprBinaryOp::Add, bitValue);
  return succeeded(correction) && succeeded(raised)
             ? sym::composeExprBinary(store, *raised, sym::ExprBinaryOp::Sub,
                                      *correction)
             : FailureOr<sym::ExprHandle>(failure());
}

static FailureOr<bool> proveSpecializedSourceToggle(
    sym::Store &store, const indexing::IndexMap &carrier,
    sym::ExprHandle sourceSlot, unsigned resultBit, unsigned resultBits,
    int64_t sourceBitValue, indexing::CheckMemo &memo) {
  sym::ExprHandle resultSlot = getInput(carrier, kSlot).variable;
  int64_t resultBitValue = int64_t{1} << resultBit;
  int64_t resultSlots = int64_t{1} << resultBits;
  for (int64_t slot : llvm::seq<int64_t>(0, resultSlots)) {
    FailureOr<sym::ExprHandle> sourceIndex = sym::composeExprInt(store, slot);
    FailureOr<sym::ExprHandle> toggledIndex =
        sym::composeExprInt(store, slot ^ resultBitValue);
    if (failed(sourceIndex) || failed(toggledIndex))
      return failure();
    std::array<sym::ExprSubstitution, 1> atSource{
        sym::ExprSubstitution{resultSlot, *sourceIndex}};
    std::array<sym::ExprSubstitution, 1> atToggled{
        sym::ExprSubstitution{resultSlot, *toggledIndex}};
    FailureOr<sym::ExprHandle> source =
        sym::substituteExpr(store, sourceSlot, atSource);
    FailureOr<sym::ExprHandle> toggled =
        sym::substituteExpr(store, sourceSlot, atToggled);
    FailureOr<sym::ExprHandle> expected =
        succeeded(source) ? toggleCoordinateBit(store, *source, sourceBitValue)
                          : FailureOr<sym::ExprHandle>(failure());
    FailureOr<sym::PredHandle> exact =
        succeeded(toggled) && succeeded(expected)
            ? equal(store, *toggled, *expected)
            : FailureOr<sym::PredHandle>(failure());
    FailureOr<sym::CheckResult> proven =
        succeeded(exact)
            ? indexing::check(store, carrier, ArrayRef<sym::PredHandle>{*exact},
                              memo)
            : FailureOr<sym::CheckResult>(failure());
    if (failed(proven))
      return failure();
    if (*proven != sym::CheckResult::True)
      return false;
  }
  return true;
}

static LogicalResult appendPacketBitDependencies(
    sym::Store &store, const indexing::IndexMap &carrier,
    sym::ExprHandle resultSlot, sym::ExprHandle owner,
    sym::ExprHandle sourceSlot, unsigned sourceBits, unsigned resultBits,
    unsigned resultBit, indexing::CheckMemo &memo,
    PacketBitDependencies &dependencies) {
  FailureOr<sym::ExprHandle> toggled = composeWithInt(
      store, resultSlot, sym::ExprBinaryOp::Xor, int64_t{1} << resultBit);
  if (failed(toggled))
    return failure();
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{resultSlot, *toggled}};
  FailureOr<bool> ownerInvariant =
      isInvariantUnderSubstitution(store, carrier, owner, substitution, memo);
  if (failed(ownerInvariant))
    return failure();
  if (!*ownerInvariant)
    return success();
  dependencies.ownerInvariant |= uint64_t{1} << resultBit;
  FailureOr<sym::ExprHandle> toggledSource =
      sym::substituteExpr(store, sourceSlot, substitution);
  if (failed(toggledSource))
    return failure();
  for (unsigned sourceBit = 0; sourceBit <= sourceBits; ++sourceBit) {
    int64_t candidate = sourceBit == sourceBits ? 0 : int64_t{1} << sourceBit;
    FailureOr<sym::ExprHandle> expected =
        toggleCoordinateBit(store, sourceSlot, candidate);
    FailureOr<sym::PredHandle> exact =
        succeeded(expected) ? equal(store, *toggledSource, *expected)
                            : FailureOr<sym::PredHandle>(failure());
    FailureOr<sym::CheckResult> proven =
        succeeded(exact)
            ? indexing::check(store, carrier, ArrayRef<sym::PredHandle>{*exact},
                              memo)
            : FailureOr<sym::CheckResult>(failure());
    if (failed(proven))
      return failure();
    if (*proven == sym::CheckResult::True) {
      dependencies.sourceByResultBit[resultBit] = candidate;
      return success();
    }
    FailureOr<bool> specialized = proveSpecializedSourceToggle(
        store, carrier, sourceSlot, resultBit, resultBits, candidate, memo);
    if (failed(specialized))
      return failure();
    if (*specialized) {
      dependencies.sourceByResultBit[resultBit] = candidate;
      return success();
    }
  }
  for (unsigned sourceBit : llvm::seq<unsigned>(0, sourceBits)) {
    FailureOr<CoordinateFactor> factor =
        factorCoordinate(store, sourceSlot, int64_t{1} << sourceBit);
    FailureOr<sym::ExprHandle> bit =
        succeeded(factor)
            ? composeWithInt(store, factor->group, sym::ExprBinaryOp::Mod, 2)
            : FailureOr<sym::ExprHandle>(failure());
    FailureOr<bool> invariant =
        succeeded(bit) ? isInvariantUnderSubstitution(store, carrier, *bit,
                                                      substitution, memo)
                       : FailureOr<bool>(failure());
    if (failed(invariant))
      return failure();
    if (!*invariant)
      dependencies.sourceByResultBit[resultBit] |= uint64_t{1} << sourceBit;
  }
  return success();
}

static FailureOr<PacketBitDependencies> analyzePacketBitDependencies(
    sym::Store &store, const indexing::IndexMap &carrier, sym::ExprHandle owner,
    sym::ExprHandle sourceSlot, unsigned sourceBits, unsigned resultBits,
    indexing::CheckMemo &memo) {
  sym::ExprHandle resultSlot = getInput(carrier, kSlot).variable;
  PacketBitDependencies dependencies;
  dependencies.sourceByResultBit.resize(resultBits);
  for (unsigned resultBit : llvm::seq<unsigned>(0, resultBits))
    if (failed(appendPacketBitDependencies(store, carrier, resultSlot, owner,
                                           sourceSlot, sourceBits, resultBits,
                                           resultBit, memo, dependencies)))
      return failure();
  return dependencies;
}

static uint64_t getSourceWithinMask(const PacketBitDependencies &dependencies,
                                    uint64_t resultMask, unsigned sourceBits,
                                    unsigned withinBits) {
  uint64_t sourceMask = 0;
  for (unsigned bit :
       llvm::seq<unsigned>(0, dependencies.sourceByResultBit.size()))
    if (resultMask & (uint64_t{1} << bit))
      sourceMask |= dependencies.sourceByResultBit[bit];
  if (static_cast<unsigned>(llvm::popcount(sourceMask)) > withinBits)
    return 0;
  for (bool alsoResultBit : {true, false})
    for (unsigned bit : llvm::seq<unsigned>(0, sourceBits))
      if (static_cast<unsigned>(llvm::popcount(sourceMask)) < withinBits &&
          bool(resultMask & (uint64_t{1} << bit)) == alsoResultBit)
        sourceMask |= uint64_t{1} << bit;
  return sourceMask;
}

static FailureOr<bool>
provePacketPermutations(sym::Store &store, int64_t sourceSlots,
                        int64_t resultSlots, uint64_t sourceMask,
                        uint64_t resultMask, indexing::CheckMemo &memo,
                        std::string &diagnostic) {
  FailureOr<bool> source = proveSlotPermutation(
      store, sourceSlots, sourceMask, "source_packet_slot", memo, diagnostic);
  FailureOr<bool> result = proveSlotPermutation(
      store, resultSlots, resultMask, "result_packet_slot", memo, diagnostic);
  if (failed(source) || failed(result))
    return failure();
  return *source && *result;
}

struct PacketPartition {
  sym::ExprHandle packedSource, packedResult;
  CoordinateFactor source, result;
};

static FailureOr<PacketPartition>
buildPacketPartition(sym::Store &store, const indexing::IndexMap &carrier,
                     sym::ExprHandle sourceSlot, int64_t sourceSlots,
                     int64_t resultSlots, int64_t vectorElements,
                     uint64_t sourceMask, uint64_t resultMask) {
  FailureOr<sym::ExprHandle> packedSource = composeSlotPermutation(
      store, sourceSlot, sourceSlots, sourceMask, /*inverse=*/false);
  FailureOr<sym::ExprHandle> packedResult = composeSlotPermutation(
      store, getInput(carrier, kSlot).variable, resultSlots, resultMask,
      /*inverse=*/false);
  FailureOr<CoordinateFactor> source =
      succeeded(packedSource)
          ? factorCoordinate(store, *packedSource, vectorElements)
          : FailureOr<CoordinateFactor>(failure());
  FailureOr<CoordinateFactor> result =
      succeeded(packedResult)
          ? factorCoordinate(store, *packedResult, vectorElements)
          : FailureOr<CoordinateFactor>(failure());
  if (failed(packedSource) || failed(packedResult) || failed(source) ||
      failed(result))
    return failure();
  return PacketPartition{*packedSource, *packedResult, *source, *result};
}

static FailureOr<bool>
provePacketPartition(sym::Store &store, const indexing::IndexMap &carrier,
                     const PacketPartition &partition, int64_t sourceSlots,
                     int64_t resultSlots, int64_t vectorElements,
                     indexing::CheckMemo &memo, std::string &diagnostic) {
  SmallVector<sym::PredHandle, 16> goals;
  if (failed(appendFactorProof(store, partition.packedSource, partition.source,
                               sourceSlots, vectorElements, goals)) ||
      failed(appendFactorProof(store, partition.packedResult, partition.result,
                               resultSlots, vectorElements, goals)))
    return failure();
  diagnostic.clear();
  FailureOr<sym::CheckResult> proven =
      indexing::check(store, carrier, goals, memo, &diagnostic);
  if (failed(proven))
    return failure();
  return *proven == sym::CheckResult::True;
}

static FailureOr<std::optional<PacketPlan>> provePacketPlan(
    sym::Store &store, const indexing::IndexMap &carrier,
    sym::ExprHandle sourceItem, sym::ExprHandle sourceSlot, int64_t sourceSlots,
    int64_t resultSlots, int64_t vectorElements, uint64_t sourceMask,
    uint64_t resultMask, indexing::CheckMemo &memo, std::string &diagnostic) {
  FailureOr<bool> permutations =
      provePacketPermutations(store, sourceSlots, resultSlots, sourceMask,
                              resultMask, memo, diagnostic);
  if (failed(permutations))
    return failure();
  if (!*permutations)
    return std::optional<PacketPlan>();
  FailureOr<PacketPartition> partition =
      buildPacketPartition(store, carrier, sourceSlot, sourceSlots, resultSlots,
                           vectorElements, sourceMask, resultMask);
  if (failed(partition))
    return failure();
  FailureOr<bool> proven =
      provePacketPartition(store, carrier, *partition, sourceSlots, resultSlots,
                           vectorElements, memo, diagnostic);
  if (failed(proven))
    return failure();
  if (!*proven)
    return std::optional<PacketPlan>();
  return std::optional<PacketPlan>(
      PacketPlan{sourceItem, partition->source.within, partition->source.group,
                 sourceMask, resultMask, vectorElements,
                 sourceSlots / vectorElements, resultSlots / vectorElements});
}

static FailureOr<std::optional<PacketPlan>> searchPacketPlanMasks(
    sym::Store &store, const indexing::IndexMap &carrier,
    sym::ExprHandle sourceItem, sym::ExprHandle sourceSlot, int64_t sourceSlots,
    int64_t resultSlots, int64_t vectorElements,
    const PacketBitDependencies &dependencies, unsigned sourceBits,
    unsigned resultBits, bool allowResultPermutation, indexing::CheckMemo &memo,
    std::string &diagnostic) {
  unsigned withinBits = llvm::Log2_64(vectorElements);
  uint64_t resultMaskLimit = uint64_t{1} << resultBits;
  for (uint64_t resultMask = 0; resultMask < resultMaskLimit; ++resultMask) {
    if (static_cast<unsigned>(llvm::popcount(resultMask)) != withinBits ||
        (!allowResultPermutation &&
         resultMask != static_cast<uint64_t>(vectorElements - 1)) ||
        (resultMask & ~dependencies.ownerInvariant))
      continue;
    uint64_t sourceMask =
        getSourceWithinMask(dependencies, resultMask, sourceBits, withinBits);
    if (static_cast<unsigned>(llvm::popcount(sourceMask)) != withinBits)
      continue;
    FailureOr<std::optional<PacketPlan>> candidate = provePacketPlan(
        store, carrier, sourceItem, sourceSlot, sourceSlots, resultSlots,
        vectorElements, sourceMask, resultMask, memo, diagnostic);
    if (failed(candidate))
      return failure();
    if (*candidate)
      return std::move(*candidate);
  }
  return std::optional<PacketPlan>();
}

static FailureOr<std::optional<PacketPlan>> searchPowerOfTwoPacketPlan(
    sym::Store &store, const indexing::IndexMap &carrier, sym::ExprHandle owner,
    sym::ExprHandle sourceItem, sym::ExprHandle sourceSlot, int64_t sourceSlots,
    int64_t resultSlots, int64_t maxVectorElements, bool allowResultPermutation,
    indexing::CheckMemo &memo, std::string &diagnostic) {
  unsigned sourceBits = llvm::Log2_64(sourceSlots);
  unsigned resultBits = llvm::Log2_64(resultSlots);
  FailureOr<PacketBitDependencies> dependencies = analyzePacketBitDependencies(
      store, carrier, owner, sourceSlot, sourceBits, resultBits, memo);
  if (failed(dependencies))
    return failure();
  for (int64_t vectorElements = maxVectorElements; vectorElements >= 1;
       vectorElements /= 2) {
    FailureOr<std::optional<PacketPlan>> candidate = searchPacketPlanMasks(
        store, carrier, sourceItem, sourceSlot, sourceSlots, resultSlots,
        vectorElements, *dependencies, sourceBits, resultBits,
        allowResultPermutation, memo, diagnostic);
    if (failed(candidate) || *candidate)
      return candidate;
  }
  return std::optional<PacketPlan>();
}

struct EnumeratedPacketPoint {
  int64_t sourceItem, sourceSlot;
};

static FailureOr<int64_t>
evaluatePacketCoordinate(sym::Store &store, const indexing::IndexMap &carrier,
                         sym::ExprHandle expression, int64_t block,
                         int64_t item, int64_t slot) {
  FailureOr<sym::ExprHandle> blockValue = sym::composeExprInt(store, block);
  FailureOr<sym::ExprHandle> itemValue = sym::composeExprInt(store, item);
  FailureOr<sym::ExprHandle> slotValue = sym::composeExprInt(store, slot);
  if (failed(blockValue) || failed(itemValue) || failed(slotValue))
    return failure();
  std::array<sym::ExprSubstitution, 3> substitutions{
      sym::ExprSubstitution{getInput(carrier, kBlock).variable, *blockValue},
      sym::ExprSubstitution{getInput(carrier, kItem).variable, *itemValue},
      sym::ExprSubstitution{getInput(carrier, kSlot).variable, *slotValue}};
  FailureOr<sym::ExprHandle> specialized =
      sym::substituteExpr(store, expression, substitutions);
  FailureOr<sym::ExprHandle> simplified =
      succeeded(specialized) ? sym::simplifyExpr(store, *specialized)
                             : FailureOr<sym::ExprHandle>(failure());
  std::optional<int64_t> literal =
      succeeded(simplified) ? sym::getIntegerLiteralValue(*simplified)
                            : std::nullopt;
  return literal ? FailureOr<int64_t>(*literal) : FailureOr<int64_t>(failure());
}

static bool supportsEnumeratedPacket(ArrayRef<EnumeratedPacketPoint> points,
                                     int64_t blocks, int64_t items,
                                     int64_t sourceSlots, int64_t resultSlots,
                                     int64_t vectorElements,
                                     uint64_t sourceMask, uint64_t resultMask) {
  for (int64_t block : llvm::seq<int64_t>(0, blocks)) {
    for (int64_t item : llvm::seq<int64_t>(0, items)) {
      int64_t base = (block * items + item) * resultSlots;
      for (int64_t packedResult = 0; packedResult < resultSlots;
           packedResult += vectorElements) {
        int64_t resultSlot =
            packedToLogicalSlot(resultMask, resultSlots, packedResult);
        const EnumeratedPacketPoint &first = points[base + resultSlot];
        int64_t sourceGroup =
            logicalToPackedSlot(sourceMask, sourceSlots, first.sourceSlot) /
            vectorElements;
        for (int64_t offset : llvm::seq<int64_t>(1, vectorElements)) {
          resultSlot = packedToLogicalSlot(resultMask, resultSlots,
                                           packedResult + offset);
          const EnumeratedPacketPoint &next = points[base + resultSlot];
          int64_t nextSourceGroup =
              logicalToPackedSlot(sourceMask, sourceSlots, next.sourceSlot) /
              vectorElements;
          if (next.sourceItem != first.sourceItem ||
              nextSourceGroup != sourceGroup)
            return false;
        }
      }
    }
  }
  return true;
}

static FailureOr<std::optional<PacketPlan>> searchEnumeratedPacketPlan(
    sym::Store &store, RedistributeOp op, const indexing::IndexMap &carrier,
    sym::ExprHandle sourceItem, sym::ExprHandle sourceSlot, int64_t sourceSlots,
    int64_t resultSlots, int64_t maxVectorElements, int64_t minVectorElements,
    bool allowResultPermutation) {
  int64_t blocks = op.getRelation().getBlocks();
  int64_t items = op.getRelation().getItems();
  std::optional<int64_t> pointCount = llvm::checkedMul(blocks, items);
  if (pointCount)
    pointCount = llvm::checkedMul(*pointCount, resultSlots);
  if (!pointCount || *pointCount > kMaxEnumeratedPacketPoints)
    return std::optional<PacketPlan>();

  std::vector<EnumeratedPacketPoint> points;
  points.reserve(*pointCount);
  for (int64_t block : llvm::seq<int64_t>(0, blocks)) {
    for (int64_t item : llvm::seq<int64_t>(0, items)) {
      for (int64_t slot : llvm::seq<int64_t>(0, resultSlots)) {
        FailureOr<int64_t> mappedItem = evaluatePacketCoordinate(
            store, carrier, sourceItem, block, item, slot);
        FailureOr<int64_t> mappedSlot = evaluatePacketCoordinate(
            store, carrier, sourceSlot, block, item, slot);
        if (failed(mappedItem) || failed(mappedSlot))
          return failure();
        points.push_back({*mappedItem, *mappedSlot});
      }
    }
  }

  unsigned sourceBits = llvm::Log2_64(sourceSlots);
  unsigned resultBits = llvm::Log2_64(resultSlots);
  for (int64_t vectorElements = maxVectorElements;
       vectorElements > minVectorElements; vectorElements /= 2) {
    unsigned withinBits = llvm::Log2_64(vectorElements);
    uint64_t resultMaskLimit = uint64_t{1} << resultBits;
    uint64_t sourceMaskLimit = uint64_t{1} << sourceBits;
    for (uint64_t resultMask = 0; resultMask < resultMaskLimit; ++resultMask) {
      if (static_cast<unsigned>(llvm::popcount(resultMask)) != withinBits ||
          (!allowResultPermutation &&
           resultMask != static_cast<uint64_t>(vectorElements - 1)))
        continue;
      for (uint64_t sourceMask = 0; sourceMask < sourceMaskLimit;
           ++sourceMask) {
        if (static_cast<unsigned>(llvm::popcount(sourceMask)) != withinBits ||
            !supportsEnumeratedPacket(points, blocks, items, sourceSlots,
                                      resultSlots, vectorElements, sourceMask,
                                      resultMask))
          continue;
        FailureOr<PacketPartition> partition = buildPacketPartition(
            store, carrier, sourceSlot, sourceSlots, resultSlots,
            vectorElements, sourceMask, resultMask);
        if (failed(partition))
          return failure();
        return std::optional<PacketPlan>(PacketPlan{
            sourceItem, partition->source.within, partition->source.group,
            sourceMask, resultMask, vectorElements,
            sourceSlots / vectorElements, resultSlots / vectorElements});
      }
    }
  }
  return std::optional<PacketPlan>();
}

static std::optional<int64_t> getMaxPacketVectorElements(int64_t sourceSlots,
                                                         int64_t resultSlots,
                                                         int64_t maxElements) {
  if (sourceSlots <= 0 || resultSlots <= 0 || maxElements <= 0)
    return std::nullopt;
  int64_t limit = std::min({sourceSlots, resultSlots, maxElements});
  int64_t vectorElements = 1;
  while (vectorElements <= limit / 2)
    vectorElements *= 2;
  return vectorElements;
}

static FailureOr<std::optional<GroupWindow>> proveGroupWindow(
    sym::Store &store, RedistributeOp op, const indexing::IndexMap &carrier,
    sym::ExprHandle sourceGroup, int64_t sourceGroups, int64_t localGroups,
    ArrayRef<sym::ExprSubstitution> atItemZero, bool requireItemInvariant,
    indexing::CheckMemo &memo, std::string &diagnostic) {
  FailureOr<CoordinateFactor> factor =
      factorCoordinate(store, sourceGroup, localGroups);
  if (failed(factor))
    return failure();
  int64_t stageCount = llvm::divideCeil(sourceGroups, localGroups);
  SmallVector<sym::PredHandle, 8> goals;
  if (failed(appendFactorProof(store, sourceGroup, *factor, sourceGroups,
                               localGroups, goals)))
    return failure();
  std::optional<sym::ExprHandle> invariantStage;
  if (requireItemInvariant) {
    FailureOr<sym::ExprHandle> reference =
        sym::substituteExpr(store, factor->group, atItemZero);
    FailureOr<sym::PredHandle> invariant =
        succeeded(reference) ? equal(store, factor->group, *reference)
                             : FailureOr<sym::PredHandle>(failure());
    if (failed(invariant))
      return failure();
    goals.push_back(*invariant);
    invariantStage = *reference;
  }
  diagnostic.clear();
  FailureOr<sym::CheckResult> proven =
      indexing::check(store, carrier, goals, memo, &diagnostic);
  if (failed(proven))
    return op.emitOpError("failed to prove direct source-group window: ")
           << diagnostic;
  if (*proven != sym::CheckResult::True)
    return std::optional<GroupWindow>();
  if (invariantStage) {
    auto simplified = indexing::simplify(
        store, carrier, ArrayRef<sym::ExprHandle>{*invariantStage}, {});
    if (failed(simplified))
      return failure();
    invariantStage = simplified->front();
  }
  return std::optional<GroupWindow>(
      GroupWindow{invariantStage.value_or(factor->group), factor->within,
                  localGroups, stageCount});
}

static FailureOr<std::optional<GroupWindow>>
findGroupWindowFiber(sym::Store &store, RedistributeOp op,
                     const indexing::IndexMap &carrier,
                     sym::ExprHandle sourceGroup, int64_t sourceGroups,
                     ArrayRef<sym::ExprSubstitution> atItemZero,
                     indexing::CheckMemo &memo, std::string &diagnostic) {
  for (int64_t localGroups = 1; localGroups < sourceGroups; ++localGroups) {
    FailureOr<std::optional<GroupWindow>> candidate = proveGroupWindow(
        store, op, carrier, sourceGroup, sourceGroups, localGroups, atItemZero,
        /*requireItemInvariant=*/true, memo, diagnostic);
    if (failed(candidate) || *candidate)
      return candidate;
  }
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  if (failed(zero))
    return failure();
  // PacketPlan has already proved sourceGroup is in [0, sourceGroups). The
  // full source-group window therefore has one constant stage by construction;
  // re-proving that range through the expanded relation is redundant.
  return std::optional<GroupWindow>(
      GroupWindow{*zero, sourceGroup, sourceGroups, /*stageCount=*/1});
}

} // namespace

namespace mlir::wave {

int64_t packedToLogicalSlot(uint64_t withinMask, int64_t slots,
                            int64_t packedSlot) {
  if (isIdentitySlotPermutation(slots, withinMask))
    return packedSlot;
  uint64_t logicalSlot = 0;
  unsigned packedBit = 0, slotBits = llvm::Log2_64(slots);
  for (bool selected : {true, false})
    for (unsigned logicalBit : llvm::seq<unsigned>(0, slotBits))
      if (bool(withinMask & (uint64_t{1} << logicalBit)) == selected)
        logicalSlot |= ((uint64_t(packedSlot) >> packedBit++) & 1)
                       << logicalBit;
  return logicalSlot;
}

int64_t logicalToPackedSlot(uint64_t withinMask, int64_t slots,
                            int64_t logicalSlot) {
  if (isIdentitySlotPermutation(slots, withinMask))
    return logicalSlot;
  int64_t packedSlot = 0;
  unsigned packedBit = 0, slotBits = llvm::Log2_64(slots);
  for (bool selected : {true, false})
    for (unsigned logicalBit : llvm::seq<unsigned>(0, slotBits))
      if (bool(withinMask & (uint64_t{1} << logicalBit)) == selected)
        packedSlot |= ((logicalSlot >> logicalBit) & 1) << packedBit++;
  return packedSlot;
}

FailureOr<PacketPlan> buildPacketPlan(sym::Store &store, RedistributeOp op,
                                      const indexing::IndexMap &carrier,
                                      int64_t maxElements,
                                      std::optional<int64_t> waveWidth,
                                      bool allowResultPermutation) {
  int64_t sourceSlots = getPacketElementCount(op.getSource().getType());
  int64_t resultSlots = getPacketElementCount(op.getResult().getType());
  auto [sourceBlock, sourceItem, sourceSlot] = getSourceCoordinates(carrier);
  (void)sourceBlock;
  std::optional<int64_t> maxVectorElements =
      getMaxPacketVectorElements(sourceSlots, resultSlots, maxElements);
  if (!maxVectorElements)
    return failure();
  FailureOr<sym::ExprHandle> owner =
      waveWidth ? composeWithInt(store, sourceItem, sym::ExprBinaryOp::Mod,
                                 *waveWidth)
                : FailureOr<sym::ExprHandle>(sourceItem);
  if (failed(owner))
    return failure();
  indexing::CheckMemo memo;
  std::string diagnostic;
  FailureOr<std::optional<PacketPlan>> candidate =
      llvm::isPowerOf2_64(sourceSlots) && llvm::isPowerOf2_64(resultSlots)
          ? searchPowerOfTwoPacketPlan(store, carrier, *owner, sourceItem,
                                       sourceSlot, sourceSlots, resultSlots,
                                       *maxVectorElements,
                                       allowResultPermutation, memo, diagnostic)
          : provePacketPlan(store, carrier, sourceItem, sourceSlot, sourceSlots,
                            resultSlots, /*vectorElements=*/1, 0, 0, memo,
                            diagnostic);
  if (failed(candidate))
    return op.emitOpError("failed to prove direct packet partition: ")
           << diagnostic;
  if (allowResultPermutation && llvm::isPowerOf2_64(sourceSlots) &&
      llvm::isPowerOf2_64(resultSlots) &&
      (!*candidate || (**candidate).vectorElements < *maxVectorElements)) {
    FailureOr<std::optional<PacketPlan>> enumerated =
        searchEnumeratedPacketPlan(store, op, carrier, sourceItem, sourceSlot,
                                   sourceSlots, resultSlots, *maxVectorElements,
                                   *candidate ? (**candidate).vectorElements
                                              : 0,
                                   allowResultPermutation);
    if (failed(enumerated))
      return op.emitOpError("failed to enumerate direct packet partition");
    if (*enumerated)
      return std::move(**enumerated);
  }
  if (*candidate)
    return std::move(**candidate);
  return op.emitOpError("could not prove the scalar direct packet partition: ")
         << diagnostic;
}

FailureOr<GroupWindow> buildGroupWindow(sym::Store &store, RedistributeOp op,
                                        const indexing::IndexMap &carrier,
                                        sym::ExprHandle sourceGroup,
                                        int64_t sourceGroups,
                                        int64_t maxLocalGroups) {
  if (sourceGroups <= 0 || maxLocalGroups <= 0)
    return failure();
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  if (failed(zero))
    return failure();
  sym::ExprHandle item = getInput(carrier, kItem).variable;
  std::array<sym::ExprSubstitution, 1> atItemZero{
      sym::ExprSubstitution{item, *zero}};
  indexing::CheckMemo memo;
  std::string diagnostic;
  FailureOr<std::optional<GroupWindow>> fiber =
      findGroupWindowFiber(store, op, carrier, sourceGroup, sourceGroups,
                           atItemZero, memo, diagnostic);
  if (failed(fiber))
    return failure();
  if (!*fiber)
    return op.emitOpError(
               "could not prove a destination-item source-group fiber: ")
           << diagnostic;
  int64_t localGroups = std::min((**fiber).localGroups, maxLocalGroups);
  if (localGroups == (**fiber).localGroups)
    return std::move(**fiber);
  FailureOr<std::optional<GroupWindow>> refined = proveGroupWindow(
      store, op, carrier, sourceGroup, sourceGroups, localGroups, atItemZero,
      /*requireItemInvariant=*/false, memo, diagnostic);
  if (failed(refined))
    return failure();
  if (!*refined)
    return op.emitOpError("could not prove the capacity-refined source-group "
                          "partition: ")
           << diagnostic;
  return std::move(**refined);
}

} // namespace mlir::wave
