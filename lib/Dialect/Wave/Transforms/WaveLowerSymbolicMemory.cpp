//===- WaveLowerSymbolicMemory.cpp - lower symbolic memory -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/Wave/Transforms/SymbolicValue.h"

#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"

#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <limits>
#include <optional>
#include <string>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVELOWERSYMBOLICMEMORY
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct NamedBinding {
  std::string name;
  Value value;
};

struct SlotMapping {
  SmallVector<NamedBinding> bindings;
  SmallVector<sym::PredHandle> assumptions;
  SmallVector<unsigned> logicalSlots;
  sym::ExprHandle base;
  sym::ExprHandle targetBlock;
  sym::ExprHandle bitOffset;
  sym::ExprHandle byteOffset;
  int64_t baseIndex = 0;
};

struct PacketBindingState {
  llvm::DenseMap<Value, StringRef> byValue;
  llvm::StringMap<Value> reserved;
};

struct MappingCoordinates {
  sym::ExprHandle base;
  sym::ExprHandle targetBlock;
  sym::ExprHandle bitOffset;
};

struct MemoryAccess {
  SmallVector<Value> bases;
  SmallVector<Value> bindings;
  SmallVector<Value> packetBindings;
  SmallVector<std::string> bindingNames;
  SmallVector<std::string> packetBindingNames;
  MemoryMappingAttr mapping;
  SimdType packetType;
  Value packet;
  Value dependency;
  Attribute cache;
  Type tokenType;
  Operation *op = nullptr;
  bool gather = false;
};

struct CoverState {
  int64_t singletons = std::numeric_limits<int64_t>::max();
  int64_t transactions = std::numeric_limits<int64_t>::max();
  int64_t widthScore = std::numeric_limits<int64_t>::min();
  int64_t length = -1;
};

struct TransactionCandidate {
  SmallVector<unsigned> nodes;
  uint64_t mask = 0;
};

struct ExactCoverResult {
  SmallVector<unsigned> candidates;
  CoverState score;
  bool valid = false;
};

struct ContiguousMatching {
  SmallVector<int64_t> successor;
  SmallVector<int64_t> predecessor;
};

struct AccessShape {
  VectorType packet;
  int64_t slotCount = 0;
  int64_t elementBits = 0;
};

struct MappingDomain {
  sym::ExprHandle block;
  sym::ExprHandle slot;
  sym::ExprHandle zero;
};

static constexpr unsigned kMaxExactCoverNodes = 20;
static constexpr unsigned kMaxTransactionCandidates = 4096;

static SmallVector<std::string> getNames(ArrayAttr attrs) {
  SmallVector<std::string> names;
  names.reserve(attrs.size());
  for (Attribute attr : attrs)
    names.push_back(cast<StringAttr>(attr).getValue().str());
  return names;
}

static MemoryAccess getAccess(GatherOp op) {
  MemoryAccess access;
  access.op = op;
  llvm::append_range(access.bases, op.getBases());
  llvm::append_range(access.bindings, op.getBindings());
  llvm::append_range(access.packetBindings, op.getPacketBindings());
  access.bindingNames = getNames(op.getBindingNames());
  access.packetBindingNames = getNames(op.getPacketBindingNames());
  access.mapping = op.getMapping();
  access.packetType = cast<SimdType>(op.getValue().getType());
  access.dependency = op.getDependency();
  access.cache = op.getCacheAttr();
  access.tokenType = op.getToken().getType();
  access.gather = true;
  return access;
}

static MemoryAccess getAccess(ScatterOp op) {
  MemoryAccess access;
  access.op = op;
  llvm::append_range(access.bases, op.getBases());
  llvm::append_range(access.bindings, op.getBindings());
  llvm::append_range(access.packetBindings, op.getPacketBindings());
  access.bindingNames = getNames(op.getBindingNames());
  access.packetBindingNames = getNames(op.getPacketBindingNames());
  access.mapping = op.getMapping();
  access.packetType = cast<SimdType>(op.getValue().getType());
  access.packet = op.getValue();
  access.dependency = op.getDependency();
  access.cache = op.getCacheAttr();
  access.tokenType = op.getToken().getType();
  return access;
}

static bool hasSymbol(sym::ExprHandle expr, StringRef sought) {
  bool found = false;
  sym::walkSymbolNames(expr, [&](StringRef name) { found |= name == sought; });
  return found;
}

static bool mappingHasSymbol(MemoryMappingAttr mapping, StringRef name) {
  return (mapping.getBase() && hasSymbol(mapping.getBase().getValue(), name)) ||
         (mapping.getTargetBlock() &&
          hasSymbol(mapping.getTargetBlock().getValue(), name)) ||
         hasSymbol(mapping.getBitOffset().getValue(), name);
}

static DenseI32ArrayAttr getWorkgroupShape(Operation *op) {
  func::FuncOp func = op->getParentOfType<func::FuncOp>();
  if (!func)
    return {};
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"})
    if (DenseI32ArrayAttr shape = func->getAttrOfType<DenseI32ArrayAttr>(name))
      return shape;
  return {};
}

