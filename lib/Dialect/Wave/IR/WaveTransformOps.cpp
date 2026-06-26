//===- WaveTransformOps.cpp - Wave transform-dialect ops --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/Wave.h"

#include "mlir/Dialect/Wave/IR/WaveMeta.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/PressureAnalysis.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/RegionProfile.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Transform/IR/TransformDialect.h"
#include "mlir/Dialect/Transform/IR/TransformOps.h"
#include "mlir/Dialect/Transform/Interfaces/TransformInterfaces.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OwningOpRef.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/IR/Threading.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/TargetParser/TargetParser.h"
#include <cmath>
#include <limits>
#include <optional>

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveTransformOps.cpp.inc"

using namespace mlir;

DiagnosedSilenceableFailure
wave::TransformGetIntAttrOp::apply(transform::TransformRewriter &rewriter,
                                   transform::TransformResults &results,
                                   transform::TransformState &state) {
  StringRef key = getAttrName();
  SmallVector<Attribute> values;
  for (Operation *target : state.getPayloadOps(getTarget())) {
    auto attr = target->getAttrOfType<IntegerAttr>(key);
    if (!attr)
      return emitDefiniteFailure()
             << "target op missing IntegerAttr `" << key << "`";
    values.push_back(attr);
  }
  results.setParams(cast<OpResult>(getResult()), values);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformGetIntAttrOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
}

//===----------------------------------------------------------------------===//
// wave.transform.regalloc_loop
//===----------------------------------------------------------------------===//

namespace {

static constexpr StringLiteral kRegAllocTransformStateAttr =
    "waveamdmachine.regalloc_transform_state";

static DiagnosedSilenceableFailure
runNamedSequence(transform::TransformOpInterface caller,
                 transform::NamedSequenceOp callee,
                 MutableArrayRef<SmallVector<transform::MappedValue>> bindings,
                 transform::TransformState &state,
                 SmallVectorImpl<SmallVector<transform::MappedValue>> &out);

static StringRef getRegClassName(waveamdmachine::RegClass regClass) {
  switch (regClass) {
  case waveamdmachine::RegClass::SGPR:
    return "sgpr";
  case waveamdmachine::RegClass::VGPR:
    return "vgpr";
  case waveamdmachine::RegClass::AGPR:
    return "agpr";
  case waveamdmachine::RegClass::SCC:
    return "scc";
  case waveamdmachine::RegClass::VCC:
    return "vcc";
  }
  llvm_unreachable("unknown register class");
}

static std::optional<waveamdmachine::RegType> getTrackedRegType(Value value) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type)
    return std::nullopt;
  switch (type.getRegClass()) {
  case waveamdmachine::RegClass::SGPR:
  case waveamdmachine::RegClass::VGPR:
  case waveamdmachine::RegClass::AGPR:
    return type;
  case waveamdmachine::RegClass::SCC:
  case waveamdmachine::RegClass::VCC:
    return std::nullopt;
  }
  llvm_unreachable("unknown register class");
}

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
    std::optional<waveamdmachine::RegType> type = getTrackedRegType(value);
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

  void collectMMAAliases(Operation *op) {
    auto mma = dyn_cast<waveamdmachine::MMAOpInterface>(op);
    if (!mma || !op->hasTrait<OpTrait::waveamdmachine::MFMAOp>())
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

  void collectRegionAliases(Operation *op) {
    if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op)) {
      if (!loop.getBody().empty()) {
        Block &body = loop.getBody().front();
        for (auto [init, arg, result] : llvm::zip_equal(
                 loop.getInits(), body.getArguments(), loop.getResults())) {
          addAliasEdge(init, arg, 0);
          addAliasEdge(init, result, 0);
        }
        if (auto cont =
                dyn_cast<waveamdmachine::ContinueIfOp>(body.getTerminator()))
          for (auto [init, carry] :
               llvm::zip_equal(loop.getInits(), cont.getCarries()))
            addAliasEdge(init, carry, 0);
      }
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
      for (Value operand : record.op->getOperands())
        extendValue(operand, record.position);
      collectTupleAliases(record.op);
      collectMMAAliases(record.op);
      collectRegionAliases(record.op);
    }
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
    attrs.emplace_back(
        builder.getStringAttr("class"),
        builder.getStringAttr(getRegClassName(record.type.getRegClass())));
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

  DictionaryAttr buildAliasMemberAttr(const RegAllocAliasValue &record) {
    SmallVector<NamedAttribute> attrs;
    attrs.emplace_back(builder.getStringAttr("end"), getI64(record.end));
    attrs.emplace_back(builder.getStringAttr("offset"), getI64(record.offset));
    attrs.emplace_back(builder.getStringAttr("start"), getI64(record.start));
    attrs.emplace_back(builder.getStringAttr("value"), getI64(record.id));
    attrs.emplace_back(builder.getStringAttr("width"),
                       getI64(record.type.getWidth()));
    return getDictionary(attrs);
  }

  DictionaryAttr buildAliasSetAttr(const RegAllocAliasSet &set) {
    SmallVector<Attribute> memberAttrs;
    int64_t width = 0;
    for (unsigned member : set.members) {
      const RegAllocAliasValue &value = values[member];
      memberAttrs.push_back(buildAliasMemberAttr(value));
      width = std::max(width, value.offset + value.type.getWidth());
    }
    SmallVector<NamedAttribute> attrs;
    attrs.emplace_back(builder.getStringAttr("class"),
                       builder.getStringAttr(getRegClassName(
                           values[set.members.front()].type.getRegClass())));
    attrs.emplace_back(builder.getStringAttr("id"), getI64(set.id));
    attrs.emplace_back(builder.getStringAttr("members"),
                       builder.getArrayAttr(memberAttrs));
    attrs.emplace_back(builder.getStringAttr("width"), getI64(width));
    return getDictionary(attrs);
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
  DenseMap<Operation *, unsigned> positions;
  DenseMap<Value, unsigned> valueIds;
  func::FuncOp func;
  Builder &builder;
};

