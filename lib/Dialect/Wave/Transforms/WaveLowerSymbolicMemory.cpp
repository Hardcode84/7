//===- WaveLowerSymbolicMemory.cpp - lower symbolic memory -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/Wave/Transforms/SymbolicValue.h"

#include "WaveMemoryTransactionProvider.h"

#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/MathExtras.h"

#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <functional>
#include <limits>
#include <memory>
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

struct MaterializationCandidate {
  Value value;
  sym::ExprHandle expression;
};

struct SlotMapping {
  SmallVector<NamedBinding> bindings;
  SmallVector<sym::PredHandle> assumptions;
  SmallVector<MaterializationCandidate> materializationCandidates;
  SmallVector<unsigned> logicalSlots;
  std::optional<sym::PredHandle> activationPredicate;
  sym::PredHandle activationRelationPredicate;
  Value packetCondition;
  sym::ExprHandle base;
  sym::ExprHandle targetBlock;
  sym::ExprHandle bitOffset;
  sym::ExprHandle materializationBitOffset;
  sym::ExprHandle byteOffset;
  int64_t baseIndex = 0;
};

struct PacketBindingState {
  llvm::DenseMap<Value, Value> canonicalValues;
  llvm::DenseMap<Value, StringRef> byValue;
  llvm::StringMap<Value> reserved;
};

struct PacketBinding {
  std::string name;
  SmallVector<Value> values;
};

struct MappingCoordinates {
  sym::ExprHandle base;
  sym::ExprHandle targetBlock;
  sym::ExprHandle bitOffset;
};

struct MemoryAccess {
  SmallVector<Value> bases;
  SmallVector<Value> bindings;
  SmallVector<PacketBinding> packetBindings;
  SmallVector<std::string> bindingNames;
  SmallVector<Value> packetConditions;
  SmallVector<Value> inactiveComponents;
  MemoryMappingAttr mapping;
  SimdType packetType;
  Value packet;
  Value dependency;
  Attribute cache;
  Type tokenType;
  Operation *op = nullptr;
  WhereOp packetWhere;
  Value inactiveToken;
  bool gather = false;
};

struct ActiveControl {
  SymbolicPredicate predicate;
  bool negated = false;
};

struct ControlCondition {
  Value value;
  bool negated = false;
};

struct PacketControl {
  std::optional<SymbolicPredicate> predicate;
  std::unique_ptr<SymbolicPredicate> relationPredicate;
  Value value;
};