static FailureOr<Value> materializeItem(IRRewriter &rewriter,
                                        const MemoryAccess &access) {
  DenseI32ArrayAttr shape = getWorkgroupShape(access.op);
  if (!shape)
    return access.op->emitOpError("requires a known workgroup shape");
  ArrayRef<int32_t> dims = shape.asArrayRef();
  if (dims.size() != 3 ||
      llvm::any_of(dims, [](int32_t dim) { return dim <= 0; }))
    return access.op->emitOpError(
        "requires three positive workgroup dimensions");
  int64_t xy = int64_t{dims[0]} * dims[1];
  if (xy * dims[2] > std::numeric_limits<int32_t>::max())
    return access.op->emitOpError("row-major workitem index exceeds i32");
  Type type = SimdType::get(access.op->getContext(), rewriter.getI32Type(),
                            access.packetType.getWidth());
  Location loc = access.op->getLoc();
  Value item = WorkitemIdOp::create(rewriter, loc, type, 0);
  if (dims[1] > 1) {
    Value y = WorkitemIdOp::create(rewriter, loc, type, 1);
    Value scale = ConstantOp::create(rewriter, loc, type,
                                     rewriter.getI32IntegerAttr(dims[0]));
    Value scaled =
        BinaryOp::create(rewriter, loc, type, BinaryKind::MulI, y, scale);
    item =
        BinaryOp::create(rewriter, loc, type, BinaryKind::AddI, item, scaled);
  }
  if (dims[2] > 1) {
    Value z = WorkitemIdOp::create(rewriter, loc, type, 2);
    Value scale = ConstantOp::create(
        rewriter, loc, type,
        rewriter.getI32IntegerAttr(static_cast<int32_t>(xy)));
    Value scaled =
        BinaryOp::create(rewriter, loc, type, BinaryKind::MulI, z, scale);
    item =
        BinaryOp::create(rewriter, loc, type, BinaryKind::AddI, item, scaled);
  }
  return item;
}

static FailureOr<sym::ExprHandle>
substituteAndSimplify(sym::Store &store, sym::ExprHandle expr,
                      ArrayRef<sym::ExprSubstitution> substitutions,
                      ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> substituted =
      sym::substituteExpr(store, expr, substitutions);
  if (failed(substituted))
    return failure();
  return sym::simplifyExpr(store, *substituted, assumptions);
}

static FailureOr<sym::ExprHandle>
divideExactly(sym::Store &store, sym::ExprHandle value, int64_t divisor,
              ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> divisorExpr = sym::composeExprInt(store, divisor);
  if (failed(divisorExpr))
    return failure();
  FailureOr<sym::ExprHandle> quotient = sym::composeExprBinary(
      store, value, sym::ExprBinaryOp::Div, *divisorExpr);
  if (failed(quotient))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(store, *quotient, assumptions);
  if (failed(simplified))
    return failure();
  std::optional<int64_t> denominator = sym::collectDenominator(*simplified);
  if (!denominator || *denominator != 1)
    return failure();
  return *simplified;
}

static bool proveEqual(sym::Store &store, sym::ExprHandle lhs,
                       sym::ExprHandle rhs,
                       ArrayRef<sym::PredHandle> assumptions);

static StringRef getSymbolName(const SymbolicOffsetBinding &binding) {
  StringRef name = sym::ExprView(binding.name).getSymbolName();
  assert(!name.empty() && "symbolic offset binding must have a name");
  return name;
}

static LogicalResult appendBinding(SlotMapping &mapping, StringRef name,
                                   Value value) {
  for (const NamedBinding &binding : mapping.bindings) {
    if (binding.name != name)
      continue;
    return success(binding.value == value);
  }
  mapping.bindings.push_back({name.str(), value});
  return success();
}

static void seedPacketBindingState(const MemoryAccess &access, Value item,
                                   PacketBindingState &state) {
  state.reserved.try_emplace("block", Value());
  state.reserved.try_emplace("slot", Value());
  auto [itemIt, itemInserted] = state.reserved.try_emplace("item", item);
  (void)itemInserted;
  if (item)
    state.byValue.try_emplace(item, itemIt->getKey());

  for (auto [name, value] : llvm::zip(access.bindingNames, access.bindings)) {
    auto [it, inserted] = state.reserved.try_emplace(name, value);
    (void)inserted;
    state.byValue.try_emplace(value, it->getKey());
  }
  for (StringRef name : access.packetBindingNames)
    state.reserved.try_emplace(name, Value());
}

static FailureOr<sym::ExprHandle>
remapSymbolicOffset(sym::Store &store, const SymbolicOffset &offset,
                    PacketBindingState &state, SlotMapping &mapping) {
  SmallVector<sym::ExprSubstitution> substitutions;
  for (const SymbolicOffsetBinding &binding : offset.bindings) {
    StringRef oldName = getSymbolName(binding);
    StringRef newName = reserveIndexExprBindingName(
        oldName, binding.value, state.reserved, state.byValue);
    if (failed(appendBinding(mapping, newName, binding.value)))
      return failure();
    if (newName == oldName)
      continue;
    FailureOr<sym::ExprHandle> replacement =
        sym::composeExprSym(store, newName);
    if (failed(replacement))
      return failure();
    substitutions.push_back({binding.name, *replacement});
  }

  if (substitutions.empty())
    llvm::append_range(mapping.assumptions, offset.assumptions);
  else {
    FailureOr<SmallVector<sym::PredHandle>> assumptions =
        substituteIndexExprPredicates(store, offset.assumptions, substitutions);
    if (failed(assumptions))
      return failure();
    llvm::append_range(mapping.assumptions, *assumptions);
  }
  if (substitutions.empty())
    return offset.expr;
  return sym::substituteExpr(store, offset.expr, substitutions);
}

static LogicalResult appendPacketSubstitution(
    sym::Store &store, StringRef name, const SymbolicOffset &offset,
    PacketBindingState &state, SlotMapping &mapping,
    SmallVectorImpl<sym::ExprSubstitution> &substitutions) {
  FailureOr<sym::ExprHandle> original = sym::composeExprSym(store, name);
  FailureOr<sym::ExprHandle> replacement =
      remapSymbolicOffset(store, offset, state, mapping);
  if (failed(original) || failed(replacement))
    return failure();
  substitutions.push_back({*original, *replacement});
  return success();
}

static LogicalResult appendAccessBindings(const MemoryAccess &access,
                                          sym::Store &store, Value item,
                                          SlotMapping &mapping) {
  for (auto [name, value] : llvm::zip(access.bindingNames, access.bindings)) {
    if (failed(appendBinding(mapping, name, value)))
      return failure();
    appendAssumePredicates(store, value, name, mapping.assumptions);
  }
  if (!item)
    return success();
  if (failed(appendBinding(mapping, "item", item)))
    return failure();
  appendAssumePredicates(store, item, "item", mapping.assumptions);
  return success();
}

