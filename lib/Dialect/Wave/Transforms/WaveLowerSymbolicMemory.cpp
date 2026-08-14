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
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Support/Timing.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/Hashing.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/ADT/Twine.h"
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
  bool mayMaterializeAddress = true;
};

struct SlotMapping {
  SmallVector<NamedBinding> bindings;
  SmallVector<sym::PredHandle> assumptions;
  SmallVector<sym::PredHandle> activationProofAssumptions;
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
  bool staticallyInactive = false;
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
  SmallVector<SymbolicOffset> materializationOffsets;
};

struct SlotSubstitutions {
  SmallVector<sym::ExprSubstitution> proof;
  SmallVector<sym::ExprSubstitution> materialization;
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
static constexpr int64_t kMaxItemEnumerationPoints = 4096;

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

static void collectLocalIndexProducers(Value value, Block *block,
                                       DenseSet<Operation *> &producers) {
  Operation *producer = value.getDefiningOp();
  if (!producer || producer->getBlock() != block ||
      !producers.insert(producer).second)
    return;
  for (Value operand : producer->getOperands())
    collectLocalIndexProducers(operand, block, producers);
}

static DenseSet<Operation *>
collectLocalIndexProducers(const MemoryAccess &access, Block *block) {
  DenseSet<Operation *> producers;
  for (Value binding : access.bindings)
    collectLocalIndexProducers(binding, block, producers);
  for (const PacketBinding &binding : access.packetBindings)
    for (Value value : binding.values)
      collectLocalIndexProducers(value, block, producers);
  return producers;
}

static bool isSafePacketIndexProducer(Operation *op) {
  if (isa<BallotOp, ReadFirstOp, ShuffleOp>(op) || op->getNumRegions() != 0)
    return false;
  return isMemoryEffectFree(op) && isSpeculatable(op);
}

static bool hasIsolatedPacketAccess(WhereOp where, const MemoryAccess &access,
                                    YieldOp thenYield) {
  if (!thenYield || access.op->getNextNode() != thenYield)
    return false;
  Block *block = &where.getThenRegion().front();
  DenseSet<Operation *> producers = collectLocalIndexProducers(access, block);
  for (Operation &op :
       llvm::make_range(block->begin(), access.op->getIterator())) {
    if (!producers.contains(&op))
      return false;
    if (!isSafePacketIndexProducer(&op))
      return false;
  }
  return true;
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
  if (!hasIsolatedPacketAccess(where, access, thenYield))
    return where.emitOpError(
        "packet-predicated symbolic memory then region must contain only "
        "index dependencies and the memory access");

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

static void canonicalizePacketWorkitems(const MemoryAccess &access,
                                        PacketBindingState &state) {
  Type workitemType = SimdType::get(
      access.op->getContext(), IntegerType::get(access.op->getContext(), 32),
      access.packetType.getWidth());
  for (ArrayRef<Value> workitems :
       collectPacketWorkitemIds(access, workitemType)) {
    if (workitems.empty())
      continue;
    Value representative = workitems.front();
    for (Value alias : workitems)
      state.canonicalValues.try_emplace(alias, representative);
  }
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

  canonicalizePacketWorkitems(access, state);

  for (auto [name, value] : llvm::zip(access.bindingNames, access.bindings)) {
    auto [it, inserted] = state.reserved.try_emplace(name, value);
    (void)inserted;
    state.byValue.try_emplace(value, it->getKey());
  }
  for (const PacketBinding &binding : access.packetBindings)
    state.reserved.try_emplace(binding.name, Value());
}

static LogicalResult remapSymbolicBindings(
    sym::Store &store, ArrayRef<SymbolicOffsetBinding> bindings,
    ArrayRef<sym::PredHandle> assumptions, PacketBindingState &state,
    SlotMapping &mapping, SmallVectorImpl<sym::ExprSubstitution> &substitutions,
    SmallVectorImpl<sym::PredHandle> &remappedAssumptions) {
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
    llvm::append_range(remappedAssumptions, assumptions);
  else {
    FailureOr<SmallVector<sym::PredHandle>> substitutedAssumptions =
        substituteIndexExprPredicates(store, assumptions, substitutions);
    if (failed(substitutedAssumptions))
      return failure();
    llvm::append_range(remappedAssumptions, *substitutedAssumptions);
  }
  return success();
}

static FailureOr<sym::ExprHandle> remapSymbolicOffset(
    sym::Store &store, const SymbolicOffset &offset, PacketBindingState &state,
    SlotMapping &mapping,
    SmallVectorImpl<sym::ExprSubstitution> *resultSubstitutions = nullptr) {
  SmallVector<sym::ExprSubstitution> substitutions;
  if (failed(remapSymbolicBindings(store, offset.bindings, offset.assumptions,
                                   state, mapping, substitutions,
                                   mapping.assumptions)))
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
                                   substitutions, mapping.assumptions)))
    return failure();
  if (substitutions.empty())
    return predicate.predicate;
  return sym::substitutePred(store, predicate.predicate, substitutions);
}