static LogicalResult setRegAllocTransformState(func::FuncOp func,
                                               Builder &builder) {
  RegAllocAliasStateBuilder stateBuilder(func, builder);
  FailureOr<DictionaryAttr> state = stateBuilder.build();
  if (failed(state))
    return failure();
  func->setAttr(kRegAllocTransformStateAttr, *state);
  return success();
}

static LogicalResult stampRegAllocTransformState(Operation *target,
                                                 Builder &builder) {
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return setRegAllocTransformState(func, builder);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(setRegAllocTransformState(func, builder))
               ? WalkResult::interrupt()
               : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}

static void clearRegAllocTransformState(Operation *target) {
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target)) {
    func->removeAttr(kRegAllocTransformStateAttr);
    return;
  }
  target->walk(
      [](func::FuncOp func) { func->removeAttr(kRegAllocTransformStateAttr); });
}

static DiagnosedSilenceableFailure
emitRegAllocTransformStateFailure(wave::TransformRegAllocBuildAliasStateOp op) {
  return op.emitDefiniteFailure() << "failed to build regalloc alias state";
}

static DiagnosedSilenceableFailure
stampRegAllocTransformState(wave::TransformRegAllocBuildAliasStateOp op,
                            transform::TransformState &state,
                            SmallVectorImpl<Operation *> &targets) {
  Builder builder(op.getContext());
  for (Operation *target : state.getPayloadOps(op.getTarget())) {
    targets.push_back(target);
    clearRegAllocTransformState(target);
    if (failed(stampRegAllocTransformState(target, builder)))
      return emitRegAllocTransformStateFailure(op);
  }
  return DiagnosedSilenceableFailure::success();
}

static DiagnosedSilenceableFailure
collectHandleResults(wave::TransformRegAllocLoopOp op,
                     ArrayRef<transform::MappedValue> mappings,
                     SmallVectorImpl<Operation *> &result) {
  result.reserve(mappings.size());
  for (transform::MappedValue mapping : mappings) {
    Operation *payload = mapping.dyn_cast<Operation *>();
    if (!payload)
      return op.emitDefiniteFailure()
             << "regalloc loop body must yield an operation handle";
    result.push_back(payload);
  }
  return DiagnosedSilenceableFailure::success();
}

static DiagnosedSilenceableFailure
runRegAllocLoopBody(wave::TransformRegAllocLoopOp op,
                    transform::TransformResults &results,
                    transform::TransformState &state) {
  transform::NamedSequenceOp body =
      SymbolTable::lookupNearestSymbolFrom<transform::NamedSequenceOp>(
          op.getOperation(), op.getBodyAttr());
  if (!body)
    return op.emitDefiniteFailure()
           << "body symbol `" << op.getBody()
           << "` does not resolve to a transform.named_sequence";

  SmallVector<transform::MappedValue> targetMapping;
  for (Operation *target : state.getPayloadOps(op.getTarget()))
    targetMapping.push_back(target);
  SmallVector<SmallVector<transform::MappedValue>> bindings;
  bindings.push_back(std::move(targetMapping));
  SmallVector<SmallVector<transform::MappedValue>> out;
  DiagnosedSilenceableFailure status =
      runNamedSequence(op, body, bindings, state, out);
  if (!status.succeeded())
    return status;
  if (out.size() != 1)
    return op.emitDefiniteFailure()
           << "regalloc loop body must yield one operation handle";
  SmallVector<Operation *> yielded;
  DiagnosedSilenceableFailure collectStatus =
      collectHandleResults(op, out[0], yielded);
  if (!collectStatus.succeeded())
    return collectStatus;
  results.set(cast<OpResult>(op.getResult()), yielded);
  return DiagnosedSilenceableFailure::success();
}

} // namespace

LogicalResult wave::TransformRegAllocLoopOp::verifySymbolUses(
    SymbolTableCollection &symbolTable) {
  transform::NamedSequenceOp body =
      symbolTable.lookupNearestSymbolFrom<transform::NamedSequenceOp>(
          getOperation(), getBodyAttr());
  if (!body)
    return emitOpError() << "body symbol `" << getBody()
                         << "` does not resolve to a transform.named_sequence";
  return success();
}