struct PacketComponents {
  SmallVector<Value> values;
  SmallVector<SymbolicOffset> offsets;
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

struct GatherCandidate {
  SmallVector<unsigned> physicalNodes;
  SmallVector<unsigned> logicalSlots;
  std::unique_ptr<wave::memory_lowering::GatherTransactionCandidate> provider;
  uint64_t mask = 0;
  int64_t width = 0;
  bool singleton = false;
};

struct GatherPlan {
  SmallVector<SlotMapping, 4> physicalSlots;
  SmallVector<GatherCandidate> candidates;
  SmallVector<unsigned> selected;
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

struct PreparedAccessMappings {
  SmallVector<SlotMapping, 4> mappings;
  AccessShape shape;
};

struct MappingDomain {
  sym::ExprHandle block;
  sym::ExprHandle slot;
  sym::ExprHandle zero;
};

struct MappedItem {
  SmallVector<Value> aliases;
  Value value;
  sym::PredHandle range;
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

static void appendPacketBindings(ValueRange values, ArrayAttr names,
                                 MemoryAccess &access) {
  for (auto [value, nameAttr] : llvm::zip(values, names)) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    auto existing =
        llvm::find_if(access.packetBindings, [&](const PacketBinding &binding) {
          return binding.name == name;
        });
    if (existing == access.packetBindings.end()) {
      access.packetBindings.push_back(PacketBinding{name.str(), {value}});
      continue;
    }
    existing->values.push_back(value);
  }
}

static MemoryAccess getAccess(GatherOp op) {
  MemoryAccess access;
  access.op = op;
  llvm::append_range(access.bases, op.getBases());
  llvm::append_range(access.bindings, op.getBindings());
  appendPacketBindings(op.getPacketBindings(), op.getPacketBindingNames(),
                       access);
  access.bindingNames = getNames(op.getBindingNames());
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
  appendPacketBindings(op.getPacketBindings(), op.getPacketBindingNames(),
                       access);
  access.bindingNames = getNames(op.getBindingNames());
  access.mapping = op.getMapping();
  access.packetType = cast<SimdType>(op.getValue().getType());
  access.packet = op.getValue();
  access.dependency = op.getDependency();
  access.cache = op.getCacheAttr();
  access.tokenType = op.getToken().getType();
  return access;
}

static Type getComponentType(const MemoryAccess &access);

static SmallVector<Value> getDataPacketComponents(IRRewriter &rewriter,
                                                  const MemoryAccess &access,
                                                  Value packet,
                                                  int64_t slotCount) {
  Type componentType = getComponentType(access);
  if (PackOp pack = packet.getDefiningOp<PackOp>();
      pack && pack.getInputs().size() == static_cast<size_t>(slotCount) &&
      llvm::all_of(pack.getInputs(), [&](Value value) {
        return value.getType() == componentType;
      }))
    return SmallVector<Value>(pack.getInputs().begin(), pack.getInputs().end());

  SmallVector<Value> components;
  components.reserve(slotCount);
  for (int64_t index : llvm::seq<int64_t>(0, slotCount))
    components.push_back(ExtractOp::create(rewriter, access.op->getLoc(),
                                           componentType, packet, index));
  return components;
}

static bool hasIsolatedPacketAccess(WhereOp where, Operation *access,
                                    YieldOp thenYield) {
  return thenYield && &where.getThenRegion().front().front() == access &&
         access->getNextNode() == thenYield;
}

static bool hasValidGatherThenYield(WhereOp where, const MemoryAccess &access,
                                    YieldOp thenYield) {
  return where.getNumResults() == 2 && thenYield.getNumOperands() == 2 &&
         thenYield.getOperand(0) == access.op->getResult(0) &&
         thenYield.getOperand(1) == access.op->getResult(1) &&
         !where.getElseRegion().empty();
}

static bool hasIsolatedGatherElseYield(WhereOp where, YieldOp elseYield) {
  return elseYield && elseYield.getNumOperands() == 2 &&
         &where.getElseRegion().front().front() == elseYield.getOperation();
}

static LogicalResult prepareGatherPacketPredication(IRRewriter &rewriter,
                                                    MemoryAccess &access,
                                                    WhereOp where,
                                                    YieldOp thenYield,
                                                    int64_t slotCount) {
  if (!hasValidGatherThenYield(where, access, thenYield))
    return where.emitOpError(
        "packet-predicated gather must yield its value and token and have "
        "an inactive region");
  YieldOp elseYield =
      dyn_cast<YieldOp>(where.getElseRegion().front().getTerminator());
  if (!hasIsolatedGatherElseYield(where, elseYield))
    return where.emitOpError(
        "packet-predicated gather inactive region must only yield fallback "
        "value and token");
  access.inactiveComponents = getDataPacketComponents(
      rewriter, access, elseYield.getOperand(0), slotCount);
  access.inactiveToken = elseYield.getOperand(1);
  return success();
}

static bool hasValidScatterThenYield(WhereOp where, const MemoryAccess &access,
                                     YieldOp thenYield) {
  if (where.getNumResults() > 1)
    return false;
  if (thenYield.getNumOperands() != where.getNumResults())
    return false;
  return where.getNumResults() == 0 ||
         thenYield.getOperand(0) == access.op->getResult(0);
}

static LogicalResult prepareResultScatterPredication(MemoryAccess &access,
                                                     WhereOp where) {
  if (where.getElseRegion().empty())
    return where.emitOpError(
        "result-bearing packet-predicated scatter requires an inactive "
        "region");
  YieldOp elseYield =
      dyn_cast<YieldOp>(where.getElseRegion().front().getTerminator());
  if (!elseYield || elseYield.getNumOperands() != 1 ||
      &where.getElseRegion().front().front() != elseYield.getOperation())
    return where.emitOpError(
        "packet-predicated scatter inactive region must only yield a token");
  access.inactiveToken = elseYield.getOperand(0);
  return success();
}

static LogicalResult prepareEffectScatterPredication(IRRewriter &rewriter,
                                                     MemoryAccess &access,
                                                     WhereOp where) {
  if (!where.getElseRegion().empty())
    return where.emitOpError(
        "effect-only packet-predicated scatter must not have an inactive "
        "region");
  access.inactiveToken = access.dependency;
  if (!access.inactiveToken)
    access.inactiveToken =
        TokenOp::create(rewriter, where.getLoc(), access.tokenType).getResult();
  return success();
}

static LogicalResult prepareScatterPacketPredication(IRRewriter &rewriter,
                                                     MemoryAccess &access,
                                                     WhereOp where,
                                                     YieldOp thenYield) {
  if (!hasValidScatterThenYield(where, access, thenYield))
    return where.emitOpError(
        "packet-predicated scatter must yield only its optional token");
  if (where.getNumResults() == 1)
    return prepareResultScatterPredication(access, where);
  return prepareEffectScatterPredication(rewriter, access, where);
}

static LogicalResult preparePacketPredication(IRRewriter &rewriter,
                                              MemoryAccess &access,
                                              int64_t slotCount) {
  WhereOp where = dyn_cast_or_null<WhereOp>(access.op->getParentOp());
  if (!where)
    return success();
  if (where.getConditions().size() == 1)
    return success();
  if (where.getConditions().size() != static_cast<size_t>(slotCount))
    return where.emitOpError(
        "mask packet length must match symbolic memory packet length");
  if (access.op->getBlock() != &where.getThenRegion().front())
    return access.op->emitOpError(
        "packet-predicated symbolic memory access must be in the then region");

  YieldOp thenYield =
      dyn_cast<YieldOp>(where.getThenRegion().front().getTerminator());
  if (!hasIsolatedPacketAccess(where, access.op, thenYield))
    return where.emitOpError(
        "packet-predicated symbolic memory then region must contain only the "
        "memory access");

  rewriter.setInsertionPoint(where);
  access.packetWhere = where;
  llvm::append_range(access.packetConditions, where.getConditions());

  if (access.gather)
    return prepareGatherPacketPredication(rewriter, access, where, thenYield,
                                          slotCount);
  return prepareScatterPacketPredication(rewriter, access, where, thenYield);
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

static bool isPacketIndexProducer(Operation *op) {
  return isa<AssumeOp, BinaryOp, CastOp, ExtractOp, IndexExprOp, PackOp,
             SelectOp, SplatOp>(op);
}

static std::array<SmallVector<Value>, 3>
collectPacketWorkitemIds(const MemoryAccess &access, Type type) {
  std::array<SmallVector<Value>, 3> workitems;
  SmallVector<Value> worklist;
  for (const PacketBinding &binding : access.packetBindings)
    llvm::append_range(worklist, binding.values);
  DenseSet<Value> visited;
  while (!worklist.empty()) {
    Value value = worklist.pop_back_val();
    if (!visited.insert(value).second)
      continue;
    if (WorkitemIdOp workitem = value.getDefiningOp<WorkitemIdOp>()) {
      if (value.getType() == type)
        workitems[workitem.getAxis()].push_back(value);
      continue;
    }
    Operation *producer = value.getDefiningOp();
    if (!producer || !isPacketIndexProducer(producer))
      continue;
    llvm::append_range(worklist, producer->getOperands());
  }
  return workitems;
}

static Value getOrCreatePacketWorkitemId(IRRewriter &rewriter, Location loc,
                                         Type type, unsigned axis,
                                         ArrayRef<Value> workitems) {
  if (!workitems.empty())
    return workitems.front();
  return WorkitemIdOp::create(rewriter, loc, type, axis);
}

static FailureOr<MappedItem> materializeItem(IRRewriter &rewriter,
                                             const MemoryAccess &access,
                                             sym::Store &store) {
  DenseI32ArrayAttr shape = getWorkgroupShape(access.op);
  if (!shape)
    return access.op->emitOpError("requires a known workgroup shape");
  ArrayRef<int32_t> dims = shape.asArrayRef();
  if (dims.size() != 3 ||
      llvm::any_of(dims, [](int32_t dim) { return dim <= 0; }))
    return access.op->emitOpError(
        "requires three positive workgroup dimensions");
  int64_t xy = int64_t{dims[0]} * dims[1];
  if (xy > std::numeric_limits<int32_t>::max() / int64_t{dims[2]})
    return access.op->emitOpError("row-major workitem index exceeds i32");
  int64_t itemCount = xy * dims[2];
  Type type = SimdType::get(access.op->getContext(), rewriter.getI32Type(),
                            access.packetType.getWidth());
  Location loc = access.op->getLoc();
  std::array<SmallVector<Value>, 3> workitems =
      collectPacketWorkitemIds(access, type);
  Value item =
      getOrCreatePacketWorkitemId(rewriter, loc, type, 0, workitems[0]);
  if (dims[1] > 1) {
    Value y = getOrCreatePacketWorkitemId(rewriter, loc, type, 1, workitems[1]);
    Value scale = ConstantOp::create(rewriter, loc, type,
                                     rewriter.getI32IntegerAttr(dims[0]));
    Value scaled =
        BinaryOp::create(rewriter, loc, type, BinaryKind::MulI, y, scale);
    item =
        BinaryOp::create(rewriter, loc, type, BinaryKind::AddI, item, scaled);
  }
  if (dims[2] > 1) {
    Value z = getOrCreatePacketWorkitemId(rewriter, loc, type, 2, workitems[2]);
    Value scale = ConstantOp::create(
        rewriter, loc, type,
        rewriter.getI32IntegerAttr(static_cast<int32_t>(xy)));
    Value scaled =
        BinaryOp::create(rewriter, loc, type, BinaryKind::MulI, z, scale);
    item =
        BinaryOp::create(rewriter, loc, type, BinaryKind::AddI, item, scaled);
  }
  FailureOr<sym::PredHandle> range =
      sym::rangeAssumption(store, "item", 0, itemCount - 1);
  if (failed(range))
    return access.op->emitOpError("failed to construct workitem range");
  SmallVector<Value> aliases;
  if (dims[1] == 1 && dims[2] == 1)
    aliases = std::move(workitems[0]);
  return MappedItem{std::move(aliases), item, *range};
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
multiplyExpandedFactors(sym::Store &store, sym::ExprHandle initial,
                        sym::ExprView view) {
  FailureOr<sym::ExprHandle> result = initial;
  for (unsigned index : llvm::seq(view.getMulFactorCount())) {
    sym::MulFactor factor = view.getMulFactor(index);
    if (factor.exponent < 0)
      return failure();
    for (int32_t unused : llvm::seq(factor.exponent)) {
      (void)unused;
      result = sym::composeExprBinary(store, *result, sym::ExprBinaryOp::Mul,
                                      factor.base);
      if (failed(result))
        return failure();
    }
  }
  return result;
}

static FailureOr<sym::ExprHandle>
divideExpandedMul(sym::Store &store, sym::ExprView view, int64_t divisor) {
  std::optional<int64_t> coefficient =
      sym::getIntegerLiteralValue(view.getMulCoefficient());
  if (!coefficient || *coefficient % divisor != 0)
    return failure();
  FailureOr<sym::ExprHandle> initial =
      sym::composeExprInt(store, *coefficient / divisor);
  if (failed(initial))
    return failure();
  return multiplyExpandedFactors(store, *initial, view);
}

static FailureOr<sym::ExprHandle> appendDividedAddTerm(sym::Store &store,
                                                       sym::ExprHandle result,
                                                       sym::AddTerm term,
                                                       int64_t divisor) {
  std::optional<int64_t> coefficient =
      sym::getIntegerLiteralValue(term.coefficient);
  if (!coefficient || *coefficient % divisor != 0)
    return failure();
  FailureOr<sym::ExprHandle> scaled =
      sym::composeExprInt(store, *coefficient / divisor);
  if (failed(scaled))
    return failure();
  scaled =
      sym::composeExprBinary(store, *scaled, sym::ExprBinaryOp::Mul, term.term);
  if (failed(scaled))
    return failure();
  return sym::composeExprBinary(store, result, sym::ExprBinaryOp::Add, *scaled);
}

static FailureOr<sym::ExprHandle>
divideExpandedAdd(sym::Store &store, sym::ExprView view, int64_t divisor) {
  std::optional<int64_t> constant =
      sym::getIntegerLiteralValue(view.getAddConstant());
  if (!constant || *constant % divisor != 0)
    return failure();
  FailureOr<sym::ExprHandle> result =
      sym::composeExprInt(store, *constant / divisor);
  if (failed(result))
    return failure();

  for (unsigned index : llvm::seq(view.getAddTermCount())) {
    result =
        appendDividedAddTerm(store, *result, view.getAddTerm(index), divisor);
    if (failed(result))
      return failure();
  }
  return result;
}

static FailureOr<sym::ExprHandle>
divideCoefficientsExactly(sym::Store &store, sym::ExprHandle value,
                          int64_t divisor) {
  FailureOr<sym::ExprHandle> expanded = sym::expandExpr(store, value);
  if (failed(expanded))
    return failure();
  sym::ExprView view(*expanded);
  if (view.getKind() == sym::ExprKind::Mul)
    return divideExpandedMul(store, view, divisor);
  if (view.getKind() == sym::ExprKind::Add)
    return divideExpandedAdd(store, view, divisor);
  return failure();
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
  if (denominator && *denominator == 1)
    return *simplified;
  FailureOr<sym::ExprHandle> divided =
      divideCoefficientsExactly(store, value, divisor);
  if (failed(divided))
    return failure();
  return sym::simplifyExpr(store, *divided, assumptions);
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

static void seedPacketBindingState(const MemoryAccess &access,
                                   const MappedItem &item,
                                   PacketBindingState &state) {
  state.reserved.try_emplace("block", Value());
  state.reserved.try_emplace("slot", Value());
  auto [itemIt, itemInserted] = state.reserved.try_emplace("item", item.value);
  (void)itemInserted;
  if (item.value) {
    state.byValue.try_emplace(item.value, itemIt->getKey());
    for (Value alias : item.aliases)
      state.canonicalValues.try_emplace(alias, item.value);
  }

  for (auto [name, value] : llvm::zip(access.bindingNames, access.bindings)) {
    auto [it, inserted] = state.reserved.try_emplace(name, value);
    (void)inserted;
    state.byValue.try_emplace(value, it->getKey());
  }
  for (const PacketBinding &binding : access.packetBindings)
    state.reserved.try_emplace(binding.name, Value());
}

static LogicalResult
remapSymbolicBindings(sym::Store &store,
                      ArrayRef<SymbolicOffsetBinding> bindings,
                      ArrayRef<sym::PredHandle> assumptions,
                      PacketBindingState &state, SlotMapping &mapping,
                      SmallVectorImpl<sym::ExprSubstitution> &substitutions) {
  for (const SymbolicOffsetBinding &binding : bindings) {
    StringRef oldName = getSymbolName(binding);
    Value value = state.canonicalValues.lookup(binding.value);
    if (!value)
      value = binding.value;
    StringRef newName = reserveIndexExprBindingName(
        oldName, value, state.reserved, state.byValue);
    if (failed(appendBinding(mapping, newName, value)))
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
    llvm::append_range(mapping.assumptions, assumptions);
  else {
    FailureOr<SmallVector<sym::PredHandle>> remappedAssumptions =
        substituteIndexExprPredicates(store, assumptions, substitutions);
    if (failed(remappedAssumptions))
      return failure();
    llvm::append_range(mapping.assumptions, *remappedAssumptions);
  }
  return success();
}

static FailureOr<sym::ExprHandle> remapSymbolicOffset(
    sym::Store &store, const SymbolicOffset &offset, PacketBindingState &state,
    SlotMapping &mapping,
    SmallVectorImpl<sym::ExprSubstitution> *resultSubstitutions = nullptr) {
  SmallVector<sym::ExprSubstitution> substitutions;
  if (failed(remapSymbolicBindings(store, offset.bindings, offset.assumptions,
                                   state, mapping, substitutions)))
    return failure();
  if (resultSubstitutions)
    llvm::append_range(*resultSubstitutions, substitutions);
  if (substitutions.empty())
    return offset.expr;
  return sym::substituteExpr(store, offset.expr, substitutions);
}

static FailureOr<sym::PredHandle>
remapSymbolicPredicate(sym::Store &store, const SymbolicPredicate &predicate,
                       PacketBindingState &state, SlotMapping &mapping) {
  SmallVector<sym::ExprSubstitution> substitutions;
  if (failed(remapSymbolicBindings(store, predicate.bindings,
                                   predicate.assumptions, state, mapping,
                                   substitutions)))
    return failure();
  if (substitutions.empty())
    return predicate.predicate;
  return sym::substitutePred(store, predicate.predicate, substitutions);
}

static bool isI32WrappingInvariant(sym::ExprHandle expression) {
  sym::ExprView view(expression);
  if (view.getKind() != sym::ExprKind::Mod)
    return false;
  std::optional<int64_t> modulus =
      sym::getIntegerLiteralValue(view.getBinaryRhs());
  return modulus && *modulus > 1 && *modulus <= (int64_t{1} << 32) &&
         llvm::isPowerOf2_64(static_cast<uint64_t>(*modulus));
}

static bool isI32WrappingInvariant(sym::PredHandle predicate) {
  sym::PredView view(predicate);
  if (view.getKind() != sym::PredKind::Cmp ||
      view.getCmpOp() != sym::PredCmpOp::Eq)
    return false;
  sym::ExprHandle lhs = view.getCmpLhs();
  sym::ExprHandle rhs = view.getCmpRhs();
  return (sym::getIntegerLiteralValue(lhs) == 0 &&
          isI32WrappingInvariant(rhs)) ||
         (sym::getIntegerLiteralValue(rhs) == 0 && isI32WrappingInvariant(lhs));
}

static FailureOr<sym::PredHandle>
remapRelationPredicate(sym::Store &store, const SymbolicPredicate &predicate,
                       PacketBindingState &state, SlotMapping &mapping) {
  SmallVector<sym::PredHandle> invariantAssumptions;
  llvm::copy_if(predicate.assumptions, std::back_inserter(invariantAssumptions),
                [](sym::PredHandle assumption) {
                  return isI32WrappingInvariant(assumption);
                });
  SmallVector<sym::ExprSubstitution> substitutions;
  if (failed(remapSymbolicBindings(store, predicate.bindings,
                                   invariantAssumptions, state, mapping,
                                   substitutions)))
    return failure();
  if (substitutions.empty())
    return predicate.predicate;
  return sym::substitutePred(store, predicate.predicate, substitutions);
}

static LogicalResult appendActiveControls(sym::Store &store,
                                          ArrayRef<ActiveControl> controls,
                                          PacketBindingState &state,
                                          SlotMapping &mapping) {
  for (const ActiveControl &control : controls) {
    FailureOr<sym::PredHandle> predicate =
        remapSymbolicPredicate(store, control.predicate, state, mapping);
    if (failed(predicate))
      return failure();
    if (control.negated)
      predicate = sym::composePredNot(store, *predicate);
    if (failed(predicate))
      return failure();
    mapping.assumptions.push_back(*predicate);
  }
  return success();
}

static LogicalResult appendPacketControl(sym::Store &store,
                                         const PacketControl *control,
                                         PacketBindingState &state,
                                         SlotMapping &mapping) {
  if (!control)
    return success();
  mapping.packetCondition = control->value;
  if (!control->predicate)
    return success();
  FailureOr<sym::PredHandle> predicate =
      remapSymbolicPredicate(store, *control->predicate, state, mapping);
  if (failed(predicate))
    return failure();
  mapping.activationPredicate = *predicate;
  mapping.assumptions.push_back(*predicate);
  if (control->relationPredicate) {
    FailureOr<sym::PredHandle> relation = remapRelationPredicate(
        store, *control->relationPredicate, state, mapping);
    if (failed(relation))
      return failure();
    mapping.activationRelationPredicate = *relation;
  }
  return success();
}

static LogicalResult appendPacketSubstitution(
    sym::Store &store, StringRef name, Value value,
    const SymbolicOffset &offset, PacketBindingState &state,
    SlotMapping &mapping,
    SmallVectorImpl<sym::ExprSubstitution> &substitutions) {
  FailureOr<sym::ExprHandle> original = sym::composeExprSym(store, name);
  SmallVector<sym::ExprSubstitution> offsetSubstitutions;
  FailureOr<sym::ExprHandle> replacement =
      remapSymbolicOffset(store, offset, state, mapping, &offsetSubstitutions);
  if (failed(original) || failed(replacement))
    return failure();
  for (const SymbolicOffsetMaterialization &materialization :
       offset.materializations) {
    FailureOr<sym::ExprHandle> expression = materialization.expr;
    if (!offsetSubstitutions.empty())
      expression =
          sym::substituteExpr(store, materialization.expr, offsetSubstitutions);
    if (failed(expression))
      return failure();
    mapping.materializationCandidates.push_back(
        {materialization.value, *expression});
  }
  mapping.materializationCandidates.push_back({value, *replacement});
  substitutions.push_back({*original, *replacement});
  return success();
}

static std::optional<int64_t> getProvenConstantScalar(DataFlowSolver &solver,
                                                      Value value) {
  Type type = value.getType();
  if (!type.isIndex() && !isa<IntegerType>(type))
    return std::nullopt;
  if (std::optional<int64_t> constant = getConstantIntValue(value))
    return constant;

  const dataflow::IntegerValueRangeLattice *lattice =
      solver.lookupState<dataflow::IntegerValueRangeLattice>(value);
  if (!lattice)
    return std::nullopt;
  IntegerValueRange valueRange = lattice->getValue();
  if (valueRange.isUninitialized())
    return std::nullopt;
  std::optional<APInt> constant = valueRange.getValue().getConstantValue();
  if (!constant || !constant->isSignedIntN(64))
    return std::nullopt;
  return constant->getSExtValue();
}

static FailureOr<SmallVector<sym::ExprSubstitution>>
buildConstantBindingSubstitutions(const MemoryAccess &access, sym::Store &store,
                                  DataFlowSolver &solver) {
  SmallVector<sym::ExprSubstitution> substitutions;
  for (auto [name, value] : llvm::zip(access.bindingNames, access.bindings)) {
    std::optional<int64_t> constant = getProvenConstantScalar(solver, value);
    if (!constant)
      continue;
    FailureOr<sym::ExprHandle> symbol = sym::composeExprSym(store, name);
    FailureOr<sym::ExprHandle> literal = sym::composeExprInt(store, *constant);
    if (failed(symbol) || failed(literal))
      return failure();
    substitutions.push_back({*symbol, *literal});
  }
  return substitutions;
}

static LogicalResult appendAccessBindings(const MemoryAccess &access,
                                          sym::Store &store,
                                          const MappedItem &item,
                                          SlotMapping &mapping) {
  for (auto [name, value] : llvm::zip(access.bindingNames, access.bindings)) {
    if (failed(appendBinding(mapping, name, value)))
      return failure();
    appendAssumePredicates(store, value, name, mapping.assumptions);
  }
  if (!item.value)
    return success();
  assert(item.range && "mapped item requires an execution range");
  if (failed(appendBinding(mapping, "item", item.value)))
    return failure();
  appendAssumePredicates(store, item.value, "item", mapping.assumptions);
  mapping.assumptions.push_back(item.range);
  return success();
}

static FailureOr<SmallVector<sym::ExprSubstitution>>
buildSlotSubstitutions(const MemoryAccess &access, sym::Store &store,
                       sym::ExprHandle slotSymbol, int64_t slot,
                       ArrayRef<sym::ExprSubstitution> bindingSubstitutions,
                       ArrayRef<PacketComponents> packetComponents,
                       PacketBindingState &bindingState, SlotMapping &mapping) {
  FailureOr<sym::ExprHandle> slotValue = sym::composeExprInt(store, slot);
  if (failed(slotValue))
    return failure();
  SmallVector<sym::ExprSubstitution> substitutions(bindingSubstitutions);
  substitutions.push_back({slotSymbol, *slotValue});
  for (auto [bindingIndex, binding] : llvm::enumerate(access.packetBindings))
    if (failed(appendPacketSubstitution(
            store, binding.name, packetComponents[bindingIndex].values[slot],
            packetComponents[bindingIndex].offsets[slot], bindingState, mapping,
            substitutions)))
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

static std::optional<uint64_t>
rangePossibleBits(sym::Store &store, sym::ExprHandle expression,
                  ArrayRef<sym::PredHandle> assumptions) {
  std::optional<int64_t> upper = sym::inferNonNegativeUpperBound(
      store, expression, assumptions, std::numeric_limits<int64_t>::max());
  if (!upper)
    return std::nullopt;
  uint64_t value = static_cast<uint64_t>(*upper);
  if (value == 0)
    return uint64_t{0};
  unsigned bits = llvm::Log2_64(value) + 1;
  return (uint64_t{1} << bits) - 1;
}

static std::optional<uint64_t> scalePossibleBits(uint64_t bits,
                                                 sym::ExprHandle coefficient) {
  std::optional<int64_t> value = sym::getIntegerLiteralValue(coefficient);
  if (!value || *value < 0)
    return std::nullopt;
  if (*value == 0 || bits == 0)
    return uint64_t{0};
  uint64_t scale = static_cast<uint64_t>(*value);
  if (!llvm::isPowerOf2_64(scale))
    return std::nullopt;
  unsigned shift = llvm::Log2_64(scale);
  if (shift >= 63 ||
      bits > (uint64_t(std::numeric_limits<int64_t>::max()) >> shift))
    return std::nullopt;
  return bits << shift;
}

static std::optional<uint64_t>
possibleOneBits(sym::Store &store, sym::ExprHandle expression,
                ArrayRef<sym::PredHandle> assumptions);

static std::optional<uint64_t>
possibleAddOneBits(sym::Store &store, sym::ExprHandle expression,
                   sym::ExprView view, ArrayRef<sym::PredHandle> assumptions) {
  std::optional<int64_t> constant =
      sym::getIntegerLiteralValue(view.getAddConstant());
  if (!constant || *constant < 0)
    return rangePossibleBits(store, expression, assumptions);
  uint64_t bits = static_cast<uint64_t>(*constant);
  for (uint32_t index : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(index);
    std::optional<uint64_t> termBits =
        possibleOneBits(store, term.term, assumptions);
    if (!termBits)
      return rangePossibleBits(store, expression, assumptions);
    termBits = scalePossibleBits(*termBits, term.coefficient);
    if (!termBits || (bits & *termBits) != 0)
      return rangePossibleBits(store, expression, assumptions);
    bits |= *termBits;
  }
  return bits;
}

static std::optional<uint64_t>
possibleMulOneBits(sym::Store &store, sym::ExprHandle expression,
                   sym::ExprView view, ArrayRef<sym::PredHandle> assumptions) {
  if (view.getMulFactorCount() != 1 || view.getMulFactor(0).exponent != 1)
    return rangePossibleBits(store, expression, assumptions);
  std::optional<uint64_t> factorBits =
      possibleOneBits(store, view.getMulFactor(0).base, assumptions);
  if (!factorBits)
    return rangePossibleBits(store, expression, assumptions);
  std::optional<uint64_t> scaled =
      scalePossibleBits(*factorBits, view.getMulCoefficient());
  return scaled ? scaled : rangePossibleBits(store, expression, assumptions);
}

static std::optional<uint64_t>
possibleModOneBits(sym::Store &store, sym::ExprHandle expression,
                   sym::ExprView view, ArrayRef<sym::PredHandle> assumptions) {
  std::optional<int64_t> modulus =
      sym::getIntegerLiteralValue(view.getBinaryRhs());
  if (!modulus || *modulus <= 0)
    return rangePossibleBits(store, expression, assumptions);
  uint64_t upper = static_cast<uint64_t>(*modulus - 1);
  if (upper == 0)
    return uint64_t{0};
  unsigned bits = llvm::Log2_64(upper) + 1;
  return (uint64_t{1} << bits) - 1;
}

static std::optional<uint64_t>
possibleXorOneBits(sym::Store &store, sym::ExprHandle expression,
                   sym::ExprView view, ArrayRef<sym::PredHandle> assumptions) {
  std::optional<uint64_t> lhs =
      possibleOneBits(store, view.getBinaryLhs(), assumptions);
  std::optional<uint64_t> rhs =
      possibleOneBits(store, view.getBinaryRhs(), assumptions);
  if (lhs && rhs)
    return *lhs | *rhs;
  return rangePossibleBits(store, expression, assumptions);
}

static std::optional<uint64_t>
possibleOneBits(sym::Store &store, sym::ExprHandle expression,
                ArrayRef<sym::PredHandle> assumptions) {
  if (std::optional<int64_t> value = sym::getIntegerLiteralValue(expression))
    return *value >= 0 ? std::optional<uint64_t>(*value) : std::nullopt;

  sym::ExprView view(expression);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return possibleAddOneBits(store, expression, view, assumptions);
  case sym::ExprKind::Mul:
    return possibleMulOneBits(store, expression, view, assumptions);
  case sym::ExprKind::Mod:
    return possibleModOneBits(store, expression, view, assumptions);
  case sym::ExprKind::Xor:
    return possibleXorOneBits(store, expression, view, assumptions);
  default:
    return rangePossibleBits(store, expression, assumptions);
  }
}

static void appendAddChildren(sym::ExprView view,
                              SmallVectorImpl<sym::ExprHandle> &children) {
  children.push_back(view.getAddConstant());
  for (uint32_t index : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(index);
    children.push_back(term.coefficient);
    children.push_back(term.term);
  }
}

static void appendMulChildren(sym::ExprView view,
                              SmallVectorImpl<sym::ExprHandle> &children) {
  children.push_back(view.getMulCoefficient());
  for (uint32_t index : llvm::seq<uint32_t>(0, view.getMulFactorCount()))
    children.push_back(view.getMulFactor(index).base);
}

static void
appendPiecewiseChildren(sym::ExprView view,
                        SmallVectorImpl<sym::ExprHandle> &children) {
  for (uint32_t index : llvm::seq<uint32_t>(0, view.getPiecewiseCaseCount()))
    children.push_back(view.getPiecewiseCase(index).value);
}

static SmallVector<sym::ExprHandle> getExpressionChildren(sym::ExprView view) {
  SmallVector<sym::ExprHandle> children;
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    appendAddChildren(view, children);
    break;
  case sym::ExprKind::Mul:
    appendMulChildren(view, children);
    break;
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    children.push_back(view.getUnaryArg());
    break;
  case sym::ExprKind::Mod:
  case sym::ExprKind::Max:
  case sym::ExprKind::Min:
  case sym::ExprKind::Xor:
    children.push_back(view.getBinaryLhs());
    children.push_back(view.getBinaryRhs());
    break;
  case sym::ExprKind::Piecewise:
    appendPiecewiseChildren(view, children);
    break;
  default:
    break;
  }
  return children;
}

static bool canLinearizeXor(std::optional<uint64_t> lhs,
                            std::optional<uint64_t> rhs) {
  return lhs && rhs && ((*lhs & *rhs) == 0);
}

static LogicalResult
rewriteDisjointXor(sym::Store &store, sym::ExprHandle expression,
                   sym::ExprView view, ArrayRef<sym::PredHandle> assumptions,
                   SmallVectorImpl<sym::ExprSubstitution> &rewrites) {
  sym::ExprHandle lhs = view.getBinaryLhs();
  sym::ExprHandle rhs = view.getBinaryRhs();
  if (!rewrites.empty()) {
    FailureOr<sym::ExprHandle> rewrittenLhs =
        sym::substituteExpr(store, lhs, rewrites);
    FailureOr<sym::ExprHandle> rewrittenRhs =
        sym::substituteExpr(store, rhs, rewrites);
    if (failed(rewrittenLhs) || failed(rewrittenRhs))
      return failure();
    lhs = *rewrittenLhs;
    rhs = *rewrittenRhs;
  }
  std::optional<uint64_t> lhsBits = possibleOneBits(store, lhs, assumptions);
  std::optional<uint64_t> rhsBits = possibleOneBits(store, rhs, assumptions);
  sym::ExprBinaryOp op = canLinearizeXor(lhsBits, rhsBits)
                             ? sym::ExprBinaryOp::Add
                             : sym::ExprBinaryOp::Xor;
  FailureOr<sym::ExprHandle> replacement =
      sym::composeExprBinary(store, lhs, op, rhs);
  if (failed(replacement))
    return failure();
  replacement = sym::simplifyExpr(store, *replacement, assumptions);
  if (failed(replacement))
    return failure();
  if (!(*replacement == expression))
    rewrites.push_back({expression, *replacement});
  return success();
}

static LogicalResult
collectDisjointXorRewrites(sym::Store &store, sym::ExprHandle expression,
                           ArrayRef<sym::PredHandle> assumptions,
                           llvm::DenseSet<sym::ExprHandle> &visited,
                           SmallVectorImpl<sym::ExprSubstitution> &rewrites) {
  if (!visited.insert(expression).second)
    return success();

  sym::ExprView view(expression);
  for (sym::ExprHandle child : getExpressionChildren(view))
    if (child && failed(collectDisjointXorRewrites(store, child, assumptions,
                                                   visited, rewrites)))
      return failure();

  if (view.getKind() != sym::ExprKind::Xor)
    return success();
  return rewriteDisjointXor(store, expression, view, assumptions, rewrites);
}

static FailureOr<sym::ExprHandle>
linearizeDisjointXors(sym::Store &store, sym::ExprHandle expression,
                      ArrayRef<sym::PredHandle> assumptions) {
  llvm::DenseSet<sym::ExprHandle> visited;
  SmallVector<sym::ExprSubstitution> rewrites;
  if (failed(collectDisjointXorRewrites(store, expression, assumptions, visited,
                                        rewrites)))
    return failure();
  if (rewrites.empty())
    return expression;
  FailureOr<sym::ExprHandle> rewritten =
      sym::substituteExpr(store, expression, rewrites);
  if (failed(rewritten))
    return failure();
  return sym::simplifyExpr(store, *rewritten, assumptions);
}

static FailureOr<SlotMapping>
buildSlotMapping(const MemoryAccess &access, sym::Store &store,
                 sym::ExprHandle blockSymbol, sym::ExprHandle slotSymbol,
                 sym::ExprHandle zero, int64_t slot, const MappedItem &item,
                 ArrayRef<sym::ExprSubstitution> bindingSubstitutions,
                 ArrayRef<PacketComponents> packetComponents,
                 ArrayRef<ActiveControl> controls,
                 const PacketControl *packetControl,
                 PacketBindingState &bindingState) {
  SlotMapping result;
  result.logicalSlots.push_back(static_cast<unsigned>(slot));
  if (failed(appendAccessBindings(access, store, item, result)))
    return failure();
  if (failed(appendActiveControls(store, controls, bindingState, result)))
    return failure();
  if (failed(appendPacketControl(store, packetControl, bindingState, result)))
    return failure();
  FailureOr<SmallVector<sym::ExprSubstitution>> substitutions =
      buildSlotSubstitutions(access, store, slotSymbol, slot,
                             bindingSubstitutions, packetComponents,
                             bindingState, result);
  if (failed(substitutions))
    return failure();
  MappingCoordinates coordinates =
      getMappingCoordinates(access, blockSymbol, zero);
  ArrayRef<sym::PredHandle> simplificationAssumptions = result.assumptions;
  FailureOr<MappingCoordinates> specialized = specializeCoordinates(
      store, coordinates, *substitutions, simplificationAssumptions);
  if (failed(specialized))
    return failure();
  FailureOr<int64_t> baseIndex = validateLocalCoordinates(
      access, store, *specialized, blockSymbol, result.assumptions);
  if (failed(baseIndex))
    return failure();
  std::array<sym::ExprSubstitution, 1> blockSubstitution{
      sym::ExprSubstitution{blockSymbol, zero}};
  FailureOr<MappingCoordinates> local = specializeCoordinates(
      store, *specialized, blockSubstitution, simplificationAssumptions);
  if (failed(local))
    return failure();
  result.materializationBitOffset = local->bitOffset;
  FailureOr<sym::ExprHandle> bitOffset =
      linearizeDisjointXors(store, local->bitOffset, simplificationAssumptions);
  if (failed(bitOffset))
    return failure();
  local->bitOffset = *bitOffset;
  FailureOr<sym::ExprHandle> byteOffset =
      getByteOffset(store, local->bitOffset, simplificationAssumptions);
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

static SmallVector<sym::PredHandle>
combineNonActivationAssumptions(const SlotMapping &lhs,
                                const SlotMapping &rhs) {
  SmallVector<sym::PredHandle> assumptions = combineAssumptions(lhs, rhs);
  llvm::erase_if(assumptions, [&](sym::PredHandle predicate) {
    return (lhs.activationPredicate && *lhs.activationPredicate == predicate) ||
           (rhs.activationPredicate && *rhs.activationPredicate == predicate);
  });
  return assumptions;
}

static bool predicateImplies(sym::Store &store, sym::PredHandle lhs,
                             sym::PredHandle rhs,
                             ArrayRef<sym::PredHandle> assumptions) {
  SmallVector<sym::PredHandle> withLhs(assumptions);
  withLhs.push_back(lhs);
  return sym::checkPredicate(store, rhs, withLhs) == sym::CheckResult::True;
}

static bool isOrderedComparison(sym::PredCmpOp comparison) {
  switch (comparison) {
  case sym::PredCmpOp::Lt:
  case sym::PredCmpOp::Le:
  case sym::PredCmpOp::Gt:
  case sym::PredCmpOp::Ge:
    return true;
  default:
    return false;
  }
}

static bool isReversedComparison(sym::PredCmpOp comparison) {
  return comparison == sym::PredCmpOp::Gt || comparison == sym::PredCmpOp::Ge;
}

static bool isStrictComparison(sym::PredCmpOp comparison) {
  return comparison == sym::PredCmpOp::Lt || comparison == sym::PredCmpOp::Gt;
}

static FailureOr<sym::ExprHandle>
getStrictComparisonResidual(sym::Store &store, sym::PredHandle predicate) {
  sym::PredView view(predicate);
  std::optional<sym::PredCmpOp> comparison = view.getCmpOp();
  if (!comparison)
    return failure();
  if (!isOrderedComparison(*comparison))
    return failure();

  sym::ExprHandle lhs = view.getCmpLhs();
  sym::ExprHandle rhs = view.getCmpRhs();
  if (isReversedComparison(*comparison))
    std::swap(lhs, rhs);
  FailureOr<sym::ExprHandle> residual =
      sym::composeExprBinary(store, lhs, sym::ExprBinaryOp::Sub, rhs);
  if (failed(residual))
    return failure();
  if (isStrictComparison(*comparison))
    return residual;

  FailureOr<sym::ExprHandle> one = sym::composeExprInt(store, 1);
  if (failed(one))
    return failure();
  return sym::composeExprBinary(store, *residual, sym::ExprBinaryOp::Sub, *one);
}

static std::optional<int64_t>
getConstantDifference(sym::Store &store, sym::ExprHandle lhs,
                      sym::ExprHandle rhs,
                      ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> difference =
      sym::composeExprBinary(store, lhs, sym::ExprBinaryOp::Sub, rhs);
  if (failed(difference))
    return std::nullopt;
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(store, *difference, assumptions);
  if (failed(simplified))
    return std::nullopt;
  if (std::optional<int64_t> value = sym::getIntegerLiteralValue(*simplified))
    return value;
  FailureOr<sym::ExprHandle> expanded = sym::expandExpr(store, *simplified);
  if (failed(expanded))
    return std::nullopt;
  simplified = sym::simplifyExpr(store, *expanded, assumptions);
  if (failed(simplified))
    return std::nullopt;
  return sym::getIntegerLiteralValue(*simplified);
}

static void appendModulus(sym::ExprHandle expression,
                          SmallVectorImpl<int64_t> &moduli) {
  sym::ExprView view(expression);
  if (view.getKind() != sym::ExprKind::Mod)
    return;
  std::optional<int64_t> modulus =
      sym::getIntegerLiteralValue(view.getBinaryRhs());
  if (!modulus || *modulus <= 1)
    return;
  if (!llvm::is_contained(moduli, *modulus))
    moduli.push_back(*modulus);

  // Legal memory transaction widths are powers of two. A divisibility fact
  // also proves every power-of-two factor, which may match a narrower packet.
  for (int64_t factor = 2; *modulus % factor == 0; factor *= 2) {
    if (!llvm::is_contained(moduli, factor))
      moduli.push_back(factor);
    if (factor == *modulus)
      break;
  }
}

static void collectAssumptionModuli(sym::PredHandle predicate,
                                    SmallVectorImpl<int64_t> &moduli) {
  sym::PredView view(predicate);
  if (view.getKind() == sym::PredKind::Cmp) {
    appendModulus(view.getCmpLhs(), moduli);
    appendModulus(view.getCmpRhs(), moduli);
    return;
  }
  if (view.getKind() == sym::PredKind::Not) {
    collectAssumptionModuli(view.getUnaryArg(), moduli);
    return;
  }
  for (uint32_t index : llvm::seq<uint32_t>(0, view.getLogicArgCount()))
    collectAssumptionModuli(view.getLogicArg(index), moduli);
}

static std::optional<int64_t> getAdditiveConstant(sym::ExprHandle expression) {
  sym::ExprView view(expression);
  if (std::optional<int64_t> literal = sym::getIntegerLiteralValue(expression))
    return literal;
  if (view.getKind() == sym::ExprKind::Add)
    return sym::getIntegerLiteralValue(view.getAddConstant());
  return int64_t{0};
}

static FailureOr<sym::ExprHandle>
normalizeComparisonResidual(sym::Store &store, sym::PredHandle predicate,
                            ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> residual =
      getStrictComparisonResidual(store, predicate);
  if (failed(residual))
    return failure();
  return linearizeDisjointXors(store, *residual, assumptions);
}

static bool
provesRemainderBelowBoundary(sym::Store &store, sym::ExprHandle residual,
                             sym::ExprHandle divisor, sym::ExprHandle boundary,
                             ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> remainder =
      sym::composeExprBinary(store, residual, sym::ExprBinaryOp::Mod, divisor);
  if (failed(remainder))
    return false;
  if (!sym::provablyDefined(store, *remainder, assumptions))
    return false;
  FailureOr<sym::PredHandle> staysInBlock =
      sym::composePredCmp(store, *remainder, sym::PredCmpOp::Lt, boundary);
  if (failed(staysInBlock))
    return false;
  return sym::checkPredicate(store, *staysInBlock, assumptions) ==
         sym::CheckResult::True;
}

static std::optional<int64_t> getAlignedResidue(sym::ExprHandle residual,
                                                int64_t modulus,
                                                uint64_t distance) {
  std::optional<int64_t> constant = getAdditiveConstant(residual);
  if (!constant)
    return std::nullopt;
  int64_t residue = *constant % modulus;
  if (residue < 0)
    residue += modulus;
  if (static_cast<uint64_t>(residue) + distance >=
      static_cast<uint64_t>(modulus))
    return std::nullopt;
  return residue;
}

static bool provesAlignedGrid(sym::Store &store, sym::ExprHandle residual,
                              sym::ExprHandle divisor, int64_t modulus,
                              uint64_t distance,
                              ArrayRef<sym::PredHandle> assumptions) {
  std::optional<int64_t> residue =
      getAlignedResidue(residual, modulus, distance);
  if (!residue)
    return false;
  FailureOr<sym::ExprHandle> residueExpr = sym::composeExprInt(store, *residue);
  if (failed(residueExpr))
    return false;
  FailureOr<sym::ExprHandle> gridBase = sym::composeExprBinary(
      store, residual, sym::ExprBinaryOp::Sub, *residueExpr);
  if (failed(gridBase))
    return false;
  FailureOr<sym::ExprHandle> remainder =
      sym::composeExprBinary(store, *gridBase, sym::ExprBinaryOp::Mod, divisor);
  if (failed(remainder))
    return false;
  if (!sym::provablyDefined(store, *remainder, assumptions))
    return false;
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  if (failed(zero))
    return false;
  FailureOr<sym::PredHandle> aligned =
      sym::composePredCmp(store, *remainder, sym::PredCmpOp::Eq, *zero);
  if (failed(aligned))
    return false;
  return sym::checkPredicate(store, *aligned, assumptions) ==
         sym::CheckResult::True;
}

static bool alignedWithinModulus(sym::Store &store,
                                 sym::ExprHandle lowerResidual,
                                 uint64_t distance, int64_t modulus,
                                 ArrayRef<sym::PredHandle> assumptions) {
  if (static_cast<uint64_t>(modulus) <= distance)
    return false;
  FailureOr<sym::ExprHandle> divisor = sym::composeExprInt(store, modulus);
  FailureOr<sym::ExprHandle> boundary =
      sym::composeExprInt(store, modulus - static_cast<int64_t>(distance));
  if (failed(divisor) || failed(boundary))
    return false;
  if (provesRemainderBelowBoundary(store, lowerResidual, *divisor, *boundary,
                                   assumptions))
    return true;
  return provesAlignedGrid(store, lowerResidual, *divisor, modulus, distance,
                           assumptions);
}

static uint64_t getAbsoluteDistance(int64_t delta) {
  return static_cast<uint64_t>(delta < 0 ? -delta : delta);
}

static sym::ExprHandle getLowerResidual(int64_t delta,
                                        sym::ExprHandle lhsResidual,
                                        sym::ExprHandle rhsResidual) {
  return delta > 0 ? lhsResidual : rhsResidual;
}

static bool
alignedComparisonsEquivalent(sym::Store &store, sym::PredHandle lhs,
                             sym::PredHandle rhs,
                             ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> lhsResidual =
      normalizeComparisonResidual(store, lhs, assumptions);
  FailureOr<sym::ExprHandle> rhsResidual =
      normalizeComparisonResidual(store, rhs, assumptions);
  if (failed(lhsResidual) || failed(rhsResidual))
    return false;
  std::optional<int64_t> delta =
      getConstantDifference(store, *rhsResidual, *lhsResidual, assumptions);
  if (!delta || *delta == std::numeric_limits<int64_t>::min())
    return false;
  if (*delta == 0)
    return true;

  uint64_t distance = getAbsoluteDistance(*delta);
  sym::ExprHandle lowerResidual =
      getLowerResidual(*delta, *lhsResidual, *rhsResidual);
  SmallVector<int64_t> moduli;
  for (sym::PredHandle assumption : assumptions)
    collectAssumptionModuli(assumption, moduli);
  for (int64_t modulus : moduli)
    if (alignedWithinModulus(store, lowerResidual, distance, modulus,
                             assumptions))
      return true;
  return false;
}

static bool
equivalentActivationPredicates(sym::Store &store, sym::PredHandle lhs,
                               sym::PredHandle rhs,
                               ArrayRef<sym::PredHandle> assumptions);

struct UnmatchedLogicArgs {
  SmallVector<uint32_t> lhs;
  SmallVector<uint32_t> rhs;
};

static std::optional<uint32_t> findExactLogicArg(sym::PredView rhs,
                                                 sym::PredHandle sought,
                                                 ArrayRef<uint8_t> matched) {
  for (uint32_t index : llvm::seq<uint32_t>(0, rhs.getLogicArgCount()))
    if (!matched[index] && sought == rhs.getLogicArg(index))
      return index;
  return std::nullopt;
}

static UnmatchedLogicArgs collectUnmatchedLogicArgs(sym::PredView lhs,
                                                    sym::PredView rhs) {
  uint32_t count = lhs.getLogicArgCount();
  SmallVector<uint8_t> rhsMatched(count, false);
  UnmatchedLogicArgs result;
  for (uint32_t lhsIndex : llvm::seq<uint32_t>(0, count)) {
    std::optional<uint32_t> exact =
        findExactLogicArg(rhs, lhs.getLogicArg(lhsIndex), rhsMatched);
    if (!exact) {
      result.lhs.push_back(lhsIndex);
      continue;
    }
    rhsMatched[*exact] = true;
  }
  for (uint32_t rhsIndex : llvm::seq<uint32_t>(0, count))
    if (!rhsMatched[rhsIndex])
      result.rhs.push_back(rhsIndex);
  return result;
}

static SmallVector<SmallVector<uint8_t>>
buildLogicEquivalenceMatrix(sym::Store &store, sym::PredView lhs,
                            sym::PredView rhs,
                            const UnmatchedLogicArgs &remaining,
                            ArrayRef<sym::PredHandle> assumptions) {
  uint32_t count = remaining.lhs.size();
  SmallVector<SmallVector<uint8_t>> equivalent(count);
  for (uint32_t lhsIndex : llvm::seq<uint32_t>(0, count)) {
    equivalent[lhsIndex].reserve(count);
    for (uint32_t rhsIndex : llvm::seq<uint32_t>(0, count))
      equivalent[lhsIndex].push_back(equivalentActivationPredicates(
          store, lhs.getLogicArg(remaining.lhs[lhsIndex]),
          rhs.getLogicArg(remaining.rhs[rhsIndex]), assumptions));
  }
  return equivalent;
}

static bool augmentLogicMatching(uint32_t lhsIndex,
                                 ArrayRef<SmallVector<uint8_t>> equivalent,
                                 SmallVectorImpl<int32_t> &matchedLhs,
                                 SmallVectorImpl<uint8_t> &visited) {
  for (uint32_t rhsIndex :
       llvm::seq<uint32_t>(0, static_cast<uint32_t>(equivalent.size()))) {
    if (!equivalent[lhsIndex][rhsIndex] || visited[rhsIndex])
      continue;
    visited[rhsIndex] = true;
    if (matchedLhs[rhsIndex] < 0 ||
        augmentLogicMatching(static_cast<uint32_t>(matchedLhs[rhsIndex]),
                             equivalent, matchedLhs, visited)) {
      matchedLhs[rhsIndex] = lhsIndex;
      return true;
    }
  }
  return false;
}

static bool hasPerfectLogicMatching(ArrayRef<SmallVector<uint8_t>> equivalent) {
  uint32_t count = equivalent.size();
  SmallVector<int32_t> matchedLhs(count, -1);
  for (uint32_t lhsIndex : llvm::seq<uint32_t>(0, count)) {
    SmallVector<uint8_t> visited(count, false);
    if (!augmentLogicMatching(lhsIndex, equivalent, matchedLhs, visited))
      return false;
  }
  return true;
}

static bool equivalentLogicPredicates(sym::Store &store, sym::PredView lhs,
                                      sym::PredView rhs,
                                      ArrayRef<sym::PredHandle> assumptions) {
  uint32_t count = lhs.getLogicArgCount();
  if (count != rhs.getLogicArgCount())
    return false;
  UnmatchedLogicArgs remaining = collectUnmatchedLogicArgs(lhs, rhs);
  SmallVector<SmallVector<uint8_t>> equivalent =
      buildLogicEquivalenceMatrix(store, lhs, rhs, remaining, assumptions);
  return hasPerfectLogicMatching(equivalent);
}

static bool
equivalentActivationPredicates(sym::Store &store, sym::PredHandle lhs,
                               sym::PredHandle rhs,
                               ArrayRef<sym::PredHandle> assumptions) {
  if (lhs == rhs)
    return true;
  sym::PredView lhsView(lhs);
  sym::PredView rhsView(rhs);
  if (lhsView.getKind() != rhsView.getKind())
    return false;

  switch (lhsView.getKind()) {
  case sym::PredKind::Cmp:
    return alignedComparisonsEquivalent(store, lhs, rhs, assumptions);
  case sym::PredKind::Not:
    return equivalentActivationPredicates(store, lhsView.getUnaryArg(),
                                          rhsView.getUnaryArg(), assumptions);
  case sym::PredKind::And:
  case sym::PredKind::Or:
    return equivalentLogicPredicates(store, lhsView, rhsView, assumptions);
  case sym::PredKind::True:
  case sym::PredKind::False:
    return true;
  default:
    return false;
  }
}

static sym::PredHandle getActivationRelation(const SlotMapping &mapping) {
  return mapping.activationRelationPredicate
             ? mapping.activationRelationPredicate
             : *mapping.activationPredicate;
}

static bool mutuallyImply(sym::Store &store, sym::PredHandle lhs,
                          sym::PredHandle rhs,
                          ArrayRef<sym::PredHandle> assumptions) {
  return predicateImplies(store, lhs, rhs, assumptions) &&
         predicateImplies(store, rhs, lhs, assumptions);
}

static bool sameActivation(sym::Store &store, const SlotMapping &lhs,
                           const SlotMapping &rhs) {
  if (!lhs.packetCondition)
    return !rhs.packetCondition;
  if (!rhs.packetCondition)
    return false;
  if (lhs.packetCondition == rhs.packetCondition)
    return true;
  if (!lhs.activationPredicate)
    return false;
  if (!rhs.activationPredicate)
    return false;
  sym::PredHandle lhsPredicate = *lhs.activationPredicate;
  sym::PredHandle rhsPredicate = *rhs.activationPredicate;
  if (lhsPredicate == rhsPredicate)
    return true;
  SmallVector<sym::PredHandle> assumptions =
      combineNonActivationAssumptions(lhs, rhs);
  sym::PredHandle lhsRelation = getActivationRelation(lhs);
  sym::PredHandle rhsRelation = getActivationRelation(rhs);
  if (equivalentActivationPredicates(store, lhsRelation, rhsRelation,
                                     assumptions))
    return true;
  return mutuallyImply(store, lhsPredicate, rhsPredicate, assumptions);
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
    if (succeeded(simplified)) {
      FailureOr<sym::ExprHandle> expanded = sym::expandExpr(store, *simplified);
      if (succeeded(expanded)) {
        simplified = sym::simplifyExpr(store, *expanded, assumptions);
        if (succeeded(simplified) &&
            sym::getIntegerLiteralValue(*simplified) == 0)
          return true;
      }
    }
  }
  FailureOr<sym::PredHandle> equal =
      sym::composePredCmp(store, lhs, sym::PredCmpOp::Eq, rhs);
  return succeeded(equal) && sym::checkPredicate(store, *equal, assumptions) ==
                                 sym::CheckResult::True;
}

struct SymbolicProofValue {
  SmallVector<sym::PredHandle> assumptions;
  sym::ExprHandle expression;
};

// Runtime div/rem stay SSA; proof-only projections must not duplicate them.
class RemainderProofContext {
public:
  RemainderProofContext(WaveDialect &dialect, DataFlowSolver &solver,
                        Operation *access, ArrayRef<SlotMapping> slots)
      : dialect(dialect), solver(solver), store(dialect.getSymbolStore()),
        slots(slots), access(access) {}

  std::optional<SymbolicProofValue> get(Value value) {
    auto found = values.find(value);
    if (found != values.end())
      return entries[found->second];
    if (unavailableValues.contains(value))
      return std::nullopt;
    if (AssumeOp assume = value.getDefiningOp<AssumeOp>())
      return getAssumedValue(value, assume);
    return getSymbolicValue(value);
  }

  bool isNonnegative(Value value) {
    auto found = nonnegativeValues.find(value);
    if (found != nonnegativeValues.end())
      return found->second;
    std::optional<SymbolicProofValue> symbolic = get(value);
    if (!symbolic)
      return cacheNonnegative(value, false);
    FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
    if (failed(zero))
      return cacheNonnegative(value, false);
    FailureOr<sym::PredHandle> predicate = sym::composePredCmp(
        store, symbolic->expression, sym::PredCmpOp::Ge, *zero);
    bool result =
        succeeded(predicate) &&
        sym::checkPredicate(store, *predicate, symbolic->assumptions) ==
            sym::CheckResult::True;
    return cacheNonnegative(value, result);
  }

  bool isNonnegativeFromMaterializations(const SlotMapping &slot,
                                         const NamedBinding &binding,
                                         BinaryOp remainder) {
    Value result = remainder.getResult();
    auto found = materializedNonnegativeValues.find(result);
    if (found != materializedNonnegativeValues.end())
      return found->second;
    bool proven =
        isNonnegativeFromMaterializationsInSlot(slot, binding, remainder);
    if (!proven)
      for (const SlotMapping &candidateSlot : slots) {
        for (const NamedBinding &candidateBinding : candidateSlot.bindings) {
          if (candidateBinding.value == result &&
              isNonnegativeFromMaterializationsInSlot(
                  candidateSlot, candidateBinding, remainder)) {
            proven = true;
            break;
          }
        }
        if (proven)
          break;
      }
    materializedNonnegativeValues.try_emplace(result, proven);
    return proven;
  }

private:
  std::optional<SymbolicProofValue> getAssumedValue(Value value,
                                                    AssumeOp assume) {
    std::optional<SymbolicProofValue> source = get(assume.getValue());
    if (!source)
      return cacheFailure(value);
    state.canonicalValues.try_emplace(value, assume.getValue());
    FailureOr<sym::ExprHandle> name =
        sym::composeExprSym(store, assume.getName());
    if (failed(name))
      return cacheFailure(value);
    std::array<sym::ExprSubstitution, 1> substitution{
        sym::ExprSubstitution{*name, source->expression}};
    SmallVector<sym::PredHandle> predicates;
    for (Attribute attribute : assume.getAssumptions())
      predicates.push_back(cast<PredAttr>(attribute).getValue());
    FailureOr<SmallVector<sym::PredHandle>> remapped =
        substituteIndexExprPredicates(store, predicates, substitution);
    if (failed(remapped))
      return cacheFailure(value);
    llvm::append_range(source->assumptions, *remapped);
    return cache(value, std::move(*source));
  }

  std::optional<SymbolicProofValue> getSymbolicValue(Value value) {
    FailureOr<std::optional<SymbolicOffset>> symbolic =
        buildSymbolicIndexValue(value, dialect, solver);
    if (failed(symbolic) || !*symbolic)
      return cacheFailure(value);
    canonicalizeWorkitems(**symbolic);
    size_t assumptionStart = mapping.assumptions.size();
    FailureOr<sym::ExprHandle> expression =
        remapSymbolicOffset(store, **symbolic, state, mapping);
    if (failed(expression))
      return cacheFailure(value);
    SymbolicProofValue entry{{}, *expression};
    llvm::append_range(entry.assumptions,
                       ArrayRef<sym::PredHandle>(mapping.assumptions)
                           .drop_front(assumptionStart));
    appendDirectUseAssumptions(value, entry);
    return cache(value, std::move(entry));
  }
  bool isNonnegativeFromMaterializationsInSlot(const SlotMapping &slot,
                                               const NamedBinding &binding,
                                               BinaryOp remainder) {
    for (const MaterializationCandidate &candidate :
         llvm::reverse(slot.materializationCandidates)) {
      if (!hasSymbol(candidate.expression, binding.name))
        continue;
      std::optional<SymbolicProofValue> root = get(candidate.value);
      if (!root)
        continue;
      std::optional<SymbolicProofValue> dividend = get(remainder.getLhs());
      std::optional<SymbolicProofValue> divisor = get(remainder.getRhs());
      std::optional<SymbolicProofValue> target = get(remainder.getResult());
      if (!dividend || !divisor || !target)
        continue;
      if (proveProjectedNonnegative(candidate.value, remainder.getResult(),
                                    *root, *dividend, *divisor, *target))
        return true;
    }
    return false;
  }

  struct WorkitemProjection {
    std::array<std::optional<int64_t>, 3> periods;
  };

  void canonicalizeWorkitems(const SymbolicOffset &symbolic) {
    for (const SymbolicOffsetBinding &binding : symbolic.bindings) {
      WorkitemIdOp workitem = binding.value.getDefiningOp<WorkitemIdOp>();
      if (!workitem || workitem.getAxis() >= workitems.size())
        continue;
      SmallVector<Value> &axisValues = workitems[workitem.getAxis()];
      auto found = llvm::find_if(axisValues, [&](Value existing) {
        return existing.getType() == binding.value.getType();
      });
      if (found == axisValues.end()) {
        axisValues.push_back(binding.value);
        continue;
      }
      state.canonicalValues.try_emplace(binding.value, *found);
    }
  }

  static void collectAddModuli(sym::ExprView view,
                               SmallVectorImpl<int64_t> &moduli) {
    collectExpressionModuli(view.getAddConstant(), moduli);
    for (uint32_t index : llvm::seq(view.getAddTermCount())) {
      sym::AddTerm term = view.getAddTerm(index);
      collectExpressionModuli(term.coefficient, moduli);
      collectExpressionModuli(term.term, moduli);
    }
  }

  static void collectMulModuli(sym::ExprView view,
                               SmallVectorImpl<int64_t> &moduli) {
    collectExpressionModuli(view.getMulCoefficient(), moduli);
    for (uint32_t index : llvm::seq(view.getMulFactorCount()))
      collectExpressionModuli(view.getMulFactor(index).base, moduli);
  }

  static void collectModModuli(sym::ExprView view,
                               SmallVectorImpl<int64_t> &moduli) {
    std::optional<int64_t> modulus =
        sym::getIntegerLiteralValue(view.getBinaryRhs());
    if (modulus && *modulus > 0 && !llvm::is_contained(moduli, *modulus))
      moduli.push_back(*modulus);
    collectExpressionModuli(view.getBinaryLhs(), moduli);
    collectExpressionModuli(view.getBinaryRhs(), moduli);
  }

  static void collectBinaryModuli(sym::ExprView view,
                                  SmallVectorImpl<int64_t> &moduli) {
    collectExpressionModuli(view.getBinaryLhs(), moduli);
    collectExpressionModuli(view.getBinaryRhs(), moduli);
  }

  static void collectOtherExpressionModuli(sym::ExprView view,
                                           SmallVectorImpl<int64_t> &moduli) {
    switch (view.getKind()) {
    case sym::ExprKind::Floor:
    case sym::ExprKind::Ceil:
      collectExpressionModuli(view.getUnaryArg(), moduli);
      return;
    case sym::ExprKind::Max:
    case sym::ExprKind::Min:
    case sym::ExprKind::Xor:
      collectBinaryModuli(view, moduli);
      return;
    case sym::ExprKind::Piecewise:
      for (uint32_t index : llvm::seq(view.getPiecewiseCaseCount()))
        collectExpressionModuli(view.getPiecewiseCase(index).value, moduli);
      return;
    default:
      return;
    }
  }

  static void collectExpressionModuli(sym::ExprHandle expression,
                                      SmallVectorImpl<int64_t> &moduli) {
    sym::ExprView view(expression);
    if (view.getKind() == sym::ExprKind::Add)
      return collectAddModuli(view, moduli);
    if (view.getKind() == sym::ExprKind::Mul)
      return collectMulModuli(view, moduli);
    if (view.getKind() == sym::ExprKind::Mod)
      return collectModModuli(view, moduli);
    collectOtherExpressionModuli(view, moduli);
  }

  std::optional<sym::ExprHandle> getBindingSymbol(Value value) {
    Value canonical = state.canonicalValues.lookup(value);
    if (canonical)
      value = canonical;
    for (const NamedBinding &binding : mapping.bindings) {
      if (binding.value != value)
        continue;
      FailureOr<sym::ExprHandle> symbol =
          sym::composeExprSym(store, binding.name);
      if (succeeded(symbol))
        return *symbol;
      return std::nullopt;
    }
    return std::nullopt;
  }

  static bool isUnconditionalAcrossWorkitems(Value root) {
    Operation *child = root.getDefiningOp();
    if (!child)
      return false;
    for (Operation *parent = child->getParentOp(); parent;
         child = parent, parent = parent->getParentOp()) {
      if (isa<func::FuncOp>(parent))
        return true;
      if (parent->getNumRegions() == 0)
        continue;
      scf::ForOp loop = dyn_cast<scf::ForOp>(parent);
      if (!loop || child->getBlock() != loop.getBody())
        return false;
    }
    return false;
  }

  static bool dependsOnWorkitem(Value value, DenseSet<Value> &visited) {
    if (!visited.insert(value).second)
      return false;
    if (value.getDefiningOp<WorkitemIdOp>())
      return true;
    if (BlockArgument argument = dyn_cast<BlockArgument>(value)) {
      if (argument.getArgNumber() == 0 &&
          isa_and_nonnull<scf::ForOp>(argument.getOwner()->getParentOp()))
        return false;
      return argument.getOwner()->isEntryBlock() ? false : true;
    }
    Operation *producer = value.getDefiningOp();
    return producer &&
           llvm::any_of(producer->getOperands(), [&](Value operand) {
             return dependsOnWorkitem(operand, visited);
           });
  }

  bool proofReferencesBinding(const SymbolicProofValue &proof, StringRef name) {
    if (hasSymbol(proof.expression, name))
      return true;
    for (sym::PredHandle assumption : proof.assumptions) {
      bool found = false;
      sym::walkSymbolNames(
          assumption, [&](StringRef candidate) { found |= candidate == name; });
      if (found)
        return true;
    }
    return false;
  }

  bool hasOpaqueWorkitemDependency(const SymbolicProofValue &root,
                                   const SymbolicProofValue &dividend,
                                   const SymbolicProofValue &divisor,
                                   Value target) {
    Value canonicalTarget = state.canonicalValues.lookup(target);
    if (!canonicalTarget)
      canonicalTarget = target;
    for (const NamedBinding &binding : mapping.bindings) {
      if (!proofReferencesBinding(root, binding.name) &&
          !proofReferencesBinding(dividend, binding.name) &&
          !proofReferencesBinding(divisor, binding.name))
        continue;
      if (binding.value == canonicalTarget ||
          binding.value.getDefiningOp<WorkitemIdOp>())
        continue;
      DenseSet<Value> visited;
      if (dependsOnWorkitem(binding.value, visited))
        return true;
    }
    return false;
  }

  bool proofReferencesWorkitemAxis(const SymbolicProofValue &proof,
                                   unsigned axis) {
    for (Value workitem : workitems[axis]) {
      std::optional<sym::ExprHandle> symbol = getBindingSymbol(workitem);
      if (!symbol)
        continue;
      if (proofReferencesBinding(proof, sym::ExprView(*symbol).getSymbolName()))
        return true;
    }
    return false;
  }

  std::array<SmallVector<int64_t>, 3>
  getProjectionPeriodsByAxis(const SymbolicProofValue &root,
                             ArrayRef<int64_t> periods,
                             ArrayRef<int32_t> dimensions) {
    std::array<SmallVector<int64_t>, 3> periodsByAxis;
    for (unsigned axis : llvm::seq<unsigned>(0, 3)) {
      if (!proofReferencesWorkitemAxis(root, axis))
        continue;
      for (int64_t period : periods)
        if (period <= dimensions[axis])
          periodsByAxis[axis].push_back(period);
    }
    return periodsByAxis;
  }

  static SmallVector<WorkitemProjection> expandWorkitemProjections(
      const std::array<SmallVector<int64_t>, 3> &periodsByAxis) {
    SmallVector<WorkitemProjection> projections(1);
    constexpr size_t projectionLimit = 256;
    for (unsigned axis : llvm::seq<unsigned>(0, 3)) {
      if (periodsByAxis[axis].empty())
        continue;
      if (periodsByAxis[axis].size() > projectionLimit / projections.size())
        return {};
      SmallVector<WorkitemProjection> expanded;
      for (const WorkitemProjection &projection : projections)
        for (int64_t period : periodsByAxis[axis]) {
          WorkitemProjection next = projection;
          next.periods[axis] = period;
          expanded.push_back(std::move(next));
        }
      projections = std::move(expanded);
    }
    return projections;
  }

  SmallVector<WorkitemProjection>
  getWorkitemProjections(Value rootValue, const SymbolicProofValue &root,
                         const SymbolicProofValue &dividend,
                         const SymbolicProofValue &divisor, Value target) {
    if (!isUnconditionalAcrossWorkitems(rootValue) ||
        hasOpaqueWorkitemDependency(root, dividend, divisor, target))
      return {};
    DenseI32ArrayAttr shape = getWorkgroupShape(access);
    if (!shape)
      return {};
    ArrayRef<int32_t> dimensions = shape.asArrayRef();
    if (dimensions.size() != 3)
      return {};

    SmallVector<int64_t> periods{1};
    collectExpressionModuli(dividend.expression, periods);
    collectExpressionModuli(divisor.expression, periods);
    llvm::sort(periods);
    periods.erase(std::unique(periods.begin(), periods.end()), periods.end());
    std::array<SmallVector<int64_t>, 3> periodsByAxis =
        getProjectionPeriodsByAxis(root, periods, dimensions);
    if (llvm::all_of(periodsByAxis,
                     [](ArrayRef<int64_t> values) { return values.empty(); }))
      return {};
    return expandWorkitemProjections(periodsByAxis);
  }

  FailureOr<std::optional<sym::ExprSubstitution>>
  getWorkitemProjectionSubstitution(
      sym::ExprHandle symbol, WorkitemIdOp workitem,
      std::optional<WorkitemProjection> projection) {
    if (!projection || workitem.getAxis() >= projection->periods.size() ||
        !projection->periods[workitem.getAxis()])
      return std::optional<sym::ExprSubstitution>{};
    FailureOr<sym::ExprHandle> period =
        sym::composeExprInt(store, *projection->periods[workitem.getAxis()]);
    if (failed(period))
      return failure();
    FailureOr<sym::ExprHandle> representative =
        sym::composeExprBinary(store, symbol, sym::ExprBinaryOp::Mod, *period);
    if (failed(representative))
      return failure();
    return std::optional<sym::ExprSubstitution>{
        sym::ExprSubstitution{symbol, *representative}};
  }

  FailureOr<std::optional<sym::ExprSubstitution>>
  getLoopProjectionSubstitution(sym::ExprHandle symbol, Value value,
                                Operation *rootOp) {
    if (!rootOp)
      return std::optional<sym::ExprSubstitution>{};
    BlockArgument argument = dyn_cast<BlockArgument>(value);
    if (!argument || argument.getArgNumber() != 0)
      return std::optional<sym::ExprSubstitution>{};
    scf::ForOp loop =
        dyn_cast_or_null<scf::ForOp>(argument.getOwner()->getParentOp());
    if (!loop || rootOp->getBlock() != loop.getBody())
      return std::optional<sym::ExprSubstitution>{};
    std::optional<int64_t> lower = getConstantIntValue(loop.getLowerBound());
    if (!lower)
      return std::optional<sym::ExprSubstitution>{};
    FailureOr<sym::ExprHandle> lowerExpression =
        sym::composeExprInt(store, *lower);
    if (failed(lowerExpression))
      return failure();
    return std::optional<sym::ExprSubstitution>{
        sym::ExprSubstitution{symbol, *lowerExpression}};
  }

  FailureOr<std::optional<sym::ExprSubstitution>>
  getExecutionSubstitution(const NamedBinding &binding, Operation *rootOp,
                           std::optional<WorkitemProjection> projection) {
    FailureOr<sym::ExprHandle> symbol =
        sym::composeExprSym(store, binding.name);
    if (failed(symbol))
      return failure();
    if (WorkitemIdOp workitem = binding.value.getDefiningOp<WorkitemIdOp>())
      return getWorkitemProjectionSubstitution(*symbol, workitem, projection);
    return getLoopProjectionSubstitution(*symbol, binding.value, rootOp);
  }

  FailureOr<SmallVector<sym::ExprSubstitution>>
  buildExecutionProjection(Value root,
                           std::optional<WorkitemProjection> projection) {
    SmallVector<sym::ExprSubstitution> substitutions;
    Operation *rootOp = root.getDefiningOp();
    for (const NamedBinding &binding : mapping.bindings) {
      FailureOr<std::optional<sym::ExprSubstitution>> substitution =
          getExecutionSubstitution(binding, rootOp, projection);
      if (failed(substitution))
        return failure();
      if (*substitution)
        substitutions.push_back(**substitution);
    }
    return substitutions;
  }

  bool invariantUnderProjection(const SymbolicProofValue &value,
                                ArrayRef<sym::ExprSubstitution> substitutions) {
    FailureOr<sym::ExprHandle> projected =
        sym::substituteExpr(store, value.expression, substitutions);
    return succeeded(projected) &&
           proveEqual(store, value.expression, *projected, value.assumptions);
  }

  LogicalResult
  appendProjectionFacts(ArrayRef<sym::ExprSubstitution> substitutions,
                        SmallVectorImpl<sym::PredHandle> &assumptions) {
    FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
    if (failed(zero))
      return failure();
    for (const sym::ExprSubstitution &substitution : substitutions) {
      sym::ExprView replacement(substitution.replacement);
      if (replacement.getKind() != sym::ExprKind::Mod)
        continue;
      sym::ExprHandle divisor = replacement.getBinaryRhs();
      std::optional<int64_t> modulus = sym::getIntegerLiteralValue(divisor);
      if (!modulus || *modulus <= 0)
        return failure();
      FailureOr<sym::PredHandle> lower = sym::composePredCmp(
          store, substitution.replacement, sym::PredCmpOp::Ge, *zero);
      FailureOr<sym::PredHandle> upper = sym::composePredCmp(
          store, substitution.replacement, sym::PredCmpOp::Lt, divisor);
      if (failed(lower) || failed(upper))
        return failure();
      assumptions.push_back(*lower);
      assumptions.push_back(*upper);
    }
    return success();
  }

  FailureOr<sym::ExprHandle> getNonnegativeResidual(sym::PredHandle predicate) {
    sym::PredView view(predicate);
    if (view.getKind() != sym::PredKind::Cmp)
      return failure();
    sym::ExprHandle lhs = view.getCmpLhs();
    sym::ExprHandle rhs = view.getCmpRhs();
    sym::PredCmpOp comparison = view.getCmpOp().value_or(sym::PredCmpOp::Eq);
    bool strict = false;
    switch (comparison) {
    case sym::PredCmpOp::Ge:
      break;
    case sym::PredCmpOp::Gt:
      strict = true;
      break;
    case sym::PredCmpOp::Le:
      std::swap(lhs, rhs);
      break;
    case sym::PredCmpOp::Lt:
      std::swap(lhs, rhs);
      strict = true;
      break;
    default:
      return failure();
    }
    FailureOr<sym::ExprHandle> residual =
        sym::composeExprBinary(store, lhs, sym::ExprBinaryOp::Sub, rhs);
    if (failed(residual) || !strict)
      return residual;
    FailureOr<sym::ExprHandle> one = sym::composeExprInt(store, 1);
    if (failed(one))
      return failure();
    return sym::composeExprBinary(store, *residual, sym::ExprBinaryOp::Sub,
                                  *one);
  }

  bool projectedAssumptionProvesNonnegative(
      sym::PredHandle predicate, const SymbolicProofValue &target,
      ArrayRef<sym::ExprSubstitution> substitutions,
      ArrayRef<sym::PredHandle> assumptions) {
    sym::PredView view(predicate);
    if (view.getKind() == sym::PredKind::And) {
      for (uint32_t index : llvm::seq(view.getLogicArgCount()))
        if (projectedAssumptionProvesNonnegative(
                view.getLogicArg(index), target, substitutions, assumptions))
          return true;
      return false;
    }
    FailureOr<sym::ExprHandle> residual = getNonnegativeResidual(predicate);
    if (failed(residual))
      return false;
    FailureOr<sym::ExprHandle> projected =
        sym::substituteExpr(store, *residual, substitutions);
    if (failed(projected))
      return false;
    FailureOr<sym::ExprHandle> simplified =
        sym::simplifyExpr(store, *projected, assumptions);
    if (succeeded(simplified))
      projected = *simplified;
    return proveEqual(store, *projected, target.expression, assumptions);
  }

  bool
  projectionProvesNonnegative(const SymbolicProofValue &root,
                              const SymbolicProofValue &target,
                              ArrayRef<sym::ExprSubstitution> substitutions) {
    SmallVector<sym::PredHandle> assumptions(target.assumptions);
    if (failed(appendProjectionFacts(substitutions, assumptions)))
      return false;
    for (sym::PredHandle assumption : root.assumptions) {
      FailureOr<sym::PredHandle> projected =
          sym::substitutePred(store, assumption, substitutions);
      if (failed(projected))
        return false;
      FailureOr<sym::PredHandle> simplified =
          sym::simplifyPred(store, *projected);
      assumptions.push_back(succeeded(simplified) ? *simplified : *projected);
    }
    return llvm::any_of(root.assumptions, [&](sym::PredHandle assumption) {
      return projectedAssumptionProvesNonnegative(assumption, target,
                                                  substitutions, assumptions);
    });
  }

  bool proveProjectedNonnegative(Value rootValue, Value targetValue,
                                 const SymbolicProofValue &root,
                                 const SymbolicProofValue &dividend,
                                 const SymbolicProofValue &divisor,
                                 const SymbolicProofValue &target) {
    SmallVector<std::optional<WorkitemProjection>> projections{std::nullopt};
    for (WorkitemProjection projection : getWorkitemProjections(
             rootValue, root, dividend, divisor, targetValue))
      projections.push_back(projection);
    for (std::optional<WorkitemProjection> projection : projections) {
      FailureOr<SmallVector<sym::ExprSubstitution>> substitutions =
          buildExecutionProjection(rootValue, projection);
      if (failed(substitutions))
        continue;
      // Projected execution point must preserve remainder operands.
      bool dividendInvariant =
          invariantUnderProjection(dividend, *substitutions);
      bool divisorInvariant = invariantUnderProjection(divisor, *substitutions);
      if (!dividendInvariant || !divisorInvariant)
        continue;
      bool proven = projectionProvesNonnegative(root, target, *substitutions);
      if (proven)
        return true;
    }
    return false;
  }

  static bool referencesOnly(sym::PredHandle predicate, StringRef name) {
    bool found = false;
    bool only = true;
    sym::walkSymbolNames(predicate, [&](StringRef candidate) {
      found |= candidate == name;
      only &= candidate == name;
    });
    return found && only;
  }

  void appendRemappedAssumptions(StringRef name,
                                 ArrayRef<sym::PredHandle> predicates,
                                 SymbolicProofValue &entry,
                                 bool requireSingleSymbol = false) {
    FailureOr<sym::ExprHandle> source = sym::composeExprSym(store, name);
    if (failed(source))
      return;
    std::array<sym::ExprSubstitution, 1> substitution{
        sym::ExprSubstitution{*source, entry.expression}};
    for (sym::PredHandle predicate : predicates) {
      if (requireSingleSymbol && !referencesOnly(predicate, name))
        continue;
      FailureOr<sym::PredHandle> remapped =
          sym::substitutePred(store, predicate, substitution);
      if (succeeded(remapped))
        entry.assumptions.push_back(*remapped);
    }
  }

  void appendDirectUseAssumptions(Value value, SymbolicProofValue &entry) {
    // Assumptions describe SSA values; textual order is irrelevant.
    for (OpOperand &use : value.getUses()) {
      Operation *owner = use.getOwner();
      if (AssumeOp assume = dyn_cast<AssumeOp>(owner)) {
        SmallVector<sym::PredHandle> predicates;
        for (Attribute attribute : assume.getAssumptions())
          predicates.push_back(cast<PredAttr>(attribute).getValue());
        appendRemappedAssumptions(assume.getName(), predicates, entry);
        continue;
      }
      IndexExprOp indexExpr = dyn_cast<IndexExprOp>(owner);
      if (!indexExpr)
        continue;
      for (auto [binding, nameAttr] :
           llvm::zip(indexExpr.getBindings(), indexExpr.getNames())) {
        if (binding != value)
          continue;
        StringRef name = cast<StringAttr>(nameAttr).getValue();
        SmallVector<sym::PredHandle> predicates;
        for (Attribute attribute : indexExpr.getAssumptions())
          predicates.push_back(cast<PredAttr>(attribute).getValue());
        appendRemappedAssumptions(name, predicates, entry,
                                  /*requireSingleSymbol=*/true);
      }
    }
  }

  std::optional<SymbolicProofValue> cache(Value value,
                                          SymbolicProofValue entry) {
    unsigned index = entries.size();
    entries.push_back(std::move(entry));
    values.try_emplace(value, index);
    return entries.back();
  }

  std::optional<SymbolicProofValue> cacheFailure(Value value) {
    unavailableValues.insert(value);
    return std::nullopt;
  }

  bool cacheNonnegative(Value value, bool result) {
    nonnegativeValues.try_emplace(value, result);
    return result;
  }

  PacketBindingState state;
  SlotMapping mapping;
  SmallVector<SymbolicProofValue> entries;
  std::array<SmallVector<Value>, 3> workitems;
  DenseSet<Value> unavailableValues;
  llvm::DenseMap<Value, bool> nonnegativeValues;
  llvm::DenseMap<Value, bool> materializedNonnegativeValues;
  llvm::DenseMap<Value, unsigned> values;
  WaveDialect &dialect;
  DataFlowSolver &solver;
  sym::Store &store;
  ArrayRef<SlotMapping> slots;
  Operation *access;
};

static bool provePredicate(sym::Store &store, sym::ExprHandle lhs,
                           sym::PredCmpOp comparison, sym::ExprHandle rhs,
                           ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::PredHandle> predicate =
      sym::composePredCmp(store, lhs, comparison, rhs);
  return succeeded(predicate) &&
         sym::checkPredicate(store, *predicate, assumptions) ==
             sym::CheckResult::True;
}

static BinaryOp findRemainder(Value value) {
  while (true) {
    if (BinaryOp binary = value.getDefiningOp<BinaryOp>())
      return binary.getKind() == BinaryKind::RemSI ||
                     binary.getKind() == BinaryKind::RemUI
                 ? binary
                 : BinaryOp{};
    if (AssumeOp assume = value.getDefiningOp<AssumeOp>()) {
      value = assume.getValue();
      continue;
    }
    if (SplatOp splat = value.getDefiningOp<SplatOp>()) {
      value = splat.getSource();
      continue;
    }
    return {};
  }
}

static FailureOr<sym::ExprHandle>
getRemainderResidual(sym::Store &store, const SlotMapping &slot,
                     const NamedBinding &binding, int64_t elementBits) {
  FailureOr<sym::ExprHandle> symbol = sym::composeExprSym(store, binding.name);
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  FailureOr<sym::ExprHandle> scale = sym::composeExprInt(store, elementBits);
  if (failed(symbol) || failed(zero) || failed(scale))
    return failure();
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{*symbol, *zero}};
  FailureOr<sym::ExprHandle> residual =
      sym::substituteExpr(store, slot.bitOffset, substitution);
  if (failed(residual))
    return failure();
  residual = sym::simplifyExpr(store, *residual, slot.assumptions);
  if (failed(residual))
    return failure();
  FailureOr<sym::ExprHandle> contribution =
      sym::composeExprBinary(store, *scale, sym::ExprBinaryOp::Mul, *symbol);
  if (failed(contribution))
    return failure();
  FailureOr<sym::ExprHandle> rebuilt = sym::composeExprBinary(
      store, *residual, sym::ExprBinaryOp::Add, *contribution);
  if (failed(rebuilt) ||
      !proveEqual(store, slot.bitOffset, *rebuilt, slot.assumptions))
    return failure();
  return *residual;
}

static bool isBindingNonnegative(sym::Store &store, const SlotMapping &slot,
                                 const NamedBinding &binding) {
  FailureOr<sym::ExprHandle> symbol = sym::composeExprSym(store, binding.name);
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  return succeeded(symbol) && succeeded(zero) &&
         provePredicate(store, *symbol, sym::PredCmpOp::Ge, *zero,
                        slot.assumptions);
}

struct AlignedRemainderProof {
  SmallVector<sym::PredHandle> assumptions;
  sym::ExprHandle dividend;
  sym::ExprHandle divisor;
};

static std::optional<AlignedRemainderProof>
buildAlignedRemainderProof(sym::Store &store, BinaryOp lhs, BinaryOp rhs,
                           RemainderProofContext &proofContext) {
  std::optional<SymbolicProofValue> lhsDividend =
      proofContext.get(lhs.getLhs());
  if (!lhsDividend)
    return std::nullopt;
  std::optional<SymbolicProofValue> rhsDividend =
      proofContext.get(rhs.getLhs());
  if (!rhsDividend)
    return std::nullopt;
  std::optional<SymbolicProofValue> lhsDivisor = proofContext.get(lhs.getRhs());
  if (!lhsDivisor)
    return std::nullopt;
  std::optional<SymbolicProofValue> rhsDivisor = proofContext.get(rhs.getRhs());
  if (!rhsDivisor)
    return std::nullopt;
  SmallVector<sym::PredHandle> assumptions;
  llvm::append_range(assumptions, lhsDividend->assumptions);
  llvm::append_range(assumptions, rhsDividend->assumptions);
  llvm::append_range(assumptions, lhsDivisor->assumptions);
  llvm::append_range(assumptions, rhsDivisor->assumptions);
  if (!proveEqual(store, lhsDivisor->expression, rhsDivisor->expression,
                  assumptions))
    return std::nullopt;
  FailureOr<sym::ExprHandle> one = sym::composeExprInt(store, 1);
  if (failed(one))
    return std::nullopt;
  FailureOr<sym::ExprHandle> nextDividend = sym::composeExprBinary(
      store, lhsDividend->expression, sym::ExprBinaryOp::Add, *one);
  if (failed(nextDividend))
    return std::nullopt;
  if (!proveEqual(store, *nextDividend, rhsDividend->expression, assumptions))
    return std::nullopt;
  return AlignedRemainderProof{std::move(assumptions), lhsDividend->expression,
                               lhsDivisor->expression};
}

static bool appendRemainderDefinedAssumption(
    sym::Store &store, BinaryKind kind, sym::ExprHandle divisor,
    sym::ExprHandle zero, SmallVectorImpl<sym::PredHandle> &assumptions) {
  sym::PredCmpOp comparison = sym::PredCmpOp::Ne;
  if (kind == BinaryKind::RemUI)
    comparison = sym::PredCmpOp::Gt;
  FailureOr<sym::PredHandle> defined =
      sym::composePredCmp(store, divisor, comparison, zero);
  if (failed(defined))
    return false;
  if (kind == BinaryKind::RemUI &&
      sym::checkPredicate(store, *defined, assumptions) !=
          sym::CheckResult::True)
    return false;
  assumptions.push_back(*defined);
  return true;
}

static bool hasValidRemainderSign(sym::Store &store, BinaryKind kind,
                                  sym::ExprHandle dividend,
                                  sym::ExprHandle zero,
                                  bool nonnegativeRemainders,
                                  ArrayRef<sym::PredHandle> assumptions) {
  if (kind != BinaryKind::RemSI || nonnegativeRemainders)
    return true;
  return provePredicate(store, dividend, sym::PredCmpOp::Ge, zero, assumptions);
}

static bool hasAlignedRemainderGrid(sym::Store &store,
                                    const AlignedRemainderProof &proof,
                                    sym::ExprHandle zero) {
  SmallVector<int64_t> moduli;
  for (sym::PredHandle assumption : proof.assumptions)
    collectAssumptionModuli(assumption, moduli);
  for (int64_t modulusValue : moduli) {
    FailureOr<sym::ExprHandle> modulus =
        sym::composeExprInt(store, modulusValue);
    if (failed(modulus))
      return false;
    FailureOr<sym::ExprHandle> divisorResidue = sym::composeExprBinary(
        store, proof.divisor, sym::ExprBinaryOp::Mod, *modulus);
    if (failed(divisorResidue))
      return false;
    if (provePredicate(store, *divisorResidue, sym::PredCmpOp::Eq, zero,
                       proof.assumptions) &&
        alignedWithinModulus(store, proof.dividend, 1, modulusValue,
                             proof.assumptions))
      return true;
  }
  return false;
}

static bool
proveAlignedRemainderSuccessor(sym::Store &store, BinaryOp lhs, BinaryOp rhs,
                               bool nonnegativeRemainders,
                               RemainderProofContext &proofContext) {
  if (lhs.getKind() != rhs.getKind())
    return false;
  std::optional<AlignedRemainderProof> proof =
      buildAlignedRemainderProof(store, lhs, rhs, proofContext);
  if (!proof)
    return false;
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  if (failed(zero))
    return false;
  if (!appendRemainderDefinedAssumption(store, lhs.getKind(), proof->divisor,
                                        *zero, proof->assumptions))
    return false;
  if (!hasValidRemainderSign(store, lhs.getKind(), proof->dividend, *zero,
                             nonnegativeRemainders, proof->assumptions))
    return false;
  return hasAlignedRemainderGrid(store, *proof, *zero);
}

static bool isRemainderNonnegative(sym::Store &store, const SlotMapping &slot,
                                   const NamedBinding &binding,
                                   BinaryOp remainder,
                                   RemainderProofContext &proofContext) {
  return isBindingNonnegative(store, slot, binding) ||
         proofContext.isNonnegative(remainder.getResult()) ||
         proofContext.isNonnegativeFromMaterializations(slot, binding,
                                                        remainder);
}

static bool proveRemainderBindingAdjacent(
    sym::Store &store, const SlotMapping &lhs, const SlotMapping &rhs,
    const NamedBinding &lhsBinding, const NamedBinding &rhsBinding,
    int64_t elementBits, ArrayRef<sym::PredHandle> assumptions,
    RemainderProofContext &proofContext) {
  BinaryOp lhsRemainder = findRemainder(lhsBinding.value);
  if (!lhsRemainder)
    return false;
  BinaryOp rhsRemainder = findRemainder(rhsBinding.value);
  if (!rhsRemainder)
    return false;
  FailureOr<sym::ExprHandle> lhsResidual =
      getRemainderResidual(store, lhs, lhsBinding, elementBits);
  if (failed(lhsResidual))
    return false;
  FailureOr<sym::ExprHandle> rhsResidual =
      getRemainderResidual(store, rhs, rhsBinding, elementBits);
  if (failed(rhsResidual))
    return false;
  if (!proveEqual(store, *lhsResidual, *rhsResidual, assumptions))
    return false;
  bool nonnegativeRemainders =
      isRemainderNonnegative(store, lhs, lhsBinding, lhsRemainder,
                             proofContext) &&
      isRemainderNonnegative(store, rhs, rhsBinding, rhsRemainder,
                             proofContext);
  return proveAlignedRemainderSuccessor(store, lhsRemainder, rhsRemainder,
                                        nonnegativeRemainders, proofContext);
}

static bool proveRemainderAdjacent(sym::Store &store, const SlotMapping &lhs,
                                   const SlotMapping &rhs, int64_t elementBits,
                                   RemainderProofContext &proofContext) {
  SmallVector<sym::PredHandle> assumptions = combineAssumptions(lhs, rhs);
  for (const NamedBinding &lhsBinding : lhs.bindings)
    for (const NamedBinding &rhsBinding : rhs.bindings)
      if (proveRemainderBindingAdjacent(store, lhs, rhs, lhsBinding, rhsBinding,
                                        elementBits, assumptions, proofContext))
        return true;
  return false;
}

static bool samePoint(sym::Store &store, const SlotMapping &lhs,
                      const SlotMapping &rhs) {
  if (!sameActivation(store, lhs, rhs))
    return false;
  SmallVector<sym::PredHandle> assumptions = combineAssumptions(lhs, rhs);
  return proveEqual(store, lhs.base, rhs.base, assumptions) &&
         proveEqual(store, lhs.targetBlock, rhs.targetBlock, assumptions) &&
         proveEqual(store, lhs.bitOffset, rhs.bitOffset, assumptions);
}

static bool adjacent(sym::Store &store, const SlotMapping &lhs,
                     const SlotMapping &rhs, int64_t elementBits,
                     RemainderProofContext &proofContext) {
  SmallVector<sym::PredHandle> assumptions = combineAssumptions(lhs, rhs);
  if (!proveEqual(store, lhs.base, rhs.base, assumptions) ||
      !proveEqual(store, lhs.targetBlock, rhs.targetBlock, assumptions))
    return false;
  FailureOr<sym::ExprHandle> delta = sym::composeExprInt(store, elementBits);
  if (failed(delta))
    return false;
  FailureOr<sym::ExprHandle> expected = sym::composeExprBinary(
      store, lhs.bitOffset, sym::ExprBinaryOp::Add, *delta);
  if (failed(expected))
    return false;
  if (!proveEqual(store, *expected, rhs.bitOffset, assumptions)) {
    if (!proveRemainderAdjacent(store, lhs, rhs, elementBits, proofContext))
      return false;
  }
  return sameActivation(store, lhs, rhs);
}

static SmallVector<SlotMapping, 4>
deduplicateGatherSlots(sym::Store &store, SmallVector<SlotMapping, 4> slots) {
  SmallVector<SlotMapping, 4> unique;
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
buildDenseSuccessorGraph(sym::Store &store, ArrayRef<SlotMapping> slots,
                         int64_t elementBits,
                         RemainderProofContext &proofContext) {
  size_t count = slots.size();
  SmallVector<SmallVector<unsigned>> edges(count);
  for (unsigned lhs = 0; lhs < count; ++lhs)
    for (unsigned rhs = 0; rhs < count; ++rhs)
      if (lhs != rhs &&
          adjacent(store, slots[lhs], slots[rhs], elementBits, proofContext))
        edges[lhs].push_back(rhs);
  return edges;
}

using SparseAddressKey =
    std::pair<sym::ExprHandle, std::pair<sym::ExprHandle, sym::ExprHandle>>;

static FailureOr<sym::ExprHandle>
canonicalizeAddressExpr(sym::Store &store, sym::ExprHandle expression,
                        ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(store, expression, assumptions);
  if (failed(simplified))
    return failure();
  FailureOr<sym::ExprHandle> expanded = sym::expandExpr(store, *simplified);
  if (failed(expanded))
    return *simplified;
  FailureOr<sym::ExprHandle> canonical =
      sym::simplifyExpr(store, *expanded, assumptions);
  if (succeeded(canonical))
    return *canonical;
  return *simplified;
}

static FailureOr<std::pair<sym::ExprHandle, int64_t>>
splitAddressConstant(sym::Store &store, sym::ExprHandle expression,
                     ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> canonical =
      canonicalizeAddressExpr(store, expression, assumptions);
  if (failed(canonical))
    return failure();
  std::optional<int64_t> constant = getAdditiveConstant(*canonical);
  if (!constant)
    return failure();
  FailureOr<sym::ExprHandle> constantExpr =
      sym::composeExprInt(store, *constant);
  if (failed(constantExpr))
    return failure();
  FailureOr<sym::ExprHandle> origin = sym::composeExprBinary(
      store, *canonical, sym::ExprBinaryOp::Sub, *constantExpr);
  if (failed(origin))
    return failure();
  FailureOr<sym::ExprHandle> canonicalOrigin =
      canonicalizeAddressExpr(store, *origin, assumptions);
  if (failed(canonicalOrigin))
    return failure();
  return std::pair<sym::ExprHandle, int64_t>{*canonicalOrigin, *constant};
}

using SparseOffsetBuckets = llvm::DenseMap<int64_t, SmallVector<unsigned>>;
using SparseAddressGroups =
    llvm::DenseMap<SparseAddressKey, SparseOffsetBuckets>;

static SparseAddressGroups groupSparseAddresses(sym::Store &store,
                                                ArrayRef<SlotMapping> slots) {
  SparseAddressGroups groups;
  for (auto [index, slot] : llvm::enumerate(slots)) {
    ArrayRef<sym::PredHandle> assumptions = slot.assumptions;
    FailureOr<sym::ExprHandle> base =
        canonicalizeAddressExpr(store, slot.base, assumptions);
    FailureOr<sym::ExprHandle> targetBlock =
        canonicalizeAddressExpr(store, slot.targetBlock, assumptions);
    FailureOr<std::pair<sym::ExprHandle, int64_t>> offset =
        splitAddressConstant(store, slot.bitOffset, assumptions);
    if (failed(base) || failed(targetBlock) || failed(offset))
      continue;
    SparseAddressKey key{*base, {*targetBlock, offset->first}};
    groups[key][offset->second].push_back(index);
  }
  return groups;
}

static void
appendSparseGroupEdges(sym::Store &store, ArrayRef<SlotMapping> slots,
                       SparseOffsetBuckets &buckets, int64_t elementBits,
                       SmallVectorImpl<SmallVector<unsigned>> &edges,
                       RemainderProofContext &proofContext) {
  for (auto &bucket : buckets) {
    int64_t offset = bucket.first;
    if (offset > std::numeric_limits<int64_t>::max() - elementBits)
      continue;
    auto successor = buckets.find(offset + elementBits);
    if (successor == buckets.end())
      continue;
    for (unsigned lhs : bucket.second)
      for (unsigned rhs : successor->second)
        if (adjacent(store, slots[lhs], slots[rhs], elementBits, proofContext))
          edges[lhs].push_back(rhs);
  }
}

static SmallVector<SmallVector<unsigned>>
buildSparseSuccessorGraph(sym::Store &store, ArrayRef<SlotMapping> slots,
                          int64_t elementBits,
                          RemainderProofContext &proofContext) {
  SparseAddressGroups groups = groupSparseAddresses(store, slots);
  SmallVector<SmallVector<unsigned>> edges(slots.size());
  for (auto &group : groups)
    appendSparseGroupEdges(store, slots, group.second, elementBits, edges,
                           proofContext);
  return edges;
}

static void
appendLogicalPacketEdges(sym::Store &store, ArrayRef<SlotMapping> slots,
                         int64_t elementBits,
                         RemainderProofContext &proofContext,
                         SmallVectorImpl<SmallVector<unsigned>> &edges) {
  llvm::DenseMap<unsigned, SmallVector<unsigned>> nodesByLogicalSlot;
  for (auto [node, slot] : llvm::enumerate(slots))
    for (unsigned logicalSlot : slot.logicalSlots)
      nodesByLogicalSlot[logicalSlot].push_back(node);
  for (auto [lhs, slot] : llvm::enumerate(slots)) {
    for (unsigned logicalSlot : slot.logicalSlots) {
      auto successors = nodesByLogicalSlot.find(logicalSlot + 1);
      if (successors == nodesByLogicalSlot.end())
        continue;
      for (unsigned rhs : successors->second)
        if (lhs != rhs && !llvm::is_contained(edges[lhs], rhs) &&
            adjacent(store, slots[lhs], slots[rhs], elementBits, proofContext))
          edges[lhs].push_back(rhs);
    }
  }
}

static SmallVector<SmallVector<unsigned>>
buildSuccessorGraph(sym::Store &store, ArrayRef<SlotMapping> slots,
                    int64_t elementBits, RemainderProofContext &proofContext) {
  constexpr size_t denseLimit = 64;
  SmallVector<SmallVector<unsigned>> edges =
      slots.size() <= denseLimit
          ? buildDenseSuccessorGraph(store, slots, elementBits, proofContext)
          : buildSparseSuccessorGraph(store, slots, elementBits, proofContext);
  appendLogicalPacketEdges(store, slots, elementBits, proofContext, edges);
  return edges;
}

static SmallVector<SmallVector<unsigned>>
buildConnectedComponents(ArrayRef<SmallVector<unsigned>> edges) {
  SmallVector<SmallVector<unsigned>> neighbors(edges.size());
  for (auto [lhs, successors] : llvm::enumerate(edges)) {
    for (unsigned rhs : successors) {
      neighbors[lhs].push_back(rhs);
      neighbors[rhs].push_back(lhs);
    }
  }

  SmallVector<SmallVector<unsigned>> components;
  SmallVector<uint8_t> visited(edges.size(), 0);
  for (unsigned start = 0; start < edges.size(); ++start) {
    if (visited[start])
      continue;
    SmallVector<unsigned> component;
    SmallVector<unsigned> worklist{start};
    visited[start] = 1;
    while (!worklist.empty()) {
      unsigned node = worklist.pop_back_val();
      component.push_back(node);
      for (unsigned neighbor : neighbors[node]) {
        if (visited[neighbor])
          continue;
        visited[neighbor] = 1;
        worklist.push_back(neighbor);
      }
    }
    llvm::sort(component);
    components.push_back(std::move(component));
  }
  return components;
}

static SmallVector<SmallVector<unsigned>>
buildComponentGraph(ArrayRef<SmallVector<unsigned>> edges,
                    ArrayRef<unsigned> component) {
  SmallVector<int64_t> localIndex(edges.size(), -1);
  for (auto [local, global] : llvm::enumerate(component))
    localIndex[global] = local;

  SmallVector<SmallVector<unsigned>> localEdges(component.size());
  for (auto [local, global] : llvm::enumerate(component)) {
    for (unsigned successor : edges[global]) {
      assert(localIndex[successor] >= 0 &&
             "component must contain successor endpoints");
      localEdges[local].push_back(static_cast<unsigned>(localIndex[successor]));
    }
  }
  return localEdges;
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
findMatchingCover(ArrayRef<SmallVector<unsigned>> edges, int64_t elementBits) {
  SmallVector<SmallVector<unsigned>> transactions;
  for (ArrayRef<unsigned> chain : buildContiguousChains(edges)) {
    SmallVector<SmallVector<unsigned>> cover = coverChain(chain, elementBits);
    if (cover.empty())
      return failure();
    llvm::append_range(transactions, std::move(cover));
  }
  return transactions;
}

static FailureOr<SmallVector<SmallVector<unsigned>>>
planTransactions(sym::Store &store, ArrayRef<SlotMapping> slots,
                 int64_t elementBits, RemainderProofContext &proofContext) {
  SmallVector<SmallVector<unsigned>> edges =
      buildSuccessorGraph(store, slots, elementBits, proofContext);
  SmallVector<SmallVector<unsigned>> transactions;
  for (ArrayRef<unsigned> component : buildConnectedComponents(edges)) {
    SmallVector<SmallVector<unsigned>> localEdges =
        buildComponentGraph(edges, component);
    FailureOr<SmallVector<SmallVector<unsigned>>> cover =
        findExactCover(localEdges, elementBits);
    if (failed(cover))
      cover = findMatchingCover(localEdges, elementBits);
    if (failed(cover))
      return failure();
    for (ArrayRef<unsigned> localTransaction : *cover) {
      SmallVector<unsigned> transaction;
      transaction.reserve(localTransaction.size());
      for (unsigned local : localTransaction)
        transaction.push_back(component[local]);
      transactions.push_back(std::move(transaction));
    }
  }
  return transactions;
}

static FailureOr<GatherPlan>
buildGenericGatherPlan(const MemoryAccess &access, sym::Store &store,
                       ArrayRef<SlotMapping> mappings, int64_t elementBits,
                       RemainderProofContext &proofContext) {
  GatherPlan plan;
  plan.physicalSlots =
      access.packetWhere
          ? SmallVector<SlotMapping, 4>(mappings.begin(), mappings.end())
          : deduplicateGatherSlots(
                store,
                SmallVector<SlotMapping, 4>(mappings.begin(), mappings.end()));
  FailureOr<SmallVector<SmallVector<unsigned>>> transactions =
      planTransactions(store, plan.physicalSlots, elementBits, proofContext);
  if (failed(transactions))
    return failure();
  for (SmallVector<unsigned> &transaction : *transactions) {
    GatherCandidate candidate;
    candidate.width = transaction.size();
    candidate.singleton = transaction.size() == 1;
    candidate.physicalNodes = std::move(transaction);
    plan.selected.push_back(plan.candidates.size());
    plan.candidates.push_back(std::move(candidate));
  }
  return plan;
}

static SmallVector<wave::memory_lowering::GatherTransactionCandidate>
getProviderGatherCandidates(const MemoryAccess &access, sym::Store &store,
                            ArrayRef<SlotMapping> mappings) {
  SmallVector<SmallVector<wave::memory_lowering::MemoryTransactionBinding>>
      bindingStorage;
  bindingStorage.reserve(mappings.size());
  for (const SlotMapping &mapping : mappings) {
    SmallVector<wave::memory_lowering::MemoryTransactionBinding> bindings;
    bindings.reserve(mapping.bindings.size());
    for (const NamedBinding &binding : mapping.bindings)
      bindings.push_back({binding.name, binding.value});
    bindingStorage.push_back(std::move(bindings));
  }

  SmallVector<wave::memory_lowering::MemoryTransactionPoint> points;
  points.reserve(mappings.size());
  for (auto [index, mapping] : llvm::enumerate(mappings))
    points.push_back({bindingStorage[index], mapping.assumptions, mapping.base,
                      mapping.targetBlock, mapping.byteOffset,
                      mapping.baseIndex});

  wave::memory_lowering::GatherTransactionRequest request;
  request.bases = access.bases;
  request.points = points;
  request.op = access.op;
  request.store = &store;
  request.resultType = access.packetType;
  request.dependency = access.dependency;
  request.cache = access.cache;
  request.tokenType = access.tokenType;
  SmallVector<std::unique_ptr<wave::memory_lowering::GatherTransactionProvider>>
      providers;
  wave::memory_lowering::populateGatherTransactionProviders(providers);
  SmallVector<wave::memory_lowering::GatherTransactionCandidate> candidates;
  for (const auto &provider : providers)
    provider->enumerate(request, candidates);
  return candidates;
}

static ExactCoverResult
solveGatherExactCover(uint64_t mask, uint64_t fullMask,
                      ArrayRef<GatherCandidate> candidates,
                      ArrayRef<SmallVector<unsigned>> candidatesBySlot,
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
  for (unsigned candidateIndex : candidatesBySlot[first]) {
    const GatherCandidate &candidate = candidates[candidateIndex];
    if (mask & candidate.mask)
      continue;
    ExactCoverResult tail = solveGatherExactCover(
        mask | candidate.mask, fullMask, candidates, candidatesBySlot, memo);
    if (!tail.valid)
      continue;
    CoverState score{tail.score.singletons + candidate.singleton,
                     tail.score.transactions + 1,
                     tail.score.widthScore + candidate.width * candidate.width,
                     candidate.width};
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

static bool setGatherCandidateMask(GatherCandidate &candidate,
                                   int64_t slotCount) {
  for (unsigned slot : candidate.logicalSlots) {
    if (slot >= static_cast<uint64_t>(slotCount))
      return false;
    uint64_t bit = uint64_t{1} << slot;
    if (candidate.mask & bit)
      return false;
    candidate.mask |= bit;
  }
  return candidate.mask != 0;
}

static void
appendGenericGatherCandidates(GatherPlan &plan,
                              ArrayRef<TransactionCandidate> transactions,
                              int64_t slotCount) {
  for (const TransactionCandidate &transaction : transactions) {
    GatherCandidate candidate;
    candidate.physicalNodes = transaction.nodes;
    candidate.width = transaction.nodes.size();
    candidate.singleton = transaction.nodes.size() == 1;
    for (unsigned node : transaction.nodes)
      llvm::append_range(candidate.logicalSlots,
                         plan.physicalSlots[node].logicalSlots);
    llvm::sort(candidate.logicalSlots);
    candidate.logicalSlots.erase(std::unique(candidate.logicalSlots.begin(),
                                             candidate.logicalSlots.end()),
                                 candidate.logicalSlots.end());
    if (setGatherCandidateMask(candidate, slotCount))
      plan.candidates.push_back(std::move(candidate));
  }
}

static void appendProviderGatherCandidates(
    GatherPlan &plan,
    SmallVectorImpl<wave::memory_lowering::GatherTransactionCandidate>
        &transactions,
    int64_t slotCount) {
  for (wave::memory_lowering::GatherTransactionCandidate &transaction :
       transactions) {
    GatherCandidate candidate;
    candidate.logicalSlots = transaction.slots;
    candidate.width = transaction.slots.size();
    candidate.singleton = transaction.slots.size() == 1;
    candidate.provider =
        std::make_unique<wave::memory_lowering::GatherTransactionCandidate>(
            std::move(transaction));
    if (setGatherCandidateMask(candidate, slotCount))
      plan.candidates.push_back(std::move(candidate));
  }
}

static LogicalResult selectGatherCover(GatherPlan &plan, int64_t slotCount) {
  SmallVector<SmallVector<unsigned>> candidatesBySlot(slotCount);
  for (auto [candidateIndex, candidate] : llvm::enumerate(plan.candidates))
    for (unsigned slot : candidate.logicalSlots)
      candidatesBySlot[slot].push_back(candidateIndex);
  uint64_t fullMask = (uint64_t{1} << slotCount) - 1;
  llvm::DenseMap<uint64_t, ExactCoverResult> memo;
  ExactCoverResult cover = solveGatherExactCover(0, fullMask, plan.candidates,
                                                 candidatesBySlot, memo);
  if (!cover.valid)
    return failure();
  plan.selected = std::move(cover.candidates);
  return success();
}

static FailureOr<GatherPlan>
planGatherTransactions(const MemoryAccess &access, sym::Store &store,
                       ArrayRef<SlotMapping> mappings, int64_t elementBits,
                       RemainderProofContext &proofContext) {
  SmallVector<wave::memory_lowering::GatherTransactionCandidate>
      providerCandidates = getProviderGatherCandidates(access, store, mappings);
  if (access.packetWhere)
    return buildGenericGatherPlan(access, store, mappings, elementBits,
                                  proofContext);
  if (providerCandidates.empty() || mappings.size() > kMaxExactCoverNodes)
    return buildGenericGatherPlan(access, store, mappings, elementBits,
                                  proofContext);

  GatherPlan plan;
  plan.physicalSlots = deduplicateGatherSlots(
      store, SmallVector<SlotMapping, 4>(mappings.begin(), mappings.end()));
  SmallVector<SmallVector<unsigned>> edges =
      buildSuccessorGraph(store, plan.physicalSlots, elementBits, proofContext);
  FailureOr<SmallVector<TransactionCandidate>> genericCandidates =
      enumerateTransactionCandidates(edges, elementBits);
  if (failed(genericCandidates))
    return buildGenericGatherPlan(access, store, mappings, elementBits,
                                  proofContext);

  appendGenericGatherCandidates(plan, *genericCandidates, mappings.size());
  appendProviderGatherCandidates(plan, providerCandidates, mappings.size());
  if (failed(selectGatherCover(plan, mappings.size())))
    return buildGenericGatherPlan(access, store, mappings, elementBits,
                                  proofContext);
  return plan;
}

static bool isLegalPtrAddOffset(Type type) {
  if (type.isIndex())
    return true;
  if (IntegerType integer = dyn_cast<IntegerType>(type))
    return integer.getWidth() == 32 || integer.getWidth() == 64;
  SimdType simd = dyn_cast<SimdType>(type);
  return simd && (simd.getElementType().isIndex() ||
                  simd.getElementType().isInteger(32));
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

  StringRef symbol = sym::ExprView(expr).getSymbolName();
  if (!symbol.empty())
    for (const NamedBinding &binding : slot.bindings)
      if (binding.name == symbol &&
          isLegalPtrAddOffset(binding.value.getType()))
        return binding.value;

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

static Value findElementOffsetMaterialization(const SlotMapping &slot,
                                              sym::ExprHandle byteOffset,
                                              int64_t elementBits,
                                              sym::Store &store) {
  if (elementBits <= 0 || elementBits % 8 != 0)
    return {};
  FailureOr<sym::ExprHandle> elementOffset =
      divideExactly(store, byteOffset, elementBits / 8, slot.assumptions);
  if (failed(elementOffset))
    return {};
  FailureOr<sym::ExprHandle> materializationElementOffset = divideExactly(
      store, slot.materializationBitOffset, elementBits, slot.assumptions);
  for (const MaterializationCandidate &candidate :
       slot.materializationCandidates) {
    if (!isLegalPtrAddOffset(candidate.value.getType()))
      continue;
    if ((succeeded(materializationElementOffset) &&
         proveEqual(store, *materializationElementOffset, candidate.expression,
                    slot.assumptions)) ||
        proveEqual(store, *elementOffset, candidate.expression,
                   slot.assumptions))
      return candidate.value;
  }
  return {};
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

static void materializePredicatedByteBases(IRRewriter &rewriter,
                                           const MemoryAccess &access,
                                           SmallVectorImpl<Value> &byteBases) {
  if (!access.packetWhere)
    return;
  for (unsigned index : llvm::seq<unsigned>(0, access.bases.size()))
    (void)getByteBase(rewriter, access, index, byteBases);
}

static std::optional<int64_t>
getTypedPointerElementBits(const MemoryAccess &access, unsigned baseIndex) {
  PtrType sourceType = cast<PtrType>(access.bases[baseIndex].getType());
  VectorType packet = cast<VectorType>(access.packetType.getElementType());
  Type sourceElement = sourceType.getElementType();
  if (!sourceElement)
    return std::nullopt;
  if (sourceElement != packet.getElementType())
    return std::nullopt;
  if (!sourceElement.isIntOrFloat())
    return std::nullopt;
  int64_t elementBits = sourceElement.getIntOrFloatBitWidth();
  if (elementBits <= 0)
    return std::nullopt;
  if (elementBits % 8 != 0)
    return std::nullopt;
  return elementBits;
}

static Type getPointerAddResultType(MLIRContext *context, PtrType pointerType,
                                    Value offset) {
  if (SimdType simd = dyn_cast<SimdType>(offset.getType()))
    return SimdType::get(context, pointerType, simd.getWidth());
  return pointerType;
}

static FailureOr<Value>
materializeTypedPointer(IRRewriter &rewriter, const MemoryAccess &access,
                        const SlotMapping &slot, sym::ExprHandle byteOffset,
                        int64_t baseIndex, sym::Store &store) {
  Value source = access.bases[baseIndex];
  PtrType sourceType = cast<PtrType>(source.getType());
  std::optional<int64_t> elementBits =
      getTypedPointerElementBits(access, baseIndex);
  if (!elementBits)
    return failure();
  if (Value candidate = findElementOffsetMaterialization(slot, byteOffset,
                                                         *elementBits, store)) {
    Type resultType =
        getPointerAddResultType(access.op->getContext(), sourceType, candidate);
    return PtrAddOp::create(rewriter, access.op->getLoc(), resultType, source,
                            candidate)
        .getResult();
  }
  FailureOr<sym::ExprHandle> elementOffset =
      divideExactly(store, byteOffset, *elementBits / 8, slot.assumptions);
  if (failed(elementOffset))
    return failure();
  FailureOr<Value> offset =
      materializeExpr(rewriter, access, slot, *elementOffset);
  if (failed(offset))
    return failure();
  Type resultType =
      getPointerAddResultType(access.op->getContext(), sourceType, *offset);
  return PtrAddOp::create(rewriter, access.op->getLoc(), resultType, source,
                          *offset)
      .getResult();
}

static FailureOr<Value> materializePointer(IRRewriter &rewriter,
                                           const MemoryAccess &access,
                                           const SlotMapping &slot,
                                           sym::ExprHandle byteOffset,
                                           int64_t baseIndex, sym::Store &store,
                                           SmallVectorImpl<Value> &byteBases) {
  FailureOr<Value> typed = materializeTypedPointer(
      rewriter, access, slot, byteOffset, baseIndex, store);
  if (succeeded(typed))
    return typed;
  Value byteBase = getByteBase(rewriter, access, baseIndex, byteBases);

  if (std::optional<int64_t> literal = sym::getIntegerLiteralValue(byteOffset))
    if (*literal == 0)
      return byteBase;

  FailureOr<Value> offset = materializeExpr(rewriter, access, slot, byteOffset);
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

static FailureOr<Value> materializePointer(IRRewriter &rewriter,
                                           const MemoryAccess &access,
                                           const SlotMapping &slot,
                                           sym::Store &store,
                                           SmallVectorImpl<Value> &byteBases) {
  return materializePointer(rewriter, access, slot, slot.byteOffset,
                            slot.baseIndex, store, byteBases);
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

struct PredicatedLoadResult {
  Value value;
  Value token;
};

static SlotMapping buildTransactionPoint(ArrayRef<SlotMapping> slots,
                                         ArrayRef<unsigned> transaction,
                                         unsigned addressPoint) {
  SlotMapping point = slots[addressPoint];
  for (unsigned nodeIndex : transaction) {
    const SlotMapping &slot = slots[nodeIndex];
    for (const NamedBinding &binding : slot.bindings) {
      auto existing =
          llvm::find_if(point.bindings, [&](const NamedBinding &it) {
            return it.name == binding.name;
          });
      if (existing == point.bindings.end()) {
        point.bindings.push_back(binding);
        continue;
      }
      assert(existing->value == binding.value &&
             "canonical binding names must identify one value");
    }
    for (sym::PredHandle assumption : slot.assumptions)
      if (!llvm::is_contained(point.assumptions, assumption))
        point.assumptions.push_back(assumption);
  }
  return point;
}

static FailureOr<PredicatedLoadResult>
emitPredicatedLoad(IRRewriter &rewriter, const MemoryAccess &access,
                   sym::Store &store, const SlotMapping &point,
                   SmallVectorImpl<Value> &byteBases, Value condition,
                   Type valueType, Value inactiveValue) {
  SmallVector<Type> resultTypes{valueType, access.tokenType};
  WhereOp where = WhereOp::create(rewriter, access.op->getLoc(), resultTypes,
                                  ValueRange{condition});
  Block &thenBlock = where.getThenRegion().emplaceBlock();
  rewriter.setInsertionPointToStart(&thenBlock);
  FailureOr<Value> ptr =
      materializePointer(rewriter, access, point, store, byteBases);
  if (failed(ptr))
    return failure();
  LoadOp load =
      LoadOp::create(rewriter, access.op->getLoc(), valueType, access.tokenType,
                     *ptr, access.dependency, access.cache);
  YieldOp::create(rewriter, access.op->getLoc(),
                  ValueRange{load.getValue(), load.getToken()});
  Block &elseBlock = where.getElseRegion().emplaceBlock();
  rewriter.setInsertionPointToStart(&elseBlock);
  YieldOp::create(rewriter, access.op->getLoc(),
                  ValueRange{inactiveValue, access.inactiveToken});
  rewriter.setInsertionPointAfter(where);
  return PredicatedLoadResult{where.getResult(0), where.getResult(1)};
}

static Value buildInactivePacketValue(IRRewriter &rewriter,
                                      const MemoryAccess &access,
                                      ArrayRef<unsigned> logicalSlots,
                                      Type valueType) {
  SmallVector<Value> values;
  values.reserve(logicalSlots.size());
  for (unsigned logicalSlot : logicalSlots) {
    assert(logicalSlot < access.inactiveComponents.size() &&
           "inactive packet slot must exist");
    values.push_back(access.inactiveComponents[logicalSlot]);
  }
  if (values.size() == 1)
    return values.front();
  return PackOp::create(rewriter, access.op->getLoc(), valueType, values);
}

static Value buildInactiveTransactionValue(IRRewriter &rewriter,
                                           const MemoryAccess &access,
                                           ArrayRef<SlotMapping> slots,
                                           ArrayRef<unsigned> transaction,
                                           Type valueType) {
  SmallVector<unsigned> logicalSlots;
  logicalSlots.reserve(transaction.size());
  for (unsigned nodeIndex : transaction) {
    ArrayRef<unsigned> nodeSlots = slots[nodeIndex].logicalSlots;
    assert(nodeSlots.size() == 1 &&
           "packet-predicated gather must retain logical slots");
    logicalSlots.push_back(nodeSlots.front());
  }
  return buildInactivePacketValue(rewriter, access, logicalSlots, valueType);
}

static FailureOr<Value> emitPredicatedStore(IRRewriter &rewriter,
                                            const MemoryAccess &access,
                                            sym::Store &symbolStore,
                                            const SlotMapping &point,
                                            SmallVectorImpl<Value> &byteBases,
                                            Value condition, Value value) {
  WhereOp where =
      WhereOp::create(rewriter, access.op->getLoc(),
                      TypeRange{access.tokenType}, ValueRange{condition});
  Block &thenBlock = where.getThenRegion().emplaceBlock();
  rewriter.setInsertionPointToStart(&thenBlock);
  FailureOr<Value> ptr =
      materializePointer(rewriter, access, point, symbolStore, byteBases);
  if (failed(ptr))
    return failure();
  StoreOp store =
      StoreOp::create(rewriter, access.op->getLoc(), access.tokenType, value,
                      *ptr, access.dependency, access.cache);
  YieldOp::create(rewriter, access.op->getLoc(), store.getToken());
  Block &elseBlock = where.getElseRegion().emplaceBlock();
  rewriter.setInsertionPointToStart(&elseBlock);
  YieldOp::create(rewriter, access.op->getLoc(), access.inactiveToken);
  rewriter.setInsertionPointAfter(where);
  return where.getResult(0);
}

struct GatherEmissionState {
  SmallVector<Value> components;
  SmallVector<Value> tokens;
  SmallVector<Value> byteBases;
  Value directResult;
};

static bool hasNaturalSlotOrder(ArrayRef<unsigned> slots, int64_t slotCount) {
  if (slots.size() != static_cast<size_t>(slotCount))
    return false;
  return llvm::all_of(llvm::enumerate(slots), [](auto indexed) {
    return indexed.index() == indexed.value();
  });
}

static LogicalResult unpackTargetGatherResult(
    IRRewriter &rewriter, const MemoryAccess &access,
    const wave::memory_lowering::GatherTransactionCandidate &transaction,
    Value value, Type componentType, GatherEmissionState &state) {
  SimdType resultType = dyn_cast<SimdType>(value.getType());
  if (!resultType)
    return access.op->emitOpError("invalid target transaction result");
  VectorType resultVector = dyn_cast<VectorType>(resultType.getElementType());
  if (!resultVector || resultVector.getNumElements() !=
                           static_cast<int64_t>(transaction.slots.size()))
    return access.op->emitOpError("invalid target transaction result");
  for (auto [index, slot] : llvm::enumerate(transaction.slots))
    state.components[slot] = ExtractOp::create(rewriter, access.op->getLoc(),
                                               componentType, value, index);
  return success();
}

static LogicalResult emitProviderGatherCandidate(
    IRRewriter &rewriter, const MemoryAccess &access, sym::Store &store,
    ArrayRef<SlotMapping> mappings,
    const wave::memory_lowering::GatherTransactionCandidate &transaction,
    bool soleCandidate, int64_t slotCount, Type componentType,
    GatherEmissionState &state) {
  if (transaction.addressPoint >= mappings.size())
    return access.op->emitOpError("invalid target transaction address");
  SlotMapping point = buildTransactionPoint(mappings, transaction.slots,
                                            transaction.addressPoint);
  FailureOr<Value> ptr =
      materializePointer(rewriter, access, point, transaction.byteOffset,
                         transaction.baseIndex, store, state.byteBases);
  if (failed(ptr))
    return access.op->emitOpError("failed to materialize mapped address");
  FailureOr<wave::memory_lowering::GatherTransactionResult> result =
      transaction.emitter->emit(rewriter, access.op->getLoc(),
                                access.packetType, access.tokenType, *ptr,
                                access.dependency);
  if (failed(result))
    return failure();
  state.tokens.push_back(result->token);

  if (soleCandidate && hasNaturalSlotOrder(transaction.slots, slotCount)) {
    if (result->value.getType() != access.packetType)
      return access.op->emitOpError("invalid target transaction result");
    state.directResult = result->value;
    return success();
  }
  return unpackTargetGatherResult(rewriter, access, transaction, result->value,
                                  componentType, state);
}

static LogicalResult
emitGenericGatherCandidate(IRRewriter &rewriter, const MemoryAccess &access,
                           sym::Store &store, const GatherPlan &plan,
                           const GatherCandidate &candidate, Type componentType,
                           GatherEmissionState &state) {
  ArrayRef<unsigned> transaction = candidate.physicalNodes;
  SlotMapping point = buildTransactionPoint(plan.physicalSlots, transaction,
                                            transaction.front());
  Type valueType = getTransactionType(access, transaction.size());
  Value loadedValue;
  if (access.packetWhere) {
    Value inactiveValue = buildInactiveTransactionValue(
        rewriter, access, plan.physicalSlots, transaction, valueType);
    FailureOr<PredicatedLoadResult> load =
        emitPredicatedLoad(rewriter, access, store, point, state.byteBases,
                           point.packetCondition, valueType, inactiveValue);
    if (failed(load))
      return access.op->emitOpError("failed to materialize mapped address");
    loadedValue = load->value;
    state.tokens.push_back(load->token);
  } else {
    FailureOr<Value> ptr =
        materializePointer(rewriter, access, point, store, state.byteBases);
    if (failed(ptr))
      return access.op->emitOpError("failed to materialize mapped address");
    LoadOp load =
        LoadOp::create(rewriter, access.op->getLoc(), valueType,
                       access.tokenType, *ptr, access.dependency, access.cache);
    loadedValue = load.getValue();
    state.tokens.push_back(load.getToken());
  }
  for (auto [physicalIndex, nodeIndex] : llvm::enumerate(transaction)) {
    Value value = loadedValue;
    if (transaction.size() > 1)
      value = ExtractOp::create(rewriter, access.op->getLoc(), componentType,
                                value, physicalIndex);
    for (unsigned logicalSlot : plan.physicalSlots[nodeIndex].logicalSlots)
      state.components[logicalSlot] = value;
  }
  return success();
}

static FailureOr<Value> buildGatherResult(IRRewriter &rewriter,
                                          const MemoryAccess &access,
                                          GatherEmissionState &state) {
  if (state.directResult)
    return state.directResult;
  if (llvm::any_of(state.components, [](Value value) { return !value; })) {
    access.op->emitOpError("failed to cover every gathered packet slot");
    return failure();
  }
  return PackOp::create(rewriter, access.op->getLoc(), access.packetType,
                        state.components)
      .getResult();
}

static LogicalResult lowerGather(IRRewriter &rewriter,
                                 const MemoryAccess &access, sym::Store &store,
                                 ArrayRef<SlotMapping> mappings,
                                 const GatherPlan &plan) {
  VectorType packet = cast<VectorType>(access.packetType.getElementType());
  GatherEmissionState state{SmallVector<Value>(packet.getNumElements()),
                            {},
                            SmallVector<Value>(access.bases.size()),
                            {}};
  materializePredicatedByteBases(rewriter, access, state.byteBases);
  Type componentType = getComponentType(access);

  for (unsigned candidateIndex : plan.selected) {
    const GatherCandidate &candidate = plan.candidates[candidateIndex];
    LogicalResult emitted =
        candidate.provider
            ? emitProviderGatherCandidate(
                  rewriter, access, store, mappings, *candidate.provider,
                  plan.selected.size() == 1, packet.getNumElements(),
                  componentType, state)
            : emitGenericGatherCandidate(rewriter, access, store, plan,
                                         candidate, componentType, state);
    if (failed(emitted))
      return failure();
  }

  FailureOr<Value> result = buildGatherResult(rewriter, access, state);
  if (failed(result))
    return failure();
  Value token = joinTokens(rewriter, access, state.tokens);
  if (access.packetWhere)
    rewriter.replaceOp(access.packetWhere, {*result, token});
  else
    rewriter.replaceOp(access.op, {*result, token});
  return success();
}

static LogicalResult
lowerScatter(IRRewriter &rewriter, const MemoryAccess &access,
             sym::Store &store, ArrayRef<SlotMapping> slots,
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
  materializePredicatedByteBases(rewriter, access, byteBases);
  for (ArrayRef<unsigned> transaction : transactions) {
    SlotMapping point =
        buildTransactionPoint(slots, transaction, transaction.front());
    SmallVector<Value> values;
    values.reserve(transaction.size());
    for (unsigned nodeIndex : transaction)
      values.push_back(components[slots[nodeIndex].logicalSlots.front()]);
    Value value = values.front();
    if (values.size() > 1)
      value = PackOp::create(rewriter, access.op->getLoc(),
                             getTransactionType(access, values.size()), values);
    if (access.packetWhere) {
      FailureOr<Value> token =
          emitPredicatedStore(rewriter, access, store, point, byteBases,
                              point.packetCondition, value);
      if (failed(token))
        return access.op->emitOpError("failed to materialize mapped address");
      tokens.push_back(*token);
    } else {
      FailureOr<Value> ptr =
          materializePointer(rewriter, access, point, store, byteBases);
      if (failed(ptr))
        return access.op->emitOpError("failed to materialize mapped address");
      StoreOp store =
          StoreOp::create(rewriter, access.op->getLoc(), access.tokenType,
                          value, *ptr, access.dependency, access.cache);
      tokens.push_back(store.getToken());
    }
  }

  Value token = joinTokens(rewriter, access, tokens);
  if (!access.packetWhere) {
    rewriter.replaceOp(access.op, token);
  } else if (access.packetWhere->getNumResults() == 1) {
    rewriter.replaceOp(access.packetWhere, token);
  } else {
    rewriter.eraseOp(access.packetWhere);
  }
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
  if (!isa<GlobalAddressSpaceAttr, SharedAddressSpaceAttr,
           waveamd::BufferAddressSpaceAttr>(addressSpace)) {
    access.op->emitOpError(
        "lowering requires global, shared, or AMD buffer pointer bases");
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

static bool coordinatesHaveSymbol(const MappingCoordinates &coordinates,
                                  StringRef name) {
  return hasSymbol(coordinates.base, name) ||
         hasSymbol(coordinates.targetBlock, name) ||
         hasSymbol(coordinates.bitOffset, name);
}

static bool mappingNeedsItemAfterSlotSpecialization(
    const MemoryAccess &access, sym::Store &store, const MappingDomain &domain,
    int64_t slotCount, ArrayRef<sym::ExprSubstitution> bindingSubstitutions) {
  if (!mappingHasSymbol(access.mapping, "item"))
    return false;
  MappingCoordinates coordinates =
      getMappingCoordinates(access, domain.block, domain.zero);
  for (int64_t slot : llvm::seq<int64_t>(0, slotCount)) {
    FailureOr<sym::ExprHandle> slotValue = sym::composeExprInt(store, slot);
    if (failed(slotValue))
      return true;
    SmallVector<sym::ExprSubstitution> substitutions(bindingSubstitutions);
    substitutions.push_back({domain.slot, *slotValue});
    FailureOr<MappingCoordinates> specialized =
        specializeCoordinates(store, coordinates, substitutions, {});
    if (failed(specialized) || coordinatesHaveSymbol(*specialized, "item"))
      return true;
  }
  return false;
}

static FailureOr<MappedItem> getMappedItem(IRRewriter &rewriter,
                                           const MemoryAccess &access,
                                           sym::Store &store, bool needsItem) {
  if (!needsItem)
    return MappedItem{};
  return materializeItem(rewriter, access, store);
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

static FailureOr<SmallVector<PacketComponents, 4>>
buildPacketComponents(IRRewriter &rewriter, const MemoryAccess &access,
                      int64_t slotCount, WaveDialect &dialect,
                      DataFlowSolver &solver) {
  SmallVector<PacketComponents, 4> packetComponents;
  packetComponents.reserve(access.packetBindings.size());
  for (const PacketBinding &binding : access.packetBindings) {
    SmallVector<Value> values;
    if (binding.values.size() == 1 &&
        isa<VectorType>(cast<SimdType>(binding.values.front().getType())
                            .getElementType())) {
      values = getPacketComponentValues(rewriter, access,
                                        binding.values.front(), slotCount);
    } else {
      llvm::append_range(values, binding.values);
    }
    if (values.size() != static_cast<size_t>(slotCount)) {
      access.op->emitOpError("packet binding component count does not match "
                             "the accessed packet");
      return failure();
    }
    FailureOr<SmallVector<SymbolicOffset>> components =
        buildPacketComponentOffsets(access, values, dialect, solver);
    if (failed(components))
      return failure();
    packetComponents.push_back(
        PacketComponents{std::move(values), std::move(*components)});
  }
  return packetComponents;
}

static SmallVector<ControlCondition> collectControlConditions(Operation *op) {
  SmallVector<ControlCondition> conditions;
  Operation *child = op;
  for (Operation *parent = child->getParentOp(); parent;
       child = parent, parent = parent->getParentOp()) {
    Region *region = child->getParentRegion();
    if (WhereOp where = dyn_cast<WhereOp>(parent)) {
      if (where.getConditions().size() != 1)
        continue;
      if (region == &where.getThenRegion())
        conditions.push_back({where.getCondition(), false});
      else if (region == &where.getElseRegion())
        conditions.push_back({where.getCondition(), true});
      continue;
    }
    if (scf::IfOp ifOp = dyn_cast<scf::IfOp>(parent)) {
      if (region == &ifOp.getThenRegion())
        conditions.push_back({ifOp.getCondition(), false});
      else if (region == &ifOp.getElseRegion())
        conditions.push_back({ifOp.getCondition(), true});
    }
  }
  std::reverse(conditions.begin(), conditions.end());
  return conditions;
}

static SmallVector<ActiveControl>
buildActiveControls(const MemoryAccess &access, WaveDialect &dialect,
                    DataFlowSolver &solver) {
  SmallVector<ActiveControl> controls;
  for (ControlCondition condition : collectControlConditions(access.op)) {
    FailureOr<std::optional<SymbolicPredicate>> predicate =
        buildSymbolicIndexPredicate(condition.value, dialect, solver);
    if (failed(predicate) || !*predicate)
      continue;
    controls.push_back({std::move(**predicate), condition.negated});
  }
  return controls;
}

static FailureOr<SmallVector<PacketControl>>
buildPacketControls(const MemoryAccess &access, WaveDialect &dialect,
                    DataFlowSolver &solver) {
  SmallVector<PacketControl> controls;
  controls.reserve(access.packetConditions.size());
  for (Value condition : access.packetConditions) {
    FailureOr<std::optional<SymbolicPredicate>> predicate =
        buildSymbolicIndexPredicate(condition, dialect, solver);
    if (failed(predicate))
      return failure();
    FailureOr<std::optional<SymbolicPredicate>> relationPredicate =
        buildSymbolicPacketPredicateRelation(condition, dialect, solver);
    if (failed(relationPredicate))
      return failure();
    std::unique_ptr<SymbolicPredicate> relation;
    if (*relationPredicate)
      relation =
          std::make_unique<SymbolicPredicate>(std::move(**relationPredicate));
    controls.push_back(
        PacketControl{std::move(*predicate), std::move(relation), condition});
  }
  return controls;
}

static FailureOr<SmallVector<SlotMapping, 4>> buildAccessSlotMappings(
    const MemoryAccess &access, sym::Store &store, const MappingDomain &domain,
    int64_t slotCount, const MappedItem &item,
    ArrayRef<sym::ExprSubstitution> bindingSubstitutions,
    ArrayRef<PacketComponents> packetComponents,
    ArrayRef<ActiveControl> controls, ArrayRef<PacketControl> packetControls) {
  PacketBindingState bindingState;
  seedPacketBindingState(access, item, bindingState);
  SmallVector<SlotMapping, 4> mappings;
  mappings.reserve(slotCount);
  for (int64_t index : llvm::seq<int64_t>(0, slotCount)) {
    FailureOr<SlotMapping> mapping = buildSlotMapping(
        access, store, domain.block, domain.slot, domain.zero, index, item,
        bindingSubstitutions, packetComponents, controls,
        packetControls.empty() ? nullptr : &packetControls[index],
        bindingState);
    if (failed(mapping)) {
      access.op->emitOpError(
          "mapping is not a defined, byte-addressable local memory point");
      return failure();
    }
    mappings.push_back(std::move(*mapping));
  }
  return mappings;
}

static FailureOr<PreparedAccessMappings>
prepareAccessMappings(IRRewriter &rewriter, MemoryAccess &access,
                      WaveDialect &dialect, DataFlowSolver &solver) {
  FailureOr<AccessShape> shape = getAccessShape(access);
  if (failed(shape))
    return failure();
  if (failed(preparePacketPredication(rewriter, access, shape->slotCount)))
    return failure();
  sym::Store &store = dialect.getSymbolStore();
  FailureOr<MappingDomain> domain = getMappingDomain(store);
  if (failed(domain))
    return access.op->emitOpError("failed to construct mapping domain");
  FailureOr<SmallVector<sym::ExprSubstitution>> bindingSubstitutions =
      buildConstantBindingSubstitutions(access, store, solver);
  if (failed(bindingSubstitutions))
    return failure();
  bool needsItem = mappingNeedsItemAfterSlotSpecialization(
      access, store, *domain, shape->slotCount, *bindingSubstitutions);
  FailureOr<MappedItem> item =
      getMappedItem(rewriter, access, store, needsItem);
  if (failed(item))
    return failure();
  FailureOr<SmallVector<PacketComponents, 4>> packetComponents =
      buildPacketComponents(rewriter, access, shape->slotCount, dialect,
                            solver);
  if (failed(packetComponents))
    return failure();
  SmallVector<ActiveControl> controls =
      buildActiveControls(access, dialect, solver);
  FailureOr<SmallVector<PacketControl>> packetControls =
      buildPacketControls(access, dialect, solver);
  if (failed(packetControls))
    return access.op->emitOpError(
        "failed to analyze symbolic memory packet predicates");
  FailureOr<SmallVector<SlotMapping, 4>> mappings = buildAccessSlotMappings(
      access, store, *domain, shape->slotCount, *item, *bindingSubstitutions,
      *packetComponents, controls, *packetControls);
  if (failed(mappings))
    return failure();
  return PreparedAccessMappings{std::move(*mappings), *shape};
}

static LogicalResult lowerAccess(IRRewriter &rewriter, MemoryAccess &access,
                                 WaveDialect &dialect, DataFlowSolver &solver) {
  FailureOr<PreparedAccessMappings> prepared =
      prepareAccessMappings(rewriter, access, dialect, solver);
  if (failed(prepared))
    return failure();
  sym::Store &store = dialect.getSymbolStore();
  RemainderProofContext proofContext(dialect, solver, access.op,
                                     prepared->mappings);
  if (access.packetWhere)
    rewriter.setInsertionPoint(access.packetWhere);
  if (access.gather) {
    FailureOr<GatherPlan> plan =
        planGatherTransactions(access, store, prepared->mappings,
                               prepared->shape.elementBits, proofContext);
    if (failed(plan))
      return access.op->emitOpError(
          "packet cannot be covered by legal memory transactions");
    return lowerGather(rewriter, access, store, prepared->mappings, *plan);
  }
  FailureOr<SmallVector<SmallVector<unsigned>>> transactions = planTransactions(
      store, prepared->mappings, prepared->shape.elementBits, proofContext);
  if (failed(transactions))
    return access.op->emitOpError(
        "packet cannot be covered by legal memory transactions");
  return lowerScatter(rewriter, access, store, prepared->mappings,
                      *transactions);
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
