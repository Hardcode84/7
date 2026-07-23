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
#include "mlir/Support/Timing.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/Hashing.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/CheckedArithmetic.h"
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

struct SymbolicMemoryStageTimingManager {
  SymbolicMemoryStageTimingManager() {
    applyDefaultTimingManagerCLOptions(manager);
  }

  DefaultTimingManager manager;
};

static DefaultTimingManager &getSymbolicMemoryStageTimingManager() {
  static SymbolicMemoryStageTimingManager timing;
  return timing.manager;
}

struct SymbolicMemoryStageTiming {
  SymbolicMemoryStageTiming() {
    rootScope = getSymbolicMemoryStageTimingManager().getRootScope();
    stageScope = rootScope.nest("wave_lower_symbolic_memory_stages");
  }

  TimingScope nest(StringRef name) { return stageScope.nest(name); }

  TimingScope rootScope;
  TimingScope stageScope;
};

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
  std::optional<sym::SplitAdditiveConstant> proofOffset;
  sym::PredHandle activationRelationPredicate;
  Value packetCondition;
  sym::ExprHandle base;
  sym::ExprHandle targetBlock;
  sym::ExprHandle bitOffset;
  sym::ExprHandle materializationBitOffset;
  sym::ExprHandle byteOffset;
  sym::ExprHandle materializationByteOffset;
  size_t proofIndex = std::numeric_limits<size_t>::max();
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
simplifyForMaterialization(sym::Analysis &analysis, sym::ExprHandle expr) {
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(expr);
  if (failed(simplified))
    return failure();
  return shouldUseSimplifiedIndexExpr(*simplified, expr) ? *simplified : expr;
}

static FailureOr<sym::ExprHandle> divideExactlyProof(sym::Analysis &analysis,
                                                     sym::ExprHandle value,
                                                     int64_t divisor) {
  sym::ExactDivideResult result = analysis.tryExactDivide(value, divisor);
  if (result.status != sym::ExactDivideStatus::Proven || !result.quotient)
    return failure();
  if (analysis.defined(value) != sym::CheckResult::True ||
      analysis.defined(result.quotient) != sym::CheckResult::True)
    return failure();
  return result.quotient;
}

static FailureOr<sym::ExprHandle>
divideExactlyForMaterialization(sym::Analysis &analysis, sym::ExprHandle value,
                                int64_t divisor) {
  FailureOr<sym::ExprHandle> proof =
      divideExactlyProof(analysis, value, divisor);
  if (failed(proof))
    return failure();
  FailureOr<sym::ExprHandle> divisorExpr = analysis.composeInteger(divisor);
  if (failed(divisorExpr))
    return failure();
  FailureOr<sym::ExprHandle> materialization =
      analysis.compose(value, sym::ExprBinaryOp::Div, *divisorExpr);
  if (failed(materialization))
    return failure();
  if (analysis.defined(*materialization) != sym::CheckResult::True)
    return failure();
  return shouldUseSimplifiedIndexExpr(*proof, *materialization)
             ? *proof
             : *materialization;
}

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
specializeCoordinates(sym::Analysis &analysis,
                      const MappingCoordinates &coordinates,
                      ArrayRef<sym::ExprSubstitution> substitutions) {
  std::array<sym::ExprHandle, 3> roots{
      coordinates.base, coordinates.targetBlock, coordinates.bitOffset};
  for (sym::ExprHandle &root : roots) {
    FailureOr<sym::ExprHandle> substituted =
        analysis.substitute(root, substitutions);
    if (failed(substituted))
      return failure();
    root = *substituted;
  }
  if (failed(analysis.simplify(roots)))
    return failure();
  return MappingCoordinates{roots[0], roots[1], roots[2]};
}

static bool coordinatesProvablyDefined(sym::Analysis &analysis,
                                       const MappingCoordinates &coordinates) {
  return analysis.defined(coordinates.base) == sym::CheckResult::True &&
         analysis.defined(coordinates.targetBlock) == sym::CheckResult::True &&
         analysis.defined(coordinates.bitOffset) == sym::CheckResult::True;
}

