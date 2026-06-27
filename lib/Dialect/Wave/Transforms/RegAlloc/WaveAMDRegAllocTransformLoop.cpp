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
    values[it->second].end = std::max(values[it->second].end, position);
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
    unsigned loopExit = getLoopExitPosition(loop);
    DenseSet<Value> seenInits;
    for (auto [init, arg, result] : llvm::zip_equal(
             loop.getInits(), body.getArguments(), loop.getResults())) {
      addAliasEdge(arg, result, 0);
      if (seenInits.insert(init).second) {
        addAliasEdge(init, arg, 0);
        extendValue(init, loopExit);
      }
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

static bool isVGPRFamilyClass(waveamdmachine::RegClass regClass) {
  return regClass == waveamdmachine::RegClass::VGPR ||
         regClass == waveamdmachine::RegClass::AGPR;
}

static constexpr unsigned kRegClassCount = 5;

using RegClassPressure = std::array<int64_t, kRegClassCount>;

static constexpr std::array<waveamdmachine::RegClass, kRegClassCount>
    kRegClasses = {
        waveamdmachine::RegClass::SGPR, waveamdmachine::RegClass::VGPR,
        waveamdmachine::RegClass::AGPR, waveamdmachine::RegClass::SCC,
        waveamdmachine::RegClass::VCC};

static unsigned getRegClassIndex(waveamdmachine::RegClass regClass) {
  return static_cast<unsigned>(regClass);
}

static void addRegClassPressure(RegClassPressure &pressure,
                                waveamdmachine::RegClass regClass,
                                int64_t dwords) {
  unsigned index = getRegClassIndex(regClass);
  assert(index < pressure.size() && "unknown register class");
  pressure[index] += dwords;
}

static int64_t getTotalPressure(RegClassPressure pressure) {
  int64_t total = 0;
  for (int64_t dwords : pressure)
    total += dwords;
  return total;
}

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

struct AGPRReliefScore {
  unsigned liveDwords = 0;
  int64_t bridgeCost = 0;
  int64_t bridgeCount = 0;
  int64_t loopBridgeCost = 0;
  unsigned end = 0;
};

struct AGPRReliefCandidate {
  SmallVector<ResolvedRegAllocValue> values;
  const wave::RegAllocTransformAliasSet *set = nullptr;
  AGPRReliefScore score;
};

struct AGPRReliefInterval {
  std::optional<unsigned> fixedBase;
  unsigned id = 0;
  unsigned start = 0;
  unsigned end = 0;
  unsigned width = 0;
};

struct RematReliefContext {
  DenseMap<Operation *, unsigned> positions;
  DenseMap<Value, const wave::RegAllocTransformValue *> values;
};

struct RematReliefSlot {
  SmallVector<OpOperand *> uses;
  SmallVector<Value> extendedLeaves;
  Value value;
  Operation *rebuildOp = nullptr;
  const wave::RegAllocTransformValue *stateValue = nullptr;
  int64_t cost = 0;
  unsigned opCount = 0;
  unsigned rebuildPosition = 0;
};

struct RematReliefCandidate {
  SmallVector<RematReliefSlot> slots;
  SmallVector<Value> rematValues;
  const wave::RegAllocTransformAliasSet *set = nullptr;
  int64_t cost = 0;
};

template <typename PlanT> struct MemoryReliefSlot {
  SmallVector<OpOperand *> uses;
  PlanT plan;
  Value value;
  waveamdmachine::RegType type;
  const wave::RegAllocTransformValue *stateValue = nullptr;
  std::optional<wave::regalloc::MemorySpillLoopCarrySlot> loopCarry;
  int64_t cost = 0;
};

template <typename SlotT> struct MemoryReliefCandidate {
  SmallVector<SlotT, 4> slots;
  const wave::RegAllocTransformAliasSet *set = nullptr;
  int64_t cost = 0;
  unsigned reservedBytes = 0;
};

template <typename SlotT> struct MemoryStoredSlot {
  const SlotT *slot = nullptr;
  Value token;
};

struct LDSReliefPlanningState {
  wave::regalloc::RegisterBudgets budgets;
  unsigned committedBytes = 0;
  unsigned fixedLDS = 0;
  unsigned dynamicLDS = 0;
};

struct ScratchReliefPlanningState {
  unsigned committedBytes = 0;
  unsigned existingPrivateBytes = 0;
};

using LDSReliefPlan = SmallVector<wave::regalloc::LDSSpillPlan, 4>;
using LDSReliefSlot = MemoryReliefSlot<LDSReliefPlan>;
using LDSReliefCandidate = MemoryReliefCandidate<LDSReliefSlot>;
using ScratchReliefSlot = MemoryReliefSlot<wave::regalloc::ScratchSpillPlan>;
using ScratchReliefCandidate = MemoryReliefCandidate<ScratchReliefSlot>;

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

static FailureOr<wave::RegAllocTransformAssignment>
parseRegAllocTransformAssignment(DictionaryAttr dict, Operation *diagOp) {
  FailureOr<waveamdmachine::RegClass> regClass =
      wave::getRegAllocTransformRegClassAttr(dict, diagOp);
  FailureOr<unsigned> set =
      wave::getRegAllocTransformUnsignedAttr(dict, "set", diagOp);
  FailureOr<unsigned> base =
      wave::getRegAllocTransformUnsignedAttr(dict, "base", diagOp);
  FailureOr<unsigned> width =
      wave::getRegAllocTransformUnsignedAttr(dict, "width", diagOp);
  FailureOr<unsigned> start =
      wave::getRegAllocTransformUnsignedAttr(dict, "start", diagOp);
  FailureOr<unsigned> end =
      wave::getRegAllocTransformUnsignedAttr(dict, "end", diagOp);
  if (failed(regClass) || failed(set) || failed(base) || failed(width) ||
      failed(start) || failed(end))
    return failure();
  return wave::RegAllocTransformAssignment{*regClass, *set,   *base,
                                           *width,    *start, *end};
}

static LogicalResult parseRegAllocFailureOverlaps(
    DictionaryAttr failureAttr, Operation *diagOp,
    SmallVectorImpl<wave::RegAllocTransformAssignment> &overlaps) {
  ArrayAttr overlapAttrs = failureAttr.getAs<ArrayAttr>("overlaps");
  if (!overlapAttrs)
    return diagOp->emitError("regalloc failure state missing `overlaps`");
  for (Attribute attr : overlapAttrs) {
    auto dict = dyn_cast<DictionaryAttr>(attr);
    if (!dict)
      return diagOp->emitError("regalloc failure overlap is not a dictionary");
    FailureOr<wave::RegAllocTransformAssignment> overlap =
        parseRegAllocTransformAssignment(dict, diagOp);
    if (failed(overlap))
      return failure();
    overlaps.push_back(*overlap);
  }
  return success();
}

static bool isAGPRRelievableFailureClass(StringRef className) {
  return className == "vgpr" || className == "vgpr_agpr";
}

static bool isAGPRRelievableFailureReason(StringRef reason) {
  return reason == "pressure" || reason == "allocated-footprint";
}

static bool isAGPRRelievableFailure(const RegAllocTransformFailure &failure) {
  return isAGPRRelievableFailureClass(failure.className) &&
         isAGPRRelievableFailureReason(failure.reason);
}

static FailureOr<std::optional<DictionaryAttr>>
getLinearScanFailureAttr(func::FuncOp func) {
  DictionaryAttr state = func->getAttrOfType<DictionaryAttr>(
      wave::getRegAllocTransformStateAttrName());
  if (!state)
    return std::optional<DictionaryAttr>();
  StringAttr stage = state.getAs<StringAttr>("stage");
  if (!stage)
    return func.emitError("regalloc transform state missing `stage`");
  if (stage.getValue() != "linear-scan-failure")
    return std::optional<DictionaryAttr>();

  DictionaryAttr failureAttr = state.getAs<DictionaryAttr>("failure");
  if (!failureAttr)
    return func.emitError("regalloc transform state missing `failure`");
  return std::optional<DictionaryAttr>(failureAttr);
}

static FailureOr<RegAllocFailureKind>
parseRegAllocFailureKind(DictionaryAttr failureAttr, Operation *diagOp) {
  StringAttr className = failureAttr.getAs<StringAttr>("class");
  StringAttr reason = failureAttr.getAs<StringAttr>("reason");
  if (!className || !reason)
    return diagOp->emitError("regalloc failure state missing string field");
  return RegAllocFailureKind{className.getValue(), reason.getValue()};
}

static FailureOr<RegAllocTransformFailure>
parseRegAllocFailure(DictionaryAttr failureAttr, RegAllocFailureKind kind,
                     func::FuncOp func) {
  FailureOr<unsigned> set =
      wave::getRegAllocTransformUnsignedAttr(failureAttr, "set", func);
  FailureOr<unsigned> position =
      wave::getRegAllocTransformUnsignedAttr(failureAttr, "position", func);
  if (failed(set) || failed(position))
    return failure();

  RegAllocTransformFailure parsed;
  parsed.className = kind.className;
  parsed.reason = kind.reason;
  parsed.set = *set;
  parsed.position = *position;
  if (failed(parseRegAllocFailureOverlaps(failureAttr, func, parsed.overlaps)))
    return failure();
  return parsed;
}

static FailureOr<std::optional<RegAllocTransformFailure>>
parseRegAllocTransformFailure(func::FuncOp func) {
  FailureOr<std::optional<DictionaryAttr>> failureAttr =
      getLinearScanFailureAttr(func);
  if (failed(failureAttr))
    return failure();
  if (!*failureAttr)
    return std::optional<RegAllocTransformFailure>();

  FailureOr<RegAllocFailureKind> kind =
      parseRegAllocFailureKind(**failureAttr, func);
  if (failed(kind))
    return failure();

  FailureOr<RegAllocTransformFailure> parsed =
      parseRegAllocFailure(**failureAttr, *kind, func);
  if (failed(parsed))
    return failure();
  return std::optional<RegAllocTransformFailure>(std::move(*parsed));
}

static std::optional<unsigned>
getRegAllocTransformFixedBase(const wave::RegAllocTransformAliasSet &set,
                              ArrayRef<wave::RegAllocTransformValue> values) {
  std::optional<unsigned> fixedBase;
  for (unsigned valueId : set.members) {
    const wave::RegAllocTransformValue &value = values[valueId];
    if (!value.fixed)
      continue;
    if (*value.fixed < value.offset)
      return std::nullopt;
    unsigned base = *value.fixed - value.offset;
    if (fixedBase && *fixedBase != base)
      return std::nullopt;
    fixedBase = base;
  }
  return fixedBase;
}

static std::optional<unsigned>
findFreeAGPRBase(const AGPRReliefInterval &interval,
                 ArrayRef<wave::RegAllocTransformAssignment> active,
                 unsigned limit) {
  if (interval.width > limit)
    return std::nullopt;
  unsigned align = std::max<unsigned>(1, llvm::PowerOf2Ceil(interval.width));
  for (unsigned base = 0; base <= limit - interval.width; base += align) {
    bool blocked = llvm::any_of(
        active, [&](const wave::RegAllocTransformAssignment &assigned) {
          return assignedRangesOverlap(assigned, base, interval.width);
        });
    if (!blocked)
      return base;
  }
  return std::nullopt;
}

static bool
canAllocateAGPRReliefIntervals(ArrayRef<AGPRReliefInterval> intervals,
                               unsigned candidateId, unsigned limit,
                               unsigned &footprint) {
  SmallVector<wave::RegAllocTransformAssignment> active;
  bool allocatedCandidate = false;
  footprint = 0;
  for (const AGPRReliefInterval &interval : intervals) {
    llvm::erase_if(active,
                   [&](const wave::RegAllocTransformAssignment &assigned) {
                     return assigned.end < interval.start;
                   });
    if (interval.fixedBase) {
      if (*interval.fixedBase + interval.width > limit)
        return false;
      if (llvm::any_of(active,
                       [&](const wave::RegAllocTransformAssignment &assigned) {
                         return assignedRangesOverlap(
                             assigned, *interval.fixedBase, interval.width);
                       }))
        return false;
      active.push_back({waveamdmachine::RegClass::AGPR, interval.id,
                        *interval.fixedBase, interval.width, interval.start,
                        interval.end});
      footprint = std::max(footprint, *interval.fixedBase + interval.width);
      allocatedCandidate |= interval.id == candidateId;
      continue;
    }
    std::optional<unsigned> base = findFreeAGPRBase(interval, active, limit);
    if (!base)
      return false;
    active.push_back({waveamdmachine::RegClass::AGPR, interval.id, *base,
                      interval.width, interval.start, interval.end});
    footprint = std::max(footprint, *base + interval.width);
    allocatedCandidate |= interval.id == candidateId;
  }
  return allocatedCandidate;
}

static bool lessAGPRReliefInterval(const AGPRReliefInterval &lhs,
                                   const AGPRReliefInterval &rhs) {
  return std::tie(lhs.start, lhs.id) < std::tie(rhs.start, rhs.id);
}

static bool canAllocateAGPRReliefCandidate(
    func::FuncOp func, const wave::RegAllocTransformAliasSet &candidate,
    ArrayRef<wave::RegAllocTransformAliasSet> sets,
    ArrayRef<wave::RegAllocTransformValue> values, unsigned &agprFootprint) {
  wave::RegAllocTransformBudget budget =
      wave::getRegAllocTransformBudget(func, waveamdmachine::RegClass::AGPR);
  SmallVector<AGPRReliefInterval> intervals;
  for (const wave::RegAllocTransformAliasSet &set : sets) {
    if (set.regClass != waveamdmachine::RegClass::AGPR)
      continue;
    intervals.push_back({getRegAllocTransformFixedBase(set, values), set.id,
                         set.start, set.end, set.width});
  }
  intervals.push_back({std::nullopt, candidate.id, candidate.start,
                       candidate.end, candidate.width});
  llvm::stable_sort(intervals, lessAGPRReliefInterval);
  return canAllocateAGPRReliefIntervals(intervals, candidate.id, budget.limit,
                                        agprFootprint);
}

static unsigned getVGPRFootprintAfterRemovingSet(
    ArrayRef<wave::RegAllocTransformAssignment> assignments,
    std::optional<unsigned> removedSet) {
  unsigned footprint = 0;
  for (const wave::RegAllocTransformAssignment &assignment : assignments) {
    if (assignment.regClass != waveamdmachine::RegClass::VGPR ||
        (removedSet && assignment.set == *removedSet))
      continue;
    footprint = std::max(footprint, assignment.base + assignment.width);
  }
  return footprint;
}

static const wave::RegAllocTransformAssignment *
findFailureOverlap(const RegAllocTransformFailure &failureRecord,
                   unsigned setId) {
  for (const wave::RegAllocTransformAssignment &overlap :
       failureRecord.overlaps)
    if (overlap.set == setId)
      return &overlap;
  return nullptr;
}

static FailureOr<bool> respectsCombinedVGPRFamilyBudget(
    func::FuncOp func, const wave::RegAllocTransformAliasSet &candidate,
    const RegAllocTransformFailure &failureRecord,
    ArrayRef<wave::RegAllocTransformAliasSet> sets, unsigned agprFootprint) {
  FailureOr<std::optional<wave::RegAllocTransformBudget>> familyBudget =
      wave::getRegAllocTransformVGPRFamilyBudget(func);
  if (failed(familyBudget))
    return failure();
  if (!*familyBudget)
    return true;

  unsigned vgprFootprint = getVGPRFootprintAfterRemovingSet(
      failureRecord.overlaps, /*removedSet=*/std::nullopt);
  if (candidate.id != failureRecord.set) {
    const wave::RegAllocTransformAssignment *moved =
        findFailureOverlap(failureRecord, candidate.id);
    if (!moved)
      return false;
    const wave::RegAllocTransformAliasSet *request = nullptr;
    for (const wave::RegAllocTransformAliasSet &set : sets)
      if (set.id == failureRecord.set) {
        request = &set;
        break;
      }
    if (!request || request->width > moved->width)
      return false;
    vgprFootprint = std::max(
        getVGPRFootprintAfterRemovingSet(failureRecord.overlaps, candidate.id),
        moved->base + request->width);
  }

  unsigned pressure =
      getCombinedVGPRFamilyPressure(agprFootprint, vgprFootprint);
  return pressure <= (*familyBudget)->limit;
}

static const wave::RegAllocTransformAliasSet *
findRegAllocTransformSet(ArrayRef<wave::RegAllocTransformAliasSet> sets,
                         unsigned id) {
  for (const wave::RegAllocTransformAliasSet &set : sets)
    if (set.id == id)
      return &set;
  return nullptr;
}

static bool setCanRelieveAtPosition(const wave::RegAllocTransformAliasSet &set,
                                    unsigned position) {
  return set.start < position && position <= set.end;
}

static bool
liveValuesCanRelieveAtPosition(ArrayRef<ResolvedRegAllocValue> resolvedValues,
                               unsigned position) {
  return llvm::all_of(resolvedValues, [position](ResolvedRegAllocValue value) {
    const wave::RegAllocTransformValue &stateValue = *value.second;
    if (position < stateValue.start || stateValue.end < position)
      return true;
    return stateValue.start < position;
  });
}

static bool
hasFixedRegAllocValue(const wave::RegAllocTransformAliasSet &set,
                      ArrayRef<wave::RegAllocTransformValue> values) {
  return llvm::any_of(set.members, [&](unsigned valueId) {
    return values[valueId].fixed.has_value();
  });
}

static bool isRegAllocTransformBridgeValue(Value value) {
  Operation *def = value.getDefiningOp();
  return isa_and_nonnull<waveamdmachine::VAccvgprReadB32TupleOp,
                         waveamdmachine::VAccvgprWriteB32TupleOp>(def);
}

static bool hasRegAllocTransformBridgeUse(Value value) {
  return llvm::any_of(value.getUses(), [](OpOperand &use) {
    return isa<waveamdmachine::VAccvgprReadB32TupleOp,
               waveamdmachine::VAccvgprWriteB32TupleOp>(use.getOwner());
  });
}

static bool isRegAllocTransformBridgeRelated(Value value) {
  return isRegAllocTransformBridgeValue(value) ||
         hasRegAllocTransformBridgeUse(value);
}

static bool isStructuralLoopCarryUse(Operation *op) {
  return isa_and_nonnull<waveamdmachine::UniformLoopOp,
                         waveamdmachine::ContinueIfOp>(op);
}

static bool hasStructuralLoopCarryUse(Value value) {
  return llvm::any_of(value.getUses(), [](OpOperand &use) {
    return isStructuralLoopCarryUse(use.getOwner());
  });
}

static bool hasRegAllocTransformClass(Value value,
                                      waveamdmachine::RegClass regClass) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  return type && type.getRegClass() == regClass;
}

