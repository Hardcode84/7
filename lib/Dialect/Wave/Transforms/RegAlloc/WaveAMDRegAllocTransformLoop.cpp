//===- WaveAMDRegAllocTransformLoop.cpp - Regalloc transforms -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocTransformLoop.h"

#include "WaveAMDRegAllocInternal.h"
#include "WaveAMDRegAllocPrep.h"
#include "WaveAMDRegAllocTransformState.h"
#include "WaveAMDRegAllocTransformUtils.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/IRMapping.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/MathExtras.h"
#include <algorithm>
#include <array>
#include <limits>
#include <optional>

using namespace mlir;
using wave::regalloc_detail::RegAllocTransformDecodedState;
using wave::regalloc_detail::RegAllocTransformStateCache;

namespace {

struct RegAllocAliasValue {
  SmallVector<int64_t> path;
  SmallVector<wave::RegAllocTransformLiveRange, 2> ranges;
  waveamdmachine::RegType type;
  unsigned id = 0;
  unsigned start = 0;
  unsigned end = 0;
  unsigned aliasSet = 0;
  unsigned number = 0;
  int64_t offset = 0;
  bool blockArgument = false;
};

struct RegAllocAliasOp {
  SmallVector<int64_t> path;
  Operation *op = nullptr;
  Operation *enclosingLoop = nullptr;
  TypeID typeId;
  unsigned id = 0;
  unsigned position = 0;
};

struct RegAllocAliasEdge {
  unsigned lhs = 0;
  unsigned rhs = 0;
  int64_t delta = 0;
};

struct RegAllocAliasSet {
  SmallVector<unsigned> members;
  unsigned id = 0;
};

static wave::RegAllocStateAttr::PackedRegClass
packRegAllocClass(waveamdmachine::RegClass regClass) {
  switch (regClass) {
  case waveamdmachine::RegClass::SGPR:
    return wave::RegAllocStateAttr::PackedSGPR;
  case waveamdmachine::RegClass::VGPR:
    return wave::RegAllocStateAttr::PackedVGPR;
  case waveamdmachine::RegClass::AGPR:
    return wave::RegAllocStateAttr::PackedAGPR;
  case waveamdmachine::RegClass::SCC:
  case waveamdmachine::RegClass::VCC:
    llvm_unreachable("untracked packed register class");
  }
  llvm_unreachable("unknown register class");
}

static bool isSGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::SGPR;
}

static bool isVGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::VGPR;
}

static bool isAGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::AGPR;
}

static bool isFixedHardwareRead(Value value) {
  Operation *def = value.getDefiningOp();
  return isa_and_nonnull<
      waveamdmachine::SWorkgroupIdXOp, waveamdmachine::SWorkgroupIdYOp,
      waveamdmachine::SWorkgroupIdZOp, waveamdmachine::VWorkitemIdXOp,
      waveamdmachine::VWorkitemIdYOp, waveamdmachine::VWorkitemIdZOp>(def);
}

static bool areEquivalentFixedHardwareReads(Value lhs, Value rhs) {
  if (!isFixedHardwareRead(lhs) || !isFixedHardwareRead(rhs))
    return false;
  if (lhs.getType() != rhs.getType())
    return false;
  return lhs.getDefiningOp()->getName() == rhs.getDefiningOp()->getName();
}

static waveamdmachine::RegType
getUnassignedRegType(waveamdmachine::RegType type) {
  return waveamdmachine::RegType::get(type.getContext(), type.getRegClass(),
                                      type.getWidth(), /*index=*/-1);
}

static FailureOr<Value>
cloneImmediateTupleMove(OpBuilder &builder, Value value,
                        waveamdmachine::RegType resultType) {
  auto mov = value.getDefiningOp<waveamdmachine::VMovB32TupleOp>();
  if (!mov || !mov.getSource().getDefiningOp<waveamdmachine::ImmOp>())
    return failure();
  Operation *clone = builder.clone(*mov);
  clone->getResult(0).setType(resultType);
  return clone->getResult(0);
}

static FailureOr<Value> cloneAGPRDuplicate(OpBuilder &builder, Value value,
                                           waveamdmachine::RegType resultType) {
  Operation *def = value.getDefiningOp();
  if (!isa_and_nonnull<waveamdmachine::UninitOp,
                       waveamdmachine::VAccvgprWriteB32TupleOp>(def))
    return failure();
  Operation *clone = builder.clone(*def);
  clone->getResult(0).setType(resultType);
  return clone->getResult(0);
}

static Value copyRegDuplicate(OpBuilder &builder, Location loc, Value value,
                              waveamdmachine::RegType resultType) {
  return waveamdmachine::CopyTupleOp::create(builder, loc, resultType, value)
      .getResult();
}

static FailureOr<Value> duplicateRegValue(OpBuilder &builder, Location loc,
                                          Value value) {
  waveamdmachine::RegType type = cast<waveamdmachine::RegType>(value.getType());
  waveamdmachine::RegType resultType = getUnassignedRegType(type);
  FailureOr<Value> immClone =
      cloneImmediateTupleMove(builder, value, resultType);
  if (succeeded(immClone))
    return *immClone;
  if (isAGPR(type)) {
    FailureOr<Value> agprClone = cloneAGPRDuplicate(builder, value, resultType);
    if (succeeded(agprClone))
      return *agprClone;
    return emitError(loc) << "regalloc transform cannot duplicate AGPR value";
  }
  if (isVGPR(type) || isSGPR(type))
    return copyRegDuplicate(builder, loc, value, resultType);
  return emitError(loc, "regalloc transform cannot duplicate register value");
}

using LoopInitAliasEdge = std::pair<Value, int64_t>;
using LoopInitAliasGraph = DenseMap<Value, SmallVector<LoopInitAliasEdge, 4>>;

static void addLoopInitAliasEdge(LoopInitAliasGraph &graph, Value tuple,
                                 Value element, int64_t offset) {
  graph[tuple].push_back({element, offset});
  graph[element].push_back({tuple, -offset});
}

static LoopInitAliasGraph buildLoopInitAliasGraph(func::FuncOp func) {
  LoopInitAliasGraph graph;
  func.walk([&](Operation *op) {
    auto collect = [&](Value tuple, ValueRange elements) {
      int64_t offset = 0;
      for (Value element : elements) {
        addLoopInitAliasEdge(graph, tuple, element, offset);
        offset += cast<waveamdmachine::RegType>(element.getType()).getWidth();
      }
    };
    if (auto toElements = dyn_cast<waveamdmachine::TupleToElementsOp>(op))
      collect(toElements.getTuple(), toElements.getElements());
    if (auto fromElements = dyn_cast<waveamdmachine::TupleFromElementsOp>(op))
      collect(fromElements.getTuple(), fromElements.getElements());
    if (auto update = dyn_cast<waveamdmachine::UpdateTupleOp>(op)) {
      addLoopInitAliasEdge(graph, update.getResult(), update.getBase(), 0);
      for (auto [value, offset] :
           llvm::zip_equal(update.getUpdates(), update.getOffsets()))
        addLoopInitAliasEdge(graph, update.getResult(), value,
                             cast<IntegerAttr>(offset).getInt());
    }
  });
  return graph;
}

// Returns rhs' register offset relative to lhs when tuple aliasing constrains
// both values to the same storage.
static std::optional<int64_t>
getLoopInitAliasOffset(const LoopInitAliasGraph &graph, Value lhs, Value rhs) {
  if (lhs == rhs)
    return 0;
  DenseMap<Value, int64_t> offsets;
  SmallVector<Value> worklist;
  offsets.try_emplace(lhs, 0);
  worklist.push_back(lhs);
  while (!worklist.empty()) {
    Value value = worklist.pop_back_val();
    auto edges = graph.find(value);
    if (edges == graph.end())
      continue;
    for (auto [next, delta] : edges->second) {
      int64_t nextOffset = offsets.lookup(value) + delta;
      if (next == rhs)
        return nextOffset;
      if (offsets.try_emplace(next, nextOffset).second)
        worklist.push_back(next);
    }
  }
  return std::nullopt;
}

static bool loopInitStorageOverlaps(const LoopInitAliasGraph &graph, Value lhs,
                                    waveamdmachine::RegType lhsType,
                                    Value rhs) {
  std::optional<waveamdmachine::RegType> rhsType =
      wave::getRegAllocTransformTrackedRegType(rhs);
  if (!rhsType || lhsType.getRegClass() != rhsType->getRegClass())
    return false;
  std::optional<int64_t> rhsOffset = getLoopInitAliasOffset(graph, lhs, rhs);
  if (!rhsOffset)
    return false;
  int64_t lhsEnd = lhsType.getWidth();
  int64_t rhsEnd = *rhsOffset + rhsType->getWidth();
  return std::max<int64_t>(0, *rhsOffset) < std::min(lhsEnd, rhsEnd);
}

static LogicalResult splitOverlappingLoopInits(func::FuncOp func) {
  SmallVector<waveamdmachine::UniformLoopOp> loops;
  func.walk([&](waveamdmachine::UniformLoopOp loop) { loops.push_back(loop); });
  LoopInitAliasGraph aliasGraph = buildLoopInitAliasGraph(func);
  OpBuilder builder(func.getContext());
  for (waveamdmachine::UniformLoopOp loop : loops) {
    SmallVector<bool> needsCopy(loop.getInits().size(), false);
    for (auto [lhsIndex, lhs] : llvm::enumerate(loop.getInits())) {
      std::optional<waveamdmachine::RegType> lhsType =
          wave::getRegAllocTransformTrackedRegType(lhs);
      if (!lhsType)
        continue;
      for (unsigned rhsIndex = lhsIndex + 1; rhsIndex < loop.getInits().size();
           ++rhsIndex) {
        Value rhs = loop.getInits()[rhsIndex];
        if (!loopInitStorageOverlaps(aliasGraph, lhs, *lhsType, rhs))
          continue;
        needsCopy[lhsIndex] = true;
        needsCopy[rhsIndex] = true;
      }
    }

    builder.setInsertionPoint(loop);
    for (auto [index, init] : llvm::enumerate(loop.getInits())) {
      if (!needsCopy[index])
        continue;
      FailureOr<Value> duplicate =
          duplicateRegValue(builder, loop.getLoc(), init);
      if (failed(duplicate))
        return failure();
      loop.getInitsMutable()[index].assign(*duplicate);
    }
  }
  return success();
}

class RegAllocAliasStateBuilder {
public:
  RegAllocAliasStateBuilder(func::FuncOp func, Builder &builder,
                            bool coalesceMFMAAccResult)
      : func(func), builder(builder),
        coalesceMFMAAccResult(coalesceMFMAAccResult) {}

  FailureOr<DictionaryAttr>
  build(wave::regalloc_detail::RegAllocTransformStateCache *cache) {
    collectRegion(func.getBody(), {0}, nullptr);
    collectUsesAndAliases();
    if (failed(assignAliasSets()))
      return failure();
    DictionaryAttr state = buildAttr();
    if (cache)
      cache->install(func, state, buildDecodedState());
    return state;
  }

private:
  using AliasAdjacency = SmallVector<SmallVector<std::pair<unsigned, int64_t>>>;

  void registerValue(Value value, unsigned start, ArrayRef<int64_t> path,
                     bool blockArgument, unsigned number) {
    if (valueIds.contains(value))
      return;
    std::optional<waveamdmachine::RegType> type =
        wave::getRegAllocTransformTrackedRegType(value);
    if (!type)
      return;
    RegAllocAliasValue record;
    record.path.append(path.begin(), path.end());
    record.type = *type;
    record.id = values.size();
    record.start = start;
    record.end = start;
    record.ranges.push_back({start, start});
    record.blockArgument = blockArgument;
    record.number = number;
    valueIds[value] = record.id;
    values.push_back(record);
    payloadValues.push_back(value);
  }

  void collectBlockArguments(Block &block, unsigned start,
                             ArrayRef<int64_t> blockPath) {
    for (BlockArgument arg : block.getArguments())
      registerValue(arg, start, blockPath, /*blockArgument=*/true,
                    arg.getArgNumber());
  }