static FailureOr<int64_t>
validateLocalCoordinates(const MemoryAccess &access, sym::Analysis &analysis,
                         const MappingCoordinates &coordinates,
                         sym::ExprHandle block) {
  if (!coordinatesProvablyDefined(analysis, coordinates))
    return failure();
  if (hasSymbol(coordinates.base, "block") ||
      hasSymbol(coordinates.bitOffset, "block"))
    return failure();
  if (analysis.equivalent(coordinates.targetBlock, block) !=
      sym::CheckResult::True)
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

static FailureOr<sym::ExprHandle> getByteOffset(sym::Analysis &analysis,
                                                sym::ExprHandle bitOffset) {
  return divideExactlyProof(analysis, bitOffset, 8);
}

struct PreparedSlotMapping {
  SmallVector<sym::ExprSubstitution> substitutions;
  SlotMapping mapping;
};

static FailureOr<PreparedSlotMapping> prepareSlotMapping(
    const MemoryAccess &access, sym::Store &store, sym::ExprHandle slotSymbol,
    int64_t slot, const MappedItem &item,
    ArrayRef<sym::ExprSubstitution> bindingSubstitutions,
    ArrayRef<PacketComponents> packetComponents,
    ArrayRef<ActiveControl> controls, const PacketControl *packetControl,
    PacketBindingState &bindingState) {
  PreparedSlotMapping prepared;
  prepared.mapping.logicalSlots.push_back(static_cast<unsigned>(slot));
  prepared.mapping.proofIndex = static_cast<size_t>(slot);
  if (failed(appendAccessBindings(access, store, item, prepared.mapping)))
    return failure();
  if (failed(appendActiveControls(store, controls, bindingState,
                                  prepared.mapping)))
    return failure();
  if (failed(appendPacketControl(store, packetControl, bindingState,
                                 prepared.mapping)))
    return failure();
  FailureOr<SmallVector<sym::ExprSubstitution>> substitutions =
      buildSlotSubstitutions(access, store, slotSymbol, slot,
                             bindingSubstitutions, packetComponents,
                             bindingState, prepared.mapping);
  if (failed(substitutions))
    return failure();
  prepared.substitutions = std::move(*substitutions);
  return prepared;
}

static FailureOr<SlotMapping> analyzeSlotMapping(const MemoryAccess &access,
                                                 sym::Analysis &analysis,
                                                 sym::ExprHandle blockSymbol,
                                                 sym::ExprHandle zero,
                                                 PreparedSlotMapping prepared) {
  SlotMapping &result = prepared.mapping;
  MappingCoordinates coordinates =
      getMappingCoordinates(access, blockSymbol, zero);
  FailureOr<sym::ExprHandle> materializationBitOffset =
      analysis.substitute(coordinates.bitOffset, prepared.substitutions);
  if (failed(materializationBitOffset))
    return failure();
  FailureOr<MappingCoordinates> specialized =
      specializeCoordinates(analysis, coordinates, prepared.substitutions);
  if (failed(specialized))
    return failure();
  FailureOr<int64_t> baseIndex =
      validateLocalCoordinates(access, analysis, *specialized, blockSymbol);
  if (failed(baseIndex))
    return failure();
  std::array<sym::ExprSubstitution, 1> blockSubstitution{
      sym::ExprSubstitution{blockSymbol, zero}};
  materializationBitOffset =
      analysis.substitute(*materializationBitOffset, blockSubstitution);
  if (failed(materializationBitOffset))
    return failure();
  FailureOr<MappingCoordinates> local =
      specializeCoordinates(analysis, *specialized, blockSubstitution);
  if (failed(local))
    return failure();
  result.materializationBitOffset = *materializationBitOffset;
  FailureOr<sym::ExprHandle> materializationByteOffset =
      divideExactlyForMaterialization(analysis, result.materializationBitOffset,
                                      8);
  if (failed(materializationByteOffset))
    return failure();
  materializationByteOffset =
      simplifyForMaterialization(analysis, *materializationByteOffset);
  if (failed(materializationByteOffset))
    return failure();
  result.materializationByteOffset = *materializationByteOffset;
  FailureOr<sym::ExprHandle> bitOffset = analysis.simplify(local->bitOffset);
  if (failed(bitOffset))
    return failure();
  local->bitOffset = *bitOffset;
  FailureOr<sym::ExprHandle> byteOffset =
      getByteOffset(analysis, local->bitOffset);
  if (failed(byteOffset))
    return failure();
  result.base = local->base;
  result.targetBlock = local->targetBlock;
  result.bitOffset = local->bitOffset;
  result.byteOffset = *byteOffset;
  result.proofOffset = analysis.splitAdditiveConstant(local->bitOffset);
  result.baseIndex = *baseIndex;
  return std::move(prepared.mapping);
}

static SmallVector<sym::PredHandle> combineAssumptions(const SlotMapping &lhs,
                                                       const SlotMapping &rhs) {
  SmallVector<sym::PredHandle> assumptions = lhs.assumptions;
  llvm::append_range(assumptions, rhs.assumptions);
  return assumptions;
}

static SmallVector<sym::PredHandle>
getNonActivationAssumptions(const SlotMapping &slot) {
  SmallVector<sym::PredHandle> assumptions = slot.assumptions;
  if (slot.activationPredicate)
    llvm::erase(assumptions, *slot.activationPredicate);
  return assumptions;
}

static SmallVector<sym::PredHandle>
combineNonActivationAssumptions(const SlotMapping &lhs,
                                const SlotMapping &rhs) {
  SmallVector<sym::PredHandle> assumptions = getNonActivationAssumptions(lhs);
  SmallVector<sym::PredHandle> rhsAssumptions =
      getNonActivationAssumptions(rhs);
  llvm::append_range(assumptions, rhsAssumptions);
  return assumptions;
}

static sym::PredHandle getActivationRelation(const SlotMapping &mapping) {
  return mapping.activationRelationPredicate
             ? mapping.activationRelationPredicate
             : *mapping.activationPredicate;
}

static std::optional<bool>
getStructuralActivationRelation(const SlotMapping &lhs,
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
  return std::nullopt;
}

struct ExactFactDomainGroup {
  SmallVector<sym::PredHandle> assumptions;
  SmallVector<size_t> tasks;
};

static void appendExactFactDomainTask(
    SmallVector<sym::PredHandle> assumptions, size_t task,
    SmallVectorImpl<ExactFactDomainGroup> &groups,
    llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> &buckets) {
  llvm::hash_code hash =
      llvm::hash_combine_range(assumptions.begin(), assumptions.end());
  SmallVector<size_t> &bucket = buckets[hash];
  for (size_t groupIndex : bucket) {
    ExactFactDomainGroup &group = groups[groupIndex];
    if (llvm::equal(group.assumptions, assumptions)) {
      group.tasks.push_back(task);
      return;
    }
  }
  bucket.push_back(groups.size());
  groups.push_back({std::move(assumptions), {task}});
}

using RelationPair = std::pair<size_t, size_t>;
using AddressProofClassKey =
    std::pair<sym::ExprHandle, std::pair<sym::ExprHandle, sym::ExprHandle>>;

struct RelationProof {
  bool available = false;
  bool baseTargetProven = false;
  bool sameBitOffset = false;
  bool lowToHighAdjacent = false;
  bool highToLowAdjacent = false;
};

struct ActivationProof {
  bool available = false;
  bool same = false;
};

struct AddressClassProof {
  bool available = false;
  bool baseTargetProven = false;
  int64_t residualDifference = 0;
};

struct RemainderPairPreparationProof {
  bool ready = false;
  bool lhsBindingNonnegative = false;
  bool rhsBindingNonnegative = false;
};

class SymbolicRelationProofCache {
public:
  std::optional<RelationProof>
  lookupAddress(ArrayRef<sym::PredHandle> assumptions, const SlotMapping &lhs,
                const SlotMapping &rhs, int64_t elementBits) const {
    llvm::hash_code hash = getAddressHash(assumptions, lhs, rhs, elementBits);
    auto bucket = addressBuckets.find(hash);
    if (bucket == addressBuckets.end())
      return std::nullopt;
    for (size_t index : bucket->second) {
      const AddressEntry &entry = addressEntries[index];
      if (matchesAddressEntry(entry, assumptions, lhs, rhs, elementBits))
        return entry.proof;
    }
    return std::nullopt;
  }

  void insertAddress(ArrayRef<sym::PredHandle> assumptions,
                     const SlotMapping &lhs, const SlotMapping &rhs,
                     int64_t elementBits, RelationProof proof) {
    llvm::hash_code hash = getAddressHash(assumptions, lhs, rhs, elementBits);
    addressBuckets[hash].push_back(addressEntries.size());
    addressEntries.push_back({SmallVector<sym::PredHandle>(assumptions),
                              lhs.base, rhs.base, lhs.targetBlock,
                              rhs.targetBlock, lhs.bitOffset, rhs.bitOffset,
                              elementBits, proof});
  }

  std::optional<AddressClassProof>
  lookupAddressClass(ArrayRef<sym::PredHandle> assumptions,
                     AddressProofClassKey lhs, AddressProofClassKey rhs) const {
    llvm::hash_code hash = getAddressClassHash(assumptions, lhs, rhs);
    auto bucket = addressClassBuckets.find(hash);
    if (bucket == addressClassBuckets.end())
      return std::nullopt;
    for (size_t index : bucket->second) {
      const AddressClassEntry &entry = addressClassEntries[index];
      if (entry.lhs == lhs && entry.rhs == rhs &&
          llvm::equal(entry.assumptions, assumptions))
        return entry.proof;
    }
    return std::nullopt;
  }

  void insertAddressClass(ArrayRef<sym::PredHandle> assumptions,
                          AddressProofClassKey lhs, AddressProofClassKey rhs,
                          AddressClassProof proof) {
    llvm::hash_code hash = getAddressClassHash(assumptions, lhs, rhs);
    addressClassBuckets[hash].push_back(addressClassEntries.size());
    addressClassEntries.push_back(
        {SmallVector<sym::PredHandle>(assumptions), lhs, rhs, proof});
  }

  std::optional<ActivationProof>
  lookupActivation(ArrayRef<sym::PredHandle> assumptions,
                   sym::PredHandle lhsRelation,
                   sym::PredHandle rhsRelation) const {
    llvm::hash_code hash =
        getActivationHash(assumptions, lhsRelation, rhsRelation);
    auto bucket = activationBuckets.find(hash);
    if (bucket == activationBuckets.end())
      return std::nullopt;
    for (size_t index : bucket->second) {
      const ActivationEntry &entry = activationEntries[index];
      if (entry.lhsRelation == lhsRelation &&
          entry.rhsRelation == rhsRelation &&
          llvm::equal(entry.assumptions, assumptions))
        return entry.proof;
    }
    return std::nullopt;
  }

  void insertActivation(ArrayRef<sym::PredHandle> assumptions,
                        sym::PredHandle lhsRelation,
                        sym::PredHandle rhsRelation, ActivationProof proof) {
    llvm::hash_code hash =
        getActivationHash(assumptions, lhsRelation, rhsRelation);
    activationBuckets[hash].push_back(activationEntries.size());
    activationEntries.push_back({SmallVector<sym::PredHandle>(assumptions),
                                 lhsRelation, rhsRelation, proof});
  }

  std::optional<RemainderPairPreparationProof> lookupRemainderPairPreparation(
      ArrayRef<sym::PredHandle> assumptions, sym::ExprHandle lhsBitOffset,
      sym::ExprHandle rhsBitOffset, sym::ExprHandle lhsBinding,
      sym::ExprHandle rhsBinding, int64_t elementBits) const {
    llvm::hash_code hash =
        getRemainderPairPreparationHash(assumptions, lhsBitOffset, rhsBitOffset,
                                        lhsBinding, rhsBinding, elementBits);
    auto bucket = remainderPairPreparationBuckets.find(hash);
    if (bucket == remainderPairPreparationBuckets.end())
      return std::nullopt;
    for (size_t index : bucket->second) {
      const RemainderPairPreparationEntry &entry =
          remainderPairPreparationEntries[index];
      if (entry.lhsBitOffset == lhsBitOffset &&
          entry.rhsBitOffset == rhsBitOffset &&
          entry.lhsBinding == lhsBinding && entry.rhsBinding == rhsBinding &&
          entry.elementBits == elementBits &&
          llvm::equal(entry.assumptions, assumptions))
        return entry.proof;
    }
    return std::nullopt;
  }

  void insertRemainderPairPreparation(ArrayRef<sym::PredHandle> assumptions,
                                      sym::ExprHandle lhsBitOffset,
                                      sym::ExprHandle rhsBitOffset,
                                      sym::ExprHandle lhsBinding,
                                      sym::ExprHandle rhsBinding,
                                      int64_t elementBits,
                                      RemainderPairPreparationProof proof) {
    if (lookupRemainderPairPreparation(assumptions, lhsBitOffset, rhsBitOffset,
                                       lhsBinding, rhsBinding, elementBits))
      return;
    llvm::hash_code hash =
        getRemainderPairPreparationHash(assumptions, lhsBitOffset, rhsBitOffset,
                                        lhsBinding, rhsBinding, elementBits);
    remainderPairPreparationBuckets[hash].push_back(
        remainderPairPreparationEntries.size());
    remainderPairPreparationEntries.push_back(
        {SmallVector<sym::PredHandle>(assumptions), lhsBitOffset, rhsBitOffset,
         lhsBinding, rhsBinding, elementBits, proof});
  }

private:
  struct AddressEntry {
    SmallVector<sym::PredHandle> assumptions;
    sym::ExprHandle lhsBase;
    sym::ExprHandle rhsBase;
    sym::ExprHandle lhsTargetBlock;
    sym::ExprHandle rhsTargetBlock;
    sym::ExprHandle lhsBitOffset;
    sym::ExprHandle rhsBitOffset;
    int64_t elementBits = 0;
    RelationProof proof;
  };

  struct AddressClassEntry {
    SmallVector<sym::PredHandle> assumptions;
    AddressProofClassKey lhs;
    AddressProofClassKey rhs;
    AddressClassProof proof;
  };

  struct ActivationEntry {
    SmallVector<sym::PredHandle> assumptions;
    sym::PredHandle lhsRelation;
    sym::PredHandle rhsRelation;
    ActivationProof proof;
  };

  struct RemainderPairPreparationEntry {
    SmallVector<sym::PredHandle> assumptions;
    sym::ExprHandle lhsBitOffset;
    sym::ExprHandle rhsBitOffset;
    sym::ExprHandle lhsBinding;
    sym::ExprHandle rhsBinding;
    int64_t elementBits = 0;
    RemainderPairPreparationProof proof;
  };

  static bool matchesAddressEntry(const AddressEntry &entry,
                                  ArrayRef<sym::PredHandle> assumptions,
                                  const SlotMapping &lhs,
                                  const SlotMapping &rhs, int64_t elementBits) {
    return entry.elementBits == elementBits && entry.lhsBase == lhs.base &&
           entry.rhsBase == rhs.base &&
           entry.lhsTargetBlock == lhs.targetBlock &&
           entry.rhsTargetBlock == rhs.targetBlock &&
           entry.lhsBitOffset == lhs.bitOffset &&
           entry.rhsBitOffset == rhs.bitOffset &&
           llvm::equal(entry.assumptions, assumptions);
  }

  static llvm::hash_code getAddressHash(ArrayRef<sym::PredHandle> assumptions,
                                        const SlotMapping &lhs,
                                        const SlotMapping &rhs,
                                        int64_t elementBits) {
    return llvm::hash_combine(
        llvm::hash_combine_range(assumptions.begin(), assumptions.end()),
        lhs.base, rhs.base, lhs.targetBlock, rhs.targetBlock, lhs.bitOffset,
        rhs.bitOffset, elementBits);
  }

  static llvm::hash_code
  getAddressClassHash(ArrayRef<sym::PredHandle> assumptions,
                      AddressProofClassKey lhs, AddressProofClassKey rhs) {
    return llvm::hash_combine(
        llvm::hash_combine_range(assumptions.begin(), assumptions.end()), lhs,
        rhs);
  }

  static llvm::hash_code
  getActivationHash(ArrayRef<sym::PredHandle> assumptions,
                    sym::PredHandle lhsRelation, sym::PredHandle rhsRelation) {
    return llvm::hash_combine(
        llvm::hash_combine_range(assumptions.begin(), assumptions.end()),
        lhsRelation, rhsRelation);
  }

  static llvm::hash_code getRemainderPairPreparationHash(
      ArrayRef<sym::PredHandle> assumptions, sym::ExprHandle lhsBitOffset,
      sym::ExprHandle rhsBitOffset, sym::ExprHandle lhsBinding,
      sym::ExprHandle rhsBinding, int64_t elementBits) {
    return llvm::hash_combine(
        llvm::hash_combine_range(assumptions.begin(), assumptions.end()),
        lhsBitOffset, rhsBitOffset, lhsBinding, rhsBinding, elementBits);
  }

  SmallVector<AddressEntry> addressEntries;
  SmallVector<AddressClassEntry> addressClassEntries;
  SmallVector<ActivationEntry> activationEntries;
  SmallVector<RemainderPairPreparationEntry> remainderPairPreparationEntries;
  llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> addressBuckets;
  llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> addressClassBuckets;
  llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> activationBuckets;
  llvm::DenseMap<llvm::hash_code, SmallVector<size_t>>
      remainderPairPreparationBuckets;
};

class RelationCache {
public:
  RelationCache(sym::Store &store, ArrayRef<SlotMapping> slots,
                SymbolicRelationProofCache &proofCache)
      : store(store), slots(slots), proofCache(proofCache) {}

  void prepare(ArrayRef<RelationPair> pairs, int64_t elementBits,
               uint64_t &factDomainCount) {
    SmallVector<RelationPair> addressPairs;
    for (RelationPair pair : pairs) {
      std::optional<RelationPair> canonical = getCanonicalPair(pair);
      if (!canonical)
        continue;
      if (relationProofs.try_emplace(*canonical).second)
        addressPairs.push_back(*canonical);
    }
    prepareAddressRelations(addressPairs, elementBits, factDomainCount);
  }

  const RelationProof *lookupPrepared(const SlotMapping &lhs,
                                      const SlotMapping &rhs) const {
    std::optional<RelationPair> pair =
        getCanonicalPair({lhs.proofIndex, rhs.proofIndex});
    if (!pair)
      return nullptr;
    auto found = relationProofs.find(*pair);
    if (found == relationProofs.end())
      return nullptr;
    return &found->second;
  }

  std::optional<AddressClassProof>
  proveAddressClasses(ArrayRef<sym::PredHandle> assumptions,
                      AddressProofClassKey lhs, AddressProofClassKey rhs,
                      uint64_t &factDomainCount) {
    std::optional<AddressClassProof> cached =
        proofCache.lookupAddressClass(assumptions, lhs, rhs);
    if (cached)
      return cached;

    std::optional<AddressClassProof> proof;
    bool countedDomain = false;
    bool cacheable = false;
    {
      FailureOr<std::unique_ptr<sym::Analysis>> analysis =
          sym::Analysis::createDirect(store, assumptions);
      if (succeeded(analysis)) {
        ++factDomainCount;
        countedDomain = true;
        proof = prepareAddressClass(**analysis, lhs, rhs);
        cacheable = proof.has_value();
      }
    }
    if (!proof) {
      FailureOr<std::unique_ptr<sym::Analysis>> analysis =
          sym::Analysis::create(store, assumptions);
      if (succeeded(analysis)) {
        if (!countedDomain)
          ++factDomainCount;
        cacheable = true;
        proof = prepareAddressClass(**analysis, lhs, rhs);
      }
    }
    if (!cacheable)
      return std::nullopt;
    AddressClassProof result = proof.value_or(AddressClassProof{});
    proofCache.insertAddressClass(assumptions, lhs, rhs, result);
    return result;
  }

  bool sameActivation(const SlotMapping &lhs, const SlotMapping &rhs,
                      uint64_t &factDomainCount) {
    std::optional<bool> structural = getStructuralActivationRelation(lhs, rhs);
    if (structural)
      return *structural;
    std::optional<RelationPair> pair =
        getCanonicalPair({lhs.proofIndex, rhs.proofIndex});
    if (!pair)
      return false;
    auto found = activationProofs.find(*pair);
    if (found != activationProofs.end())
      return found->second.same;

    const SlotMapping &lowSlot = slots[pair->first];
    const SlotMapping &highSlot = slots[pair->second];
    SmallVector<sym::PredHandle> assumptions =
        combineNonActivationAssumptions(lowSlot, highSlot);
    sym::PredHandle lhsRelation = getActivationRelation(lowSlot);
    sym::PredHandle rhsRelation = getActivationRelation(highSlot);
    std::optional<ActivationProof> cached =
        proofCache.lookupActivation(assumptions, lhsRelation, rhsRelation);
    if (cached) {
      activationProofs.try_emplace(*pair, *cached);
      return cached->same;
    }

    std::optional<ActivationProof> proof;
    bool countedDomain = false;
    {
      FailureOr<std::unique_ptr<sym::Analysis>> created =
          sym::Analysis::createDirect(store, assumptions);
      if (succeeded(created)) {
        ++factDomainCount;
        countedDomain = true;
        proof = prepareActivationRelation(**created, *pair);
      }
    }
    if (!proof) {
      FailureOr<std::unique_ptr<sym::Analysis>> created =
          sym::Analysis::create(store, assumptions);
      if (succeeded(created)) {
        if (!countedDomain)
          ++factDomainCount;
        proof = prepareActivationRelation(**created, *pair);
      }
    }
    if (!proof)
      return false;
    activationProofs.try_emplace(*pair, *proof);
    proofCache.insertActivation(assumptions, lhsRelation, rhsRelation, *proof);
    return proof->same;
  }

private:
  std::optional<RelationPair> getCanonicalPair(RelationPair pair) const {
    if (pair.first == pair.second || pair.first >= slots.size() ||
        pair.second >= slots.size())
      return std::nullopt;
    if (pair.first > pair.second)
      std::swap(pair.first, pair.second);
    return pair;
  }

  void prepareAddressRelations(ArrayRef<RelationPair> pairs,
                               int64_t elementBits, uint64_t &factDomainCount) {
    SmallVector<ExactFactDomainGroup> groups;
    llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> buckets;
    collectAddressRelationGroups(pairs, elementBits, groups, buckets);

    for (ExactFactDomainGroup &group : groups) {
      SmallVector<size_t> fallbackTasks;
      bool countedDomain = prepareDirectAddressGroup(
          group, pairs, elementBits, factDomainCount, fallbackTasks);
      prepareStrongAddressGroup(group, pairs, fallbackTasks, elementBits,
                                countedDomain, factDomainCount);
    }
  }

  void collectAddressRelationGroups(
      ArrayRef<RelationPair> pairs, int64_t elementBits,
      SmallVectorImpl<ExactFactDomainGroup> &groups,
      llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> &buckets) {
    for (auto [index, pair] : llvm::enumerate(pairs)) {
      std::optional<RelationProof> proof =
          getCachedAddressRelation(pair, elementBits);
      if (proof) {
        relationProofs[pair] = *proof;
        continue;
      }
      SmallVector<sym::PredHandle> assumptions =
          combineAssumptions(slots[pair.first], slots[pair.second]);
      std::optional<RelationProof> cached = proofCache.lookupAddress(
          assumptions, slots[pair.first], slots[pair.second], elementBits);
      if (cached) {
        relationProofs[pair] = *cached;
        continue;
      }
      appendExactFactDomainTask(std::move(assumptions), index, groups, buckets);
    }
  }

  void cacheAddressRelation(ArrayRef<sym::PredHandle> assumptions,
                            RelationPair pair, int64_t elementBits,
                            RelationProof proof) {
    relationProofs[pair] = proof;
    proofCache.insertAddress(assumptions, slots[pair.first], slots[pair.second],
                             elementBits, proof);
  }

  bool prepareDirectAddressGroup(const ExactFactDomainGroup &group,
                                 ArrayRef<RelationPair> pairs,
                                 int64_t elementBits, uint64_t &factDomainCount,
                                 SmallVectorImpl<size_t> &fallbackTasks) {
    FailureOr<std::unique_ptr<sym::Analysis>> created =
        sym::Analysis::createDirect(store, group.assumptions);
    if (failed(created)) {
      llvm::append_range(fallbackTasks, group.tasks);
      return false;
    }
    ++factDomainCount;
    for (size_t index : group.tasks) {
      RelationPair pair = pairs[index];
      std::optional<RelationProof> proof =
          prepareAddressRelation(**created, pair, elementBits);
      if (proof)
        cacheAddressRelation(group.assumptions, pair, elementBits, *proof);
      else
        fallbackTasks.push_back(index);
    }
    return true;
  }

  void prepareStrongAddressGroup(const ExactFactDomainGroup &group,
                                 ArrayRef<RelationPair> pairs,
                                 ArrayRef<size_t> fallbackTasks,
                                 int64_t elementBits, bool countedDomain,
                                 uint64_t &factDomainCount) {
    if (fallbackTasks.empty())
      return;
    FailureOr<std::unique_ptr<sym::Analysis>> created =
        sym::Analysis::create(store, group.assumptions);
    if (failed(created))
      return;
    if (!countedDomain)
      ++factDomainCount;
    for (size_t index : fallbackTasks) {
      RelationPair pair = pairs[index];
      bool cacheableUnknown = false;
      RelationProof partial;
      std::optional<RelationProof> proof = prepareAddressRelation(
          **created, pair, elementBits, &cacheableUnknown, &partial);
      if (proof || cacheableUnknown)
        cacheAddressRelation(group.assumptions, pair, elementBits,
                             proof.value_or(partial));
    }
  }

  std::optional<RelationProof>
  getCachedAddressRelation(RelationPair pair, int64_t elementBits) const {
    const SlotMapping &lowSlot = slots[pair.first];
    const SlotMapping &highSlot = slots[pair.second];
    if (!(lowSlot.base == highSlot.base) ||
        !(lowSlot.targetBlock == highSlot.targetBlock) ||
        !lowSlot.proofOffset || !highSlot.proofOffset ||
        !(lowSlot.proofOffset->residual == highSlot.proofOffset->residual))
      return std::nullopt;
    std::optional<int64_t> difference = llvm::checkedSub(
        highSlot.proofOffset->constant, lowSlot.proofOffset->constant);
    if (!difference)
      return std::nullopt;
    return RelationProof{/*available=*/true, /*baseTargetProven=*/true,
                         /*sameBitOffset=*/*difference == 0,
                         /*lowToHighAdjacent=*/*difference == elementBits,
                         /*highToLowAdjacent=*/*difference == -elementBits};
  }

  std::optional<RelationProof>
  prepareAddressRelation(sym::Analysis &analysis, RelationPair pair,
                         int64_t elementBits, bool *cacheableUnknown = nullptr,
                         RelationProof *partial = nullptr) {
    if (cacheableUnknown)
      *cacheableUnknown = false;
    const SlotMapping &lowSlot = slots[pair.first];
    const SlotMapping &highSlot = slots[pair.second];
    RelationProof proof;
    std::optional<bool> baseTarget = prepareAddressBaseTarget(
        analysis, lowSlot, highSlot, proof, cacheableUnknown, partial);
    if (!baseTarget)
      return std::nullopt;
    if (!*baseTarget)
      return proof;
    return prepareAddressOffset(analysis, lowSlot, highSlot, elementBits, proof,
                                cacheableUnknown, partial);
  }

  static void markAddressUnknown(const RelationProof &proof,
                                 bool *cacheableUnknown,
                                 RelationProof *partial) {
    if (cacheableUnknown)
      *cacheableUnknown = true;
    if (partial)
      *partial = proof;
  }

  static std::optional<bool>
  queryAddressEquivalent(sym::Analysis &analysis, sym::ExprHandle lhs,
                         sym::ExprHandle rhs, const RelationProof &proof,
                         bool *cacheableUnknown, RelationProof *partial) {
    sym::CheckResult result = analysis.equivalent(lhs, rhs);
    if (result != sym::CheckResult::Unknown)
      return result == sym::CheckResult::True;
    markAddressUnknown(proof, cacheableUnknown, partial);
    return std::nullopt;
  }

  static std::optional<bool>
  prepareAddressBaseTarget(sym::Analysis &analysis, const SlotMapping &lowSlot,
                           const SlotMapping &highSlot, RelationProof &proof,
                           bool *cacheableUnknown, RelationProof *partial) {
    std::optional<bool> sameBase =
        queryAddressEquivalent(analysis, lowSlot.base, highSlot.base, proof,
                               cacheableUnknown, partial);
    if (!sameBase)
      return std::nullopt;
    if (!*sameBase) {
      proof.available = true;
      return false;
    }
    std::optional<bool> sameTarget = queryAddressEquivalent(
        analysis, lowSlot.targetBlock, highSlot.targetBlock, proof,
        cacheableUnknown, partial);
    if (!sameTarget)
      return std::nullopt;
    if (!*sameTarget) {
      proof.available = true;
      return false;
    }
    proof.baseTargetProven = true;
    return true;
  }

  static std::optional<RelationProof>
  prepareAddressOffset(sym::Analysis &analysis, const SlotMapping &lowSlot,
                       const SlotMapping &highSlot, int64_t elementBits,
                       RelationProof proof, bool *cacheableUnknown,
                       RelationProof *partial) {
    std::optional<int64_t> difference =
        analysis.constantDifference(highSlot.bitOffset, lowSlot.bitOffset);
    if (difference) {
      proof.sameBitOffset = *difference == 0;
      proof.lowToHighAdjacent = *difference == elementBits;
      proof.highToLowAdjacent = *difference == -elementBits;
      proof.available = true;
      return proof;
    }

    std::optional<bool> sameOffset =
        queryAddressEquivalent(analysis, lowSlot.bitOffset, highSlot.bitOffset,
                               proof, cacheableUnknown, partial);
    if (!sameOffset)
      return std::nullopt;
    proof.sameBitOffset = *sameOffset;
    FailureOr<sym::ExprHandle> delta = analysis.composeInteger(elementBits);
    if (failed(delta))
      return std::nullopt;
    FailureOr<sym::ExprHandle> highExpected =
        analysis.compose(lowSlot.bitOffset, sym::ExprBinaryOp::Add, *delta);
    FailureOr<sym::ExprHandle> lowExpected =
        analysis.compose(highSlot.bitOffset, sym::ExprBinaryOp::Add, *delta);
    if (failed(highExpected) || failed(lowExpected))
      return std::nullopt;
    std::optional<bool> lowToHigh =
        queryAddressEquivalent(analysis, *highExpected, highSlot.bitOffset,
                               proof, cacheableUnknown, partial);
    if (!lowToHigh)
      return std::nullopt;
    proof.lowToHighAdjacent = *lowToHigh;
    std::optional<bool> highToLow =
        queryAddressEquivalent(analysis, *lowExpected, lowSlot.bitOffset, proof,
                               cacheableUnknown, partial);
    if (!highToLow)
      return std::nullopt;
    proof.highToLowAdjacent = *highToLow;
    proof.available = true;
    return proof;
  }

  static std::optional<AddressClassProof>
  prepareAddressClass(sym::Analysis &analysis, AddressProofClassKey lhs,
                      AddressProofClassKey rhs) {
    sym::CheckResult base = analysis.equivalent(lhs.first, rhs.first);
    if (base == sym::CheckResult::False)
      return AddressClassProof{/*available=*/true};
    if (base == sym::CheckResult::Unknown)
      return std::nullopt;
    sym::CheckResult target =
        analysis.equivalent(lhs.second.first, rhs.second.first);
    if (target == sym::CheckResult::False)
      return AddressClassProof{/*available=*/true};
    if (target == sym::CheckResult::Unknown)
      return std::nullopt;
    std::optional<int64_t> residualDifference =
        analysis.constantDifference(rhs.second.second, lhs.second.second);
    if (!residualDifference)
      return std::nullopt;
    return AddressClassProof{/*available=*/true,
                             /*baseTargetProven=*/true, *residualDifference};
  }

  std::optional<ActivationProof>
  prepareActivationRelation(sym::Analysis &analysis, RelationPair pair) {
    sym::CheckResult result =
        analysis.equivalent(getActivationRelation(slots[pair.first]),
                            getActivationRelation(slots[pair.second]));
    if (result == sym::CheckResult::Unknown)
      return std::nullopt;
    return ActivationProof{true, result == sym::CheckResult::True};
  }

  llvm::DenseMap<RelationPair, RelationProof> relationProofs;
  llvm::DenseMap<RelationPair, ActivationProof> activationProofs;
  sym::Store &store;
  ArrayRef<SlotMapping> slots;
  SymbolicRelationProofCache &proofCache;
};

struct SymbolicProofValue {
  SmallVector<sym::PredHandle> assumptions;
  sym::ExprHandle expression;
};

enum class RemainderDivisorSign { Positive, Negative, Unknown };

struct PreparedRemainderCandidate {
  SmallVector<sym::PredHandle> assumptions;
  BinaryOp lhsRemainder;
  BinaryOp rhsRemainder;
  sym::ExprHandle lhsDividend;
  sym::ExprHandle rhsDividend;
  sym::ExprHandle lhsDivisor;
  sym::ExprHandle rhsDivisor;
  BinaryKind kind = BinaryKind::AddI;
  size_t lhsBinding = 0;
  size_t rhsBinding = 0;
  RemainderDivisorSign divisorSign = RemainderDivisorSign::Unknown;
  bool lhsBindingNonnegative = false;
  bool rhsBindingNonnegative = false;
  bool successorProven = false;
};

struct PreparedRemainderRelation {
  SmallVector<PreparedRemainderCandidate> candidates;
  bool available = false;
};

// Runtime div/rem stay SSA; proof-only projections must not duplicate them.
class RemainderProofContext {
public:
  RemainderProofContext(WaveDialect &dialect, DataFlowSolver &solver,
                        Operation *access, ArrayRef<SlotMapping> slots,
                        SymbolicRelationProofCache &proofCache,
                        uint64_t &factDomainCount)
      : proofCache(proofCache),
        relations(dialect.getSymbolStore(), slots, proofCache),
        dialect(dialect), solver(solver), store(dialect.getSymbolStore()),
        slots(slots), factDomainCount(factDomainCount), access(access) {}

  void prepareRelations(ArrayRef<RelationPair> pairs, int64_t elementBits) {
    relations.prepare(pairs, elementBits, factDomainCount);
    prepareRemainderRelations(pairs, elementBits, false);
  }

  const RelationProof *lookupPreparedRelation(const SlotMapping &lhs,
                                              const SlotMapping &rhs) const {
    return relations.lookupPrepared(lhs, rhs);
  }

  std::optional<AddressClassProof>
  proveAddressClasses(ArrayRef<sym::PredHandle> assumptions,
                      AddressProofClassKey lhs, AddressProofClassKey rhs) {
    return relations.proveAddressClasses(assumptions, lhs, rhs,
                                         factDomainCount);
  }

  const PreparedRemainderRelation *
  lookupRemainderRelation(const SlotMapping &lhs,
                          const SlotMapping &rhs) const {
    auto found = remainderRelations.find({lhs.proofIndex, rhs.proofIndex});
    if (found == remainderRelations.end() || !found->second.available)
      return nullptr;
    return &found->second;
  }

  void prepareRemainderRelation(const SlotMapping &lhs, const SlotMapping &rhs,
                                int64_t elementBits) {
    RelationPair pair{lhs.proofIndex, rhs.proofIndex};
    if (pair.first == pair.second)
      return;
    std::array<RelationPair, 1> pairs{pair};
    prepareRemainderRelations(pairs, elementBits, true);
  }

  bool sameActivation(const SlotMapping &lhs, const SlotMapping &rhs) {
    return relations.sameActivation(lhs, rhs, factDomainCount);
  }

  void recordFactDomain() { ++factDomainCount; }

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
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        sym::Analysis::create(store, symbolic->assumptions);
    if (failed(analysis))
      return cacheNonnegative(value, false);
    FailureOr<sym::ExprHandle> zero = (*analysis)->composeInteger(0);
    if (failed(zero))
      return cacheNonnegative(value, false);
    FailureOr<sym::PredHandle> predicate =
        (*analysis)->compare(symbolic->expression, sym::PredCmpOp::Ge, *zero);
    bool result = succeeded(predicate) &&
                  (*analysis)->check(*predicate) == sym::CheckResult::True;
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
  void prepareRemainderRelations(ArrayRef<RelationPair> pairs,
                                 int64_t elementBits, bool directed);

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

  struct PreparedProjection {
    SmallVector<sym::ExprSubstitution> substitutions;
    bool available = false;
  };

  static void getProjectionInvariance(sym::Analysis &analysis,
                                      const SymbolicProofValue &value,
                                      ArrayRef<PreparedProjection> projections,
                                      MutableArrayRef<uint8_t> invariant) {
    for (auto [index, projection] : llvm::enumerate(projections)) {
      if (!projection.available)
        continue;
      FailureOr<sym::ExprHandle> projected =
          analysis.substitute(value.expression, projection.substitutions);
      invariant[index] = succeeded(projected) &&
                         analysis.equivalent(value.expression, *projected) ==
                             sym::CheckResult::True;
    }
  }

  bool
  projectionProvesNonnegative(const SymbolicProofValue &root,
                              const SymbolicProofValue &target,
                              ArrayRef<sym::ExprSubstitution> substitutions) {
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        sym::Analysis::create(store, target.assumptions);
    if (failed(analysis))
      return false;
    SmallVector<sym::PredHandle> projectedPredicates;
    projectedPredicates.reserve(root.assumptions.size());
    for (sym::PredHandle assumption : root.assumptions) {
      FailureOr<sym::PredHandle> projected =
          (*analysis)->substitute(assumption, substitutions);
      if (failed(projected))
        return false;
      projectedPredicates.push_back(*projected);
    }
    if (!projectedPredicates.empty() &&
        failed((*analysis)->assume(projectedPredicates)))
      return false;
    FailureOr<sym::ExprHandle> zero = (*analysis)->composeInteger(0);
    if (failed(zero))
      return false;
    FailureOr<sym::PredHandle> nonnegative =
        (*analysis)->compare(target.expression, sym::PredCmpOp::Ge, *zero);
    return succeeded(nonnegative) &&
           (*analysis)->check(*nonnegative) == sym::CheckResult::True;
  }

  bool proveProjectedNonnegative(Value rootValue, Value targetValue,
                                 const SymbolicProofValue &root,
                                 const SymbolicProofValue &dividend,
                                 const SymbolicProofValue &divisor,
                                 const SymbolicProofValue &target) {
    SmallVector<PreparedProjection> prepared = prepareExecutionProjections(
        rootValue, targetValue, root, dividend, divisor);
    if (llvm::none_of(prepared, [](const PreparedProjection &projection) {
          return projection.available;
        }))
      return false;

    SmallVector<uint8_t> dividendInvariant(prepared.size(), 0);
    SmallVector<uint8_t> divisorInvariant(prepared.size(), 0);
    getRemainderProjectionInvariance(dividend, divisor, prepared,
                                     dividendInvariant, divisorInvariant);
    for (size_t index : llvm::seq<size_t>(0, prepared.size())) {
      if (!prepared[index].available || !dividendInvariant[index] ||
          !divisorInvariant[index])
        continue;
      if (projectionProvesNonnegative(root, target,
                                      prepared[index].substitutions))
        return true;
    }
    return false;
  }

  SmallVector<PreparedProjection> prepareExecutionProjections(
      Value rootValue, Value targetValue, const SymbolicProofValue &root,
      const SymbolicProofValue &dividend, const SymbolicProofValue &divisor) {
    SmallVector<std::optional<WorkitemProjection>> projections{std::nullopt};
    for (WorkitemProjection projection : getWorkitemProjections(
             rootValue, root, dividend, divisor, targetValue))
      projections.push_back(projection);

    SmallVector<PreparedProjection> prepared;
    prepared.reserve(projections.size());
    for (std::optional<WorkitemProjection> projection : projections) {
      FailureOr<SmallVector<sym::ExprSubstitution>> substitutions =
          buildExecutionProjection(rootValue, projection);
      if (failed(substitutions)) {
        prepared.push_back({});
        continue;
      }
      prepared.push_back({std::move(*substitutions), true});
    }
    return prepared;
  }

  void getValueProjectionInvariance(const SymbolicProofValue &value,
                                    ArrayRef<PreparedProjection> prepared,
                                    MutableArrayRef<uint8_t> invariant) {
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        sym::Analysis::create(store, value.assumptions);
    if (succeeded(analysis))
      getProjectionInvariance(**analysis, value, prepared, invariant);
  }

  void
  getRemainderProjectionInvariance(const SymbolicProofValue &dividend,
                                   const SymbolicProofValue &divisor,
                                   ArrayRef<PreparedProjection> prepared,
                                   MutableArrayRef<uint8_t> dividendInvariant,
                                   MutableArrayRef<uint8_t> divisorInvariant) {
    if (llvm::equal(dividend.assumptions, divisor.assumptions)) {
      FailureOr<std::unique_ptr<sym::Analysis>> analysis =
          sym::Analysis::create(store, dividend.assumptions);
      if (succeeded(analysis)) {
        getProjectionInvariance(**analysis, dividend, prepared,
                                dividendInvariant);
        getProjectionInvariance(**analysis, divisor, prepared,
                                divisorInvariant);
      }
      return;
    }
    getValueProjectionInvariance(dividend, prepared, dividendInvariant);
    getValueProjectionInvariance(divisor, prepared, divisorInvariant);
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
  llvm::DenseMap<RelationPair, PreparedRemainderRelation> remainderRelations;
  SymbolicRelationProofCache &proofCache;
  RelationCache relations;
  WaveDialect &dialect;
  DataFlowSolver &solver;
  sym::Store &store;
  ArrayRef<SlotMapping> slots;
  uint64_t &factDomainCount;
  Operation *access;
};

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

enum class RemainderPreparationResult {
  Unprepared,
  Ready,
  Ineligible,
  Retry,
  Failure,
};

struct RemainderBindingProof {
  sym::ExprHandle residual;
  RemainderPreparationResult result = RemainderPreparationResult::Unprepared;
  bool nonnegative = false;
};

static FailureOr<std::optional<sym::AffineDecomposition>>
getRemainderDecomposition(sym::Analysis &analysis, const SlotMapping &slot,
                          const NamedBinding &binding, int64_t elementBits) {
  FailureOr<sym::ExprHandle> symbol = analysis.composeSymbol(binding.name);
  FailureOr<sym::ExprHandle> scale = analysis.composeInteger(elementBits);
  if (failed(symbol) || failed(scale))
    return failure();
  std::optional<sym::AffineDecomposition> decomposition =
      analysis.affineDecompose(slot.bitOffset, *symbol);
  if (!decomposition || analysis.equivalent(decomposition->coefficient,
                                            *scale) != sym::CheckResult::True)
    return std::optional<sym::AffineDecomposition>{};
  return decomposition;
}

static FailureOr<sym::CheckResult>
checkBindingNonnegative(sym::Analysis &analysis, const NamedBinding &binding) {
  FailureOr<sym::ExprHandle> symbol = analysis.composeSymbol(binding.name);
  FailureOr<sym::ExprHandle> zero = analysis.composeInteger(0);
  if (failed(symbol) || failed(zero))
    return failure();
  FailureOr<sym::PredHandle> nonnegative =
      analysis.compare(*symbol, sym::PredCmpOp::Ge, *zero);
  if (failed(nonnegative))
    return failure();
  return analysis.check(*nonnegative);
}

static RemainderPreparationResult
prepareRemainderBinding(sym::Analysis &analysis, const SlotMapping &slot,
                        size_t index, int64_t elementBits, bool retryIncomplete,
                        SmallVectorImpl<RemainderBindingProof> &proofs) {
  RemainderBindingProof &proof = proofs[index];
  if (proof.result != RemainderPreparationResult::Unprepared)
    return proof.result;

  RemainderPreparationResult incomplete =
      retryIncomplete ? RemainderPreparationResult::Retry
                      : RemainderPreparationResult::Ineligible;
  RemainderPreparationResult queryFailure =
      retryIncomplete ? RemainderPreparationResult::Retry
                      : RemainderPreparationResult::Failure;
  const NamedBinding &binding = slot.bindings[index];
  FailureOr<std::optional<sym::AffineDecomposition>> decomposition =
      getRemainderDecomposition(analysis, slot, binding, elementBits);
  if (failed(decomposition))
    return proof.result = queryFailure;
  if (!*decomposition)
    return proof.result = incomplete;

  FailureOr<sym::CheckResult> nonnegativeResult =
      checkBindingNonnegative(analysis, binding);
  if (failed(nonnegativeResult))
    return proof.result = queryFailure;
  if (retryIncomplete && *nonnegativeResult == sym::CheckResult::Unknown)
    return proof.result = RemainderPreparationResult::Retry;

  proof.residual = (*decomposition)->residual;
  proof.nonnegative = *nonnegativeResult == sym::CheckResult::True;
  return proof.result = RemainderPreparationResult::Ready;
}

static RemainderPreparationResult prepareRemainderCandidate(
    sym::Analysis &analysis, const SlotMapping &lhs, const SlotMapping &rhs,
    PreparedRemainderCandidate &candidate, int64_t elementBits,
    bool retryIncomplete, SmallVectorImpl<RemainderBindingProof> &lhsProofs,
    SmallVectorImpl<RemainderBindingProof> &rhsProofs) {
  RemainderPreparationResult lhsResult =
      prepareRemainderBinding(analysis, lhs, candidate.lhsBinding, elementBits,
                              retryIncomplete, lhsProofs);
  RemainderPreparationResult rhsResult =
      prepareRemainderBinding(analysis, rhs, candidate.rhsBinding, elementBits,
                              retryIncomplete, rhsProofs);
  if (lhsResult == RemainderPreparationResult::Failure ||
      rhsResult == RemainderPreparationResult::Failure)
    return RemainderPreparationResult::Failure;
  if (lhsResult == RemainderPreparationResult::Retry ||
      rhsResult == RemainderPreparationResult::Retry)
    return RemainderPreparationResult::Retry;
  if (lhsResult == RemainderPreparationResult::Ineligible ||
      rhsResult == RemainderPreparationResult::Ineligible)
    return RemainderPreparationResult::Ineligible;

  RemainderBindingProof &lhsProof = lhsProofs[candidate.lhsBinding];
  RemainderBindingProof &rhsProof = rhsProofs[candidate.rhsBinding];
  sym::CheckResult residuals =
      analysis.equivalent(lhsProof.residual, rhsProof.residual);
  if (residuals == sym::CheckResult::False)
    return RemainderPreparationResult::Ineligible;
  if (residuals == sym::CheckResult::Unknown)
    return retryIncomplete ? RemainderPreparationResult::Retry
                           : RemainderPreparationResult::Ineligible;
  candidate.lhsBindingNonnegative = lhsProof.nonnegative;
  candidate.rhsBindingNonnegative = rhsProof.nonnegative;
  return RemainderPreparationResult::Ready;
}

static bool provesModSuccessor(sym::Analysis &analysis,
                               sym::ExprHandle dividend,
                               sym::ExprHandle positiveDivisor) {
  FailureOr<sym::ExprHandle> one = analysis.composeInteger(1);
  if (failed(one))
    return false;
  FailureOr<sym::ExprHandle> nextDividend =
      analysis.compose(dividend, sym::ExprBinaryOp::Add, *one);
  FailureOr<sym::ExprHandle> remainder =
      analysis.compose(dividend, sym::ExprBinaryOp::Mod, positiveDivisor);
  if (failed(nextDividend) || failed(remainder))
    return false;
  FailureOr<sym::ExprHandle> nextRemainder =
      analysis.compose(*nextDividend, sym::ExprBinaryOp::Mod, positiveDivisor);
  FailureOr<sym::ExprHandle> expected =
      analysis.compose(*remainder, sym::ExprBinaryOp::Add, *one);
  return succeeded(nextRemainder) && succeeded(expected) &&
         analysis.equivalent(*nextRemainder, *expected) ==
             sym::CheckResult::True;
}

static bool provesModSuccessor(sym::Store &store,
                               const PreparedRemainderCandidate &candidate,
                               sym::PredHandle defined,
                               sym::PredHandle divisorSign,
                               bool negateDivisor) {
  SmallVector<sym::PredHandle> assumptions(candidate.assumptions);
  assumptions.push_back(defined);
  assumptions.push_back(divisorSign);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, assumptions);
  if (failed(analysis))
    return false;
  sym::ExprHandle divisor = candidate.lhsDivisor;
  if (negateDivisor) {
    FailureOr<sym::ExprHandle> negated = (*analysis)->composeNeg(divisor);
    if (failed(negated))
      return false;
    divisor = *negated;
  }
  return provesModSuccessor(**analysis, candidate.lhsDividend, divisor);
}

struct RemainderSuccessorProofPlan {
  std::optional<bool> directResult;
  sym::PredHandle defined;
  sym::PredHandle positive;
  sym::PredHandle negative;
};

struct RemainderSignPredicates {
  sym::PredHandle positive;
  sym::PredHandle negative;
};

static bool
provesNonnegativeRemainderDividend(sym::Analysis &analysis,
                                   const PreparedRemainderCandidate &candidate,
                                   sym::ExprHandle zero) {
  FailureOr<sym::PredHandle> nonnegative =
      analysis.compare(candidate.lhsDividend, sym::PredCmpOp::Ge, zero);
  return succeeded(nonnegative) &&
         analysis.check(*nonnegative) == sym::CheckResult::True;
}

static FailureOr<RemainderSignPredicates>
composeRemainderSignPredicates(sym::Analysis &analysis,
                               const PreparedRemainderCandidate &candidate,
                               sym::ExprHandle zero) {
  FailureOr<sym::PredHandle> positive =
      analysis.compare(candidate.lhsDivisor, sym::PredCmpOp::Gt, zero);
  FailureOr<sym::PredHandle> negative =
      analysis.compare(candidate.lhsDivisor, sym::PredCmpOp::Lt, zero);
  if (failed(positive) || failed(negative))
    return failure();
  return RemainderSignPredicates{*positive, *negative};
}

static bool
proveKnownSignRemainderSuccessor(sym::Analysis &analysis,
                                 const PreparedRemainderCandidate &candidate,
                                 const RemainderSignPredicates &signs) {
  sym::PredHandle sign = candidate.divisorSign == RemainderDivisorSign::Positive
                             ? signs.positive
                             : signs.negative;
  if (failed(analysis.assume(sign)))
    return false;
  sym::ExprHandle divisor = candidate.lhsDivisor;
  if (candidate.divisorSign == RemainderDivisorSign::Negative) {
    FailureOr<sym::ExprHandle> negated = analysis.composeNeg(divisor);
    if (failed(negated))
      return false;
    divisor = *negated;
  }
  return provesModSuccessor(analysis, candidate.lhsDividend, divisor);
}

static std::optional<RemainderSuccessorProofPlan>
buildSignedRemainderSuccessorProofPlan(
    sym::Analysis &analysis, const PreparedRemainderCandidate &candidate,
    sym::ExprHandle zero, sym::PredHandle defined, bool nonnegativeRemainders) {
  if (!nonnegativeRemainders &&
      !provesNonnegativeRemainderDividend(analysis, candidate, zero))
    return std::nullopt;
  FailureOr<RemainderSignPredicates> signs =
      composeRemainderSignPredicates(analysis, candidate, zero);
  if (failed(signs))
    return std::nullopt;

  RemainderSuccessorProofPlan plan;
  plan.defined = defined;
  plan.positive = signs->positive;
  plan.negative = signs->negative;
  if (candidate.divisorSign == RemainderDivisorSign::Unknown)
    return plan;
  plan.directResult =
      proveKnownSignRemainderSuccessor(analysis, candidate, *signs);
  return plan;
}

static std::optional<RemainderSuccessorProofPlan>
buildRemainderSuccessorProofPlan(sym::Store &store,
                                 const PreparedRemainderCandidate &candidate,
                                 bool nonnegativeRemainders) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, candidate.assumptions);
  if (failed(analysis))
    return std::nullopt;
  FailureOr<sym::ExprHandle> zero = (*analysis)->composeInteger(0);
  if (failed(zero))
    return std::nullopt;
  sym::PredCmpOp definedComparison = candidate.kind == BinaryKind::RemUI
                                         ? sym::PredCmpOp::Gt
                                         : sym::PredCmpOp::Ne;
  FailureOr<sym::PredHandle> defined =
      (*analysis)->compare(candidate.lhsDivisor, definedComparison, *zero);
  if (failed(defined) || failed((*analysis)->assume(*defined)))
    return std::nullopt;

  if (candidate.kind == BinaryKind::RemUI) {
    RemainderSuccessorProofPlan plan;
    plan.defined = *defined;
    plan.directResult = provesModSuccessor(**analysis, candidate.lhsDividend,
                                           candidate.lhsDivisor);
    return plan;
  }
  return buildSignedRemainderSuccessorProofPlan(
      **analysis, candidate, *zero, *defined, nonnegativeRemainders);
}