static FailureOr<SmallVector<sym::ExprSubstitution>>
buildSlotSubstitutions(const MemoryAccess &access, sym::Store &store,
                       sym::ExprHandle slotSymbol, int64_t slot,
                       ArrayRef<SmallVector<SymbolicOffset>> packetComponents,
                       PacketBindingState &bindingState, SlotMapping &mapping) {
  FailureOr<sym::ExprHandle> slotValue = sym::composeExprInt(store, slot);
  if (failed(slotValue))
    return failure();
  SmallVector<sym::ExprSubstitution> substitutions{
      sym::ExprSubstitution{slotSymbol, *slotValue}};
  for (auto [bindingIndex, name] : llvm::enumerate(access.packetBindingNames))
    if (failed(appendPacketSubstitution(store, name,
                                        packetComponents[bindingIndex][slot],
                                        bindingState, mapping, substitutions)))
      return failure();
  return substitutions;
}

static MappingCoordinates getMappingCoordinates(const MemoryAccess &access,
                                                sym::ExprHandle block,
                                                sym::ExprHandle zero) {
  MappingCoordinates coordinates{zero, block,
                                 access.mapping.getBitOffset().getValue()};
  if (access.mapping.getBase())
    coordinates.base = access.mapping.getBase().getValue();
  if (access.mapping.getTargetBlock())
    coordinates.targetBlock = access.mapping.getTargetBlock().getValue();
  return coordinates;
}

static FailureOr<MappingCoordinates>
specializeCoordinates(sym::Store &store, const MappingCoordinates &coordinates,
                      ArrayRef<sym::ExprSubstitution> substitutions,
                      ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> base = substituteAndSimplify(
      store, coordinates.base, substitutions, assumptions);
  if (failed(base))
    return failure();
  FailureOr<sym::ExprHandle> targetBlock = substituteAndSimplify(
      store, coordinates.targetBlock, substitutions, assumptions);
  if (failed(targetBlock))
    return failure();
  FailureOr<sym::ExprHandle> bitOffset = substituteAndSimplify(
      store, coordinates.bitOffset, substitutions, assumptions);
  if (failed(bitOffset))
    return failure();
  return MappingCoordinates{*base, *targetBlock, *bitOffset};
}

static bool coordinatesProvablyDefined(sym::Store &store,
                                       const MappingCoordinates &coordinates,
                                       ArrayRef<sym::PredHandle> assumptions) {
  return sym::provablyDefined(store, coordinates.base, assumptions) &&
         sym::provablyDefined(store, coordinates.targetBlock, assumptions) &&
         sym::provablyDefined(store, coordinates.bitOffset, assumptions);
}

static FailureOr<int64_t>
validateLocalCoordinates(const MemoryAccess &access, sym::Store &store,
                         const MappingCoordinates &coordinates,
                         sym::ExprHandle block,
                         ArrayRef<sym::PredHandle> assumptions) {
  if (!coordinatesProvablyDefined(store, coordinates, assumptions))
    return failure();
  if (hasSymbol(coordinates.base, "block") ||
      hasSymbol(coordinates.bitOffset, "block"))
    return failure();
  if (!proveEqual(store, coordinates.targetBlock, block, assumptions))
    return failure();
  std::optional<int64_t> baseIndex =
      sym::getIntegerLiteralValue(coordinates.base);
  if (!baseIndex)
    return failure();
  if (*baseIndex < 0)
    return failure();
  if (static_cast<uint64_t>(*baseIndex) >= access.bases.size())
    return failure();
  return *baseIndex;
}

static FailureOr<sym::ExprHandle>
getByteOffset(sym::Store &store, sym::ExprHandle bitOffset,
              ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> byteOffset =
      divideExactly(store, bitOffset, 8, assumptions);
  if (failed(byteOffset))
    return failure();
  if (!sym::provablyDefined(store, *byteOffset, assumptions))
    return failure();
  return byteOffset;
}

static FailureOr<SlotMapping>
buildSlotMapping(const MemoryAccess &access, sym::Store &store,
                 sym::ExprHandle blockSymbol, sym::ExprHandle slotSymbol,
                 sym::ExprHandle zero, int64_t slot, Value item,
                 ArrayRef<SmallVector<SymbolicOffset>> packetComponents,
                 PacketBindingState &bindingState) {
  SlotMapping result;
  result.logicalSlots.push_back(static_cast<unsigned>(slot));
  if (failed(appendAccessBindings(access, store, item, result)))
    return failure();
  FailureOr<SmallVector<sym::ExprSubstitution>> substitutions =
      buildSlotSubstitutions(access, store, slotSymbol, slot, packetComponents,
                             bindingState, result);
  if (failed(substitutions))
    return failure();
  MappingCoordinates coordinates =
      getMappingCoordinates(access, blockSymbol, zero);
  FailureOr<MappingCoordinates> specialized = specializeCoordinates(
      store, coordinates, *substitutions, result.assumptions);
  if (failed(specialized))
    return failure();
  FailureOr<int64_t> baseIndex = validateLocalCoordinates(
      access, store, *specialized, blockSymbol, result.assumptions);
  if (failed(baseIndex))
    return failure();
  std::array<sym::ExprSubstitution, 1> blockSubstitution{
      sym::ExprSubstitution{blockSymbol, zero}};
  FailureOr<MappingCoordinates> local = specializeCoordinates(
      store, *specialized, blockSubstitution, result.assumptions);
  if (failed(local))
    return failure();
  FailureOr<sym::ExprHandle> byteOffset =
      getByteOffset(store, local->bitOffset, result.assumptions);
  if (failed(byteOffset))
    return failure();
  result.base = local->base;
  result.targetBlock = local->targetBlock;
  result.bitOffset = local->bitOffset;
  result.byteOffset = *byteOffset;
  result.baseIndex = *baseIndex;
  return result;
}

static SmallVector<sym::PredHandle> combineAssumptions(const SlotMapping &lhs,
                                                       const SlotMapping &rhs) {
  SmallVector<sym::PredHandle> assumptions = lhs.assumptions;
  llvm::append_range(assumptions, rhs.assumptions);
  return assumptions;
}