  void collectRegion(Region &region, ArrayRef<int64_t> regionPath,
                     Operation *enclosingLoop) {
    Operation *parent = region.getParentOp();
    unsigned blockArgStart = parent ? positions.lookup(parent) : 0;
    for (auto [blockIndex, block] : llvm::enumerate(region)) {
      SmallVector<int64_t> blockPath(regionPath);
      blockPath.push_back(blockIndex);
      collectBlockArguments(block, blockArgStart, blockPath);
      for (auto [opIndex, op] : llvm::enumerate(block)) {
        SmallVector<int64_t> opPath(blockPath);
        opPath.push_back(opIndex);
        RegAllocAliasOp record;
        record.path = opPath;
        record.op = &op;
        record.enclosingLoop = enclosingLoop;
        record.typeId = op.getName().getTypeID();
        record.id = ops.size();
        record.position = ops.size();
        positions[&op] = record.position;
        ops.push_back(record);
        Operation *nestedEnclosingLoop = enclosingLoop;
        if (op.getNumRegions() != 0 &&
            record.typeId == TypeID::get<waveamdmachine::UniformLoopOp>()) {
          parentUniformLoops[&op] = enclosingLoop;
          nestedEnclosingLoop = &op;
        }
        for (auto [regionIndex, nested] : llvm::enumerate(op.getRegions())) {
          SmallVector<int64_t> nestedPath(opPath);
          nestedPath.push_back(regionIndex);
          collectRegion(nested, nestedPath, nestedEnclosingLoop);
        }
        unsigned resultStart = record.position;
        if (record.typeId == TypeID::get<waveamdmachine::UniformLoopOp>())
          resultStart = ops.back().position;
        for (OpResult result : op.getResults())
          registerValue(result, resultStart, opPath,
                        /*blockArgument=*/false, result.getResultNumber());
      }
    }
  }

  void extendValue(Value value, unsigned position) {
    auto it = valueIds.find(value);
    if (it == valueIds.end())
      return;
    RegAllocAliasValue &record = values[it->second];
    record.start = std::min(record.start, position);
    record.end = std::max(record.end, position);
    if (record.ranges.empty()) {
      record.ranges.push_back({position, position});
      return;
    }
    if (position >= record.ranges.back().start) {
      record.ranges.back().end = std::max(record.ranges.back().end, position);
      return;
    }
    auto pos = llvm::lower_bound(
        record.ranges, position,
        [](wave::RegAllocTransformLiveRange range, unsigned position) {
          return range.end < position;
        });
    if (pos != record.ranges.end() && pos->start <= position)
      return;
    record.ranges.insert(pos, {position, position});
  }

  bool valueRangeEndsAt(Value value, unsigned position) {
    auto it = valueIds.find(value);
    if (it == valueIds.end())
      return false;
    const RegAllocAliasValue &record = values[it->second];
    auto pos = llvm::lower_bound(
        record.ranges, position,
        [](wave::RegAllocTransformLiveRange range, unsigned position) {
          return range.end < position;
        });
    return pos != record.ranges.end() && pos->start <= position &&
           pos->end == position;
  }

  bool isValueDefinedInside(Operation *scope, Value value) {
    if (Operation *def = value.getDefiningOp())
      return def == scope || scope->isAncestor(def);
    auto arg = cast<BlockArgument>(value);
    Operation *owner = arg.getOwner()->getParentOp();
    return owner && (owner == scope || scope->isAncestor(owner));
  }

  void collectExternalLoopBodyUse(Value operand, Operation *enclosingLoop) {
    if (!valueIds.contains(operand))
      return;
    for (Operation *scope = enclosingLoop; scope;
         scope = parentUniformLoops.lookup(scope)) {
      if (isValueDefinedInside(scope, operand))
        break;
      auto loop = cast<waveamdmachine::UniformLoopOp>(scope);
      unsigned &end = externalLoopUseEnds[operand];
      end = std::max(end, getLoopExitPosition(loop));
    }
  }

  unsigned getLoopExitPosition(waveamdmachine::UniformLoopOp loop) {
    if (loop.getBody().empty())
      return positions.lookup(loop.getOperation());
    Operation *terminator = loop.getBody().front().getTerminator();
    auto it = positions.find(terminator);
    if (it != positions.end())
      return it->second;
    return positions.lookup(loop.getOperation());
  }

  void extendExternalLoopUses() {
    for (auto [value, end] : externalLoopUseEnds)
      extendValue(value, end);
  }

  void addAliasEdge(Value lhs, Value rhs, int64_t delta) {
    auto lhsIt = valueIds.find(lhs);
    auto rhsIt = valueIds.find(rhs);
    if (lhsIt == valueIds.end() || rhsIt == valueIds.end())
      return;
    edges.push_back({lhsIt->second, rhsIt->second, delta});
  }

  Value getSingleTrackedResult(Operation *op) {
    Value tracked;
    for (Value result : op->getResults()) {
      if (!valueIds.contains(result))
        continue;
      if (tracked)
        return {};
      tracked = result;
    }
    return tracked;
  }

  const llvm::AMDGPU::IsaVersion *getKilledOperandReuseIsa() {
    if (killedOperandReuseIsa)
      return &*killedOperandReuseIsa;
    if (killedOperandReuseIsaFailed)
      return nullptr;
    FailureOr<llvm::AMDGPU::IsaVersion> isa =
        waveamdmachine::getAMDGPUTargetIsaVersion(
            func, "waveamd regalloc required killed operand reuse");
    if (failed(isa)) {
      killedOperandReuseIsaFailed = true;
      return nullptr;
    }
    killedOperandReuseIsa = *isa;
    return &*killedOperandReuseIsa;
  }

  void collectRequiredKilledOperandAliases(Operation *op) {
    Value result = getSingleTrackedResult(op);
    if (!result || op->getNumRegions() != 0)
      return;
    waveamdmachine::KilledOperandReuseOpInterface reuse =
        dyn_cast<waveamdmachine::KilledOperandReuseOpInterface>(op);
    if (!reuse || !reuse.hasRequiredKilledOperandReuse())
      return;
    const llvm::AMDGPU::IsaVersion *targetIsa = getKilledOperandReuseIsa();
    if (!targetIsa)
      return;
    unsigned position = positions.lookup(op);
    for (OpOperand &operand : op->getOpOperands()) {
      if (!wave::regalloc_detail::requiresKilledOperandReuseForResult(
              reuse, operand, *targetIsa))
        continue;
      if (!valueRangeEndsAt(operand.get(), position))
        continue;
      addAliasEdge(operand.get(), result, 0);
    }
  }

  void collectTupleAliases(Operation *op, TypeID typeId) {
    auto collect = [&](Value tuple, ValueRange elements) {
      int64_t offset = 0;
      for (Value element : elements) {
        addAliasEdge(tuple, element, offset);
        if (auto type = dyn_cast<waveamdmachine::RegType>(element.getType()))
          offset += type.getWidth();
      }
    };
    if (typeId == TypeID::get<waveamdmachine::TupleToElementsOp>()) {
      auto toElements = cast<waveamdmachine::TupleToElementsOp>(op);
      collect(toElements.getTuple(), toElements.getElements());
      return;
    }
    if (typeId == TypeID::get<waveamdmachine::TupleFromElementsOp>()) {
      auto fromElements = cast<waveamdmachine::TupleFromElementsOp>(op);
      collect(fromElements.getTuple(), fromElements.getElements());
      return;
    }
    if (typeId == TypeID::get<waveamdmachine::UpdateTupleOp>()) {
      auto update = cast<waveamdmachine::UpdateTupleOp>(op);
      addAliasEdge(update.getResult(), update.getBase(), 0);
      for (auto [value, offset] :
           llvm::zip_equal(update.getUpdates(), update.getOffsets()))
        addAliasEdge(update.getResult(), value,
                     cast<IntegerAttr>(offset).getInt());
    }
  }

  void collectMMAAliases(Operation *op) {
    if (!coalesceMFMAAccResult)
      return;
    auto mma = dyn_cast<waveamdmachine::MMAOpInterface>(op);
    if (!mma || !op->hasTrait<OpTrait::waveamdmachine::MFMAOp>())
      return;
    if (!valueRangeEndsAt(mma.getAcc(), positions.lookup(op)))
      return;
    addAliasEdge(mma.getAcc(), mma.getAccResult(), 0);
  }

  void collectYieldAliases(ValueRange results, Region &region) {
    if (region.empty())
      return;
    auto yield =
        dyn_cast<waveamdmachine::YieldOp>(region.front().getTerminator());
    if (!yield)
      return;
    for (auto [result, yielded] : llvm::zip_equal(results, yield.getValues()))
      addAliasEdge(result, yielded, 0);
  }

  void collectLoopCarryAliases(waveamdmachine::UniformLoopOp loop) {
    if (loop.getBody().empty())
      return;
    Block &body = loop.getBody().front();
    DenseSet<Value> seenInits;
    for (auto [init, arg, result] : llvm::zip_equal(
             loop.getInits(), body.getArguments(), loop.getResults())) {
      addAliasEdge(arg, result, 0);
      if (seenInits.insert(init).second)
        addAliasEdge(init, arg, 0);
    }
    auto cont = dyn_cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
    if (!cont)
      return;
    for (auto [arg, carry] :
         llvm::zip_equal(body.getArguments(), cont.getCarries()))
      addAliasEdge(arg, carry, 0);
  }

  void collectRegionAliases(Operation *op, TypeID typeId) {
    if (typeId == TypeID::get<waveamdmachine::UniformLoopOp>()) {
      auto loop = cast<waveamdmachine::UniformLoopOp>(op);
      collectLoopCarryAliases(loop);
      return;
    }
    if (typeId == TypeID::get<waveamdmachine::UniformIfOp>()) {
      auto uniformIf = cast<waveamdmachine::UniformIfOp>(op);
      collectYieldAliases(uniformIf.getResults(), uniformIf.getThenRegion());
      collectYieldAliases(uniformIf.getResults(), uniformIf.getElseRegion());
      return;
    }
    if (typeId == TypeID::get<waveamdmachine::ExecIfOp>()) {
      auto execIf = cast<waveamdmachine::ExecIfOp>(op);
      collectYieldAliases(execIf.getResults(), execIf.getThenRegion());
      collectYieldAliases(execIf.getResults(), execIf.getElseRegion());
    }
  }

  void collectUses() {
    for (RegAllocAliasOp &record : ops) {
      for (Value operand : record.op->getOperands()) {
        extendValue(operand, record.position);
        collectExternalLoopBodyUse(operand, record.enclosingLoop);
      }
    }
    extendExternalLoopUses();
  }

  void collectAliases() {
    for (RegAllocAliasOp &record : ops) {
      collectTupleAliases(record.op, record.typeId);
      collectMMAAliases(record.op);
      collectRequiredKilledOperandAliases(record.op);
      collectRegionAliases(record.op, record.typeId);
    }
  }

  void collectUsesAndAliases() {
    collectUses();
    collectAliases();
  }

  LogicalResult addAliasAdjacencyEdge(RegAllocAliasEdge edge,
                                      AliasAdjacency &adjacency) {
    if (edge.lhs == edge.rhs) {
      if (edge.delta != 0)
        return func.emitError("regalloc alias state offset conflict");
      return success();
    }
    adjacency[edge.lhs].push_back({edge.rhs, edge.delta});
    adjacency[edge.rhs].push_back({edge.lhs, -edge.delta});
    return success();
  }

  LogicalResult buildAliasAdjacency(AliasAdjacency &adjacency) {
    for (RegAllocAliasEdge edge : edges)
      if (failed(addAliasAdjacencyEdge(edge, adjacency)))
        return failure();
    return success();
  }

  void normalizeAliasOffsets(RegAllocAliasSet &set, ArrayRef<int64_t> offsets) {
    int64_t minOffset = 0;
    for (unsigned member : set.members)
      minOffset = std::min(minOffset, offsets[member]);
    for (unsigned member : set.members)
      values[member].offset = offsets[member] - minOffset;
  }

  LogicalResult
  enqueueAliasNeighbor(unsigned current, unsigned next, int64_t delta,
                       SmallVectorImpl<unsigned> &worklist, BitVector &visited,
                       SmallVectorImpl<int64_t> &offsets, unsigned setId) {
    int64_t nextOffset = offsets[current] + delta;
    if (visited[next]) {
      if (offsets[next] != nextOffset)
        return func.emitError("regalloc alias state offset conflict");
      return success();
    }
    visited[next] = true;
    offsets[next] = nextOffset;
    values[next].aliasSet = setId;
    worklist.push_back(next);
    return success();
  }

  LogicalResult visitAliasSet(unsigned root, const AliasAdjacency &adjacency,
                              BitVector &visited,
                              SmallVectorImpl<int64_t> &offsets) {
    unsigned setId = aliasSets.size();
    RegAllocAliasSet set;
    set.id = setId;
    SmallVector<unsigned> worklist;
    worklist.push_back(root);
    visited[root] = true;
    values[root].aliasSet = setId;
    for (unsigned cursor = 0; cursor < worklist.size(); ++cursor) {
      unsigned current = worklist[cursor];
      set.members.push_back(current);
      for (auto [next, delta] : adjacency[current])
        if (failed(enqueueAliasNeighbor(current, next, delta, worklist, visited,
                                        offsets, setId)))
          return failure();
    }
    normalizeAliasOffsets(set, offsets);
    aliasSets.push_back(set);
    return success();
  }