static void setRegAllocTransformClass(Value value,
                                      waveamdmachine::RegClass regClass) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type)
    return;
  value.setType(waveamdmachine::RegType::get(type.getContext(), regClass,
                                             type.getWidth(), /*index=*/-1));
}

static bool isMFMAInputUse(waveamdmachine::MMAOpInterface mfma,
                           OpOperand &use) {
  return &use == &mfma.getAMutable() || &use == &mfma.getBMutable();
}

static bool isMFMAAccumulatorUse(waveamdmachine::MMAOpInterface mfma,
                                 OpOperand &use) {
  return &use == &mfma.getAccMutable();
}

static bool canDefineAGPR(Value value) {
  if (auto arg = dyn_cast<BlockArgument>(value))
    return isa_and_nonnull<waveamdmachine::UniformLoopOp>(
        arg.getOwner()->getParentOp());
  Operation *def = value.getDefiningOp();
  if (!def)
    return false;
  return isa<waveamdmachine::UninitOp, waveamdmachine::UniformLoopOp>(def) ||
         isa<waveamdmachine::MMAOpInterface>(def);
}

static bool isTupleAliasOp(Operation *op) {
  return isa_and_nonnull<waveamdmachine::TupleToElementsOp,
                         waveamdmachine::TupleFromElementsOp>(op);
}

static bool isReliefGroupValue(Value value,
                               const DenseSet<Value> &groupValues) {
  return groupValues.contains(value);
}

static bool canRebankTupleAliasOp(Operation *op,
                                  const DenseSet<Value> &groupValues) {
  if (!isTupleAliasOp(op))
    return false;
  if (!llvm::all_of(op->getOperands(), [&](Value value) {
        return isReliefGroupValue(value, groupValues);
      }))
    return false;
  return llvm::all_of(op->getResults(), [&](Value value) {
    return isReliefGroupValue(value, groupValues);
  });
}

static void rebankTupleAliasResults(Operation *op,
                                    waveamdmachine::RegClass regClass) {
  if (!isTupleAliasOp(op))
    return;
  for (Value result : op->getResults())
    setRegAllocTransformClass(result, regClass);
}

static bool canConsumeAGPRAfterRelief(OpOperand &use,
                                      const DenseSet<Value> &groupValues) {
  Operation *user = use.getOwner();
  if (waveamdmachine::MMAOpInterface mfma =
          dyn_cast<waveamdmachine::MMAOpInterface>(user)) {
    if (isMFMAInputUse(mfma, use))
      return true;
    if (isMFMAAccumulatorUse(mfma, use) &&
        isReliefGroupValue(mfma.getAccResult(), groupValues))
      return true;
  }
  if (isStructuralLoopCarryUse(user))
    return true;
  if (canRebankTupleAliasOp(user, groupValues))
    return true;
  auto read = dyn_cast<waveamdmachine::VAccvgprReadB32TupleOp>(user);
  return read && use.getOperandNumber() == 0;
}

static bool
isAGPRReliefEligibleSet(const wave::RegAllocTransformAliasSet &set,
                        ArrayRef<wave::RegAllocTransformValue> values,
                        ArrayRef<ResolvedRegAllocValue> resolvedValues,
                        unsigned position) {
  if (set.regClass != waveamdmachine::RegClass::VGPR ||
      !setCanRelieveAtPosition(set, position) ||
      !liveValuesCanRelieveAtPosition(resolvedValues, position) ||
      hasFixedRegAllocValue(set, values))
    return false;
  return llvm::none_of(resolvedValues, [](ResolvedRegAllocValue resolved) {
    return isRegAllocTransformBridgeRelated(resolved.first);
  });
}

static int64_t getAGPRReliefLoopCostScale(Operation *op) {
  unsigned depth = 0;
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(cur))
      ++depth;
  if (depth == 0)
    return 1;
  return int64_t{1} << std::min<unsigned>(depth * 4, 20);
}

struct AGPRReliefBridgeCost {
  int64_t cost = 0;
  int64_t count = 0;
  int64_t loopCost = 0;

  void add(Operation *op) {
    ++count;
    int64_t scale = getAGPRReliefLoopCostScale(op);
    if (scale == 1)
      ++cost;
    else
      loopCost += scale;
  }
};

static AGPRReliefBridgeCost
getAGPRReliefBridgeCost(ArrayRef<ResolvedRegAllocValue> values,
                        const DenseSet<Value> &groupValues) {
  AGPRReliefBridgeCost cost;
  for (const ResolvedRegAllocValue &value : values) {
    Operation *def = value.first.getDefiningOp();
    if (def && !canDefineAGPR(value.first) &&
        !canRebankTupleAliasOp(def, groupValues))
      cost.add(def);
    for (OpOperand &use : value.first.getUses()) {
      if (isa<waveamdmachine::VAccvgprWriteB32TupleOp>(use.getOwner()))
        continue;
      if (!canConsumeAGPRAfterRelief(use, groupValues))
        cost.add(use.getOwner());
    }
  }
  return cost;
}

static unsigned
getAGPRReliefLiveDwords(const wave::RegAllocTransformAliasSet &set,
                        ArrayRef<wave::RegAllocTransformValue> values,
                        unsigned position) {
  SmallVector<char, 8> live(set.width, 0);
  unsigned count = 0;
  for (unsigned valueId : set.members) {
    const wave::RegAllocTransformValue &value = values[valueId];
    if (position < value.start || value.end < position)
      continue;
    unsigned begin = static_cast<unsigned>(value.offset);
    if (begin >= set.width)
      continue;
    unsigned end = std::min<unsigned>(set.width, begin + value.width);
    for (unsigned lane : llvm::seq(begin, end)) {
      if (live[lane])
        continue;
      live[lane] = 1;
      ++count;
    }
  }
  return count;
}

static unsigned
getAGPRReliefEnd(const wave::RegAllocTransformAliasSet &set,
                 ArrayRef<wave::RegAllocTransformValue> values) {
  unsigned end = 0;
  for (unsigned valueId : set.members)
    end = std::max(end, values[valueId].end);
  return end;
}

static int64_t getAGPRReliefPrimaryCost(AGPRReliefScore score) {
  return score.bridgeCost + score.loopBridgeCost;
}

static AGPRReliefScore
getAGPRReliefScore(const wave::RegAllocTransformAliasSet &set,
                   ArrayRef<wave::RegAllocTransformValue> values,
                   ArrayRef<ResolvedRegAllocValue> resolvedValues,
                   unsigned position) {
  DenseSet<Value> groupValues;
  for (const ResolvedRegAllocValue &value : resolvedValues)
    groupValues.insert(value.first);
  AGPRReliefBridgeCost bridgeCost =
      getAGPRReliefBridgeCost(resolvedValues, groupValues);
  return {getAGPRReliefLiveDwords(set, values, position), bridgeCost.cost,
          bridgeCost.count, bridgeCost.loopCost, getAGPRReliefEnd(set, values)};
}

static bool isBetterAGPRReliefScore(AGPRReliefScore lhs, AGPRReliefScore rhs) {
  int64_t lhsCost = getAGPRReliefPrimaryCost(lhs);
  int64_t rhsCost = getAGPRReliefPrimaryCost(rhs);
  if (lhsCost != rhsCost)
    return lhsCost < rhsCost;
  if (lhs.bridgeCost != rhs.bridgeCost)
    return lhs.bridgeCost < rhs.bridgeCost;
  if (lhs.bridgeCount != rhs.bridgeCount)
    return lhs.bridgeCount < rhs.bridgeCount;
  if (lhs.loopBridgeCost != rhs.loopBridgeCost)
    return lhs.loopBridgeCost < rhs.loopBridgeCost;
  if (lhs.liveDwords != rhs.liveDwords)
    return lhs.liveDwords > rhs.liveDwords;
  return lhs.end > rhs.end;
}

static void addVGPRReliefCandidateId(unsigned id,
                                     SmallVectorImpl<unsigned> &ids,
                                     DenseSet<unsigned> &seen) {
  if (!seen.insert(id).second)
    return;
  ids.push_back(id);
}

static SmallVector<unsigned>
collectVGPRReliefCandidateIds(const RegAllocTransformFailure &failure) {
  SmallVector<unsigned> ids;
  DenseSet<unsigned> seen;
  addVGPRReliefCandidateId(failure.set, ids, seen);
  for (const wave::RegAllocTransformAssignment &overlap : failure.overlaps)
    if (overlap.regClass == waveamdmachine::RegClass::VGPR)
      addVGPRReliefCandidateId(overlap.set, ids, seen);
  return ids;
}

static FailureOr<SmallVector<ResolvedRegAllocValue>>
resolveSetValues(func::FuncOp func, const wave::RegAllocTransformAliasSet &set,
                 ArrayRef<wave::RegAllocTransformValue> values) {
  SmallVector<ResolvedRegAllocValue> resolvedValues;
  resolvedValues.reserve(set.members.size());
  for (unsigned valueId : set.members) {
    const wave::RegAllocTransformValue &value = values[valueId];
    FailureOr<Value> payloadValue = resolveRegAllocStateValue(func, value);
    if (failed(payloadValue))
      return failure();
    resolvedValues.push_back({*payloadValue, &value});
  }
  return resolvedValues;
}

static FailureOr<std::optional<AGPRReliefCandidate>>
buildAGPRReliefCandidate(func::FuncOp func, unsigned setId,
                         const RegAllocTransformFailure &failureRecord,
                         ArrayRef<wave::RegAllocTransformAliasSet> sets,
                         ArrayRef<wave::RegAllocTransformValue> values) {
  const wave::RegAllocTransformAliasSet *set =
      findRegAllocTransformSet(sets, setId);
  if (!set)
    return std::optional<AGPRReliefCandidate>();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveSetValues(func, *set, values);
  if (failed(resolvedValues))
    return failure();
  if (!isAGPRReliefEligibleSet(*set, values, *resolvedValues,
                               failureRecord.position))
    return std::optional<AGPRReliefCandidate>();
  unsigned agprFootprint = 0;
  if (!canAllocateAGPRReliefCandidate(func, *set, sets, values, agprFootprint))
    return std::optional<AGPRReliefCandidate>();
  FailureOr<bool> respectsFamilyBudget = respectsCombinedVGPRFamilyBudget(
      func, *set, failureRecord, sets, agprFootprint);
  if (failed(respectsFamilyBudget))
    return failure();
  if (!*respectsFamilyBudget)
    return std::optional<AGPRReliefCandidate>();

  AGPRReliefCandidate candidate;
  candidate.set = set;
  candidate.values = std::move(*resolvedValues);
  candidate.score = getAGPRReliefScore(*set, values, candidate.values,
                                       failureRecord.position);
  return std::optional<AGPRReliefCandidate>(std::move(candidate));
}

static FailureOr<std::optional<AGPRReliefCandidate>>
selectAGPRReliefCandidate(func::FuncOp func,
                          const RegAllocTransformFailure &failureRecord,
                          ArrayRef<wave::RegAllocTransformAliasSet> sets,
                          ArrayRef<wave::RegAllocTransformValue> values) {
  std::optional<AGPRReliefCandidate> best;
  for (unsigned setId : collectVGPRReliefCandidateIds(failureRecord)) {
    FailureOr<std::optional<AGPRReliefCandidate>> candidate =
        buildAGPRReliefCandidate(func, setId, failureRecord, sets, values);
    if (failed(candidate))
      return failure();
    if (!*candidate)
      continue;
    if (!best || isBetterAGPRReliefScore((*candidate)->score, best->score) ||
        (!isBetterAGPRReliefScore(best->score, (*candidate)->score) &&
         (*candidate)->set->id < best->set->id))
      best = std::move(**candidate);
  }
  return best;
}

static waveamdmachine::RegType
getRegAllocTransformClassType(Value value, waveamdmachine::RegClass regClass) {
  auto type = cast<waveamdmachine::RegType>(value.getType());
  return waveamdmachine::RegType::get(type.getContext(), regClass,
                                      type.getWidth(), /*index=*/-1);
}

static waveamdmachine::VAccvgprWriteB32TupleOp
createAGPRReliefWrite(OpBuilder &builder, Value value) {
  if (Operation *def = value.getDefiningOp()) {
    builder.setInsertionPointAfter(def);
  } else {
    Block *block = cast<BlockArgument>(value).getOwner();
    builder.setInsertionPointToStart(block);
  }
  auto agprType =
      getRegAllocTransformClassType(value, waveamdmachine::RegClass::AGPR);
  auto write = waveamdmachine::VAccvgprWriteB32TupleOp::create(
      builder, value.getLoc(), agprType, value);
  write->setAttr("waveamdmachine.regalloc_debug_temp", builder.getUnitAttr());
  return write;
}

static Value createAGPRReliefRead(OpBuilder &builder, Value agpr,
                                  OpOperand &use) {
  builder.setInsertionPoint(use.getOwner());
  auto vgprType =
      getRegAllocTransformClassType(use.get(), waveamdmachine::RegClass::VGPR);
  auto read = waveamdmachine::VAccvgprReadB32TupleOp::create(
      builder, use.getOwner()->getLoc(), vgprType, agpr);
  read->setAttr("waveamdmachine.regalloc_debug_temp", builder.getUnitAttr());
  return read.getResult();
}

static Value getAGPRReliefReplacement(OpBuilder &builder, Value value,
                                      const DenseSet<Value> &groupValues,
                                      DenseMap<Value, Value> &replacements) {
  if (Value replacement = replacements.lookup(value))
    return replacement;
  if (hasRegAllocTransformClass(value, waveamdmachine::RegClass::AGPR)) {
    setRegAllocTransformClass(value, waveamdmachine::RegClass::AGPR);
    replacements[value] = value;
    return value;
  }
  if (Operation *def = value.getDefiningOp())
    if (canRebankTupleAliasOp(def, groupValues)) {
      setRegAllocTransformClass(value, waveamdmachine::RegClass::AGPR);
      rebankTupleAliasResults(def, waveamdmachine::RegClass::AGPR);
      replacements[value] = value;
      return value;
    }
  if (canDefineAGPR(value)) {
    setRegAllocTransformClass(value, waveamdmachine::RegClass::AGPR);
    replacements[value] = value;
    return value;
  }
  Value replacement = createAGPRReliefWrite(builder, value).getResult();
  replacements[value] = replacement;
  return replacement;
}

static bool rewriteAGPRReliefAliasUse(OpOperand &use, Value agpr,
                                      const DenseSet<Value> &groupValues) {
  Operation *user = use.getOwner();
  if (!canRebankTupleAliasOp(user, groupValues))
    return false;
  use.set(agpr);
  rebankTupleAliasResults(user, waveamdmachine::RegClass::AGPR);
  return true;
}

static bool rewriteAGPRReliefMFMAUse(OpOperand &use, Value agpr,
                                     const DenseSet<Value> &groupValues) {
  auto mfma = dyn_cast<waveamdmachine::MMAOpInterface>(use.getOwner());
  if (!mfma)
    return false;
  if (isMFMAInputUse(mfma, use)) {
    use.set(agpr);
    return true;
  }
  if (!isMFMAAccumulatorUse(mfma, use) ||
      !isReliefGroupValue(mfma.getAccResult(), groupValues))
    return false;
  setRegAllocTransformClass(mfma.getAccResult(),
                            waveamdmachine::RegClass::AGPR);
  mfma.setAcc(agpr);
  return true;
}

static void rewriteAGPRReliefUse(OpBuilder &builder, OpOperand &use, Value agpr,
                                 const DenseSet<Value> &groupValues) {
  if (rewriteAGPRReliefAliasUse(use, agpr, groupValues))
    return;
  if (rewriteAGPRReliefMFMAUse(use, agpr, groupValues))
    return;
  if (isStructuralLoopCarryUse(use.getOwner())) {
    use.set(agpr);
    return;
  }
  use.set(createAGPRReliefRead(builder, agpr, use));
}