static bool proveRemainderSuccessor(sym::Store &store,
                                    const PreparedRemainderCandidate &candidate,
                                    bool nonnegativeRemainders) {
  std::optional<RemainderSuccessorProofPlan> plan =
      buildRemainderSuccessorProofPlan(store, candidate, nonnegativeRemainders);
  if (!plan)
    return false;
  if (plan->directResult.has_value())
    return *plan->directResult;
  return provesModSuccessor(store, candidate, plan->defined, plan->positive,
                            /*negateDivisor=*/false) &&
         provesModSuccessor(store, candidate, plan->defined, plan->negative,
                            /*negateDivisor=*/true);
}

static std::optional<PreparedRemainderCandidate> buildRemainderCandidate(
    RemainderProofContext &proofContext, const NamedBinding &lhsBinding,
    const NamedBinding &rhsBinding, size_t lhsIndex, size_t rhsIndex) {
  BinaryOp lhsRemainder = findRemainder(lhsBinding.value);
  BinaryOp rhsRemainder = findRemainder(rhsBinding.value);
  if (!lhsRemainder || !rhsRemainder ||
      lhsRemainder.getKind() != rhsRemainder.getKind())
    return std::nullopt;
  std::optional<SymbolicProofValue> lhsDividend =
      proofContext.get(lhsRemainder.getLhs());
  std::optional<SymbolicProofValue> rhsDividend =
      proofContext.get(rhsRemainder.getLhs());
  std::optional<SymbolicProofValue> lhsDivisor =
      proofContext.get(lhsRemainder.getRhs());
  std::optional<SymbolicProofValue> rhsDivisor =
      proofContext.get(rhsRemainder.getRhs());
  if (!lhsDividend || !rhsDividend || !lhsDivisor || !rhsDivisor)
    return std::nullopt;
  PreparedRemainderCandidate candidate;
  llvm::append_range(candidate.assumptions, lhsDividend->assumptions);
  llvm::append_range(candidate.assumptions, rhsDividend->assumptions);
  llvm::append_range(candidate.assumptions, lhsDivisor->assumptions);
  llvm::append_range(candidate.assumptions, rhsDivisor->assumptions);
  candidate.lhsRemainder = lhsRemainder;
  candidate.rhsRemainder = rhsRemainder;
  candidate.lhsDividend = lhsDividend->expression;
  candidate.rhsDividend = rhsDividend->expression;
  candidate.lhsDivisor = lhsDivisor->expression;
  candidate.rhsDivisor = rhsDivisor->expression;
  candidate.kind = lhsRemainder.getKind();
  candidate.lhsBinding = lhsIndex;
  candidate.rhsBinding = rhsIndex;
  return candidate;
}