static bool proveEqual(sym::Store &store, sym::ExprHandle lhs,
                       sym::ExprHandle rhs,
                       ArrayRef<sym::PredHandle> assumptions) {
  if (lhs == rhs)
    return true;
  FailureOr<sym::ExprHandle> difference =
      sym::composeExprBinary(store, lhs, sym::ExprBinaryOp::Sub, rhs);
  if (succeeded(difference)) {
    FailureOr<sym::ExprHandle> simplified =
        sym::simplifyExpr(store, *difference, assumptions);
    if (succeeded(simplified) && sym::getIntegerLiteralValue(*simplified) == 0)
      return true;
  }
  FailureOr<sym::PredHandle> equal =
      sym::composePredCmp(store, lhs, sym::PredCmpOp::Eq, rhs);
  return succeeded(equal) && sym::checkPredicate(store, *equal, assumptions) ==
                                 sym::CheckResult::True;
}

static bool samePoint(sym::Store &store, const SlotMapping &lhs,
                      const SlotMapping &rhs) {
  SmallVector<sym::PredHandle> assumptions = combineAssumptions(lhs, rhs);
  return proveEqual(store, lhs.base, rhs.base, assumptions) &&
         proveEqual(store, lhs.targetBlock, rhs.targetBlock, assumptions) &&
         proveEqual(store, lhs.bitOffset, rhs.bitOffset, assumptions);
}

static bool adjacent(sym::Store &store, const SlotMapping &lhs,
                     const SlotMapping &rhs, int64_t elementBits) {
  SmallVector<sym::PredHandle> assumptions = combineAssumptions(lhs, rhs);
  if (!proveEqual(store, lhs.base, rhs.base, assumptions) ||
      !proveEqual(store, lhs.targetBlock, rhs.targetBlock, assumptions))
    return false;
  FailureOr<sym::ExprHandle> delta = sym::composeExprInt(store, elementBits);
  if (failed(delta))
    return false;
  FailureOr<sym::ExprHandle> expected = sym::composeExprBinary(
      store, lhs.bitOffset, sym::ExprBinaryOp::Add, *delta);
  return succeeded(expected) &&
         proveEqual(store, *expected, rhs.bitOffset, assumptions);
}

static SmallVector<SlotMapping>
deduplicateGatherSlots(sym::Store &store, SmallVector<SlotMapping> slots) {
  SmallVector<SlotMapping> unique;
  for (SlotMapping &slot : slots) {
    auto found = llvm::find_if(unique, [&](const SlotMapping &candidate) {
      return samePoint(store, candidate, slot);
    });
    if (found == unique.end()) {
      unique.push_back(std::move(slot));
      continue;
    }
    llvm::append_range(found->logicalSlots, slot.logicalSlots);
  }
  return unique;
}

static SmallVector<SmallVector<unsigned>>
buildSuccessorGraph(sym::Store &store, ArrayRef<SlotMapping> slots,
                    int64_t elementBits) {
  size_t count = slots.size();
  SmallVector<SmallVector<unsigned>> edges(count);
  for (unsigned lhs = 0; lhs < count; ++lhs)
    for (unsigned rhs = 0; rhs < count; ++rhs)
      if (lhs != rhs && adjacent(store, slots[lhs], slots[rhs], elementBits))
        edges[lhs].push_back(rhs);
  return edges;
}

static bool augmentMatching(unsigned lhs, ArrayRef<SmallVector<unsigned>> edges,
                            SmallVectorImpl<int64_t> &matchedRight,
                            SmallVectorImpl<uint8_t> &seen) {
  for (unsigned rhs : edges[lhs]) {
    if (seen[rhs])
      continue;
    seen[rhs] = 1;
    if (matchedRight[rhs] >= 0 &&
        !augmentMatching(static_cast<unsigned>(matchedRight[rhs]), edges,
                         matchedRight, seen))
      continue;
    matchedRight[rhs] = lhs;
    return true;
  }
  return false;
}

static ContiguousMatching
buildContiguousMatching(ArrayRef<SmallVector<unsigned>> edges) {
  size_t count = edges.size();
  SmallVector<int64_t> matchedRight(count, -1);
  for (unsigned lhs = 0; lhs < count; ++lhs) {
    SmallVector<uint8_t> seen(count, 0);
    augmentMatching(lhs, edges, matchedRight, seen);
  }

  ContiguousMatching result{SmallVector<int64_t>(count, -1),
                            SmallVector<int64_t>(count, -1)};
  for (unsigned rhs = 0; rhs < count; ++rhs) {
    if (matchedRight[rhs] < 0)
      continue;
    unsigned lhs = static_cast<unsigned>(matchedRight[rhs]);
    result.successor[lhs] = rhs;
    result.predecessor[rhs] = lhs;
  }
  return result;
}

static SmallVector<unsigned>
takeContiguousChain(unsigned start, ArrayRef<int64_t> successor,
                    SmallVectorImpl<uint8_t> &visited) {
  SmallVector<unsigned> chain;
  int64_t current = start;
  while (current >= 0 && !visited[current]) {
    visited[current] = 1;
    chain.push_back(static_cast<unsigned>(current));
    current = successor[current];
  }
  return chain;
}

static SmallVector<SmallVector<unsigned>>
buildContiguousChains(ArrayRef<SmallVector<unsigned>> edges) {
  ContiguousMatching matching = buildContiguousMatching(edges);
  SmallVector<SmallVector<unsigned>> chains;
  SmallVector<uint8_t> visited(edges.size(), 0);
  for (unsigned index = 0; index < edges.size(); ++index)
    if (matching.predecessor[index] < 0)
      chains.push_back(takeContiguousChain(index, matching.successor, visited));
  for (unsigned index = 0; index < edges.size(); ++index)
    if (!visited[index])
      chains.push_back(takeContiguousChain(index, matching.successor, visited));
  return chains;
}