  LogicalResult assignAliasSets() {
    AliasAdjacency adjacency(values.size());
    if (failed(buildAliasAdjacency(adjacency)))
      return failure();

    BitVector visited(values.size());
    SmallVector<int64_t> offsets(values.size(), 0);
    for (unsigned root : llvm::seq<unsigned>(0, values.size()))
      if (!visited[root] &&
          failed(visitAliasSet(root, adjacency, visited, offsets)))
        return failure();
    return success();
  }

  Attribute getI64(int64_t value) { return builder.getI64IntegerAttr(value); }

  DictionaryAttr getDictionary(ArrayRef<NamedAttribute> attrs) {
    return builder.getDictionaryAttr(attrs);
  }

  struct PackedStateStorage {
    SmallVector<int64_t> opRecords;
    SmallVector<int64_t> opPaths;
    SmallVector<int64_t> valueRecords;
    SmallVector<int64_t> valuePaths;
    SmallVector<int64_t> valueRanges;
    SmallVector<int64_t> aliasSetRecords;
    SmallVector<int64_t> aliasMembers;
  };

  void reservePackedState(PackedStateStorage &packed) {
    packed.opRecords.reserve(ops.size() *
                             wave::RegAllocStateAttr::OpFieldCount);
    packed.valueRecords.reserve(values.size() *
                                wave::RegAllocStateAttr::ValueFieldCount);
    packed.aliasSetRecords.reserve(aliasSets.size() *
                                   wave::RegAllocStateAttr::AliasSetFieldCount);
  }

  void packOps(PackedStateStorage &packed) {
    for (auto [index, record] : llvm::enumerate(ops)) {
      assert(record.id == index && record.position == index &&
             "regalloc op IDs must match slab order");
      std::array<int64_t, wave::RegAllocStateAttr::OpFieldCount> row{};
      row[wave::RegAllocStateAttr::OpPathBegin] = packed.opPaths.size();
      row[wave::RegAllocStateAttr::OpPathLength] = record.path.size();
      packed.opPaths.append(record.path.begin(), record.path.end());
      packed.opRecords.append(row.begin(), row.end());
    }
  }

  void packValues(PackedStateStorage &packed) {
    for (auto [index, record] : llvm::enumerate(values)) {
      assert(record.id == index && record.offset >= 0 &&
             "regalloc value metadata must be packable");
      std::array<int64_t, wave::RegAllocStateAttr::ValueFieldCount> row{};
      row[wave::RegAllocStateAttr::ValueRegClass] =
          packRegAllocClass(record.type.getRegClass());
      row[wave::RegAllocStateAttr::ValueKind] =
          record.blockArgument ? wave::RegAllocStateAttr::PackedBlockArgument
                               : wave::RegAllocStateAttr::PackedOpResult;
      row[wave::RegAllocStateAttr::ValueFixed] = record.type.getIndex();
      row[wave::RegAllocStateAttr::ValueSet] = record.aliasSet;
      row[wave::RegAllocStateAttr::ValueStart] = record.start;
      row[wave::RegAllocStateAttr::ValueEnd] = record.end;
      row[wave::RegAllocStateAttr::ValueWidth] = record.type.getWidth();
      row[wave::RegAllocStateAttr::ValueOffset] = record.offset;
      row[wave::RegAllocStateAttr::ValueNumber] = record.number;
      row[wave::RegAllocStateAttr::ValuePathBegin] = packed.valuePaths.size();
      row[wave::RegAllocStateAttr::ValuePathLength] = record.path.size();
      row[wave::RegAllocStateAttr::ValueRangeBegin] =
          packed.valueRanges.size() / wave::RegAllocStateAttr::RangeFieldCount;
      row[wave::RegAllocStateAttr::ValueRangeCount] = record.ranges.size();
      packed.valuePaths.append(record.path.begin(), record.path.end());
      for (wave::RegAllocTransformLiveRange range : record.ranges) {
        std::array<int64_t, wave::RegAllocStateAttr::RangeFieldCount>
            rangeRow{};
        rangeRow[wave::RegAllocStateAttr::RangeStart] = range.start;
        rangeRow[wave::RegAllocStateAttr::RangeEnd] = range.end;
        packed.valueRanges.append(rangeRow.begin(), rangeRow.end());
      }
      packed.valueRecords.append(row.begin(), row.end());
    }
  }

  void packAliasSets(PackedStateStorage &packed) {
    for (auto [index, set] : llvm::enumerate(aliasSets)) {
      assert(set.id == index && !set.members.empty() &&
             "regalloc alias-set IDs must match slab order");
      waveamdmachine::RegClass regClass =
          values[set.members.front()].type.getRegClass();
      int64_t width = 0;
      std::array<int64_t, wave::RegAllocStateAttr::AliasSetFieldCount> row{};
      row[wave::RegAllocStateAttr::AliasSetRegClass] =
          packRegAllocClass(regClass);
      row[wave::RegAllocStateAttr::AliasSetMemberBegin] =
          packed.aliasMembers.size();
      row[wave::RegAllocStateAttr::AliasSetMemberCount] = set.members.size();
      for (unsigned member : set.members) {
        const RegAllocAliasValue &value = values[member];
        assert(value.aliasSet == index &&
               value.type.getRegClass() == regClass &&
               "regalloc alias member metadata must match set");
        packed.aliasMembers.push_back(member);
        width = std::max(width, value.offset + value.type.getWidth());
      }
      row[wave::RegAllocStateAttr::AliasSetWidth] = width;
      packed.aliasSetRecords.append(row.begin(), row.end());
    }
  }

  wave::RegAllocStateAttr buildPackedAttr() {
    PackedStateStorage packed;
    reservePackedState(packed);
    packOps(packed);
    packValues(packed);
    packAliasSets(packed);
    return wave::RegAllocStateAttr::get(
        builder.getContext(), wave::RegAllocStateAttr::kVersion,
        packed.opRecords, packed.opPaths, packed.valueRecords,
        packed.valuePaths, packed.valueRanges, packed.aliasSetRecords,
        packed.aliasMembers);
  }

  DictionaryAttr buildDebugAttr() {
    SmallVector<NamedAttribute> attrs;
    attrs.emplace_back(builder.getStringAttr("alias_edges"),
                       getI64(edges.size()));
    attrs.emplace_back(builder.getStringAttr("alias_sets"),
                       getI64(aliasSets.size()));
    attrs.emplace_back(builder.getStringAttr("ops"), getI64(ops.size()));
    attrs.emplace_back(builder.getStringAttr("values"), getI64(values.size()));
    return getDictionary(attrs);
  }

  DictionaryAttr buildAttr() {
    SmallVector<NamedAttribute> attrs;
    attrs.emplace_back(builder.getStringAttr("debug"), buildDebugAttr());
    attrs.emplace_back(builder.getStringAttr("epoch"), getI64(0));
    attrs.emplace_back(builder.getStringAttr("iteration"), getI64(0));
    attrs.emplace_back(
        builder.getStringAttr(wave::getRegAllocTransformPackedStateFieldName()),
        buildPackedAttr());
    attrs.emplace_back(builder.getStringAttr("stage"),
                       builder.getStringAttr("alias-state"));
    return getDictionary(attrs);
  }

  SmallVector<wave::RegAllocTransformAliasSet>
  buildDecodedAliasSets(ArrayRef<wave::RegAllocTransformValue> decodedValues) {
    SmallVector<wave::RegAllocTransformAliasSet> setsById;
    setsById.reserve(aliasSets.size());
    SmallVector<unsigned> setsPerStart(ops.size() + 1);
    for (RegAllocAliasSet &record : aliasSets) {
      assert(record.id == setsById.size() &&
             "alias set IDs must match slab order");
      wave::RegAllocTransformAliasSet set;
      set.members = std::move(record.members);
      set.regClass = decodedValues[set.members.front()].regClass;
      set.id = record.id;
      set.start = std::numeric_limits<unsigned>::max();
      for (unsigned valueId : set.members) {
        const wave::RegAllocTransformValue &value = decodedValues[valueId];
        set.start = std::min(set.start, value.start);
        set.end = std::max(set.end, value.end);
        set.width = std::max(set.width, value.offset + value.width);
      }
      wave::collectRegAllocTransformAliasSetLiveRanges(set, decodedValues);
      assert(set.start < setsPerStart.size() &&
             "alias set start must name an operation position");
      ++setsPerStart[set.start];
      setsById.push_back(std::move(set));
    }
    unsigned offset = 0;
    for (unsigned &count : setsPerStart) {
      unsigned next = offset + count;
      count = offset;
      offset = next;
    }
    SmallVector<unsigned> setOrder(setsById.size());
    for (auto [index, set] : llvm::enumerate(setsById))
      setOrder[setsPerStart[set.start]++] = index;
    SmallVector<wave::RegAllocTransformAliasSet> decodedSets;
    decodedSets.reserve(setsById.size());
    for (unsigned index : setOrder)
      decodedSets.push_back(std::move(setsById[index]));
    return decodedSets;
  }

  std::unique_ptr<wave::regalloc_detail::RegAllocTransformDecodedState>
  buildDecodedState() {
    using wave::regalloc_detail::RegAllocTransformDecodedState;
    std::unique_ptr<RegAllocTransformDecodedState> decoded =
        std::make_unique<RegAllocTransformDecodedState>();
    decoded->values.reserve(values.size());
    for (RegAllocAliasValue &record : values) {
      wave::RegAllocTransformValue value;
      value.path = std::move(record.path);
      value.ranges = std::move(record.ranges);
      value.regClass = record.type.getRegClass();
      value.kind = record.blockArgument
                       ? wave::RegAllocTransformValueKind::BlockArgument
                       : wave::RegAllocTransformValueKind::OpResult;
      if (record.type.getIndex() >= 0)
        value.fixed = record.type.getIndex();
      value.id = record.id;
      value.set = record.aliasSet;
      value.start = record.start;
      value.end = record.end;
      value.width = record.type.getWidth();
      value.offset = static_cast<unsigned>(record.offset);
      value.number = record.number;
      decoded->values.push_back(std::move(value));
    }

    decoded->sets = buildDecodedAliasSets(decoded->values);

    decoded->resolvedValues.reserve(decoded->values.size());
    for (unsigned id : llvm::seq<unsigned>(0, decoded->values.size())) {
      Value value = payloadValues[id];
      const wave::RegAllocTransformValue *stateValue = &decoded->values[id];
      decoded->resolvedValues.push_back({value, stateValue});
      decoded->valueLookup[value] = stateValue;
    }
    return decoded;
  }

  SmallVector<RegAllocAliasOp> ops;
  SmallVector<RegAllocAliasValue> values;
  SmallVector<RegAllocAliasEdge> edges;
  SmallVector<RegAllocAliasSet> aliasSets;
  SmallVector<Value> payloadValues;
  DenseMap<Value, unsigned> externalLoopUseEnds;
  DenseMap<Operation *, Operation *> parentUniformLoops;
  DenseMap<Operation *, unsigned> positions;
  DenseMap<Value, unsigned> valueIds;
  std::optional<llvm::AMDGPU::IsaVersion> killedOperandReuseIsa;
  func::FuncOp func;
  Builder &builder;
  bool coalesceMFMAAccResult = true;
  bool killedOperandReuseIsaFailed = false;
};

struct RegAllocScanFailure {
  SmallVector<wave::RegAllocTransformAssignment> overlaps;
  waveamdmachine::RegClass regClass;
  StringRef className;
  StringRef reason = "pressure";
  StringRef budgetMode = "default";
  unsigned set = 0;
  unsigned position = 0;
  unsigned pressure = 0;
  unsigned limit = 0;
  unsigned request = 0;
};

static bool
assignedRangesOverlap(const wave::RegAllocTransformAssignment &assignment,
                      unsigned base, unsigned width) {
  unsigned end = base + width;
  unsigned assignedEnd = assignment.base + assignment.width;
  return base < assignedEnd && assignment.base < end;
}

static bool liveRangesOverlap(unsigned lhsStart, unsigned lhsEnd,
                              unsigned rhsStart, unsigned rhsEnd) {
  return lhsStart <= rhsEnd && rhsStart <= lhsEnd;
}

static bool liveRangesOverlap(const wave::RegAllocTransformLiveRange &lhs,
                              const wave::RegAllocTransformLiveRange &rhs) {
  return liveRangesOverlap(lhs.start, lhs.end, rhs.start, rhs.end);
}

static bool
liveRangesContainPosition(ArrayRef<wave::RegAllocTransformLiveRange> ranges,
                          unsigned position) {
  auto it =
      llvm::lower_bound(ranges, position,
                        [](wave::RegAllocTransformLiveRange range,
                           unsigned position) { return range.end < position; });
  return it != ranges.end() && it->start <= position;
}

static bool
liveRangesOverlapRange(ArrayRef<wave::RegAllocTransformLiveRange> ranges,
                       unsigned start, unsigned end) {
  auto it = llvm::lower_bound(ranges, start,
                              [](wave::RegAllocTransformLiveRange range,
                                 unsigned start) { return range.end < start; });
  return it != ranges.end() && it->start <= end;
}