static FailureOr<sym::CheckResult>
hasSuccessorDividends(sym::Analysis &analysis,
                      const PreparedRemainderCandidate &candidate) {
  std::optional<int64_t> difference =
      analysis.constantDifference(candidate.rhsDividend, candidate.lhsDividend);
  if (difference)
    return *difference == 1 ? sym::CheckResult::True : sym::CheckResult::False;
  FailureOr<sym::ExprHandle> one = analysis.composeInteger(1);
  if (failed(one))
    return failure();
  FailureOr<sym::ExprHandle> next =
      analysis.compose(candidate.lhsDividend, sym::ExprBinaryOp::Add, *one);
  if (failed(next))
    return failure();
  return analysis.equivalent(*next, candidate.rhsDividend);
}

static RemainderPreparationResult
getRemainderQueryFailure(bool retryIncomplete) {
  return retryIncomplete ? RemainderPreparationResult::Retry
                         : RemainderPreparationResult::Failure;
}

static RemainderPreparationResult
getIncompleteRemainderResult(bool retryIncomplete) {
  return retryIncomplete ? RemainderPreparationResult::Retry
                         : RemainderPreparationResult::Ineligible;
}

static std::optional<RemainderPreparationResult>
validateRemainderSuccessorOperands(sym::Analysis &analysis,
                                   const PreparedRemainderCandidate &candidate,
                                   bool retryIncomplete) {
  FailureOr<sym::CheckResult> successorDividends =
      hasSuccessorDividends(analysis, candidate);
  if (failed(successorDividends))
    return getRemainderQueryFailure(retryIncomplete);
  sym::CheckResult sameDivisor =
      analysis.equivalent(candidate.lhsDivisor, candidate.rhsDivisor);
  if (*successorDividends == sym::CheckResult::False ||
      sameDivisor == sym::CheckResult::False)
    return RemainderPreparationResult::Ineligible;
  if (*successorDividends == sym::CheckResult::Unknown ||
      sameDivisor == sym::CheckResult::Unknown)
    return getIncompleteRemainderResult(retryIncomplete);
  return std::nullopt;
}

static RemainderPreparationResult
prepareUnsignedRemainderSuccessor(PreparedRemainderCandidate &candidate,
                                  sym::CheckResult positive,
                                  bool retryIncomplete) {
  if (positive == sym::CheckResult::Unknown)
    return getIncompleteRemainderResult(retryIncomplete);
  if (positive == sym::CheckResult::False)
    return RemainderPreparationResult::Ineligible;
  candidate.successorProven = true;
  return RemainderPreparationResult::Ready;
}

