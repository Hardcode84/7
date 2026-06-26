//===- WaveAMDRegAllocTransformLoop.cpp - Regalloc transforms -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocTransformLoop.h"

#include "WaveAMDRegAllocInternal.h"
#include "WaveAMDRegAllocTransformState.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/IRMapping.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/MathExtras.h"
#include <limits>
#include <optional>

using namespace mlir;

namespace {

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
        for (OpResult result : op.getResults())
          registerValue(result, record.position, opPath,
                        /*blockArgument=*/false, result.getResultNumber(),
                        record.id);
        for (auto [regionIndex, nested] : llvm::enumerate(op.getRegions())) {
          SmallVector<int64_t> nestedPath(opPath);
          nestedPath.push_back(regionIndex);
          collectRegion(nested, nestedPath);
        }
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

struct AGPRReliefCandidate {
  SmallVector<ResolvedRegAllocValue> values;
  const wave::RegAllocTransformAliasSet *set = nullptr;
  int64_t bridgeCost = 0;
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

struct LDSReliefSlot {
  SmallVector<OpOperand *> uses;
  SmallVector<wave::regalloc::LDSSpillPlan, 4> plans;
  Value value;
  waveamdmachine::RegType type;
  const wave::RegAllocTransformValue *stateValue = nullptr;
  int64_t cost = 0;
  unsigned useCount = 0;
};

struct LDSReliefCandidate {
  SmallVector<LDSReliefSlot, 4> slots;
  const wave::RegAllocTransformAliasSet *set = nullptr;
  int64_t cost = 0;
  unsigned reservedBytes = 0;
};

struct LDSStoredSlot {
  const LDSReliefSlot *slot = nullptr;
  Value token;
};

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
  for (unsigned base = 0; base <= limit - interval.width; ++base) {
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
                               unsigned candidateId, unsigned limit) {
  SmallVector<wave::RegAllocTransformAssignment> active;
  bool allocatedCandidate = false;
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
      allocatedCandidate |= interval.id == candidateId;
      continue;
    }
    std::optional<unsigned> base = findFreeAGPRBase(interval, active, limit);
    if (!base)
      return false;
    active.push_back({waveamdmachine::RegClass::AGPR, interval.id, *base,
                      interval.width, interval.start, interval.end});
    allocatedCandidate |= interval.id == candidateId;
  }
  return allocatedCandidate;
}

static bool lessAGPRReliefInterval(const AGPRReliefInterval &lhs,
                                   const AGPRReliefInterval &rhs) {
  return std::tie(lhs.start, lhs.id) < std::tie(rhs.start, rhs.id);
}