static bool
liveRangeListsOverlap(ArrayRef<wave::RegAllocTransformLiveRange> lhs,
                      ArrayRef<wave::RegAllocTransformLiveRange> rhs) {
  unsigned lhsIndex = 0;
  unsigned rhsIndex = 0;
  while (lhsIndex < lhs.size() && rhsIndex < rhs.size()) {
    wave::RegAllocTransformLiveRange lhsRange = lhs[lhsIndex];
    wave::RegAllocTransformLiveRange rhsRange = rhs[rhsIndex];
    if (liveRangesOverlap(lhsRange, rhsRange))
      return true;
    if (lhsRange.end < rhsRange.start)
      ++lhsIndex;
    else
      ++rhsIndex;
  }
  return false;
}

static bool valueRangeEndsAt(const wave::RegAllocTransformValue &value,
                             unsigned position) {
  return llvm::any_of(value.ranges,
                      [&](wave::RegAllocTransformLiveRange range) {
                        return range.end == position;
                      });
}

static bool aliasSetLiveAtPosition(const wave::RegAllocTransformAliasSet &set,
                                   unsigned position) {
  return liveRangesContainPosition(set.ranges, position);
}

static bool aliasSetOverlapsRange(const wave::RegAllocTransformAliasSet &set,
                                  unsigned start, unsigned end) {
  return liveRangesOverlapRange(set.ranges, start, end);
}

static bool isVGPRFamilyClass(waveamdmachine::RegClass regClass) {
  return regClass == waveamdmachine::RegClass::VGPR ||
         regClass == waveamdmachine::RegClass::AGPR;
}

static constexpr unsigned kRegClassCount = 5;

static constexpr std::array<waveamdmachine::RegClass, kRegClassCount>
    kRegClasses = {
        waveamdmachine::RegClass::SGPR, waveamdmachine::RegClass::VGPR,
        waveamdmachine::RegClass::AGPR, waveamdmachine::RegClass::SCC,
        waveamdmachine::RegClass::VCC};

static unsigned getRegClassIndex(waveamdmachine::RegClass regClass) {
  unsigned index = static_cast<unsigned>(regClass);
  assert(index < kRegClassCount && "unknown register class");
  return index;
}

static unsigned getCombinedVGPRFamilyPressure(unsigned agprFootprint,
                                              unsigned vgprFootprint) {
  return agprFootprint + llvm::alignTo(vgprFootprint, 4);
}

using ResolvedRegAllocValue = wave::regalloc_detail::ResolvedRegAllocValue;

struct PendingRegAllocAssignment {
  Value payloadValue;
  Type assignedType;
};

struct RegAllocTransformFailure {
  SmallVector<wave::RegAllocTransformAssignment> overlaps;
  StringRef className;
  StringRef reason;
  unsigned set = 0;
  unsigned position = 0;
};

struct RegAllocFailureKind {
  StringRef className;
  StringRef reason;
};

static void collectRegAllocOpPositions(Region &region,
                                       DenseMap<Operation *, unsigned> &ops) {
  for (Block &block : region) {
    for (Operation &op : block) {
      ops[&op] = ops.size();
      for (Region &nested : op.getRegions())
        collectRegAllocOpPositions(nested, ops);
    }
  }
}

using ReservedLaneUses = SmallVector<std::optional<unsigned>, 8>;

static void noteReservedLaneUse(ReservedLaneUses &lastUses, unsigned lane,
                                unsigned position) {
  if (lane >= lastUses.size())
    return;
  std::optional<unsigned> &lastUse = lastUses[lane];
  lastUse = lastUse ? std::max(*lastUse, position) : position;
}

static void noteReservedSpanUse(ReservedLaneUses &lastUses, unsigned begin,
                                unsigned width, unsigned position) {
  for (unsigned lane : llvm::seq<unsigned>(begin, begin + width))
    noteReservedLaneUse(lastUses, lane, position);
}

static std::optional<std::pair<unsigned, unsigned>>
parseSGPRSpan(StringRef text) {
  text = text.trim();
  if (!text.consume_front("s"))
    return std::nullopt;
  if (text.consume_front("[")) {
    StringRef beginText;
    StringRef endText;
    std::tie(beginText, text) = text.split(':');
    std::tie(endText, text) = text.split(']');
    if (beginText.empty() || endText.empty() || !text.empty())
      return std::nullopt;
    unsigned begin = 0;
    unsigned end = 0;
    if (beginText.getAsInteger(10, begin) || endText.getAsInteger(10, end) ||
        end < begin)
      return std::nullopt;
    return std::make_pair(begin, end - begin + 1);
  }
  unsigned reg = 0;
  if (text.getAsInteger(10, reg))
    return std::nullopt;
  return std::make_pair(reg, 1);
}

static std::optional<StringRef> getSLoadBase(Operation *op) {
  if (auto load = dyn_cast<waveamdmachine::SLoadB32Op>(op))
    return load.getBase();
  if (auto load = dyn_cast<waveamdmachine::SLoadB64Op>(op))
    return load.getBase();
  if (auto load = dyn_cast<waveamdmachine::SLoadB128Op>(op))
    return load.getBase();
  return std::nullopt;
}

static unsigned
getOperationEnd(Operation *op, const DenseMap<Operation *, unsigned> &positions,
                DenseMap<Operation *, unsigned> &endCache) {
  auto cached = endCache.find(op);
  if (cached != endCache.end())
    return cached->second;
  unsigned end = positions.lookup(op);
  op->walk([&](Operation *nested) {
    auto it = positions.find(nested);
    if (it != positions.end())
      end = std::max(end, it->second);
  });
  endCache[op] = end;
  return end;
}

static unsigned
getImplicitABIUseEnd(Operation *op,
                     const DenseMap<Operation *, unsigned> &positions,
                     DenseMap<Operation *, unsigned> &endCache) {
  unsigned end = positions.lookup(op);
  for (Operation *parent = op->getParentOp(); parent;
       parent = parent->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(parent))
      end = std::max(end, getOperationEnd(parent, positions, endCache));
  return end;
}

static void noteImplicitSGPRABIUse(
    Operation *op, const DenseMap<Operation *, unsigned> &positions,
    DenseMap<Operation *, unsigned> &endCache,
    const wave::WaveAMDKernelEntryRegs &regs, ReservedLaneUses &sgprLastUses) {
  std::optional<StringRef> base = getSLoadBase(op);
  bool isPreload = isa<waveamdmachine::KernargPreloadOp>(op);
  if (!base && !isPreload)
    return;
  unsigned end = getImplicitABIUseEnd(op, positions, endCache);
  if (base) {
    if (std::optional<std::pair<unsigned, unsigned>> span =
            parseSGPRSpan(*base))
      noteReservedSpanUse(sgprLastUses, span->first, span->second, end);
  }
  if (isPreload)
    noteReservedSpanUse(sgprLastUses, regs.kernargSegmentPtrSGPR,
                        regs.kernargSegmentPtrWidth, end);
}

static std::optional<unsigned>
getKernargPreloadBase(waveamdmachine::KernargPreloadOp op,
                      waveamdmachine::RegType type,
                      const wave::WaveAMDKernelEntryRegs &regs) {
  if (type.getRegClass() != waveamdmachine::RegClass::SGPR)
    return std::nullopt;
  uint64_t dwordOffset = op.getDwordOffset();
  if (dwordOffset < regs.kernargPreloadOffsetDwords)
    return std::nullopt;
  uint64_t preloadOffset = dwordOffset - regs.kernargPreloadOffsetDwords;
  if (preloadOffset + static_cast<uint64_t>(type.getWidth()) >
      regs.kernargPreloadDwords)
    return std::nullopt;
  return regs.kernargSegmentPtrWidth + static_cast<unsigned>(preloadOffset);
}

static std::optional<unsigned> getWorkitemIdAxis(Operation *op) {
  if (isa<waveamdmachine::VWorkitemIdXOp>(op))
    return 0;
  if (isa<waveamdmachine::VWorkitemIdYOp>(op))
    return 1;
  if (isa<waveamdmachine::VWorkitemIdZOp>(op))
    return 2;
  return std::nullopt;
}

static std::optional<unsigned>
getEntryRegFixedBase(Value value, const wave::WaveAMDKernelEntryRegs &regs) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return std::nullopt;
  auto type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getRegClass() == waveamdmachine::RegClass::VGPR)
    if (std::optional<unsigned> axis = getWorkitemIdAxis(def))
      return regs.workitemIdVGPR(*axis);
  if (type.getRegClass() != waveamdmachine::RegClass::SGPR)
    return std::nullopt;
  if (isa<waveamdmachine::SWorkgroupIdXOp>(def))
    return regs.workgroupIdSGPR(0);
  if (isa<waveamdmachine::SWorkgroupIdYOp>(def))
    return regs.workgroupIdSGPR(1);
  if (isa<waveamdmachine::SWorkgroupIdZOp>(def))
    return regs.workgroupIdSGPR(2);
  if (auto preload = dyn_cast<waveamdmachine::KernargPreloadOp>(def))
    return getKernargPreloadBase(preload, type, regs);
  return std::nullopt;
}