static void materializeAGPRReliefValue(OpBuilder &builder, Value value,
                                       const DenseSet<Value> &groupValues,
                                       DenseMap<Value, Value> &replacements) {
  Value agpr =
      getAGPRReliefReplacement(builder, value, groupValues, replacements);
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : value.getUses())
    if (agpr == value || use.getOwner() != agpr.getDefiningOp())
      uses.push_back(&use);
  for (OpOperand *use : uses)
    if (use->get() == value)
      rewriteAGPRReliefUse(builder, *use, agpr, groupValues);
}

static void materializeAGPRRelief(OpBuilder &builder,
                                  const AGPRReliefCandidate &candidate) {
  DenseSet<Value> groupValues;
  DenseMap<Value, Value> replacements;
  for (const ResolvedRegAllocValue &value : candidate.values)
    groupValues.insert(value.first);
  for (const ResolvedRegAllocValue &value : candidate.values)
    materializeAGPRReliefValue(builder, value.first, groupValues, replacements);
}

static bool isRematRelievableFailureClass(StringRef className) {
  return className == "vgpr" || className == "vgpr_agpr";
}

static bool isRematRelievableFailureReason(StringRef reason) {
  return reason == "pressure" || reason == "allocated-footprint";
}

static bool isRematRelievableFailure(const RegAllocTransformFailure &failure) {
  return isRematRelievableFailureClass(failure.className) &&
         isRematRelievableFailureReason(failure.reason);
}

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

static RematReliefContext
buildRematReliefContext(func::FuncOp func,
                        ArrayRef<ResolvedRegAllocValue> values) {
  RematReliefContext context;
  collectRegAllocOpPositions(func.getBody(), context.positions);
  for (ResolvedRegAllocValue value : values)
    context.values[value.first] = value.second;
  return context;
}

static Operation *getAncestorInBlock(Operation *op, Block *block) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (cur->getBlock() == block)
      return cur;
  return nullptr;
}

static bool useIsDominatedByDef(Operation *def, Operation *user) {
  if (user->getBlock() == def->getBlock())
    return true;
  Operation *ancestor = getAncestorInBlock(user, def->getBlock());
  return ancestor && def->isBeforeInBlock(ancestor);
}

static bool insertionBeforeDominatesUse(Operation *anchor, Operation *user) {
  if (anchor == user)
    return true;
  if (anchor->getBlock() == user->getBlock())
    return anchor->isBeforeInBlock(user);
  Operation *ancestor = getAncestorInBlock(user, anchor->getBlock());
  return ancestor && (ancestor == anchor || anchor->isBeforeInBlock(ancestor));
}

static bool valueIsAvailableAt(Value value, Operation *user) {
  if (Operation *def = value.getDefiningOp())
    return useIsDominatedByDef(def, user);
  auto arg = dyn_cast<BlockArgument>(value);
  if (!arg)
    return false;
  Operation *parent = arg.getOwner()->getParentOp();
  if (isa_and_nonnull<func::FuncOp>(parent))
    return true;
  return getAncestorInBlock(user, arg.getOwner()) != nullptr;
}

static bool isTrackedRegValue(Value value) {
  return wave::getRegAllocTransformTrackedRegType(value).has_value();
}

static bool isAnchoredRematSource(Value value) {
  Operation *def = value.getDefiningOp();
  return isa_and_nonnull<
      waveamdmachine::KernargPreloadOp, waveamdmachine::SWorkgroupIdXOp,
      waveamdmachine::SWorkgroupIdYOp, waveamdmachine::SWorkgroupIdZOp,
      waveamdmachine::VWorkitemIdXOp>(def);
}

static bool isCheapRematRoot(Operation *op) {
  return isa_and_nonnull<
      waveamdmachine::SAddI32Op, waveamdmachine::SLshlB32Op,
      waveamdmachine::SLshrB32Op, waveamdmachine::SAndB32Op,
      waveamdmachine::SOrB32Op, waveamdmachine::SXorB32Op,
      waveamdmachine::UninitOp, waveamdmachine::VMovB32TupleOp,
      waveamdmachine::VLshrrevB32Op, waveamdmachine::VLshlrevB32Op,
      waveamdmachine::VLshlAddU32Op, waveamdmachine::VAddU32Op,
      waveamdmachine::VAdd3U32Op, waveamdmachine::VAndB32Op,
      waveamdmachine::VMulLoU32Op, waveamdmachine::VAddLshlU32Op,
      waveamdmachine::VXorB32Op, waveamdmachine::VAndOrB32Op,
      waveamdmachine::TupleFromElementsOp, waveamdmachine::TupleToElementsOp>(
      op);
}

static bool isRematRootValue(Value value) {
  Operation *def = value.getDefiningOp();
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  return def && type && type.getIndex() < 0 && !isAnchoredRematSource(value) &&
         !wave::regalloc::isRegAllocRematTempOp(def) && isCheapRematRoot(def) &&
         !isRegAllocTransformBridgeRelated(value);
}

static std::optional<unsigned>
getRematOpPosition(Operation *op, const RematReliefContext &context) {
  auto it = context.positions.find(op);
  if (it == context.positions.end())
    return std::nullopt;
  return it->second;
}

static bool isStateValueLiveAt(Value value, unsigned position,
                               const RematReliefContext &context) {
  auto it = context.values.find(value);
  if (it == context.values.end())
    return false;
  const wave::RegAllocTransformValue &stateValue = *it->second;
  return stateValue.start <= position && position <= stateValue.end;
}

static bool mustRematValue(Value value,
                           const DenseSet<Value> *forcedRematValues) {
  return forcedRematValues && forcedRematValues->contains(value);
}

static bool
isRematValueLiveAtFailure(Value value,
                          const RegAllocTransformFailure &failureRecord,
                          const RematReliefContext &context) {
  auto it = context.values.find(value);
  if (it == context.values.end())
    return false;
  const wave::RegAllocTransformValue &stateValue = *it->second;
  unsigned position = failureRecord.position;
  return stateValue.start < position && position < stateValue.end;
}

static bool
canUseOriginalRematLeaf(Value value, Operation *user,
                        const RegAllocTransformFailure &failureRecord,
                        const RematReliefContext &context,
                        const DenseSet<Value> *forcedRematValues) {
  if (mustRematValue(value, forcedRematValues))
    return false;
  if (!valueIsAvailableAt(value, user))
    return false;
  if (isRematRootValue(value) &&
      isRematValueLiveAtFailure(value, failureRecord, context))
    return false;
  if (!isTrackedRegValue(value))
    return true;
  std::optional<unsigned> position = getRematOpPosition(user, context);
  return position && isStateValueLiveAt(value, *position, context);
}

static bool
canExtendOriginalRematLeaf(Value value, Operation *user,
                           const RematReliefContext &context,
                           const DenseSet<Value> *forcedRematValues) {
  return !mustRematValue(value, forcedRematValues) &&
         isTrackedRegValue(value) && context.values.contains(value) &&
         valueIsAvailableAt(value, user);
}

static bool collectExtendedRematLeaves(
    Value value, Operation *user, const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, DenseSet<Value> &visiting,
    const DenseSet<Value> *forcedRematValues, DenseSet<Value> &extendedLeaves);

static bool collectExtendedRematOperandLeaves(
    Value operand, Operation *user,
    const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, DenseSet<Value> &visiting,
    const DenseSet<Value> *forcedRematValues, DenseSet<Value> &extendedLeaves) {
  if (canUseOriginalRematLeaf(operand, user, failureRecord, context,
                              forcedRematValues))
    return true;
  DenseSet<Value> rematLeaves = extendedLeaves;
  if (collectExtendedRematLeaves(operand, user, failureRecord, context,
                                 visiting, forcedRematValues, rematLeaves)) {
    extendedLeaves = std::move(rematLeaves);
    return true;
  }
  if (canExtendOriginalRematLeaf(operand, user, context, forcedRematValues)) {
    extendedLeaves.insert(operand);
    return true;
  }
  return false;
}

static bool collectExtendedRematLeaves(
    Value value, Operation *user, const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, DenseSet<Value> &visiting,
    const DenseSet<Value> *forcedRematValues, DenseSet<Value> &extendedLeaves) {
  Operation *def = value.getDefiningOp();
  if (!isRematRootValue(value) || !valueIsAvailableAt(value, user))
    return false;
  if (!visiting.insert(value).second)
    return false;
  bool ok = llvm::all_of(def->getOperands(), [&](Value operand) {
    return collectExtendedRematOperandLeaves(operand, user, failureRecord,
                                             context, visiting,
                                             forcedRematValues, extendedLeaves);
  });
  visiting.erase(value);
  return ok;
}

static FailureOr<SmallVector<Value>>
collectExtendedRematLeaves(Value value, Operation *user,
                           const RegAllocTransformFailure &failureRecord,
                           const RematReliefContext &context,
                           const DenseSet<Value> *forcedRematValues) {
  DenseSet<Value> visiting;
  DenseSet<Value> extendedLeaves;
  if (!collectExtendedRematLeaves(value, user, failureRecord, context, visiting,
                                  forcedRematValues, extendedLeaves))
    return failure();
  SmallVector<Value> leaves(extendedLeaves.begin(), extendedLeaves.end());
  llvm::sort(leaves, [&](Value lhs, Value rhs) {
    return context.values.lookup(lhs)->id < context.values.lookup(rhs)->id;
  });
  return leaves;
}

static unsigned getRematOpCountAt(Value value, Operation *user,
                                  const RegAllocTransformFailure &failureRecord,
                                  const RematReliefContext &context,
                                  DenseSet<Value> &counted,
                                  const DenseSet<Value> *forcedRematValues) {
  if (!counted.insert(value).second)
    return 0;
  unsigned count = 1;
  Operation *def = value.getDefiningOp();
  for (Value operand : def->getOperands()) {
    if (canUseOriginalRematLeaf(operand, user, failureRecord, context,
                                forcedRematValues))
      continue;
    FailureOr<SmallVector<Value>> extendedLeaves = collectExtendedRematLeaves(
        operand, user, failureRecord, context, forcedRematValues);
    if (succeeded(extendedLeaves))
      count += getRematOpCountAt(operand, user, failureRecord, context, counted,
                                 forcedRematValues);
  }
  return count;
}

static unsigned getRematOpCountAt(Value value, Operation *user,
                                  const RegAllocTransformFailure &failureRecord,
                                  const RematReliefContext &context,
                                  const DenseSet<Value> *forcedRematValues) {
  DenseSet<Value> counted;
  return getRematOpCountAt(value, user, failureRecord, context, counted,
                           forcedRematValues);
}

static int64_t getLoopCostScale(unsigned depth) {
  if (depth == 0)
    return 1;
  return int64_t{1} << std::min<unsigned>(depth * 4, 20);
}

static int64_t getRematReliefLoopCostScale(Operation *op) {
  unsigned depth = 0;
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(cur))
      ++depth;
  return getLoopCostScale(depth);
}

static int64_t getParentLoopCostScale(Operation *op) {
  unsigned depth = 0;
  for (Operation *cur = op->getParentOp(); cur; cur = cur->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(cur))
      ++depth;
  return getLoopCostScale(depth);
}

static int64_t getMemoryBridgeCostScale(Operation *anchor, bool beforeAnchor) {
  if (beforeAnchor && isa<waveamdmachine::UniformLoopOp>(anchor))
    return getParentLoopCostScale(anchor);
  return getRematReliefLoopCostScale(anchor);
}

static FailureOr<SmallVector<OpOperand *>>
collectSortedRematPostFailureUses(Value value,
                                  const RegAllocTransformFailure &failureRecord,
                                  const RematReliefContext &context) {
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : value.getUses()) {
    std::optional<unsigned> position =
        getRematOpPosition(use.getOwner(), context);
    if (!position)
      return failure();
    if (*position >= failureRecord.position)
      uses.push_back(&use);
  }
  llvm::stable_sort(uses, [&](OpOperand *lhs, OpOperand *rhs) {
    return context.positions.lookup(lhs->getOwner()) <
           context.positions.lookup(rhs->getOwner());
  });
  return uses;
}

static FailureOr<SmallVector<SmallVector<OpOperand *>>>
collectRematPostFailureUseGroups(Value value,
                                 const RegAllocTransformFailure &failureRecord,
                                 const RematReliefContext &context) {
  FailureOr<SmallVector<OpOperand *>> sortedUses =
      collectSortedRematPostFailureUses(value, failureRecord, context);
  if (failed(sortedUses))
    return failure();

  SmallVector<SmallVector<OpOperand *>> groups;
  while (!sortedUses->empty()) {
    Operation *anchor = sortedUses->front()->getOwner();
    SmallVector<OpOperand *> group;
    SmallVector<OpOperand *> remaining;
    for (OpOperand *use : *sortedUses) {
      if (insertionBeforeDominatesUse(anchor, use->getOwner()))
        group.push_back(use);
      else
        remaining.push_back(use);
    }
    groups.push_back(std::move(group));
    *sortedUses = std::move(remaining);
  }
  return groups;
}

static bool isRematCandidateSet(const wave::RegAllocTransformAliasSet &set,
                                ArrayRef<wave::RegAllocTransformValue> values,
                                const RegAllocTransformFailure &failureRecord) {
  unsigned position = failureRecord.position;
  return set.regClass == waveamdmachine::RegClass::VGPR &&
         (set.start < position ||
          (set.id == failureRecord.set && set.start == position)) &&
         position < set.end && !hasFixedRegAllocValue(set, values);
}

static bool
hasStructuralLoopCarryUse(ArrayRef<ResolvedRegAllocValue> resolvedValues) {
  return llvm::any_of(resolvedValues, [](ResolvedRegAllocValue resolved) {
    return hasStructuralLoopCarryUse(resolved.first);
  });
}

static bool
isRematValueLiveAcrossFailure(const wave::RegAllocTransformValue &stateValue,
                              unsigned position) {
  return stateValue.start < position && position < stateValue.end;
}

static bool
canRematValueRelieveFailure(const wave::RegAllocTransformValue &stateValue,
                            const RegAllocTransformFailure &failureRecord) {
  unsigned position = failureRecord.position;
  if (stateValue.set == failureRecord.set)
    return stateValue.start <= position && position < stateValue.end;
  return isRematValueLiveAcrossFailure(stateValue, position);
}

static bool
aliasSetLiveAtPosition(const wave::RegAllocTransformAliasSet &set,
                       ArrayRef<wave::RegAllocTransformValue> values,
                       unsigned position) {
  return llvm::any_of(set.members, [&](unsigned valueId) {
    const wave::RegAllocTransformValue &value = values[valueId];
    return value.start <= position && position <= value.end;
  });
}

static RegClassPressure
getRegClassPressureAtPosition(ArrayRef<wave::RegAllocTransformAliasSet> sets,
                              ArrayRef<wave::RegAllocTransformValue> values,
                              unsigned position) {
  RegClassPressure pressure = {};
  for (const wave::RegAllocTransformAliasSet &set : sets)
    if (aliasSetLiveAtPosition(set, values, position))
      addRegClassPressure(pressure, set.regClass, set.width);
  return pressure;
}

static bool
extendedLeafAddsPressureAtFailure(Value leaf, const RematReliefSlot &slot,
                                  const RegAllocTransformFailure &failureRecord,
                                  const RematReliefContext &context) {
  auto it = context.values.find(leaf);
  if (it == context.values.end())
    return false;
  const wave::RegAllocTransformValue &stateValue = *it->second;
  unsigned position = failureRecord.position;
  if (stateValue.start > position || slot.rebuildPosition < position)
    return false;
  return !isStateValueLiveAt(leaf, position, context);
}

static RegClassPressure
getRematExtendedLeafPressure(const RematReliefCandidate &candidate,
                             const RegAllocTransformFailure &failureRecord,
                             ArrayRef<wave::RegAllocTransformAliasSet> sets,
                             const RematReliefContext &context) {
  RegClassPressure pressure = {};
  DenseSet<unsigned> countedSets;
  for (const RematReliefSlot &slot : candidate.slots) {
    for (Value leaf : slot.extendedLeaves) {
      auto it = context.values.find(leaf);
      if (it == context.values.end())
        continue;
      const wave::RegAllocTransformValue &stateValue = *it->second;
      if (!extendedLeafAddsPressureAtFailure(leaf, slot, failureRecord,
                                             context) ||
          !countedSets.insert(stateValue.set).second)
        continue;
      const wave::RegAllocTransformAliasSet *set =
          findRegAllocTransformSet(sets, stateValue.set);
      addRegClassPressure(pressure, stateValue.regClass,
                          set ? set->width : stateValue.width);
    }
  }
  return pressure;
}

static RegClassPressure
getRematRemovedPressure(const RematReliefCandidate &candidate) {
  RegClassPressure pressure = {};
  addRegClassPressure(pressure, candidate.set->regClass, candidate.set->width);
  return pressure;
}