static bool legalTransactionLength(int64_t length, int64_t elementBits) {
  if (length == 1)
    return elementBits == 8 || elementBits == 16 || elementBits == 32;
  int64_t payloadBits = length * elementBits;
  return payloadBits == 16 || payloadBits % 32 == 0;
}

static bool betterCover(const CoverState &candidate,
                        const CoverState &current) {
  if (candidate.singletons != current.singletons)
    return candidate.singletons < current.singletons;
  if (candidate.transactions != current.transactions)
    return candidate.transactions < current.transactions;
  if (candidate.widthScore != current.widthScore)
    return candidate.widthScore > current.widthScore;
  return candidate.length > current.length;
}

static SmallVector<SmallVector<unsigned>> coverChain(ArrayRef<unsigned> chain,
                                                     int64_t elementBits) {
  int64_t count = chain.size();
  SmallVector<CoverState> states(count + 1);
  states[count] = CoverState{0, 0, 0, 0};
  for (int64_t position = static_cast<int64_t>(count) - 1; position >= 0;
       --position) {
    for (int64_t length = 1; position + length <= count; ++length) {
      if (!legalTransactionLength(length, elementBits))
        continue;
      const CoverState &tail = states[position + length];
      if (tail.length < 0)
        continue;
      CoverState candidate{tail.singletons + (length == 1),
                           tail.transactions + 1,
                           tail.widthScore + length * length, length};
      if (betterCover(candidate, states[position]))
        states[position] = candidate;
    }
  }

  SmallVector<SmallVector<unsigned>> transactions;
  for (int64_t position = 0; position < count;) {
    int64_t length = states[position].length;
    if (length <= 0)
      return {};
    transactions.emplace_back(chain.slice(position, length));
    position += length;
  }
  return transactions;
}

static void
enumerateTransactionPaths(ArrayRef<SmallVector<unsigned>> edges,
                          int64_t elementBits, SmallVectorImpl<unsigned> &path,
                          uint64_t mask, llvm::DenseSet<uint64_t> &seenMasks,
                          SmallVectorImpl<TransactionCandidate> &candidates,
                          bool &exhausted) {
  if (exhausted)
    return;
  if (legalTransactionLength(path.size(), elementBits) &&
      seenMasks.insert(mask).second) {
    if (candidates.size() == kMaxTransactionCandidates) {
      exhausted = true;
      return;
    }
    TransactionCandidate candidate;
    llvm::append_range(candidate.nodes, path);
    candidate.mask = mask;
    candidates.push_back(std::move(candidate));
  }
  for (unsigned next : edges[path.back()]) {
    uint64_t bit = uint64_t{1} << next;
    if (mask & bit)
      continue;
    path.push_back(next);
    enumerateTransactionPaths(edges, elementBits, path, mask | bit, seenMasks,
                              candidates, exhausted);
    path.pop_back();
    if (exhausted)
      return;
  }
}

static FailureOr<SmallVector<TransactionCandidate>>
enumerateTransactionCandidates(ArrayRef<SmallVector<unsigned>> edges,
                               int64_t elementBits) {
  SmallVector<TransactionCandidate> candidates;
  llvm::DenseSet<uint64_t> seenMasks;
  bool exhausted = false;
  for (unsigned start = 0; start < edges.size() && !exhausted; ++start) {
    SmallVector<unsigned> path{start};
    enumerateTransactionPaths(edges, elementBits, path, uint64_t{1} << start,
                              seenMasks, candidates, exhausted);
  }
  if (exhausted)
    return failure();
  llvm::sort(candidates, [](const TransactionCandidate &lhs,
                            const TransactionCandidate &rhs) {
    if (lhs.nodes.size() != rhs.nodes.size())
      return lhs.nodes.size() > rhs.nodes.size();
    return std::lexicographical_compare(lhs.nodes.begin(), lhs.nodes.end(),
                                        rhs.nodes.begin(), rhs.nodes.end());
  });
  return candidates;
}

static ExactCoverResult
solveExactCover(uint64_t mask, uint64_t fullMask,
                ArrayRef<TransactionCandidate> candidates,
                ArrayRef<SmallVector<unsigned>> candidatesByNode,
                llvm::DenseMap<uint64_t, ExactCoverResult> &memo) {
  if (mask == fullMask) {
    ExactCoverResult result;
    result.score = CoverState{0, 0, 0, 0};
    result.valid = true;
    return result;
  }
  auto found = memo.find(mask);
  if (found != memo.end())
    return found->second;

  unsigned first = 0;
  while (mask & (uint64_t{1} << first))
    ++first;
  ExactCoverResult best;
  for (unsigned candidateIndex : candidatesByNode[first]) {
    const TransactionCandidate &candidate = candidates[candidateIndex];
    if (mask & candidate.mask)
      continue;
    ExactCoverResult tail = solveExactCover(mask | candidate.mask, fullMask,
                                            candidates, candidatesByNode, memo);
    if (!tail.valid)
      continue;
    int64_t length = candidate.nodes.size();
    CoverState score{tail.score.singletons + (length == 1),
                     tail.score.transactions + 1,
                     tail.score.widthScore + length * length, length};
    if (best.valid && !betterCover(score, best.score))
      continue;
    best = std::move(tail);
    best.score = score;
    best.candidates.insert(best.candidates.begin(), candidateIndex);
    best.valid = true;
  }
  memo.try_emplace(mask, best);
  return best;
}

static FailureOr<SmallVector<SmallVector<unsigned>>>
findExactCover(ArrayRef<SmallVector<unsigned>> edges, int64_t elementBits) {
  unsigned count = edges.size();
  if (count > kMaxExactCoverNodes)
    return failure();
  FailureOr<SmallVector<TransactionCandidate>> candidates =
      enumerateTransactionCandidates(edges, elementBits);
  if (failed(candidates))
    return failure();

  SmallVector<SmallVector<unsigned>> candidatesByNode(count);
  for (auto [candidateIndex, candidate] : llvm::enumerate(*candidates))
    for (unsigned node : candidate.nodes)
      candidatesByNode[node].push_back(candidateIndex);

  uint64_t fullMask = (uint64_t{1} << count) - 1;
  llvm::DenseMap<uint64_t, ExactCoverResult> memo;
  ExactCoverResult cover =
      solveExactCover(0, fullMask, *candidates, candidatesByNode, memo);
  if (!cover.valid)
    return failure();
  SmallVector<SmallVector<unsigned>> transactions;
  transactions.reserve(cover.candidates.size());
  for (unsigned candidateIndex : cover.candidates)
    transactions.push_back((*candidates)[candidateIndex].nodes);
  return transactions;
}

