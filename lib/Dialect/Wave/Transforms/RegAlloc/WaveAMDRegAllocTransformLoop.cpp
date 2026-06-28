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
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/MathExtras.h"
#include <array>
#include <limits>
#include <optional>

using namespace mlir;

namespace {

namespace waveTraits = ::mlir::OpTrait::waveamdmachine;

struct RegAllocAliasValue {
  SmallVector<int64_t> path;
  SmallVector<wave::RegAllocTransformLiveRange, 2> ranges;
  waveamdmachine::RegType type;
  unsigned id = 0;
  unsigned start = 0;
  unsigned end = 0;
  unsigned aliasSet = 0;
  unsigned opId = 0;
  unsigned number = 0;
  int64_t offset = 0;
  bool blockArgument = false;
};

struct RegAllocAliasOp {
  SmallVector<int64_t> path;
  Operation *op = nullptr;
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
      waveamdmachine::SWorkgroupIdZOp, waveamdmachine::VWorkitemIdXOp>(def);
}

static bool areEquivalentFixedHardwareReads(Value lhs, Value rhs) {
  if (!isFixedHardwareRead(lhs) || !isFixedHardwareRead(rhs))
    return false;
  if (lhs.getType() != rhs.getType())
    return false;
  return lhs.getDefiningOp()->getName() == rhs.getDefiningOp()->getName();
}

static bool hasNoMemoryEffects(Operation *op) {
  MemoryEffectOpInterface effects = dyn_cast<MemoryEffectOpInterface>(op);
  if (!effects)
    return false;
  SmallVector<MemoryEffects::EffectInstance> instances;
  effects.getEffects(instances);
  return instances.empty();
}

static bool hasSingleTrackedGPRResult(Operation *op) {
  bool found = false;
  for (Value result : op->getResults()) {
    if (!wave::getRegAllocTransformTrackedRegType(result))
      continue;
    if (found)
      return false;
    found = true;
  }
  return found;
}

static bool canReuseKilledOperandForResult(Operation *op) {
  if (!op || op->getNumRegions() != 0)
    return false;
  if (!hasSingleTrackedGPRResult(op))
    return false;
  if (!hasNoMemoryEffects(op))
    return false;
  if (op->hasTrait<waveTraits::NoMachineInst>() ||
      isa<waveamdmachine::MMAOpInterface>(op) ||
      op->hasTrait<waveTraits::MFMAOp>() ||
      op->hasTrait<waveTraits::WritesExecOp>())
    return false;
  return op->hasTrait<waveTraits::VALUOp>() ||
         op->hasTrait<waveTraits::SALUOp>();
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

static Value copyVGPRDuplicate(OpBuilder &builder, Location loc, Value value,
                               waveamdmachine::RegType resultType,
                               waveamdmachine::RegType sourceType) {
  auto copy =
      waveamdmachine::VMovB32TupleOp::create(builder, loc, resultType, value);
  copy->setAttr("registers", builder.getI64IntegerAttr(sourceType.getWidth()));
  return copy.getResult();
}

static Value copySGPRDuplicate(OpBuilder &builder, Location loc, Value value,
                               waveamdmachine::RegType resultType,
                               waveamdmachine::RegType sourceType) {
  auto copy =
      waveamdmachine::SMovB32TupleOp::create(builder, loc, resultType, value);
  copy->setAttr("registers", builder.getI64IntegerAttr(sourceType.getWidth()));
  return copy.getResult();
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
  if (isVGPR(type))
    return copyVGPRDuplicate(builder, loc, value, resultType, type);
  if (isSGPR(type))
    return copySGPRDuplicate(builder, loc, value, resultType, type);
  return emitError(loc, "regalloc transform cannot duplicate register value");
}

static LogicalResult splitDuplicateLoopInits(func::FuncOp func) {
  SmallVector<waveamdmachine::UniformLoopOp> loops;
  func.walk([&](waveamdmachine::UniformLoopOp loop) { loops.push_back(loop); });
  OpBuilder builder(func.getContext());
  for (waveamdmachine::UniformLoopOp loop : loops) {
    DenseSet<Value> seen;
    builder.setInsertionPoint(loop);
    for (auto [index, init] : llvm::enumerate(loop.getInits())) {
      if (!wave::getRegAllocTransformTrackedRegType(init))
        continue;
      if (seen.insert(init).second)
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
  RegAllocAliasStateBuilder(func::FuncOp func, Builder &builder)
      : func(func), builder(builder) {}

  FailureOr<DictionaryAttr> build() {
    collectRegion(func.getBody(), {0});
    collectUsesAndAliases();
    if (failed(assignAliasSets()))
      return failure();
    return buildAttr();
  }

private:
  using AliasAdjacency = SmallVector<SmallVector<std::pair<unsigned, int64_t>>>;

  void registerValue(Value value, unsigned start, ArrayRef<int64_t> path,
                     bool blockArgument, unsigned number, unsigned opId) {
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
    record.opId = opId;
    valueIds[value] = record.id;
    values.push_back(record);
  }

  void collectBlockArguments(Block &block, unsigned start,
                             ArrayRef<int64_t> blockPath) {
    for (BlockArgument arg : block.getArguments())
      registerValue(arg, start, blockPath, /*blockArgument=*/true,
                    arg.getArgNumber(), /*opId=*/0);
  }

  void collectRegion(Region &region, ArrayRef<int64_t> regionPath) {
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
        record.id = ops.size();
        record.position = ops.size();
        positions[&op] = record.position;
        ops.push_back(record);
        for (auto [regionIndex, nested] : llvm::enumerate(op.getRegions())) {
          SmallVector<int64_t> nestedPath(opPath);
          nestedPath.push_back(regionIndex);
          collectRegion(nested, nestedPath);
        }
        for (OpResult result : op.getResults())
          registerValue(result, record.position, opPath,
                        /*blockArgument=*/false, result.getResultNumber(),
                        record.id);
      }
    }
  }

  void extendValue(Value value, unsigned position) {
    auto it = valueIds.find(value);
    if (it == valueIds.end())
      return;
    RegAllocAliasValue &record = values[it->second];
    record.end = std::max(record.end, position);
    if (record.ranges.empty() || position < record.ranges.back().start) {
      record.ranges.push_back({position, position});
      llvm::stable_sort(record.ranges, [](auto lhs, auto rhs) {
        return std::tie(lhs.start, lhs.end) < std::tie(rhs.start, rhs.end);
      });
      return;
    }
    record.ranges.back().end = std::max(record.ranges.back().end, position);
  }

  bool isValueDefinedInside(Operation *scope, Value value) {
    if (Operation *def = value.getDefiningOp())
      return def == scope || scope->isAncestor(def);
    auto arg = cast<BlockArgument>(value);
    Operation *owner = arg.getOwner()->getParentOp();
    return owner && (owner == scope || scope->isAncestor(owner));
  }

  void collectExternalLoopBodyUse(Value operand, Operation *user) {
    if (!valueIds.contains(operand))
      return;
    for (Operation *scope = user->getParentOp(); scope;
         scope = scope->getParentOp()) {
      auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(scope);
      if (!loop || isValueDefinedInside(scope, operand))
        continue;
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

  void collectTupleAliases(Operation *op) {
    auto collect = [&](Value tuple, ValueRange elements) {
      int64_t offset = 0;
      for (Value element : elements) {
        addAliasEdge(tuple, element, offset);
        if (auto type = dyn_cast<waveamdmachine::RegType>(element.getType()))
          offset += type.getWidth();
      }
    };
    if (auto toElements = dyn_cast<waveamdmachine::TupleToElementsOp>(op))
      collect(toElements.getTuple(), toElements.getElements());
    if (auto fromElements = dyn_cast<waveamdmachine::TupleFromElementsOp>(op))
      collect(fromElements.getTuple(), fromElements.getElements());
  }

  bool hasUseAfter(Operation *op, Value value) {
    unsigned position = positions.lookup(op);
    auto externalIt = externalLoopUseEnds.find(value);
    if (externalIt != externalLoopUseEnds.end() &&
        externalIt->second > position)
      return true;
    for (OpOperand &use : value.getUses()) {
      auto it = positions.find(use.getOwner());
      if (it == positions.end() || it->second > position)
        return true;
    }
    return false;
  }

  void collectMMAAliases(Operation *op) {
    auto mma = dyn_cast<waveamdmachine::MMAOpInterface>(op);
    if (!mma || !op->hasTrait<OpTrait::waveamdmachine::MFMAOp>())
      return;
    if (hasUseAfter(op, mma.getAcc()))
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

  void collectRegionAliases(Operation *op) {
    if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op)) {
      collectLoopCarryAliases(loop);
      return;
    }
    if (auto uniformIf = dyn_cast<waveamdmachine::UniformIfOp>(op)) {
      collectYieldAliases(uniformIf.getResults(), uniformIf.getThenRegion());
      collectYieldAliases(uniformIf.getResults(), uniformIf.getElseRegion());
      return;
    }
    if (auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(op)) {
      collectYieldAliases(execIf.getResults(), execIf.getThenRegion());
      collectYieldAliases(execIf.getResults(), execIf.getElseRegion());
    }
  }

  void collectUsesAndAliases() {
    for (RegAllocAliasOp &record : ops) {
      for (Value operand : record.op->getOperands()) {
        extendValue(operand, record.position);
        collectExternalLoopBodyUse(operand, record.op);
      }
      collectTupleAliases(record.op);
      collectMMAAliases(record.op);
      collectRegionAliases(record.op);
    }
    extendExternalLoopUses();
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

  LogicalResult enqueueAliasNeighbor(unsigned current, unsigned next,
                                     int64_t delta,
                                     SmallVectorImpl<unsigned> &worklist,
                                     SmallVectorImpl<bool> &visited,
                                     SmallVectorImpl<int64_t> &offsets,
                                     unsigned setId) {
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
                              SmallVectorImpl<bool> &visited,
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

    SmallVector<bool> visited(values.size(), false);
    SmallVector<int64_t> offsets(values.size(), 0);
    for (unsigned root : llvm::seq<unsigned>(0, values.size()))
      if (!visited[root] &&
          failed(visitAliasSet(root, adjacency, visited, offsets)))
        return failure();
    return success();
  }

  Attribute getI64(int64_t value) { return builder.getI64IntegerAttr(value); }

  ArrayAttr getI64Array(ArrayRef<int64_t> values) {
    return builder.getI64ArrayAttr(values);
  }

  DictionaryAttr getDictionary(ArrayRef<NamedAttribute> attrs) {
    return builder.getDictionaryAttr(attrs);
  }

  DictionaryAttr buildLiveRangeAttr(wave::RegAllocTransformLiveRange range) {
    SmallVector<NamedAttribute> attrs;
    attrs.emplace_back(builder.getStringAttr("end"), getI64(range.end));
    attrs.emplace_back(builder.getStringAttr("start"), getI64(range.start));
    return getDictionary(attrs);
  }

  ArrayAttr
  buildLiveRangeArrayAttr(ArrayRef<wave::RegAllocTransformLiveRange> ranges) {
    SmallVector<Attribute> attrs;
    for (wave::RegAllocTransformLiveRange range : ranges)
      attrs.push_back(buildLiveRangeAttr(range));
    return builder.getArrayAttr(attrs);
  }

  DictionaryAttr buildOpAttr(const RegAllocAliasOp &record) {
    SmallVector<NamedAttribute> attrs;
    attrs.emplace_back(builder.getStringAttr("id"), getI64(record.id));
    attrs.emplace_back(
        builder.getStringAttr("name"),
        builder.getStringAttr(record.op->getName().getStringRef()));
    attrs.emplace_back(builder.getStringAttr("path"), getI64Array(record.path));
    attrs.emplace_back(builder.getStringAttr("position"),
                       getI64(record.position));
    return getDictionary(attrs);
  }

  DictionaryAttr buildValueAttr(const RegAllocAliasValue &record) {
    SmallVector<NamedAttribute> attrs;
    attrs.emplace_back(builder.getStringAttr("class"),
                       builder.getStringAttr(waveamdmachine::stringifyRegClass(
                           record.type.getRegClass())));
    attrs.emplace_back(builder.getStringAttr("end"), getI64(record.end));
    if (record.type.getIndex() >= 0)
      attrs.emplace_back(builder.getStringAttr("fixed"),
                         getI64(record.type.getIndex()));
    attrs.emplace_back(builder.getStringAttr("id"), getI64(record.id));
    attrs.emplace_back(builder.getStringAttr("kind"),
                       builder.getStringAttr(
                           record.blockArgument ? "block_arg" : "op_result"));
    attrs.emplace_back(builder.getStringAttr("number"), getI64(record.number));
    attrs.emplace_back(builder.getStringAttr("offset"), getI64(record.offset));
    if (!record.blockArgument)
      attrs.emplace_back(builder.getStringAttr("op"), getI64(record.opId));
    attrs.emplace_back(builder.getStringAttr("path"), getI64Array(record.path));
    attrs.emplace_back(builder.getStringAttr("ranges"),
                       buildLiveRangeArrayAttr(record.ranges));
    attrs.emplace_back(builder.getStringAttr("set"), getI64(record.aliasSet));
    attrs.emplace_back(builder.getStringAttr("start"), getI64(record.start));
    attrs.emplace_back(builder.getStringAttr("width"),
                       getI64(record.type.getWidth()));
    return getDictionary(attrs);
  }

  DictionaryAttr buildAliasSetAttr(const RegAllocAliasSet &set) {
    SmallVector<wave::RegAllocTransformAliasMember> members;
    int64_t width = 0;
    for (unsigned member : set.members) {
      const RegAllocAliasValue &value = values[member];
      unsigned memberWidth = static_cast<unsigned>(value.type.getWidth());
      members.push_back(
          {value.id, value.start, value.end, memberWidth, value.offset});
      width = std::max<int64_t>(width, value.offset + memberWidth);
    }
    return wave::buildRegAllocTransformAliasSetAttr(
        builder, values[set.members.front()].type.getRegClass(), set.id,
        members, static_cast<unsigned>(width));
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
    SmallVector<Attribute> opAttrs;
    for (const RegAllocAliasOp &record : ops)
      opAttrs.push_back(buildOpAttr(record));
    SmallVector<Attribute> valueAttrs;
    for (const RegAllocAliasValue &record : values)
      valueAttrs.push_back(buildValueAttr(record));
    SmallVector<Attribute> aliasSetAttrs;
    for (const RegAllocAliasSet &set : aliasSets)
      aliasSetAttrs.push_back(buildAliasSetAttr(set));

    SmallVector<NamedAttribute> attrs;
    attrs.emplace_back(builder.getStringAttr("alias_sets"),
                       builder.getArrayAttr(aliasSetAttrs));
    attrs.emplace_back(builder.getStringAttr("debug"), buildDebugAttr());
    attrs.emplace_back(builder.getStringAttr("epoch"), getI64(0));
    attrs.emplace_back(builder.getStringAttr("iteration"), getI64(0));
    attrs.emplace_back(builder.getStringAttr("ops"),
                       builder.getArrayAttr(opAttrs));
    attrs.emplace_back(builder.getStringAttr("stage"),
                       builder.getStringAttr("alias-state"));
    attrs.emplace_back(builder.getStringAttr("values"),
                       builder.getArrayAttr(valueAttrs));
    return getDictionary(attrs);
  }

  SmallVector<RegAllocAliasOp> ops;
  SmallVector<RegAllocAliasValue> values;
  SmallVector<RegAllocAliasEdge> edges;
  SmallVector<RegAllocAliasSet> aliasSets;
  DenseMap<Value, unsigned> externalLoopUseEnds;
  DenseMap<Operation *, unsigned> positions;
  DenseMap<Value, unsigned> valueIds;
  func::FuncOp func;
  Builder &builder;
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

static bool valueLiveAtPosition(const wave::RegAllocTransformValue &value,
                                unsigned position) {
  return llvm::any_of(value.ranges,
                      [&](wave::RegAllocTransformLiveRange range) {
                        return range.start <= position && position <= range.end;
                      });
}

static bool valueOverlapsRange(const wave::RegAllocTransformValue &value,
                               unsigned start, unsigned end) {
  return llvm::any_of(
      value.ranges, [&](wave::RegAllocTransformLiveRange range) {
        return liveRangesOverlap(range.start, range.end, start, end);
      });
}

static bool valueRangesOverlap(const wave::RegAllocTransformValue &lhs,
                               const wave::RegAllocTransformValue &rhs) {
  for (wave::RegAllocTransformLiveRange lhsRange : lhs.ranges)
    for (wave::RegAllocTransformLiveRange rhsRange : rhs.ranges)
      if (liveRangesOverlap(lhsRange, rhsRange))
        return true;
  return false;
}

static bool valueRangeEndsAt(const wave::RegAllocTransformValue &value,
                             unsigned position) {
  return llvm::any_of(value.ranges,
                      [&](wave::RegAllocTransformLiveRange range) {
                        return range.end == position;
                      });
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

static unsigned getCombinedVGPRFamilyPressure(unsigned agprFootprint,
                                              unsigned vgprFootprint) {
  return agprFootprint + llvm::alignTo(vgprFootprint, 4);
}

template <typename T>
static FailureOr<T> failRegAllocStateIdentity(Operation *diagOp) {
  diagOp->emitError("regalloc state value identity no longer matches IR");
  return failure();
}

static Block *getBlockAt(Region &region, int64_t index) {
  if (index < 0)
    return nullptr;
  uint64_t cursor = 0;
  uint64_t target = static_cast<uint64_t>(index);
  for (Block &block : region) {
    if (cursor == target)
      return &block;
    ++cursor;
  }
  return nullptr;
}

static Operation *getOpAt(Block &block, int64_t index) {
  if (index < 0)
    return nullptr;
  uint64_t cursor = 0;
  uint64_t target = static_cast<uint64_t>(index);
  for (Operation &op : block) {
    if (cursor == target)
      return &op;
    ++cursor;
  }
  return nullptr;
}

struct RegAllocBlockPathStep {
  Block *block = nullptr;
  Region *nextRegion = nullptr;
  bool complete = false;
};

static FailureOr<RegAllocBlockPathStep>
resolveRegAllocBlockPathStep(Region &region, ArrayRef<int64_t> path,
                             unsigned &cursor, Operation *diagOp) {
  Block *block = getBlockAt(region, path[cursor++]);
  if (!block)
    return failRegAllocStateIdentity<RegAllocBlockPathStep>(diagOp);
  if (cursor == path.size())
    return RegAllocBlockPathStep{block, nullptr, true};
  if (cursor + 1 >= path.size())
    return failRegAllocStateIdentity<RegAllocBlockPathStep>(diagOp);

  Operation *op = getOpAt(*block, path[cursor++]);
  if (!op)
    return failRegAllocStateIdentity<RegAllocBlockPathStep>(diagOp);

  int64_t regionIndex = path[cursor++];
  if (regionIndex < 0 ||
      static_cast<uint64_t>(regionIndex) >= op->getNumRegions())
    return failRegAllocStateIdentity<RegAllocBlockPathStep>(diagOp);
  return RegAllocBlockPathStep{
      block, &op->getRegion(static_cast<unsigned>(regionIndex)), false};
}

static FailureOr<Block *> resolveRegAllocBlockPath(Region &root,
                                                   ArrayRef<int64_t> path,
                                                   Operation *diagOp) {
  if (path.size() < 2 || path.front() != 0)
    return failRegAllocStateIdentity<Block *>(diagOp);

  Region *region = &root;
  unsigned cursor = 1;
  while (cursor < path.size()) {
    FailureOr<RegAllocBlockPathStep> step =
        resolveRegAllocBlockPathStep(*region, path, cursor, diagOp);
    if (failed(step))
      return failure();
    if (step->complete)
      return step->block;
    region = step->nextRegion;
  }
  return failRegAllocStateIdentity<Block *>(diagOp);
}

static LogicalResult
checkResolvedRegAllocValue(Value resolved,
                           const wave::RegAllocTransformValue &value,
                           Operation *diagOp) {
  std::optional<waveamdmachine::RegType> type =
      wave::getRegAllocTransformTrackedRegType(resolved);
  if (!type || type->getRegClass() != value.regClass ||
      static_cast<unsigned>(type->getWidth()) != value.width) {
    diagOp->emitError("regalloc state value identity no longer matches IR");
    return failure();
  }
  int64_t index = type->getIndex();
  if ((value.fixed &&
       (index < 0 || *value.fixed != static_cast<unsigned>(index))) ||
      (!value.fixed && index >= 0)) {
    diagOp->emitError("regalloc state value identity no longer matches IR");
    return failure();
  }
  return success();
}

static FailureOr<Value>
resolveRegAllocStateValue(func::FuncOp func,
                          const wave::RegAllocTransformValue &value) {
  Operation *diagOp = func.getOperation();
  if (value.kind == wave::RegAllocTransformValueKind::BlockArgument) {
    FailureOr<Block *> block =
        resolveRegAllocBlockPath(func.getBody(), value.path, diagOp);
    if (failed(block))
      return failure();
    if (value.number >= (*block)->getNumArguments())
      return failRegAllocStateIdentity<Value>(diagOp);
    Value resolved = (*block)->getArgument(value.number);
    if (failed(checkResolvedRegAllocValue(resolved, value, diagOp)))
      return failure();
    return resolved;
  }

  if (value.path.size() < 3)
    return failRegAllocStateIdentity<Value>(diagOp);
  ArrayRef<int64_t> blockPath = ArrayRef<int64_t>(value.path).drop_back();
  FailureOr<Block *> block =
      resolveRegAllocBlockPath(func.getBody(), blockPath, diagOp);
  if (failed(block))
    return failure();
  Block *resolvedBlock = *block;
  Operation *op = getOpAt(*resolvedBlock, value.path.back());
  if (!op || value.number >= op->getNumResults())
    return failRegAllocStateIdentity<Value>(diagOp);
  Value resolved = op->getResult(value.number);
  if (failed(checkResolvedRegAllocValue(resolved, value, diagOp)))
    return failure();
  return resolved;
}

static void collectRegAllocValues(Region &region,
                                  SmallVectorImpl<Value> &values) {
  for (Block &block : region) {
    for (BlockArgument arg : block.getArguments())
      if (wave::getRegAllocTransformTrackedRegType(arg))
        values.push_back(arg);
    for (Operation &op : block) {
      for (OpResult result : op.getResults())
        if (wave::getRegAllocTransformTrackedRegType(result))
          values.push_back(result);
      for (Region &nested : op.getRegions())
        collectRegAllocValues(nested, values);
    }
  }
}

using ResolvedRegAllocValue =
    std::pair<Value, const wave::RegAllocTransformValue *>;

static FailureOr<SmallVector<ResolvedRegAllocValue>>
resolveRegAllocStateValues(func::FuncOp func,
                           ArrayRef<wave::RegAllocTransformValue> values) {
  SmallVector<Value> payloadValues;
  collectRegAllocValues(func.getBody(), payloadValues);
  if (payloadValues.size() != values.size())
    return func.emitError("regalloc state value count no longer matches IR");

  DenseSet<Value> unmatched(payloadValues.begin(), payloadValues.end());
  SmallVector<ResolvedRegAllocValue> resolvedValues;
  resolvedValues.reserve(values.size());
  for (const wave::RegAllocTransformValue &value : values) {
    FailureOr<Value> payloadValue = resolveRegAllocStateValue(func, value);
    if (failed(payloadValue))
      return failure();
    auto unmatchedIt = unmatched.find(*payloadValue);
    if (unmatchedIt == unmatched.end())
      return failRegAllocStateIdentity<SmallVector<ResolvedRegAllocValue>>(
          func.getOperation());
    unmatched.erase(unmatchedIt);
    resolvedValues.push_back({*payloadValue, &value});
  }
  return resolvedValues;
}

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

static std::optional<unsigned>
getEntryRegFixedBase(Value value, const wave::WaveAMDKernelEntryRegs &regs) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return std::nullopt;
  auto type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getRegClass() == waveamdmachine::RegClass::VGPR &&
      isa<waveamdmachine::VWorkitemIdXOp>(def))
    return regs.workitemIdXVGPR;
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
  RegAllocLinearScanner(func::FuncOp func, Builder &builder)
      : func(func), builder(builder) {}

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
  LogicalResult parseState() {
    state = func->getAttrOfType<DictionaryAttr>(
        wave::getRegAllocTransformStateAttrName());
    if (!state)
      return func.emitError("regalloc linear scan requires alias state");

    FailureOr<SmallVector<wave::RegAllocTransformValue>> parsedValues =
        wave::parseRegAllocTransformValues(state, func.getOperation());
    if (failed(parsedValues))
      return failure();
    values = std::move(*parsedValues);

    FailureOr<SmallVector<wave::RegAllocTransformAliasSet>> parsedSets =
        wave::parseRegAllocTransformAliasSets(state, values,
                                              func.getOperation());
    if (failed(parsedSets))
      return failure();
    sets = std::move(*parsedSets);
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

  LogicalResult collectResolvedValues() {
    FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
        resolveRegAllocStateValues(func, values);
    if (failed(resolvedValues))
      return failure();
    payloadValues.resize(values.size());
    for (auto [payloadValue, stateValue] : *resolvedValues) {
      payloadValues[stateValue->id] = payloadValue;
      valueLookup[payloadValue] = stateValue;
    }
    return success();
  }

  LogicalResult computeFixedBases() {
    for (wave::RegAllocTransformAliasSet &set : sets)
      if (failed(computeFixedBase(set)))
        return failure();
    return success();
  }

  LogicalResult computeFixedBase(wave::RegAllocTransformAliasSet &set) {
    for (unsigned valueId : set.members) {
      const wave::RegAllocTransformValue &value = values[valueId];
      if (!value.fixed)
        continue;
      if (*value.fixed < value.offset)
        return recordFixedFailure(set, "fixed-underflow");
      unsigned base = *value.fixed - value.offset;
      if (set.fixedBase && *set.fixedBase != base)
        return recordFixedFailure(set, "fixed-conflict");
      set.fixedBase = base;
    }
    return success();
  }

  LogicalResult collectFixedHardwareReadSets() {
    for (const wave::RegAllocTransformAliasSet &set : sets) {
      if (!set.fixedBase || set.members.size() != 1)
        continue;
      unsigned valueId = set.members.front();
      FailureOr<Value> payloadValue =
          resolveRegAllocStateValue(func, values[valueId]);
      if (failed(payloadValue))
        return failure();
      if (isFixedHardwareRead(*payloadValue))
        fixedHardwareReadValues[set.id] = *payloadValue;
    }
    return success();
  }

  void collectFixedReservations() {
    for (const wave::RegAllocTransformAliasSet &set : sets) {
      if (!set.fixedBase)
        continue;
      wave::RegAllocTransformBudget budget = getBudget(set.regClass);
      if (*set.fixedBase + set.width <= budget.limit)
        fixedReservations.push_back({set.regClass, set.id, *set.fixedBase,
                                     set.width, set.start, set.end});
    }
  }

  LogicalResult collectEntryABIReservations() {
    wave::WaveAMDKernelEntryRegs regs = wave::getWaveAMDKernelEntryRegs(func);
    if (regs.reservedSGPRs == 0 && regs.reservedVGPRs == 0)
      return success();

    FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
        resolveRegAllocStateValues(func, values);
    if (failed(resolvedValues))
      return failure();

    for (auto [payloadValue, stateValue] : *resolvedValues) {
      if (!stateValue->fixed)
        continue;
      Value value = payloadValue;
      std::optional<unsigned> base = getEntryRegFixedBase(value, regs);
      if (!base)
        continue;
      unsigned setId = sets.size() + fixedReservations.size();
      fixedReservations.push_back({stateValue->regClass, setId, *base,
                                   stateValue->width, /*start=*/0,
                                   stateValue->end});
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
      if (failed(allocateSet(set)))
        return failure();
      if (scanFailure)
        return success();
    }
    return success();
  }

  void expireInactive(unsigned position) {
    llvm::erase_if(
        active, [position](const wave::RegAllocTransformAssignment &assigned) {
          return assigned.end < position;
        });
  }

  LogicalResult allocateSet(const wave::RegAllocTransformAliasSet &set) {
    wave::RegAllocTransformBudget budget = getBudget(set.regClass);
    if (set.fixedBase)
      return allocateFixedSet(set, budget);
    std::optional<unsigned> base = findFreeBase(set, budget.limit);
    if (!base)
      base = findReusableInputBase(set, budget.limit);
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
    return wave::getRegAllocTransformBudget(func, regClass);
  }

  LogicalResult allocateFixedSet(const wave::RegAllocTransformAliasSet &set,
                                 wave::RegAllocTransformBudget budget) {
    if (*set.fixedBase + set.width > budget.limit ||
        conflictsWithActive(set, *set.fixedBase)) {
      recordPressureFailure(set, budget);
      return success();
    }
    if (checkCombinedPressureFailure(set, *set.fixedBase))
      return success();
    addAssignment(set, *set.fixedBase);
    return success();
  }

  std::optional<unsigned>
  findFreeBase(const wave::RegAllocTransformAliasSet &set, unsigned limit) {
    if (set.width > limit)
      return std::nullopt;
    unsigned align = std::max<unsigned>(1, llvm::PowerOf2Ceil(set.width));
    for (unsigned base = 0; base <= limit - set.width; base += align)
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
    for (const wave::RegAllocTransformAssignment &assigned : active)
      if (assigned.set == setId)
        return &assigned;
    return nullptr;
  }

  std::optional<unsigned>
  findReusableInputBase(const wave::RegAllocTransformAliasSet &set,
                        unsigned limit) {
    const wave::RegAllocTransformValue *resultValue = getSingleResultValue(set);
    if (!resultValue || resultValue->id >= payloadValues.size() ||
        set.width > limit)
      return std::nullopt;
    Operation *def = payloadValues[resultValue->id].getDefiningOp();
    if (!canReuseKilledOperandForResult(def))
      return std::nullopt;

    std::optional<unsigned> bestBase;
    for (OpOperand &operand : def->getOpOperands()) {
      auto it = valueLookup.find(operand.get());
      if (it == valueLookup.end())
        continue;
      std::optional<unsigned> base =
          getReusableOperandBase(set, *it->second, limit);
      if (!base)
        continue;
      if (!bestBase || *base < *bestBase)
        bestBase = *base;
    }
    return bestBase;
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
           sourceValue.offset + set.width <= sourceSet.width;
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
    return !conflictsWithFixedReservationIgnoring(set, base, sourceAssignment);
  }

  std::optional<unsigned>
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
    return base;
  }

  bool conflictsWithActive(const wave::RegAllocTransformAliasSet &set,
                           unsigned base) {
    return llvm::any_of(
        active, [&](const wave::RegAllocTransformAssignment &assigned) {
          if (assigned.regClass != set.regClass ||
              !assignedRangesOverlap(assigned, base, set.width) ||
              !setsHaveLiveOverlap(set, assigned))
            return false;
          return !canShareFixedHardwareRead(set, assigned, base);
        });
  }

  bool conflictsWithActiveIgnoring(const wave::RegAllocTransformAliasSet &set,
                                   unsigned base, unsigned ignoredSetId) {
    return llvm::any_of(
        active, [&](const wave::RegAllocTransformAssignment &assigned) {
          if (assigned.set == ignoredSetId)
            return false;
          if (assigned.regClass != set.regClass ||
              !assignedRangesOverlap(assigned, base, set.width) ||
              !setsHaveLiveOverlap(set, assigned))
            return false;
          return !canShareFixedHardwareRead(set, assigned, base);
        });
  }

  bool setLiveAtPosition(unsigned setId, unsigned position) {
    const wave::RegAllocTransformAliasSet *set = getSetById(setId);
    if (!set)
      return true;
    return llvm::any_of(set->members, [&](unsigned valueId) {
      return valueLiveAtPosition(values[valueId], position);
    });
  }

  const wave::RegAllocTransformAliasSet *getSetById(unsigned setId) {
    for (const wave::RegAllocTransformAliasSet &set : sets)
      if (set.id == setId)
        return &set;
    return nullptr;
  }

  bool setsHaveLiveOverlap(const wave::RegAllocTransformAliasSet &lhs,
                           const wave::RegAllocTransformAssignment &rhs) {
    const wave::RegAllocTransformAliasSet *rhsSet = getSetById(rhs.set);
    if (!rhsSet)
      return setOverlapsRange(lhs, rhs.start, rhs.end);
    for (unsigned lhsValueId : lhs.members) {
      const wave::RegAllocTransformValue &lhsValue = values[lhsValueId];
      for (unsigned rhsValueId : rhsSet->members) {
        const wave::RegAllocTransformValue &rhsValue = values[rhsValueId];
        if (valueRangesOverlap(lhsValue, rhsValue))
          return true;
      }
    }
    return false;
  }

  bool setOverlapsRange(const wave::RegAllocTransformAliasSet &set,
                        unsigned start, unsigned end) {
    return llvm::any_of(set.members, [&](unsigned valueId) {
      return valueOverlapsRange(values[valueId], start, end);
    });
  }

  bool
  canShareFixedHardwareRead(const wave::RegAllocTransformAliasSet &set,
                            const wave::RegAllocTransformAssignment &assigned,
                            unsigned base) {
    if (!set.fixedBase || *set.fixedBase != base || assigned.base != base ||
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
    return llvm::any_of(
        fixedReservations,
        [&](const wave::RegAllocTransformAssignment &reserved) {
          return reserved.regClass == set.regClass &&
                 setOverlapsRange(set, reserved.start, reserved.end) &&
                 assignedRangesOverlap(reserved, base, set.width);
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
    return llvm::any_of(
        fixedReservations,
        [&](const wave::RegAllocTransformAssignment &reserved) {
          if ((reserved.set == ignored.set ||
               reservationCoveredByIgnoredSource(reserved, ignored)) &&
              assignedRangesOverlap(reserved, base, set.width))
            return false;
          return reserved.regClass == set.regClass &&
                 setOverlapsRange(set, reserved.start, reserved.end) &&
                 assignedRangesOverlap(reserved, base, set.width);
        });
  }

  bool hasActiveAssignment(unsigned setId) {
    return llvm::any_of(
        active, [setId](const wave::RegAllocTransformAssignment &assigned) {
          return assigned.set == setId;
        });
  }

  SmallVector<wave::RegAllocTransformAssignment>
  getFixedReservationOverlaps(const wave::RegAllocTransformAliasSet &set) {
    SmallVector<wave::RegAllocTransformAssignment> overlaps;
    for (const wave::RegAllocTransformAssignment &reserved :
         fixedReservations) {
      if (reserved.set == set.id || reserved.regClass != set.regClass ||
          hasActiveAssignment(reserved.set))
        continue;
      if (setOverlapsRange(set, reserved.start, reserved.end))
        overlaps.push_back(reserved);
    }
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
    unsigned agprFootprint = 0;
    unsigned vgprFootprint = 0;
    for (const wave::RegAllocTransformAssignment &assigned : active)
      if (isVGPRFamilyClass(assigned.regClass) &&
          setLiveAtPosition(assigned.set, set.start))
        addFamilyFootprint(assigned.regClass, assigned.base, assigned.width,
                           agprFootprint, vgprFootprint);
    addFamilyFootprint(set.regClass, base, set.width, agprFootprint,
                       vgprFootprint);
    unsigned pressure =
        getCombinedVGPRFamilyPressure(agprFootprint, vgprFootprint);
    if (pressure <= vgprFamilyBudget->limit)
      return false;
    recordCombinedPressureFailure(set, pressure, active);
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
    assignments.push_back(assigned);
    active.push_back(assigned);
  }

  unsigned getPressureAtFailure(
      const wave::RegAllocTransformAliasSet &set,
      ArrayRef<wave::RegAllocTransformAssignment> fixedOverlaps) {
    unsigned pressure = set.width;
    for (const wave::RegAllocTransformAssignment &assigned : active)
      if (assigned.regClass == set.regClass &&
          setLiveAtPosition(assigned.set, set.start))
        pressure += assigned.width;
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
    for (const wave::RegAllocTransformAssignment &assigned : active)
      if (assigned.regClass == set.regClass &&
          setLiveAtPosition(assigned.set, set.start))
        failed.overlaps.push_back(assigned);
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
    FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
        resolveRegAllocStateValues(func, values);
    if (failed(resolvedValues))
      return failure();

    FailureOr<SmallVector<PendingRegAllocAssignment>> pendingAssignments =
        buildPendingAssignments(*resolvedValues);
    if (failed(pendingAssignments))
      return failure();

    return commitAssignments(*pendingAssignments);
  }

  FailureOr<SmallVector<PendingRegAllocAssignment>>
  buildPendingAssignments(ArrayRef<ResolvedRegAllocValue> resolvedValues) {
    DenseMap<unsigned, const wave::RegAllocTransformAssignment *> bySet;
    for (const wave::RegAllocTransformAssignment &assignment : assignments)
      bySet[assignment.set] = &assignment;

    SmallVector<PendingRegAllocAssignment> pendingAssignments;
    pendingAssignments.reserve(resolvedValues.size());
    for (auto [payloadValue, value] : resolvedValues) {
      const wave::RegAllocTransformAssignment *assignment =
          bySet.lookup(value->set);
      if (!assignment)
        return func.emitError("regalloc assignment map is incomplete");
      pendingAssignments.push_back(
          {payloadValue,
           getAssignedValueType(payloadValue, *value,
                                assignment->base + value->offset)});
    }
    return pendingAssignments;
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

  SmallVector<wave::RegAllocTransformValue> values;
  SmallVector<wave::RegAllocTransformAliasSet> sets;
  SmallVector<Value> payloadValues;
  SmallVector<wave::RegAllocTransformAssignment> fixedReservations;
  SmallVector<wave::RegAllocTransformAssignment> active;
  SmallVector<wave::RegAllocTransformAssignment> assignments;
  DenseMap<Value, const wave::RegAllocTransformValue *> valueLookup;
  DenseMap<unsigned, Value> fixedHardwareReadValues;
  std::optional<wave::RegAllocTransformBudget> vgprFamilyBudget;
  std::optional<RegAllocScanFailure> scanFailure;
  DictionaryAttr state;
  func::FuncOp func;
  Builder &builder;
};

static LogicalResult setRegAllocTransformState(func::FuncOp func,
                                               Builder &builder) {
  if (func.isDeclaration()) {
    func->removeAttr(wave::getRegAllocTransformStateAttrName());
    return success();
  }
  if (failed(wave::prepareWaveAMDRegAllocIR(func)))
    return failure();
  if (failed(splitDuplicateLoopInits(func)))
    return failure();
  RegAllocAliasStateBuilder stateBuilder(func, builder);
  FailureOr<DictionaryAttr> state = stateBuilder.build();
  if (failed(state))
    return failure();
  func->setAttr(wave::getRegAllocTransformStateAttrName(), *state);
  return success();
}

static LogicalResult runRegAllocLinearScan(func::FuncOp func,
                                           Builder &builder) {
  if (func.isDeclaration())
    return success();
  RegAllocLinearScanner scanner(func, builder);
  return scanner.run();
}

} // namespace

LogicalResult wave::buildRegAllocTransformAliasState(Operation *target,
                                                     Builder &builder) {
  clearRegAllocTransformState(target);
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return setRegAllocTransformState(func, builder);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(setRegAllocTransformState(func, builder))
               ? WalkResult::interrupt()
               : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}

LogicalResult wave::runRegAllocTransformLinearScan(Operation *target,
                                                   Builder &builder) {
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return runRegAllocLinearScan(func, builder);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(runRegAllocLinearScan(func, builder))
               ? WalkResult::interrupt()
               : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}