static bool pressureFitsRegClassBudgets(func::FuncOp func,
                                        RegClassPressure pressure) {
  for (waveamdmachine::RegClass regClass : kRegClasses) {
    int64_t dwords = pressure[getRegClassIndex(regClass)];
    if (dwords < 0)
      return false;
    wave::RegAllocTransformBudget budget =
        wave::getRegAllocTransformBudget(func, regClass);
    if (static_cast<uint64_t>(dwords) > budget.limit)
      return false;
  }
  return true;
}

static bool rematCandidateReducesFailurePressure(
    func::FuncOp func, const RematReliefCandidate &candidate,
    const RegAllocTransformFailure &failureRecord,
    ArrayRef<wave::RegAllocTransformAliasSet> sets,
    ArrayRef<wave::RegAllocTransformValue> values,
    const RematReliefContext &context) {
  RegClassPressure added =
      getRematExtendedLeafPressure(candidate, failureRecord, sets, context);
  RegClassPressure removed = getRematRemovedPressure(candidate);
  if (getTotalPressure(removed) <= getTotalPressure(added))
    return false;
  RegClassPressure pressure =
      getRegClassPressureAtPosition(sets, values, failureRecord.position);
  for (waveamdmachine::RegClass regClass : kRegClasses)
    pressure[getRegClassIndex(regClass)] +=
        added[getRegClassIndex(regClass)] - removed[getRegClassIndex(regClass)];
  return pressureFitsRegClassBudgets(func, pressure);
}

static bool
rematCandidateUsesFailurePosition(const RematReliefCandidate &candidate,
                                  const RegAllocTransformFailure &failureRecord,
                                  const RematReliefContext &context) {
  return llvm::any_of(candidate.slots, [&](const RematReliefSlot &slot) {
    return llvm::any_of(slot.uses, [&](OpOperand *use) {
      return context.positions.lookup(use->getOwner()) ==
             failureRecord.position;
    });
  });
}

static FailureOr<RematReliefSlot> buildRematReliefSlot(
    Value value, const wave::RegAllocTransformValue &stateValue,
    const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, const DenseSet<Value> &forcedRematValues,
    SmallVector<OpOperand *> uses) {
  Operation *rebuildOp = uses.front()->getOwner();
  FailureOr<SmallVector<Value>> extendedLeaves = collectExtendedRematLeaves(
      value, rebuildOp, failureRecord, context, &forcedRematValues);
  if (failed(extendedLeaves))
    return failure();
  unsigned opCount = getRematOpCountAt(value, rebuildOp, failureRecord, context,
                                       &forcedRematValues);
  int64_t cost = opCount * getRematReliefLoopCostScale(rebuildOp) + uses.size();
  RematReliefSlot slot;
  slot.uses = std::move(uses);
  slot.extendedLeaves = std::move(*extendedLeaves);
  slot.value = value;
  slot.rebuildOp = rebuildOp;
  slot.stateValue = &stateValue;
  slot.cost = cost;
  slot.opCount = opCount;
  slot.rebuildPosition = context.positions.lookup(rebuildOp);
  return slot;
}

static void sortRematReliefSlots(MutableArrayRef<RematReliefSlot> slots) {
  llvm::stable_sort(slots,
                    [](const RematReliefSlot &lhs, const RematReliefSlot &rhs) {
                      return std::tie(lhs.rebuildPosition, lhs.stateValue->id) <
                             std::tie(rhs.rebuildPosition, rhs.stateValue->id);
                    });
}

static void addForcedRematValues(ArrayRef<ResolvedRegAllocValue> values,
                                 const RegAllocTransformFailure &failureRecord,
                                 SmallVectorImpl<Value> &rematValues,
                                 DenseSet<Value> &forcedRematValues) {
  for (ResolvedRegAllocValue resolved : values)
    if (canRematValueRelieveFailure(*resolved.second, failureRecord)) {
      rematValues.push_back(resolved.first);
      forcedRematValues.insert(resolved.first);
    }
}

static FailureOr<bool>
addRematReliefSlot(Value value, const wave::RegAllocTransformValue &stateValue,
                   const RegAllocTransformFailure &failureRecord,
                   const RematReliefContext &context,
                   const DenseSet<Value> &forcedRematValues,
                   RematReliefCandidate &candidate) {
  if (!canRematValueRelieveFailure(stateValue, failureRecord))
    return true;
  if (stateValue.fixed || !isRematRootValue(value))
    return false;
  FailureOr<SmallVector<SmallVector<OpOperand *>>> useGroups =
      collectRematPostFailureUseGroups(value, failureRecord, context);
  if (failed(useGroups))
    return failure();
  if (useGroups->empty())
    return false;
  for (SmallVector<OpOperand *> &uses : *useGroups) {
    FailureOr<RematReliefSlot> slot =
        buildRematReliefSlot(value, stateValue, failureRecord, context,
                             forcedRematValues, std::move(uses));
    if (failed(slot))
      return false;
    candidate.cost += slot->cost;
    candidate.slots.push_back(std::move(*slot));
  }
  return true;
}

static void
eraseDeadRematProducerTree(Operation *op,
                           const DenseSet<Operation *> &protectedDefs) {
  if (!op || !isOpTriviallyDead(op))
    return;
  SmallVector<Operation *> producers;
  for (Value operand : op->getOperands())
    if (Operation *producer = operand.getDefiningOp())
      if (!protectedDefs.contains(producer))
        producers.push_back(producer);
  op->erase();
  for (Operation *producer : producers)
    eraseDeadRematProducerTree(producer, protectedDefs);
}

static void eraseDeadRematDefs(ArrayRef<RematReliefSlot> slots) {
  SmallVector<Operation *> defs;
  DenseSet<Operation *> seen;
  for (const RematReliefSlot &slot : slots) {
    Operation *def = slot.value.getDefiningOp();
    if (def && seen.insert(def).second)
      defs.push_back(def);
  }
  for (Operation *def : llvm::reverse(defs))
    eraseDeadRematProducerTree(def, seen);
}

static FailureOr<bool>
addRematReliefSlotsForSet(ArrayRef<ResolvedRegAllocValue> resolvedValues,
                          const RegAllocTransformFailure &failureRecord,
                          const RematReliefContext &context,
                          const DenseSet<Value> &forcedRematValues,
                          RematReliefCandidate &candidate) {
  for (ResolvedRegAllocValue resolved : resolvedValues) {
    FailureOr<bool> added =
        addRematReliefSlot(resolved.first, *resolved.second, failureRecord,
                           context, forcedRematValues, candidate);
    if (failed(added))
      return failure();
    if (!*added)
      return false;
  }
  return true;
}

static bool rematCandidatePassesPressureCheck(
    func::FuncOp func, const RematReliefCandidate &candidate,
    const RegAllocTransformFailure &failureRecord,
    ArrayRef<wave::RegAllocTransformAliasSet> sets,
    ArrayRef<wave::RegAllocTransformValue> values,
    const RematReliefContext &context) {
  if (rematCandidateUsesFailurePosition(candidate, failureRecord, context))
    return true;
  return rematCandidateReducesFailurePressure(func, candidate, failureRecord,
                                              sets, values, context);
}

static FailureOr<std::optional<RematReliefCandidate>>
buildRematReliefCandidate(func::FuncOp func, unsigned setId,
                          const RegAllocTransformFailure &failureRecord,
                          ArrayRef<wave::RegAllocTransformAliasSet> sets,
                          ArrayRef<wave::RegAllocTransformValue> values,
                          const RematReliefContext &context) {
  const wave::RegAllocTransformAliasSet *set =
      findRegAllocTransformSet(sets, setId);
  if (!set || !isRematCandidateSet(*set, values, failureRecord))
    return std::optional<RematReliefCandidate>();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveSetValues(func, *set, values);
  if (failed(resolvedValues))
    return failure();
  if (hasStructuralLoopCarryUse(*resolvedValues))
    return std::optional<RematReliefCandidate>();

  RematReliefCandidate candidate;
  DenseSet<Value> forcedRematValues;
  candidate.set = set;
  addForcedRematValues(*resolvedValues, failureRecord, candidate.rematValues,
                       forcedRematValues);
  FailureOr<bool> added = addRematReliefSlotsForSet(
      *resolvedValues, failureRecord, context, forcedRematValues, candidate);
  if (failed(added))
    return failure();
  if (!*added)
    return std::optional<RematReliefCandidate>();
  if (candidate.slots.empty())
    return std::optional<RematReliefCandidate>();
  sortRematReliefSlots(candidate.slots);
  if (!rematCandidatePassesPressureCheck(func, candidate, failureRecord, sets,
                                         values, context))
    return std::optional<RematReliefCandidate>();
  return std::optional<RematReliefCandidate>(std::move(candidate));
}

static bool
isBetterRematSetCandidate(const RematReliefCandidate &candidate,
                          const std::optional<RematReliefCandidate> &best) {
  if (!best)
    return true;
  if (candidate.cost != best->cost)
    return candidate.cost < best->cost;
  return candidate.set->id < best->set->id;
}

static FailureOr<std::optional<RematReliefCandidate>>
selectRematReliefCandidate(func::FuncOp func,
                           const RegAllocTransformFailure &failureRecord,
                           ArrayRef<wave::RegAllocTransformAliasSet> sets,
                           ArrayRef<wave::RegAllocTransformValue> values,
                           const RematReliefContext &context) {
  std::optional<RematReliefCandidate> best;
  for (unsigned setId : collectVGPRReliefCandidateIds(failureRecord)) {
    FailureOr<std::optional<RematReliefCandidate>> candidate =
        buildRematReliefCandidate(func, setId, failureRecord, sets, values,
                                  context);
    if (failed(candidate))
      return failure();
    if (!*candidate)
      continue;
    if (isBetterRematSetCandidate(**candidate, best))
      best = std::move(**candidate);
  }
  return best;
}

static FailureOr<Value>
materializeRematValueAt(OpBuilder &builder, Value value, Operation *user,
                        const RegAllocTransformFailure &failureRecord,
                        const RematReliefContext &context,
                        DenseMap<Value, Value> &cache,
                        const DenseSet<Value> &forcedRematValues) {
  auto cached = cache.find(value);
  if (cached != cache.end())
    return cached->second;
  Operation *def = value.getDefiningOp();
  if (!def || !isRematRootValue(value))
    return failure();

  IRMapping mapping;
  for (Value operand : def->getOperands()) {
    Value mapped = operand;
    if (!canUseOriginalRematLeaf(operand, user, failureRecord, context,
                                 &forcedRematValues)) {
      FailureOr<SmallVector<Value>> extendedLeaves = collectExtendedRematLeaves(
          operand, user, failureRecord, context, &forcedRematValues);
      if (succeeded(extendedLeaves)) {
        FailureOr<Value> rematOperand =
            materializeRematValueAt(builder, operand, user, failureRecord,
                                    context, cache, forcedRematValues);
        if (failed(rematOperand))
          return failure();
        mapped = *rematOperand;
      } else if (canExtendOriginalRematLeaf(operand, user, context,
                                            &forcedRematValues)) {
        mapped = operand;
      } else {
        return failure();
      }
    }
    mapping.map(operand, mapped);
  }

  Operation *clone = builder.clone(*def, mapping);
  clone->setAttr(wave::regalloc::kRegAllocRematTempAttr, builder.getUnitAttr());
  Value result = clone->getResult(cast<OpResult>(value).getResultNumber());
  cache[value] = result;
  return result;
}

static LogicalResult materializeRematReliefSlot(
    OpBuilder &builder, const RematReliefSlot &slot,
    const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, const DenseSet<Value> &forcedRematValues,
    SmallVectorImpl<std::pair<const RematReliefSlot *, Value>> &rebuiltSlots) {
  builder.setInsertionPoint(slot.rebuildOp);
  DenseMap<Value, Value> cache;
  FailureOr<Value> rebuilt =
      materializeRematValueAt(builder, slot.value, slot.rebuildOp,
                              failureRecord, context, cache, forcedRematValues);
  if (failed(rebuilt))
    return failure();
  rebuiltSlots.push_back({&slot, *rebuilt});
  return success();
}

static LogicalResult
materializeRematRelief(OpBuilder &builder,
                       const RematReliefCandidate &candidate,
                       const RegAllocTransformFailure &failureRecord,
                       const RematReliefContext &context) {
  DenseSet<Value> forcedRematValues(candidate.rematValues.begin(),
                                    candidate.rematValues.end());
  SmallVector<std::pair<const RematReliefSlot *, Value>> rebuiltSlots;
  rebuiltSlots.reserve(candidate.slots.size());
  for (const RematReliefSlot &slot : candidate.slots)
    if (failed(materializeRematReliefSlot(builder, slot, failureRecord, context,
                                          forcedRematValues, rebuiltSlots)))
      return failure();
  for (auto [slot, rebuilt] : rebuiltSlots)
    for (OpOperand *use : slot->uses)
      use->set(rebuilt);
  eraseDeadRematDefs(candidate.slots);
  return success();
}

static bool isRegAllocTransformTempOp(Operation *op) {
  return op && op->hasAttr(wave::regalloc::kRegAllocTempAttr);
}

static bool isRegAllocTransformTempValue(Value value) {
  return isRegAllocTransformTempOp(value.getDefiningOp());
}

static bool
isInternalPlannedTupleFromElementsUse(OpOperand *use,
                                      const DenseSet<Value> &plannedValues) {
  auto fromElements =
      dyn_cast<waveamdmachine::TupleFromElementsOp>(use->getOwner());
  return fromElements && plannedValues.contains(fromElements.getTuple());
}

static FailureOr<SmallVector<OpOperand *>> collectMemoryReliefUses(
    Value value, const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, const DenseSet<Value> &plannedValues) {
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : value.getUses()) {
    Operation *user = use.getOwner();
    if (isRegAllocTransformTempOp(user))
      continue;
    if (isa<waveamdmachine::ContinueIfOp>(user)) {
      uses.clear();
      return uses;
    }
    std::optional<unsigned> position = getRematOpPosition(user, context);
    if (!position)
      return failure();
    if (*position == failureRecord.position) {
      uses.clear();
      return uses;
    }
    if (*position > failureRecord.position &&
        !isInternalPlannedTupleFromElementsUse(&use, plannedValues))
      uses.push_back(&use);
  }
  llvm::stable_sort(uses, [&](OpOperand *lhs, OpOperand *rhs) {
    return context.positions.lookup(lhs->getOwner()) <
           context.positions.lookup(rhs->getOwner());
  });
  return uses;
}

static std::optional<unsigned> getUnsignedIntegerAttr(Operation *op,
                                                      StringRef name) {
  if (!op)
    return std::nullopt;
  auto attr = op->getAttrOfType<IntegerAttr>(name);
  if (!attr)
    return std::nullopt;
  int64_t value = attr.getInt();
  if (value < 0 ||
      static_cast<uint64_t>(value) > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  return static_cast<unsigned>(value);
}

static Attribute findAncestorAttr(Operation *op, StringRef name) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (Attribute attr = cur->getAttr(name))
      return attr;
  return {};
}

static FailureOr<unsigned> getLDSTransformTargetWaves(func::FuncOp func) {
  Attribute attr = findAncestorAttr(func, "waveamdmachine.target_waves");
  if (!attr)
    return 0;
  auto intAttr = dyn_cast<IntegerAttr>(attr);
  if (!intAttr)
    return func.emitError("regalloc transform LDS relief target_waves must be "
                          "an integer attribute");
  int64_t value = intAttr.getInt();
  if (value <= 0)
    return func.emitError(
        "regalloc transform LDS relief target_waves must be positive");
  if (static_cast<uint64_t>(value) > std::numeric_limits<unsigned>::max())
    return func.emitError(
        "regalloc transform LDS relief target_waves exceeds supported range");
  return static_cast<unsigned>(value);
}

static FailureOr<wave::regalloc::RegisterBudgets>
getLDSTransformBudgets(func::FuncOp func) {
  FailureOr<unsigned> targetWaves = getLDSTransformTargetWaves(func);
  if (failed(targetWaves))
    return failure();
  wave::regalloc::RegisterBudgets budgets;
  budgets.targetWaves = *targetWaves;
  return budgets;
}

static bool
isMemoryReliefCandidateSet(const wave::RegAllocTransformAliasSet &set,
                           ArrayRef<wave::RegAllocTransformValue> values,
                           unsigned position) {
  return set.regClass == waveamdmachine::RegClass::VGPR &&
         set.start < position && position < set.end &&
         !hasFixedRegAllocValue(set, values);
}

static bool
isMemoryValueLiveAcrossFailure(const wave::RegAllocTransformValue &stateValue,
                               unsigned position) {
  return stateValue.start < position && position < stateValue.end;
}

static void addPlannedMemoryReliefValues(ArrayRef<ResolvedRegAllocValue> values,
                                         unsigned position,
                                         DenseSet<Value> &plannedValues) {
  for (ResolvedRegAllocValue resolved : values)
    if (isMemoryValueLiveAcrossFailure(*resolved.second, position))
      plannedValues.insert(resolved.first);
}

static unsigned getCommittedLDSSpillBytes(func::FuncOp func) {
  return getUnsignedIntegerAttr(func.getOperation(),
                                wave::regalloc::kLDSSpillBytesAttr)
      .value_or(0);
}