static FailureOr<SmallVector<SmallVector<unsigned>>>
planTransactions(sym::Store &store, ArrayRef<SlotMapping> slots,
                 int64_t elementBits) {
  SmallVector<SmallVector<unsigned>> edges =
      buildSuccessorGraph(store, slots, elementBits);
  if (FailureOr<SmallVector<SmallVector<unsigned>>> exact =
          findExactCover(edges, elementBits);
      succeeded(exact))
    return exact;

  SmallVector<SmallVector<unsigned>> transactions;
  for (ArrayRef<unsigned> chain : buildContiguousChains(edges)) {
    SmallVector<SmallVector<unsigned>> cover = coverChain(chain, elementBits);
    if (cover.empty())
      return failure();
    llvm::append_range(transactions, std::move(cover));
  }
  return transactions;
}

static FailureOr<Value> materializeExpr(IRRewriter &rewriter,
                                        const MemoryAccess &access,
                                        const SlotMapping &slot,
                                        sym::ExprHandle expr) {
  if (std::optional<int64_t> literal = sym::getIntegerLiteralValue(expr)) {
    ConstantOp constant = ConstantOp::create(rewriter, access.op->getLoc(),
                                             rewriter.getIndexType(),
                                             rewriter.getIndexAttr(*literal));
    return constant.getResult();
  }

  llvm::DenseSet<StringRef> freeSymbols;
  sym::walkSymbolNames(expr, [&](StringRef name) { freeSymbols.insert(name); });
  SmallVector<StringRef> names;
  SmallVector<Value> values;
  for (const NamedBinding &binding : slot.bindings) {
    if (!freeSymbols.contains(binding.name))
      continue;
    names.push_back(binding.name);
    values.push_back(binding.value);
    freeSymbols.erase(binding.name);
  }
  if (!freeSymbols.empty())
    return failure();

  llvm::DenseSet<StringRef> liveSymbols;
  for (StringRef name : names)
    liveSymbols.insert(name);
  SmallVector<sym::PredHandle> assumptions =
      filterIndexExprPredicatesBySymbols(slot.assumptions, liveSymbols);
  Type resultType = getIndexExprResultType(access.op->getContext(), values);
  IndexExprOp index = IndexExprOp::create(
      rewriter, access.op->getLoc(), resultType,
      ExprAttr::get(access.op->getContext(), expr),
      getIndexExprPredArrayAttr(access.op->getContext(), assumptions),
      rewriter.getStrArrayAttr(names), values);
  return index.getResult();
}

static Value getByteBase(IRRewriter &rewriter, const MemoryAccess &access,
                         unsigned index, SmallVectorImpl<Value> &byteBases) {
  Value &byteBase = byteBases[index];
  PtrType sourceType = cast<PtrType>(access.bases[index].getType());
  PtrType byteType = PtrType::get(access.op->getContext(), rewriter.getI8Type(),
                                  sourceType.getAddressSpace());
  if (byteBase)
    return byteBase;
  Value source = access.bases[index];
  byteBase = source.getType() == byteType
                 ? source
                 : Value(PtrCastOp::create(rewriter, access.op->getLoc(),
                                           byteType, source));
  return byteBase;
}

static FailureOr<Value> materializePointer(IRRewriter &rewriter,
                                           const MemoryAccess &access,
                                           const SlotMapping &slot,
                                           SmallVectorImpl<Value> &byteBases) {
  Value byteBase = getByteBase(rewriter, access, slot.baseIndex, byteBases);

  if (std::optional<int64_t> literal =
          sym::getIntegerLiteralValue(slot.byteOffset))
    if (*literal == 0)
      return byteBase;

  FailureOr<Value> offset =
      materializeExpr(rewriter, access, slot, slot.byteOffset);
  if (failed(offset))
    return failure();
  Type resultType = byteBase.getType();
  if (SimdType simd = dyn_cast<SimdType>((*offset).getType()))
    if (!isa<SimdType>(resultType)) {
      Type byteType = cast<PtrType>(resultType);
      resultType =
          SimdType::get(access.op->getContext(), byteType, simd.getWidth());
    }
  PtrAddOp ptr = PtrAddOp::create(rewriter, access.op->getLoc(), resultType,
                                  byteBase, *offset);
  return ptr.getResult();
}

static Type getComponentType(const MemoryAccess &access) {
  VectorType packet = cast<VectorType>(access.packetType.getElementType());
  return SimdType::get(access.op->getContext(), packet.getElementType(),
                       access.packetType.getWidth());
}

static Type getTransactionType(const MemoryAccess &access, int64_t length) {
  VectorType packet = cast<VectorType>(access.packetType.getElementType());
  Type elementType = packet.getElementType();
  if (length > 1)
    elementType = VectorType::get({length}, elementType);
  return SimdType::get(access.op->getContext(), elementType,
                       access.packetType.getWidth());
}

static Value joinTokens(IRRewriter &rewriter, const MemoryAccess &access,
                        ValueRange tokens) {
  if (tokens.size() == 1)
    return tokens.front();
  return JoinOp::create(rewriter, access.op->getLoc(), access.tokenType,
                        tokens);
}