static RemainderDivisorSign
classifyRemainderDivisorSign(sym::CheckResult positive,
                             sym::CheckResult negative) {
  if (positive == sym::CheckResult::True || negative == sym::CheckResult::False)
    return RemainderDivisorSign::Positive;
  if (negative == sym::CheckResult::True || positive == sym::CheckResult::False)
    return RemainderDivisorSign::Negative;
  return RemainderDivisorSign::Unknown;
}

static RemainderPreparationResult
prepareSignedRemainderSuccessor(sym::Analysis &analysis, sym::ExprHandle zero,
                                PreparedRemainderCandidate &candidate,
                                sym::CheckResult positive,
                                bool retryIncomplete) {
  FailureOr<sym::PredHandle> negative =
      analysis.compare(candidate.lhsDivisor, sym::PredCmpOp::Lt, zero);
  if (failed(negative))
    return getRemainderQueryFailure(retryIncomplete);
  RemainderDivisorSign sign =
      classifyRemainderDivisorSign(positive, analysis.check(*negative));
  if (retryIncomplete && sign == RemainderDivisorSign::Unknown)
    return RemainderPreparationResult::Retry;
  candidate.divisorSign = sign;
  candidate.successorProven = true;
  return RemainderPreparationResult::Ready;
}

static RemainderPreparationResult
prepareRemainderSuccessor(sym::Analysis &analysis, sym::ExprHandle zero,
                          PreparedRemainderCandidate &candidate,
                          bool retryIncomplete) {
  std::optional<RemainderPreparationResult> invalid =
      validateRemainderSuccessorOperands(analysis, candidate, retryIncomplete);
  if (invalid)
    return *invalid;

  FailureOr<sym::PredHandle> positive =
      analysis.compare(candidate.lhsDivisor, sym::PredCmpOp::Gt, zero);
  if (failed(positive))
    return getRemainderQueryFailure(retryIncomplete);
  sym::CheckResult positiveResult = analysis.check(*positive);
  if (candidate.kind == BinaryKind::RemUI)
    return prepareUnsignedRemainderSuccessor(candidate, positiveResult,
                                             retryIncomplete);
  return prepareSignedRemainderSuccessor(analysis, zero, candidate,
                                         positiveResult, retryIncomplete);
}

class RemainderRelationPreparer {
public:
  RemainderRelationPreparer(
      RemainderProofContext &proofContext, sym::Store &store,
      ArrayRef<SlotMapping> slots, SymbolicRelationProofCache &proofCache,
      llvm::DenseMap<RelationPair, PreparedRemainderRelation> &relations,
      int64_t elementBits)
      : proofContext(proofContext), store(store), slots(slots),
        proofCache(proofCache), relations(relations), elementBits(elementBits) {
  }

  void prepare(ArrayRef<RelationPair> pairs, bool directed) {
    collectPairs(pairs, directed);
    buildCandidates();
    preparePairs();
    prepareSuccessors();
    eraseUnavailable();
  }

private:
  struct PairPreparation {
    SmallVector<RemainderPreparationResult> results;
    SmallVector<std::optional<std::pair<sym::ExprHandle, sym::ExprHandle>>>
        bindingSymbols;
    RelationPair pair;
  };

  using CandidateTask = std::pair<RelationPair, size_t>;

  void appendPair(RelationPair pair) {
    if (pair.first == pair.second || pair.first >= slots.size() ||
        pair.second >= slots.size())
      return;
    auto existing = relations.find(pair);
    if (existing != relations.end() && !existing->second.available)
      relations.erase(existing);
    if (relations.try_emplace(pair).second)
      directedPairs.push_back(pair);
  }

  void appendUnprovenDirections(RelationPair pair,
                                const RelationProof &relation) {
    std::array<std::pair<RelationPair, bool>, 2> directions{{
        {{pair.first, pair.second},
         relation.available && relation.lowToHighAdjacent},
        {{pair.second, pair.first},
         relation.available && relation.highToLowAdjacent},
    }};
    for (auto [direction, directlyAdjacent] : directions)
      if (!directlyAdjacent)
        appendPair(direction);
  }

  void collectPairs(ArrayRef<RelationPair> pairs, bool directed) {
    if (directed) {
      for (RelationPair pair : pairs)
        appendPair(pair);
      return;
    }
    for (RelationPair pair : pairs) {
      if (pair.first == pair.second || pair.first >= slots.size() ||
          pair.second >= slots.size())
        continue;
      if (pair.first > pair.second)
        std::swap(pair.first, pair.second);
      const RelationProof *relation = proofContext.lookupPreparedRelation(
          slots[pair.first], slots[pair.second]);
      if (relation && relation->baseTargetProven)
        appendUnprovenDirections(pair, *relation);
    }
  }

  void buildCandidates(RelationPair pair) {
    PreparedRemainderRelation &relation = relations[pair];
    const SlotMapping &lhs = slots[pair.first];
    const SlotMapping &rhs = slots[pair.second];
    for (auto [lhsIndex, lhsBinding] : llvm::enumerate(lhs.bindings))
      for (auto [rhsIndex, rhsBinding] : llvm::enumerate(rhs.bindings))
        if (std::optional<PreparedRemainderCandidate> candidate =
                buildRemainderCandidate(proofContext, lhsBinding, rhsBinding,
                                        lhsIndex, rhsIndex))
          relation.candidates.push_back(std::move(*candidate));
    if (relation.candidates.empty())
      relation.available = true;
  }

  void buildCandidates() {
    for (RelationPair pair : directedPairs)
      buildCandidates(pair);
  }

  SmallVector<ExactFactDomainGroup> buildPairGroups() {
    SmallVector<ExactFactDomainGroup> groups;
    llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> buckets;
    for (auto [index, pair] : llvm::enumerate(directedPairs)) {
      if (relations[pair].candidates.empty())
        continue;
      appendExactFactDomainTask(
          combineAssumptions(slots[pair.first], slots[pair.second]), index,
          groups, buckets);
    }
    return groups;
  }

  PairPreparation buildPairPreparation(ArrayRef<sym::PredHandle> assumptions,
                                       RelationPair pair) {
    const SlotMapping &lhs = slots[pair.first];
    const SlotMapping &rhs = slots[pair.second];
    PreparedRemainderRelation &relation = relations[pair];
    PairPreparation preparation{{}, {}, pair};
    preparation.results.assign(relation.candidates.size(),
                               RemainderPreparationResult::Retry);
    preparation.bindingSymbols.resize(relation.candidates.size());
    for (auto [candidateIndex, candidate] :
         llvm::enumerate(relation.candidates))
      restoreCachedPreparation(assumptions, lhs, rhs, candidateIndex, candidate,
                               preparation);
    return preparation;
  }

  void restoreCachedPreparation(ArrayRef<sym::PredHandle> assumptions,
                                const SlotMapping &lhs, const SlotMapping &rhs,
                                size_t candidateIndex,
                                PreparedRemainderCandidate &candidate,
                                PairPreparation &preparation) {
    FailureOr<sym::ExprHandle> lhsSymbol =
        sym::composeExprSym(store, lhs.bindings[candidate.lhsBinding].name);
    FailureOr<sym::ExprHandle> rhsSymbol =
        sym::composeExprSym(store, rhs.bindings[candidate.rhsBinding].name);
    if (failed(lhsSymbol) || failed(rhsSymbol))
      return;
    preparation.bindingSymbols[candidateIndex] =
        std::pair{*lhsSymbol, *rhsSymbol};
    std::optional<RemainderPairPreparationProof> cached =
        proofCache.lookupRemainderPairPreparation(assumptions, lhs.bitOffset,
                                                  rhs.bitOffset, *lhsSymbol,
                                                  *rhsSymbol, elementBits);
    if (!cached)
      return;
    preparation.results[candidateIndex] =
        cached->ready ? RemainderPreparationResult::Ready
                      : RemainderPreparationResult::Ineligible;
    candidate.lhsBindingNonnegative = cached->lhsBindingNonnegative;
    candidate.rhsBindingNonnegative = cached->rhsBindingNonnegative;
  }

  SmallVector<PairPreparation>
  buildPairPreparations(const ExactFactDomainGroup &group) {
    SmallVector<PairPreparation> preparations;
    preparations.reserve(group.tasks.size());
    for (size_t pairIndex : group.tasks)
      preparations.push_back(
          buildPairPreparation(group.assumptions, directedPairs[pairIndex]));
    return preparations;
  }

  static bool needsAnalysis(ArrayRef<PairPreparation> preparations) {
    return llvm::any_of(preparations, [](const PairPreparation &preparation) {
      return llvm::is_contained(preparation.results,
                                RemainderPreparationResult::Retry);
    });
  }

  void cachePreparation(ArrayRef<sym::PredHandle> assumptions,
                        const PairPreparation &preparation,
                        size_t candidateIndex,
                        const PreparedRemainderCandidate &candidate,
                        RemainderPreparationResult result) {
    if (result != RemainderPreparationResult::Ready &&
        result != RemainderPreparationResult::Ineligible)
      return;
    const auto &symbols = preparation.bindingSymbols[candidateIndex];
    if (!symbols)
      return;
    const SlotMapping &lhs = slots[preparation.pair.first];
    const SlotMapping &rhs = slots[preparation.pair.second];
    proofCache.insertRemainderPairPreparation(
        assumptions, lhs.bitOffset, rhs.bitOffset, symbols->first,
        symbols->second, elementBits,
        {/*ready=*/result == RemainderPreparationResult::Ready,
         candidate.lhsBindingNonnegative, candidate.rhsBindingNonnegative});
  }

  void preparePairCandidates(sym::Analysis &analysis,
                             ArrayRef<sym::PredHandle> assumptions,
                             MutableArrayRef<PairPreparation> preparations,
                             bool retryIncomplete) {
    for (PairPreparation &preparation : preparations) {
      const SlotMapping &lhs = slots[preparation.pair.first];
      const SlotMapping &rhs = slots[preparation.pair.second];
      PreparedRemainderRelation &relation = relations[preparation.pair];
      SmallVector<RemainderBindingProof> lhsProofs(lhs.bindings.size());
      SmallVector<RemainderBindingProof> rhsProofs(rhs.bindings.size());
      for (auto [candidateIndex, candidate] :
           llvm::enumerate(relation.candidates)) {
        if (preparation.results[candidateIndex] !=
            RemainderPreparationResult::Retry)
          continue;
        preparation.results[candidateIndex] = prepareRemainderCandidate(
            analysis, lhs, rhs, candidate, elementBits, retryIncomplete,
            lhsProofs, rhsProofs);
        cachePreparation(assumptions, preparation, candidateIndex, candidate,
                         preparation.results[candidateIndex]);
      }
    }
  }

  void finalizePairPreparation(PairPreparation &preparation) {
    PreparedRemainderRelation &relation = relations[preparation.pair];
    if (llvm::is_contained(preparation.results,
                           RemainderPreparationResult::Failure) ||
        llvm::is_contained(preparation.results,
                           RemainderPreparationResult::Retry)) {
      relation.available = false;
      return;
    }
    SmallVector<PreparedRemainderCandidate> candidates;
    candidates.reserve(relation.candidates.size());
    for (auto [candidateIndex, candidate] :
         llvm::enumerate(relation.candidates))
      if (preparation.results[candidateIndex] ==
          RemainderPreparationResult::Ready)
        candidates.push_back(std::move(candidate));
    relation.candidates = std::move(candidates);
    relation.available = true;
  }

  void preparePairGroup(ExactFactDomainGroup &group) {
    SmallVector<PairPreparation> preparations = buildPairPreparations(group);
    if (needsAnalysis(preparations)) {
      FailureOr<std::unique_ptr<sym::Analysis>> direct =
          sym::Analysis::createDirect(store, group.assumptions);
      if (succeeded(direct))
        preparePairCandidates(**direct, group.assumptions, preparations,
                              /*retryIncomplete=*/true);
    }
    if (needsAnalysis(preparations)) {
      FailureOr<std::unique_ptr<sym::Analysis>> strong =
          sym::Analysis::create(store, group.assumptions);
      if (succeeded(strong))
        preparePairCandidates(**strong, group.assumptions, preparations,
                              /*retryIncomplete=*/false);
    }
    for (PairPreparation &preparation : preparations)
      finalizePairPreparation(preparation);
  }

  void preparePairs() {
    SmallVector<ExactFactDomainGroup> groups = buildPairGroups();
    for (ExactFactDomainGroup &group : groups)
      preparePairGroup(group);
  }

  SmallVector<ExactFactDomainGroup> buildSuccessorGroups() {
    SmallVector<ExactFactDomainGroup> groups;
    llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> buckets;
    for (RelationPair pair : directedPairs) {
      PreparedRemainderRelation &relation = relations[pair];
      if (!relation.available)
        continue;
      for (size_t index : llvm::seq<size_t>(0, relation.candidates.size())) {
        size_t task = candidateTasks.size();
        candidateTasks.push_back({pair, index});
        appendExactFactDomainTask(relation.candidates[index].assumptions, task,
                                  groups, buckets);
      }
    }
    return groups;
  }

  void prepareSuccessorCandidates(
      sym::Analysis &analysis, const ExactFactDomainGroup &group,
      MutableArrayRef<RemainderPreparationResult> results,
      bool retryIncomplete) {
    FailureOr<sym::ExprHandle> zero = analysis.composeInteger(0);
    if (failed(zero))
      return;
    for (auto [groupIndex, task] : llvm::enumerate(group.tasks)) {
      if (!retryIncomplete &&
          results[groupIndex] != RemainderPreparationResult::Retry)
        continue;
      auto [pair, candidateIndex] = candidateTasks[task];
      PreparedRemainderCandidate &candidate =
          relations[pair].candidates[candidateIndex];
      results[groupIndex] = prepareRemainderSuccessor(
          analysis, *zero, candidate, retryIncomplete);
    }
  }

  void markFailedSuccessors(const ExactFactDomainGroup &group,
                            ArrayRef<RemainderPreparationResult> results) {
    for (auto [groupIndex, task] : llvm::enumerate(group.tasks)) {
      RemainderPreparationResult result = results[groupIndex];
      if (result == RemainderPreparationResult::Failure ||
          result == RemainderPreparationResult::Retry)
        relations[candidateTasks[task].first].available = false;
    }
  }

  void prepareSuccessorGroup(const ExactFactDomainGroup &group) {
    SmallVector<RemainderPreparationResult> results(
        group.tasks.size(), RemainderPreparationResult::Retry);
    {
      FailureOr<std::unique_ptr<sym::Analysis>> direct =
          sym::Analysis::createDirect(store, group.assumptions);
      if (succeeded(direct))
        prepareSuccessorCandidates(**direct, group, results,
                                   /*retryIncomplete=*/true);
    }
    if (llvm::is_contained(results, RemainderPreparationResult::Retry)) {
      FailureOr<std::unique_ptr<sym::Analysis>> strong =
          sym::Analysis::create(store, group.assumptions);
      if (succeeded(strong))
        prepareSuccessorCandidates(**strong, group, results,
                                   /*retryIncomplete=*/false);
    }
    markFailedSuccessors(group, results);
  }

  void prepareSuccessors() {
    SmallVector<ExactFactDomainGroup> groups = buildSuccessorGroups();
    for (const ExactFactDomainGroup &group : groups)
      prepareSuccessorGroup(group);
  }

  void eraseUnavailable() {
    for (RelationPair pair : directedPairs)
      if (!relations[pair].available)
        relations.erase(pair);
  }