static LDSReliefPlanningState
getLDSReliefPlanningState(func::FuncOp func,
                          wave::regalloc::RegisterBudgets budgets) {
  LDSReliefPlanningState state;
  state.budgets = budgets;
  state.committedBytes = getCommittedLDSSpillBytes(func);
  wave::regalloc::getExistingLDSBytes(func, state.fixedLDS, state.dynamicLDS,
                                      state.committedBytes);
  return state;
}

static std::optional<SmallVector<wave::regalloc::LDSSpillPlan, 4>>
getLDSPlansForValue(func::FuncOp func, const LDSReliefPlanningState &planning,
                    waveamdmachine::RegType type, unsigned extraReservedBytes) {
  if (type.getWidth() == 0)
    return std::nullopt;
  SmallVector<wave::regalloc::LDSSpillPlan, 4> plans;
  plans.reserve(type.getWidth());
  unsigned reserved = planning.committedBytes + extraReservedBytes;
  for ([[maybe_unused]] unsigned index :
       llvm::seq<unsigned>(0, type.getWidth())) {
    wave::regalloc::LDSSpillPlan plan = wave::regalloc::planLDSSpillSlot(
        func, planning.budgets, /*valueBytes=*/4, reserved, planning.fixedLDS,
        planning.dynamicLDS);
    if (plan.status != wave::regalloc::LDSSpillPlanStatus::Available)
      return std::nullopt;
    reserved += plan.slotBytes;
    plans.push_back(plan);
  }
  return plans;
}

static unsigned getLDSSlotBytes(ArrayRef<wave::regalloc::LDSSpillPlan> plans) {
  unsigned total = 0;
  for (wave::regalloc::LDSSpillPlan plan : plans)
    total += plan.slotBytes;
  return total;
}

static bool canFoldSlotBaseIntoDSOffset(unsigned slotBase) {
  std::pair<int64_t, int64_t> range = waveamdmachine::instOffsetRange(
      waveamdmachine::DsStoreB32Op::getAddressFieldSpec());
  return slotBase >= static_cast<uint64_t>(range.first) &&
         slotBase <= static_cast<uint64_t>(range.second);
}

static unsigned getLDSAddressOpsPerAccess(wave::regalloc::LDSSpillPlan plan) {
  return canFoldSlotBaseIntoDSOffset(plan.slotBase) ? 1 : 2;
}

static unsigned
getLDSAccessOpCount(ArrayRef<wave::regalloc::LDSSpillPlan> plans) {
  unsigned total = 0;
  for (wave::regalloc::LDSSpillPlan plan : plans)
    total += 1 + getLDSAddressOpsPerAccess(plan);
  return total;
}

static Operation *getValueAnchorOp(Value value) {
  if (Operation *def = value.getDefiningOp())
    return def;
  auto arg = cast<BlockArgument>(value);
  return arg.getOwner()->getParentOp();
}

static int64_t getMemoryLoopCarryInitStoreCost(
    Value init, wave::regalloc::MemorySpillLoopCarrySlot loopCarry,
    unsigned accessOps) {
  OpOperand *loopUse = &loopCarry.loop.getInitsMutable()[loopCarry.index];
  Operation *anchor = wave::regalloc::getLoopCarryInitStoreDiagOp(
      init, loopUse, loopCarry.loop);
  return accessOps * getMemoryBridgeCostScale(
                         anchor, anchor == loopCarry.loop.getOperation());
}

static int64_t getMemoryLoopCarryExtraInitUseCost(
    Value init, wave::regalloc::MemorySpillLoopCarrySlot loopCarry,
    unsigned accessOps) {
  OpOperand *loopUse = &loopCarry.loop.getInitsMutable()[loopCarry.index];
  int64_t cost = 0;
  for (OpOperand &use : init.getUses()) {
    Operation *user = use.getOwner();
    if (&use == loopUse || isRegAllocTransformTempOp(user))
      continue;
    if (!wave::regalloc::canRewriteExtraLoopInitUse(use, loopUse,
                                                    loopCarry.loop))
      continue;
    cost += accessOps * getMemoryBridgeCostScale(user, /*beforeAnchor=*/true);
  }
  return cost;
}

static int64_t getMemoryLoopCarryBodyUseCost(
    wave::regalloc::MemorySpillLoopCarrySlot loopCarry, unsigned accessOps) {
  Block &body = loopCarry.loop.getBody().front();
  BlockArgument arg = body.getArgument(loopCarry.index);
  llvm::SmallDenseSet<Operation *, 8> users;
  int64_t cost = 0;
  for (OpOperand &use : arg.getUses()) {
    if (isa<waveamdmachine::ContinueIfOp>(use.getOwner()))
      continue;
    Operation *anchor =
        wave::regalloc::getAncestorInBlock(use.getOwner(), &body);
    if (!anchor || !users.insert(anchor).second)
      continue;
    cost += accessOps * getMemoryBridgeCostScale(anchor, /*beforeAnchor=*/true);
  }
  return cost;
}

static int64_t getMemoryLoopCarryTerminatorStoreCost(
    wave::regalloc::MemorySpillLoopCarrySlot loopCarry, unsigned accessOps) {
  Block &body = loopCarry.loop.getBody().front();
  auto term = cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
  BlockArgument arg = body.getArgument(loopCarry.index);
  if (term.getCarries()[loopCarry.index] == arg)
    return 0;
  return accessOps *
         getMemoryBridgeCostScale(term.getOperation(), /*beforeAnchor=*/true);
}

static int64_t getMemoryLoopCarryResultUseCost(
    wave::regalloc::MemorySpillLoopCarrySlot loopCarry, unsigned accessOps) {
  if (loopCarry.loop.getResult(loopCarry.index).use_empty())
    return 0;
  return accessOps * getParentLoopCostScale(loopCarry.loop.getOperation());
}

static int64_t
getMemoryLoopCarryReliefCost(Value init,
                             wave::regalloc::MemorySpillLoopCarrySlot loopCarry,
                             unsigned accessOps) {
  int64_t cost = getMemoryLoopCarryInitStoreCost(init, loopCarry, accessOps);
  cost += getMemoryLoopCarryExtraInitUseCost(init, loopCarry, accessOps);
  cost += getMemoryLoopCarryBodyUseCost(loopCarry, accessOps);
  cost += getMemoryLoopCarryTerminatorStoreCost(loopCarry, accessOps);
  cost += getMemoryLoopCarryResultUseCost(loopCarry, accessOps);
  return cost;
}

static int64_t getLDSReliefCost(Value value,
                                ArrayRef<wave::regalloc::LDSSpillPlan> plans,
                                ArrayRef<OpOperand *> uses) {
  unsigned accessOps = getLDSAccessOpCount(plans);
  int64_t cost =
      accessOps * getRematReliefLoopCostScale(getValueAnchorOp(value));
  for (OpOperand *use : uses)
    cost += accessOps * getRematReliefLoopCostScale(use->getOwner());
  return cost;
}

static int64_t
getLDSLoopCarryReliefCost(Value value,
                          ArrayRef<wave::regalloc::LDSSpillPlan> plans,
                          wave::regalloc::MemorySpillLoopCarrySlot loopCarry) {
  unsigned accessOps = getLDSAccessOpCount(plans);
  return getMemoryLoopCarryReliefCost(value, loopCarry, accessOps);
}

template <typename Traits>
static FailureOr<std::optional<typename Traits::Slot>>
buildMemoryReliefSlot(func::FuncOp func, Value value,
                      const wave::RegAllocTransformValue &stateValue,
                      const RegAllocTransformFailure &failureRecord,
                      const RematReliefContext &context,
                      const typename Traits::PlanningState &planning,
                      const DenseSet<Value> &plannedValues,
                      unsigned extraReservedBytes) {
  if (!isMemoryValueLiveAcrossFailure(stateValue, failureRecord.position) ||
      stateValue.fixed || isRegAllocTransformTempValue(value))
    return std::optional<typename Traits::Slot>();
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR ||
      type.getWidth() == 0)
    return std::optional<typename Traits::Slot>();
  FailureOr<SmallVector<OpOperand *>> uses =
      collectMemoryReliefUses(value, failureRecord, context, plannedValues);
  if (failed(uses))
    return failure();
  if (uses->empty())
    return std::optional<typename Traits::Slot>();
  std::optional<typename Traits::Plan> plan =
      Traits::getPlanForValue(func, planning, type, extraReservedBytes);
  if (!plan)
    return std::optional<typename Traits::Slot>();
  typename Traits::Slot slot;
  slot.uses = std::move(*uses);
  slot.plan = std::move(*plan);
  slot.value = value;
  slot.type = type;
  slot.stateValue = &stateValue;
  slot.cost = Traits::getCost(value, slot.plan, type, slot.uses);
  return std::optional<typename Traits::Slot>(std::move(slot));
}

static std::optional<wave::regalloc::MemorySpillLoopCarrySlot>
getMemoryReliefLoopCarrySlot(ArrayRef<ResolvedRegAllocValue> values) {
  std::optional<wave::regalloc::MemorySpillLoopCarrySlot> slot;
  for (ResolvedRegAllocValue resolved : values)
    if (failed(wave::regalloc::mergeLoopCarrySlot(resolved.first, slot)))
      return std::nullopt;
  return slot;
}

static const wave::RegAllocTransformValue *
findMemoryReliefStateValue(ArrayRef<ResolvedRegAllocValue> values,
                           Value value) {
  for (ResolvedRegAllocValue resolved : values)
    if (resolved.first == value)
      return resolved.second;
  return nullptr;
}

static bool
canStoreLoopCarryBeforeFailure(wave::regalloc::MemorySpillLoopCarrySlot slot,
                               Value init,
                               const RegAllocTransformFailure &failureRecord,
                               const RematReliefContext &context) {
  OpOperand *loopUse = &slot.loop.getInitsMutable()[slot.index];
  Operation *storeAnchor =
      wave::regalloc::getLoopCarryInitStoreDiagOp(init, loopUse, slot.loop);
  std::optional<unsigned> storePosition =
      getRematOpPosition(storeAnchor, context);
  return storePosition && *storePosition < failureRecord.position;
}

static bool canMaterializeMemoryLoopCarryRelief(
    wave::regalloc::MemorySpillLoopCarrySlot slot, Value init,
    const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context) {
  return canStoreLoopCarryBeforeFailure(slot, init, failureRecord, context) &&
         wave::regalloc::hasLocalLoopCarryUses(slot) &&
         wave::regalloc::canRewriteExtraLoopInitUses(slot);
}

static bool isMemoryLoopCarryReliefStateValue(
    const wave::RegAllocTransformAliasSet &set,
    const wave::RegAllocTransformValue *stateValue,
    const RegAllocTransformFailure &failureRecord, Value init) {
  if (!stateValue ||
      !isMemoryValueLiveAcrossFailure(*stateValue, failureRecord.position))
    return false;
  return stateValue->offset == 0 && stateValue->width == set.width &&
         !stateValue->fixed && !isRegAllocTransformTempValue(init);
}

static std::optional<waveamdmachine::RegType>
getMemoryLoopCarryReliefRegType(const wave::RegAllocTransformAliasSet &set,
                                Value init) {
  auto type = dyn_cast<waveamdmachine::RegType>(init.getType());
  if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR ||
      type.getWidth() != set.width || type.getWidth() == 0)
    return std::nullopt;
  return type;
}

template <typename Traits>
static FailureOr<std::optional<typename Traits::Candidate>>
buildMemoryLoopCarryReliefCandidate(
    func::FuncOp func, const wave::RegAllocTransformAliasSet &set,
    ArrayRef<ResolvedRegAllocValue> resolvedValues,
    const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context,
    const typename Traits::PlanningState &planning,
    unsigned extraReservedBytes) {
  std::optional<wave::regalloc::MemorySpillLoopCarrySlot> loopCarry =
      getMemoryReliefLoopCarrySlot(resolvedValues);
  if (!loopCarry)
    return std::optional<typename Traits::Candidate>();

  Value init = loopCarry->loop.getInits()[loopCarry->index];
  const wave::RegAllocTransformValue *stateValue =
      findMemoryReliefStateValue(resolvedValues, init);
  if (!isMemoryLoopCarryReliefStateValue(set, stateValue, failureRecord, init))
    return std::optional<typename Traits::Candidate>();
  std::optional<waveamdmachine::RegType> type =
      getMemoryLoopCarryReliefRegType(set, init);
  if (!type)
    return std::optional<typename Traits::Candidate>();
  if (!canMaterializeMemoryLoopCarryRelief(*loopCarry, init, failureRecord,
                                           context))
    return std::optional<typename Traits::Candidate>();

  std::optional<typename Traits::Plan> plan =
      Traits::getPlanForValue(func, planning, *type, extraReservedBytes);
  if (!plan)
    return std::optional<typename Traits::Candidate>();

  typename Traits::Slot slot;
  slot.plan = std::move(*plan);
  slot.value = init;
  slot.type = *type;
  slot.stateValue = stateValue;
  slot.loopCarry = *loopCarry;
  slot.cost = Traits::getLoopCarryCost(init, slot.plan, *type, *loopCarry);

  typename Traits::Candidate candidate;
  candidate.set = &set;
  candidate.reservedBytes = Traits::getSlotBytes(slot.plan);
  candidate.cost = slot.cost;
  candidate.slots.push_back(std::move(slot));
  return std::optional<typename Traits::Candidate>(std::move(candidate));
}

template <typename Traits>
static FailureOr<bool>
addMemoryReliefSlot(func::FuncOp func, ResolvedRegAllocValue resolved,
                    const RegAllocTransformFailure &failureRecord,
                    const RematReliefContext &context,
                    const typename Traits::PlanningState &planning,
                    const DenseSet<Value> &plannedValues,
                    typename Traits::Candidate &candidate) {
  const wave::RegAllocTransformValue &stateValue = *resolved.second;
  if (!isMemoryValueLiveAcrossFailure(stateValue, failureRecord.position))
    return true;
  FailureOr<std::optional<typename Traits::Slot>> slot =
      buildMemoryReliefSlot<Traits>(func, resolved.first, stateValue,
                                    failureRecord, context, planning,
                                    plannedValues, candidate.reservedBytes);
  if (failed(slot))
    return failure();
  if (!*slot)
    return false;
  candidate.cost += (*slot)->cost;
  candidate.reservedBytes += Traits::getSlotBytes((*slot)->plan);
  candidate.slots.push_back(std::move(**slot));
  return true;
}

template <typename SlotT>
static void sortMemoryReliefSlots(SmallVectorImpl<SlotT> &slots) {
  llvm::stable_sort(slots, [](const SlotT &lhs, const SlotT &rhs) {
    return lhs.stateValue->id < rhs.stateValue->id;
  });
}

template <typename Traits>
static FailureOr<std::optional<typename Traits::Candidate>>
buildMemoryReliefCandidate(func::FuncOp func, unsigned setId,
                           const RegAllocTransformFailure &failureRecord,
                           ArrayRef<wave::RegAllocTransformAliasSet> sets,
                           ArrayRef<wave::RegAllocTransformValue> values,
                           const RematReliefContext &context,
                           const typename Traits::PlanningState &planning) {
  const wave::RegAllocTransformAliasSet *set =
      findRegAllocTransformSet(sets, setId);
  if (!set || !isMemoryReliefCandidateSet(*set, values, failureRecord.position))
    return std::optional<typename Traits::Candidate>();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveSetValues(func, *set, values);
  if (failed(resolvedValues))
    return failure();

  FailureOr<std::optional<typename Traits::Candidate>> loopCarryCandidate =
      buildMemoryLoopCarryReliefCandidate<Traits>(
          func, *set, *resolvedValues, failureRecord, context, planning,
          /*extraReservedBytes=*/0);
  if (failed(loopCarryCandidate))
    return failure();
  if (*loopCarryCandidate)
    return loopCarryCandidate;

  DenseSet<Value> plannedValues;
  addPlannedMemoryReliefValues(*resolvedValues, failureRecord.position,
                               plannedValues);
  typename Traits::Candidate candidate;
  candidate.set = set;
  for (ResolvedRegAllocValue resolved : *resolvedValues) {
    FailureOr<bool> added =
        addMemoryReliefSlot<Traits>(func, resolved, failureRecord, context,
                                    planning, plannedValues, candidate);
    if (failed(added))
      return failure();
    if (!*added)
      return std::optional<typename Traits::Candidate>();
  }
  if (candidate.slots.empty())
    return std::optional<typename Traits::Candidate>();
  sortMemoryReliefSlots(candidate.slots);
  return std::optional<typename Traits::Candidate>(std::move(candidate));
}

template <typename CandidateT>
static bool
isBetterMemoryReliefCandidate(const CandidateT &candidate,
                              const std::optional<CandidateT> &best) {
  if (!best)
    return true;
  if (candidate.cost != best->cost)
    return candidate.cost < best->cost;
  return candidate.set->id < best->set->id;
}

template <typename CandidateT>
static bool isMemoryLoopCarryReliefCandidate(const CandidateT &candidate) {
  return !candidate.slots.empty() && candidate.slots.front().loopCarry;
}

template <typename CandidateT>
static bool hasMemoryLoopCarrySlotIndex(const CandidateT &candidate,
                                        unsigned index) {
  return llvm::any_of(candidate.slots, [index](const auto &slot) {
    return slot.loopCarry && slot.loopCarry->index == index;
  });
}