static LogicalResult lowerGather(IRRewriter &rewriter,
                                 const MemoryAccess &access,
                                 ArrayRef<SlotMapping> slots,
                                 ArrayRef<SmallVector<unsigned>> transactions) {
  VectorType packet = cast<VectorType>(access.packetType.getElementType());
  SmallVector<Value> components(packet.getNumElements());
  SmallVector<Value> tokens;
  SmallVector<Value> byteBases(access.bases.size());
  Type componentType = getComponentType(access);

  for (ArrayRef<unsigned> transaction : transactions) {
    const SlotMapping &first = slots[transaction.front()];
    FailureOr<Value> ptr =
        materializePointer(rewriter, access, first, byteBases);
    if (failed(ptr))
      return access.op->emitOpError("failed to materialize mapped address");
    Type valueType = getTransactionType(access, transaction.size());
    LoadOp load =
        LoadOp::create(rewriter, access.op->getLoc(), valueType,
                       access.tokenType, *ptr, access.dependency, access.cache);
    tokens.push_back(load.getToken());
    for (auto [physicalIndex, nodeIndex] : llvm::enumerate(transaction)) {
      Value value = load.getValue();
      if (transaction.size() > 1)
        value = ExtractOp::create(rewriter, access.op->getLoc(), componentType,
                                  value, physicalIndex);
      for (unsigned logicalSlot : slots[nodeIndex].logicalSlots)
        components[logicalSlot] = value;
    }
  }

  if (llvm::any_of(components, [](Value value) { return !value; }))
    return access.op->emitOpError("failed to cover every gathered packet slot");
  Value result = PackOp::create(rewriter, access.op->getLoc(),
                                access.packetType, components);
  Value token = joinTokens(rewriter, access, tokens);
  rewriter.replaceOp(access.op, {result, token});
  return success();
}

static LogicalResult
lowerScatter(IRRewriter &rewriter, const MemoryAccess &access,
             ArrayRef<SlotMapping> slots,
             ArrayRef<SmallVector<unsigned>> transactions) {
  VectorType packet = cast<VectorType>(access.packetType.getElementType());
  Type componentType = getComponentType(access);
  SmallVector<Value> components;
  components.reserve(packet.getNumElements());
  for (int64_t index : llvm::seq<int64_t>(0, packet.getNumElements()))
    components.push_back(ExtractOp::create(
        rewriter, access.op->getLoc(), componentType, access.packet, index));

  SmallVector<Value> tokens;
  SmallVector<Value> byteBases(access.bases.size());
  for (ArrayRef<unsigned> transaction : transactions) {
    const SlotMapping &first = slots[transaction.front()];
    FailureOr<Value> ptr =
        materializePointer(rewriter, access, first, byteBases);
    if (failed(ptr))
      return access.op->emitOpError("failed to materialize mapped address");
    SmallVector<Value> values;
    values.reserve(transaction.size());
    for (unsigned nodeIndex : transaction)
      values.push_back(components[slots[nodeIndex].logicalSlots.front()]);
    Value value = values.front();
    if (values.size() > 1)
      value = PackOp::create(rewriter, access.op->getLoc(),
                             getTransactionType(access, values.size()), values);
    StoreOp store =
        StoreOp::create(rewriter, access.op->getLoc(), access.tokenType, value,
                        *ptr, access.dependency, access.cache);
    tokens.push_back(store.getToken());
  }

  Value token = joinTokens(rewriter, access, tokens);
  rewriter.replaceOp(access.op, token);
  return success();
}

static FailureOr<AccessShape> getAccessShape(const MemoryAccess &access) {
  VectorType packet = cast<VectorType>(access.packetType.getElementType());
  int64_t slotCount = packet.getNumElements();
  if (slotCount <= 0) {
    access.op->emitOpError("requires at least one packet slot");
    return failure();
  }
  Type elementType = packet.getElementType();
  if (!elementType.isIntOrFloat()) {
    access.op->emitOpError(
        "lowering requires an integer or float packet element type");
    return failure();
  }
  int64_t elementBits = elementType.getIntOrFloatBitWidth();
  if (elementBits != 8 && elementBits != 16 && elementBits != 32) {
    access.op->emitOpError(
        "lowering requires 8-, 16-, or 32-bit packet elements");
    return failure();
  }
  Attribute addressSpace =
      cast<PtrType>(access.bases.front().getType()).getAddressSpace();
  if (!isa<GlobalAddressSpaceAttr, SharedAddressSpaceAttr>(addressSpace)) {
    access.op->emitOpError("lowering requires global or shared pointer bases");
    return failure();
  }
  return AccessShape{packet, slotCount, elementBits};
}

static FailureOr<MappingDomain> getMappingDomain(sym::Store &store) {
  FailureOr<sym::ExprHandle> block = sym::composeExprSym(store, "block");
  if (failed(block))
    return failure();
  FailureOr<sym::ExprHandle> slot = sym::composeExprSym(store, "slot");
  if (failed(slot))
    return failure();
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  if (failed(zero))
    return failure();
  return MappingDomain{*block, *slot, *zero};
}

static FailureOr<Value> getMappedItem(IRRewriter &rewriter,
                                      const MemoryAccess &access) {
  if (!mappingHasSymbol(access.mapping, "item"))
    return Value{};
  return materializeItem(rewriter, access);
}

static SmallVector<Value> getPacketComponentValues(IRRewriter &rewriter,
                                                   const MemoryAccess &access,
                                                   Value binding,
                                                   int64_t slotCount) {
  SimdType bindingType = cast<SimdType>(binding.getType());
  VectorType vectorType = cast<VectorType>(bindingType.getElementType());
  Type componentType =
      SimdType::get(access.op->getContext(), vectorType.getElementType(),
                    bindingType.getWidth());
  SmallVector<Value> values;
  if (PackOp pack = binding.getDefiningOp<PackOp>();
      pack && pack.getInputs().size() == static_cast<size_t>(slotCount) &&
      llvm::all_of(pack.getInputs(), [&](Value value) {
        return value.getType() == componentType;
      })) {
    llvm::append_range(values, pack.getInputs());
    return values;
  }
  for (int64_t index : llvm::seq<int64_t>(0, slotCount))
    values.push_back(ExtractOp::create(rewriter, access.op->getLoc(),
                                       componentType, binding, index));
  return values;
}