  RemainderProofContext &proofContext;
  sym::Store &store;
  ArrayRef<SlotMapping> slots;
  SymbolicRelationProofCache &proofCache;
  llvm::DenseMap<RelationPair, PreparedRemainderRelation> &relations;
  int64_t elementBits;
  SmallVector<RelationPair> directedPairs;
  SmallVector<CandidateTask> candidateTasks;
};

void RemainderProofContext::prepareRemainderRelations(
    ArrayRef<RelationPair> pairs, int64_t elementBits, bool directed) {
  RemainderRelationPreparer(*this, store, slots, proofCache, remainderRelations,
                            elementBits)
      .prepare(pairs, directed);
}

static bool isRemainderNonnegative(const SlotMapping &slot,
                                   const NamedBinding &binding,
                                   BinaryOp remainder, bool bindingNonnegative,
                                   RemainderProofContext &proofContext) {
  return bindingNonnegative ||
         proofContext.isNonnegative(remainder.getResult()) ||
         proofContext.isNonnegativeFromMaterializations(slot, binding,
                                                        remainder);
}

static bool proveRemainderAdjacent(sym::Store &store, const SlotMapping &lhs,
                                   const SlotMapping &rhs, int64_t elementBits,
                                   RemainderProofContext &proofContext) {
  const PreparedRemainderRelation *relation =
      proofContext.lookupRemainderRelation(lhs, rhs);
  if (!relation) {
    proofContext.prepareRemainderRelation(lhs, rhs, elementBits);
    relation = proofContext.lookupRemainderRelation(lhs, rhs);
  }
  if (!relation)
    return false;
  for (const PreparedRemainderCandidate &candidate : relation->candidates) {
    if (!candidate.successorProven ||
        candidate.lhsBinding >= lhs.bindings.size() ||
        candidate.rhsBinding >= rhs.bindings.size())
      continue;
    const NamedBinding &lhsBinding = lhs.bindings[candidate.lhsBinding];
    const NamedBinding &rhsBinding = rhs.bindings[candidate.rhsBinding];
    bool nonnegativeRemainders =
        isRemainderNonnegative(lhs, lhsBinding, candidate.lhsRemainder,
                               candidate.lhsBindingNonnegative, proofContext) &&
        isRemainderNonnegative(rhs, rhsBinding, candidate.rhsRemainder,
                               candidate.rhsBindingNonnegative, proofContext);
    if (proveRemainderSuccessor(store, candidate, nonnegativeRemainders))
      return true;
  }
  return false;
}

static bool samePoint(sym::Store &store, const SlotMapping &lhs,
                      const SlotMapping &rhs,
                      RemainderProofContext &proofContext) {
  if (const RelationProof *proof =
          proofContext.lookupPreparedRelation(lhs, rhs)) {
    if (!proof->baseTargetProven || !proof->sameBitOffset)
      return false;
    return proofContext.sameActivation(lhs, rhs);
  }
  SmallVector<sym::PredHandle> assumptions = combineAssumptions(lhs, rhs);
  {
    FailureOr<std::unique_ptr<sym::Analysis>> created =
        sym::Analysis::create(store, assumptions);
    if (failed(created))
      return false;
    sym::Analysis &analysis = **created;
    if (analysis.equivalent(lhs.base, rhs.base) != sym::CheckResult::True ||
        analysis.equivalent(lhs.targetBlock, rhs.targetBlock) !=
            sym::CheckResult::True ||
        analysis.equivalent(lhs.bitOffset, rhs.bitOffset) !=
            sym::CheckResult::True)
      return false;
  }
  return proofContext.sameActivation(lhs, rhs);
}

static std::optional<bool>
getPreparedAddressAdjacency(const SlotMapping &lhs, const SlotMapping &rhs,
                            const RelationProof &proof) {
  if (!proof.baseTargetProven)
    return std::nullopt;
  return lhs.proofIndex < rhs.proofIndex ? proof.lowToHighAdjacent
                                         : proof.highToLowAdjacent;
}

static std::optional<bool> proveDirectAddressAdjacency(sym::Store &store,
                                                       const SlotMapping &lhs,
                                                       const SlotMapping &rhs,
                                                       int64_t elementBits) {
  SmallVector<sym::PredHandle> assumptions = combineAssumptions(lhs, rhs);
  FailureOr<std::unique_ptr<sym::Analysis>> created =
      sym::Analysis::create(store, assumptions);
  if (failed(created))
    return std::nullopt;
  sym::Analysis &analysis = **created;
  if (analysis.equivalent(lhs.base, rhs.base) != sym::CheckResult::True ||
      analysis.equivalent(lhs.targetBlock, rhs.targetBlock) !=
          sym::CheckResult::True)
    return std::nullopt;
  FailureOr<sym::ExprHandle> delta = analysis.composeInteger(elementBits);
  if (failed(delta))
    return std::nullopt;
  FailureOr<sym::ExprHandle> expected =
      analysis.compose(lhs.bitOffset, sym::ExprBinaryOp::Add, *delta);
  if (failed(expected))
    return std::nullopt;
  return analysis.equivalent(*expected, rhs.bitOffset) ==
         sym::CheckResult::True;
}

static std::optional<bool>
getAddressAdjacency(sym::Store &store, const SlotMapping &lhs,
                    const SlotMapping &rhs, int64_t elementBits,
                    RemainderProofContext &proofContext) {
  const RelationProof *proof = proofContext.lookupPreparedRelation(lhs, rhs);
  if (proof)
    return getPreparedAddressAdjacency(lhs, rhs, *proof);
  return proveDirectAddressAdjacency(store, lhs, rhs, elementBits);
}

static bool adjacent(sym::Store &store, const SlotMapping &lhs,
                     const SlotMapping &rhs, int64_t elementBits,
                     RemainderProofContext &proofContext) {
  std::optional<bool> directlyAdjacent =
      getAddressAdjacency(store, lhs, rhs, elementBits, proofContext);
  if (!directlyAdjacent)
    return false;
  if (!*directlyAdjacent &&
      !proveRemainderAdjacent(store, lhs, rhs, elementBits, proofContext))
    return false;
  return proofContext.sameActivation(lhs, rhs);
}

static SmallVector<SlotMapping, 4>
deduplicateGatherSlots(sym::Store &store, SmallVector<SlotMapping, 4> slots,
                       RemainderProofContext &proofContext) {
  SmallVector<SlotMapping, 4> unique;
  for (SlotMapping &slot : slots) {
    auto found = llvm::find_if(unique, [&](const SlotMapping &candidate) {
      return samePoint(store, candidate, slot, proofContext);
    });
    if (found == unique.end()) {
      unique.push_back(std::move(slot));
      continue;
    }
    llvm::append_range(found->logicalSlots, slot.logicalSlots);
  }
  return unique;
}

constexpr size_t kRelationPairByteBudget = 4 * 1024 * 1024;
constexpr size_t kMaxRelationBatchPairs =
    kRelationPairByteBudget / sizeof(RelationPair);

static std::optional<size_t> getUnorderedPairCount(size_t count) {
  if (count < 2)
    return 0;
  size_t lhs = count;
  size_t rhs = count - 1;
  if ((lhs & 1) == 0)
    lhs /= 2;
  else
    rhs /= 2;
  if (lhs > std::numeric_limits<size_t>::max() / rhs)
    return std::nullopt;
  return lhs * rhs;
}

static std::optional<SmallVector<RelationPair>>
buildAllRelationPairs(ArrayRef<SlotMapping> slots) {
  std::optional<size_t> pairCount = getUnorderedPairCount(slots.size());
  if (!pairCount || *pairCount > kMaxRelationBatchPairs)
    return std::nullopt;
  SmallVector<RelationPair> pairs;
  pairs.reserve(*pairCount);
  for (size_t low = 0; low < slots.size(); ++low)
    for (size_t high = low + 1; high < slots.size(); ++high)
      pairs.push_back({slots[low].proofIndex, slots[high].proofIndex});
  return pairs;
}

static void prepareAllRelations(ArrayRef<SlotMapping> slots,
                                int64_t elementBits,
                                RemainderProofContext &proofContext) {
  std::optional<SmallVector<RelationPair>> pairs = buildAllRelationPairs(slots);
  if (pairs)
    proofContext.prepareRelations(*pairs, elementBits);
}

using SparseAddressKey =
    std::pair<sym::ExprHandle, std::pair<sym::ExprHandle, sym::ExprHandle>>;

static FailureOr<sym::ExprHandle>
canonicalizeAddressExpr(sym::Analysis &analysis, sym::ExprHandle expression) {
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(expression);
  if (failed(simplified))
    return failure();
  FailureOr<sym::ExprHandle> expanded = analysis.expand(*simplified);
  if (failed(expanded))
    return *simplified;
  FailureOr<sym::ExprHandle> canonical = analysis.simplify(*expanded);
  if (succeeded(canonical))
    return *canonical;
  return *simplified;
}

using SparseOffsetBuckets = llvm::DenseMap<int64_t, SmallVector<unsigned>>;
using SparseAddressGroups =
    llvm::DenseMap<SparseAddressKey, SparseOffsetBuckets>;

class RelationPairBatch {
public:
  void append(const SlotMapping &lhs, const SlotMapping &rhs) {
    if (!valid || lhs.proofIndex == rhs.proofIndex)
      return;
    RelationPair pair{lhs.proofIndex, rhs.proofIndex};
    if (pair.first > pair.second)
      std::swap(pair.first, pair.second);
    if (!seen.insert(pair).second)
      return;
    if (pairs.size() == kMaxRelationBatchPairs) {
      valid = false;
      pairs.clear();
      seen.clear();
      return;
    }
    pairs.push_back(pair);
  }

  void prepare(int64_t elementBits, RemainderProofContext &proofContext) const {
    if (valid)
      proofContext.prepareRelations(pairs, elementBits);
  }

private:
  SmallVector<RelationPair> pairs;
  llvm::DenseSet<RelationPair> seen;
  bool valid = true;
};

static SparseAddressGroups
groupSparseAddresses(sym::Store &store, ArrayRef<SlotMapping> slots,
                     RemainderProofContext &proofContext) {
  SparseAddressGroups groups;
  SmallVector<ExactFactDomainGroup> factGroups;
  llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> buckets;
  for (auto [index, slot] : llvm::enumerate(slots))
    appendExactFactDomainTask(slot.assumptions, index, factGroups, buckets);
  for (ExactFactDomainGroup &factGroup : factGroups) {
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        sym::Analysis::create(store, factGroup.assumptions);
    if (failed(analysis))
      continue;
    proofContext.recordFactDomain();
    for (size_t index : factGroup.tasks) {
      const SlotMapping &slot = slots[index];
      FailureOr<sym::ExprHandle> base =
          canonicalizeAddressExpr(**analysis, slot.base);
      FailureOr<sym::ExprHandle> targetBlock =
          canonicalizeAddressExpr(**analysis, slot.targetBlock);
      std::optional<sym::SplitAdditiveConstant> offset =
          (*analysis)->splitAdditiveConstant(slot.bitOffset);
      if (failed(base) || failed(targetBlock) || !offset)
        continue;
      SparseAddressKey key{*base, {*targetBlock, offset->residual}};
      groups[key][offset->constant].push_back(index);
    }
  }
  return groups;
}

template <typename Callback>
static void forEachSparseGroupPair(SparseOffsetBuckets &buckets,
                                   int64_t elementBits, Callback callback) {
  for (auto &bucket : buckets) {
    int64_t offset = bucket.first;
    if (offset > std::numeric_limits<int64_t>::max() - elementBits)
      continue;
    auto successor = buckets.find(offset + elementBits);
    if (successor == buckets.end())
      continue;
    for (unsigned lhs : bucket.second)
      for (unsigned rhs : successor->second)
        callback(lhs, rhs);
  }
}

template <typename Callback>
static void forEachLogicalPacketPair(ArrayRef<SlotMapping> slots,
                                     Callback callback) {
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
        if (lhs != rhs)
          callback(lhs, rhs);
    }
  }
}

static void appendSparseGroupPairs(ArrayRef<SlotMapping> slots,
                                   SparseOffsetBuckets &buckets,
                                   int64_t elementBits,
                                   RelationPairBatch &batch) {
  forEachSparseGroupPair(buckets, elementBits, [&](unsigned lhs, unsigned rhs) {
    batch.append(slots[lhs], slots[rhs]);
  });
}

static void appendLogicalPacketPairs(ArrayRef<SlotMapping> slots,
                                     RelationPairBatch &batch) {
  forEachLogicalPacketPair(slots, [&](unsigned lhs, unsigned rhs) {
    batch.append(slots[lhs], slots[rhs]);
  });
}

static void
appendSparseGroupEdges(sym::Store &store, ArrayRef<SlotMapping> slots,
                       SparseOffsetBuckets &buckets, int64_t elementBits,
                       SmallVectorImpl<SmallVector<unsigned>> &edges,
                       RemainderProofContext &proofContext) {
  forEachSparseGroupPair(buckets, elementBits, [&](unsigned lhs, unsigned rhs) {
    if (adjacent(store, slots[lhs], slots[rhs], elementBits, proofContext))
      edges[lhs].push_back(rhs);
  });
}

static SmallVector<SmallVector<unsigned>>
buildSparseSuccessorGraph(sym::Store &store, ArrayRef<SlotMapping> slots,
                          int64_t elementBits,
                          RemainderProofContext &proofContext) {
  SparseAddressGroups groups = groupSparseAddresses(store, slots, proofContext);
  RelationPairBatch batch;
  for (auto &group : groups)
    appendSparseGroupPairs(slots, group.second, elementBits, batch);
  appendLogicalPacketPairs(slots, batch);
  batch.prepare(elementBits, proofContext);
  SmallVector<SmallVector<unsigned>> edges(slots.size());
  for (auto &group : groups)
    appendSparseGroupEdges(store, slots, group.second, elementBits, edges,
                           proofContext);
  return edges;
}

static std::optional<int64_t>
getCachedAddressDifference(const SlotMapping &lhs, const SlotMapping &rhs) {
  if (!(lhs.base == rhs.base) || !(lhs.targetBlock == rhs.targetBlock) ||
      !lhs.proofOffset || !rhs.proofOffset ||
      !(lhs.proofOffset->residual == rhs.proofOffset->residual))
    return std::nullopt;
  return llvm::checkedSub(rhs.proofOffset->constant, lhs.proofOffset->constant);
}

struct AddressProofClass {
  SmallVector<sym::PredHandle> assumptions;
  SmallVector<unsigned> members;
  AddressProofClassKey key;
};

static SmallVector<AddressProofClass>
buildAddressProofClasses(ArrayRef<SlotMapping> slots,
                         SmallVectorImpl<std::optional<unsigned>> &classIds) {
  SmallVector<AddressProofClass> classes;
  llvm::DenseMap<AddressProofClassKey, unsigned> indices;
  classIds.resize(slots.size());
  for (auto [index, slot] : llvm::enumerate(slots)) {
    if (!slot.proofOffset)
      continue;
    AddressProofClassKey key{slot.base,
                             {slot.targetBlock, slot.proofOffset->residual}};
    auto [found, inserted] = indices.try_emplace(key, classes.size());
    if (inserted)
      classes.push_back({{}, {}, key});
    classes[found->second].members.push_back(index);
    classIds[index] = found->second;
  }
  for (AddressProofClass &addressClass : classes) {
    addressClass.assumptions =
        getNonActivationAssumptions(slots[addressClass.members.front()]);
    for (unsigned member : ArrayRef(addressClass.members).drop_front()) {
      SmallVector<sym::PredHandle> assumptions =
          getNonActivationAssumptions(slots[member]);
      llvm::erase_if(addressClass.assumptions, [&](sym::PredHandle predicate) {
        return !llvm::is_contained(assumptions, predicate);
      });
    }
  }
  return classes;
}