template <typename CandidateT>
static void appendMemoryLoopCarryReliefCandidate(CandidateT &candidate,
                                                 CandidateT next) {
  candidate.cost += next.cost;
  candidate.reservedBytes += next.reservedBytes;
  candidate.slots.append(std::make_move_iterator(next.slots.begin()),
                         std::make_move_iterator(next.slots.end()));
}

template <typename Traits>
static FailureOr<std::optional<typename Traits::Candidate>>
buildExtraMemoryLoopCarryReliefCandidate(
    func::FuncOp func, unsigned setId, const typename Traits::Candidate &base,
    waveamdmachine::UniformLoopOp loop,
    const RegAllocTransformFailure &failureRecord,
    ArrayRef<wave::RegAllocTransformAliasSet> sets,
    ArrayRef<wave::RegAllocTransformValue> values,
    const RematReliefContext &context,
    const typename Traits::PlanningState &planning) {
  if (setId == base.set->id)
    return std::optional<typename Traits::Candidate>();
  const wave::RegAllocTransformAliasSet *set =
      findRegAllocTransformSet(sets, setId);
  if (!set || !isMemoryReliefCandidateSet(*set, values, failureRecord.position))
    return std::optional<typename Traits::Candidate>();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveSetValues(func, *set, values);
  if (failed(resolvedValues))
    return failure();
  FailureOr<std::optional<typename Traits::Candidate>> next =
      buildMemoryLoopCarryReliefCandidate<Traits>(func, *set, *resolvedValues,
                                                  failureRecord, context,
                                                  planning, base.reservedBytes);
  if (failed(next))
    return failure();
  if (!*next || !isMemoryLoopCarryReliefCandidate(**next))
    return std::optional<typename Traits::Candidate>();
  const typename Traits::Slot &slot = (*next)->slots.front();
  if (slot.loopCarry->loop != loop ||
      hasMemoryLoopCarrySlotIndex(base, slot.loopCarry->index))
    return std::optional<typename Traits::Candidate>();
  return std::optional<typename Traits::Candidate>(std::move(**next));
}

template <typename Traits>
static FailureOr<typename Traits::Candidate>
expandMemoryLoopCarryReliefCandidate(
    func::FuncOp func, typename Traits::Candidate candidate,
    ArrayRef<unsigned> candidateIds,
    const RegAllocTransformFailure &failureRecord,
    ArrayRef<wave::RegAllocTransformAliasSet> sets,
    ArrayRef<wave::RegAllocTransformValue> values,
    const RematReliefContext &context,
    const typename Traits::PlanningState &planning) {
  assert(isMemoryLoopCarryReliefCandidate(candidate) &&
         "expected loop-carry memory relief candidate");
  waveamdmachine::UniformLoopOp loop = candidate.slots.front().loopCarry->loop;
  for (unsigned setId : candidateIds) {
    FailureOr<std::optional<typename Traits::Candidate>> next =
        buildExtraMemoryLoopCarryReliefCandidate<Traits>(
            func, setId, candidate, loop, failureRecord, sets, values, context,
            planning);
    if (failed(next))
      return failure();
    if (!*next)
      continue;
    appendMemoryLoopCarryReliefCandidate(candidate, std::move(**next));
  }
  sortMemoryReliefSlots(candidate.slots);
  return candidate;
}

template <typename Traits>
static FailureOr<std::optional<typename Traits::Candidate>>
selectMemoryReliefCandidate(func::FuncOp func,
                            const RegAllocTransformFailure &failureRecord,
                            ArrayRef<wave::RegAllocTransformAliasSet> sets,
                            ArrayRef<wave::RegAllocTransformValue> values,
                            const RematReliefContext &context,
                            const typename Traits::PlanningState &planning) {
  std::optional<typename Traits::Candidate> best;
  SmallVector<unsigned> candidateIds =
      collectVGPRReliefCandidateIds(failureRecord);
  for (unsigned setId : candidateIds) {
    FailureOr<std::optional<typename Traits::Candidate>> candidate =
        buildMemoryReliefCandidate<Traits>(func, setId, failureRecord, sets,
                                           values, context, planning);
    if (failed(candidate))
      return failure();
    if (!*candidate)
      continue;
    if (isMemoryLoopCarryReliefCandidate(**candidate)) {
      FailureOr<typename Traits::Candidate> expanded =
          expandMemoryLoopCarryReliefCandidate<Traits>(
              func, std::move(**candidate), candidateIds, failureRecord, sets,
              values, context, planning);
      if (failed(expanded))
        return failure();
      *candidate =
          std::optional<typename Traits::Candidate>(std::move(*expanded));
    }
    if (isBetterMemoryReliefCandidate(**candidate, best))
      best = std::move(**candidate);
  }
  return best;
}

struct LDSMemoryReliefTraits {
  using Plan = LDSReliefPlan;
  using Slot = LDSReliefSlot;
  using Candidate = LDSReliefCandidate;
  using PlanningState = LDSReliefPlanningState;

  static std::optional<Plan> getPlanForValue(func::FuncOp func,
                                             const PlanningState &planning,
                                             waveamdmachine::RegType type,
                                             unsigned extraReservedBytes) {
    return getLDSPlansForValue(func, planning, type, extraReservedBytes);
  }

  static unsigned getSlotBytes(const Plan &plan) {
    return getLDSSlotBytes(plan);
  }

  static int64_t getCost(Value value, const Plan &plan, waveamdmachine::RegType,
                         ArrayRef<OpOperand *> uses) {
    return getLDSReliefCost(value, plan, uses);
  }

  static int64_t
  getLoopCarryCost(Value value, const Plan &plan, waveamdmachine::RegType,
                   wave::regalloc::MemorySpillLoopCarrySlot loopCarry) {
    return getLDSLoopCarryReliefCost(value, plan, loopCarry);
  }
};

static Value createLDSImm(OpBuilder &builder, Location loc, int64_t value) {
  return waveamdmachine::ImmOp::create(
      builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
      static_cast<uint64_t>(value));
}

static waveamdmachine::RegType getVirtualVGPR1(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::VGPR,
                                      /*width=*/1, /*index=*/-1);
}

static waveamdmachine::RegType getWorkitemIdType(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::VGPR,
                                      /*width=*/1, /*index=*/0);
}

static waveamdmachine::VWorkitemIdXOp getFixedWorkitemIdX(Operation &op) {
  auto workitem = dyn_cast<waveamdmachine::VWorkitemIdXOp>(&op);
  if (!workitem)
    return {};
  waveamdmachine::RegType type =
      cast<waveamdmachine::RegType>(workitem.getType());
  if (type.getIndex() != 0)
    return {};
  return workitem;
}

static bool opUsesValue(Operation *op, Value value) {
  bool found = false;
  op->walk([&](Operation *nested) {
    if (llvm::is_contained(nested->getOperands(), value)) {
      found = true;
      return WalkResult::interrupt();
    }
    return WalkResult::advance();
  });
  return found;
}

static bool valueHasUseAtOrAfter(Value value, Block *block,
                                 Block::iterator stop) {
  for (auto it = stop; it != block->end(); ++it)
    if (opUsesValue(&*it, value))
      return true;
  return false;
}

static Value findLiveWorkitemIdBefore(Block *block, Block::iterator stop) {
  for (auto it = block->begin(); it != stop; ++it) {
    waveamdmachine::VWorkitemIdXOp workitem = getFixedWorkitemIdX(*it);
    if (workitem && valueHasUseAtOrAfter(workitem.getResult(), block, stop))
      return workitem.getResult();
  }
  return {};
}

static Value moveWorkitemIdBefore(Block *block, Block::iterator stop,
                                  OpBuilder &builder) {
  for (auto it = stop; it != block->end(); ++it) {
    waveamdmachine::VWorkitemIdXOp workitem = getFixedWorkitemIdX(*it);
    if (!workitem)
      continue;
    workitem->moveBefore(block, stop);
    builder.setInsertionPointAfter(workitem);
    return workitem.getResult();
  }
  return {};
}

static Value findAvailableWorkitemId(OpBuilder &builder) {
  Block *block = builder.getInsertionBlock();
  if (!block)
    return {};
  Block::iterator stop = builder.getInsertionPoint();
  if (Value workitem = findLiveWorkitemIdBefore(block, stop))
    return workitem;
  if (Value workitem = moveWorkitemIdBefore(block, stop, builder))
    return workitem;
  while (block) {
    Operation *parent = block->getParentOp();
    if (!parent)
      return {};
    block = parent->getBlock();
    if (!block)
      return {};
    stop = parent->getIterator();
    if (Value workitem = findLiveWorkitemIdBefore(block, stop))
      return workitem;
  }
  return {};
}

static Value getOrCreateWorkitemId(OpBuilder &builder, Location loc) {
  if (Value workitem = findAvailableWorkitemId(builder))
    return workitem;
  return waveamdmachine::VWorkitemIdXOp::create(
             builder, loc, getWorkitemIdType(builder.getContext()))
      .getResult();
}

static FailureOr<std::pair<Value, int64_t>>
materializeLDSAddress(OpBuilder &builder, Location loc,
                      wave::regalloc::LDSSpillPlan plan) {
  MLIRContext *ctx = builder.getContext();
  Value workitem = getOrCreateWorkitemId(builder, loc);
  waveamdmachine::VLshlrevB32Op addr = waveamdmachine::VLshlrevB32Op::create(
      builder, loc, getVirtualVGPR1(ctx), workitem,
      createLDSImm(builder, loc, llvm::Log2_32(plan.valueBytes)));
  addr->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  if (canFoldSlotBaseIntoDSOffset(plan.slotBase))
    return std::make_pair(addr.getResult(),
                          static_cast<int64_t>(plan.slotBase));
  waveamdmachine::VAddU32Op fullAddr = waveamdmachine::VAddU32Op::create(
      builder, loc, getVirtualVGPR1(ctx), addr.getResult(),
      createLDSImm(builder, loc, plan.slotBase));
  fullAddr->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return std::make_pair(fullAddr.getResult(), int64_t{0});
}

static FailureOr<Value> storeLDSScalarValue(OpBuilder &builder, Location loc,
                                            Value value, Value token,
                                            wave::regalloc::LDSSpillPlan plan) {
  FailureOr<std::pair<Value, int64_t>> addr =
      materializeLDSAddress(builder, loc, plan);
  if (failed(addr))
    return failure();
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  waveamdmachine::DsStoreB32Op store = waveamdmachine::DsStoreB32Op::create(
      builder, loc, tokenType, addr->first, value, token, addr->second);
  store->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return store.getToken();
}

static FailureOr<Value>
storeLDSValueAt(OpBuilder &builder, Location loc, Value value,
                waveamdmachine::RegType type, Value token,
                ArrayRef<wave::regalloc::LDSSpillPlan> plans) {
  unsigned width = type.getWidth();
  if (width == 1)
    return storeLDSScalarValue(builder, loc, value, token, plans.front());

  SmallVector<Value> elements =
      wave::regalloc::splitMemorySpillValue(value, builder, loc);
  SmallVector<Value> tokens;
  tokens.reserve(elements.size());
  for (auto [index, element] : llvm::enumerate(elements)) {
    FailureOr<Value> stored =
        storeLDSScalarValue(builder, loc, element, token, plans[index]);
    if (failed(stored))
      return failure();
    tokens.push_back(*stored);
  }
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  return wave::regalloc::joinMemorySpillTokens(tokenType, tokens, builder, loc);
}