DiagnosedSilenceableFailure
wave::TransformRegAllocLoopOp::apply(transform::TransformRewriter &rewriter,
                                     transform::TransformResults &results,
                                     transform::TransformState &state) {
  return runRegAllocLoopBody(*this, results, state);
}

void wave::TransformRegAllocLoopOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}

DiagnosedSilenceableFailure wave::TransformRegAllocBuildAliasStateOp::apply(
    transform::TransformRewriter &rewriter,
    transform::TransformResults &results, transform::TransformState &state) {
  SmallVector<Operation *> targets;
  DiagnosedSilenceableFailure status =
      stampRegAllocTransformState(*this, state, targets);
  if (!status.succeeded())
    return status;
  results.set(cast<OpResult>(getResult()), targets);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformRegAllocBuildAliasStateOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}

//===----------------------------------------------------------------------===//
// wave.transform.estimate_cycles + wave.transform.pressure_report
//===----------------------------------------------------------------------===//

namespace {

static std::optional<waveamdmachine::AMDGPUTarget>
readTargetFromEnclosingModule(Operation *op) {
  ModuleOp mod = waveamdmachine::findAMDGPUTargetModule(op);
  if (!mod)
    return std::nullopt;
  StringAttr attr = mod->getAttrOfType<StringAttr>("waveamdmachine.target");
  return waveamdmachine::parseAMDGPUTargetAttr(attr.getValue());
}

// Failure if enclosing target attr is missing, malformed, or unsupported.
static FailureOr<const waveamdmachine::ArchData *>
resolveArch(Operation *target) {
  std::optional<waveamdmachine::AMDGPUTarget> parsed =
      readTargetFromEnclosingModule(target);
  if (!parsed)
    return failure();
  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(parsed->chip);
  if (!waveamdmachine::isArchSupported(isa))
    return failure();
  return &waveamdmachine::getArchData(isa);
}

// Sum totalCycles across all func.func in a target. For a single
// func target this is just that func's cycles.
static FailureOr<int64_t> sumFuncCycles(Operation *target,
                                        const waveamdmachine::ArchData &arch) {
  int64_t total = 0;
  auto runOne = [&](func::FuncOp f) -> LogicalResult {
    waveamdmachine::PressureAnalysisResult res;
    if (failed(waveamdmachine::runPressureAnalysis(f, arch, res)))
      return failure();
    total += res.totalCycles;
    return success();
  };
  if (auto f = dyn_cast<func::FuncOp>(target))
    return failed(runOne(f)) ? FailureOr<int64_t>(failure())
                             : FailureOr<int64_t>(total);
  WalkResult walk = target->walk([&](func::FuncOp f) {
    return failed(runOne(f)) ? WalkResult::interrupt() : WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return failure();
  return total;
}

} // namespace

DiagnosedSilenceableFailure
wave::TransformEstimateCyclesOp::apply(transform::TransformRewriter &rewriter,
                                       transform::TransformResults &results,
                                       transform::TransformState &state) {
  Builder b(getContext());
  SmallVector<Attribute> values;
  for (Operation *target : state.getPayloadOps(getTarget())) {
    auto arch = resolveArch(target);
    if (failed(arch))
      return emitDefiniteFailure()
             << "target has no enclosing module with `waveamdmachine.target` "
                "or arch is unsupported";
    auto cycles = sumFuncCycles(target, **arch);
    if (failed(cycles))
      return emitDefiniteFailure() << "PressureAnalysis failed on target";
    values.push_back(b.getI64IntegerAttr(*cycles));
  }
  results.setParams(cast<OpResult>(getResult()), values);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformEstimateCyclesOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
}

namespace {

// Walk wave.amd.machine ops in `target` (a func or module);
// accumulate issue cycles per FU from classifier + funit. Pure
// static walk -- no dataflow needed.
static llvm::DenseMap<waveamdmachine::FunctionalUnit, int64_t>
computePerFuCycles(Operation *target, const waveamdmachine::ArchData &arch) {
  llvm::DenseMap<waveamdmachine::FunctionalUnit, int64_t> counts;
  target->walk([&](Operation *op) {
    if (op == target)
      return;
    if (!isa<waveamdmachine::WaveAMDMachineDialect>(op->getDialect()))
      return;
    waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
    if (cls == waveamdmachine::SchedClass::NoInst)
      return;
    waveamdmachine::FunctionalUnit fu = waveamdmachine::funit(arch, cls);
    if (fu == waveamdmachine::FunctionalUnit::None)
      return;
    counts[fu] += 1;
  });
  return counts;
}

} // namespace

DiagnosedSilenceableFailure
wave::TransformPressureReportOp::apply(transform::TransformRewriter &rewriter,
                                       transform::TransformResults &results,
                                       transform::TransformState &state) {
  Builder b(getContext());
  StringAttr attrName = b.getStringAttr(getAttrName());
  for (Operation *target : state.getPayloadOps(getTarget())) {
    auto arch = resolveArch(target);
    if (failed(arch))
      return emitDefiniteFailure()
             << "target has no enclosing module with `waveamdmachine.target` "
                "or arch is unsupported";
    auto counts = computePerFuCycles(target, **arch);
    SmallVector<NamedAttribute> entries;
    for (int i = 0; i < static_cast<int>(
                            waveamdmachine::FunctionalUnit::NumFunctionalUnits);
         ++i) {
      auto fu = static_cast<waveamdmachine::FunctionalUnit>(i);
      if (fu == waveamdmachine::FunctionalUnit::None)
        continue;
      auto it = counts.find(fu);
      if (it == counts.end())
        continue;
      entries.emplace_back(
          b.getStringAttr(waveamdmachine::getFunctionalUnitName(fu)),
          b.getI64IntegerAttr(it->second));
    }
    target->setAttr(attrName, b.getDictionaryAttr(entries));
  }
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformPressureReportOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::modifiesPayload(effects);
}

//===----------------------------------------------------------------------===//
// wave.transform.pingpong_score
//===----------------------------------------------------------------------===//

namespace {

static FailureOr<waveamdmachine::PingpongPick>
scorePingpongFunc(func::FuncOp f, const waveamdmachine::ArchData &arch) {
  waveamdmachine::PressureAnalysisResult res;
  if (failed(waveamdmachine::runPressureAnalysis(f, arch, res)))
    return failure();
  SmallVector<waveamdmachine::RegionProfile> regions =
      waveamdmachine::partitionRegions(f, res, arch);
  return waveamdmachine::findOptimalPingpongDelay(regions, arch);
}

static FailureOr<waveamdmachine::PingpongPick>
scorePingpongTarget(Operation *target, const waveamdmachine::ArchData &arch) {
  if (auto f = dyn_cast<func::FuncOp>(target))
    return scorePingpongFunc(f, arch);

  bool sawFunc = false;
  waveamdmachine::PingpongPick best;
  WalkResult walk = target->walk([&](func::FuncOp f) {
    FailureOr<waveamdmachine::PingpongPick> pick = scorePingpongFunc(f, arch);
    if (failed(pick))
      return WalkResult::interrupt();
    if (!sawFunc || pick->predictedPeakUtil > best.predictedPeakUtil)
      best = *pick;
    sawFunc = true;
    return WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return failure();
  return best;
}

} // namespace

DiagnosedSilenceableFailure
wave::TransformPingpongScoreOp::apply(transform::TransformRewriter &rewriter,
                                      transform::TransformResults &results,
                                      transform::TransformState &state) {
  if (getWaves() != 2)
    return emitDefiniteFailure()
           << "pingpong_score currently supports waves = 2 only";

  Builder b(getContext());
  SmallVector<Attribute> delays;
  SmallVector<Attribute> peaks;
  for (Operation *target : state.getPayloadOps(getTarget())) {
    auto arch = resolveArch(target);
    if (failed(arch))
      return emitDefiniteFailure()
             << "target has no enclosing module with `waveamdmachine.target` "
                "or arch is unsupported";
    FailureOr<waveamdmachine::PingpongPick> pick =
        scorePingpongTarget(target, **arch);
    if (failed(pick))
      return emitDefiniteFailure() << "region partition failed";
    int64_t peak = std::llround(pick->predictedPeakUtil * 1000.0);
    delays.push_back(b.getI64IntegerAttr(pick->delay));
    peaks.push_back(b.getI64IntegerAttr(peak));
  }
  results.setParams(cast<OpResult>(getDelay()), delays);
  results.setParams(cast<OpResult>(getPeak()), peaks);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformPingpongScoreOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
}

//===----------------------------------------------------------------------===//
// wave.transform.insert_pingpong_barriers
//===----------------------------------------------------------------------===//

namespace {

// Insert a wave-id-prio nudge at func entry and an s_barrier before
// every region boundary after the first. Empty-token barriers --
// ticket-wait insertion runs later and threads dependencies.
static LogicalResult insertBarriersInFunc(func::FuncOp f,
                                          const waveamdmachine::ArchData &arch,
                                          int64_t prio) {
  waveamdmachine::PressureAnalysisResult res;
  if (failed(waveamdmachine::runPressureAnalysis(f, arch, res)))
    return failure();
  SmallVector<waveamdmachine::RegionProfile> regions =
      waveamdmachine::partitionRegions(f, res, arch);
  OpBuilder b(f.getContext());
  Block &entry = f.getBody().front();
  b.setInsertionPointToStart(&entry);
  Value imm = waveamdmachine::ImmOp::create(
      b, f.getLoc(), waveamdmachine::ImmType::get(f.getContext()),
      static_cast<uint64_t>(prio));
  waveamdmachine::SSetprioOp::create(b, f.getLoc(), imm);
  for (size_t i = 1; i < regions.size(); ++i) {
    Operation *begin = regions[i].begin;
    if (!begin)
      continue;
    b.setInsertionPoint(begin);
    waveamdmachine::SBarrierOp::create(b, begin->getLoc(), TypeRange{},
                                       ValueRange{});
  }
  return success();
}

} // namespace

DiagnosedSilenceableFailure wave::TransformInsertPingpongBarriersOp::apply(
    transform::TransformRewriter &rewriter,
    transform::TransformResults &results, transform::TransformState &state) {
  int64_t prio = getPrio();
  for (Operation *target : state.getPayloadOps(getTarget())) {
    auto arch = resolveArch(target);
    if (failed(arch))
      return emitDefiniteFailure()
             << "target has no enclosing module with `waveamdmachine.target` "
                "or arch is unsupported";
    auto runOne = [&](func::FuncOp f) {
      return insertBarriersInFunc(f, **arch, prio);
    };
    if (auto f = dyn_cast<func::FuncOp>(target)) {
      if (failed(runOne(f)))
        return emitDefiniteFailure() << "region partition failed";
    } else {
      WalkResult w = target->walk([&](func::FuncOp f) {
        return failed(runOne(f)) ? WalkResult::interrupt()
                                 : WalkResult::advance();
      });
      if (w.wasInterrupted())
        return emitDefiniteFailure() << "region partition failed";
    }
  }
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformInsertPingpongBarriersOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::modifiesPayload(effects);
}

DiagnosedSilenceableFailure
wave::TransformBindParamOp::apply(transform::TransformRewriter &rewriter,
                                  transform::TransformResults &results,
                                  transform::TransformState &state) {
  auto targets = state.getPayloadOps(getTarget());
  if (llvm::range_size(targets) != 1)
    return emitDefiniteFailure() << "expected exactly one target op, got "
                                 << llvm::range_size(targets);
  Operation *target = *targets.begin();
  auto mod = dyn_cast<ModuleOp>(target);
  if (!mod)
    return emitDefiniteFailure() << "target must be a `builtin.module` op";

  ArrayRef<Attribute> values = state.getParams(getValue());
  if (values.size() != 1)
    return emitDefiniteFailure()
           << "expected the value param to hold one attribute, got "
           << values.size();

  Builder builder(mod.getContext());
  Attribute valueAttr = values.front();
  if (TypeAttr resultTypeAttr = getResultTypeAttr()) {
    Type resultType = resultTypeAttr.getValue();
    if (!resultType.isIntOrIndex())
      return emitDefiniteFailure()
             << "`as` clause requires an integer or index type, got "
             << resultType;
    auto intAttr = dyn_cast<IntegerAttr>(valueAttr);
    if (!intAttr)
      return emitDefiniteFailure()
             << "`as` clause requires the value to be an IntegerAttr, got "
             << valueAttr;
    valueAttr = IntegerAttr::get(resultType, intAttr.getValue().getSExtValue());
  }
  StringAttr paramsName =
      builder.getStringAttr(wavemeta::WaveMetaDialect::getParamsAttrName());
  StringAttr keyAttr = builder.getStringAttr(getAttrName());
  SmallVector<NamedAttribute> entries;
  if (auto existing = mod->getAttrOfType<DictionaryAttr>(paramsName)) {
    for (NamedAttribute na : existing) {
      if (na.getName() != keyAttr)
        entries.push_back(na);
    }
  }
  entries.emplace_back(keyAttr, valueAttr);
  mod->setAttr(paramsName, builder.getDictionaryAttr(entries));
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformBindParamOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::onlyReadsHandle(getValueMutable(), effects);
  transform::modifiesPayload(effects);
}

//===----------------------------------------------------------------------===//
// wave.transform.tune
//===----------------------------------------------------------------------===//

namespace {

// Enumerate one variable's domain into a flat `int64_t` list.
static FailureOr<SmallVector<int64_t>>
expandDomain(Attribute domainAttr, Operation *errOp, StringAttr name) {
  if (auto e = dyn_cast<wave::TuneEnumAttr>(domainAttr))
    return SmallVector<int64_t>(e.getValues().begin(), e.getValues().end());
  if (auto r = dyn_cast<wave::TuneRangeAttr>(domainAttr)) {
    SmallVector<int64_t> result;
    for (int64_t v = r.getLower(); v < r.getUpper(); v += r.getStep())
      result.push_back(v);
    return result;
  }
  if (auto p = dyn_cast<wave::TunePow2InAttr>(domainAttr)) {
    SmallVector<int64_t> result;
    uint64_t v = 1;
    while (v < static_cast<uint64_t>(p.getLower()))
      v <<= 1;
    for (; v <= static_cast<uint64_t>(p.getUpper()); v <<= 1)
      result.push_back(static_cast<int64_t>(v));
    return result;
  }
  return errOp->emitError("unrecognized tune-var domain for `")
         << name.getValue() << "`";
}

// Walk the Cartesian product of `domains` in lex order (first variable
// is the slow axis). `out` receives one i64 vector per config.
static void enumerateCartesian(ArrayRef<SmallVector<int64_t>> domains,
                               SmallVector<SmallVector<int64_t>> &out) {
  size_t n = domains.size();
  if (n == 0) {
    out.emplace_back();
    return;
  }
  size_t total = 1;
  for (const auto &d : domains)
    total *= d.size();
  out.reserve(total);
  for (size_t k = 0; k < total; ++k) {
    SmallVector<int64_t> config(n);
    size_t rem = k;
    for (size_t i = n; i > 0; --i) {
      size_t idx = rem % domains[i - 1].size();
      config[i - 1] = domains[i - 1][idx];
      rem /= domains[i - 1].size();
    }
    out.push_back(std::move(config));
  }
}

// Run a `transform.named_sequence` with explicit block-argument bindings.
// Mirrors `IncludeOp::apply` minus the failure-propagation knobs.
//   `bindings[i]` is the mapping for the i-th block argument of `callee`.
//   `out` receives one mapping per terminator operand.
static DiagnosedSilenceableFailure
runNamedSequence(transform::TransformOpInterface caller,
                 transform::NamedSequenceOp callee,
                 MutableArrayRef<SmallVector<transform::MappedValue>> bindings,
                 transform::TransformState &state,
                 SmallVectorImpl<SmallVector<transform::MappedValue>> &out) {
  if (callee.isExternal())
    return caller.emitDefiniteFailure()
           << "named sequence `" << callee.getSymName()
           << "` is external; cannot invoke";
  Block &block = callee.getBody().front();
  if (block.getNumArguments() != bindings.size())
    return caller.emitDefiniteFailure()
           << "named sequence `" << callee.getSymName() << "` expects "
           << block.getNumArguments() << " arguments, got " << bindings.size();
  auto scope = state.make_region_scope(callee.getBody());
  for (auto &&[arg, mapping] :
       llvm::zip_equal(block.getArguments(), bindings)) {
    if (failed(state.mapBlockArgument(arg, mapping)))
      return DiagnosedSilenceableFailure::definiteFailure();
  }
  for (Operation &op : block.without_terminator()) {
    DiagnosedSilenceableFailure res =
        state.applyTransform(cast<transform::TransformOpInterface>(op));
    if (!res.succeeded())
      return res;
  }
  // Materialise mappings for the terminator operands.
  Operation *yield = block.getTerminator();
  transform::detail::prepareValueMappings(out, yield->getOperands(), state);
  return DiagnosedSilenceableFailure::success();
}

// Expand every `$variables` entry's domain. Definite-failure on bad or
// empty domain. Outputs in declared key order.
static DiagnosedSilenceableFailure
tuneCollectDomains(transform::TransformOpInterface op, DictionaryAttr variables,
                   SmallVectorImpl<StringAttr> &names,
                   SmallVectorImpl<SmallVector<int64_t>> &domains) {
  for (NamedAttribute na : variables) {
    FailureOr<SmallVector<int64_t>> dom =
        expandDomain(na.getValue(), op.getOperation(), na.getName());
    if (failed(dom))
      return DiagnosedSilenceableFailure::definiteFailure();
    if (dom->empty())
      return op.emitDefiniteFailure()
             << "tune variable `" << na.getName().getValue()
             << "` has an empty domain after expansion";
    names.push_back(na.getName());
    domains.push_back(std::move(*dom));
  }
  return DiagnosedSilenceableFailure::success();
}

// Build the per-variable `!transform.param<i64>` bindings for one config.
static SmallVector<SmallVector<transform::MappedValue>>
buildParamBindings(Builder &builder, ArrayRef<int64_t> config) {
  SmallVector<SmallVector<transform::MappedValue>> bindings(config.size());
  for (size_t i = 0; i < config.size(); ++i)
    bindings[i].push_back(
        static_cast<Attribute>(builder.getI64IntegerAttr(config[i])));
  return bindings;
}

enum class TrialStatus { Definite, Skip, Ok };

struct TrialOutcome {
  TrialStatus status = TrialStatus::Skip;
  OwningOpRef<ModuleOp> clone;
  int64_t score = 0;
  DiagnosedSilenceableFailure diag = DiagnosedSilenceableFailure::success();
};

// Helper: pull the i64 out of a score-sequence yield. Returns the score
// on success, or `failure()` after setting `out.diag` to a definite
// failure on a malformed yield.
static FailureOr<int64_t>
extractScore(transform::TransformOpInterface caller,
             ArrayRef<SmallVector<transform::MappedValue>> scoreOut,
             TrialOutcome &out) {
  if (scoreOut.size() != 1 || scoreOut[0].size() != 1) {
    out.status = TrialStatus::Definite;
    out.diag = caller.emitDefiniteFailure()
               << "score sequence must yield a single !transform.param<i64> "
                  "with one associated value";
    return failure();
  }
  auto scoreAttr = dyn_cast<IntegerAttr>(cast<Attribute>(scoreOut[0][0]));
  if (!scoreAttr) {
    out.status = TrialStatus::Definite;
    out.diag = caller.emitDefiniteFailure()
               << "score sequence must yield an IntegerAttr-shaped param";
    return failure();
  }
  return scoreAttr.getInt();
}

// Invoke `callee` and translate the three failure modes into a
// `TrialStatus`. `Ok` here just means "no failure"; the caller still
// needs to check terminator output if any.
static TrialStatus
invokeOrClassify(transform::TransformOpInterface caller,
                 transform::NamedSequenceOp callee,
                 MutableArrayRef<SmallVector<transform::MappedValue>> bindings,
                 transform::TransformState &state,
                 SmallVectorImpl<SmallVector<transform::MappedValue>> &out,
                 TrialOutcome &outcome) {
  DiagnosedSilenceableFailure r =
      runNamedSequence(caller, callee, bindings, state, out);
  if (r.isDefiniteFailure()) {
    outcome.status = TrialStatus::Definite;
    outcome.diag = std::move(r);
    return TrialStatus::Definite;
  }
  if (!r.succeeded()) {
    (void)r.silence();
    return TrialStatus::Skip;
  }
  return TrialStatus::Ok;
}

// Evaluate one trial: assumes-check, clone, body, score. Constructs
// per-trial `TransformState` instances so the runtime stack and
// payload mappings are isolated from the outer interpreter -- this is
// what lets trials run on a thread pool. `Ok` carries the clone and
// its score; `Skip` is a silenceable prune; `Definite` is a
// propagating failure.
static TrialOutcome
runTrial(transform::TransformOpInterface caller, ModuleOp origModule,
         transform::NamedSequenceOp bodyCallee,
         transform::NamedSequenceOp scoreCallee,
         transform::NamedSequenceOp assumesCallee,
         MutableArrayRef<SmallVector<transform::MappedValue>> paramBindings) {
  TrialOutcome out;
  // Each sub-sequence runs against its own `TransformState`. The
  // public ctor is private; `makeTransformStateForTesting` is the only
  // public factory and the cross-thread isolation it gives is the
  // whole point of using it here, not just testing.
  if (assumesCallee) {
    transform::TransformState assumesState =
        transform::detail::makeTransformStateForTesting(
            /*region=*/nullptr, /*payloadRoot=*/origModule);
    SmallVector<SmallVector<transform::MappedValue>> dummy;
    TrialStatus st = invokeOrClassify(caller, assumesCallee, paramBindings,
                                      assumesState, dummy, out);
    if (st != TrialStatus::Ok)
      return out;
  }

  out.clone = cast<ModuleOp>(origModule->clone());

  SmallVector<SmallVector<transform::MappedValue>> bodyBindings;
  bodyBindings.reserve(1 + paramBindings.size());
  SmallVector<transform::MappedValue> targetMapping;
  targetMapping.push_back(static_cast<Operation *>(out.clone->getOperation()));
  bodyBindings.push_back(std::move(targetMapping));
  for (const SmallVector<transform::MappedValue> &m : paramBindings)
    bodyBindings.push_back(m);

  transform::TransformState bodyState =
      transform::detail::makeTransformStateForTesting(
          /*region=*/nullptr,
          /*payloadRoot=*/out.clone->getOperation());
  SmallVector<SmallVector<transform::MappedValue>> bodyOut;
  TrialStatus bst = invokeOrClassify(caller, bodyCallee, bodyBindings,
                                     bodyState, bodyOut, out);
  if (bst != TrialStatus::Ok)
    return out;

  transform::TransformState scoreState =
      transform::detail::makeTransformStateForTesting(
          /*region=*/nullptr,
          /*payloadRoot=*/out.clone->getOperation());
  SmallVector<SmallVector<transform::MappedValue>> scoreOut;
  TrialStatus sst = invokeOrClassify(caller, scoreCallee, bodyBindings,
                                     scoreState, scoreOut, out);
  if (sst != TrialStatus::Ok)
    return out;

  FailureOr<int64_t> sc = extractScore(caller, scoreOut, out);
  if (failed(sc))
    return out;
  out.score = *sc;
  out.status = TrialStatus::Ok;
  return out;
}

// Per-tune-op resolved callees.
struct TuneCallees {
  transform::NamedSequenceOp body;
  transform::NamedSequenceOp score;
  transform::NamedSequenceOp assumes; // May be null.
};

// Drive the enumeration: dispatch every trial in parallel via the
// context thread pool, then reduce sequentially in enumeration order
// for deterministic tie-breaking. Each trial runs on its own clone
// with its own `TransformState`, so the only shared state during the
// parallel phase is the unifying StorageUniquer and the source
// module's read-only IR. `bestClone`/`bestScore` are valid only when
// `anyFeasible` flips to true.
static DiagnosedSilenceableFailure
tuneRunAllTrials(transform::TransformOpInterface caller, ModuleOp orig,
                 const TuneCallees &callees,
                 ArrayRef<SmallVector<int64_t>> configs, Builder &builder,
                 OwningOpRef<ModuleOp> &bestClone, int64_t &bestScore,
                 bool &anyFeasible) {
  SmallVector<SmallVector<SmallVector<transform::MappedValue>>> allBindings;
  allBindings.reserve(configs.size());
  for (const SmallVector<int64_t> &config : configs)
    allBindings.push_back(buildParamBindings(builder, config));
  SmallVector<TrialOutcome> outcomes(configs.size());
  // MLIR wrapper buffers diagnostics per config and flushes in order.
  mlir::parallelFor(caller->getContext(), 0, configs.size(), [&](size_t i) {
    outcomes[i] = runTrial(caller, orig, callees.body, callees.score,
                           callees.assumes, allBindings[i]);
  });
  for (TrialOutcome &o : outcomes) {
    if (o.status == TrialStatus::Definite)
      return std::move(o.diag);
    if (o.status == TrialStatus::Skip)
      continue;
    if (!anyFeasible || o.score > bestScore) {
      bestClone = std::move(o.clone);
      bestScore = o.score;
    }
    anyFeasible = true;
  }
  return DiagnosedSilenceableFailure::success();
}

// Move the winner's non-transform contents into `orig`'s body and adopt
// its module-level attributes. Transform-dialect ops on both sides
// survive: orig still hosts the running interpreter.
static void installWinner(ModuleOp orig, ModuleOp winner) {
  Block &origBody = orig.getBodyRegion().front();
  Block &winBody = winner.getBodyRegion().front();
  auto isTransformOp = [](Operation &op) {
    Dialect *d = op.getDialect();
    return d && isa<transform::TransformDialect>(d);
  };
  for (Operation &op : llvm::make_early_inc_range(origBody)) {
    if (!isTransformOp(op))
      op.erase();
  }
  SmallVector<Operation *> toMove;
  for (Operation &op : winBody) {
    if (!isTransformOp(op))
      toMove.push_back(&op);
  }
  for (Operation *op : toMove)
    op->moveBefore(&origBody, origBody.end());
  // Clone's attrs >= orig's (clone started as a copy).
  orig->setAttrs(winner->getAttrs());
}

} // namespace

LogicalResult
wave::TransformTuneOp::verifySymbolUses(SymbolTableCollection &symbolTable) {
  auto checkExists = [&](SymbolRefAttr ref, StringRef role) -> LogicalResult {
    auto callee =
        symbolTable.lookupNearestSymbolFrom<transform::NamedSequenceOp>(
            getOperation(), ref);
    if (!callee)
      return emitOpError()
             << role << " symbol `" << ref
             << "` does not resolve to a transform.named_sequence";
    return success();
  };
  if (failed(checkExists(getBodyAttr(), "body")))
    return failure();
  if (failed(checkExists(getScoreAttr(), "score")))
    return failure();
  if (SymbolRefAttr assumes = getAssumesAttr())
    if (failed(checkExists(assumes, "assumes")))
      return failure();
  return success();
}

DiagnosedSilenceableFailure
wave::TransformTuneOp::apply(transform::TransformRewriter &rewriter,
                             transform::TransformResults &results,
                             transform::TransformState &state) {
  auto targets = state.getPayloadOps(getTarget());
  if (llvm::range_size(targets) != 1)
    return emitDefiniteFailure() << "expected exactly one target op, got "
                                 << llvm::range_size(targets);
  auto origModule = dyn_cast<ModuleOp>(*targets.begin());
  if (!origModule)
    return emitDefiniteFailure() << "target must be a `builtin.module` op";

  TuneCallees callees;
  callees.body =
      SymbolTable::lookupNearestSymbolFrom<transform::NamedSequenceOp>(
          getOperation(), getBodyAttr());
  callees.score =
      SymbolTable::lookupNearestSymbolFrom<transform::NamedSequenceOp>(
          getOperation(), getScoreAttr());
  if (SymbolRefAttr assumes = getAssumesAttr())
    callees.assumes =
        SymbolTable::lookupNearestSymbolFrom<transform::NamedSequenceOp>(
            getOperation(), assumes);

  SmallVector<StringAttr> varNames;
  SmallVector<SmallVector<int64_t>> varDomains;
  if (DiagnosedSilenceableFailure r =
          tuneCollectDomains(*this, getVariables(), varNames, varDomains);
      !r.succeeded())
    return r;

  SmallVector<SmallVector<int64_t>> configs;
  enumerateCartesian(varDomains, configs);

  Builder builder(getContext());
  OwningOpRef<ModuleOp> bestClone;
  int64_t bestScore = std::numeric_limits<int64_t>::min();
  bool anyFeasible = false;
  if (DiagnosedSilenceableFailure r =
          tuneRunAllTrials(*this, origModule, callees, configs, builder,
                           bestClone, bestScore, anyFeasible);
      !r.succeeded())
    return r;
  if (!anyFeasible)
    return emitDefiniteFailure() << "no feasible tune trial";

  installWinner(origModule, *bestClone);
  results.set(cast<OpResult>(getWinner()), {origModule});
  results.setParams(cast<OpResult>(getBestScore()),
                    {builder.getI64IntegerAttr(bestScore)});
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformTuneOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::consumesHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
  transform::modifiesPayload(effects);
}