static FailureOr<SmallVector<SymbolicOffset>>
buildPacketComponentOffsets(const MemoryAccess &access, ValueRange values,
                            WaveDialect &dialect, DataFlowSolver &solver) {
  SmallVector<SymbolicOffset> components;
  components.reserve(values.size());
  for (Value value : values) {
    FailureOr<std::optional<SymbolicOffset>> symbolic =
        buildSymbolicIndexValue(value, dialect, solver);
    if (failed(symbolic) || !*symbolic) {
      access.op->emitOpError("failed to specialize packet binding producer");
      return failure();
    }
    components.push_back(std::move(**symbolic));
  }
  return components;
}

static FailureOr<SmallVector<SmallVector<SymbolicOffset>>>
buildPacketComponents(IRRewriter &rewriter, const MemoryAccess &access,
                      int64_t slotCount, WaveDialect &dialect,
                      DataFlowSolver &solver) {
  SmallVector<SmallVector<SymbolicOffset>> packetComponents;
  packetComponents.reserve(access.packetBindings.size());
  for (Value binding : access.packetBindings) {
    SmallVector<Value> values =
        getPacketComponentValues(rewriter, access, binding, slotCount);
    FailureOr<SmallVector<SymbolicOffset>> components =
        buildPacketComponentOffsets(access, values, dialect, solver);
    if (failed(components))
      return failure();
    packetComponents.push_back(std::move(*components));
  }
  return packetComponents;
}

static FailureOr<SmallVector<SlotMapping>> buildAccessSlotMappings(
    const MemoryAccess &access, sym::Store &store, const MappingDomain &domain,
    int64_t slotCount, Value item,
    ArrayRef<SmallVector<SymbolicOffset>> packetComponents) {
  PacketBindingState bindingState;
  seedPacketBindingState(access, item, bindingState);
  SmallVector<SlotMapping> mappings;
  mappings.reserve(slotCount);
  for (int64_t index : llvm::seq<int64_t>(0, slotCount)) {
    FailureOr<SlotMapping> mapping =
        buildSlotMapping(access, store, domain.block, domain.slot, domain.zero,
                         index, item, packetComponents, bindingState);
    if (failed(mapping)) {
      access.op->emitOpError(
          "mapping is not a defined, byte-addressable local memory point");
      return failure();
    }
    mappings.push_back(std::move(*mapping));
  }
  if (access.gather)
    mappings = deduplicateGatherSlots(store, std::move(mappings));
  return mappings;
}

static LogicalResult lowerAccess(IRRewriter &rewriter,
                                 const MemoryAccess &access,
                                 WaveDialect &dialect, DataFlowSolver &solver) {
  FailureOr<AccessShape> shape = getAccessShape(access);
  if (failed(shape))
    return failure();
  sym::Store &store = dialect.getSymbolStore();
  FailureOr<MappingDomain> domain = getMappingDomain(store);
  if (failed(domain))
    return access.op->emitOpError("failed to construct mapping domain");
  FailureOr<Value> item = getMappedItem(rewriter, access);
  if (failed(item))
    return failure();
  FailureOr<SmallVector<SmallVector<SymbolicOffset>>> packetComponents =
      buildPacketComponents(rewriter, access, shape->slotCount, dialect,
                            solver);
  if (failed(packetComponents))
    return failure();
  FailureOr<SmallVector<SlotMapping>> mappings = buildAccessSlotMappings(
      access, store, *domain, shape->slotCount, *item, *packetComponents);
  if (failed(mappings))
    return failure();
  FailureOr<SmallVector<SmallVector<unsigned>>> transactions =
      planTransactions(store, *mappings, shape->elementBits);
  if (failed(transactions))
    return access.op->emitOpError(
        "packet cannot be covered by legal memory transactions");
  if (access.gather)
    return lowerGather(rewriter, access, *mappings, *transactions);
  return lowerScatter(rewriter, access, *mappings, *transactions);
}

static LogicalResult lowerFunc(func::FuncOp func, WaveDialect &dialect,
                               IRRewriter &rewriter, DataFlowSolver &solver) {
  SmallVector<Operation *> accesses;
  func.walk([&](Operation *op) {
    if (isa<GatherOp, ScatterOp>(op))
      accesses.push_back(op);
  });
  for (Operation *op : accesses) {
    rewriter.setInsertionPoint(op);
    MemoryAccess access = isa<GatherOp>(op) ? getAccess(cast<GatherOp>(op))
                                            : getAccess(cast<ScatterOp>(op));
    if (failed(lowerAccess(rewriter, access, dialect, solver)))
      return failure();
  }
  return success();
}

struct WaveLowerSymbolicMemoryPass
    : public wave::impl::WaveLowerSymbolicMemoryBase<
          WaveLowerSymbolicMemoryPass> {
  void runOnOperation() override {
    WaveDialect *dialect = getContext().getLoadedDialect<WaveDialect>();
    if (!dialect) {
      getOperation()->emitError("Wave dialect is not loaded");
      return signalPassFailure();
    }
    bool hasAccess = false;
    getOperation()->walk(
        [&](Operation *op) { hasAccess |= isa<GatherOp, ScatterOp>(op); });
    if (!hasAccess)
      return;

    DataFlowSolver solver;
    dataflow::loadBaselineAnalyses(solver);
    solver.load<dataflow::IntegerRangeAnalysis>();
    if (failed(solver.initializeAndRun(getOperation()))) {
      getOperation()->emitError(
          "IntegerRangeAnalysis failed for symbolic memory lowering");
      return signalPassFailure();
    }

    IRRewriter rewriter(&getContext());
    SmallVector<func::FuncOp> funcs;
    if (func::FuncOp func = dyn_cast<func::FuncOp>(getOperation()))
      funcs.push_back(func);
    else
      getOperation()->walk([&](func::FuncOp func) { funcs.push_back(func); });
    for (func::FuncOp func : funcs)
      if (failed(lowerFunc(func, *dialect, rewriter, solver)))
        return signalPassFailure();
  }
};

} // namespace