static void appendKnownAddressDifference(
    ArrayRef<SlotMapping> slots, unsigned lhs, unsigned rhs, int64_t difference,
    int64_t elementBits, RemainderProofContext &proofContext,
    SmallVectorImpl<SmallVector<unsigned>> &edges) {
  if (difference == elementBits &&
      proofContext.sameActivation(slots[lhs], slots[rhs]))
    edges[lhs].push_back(rhs);
  if (difference == -elementBits &&
      proofContext.sameActivation(slots[rhs], slots[lhs]))
    edges[rhs].push_back(lhs);
}

static std::optional<int64_t>
getClassPairDifference(const AddressClassProof &proof, const SlotMapping &lhs,
                       const SlotMapping &rhs) {
  std::optional<int64_t> difference =
      llvm::checkedAdd(proof.residualDifference, rhs.proofOffset->constant);
  if (!difference)
    return std::nullopt;
  return llvm::checkedSub(*difference, lhs.proofOffset->constant);
}

static void appendSameClassEdges(
    ArrayRef<SlotMapping> slots, ArrayRef<AddressProofClass> classes,
    int64_t elementBits, RemainderProofContext &proofContext,
    SmallVectorImpl<SmallVector<unsigned>> &edges,
    SmallVectorImpl<std::pair<unsigned, unsigned>> &fallbackPairs) {
  for (const AddressProofClass &addressClass : classes) {
    for (auto [position, lhs] : llvm::enumerate(addressClass.members)) {
      for (unsigned rhs :
           ArrayRef(addressClass.members).drop_front(position + 1)) {
        std::optional<int64_t> difference =
            getCachedAddressDifference(slots[lhs], slots[rhs]);
        if (difference)
          appendKnownAddressDifference(slots, lhs, rhs, *difference,
                                       elementBits, proofContext, edges);
        else
          fallbackPairs.push_back({lhs, rhs});
      }
    }
  }
}

static void appendAddressClassPairEdges(
    ArrayRef<SlotMapping> slots, const AddressProofClass &lhs,
    const AddressProofClass &rhs, int64_t elementBits,
    RemainderProofContext &proofContext,
    SmallVectorImpl<SmallVector<unsigned>> &edges,
    SmallVectorImpl<std::pair<unsigned, unsigned>> &fallbackPairs) {
  SmallVector<sym::PredHandle> assumptions = lhs.assumptions;
  llvm::append_range(assumptions, rhs.assumptions);
  AddressClassProof proof =
      proofContext.proveAddressClasses(assumptions, lhs.key, rhs.key)
          .value_or(AddressClassProof{});
  for (unsigned lhsMember : lhs.members) {
    for (unsigned rhsMember : rhs.members) {
      if (!proof.available) {
        fallbackPairs.push_back(
            {std::min(lhsMember, rhsMember), std::max(lhsMember, rhsMember)});
        continue;
      }
      if (!proof.baseTargetProven)
        continue;
      std::optional<int64_t> difference =
          getClassPairDifference(proof, slots[lhsMember], slots[rhsMember]);
      if (!difference) {
        fallbackPairs.push_back(
            {std::min(lhsMember, rhsMember), std::max(lhsMember, rhsMember)});
        continue;
      }
      appendKnownAddressDifference(slots, lhsMember, rhsMember, *difference,
                                   elementBits, proofContext, edges);
    }
  }
}

static void appendCrossClassEdges(
    ArrayRef<SlotMapping> slots, ArrayRef<AddressProofClass> classes,
    int64_t elementBits, RemainderProofContext &proofContext,
    SmallVectorImpl<SmallVector<unsigned>> &edges,
    SmallVectorImpl<std::pair<unsigned, unsigned>> &fallbackPairs) {
  for (unsigned lhs = 0; lhs < classes.size(); ++lhs)
    for (unsigned rhs = lhs + 1; rhs < classes.size(); ++rhs)
      appendAddressClassPairEdges(slots, classes[lhs], classes[rhs],
                                  elementBits, proofContext, edges,
                                  fallbackPairs);
}

static void appendUnclassifiedPairs(
    ArrayRef<std::optional<unsigned>> classIds,
    SmallVectorImpl<std::pair<unsigned, unsigned>> &fallbackPairs) {
  for (unsigned lhs = 0; lhs < classIds.size(); ++lhs)
    for (unsigned rhs = lhs + 1; rhs < classIds.size(); ++rhs)
      if (!classIds[lhs] || !classIds[rhs])
        fallbackPairs.push_back({lhs, rhs});
}

static void
appendDenseFallbackEdges(sym::Store &store, ArrayRef<SlotMapping> slots,
                         int64_t elementBits,
                         ArrayRef<std::pair<unsigned, unsigned>> fallbackPairs,
                         RemainderProofContext &proofContext,
                         SmallVectorImpl<SmallVector<unsigned>> &edges) {
  SmallVector<RelationPair> relationPairs;
  relationPairs.reserve(fallbackPairs.size());
  for (auto [lhs, rhs] : fallbackPairs)
    relationPairs.push_back({slots[lhs].proofIndex, slots[rhs].proofIndex});
  proofContext.prepareRelations(relationPairs, elementBits);
  for (auto [lhs, rhs] : fallbackPairs) {
    if (!llvm::is_contained(edges[lhs], rhs) &&
        adjacent(store, slots[lhs], slots[rhs], elementBits, proofContext))
      edges[lhs].push_back(rhs);
    if (!llvm::is_contained(edges[rhs], lhs) &&
        adjacent(store, slots[rhs], slots[lhs], elementBits, proofContext))
      edges[rhs].push_back(lhs);
  }
}

static SmallVector<SmallVector<unsigned>>
buildDenseSuccessorGraph(sym::Store &store, ArrayRef<SlotMapping> slots,
                         int64_t elementBits,
                         RemainderProofContext &proofContext) {
  SmallVector<SmallVector<unsigned>> edges(slots.size());
  SmallVector<std::optional<unsigned>> classIds;
  SmallVector<AddressProofClass> classes =
      buildAddressProofClasses(slots, classIds);
  SmallVector<std::pair<unsigned, unsigned>> fallbackPairs;

  appendSameClassEdges(slots, classes, elementBits, proofContext, edges,
                       fallbackPairs);
  appendCrossClassEdges(slots, classes, elementBits, proofContext, edges,
                        fallbackPairs);
  appendUnclassifiedPairs(classIds, fallbackPairs);
  appendDenseFallbackEdges(store, slots, elementBits, fallbackPairs,
                           proofContext, edges);
  return edges;
}

static void
appendLogicalPacketEdges(sym::Store &store, ArrayRef<SlotMapping> slots,
                         int64_t elementBits,
                         RemainderProofContext &proofContext,
                         SmallVectorImpl<SmallVector<unsigned>> &edges) {
  forEachLogicalPacketPair(slots, [&](unsigned lhs, unsigned rhs) {
    if (!llvm::is_contained(edges[lhs], rhs) &&
        adjacent(store, slots[lhs], slots[rhs], elementBits, proofContext))
      edges[lhs].push_back(rhs);
  });
}

static SmallVector<SmallVector<unsigned>>
buildSuccessorGraph(sym::Store &store, ArrayRef<SlotMapping> slots,
                    int64_t elementBits, RemainderProofContext &proofContext) {
  constexpr size_t denseLimit = 64;
  SmallVector<SmallVector<unsigned>> edges;
  if (slots.size() <= denseLimit)
    edges = buildDenseSuccessorGraph(store, slots, elementBits, proofContext);
  else
    edges = buildSparseSuccessorGraph(store, slots, elementBits, proofContext);
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
  if (access.packetWhere) {
    plan.physicalSlots =
        SmallVector<SlotMapping, 4>(mappings.begin(), mappings.end());
  } else {
    prepareAllRelations(mappings, elementBits, proofContext);
    plan.physicalSlots = deduplicateGatherSlots(
        store, SmallVector<SlotMapping, 4>(mappings.begin(), mappings.end()),
        proofContext);
  }
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
                      mapping.materializationByteOffset, mapping.baseIndex});

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
  if (access.packetWhere || mappings.size() > kMaxExactCoverNodes)
    return buildGenericGatherPlan(access, store, mappings, elementBits,
                                  proofContext);
  SmallVector<wave::memory_lowering::GatherTransactionCandidate>
      providerCandidates = getProviderGatherCandidates(access, store, mappings);
  if (providerCandidates.empty())
    return buildGenericGatherPlan(access, store, mappings, elementBits,
                                  proofContext);

  GatherPlan plan;
  prepareAllRelations(mappings, elementBits, proofContext);
  plan.physicalSlots = deduplicateGatherSlots(
      store, SmallVector<SlotMapping, 4>(mappings.begin(), mappings.end()),
      proofContext);
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
                                              sym::Analysis &analysis) {
  if (elementBits <= 0 || elementBits % 8 != 0)
    return {};
  FailureOr<sym::ExprHandle> elementOffset =
      divideExactlyProof(analysis, byteOffset, elementBits / 8);
  if (failed(elementOffset))
    return {};
  FailureOr<sym::ExprHandle> materializationElementOffset =
      divideExactlyProof(analysis, slot.materializationBitOffset, elementBits);
  for (const MaterializationCandidate &candidate :
       slot.materializationCandidates) {
    if (!isLegalPtrAddOffset(candidate.value.getType()))
      continue;
    if ((succeeded(materializationElementOffset) &&
         analysis.equivalent(*materializationElementOffset,
                             candidate.expression) == sym::CheckResult::True) ||
        analysis.equivalent(*elementOffset, candidate.expression) ==
            sym::CheckResult::True)
      return candidate.value;
  }
  return {};
}

struct TypedPointerRequest {
  const SlotMapping *slot = nullptr;
  sym::ExprHandle byteOffset;
  int64_t baseIndex = 0;
};

struct TypedPointerPlan {
  Value offset;
  sym::ExprHandle elementOffset;
  bool available = false;
};

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

static bool isValidTypedPointerRequest(const MemoryAccess &access,
                                       const TypedPointerRequest &request) {
  if (!request.slot || request.baseIndex < 0 ||
      request.baseIndex >= static_cast<int64_t>(access.bases.size()))
    return false;
  return getTypedPointerElementBits(access, request.baseIndex).has_value();
}

static void prepareTypedPointerPlan(const MemoryAccess &access,
                                    const TypedPointerRequest &request,
                                    sym::Analysis &analysis,
                                    TypedPointerPlan &plan) {
  std::optional<int64_t> elementBits =
      getTypedPointerElementBits(access, request.baseIndex);
  if (!elementBits)
    return;
  plan.offset = findElementOffsetMaterialization(
      *request.slot, request.byteOffset, *elementBits, analysis);
  if (plan.offset) {
    plan.available = true;
    return;
  }
  FailureOr<sym::ExprHandle> elementOffset = divideExactlyForMaterialization(
      analysis, request.byteOffset, *elementBits / 8);
  if (failed(elementOffset))
    return;
  plan.elementOffset = *elementOffset;
  plan.available = true;
}

static SmallVector<TypedPointerPlan>
prepareTypedPointerPlans(const MemoryAccess &access, sym::Store &store,
                         ArrayRef<TypedPointerRequest> requests) {
  SmallVector<ExactFactDomainGroup> groups;
  llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> buckets;
  for (auto [index, request] : llvm::enumerate(requests)) {
    if (!isValidTypedPointerRequest(access, request))
      continue;
    appendExactFactDomainTask(request.slot->assumptions, index, groups,
                              buckets);
  }
  SmallVector<TypedPointerPlan> plans(requests.size());
  for (ExactFactDomainGroup &group : groups) {
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        sym::Analysis::create(store, group.assumptions);
    if (failed(analysis))
      continue;
    for (size_t index : group.tasks)
      prepareTypedPointerPlan(access, requests[index], **analysis,
                              plans[index]);
  }
  return plans;
}

static FailureOr<Value> materializeTypedPointer(IRRewriter &rewriter,
                                                const MemoryAccess &access,
                                                const SlotMapping &slot,
                                                int64_t baseIndex,
                                                const TypedPointerPlan &plan) {
  if (!plan.available)
    return failure();
  Value source = access.bases[baseIndex];
  PtrType sourceType = cast<PtrType>(source.getType());
  if (plan.offset) {
    Type resultType = getPointerAddResultType(access.op->getContext(),
                                              sourceType, plan.offset);
    return PtrAddOp::create(rewriter, access.op->getLoc(), resultType, source,
                            plan.offset)
        .getResult();
  }
  FailureOr<Value> offset =
      materializeExpr(rewriter, access, slot, plan.elementOffset);
  if (failed(offset))
    return failure();
  Type resultType =
      getPointerAddResultType(access.op->getContext(), sourceType, *offset);
  return PtrAddOp::create(rewriter, access.op->getLoc(), resultType, source,
                          *offset)
      .getResult();
}