static FailureOr<Value> storeLDSValue(OpBuilder &builder,
                                      const LDSReliefSlot &slot, Value token) {
  wave::regalloc::setInsertionPointForMemorySpillStore(slot.value, builder);
  return storeLDSValueAt(builder, slot.value.getLoc(), slot.value, slot.type,
                         token, slot.plan);
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadLDSScalarValue(OpBuilder &builder, Location loc, Type type, Value token,
                   wave::regalloc::LDSSpillPlan plan) {
  FailureOr<std::pair<Value, int64_t>> addr =
      materializeLDSAddress(builder, loc, plan);
  if (failed(addr))
    return failure();
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  waveamdmachine::DsLoadB32Op load = waveamdmachine::DsLoadB32Op::create(
      builder, loc, type, tokenType, addr->first, token, addr->second);
  load->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return wave::regalloc::MemorySpillLoadResult{load.getResult(),
                                               load.getToken()};
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadLDSValue(OpBuilder &builder, Location loc, Type type, Value token,
             ArrayRef<wave::regalloc::LDSSpillPlan> plans) {
  unsigned width = cast<waveamdmachine::RegType>(type).getWidth();
  if (width == 1)
    return loadLDSScalarValue(builder, loc, type, token, plans.front());

  SmallVector<Type> elementTypes =
      wave::regalloc::getMemorySpillScalarRegTypes(type);
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  elements.reserve(elementTypes.size());
  tokens.reserve(elementTypes.size());
  for (auto [index, elementType] : llvm::enumerate(elementTypes)) {
    FailureOr<wave::regalloc::MemorySpillLoadResult> load =
        loadLDSScalarValue(builder, loc, elementType, token, plans[index]);
    if (failed(load))
      return failure();
    elements.push_back(load->value);
    tokens.push_back(load->token);
  }
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  return wave::regalloc::MemorySpillLoadResult{
      wave::regalloc::joinMemorySpillValue(type, elements, builder, loc),
      wave::regalloc::joinMemorySpillTokens(tokenType, tokens, builder, loc)};
}

template <typename SlotT, typename LoadFn>
static LogicalResult
replaceMemoryReliefUses(OpBuilder &builder,
                        const MemoryStoredSlot<SlotT> &stored,
                        const DenseSet<Value> &plannedValues, LoadFn loadFn) {
  const SlotT &slot = *stored.slot;
  for (OpOperand *use : slot.uses) {
    if (use->get() != slot.value)
      continue;
    if (isInternalPlannedTupleFromElementsUse(use, plannedValues))
      continue;
    Operation *user = use->getOwner();
    builder.setInsertionPoint(user);
    FailureOr<wave::regalloc::MemorySpillLoadResult> loaded =
        loadFn(user->getLoc(), slot.type, stored.token, slot.plan);
    if (failed(loaded))
      return failure();
    use->set(loaded->value);
  }
  return success();
}

template <typename SlotT, typename StoreFn, typename LoadFn>
class TransformMemoryLoopCarryMaterializer {
public:
  TransformMemoryLoopCarryMaterializer(OpBuilder &builder,
                                       ArrayRef<const SlotT *> slots,
                                       StoreFn storeFn, LoadFn loadFn)
      : slots(slots), builder(builder), storeFn(storeFn), loadFn(loadFn) {}

  LogicalResult run() {
    if (slots.empty())
      return success();
    SmallVector<const SlotT *, 8> sorted(slots.begin(), slots.end());
    llvm::stable_sort(sorted, [](const SlotT *lhs, const SlotT *rhs) {
      return lhs->loopCarry->index < rhs->loopCarry->index;
    });
    slots = sorted;

    waveamdmachine::UniformLoopOp loop = slots.front()->loopCarry->loop;
    for (const SlotT *slot : slots)
      assert(slot->loopCarry->loop == loop && "expected one loop group");

    SmallVector<Value, 8> initTokens;
    if (failed(materializeInitStores(loop, initTokens)))
      return failure();
    for (auto [index, slot] : llvm::enumerate(slots))
      if (failed(rewriteExtraLoopInitUses(loop, *slot->loopCarry,
                                          initTokens[index])))
        return failure();

    FailureOr<waveamdmachine::UniformLoopOp> newLoop =
        cloneLoopWithoutCarries(loop, initTokens);
    if (failed(newLoop))
      return failure();
    if (failed(replaceLoopResults(loop, *newLoop)))
      return failure();
    loop.erase();
    return success();
  }

private:
  bool isSpilledIndex(unsigned index) const {
    return llvm::any_of(slots, [index](const SlotT *slot) {
      return slot->loopCarry->index == index;
    });
  }

  std::optional<unsigned> getSpillOrdinal(unsigned index) const {
    for (auto [ordinal, slot] : llvm::enumerate(slots))
      if (slot->loopCarry->index == index)
        return ordinal;
    return std::nullopt;
  }

  static Value getInitStoreToken(Value init) {
    if (Operation *def = init.getDefiningOp())
      return wave::regalloc::getMemoryIssuerToken(def);
    return {};
  }

  void setInsertionPointForInitStore(Value init, OpOperand *loopUse,
                                     waveamdmachine::UniformLoopOp loop) const {
    Operation *def = init.getDefiningOp();
    Operation *firstPreheaderUse =
        wave::regalloc::getLoopCarryFirstPreheaderUse(init, loopUse, loop);
    if (firstPreheaderUse && (!def || def->getBlock() != loop->getBlock() ||
                              def->isBeforeInBlock(firstPreheaderUse))) {
      builder.setInsertionPoint(firstPreheaderUse);
      return;
    }
    if (!def || def->getBlock() != loop->getBlock() ||
        !def->isBeforeInBlock(loop)) {
      builder.setInsertionPoint(loop);
      return;
    }
    builder.setInsertionPointAfter(def);
  }

  LogicalResult
  materializeInitStores(waveamdmachine::UniformLoopOp loop,
                        SmallVectorImpl<Value> &initTokens) const {
    for (const SlotT *slot : slots) {
      Value initToken;
      if (failed(materializeInitStore(loop, *slot, initToken)))
        return failure();
      initTokens.push_back(initToken);
    }
    return success();
  }

  LogicalResult materializeInitStore(waveamdmachine::UniformLoopOp loop,
                                     const SlotT &slot,
                                     Value &initToken) const {
    unsigned index = slot.loopCarry->index;
    Value init = loop.getInits()[index];
    OpOperand *loopUse = &loop.getInitsMutable()[index];
    setInsertionPointForInitStore(init, loopUse, loop);
    FailureOr<Value> stored =
        storeFn(init, getInitStoreToken(init), slot, loop.getLoc());
    if (failed(stored))
      return failure();
    initToken = *stored;
    return success();
  }

  LogicalResult
  rewriteExtraLoopInitUses(waveamdmachine::UniformLoopOp loop,
                           wave::regalloc::MemorySpillLoopCarrySlot carry,
                           Value initToken) const {
    OpOperand *loopUse = &loop.getInitsMutable()[carry.index];
    Value init = loopUse->get();
    SmallVector<OpOperand *> uses;
    for (OpOperand &use : init.getUses()) {
      if (&use == loopUse || isRegAllocTransformTempOp(use.getOwner()))
        continue;
      uses.push_back(&use);
    }

    const SlotT &slot = *slots[*getSpillOrdinal(carry.index)];
    for (OpOperand *use : uses) {
      if (!wave::regalloc::canRewriteExtraLoopInitUse(*use, loopUse, loop))
        return failure();
      Operation *user = use->getOwner();
      builder.setInsertionPoint(user);
      FailureOr<wave::regalloc::MemorySpillLoadResult> loaded =
          loadFn(user->getLoc(), slot.type, initToken, slot.plan);
      if (failed(loaded))
        return failure();
      use->set(loaded->value);
    }
    return success();
  }

  FailureOr<waveamdmachine::UniformLoopOp>
  cloneLoopWithoutCarries(waveamdmachine::UniformLoopOp loop,
                          ArrayRef<Value> initTokens) const {
    SmallVector<Type> resultTypes;
    SmallVector<Value> inits;
    for (unsigned index : llvm::seq<unsigned>(0, loop.getInits().size())) {
      if (isSpilledIndex(index))
        continue;
      resultTypes.push_back(loop.getResult(index).getType());
      inits.push_back(loop.getInits()[index]);
    }
    for (Value initToken : initTokens) {
      resultTypes.push_back(initToken.getType());
      inits.push_back(initToken);
    }

    builder.setInsertionPoint(loop);
    waveamdmachine::UniformLoopOp newLoop =
        waveamdmachine::UniformLoopOp::create(
            builder, loop.getLoc(), resultTypes, loop.getEntryCond(), inits);
    if (failed(cloneLoopBody(loop, newLoop))) {
      newLoop.erase();
      return failure();
    }
    return newLoop;
  }

  LogicalResult cloneLoopBody(waveamdmachine::UniformLoopOp oldLoop,
                              waveamdmachine::UniformLoopOp newLoop) const {
    Block &oldBody = oldLoop.getBody().front();
    Block *newBody = new Block;
    newLoop.getBody().push_back(newBody);
    for (Value init : newLoop.getInits())
      newBody->addArgument(init.getType(), oldLoop.getLoc());

    IRMapping mapper;
    unsigned newArgIndex = 0;
    for (unsigned index : llvm::seq<unsigned>(0, oldLoop.getInits().size())) {
      if (isSpilledIndex(index))
        continue;
      mapper.map(oldBody.getArgument(index),
                 newBody->getArgument(newArgIndex++));
    }
    SmallVector<Value, 8> tokens;
    for ([[maybe_unused]] const SlotT *slot : slots)
      tokens.push_back(newBody->getArgument(newArgIndex++));
    return cloneLoopBodyOps(oldLoop, newBody, tokens, mapper);
  }

  LogicalResult cloneLoopBodyOps(waveamdmachine::UniformLoopOp oldLoop,
                                 Block *newBody, SmallVectorImpl<Value> &tokens,
                                 IRMapping &mapper) const {
    Block &oldBody = oldLoop.getBody().front();
    builder.setInsertionPointToEnd(newBody);
    for (Operation &op : oldBody.without_terminator()) {
      SmallVector<Value, 4> mappedCarries;
      for (const SlotT *slot : slots) {
        BlockArgument oldArg = oldBody.getArgument(slot->loopCarry->index);
        if (!opUsesValue(&op, oldArg))
          continue;
        FailureOr<Value> mapped =
            getMappedValue(oldLoop, oldArg, tokens, mapper, op.getLoc());
        if (failed(mapped))
          return failure();
        mappedCarries.push_back(oldArg);
      }
      builder.clone(op, mapper);
      for (Value carry : mappedCarries)
        mapper.erase(carry);
    }
    return cloneLoopTerminator(oldLoop, tokens, mapper);
  }

  std::optional<unsigned>
  getSpillOrdinalForValue(waveamdmachine::UniformLoopOp loop,
                          Value value) const {
    BlockArgument arg = dyn_cast<BlockArgument>(value);
    if (!arg || arg.getOwner() != &loop.getBody().front())
      return std::nullopt;
    return getSpillOrdinal(arg.getArgNumber());
  }

  FailureOr<Value> getMappedValue(waveamdmachine::UniformLoopOp loop,
                                  Value value, SmallVectorImpl<Value> &tokens,
                                  IRMapping &mapper, Location loc) const {
    if (Value mapped = mapper.lookupOrNull(value))
      return mapped;
    std::optional<unsigned> ordinal = getSpillOrdinalForValue(loop, value);
    if (!ordinal)
      return mapper.lookupOrDefault(value);
    const SlotT &slot = *slots[*ordinal];
    FailureOr<wave::regalloc::MemorySpillLoadResult> loaded =
        loadFn(loc, slot.type, tokens[*ordinal], slot.plan);
    if (failed(loaded))
      return failure();
    tokens[*ordinal] = loaded->token;
    mapper.map(value, loaded->value);
    return loaded->value;
  }

  LogicalResult cloneLoopTerminator(waveamdmachine::UniformLoopOp loop,
                                    SmallVectorImpl<Value> &tokens,
                                    IRMapping &mapper) const {
    waveamdmachine::ContinueIfOp oldTerm = cast<waveamdmachine::ContinueIfOp>(
        loop.getBody().front().getTerminator());

    SmallVector<Value> carries;
    for (unsigned index : llvm::seq<unsigned>(0, oldTerm.getCarries().size())) {
      Value oldCarry = oldTerm.getCarries()[index];
      if (std::optional<unsigned> ordinal = getSpillOrdinal(index)) {
        if (failed(storeTerminatorCarry(loop, oldCarry, *ordinal, tokens,
                                        mapper, oldTerm.getLoc())))
          return failure();
        continue;
      }
      FailureOr<Value> mapped =
          getMappedValue(loop, oldCarry, tokens, mapper, oldTerm.getLoc());
      if (failed(mapped))
        return failure();
      carries.push_back(*mapped);
    }
    carries.append(tokens.begin(), tokens.end());
    waveamdmachine::ContinueIfOp::create(
        builder, oldTerm.getLoc(), mapper.lookupOrDefault(oldTerm.getCond()),
        carries);
    return success();
  }

  LogicalResult storeTerminatorCarry(waveamdmachine::UniformLoopOp loop,
                                     Value oldCarry, unsigned ordinal,
                                     SmallVectorImpl<Value> &tokens,
                                     IRMapping &mapper, Location loc) const {
    const SlotT &slot = *slots[ordinal];
    BlockArgument oldArg =
        loop.getBody().front().getArgument(slot.loopCarry->index);
    if (oldCarry == oldArg)
      return success();
    FailureOr<Value> mapped =
        getMappedValue(loop, oldCarry, tokens, mapper, loc);
    if (failed(mapped))
      return failure();
    FailureOr<Value> stored = storeFn(*mapped, tokens[ordinal], slot, loc);
    if (failed(stored))
      return failure();
    tokens[ordinal] = *stored;
    return success();
  }

  LogicalResult
  replaceLoopResults(waveamdmachine::UniformLoopOp oldLoop,
                     waveamdmachine::UniformLoopOp newLoop) const {
    builder.setInsertionPointAfter(newLoop);
    unsigned newResultIndex = 0;
    for (unsigned index : llvm::seq<unsigned>(0, oldLoop.getResults().size())) {
      if (isSpilledIndex(index))
        continue;
      oldLoop.getResult(index).replaceAllUsesWith(
          newLoop.getResult(newResultIndex++));
    }
    for (const SlotT *slot : slots) {
      Value token = newLoop.getResult(newResultIndex++);
      Value oldResult = oldLoop.getResult(slot->loopCarry->index);
      if (oldResult.use_empty())
        continue;
      FailureOr<wave::regalloc::MemorySpillLoadResult> loaded =
          loadFn(oldLoop.getLoc(), slot->type, token, slot->plan);
      if (failed(loaded))
        return failure();
      oldResult.replaceAllUsesWith(loaded->value);
    }
    return success();
  }

  ArrayRef<const SlotT *> slots;
  OpBuilder &builder;
  StoreFn storeFn;
  LoadFn loadFn;
};

template <typename SlotT, typename StoreFn, typename LoadFn>
static LogicalResult
materializeMemoryLoopCarryRelief(OpBuilder &builder, ArrayRef<SlotT> slots,
                                 StoreFn storeFn, LoadFn loadFn) {
  SmallVector<const SlotT *, 8> slotPtrs;
  slotPtrs.reserve(slots.size());
  for (const SlotT &slot : slots)
    slotPtrs.push_back(&slot);
  return TransformMemoryLoopCarryMaterializer<SlotT, StoreFn, LoadFn>(
             builder, slotPtrs, storeFn, loadFn)
      .run();
}

template <typename SlotT, typename CandidateT, typename StoreFn,
          typename LoadFn, typename ReserveFn, typename LoopStoreFn>
static LogicalResult
materializeMemoryRelief(OpBuilder &builder, const CandidateT &candidate,
                        StoreFn storeFn, LoadFn loadFn, ReserveFn reserveFn,
                        LoopStoreFn loopStoreFn) {
  if (!candidate.slots.empty() && candidate.slots.front().loopCarry) {
    if (failed(materializeMemoryLoopCarryRelief(
            builder, ArrayRef<SlotT>(candidate.slots), loopStoreFn, loadFn)))
      return failure();
    reserveFn(candidate.reservedBytes);
    return success();
  }

  DenseSet<Value> plannedValues;
  for (const SlotT &slot : candidate.slots)
    plannedValues.insert(slot.value);

  SmallVector<MemoryStoredSlot<SlotT>> storedSlots;
  storedSlots.reserve(candidate.slots.size());
  for (const SlotT &slot : candidate.slots) {
    Value token =
        wave::regalloc::getMemoryIssuerToken(slot.value.getDefiningOp());
    FailureOr<Value> stored = storeFn(slot, token);
    if (failed(stored))
      return failure();
    storedSlots.push_back({&slot, *stored});
  }
  for (const MemoryStoredSlot<SlotT> &stored : storedSlots)
    if (failed(replaceMemoryReliefUses(builder, stored, plannedValues, loadFn)))
      return failure();
  reserveFn(candidate.reservedBytes);
  return success();
}

static void reserveLDSSpillBytes(func::FuncOp func, OpBuilder &builder,
                                 unsigned bytes) {
  unsigned reserved = getCommittedLDSSpillBytes(func);
  func->setAttr(wave::regalloc::kLDSSpillBytesAttr,
                builder.getI64IntegerAttr(reserved + bytes));
}

static LogicalResult materializeLDSRelief(OpBuilder &builder, func::FuncOp func,
                                          const LDSReliefCandidate &candidate) {
  auto store = [&](const LDSReliefSlot &slot, Value token) {
    return storeLDSValue(builder, slot, token);
  };
  auto load = [&](Location loc, Type type, Value token,
                  const LDSReliefPlan &plan)
      -> FailureOr<wave::regalloc::MemorySpillLoadResult> {
    return loadLDSValue(builder, loc, type, token, plan);
  };
  auto reserve = [&](unsigned bytes) {
    reserveLDSSpillBytes(func, builder, bytes);
  };
  auto loopStore = [&](Value value, Value token, const LDSReliefSlot &slot,
                       Location loc) -> FailureOr<Value> {
    return storeLDSValueAt(builder, loc, value, slot.type, token, slot.plan);
  };
  return materializeMemoryRelief<LDSReliefSlot>(builder, candidate, store, load,
                                                reserve, loopStore);
}

static unsigned getCommittedScratchSpillBytes(func::FuncOp func) {
  return getUnsignedIntegerAttr(func.getOperation(),
                                wave::regalloc::kScratchSpillBytesAttr)
      .value_or(0);
}

static ScratchReliefPlanningState
getScratchReliefPlanningState(func::FuncOp func) {
  ScratchReliefPlanningState state;
  state.committedBytes = getCommittedScratchSpillBytes(func);
  state.existingPrivateBytes = wave::regalloc::getExistingPrivateSegmentBytes(
      func, state.committedBytes);
  return state;
}

static std::optional<wave::regalloc::ScratchSpillPlan> getScratchPlanForValue(
    func::FuncOp func, const ScratchReliefPlanningState &planning,
    waveamdmachine::RegType type, unsigned extraReservedBytes) {
  if (type.getWidth() == 0)
    return std::nullopt;
  unsigned reserved = planning.committedBytes + extraReservedBytes;
  wave::regalloc::ScratchSpillPlan plan = wave::regalloc::planScratchSpillSlot(
      func, type.getWidth() * 4, reserved, planning.existingPrivateBytes);
  if (plan.status != wave::regalloc::ScratchSpillPlanStatus::Available)
    return std::nullopt;
  return plan;
}

static constexpr unsigned kScratchTransformImmediateOffsetMax = 4095;

static bool scratchTupleFitsImmediate(unsigned slotBase, unsigned width) {
  if (width == 0)
    return false;
  uint64_t lastOffset =
      static_cast<uint64_t>(slotBase) + static_cast<uint64_t>(width - 1) * 4;
  return lastOffset <= kScratchTransformImmediateOffsetMax;
}

static unsigned getScratchMemoryOps(wave::regalloc::ScratchSpillPlan plan,
                                    unsigned width) {
  if (width > 1 && !scratchTupleFitsImmediate(plan.slotBase, width))
    return width;
  return 1;
}

static unsigned getScratchAccessOpCount(wave::regalloc::ScratchSpillPlan plan,
                                        unsigned width) {
  return getScratchMemoryOps(plan, width) * 2;
}

static int64_t getScratchReliefCost(Value value,
                                    wave::regalloc::ScratchSpillPlan plan,
                                    waveamdmachine::RegType type,
                                    ArrayRef<OpOperand *> uses) {
  unsigned accessOps = getScratchAccessOpCount(plan, type.getWidth());
  int64_t cost =
      accessOps * getRematReliefLoopCostScale(getValueAnchorOp(value));
  for (OpOperand *use : uses)
    cost += accessOps * getRematReliefLoopCostScale(use->getOwner());
  return cost;
}

static int64_t getScratchLoopCarryReliefCost(
    Value value, wave::regalloc::ScratchSpillPlan plan,
    waveamdmachine::RegType type,
    wave::regalloc::MemorySpillLoopCarrySlot loopCarry) {
  unsigned accessOps = getScratchAccessOpCount(plan, type.getWidth());
  return getMemoryLoopCarryReliefCost(value, loopCarry, accessOps);
}

struct ScratchMemoryReliefTraits {
  using Plan = wave::regalloc::ScratchSpillPlan;
  using Slot = ScratchReliefSlot;
  using Candidate = ScratchReliefCandidate;
  using PlanningState = ScratchReliefPlanningState;

  static std::optional<Plan> getPlanForValue(func::FuncOp func,
                                             const PlanningState &planning,
                                             waveamdmachine::RegType type,
                                             unsigned extraReservedBytes) {
    return getScratchPlanForValue(func, planning, type, extraReservedBytes);
  }

  static unsigned getSlotBytes(Plan plan) { return plan.slotBytes; }

  static int64_t getCost(Value value, Plan plan, waveamdmachine::RegType type,
                         ArrayRef<OpOperand *> uses) {
    return getScratchReliefCost(value, plan, type, uses);
  }

  static int64_t
  getLoopCarryCost(Value value, Plan plan, waveamdmachine::RegType type,
                   wave::regalloc::MemorySpillLoopCarrySlot loopCarry) {
    return getScratchLoopCarryReliefCost(value, plan, type, loopCarry);
  }
};

static Value createScratchImm(OpBuilder &builder, Location loc, int64_t value) {
  return waveamdmachine::ImmOp::create(
      builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
      static_cast<uint64_t>(value));
}

static waveamdmachine::RegType getVirtualSGPR1(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::SGPR,
                                      /*width=*/1, /*index=*/-1);
}

static Value materializeScratchSAddress(OpBuilder &builder, Location loc,
                                        unsigned offset) {
  waveamdmachine::SMovB32ValueOp addr = waveamdmachine::SMovB32ValueOp::create(
      builder, loc, getVirtualSGPR1(builder.getContext()),
      createScratchImm(builder, loc, offset));
  addr->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return addr.getResult();
}

static void materializeScratchAddress(OpBuilder &builder, Location loc,
                                      unsigned byteOffset, Value &vaddr,
                                      Value &saddr, int64_t &instOffset) {
  vaddr = createScratchImm(builder, loc, 0);
  if (byteOffset <= kScratchTransformImmediateOffsetMax) {
    saddr = materializeScratchSAddress(builder, loc, 0);
    instOffset = byteOffset;
    return;
  }
  saddr = materializeScratchSAddress(builder, loc, byteOffset);
  instOffset = 0;
}

static FailureOr<Value>
storeScratchScalarValue(OpBuilder &builder, Location loc, Value value,
                        Value token, wave::regalloc::ScratchSpillPlan plan) {
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  Value storeVaddr;
  Value storeSaddr;
  int64_t storeOffset = 0;
  materializeScratchAddress(builder, loc, plan.slotBase, storeVaddr, storeSaddr,
                            storeOffset);
  waveamdmachine::ScratchStoreB32Op store =
      waveamdmachine::ScratchStoreB32Op::create(builder, loc, tokenType,
                                                storeVaddr, value, storeSaddr,
                                                token, storeOffset);
  store->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return store.getToken();
}

static FailureOr<Value> storeScratchScalarValue(OpBuilder &builder,
                                                Location loc, Value value,
                                                Value token,
                                                unsigned byteOffset) {
  wave::regalloc::ScratchSpillPlan plan;
  plan.slotBase = byteOffset;
  return storeScratchScalarValue(builder, loc, value, token, plan);
}

static FailureOr<Value>
storeScratchTupleValue(OpBuilder &builder, Location loc, Value value,
                       Value token, wave::regalloc::ScratchSpillPlan plan) {
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  Value storeVaddr;
  Value storeSaddr;
  int64_t storeOffset = 0;
  materializeScratchAddress(builder, loc, plan.slotBase, storeVaddr, storeSaddr,
                            storeOffset);
  waveamdmachine::ScratchStoreTupleB32Op store =
      waveamdmachine::ScratchStoreTupleB32Op::create(
          builder, loc, tokenType, storeVaddr, value, storeSaddr, token,
          storeOffset);
  store->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return store.getToken();
}

static void recordScratchVGPRSpillSave(func::FuncOp func, OpBuilder &builder,
                                       unsigned dwords) {
  unsigned spilledVGPRs =
      getUnsignedIntegerAttr(func.getOperation(),
                             wave::regalloc::kVGPRSpillCountAttr)
          .value_or(0);
  func->setAttr(wave::regalloc::kVGPRSpillCountAttr,
                builder.getI64IntegerAttr(spilledVGPRs + dwords));
}

static FailureOr<Value>
storeScratchValueAt(OpBuilder &builder, func::FuncOp func, Location loc,
                    Value value, waveamdmachine::RegType type, Value token,
                    wave::regalloc::ScratchSpillPlan plan);

static FailureOr<Value> storeScratchValue(OpBuilder &builder, func::FuncOp func,
                                          const ScratchReliefSlot &slot,
                                          Value token) {
  wave::regalloc::setInsertionPointForMemorySpillStore(slot.value, builder);
  return storeScratchValueAt(builder, func, slot.value.getLoc(), slot.value,
                             slot.type, token, slot.plan);
}

static FailureOr<Value>
storeScratchValueAt(OpBuilder &builder, func::FuncOp func, Location loc,
                    Value value, waveamdmachine::RegType type, Value token,
                    wave::regalloc::ScratchSpillPlan plan) {
  unsigned width = type.getWidth();
  recordScratchVGPRSpillSave(func, builder, width);
  if (width == 1)
    return storeScratchScalarValue(builder, loc, value, token, plan);
  if (scratchTupleFitsImmediate(plan.slotBase, width))
    return storeScratchTupleValue(builder, loc, value, token, plan);

  SmallVector<Value> elements =
      wave::regalloc::splitMemorySpillValue(value, builder, loc);
  SmallVector<Value> tokens;
  tokens.reserve(elements.size());
  for (auto [index, element] : llvm::enumerate(elements)) {
    FailureOr<Value> stored = storeScratchScalarValue(
        builder, loc, element, token,
        plan.slotBase + static_cast<unsigned>(index) * 4);
    if (failed(stored))
      return failure();
    tokens.push_back(*stored);
  }
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  return wave::regalloc::joinMemorySpillTokens(tokenType, tokens, builder, loc);
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadScratchScalarValue(OpBuilder &builder, Location loc, Type type, Value token,
                       wave::regalloc::ScratchSpillPlan plan) {
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  Value loadVaddr;
  Value loadSaddr;
  int64_t loadOffset = 0;
  materializeScratchAddress(builder, loc, plan.slotBase, loadVaddr, loadSaddr,
                            loadOffset);
  waveamdmachine::ScratchLoadB32Op load =
      waveamdmachine::ScratchLoadB32Op::create(builder, loc, type, tokenType,
                                               loadVaddr, loadSaddr, token,
                                               loadOffset);
  load->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return wave::regalloc::MemorySpillLoadResult{load.getResult(),
                                               load.getToken()};
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadScratchScalarValue(OpBuilder &builder, Location loc, Type type, Value token,
                       unsigned byteOffset) {
  wave::regalloc::ScratchSpillPlan plan;
  plan.slotBase = byteOffset;
  return loadScratchScalarValue(builder, loc, type, token, plan);
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadScratchTupleValue(OpBuilder &builder, Location loc, Type type, Value token,
                      wave::regalloc::ScratchSpillPlan plan) {
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  Value loadVaddr;
  Value loadSaddr;
  int64_t loadOffset = 0;
  materializeScratchAddress(builder, loc, plan.slotBase, loadVaddr, loadSaddr,
                            loadOffset);
  waveamdmachine::ScratchLoadTupleB32Op load =
      waveamdmachine::ScratchLoadTupleB32Op::create(
          builder, loc, type, tokenType, loadVaddr, loadSaddr, token,
          loadOffset);
  load->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return wave::regalloc::MemorySpillLoadResult{load.getResult(),
                                               load.getToken()};
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadScratchValue(OpBuilder &builder, Location loc, Type type, Value token,
                 wave::regalloc::ScratchSpillPlan plan) {
  unsigned width = cast<waveamdmachine::RegType>(type).getWidth();
  if (width == 1)
    return loadScratchScalarValue(builder, loc, type, token, plan);
  if (scratchTupleFitsImmediate(plan.slotBase, width))
    return loadScratchTupleValue(builder, loc, type, token, plan);

  SmallVector<Type> elementTypes =
      wave::regalloc::getMemorySpillScalarRegTypes(type);
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  elements.reserve(elementTypes.size());
  tokens.reserve(elementTypes.size());
  for (auto [index, elementType] : llvm::enumerate(elementTypes)) {
    FailureOr<wave::regalloc::MemorySpillLoadResult> load =
        loadScratchScalarValue(builder, loc, elementType, token,
                               plan.slotBase +
                                   static_cast<unsigned>(index) * 4);
    if (failed(load))
      return failure();
    elements.push_back(load->value);
    tokens.push_back(load->token);
  }
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  return wave::regalloc::MemorySpillLoadResult{
      wave::regalloc::joinMemorySpillValue(type, elements, builder, loc),
      wave::regalloc::joinMemorySpillTokens(tokenType, tokens, builder, loc)};
}

static void reserveScratchSpillBytes(func::FuncOp func, OpBuilder &builder,
                                     unsigned bytes) {
  unsigned reserved = getCommittedScratchSpillBytes(func);
  unsigned existingPrivate =
      wave::regalloc::getExistingPrivateSegmentBytes(func, reserved);
  unsigned newReserved = reserved + bytes;
  func->setAttr(wave::regalloc::kScratchSpillBytesAttr,
                builder.getI64IntegerAttr(newReserved));
  func->setAttr(wave::regalloc::kPrivateSegmentFixedSizeAttr,
                builder.getI64IntegerAttr(existingPrivate + newReserved));
  func->setAttr(wave::regalloc::kUsesFlatScratchAttr,
                builder.getBoolAttr(true));
}

static LogicalResult
materializeScratchRelief(OpBuilder &builder, func::FuncOp func,
                         const ScratchReliefCandidate &candidate) {
  auto store = [&](const ScratchReliefSlot &slot, Value token) {
    return storeScratchValue(builder, func, slot, token);
  };
  auto load = [&](Location loc, Type type, Value token,
                  wave::regalloc::ScratchSpillPlan plan)
      -> FailureOr<wave::regalloc::MemorySpillLoadResult> {
    return loadScratchValue(builder, loc, type, token, plan);
  };
  auto reserve = [&](unsigned bytes) {
    reserveScratchSpillBytes(func, builder, bytes);
  };
  auto loopStore = [&](Value value, Value token, const ScratchReliefSlot &slot,
                       Location loc) -> FailureOr<Value> {
    return storeScratchValueAt(builder, func, loc, value, slot.type, token,
                               slot.plan);
  };
  return materializeMemoryRelief<ScratchReliefSlot>(builder, candidate, store,
                                                    load, reserve, loopStore);
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
    return sourceSet.end == set.start &&
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
      const wave::RegAllocTransformValue &value = values[valueId];
      return value.start <= position && position <= value.end;
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
        if (liveRangesOverlap(lhsValue.start, lhsValue.end, rhsValue.start,
                              rhsValue.end))
          return true;
      }
    }
    return false;
  }

  bool setOverlapsRange(const wave::RegAllocTransformAliasSet &set,
                        unsigned start, unsigned end) {
    return llvm::any_of(set.members, [&](unsigned valueId) {
      const wave::RegAllocTransformValue &value = values[valueId];
      return liveRangesOverlap(value.start, value.end, start, end);
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

static FailureOr<std::optional<AGPRReliefCandidate>>
selectAGPRReliefCandidateFromFunc(
    func::FuncOp func, const RegAllocTransformFailure &failureRecord) {
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      waveamdmachine::getAMDGPUTargetIsaVersion(
          func, "regalloc transform AGPR relief");
  if (failed(isa))
    return failure();
  if (!waveamdmachine::supportsAGPRs(*isa))
    return std::optional<AGPRReliefCandidate>();

  DictionaryAttr state = func->getAttrOfType<DictionaryAttr>(
      wave::getRegAllocTransformStateAttrName());
  FailureOr<SmallVector<wave::RegAllocTransformValue>> values =
      wave::parseRegAllocTransformValues(state, func.getOperation());
  if (failed(values))
    return failure();
  FailureOr<SmallVector<wave::RegAllocTransformAliasSet>> sets =
      wave::parseRegAllocTransformAliasSets(state, *values,
                                            func.getOperation());
  if (failed(sets))
    return failure();
  return selectAGPRReliefCandidate(func, failureRecord, *sets, *values);
}

static LogicalResult runRegAllocAGPRRelief(func::FuncOp func) {
  FailureOr<std::optional<RegAllocTransformFailure>> failureRecord =
      parseRegAllocTransformFailure(func);
  if (failed(failureRecord))
    return failure();
  if (!*failureRecord)
    return success();
  if (!isAGPRRelievableFailure(**failureRecord))
    return success();
  if ((*failureRecord)->className == "vgpr_agpr")
    return success();

  FailureOr<std::optional<AGPRReliefCandidate>> candidate =
      selectAGPRReliefCandidateFromFunc(func, **failureRecord);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return success();

  OpBuilder builder(func.getContext());
  materializeAGPRRelief(builder, **candidate);
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  func->removeAttr(wave::getRegAllocTransformStateAttrName());
  return success();
}

static LogicalResult runRegAllocRematRelief(func::FuncOp func) {
  FailureOr<std::optional<RegAllocTransformFailure>> failureRecord =
      parseRegAllocTransformFailure(func);
  if (failed(failureRecord))
    return failure();
  if (!*failureRecord)
    return success();
  if (!isRematRelievableFailure(**failureRecord))
    return success();

  DictionaryAttr state = func->getAttrOfType<DictionaryAttr>(
      wave::getRegAllocTransformStateAttrName());
  FailureOr<SmallVector<wave::RegAllocTransformValue>> values =
      wave::parseRegAllocTransformValues(state, func.getOperation());
  if (failed(values))
    return failure();
  FailureOr<SmallVector<wave::RegAllocTransformAliasSet>> sets =
      wave::parseRegAllocTransformAliasSets(state, *values,
                                            func.getOperation());
  if (failed(sets))
    return failure();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveRegAllocStateValues(func, *values);
  if (failed(resolvedValues))
    return failure();

  RematReliefContext context = buildRematReliefContext(func, *resolvedValues);
  FailureOr<std::optional<RematReliefCandidate>> candidate =
      selectRematReliefCandidate(func, **failureRecord, *sets, *values,
                                 context);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return success();

  OpBuilder builder(func.getContext());
  if (failed(materializeRematRelief(builder, **candidate, **failureRecord,
                                    context)))
    return failure();
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  func->removeAttr(wave::getRegAllocTransformStateAttrName());
  return success();
}

template <typename Traits>
static FailureOr<std::optional<typename Traits::Candidate>>
selectMemoryReliefCandidateFromState(
    func::FuncOp func, const RegAllocTransformFailure &failureRecord,
    const typename Traits::PlanningState &planning) {
  DictionaryAttr state = func->getAttrOfType<DictionaryAttr>(
      wave::getRegAllocTransformStateAttrName());
  FailureOr<SmallVector<wave::RegAllocTransformValue>> values =
      wave::parseRegAllocTransformValues(state, func.getOperation());
  if (failed(values))
    return failure();
  FailureOr<SmallVector<wave::RegAllocTransformAliasSet>> sets =
      wave::parseRegAllocTransformAliasSets(state, *values,
                                            func.getOperation());
  if (failed(sets))
    return failure();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveRegAllocStateValues(func, *values);
  if (failed(resolvedValues))
    return failure();

  RematReliefContext context = buildRematReliefContext(func, *resolvedValues);
  return selectMemoryReliefCandidate<Traits>(func, failureRecord, *sets,
                                             *values, context, planning);
}

static LogicalResult runRegAllocLDSRelief(func::FuncOp func) {
  FailureOr<std::optional<RegAllocTransformFailure>> failureRecord =
      parseRegAllocTransformFailure(func);
  if (failed(failureRecord))
    return failure();
  if (!*failureRecord)
    return success();
  if (!isAGPRRelievableFailure(**failureRecord))
    return success();

  FailureOr<wave::regalloc::RegisterBudgets> budgets =
      getLDSTransformBudgets(func);
  if (failed(budgets))
    return failure();
  LDSReliefPlanningState planning = getLDSReliefPlanningState(func, *budgets);
  FailureOr<std::optional<LDSReliefCandidate>> candidate =
      selectMemoryReliefCandidateFromState<LDSMemoryReliefTraits>(
          func, **failureRecord, planning);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return success();

  OpBuilder builder(func.getContext());
  if (failed(materializeLDSRelief(builder, func, **candidate)))
    return failure();
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  func->removeAttr(wave::getRegAllocTransformStateAttrName());
  return success();
}

static LogicalResult runRegAllocScratchRelief(func::FuncOp func) {
  FailureOr<std::optional<RegAllocTransformFailure>> failureRecord =
      parseRegAllocTransformFailure(func);
  if (failed(failureRecord))
    return failure();
  if (!*failureRecord)
    return success();
  if (!isAGPRRelievableFailure(**failureRecord))
    return success();

  ScratchReliefPlanningState planning = getScratchReliefPlanningState(func);
  FailureOr<std::optional<ScratchReliefCandidate>> candidate =
      selectMemoryReliefCandidateFromState<ScratchMemoryReliefTraits>(
          func, **failureRecord, planning);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return success();

  OpBuilder builder(func.getContext());
  if (failed(materializeScratchRelief(builder, func, **candidate)))
    return failure();
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  func->removeAttr(wave::getRegAllocTransformStateAttrName());
  return success();
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

LogicalResult wave::runRegAllocTransformAGPRRelief(Operation *target,
                                                   Builder &builder) {
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return runRegAllocAGPRRelief(func);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(runRegAllocAGPRRelief(func)) ? WalkResult::interrupt()
                                               : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}

LogicalResult wave::runRegAllocTransformRematRelief(Operation *target,
                                                    Builder &builder) {
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return runRegAllocRematRelief(func);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(runRegAllocRematRelief(func)) ? WalkResult::interrupt()
                                                : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}

LogicalResult wave::runRegAllocTransformLDSRelief(Operation *target,
                                                  Builder &builder) {
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return runRegAllocLDSRelief(func);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(runRegAllocLDSRelief(func)) ? WalkResult::interrupt()
                                              : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}

LogicalResult wave::runRegAllocTransformScratchRelief(Operation *target,
                                                      Builder &builder) {
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return runRegAllocScratchRelief(func);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(runRegAllocScratchRelief(func)) ? WalkResult::interrupt()
                                                  : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}