static FailureOr<sym::PredHandle>
remapRelationPredicate(sym::Store &store, const SymbolicPredicate &predicate,
                       PacketBindingState &state, SlotMapping &mapping,
                       SmallVectorImpl<sym::PredHandle> &assumptions) {
  SmallVector<sym::ExprSubstitution> substitutions;
  if (failed(remapSymbolicBindings(store, predicate.bindings,
                                   predicate.assumptions, state, mapping,
                                   substitutions, assumptions)))
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

static LogicalResult
appendPacketControl(sym::Store &store, const PacketControl *control,
                    PacketBindingState &state, SlotMapping &mapping,
                    SmallVectorImpl<sym::PredHandle> &relationAssumptions) {
  if (!control)
    return success();
  mapping.packetCondition = control->value;
  if (control->predicate) {
    FailureOr<sym::PredHandle> predicate =
        remapSymbolicPredicate(store, *control->predicate, state, mapping);
    if (failed(predicate))
      return failure();
    mapping.activationPredicate = *predicate;
    mapping.assumptions.push_back(*predicate);
  }
  if (control->relationPredicate) {
    FailureOr<sym::PredHandle> relation =
        remapRelationPredicate(store, *control->relationPredicate, state,
                               mapping, relationAssumptions);
    if (failed(relation))
      return failure();
    mapping.activationRelationPredicate = *relation;
  }
  return success();
}

static bool mayMaterializeAtPacketRewrite(const MemoryAccess &access,
                                          Value value) {
  if (!access.packetWhere)
    return true;
  Operation *parent = value.getParentRegion()->getParentOp();
  return !access.packetWhere->isAncestor(parent);
}

static LogicalResult appendMaterializationCandidates(
    const MemoryAccess &access, sym::Store &store, const SymbolicOffset &offset,
    ArrayRef<sym::ExprSubstitution> substitutions, sym::ExprHandle replacement,
    Value value, SlotMapping &mapping) {
  for (const SymbolicOffsetMaterialization &materialization :
       offset.materializations) {
    FailureOr<sym::ExprHandle> expression = materialization.expr;
    if (!substitutions.empty())
      expression =
          sym::substituteExpr(store, materialization.expr, substitutions);
    if (failed(expression))
      return failure();
    mapping.materializationCandidates.push_back(
        {materialization.value, *expression,
         mayMaterializeAtPacketRewrite(access, materialization.value)});
  }
  mapping.materializationCandidates.push_back(
      {value, replacement, mayMaterializeAtPacketRewrite(access, value)});
  return success();
}

static LogicalResult appendPacketSubstitution(
    const MemoryAccess &access, sym::Store &store, StringRef name, Value value,
    const SymbolicOffset &offset, const SymbolicOffset &materializationOffset,
    PacketBindingState &state, SlotMapping &mapping,
    SlotSubstitutions &substitutions) {
  FailureOr<sym::ExprHandle> original = sym::composeExprSym(store, name);
  if (failed(original))
    return failure();

  if (access.packetWhere) {
    SmallVector<sym::ExprSubstitution> materializationOffsetSubstitutions;
    FailureOr<sym::ExprHandle> materializationReplacement =
        remapSymbolicOffset(store, materializationOffset, state, mapping,
                            &materializationOffsetSubstitutions);
    if (failed(materializationReplacement))
      return failure();
    if (failed(appendMaterializationCandidates(
            access, store, materializationOffset,
            materializationOffsetSubstitutions, *materializationReplacement,
            value, mapping)))
      return failure();
    substitutions.materialization.push_back(
        {*original, *materializationReplacement});
  }

  SmallVector<sym::ExprSubstitution> offsetSubstitutions;
  FailureOr<sym::ExprHandle> replacement =
      remapSymbolicOffset(store, offset, state, mapping, &offsetSubstitutions);
  if (failed(replacement))
    return failure();
  if (failed(appendMaterializationCandidates(access, store, offset,
                                             offsetSubstitutions, *replacement,
                                             value, mapping)))
    return failure();
  substitutions.proof.push_back({*original, *replacement});

  if (!access.packetWhere)
    substitutions.materialization.push_back({*original, *replacement});
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

static FailureOr<SlotSubstitutions>
buildSlotSubstitutions(const MemoryAccess &access, sym::Store &store,
                       sym::ExprHandle slotSymbol, int64_t slot,
                       ArrayRef<sym::ExprSubstitution> bindingSubstitutions,
                       ArrayRef<PacketComponents> packetComponents,
                       PacketBindingState &bindingState, SlotMapping &mapping) {
  FailureOr<sym::ExprHandle> slotValue = sym::composeExprInt(store, slot);
  if (failed(slotValue))
    return failure();
  SlotSubstitutions substitutions;
  substitutions.proof.append(bindingSubstitutions.begin(),
                             bindingSubstitutions.end());
  substitutions.materialization.append(bindingSubstitutions.begin(),
                                       bindingSubstitutions.end());
  substitutions.proof.push_back({slotSymbol, *slotValue});
  substitutions.materialization.push_back({slotSymbol, *slotValue});
  for (auto [bindingIndex, binding] : llvm::enumerate(access.packetBindings))
    if (failed(appendPacketSubstitution(
            access, store, binding.name,
            packetComponents[bindingIndex].values[slot],
            packetComponents[bindingIndex].offsets[slot],
            packetComponents[bindingIndex].materializationOffsets[slot],
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
substituteCoordinates(sym::Analysis &analysis,
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
  return MappingCoordinates{roots[0], roots[1], roots[2]};
}

static LogicalResult simplifyCoordinates(sym::Analysis &analysis,
                                         MappingCoordinates &coordinates) {
  std::array<sym::ExprHandle, 3> roots{
      coordinates.base, coordinates.targetBlock, coordinates.bitOffset};
  if (failed(analysis.simplify(roots)))
    return failure();
  coordinates = MappingCoordinates{roots[0], roots[1], roots[2]};
  return success();
}

static bool coordinatesProvablyDefined(sym::Analysis &analysis,
                                       const MappingCoordinates &coordinates,
                                       bool defaultBase,
                                       bool defaultTargetBlock) {
  if (analysis.defined(coordinates.bitOffset) != sym::CheckResult::True)
    return false;
  if (!defaultBase &&
      analysis.defined(coordinates.base) != sym::CheckResult::True)
    return false;
  return defaultTargetBlock ||
         analysis.defined(coordinates.targetBlock) == sym::CheckResult::True;
}

static bool coordinatesAreLocal(sym::Analysis &analysis,
                                const MappingCoordinates &coordinates,
                                sym::ExprHandle block, bool defaultBase,
                                bool defaultTargetBlock) {
  if (!defaultBase && hasSymbol(coordinates.base, "block"))
    return false;
  if (hasSymbol(coordinates.bitOffset, "block"))
    return false;
  return defaultTargetBlock ||
         analysis.equivalent(coordinates.targetBlock, block) ==
             sym::CheckResult::True;
}

static FailureOr<int64_t>
getLocalBaseIndex(const MemoryAccess &access,
                  const MappingCoordinates &coordinates, bool defaultBase) {
  int64_t baseIndex = 0;
  if (!defaultBase) {
    std::optional<int64_t> literal =
        sym::getIntegerLiteralValue(coordinates.base);
    if (!literal || *literal < 0)
      return failure();
    baseIndex = *literal;
  }
  if (static_cast<uint64_t>(baseIndex) >= access.bases.size())
    return failure();
  return baseIndex;
}

static FailureOr<int64_t>
validateLocalCoordinates(const MemoryAccess &access, sym::Analysis &analysis,
                         const MappingCoordinates &coordinates,
                         sym::ExprHandle block, bool defaultBase,
                         bool defaultTargetBlock) {
  if (!coordinatesProvablyDefined(analysis, coordinates, defaultBase,
                                  defaultTargetBlock))
    return failure();
  if (!coordinatesAreLocal(analysis, coordinates, block, defaultBase,
                           defaultTargetBlock))
    return failure();
  return getLocalBaseIndex(access, coordinates, defaultBase);
}

static FailureOr<sym::ExprHandle> getByteOffset(sym::Analysis &analysis,
                                                sym::ExprHandle bitOffset) {
  return divideExactlyProof(analysis, bitOffset, 8);
}

struct PreparedSlotMapping {
  SlotSubstitutions substitutions;
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
  if (failed(appendActiveControls(store, controls, bindingState,
                                  prepared.mapping)))
    return failure();
  SmallVector<sym::PredHandle> relationAssumptions;
  if (failed(appendPacketControl(store, packetControl, bindingState,
                                 prepared.mapping, relationAssumptions)))
    return failure();
  if (prepared.mapping.packetCondition) {
    prepared.mapping.activationProofAssumptions = prepared.mapping.assumptions;
    if (prepared.mapping.activationPredicate)
      llvm::erase(prepared.mapping.activationProofAssumptions,
                  *prepared.mapping.activationPredicate);
    for (sym::PredHandle assumption : relationAssumptions)
      if (!llvm::is_contained(prepared.mapping.activationProofAssumptions,
                              assumption))
        prepared.mapping.activationProofAssumptions.push_back(assumption);
  }
  if (failed(appendAccessBindings(access, store, item, prepared.mapping)))
    return failure();
  FailureOr<SlotSubstitutions> substitutions = buildSlotSubstitutions(
      access, store, slotSymbol, slot, bindingSubstitutions, packetComponents,
      bindingState, prepared.mapping);
  if (failed(substitutions))
    return failure();
  prepared.substitutions = std::move(*substitutions);
  return prepared;
}

static FailureOr<sym::ExprHandle>
specializeCoordinate(sym::Analysis &analysis, sym::ExprHandle coordinate,
                     ArrayRef<sym::ExprSubstitution> substitutions) {
  FailureOr<sym::ExprHandle> specialized =
      analysis.substitute(coordinate, substitutions);
  if (failed(specialized))
    return failure();
  return analysis.simplify(*specialized);
}

static FailureOr<MappingCoordinates> specializeProofCoordinates(
    sym::Analysis &analysis, const MappingCoordinates &coordinates,
    ArrayRef<sym::ExprSubstitution> substitutions,
    sym::ExprHandle proofBitOffset, sym::ExprHandle block, sym::ExprHandle zero,
    bool defaultBase, bool defaultTargetBlock) {
  MappingCoordinates specialized{zero, block, {}};
  FailureOr<sym::ExprHandle> bitOffset = analysis.simplify(proofBitOffset);
  if (failed(bitOffset))
    return failure();
  specialized.bitOffset = *bitOffset;
  if (!defaultBase) {
    FailureOr<sym::ExprHandle> base =
        specializeCoordinate(analysis, coordinates.base, substitutions);
    if (failed(base))
      return failure();
    specialized.base = *base;
  }
  if (!defaultTargetBlock) {
    FailureOr<sym::ExprHandle> targetBlock =
        specializeCoordinate(analysis, coordinates.targetBlock, substitutions);
    if (failed(targetBlock))
      return failure();
    specialized.targetBlock = *targetBlock;
  }
  return specialized;
}

static FailureOr<SlotMapping> analyzeSlotMapping(const MemoryAccess &access,
                                                 sym::Analysis &analysis,
                                                 sym::ExprHandle blockSymbol,
                                                 sym::ExprHandle zero,
                                                 PreparedSlotMapping prepared) {
  SlotMapping &result = prepared.mapping;
  MappingCoordinates coordinates =
      getMappingCoordinates(access, blockSymbol, zero);
  bool defaultBase = !access.mapping.getBase();
  bool defaultTargetBlock = !access.mapping.getTargetBlock();
  FailureOr<sym::ExprHandle> proofBitOffset =
      analysis.substitute(coordinates.bitOffset, prepared.substitutions.proof);
  FailureOr<sym::ExprHandle> materializationBitOffset = analysis.substitute(
      coordinates.bitOffset, prepared.substitutions.materialization);
  if (failed(proofBitOffset) || failed(materializationBitOffset))
    return failure();
  FailureOr<MappingCoordinates> specialized = specializeProofCoordinates(
      analysis, coordinates, prepared.substitutions.proof, *proofBitOffset,
      blockSymbol, zero, defaultBase, defaultTargetBlock);
  if (failed(specialized))
    return failure();
  FailureOr<int64_t> baseIndex =
      validateLocalCoordinates(access, analysis, *specialized, blockSymbol,
                               defaultBase, defaultTargetBlock);
  if (failed(baseIndex))
    return failure();
  std::array<sym::ExprSubstitution, 1> blockSubstitution{
      sym::ExprSubstitution{blockSymbol, zero}};
  materializationBitOffset =
      analysis.substitute(*materializationBitOffset, blockSubstitution);
  if (failed(materializationBitOffset))
    return failure();
  // Validation makes base/offset block-invariant and targetBlock == block.
  MappingCoordinates local = *specialized;
  local.targetBlock = zero;
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
  FailureOr<sym::ExprHandle> byteOffset =
      getByteOffset(analysis, local.bitOffset);
  if (failed(byteOffset))
    return failure();
  result.base = local.base;
  result.targetBlock = local.targetBlock;
  result.bitOffset = local.bitOffset;
  result.byteOffset = *byteOffset;
  result.proofOffset = analysis.splitAdditiveConstant(local.bitOffset);
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
getActivationProofAssumptions(const SlotMapping &slot) {
  if (slot.packetCondition)
    return slot.activationProofAssumptions;
  return getNonActivationAssumptions(slot);
}

static bool isProvablyFalseActivation(sym::Store &store,
                                      const SlotMapping &slot) {
  if (!slot.activationPredicate)
    return false;
  SmallVector<sym::PredHandle> assumptions =
      getActivationProofAssumptions(slot);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, assumptions);
  if (failed(analysis))
    return false;
  sym::PredHandle relation = slot.activationRelationPredicate
                                 ? slot.activationRelationPredicate
                                 : *slot.activationPredicate;
  std::array<sym::PredHandle, 2> predicates{relation,
                                            *slot.activationPredicate};
  for (sym::PredHandle predicate : predicates) {
    FailureOr<sym::PredHandle> simplified = (*analysis)->simplify(predicate);
    if (succeeded(simplified) &&
        sym::PredView(*simplified).getKind() == sym::PredKind::False)
      return true;
    FailureOr<sym::PredHandle> negated = (*analysis)->composeNot(predicate);
    if (succeeded(negated) &&
        (*analysis)->check(*negated) == sym::CheckResult::True)
      return true;
  }
  return false;
}

static SmallVector<sym::PredHandle>
combineActivationProofAssumptions(const SlotMapping &lhs,
                                  const SlotMapping &rhs) {
  SmallVector<sym::PredHandle> assumptions = getActivationProofAssumptions(lhs);
  SmallVector<sym::PredHandle> rhsAssumptions =
      getActivationProofAssumptions(rhs);
  llvm::append_range(assumptions, rhsAssumptions);
  return assumptions;
}

static sym::PredHandle getActivationRelation(const SlotMapping &mapping) {
  return mapping.activationRelationPredicate
             ? mapping.activationRelationPredicate
             : *mapping.activationPredicate;
}

static bool hasActivationModel(const SlotMapping &mapping) {
  return mapping.activationPredicate || mapping.activationRelationPredicate;
}

static std::optional<bool>
getStructuralActivationRelation(const SlotMapping &lhs,
                                const SlotMapping &rhs) {
  if (lhs.staticallyInactive || rhs.staticallyInactive)
    return lhs.staticallyInactive && rhs.staticallyInactive;
  if (!lhs.packetCondition)
    return !rhs.packetCondition;
  if (!rhs.packetCondition)
    return false;
  if (lhs.packetCondition == rhs.packetCondition)
    return true;
  if (!hasActivationModel(lhs) || !hasActivationModel(rhs))
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
        combineActivationProofAssumptions(lowSlot, highSlot);
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

  Operation *getAccess() const { return access; }

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

  static void collectAssociativeModuli(sym::ExprView view,
                                       SmallVectorImpl<int64_t> &moduli) {
    for (uint32_t index : llvm::seq(view.getAssocArgCount()))
      collectExpressionModuli(view.getAssocArg(index), moduli);
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
    case sym::ExprKind::And:
    case sym::ExprKind::Or:
      collectAssociativeModuli(view, moduli);
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

static std::optional<int64_t> getBoundedItemCount(DenseI32ArrayAttr shape) {
  if (!shape || shape.size() != 3 ||
      llvm::any_of(shape.asArrayRef(), [](int32_t dim) { return dim <= 0; }))
    return std::nullopt;
  int64_t count = 1;
  for (int32_t dim : shape.asArrayRef()) {
    if (count > kMaxItemEnumerationPoints / dim)
      return std::nullopt;
    count *= dim;
  }
  return count;
}

static bool isLinearItemBinding(const NamedBinding &binding,
                                DenseI32ArrayAttr shape) {
  if (binding.name == "item")
    return true;
  WorkitemIdOp workitem = binding.value.getDefiningOp<WorkitemIdOp>();
  return shape[1] == 1 && shape[2] == 1 && workitem && workitem.getAxis() == 0;
}

static const NamedBinding *
findLinearItemBinding(ArrayRef<NamedBinding> bindings,
                      DenseI32ArrayAttr shape) {
  ArrayRef<NamedBinding>::iterator found =
      llvm::find_if(bindings, [&](const NamedBinding &binding) {
        return isLinearItemBinding(binding, shape);
      });
  return found == bindings.end() ? nullptr : found;
}

static bool hasMatchingBinding(ArrayRef<NamedBinding> bindings,
                               const NamedBinding &sought) {
  return llvm::any_of(bindings, [&](const NamedBinding &binding) {
    return binding.name == sought.name && binding.value == sought.value;
  });
}

static bool mappingAddressHasSymbol(const SlotMapping &mapping,
                                    StringRef name) {
  return hasSymbol(mapping.base, name) ||
         hasSymbol(mapping.targetBlock, name) ||
         hasSymbol(mapping.bitOffset, name);
}

static bool haveEquivalentAddressRoots(sym::Analysis &analysis,
                                       const SlotMapping &lhs,
                                       const SlotMapping &rhs) {
  return analysis.equivalent(lhs.base, rhs.base) == sym::CheckResult::True &&
         analysis.equivalent(lhs.targetBlock, rhs.targetBlock) ==
             sym::CheckResult::True;
}

static std::optional<bool>
proveEnumeratedDifference(sym::Analysis &analysis, sym::ExprHandle difference,
                          sym::ExprHandle item, sym::ExprHandle expected,
                          int64_t itemCount, int64_t elementBits) {
  if (std::optional<int64_t> constant = sym::getIntegerLiteralValue(difference))
    return *constant == elementBits;
  for (int64_t index : llvm::seq<int64_t>(0, itemCount)) {
    FailureOr<sym::ExprHandle> replacement = analysis.composeInteger(index);
    if (failed(replacement))
      return std::nullopt;
    std::array<sym::ExprSubstitution, 1> substitutions{
        sym::ExprSubstitution{item, *replacement}};
    FailureOr<sym::ExprHandle> specialized =
        analysis.substitute(difference, substitutions);
    if (failed(specialized))
      return std::nullopt;
    std::optional<int64_t> constant = sym::getIntegerLiteralValue(*specialized);
    if ((constant && *constant != elementBits) ||
        (!constant &&
         analysis.equivalent(*specialized, expected) != sym::CheckResult::True))
      return std::nullopt;
  }
  return true;
}

static std::optional<bool>
proveEnumeratedAddressAdjacency(sym::Analysis &analysis, const SlotMapping &lhs,
                                const SlotMapping &rhs, StringRef itemName,
                                int64_t itemCount, int64_t elementBits) {
  FailureOr<sym::ExprHandle> item = analysis.composeSymbol(itemName);
  if (failed(item) || !haveEquivalentAddressRoots(analysis, lhs, rhs))
    return std::nullopt;
  FailureOr<sym::ExprHandle> difference =
      analysis.compose(rhs.bitOffset, sym::ExprBinaryOp::Sub, lhs.bitOffset);
  if (failed(difference))
    return std::nullopt;
  difference = analysis.simplify(*difference);
  FailureOr<sym::ExprHandle> expected = analysis.composeInteger(elementBits);
  if (failed(difference) || failed(expected))
    return std::nullopt;
  return proveEnumeratedDifference(analysis, *difference, *item, *expected,
                                   itemCount, elementBits);
}

static std::optional<bool> getAddressAdjacencyByItemEnumeration(
    sym::Store &store, const SlotMapping &lhs, const SlotMapping &rhs,
    int64_t elementBits, RemainderProofContext &proofContext) {
  DenseI32ArrayAttr shape = getWorkgroupShape(proofContext.getAccess());
  std::optional<int64_t> itemCount = getBoundedItemCount(shape);
  if (!itemCount)
    return std::nullopt;
  const NamedBinding *lhsItem = findLinearItemBinding(lhs.bindings, shape);
  if (!lhsItem || !hasMatchingBinding(rhs.bindings, *lhsItem))
    return std::nullopt;
  if (!mappingAddressHasSymbol(lhs, lhsItem->name) &&
      !mappingAddressHasSymbol(rhs, lhsItem->name))
    return std::nullopt;
  SmallVector<sym::PredHandle> assumptions = combineAssumptions(lhs, rhs);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, assumptions);
  if (failed(analysis))
    return std::nullopt;
  return proveEnumeratedAddressAdjacency(**analysis, lhs, rhs, lhsItem->name,
                                         *itemCount, elementBits);
}

static bool adjacent(sym::Store &store, const SlotMapping &lhs,
                     const SlotMapping &rhs, int64_t elementBits,
                     RemainderProofContext &proofContext) {
  std::optional<bool> directlyAdjacent =
      getAddressAdjacency(store, lhs, rhs, elementBits, proofContext);
  bool addressAdjacent = directlyAdjacent.value_or(false);
  if (!addressAdjacent) {
    std::optional<bool> enumerated = getAddressAdjacencyByItemEnumeration(
        store, lhs, rhs, elementBits, proofContext);
    if (enumerated) {
      if (!*enumerated)
        return false;
      addressAdjacent = true;
    } else {
      addressAdjacent =
          proveRemainderAdjacent(store, lhs, rhs, elementBits, proofContext);
    }
  }
  if (!addressAdjacent)
    return false;
  return proofContext.sameActivation(lhs, rhs);
}

constexpr size_t kRelationPairByteBudget = 4 * 1024 * 1024;
constexpr size_t kMaxRelationBatchPairs =
    kRelationPairByteBudget / sizeof(RelationPair);

static void prepareGatherDedupRelations(ArrayRef<SlotMapping> slots,
                                        int64_t elementBits,
                                        RemainderProofContext &proofContext) {
  if (slots.size() < 2)
    return;
  size_t lhsCount = slots.size();
  size_t rhsCount = slots.size() - 1;
  if (lhsCount % 2 == 0)
    lhsCount /= 2;
  else
    rhsCount /= 2;
  if (rhsCount && lhsCount > kMaxRelationBatchPairs / rhsCount)
    return;
  size_t pairCount = lhsCount * rhsCount;
  SmallVector<RelationPair> pairs;
  pairs.reserve(pairCount);
  for (auto [position, lhs] : llvm::enumerate(slots))
    for (const SlotMapping &rhs : slots.drop_front(position + 1))
      pairs.push_back({lhs.proofIndex, rhs.proofIndex});
  proofContext.prepareRelations(pairs, elementBits);
}

static SmallVector<SlotMapping, 4>
deduplicateGatherSlots(sym::Store &store, SmallVector<SlotMapping, 4> slots,
                       int64_t elementBits,
                       RemainderProofContext &proofContext) {
  prepareGatherDedupRelations(slots, elementBits, proofContext);
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
                 int64_t elementBits, RemainderProofContext &proofContext,
                 SymbolicMemoryStageTiming &timing) {
  TimingScope graphTiming =
      timing.nest("lower_symbolic_memory_build_successor_graph");
  SmallVector<SmallVector<unsigned>> edges =
      buildSuccessorGraph(store, slots, elementBits, proofContext);
  graphTiming.stop();
  TimingScope coverTiming =
      timing.nest("lower_symbolic_memory_select_transaction_cover");
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
                       RemainderProofContext &proofContext,
                       SymbolicMemoryStageTiming &timing) {
  GatherPlan plan;
  TimingScope dedupTiming =
      timing.nest("lower_symbolic_memory_deduplicate_gather");
  if (access.packetWhere) {
    plan.physicalSlots =
        SmallVector<SlotMapping, 4>(mappings.begin(), mappings.end());
  } else {
    plan.physicalSlots = deduplicateGatherSlots(
        store, SmallVector<SlotMapping, 4>(mappings.begin(), mappings.end()),
        elementBits, proofContext);
  }
  dedupTiming.stop();
  FailureOr<SmallVector<SmallVector<unsigned>>> transactions = planTransactions(
      store, plan.physicalSlots, elementBits, proofContext, timing);
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
getProviderGatherCandidates(
    const MemoryAccess &access, sym::Store &store,
    ArrayRef<SlotMapping> mappings,
    ArrayRef<std::unique_ptr<wave::memory_lowering::GatherTransactionProvider>>
        providers) {
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

static FailureOr<GatherPlan> planGatherTransactions(
    const MemoryAccess &access, sym::Store &store,
    ArrayRef<SlotMapping> mappings, int64_t elementBits,
    RemainderProofContext &proofContext, SymbolicMemoryStageTiming &timing,
    ArrayRef<std::unique_ptr<wave::memory_lowering::GatherTransactionProvider>>
        providers) {
  if (access.packetWhere || mappings.size() > kMaxExactCoverNodes)
    return buildGenericGatherPlan(access, store, mappings, elementBits,
                                  proofContext, timing);

  FailureOr<GatherPlan> genericPlan = buildGenericGatherPlan(
      access, store, mappings, elementBits, proofContext, timing);
  if (failed(genericPlan))
    return failure();

  TimingScope providerTiming =
      timing.nest("lower_symbolic_memory_enumerate_provider_gather");
  SmallVector<wave::memory_lowering::GatherTransactionCandidate>
      providerCandidates =
          getProviderGatherCandidates(access, store, mappings, providers);
  providerTiming.stop();
  if (providerCandidates.empty())
    return genericPlan;

  GatherPlan plan;
  TimingScope providerDedupTiming =
      timing.nest("lower_symbolic_memory_deduplicate_provider_gather");
  plan.physicalSlots = deduplicateGatherSlots(
      store, SmallVector<SlotMapping, 4>(mappings.begin(), mappings.end()),
      elementBits, proofContext);
  providerDedupTiming.stop();
  TimingScope providerGraphTiming =
      timing.nest("lower_symbolic_memory_build_provider_successor_graph");
  SmallVector<SmallVector<unsigned>> edges =
      buildSuccessorGraph(store, plan.physicalSlots, elementBits, proofContext);
  providerGraphTiming.stop();
  TimingScope providerCandidateTiming =
      timing.nest("lower_symbolic_memory_enumerate_generic_gather_candidates");
  FailureOr<SmallVector<TransactionCandidate>> genericCandidates =
      enumerateTransactionCandidates(edges, elementBits);
  providerCandidateTiming.stop();
  if (failed(genericCandidates))
    return genericPlan;

  TimingScope providerCoverTiming =
      timing.nest("lower_symbolic_memory_select_provider_gather_cover");
  appendGenericGatherCandidates(plan, *genericCandidates, mappings.size());
  appendProviderGatherCandidates(plan, providerCandidates, mappings.size());
  if (failed(selectGatherCover(plan, mappings.size())))
    return genericPlan;
  providerCoverTiming.stop();
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

static Value findUnconstrainedBinding(const SlotMapping &slot,
                                      StringRef symbol) {
  if (symbol.empty())
    return {};
  llvm::DenseSet<StringRef> liveSymbols{symbol};
  SmallVector<sym::PredHandle> assumptions =
      filterIndexExprPredicatesBySymbols(slot.assumptions, liveSymbols);
  if (!assumptions.empty())
    return {};
  for (const NamedBinding &binding : slot.bindings)
    if (binding.name == symbol && isLegalPtrAddOffset(binding.value.getType()))
      return binding.value;
  return {};
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
  if (Value binding = findUnconstrainedBinding(slot, symbol))
    return binding;

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
  for (const MaterializationCandidate &candidate :
       llvm::reverse(slot.materializationCandidates)) {
    if (!candidate.mayMaterializeAddress ||
        !isLegalPtrAddOffset(candidate.value.getType()))
      continue;
    if (analysis.equivalent(*elementOffset, candidate.expression) ==
        sym::CheckResult::True)
      return candidate.value;
  }
  return {};
}

static PtrType getMemoryBasePtrType(Type type) {
  if (SimdType simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  return cast<PtrType>(type);
}

static Type getMemoryBaseTypeWithElement(Type type, Type elementType) {
  PtrType pointer = getMemoryBasePtrType(type);
  PtrType converted =
      PtrType::get(type.getContext(), elementType, pointer.getAddressSpace());
  if (SimdType simd = dyn_cast<SimdType>(type))
    return SimdType::get(type.getContext(), converted, simd.getWidth());
  return converted;
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
  Type byteType = getMemoryBaseTypeWithElement(access.bases[index].getType(),
                                               rewriter.getI8Type());
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
  PtrType sourceType = getMemoryBasePtrType(access.bases[baseIndex].getType());
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

static Type getPointerAddResultType(MLIRContext *context, Type baseType,
                                    PtrType pointerType, Value offset) {
  if (SimdType simd = dyn_cast<SimdType>(baseType))
    return SimdType::get(context, pointerType, simd.getWidth());
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
  PtrType sourceType = getMemoryBasePtrType(source.getType());
  if (plan.offset) {
    Type resultType = getPointerAddResultType(
        access.op->getContext(), source.getType(), sourceType, plan.offset);
    return PtrAddOp::create(rewriter, access.op->getLoc(), resultType, source,
                            plan.offset)
        .getResult();
  }
  FailureOr<Value> offset =
      materializeExpr(rewriter, access, slot, plan.elementOffset);
  if (failed(offset))
    return failure();
  Type resultType = getPointerAddResultType(
      access.op->getContext(), source.getType(), sourceType, *offset);
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
    for (sym::PredHandle assumption : slot.activationProofAssumptions)
      if (!llvm::is_contained(point.activationProofAssumptions, assumption))
        point.activationProofAssumptions.push_back(assumption);
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

static bool isStaticallyInactiveTransaction(ArrayRef<SlotMapping> slots,
                                            ArrayRef<unsigned> transaction) {
  return llvm::all_of(transaction, [&](unsigned index) {
    return slots[index].staticallyInactive;
  });
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

static bool emitStaticallyInactiveGather(const MemoryAccess &access,
                                         const GatherPlan &plan,
                                         ArrayRef<unsigned> transaction,
                                         GatherEmissionState &state) {
  if (!isStaticallyInactiveTransaction(plan.physicalSlots, transaction))
    return false;
  for (unsigned nodeIndex : transaction)
    for (unsigned logicalSlot : plan.physicalSlots[nodeIndex].logicalSlots)
      state.components[logicalSlot] = access.inactiveComponents[logicalSlot];
  if (access.inactiveToken &&
      !llvm::is_contained(state.tokens, access.inactiveToken))
    state.tokens.push_back(access.inactiveToken);
  return true;
}

static LogicalResult emitGenericGatherCandidate(
    IRRewriter &rewriter, const MemoryAccess &access, const GatherPlan &plan,
    const GatherCandidate &candidate, const SlotMapping &point,
    const TypedPointerPlan &typedPlan, Type componentType,
    GatherEmissionState &state) {
  ArrayRef<unsigned> transaction = candidate.physicalNodes;
  if (emitStaticallyInactiveGather(access, plan, transaction, state))
    return success();
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
  if (isStaticallyInactiveTransaction(slots, transaction))
    return access.inactiveToken;
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
      getMemoryBasePtrType(access.bases.front().getType()).getAddressSpace();
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

static bool coordinatesNeedSymbol(sym::Analysis &analysis,
                                  const MappingCoordinates &coordinates,
                                  StringRef name) {
  MappingCoordinates simplified = coordinates;
  if (failed(simplifyCoordinates(analysis, simplified)) ||
      coordinatesHaveSymbol(simplified, name))
    return true;
  std::array<sym::ExprHandle, 3> roots{
      coordinates.base, coordinates.targetBlock, coordinates.bitOffset};
  // Poison refinement may erase dependencies only from total roots.
  return llvm::any_of(roots, [&](sym::ExprHandle root) {
    return hasSymbol(root, name) &&
           analysis.defined(root) != sym::CheckResult::True;
  });
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
    FailureOr<MappingCoordinates> substituted =
        substituteCoordinates(**analysis, coordinates, substitutions);
    if (failed(substituted) ||
        coordinatesNeedSymbol(**analysis, *substituted, "item"))
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
                            WaveDialect &dialect, DataFlowSolver &solver,
                            SymbolicIndexValueMode mode) {
  SmallVector<SymbolicOffset> components;
  components.reserve(values.size());
  for (Value value : values) {
    FailureOr<std::optional<SymbolicOffset>> symbolic =
        buildSymbolicIndexValue(value, dialect, solver, mode);
    if (failed(symbolic) || !*symbolic) {
      access.op->emitOpError("failed to specialize packet binding producer");
      return failure();
    }
    components.push_back(std::move(**symbolic));
  }
  return components;
}

static bool hasPacketLocalBinding(const MemoryAccess &access,
                                  const SymbolicOffset &offset) {
  if (!access.packetWhere)
    return false;
  return llvm::any_of(
      offset.bindings, [&](const SymbolicOffsetBinding &binding) {
        Operation *producer = binding.value.getDefiningOp();
        return producer && access.packetWhere->isAncestor(producer);
      });
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
        buildPacketComponentOffsets(access, values, dialect, solver,
                                    SymbolicIndexValueMode::PacketProof);
    if (failed(components))
      return failure();
    SmallVector<SymbolicOffset> materializationComponents;
    if (access.packetWhere) {
      FailureOr<SmallVector<SymbolicOffset>> expanded =
          buildPacketComponentOffsets(access, values, dialect, solver,
                                      SymbolicIndexValueMode::Materialization);
      if (failed(expanded) ||
          llvm::any_of(*expanded, [&](const SymbolicOffset &offset) {
            return hasPacketLocalBinding(access, offset);
          })) {
        access.op->emitOpError("failed to externalize packet binding producer");
        return failure();
      }
      materializationComponents = std::move(*expanded);
    } else {
      materializationComponents = *components;
    }
    packetComponents.push_back(
        PacketComponents{std::move(values), std::move(*components),
                         std::move(materializationComponents)});
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

static SlotMapping buildInactiveSlotMapping(PreparedSlotMapping &prepared,
                                            const MappingDomain &domain) {
  SlotMapping mapping = std::move(prepared.mapping);
  mapping.materializationCandidates.clear();
  mapping.base = domain.zero;
  mapping.targetBlock = domain.block;
  mapping.bitOffset = domain.zero;
  mapping.materializationBitOffset = domain.zero;
  mapping.byteOffset = domain.zero;
  mapping.materializationByteOffset = domain.zero;
  mapping.proofOffset.reset();
  mapping.baseIndex = 0;
  return mapping;
}

static void groupPreparedMappings(
    SmallVectorImpl<PreparedSlotMapping> &preparedMappings,
    const MappingDomain &domain, SmallVectorImpl<SlotMapping> &mappings,
    SmallVectorImpl<ExactFactDomainGroup> &groups,
    llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> &buckets) {
  for (auto [index, prepared] : llvm::enumerate(preparedMappings)) {
    if (prepared.mapping.staticallyInactive) {
      mappings[index] = buildInactiveSlotMapping(prepared, domain);
      continue;
    }
    appendExactFactDomainTask(prepared.mapping.assumptions, index, groups,
                              buckets);
  }
}

static FailureOr<SmallVector<SlotMapping, 4>> buildAccessSlotMappings(
    const MemoryAccess &access, sym::Store &store, const MappingDomain &domain,
    int64_t slotCount, const MappedItem &item,
    ArrayRef<sym::ExprSubstitution> bindingSubstitutions,
    ArrayRef<PacketComponents> packetComponents,
    ArrayRef<ActiveControl> controls, ArrayRef<PacketControl> packetControls,
    SymbolicMemoryStageTiming &timing) {
  PacketBindingState bindingState;
  seedPacketBindingState(access, item, bindingState);
  SmallVector<PreparedSlotMapping, 4> preparedMappings;
  preparedMappings.reserve(slotCount);
  TimingScope prepareSlotsTiming =
      timing.nest("lower_symbolic_memory_prepare_mapping_slot_coordinates");
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
    if (isProvablyFalseActivation(store, prepared->mapping)) {
      prepared->mapping.staticallyInactive = true;
      prepared->mapping.assumptions =
          getActivationProofAssumptions(prepared->mapping);
    }
    preparedMappings.push_back(std::move(*prepared));
  }
  prepareSlotsTiming.stop();

  TimingScope groupSlotsTiming =
      timing.nest("lower_symbolic_memory_group_mapping_fact_domains");
  SmallVector<SlotMapping, 4> mappings(preparedMappings.size());
  SmallVector<ExactFactDomainGroup> groups;
  llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> buckets;
  groupPreparedMappings(preparedMappings, domain, mappings, groups, buckets);
  groupSlotsTiming.stop();

  TimingScope analyzeSlotsTiming =
      timing.nest("lower_symbolic_memory_analyze_mapping_slots");
  for (ExactFactDomainGroup &group : groups) {
    TimingScope analysisTiming =
        timing.nest("lower_symbolic_memory_create_mapping_analysis");
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        sym::Analysis::createDirect(store, group.assumptions);
    if (failed(analysis)) {
      access.op->emitOpError("mapping fact domain is inconsistent");
      return failure();
    }
    analysisTiming.stop();
    TimingScope mappingsTiming =
        timing.nest("lower_symbolic_memory_analyze_mapping_coordinates");
    for (size_t index : group.tasks) {
      FailureOr<SlotMapping> mapping =
          analyzeSlotMapping(access, **analysis, domain.block, domain.zero,
                             std::move(preparedMappings[index]));
      if (failed(mapping)) {
        access.op->emitOpError(
            "mapping is not a defined, byte-addressable local memory point at "
            "packet slot ")
            << index;
        return failure();
      }
      mappings[index] = std::move(*mapping);
    }
    mappingsTiming.stop();
  }
  return mappings;
}

static FailureOr<PreparedAccessMappings>
prepareAccessMappings(IRRewriter &rewriter, MemoryAccess &access,
                      WaveDialect &dialect, DataFlowSolver &solver,
                      SymbolicMemoryStageTiming &timing) {
  TimingScope setupTiming =
      timing.nest("lower_symbolic_memory_prepare_mapping_setup");
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
  setupTiming.stop();
  TimingScope itemTiming =
      timing.nest("lower_symbolic_memory_prepare_mapping_item");
  bool needsItem = mappingNeedsItemAfterSlotSpecialization(
      access, store, *domain, shape->slotCount, *bindingSubstitutions);
  FailureOr<MappedItem> item =
      getMappedItem(rewriter, access, store, needsItem);
  if (failed(item))
    return failure();
  itemTiming.stop();
  TimingScope componentsTiming =
      timing.nest("lower_symbolic_memory_prepare_mapping_components");
  FailureOr<SmallVector<PacketComponents, 4>> packetComponents =
      buildPacketComponents(rewriter, access, shape->slotCount, dialect,
                            solver);
  if (failed(packetComponents))
    return failure();
  componentsTiming.stop();
  TimingScope controlsTiming =
      timing.nest("lower_symbolic_memory_prepare_mapping_controls");
  SmallVector<ActiveControl> controls =
      buildActiveControls(access, dialect, solver);
  FailureOr<SmallVector<PacketControl>> packetControls =
      buildPacketControls(access, dialect, solver);
  if (failed(packetControls))
    return access.op->emitOpError(
        "failed to analyze symbolic memory packet predicates");
  controlsTiming.stop();
  TimingScope slotsTiming =
      timing.nest("lower_symbolic_memory_prepare_mapping_slots");
  FailureOr<SmallVector<SlotMapping, 4>> mappings = buildAccessSlotMappings(
      access, store, *domain, shape->slotCount, *item, *bindingSubstitutions,
      *packetComponents, controls, *packetControls, timing);
  if (failed(mappings))
    return failure();
  return PreparedAccessMappings{std::move(*mappings), *shape};
}

struct DmaCopyTransaction {
  SmallVector<unsigned> sourceSlots;
  SmallVector<unsigned> destinationSlots;
  std::unique_ptr<SlotMapping> sourcePoint;
  std::unique_ptr<SlotMapping> destinationPoint;
  std::optional<sym::PredHandle> activationPredicate;
  int64_t bytes = 0;
};

struct DmaExecutionBinding {
  std::string name;
  Value value;
};

struct DmaCopyMatch {
  GatherOp gather;
  WhereOp predicate;
  bool zeroFillInactive = false;
};

static void
deduplicateAssumptions(SmallVectorImpl<sym::PredHandle> &assumptions) {
  SmallVector<sym::PredHandle> unique;
  unique.reserve(assumptions.size());
  for (sym::PredHandle assumption : assumptions)
    if (!llvm::is_contained(unique, assumption))
      unique.push_back(assumption);
  assumptions.assign(unique.begin(), unique.end());
}

static llvm::hash_code
hashAssumptionSet(ArrayRef<sym::PredHandle> assumptions) {
  size_t xorHash = 0;
  size_t sumHash = 0;
  for (sym::PredHandle assumption : assumptions) {
    size_t valueHash = hash_value(assumption);
    xorHash ^= valueHash;
    sumHash += valueHash;
  }
  return llvm::hash_combine(assumptions.size(), xorHash, sumHash);
}

static bool sameAssumptionSet(ArrayRef<sym::PredHandle> lhs,
                              ArrayRef<sym::PredHandle> rhs) {
  return lhs.size() == rhs.size() &&
         llvm::all_of(lhs, [&](sym::PredHandle assumption) {
           return llvm::is_contained(rhs, assumption);
         });
}

struct DmaDestinationSlotShape {
  SmallVector<sym::PredHandle> assumptions;
  sym::ExprHandle base;
  sym::ExprHandle targetBlock;
  sym::ExprHandle offset;
  int64_t relativeConstant = 0;
  int64_t baseIndex = 0;

  friend bool operator==(const DmaDestinationSlotShape &lhs,
                         const DmaDestinationSlotShape &rhs) {
    return sameAssumptionSet(lhs.assumptions, rhs.assumptions) &&
           lhs.base == rhs.base && lhs.targetBlock == rhs.targetBlock &&
           lhs.offset == rhs.offset &&
           lhs.relativeConstant == rhs.relativeConstant &&
           lhs.baseIndex == rhs.baseIndex;
  }
};

struct DmaDestinationProofShape {
  SmallVector<DmaDestinationSlotShape> slots;
  std::string executionName;
  Operation *function = nullptr;
  int64_t waveWidth = 0;
  int64_t itemCount = 0;
  int64_t elementBytes = 0;
  int64_t transactionBytes = 0;

  friend bool operator==(const DmaDestinationProofShape &lhs,
                         const DmaDestinationProofShape &rhs) {
    return lhs.function == rhs.function &&
           lhs.executionName == rhs.executionName &&
           lhs.waveWidth == rhs.waveWidth && lhs.itemCount == rhs.itemCount &&
           lhs.elementBytes == rhs.elementBytes &&
           lhs.transactionBytes == rhs.transactionBytes &&
           lhs.slots == rhs.slots;
  }
};

static llvm::hash_code
hashDmaDestinationProofShape(const DmaDestinationProofShape &shape) {
  llvm::hash_code hash = llvm::hash_combine(
      shape.function, shape.executionName, shape.waveWidth, shape.itemCount,
      shape.elementBytes, shape.transactionBytes);
  for (const DmaDestinationSlotShape &slot : shape.slots)
    hash = llvm::hash_combine(hash, slot.base, slot.targetBlock, slot.offset,
                              slot.relativeConstant, slot.baseIndex,
                              hashAssumptionSet(slot.assumptions));
  return hash;
}

class DmaDestinationProofCache {
public:
  std::optional<bool> lookup(const DmaDestinationProofShape &shape) const {
    llvm::hash_code hash = hashDmaDestinationProofShape(shape);
    auto bucket = buckets.find(hash);
    if (bucket == buckets.end())
      return std::nullopt;
    for (size_t index : bucket->second)
      if (entries[index].shape == shape)
        return entries[index].result;
    return std::nullopt;
  }

  void insert(DmaDestinationProofShape shape, bool result) {
    llvm::hash_code hash = hashDmaDestinationProofShape(shape);
    SmallVector<size_t> &bucket = buckets[hash];
    for (size_t index : bucket)
      if (entries[index].shape == shape)
        return;
    bucket.push_back(entries.size());
    entries.push_back({std::move(shape), result});
  }

private:
  struct Entry {
    DmaDestinationProofShape shape;
    bool result = false;
  };

  SmallVector<Entry> entries;
  llvm::DenseMap<llvm::hash_code, SmallVector<size_t>> buckets;
};

static bool hasUnpredicatedMappings(ArrayRef<SlotMapping> mappings) {
  return llvm::all_of(mappings, [](const SlotMapping &mapping) {
    return !mapping.activationPredicate && !mapping.packetCondition;
  });
}

static bool isZeroPacket(Value value) {
  if (matchPattern(value, m_Zero()))
    return true;
  if (ConstantOp constant = value.getDefiningOp<ConstantOp>()) {
    Attribute attribute = constant.getValue();
    if (IntegerAttr integer = dyn_cast<IntegerAttr>(attribute))
      return integer.getValue().isZero();
    if (FloatAttr floating = dyn_cast<FloatAttr>(attribute))
      return floating.getValue().isZero();
  }
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    return isZeroPacket(splat.getSource());
  PackOp pack = value.getDefiningOp<PackOp>();
  return pack && llvm::all_of(pack.getInputs(), isZeroPacket);
}

static std::optional<DmaCopyMatch> matchDirectDmaCopy(ScatterOp scatter) {
  GatherOp gather = scatter.getValue().getDefiningOp<GatherOp>();
  if (!gather || gather->getBlock() != scatter->getBlock() ||
      !gather.getValue().hasOneUse() || !gather.getToken().hasOneUse() ||
      scatter.getDependency() != gather.getToken())
    return std::nullopt;
  return DmaCopyMatch{gather, {}, false};
}

static GatherOp matchDmaCopyThenRegion(WhereOp where) {
  Block &block = where.getThenRegion().front();
  YieldOp yield = dyn_cast<YieldOp>(block.getTerminator());
  if (!yield || yield.getNumOperands() != 2)
    return {};
  GatherOp gather = yield.getOperand(0).getDefiningOp<GatherOp>();
  if (!gather)
    return {};
  MemoryAccess access = getAccess(gather);
  if (gather->getNextNode() != yield ||
      yield.getOperand(1) != gather.getToken() ||
      !gather.getValue().hasOneUse() || !gather.getToken().hasOneUse())
    return {};
  if (!hasIsolatedPacketAccess(where, access, yield))
    return {};
  return gather;
}

static bool hasDmaCopyZeroFallback(WhereOp where, GatherOp gather) {
  Block &block = where.getElseRegion().front();
  YieldOp yield = dyn_cast<YieldOp>(block.getTerminator());
  return yield && &block.front() == yield.getOperation() &&
         yield.getNumOperands() == 2 && gather.getDependency() &&
         yield.getOperand(1) == gather.getDependency() &&
         isZeroPacket(yield.getOperand(0));
}

static bool hasDmaCopyWhereResults(ScatterOp scatter, WhereOp where) {
  return where->getBlock() == scatter->getBlock() &&
         where.getNumResults() == 2 &&
         scatter.getValue() == where.getResult(0) &&
         scatter.getDependency() == where.getResult(1) &&
         where.getResult(0).hasOneUse() && where.getResult(1).hasOneUse();
}

static bool hasDmaCopyWhereRegions(WhereOp where) {
  return !where.getThenRegion().empty() && !where.getElseRegion().empty();
}

static std::optional<DmaCopyMatch> matchPredicatedDmaCopy(ScatterOp scatter) {
  WhereOp where = scatter.getValue().getDefiningOp<WhereOp>();
  if (!where)
    return std::nullopt;
  if (!hasDmaCopyWhereResults(scatter, where) || !hasDmaCopyWhereRegions(where))
    return std::nullopt;

  GatherOp gather = matchDmaCopyThenRegion(where);
  if (!gather || !hasDmaCopyZeroFallback(where, gather))
    return std::nullopt;
  return DmaCopyMatch{gather, where, true};
}

static std::optional<DmaCopyMatch> matchDmaCopy(ScatterOp scatter) {
  if (std::optional<DmaCopyMatch> direct = matchDirectDmaCopy(scatter))
    return direct;
  return matchPredicatedDmaCopy(scatter);
}

static FailureOr<Value>
getDmaCopyCondition(const DmaCopyMatch &match, ArrayRef<SlotMapping> mappings,
                    ArrayRef<unsigned> transaction,
                    RemainderProofContext &proofContext) {
  if (!match.zeroFillInactive)
    return Value{};
  WhereOp predicate = match.predicate;
  if (predicate.getConditions().size() == 1)
    return predicate.getCondition();
  if (transaction.empty())
    return failure();

  const SlotMapping &reference = mappings[transaction.front()];
  if (!reference.packetCondition)
    return failure();
  for (unsigned index : transaction) {
    if (index >= mappings.size() || !mappings[index].packetCondition ||
        !proofContext.sameActivation(reference, mappings[index]))
      return failure();
  }
  return reference.packetCondition;
}

static bool mappingUsesDmaExecution(const SlotMapping &mapping,
                                    const NamedBinding &candidate) {
  auto found =
      llvm::find_if(mapping.bindings, [&](const NamedBinding &binding) {
        return binding.name == candidate.name &&
               binding.value == candidate.value;
      });
  if (found == mapping.bindings.end())
    return false;
  return hasSymbol(mapping.base, candidate.name) ||
         hasSymbol(mapping.targetBlock, candidate.name) ||
         hasSymbol(mapping.byteOffset, candidate.name) ||
         hasSymbol(mapping.materializationByteOffset, candidate.name);
}

static bool isDmaExecutionBinding(const NamedBinding &candidate,
                                  ArrayRef<SlotMapping> mappings) {
  WorkitemIdOp workitem = candidate.value.getDefiningOp<WorkitemIdOp>();
  return workitem && workitem.getAxis() == 0 &&
         llvm::all_of(mappings, [&](const SlotMapping &mapping) {
           return mappingUsesDmaExecution(mapping, candidate);
         });
}

static std::optional<DmaExecutionBinding>
findDmaExecutionBinding(ArrayRef<SlotMapping> mappings) {
  if (mappings.empty())
    return std::nullopt;
  auto found = llvm::find_if(
      mappings.front().bindings, [&](const NamedBinding &candidate) {
        return isDmaExecutionBinding(candidate, mappings);
      });
  if (found == mappings.front().bindings.end())
    return std::nullopt;
  return DmaExecutionBinding{found->name, found->value};
}

static void rebindDmaExecution(MutableArrayRef<SlotMapping> mappings,
                               const DmaExecutionBinding &source,
                               Value replacement) {
  for (SlotMapping &mapping : mappings)
    for (NamedBinding &binding : mapping.bindings)
      if (binding.name == source.name && binding.value == source.value)
        binding.value = replacement;
}

static FailureOr<sym::ExprHandle>
substituteDmaExecutionItem(sym::Analysis &analysis, sym::ExprHandle expression,
                           sym::ExprHandle item, sym::ExprHandle replacement) {
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{item, replacement}};
  FailureOr<sym::ExprHandle> result =
      analysis.substitute(expression, substitution);
  if (failed(result))
    return failure();
  return analysis.simplify(*result);
}

static bool proveEquivalent(sym::Analysis &analysis, sym::ExprHandle lhs,
                            sym::ExprHandle rhs) {
  return analysis.equivalent(lhs, rhs) == sym::CheckResult::True;
}

static FailureOr<sym::ExprHandle> addDmaConstant(sym::Analysis &analysis,
                                                 sym::ExprHandle expression,
                                                 int64_t value) {
  if (value == 0)
    return expression;
  FailureOr<sym::ExprHandle> constant = analysis.composeInteger(value);
  if (failed(constant))
    return failure();
  return analysis.compose(expression, sym::ExprBinaryOp::Add, *constant);
}

static FailureOr<sym::ExprHandle> buildDmaWaveBase(sym::Analysis &analysis,
                                                   sym::ExprHandle item,
                                                   int64_t waveWidth) {
  FailureOr<sym::ExprHandle> width = analysis.composeInteger(waveWidth);
  if (failed(width))
    return failure();
  FailureOr<sym::ExprHandle> lane =
      analysis.compose(item, sym::ExprBinaryOp::Mod, *width);
  if (failed(lane))
    return failure();
  return analysis.compose(item, sym::ExprBinaryOp::Sub, *lane);
}

struct DmaDestinationReference {
  sym::ExprHandle address;
  sym::ExprHandle base;
  sym::ExprHandle targetBlock;
};

static FailureOr<DmaDestinationReference>
getDmaDestinationReference(sym::Analysis &analysis, const SlotMapping &first,
                           sym::ExprHandle item,
                           sym::ExprHandle referenceItem) {
  FailureOr<sym::ExprHandle> address = substituteDmaExecutionItem(
      analysis, first.byteOffset, item, referenceItem);
  FailureOr<sym::ExprHandle> base =
      substituteDmaExecutionItem(analysis, first.base, item, referenceItem);
  FailureOr<sym::ExprHandle> targetBlock = substituteDmaExecutionItem(
      analysis, first.targetBlock, item, referenceItem);
  if (failed(address) || failed(base) || failed(targetBlock))
    return failure();
  return DmaDestinationReference{*address, *base, *targetBlock};
}

static bool proveDmaDestinationSlot(sym::Analysis &analysis,
                                    const SlotMapping &slot,
                                    const SlotMapping &first,
                                    const DmaDestinationReference &reference,
                                    sym::ExprHandle expectedAddress) {
  if (slot.baseIndex != first.baseIndex)
    return false;
  if (!proveEquivalent(analysis, slot.base, reference.base) ||
      !proveEquivalent(analysis, slot.targetBlock, reference.targetBlock))
    return false;
  return proveEquivalent(analysis, slot.byteOffset, expectedAddress);
}

static bool proveDmaDestinationAlgebraically(
    sym::Analysis &analysis, ArrayRef<SlotMapping> slots,
    ArrayRef<unsigned> transaction, sym::ExprHandle item, int64_t waveWidth,
    int64_t elementBytes, int64_t transactionBytes) {
  const SlotMapping &first = slots[transaction.front()];
  FailureOr<sym::ExprHandle> waveBase =
      buildDmaWaveBase(analysis, item, waveWidth);
  if (failed(waveBase))
    return false;
  FailureOr<sym::ExprHandle> lane =
      analysis.compose(item, sym::ExprBinaryOp::Sub, *waveBase);
  FailureOr<sym::ExprHandle> bytes = analysis.composeInteger(transactionBytes);
  if (failed(lane) || failed(bytes))
    return false;
  FailureOr<sym::ExprHandle> laneBytes =
      analysis.compose(*lane, sym::ExprBinaryOp::Mul, *bytes);
  if (failed(laneBytes))
    return false;
  FailureOr<DmaDestinationReference> reference =
      getDmaDestinationReference(analysis, first, item, *waveBase);
  if (failed(reference))
    return false;

  FailureOr<sym::ExprHandle> laneAddress =
      analysis.compose(reference->address, sym::ExprBinaryOp::Add, *laneBytes);
  if (failed(laneAddress))
    return false;
  for (auto [position, slotIndex] : llvm::enumerate(transaction)) {
    const SlotMapping &slot = slots[slotIndex];
    FailureOr<sym::ExprHandle> expected = addDmaConstant(
        analysis, *laneAddress, static_cast<int64_t>(position) * elementBytes);
    if (failed(expected) ||
        !proveDmaDestinationSlot(analysis, slot, first, *reference, *expected))
      return false;
  }
  return true;
}

static bool proveEnumeratedDmaDestinationSlot(
    sym::Analysis &analysis, const SlotMapping &slot, const SlotMapping &first,
    const DmaDestinationReference &reference, sym::ExprHandle item,
    sym::ExprHandle executionValue, int64_t byteOffset) {
  FailureOr<sym::ExprHandle> actual = substituteDmaExecutionItem(
      analysis, slot.byteOffset, item, executionValue);
  FailureOr<sym::ExprHandle> actualBase =
      substituteDmaExecutionItem(analysis, slot.base, item, executionValue);
  FailureOr<sym::ExprHandle> actualTarget = substituteDmaExecutionItem(
      analysis, slot.targetBlock, item, executionValue);
  FailureOr<sym::ExprHandle> expected =
      addDmaConstant(analysis, reference.address, byteOffset);
  if (failed(actual) || failed(actualBase) || failed(actualTarget) ||
      failed(expected) || slot.baseIndex != first.baseIndex)
    return false;
  return proveEquivalent(analysis, *actualBase, reference.base) &&
         proveEquivalent(analysis, *actualTarget, reference.targetBlock) &&
         proveEquivalent(analysis, *actual, *expected);
}

static bool
proveDmaDestinationForItem(sym::Analysis &analysis, ArrayRef<SlotMapping> slots,
                           ArrayRef<unsigned> transaction, sym::ExprHandle item,
                           int64_t executionItem, int64_t waveWidth,
                           int64_t elementBytes, int64_t transactionBytes) {
  const SlotMapping &first = slots[transaction.front()];
  int64_t waveBaseItem = executionItem - executionItem % waveWidth;
  FailureOr<sym::ExprHandle> executionValue =
      analysis.composeInteger(executionItem);
  FailureOr<sym::ExprHandle> waveBaseValue =
      analysis.composeInteger(waveBaseItem);
  if (failed(executionValue) || failed(waveBaseValue))
    return false;
  FailureOr<DmaDestinationReference> reference =
      getDmaDestinationReference(analysis, first, item, *waveBaseValue);
  if (failed(reference))
    return false;
  return llvm::all_of(llvm::enumerate(transaction), [&](auto indexedSlot) {
    int64_t offset = (executionItem % waveWidth) * transactionBytes +
                     static_cast<int64_t>(indexedSlot.index()) * elementBytes;
    return proveEnumeratedDmaDestinationSlot(
        analysis, slots[indexedSlot.value()], first, *reference, item,
        *executionValue, offset);
  });
}

static bool proveDmaDestinationByEnumeration(
    sym::Analysis &analysis, ArrayRef<SlotMapping> slots,
    ArrayRef<unsigned> transaction, sym::ExprHandle item, int64_t itemCount,
    int64_t waveWidth, int64_t elementBytes, int64_t transactionBytes) {
  return llvm::all_of(
      llvm::seq<int64_t>(0, itemCount), [&](int64_t executionItem) {
        return proveDmaDestinationForItem(analysis, slots, transaction, item,
                                          executionItem, waveWidth,
                                          elementBytes, transactionBytes);
      });
}

static std::optional<int64_t> getDmaItemCount(const MemoryAccess &access,
                                              int64_t waveWidth) {
  DenseI32ArrayAttr shape = getWorkgroupShape(access.op);
  if (!shape || shape.size() != 3 || shape[0] <= 0 || shape[1] != 1 ||
      shape[2] != 1 || waveWidth <= 0 || shape[0] % waveWidth != 0)
    return std::nullopt;
  return shape[0];
}

static DmaDestinationSlotShape
buildDmaDestinationSlotShape(const SlotMapping &slot) {
  DmaDestinationSlotShape shape;
  shape.assumptions = slot.assumptions;
  deduplicateAssumptions(shape.assumptions);
  shape.base = slot.base;
  shape.targetBlock = slot.targetBlock;
  shape.baseIndex = slot.baseIndex;
  return shape;
}

static SmallVector<DmaDestinationSlotShape>
buildRawDmaDestinationSlotShapes(ArrayRef<SlotMapping> slots,
                                 ArrayRef<unsigned> transaction) {
  SmallVector<DmaDestinationSlotShape> shapes;
  shapes.reserve(transaction.size());
  for (unsigned index : transaction) {
    DmaDestinationSlotShape shape = buildDmaDestinationSlotShape(slots[index]);
    shape.offset = slots[index].byteOffset;
    shapes.push_back(std::move(shape));
  }
  return shapes;
}

static std::optional<SmallVector<DmaDestinationSlotShape>>
buildNormalizedDmaDestinationSlotShapes(ArrayRef<SlotMapping> slots,
                                        ArrayRef<unsigned> transaction) {
  if (transaction.empty())
    return std::nullopt;
  for (unsigned index : transaction)
    if (index >= slots.size() || !slots[index].proofOffset)
      return std::nullopt;

  int64_t referenceConstant = slots[transaction.front()].proofOffset->constant;
  SmallVector<DmaDestinationSlotShape> shapes;
  shapes.reserve(transaction.size());
  for (unsigned index : transaction) {
    const SlotMapping &slot = slots[index];
    std::optional<int64_t> relative =
        llvm::checkedSub(slot.proofOffset->constant, referenceConstant);
    if (!relative)
      return std::nullopt;
    DmaDestinationSlotShape shape = buildDmaDestinationSlotShape(slot);
    shape.offset = slot.proofOffset->residual;
    shape.relativeConstant = *relative;
    shapes.push_back(std::move(shape));
  }
  return shapes;
}

static DmaDestinationProofShape buildDmaDestinationProofShape(
    const MemoryAccess &access, ArrayRef<SlotMapping> slots,
    ArrayRef<unsigned> transaction, const DmaExecutionBinding &execution,
    int64_t itemCount, int64_t waveWidth, int64_t elementBytes,
    int64_t transactionBytes) {
  DmaDestinationProofShape shape;
  if (func::FuncOp function = access.op->getParentOfType<func::FuncOp>())
    shape.function = function.getOperation();
  shape.executionName = execution.name;
  shape.itemCount = itemCount;
  shape.waveWidth = waveWidth;
  shape.elementBytes = elementBytes;
  shape.transactionBytes = transactionBytes;
  std::optional<SmallVector<DmaDestinationSlotShape>> normalized =
      buildNormalizedDmaDestinationSlotShapes(slots, transaction);
  shape.slots = normalized
                    ? std::move(*normalized)
                    : buildRawDmaDestinationSlotShapes(slots, transaction);
  return shape;
}

static bool proveDmaDestinationTransaction(
    const MemoryAccess &access, ArrayRef<SlotMapping> slots,
    ArrayRef<unsigned> transaction, const DmaExecutionBinding &execution,
    int64_t elementBytes, int64_t transactionBytes, sym::Store &store,
    DmaDestinationProofCache &proofCache) {
  if (transaction.empty())
    return false;
  int64_t waveWidth = access.packetType.getWidth();
  std::optional<int64_t> itemCount = getDmaItemCount(access, waveWidth);
  if (!itemCount)
    return false;

  DmaDestinationProofShape proofShape = buildDmaDestinationProofShape(
      access, slots, transaction, execution, *itemCount, waveWidth,
      elementBytes, transactionBytes);
  if (std::optional<bool> cached = proofCache.lookup(proofShape))
    return *cached;
  SmallVector<sym::PredHandle> assumptions;
  for (unsigned slotIndex : transaction)
    llvm::append_range(assumptions, slots[slotIndex].assumptions);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, assumptions);
  if (failed(analysis)) {
    proofCache.insert(std::move(proofShape), false);
    return false;
  }
  FailureOr<sym::ExprHandle> item = (*analysis)->composeSymbol(execution.name);
  if (failed(item)) {
    proofCache.insert(std::move(proofShape), false);
    return false;
  }
  bool proven = proveDmaDestinationAlgebraically(**analysis, slots, transaction,
                                                 *item, waveWidth, elementBytes,
                                                 transactionBytes);
  if (!proven)
    proven = proveDmaDestinationByEnumeration(**analysis, slots, transaction,
                                              *item, *itemCount, waveWidth,
                                              elementBytes, transactionBytes);
  proofCache.insert(std::move(proofShape), proven);
  return proven;
}

struct DmaCopyPoint {
  int64_t item = 0;
  unsigned sourceSlot = 0;
  unsigned destinationSlot = 0;
};

struct RankedDmaCopyPoint {
  DmaCopyPoint point;
  int64_t destinationOffset = 0;
};

using DmaMappingExpression = sym::ExprHandle SlotMapping::*;

static FailureOr<sym::ExprHandle> specializeDmaItem(sym::Analysis &analysis,
                                                    sym::ExprHandle expression,
                                                    sym::ExprHandle item,
                                                    int64_t value) {
  FailureOr<sym::ExprHandle> replacement = analysis.composeInteger(value);
  if (failed(replacement))
    return failure();
  return substituteDmaExecutionItem(analysis, expression, item, *replacement);
}

static FailureOr<int64_t> getDmaConstantDifference(sym::Analysis &analysis,
                                                   sym::ExprHandle expression,
                                                   sym::ExprHandle reference) {
  FailureOr<sym::ExprHandle> difference =
      analysis.compose(expression, sym::ExprBinaryOp::Sub, reference);
  if (failed(difference))
    return failure();
  difference = analysis.simplify(*difference);
  if (failed(difference))
    return failure();
  std::optional<int64_t> value = sym::getIntegerLiteralValue(*difference);
  if (!value)
    return failure();
  return *value;
}

static FailureOr<sym::ExprHandle>
composeDmaItemBit(sym::Analysis &analysis, sym::ExprHandle item, unsigned bit) {
  FailureOr<sym::ExprHandle> divisor =
      analysis.composeInteger(int64_t{1} << bit);
  if (failed(divisor))
    return failure();
  FailureOr<sym::ExprHandle> divided =
      analysis.compose(item, sym::ExprBinaryOp::Div, *divisor);
  if (failed(divided))
    return failure();
  divided = analysis.composeFloor(*divided);
  FailureOr<sym::ExprHandle> two = analysis.composeInteger(2);
  if (failed(divided) || failed(two))
    return failure();
  return analysis.compose(*divided, sym::ExprBinaryOp::Mod, *two);
}

static FailureOr<sym::ExprHandle>
appendDmaAdditiveTerm(sym::Analysis &analysis, sym::ExprHandle result,
                      sym::ExprHandle item, unsigned bit, int64_t coefficient) {
  if (coefficient == 0)
    return result;
  FailureOr<sym::ExprHandle> itemBit = composeDmaItemBit(analysis, item, bit);
  FailureOr<sym::ExprHandle> coefficientExpr =
      analysis.composeInteger(coefficient);
  if (failed(itemBit) || failed(coefficientExpr))
    return failure();
  FailureOr<sym::ExprHandle> term =
      analysis.compose(*itemBit, sym::ExprBinaryOp::Mul, *coefficientExpr);
  if (failed(term))
    return failure();
  return analysis.compose(result, sym::ExprBinaryOp::Add, *term);
}

static bool isDmaAdditiveSequence(ArrayRef<int64_t> differences,
                                  ArrayRef<int64_t> coefficients) {
  for (uint64_t value = 0; value < differences.size(); ++value) {
    int64_t expected = 0;
    for (auto [bit, coefficient] : llvm::enumerate(coefficients))
      if (value & (uint64_t{1} << bit))
        expected += coefficient;
    if (expected != differences[value])
      return false;
  }
  return true;
}

static FailureOr<SmallVector<int64_t>>
getDmaAdditiveCoefficients(ArrayRef<int64_t> differences) {
  if (differences.empty() || differences.front() != 0 ||
      !llvm::isPowerOf2_64(differences.size()))
    return failure();
  unsigned bits = llvm::Log2_64(differences.size());
  SmallVector<int64_t> coefficients;
  coefficients.reserve(bits);
  for (unsigned bit = 0; bit < bits; ++bit)
    coefficients.push_back(differences[int64_t{1} << bit]);
  if (!isDmaAdditiveSequence(differences, coefficients))
    return failure();
  return coefficients;
}

static FailureOr<sym::ExprHandle>
synthesizeDmaAdditiveExpression(sym::Analysis &analysis, sym::ExprHandle item,
                                sym::ExprHandle reference,
                                ArrayRef<int64_t> differences) {
  FailureOr<SmallVector<int64_t>> coefficients =
      getDmaAdditiveCoefficients(differences);
  if (failed(coefficients))
    return failure();
  sym::ExprHandle result = reference;
  for (auto [bit, coefficient] : llvm::enumerate(*coefficients)) {
    FailureOr<sym::ExprHandle> sum =
        appendDmaAdditiveTerm(analysis, result, item, bit, coefficient);
    if (failed(sum))
      return failure();
    result = *sum;
  }
  return analysis.simplify(result);
}

struct DmaBitAffineSequence {
  SmallVector<uint64_t> normalized;
  int64_t minimum = 0;
  uint64_t maximum = 0;
};

static FailureOr<DmaBitAffineSequence>
normalizeDmaBitAffineSequence(ArrayRef<int64_t> differences) {
  if (differences.empty() || differences.front() != 0 ||
      !llvm::isPowerOf2_64(differences.size()))
    return failure();
  DmaBitAffineSequence sequence;
  sequence.minimum = *llvm::min_element(differences);
  sequence.normalized.reserve(differences.size());
  for (int64_t difference : differences) {
    std::optional<int64_t> shifted =
        llvm::checkedSub(difference, sequence.minimum);
    if (!shifted || *shifted < 0)
      return failure();
    uint64_t value = static_cast<uint64_t>(*shifted);
    sequence.normalized.push_back(value);
    sequence.maximum = std::max(sequence.maximum, value);
  }
  return sequence;
}

static SmallVector<bool> getDmaBitAffineCoefficients(ArrayRef<uint64_t> values,
                                                     unsigned inputBits,
                                                     unsigned outputBit,
                                                     bool constant) {
  SmallVector<bool> coefficients;
  coefficients.reserve(inputBits);
  for (unsigned inputBit = 0; inputBit < inputBits; ++inputBit)
    coefficients.push_back(
        constant ^
        static_cast<bool>((values[uint64_t{1} << inputBit] >> outputBit) & 1));
  return coefficients;
}

static bool verifyDmaBitAffineOutput(ArrayRef<uint64_t> values,
                                     ArrayRef<bool> coefficients,
                                     unsigned outputBit, bool constant) {
  for (uint64_t value = 0; value < values.size(); ++value) {
    bool expected = constant;
    for (auto [inputBit, coefficient] : llvm::enumerate(coefficients))
      if (coefficient && (value & (uint64_t{1} << inputBit)))
        expected = !expected;
    if (expected != static_cast<bool>((values[value] >> outputBit) & 1))
      return false;
  }
  return true;
}

static FailureOr<sym::ExprHandle>
composeDmaBitAffineOutput(sym::Analysis &analysis, sym::ExprHandle item,
                          ArrayRef<bool> coefficients, bool constant) {
  FailureOr<sym::ExprHandle> output = analysis.composeInteger(constant ? 1 : 0);
  if (failed(output))
    return failure();
  for (auto [inputBit, coefficient] : llvm::enumerate(coefficients)) {
    if (!coefficient)
      continue;
    FailureOr<sym::ExprHandle> input =
        composeDmaItemBit(analysis, item, inputBit);
    if (failed(input))
      return failure();
    output = analysis.compose(*output, sym::ExprBinaryOp::Xor, *input);
    if (failed(output))
      return failure();
  }
  return output;
}

static FailureOr<sym::ExprHandle>
appendDmaBitAffineOutput(sym::Analysis &analysis, sym::ExprHandle result,
                         sym::ExprHandle output, unsigned outputBit) {
  FailureOr<sym::ExprHandle> weight =
      analysis.composeInteger(int64_t{1} << outputBit);
  if (failed(weight))
    return failure();
  FailureOr<sym::ExprHandle> term =
      analysis.compose(output, sym::ExprBinaryOp::Mul, *weight);
  if (failed(term))
    return failure();
  return analysis.compose(result, sym::ExprBinaryOp::Add, *term);
}

static FailureOr<sym::ExprHandle>
synthesizeDmaBitAffineExpression(sym::Analysis &analysis, sym::ExprHandle item,
                                 sym::ExprHandle reference,
                                 ArrayRef<int64_t> differences) {
  FailureOr<DmaBitAffineSequence> sequence =
      normalizeDmaBitAffineSequence(differences);
  if (failed(sequence))
    return failure();
  FailureOr<sym::ExprHandle> result =
      addDmaConstant(analysis, reference, sequence->minimum);
  if (failed(result) || sequence->maximum == 0)
    return result;

  unsigned inputBits = llvm::Log2_64(differences.size());
  unsigned outputBits = llvm::Log2_64(sequence->maximum) + 1;
  for (unsigned outputBit = 0; outputBit < outputBits; ++outputBit) {
    bool constant = (sequence->normalized.front() >> outputBit) & 1;
    SmallVector<bool> coefficients = getDmaBitAffineCoefficients(
        sequence->normalized, inputBits, outputBit, constant);
    if (!verifyDmaBitAffineOutput(sequence->normalized, coefficients, outputBit,
                                  constant))
      return failure();
    if (!constant &&
        llvm::none_of(coefficients, [](bool value) { return value; }))
      continue;
    FailureOr<sym::ExprHandle> output =
        composeDmaBitAffineOutput(analysis, item, coefficients, constant);
    if (failed(output))
      return failure();
    result = appendDmaBitAffineOutput(analysis, *result, *output, outputBit);
    if (failed(result))
      return failure();
  }
  return analysis.simplify(*result);
}

static unsigned getDmaPointSlot(const DmaCopyPoint &point, bool source) {
  return source ? point.sourceSlot : point.destinationSlot;
}

static FailureOr<sym::ExprHandle>
synthesizeDmaExpressionSequence(sym::Analysis &analysis,
                                ArrayRef<sym::ExprHandle> expressions,
                                sym::ExprHandle item) {
  if (expressions.empty())
    return failure();
  sym::ExprHandle reference = expressions.front();
  SmallVector<int64_t> differences;
  differences.reserve(expressions.size());
  for (sym::ExprHandle expression : expressions) {
    FailureOr<int64_t> difference =
        getDmaConstantDifference(analysis, expression, reference);
    if (failed(difference))
      return failure();
    differences.push_back(*difference);
  }
  FailureOr<sym::ExprHandle> additive =
      synthesizeDmaAdditiveExpression(analysis, item, reference, differences);
  if (succeeded(additive))
    return additive;
  return synthesizeDmaBitAffineExpression(analysis, item, reference,
                                          differences);
}

static FailureOr<sym::ExprHandle> synthesizeDmaMappingExpression(
    sym::Analysis &analysis, ArrayRef<SlotMapping> mappings,
    ArrayRef<DmaCopyPoint> points, bool source, sym::ExprHandle item,
    DmaMappingExpression member) {
  if (points.empty())
    return failure();
  SmallVector<sym::ExprHandle> expressions;
  expressions.reserve(points.size());
  for (const DmaCopyPoint &point : points) {
    const SlotMapping &mapping = mappings[getDmaPointSlot(point, source)];
    FailureOr<sym::ExprHandle> expression =
        specializeDmaItem(analysis, mapping.*member, item, point.item);
    if (failed(expression))
      return failure();
    expressions.push_back(*expression);
  }
  return synthesizeDmaExpressionSequence(analysis, expressions, item);
}

static FailureOr<sym::PredHandle> synthesizeDmaPredicateSequence(
    sym::Analysis &analysis, ArrayRef<sym::PredHandle> predicates,
    ArrayRef<DmaCopyPoint> points, sym::ExprHandle item);

static std::optional<sym::PredKind>
getCommonDmaPredicateKind(ArrayRef<sym::PredHandle> predicates) {
  if (predicates.empty())
    return std::nullopt;
  sym::PredKind kind = sym::PredView(predicates.front()).getKind();
  if (llvm::any_of(predicates, [&](sym::PredHandle predicate) {
        return sym::PredView(predicate).getKind() != kind;
      }))
    return std::nullopt;
  return kind;
}

static FailureOr<sym::PredHandle> synthesizeDmaComparisonPredicate(
    sym::Analysis &analysis, ArrayRef<sym::PredHandle> predicates,
    ArrayRef<DmaCopyPoint> points, sym::ExprHandle item) {
  std::optional<sym::PredCmpOp> comparison =
      sym::PredView(predicates.front()).getCmpOp();
  if (!comparison)
    return failure();
  if (llvm::any_of(predicates, [&](sym::PredHandle predicate) {
        return sym::PredView(predicate).getCmpOp() != comparison;
      }))
    return failure();

  SmallVector<sym::ExprHandle> lhsExpressions;
  SmallVector<sym::ExprHandle> rhsExpressions;
  for (auto [predicate, point] : llvm::zip(predicates, points)) {
    sym::PredView view(predicate);
    FailureOr<sym::ExprHandle> lhs =
        specializeDmaItem(analysis, view.getCmpLhs(), item, point.item);
    FailureOr<sym::ExprHandle> rhs =
        specializeDmaItem(analysis, view.getCmpRhs(), item, point.item);
    if (failed(lhs) || failed(rhs))
      return failure();
    lhsExpressions.push_back(*lhs);
    rhsExpressions.push_back(*rhs);
  }
  FailureOr<sym::ExprHandle> lhs =
      synthesizeDmaExpressionSequence(analysis, lhsExpressions, item);
  FailureOr<sym::ExprHandle> rhs =
      synthesizeDmaExpressionSequence(analysis, rhsExpressions, item);
  if (failed(lhs) || failed(rhs))
    return failure();
  return analysis.compare(*lhs, *comparison, *rhs);
}

static FailureOr<sym::PredHandle>
synthesizeDmaNotPredicate(sym::Analysis &analysis,
                          ArrayRef<sym::PredHandle> predicates,
                          ArrayRef<DmaCopyPoint> points, sym::ExprHandle item) {
  SmallVector<sym::PredHandle> arguments;
  arguments.reserve(predicates.size());
  for (sym::PredHandle predicate : predicates)
    arguments.push_back(sym::PredView(predicate).getUnaryArg());
  FailureOr<sym::PredHandle> argument =
      synthesizeDmaPredicateSequence(analysis, arguments, points, item);
  if (failed(argument))
    return failure();
  return analysis.composeNot(*argument);
}

static std::optional<uint32_t>
getDmaLogicArgumentCount(ArrayRef<sym::PredHandle> predicates) {
  uint32_t count = sym::PredView(predicates.front()).getLogicArgCount();
  if (count == 0)
    return std::nullopt;
  if (llvm::any_of(predicates, [&](sym::PredHandle predicate) {
        return sym::PredView(predicate).getLogicArgCount() != count;
      }))
    return std::nullopt;
  return count;
}

static FailureOr<sym::PredHandle>
composeDmaLogicPredicate(sym::Analysis &analysis,
                         ArrayRef<sym::PredHandle> arguments,
                         sym::PredKind kind) {
  FailureOr<sym::PredHandle> result = arguments.front();
  for (sym::PredHandle argument : ArrayRef(arguments).drop_front()) {
    result = kind == sym::PredKind::And ? analysis.composeAnd(*result, argument)
                                        : analysis.composeOr(*result, argument);
    if (failed(result))
      return failure();
  }
  return result;
}

static FailureOr<sym::PredHandle> synthesizeDmaLogicPredicate(
    sym::Analysis &analysis, ArrayRef<sym::PredHandle> predicates,
    ArrayRef<DmaCopyPoint> points, sym::ExprHandle item, sym::PredKind kind) {
  std::optional<uint32_t> argumentCount = getDmaLogicArgumentCount(predicates);
  if (!argumentCount)
    return failure();
  SmallVector<sym::PredHandle> arguments;
  arguments.reserve(*argumentCount);
  for (uint32_t index = 0; index < *argumentCount; ++index) {
    SmallVector<sym::PredHandle> pointArguments;
    for (sym::PredHandle predicate : predicates)
      pointArguments.push_back(sym::PredView(predicate).getLogicArg(index));
    FailureOr<sym::PredHandle> argument =
        synthesizeDmaPredicateSequence(analysis, pointArguments, points, item);
    if (failed(argument))
      return failure();
    arguments.push_back(*argument);
  }
  return composeDmaLogicPredicate(analysis, arguments, kind);
}

static FailureOr<sym::PredHandle> synthesizeDmaPredicateSequence(
    sym::Analysis &analysis, ArrayRef<sym::PredHandle> predicates,
    ArrayRef<DmaCopyPoint> points, sym::ExprHandle item) {
  if (predicates.size() != points.size())
    return failure();
  std::optional<sym::PredKind> kind = getCommonDmaPredicateKind(predicates);
  if (!kind)
    return failure();
  FailureOr<sym::PredHandle> result = failure();
  switch (*kind) {
  case sym::PredKind::True:
    result = analysis.composeTrue();
    break;
  case sym::PredKind::False:
    result = analysis.composeFalse();
    break;
  case sym::PredKind::Cmp:
    result =
        synthesizeDmaComparisonPredicate(analysis, predicates, points, item);
    break;
  case sym::PredKind::Not:
    result = synthesizeDmaNotPredicate(analysis, predicates, points, item);
    break;
  case sym::PredKind::And:
  case sym::PredKind::Or:
    result =
        synthesizeDmaLogicPredicate(analysis, predicates, points, item, *kind);
    break;
  default:
    return failure();
  }
  if (failed(result))
    return failure();
  return analysis.simplify(*result);
}

static FailureOr<std::optional<sym::PredHandle>>
synthesizeDmaActivationPredicate(sym::Analysis &analysis,
                                 ArrayRef<SlotMapping> mappings,
                                 ArrayRef<DmaCopyPoint> points,
                                 sym::ExprHandle item) {
  if (points.empty())
    return failure();
  bool hasPacketCondition =
      llvm::any_of(points, [&](const DmaCopyPoint &point) {
        return static_cast<bool>(mappings[point.sourceSlot].packetCondition);
      });
  if (!hasPacketCondition)
    return std::optional<sym::PredHandle>{};

  SmallVector<sym::PredHandle> predicates;
  predicates.reserve(points.size());
  for (const DmaCopyPoint &point : points) {
    const SlotMapping &mapping = mappings[point.sourceSlot];
    if (!mapping.packetCondition || !mapping.activationPredicate)
      return failure();
    predicates.push_back(*mapping.activationPredicate);
  }
  FailureOr<sym::PredHandle> predicate =
      synthesizeDmaPredicateSequence(analysis, predicates, points, item);
  if (failed(predicate))
    return failure();
  return std::optional<sym::PredHandle>{*predicate};
}

static bool verifySynthesizedDmaActivationPredicate(
    sym::Analysis &analysis, sym::PredHandle synthesized,
    ArrayRef<SlotMapping> mappings,
    ArrayRef<SmallVector<DmaCopyPoint>> pointsByItem, sym::ExprHandle item) {
  for (auto [newItem, points] : llvm::enumerate(pointsByItem)) {
    FailureOr<sym::ExprHandle> newItemValue =
        analysis.composeInteger(static_cast<int64_t>(newItem));
    if (failed(newItemValue))
      return false;
    FailureOr<sym::PredHandle> actual = analysis.substitute(
        synthesized, ArrayRef<sym::ExprSubstitution>{
                         sym::ExprSubstitution{item, *newItemValue}});
    if (failed(actual))
      return false;
    for (const DmaCopyPoint &point : points) {
      const SlotMapping &mapping = mappings[point.sourceSlot];
      if (!mapping.activationPredicate)
        return false;
      FailureOr<sym::ExprHandle> pointValue =
          analysis.composeInteger(point.item);
      if (failed(pointValue))
        return false;
      FailureOr<sym::PredHandle> expected =
          analysis.substitute(*mapping.activationPredicate,
                              ArrayRef<sym::ExprSubstitution>{
                                  sym::ExprSubstitution{item, *pointValue}});
      if (failed(expected) ||
          analysis.equivalent(*actual, *expected) != sym::CheckResult::True)
        return false;
    }
  }
  return true;
}

static FailureOr<sym::ExprHandle> getInvariantDmaMappingExpression(
    sym::Analysis &analysis, ArrayRef<SlotMapping> mappings,
    ArrayRef<DmaCopyPoint> points, bool source, sym::ExprHandle item,
    DmaMappingExpression member) {
  if (points.empty())
    return failure();
  const SlotMapping &first = mappings[getDmaPointSlot(points.front(), source)];
  FailureOr<sym::ExprHandle> reference =
      specializeDmaItem(analysis, first.*member, item, points.front().item);
  if (failed(reference))
    return failure();
  for (const DmaCopyPoint &point : points) {
    const SlotMapping &mapping = mappings[getDmaPointSlot(point, source)];
    FailureOr<sym::ExprHandle> expression =
        specializeDmaItem(analysis, mapping.*member, item, point.item);
    if (failed(expression) ||
        !proveEquivalent(analysis, *expression, *reference))
      return failure();
  }
  return *reference;
}

static bool mergeDmaMappingMetadata(SlotMapping &target,
                                    const SlotMapping &source) {
  if (target.baseIndex != source.baseIndex)
    return false;
  for (const NamedBinding &binding : source.bindings) {
    auto found =
        llvm::find_if(target.bindings, [&](const NamedBinding &candidate) {
          return candidate.name == binding.name;
        });
    if (found == target.bindings.end()) {
      target.bindings.push_back(binding);
      continue;
    }
    if (found->value != binding.value)
      return false;
  }
  for (sym::PredHandle assumption : source.assumptions)
    if (!llvm::is_contained(target.assumptions, assumption))
      target.assumptions.push_back(assumption);
  for (sym::PredHandle assumption : source.activationProofAssumptions)
    if (!llvm::is_contained(target.activationProofAssumptions, assumption))
      target.activationProofAssumptions.push_back(assumption);
  return true;
}

struct DmaClosedRange {
  int64_t lower = 0;
  int64_t upper = 0;
};

static std::optional<DmaClosedRange>
getClosedDmaRange(const std::optional<sym::InferredRange> &range) {
  if (!range || !range->lower || !range->upper)
    return std::nullopt;
  std::optional<int64_t> lower = sym::ceilEndpoint(*range->lower);
  std::optional<int64_t> upper = sym::floorEndpoint(*range->upper);
  if (!lower || !upper || *lower > *upper)
    return std::nullopt;
  return DmaClosedRange{*lower, *upper};
}

static LogicalResult
appendInferredExpressionRange(sym::Analysis &analysis,
                              sym::ExprHandle expression,
                              SmallVectorImpl<sym::PredHandle> &assumptions) {
  std::optional<DmaClosedRange> range =
      getClosedDmaRange(analysis.range(expression));
  if (!range)
    return success();
  FailureOr<sym::ExprHandle> lowerValue = analysis.composeInteger(range->lower);
  FailureOr<sym::ExprHandle> upperValue = analysis.composeInteger(range->upper);
  if (failed(lowerValue) || failed(upperValue))
    return failure();
  FailureOr<sym::PredHandle> lowerBound =
      analysis.compare(expression, sym::PredCmpOp::Ge, *lowerValue);
  FailureOr<sym::PredHandle> upperBound =
      analysis.compare(expression, sym::PredCmpOp::Le, *upperValue);
  if (failed(lowerBound) || failed(upperBound))
    return failure();
  if (!llvm::is_contained(assumptions, *lowerBound))
    assumptions.push_back(*lowerBound);
  if (!llvm::is_contained(assumptions, *upperBound))
    assumptions.push_back(*upperBound);
  return success();
}

static LogicalResult
appendDmaExpressionRange(sym::Store &store, sym::ExprHandle expression,
                         int64_t lower, int64_t upper,
                         SmallVectorImpl<sym::PredHandle> &assumptions) {
  FailureOr<sym::ExprHandle> lowerValue = sym::composeExprInt(store, lower);
  FailureOr<sym::ExprHandle> upperValue = sym::composeExprInt(store, upper);
  if (failed(lowerValue) || failed(upperValue))
    return failure();
  FailureOr<sym::PredHandle> lowerBound =
      sym::composePredCmp(store, expression, sym::PredCmpOp::Ge, *lowerValue);
  FailureOr<sym::PredHandle> upperBound =
      sym::composePredCmp(store, expression, sym::PredCmpOp::Le, *upperValue);
  if (failed(lowerBound) || failed(upperBound))
    return failure();
  if (!llvm::is_contained(assumptions, *lowerBound))
    assumptions.push_back(*lowerBound);
  if (!llvm::is_contained(assumptions, *upperBound))
    assumptions.push_back(*upperBound);
  return success();
}

static FailureOr<DmaClosedRange> getDmaPointRange(sym::Store &store,
                                                  const SlotMapping &mapping,
                                                  const DmaCopyPoint &point,
                                                  sym::ExprHandle item,
                                                  DmaMappingExpression member) {
  FailureOr<sym::ExprHandle> value = sym::composeExprInt(store, point.item);
  if (failed(value))
    return failure();
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{item, *value}};
  FailureOr<sym::ExprHandle> expression =
      sym::substituteExpr(store, mapping.*member, substitution);
  FailureOr<SmallVector<sym::PredHandle>> assumptions =
      substituteIndexExprPredicates(store, mapping.assumptions, substitution);
  if (failed(expression) || failed(assumptions))
    return failure();
  std::optional<DmaClosedRange> range =
      getClosedDmaRange(sym::inferRange(store, *expression, *assumptions));
  if (!range)
    return failure();
  return *range;
}

static LogicalResult appendDmaPointUnionRange(sym::Store &store,
                                              SlotMapping &synthesized,
                                              ArrayRef<SlotMapping> mappings,
                                              ArrayRef<DmaCopyPoint> points,
                                              bool source, sym::ExprHandle item,
                                              DmaMappingExpression member) {
  std::optional<int64_t> unionLower;
  std::optional<int64_t> unionUpper;
  for (const DmaCopyPoint &point : points) {
    const SlotMapping &mapping = mappings[getDmaPointSlot(point, source)];
    FailureOr<DmaClosedRange> range =
        getDmaPointRange(store, mapping, point, item, member);
    if (failed(range))
      return failure();
    unionLower = unionLower ? std::min(*unionLower, range->lower)
                            : std::optional(range->lower);
    unionUpper = unionUpper ? std::max(*unionUpper, range->upper)
                            : std::optional(range->upper);
  }
  if (!unionLower || !unionUpper)
    return failure();
  return appendDmaExpressionRange(store, synthesized.*member, *unionLower,
                                  *unionUpper, synthesized.assumptions);
}

struct DmaMappingExpressions {
  sym::ExprHandle base;
  sym::ExprHandle targetBlock;
  sym::ExprHandle bitOffset;
  sym::ExprHandle materializationBitOffset;
  sym::ExprHandle byteOffset;
  sym::ExprHandle materializationByteOffset;
};

static FailureOr<DmaMappingExpressions> synthesizeDmaMappingExpressions(
    sym::Analysis &analysis, ArrayRef<SlotMapping> mappings,
    ArrayRef<DmaCopyPoint> points, bool source, sym::ExprHandle item) {
  FailureOr<sym::ExprHandle> base = getInvariantDmaMappingExpression(
      analysis, mappings, points, source, item, &SlotMapping::base);
  FailureOr<sym::ExprHandle> targetBlock = getInvariantDmaMappingExpression(
      analysis, mappings, points, source, item, &SlotMapping::targetBlock);
  FailureOr<sym::ExprHandle> bitOffset = synthesizeDmaMappingExpression(
      analysis, mappings, points, source, item, &SlotMapping::bitOffset);
  FailureOr<sym::ExprHandle> materializationBitOffset =
      synthesizeDmaMappingExpression(analysis, mappings, points, source, item,
                                     &SlotMapping::materializationBitOffset);
  FailureOr<sym::ExprHandle> byteOffset = synthesizeDmaMappingExpression(
      analysis, mappings, points, source, item, &SlotMapping::byteOffset);
  FailureOr<sym::ExprHandle> materializationByteOffset =
      synthesizeDmaMappingExpression(analysis, mappings, points, source, item,
                                     &SlotMapping::materializationByteOffset);
  if (failed(base) || failed(targetBlock) || failed(bitOffset) ||
      failed(materializationBitOffset) || failed(byteOffset) ||
      failed(materializationByteOffset))
    return failure();
  return DmaMappingExpressions{*base,       *targetBlock,
                               *bitOffset,  *materializationBitOffset,
                               *byteOffset, *materializationByteOffset};
}

static void setDmaMappingExpressions(SlotMapping &mapping,
                                     const DmaMappingExpressions &expressions) {
  mapping.base = expressions.base;
  mapping.targetBlock = expressions.targetBlock;
  mapping.bitOffset = expressions.bitOffset;
  mapping.materializationBitOffset = expressions.materializationBitOffset;
  mapping.byteOffset = expressions.byteOffset;
  mapping.materializationByteOffset = expressions.materializationByteOffset;
  mapping.logicalSlots.clear();
  mapping.activationPredicate.reset();
  mapping.activationRelationPredicate = {};
  mapping.proofOffset.reset();
  mapping.packetCondition = {};
  mapping.materializationCandidates.clear();
  mapping.proofIndex = std::numeric_limits<size_t>::max();
}

static LogicalResult
bindDmaMappingExecution(SlotMapping &mapping,
                        const DmaExecutionBinding &execution) {
  auto found =
      llvm::find_if(mapping.bindings, [&](const NamedBinding &binding) {
        return binding.name == execution.name;
      });
  if (found == mapping.bindings.end()) {
    mapping.bindings.push_back({execution.name, execution.value});
    return success();
  }
  return success(found->value == execution.value);
}

static FailureOr<SlotMapping> synthesizeDmaMappingPoint(
    sym::Analysis &analysis, ArrayRef<SlotMapping> mappings,
    ArrayRef<DmaCopyPoint> points, bool source,
    const DmaExecutionBinding &execution, sym::ExprHandle item) {
  if (points.empty())
    return failure();
  SlotMapping result = mappings[getDmaPointSlot(points.front(), source)];
  for (const DmaCopyPoint &point : points)
    if (!mergeDmaMappingMetadata(result,
                                 mappings[getDmaPointSlot(point, source)]))
      return failure();

  FailureOr<DmaMappingExpressions> expressions =
      synthesizeDmaMappingExpressions(analysis, mappings, points, source, item);
  if (failed(expressions))
    return failure();
  setDmaMappingExpressions(result, *expressions);
  if (failed(appendInferredExpressionRange(
          analysis, result.materializationByteOffset, result.assumptions)))
    return failure();
  if (failed(bindDmaMappingExecution(result, execution)))
    return failure();
  return result;
}

static FailureOr<sym::ExprHandle>
getDmaPointExpression(sym::Analysis &analysis, ArrayRef<SlotMapping> mappings,
                      const DmaCopyPoint &point, bool source,
                      sym::ExprHandle item, DmaMappingExpression member) {
  const SlotMapping &mapping = mappings[getDmaPointSlot(point, source)];
  return specializeDmaItem(analysis, mapping.*member, item, point.item);
}

static bool verifyDmaPointPacket(sym::Analysis &analysis,
                                 ArrayRef<SlotMapping> mappings,
                                 ArrayRef<DmaCopyPoint> points, bool source,
                                 sym::ExprHandle item, int64_t elementBytes,
                                 DmaMappingExpression member) {
  if (points.empty())
    return false;
  FailureOr<sym::ExprHandle> first = getDmaPointExpression(
      analysis, mappings, points.front(), source, item, member);
  if (failed(first))
    return false;
  for (auto [position, point] : llvm::enumerate(points)) {
    FailureOr<sym::ExprHandle> actual =
        getDmaPointExpression(analysis, mappings, point, source, item, member);
    FailureOr<sym::ExprHandle> expected = addDmaConstant(
        analysis, *first, static_cast<int64_t>(position) * elementBytes);
    if (failed(actual) || failed(expected) ||
        !proveEquivalent(analysis, *actual, *expected))
      return false;
  }
  return true;
}

static bool verifySynthesizedDmaMappingExpression(
    sym::Analysis &analysis, const SlotMapping &synthesized,
    ArrayRef<SlotMapping> mappings, ArrayRef<DmaCopyPoint> points, bool source,
    sym::ExprHandle item, DmaMappingExpression member) {
  for (auto [newItem, point] : llvm::enumerate(points)) {
    FailureOr<sym::ExprHandle> actual =
        specializeDmaItem(analysis, synthesized.*member, item, newItem);
    FailureOr<sym::ExprHandle> expected =
        getDmaPointExpression(analysis, mappings, point, source, item, member);
    if (failed(actual) || failed(expected) ||
        !proveEquivalent(analysis, *actual, *expected))
      return false;
  }
  return true;
}

static bool verifySynthesizedDmaMapping(sym::Analysis &analysis,
                                        const SlotMapping &synthesized,
                                        ArrayRef<SlotMapping> mappings,
                                        ArrayRef<DmaCopyPoint> points,
                                        bool source, sym::ExprHandle item) {
  if (points.empty())
    return false;
  const SlotMapping &first = mappings[getDmaPointSlot(points.front(), source)];
  if (synthesized.baseIndex != first.baseIndex)
    return false;
  constexpr DmaMappingExpression members[] = {
      &SlotMapping::base,       &SlotMapping::targetBlock,
      &SlotMapping::bitOffset,  &SlotMapping::materializationBitOffset,
      &SlotMapping::byteOffset, &SlotMapping::materializationByteOffset,
  };
  return llvm::all_of(members, [&](DmaMappingExpression member) {
    return verifySynthesizedDmaMappingExpression(
        analysis, synthesized, mappings, points, source, item, member);
  });
}

static std::optional<int64_t> getDmaTransactionStep(int64_t bytes,
                                                    int64_t elementBytes,
                                                    int64_t covered,
                                                    int64_t elementCount) {
  if (bytes <= 0 || bytes % elementBytes)
    return std::nullopt;
  int64_t elements = bytes / elementBytes;
  if (covered + elements > elementCount)
    return std::nullopt;
  return elements;
}

static void fillDmaTransactionSteps(MutableArrayRef<int64_t> steps,
                                    int64_t elementBytes,
                                    ArrayRef<int64_t> supportedByteWidths) {
  int64_t elementCount = steps.size() - 1;
  steps[elementCount] = 0;
  for (int64_t covered = elementCount - 1; covered >= 0; --covered) {
    for (int64_t bytes : supportedByteWidths) {
      std::optional<int64_t> elements =
          getDmaTransactionStep(bytes, elementBytes, covered, elementCount);
      if (elements && steps[covered + *elements] >= 0) {
        steps[covered] = *elements;
        break;
      }
    }
  }
}

static SmallVector<int64_t>
collectDmaTransactionElements(ArrayRef<int64_t> steps) {
  SmallVector<int64_t> result;
  int64_t elementCount = steps.size() - 1;
  for (int64_t covered = 0; covered < elementCount;) {
    int64_t elements = steps[covered];
    result.push_back(elements);
    covered += elements;
  }
  return result;
}

static FailureOr<SmallVector<int64_t>>
planDmaTransactionElements(int64_t elementCount, int64_t elementBytes,
                           ArrayRef<int64_t> supportedByteWidths) {
  if (elementCount <= 0 || elementBytes <= 0)
    return failure();
  SmallVector<int64_t> steps(elementCount + 1, -1);
  fillDmaTransactionSteps(steps, elementBytes, supportedByteWidths);
  if (steps[0] < 0)
    return failure();
  return collectDmaTransactionElements(steps);
}

static bool indexDmaMappings(ArrayRef<SlotMapping> mappings,
                             MutableArrayRef<int64_t> indices) {
  for (auto [index, mapping] : llvm::enumerate(mappings)) {
    if (mapping.logicalSlots.size() != 1)
      return false;
    unsigned logical = mapping.logicalSlots.front();
    if (logical >= indices.size() || indices[logical] >= 0)
      return false;
    indices[logical] = static_cast<int64_t>(index);
  }
  return llvm::none_of(indices, [](int64_t index) { return index < 0; });
}

struct DmaRepackShape {
  int64_t itemCount = 0;
  int64_t waveWidth = 0;
  int64_t elementBytes = 0;
  int64_t waveCount = 0;
};

static bool hasDmaRepackExecutionShape(int64_t itemCount, int64_t waveWidth,
                                       int64_t elementBits) {
  return itemCount > 0 && waveWidth > 0 && itemCount % waveWidth == 0 &&
         llvm::isPowerOf2_64(itemCount) && elementBits > 0 &&
         elementBits % 8 == 0;
}

static bool
hasDmaRepackMappingShape(const AccessShape &shape,
                         ArrayRef<SlotMapping> sourceMappings,
                         ArrayRef<SlotMapping> destinationMappings) {
  return sourceMappings.size() == static_cast<size_t>(shape.slotCount) &&
         destinationMappings.size() == static_cast<size_t>(shape.slotCount);
}

static std::optional<DmaRepackShape>
getDmaRepackShape(const MemoryAccess &access, const AccessShape &shape,
                  ArrayRef<SlotMapping> sourceMappings,
                  ArrayRef<SlotMapping> destinationMappings) {
  DenseI32ArrayAttr workgroupShape = getWorkgroupShape(access.op);
  int64_t itemCount =
      workgroupShape && workgroupShape.size() == 3 ? workgroupShape[0] : 0;
  int64_t waveWidth = access.packetType.getWidth();
  if (!hasDmaRepackExecutionShape(itemCount, waveWidth, shape.elementBits) ||
      !hasDmaRepackMappingShape(shape, sourceMappings, destinationMappings))
    return std::nullopt;
  return DmaRepackShape{itemCount, waveWidth, shape.elementBits / 8,
                        itemCount / waveWidth};
}

static void
appendUniqueDmaAssumptions(ArrayRef<SlotMapping> mappings,
                           bool includeActivation,
                           SmallVectorImpl<sym::PredHandle> &assumptions) {
  for (const SlotMapping &mapping : mappings) {
    SmallVector<sym::PredHandle> selected =
        includeActivation ? mapping.assumptions
                          : getActivationProofAssumptions(mapping);
    for (sym::PredHandle assumption : selected)
      if (!llvm::is_contained(assumptions, assumption))
        assumptions.push_back(assumption);
  }
}

struct DmaRepackAnalyses {
  std::unique_ptr<sym::Analysis> mapping;
  std::unique_ptr<sym::Analysis> predicate;
  sym::ExprHandle sourceItem;
  sym::ExprHandle destinationItem;
  sym::ExprHandle predicateItem;
};

static FailureOr<DmaRepackAnalyses>
createDmaRepackAnalyses(sym::Store &store, ArrayRef<SlotMapping> sourceMappings,
                        ArrayRef<SlotMapping> destinationMappings,
                        const DmaExecutionBinding &sourceExecution,
                        const DmaExecutionBinding &destinationExecution) {
  SmallVector<sym::PredHandle> assumptions;
  appendUniqueDmaAssumptions(sourceMappings, true, assumptions);
  appendUniqueDmaAssumptions(destinationMappings, true, assumptions);
  FailureOr<std::unique_ptr<sym::Analysis>> mapping =
      sym::Analysis::create(store, assumptions);
  if (failed(mapping))
    return failure();

  SmallVector<sym::PredHandle> predicateAssumptions;
  appendUniqueDmaAssumptions(sourceMappings, false, predicateAssumptions);
  appendUniqueDmaAssumptions(destinationMappings, false, predicateAssumptions);
  FailureOr<std::unique_ptr<sym::Analysis>> predicate =
      sym::Analysis::create(store, predicateAssumptions);
  if (failed(predicate))
    return failure();

  FailureOr<sym::ExprHandle> sourceItem =
      (*mapping)->composeSymbol(sourceExecution.name);
  FailureOr<sym::ExprHandle> destinationItem =
      (*mapping)->composeSymbol(destinationExecution.name);
  FailureOr<sym::ExprHandle> predicateItem =
      (*predicate)->composeSymbol(sourceExecution.name);
  if (failed(sourceItem) || failed(destinationItem) || failed(predicateItem))
    return failure();
  return DmaRepackAnalyses{std::move(*mapping), std::move(*predicate),
                           *sourceItem, *destinationItem, *predicateItem};
}

static FailureOr<SmallVector<RankedDmaCopyPoint>>
rankDmaWavePoints(int64_t wave, const DmaRepackShape &shape,
                  ArrayRef<SlotMapping> destinationMappings,
                  ArrayRef<int64_t> sourceByLogical, sym::Analysis &analysis,
                  sym::ExprHandle destinationItem,
                  sym::ExprHandle referenceDestination) {
  SmallVector<RankedDmaCopyPoint> ranked;
  ranked.reserve(shape.waveWidth * destinationMappings.size());
  int64_t waveBase = wave * shape.waveWidth;
  for (int64_t oldItem = waveBase; oldItem < waveBase + shape.waveWidth;
       ++oldItem) {
    for (auto [destinationSlot, mapping] :
         llvm::enumerate(destinationMappings)) {
      unsigned logical = mapping.logicalSlots.front();
      DmaCopyPoint point{oldItem,
                         static_cast<unsigned>(sourceByLogical[logical]),
                         static_cast<unsigned>(destinationSlot)};
      FailureOr<sym::ExprHandle> destination =
          getDmaPointExpression(analysis, destinationMappings, point, false,
                                destinationItem, &SlotMapping::byteOffset);
      if (failed(destination))
        return failure();
      FailureOr<int64_t> offset = getDmaConstantDifference(
          analysis, *destination, referenceDestination);
      if (failed(offset))
        return failure();
      ranked.push_back({point, *offset});
    }
  }
  llvm::sort(ranked,
             [](const RankedDmaCopyPoint &lhs, const RankedDmaCopyPoint &rhs) {
               return lhs.destinationOffset < rhs.destinationOffset;
             });
  auto duplicate = llvm::adjacent_find(
      ranked, [](const RankedDmaCopyPoint &lhs, const RankedDmaCopyPoint &rhs) {
        return lhs.destinationOffset == rhs.destinationOffset;
      });
  if (duplicate != ranked.end())
    return failure();
  return ranked;
}

static FailureOr<SmallVector<SmallVector<RankedDmaCopyPoint>>>
rankDmaPoints(const DmaRepackShape &shape,
              ArrayRef<SlotMapping> destinationMappings,
              ArrayRef<int64_t> sourceByLogical, sym::Analysis &analysis,
              sym::ExprHandle destinationItem) {
  FailureOr<sym::ExprHandle> referenceDestination = specializeDmaItem(
      analysis, destinationMappings.front().byteOffset, destinationItem, 0);
  if (failed(referenceDestination))
    return failure();
  SmallVector<SmallVector<RankedDmaCopyPoint>> rankedByWave(shape.waveCount);
  for (int64_t wave = 0; wave < shape.waveCount; ++wave) {
    FailureOr<SmallVector<RankedDmaCopyPoint>> ranked =
        rankDmaWavePoints(wave, shape, destinationMappings, sourceByLogical,
                          analysis, destinationItem, *referenceDestination);
    if (failed(ranked))
      return failure();
    rankedByWave[wave] = std::move(*ranked);
  }
  return rankedByWave;
}

using DmaTransactionPointGrid =
    SmallVector<SmallVector<SmallVector<DmaCopyPoint>>>;

static DmaTransactionPointGrid
createDmaTransactionPointGrid(ArrayRef<int64_t> transactionElements,
                              int64_t itemCount) {
  DmaTransactionPointGrid grid(transactionElements.size());
  for (auto [transactionIndex, elements] :
       llvm::enumerate(transactionElements)) {
    grid[transactionIndex].resize(itemCount);
    for (SmallVector<DmaCopyPoint> &points : grid[transactionIndex])
      points.resize(elements);
  }
  return grid;
}

static bool isContiguousDmaRankedSegment(ArrayRef<RankedDmaCopyPoint> ranked,
                                         int64_t start, int64_t count,
                                         int64_t elementBytes) {
  int64_t base = ranked[start].destinationOffset;
  return llvm::all_of(llvm::seq<int64_t>(0, count), [&](int64_t index) {
    return ranked[start + index].destinationOffset ==
           base + index * elementBytes;
  });
}

static bool assignDmaWaveTransactions(int64_t wave, const DmaRepackShape &shape,
                                      ArrayRef<RankedDmaCopyPoint> ranked,
                                      ArrayRef<int64_t> transactionElements,
                                      DmaTransactionPointGrid &grid) {
  int64_t segmentStart = 0;
  for (auto [transactionIndex, elements] :
       llvm::enumerate(transactionElements)) {
    int64_t segmentPoints = shape.waveWidth * elements;
    if (!isContiguousDmaRankedSegment(ranked, segmentStart, segmentPoints,
                                      shape.elementBytes))
      return false;
    for (int64_t lane = 0; lane < shape.waveWidth; ++lane) {
      int64_t newItem = wave * shape.waveWidth + lane;
      for (int64_t position = 0; position < elements; ++position)
        grid[transactionIndex][newItem][position] =
            ranked[segmentStart + lane * elements + position].point;
    }
    segmentStart += segmentPoints;
  }
  return segmentStart == static_cast<int64_t>(ranked.size());
}

static FailureOr<DmaTransactionPointGrid> buildDmaTransactionPointGrid(
    const DmaRepackShape &shape,
    ArrayRef<SmallVector<RankedDmaCopyPoint>> rankedByWave,
    ArrayRef<int64_t> transactionElements) {
  DmaTransactionPointGrid grid =
      createDmaTransactionPointGrid(transactionElements, shape.itemCount);
  for (int64_t wave = 0; wave < shape.waveCount; ++wave)
    if (!assignDmaWaveTransactions(wave, shape, rankedByWave[wave],
                                   transactionElements, grid))
      return failure();
  return grid;
}

static SmallVector<DmaCopyPoint>
getDmaTransactionStarts(ArrayRef<SmallVector<DmaCopyPoint>> pointsByItem) {
  SmallVector<DmaCopyPoint> starts;
  starts.reserve(pointsByItem.size());
  for (ArrayRef<DmaCopyPoint> points : pointsByItem)
    starts.push_back(points.front());
  return starts;
}

static bool verifyRepackedDmaMappings(
    sym::Analysis &analysis, const SlotMapping &sourcePoint,
    const SlotMapping &destinationPoint, ArrayRef<SlotMapping> sourceMappings,
    ArrayRef<SlotMapping> destinationMappings, ArrayRef<DmaCopyPoint> starts,
    sym::ExprHandle sourceItem, sym::ExprHandle destinationItem) {
  return verifySynthesizedDmaMapping(analysis, sourcePoint, sourceMappings,
                                     starts, true, sourceItem) &&
         verifySynthesizedDmaMapping(analysis, destinationPoint,
                                     destinationMappings, starts, false,
                                     destinationItem);
}

static bool verifyRepackedDmaPackets(
    sym::Analysis &analysis, ArrayRef<SlotMapping> sourceMappings,
    ArrayRef<SlotMapping> destinationMappings,
    ArrayRef<SmallVector<DmaCopyPoint>> pointsByItem,
    sym::ExprHandle sourceItem, sym::ExprHandle destinationItem,
    int64_t elementBytes) {
  for (ArrayRef<DmaCopyPoint> points : pointsByItem)
    if (!verifyDmaPointPacket(analysis, sourceMappings, points, true,
                              sourceItem, elementBytes,
                              &SlotMapping::byteOffset) ||
        !verifyDmaPointPacket(analysis, sourceMappings, points, true,
                              sourceItem, elementBytes,
                              &SlotMapping::materializationByteOffset) ||
        !verifyDmaPointPacket(analysis, destinationMappings, points, false,
                              destinationItem, elementBytes,
                              &SlotMapping::byteOffset) ||
        !verifyDmaPointPacket(analysis, destinationMappings, points, false,
                              destinationItem, elementBytes,
                              &SlotMapping::materializationByteOffset))
      return false;
  return true;
}

static bool
mergeRepackedDmaMetadata(SlotMapping &sourcePoint,
                         SlotMapping &destinationPoint,
                         ArrayRef<SlotMapping> sourceMappings,
                         ArrayRef<SlotMapping> destinationMappings,
                         ArrayRef<SmallVector<DmaCopyPoint>> pointsByItem) {
  for (ArrayRef<DmaCopyPoint> points : pointsByItem)
    for (const DmaCopyPoint &point : points)
      if (!mergeDmaMappingMetadata(sourcePoint,
                                   sourceMappings[point.sourceSlot]) ||
          !mergeDmaMappingMetadata(destinationPoint,
                                   destinationMappings[point.destinationSlot]))
        return false;
  return true;
}

static FailureOr<std::optional<sym::PredHandle>>
setRepackedDmaActivation(sym::Analysis &analysis, SlotMapping &sourcePoint,
                         ArrayRef<SlotMapping> sourceMappings,
                         ArrayRef<SmallVector<DmaCopyPoint>> pointsByItem,
                         ArrayRef<DmaCopyPoint> starts,
                         sym::ExprHandle predicateItem) {
  FailureOr<std::optional<sym::PredHandle>> predicate =
      synthesizeDmaActivationPredicate(analysis, sourceMappings, starts,
                                       predicateItem);
  if (failed(predicate))
    return failure();
  if (*predicate &&
      !verifySynthesizedDmaActivationPredicate(
          analysis, **predicate, sourceMappings, pointsByItem, predicateItem))
    return failure();
  for (const SlotMapping &mapping : sourceMappings)
    if (mapping.activationPredicate)
      llvm::erase(sourcePoint.assumptions, *mapping.activationPredicate);
  sourcePoint.activationPredicate = *predicate;
  sourcePoint.activationRelationPredicate = {};
  if (*predicate && !llvm::is_contained(sourcePoint.assumptions, **predicate))
    sourcePoint.assumptions.push_back(**predicate);
  return predicate;
}

static FailureOr<DmaCopyTransaction> buildRepackedDmaTransaction(
    sym::Analysis &mappingAnalysis, sym::Analysis &predicateAnalysis,
    ArrayRef<SlotMapping> sourceMappings,
    ArrayRef<SlotMapping> destinationMappings,
    ArrayRef<SmallVector<DmaCopyPoint>> pointsByItem,
    const DmaExecutionBinding &sourceExecution,
    const DmaExecutionBinding &destinationExecution, sym::ExprHandle sourceItem,
    sym::ExprHandle destinationItem, sym::ExprHandle predicateItem,
    int64_t elementBytes, int64_t transactionElements) {
  SmallVector<DmaCopyPoint> starts = getDmaTransactionStarts(pointsByItem);
  FailureOr<SlotMapping> sourcePoint =
      synthesizeDmaMappingPoint(mappingAnalysis, sourceMappings, starts, true,
                                sourceExecution, sourceItem);
  FailureOr<SlotMapping> destinationPoint =
      synthesizeDmaMappingPoint(mappingAnalysis, destinationMappings, starts,
                                false, destinationExecution, destinationItem);
  if (failed(sourcePoint) || failed(destinationPoint))
    return failure();
  if (!verifyRepackedDmaMappings(
          mappingAnalysis, *sourcePoint, *destinationPoint, sourceMappings,
          destinationMappings, starts, sourceItem, destinationItem))
    return failure();
  if (!verifyRepackedDmaPackets(mappingAnalysis, sourceMappings,
                                destinationMappings, pointsByItem, sourceItem,
                                destinationItem, elementBytes))
    return failure();
  if (!mergeRepackedDmaMetadata(*sourcePoint, *destinationPoint, sourceMappings,
                                destinationMappings, pointsByItem))
    return failure();
  FailureOr<std::optional<sym::PredHandle>> predicate =
      setRepackedDmaActivation(predicateAnalysis, *sourcePoint, sourceMappings,
                               pointsByItem, starts, predicateItem);
  if (failed(predicate))
    return failure();

  DmaCopyTransaction transaction;
  transaction.bytes = transactionElements * elementBytes;
  transaction.activationPredicate = *predicate;
  transaction.sourcePoint =
      std::make_unique<SlotMapping>(std::move(*sourcePoint));
  transaction.destinationPoint =
      std::make_unique<SlotMapping>(std::move(*destinationPoint));
  return transaction;
}

struct RepackedDmaTransactions {
  SmallVector<DmaCopyTransaction> transactions;
  SmallVector<SmallVector<DmaCopyPoint>> starts;
};

static FailureOr<RepackedDmaTransactions> buildRepackedDmaTransactions(
    DmaRepackAnalyses &analyses, ArrayRef<SlotMapping> sourceMappings,
    ArrayRef<SlotMapping> destinationMappings,
    const DmaTransactionPointGrid &pointGrid,
    ArrayRef<int64_t> transactionElements,
    const DmaExecutionBinding &sourceExecution,
    const DmaExecutionBinding &destinationExecution, int64_t elementBytes) {
  RepackedDmaTransactions result;
  result.transactions.reserve(transactionElements.size());
  result.starts.reserve(transactionElements.size());
  for (auto [transactionIndex, elements] :
       llvm::enumerate(transactionElements)) {
    ArrayRef<SmallVector<DmaCopyPoint>> pointsByItem =
        pointGrid[transactionIndex];
    FailureOr<DmaCopyTransaction> transaction = buildRepackedDmaTransaction(
        *analyses.mapping, *analyses.predicate, sourceMappings,
        destinationMappings, pointsByItem, sourceExecution,
        destinationExecution, analyses.sourceItem, analyses.destinationItem,
        analyses.predicateItem, elementBytes, elements);
    if (failed(transaction))
      return failure();
    result.transactions.push_back(std::move(*transaction));
    result.starts.push_back(getDmaTransactionStarts(pointsByItem));
  }
  return result;
}

static LogicalResult appendRepackedDmaRanges(
    sym::Store &store, MutableArrayRef<DmaCopyTransaction> transactions,
    ArrayRef<SmallVector<DmaCopyPoint>> starts,
    ArrayRef<SlotMapping> sourceMappings,
    ArrayRef<SlotMapping> destinationMappings, sym::ExprHandle sourceItem,
    sym::ExprHandle destinationItem) {
  for (auto [transaction, transactionStarts] : llvm::zip(transactions, starts))
    if (failed(appendDmaPointUnionRange(
            store, *transaction.sourcePoint, sourceMappings, transactionStarts,
            true, sourceItem, &SlotMapping::materializationByteOffset)) ||
        failed(appendDmaPointUnionRange(
            store, *transaction.destinationPoint, destinationMappings,
            transactionStarts, false, destinationItem,
            &SlotMapping::materializationByteOffset)))
      return failure();
  return success();
}

static FailureOr<SmallVector<DmaCopyTransaction>>
planRepackedDmaCopyTransactions(const MemoryAccess &access,
                                ArrayRef<SlotMapping> sourceMappings,
                                ArrayRef<SlotMapping> destinationMappings,
                                const AccessShape &shape,
                                const DmaExecutionBinding &sourceExecution,
                                const DmaExecutionBinding &destinationExecution,
                                ArrayRef<int64_t> supportedByteWidths,
                                sym::Store &store) {
  std::optional<DmaRepackShape> repackShape =
      getDmaRepackShape(access, shape, sourceMappings, destinationMappings);
  if (!repackShape)
    return failure();

  SmallVector<int64_t> sourceByLogical(shape.slotCount, -1);
  SmallVector<int64_t> destinationByLogical(shape.slotCount, -1);
  if (!indexDmaMappings(sourceMappings, sourceByLogical) ||
      !indexDmaMappings(destinationMappings, destinationByLogical))
    return failure();

  FailureOr<DmaRepackAnalyses> analyses =
      createDmaRepackAnalyses(store, sourceMappings, destinationMappings,
                              sourceExecution, destinationExecution);
  if (failed(analyses))
    return failure();

  FailureOr<SmallVector<SmallVector<RankedDmaCopyPoint>>> rankedByWave =
      rankDmaPoints(*repackShape, destinationMappings, sourceByLogical,
                    *analyses->mapping, analyses->destinationItem);
  if (failed(rankedByWave))
    return failure();

  FailureOr<SmallVector<int64_t>> transactionElements =
      planDmaTransactionElements(shape.slotCount, repackShape->elementBytes,
                                 supportedByteWidths);
  if (failed(transactionElements))
    return failure();
  FailureOr<DmaTransactionPointGrid> pointGrid = buildDmaTransactionPointGrid(
      *repackShape, *rankedByWave, *transactionElements);
  if (failed(pointGrid))
    return failure();
  FailureOr<RepackedDmaTransactions> transactions =
      buildRepackedDmaTransactions(
          *analyses, sourceMappings, destinationMappings, *pointGrid,
          *transactionElements, sourceExecution, destinationExecution,
          repackShape->elementBytes);
  if (failed(transactions))
    return failure();

  analyses->mapping.reset();
  if (failed(appendRepackedDmaRanges(store, transactions->transactions,
                                     transactions->starts, sourceMappings,
                                     destinationMappings, analyses->sourceItem,
                                     analyses->destinationItem)))
    return failure();
  return std::move(transactions->transactions);
}

static SmallVector<SmallVector<unsigned>>
buildCommonDmaEdges(ArrayRef<SlotMapping> sourceMappings,
                    ArrayRef<int64_t> destinationByLogical,
                    ArrayRef<SmallVector<unsigned>> sourceEdges,
                    ArrayRef<SmallVector<unsigned>> destinationEdges) {
  SmallVector<SmallVector<unsigned>> commonEdges(sourceMappings.size());
  for (auto [sourceIndex, successors] : llvm::enumerate(sourceEdges)) {
    unsigned logical = sourceMappings[sourceIndex].logicalSlots.front();
    unsigned destinationIndex =
        static_cast<unsigned>(destinationByLogical[logical]);
    for (unsigned sourceSuccessor : successors) {
      unsigned successorLogical =
          sourceMappings[sourceSuccessor].logicalSlots.front();
      unsigned destinationSuccessor =
          static_cast<unsigned>(destinationByLogical[successorLogical]);
      if (llvm::is_contained(destinationEdges[destinationIndex],
                             destinationSuccessor))
        commonEdges[sourceIndex].push_back(sourceSuccessor);
    }
  }
  return commonEdges;
}

static LogicalResult appendDmaChainTransactions(
    ArrayRef<unsigned> chain, ArrayRef<SlotMapping> sourceMappings,
    ArrayRef<int64_t> destinationByLogical, int64_t elementBytes,
    ArrayRef<int64_t> supportedByteWidths,
    SmallVectorImpl<DmaCopyTransaction> &transactions) {
  FailureOr<SmallVector<int64_t>> transactionElements =
      planDmaTransactionElements(chain.size(), elementBytes,
                                 supportedByteWidths);
  if (failed(transactionElements))
    return failure();
  size_t position = 0;
  for (int64_t elements : *transactionElements) {
    DmaCopyTransaction transaction;
    transaction.bytes = elements * elementBytes;
    llvm::append_range(transaction.sourceSlots,
                       chain.slice(position, static_cast<size_t>(elements)));
    for (unsigned sourceIndex : transaction.sourceSlots) {
      unsigned logical = sourceMappings[sourceIndex].logicalSlots.front();
      transaction.destinationSlots.push_back(
          static_cast<unsigned>(destinationByLogical[logical]));
    }
    transactions.push_back(std::move(transaction));
    position += static_cast<size_t>(elements);
  }
  return success();
}

static FailureOr<SmallVector<DmaCopyTransaction>>
planDmaCopyTransactions(sym::Store &store, ArrayRef<SlotMapping> sourceMappings,
                        ArrayRef<SlotMapping> destinationMappings,
                        const AccessShape &shape,
                        RemainderProofContext &sourceProofContext,
                        RemainderProofContext &destinationProofContext,
                        ArrayRef<int64_t> supportedByteWidths) {
  if (shape.elementBits <= 0 || shape.elementBits % 8 != 0 ||
      sourceMappings.size() != static_cast<size_t>(shape.slotCount) ||
      destinationMappings.size() != static_cast<size_t>(shape.slotCount))
    return failure();

  SmallVector<int64_t> sourceByLogical(shape.slotCount, -1);
  SmallVector<int64_t> destinationByLogical(shape.slotCount, -1);
  if (!indexDmaMappings(sourceMappings, sourceByLogical) ||
      !indexDmaMappings(destinationMappings, destinationByLogical))
    return failure();

  SmallVector<SmallVector<unsigned>> sourceEdges = buildSuccessorGraph(
      store, sourceMappings, shape.elementBits, sourceProofContext);
  SmallVector<SmallVector<unsigned>> destinationEdges = buildSuccessorGraph(
      store, destinationMappings, shape.elementBits, destinationProofContext);
  SmallVector<SmallVector<unsigned>> commonEdges = buildCommonDmaEdges(
      sourceMappings, destinationByLogical, sourceEdges, destinationEdges);

  int64_t elementBytes = shape.elementBits / 8;
  SmallVector<DmaCopyTransaction> transactions;
  for (ArrayRef<unsigned> chain : buildContiguousChains(commonEdges))
    if (failed(appendDmaChainTransactions(chain, sourceMappings,
                                          destinationByLogical, elementBytes,
                                          supportedByteWidths, transactions)))
      return failure();
  return transactions;
}

static std::string getDmaWaveBaseBindingName(ArrayRef<SlotMapping> mappings) {
  llvm::StringSet<> names;
  for (const SlotMapping &mapping : mappings)
    for (const NamedBinding &binding : mapping.bindings)
      names.insert(binding.name);
  std::string name = "dma_wave_base";
  for (unsigned suffix = 0; names.contains(name); ++suffix)
    name = ("dma_wave_base_" + Twine(suffix)).str();
  return name;
}

static FailureOr<SlotMapping> buildDmaDestinationPoint(
    const SlotMapping &source, const DmaExecutionBinding &execution,
    StringRef waveBaseName, Value waveBaseValue, sym::Store &store) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, source.assumptions);
  if (failed(analysis))
    return failure();
  FailureOr<sym::ExprHandle> item = (*analysis)->composeSymbol(execution.name);
  FailureOr<sym::ExprHandle> waveBase =
      (*analysis)->composeSymbol(waveBaseName);
  if (failed(item) || failed(waveBase))
    return failure();

  SlotMapping point = source;
  FailureOr<sym::ExprHandle> proofOffset = substituteDmaExecutionItem(
      **analysis, source.byteOffset, *item, *waveBase);
  FailureOr<sym::ExprHandle> materializationOffset = substituteDmaExecutionItem(
      **analysis, source.materializationByteOffset, *item, *waveBase);
  if (failed(proofOffset) || failed(materializationOffset))
    return failure();
  point.byteOffset = *proofOffset;
  point.materializationByteOffset = *materializationOffset;
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{*item, *waveBase}};
  FailureOr<SmallVector<sym::PredHandle>> assumptions =
      substituteIndexExprPredicates(store, point.assumptions, substitution);
  if (failed(assumptions))
    return failure();
  point.assumptions = std::move(*assumptions);
  llvm::erase_if(point.bindings, [&](const NamedBinding &binding) {
    return binding.name == execution.name;
  });
  point.bindings.push_back({waveBaseName.str(), waveBaseValue});
  point.materializationCandidates.clear();

  llvm::DenseSet<StringRef> freeSymbols;
  sym::walkSymbolNames(point.materializationByteOffset,
                       [&](StringRef name) { freeSymbols.insert(name); });
  for (const NamedBinding &binding : point.bindings)
    if (freeSymbols.contains(binding.name) &&
        isa<SimdType>(binding.value.getType()))
      return failure();
  return point;
}

static FailureOr<Value> materializeDmaPredicateExpression(
    IRRewriter &rewriter, const MemoryAccess &access, const SlotMapping &point,
    sym::ExprHandle expression, int64_t waveWidth) {
  llvm::DenseSet<StringRef> freeSymbols;
  sym::walkSymbolNames(expression,
                       [&](StringRef name) { freeSymbols.insert(name); });
  SmallVector<StringRef> names;
  SmallVector<Value> values;
  for (const NamedBinding &binding : point.bindings) {
    if (!freeSymbols.contains(binding.name))
      continue;
    names.push_back(binding.name);
    values.push_back(binding.value);
    freeSymbols.erase(binding.name);
  }
  if (!freeSymbols.empty())
    return failure();

  Value result;
  if (std::optional<int64_t> literal =
          sym::getIntegerLiteralValue(expression)) {
    result = ConstantOp::create(rewriter, access.op->getLoc(),
                                rewriter.getIndexType(),
                                rewriter.getIndexAttr(*literal));
  } else {
    llvm::DenseSet<StringRef> liveSymbols;
    for (StringRef name : names)
      liveSymbols.insert(name);
    SmallVector<sym::PredHandle> assumptions =
        filterIndexExprPredicatesBySymbols(point.assumptions, liveSymbols);
    Type resultType = getIndexExprResultType(access.op->getContext(), values);
    result = IndexExprOp::create(
        rewriter, access.op->getLoc(), resultType,
        ExprAttr::get(access.op->getContext(), expression),
        getIndexExprPredArrayAttr(access.op->getContext(), assumptions),
        rewriter.getStrArrayAttr(names), values);
  }

  Type simdIndexType = SimdType::get(access.op->getContext(),
                                     rewriter.getIndexType(), waveWidth);
  if (result.getType().isIndex())
    return SplatOp::create(rewriter, access.op->getLoc(), simdIndexType, result)
        .getResult();
  if (result.getType() != simdIndexType)
    return failure();
  return result;
}

static std::optional<arith::CmpIPredicate>
convertDmaPredicateComparison(sym::PredCmpOp comparison) {
  switch (comparison) {
  case sym::PredCmpOp::Lt:
    return arith::CmpIPredicate::slt;
  case sym::PredCmpOp::Le:
    return arith::CmpIPredicate::sle;
  case sym::PredCmpOp::Gt:
    return arith::CmpIPredicate::sgt;
  case sym::PredCmpOp::Ge:
    return arith::CmpIPredicate::sge;
  case sym::PredCmpOp::Eq:
    return arith::CmpIPredicate::eq;
  case sym::PredCmpOp::Ne:
    return arith::CmpIPredicate::ne;
  }
  return std::nullopt;
}

static Value createDmaMaskConstant(IRRewriter &rewriter, Location loc,
                                   Type maskType, bool value) {
  return ConstantOp::create(rewriter, loc, maskType,
                            rewriter.getBoolAttr(value));
}

static FailureOr<Value> materializeDmaActivationPredicate(
    IRRewriter &rewriter, const MemoryAccess &access, const SlotMapping &point,
    sym::PredHandle predicate, int64_t waveWidth);

static FailureOr<Value> materializeDmaComparison(IRRewriter &rewriter,
                                                 const MemoryAccess &access,
                                                 const SlotMapping &point,
                                                 sym::PredView view,
                                                 int64_t waveWidth) {
  std::optional<sym::PredCmpOp> symbolicComparison = view.getCmpOp();
  if (!symbolicComparison)
    return failure();
  std::optional<arith::CmpIPredicate> comparison =
      convertDmaPredicateComparison(*symbolicComparison);
  FailureOr<Value> lhs = materializeDmaPredicateExpression(
      rewriter, access, point, view.getCmpLhs(), waveWidth);
  FailureOr<Value> rhs = materializeDmaPredicateExpression(
      rewriter, access, point, view.getCmpRhs(), waveWidth);
  if (!comparison || failed(lhs) || failed(rhs))
    return failure();
  Type maskType = MaskType::get(access.op->getContext(), waveWidth);
  return CmpIOp::create(rewriter, access.op->getLoc(), maskType, *comparison,
                        *lhs, *rhs)
      .getResult();
}

static FailureOr<Value> materializeDmaNot(IRRewriter &rewriter,
                                          const MemoryAccess &access,
                                          const SlotMapping &point,
                                          sym::PredView view,
                                          int64_t waveWidth) {
  FailureOr<Value> argument = materializeDmaActivationPredicate(
      rewriter, access, point, view.getUnaryArg(), waveWidth);
  if (failed(argument))
    return failure();
  Type maskType = MaskType::get(access.op->getContext(), waveWidth);
  Location loc = access.op->getLoc();
  Value falseValue = createDmaMaskConstant(rewriter, loc, maskType, false);
  Value trueValue = createDmaMaskConstant(rewriter, loc, maskType, true);
  return SelectOp::create(rewriter, loc, maskType, *argument, falseValue,
                          trueValue)
      .getResult();
}

static Value combineDmaMasks(IRRewriter &rewriter, Location loc, Type maskType,
                             Value lhs, Value rhs, sym::PredKind kind) {
  bool disjunction = kind == sym::PredKind::Or;
  Value constant = createDmaMaskConstant(rewriter, loc, maskType, disjunction);
  return disjunction
             ? SelectOp::create(rewriter, loc, maskType, lhs, constant, rhs)
                   .getResult()
             : SelectOp::create(rewriter, loc, maskType, lhs, rhs, constant)
                   .getResult();
}

static FailureOr<Value> materializeDmaLogic(IRRewriter &rewriter,
                                            const MemoryAccess &access,
                                            const SlotMapping &point,
                                            sym::PredView view,
                                            int64_t waveWidth) {
  if (view.getLogicArgCount() == 0)
    return failure();
  FailureOr<Value> result = materializeDmaActivationPredicate(
      rewriter, access, point, view.getLogicArg(0), waveWidth);
  if (failed(result))
    return failure();
  Type maskType = MaskType::get(access.op->getContext(), waveWidth);
  for (uint32_t index = 1; index < view.getLogicArgCount(); ++index) {
    FailureOr<Value> argument = materializeDmaActivationPredicate(
        rewriter, access, point, view.getLogicArg(index), waveWidth);
    if (failed(argument))
      return failure();
    result = combineDmaMasks(rewriter, access.op->getLoc(), maskType, *result,
                             *argument, view.getKind());
  }
  return result;
}

static FailureOr<Value> materializeDmaActivationPredicate(
    IRRewriter &rewriter, const MemoryAccess &access, const SlotMapping &point,
    sym::PredHandle predicate, int64_t waveWidth) {
  sym::PredView view(predicate);
  Type maskType = MaskType::get(access.op->getContext(), waveWidth);
  Location loc = access.op->getLoc();
  switch (view.getKind()) {
  case sym::PredKind::True:
    return createDmaMaskConstant(rewriter, loc, maskType, true);
  case sym::PredKind::False:
    return createDmaMaskConstant(rewriter, loc, maskType, false);
  case sym::PredKind::Cmp:
    return materializeDmaComparison(rewriter, access, point, view, waveWidth);
  case sym::PredKind::Not:
    return materializeDmaNot(rewriter, access, point, view, waveWidth);
  case sym::PredKind::And:
  case sym::PredKind::Or:
    return materializeDmaLogic(rewriter, access, point, view, waveWidth);
  default:
    return failure();
  }
}

static bool hasDmaCopyAccessShape(const MemoryAccess &source,
                                  const MemoryAccess &destination) {
  return !source.cache && !destination.cache && source.bases.size() == 1 &&
         destination.bases.size() == 1 &&
         source.packetType == destination.packetType;
}

static std::unique_ptr<wave::memory_lowering::CopyTransactionEmitter>
matchDmaCopyEmitter(ScatterOp scatter, const DmaCopyMatch &match,
                    const MemoryAccess &source,
                    const MemoryAccess &destination) {
  SmallVector<std::unique_ptr<wave::memory_lowering::CopyTransactionProvider>>
      providers;
  wave::memory_lowering::populateCopyTransactionProviders(providers);
  wave::memory_lowering::CopyTransactionRequest request{
      source.bases.front(), destination.bases.front(), scatter,
      match.zeroFillInactive};
  for (const std::unique_ptr<wave::memory_lowering::CopyTransactionProvider>
           &provider : providers)
    if (std::unique_ptr<wave::memory_lowering::CopyTransactionEmitter> emitter =
            provider->match(request))
      return emitter;
  return {};
}

static bool
hasCompatibleDmaMappings(const PreparedAccessMappings &source,
                         const PreparedAccessMappings &destination) {
  return source.shape.slotCount == destination.shape.slotCount &&
         source.shape.elementBits == destination.shape.elementBits &&
         hasUnpredicatedMappings(destination.mappings);
}

static bool
hasSupportedDmaSourcePredication(const DmaCopyMatch &match,
                                 const MemoryAccess &source,
                                 const PreparedAccessMappings &prepared) {
  if (match.zeroFillInactive)
    return !source.packetWhere || source.packetWhere == match.predicate;
  return !source.packetWhere && hasUnpredicatedMappings(prepared.mappings);
}

static bool hasDmaExecutionType(const DmaExecutionBinding &execution) {
  SimdType type = dyn_cast<SimdType>(execution.value.getType());
  return type && type.getElementType().isInteger(32) && type.getWidth() > 0;
}

struct PreparedDmaCopy {
  PreparedAccessMappings source;
  PreparedAccessMappings destination;
  std::optional<DmaExecutionBinding> sourceExecution;
  DmaExecutionBinding destinationExecution;
};

static std::optional<PreparedDmaCopy>
prepareDmaCopy(IRRewriter &rewriter, MemoryAccess &source,
               MemoryAccess &destination, const DmaCopyMatch &match,
               WaveDialect &dialect, DataFlowSolver &solver,
               SymbolicMemoryStageTiming &timing) {
  rewriter.setInsertionPoint(source.op);
  FailureOr<PreparedAccessMappings> sourcePrepared =
      prepareAccessMappings(rewriter, source, dialect, solver, timing);
  rewriter.setInsertionPoint(destination.op);
  FailureOr<PreparedAccessMappings> destinationPrepared =
      prepareAccessMappings(rewriter, destination, dialect, solver, timing);
  if (failed(sourcePrepared) || failed(destinationPrepared))
    return std::nullopt;
  if (!hasCompatibleDmaMappings(*sourcePrepared, *destinationPrepared) ||
      !hasSupportedDmaSourcePredication(match, source, *sourcePrepared))
    return std::nullopt;

  std::optional<DmaExecutionBinding> destinationExecution =
      findDmaExecutionBinding(destinationPrepared->mappings);
  if (!destinationExecution || !hasDmaExecutionType(*destinationExecution))
    return std::nullopt;
  std::optional<DmaExecutionBinding> sourceExecution =
      findDmaExecutionBinding(sourcePrepared->mappings);
  if (sourceExecution &&
      sourceExecution->value != destinationExecution->value) {
    rebindDmaExecution(sourcePrepared->mappings, *sourceExecution,
                       destinationExecution->value);
    sourceExecution->value = destinationExecution->value;
  }
  return PreparedDmaCopy{
      std::move(*sourcePrepared), std::move(*destinationPrepared),
      std::move(sourceExecution), std::move(*destinationExecution)};
}

static bool isValidDirectDmaPlan(
    const FailureOr<SmallVector<DmaCopyTransaction>> &transactions,
    const MemoryAccess &destination, const PreparedDmaCopy &prepared,
    int64_t elementBytes, sym::Store &store,
    DmaDestinationProofCache &proofCache) {
  if (failed(transactions) || transactions->empty())
    return false;
  return llvm::all_of(
      *transactions, [&](const DmaCopyTransaction &transaction) {
        return proveDmaDestinationTransaction(
            destination, prepared.destination.mappings,
            transaction.destinationSlots, prepared.destinationExecution,
            elementBytes, transaction.bytes, store, proofCache);
      });
}

static std::optional<SmallVector<Value>> getDmaTransactionConditions(
    const DmaCopyMatch &match, const PreparedDmaCopy &prepared,
    ArrayRef<DmaCopyTransaction> transactions, bool repacked,
    RemainderProofContext &sourceProofContext) {
  SmallVector<Value> conditions;
  conditions.reserve(transactions.size());
  for (const DmaCopyTransaction &transaction : transactions) {
    if (repacked) {
      if (match.zeroFillInactive && !transaction.activationPredicate)
        return std::nullopt;
      conditions.push_back({});
      continue;
    }
    FailureOr<Value> condition =
        getDmaCopyCondition(match, prepared.source.mappings,
                            transaction.sourceSlots, sourceProofContext);
    if (failed(condition))
      return std::nullopt;
    conditions.push_back(*condition);
  }
  return conditions;
}

struct DmaCopyPlan {
  SmallVector<DmaCopyTransaction> transactions;
  SmallVector<Value> conditions;
  bool repacked = false;
};

static std::optional<DmaCopyPlan>
planDmaCopy(const DmaCopyMatch &match, const MemoryAccess &destination,
            PreparedDmaCopy &prepared, WaveDialect &dialect,
            DataFlowSolver &solver, SymbolicRelationProofCache &proofCache,
            DmaDestinationProofCache &dmaProofCache, uint64_t &factDomainCount,
            ArrayRef<int64_t> supportedByteWidths,
            SymbolicMemoryStageTiming &timing) {
  sym::Store &store = dialect.getSymbolStore();
  RemainderProofContext sourceProofContext(dialect, solver, match.gather,
                                           prepared.source.mappings, proofCache,
                                           factDomainCount);
  RemainderProofContext destinationProofContext(dialect, solver, destination.op,
                                                prepared.destination.mappings,
                                                proofCache, factDomainCount);
  TimingScope transactionsTiming =
      timing.nest("lower_symbolic_memory_plan_dma_transactions");
  FailureOr<SmallVector<DmaCopyTransaction>> transactions =
      planDmaCopyTransactions(store, prepared.source.mappings,
                              prepared.destination.mappings,
                              prepared.source.shape, sourceProofContext,
                              destinationProofContext, supportedByteWidths);
  transactionsTiming.stop();
  int64_t elementBytes = prepared.source.shape.elementBits / 8;
  TimingScope validationTiming =
      timing.nest("lower_symbolic_memory_validate_dma_transactions");
  bool repacked = !isValidDirectDmaPlan(transactions, destination, prepared,
                                        elementBytes, store, dmaProofCache);
  validationTiming.stop();
  if (repacked) {
    if (!prepared.sourceExecution)
      return std::nullopt;
    transactions = planRepackedDmaCopyTransactions(
        destination, prepared.source.mappings, prepared.destination.mappings,
        prepared.source.shape, *prepared.sourceExecution,
        prepared.destinationExecution, supportedByteWidths, store);
  }
  if (failed(transactions) || transactions->empty())
    return std::nullopt;
  TimingScope conditionTiming =
      timing.nest("lower_symbolic_memory_prepare_dma_conditions");
  std::optional<SmallVector<Value>> conditions = getDmaTransactionConditions(
      match, prepared, *transactions, repacked, sourceProofContext);
  if (!conditions)
    return std::nullopt;
  conditionTiming.stop();
  return DmaCopyPlan{std::move(*transactions), std::move(*conditions),
                     repacked};
}

static Value materializeDmaWaveBase(IRRewriter &rewriter, Location loc,
                                    const DmaExecutionBinding &execution) {
  SimdType type = cast<SimdType>(execution.value.getType());
  Value width = ConstantOp::create(
      rewriter, loc, type,
      rewriter.getI32IntegerAttr(static_cast<int32_t>(type.getWidth())));
  Value lane = BinaryOp::create(rewriter, loc, type, BinaryKind::RemUI,
                                execution.value, width);
  Value base = BinaryOp::create(rewriter, loc, type, BinaryKind::SubI,
                                execution.value, lane);
  return ReadFirstOp::create(rewriter, loc, rewriter.getI32Type(), base);
}

struct DmaCopyEmissionState {
  std::string waveBaseName;
  SmallVector<Value> sourceByteBases;
  SmallVector<Value> destinationByteBases;
  SmallVector<Value> tokens;
  Value dependency;
  Value waveBase;
};

static DmaCopyEmissionState initializeDmaCopyEmission(
    IRRewriter &rewriter, ScatterOp scatter, const MemoryAccess &source,
    const MemoryAccess &destination, const PreparedDmaCopy &prepared,
    size_t transactionCount) {
  rewriter.setInsertionPoint(scatter);
  Value dependency = source.dependency;
  if (!dependency)
    dependency = TokenOp::create(rewriter, scatter.getLoc(), source.tokenType)
                     .getResult();
  Value waveBase = materializeDmaWaveBase(rewriter, scatter.getLoc(),
                                          prepared.destinationExecution);
  DmaCopyEmissionState state;
  state.waveBaseName = getDmaWaveBaseBindingName(prepared.destination.mappings);
  state.sourceByteBases.resize(source.bases.size());
  state.destinationByteBases.resize(destination.bases.size());
  state.tokens.reserve(transactionCount);
  state.dependency = dependency;
  state.waveBase = waveBase;
  return state;
}

static FailureOr<Value> materializeDmaTransactionCondition(
    IRRewriter &rewriter, ScatterOp scatter, const MemoryAccess &source,
    const DmaCopyTransaction &transaction, const SlotMapping &sourcePoint,
    Value condition, bool repacked) {
  if (!repacked || !transaction.activationPredicate)
    return condition;
  SlotMapping conditionPoint = sourcePoint;
  conditionPoint.assumptions = getActivationProofAssumptions(conditionPoint);
  FailureOr<Value> materialized = materializeDmaActivationPredicate(
      rewriter, source, conditionPoint, *transaction.activationPredicate,
      source.packetType.getWidth());
  if (failed(materialized))
    return scatter.emitOpError(
        "failed to materialize repacked DMA activation predicate");
  return materialized;
}

static FailureOr<Value>
materializeDmaSourcePointer(IRRewriter &rewriter, ScatterOp scatter,
                            const MemoryAccess &source,
                            SlotMapping &sourcePoint, sym::Store &store,
                            SmallVectorImpl<Value> &sourceByteBases) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, sourcePoint.assumptions);
  if (failed(analysis))
    return scatter.emitOpError("failed to prove fused DMA source range");
  if (failed(appendInferredExpressionRange(
          **analysis, sourcePoint.materializationByteOffset,
          sourcePoint.assumptions)))
    return scatter.emitOpError("failed to prove fused DMA source range");

  // Keep proven range on address consumed by machine selection.
  sourcePoint.materializationCandidates.clear();
  SmallVector<TypedPointerRequest> requests{
      TypedPointerRequest{&sourcePoint, sourcePoint.materializationByteOffset,
                          sourcePoint.baseIndex}};
  SmallVector<TypedPointerPlan> plans =
      prepareTypedPointerPlans(source, store, requests);
  return materializePointer(rewriter, source, sourcePoint, plans.front(),
                            sourceByteBases);
}

static FailureOr<Value> materializeDmaDestinationPointer(
    IRRewriter &rewriter, ScatterOp scatter, const MemoryAccess &destination,
    const PreparedDmaCopy &prepared, const DmaCopyTransaction &transaction,
    sym::Store &store, DmaCopyEmissionState &state) {
  const SlotMapping &start =
      transaction.destinationPoint
          ? *transaction.destinationPoint
          : prepared.destination.mappings[transaction.destinationSlots.front()];
  FailureOr<SlotMapping> point =
      buildDmaDestinationPoint(start, prepared.destinationExecution,
                               state.waveBaseName, state.waveBase, store);
  if (failed(point))
    return scatter.emitOpError("failed to materialize proven DMA copy");
  TypedPointerPlan noTypedDestination;
  FailureOr<Value> pointer =
      materializePointer(rewriter, destination, *point, noTypedDestination,
                         state.destinationByteBases);
  if (failed(pointer))
    return scatter.emitOpError("failed to materialize proven DMA destination");

  PtrType destinationType = cast<PtrType>(destination.bases.front().getType());
  PtrType i32Type = PtrType::get(scatter.getContext(), rewriter.getI32Type(),
                                 destinationType.getAddressSpace());
  return PtrCastOp::create(rewriter, scatter.getLoc(), i32Type, *pointer)
      .getResult();
}

static FailureOr<Value>
emitDmaTransaction(IRRewriter &rewriter, ScatterOp scatter,
                   const MemoryAccess &source, const MemoryAccess &destination,
                   const PreparedDmaCopy &prepared,
                   const DmaCopyTransaction &transaction,
                   Value initialCondition, bool repacked, sym::Store &store,
                   const wave::memory_lowering::CopyTransactionEmitter &emitter,
                   DmaCopyEmissionState &state) {
  SlotMapping sourcePoint =
      transaction.sourcePoint
          ? *transaction.sourcePoint
          : buildTransactionPoint(prepared.source.mappings,
                                  transaction.sourceSlots,
                                  transaction.sourceSlots.front());
  FailureOr<Value> condition = materializeDmaTransactionCondition(
      rewriter, scatter, source, transaction, sourcePoint, initialCondition,
      repacked);
  if (failed(condition))
    return failure();
  FailureOr<Value> sourcePointer = materializeDmaSourcePointer(
      rewriter, scatter, source, sourcePoint, store, state.sourceByteBases);
  if (failed(sourcePointer))
    return failure();
  FailureOr<Value> destinationPointer = materializeDmaDestinationPointer(
      rewriter, scatter, destination, prepared, transaction, store, state);
  if (failed(destinationPointer))
    return failure();
  FailureOr<Value> token = emitter.emit(
      rewriter, scatter.getLoc(), destination.tokenType, *sourcePointer,
      *destinationPointer, state.dependency, transaction.bytes, *condition);
  if (failed(token))
    return scatter.emitOpError("failed to emit fused DMA copy");
  return token;
}

static LogicalResult
emitDmaCopy(IRRewriter &rewriter, ScatterOp scatter, const DmaCopyMatch &match,
            const MemoryAccess &source, const MemoryAccess &destination,
            const PreparedDmaCopy &prepared, DmaCopyPlan &plan,
            sym::Store &store,
            const wave::memory_lowering::CopyTransactionEmitter &emitter) {
  DmaCopyEmissionState state =
      initializeDmaCopyEmission(rewriter, scatter, source, destination,
                                prepared, plan.transactions.size());
  for (auto [transaction, condition] :
       llvm::zip(plan.transactions, plan.conditions)) {
    FailureOr<Value> token = emitDmaTransaction(
        rewriter, scatter, source, destination, prepared, transaction,
        condition, plan.repacked, store, emitter, state);
    if (failed(token))
      return failure();
    state.tokens.push_back(*token);
  }
  Value token = joinTokens(rewriter, destination, state.tokens);
  rewriter.replaceOp(scatter, token);
  if (match.predicate)
    rewriter.eraseOp(match.predicate);
  else
    rewriter.eraseOp(match.gather);
  return success();
}

static FailureOr<bool>
tryLowerDmaCopy(ScatterOp scatter, WaveDialect &dialect, IRRewriter &rewriter,
                DataFlowSolver &solver, SymbolicRelationProofCache &proofCache,
                DmaDestinationProofCache &dmaProofCache,
                uint64_t &factDomainCount, SymbolicMemoryStageTiming &timing) {
  std::optional<DmaCopyMatch> matched = matchDmaCopy(scatter);
  if (!matched)
    return false;
  MemoryAccess source = getAccess(matched->gather);
  MemoryAccess destination = getAccess(scatter);
  if (!hasDmaCopyAccessShape(source, destination))
    return false;

  std::unique_ptr<wave::memory_lowering::CopyTransactionEmitter> emitter =
      matchDmaCopyEmitter(scatter, *matched, source, destination);
  if (!emitter)
    return false;
  ArrayRef<int64_t> supportedByteWidths = emitter->getSupportedByteWidths();
  if (supportedByteWidths.empty())
    return false;

  TimingScope prepareTiming = timing.nest("lower_symbolic_memory_prepare_dma");
  std::optional<PreparedDmaCopy> prepared = prepareDmaCopy(
      rewriter, source, destination, *matched, dialect, solver, timing);
  if (!prepared)
    return false;
  prepareTiming.stop();
  TimingScope planTiming = timing.nest("lower_symbolic_memory_plan_dma");
  std::optional<DmaCopyPlan> plan =
      planDmaCopy(*matched, destination, *prepared, dialect, solver, proofCache,
                  dmaProofCache, factDomainCount, supportedByteWidths, timing);
  if (!plan)
    return false;
  planTiming.stop();
  TimingScope emitTiming = timing.nest("lower_symbolic_memory_emit_dma");
  if (failed(emitDmaCopy(rewriter, scatter, *matched, source, destination,
                         *prepared, *plan, dialect.getSymbolStore(), *emitter)))
    return failure();
  return true;
}

static LogicalResult
lowerDmaCopies(Operation *root, WaveDialect &dialect, IRRewriter &rewriter,
               DataFlowSolver &solver, SymbolicRelationProofCache &proofCache,
               uint64_t &factDomainCount, SymbolicMemoryStageTiming &timing) {
  SmallVector<ScatterOp> scatters;
  root->walk([&](ScatterOp scatter) { scatters.push_back(scatter); });
  DmaDestinationProofCache dmaProofCache;
  for (ScatterOp scatter : scatters) {
    FailureOr<bool> lowered =
        tryLowerDmaCopy(scatter, dialect, rewriter, solver, proofCache,
                        dmaProofCache, factDomainCount, timing);
    if (failed(lowered))
      return failure();
  }
  return success();
}

static LogicalResult lowerAccess(
    IRRewriter &rewriter, MemoryAccess &access, WaveDialect &dialect,
    DataFlowSolver &solver, SymbolicRelationProofCache &proofCache,
    uint64_t &factDomainCount, SymbolicMemoryStageTiming &timing,
    ArrayRef<std::unique_ptr<wave::memory_lowering::GatherTransactionProvider>>
        providers) {
  TimingScope prepareTiming =
      timing.nest("lower_symbolic_memory_prepare_mappings");
  FailureOr<PreparedAccessMappings> prepared =
      prepareAccessMappings(rewriter, access, dialect, solver, timing);
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
    FailureOr<GatherPlan> plan = planGatherTransactions(
        access, store, prepared->mappings, prepared->shape.elementBits,
        proofContext, timing, providers);
    if (failed(plan))
      return access.op->emitOpError(
          "packet cannot be covered by legal memory transactions");
    planTiming.stop();

    TimingScope emitTiming = timing.nest("lower_symbolic_memory_emit_gather");
    return lowerGather(rewriter, access, store, prepared->mappings, *plan);
  }

  TimingScope planTiming = timing.nest("lower_symbolic_memory_plan_scatter");
  FailureOr<SmallVector<SmallVector<unsigned>>> transactions =
      planTransactions(store, prepared->mappings, prepared->shape.elementBits,
                       proofContext, timing);
  if (failed(transactions))
    return access.op->emitOpError(
        "packet cannot be covered by legal memory transactions");
  planTiming.stop();

  TimingScope emitTiming = timing.nest("lower_symbolic_memory_emit_scatter");
  return lowerScatter(rewriter, access, store, prepared->mappings,
                      *transactions);
}

static LogicalResult lowerAccesses(
    ArrayRef<Operation *> accesses, WaveDialect &dialect, IRRewriter &rewriter,
    DataFlowSolver &solver, SymbolicRelationProofCache &proofCache,
    uint64_t &factDomainCount, SymbolicMemoryStageTiming &timing,
    ArrayRef<std::unique_ptr<wave::memory_lowering::GatherTransactionProvider>>
        providers) {
  for (Operation *op : accesses) {
    rewriter.setInsertionPoint(op);
    MemoryAccess access = isa<GatherOp>(op) ? getAccess(cast<GatherOp>(op))
                                            : getAccess(cast<ScatterOp>(op));
    if (failed(lowerAccess(rewriter, access, dialect, solver, proofCache,
                           factDomainCount, timing, providers)))
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
    // Provider caches span one pass invocation.
    SmallVector<
        std::unique_ptr<wave::memory_lowering::GatherTransactionProvider>>
        providers;
    wave::memory_lowering::populateGatherTransactionProviders(providers);
    uint64_t factDomainCount = 0;
    TimingScope dmaTiming =
        timing.nest("lower_symbolic_memory_lower_dma_copies");
    if (failed(lowerDmaCopies(root, *dialect, rewriter, solver, proofCache,
                              factDomainCount, timing)))
      return signalPassFailure();
    dmaTiming.stop();
    accesses.clear();
    root->walk([&](Operation *op) {
      if (isa<GatherOp, ScatterOp>(op))
        accesses.push_back(op);
    });
    if (failed(lowerAccesses(accesses, *dialect, rewriter, solver, proofCache,
                             factDomainCount, timing, providers)))
      return signalPassFailure();
    numRelationPlanningFactDomains += factDomainCount;
  }
};

} // namespace
