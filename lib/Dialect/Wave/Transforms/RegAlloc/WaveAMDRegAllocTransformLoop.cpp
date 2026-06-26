//===- WaveAMDRegAllocTransformLoop.cpp - Regalloc transforms -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocTransformLoop.h"

#include "WaveAMDRegAllocTransformState.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinTypes.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
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
      externalLoopUses[scope].insert(operand);
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
    for (auto &entry : externalLoopUses) {
      auto loop = cast<waveamdmachine::UniformLoopOp>(entry.first);
      unsigned exit = getLoopExitPosition(loop);
      for (Value value : entry.second)
        extendValue(value, exit);
    }
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
  DenseMap<Operation *, DenseSet<Value>> externalLoopUses;
  DenseMap<Operation *, unsigned> positions;
  DenseMap<Value, unsigned> valueIds;
  func::FuncOp func;
  Builder &builder;
};

struct RegAllocScanFailure {
  SmallVector<wave::RegAllocTransformAssignment> overlaps;
  waveamdmachine::RegClass regClass;
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
    return computeFixedBases();
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
      recordPressureFailure(set, budget);
      return success();
    }
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
    addAssignment(set, *set.fixedBase);
    return success();
  }

  std::optional<unsigned>
  findFreeBase(const wave::RegAllocTransformAliasSet &set, unsigned limit) {
    if (set.width > limit)
      return std::nullopt;
    for (unsigned base = 0; base <= limit - set.width; ++base)
      if (!conflictsWithActive(set, base))
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

  void addAssignment(const wave::RegAllocTransformAliasSet &set,
                     unsigned base) {
    wave::RegAllocTransformAssignment assigned{
        set.regClass, set.id, base, set.width, set.start, set.end};
    assignments.push_back(assigned);
    active.push_back(assigned);
  }

  unsigned getPressureAtFailure(const wave::RegAllocTransformAliasSet &set) {
    unsigned pressure = set.width;
    for (const wave::RegAllocTransformAssignment &assigned : active)
      if (assigned.regClass == set.regClass)
        pressure += assigned.width;
    return pressure;
  }

  void recordPressureFailure(const wave::RegAllocTransformAliasSet &set,
                             wave::RegAllocTransformBudget budget) {
    RegAllocScanFailure failed;
    failed.regClass = set.regClass;
    failed.reason = "pressure";
    failed.budgetMode = budget.mode;
    failed.set = set.id;
    failed.position = set.start;
    failed.pressure = getPressureAtFailure(set);
    failed.limit = budget.limit;
    failed.request = set.width;
    for (const wave::RegAllocTransformAssignment &assigned : active)
      if (assigned.regClass == set.regClass)
        failed.overlaps.push_back(assigned);
    scanFailure = std::move(failed);
  }

  LogicalResult applyAssignments() {
    SmallVector<Value> payloadValues;
    collectRegAllocValues(func.getBody(), payloadValues);
    if (payloadValues.size() != values.size())
      return func.emitError("regalloc state value count no longer matches IR");
    DenseMap<unsigned, const wave::RegAllocTransformAssignment *> bySet;
    for (const wave::RegAllocTransformAssignment &assignment : assignments)
      bySet[assignment.set] = &assignment;
    for (const wave::RegAllocTransformValue &value : values) {
      const wave::RegAllocTransformAssignment *assignment =
          bySet.lookup(value.set);
      if (!assignment)
        return func.emitError("regalloc assignment map is incomplete");
      setValueType(payloadValues[value.id], value,
                   assignment->base + value.offset);
    }
    return refreshFuncTypeFromBody(func);
  }

  void setValueType(Value payloadValue,
                    const wave::RegAllocTransformValue &value, unsigned index) {
    auto type = cast<waveamdmachine::RegType>(payloadValue.getType());
    payloadValue.setType(waveamdmachine::RegType::get(
        type.getContext(), value.regClass, value.width, index));
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
    attrs.emplace_back(builder.getStringAttr("class"),
                       builder.getStringAttr(waveamdmachine::stringifyRegClass(
                           scanFailure->regClass)));
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
  SmallVector<wave::RegAllocTransformAssignment> active;
  SmallVector<wave::RegAllocTransformAssignment> assignments;
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