static bool
canAllocateAGPRReliefCandidate(func::FuncOp func,
                               const wave::RegAllocTransformAliasSet &candidate,
                               ArrayRef<wave::RegAllocTransformAliasSet> sets,
                               ArrayRef<wave::RegAllocTransformValue> values) {
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
  return canAllocateAGPRReliefIntervals(intervals, candidate.id, budget.limit);
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

static int64_t getAGPRReliefBridgeCost(ArrayRef<ResolvedRegAllocValue> values) {
  int64_t cost = 0;
  for (const ResolvedRegAllocValue &value : values) {
    ++cost;
    for (OpOperand &use : value.first.getUses())
      cost += getAGPRReliefLoopCostScale(use.getOwner());
  }
  return cost;
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
  if (!canAllocateAGPRReliefCandidate(func, *set, sets, values))
    return std::optional<AGPRReliefCandidate>();

  AGPRReliefCandidate candidate;
  candidate.set = set;
  candidate.values = std::move(*resolvedValues);
  candidate.bridgeCost = getAGPRReliefBridgeCost(candidate.values);
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
    if (!best || (*candidate)->bridgeCost < best->bridgeCost ||
        ((*candidate)->bridgeCost == best->bridgeCost &&
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

static void setInsertionPointAfterValue(OpBuilder &builder, Value value) {
  if (Operation *def = value.getDefiningOp()) {
    builder.setInsertionPointAfter(def);
    return;
  }
  Block *block = cast<BlockArgument>(value).getOwner();
  builder.setInsertionPointToStart(block);
}

static waveamdmachine::VAccvgprWriteB32TupleOp
createAGPRReliefWrite(OpBuilder &builder, Value value) {
  setInsertionPointAfterValue(builder, value);
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

static void materializeAGPRReliefValue(OpBuilder &builder, Value value) {
  waveamdmachine::VAccvgprWriteB32TupleOp write =
      createAGPRReliefWrite(builder, value);
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : value.getUses())
    if (use.getOwner() != write.getOperation())
      uses.push_back(&use);
  for (OpOperand *use : uses)
    use->set(createAGPRReliefRead(builder, write.getResult(), *use));
}

static void materializeAGPRRelief(OpBuilder &builder,
                                  const AGPRReliefCandidate &candidate) {
  for (const ResolvedRegAllocValue &value : candidate.values)
    materializeAGPRReliefValue(builder, value.first);
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
      waveamdmachine::UninitOp, waveamdmachine::VMovB32TupleOp,
      waveamdmachine::VLshrrevB32Op, waveamdmachine::VLshlrevB32Op,
      waveamdmachine::VLshlAddU32Op, waveamdmachine::VAddU32Op,
      waveamdmachine::VAdd3U32Op, waveamdmachine::VAndB32Op,
      waveamdmachine::VMulLoU32Op, waveamdmachine::VAddLshlU32Op,
      waveamdmachine::VXorB32Op, waveamdmachine::VAndOrB32Op,
      waveamdmachine::TupleFromElementsOp>(op);
}

static bool isRematRootValue(Value value) {
  Operation *def = value.getDefiningOp();
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  return def && type && type.getIndex() < 0 && !isAnchoredRematSource(value) &&
         isCheapRematRoot(def) && !isRegAllocTransformBridgeRelated(value);
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

static bool canUseOriginalRematLeaf(Value value, Operation *user,
                                    const RematReliefContext &context,
                                    const DenseSet<Value> *forcedRematValues) {
  if (mustRematValue(value, forcedRematValues))
    return false;
  if (!valueIsAvailableAt(value, user))
    return false;
  if (!isTrackedRegValue(value))
    return true;
  std::optional<unsigned> position = getRematOpPosition(user, context);
  return position && isStateValueLiveAt(value, *position, context);
}

static bool canRematerializeValueAt(Value value, Operation *user,
                                    const RematReliefContext &context,
                                    DenseSet<Value> &visiting,
                                    const DenseSet<Value> *forcedRematValues);

static bool canRematerializeOperandAt(
    Value operand, Operation *user, const RematReliefContext &context,
    DenseSet<Value> &visiting, const DenseSet<Value> *forcedRematValues) {
  if (canUseOriginalRematLeaf(operand, user, context, forcedRematValues))
    return true;
  if (!isTrackedRegValue(operand) || isAnchoredRematSource(operand))
    return false;
  return canRematerializeValueAt(operand, user, context, visiting,
                                 forcedRematValues);
}

static bool canRematerializeValueAt(Value value, Operation *user,
                                    const RematReliefContext &context,
                                    DenseSet<Value> &visiting,
                                    const DenseSet<Value> *forcedRematValues) {
  Operation *def = value.getDefiningOp();
  if (!isRematRootValue(value) || !valueIsAvailableAt(value, user))
    return false;
  if (!visiting.insert(value).second)
    return false;
  bool ok = llvm::all_of(def->getOperands(), [&](Value operand) {
    return canRematerializeOperandAt(operand, user, context, visiting,
                                     forcedRematValues);
  });
  visiting.erase(value);
  return ok;
}

static bool canRematerializeValueAt(Value value, Operation *user,
                                    const RematReliefContext &context,
                                    const DenseSet<Value> *forcedRematValues) {
  DenseSet<Value> visiting;
  return canRematerializeValueAt(value, user, context, visiting,
                                 forcedRematValues);
}

static unsigned getRematOpCountAt(Value value, Operation *user,
                                  const RematReliefContext &context,
                                  DenseSet<Value> &counted,
                                  const DenseSet<Value> *forcedRematValues) {
  if (!counted.insert(value).second)
    return 0;
  unsigned count = 1;
  Operation *def = value.getDefiningOp();
  for (Value operand : def->getOperands()) {
    if (canUseOriginalRematLeaf(operand, user, context, forcedRematValues))
      continue;
    count +=
        getRematOpCountAt(operand, user, context, counted, forcedRematValues);
  }
  return count;
}

static unsigned getRematOpCountAt(Value value, Operation *user,
                                  const RematReliefContext &context,
                                  const DenseSet<Value> *forcedRematValues) {
  DenseSet<Value> counted;
  return getRematOpCountAt(value, user, context, counted, forcedRematValues);
}

static int64_t getRematReliefLoopCostScale(Operation *op) {
  unsigned depth = 0;
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(cur))
      ++depth;
  if (depth == 0)
    return 1;
  return int64_t{1} << std::min<unsigned>(depth * 4, 20);
}

static FailureOr<SmallVector<OpOperand *>>
collectRematPostFailureUses(Value value,
                            const RegAllocTransformFailure &failureRecord,
                            const RematReliefContext &context) {
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : value.getUses()) {
    std::optional<unsigned> position =
        getRematOpPosition(use.getOwner(), context);
    if (!position)
      return failure();
    if (*position == failureRecord.position) {
      uses.clear();
      return uses;
    }
    if (*position > failureRecord.position)
      uses.push_back(&use);
  }
  llvm::stable_sort(uses, [&](OpOperand *lhs, OpOperand *rhs) {
    return context.positions.lookup(lhs->getOwner()) <
           context.positions.lookup(rhs->getOwner());
  });
  if (uses.empty())
    return uses;
  Operation *anchor = uses.front()->getOwner();
  if (llvm::all_of(uses, [&](OpOperand *use) {
        return insertionBeforeDominatesUse(anchor, use->getOwner());
      }))
    return uses;
  uses.clear();
  return uses;
}

static bool isRematCandidateSet(const wave::RegAllocTransformAliasSet &set,
                                ArrayRef<wave::RegAllocTransformValue> values,
                                unsigned position) {
  return set.regClass == waveamdmachine::RegClass::VGPR &&
         set.start < position && position < set.end &&
         !hasFixedRegAllocValue(set, values);
}

static bool
isRematValueLiveAcrossFailure(const wave::RegAllocTransformValue &stateValue,
                              unsigned position) {
  return stateValue.start < position && position < stateValue.end;
}

static FailureOr<std::optional<RematReliefSlot>>
buildRematReliefSlot(Value value,
                     const wave::RegAllocTransformValue &stateValue,
                     const RegAllocTransformFailure &failureRecord,
                     const RematReliefContext &context,
                     const DenseSet<Value> &forcedRematValues) {
  if (stateValue.start >= failureRecord.position ||
      failureRecord.position >= stateValue.end || stateValue.fixed ||
      !isRematRootValue(value))
    return std::optional<RematReliefSlot>();
  FailureOr<SmallVector<OpOperand *>> uses =
      collectRematPostFailureUses(value, failureRecord, context);
  if (failed(uses))
    return failure();
  if (uses->empty())
    return std::optional<RematReliefSlot>();
  Operation *rebuildOp = uses->front()->getOwner();
  if (!canRematerializeValueAt(value, rebuildOp, context, &forcedRematValues))
    return std::optional<RematReliefSlot>();
  unsigned opCount =
      getRematOpCountAt(value, rebuildOp, context, &forcedRematValues);
  int64_t cost =
      opCount * getRematReliefLoopCostScale(rebuildOp) + uses->size();
  RematReliefSlot slot;
  slot.uses = std::move(*uses);
  slot.value = value;
  slot.rebuildOp = rebuildOp;
  slot.stateValue = &stateValue;
  slot.cost = cost;
  slot.opCount = opCount;
  slot.rebuildPosition = context.positions.lookup(rebuildOp);
  return std::optional<RematReliefSlot>(std::move(slot));
}

static void sortRematReliefSlots(MutableArrayRef<RematReliefSlot> slots) {
  llvm::stable_sort(slots,
                    [](const RematReliefSlot &lhs, const RematReliefSlot &rhs) {
                      return std::tie(lhs.rebuildPosition, lhs.stateValue->id) <
                             std::tie(rhs.rebuildPosition, rhs.stateValue->id);
                    });
}

static void addForcedRematValues(ArrayRef<ResolvedRegAllocValue> values,
                                 unsigned position,
                                 SmallVectorImpl<Value> &rematValues,
                                 DenseSet<Value> &forcedRematValues) {
  for (ResolvedRegAllocValue resolved : values) {
    if (!isRematValueLiveAcrossFailure(*resolved.second, position))
      continue;
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
  if (!isRematValueLiveAcrossFailure(stateValue, failureRecord.position))
    return true;
  FailureOr<std::optional<RematReliefSlot>> slot = buildRematReliefSlot(
      value, stateValue, failureRecord, context, forcedRematValues);
  if (failed(slot))
    return failure();
  if (!*slot)
    return false;
  candidate.cost += (*slot)->cost;
  candidate.slots.push_back(std::move(**slot));
  return true;
}

static FailureOr<std::optional<RematReliefCandidate>>
buildRematReliefCandidate(func::FuncOp func, unsigned setId,
                          const RegAllocTransformFailure &failureRecord,
                          ArrayRef<wave::RegAllocTransformAliasSet> sets,
                          ArrayRef<wave::RegAllocTransformValue> values,
                          const RematReliefContext &context) {
  const wave::RegAllocTransformAliasSet *set =
      findRegAllocTransformSet(sets, setId);
  if (!set || !isRematCandidateSet(*set, values, failureRecord.position))
    return std::optional<RematReliefCandidate>();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveSetValues(func, *set, values);
  if (failed(resolvedValues))
    return failure();

  RematReliefCandidate candidate;
  DenseSet<Value> forcedRematValues;
  candidate.set = set;
  addForcedRematValues(*resolvedValues, failureRecord.position,
                       candidate.rematValues, forcedRematValues);
  for (ResolvedRegAllocValue resolved : *resolvedValues) {
    FailureOr<bool> added =
        addRematReliefSlot(resolved.first, *resolved.second, failureRecord,
                           context, forcedRematValues, candidate);
    if (failed(added))
      return failure();
    if (!*added)
      return std::optional<RematReliefCandidate>();
  }
  if (candidate.slots.empty())
    return std::optional<RematReliefCandidate>();
  sortRematReliefSlots(candidate.slots);
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
    if (!canUseOriginalRematLeaf(operand, user, context, &forcedRematValues)) {
      FailureOr<Value> rematOperand = materializeRematValueAt(
          builder, operand, user, context, cache, forcedRematValues);
      if (failed(rematOperand))
        return failure();
      mapped = *rematOperand;
    }
    mapping.map(operand, mapped);
  }

  Operation *clone = builder.clone(*def, mapping);
  clone->setAttr("waveamdmachine.regalloc_remat_temp", builder.getUnitAttr());
  Value result = clone->getResult(cast<OpResult>(value).getResultNumber());
  cache[value] = result;
  return result;
}

static LogicalResult materializeRematReliefSlot(
    OpBuilder &builder, const RematReliefSlot &slot,
    const RematReliefContext &context, const DenseSet<Value> &forcedRematValues,
    SmallVectorImpl<std::pair<const RematReliefSlot *, Value>> &rebuiltSlots) {
  builder.setInsertionPoint(slot.rebuildOp);
  DenseMap<Value, Value> cache;
  FailureOr<Value> rebuilt = materializeRematValueAt(
      builder, slot.value, slot.rebuildOp, context, cache, forcedRematValues);
  if (failed(rebuilt))
    return failure();
  rebuiltSlots.push_back({&slot, *rebuilt});
  return success();
}

static LogicalResult
materializeRematRelief(OpBuilder &builder,
                       const RematReliefCandidate &candidate,
                       const RematReliefContext &context) {
  DenseSet<Value> forcedRematValues(candidate.rematValues.begin(),
                                    candidate.rematValues.end());
  SmallVector<std::pair<const RematReliefSlot *, Value>> rebuiltSlots;
  rebuiltSlots.reserve(candidate.slots.size());
  for (const RematReliefSlot &slot : candidate.slots)
    if (failed(materializeRematReliefSlot(builder, slot, context,
                                          forcedRematValues, rebuiltSlots)))
      return failure();
  for (auto [slot, rebuilt] : rebuiltSlots)
    for (OpOperand *use : slot->uses)
      use->set(rebuilt);
  return success();
}

static bool isRegAllocTransformTempOp(Operation *op) {
  return op && op->hasAttr(wave::regalloc::kRegAllocTempAttr);
}

static bool isRegAllocTransformTempValue(Value value) {
  return isRegAllocTransformTempOp(value.getDefiningOp());
}

static bool isStructuralLoopCarryUse(Operation *op) {
  return isa_and_nonnull<waveamdmachine::UniformLoopOp,
                         waveamdmachine::ContinueIfOp>(op);
}

static bool
isInternalPlannedTupleFromElementsUse(OpOperand *use,
                                      const DenseSet<Value> &plannedValues) {
  auto fromElements =
      dyn_cast<waveamdmachine::TupleFromElementsOp>(use->getOwner());
  return fromElements && plannedValues.contains(fromElements.getTuple());
}

static FailureOr<SmallVector<OpOperand *>>
collectLDSReliefUses(Value value, const RegAllocTransformFailure &failureRecord,
                     const RematReliefContext &context,
                     const DenseSet<Value> &plannedValues) {
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : value.getUses()) {
    Operation *user = use.getOwner();
    if (isRegAllocTransformTempOp(user))
      continue;
    if (isStructuralLoopCarryUse(user)) {
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
isLDSReliefCandidateSet(const wave::RegAllocTransformAliasSet &set,
                        ArrayRef<wave::RegAllocTransformValue> values,
                        unsigned position) {
  return set.regClass == waveamdmachine::RegClass::VGPR &&
         set.start < position && position < set.end &&
         !hasFixedRegAllocValue(set, values);
}

static bool
isLDSValueLiveAcrossFailure(const wave::RegAllocTransformValue &stateValue,
                            unsigned position) {
  return stateValue.start < position && position < stateValue.end;
}

static void addPlannedLDSValues(ArrayRef<ResolvedRegAllocValue> values,
                                unsigned position,
                                DenseSet<Value> &plannedValues) {
  for (ResolvedRegAllocValue resolved : values)
    if (isLDSValueLiveAcrossFailure(*resolved.second, position))
      plannedValues.insert(resolved.first);
}

static unsigned getCommittedLDSSpillBytes(func::FuncOp func) {
  return getUnsignedIntegerAttr(func.getOperation(),
                                wave::regalloc::kLDSSpillBytesAttr)
      .value_or(0);
}

static std::optional<SmallVector<wave::regalloc::LDSSpillPlan, 4>>
getLDSPlansForValue(func::FuncOp func, wave::regalloc::RegisterBudgets budgets,
                    waveamdmachine::RegType type, unsigned extraReservedBytes) {
  if (type.getWidth() == 0)
    return std::nullopt;
  SmallVector<wave::regalloc::LDSSpillPlan, 4> plans;
  plans.reserve(type.getWidth());
  unsigned reserved = getCommittedLDSSpillBytes(func) + extraReservedBytes;
  for ([[maybe_unused]] unsigned index :
       llvm::seq<unsigned>(0, type.getWidth())) {
    wave::regalloc::LDSSpillPlan plan = wave::regalloc::planLDSSpillSlot(
        func, budgets, /*valueBytes=*/4, reserved);
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

static int64_t getLDSReliefCost(Value value,
                                ArrayRef<wave::regalloc::LDSSpillPlan> plans,
                                ArrayRef<OpOperand *> uses) {
  unsigned accessOps = getLDSAccessOpCount(plans);
  int64_t cost =
      accessOps * getRematReliefLoopCostScale(getValueAnchorOp(value));
  for (OpOperand *use : uses)
    cost += accessOps * getRematReliefLoopCostScale(use->getOwner());
  return cost + uses.size();
}

static FailureOr<std::optional<LDSReliefSlot>> buildLDSReliefSlot(
    func::FuncOp func, Value value,
    const wave::RegAllocTransformValue &stateValue,
    const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, wave::regalloc::RegisterBudgets budgets,
    const DenseSet<Value> &plannedValues, unsigned extraReservedBytes) {
  if (!isLDSValueLiveAcrossFailure(stateValue, failureRecord.position) ||
      stateValue.fixed || isRegAllocTransformTempValue(value))
    return std::optional<LDSReliefSlot>();
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR ||
      type.getWidth() == 0)
    return std::optional<LDSReliefSlot>();
  FailureOr<SmallVector<OpOperand *>> uses =
      collectLDSReliefUses(value, failureRecord, context, plannedValues);
  if (failed(uses))
    return failure();
  if (uses->empty())
    return std::optional<LDSReliefSlot>();
  std::optional<SmallVector<wave::regalloc::LDSSpillPlan, 4>> plans =
      getLDSPlansForValue(func, budgets, type, extraReservedBytes);
  if (!plans)
    return std::optional<LDSReliefSlot>();
  LDSReliefSlot slot;
  slot.uses = std::move(*uses);
  slot.plans = std::move(*plans);
  slot.value = value;
  slot.type = type;
  slot.stateValue = &stateValue;
  slot.useCount = slot.uses.size();
  slot.cost = getLDSReliefCost(value, slot.plans, slot.uses);
  return std::optional<LDSReliefSlot>(std::move(slot));
}

static FailureOr<bool> addLDSReliefSlot(
    func::FuncOp func, ResolvedRegAllocValue resolved,
    const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, wave::regalloc::RegisterBudgets budgets,
    const DenseSet<Value> &plannedValues, LDSReliefCandidate &candidate) {
  const wave::RegAllocTransformValue &stateValue = *resolved.second;
  if (!isLDSValueLiveAcrossFailure(stateValue, failureRecord.position))
    return true;
  FailureOr<std::optional<LDSReliefSlot>> slot = buildLDSReliefSlot(
      func, resolved.first, stateValue, failureRecord, context, budgets,
      plannedValues, candidate.reservedBytes);
  if (failed(slot))
    return failure();
  if (!*slot)
    return false;
  candidate.cost += (*slot)->cost;
  candidate.reservedBytes += getLDSSlotBytes((*slot)->plans);
  candidate.slots.push_back(std::move(**slot));
  return true;
}

static void sortLDSReliefSlots(MutableArrayRef<LDSReliefSlot> slots) {
  llvm::stable_sort(slots,
                    [](const LDSReliefSlot &lhs, const LDSReliefSlot &rhs) {
                      return lhs.stateValue->id < rhs.stateValue->id;
                    });
}

static FailureOr<std::optional<LDSReliefCandidate>>
buildLDSReliefCandidate(func::FuncOp func, unsigned setId,
                        const RegAllocTransformFailure &failureRecord,
                        ArrayRef<wave::RegAllocTransformAliasSet> sets,
                        ArrayRef<wave::RegAllocTransformValue> values,
                        const RematReliefContext &context,
                        wave::regalloc::RegisterBudgets budgets) {
  const wave::RegAllocTransformAliasSet *set =
      findRegAllocTransformSet(sets, setId);
  if (!set || !isLDSReliefCandidateSet(*set, values, failureRecord.position))
    return std::optional<LDSReliefCandidate>();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveSetValues(func, *set, values);
  if (failed(resolvedValues))
    return failure();

  DenseSet<Value> plannedValues;
  addPlannedLDSValues(*resolvedValues, failureRecord.position, plannedValues);
  LDSReliefCandidate candidate;
  candidate.set = set;
  for (ResolvedRegAllocValue resolved : *resolvedValues) {
    FailureOr<bool> added =
        addLDSReliefSlot(func, resolved, failureRecord, context, budgets,
                         plannedValues, candidate);
    if (failed(added))
      return failure();
    if (!*added)
      return std::optional<LDSReliefCandidate>();
  }
  if (candidate.slots.empty())
    return std::optional<LDSReliefCandidate>();
  sortLDSReliefSlots(candidate.slots);
  return std::optional<LDSReliefCandidate>(std::move(candidate));
}

static bool
isBetterLDSReliefCandidate(const LDSReliefCandidate &candidate,
                           const std::optional<LDSReliefCandidate> &best) {
  if (!best)
    return true;
  if (candidate.cost != best->cost)
    return candidate.cost < best->cost;
  return candidate.set->id < best->set->id;
}

static FailureOr<std::optional<LDSReliefCandidate>>
selectLDSReliefCandidate(func::FuncOp func,
                         const RegAllocTransformFailure &failureRecord,
                         ArrayRef<wave::RegAllocTransformAliasSet> sets,
                         ArrayRef<wave::RegAllocTransformValue> values,
                         const RematReliefContext &context,
                         wave::regalloc::RegisterBudgets budgets) {
  std::optional<LDSReliefCandidate> best;
  for (unsigned setId : collectVGPRReliefCandidateIds(failureRecord)) {
    FailureOr<std::optional<LDSReliefCandidate>> candidate =
        buildLDSReliefCandidate(func, setId, failureRecord, sets, values,
                                context, budgets);
    if (failed(candidate))
      return failure();
    if (!*candidate)
      continue;
    if (isBetterLDSReliefCandidate(**candidate, best))
      best = std::move(**candidate);
  }
  return best;
}

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

static FailureOr<Value> storeLDSValue(OpBuilder &builder,
                                      const LDSReliefSlot &slot, Value token) {
  wave::regalloc::setInsertionPointForMemorySpillStore(slot.value, builder);
  unsigned width = slot.type.getWidth();
  if (width == 1)
    return storeLDSScalarValue(builder, slot.value.getLoc(), slot.value, token,
                               slot.plans.front());

  SmallVector<Value> elements = wave::regalloc::splitMemorySpillValue(
      slot.value, builder, slot.value.getLoc());
  SmallVector<Value> tokens;
  tokens.reserve(elements.size());
  for (auto [index, element] : llvm::enumerate(elements)) {
    FailureOr<Value> stored = storeLDSScalarValue(
        builder, slot.value.getLoc(), element, token, slot.plans[index]);
    if (failed(stored))
      return failure();
    tokens.push_back(*stored);
  }
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  return wave::regalloc::joinMemorySpillTokens(tokenType, tokens, builder,
                                               slot.value.getLoc());
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

static Value getLDSStoreDependency(Value value) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return {};
  return wave::regalloc::getMemoryIssuerToken(def);
}

static FailureOr<LDSStoredSlot> materializeLDSStore(OpBuilder &builder,
                                                    const LDSReliefSlot &slot) {
  FailureOr<Value> token =
      storeLDSValue(builder, slot, getLDSStoreDependency(slot.value));
  if (failed(token))
    return failure();
  return LDSStoredSlot{&slot, *token};
}

static LogicalResult
replaceLDSReliefUses(OpBuilder &builder, const LDSStoredSlot &stored,
                     const DenseSet<Value> &plannedValues) {
  const LDSReliefSlot &slot = *stored.slot;
  for (OpOperand *use : slot.uses) {
    if (use->get() != slot.value)
      continue;
    if (isInternalPlannedTupleFromElementsUse(use, plannedValues))
      continue;
    Operation *user = use->getOwner();
    builder.setInsertionPoint(user);
    FailureOr<wave::regalloc::MemorySpillLoadResult> loaded = loadLDSValue(
        builder, user->getLoc(), slot.type, stored.token, slot.plans);
    if (failed(loaded))
      return failure();
    use->set(loaded->value);
  }
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
  DenseSet<Value> plannedValues;
  for (const LDSReliefSlot &slot : candidate.slots)
    plannedValues.insert(slot.value);

  SmallVector<LDSStoredSlot> storedSlots;
  storedSlots.reserve(candidate.slots.size());
  for (const LDSReliefSlot &slot : candidate.slots) {
    FailureOr<LDSStoredSlot> stored = materializeLDSStore(builder, slot);
    if (failed(stored))
      return failure();
    storedSlots.push_back(*stored);
  }
  for (const LDSStoredSlot &stored : storedSlots)
    if (failed(replaceLDSReliefUses(builder, stored, plannedValues)))
      return failure();
  reserveLDSSpillBytes(func, builder, candidate.reservedBytes);
  return success();
}

static LogicalResult refreshFuncTypeFromBody(func::FuncOp func) {
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
    FailureOr<std::optional<wave::RegAllocTransformBudget>> familyBudget =
        wave::getRegAllocTransformVGPRFamilyBudget(func);
    if (failed(familyBudget))
      return failure();
    vgprFamilyBudget = *familyBudget;
    if (failed(computeFixedBases()))
      return failure();
    collectFixedReservations();
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

  void collectFixedReservations() {
    for (const wave::RegAllocTransformAliasSet &set : sets) {
      if (!set.fixedBase)
        continue;
      wave::RegAllocTransformBudget budget =
          wave::getRegAllocTransformBudget(func, set.regClass);
      if (*set.fixedBase + set.width <= budget.limit)
        fixedReservations.push_back({set.regClass, set.id, *set.fixedBase,
                                     set.width, set.start, set.end});
    }
  }

  LogicalResult recordFixedFailure(const wave::RegAllocTransformAliasSet &set,
                                   StringRef reason) {
    wave::RegAllocTransformBudget budget =
        wave::getRegAllocTransformBudget(func, set.regClass);
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
    wave::RegAllocTransformBudget budget =
        wave::getRegAllocTransformBudget(func, set.regClass);
    if (set.fixedBase)
      return allocateFixedSet(set, budget);
    std::optional<unsigned> base = findFreeBase(set, budget.limit);
    if (!base) {
      recordPressureFailure(set, budget, getFixedReservationOverlaps(set));
      return success();
    }
    if (checkCombinedPressureFailure(set, *base))
      return success();
    addAssignment(set, *base);
    return success();
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
    for (unsigned base = 0; base <= limit - set.width; ++base)
      if (!conflictsWithActive(set, base) &&
          !conflictsWithFixedReservation(set, base))
        return base;
    return std::nullopt;
  }

  bool conflictsWithActive(const wave::RegAllocTransformAliasSet &set,
                           unsigned base) {
    return llvm::any_of(
        active, [&](const wave::RegAllocTransformAssignment &assigned) {
          return assigned.regClass == set.regClass &&
                 assignedRangesOverlap(assigned, base, set.width);
        });
  }

  bool conflictsWithFixedReservation(const wave::RegAllocTransformAliasSet &set,
                                     unsigned base) {
    return llvm::any_of(fixedReservations,
                        [&](const wave::RegAllocTransformAssignment &reserved) {
                          return reserved.regClass == set.regClass &&
                                 liveRangesOverlap(reserved.start, reserved.end,
                                                   set.start, set.end) &&
                                 assignedRangesOverlap(reserved, base,
                                                       set.width);
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
      if (liveRangesOverlap(reserved.start, reserved.end, set.start, set.end))
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
      if (isVGPRFamilyClass(assigned.regClass))
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
      if (assigned.regClass == set.regClass)
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
      if (assigned.regClass == set.regClass)
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
  SmallVector<wave::RegAllocTransformAssignment> fixedReservations;
  SmallVector<wave::RegAllocTransformAssignment> active;
  SmallVector<wave::RegAllocTransformAssignment> assignments;
  std::optional<wave::RegAllocTransformBudget> vgprFamilyBudget;
  std::optional<RegAllocScanFailure> scanFailure;
  DictionaryAttr state;
  func::FuncOp func;
  Builder &builder;
};

static LogicalResult setRegAllocTransformState(func::FuncOp func,
                                               Builder &builder) {
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
  RegAllocLinearScanner scanner(func, builder);
  return scanner.run();
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

  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      waveamdmachine::getAMDGPUTargetIsaVersion(
          func, "regalloc transform AGPR relief");
  if (failed(isa))
    return failure();
  if (!waveamdmachine::supportsAGPRs(*isa))
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

  FailureOr<std::optional<AGPRReliefCandidate>> candidate =
      selectAGPRReliefCandidate(func, **failureRecord, *sets, *values);
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
  if (failed(materializeRematRelief(builder, **candidate, context)))
    return failure();
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  func->removeAttr(wave::getRegAllocTransformStateAttrName());
  return success();
}

static FailureOr<std::optional<LDSReliefCandidate>>
selectLDSReliefCandidateFromState(
    func::FuncOp func, const RegAllocTransformFailure &failureRecord) {
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
  FailureOr<wave::regalloc::RegisterBudgets> budgets =
      getLDSTransformBudgets(func);
  if (failed(budgets))
    return failure();

  RematReliefContext context = buildRematReliefContext(func, *resolvedValues);
  return selectLDSReliefCandidate(func, failureRecord, *sets, *values, context,
                                  *budgets);
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

  FailureOr<std::optional<LDSReliefCandidate>> candidate =
      selectLDSReliefCandidateFromState(func, **failureRecord);
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