static FailureOr<Value>
materializePointer(IRRewriter &rewriter, const MemoryAccess &access,
                   const SlotMapping &slot, sym::ExprHandle byteOffset,
                   int64_t baseIndex, const TypedPointerPlan &typedPlan,
                   SmallVectorImpl<Value> &byteBases) {
  FailureOr<Value> typed =
      materializeTypedPointer(rewriter, access, slot, baseIndex, typedPlan);
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
                                           const TypedPointerPlan &typedPlan,
                                           SmallVectorImpl<Value> &byteBases) {
  return materializePointer(rewriter, access, slot,
                            slot.materializationByteOffset, slot.baseIndex,
                            typedPlan, byteBases);
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
                   const SlotMapping &point, const TypedPointerPlan &typedPlan,
                   SmallVectorImpl<Value> &byteBases, Value condition,
                   Type valueType, Value inactiveValue) {
  SmallVector<Type> resultTypes{valueType, access.tokenType};
  WhereOp where = WhereOp::create(rewriter, access.op->getLoc(), resultTypes,
                                  ValueRange{condition});
  Block &thenBlock = where.getThenRegion().emplaceBlock();
  rewriter.setInsertionPointToStart(&thenBlock);
  FailureOr<Value> ptr =
      materializePointer(rewriter, access, point, typedPlan, byteBases);
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
                                            const SlotMapping &point,
                                            const TypedPointerPlan &typedPlan,
                                            SmallVectorImpl<Value> &byteBases,
                                            Value condition, Value value) {
  WhereOp where =
      WhereOp::create(rewriter, access.op->getLoc(),
                      TypeRange{access.tokenType}, ValueRange{condition});
  Block &thenBlock = where.getThenRegion().emplaceBlock();
  rewriter.setInsertionPointToStart(&thenBlock);
  FailureOr<Value> ptr =
      materializePointer(rewriter, access, point, typedPlan, byteBases);
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
    IRRewriter &rewriter, const MemoryAccess &access,
    const wave::memory_lowering::GatherTransactionCandidate &transaction,
    const SlotMapping &point, const TypedPointerPlan &typedPlan,
    bool soleCandidate, int64_t slotCount, Type componentType,
    GatherEmissionState &state) {
  FailureOr<Value> ptr =
      materializePointer(rewriter, access, point, transaction.byteOffset,
                         transaction.baseIndex, typedPlan, state.byteBases);
  if (failed(ptr))
    return access.op->emitOpError("failed to materialize mapped address");
  FailureOr<wave::memory_lowering::GatherTransactionResult> result =
      transaction.emitter->emit(
          rewriter, access.op->getLoc(),
          cast<SimdType>(getTransactionType(access, transaction.slots.size())),
          access.tokenType, *ptr, access.dependency);
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

static LogicalResult emitGenericGatherCandidate(
    IRRewriter &rewriter, const MemoryAccess &access, const GatherPlan &plan,
    const GatherCandidate &candidate, const SlotMapping &point,
    const TypedPointerPlan &typedPlan, Type componentType,
    GatherEmissionState &state) {
  ArrayRef<unsigned> transaction = candidate.physicalNodes;
  Type valueType = getTransactionType(access, transaction.size());
  Value loadedValue;
  if (access.packetWhere) {
    Value inactiveValue = buildInactiveTransactionValue(
        rewriter, access, plan.physicalSlots, transaction, valueType);
    FailureOr<PredicatedLoadResult> load =
        emitPredicatedLoad(rewriter, access, point, typedPlan, state.byteBases,
                           point.packetCondition, valueType, inactiveValue);
    if (failed(load))
      return access.op->emitOpError("failed to materialize mapped address");
    loadedValue = load->value;
    state.tokens.push_back(load->token);
  } else {
    FailureOr<Value> ptr =
        materializePointer(rewriter, access, point, typedPlan, state.byteBases);
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

static FailureOr<SmallVector<SlotMapping, 4>>
buildGatherTransactionPoints(const MemoryAccess &access,
                             ArrayRef<SlotMapping> mappings,
                             const GatherPlan &plan) {
  SmallVector<SlotMapping, 4> points;
  points.reserve(plan.selected.size());
  for (unsigned candidateIndex : plan.selected) {
    const GatherCandidate &candidate = plan.candidates[candidateIndex];
    if (candidate.provider) {
      if (candidate.provider->addressPoint >= mappings.size()) {
        access.op->emitOpError("invalid target transaction address");
        return failure();
      }
      points.push_back(buildTransactionPoint(mappings,
                                             candidate.provider->slots,
                                             candidate.provider->addressPoint));
      continue;
    }
    ArrayRef<unsigned> transaction = candidate.physicalNodes;
    points.push_back(buildTransactionPoint(plan.physicalSlots, transaction,
                                           transaction.front()));
  }
  return points;
}

static SmallVector<TypedPointerRequest>
buildGatherTypedPointerRequests(const GatherPlan &plan,
                                ArrayRef<SlotMapping> points) {
  SmallVector<TypedPointerRequest> requests;
  requests.reserve(points.size());
  for (auto [index, candidateIndex] : llvm::enumerate(plan.selected)) {
    const GatherCandidate &candidate = plan.candidates[candidateIndex];
    requests.push_back(
        candidate.provider
            ? TypedPointerRequest{&points[index],
                                  candidate.provider->byteOffset,
                                  candidate.provider->baseIndex}
            : TypedPointerRequest{&points[index],
                                  points[index].materializationByteOffset,
                                  points[index].baseIndex});
  }
  return requests;
}

static LogicalResult
emitGatherCandidates(IRRewriter &rewriter, const MemoryAccess &access,
                     const GatherPlan &plan, ArrayRef<SlotMapping> points,
                     ArrayRef<TypedPointerPlan> typedPlans, int64_t slotCount,
                     Type componentType, GatherEmissionState &state) {
  for (auto [index, candidateIndex] : llvm::enumerate(plan.selected)) {
    const GatherCandidate &candidate = plan.candidates[candidateIndex];
    LogicalResult emitted =
        candidate.provider
            ? emitProviderGatherCandidate(rewriter, access, *candidate.provider,
                                          points[index], typedPlans[index],
                                          plan.selected.size() == 1, slotCount,
                                          componentType, state)
            : emitGenericGatherCandidate(rewriter, access, plan, candidate,
                                         points[index], typedPlans[index],
                                         componentType, state);
    if (failed(emitted))
      return failure();
  }
  return success();
}

static LogicalResult finishGatherLowering(IRRewriter &rewriter,
                                          const MemoryAccess &access,
                                          GatherEmissionState &state) {
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

  FailureOr<SmallVector<SlotMapping, 4>> points =
      buildGatherTransactionPoints(access, mappings, plan);
  if (failed(points))
    return failure();
  SmallVector<TypedPointerRequest> requests =
      buildGatherTypedPointerRequests(plan, *points);
  SmallVector<TypedPointerPlan> typedPlans =
      prepareTypedPointerPlans(access, store, requests);

  if (failed(emitGatherCandidates(rewriter, access, plan, *points, typedPlans,
                                  packet.getNumElements(), componentType,
                                  state)))
    return failure();
  return finishGatherLowering(rewriter, access, state);
}

struct ScatterEmissionState {
  SmallVector<Value> components;
  SmallVector<Value> tokens;
  SmallVector<Value> byteBases;
};

static SmallVector<Value> extractScatterComponents(IRRewriter &rewriter,
                                                   const MemoryAccess &access,
                                                   VectorType packet,
                                                   Type componentType) {
  SmallVector<Value> components;
  components.reserve(packet.getNumElements());
  for (int64_t index : llvm::seq<int64_t>(0, packet.getNumElements()))
    components.push_back(ExtractOp::create(
        rewriter, access.op->getLoc(), componentType, access.packet, index));
  return components;
}

static SmallVector<SlotMapping, 4>
buildScatterTransactionPoints(ArrayRef<SlotMapping> slots,
                              ArrayRef<SmallVector<unsigned>> transactions) {
  SmallVector<SlotMapping, 4> points;
  points.reserve(transactions.size());
  for (ArrayRef<unsigned> transaction : transactions)
    points.push_back(
        buildTransactionPoint(slots, transaction, transaction.front()));
  return points;
}

static SmallVector<TypedPointerRequest>
buildScatterTypedPointerRequests(ArrayRef<SlotMapping> points) {
  SmallVector<TypedPointerRequest> requests;
  requests.reserve(points.size());
  for (const SlotMapping &point : points)
    requests.push_back(
        {&point, point.materializationByteOffset, point.baseIndex});
  return requests;
}

static Value buildScatterTransactionValue(IRRewriter &rewriter,
                                          const MemoryAccess &access,
                                          ArrayRef<SlotMapping> slots,
                                          ArrayRef<unsigned> transaction,
                                          Type componentType,
                                          ArrayRef<Value> components) {
  SmallVector<Value> values;
  values.reserve(transaction.size());
  for (unsigned nodeIndex : transaction)
    values.push_back(components[slots[nodeIndex].logicalSlots.front()]);
  if (values.size() == 1)
    return values.front();
  return PackOp::create(rewriter, access.op->getLoc(),
                        getTransactionType(access, values.size()), values);
}

static FailureOr<Value>
emitScatterTransaction(IRRewriter &rewriter, const MemoryAccess &access,
                       ArrayRef<SlotMapping> slots,
                       ArrayRef<unsigned> transaction, SlotMapping &point,
                       const TypedPointerPlan &typedPlan, Type componentType,
                       ScatterEmissionState &state) {
  Value value = buildScatterTransactionValue(
      rewriter, access, slots, transaction, componentType, state.components);
  if (access.packetWhere)
    return emitPredicatedStore(rewriter, access, point, typedPlan,
                               state.byteBases, point.packetCondition, value);
  FailureOr<Value> ptr =
      materializePointer(rewriter, access, point, typedPlan, state.byteBases);
  if (failed(ptr))
    return failure();
  StoreOp store =
      StoreOp::create(rewriter, access.op->getLoc(), access.tokenType, value,
                      *ptr, access.dependency, access.cache);
  return store.getToken();
}

static void finishScatterLowering(IRRewriter &rewriter,
                                  const MemoryAccess &access, Value token) {
  if (!access.packetWhere) {
    rewriter.replaceOp(access.op, token);
    return;
  }
  if (access.packetWhere->getNumResults() == 1) {
    rewriter.replaceOp(access.packetWhere, token);
    return;
  }
  rewriter.eraseOp(access.packetWhere);
}

static LogicalResult
lowerScatter(IRRewriter &rewriter, const MemoryAccess &access,
             sym::Store &store, ArrayRef<SlotMapping> slots,
             ArrayRef<SmallVector<unsigned>> transactions) {
  VectorType packet = cast<VectorType>(access.packetType.getElementType());
  Type componentType = getComponentType(access);
  ScatterEmissionState state{
      extractScatterComponents(rewriter, access, packet, componentType),
      {},
      SmallVector<Value>(access.bases.size())};
  materializePredicatedByteBases(rewriter, access, state.byteBases);
  SmallVector<SlotMapping, 4> points =
      buildScatterTransactionPoints(slots, transactions);
  SmallVector<TypedPointerRequest> requests =
      buildScatterTypedPointerRequests(points);
  SmallVector<TypedPointerPlan> typedPlans =
      prepareTypedPointerPlans(access, store, requests);

  for (auto [index, transaction] : llvm::enumerate(transactions)) {
    FailureOr<Value> token = emitScatterTransaction(
        rewriter, access, slots, transaction, points[index], typedPlans[index],
        componentType, state);
    if (failed(token))
      return access.op->emitOpError("failed to materialize mapped address");
    state.tokens.push_back(*token);
  }

  Value token = joinTokens(rewriter, access, state.tokens);
  finishScatterLowering(rewriter, access, token);
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
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store);
  if (failed(analysis))
    return true;
  MappingCoordinates coordinates =
      getMappingCoordinates(access, domain.block, domain.zero);
  for (int64_t slot : llvm::seq<int64_t>(0, slotCount)) {
    FailureOr<sym::ExprHandle> slotValue = (*analysis)->composeInteger(slot);
    if (failed(slotValue))
      return true;
    SmallVector<sym::ExprSubstitution> substitutions(bindingSubstitutions);
    substitutions.push_back({domain.slot, *slotValue});
    FailureOr<MappingCoordinates> specialized =
        specializeCoordinates(**analysis, coordinates, substitutions);
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
  SmallVector<PreparedSlotMapping, 4> preparedMappings;
  preparedMappings.reserve(slotCount);
  for (int64_t index : llvm::seq<int64_t>(0, slotCount)) {
    FailureOr<PreparedSlotMapping> prepared = prepareSlotMapping(
        access, store, domain.slot, index, item, bindingSubstitutions,
        packetComponents, controls,
        packetControls.empty() ? nullptr : &packetControls[index],
        bindingState);
    if (failed(prepared)) {
      access.op->emitOpError(
          "mapping is not a defined, byte-addressable local memory point");
      return failure();
    }
    preparedMappings.push_back(std::move(*prepared));
  }

  SmallVector<ExactFactDomainGroup> groups;
  llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> buckets;
  for (auto [index, prepared] : llvm::enumerate(preparedMappings))
    appendExactFactDomainTask(prepared.mapping.assumptions, index, groups,
                              buckets);

  SmallVector<SlotMapping, 4> mappings(preparedMappings.size());
  for (ExactFactDomainGroup &group : groups) {
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        sym::Analysis::create(store, group.assumptions);
    if (failed(analysis)) {
      access.op->emitOpError(
          "mapping is not a defined, byte-addressable local memory point");
      return failure();
    }
    for (size_t index : group.tasks) {
      FailureOr<SlotMapping> mapping =
          analyzeSlotMapping(access, **analysis, domain.block, domain.zero,
                             std::move(preparedMappings[index]));
      if (failed(mapping)) {
        access.op->emitOpError(
            "mapping is not a defined, byte-addressable local memory point");
        return failure();
      }
      mappings[index] = std::move(*mapping);
    }
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
                                 WaveDialect &dialect, DataFlowSolver &solver,
                                 SymbolicRelationProofCache &proofCache,
                                 uint64_t &factDomainCount,
                                 SymbolicMemoryStageTiming &timing) {
  TimingScope prepareTiming =
      timing.nest("lower_symbolic_memory_prepare_mappings");
  FailureOr<PreparedAccessMappings> prepared =
      prepareAccessMappings(rewriter, access, dialect, solver);
  if (failed(prepared))
    return failure();
  sym::Store &store = dialect.getSymbolStore();
  RemainderProofContext proofContext(dialect, solver, access.op,
                                     prepared->mappings, proofCache,
                                     factDomainCount);
  if (access.packetWhere)
    rewriter.setInsertionPoint(access.packetWhere);
  prepareTiming.stop();

  if (access.gather) {
    TimingScope planTiming = timing.nest("lower_symbolic_memory_plan_gather");
    FailureOr<GatherPlan> plan =
        planGatherTransactions(access, store, prepared->mappings,
                               prepared->shape.elementBits, proofContext);
    if (failed(plan))
      return access.op->emitOpError(
          "packet cannot be covered by legal memory transactions");
    planTiming.stop();

    TimingScope emitTiming = timing.nest("lower_symbolic_memory_emit_gather");
    return lowerGather(rewriter, access, store, prepared->mappings, *plan);
  }

  TimingScope planTiming = timing.nest("lower_symbolic_memory_plan_scatter");
  FailureOr<SmallVector<SmallVector<unsigned>>> transactions = planTransactions(
      store, prepared->mappings, prepared->shape.elementBits, proofContext);
  if (failed(transactions))
    return access.op->emitOpError(
        "packet cannot be covered by legal memory transactions");
  planTiming.stop();

  TimingScope emitTiming = timing.nest("lower_symbolic_memory_emit_scatter");
  return lowerScatter(rewriter, access, store, prepared->mappings,
                      *transactions);
}

static LogicalResult lowerAccesses(ArrayRef<Operation *> accesses,
                                   WaveDialect &dialect, IRRewriter &rewriter,
                                   DataFlowSolver &solver,
                                   SymbolicRelationProofCache &proofCache,
                                   uint64_t &factDomainCount,
                                   SymbolicMemoryStageTiming &timing) {
  for (Operation *op : accesses) {
    rewriter.setInsertionPoint(op);
    MemoryAccess access = isa<GatherOp>(op) ? getAccess(cast<GatherOp>(op))
                                            : getAccess(cast<ScatterOp>(op));
    if (failed(lowerAccess(rewriter, access, dialect, solver, proofCache,
                           factDomainCount, timing)))
      return failure();
  }
  return success();
}

struct WaveLowerSymbolicMemoryPass
    : public wave::impl::WaveLowerSymbolicMemoryBase<
          WaveLowerSymbolicMemoryPass> {
  void runOnOperation() override {
    SymbolicMemoryStageTiming timing;
    TimingScope setupTiming = timing.nest("lower_symbolic_memory_setup");
    Operation *root = getOperation();
    WaveDialect *dialect = getContext().getLoadedDialect<WaveDialect>();
    if (!dialect) {
      root->emitError("Wave dialect is not loaded");
      return signalPassFailure();
    }
    setupTiming.stop();

    TimingScope collectTiming =
        timing.nest("lower_symbolic_memory_collect_accesses");
    SmallVector<Operation *> accesses;
    root->walk([&](Operation *op) {
      if (isa<GatherOp, ScatterOp>(op))
        accesses.push_back(op);
    });
    collectTiming.stop();
    if (accesses.empty())
      return;

    TimingScope analysisTiming =
        timing.nest("lower_symbolic_memory_integer_range_analysis");
    DataFlowSolver solver;
    dataflow::loadBaselineAnalyses(solver);
    solver.load<dataflow::IntegerRangeAnalysis>();
    if (failed(solver.initializeAndRun(root))) {
      root->emitError(
          "IntegerRangeAnalysis failed for symbolic memory lowering");
      return signalPassFailure();
    }
    analysisTiming.stop();

    IRRewriter rewriter(&getContext());
    SymbolicRelationProofCache proofCache;
    uint64_t factDomainCount = 0;
    if (failed(lowerAccesses(accesses, *dialect, rewriter, solver, proofCache,
                             factDomainCount, timing)))
      return signalPassFailure();
    numRelationPlanningFactDomains += factDomainCount;
  }
};

} // namespace