static LogicalResult refreshFuncTypeFromBody(func::FuncOp func) {
  if (func.isDeclaration())
    return success();
  SmallVector<Type> inputs(func.getBody().front().getArgumentTypes());
  SmallVector<Type> outputs;
  bool haveReturn = false;
  WalkResult walk = func.walk([&](func::ReturnOp ret) {
    SmallVector<Type> current(ret.getOperandTypes());
    if (!haveReturn) {
      outputs = std::move(current);
      haveReturn = true;
      return WalkResult::advance();
    }
    if (outputs != current)
      return WalkResult::interrupt();
    return WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return func.emitError("regalloc linear scan saw inconsistent return types");
  if (!haveReturn)
    outputs.assign(func.getFunctionType().getResults().begin(),
                   func.getFunctionType().getResults().end());
  func.setType(FunctionType::get(func.getContext(), inputs, outputs));
  return success();
}

class RegAllocLinearScanner {
public:
  RegAllocLinearScanner(func::FuncOp func, Builder &builder,
                        const RegAllocTransformDecodedState &decoded)
      : values(decoded.values), sets(decoded.sets),
        resolvedValues(decoded.resolvedValues),
        valueLookup(&decoded.valueLookup), func(func), builder(builder) {}

  LogicalResult run() {
    if (failed(parseState()))
      return failure();
    if (scanFailure) {
      func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
      setState(buildFailureState());
      return success();
    }
    if (failed(scan()))
      return failure();
    if (scanFailure) {
      func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
      setState(buildFailureState());
      return success();
    }
    checkCombinedFootprintFailure();
    if (scanFailure) {
      func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
      setState(buildFailureState());
      return success();
    }
    if (failed(applyAssignments()))
      return failure();
    func->setAttr(wave::getRegAllocTransformAssignmentsAttrName(),
                  builder.getUnitAttr());
    setState(buildSuccessState());
    return success();
  }

private:
  struct ActiveAssignments {
    using LaneAssignments = SmallVector<unsigned, 4>;
    using ClassLaneAssignments = SmallVector<LaneAssignments, 64>;

    SmallVector<unsigned> ordered;
    SmallVector<unsigned> byEnd;
    std::array<SmallVector<unsigned>, kRegClassCount> byClass;
    std::array<ClassLaneAssignments, kRegClassCount> byClassLane;
    BitVector live;
    DenseMap<unsigned, unsigned> bySet;
    mutable SmallVector<unsigned> queryMarks;
    unsigned stale = 0;
    mutable unsigned queryGeneration = 1;

    static bool
    endHeapCompare(ArrayRef<wave::RegAllocTransformAssignment> assignments,
                   unsigned lhs, unsigned rhs) {
      const wave::RegAllocTransformAssignment &lhsAssignment = assignments[lhs];
      const wave::RegAllocTransformAssignment &rhsAssignment = assignments[rhs];
      return std::tie(lhsAssignment.end, lhsAssignment.set) >
             std::tie(rhsAssignment.end, rhsAssignment.set);
    }

    bool isLive(unsigned assignmentIndex) const {
      return assignmentIndex < live.size() && live[assignmentIndex];
    }

    void add(unsigned assignmentIndex,
             ArrayRef<wave::RegAllocTransformAssignment> assignments) {
      const wave::RegAllocTransformAssignment &assignment =
          assignments[assignmentIndex];
      ordered.push_back(assignmentIndex);
      unsigned classIndex = getRegClassIndex(assignment.regClass);
      byClass[classIndex].push_back(assignmentIndex);
      ClassLaneAssignments &lanes = byClassLane[classIndex];
      unsigned end = assignment.base + assignment.width;
      if (end > lanes.size())
        lanes.resize(end);
      for (unsigned lane : llvm::seq<unsigned>(assignment.base, end))
        lanes[lane].push_back(assignmentIndex);
      if (assignmentIndex >= live.size())
        live.resize(assignmentIndex + 1, false);
      live.set(assignmentIndex);
      bySet[assignment.set] = assignmentIndex;
      byEnd.push_back(assignmentIndex);
      std::push_heap(byEnd.begin(), byEnd.end(),
                     [&](unsigned lhs, unsigned rhs) {
                       return endHeapCompare(assignments, lhs, rhs);
                     });
    }

    void expire(unsigned position,
                ArrayRef<wave::RegAllocTransformAssignment> assignments) {
      while (!byEnd.empty()) {
        unsigned assignmentIndex = byEnd.front();
        const wave::RegAllocTransformAssignment &assignment =
            assignments[assignmentIndex];
        if (assignment.end >= position)
          break;
        std::pop_heap(byEnd.begin(), byEnd.end(),
                      [&](unsigned lhs, unsigned rhs) {
                        return endHeapCompare(assignments, lhs, rhs);
                      });
        assignmentIndex = byEnd.pop_back_val();
        auto it = bySet.find(assignments[assignmentIndex].set);
        if (it == bySet.end() || it->second != assignmentIndex)
          continue;
        bySet.erase(it);
        live.reset(assignmentIndex);
        ++stale;
      }
      if (stale > bySet.size())
        compact(assignments);
    }

    void compact(ArrayRef<wave::RegAllocTransformAssignment> assignments) {
      eraseInactive(ordered, assignments);
      for (SmallVector<unsigned> &classAssignments : byClass)
        eraseInactive(classAssignments, assignments);
      for (ClassLaneAssignments &classLanes : byClassLane)
        for (LaneAssignments &laneAssignments : classLanes)
          eraseInactive(laneAssignments, assignments);
      stale = 0;
    }

    void eraseInactive(
        SmallVectorImpl<unsigned> &indices,
        ArrayRef<wave::RegAllocTransformAssignment> assignments) const {
      llvm::erase_if(indices, [&](unsigned assignmentIndex) {
        return !isLive(assignmentIndex);
      });
    }

    const wave::RegAllocTransformAssignment *
    lookup(unsigned setId,
           ArrayRef<wave::RegAllocTransformAssignment> assignments) const {
      auto it = bySet.find(setId);
      if (it == bySet.end())
        return nullptr;
      return &assignments[it->second];
    }

    bool contains(unsigned setId) const { return bySet.contains(setId); }

    void startQuery() const {
      ++queryGeneration;
      if (queryGeneration != 0)
        return;
      std::fill(queryMarks.begin(), queryMarks.end(), 0);
      queryGeneration = 1;
    }

    bool markFirstVisit(unsigned assignmentIndex) const {
      if (assignmentIndex >= queryMarks.size())
        queryMarks.resize(assignmentIndex + 1, 0);
      if (queryMarks[assignmentIndex] == queryGeneration)
        return false;
      queryMarks[assignmentIndex] = queryGeneration;
      return true;
    }

    template <typename Fn>
    void forOrdered(ArrayRef<wave::RegAllocTransformAssignment> assignments,
                    Fn &&fn) const {
      for (unsigned assignmentIndex : ordered)
        if (isLive(assignmentIndex))
          fn(assignments[assignmentIndex]);
    }

    template <typename Fn>
    void forRegClass(waveamdmachine::RegClass regClass,
                     ArrayRef<wave::RegAllocTransformAssignment> assignments,
                     Fn &&fn) const {
      for (unsigned assignmentIndex : byClass[getRegClassIndex(regClass)])
        if (isLive(assignmentIndex))
          fn(assignments[assignmentIndex]);
    }

    template <typename Predicate>
    bool anyRegClass(waveamdmachine::RegClass regClass,
                     ArrayRef<wave::RegAllocTransformAssignment> assignments,
                     Predicate &&predicate) const {
      for (unsigned assignmentIndex : byClass[getRegClassIndex(regClass)]) {
        if (!isLive(assignmentIndex))
          continue;
        if (predicate(assignments[assignmentIndex]))
          return true;
      }
      return false;
    }

    template <typename Predicate>
    bool anyRegClassOverlappingRange(
        waveamdmachine::RegClass regClass, unsigned base, unsigned width,
        ArrayRef<wave::RegAllocTransformAssignment> assignments,
        Predicate &&predicate) const {
      const ClassLaneAssignments &lanes =
          byClassLane[getRegClassIndex(regClass)];
      if (base >= lanes.size())
        return false;
      unsigned end = std::min<unsigned>(base + width, lanes.size());
      startQuery();
      for (unsigned lane : llvm::seq<unsigned>(base, end)) {
        for (unsigned assignmentIndex : lanes[lane]) {
          if (!isLive(assignmentIndex) || !markFirstVisit(assignmentIndex))
            continue;
          if (predicate(assignments[assignmentIndex]))
            return true;
        }
      }
      return false;
    }
  };

  struct CombinedFootprintTracker {
    struct ActiveRange {
      unsigned footprint = 0;
      unsigned end = 0;
      unsigned sequence = 0;
    };

    struct FutureRange {
      waveamdmachine::RegClass regClass;
      unsigned footprint = 0;
      unsigned start = 0;
      unsigned end = 0;
      unsigned sequence = 0;
    };

    static unsigned getFamilyIndex(waveamdmachine::RegClass regClass) {
      assert(isVGPRFamilyClass(regClass) && "expected VGPR-family class");
      return regClass == waveamdmachine::RegClass::AGPR ? 0 : 1;
    }

    static bool activeRangeLess(const ActiveRange &lhs,
                                const ActiveRange &rhs) {
      return std::tie(lhs.footprint, lhs.end, lhs.sequence) <
             std::tie(rhs.footprint, rhs.end, rhs.sequence);
    }

    static bool futureRangeLess(const FutureRange &lhs,
                                const FutureRange &rhs) {
      return std::tie(lhs.start, lhs.sequence) >
             std::tie(rhs.start, rhs.sequence);
    }

    void advance(unsigned position) {
      assert((!currentPosition || position >= *currentPosition) &&
             "combined footprint scan must be monotonic");
      currentPosition = position;
      while (!futureRanges.empty() && futureRanges.front().start <= position) {
        std::pop_heap(futureRanges.begin(), futureRanges.end(),
                      futureRangeLess);
        FutureRange range = futureRanges.pop_back_val();
        if (range.end >= position)
          addActive(range);
      }
      for (SmallVector<ActiveRange> &ranges : activeRanges)
        while (!ranges.empty() && ranges.front().end < position) {
          std::pop_heap(ranges.begin(), ranges.end(), activeRangeLess);
          ranges.pop_back();
        }
    }

    void add(const wave::RegAllocTransformAliasSet &set, unsigned base) {
      if (!isVGPRFamilyClass(set.regClass))
        return;
      assert(currentPosition && "combined footprint position is unset");
      for (wave::RegAllocTransformLiveRange liveRange : set.ranges) {
        if (liveRange.end < *currentPosition)
          continue;
        FutureRange range{set.regClass, base + set.width, liveRange.start,
                          liveRange.end, nextSequence++};
        if (liveRange.start <= *currentPosition) {
          addActive(range);
          continue;
        }
        futureRanges.push_back(range);
        std::push_heap(futureRanges.begin(), futureRanges.end(),
                       futureRangeLess);
      }
    }

    unsigned get(waveamdmachine::RegClass regClass) const {
      const SmallVector<ActiveRange> &ranges =
          activeRanges[getFamilyIndex(regClass)];
      return ranges.empty() ? 0 : ranges.front().footprint;
    }

  private:
    void addActive(const FutureRange &range) {
      SmallVector<ActiveRange> &ranges =
          activeRanges[getFamilyIndex(range.regClass)];
      ranges.push_back({range.footprint, range.end, range.sequence});
      std::push_heap(ranges.begin(), ranges.end(), activeRangeLess);
    }

    std::array<SmallVector<ActiveRange>, 2> activeRanges;
    SmallVector<FutureRange> futureRanges;
    std::optional<unsigned> currentPosition;
    unsigned nextSequence = 0;
  };

  struct FixedReservations {
    SmallVector<wave::RegAllocTransformAssignment> reservations;
    std::array<SmallVector<unsigned>, kRegClassCount> byClass;

    unsigned size() const { return reservations.size(); }

    void push_back(wave::RegAllocTransformAssignment reservation) {
      unsigned index = reservations.size();
      reservations.push_back(reservation);
      byClass[getRegClassIndex(reservation.regClass)].push_back(index);
    }

    template <typename Fn>
    void forRegClass(waveamdmachine::RegClass regClass, Fn &&fn) const {
      for (unsigned index : byClass[getRegClassIndex(regClass)])
        fn(reservations[index]);
    }

    template <typename Predicate>
    bool anyRegClass(waveamdmachine::RegClass regClass,
                     Predicate &&predicate) const {
      for (unsigned index : byClass[getRegClassIndex(regClass)])
        if (predicate(reservations[index]))
          return true;
      return false;
    }
  };

  struct ReusableInputBase {
    unsigned base = 0;
    unsigned sourceSet = 0;
  };

  LogicalResult parseState() {
    state = func->getAttrOfType<DictionaryAttr>(
        wave::getRegAllocTransformStateAttrName());
    if (!state)
      return func.emitError("regalloc linear scan requires alias state");

    if (failed(buildSetIndex()))
      return failure();
    if (failed(collectResolvedValues()))
      return failure();
    FailureOr<std::optional<wave::RegAllocTransformBudget>> familyBudget =
        wave::getRegAllocTransformVGPRFamilyBudget(func);
    if (failed(familyBudget))
      return failure();
    vgprFamilyBudget = *familyBudget;
    if (failed(computeFixedBases()))
      return failure();
    if (failed(collectFixedHardwareReadSets()))
      return failure();
    collectFixedReservations();
    if (failed(collectEntryABIReservations()))
      return failure();
    collectImplicitABIReservations();
    return success();
  }

  LogicalResult buildSetIndex() {
    setIndexById.clear();
    sparseSetIndexById.clear();
    if (sets.empty())
      return success();

    unsigned maxSetId = 0;
    for (const wave::RegAllocTransformAliasSet &set : sets)
      maxSetId = std::max(maxSetId, set.id);

    constexpr unsigned kInvalidSetIndex = std::numeric_limits<unsigned>::max();
    if (maxSetId <= sets.size() * 4) {
      setIndexById.assign(maxSetId + 1, kInvalidSetIndex);
      for (auto [index, set] : llvm::enumerate(sets)) {
        unsigned &entry = setIndexById[set.id];
        if (entry != kInvalidSetIndex)
          return func.emitError("regalloc state has duplicate alias set id");
        entry = static_cast<unsigned>(index);
      }
      return success();
    }

    for (auto [index, set] : llvm::enumerate(sets)) {
      auto inserted =
          sparseSetIndexById.insert({set.id, static_cast<unsigned>(index)});
      if (!inserted.second)
        return func.emitError("regalloc state has duplicate alias set id");
    }
    return success();
  }

  LogicalResult collectResolvedValues() {
    if (resolvedValues.size() != values.size())
      return func.emitError("regalloc decoded value count is invalid");
    payloadValues.resize(values.size());
    for (auto [payloadValue, stateValue] : resolvedValues) {
      if (stateValue->id >= payloadValues.size())
        return func.emitError("regalloc decoded value id is invalid");
      payloadValues[stateValue->id] = payloadValue;
    }
    return success();
  }

  LogicalResult computeFixedBases() {
    fixedBases.resize(sets.size());
    for (auto [index, set] : llvm::enumerate(sets))
      if (failed(computeFixedBase(set, index)))
        return failure();
    return success();
  }

  LogicalResult computeFixedBase(const wave::RegAllocTransformAliasSet &set,
                                 unsigned setIndex) {
    std::optional<unsigned> &fixedBase = fixedBases[setIndex];
    for (unsigned valueId : set.members) {
      const wave::RegAllocTransformValue &value = values[valueId];
      if (!value.fixed)
        continue;
      if (*value.fixed < value.offset)
        return recordFixedFailure(set, "fixed-underflow");
      unsigned base = *value.fixed - value.offset;
      if (fixedBase && *fixedBase != base)
        return recordFixedFailure(set, "fixed-conflict");
      fixedBase = base;
    }
    return success();
  }

  std::optional<unsigned>
  getFixedBase(const wave::RegAllocTransformAliasSet &set) const {
    assert(&set >= sets.begin() && &set < sets.end() &&
           "alias set must belong to decoded state");
    return fixedBases[&set - sets.begin()];
  }

  LogicalResult collectFixedHardwareReadSets() {
    for (const wave::RegAllocTransformAliasSet &set : sets) {
      if (!getFixedBase(set) || set.members.size() != 1)
        continue;
      unsigned valueId = set.members.front();
      Value payloadValue = payloadValues[valueId];
      if (isFixedHardwareRead(payloadValue))
        fixedHardwareReadValues[set.id] = payloadValue;
    }
    return success();
  }

  void collectFixedReservations() {
    for (const wave::RegAllocTransformAliasSet &set : sets) {
      std::optional<unsigned> fixedBase = getFixedBase(set);
      if (!fixedBase)
        continue;
      wave::RegAllocTransformBudget budget = getBudget(set.regClass);
      if (*fixedBase + set.width <= budget.limit)
        fixedReservations.push_back(
            {set.regClass, set.id, *fixedBase, set.width, set.start, set.end});
    }
  }

  LogicalResult collectEntryABIReservations() {
    wave::WaveAMDKernelEntryRegs regs = wave::getWaveAMDKernelEntryRegs(func);
    if (regs.reservedSGPRs == 0 && regs.reservedVGPRs == 0)
      return success();

    DenseMap<Operation *, unsigned> positions;
    collectRegAllocOpPositions(func.getBody(), positions);
    DenseMap<Operation *, unsigned> endCache;
    for (const wave::RegAllocTransformValue &stateValue : values) {
      if (!stateValue.fixed)
        continue;
      Value value = payloadValues[stateValue.id];
      std::optional<unsigned> base = getEntryRegFixedBase(value, regs);
      if (!base)
        continue;
      unsigned end = stateValue.end;
      if (isFixedHardwareRead(value))
        end = std::max(end, getImplicitABIUseEnd(value.getDefiningOp(),
                                                 positions, endCache));
      unsigned setId = sets.size() + fixedReservations.size();
      fixedReservations.push_back({stateValue.regClass, setId, *base,
                                   stateValue.width, /*start=*/0, end});
    }
    return success();
  }

  void collectImplicitABIReservations() {
    wave::WaveAMDKernelEntryRegs regs = wave::getWaveAMDKernelEntryRegs(func);
    ReservedLaneUses sgprLastUses(regs.reservedSGPRs);
    if (sgprLastUses.empty())
      return;

    DenseMap<Operation *, unsigned> positions;
    collectRegAllocOpPositions(func.getBody(), positions);
    DenseMap<Operation *, unsigned> endCache;
    for (auto &entry : positions)
      noteImplicitSGPRABIUse(entry.first, positions, endCache, regs,
                             sgprLastUses);

    for (auto [lane, lastUse] : llvm::enumerate(sgprLastUses)) {
      if (!lastUse)
        continue;
      unsigned setId = sets.size() + fixedReservations.size();
      fixedReservations.push_back({waveamdmachine::RegClass::SGPR, setId,
                                   static_cast<unsigned>(lane),
                                   /*width=*/1, /*start=*/0, *lastUse});
    }
  }

  LogicalResult recordFixedFailure(const wave::RegAllocTransformAliasSet &set,
                                   StringRef reason) {
    wave::RegAllocTransformBudget budget = getBudget(set.regClass);
    RegAllocScanFailure failed;
    failed.regClass = set.regClass;
    failed.reason = reason;
    failed.budgetMode = budget.mode;
    failed.set = set.id;
    failed.position = set.start;
    failed.pressure = set.width;
    failed.limit = budget.limit;
    failed.request = set.width;
    scanFailure = std::move(failed);
    return success();
  }

  LogicalResult scan() {
    for (const wave::RegAllocTransformAliasSet &set : sets) {
      expireInactive(set.start);
      if (vgprFamilyBudget)
        combinedFootprints.advance(set.start);
      if (failed(allocateSet(set)))
        return failure();
      if (scanFailure)
        return success();
    }
    return success();
  }

  void expireInactive(unsigned position) {
    active.expire(position, assignments);
  }

  LogicalResult allocateSet(const wave::RegAllocTransformAliasSet &set) {
    startSetConflictQuery();
    wave::RegAllocTransformBudget budget = getBudget(set.regClass);
    if (getFixedBase(set))
      return allocateFixedSet(set, budget);
    std::optional<ReusableInputBase> reusableBase =
        findReusableInputBase(set, budget.limit);
    std::optional<unsigned> beforeBase;
    if (reusableBase)
      beforeBase = reusableBase->base;
    std::optional<unsigned> base = findFreeBase(set, budget.limit, beforeBase);
    if (!base && reusableBase)
      base = reusableBase->base;
    if (!base) {
      recordPressureFailure(set, budget, getFixedReservationOverlaps(set));
      return success();
    }
    if (checkCombinedPressureFailure(set, *base))
      return success();
    addAssignment(set, *base);
    return success();
  }

  wave::RegAllocTransformBudget getBudget(waveamdmachine::RegClass regClass) {
    unsigned index = getRegClassIndex(regClass);
    if (!budgetCache[index]) {
      wave::RegAllocTransformBudget budget =
          wave::getRegAllocTransformBudget(func, regClass);
      budgetCache[index] = budget;
      return budget;
    }
    return *budgetCache[index];
  }

  LogicalResult allocateFixedSet(const wave::RegAllocTransformAliasSet &set,
                                 wave::RegAllocTransformBudget budget) {
    unsigned fixedBase = *getFixedBase(set);
    bool conflict = conflictsWithActive(set, fixedBase);
    if (conflict) {
      std::optional<ReusableInputBase> reusableBase =
          findReusableInputBase(set, budget.limit);
      conflict = !reusableBase || reusableBase->base != fixedBase;
    }
    if (fixedBase + set.width > budget.limit || conflict) {
      recordPressureFailure(set, budget);
      return success();
    }
    if (checkCombinedPressureFailure(set, fixedBase))
      return success();
    addAssignment(set, fixedBase);
    return success();
  }

  std::optional<unsigned>
  findFreeBase(const wave::RegAllocTransformAliasSet &set, unsigned limit,
               std::optional<unsigned> beforeBase = std::nullopt) {
    if (set.width > limit)
      return std::nullopt;
    unsigned maxBase = limit - set.width;
    if (beforeBase) {
      if (*beforeBase == 0)
        return std::nullopt;
      maxBase = std::min(maxBase, *beforeBase - 1);
    }
    unsigned align = std::max<unsigned>(1, llvm::PowerOf2Ceil(set.width));
    for (unsigned base = 0; base <= maxBase; base += align)
      if (!conflictsWithActive(set, base) &&
          !conflictsWithFixedReservation(set, base))
        return base;
    return std::nullopt;
  }

  static bool isAlignedBase(unsigned base, unsigned width) {
    unsigned align = std::max<unsigned>(1, llvm::PowerOf2Ceil(width));
    return base % align == 0;
  }

  const wave::RegAllocTransformValue *
  getSingleResultValue(const wave::RegAllocTransformAliasSet &set) {
    if (set.members.size() != 1)
      return nullptr;
    const wave::RegAllocTransformValue &value = values[set.members.front()];
    if (value.kind != wave::RegAllocTransformValueKind::OpResult ||
        value.start != set.start || value.offset != 0 ||
        value.width != set.width)
      return nullptr;
    return &value;
  }

  const wave::RegAllocTransformAssignment *getActiveAssignment(unsigned setId) {
    return active.lookup(setId, assignments);
  }

  const llvm::AMDGPU::IsaVersion *getKilledOperandReuseIsa(Operation *op) {
    if (killedOperandReuseIsa)
      return &*killedOperandReuseIsa;
    if (killedOperandReuseIsaFailed)
      return nullptr;
    FailureOr<llvm::AMDGPU::IsaVersion> isa =
        waveamdmachine::getAMDGPUTargetIsaVersion(
            op, "waveamd regalloc killed operand reuse");
    if (failed(isa)) {
      killedOperandReuseIsaFailed = true;
      return nullptr;
    }
    killedOperandReuseIsa = *isa;
    return &*killedOperandReuseIsa;
  }

  std::optional<ReusableInputBase>
  findReusableInputBaseForDef(const wave::RegAllocTransformAliasSet &set,
                              unsigned limit, Operation *def) {
    waveamdmachine::KilledOperandReuseOpInterface reuse =
        wave::regalloc_detail::getKilledOperandReuseCandidate(def);
    if (!reuse)
      return std::nullopt;
    const llvm::AMDGPU::IsaVersion *targetIsa = getKilledOperandReuseIsa(def);
    if (!targetIsa)
      return std::nullopt;

    std::optional<ReusableInputBase> bestBase;
    for (OpOperand &operand : def->getOpOperands()) {
      if (!wave::regalloc_detail::canReuseKilledOperandForResult(reuse, operand,
                                                                 *targetIsa))
        continue;
      auto it = valueLookup->find(operand.get());
      if (it == valueLookup->end())
        continue;
      std::optional<ReusableInputBase> base =
          getReusableOperandBase(set, *it->second, limit);
      if (!base)
        continue;
      if (!bestBase || base->base < bestBase->base)
        bestBase = *base;
    }
    return bestBase;
  }

  std::optional<ReusableInputBase>
  findReusableInputBase(const wave::RegAllocTransformAliasSet &set,
                        unsigned limit) {
    const wave::RegAllocTransformValue *resultValue = getSingleResultValue(set);
    if (!resultValue || resultValue->id >= payloadValues.size() ||
        set.width > limit)
      return std::nullopt;
    Operation *def = payloadValues[resultValue->id].getDefiningOp();
    return findReusableInputBaseForDef(set, limit, def);
  }

  bool
  reusableOperandMatchesSet(const wave::RegAllocTransformAliasSet &set,
                            const wave::RegAllocTransformValue &sourceValue) {
    return sourceValue.set != set.id && sourceValue.regClass == set.regClass &&
           sourceValue.width == set.width;
  }

  bool
  reusableOperandCoversResult(const wave::RegAllocTransformAliasSet &set,
                              const wave::RegAllocTransformAliasSet &sourceSet,
                              const wave::RegAllocTransformValue &sourceValue) {
    return valueRangeEndsAt(sourceValue, set.start) &&
           sourceValue.offset + set.width <= sourceSet.width &&
           sourceSubrangeDiesAtBoundary(set, sourceSet, sourceValue);
  }

  bool sourceSubrangeDiesAtBoundary(
      const wave::RegAllocTransformAliasSet &set,
      const wave::RegAllocTransformAliasSet &sourceSet,
      const wave::RegAllocTransformValue &sourceValue) {
    int64_t begin = sourceValue.offset;
    int64_t end = begin + static_cast<int64_t>(set.width);
    for (unsigned memberId : sourceSet.members) {
      const wave::RegAllocTransformValue &member = values[memberId];
      int64_t memberEnd = member.offset + static_cast<int64_t>(member.width);
      if (end <= member.offset || memberEnd <= begin)
        continue;
      if (memberBlocksReusableResult(set, member))
        return false;
    }
    return true;
  }

  bool memberBlocksReusableResult(const wave::RegAllocTransformAliasSet &set,
                                  const wave::RegAllocTransformValue &member) {
    unsigned memberIndex = 0;
    unsigned setIndex = 0;
    while (memberIndex < member.ranges.size() && setIndex < set.ranges.size()) {
      wave::RegAllocTransformLiveRange memberRange = member.ranges[memberIndex];
      wave::RegAllocTransformLiveRange setRange = set.ranges[setIndex];
      if (liveRangesOverlap(memberRange, setRange) &&
          std::min(memberRange.end, setRange.end) > set.start) {
        unsigned overlapStart = std::max(memberRange.start, setRange.start);
        unsigned overlapEnd = std::min(memberRange.end, setRange.end);
        if (overlapStart != set.end || overlapEnd != set.end ||
            !isDestructiveResultContinuation(set, member))
          return true;
      }
      if (memberRange.end < setRange.start)
        ++memberIndex;
      else
        ++setIndex;
    }
    return false;
  }

  bool
  isDestructiveResultContinuation(const wave::RegAllocTransformAliasSet &set,
                                  const wave::RegAllocTransformValue &member) {
    const wave::RegAllocTransformValue *resultValue = getSingleResultValue(set);
    if (!resultValue || resultValue->id >= payloadValues.size() ||
        member.id >= payloadValues.size() ||
        member.kind != wave::RegAllocTransformValueKind::OpResult ||
        member.start != set.end)
      return false;
    Value result = payloadValues[resultValue->id];
    Value continuation = payloadValues[member.id];
    Operation *def = continuation.getDefiningOp();
    if (!def || !llvm::is_contained(def->getResults(), continuation))
      return false;
    for (OpOperand &operand : def->getOpOperands())
      if (operand.get() == result)
        return wave::regalloc_detail::canReuseKilledOperandForResult(def,
                                                                     operand);
    return false;
  }

  bool reusableBaseIsAvailable(
      const wave::RegAllocTransformAliasSet &set,
      const wave::RegAllocTransformAliasSet &sourceSet,
      const wave::RegAllocTransformAssignment &sourceAssignment, unsigned base,
      unsigned limit) {
    if (base + set.width > limit)
      return false;
    if (!isAlignedBase(base, set.width))
      return false;
    if (conflictsWithActiveIgnoring(set, base, sourceSet.id))
      return false;
    if (conflictsWithFixedReservationIgnoring(set, base, sourceAssignment))
      return false;
    return true;
  }

  std::optional<ReusableInputBase>
  getReusableOperandBase(const wave::RegAllocTransformAliasSet &set,
                         const wave::RegAllocTransformValue &sourceValue,
                         unsigned limit) {
    if (!reusableOperandMatchesSet(set, sourceValue))
      return std::nullopt;
    const wave::RegAllocTransformAliasSet *sourceSet =
        getSetById(sourceValue.set);
    if (!sourceSet)
      return std::nullopt;
    const wave::RegAllocTransformAssignment *sourceAssignment =
        getActiveAssignment(sourceSet->id);
    if (!sourceAssignment)
      return std::nullopt;
    if (!reusableOperandCoversResult(set, *sourceSet, sourceValue))
      return std::nullopt;

    unsigned base = sourceAssignment->base + sourceValue.offset;
    if (!reusableBaseIsAvailable(set, *sourceSet, *sourceAssignment, base,
                                 limit))
      return std::nullopt;
    return ReusableInputBase{base, sourceSet->id};
  }

  bool conflictsWithActive(const wave::RegAllocTransformAliasSet &set,
                           unsigned base) {
    return active.anyRegClassOverlappingRange(
        set.regClass, base, set.width, assignments,
        [&](const wave::RegAllocTransformAssignment &assigned) {
          if (!assignedRangesOverlap(assigned, base, set.width) ||
              !activeAssignmentConflicts(set, assigned, base))
            return false;
          return !canShareFixedHardwareRead(set, assigned, base);
        });
  }

  bool conflictsWithActiveIgnoring(const wave::RegAllocTransformAliasSet &set,
                                   unsigned base, unsigned ignoredSetId) {
    return active.anyRegClassOverlappingRange(
        set.regClass, base, set.width, assignments,
        [&](const wave::RegAllocTransformAssignment &assigned) {
          if (assigned.set == ignoredSetId)
            return false;
          if (!assignedRangesOverlap(assigned, base, set.width) ||
              !activeAssignmentConflicts(set, assigned, base))
            return false;
          return !canShareFixedHardwareRead(set, assigned, base);
        });
  }

  bool setLiveAtPosition(unsigned setId, unsigned position) {
    const wave::RegAllocTransformAliasSet *set = getSetById(setId);
    if (!set)
      return true;
    return aliasSetLiveAtPosition(*set, position);
  }

  const wave::RegAllocTransformAliasSet *getSetById(unsigned setId) {
    if (setId < setIndexById.size()) {
      unsigned index = setIndexById[setId];
      if (index == std::numeric_limits<unsigned>::max())
        return nullptr;
      assert(index < sets.size() && "alias set index out of range");
      return &sets[index];
    }
    auto it = sparseSetIndexById.find(setId);
    if (it == sparseSetIndexById.end())
      return nullptr;
    assert(it->second < sets.size() && "alias set index out of range");
    return &sets[it->second];
  }

  bool
  activeAssignmentConflicts(const wave::RegAllocTransformAliasSet &set,
                            const wave::RegAllocTransformAssignment &assigned,
                            unsigned base) {
    const wave::RegAllocTransformAliasSet *assignedSet =
        getSetById(assigned.set);
    if (!assignedSet)
      return setOverlapsRange(set, assigned.start, assigned.end);

    int64_t setBegin = base;
    int64_t setEnd = setBegin + static_cast<int64_t>(set.width);
    for (unsigned memberId : assignedSet->members) {
      const wave::RegAllocTransformValue &member = values[memberId];
      int64_t memberBegin = assigned.base + member.offset;
      int64_t memberEnd = memberBegin + static_cast<int64_t>(member.width);
      if (setEnd <= memberBegin || memberEnd <= setBegin)
        continue;
      if (memberConflictsWithSet(set, member))
        return true;
    }
    return false;
  }

  void startSetConflictQuery() {
    ++memberConflictGeneration;
    if (memberConflictGeneration != 0)
      return;
    std::fill(memberConflictGenerations.begin(),
              memberConflictGenerations.end(), 0);
    memberConflictGeneration = 1;
  }

  bool memberConflictsWithSet(const wave::RegAllocTransformAliasSet &set,
                              const wave::RegAllocTransformValue &member) {
    if (member.id >= memberConflictGenerations.size()) {
      memberConflictGenerations.resize(member.id + 1, 0);
      memberConflicts.resize(member.id + 1, false);
    }
    if (memberConflictGenerations[member.id] == memberConflictGeneration)
      return memberConflicts[member.id];
    memberConflictGenerations[member.id] = memberConflictGeneration;
    bool conflict = liveRangeListsOverlap(member.ranges, set.ranges) &&
                    !memberOverlapIsDestructiveContinuation(set, member);
    memberConflicts[member.id] = conflict;
    return conflict;
  }

  bool memberOverlapIsDestructiveContinuation(
      const wave::RegAllocTransformAliasSet &set,
      const wave::RegAllocTransformValue &member) {
    bool sawOverlap = false;
    unsigned memberIndex = 0;
    unsigned setIndex = 0;
    while (memberIndex < member.ranges.size() && setIndex < set.ranges.size()) {
      wave::RegAllocTransformLiveRange memberRange = member.ranges[memberIndex];
      wave::RegAllocTransformLiveRange setRange = set.ranges[setIndex];
      if (liveRangesOverlap(memberRange, setRange)) {
        sawOverlap = true;
        unsigned overlapStart = std::max(memberRange.start, setRange.start);
        unsigned overlapEnd = std::min(memberRange.end, setRange.end);
        if (overlapStart != set.end || overlapEnd != set.end)
          return false;
      }
      if (memberRange.end < setRange.start)
        ++memberIndex;
      else
        ++setIndex;
    }
    return sawOverlap && isDestructiveResultContinuation(set, member);
  }

  bool setOverlapsRange(const wave::RegAllocTransformAliasSet &set,
                        unsigned start, unsigned end) {
    return aliasSetOverlapsRange(set, start, end);
  }

  bool
  canShareFixedHardwareRead(const wave::RegAllocTransformAliasSet &set,
                            const wave::RegAllocTransformAssignment &assigned,
                            unsigned base) {
    std::optional<unsigned> fixedBase = getFixedBase(set);
    if (!fixedBase || *fixedBase != base || assigned.base != base ||
        assigned.width != set.width)
      return false;
    auto lhs = fixedHardwareReadValues.find(set.id);
    auto rhs = fixedHardwareReadValues.find(assigned.set);
    if (lhs == fixedHardwareReadValues.end() ||
        rhs == fixedHardwareReadValues.end())
      return false;
    return areEquivalentFixedHardwareReads(lhs->second, rhs->second);
  }

  bool conflictsWithFixedReservation(const wave::RegAllocTransformAliasSet &set,
                                     unsigned base) {
    return fixedReservations.anyRegClass(
        set.regClass, [&](const wave::RegAllocTransformAssignment &reserved) {
          if (!assignedRangesOverlap(reserved, base, set.width))
            return false;
          return setOverlapsRange(set, reserved.start, reserved.end);
        });
  }

  bool reservationCoveredByIgnoredSource(
      const wave::RegAllocTransformAssignment &reserved,
      const wave::RegAllocTransformAssignment &ignored) {
    return reserved.regClass == ignored.regClass &&
           reserved.base <= ignored.base &&
           ignored.base + ignored.width <= reserved.base + reserved.width &&
           reserved.end == ignored.end;
  }

  bool conflictsWithFixedReservationIgnoring(
      const wave::RegAllocTransformAliasSet &set, unsigned base,
      const wave::RegAllocTransformAssignment &ignored) {
    return fixedReservations.anyRegClass(
        set.regClass, [&](const wave::RegAllocTransformAssignment &reserved) {
          bool overlaps = assignedRangesOverlap(reserved, base, set.width);
          if (!overlaps)
            return false;
          if (reserved.set == ignored.set ||
              reservationCoveredByIgnoredSource(reserved, ignored))
            return false;
          return setOverlapsRange(set, reserved.start, reserved.end);
        });
  }

  bool hasActiveAssignment(unsigned setId) { return active.contains(setId); }

  SmallVector<wave::RegAllocTransformAssignment>
  getFixedReservationOverlaps(const wave::RegAllocTransformAliasSet &set) {
    SmallVector<wave::RegAllocTransformAssignment> overlaps;
    fixedReservations.forRegClass(
        set.regClass, [&](const wave::RegAllocTransformAssignment &reserved) {
          if (reserved.set == set.id || hasActiveAssignment(reserved.set))
            return;
          if (setOverlapsRange(set, reserved.start, reserved.end))
            overlaps.push_back(reserved);
        });
    return overlaps;
  }

  static void addFamilyFootprint(waveamdmachine::RegClass regClass,
                                 unsigned base, unsigned width,
                                 unsigned &agprFootprint,
                                 unsigned &vgprFootprint) {
    if (regClass == waveamdmachine::RegClass::AGPR)
      agprFootprint = std::max(agprFootprint, base + width);
    if (regClass == waveamdmachine::RegClass::VGPR)
      vgprFootprint = std::max(vgprFootprint, base + width);
  }

  bool checkCombinedPressureFailure(const wave::RegAllocTransformAliasSet &set,
                                    unsigned base) {
    if (!vgprFamilyBudget || !isVGPRFamilyClass(set.regClass))
      return false;
    unsigned agprFootprint =
        combinedFootprints.get(waveamdmachine::RegClass::AGPR);
    unsigned vgprFootprint =
        combinedFootprints.get(waveamdmachine::RegClass::VGPR);
    addFamilyFootprint(set.regClass, base, set.width, agprFootprint,
                       vgprFootprint);
    unsigned pressure =
        getCombinedVGPRFamilyPressure(agprFootprint, vgprFootprint);
    if (pressure <= vgprFamilyBudget->limit)
      return false;
    SmallVector<wave::RegAllocTransformAssignment> overlaps;
    active.forOrdered(assignments,
                      [&](const wave::RegAllocTransformAssignment &assigned) {
                        overlaps.push_back(assigned);
                      });
    recordCombinedPressureFailure(set, pressure, overlaps);
    return true;
  }

  void checkCombinedFootprintFailure() {
    if (!vgprFamilyBudget)
      return;
    unsigned agprFootprint = 0;
    unsigned vgprFootprint = 0;
    for (const wave::RegAllocTransformAssignment &assigned : assignments) {
      if (!isVGPRFamilyClass(assigned.regClass))
        continue;
      addFamilyFootprint(assigned.regClass, assigned.base, assigned.width,
                         agprFootprint, vgprFootprint);
      unsigned pressure =
          getCombinedVGPRFamilyPressure(agprFootprint, vgprFootprint);
      if (pressure <= vgprFamilyBudget->limit)
        continue;
      SmallVector<wave::RegAllocTransformAssignment> priorAssignments;
      for (const wave::RegAllocTransformAssignment &other : assignments) {
        if (&other == &assigned)
          break;
        if (isVGPRFamilyClass(other.regClass))
          priorAssignments.push_back(other);
      }
      recordCombinedPressureFailure(assigned, pressure, priorAssignments,
                                    "allocated-footprint");
      return;
    }
  }

  void addAssignment(const wave::RegAllocTransformAliasSet &set,
                     unsigned base) {
    wave::RegAllocTransformAssignment assigned{
        set.regClass, set.id, base, set.width, set.start, set.end};
    unsigned assignmentIndex = assignments.size();
    assignments.push_back(assigned);
    assignmentIndexBySet[set.id] = assignmentIndex;
    active.add(assignmentIndex, assignments);
    if (vgprFamilyBudget)
      combinedFootprints.add(set, base);
  }

  unsigned getPressureAtFailure(
      const wave::RegAllocTransformAliasSet &set,
      ArrayRef<wave::RegAllocTransformAssignment> fixedOverlaps) {
    unsigned pressure = set.width;
    active.forRegClass(set.regClass, assignments,
                       [&](const wave::RegAllocTransformAssignment &assigned) {
                         if (!setLiveAtPosition(assigned.set, set.start))
                           return;
                         pressure += assigned.width;
                       });
    for (const wave::RegAllocTransformAssignment &reserved : fixedOverlaps)
      pressure += reserved.width;
    return pressure;
  }

  void recordPressureFailure(
      const wave::RegAllocTransformAliasSet &set,
      wave::RegAllocTransformBudget budget,
      ArrayRef<wave::RegAllocTransformAssignment> fixedOverlaps = {}) {
    RegAllocScanFailure failed;
    failed.regClass = set.regClass;
    failed.reason = "pressure";
    failed.budgetMode = budget.mode;
    failed.set = set.id;
    failed.position = set.start;
    failed.pressure = getPressureAtFailure(set, fixedOverlaps);
    failed.limit = budget.limit;
    failed.request = set.width;
    active.forRegClass(set.regClass, assignments,
                       [&](const wave::RegAllocTransformAssignment &assigned) {
                         if (!setLiveAtPosition(assigned.set, set.start))
                           return;
                         failed.overlaps.push_back(assigned);
                       });
    failed.overlaps.append(fixedOverlaps.begin(), fixedOverlaps.end());
    scanFailure = std::move(failed);
  }

  void recordCombinedPressureFailure(
      const wave::RegAllocTransformAliasSet &set, unsigned pressure,
      ArrayRef<wave::RegAllocTransformAssignment> overlaps,
      StringRef reason = "pressure") {
    RegAllocScanFailure failed;
    failed.regClass = set.regClass;
    failed.className = "vgpr_agpr";
    failed.reason = reason;
    failed.budgetMode = vgprFamilyBudget->mode;
    failed.set = set.id;
    failed.position = set.start;
    failed.pressure = pressure;
    failed.limit = vgprFamilyBudget->limit;
    failed.request = set.width;
    for (const wave::RegAllocTransformAssignment &assigned : overlaps)
      if (isVGPRFamilyClass(assigned.regClass))
        failed.overlaps.push_back(assigned);
    scanFailure = std::move(failed);
  }

  void recordCombinedPressureFailure(
      const wave::RegAllocTransformAssignment &assignment, unsigned pressure,
      ArrayRef<wave::RegAllocTransformAssignment> overlaps, StringRef reason) {
    RegAllocScanFailure failed;
    failed.regClass = assignment.regClass;
    failed.className = "vgpr_agpr";
    failed.reason = reason;
    failed.budgetMode = vgprFamilyBudget->mode;
    failed.set = assignment.set;
    failed.position = assignment.start;
    failed.pressure = pressure;
    failed.limit = vgprFamilyBudget->limit;
    failed.request = assignment.width;
    for (const wave::RegAllocTransformAssignment &assigned : overlaps)
      if (isVGPRFamilyClass(assigned.regClass))
        failed.overlaps.push_back(assigned);
    scanFailure = std::move(failed);
  }

  LogicalResult applyAssignments() {
    FailureOr<SmallVector<PendingRegAllocAssignment>> pendingAssignments =
        buildPendingAssignments();
    if (failed(pendingAssignments))
      return failure();

    return commitAssignments(*pendingAssignments);
  }

  FailureOr<SmallVector<PendingRegAllocAssignment>> buildPendingAssignments() {
    SmallVector<PendingRegAllocAssignment> pendingAssignments;
    pendingAssignments.reserve(values.size());
    for (const wave::RegAllocTransformValue &value : values) {
      const wave::RegAllocTransformAssignment *assignment =
          getAssignmentBySet(value.set);
      if (!assignment)
        return func.emitError("regalloc assignment map is incomplete");
      Value payloadValue = payloadValues[value.id];
      pendingAssignments.push_back(
          {payloadValue,
           getAssignedValueType(payloadValue, value,
                                assignment->base + value.offset)});
    }
    return pendingAssignments;
  }

  const wave::RegAllocTransformAssignment *
  getAssignmentBySet(unsigned setId) const {
    auto it = assignmentIndexBySet.find(setId);
    if (it == assignmentIndexBySet.end())
      return nullptr;
    assert(it->second < assignments.size() && "assignment index out of range");
    return &assignments[it->second];
  }

  LogicalResult
  commitAssignments(ArrayRef<PendingRegAllocAssignment> pendingAssignments) {
    SmallVector<std::pair<Value, Type>> oldTypes;
    oldTypes.reserve(pendingAssignments.size());
    for (const PendingRegAllocAssignment &pending : pendingAssignments) {
      Value payloadValue = pending.payloadValue;
      oldTypes.push_back({payloadValue, payloadValue.getType()});
      payloadValue.setType(pending.assignedType);
    }
    if (succeeded(refreshFuncTypeFromBody(func)))
      return success();
    for (auto [payloadValue, oldType] : llvm::reverse(oldTypes))
      payloadValue.setType(oldType);
    return failure();
  }

  Type getAssignedValueType(Value payloadValue,
                            const wave::RegAllocTransformValue &value,
                            unsigned index) {
    auto type = cast<waveamdmachine::RegType>(payloadValue.getType());
    return waveamdmachine::RegType::get(type.getContext(), value.regClass,
                                        value.width, index);
  }

  Attribute getI64(int64_t value) { return builder.getI64IntegerAttr(value); }

  DictionaryAttr getDictionary(ArrayRef<NamedAttribute> attrs) {
    return builder.getDictionaryAttr(attrs);
  }

  DictionaryAttr buildFailureAttr() {
    SmallVector<Attribute> overlapAttrs;
    for (const wave::RegAllocTransformAssignment &overlap :
         scanFailure->overlaps)
      overlapAttrs.push_back(
          wave::buildRegAllocTransformAssignmentAttr(builder, overlap));
    SmallVector<NamedAttribute> attrs;
    attrs.emplace_back(builder.getStringAttr("budget_mode"),
                       builder.getStringAttr(scanFailure->budgetMode));
    attrs.emplace_back(
        builder.getStringAttr("class"),
        builder.getStringAttr(
            scanFailure->className.empty()
                ? waveamdmachine::stringifyRegClass(scanFailure->regClass)
                : scanFailure->className));
    attrs.emplace_back(builder.getStringAttr("diagnostics"),
                       buildFailureDiagnostics());
    attrs.emplace_back(builder.getStringAttr("limit"),
                       getI64(scanFailure->limit));
    attrs.emplace_back(builder.getStringAttr("overlaps"),
                       builder.getArrayAttr(overlapAttrs));
    attrs.emplace_back(builder.getStringAttr("position"),
                       getI64(scanFailure->position));
    attrs.emplace_back(builder.getStringAttr("pressure"),
                       getI64(scanFailure->pressure));
    attrs.emplace_back(builder.getStringAttr("reason"),
                       builder.getStringAttr(scanFailure->reason));
    attrs.emplace_back(builder.getStringAttr("request"),
                       getI64(scanFailure->request));
    attrs.emplace_back(builder.getStringAttr("set"), getI64(scanFailure->set));
    return getDictionary(attrs);
  }

  ArrayAttr buildFailureDiagnostics() {
    SmallVector<NamedAttribute> attrs;
    attrs.emplace_back(builder.getStringAttr("event"),
                       builder.getStringAttr(scanFailure->reason));
    attrs.emplace_back(builder.getStringAttr("set"), getI64(scanFailure->set));
    attrs.emplace_back(builder.getStringAttr("position"),
                       getI64(scanFailure->position));
    return builder.getArrayAttr({getDictionary(attrs)});
  }

  DictionaryAttr buildSuccessState() {
    SmallVector<Attribute> assignmentAttrs;
    for (const wave::RegAllocTransformAssignment &assignment : assignments)
      assignmentAttrs.push_back(
          wave::buildRegAllocTransformAssignmentAttr(builder, assignment));
    return rewriteState(
        {builder.getNamedAttr("assignments",
                              builder.getArrayAttr(assignmentAttrs)),
         builder.getNamedAttr("stage",
                              builder.getStringAttr("linear-scan-success"))},
        /*dropFailure=*/true);
  }

  DictionaryAttr buildFailureState() {
    return rewriteState(
        {builder.getNamedAttr("assignments", builder.getArrayAttr({})),
         builder.getNamedAttr("failure", buildFailureAttr()),
         builder.getNamedAttr("stage",
                              builder.getStringAttr("linear-scan-failure"))},
        /*dropFailure=*/true);
  }

  DictionaryAttr rewriteState(ArrayRef<NamedAttribute> replacements,
                              bool dropFailure) {
    SmallVector<NamedAttribute> attrs;
    for (NamedAttribute attr : state) {
      StringRef name = attr.getName().getValue();
      if (name == "assignments" || name == "stage")
        continue;
      if (dropFailure && name == "failure")
        continue;
      attrs.push_back(attr);
    }
    attrs.append(replacements.begin(), replacements.end());
    return builder.getDictionaryAttr(attrs);
  }

  void setState(DictionaryAttr newState) {
    func->setAttr(wave::getRegAllocTransformStateAttrName(), newState);
  }

  ArrayRef<wave::RegAllocTransformValue> values;
  ArrayRef<wave::RegAllocTransformAliasSet> sets;
  ArrayRef<wave::regalloc_detail::ResolvedRegAllocValue> resolvedValues;
  const DenseMap<Value, const wave::RegAllocTransformValue *> *valueLookup;
  SmallVector<Value> payloadValues;
  SmallVector<unsigned> setIndexById;
  SmallVector<unsigned> memberConflictGenerations;
  SmallVector<std::optional<unsigned>> fixedBases;
  FixedReservations fixedReservations;
  ActiveAssignments active;
  CombinedFootprintTracker combinedFootprints;
  BitVector memberConflicts;
  SmallVector<wave::RegAllocTransformAssignment> assignments;
  DenseMap<unsigned, unsigned> sparseSetIndexById;
  DenseMap<unsigned, unsigned> assignmentIndexBySet;
  DenseMap<unsigned, Value> fixedHardwareReadValues;
  std::optional<wave::RegAllocTransformBudget> vgprFamilyBudget;
  std::optional<llvm::AMDGPU::IsaVersion> killedOperandReuseIsa;
  std::array<std::optional<wave::RegAllocTransformBudget>, kRegClassCount>
      budgetCache;
  std::optional<RegAllocScanFailure> scanFailure;
  DictionaryAttr state;
  func::FuncOp func;
  Builder &builder;
  unsigned memberConflictGeneration = 0;
  bool killedOperandReuseIsaFailed = false;
};

static void setMFMAAccumulatorCoalescingFlag(func::FuncOp func,
                                             Builder &builder,
                                             bool coalesceMFMAAccResult) {
  if (coalesceMFMAAccResult) {
    func->removeAttr(wave::regalloc::kRegAllocCoalesceMFMAAccResultAttr);
    return;
  }
  func->setAttr(wave::regalloc::kRegAllocCoalesceMFMAAccResultAttr,
                builder.getBoolAttr(false));
}

static LogicalResult
setRegAllocTransformState(func::FuncOp func, Builder &builder,
                          bool coalesceMFMAAccResult,
                          RegAllocTransformStateCache *cache) {
  if (cache)
    cache->erase(func);
  if (func.isDeclaration()) {
    func->removeAttr(wave::getRegAllocTransformStateAttrName());
    return success();
  }
  setMFMAAccumulatorCoalescingFlag(func, builder, coalesceMFMAAccResult);
  if (!wave::isRegAllocPreparationValid(func)) {
    if (failed(wave::prepareWaveAMDRegAllocIR(func)))
      return failure();
    if (failed(splitOverlappingLoopInits(func)))
      return failure();
    wave::markRegAllocPreparationValid(func);
  }
  RegAllocAliasStateBuilder stateBuilder(func, builder, coalesceMFMAAccResult);
  FailureOr<DictionaryAttr> state = stateBuilder.build(cache);
  if (failed(state))
    return failure();
  func->setAttr(wave::getRegAllocTransformStateAttrName(), *state);
  return success();
}

static LogicalResult runRegAllocLinearScan(func::FuncOp func, Builder &builder,
                                           RegAllocTransformStateCache &cache) {
  if (func.isDeclaration())
    return success();
  FailureOr<const RegAllocTransformDecodedState *> decoded = cache.get(func);
  if (failed(decoded))
    return failure();
  RegAllocLinearScanner scanner(func, builder, **decoded);
  LogicalResult result = scanner.run();
  if (succeeded(result) &&
      func->hasAttr(wave::getRegAllocTransformAssignmentsAttrName()))
    cache.erase(func);
  return result;
}

} // namespace

LogicalResult
wave::buildRegAllocTransformAliasState(Operation *target, Builder &builder,
                                       bool coalesceMFMAAccResult,
                                       RegAllocTransformStateCache *cache) {
  clearRegAllocTransformState(target);
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return setRegAllocTransformState(func, builder, coalesceMFMAAccResult,
                                     cache);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(setRegAllocTransformState(func, builder,
                                            coalesceMFMAAccResult, cache))
               ? WalkResult::interrupt()
               : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}

LogicalResult
wave::runRegAllocTransformLinearScan(Operation *target, Builder &builder,
                                     RegAllocTransformStateCache *cache) {
  RegAllocTransformStateCache localCache;
  if (!cache)
    cache = &localCache;
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return runRegAllocLinearScan(func, builder, *cache);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(runRegAllocLinearScan(func, builder, *cache))
               ? WalkResult::interrupt()
               : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}
