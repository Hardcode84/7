//===- WaveAMDRegAllocTransformUtils.cpp - Regalloc utilities -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocTransformUtils.h"

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include <limits>

using namespace mlir;

namespace mlir::wave::regalloc_detail {

bool valueLiveAtPosition(const wave::RegAllocTransformValue &value,
                         unsigned position) {
  return llvm::any_of(value.ranges,
                      [&](wave::RegAllocTransformLiveRange range) {
                        return range.start <= position && position <= range.end;
                      });
}

bool valueLiveBeforeAtPosition(const wave::RegAllocTransformValue &value,
                               unsigned position) {
  return llvm::any_of(value.ranges,
                      [&](wave::RegAllocTransformLiveRange range) {
                        return range.start < position && position <= range.end;
                      });
}

bool valueLiveAcrossPosition(const wave::RegAllocTransformValue &value,
                             unsigned position) {
  return llvm::any_of(value.ranges,
                      [&](wave::RegAllocTransformLiveRange range) {
                        return range.start < position && position < range.end;
                      });
}

void addRegClassPressure(RegClassPressure &pressure,
                         waveamdmachine::RegClass regClass, int64_t dwords) {
  unsigned index = getRegClassIndex(regClass);
  assert(index < pressure.size() && "unknown register class");
  pressure[index] += dwords;
}

int64_t getTotalPressure(RegClassPressure pressure) {
  int64_t total = 0;
  for (int64_t dwords : pressure)
    total += dwords;
  return total;
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

waveamdmachine::KilledOperandReuseOpInterface
getKilledOperandReuseCandidate(Operation *op) {
  if (!op || op->getNumRegions() != 0)
    return {};
  if (!hasSingleTrackedGPRResult(op))
    return {};
  return dyn_cast<waveamdmachine::KilledOperandReuseOpInterface>(op);
}

bool isKilledOperandReuseCandidate(Operation *op) {
  return static_cast<bool>(getKilledOperandReuseCandidate(op));
}

bool canReuseKilledOperandForResult(
    waveamdmachine::KilledOperandReuseOpInterface reuse, OpOperand &operand,
    const llvm::AMDGPU::IsaVersion &isa) {
  return reuse && reuse.canReuseKilledOperandForResult(isa, operand);
}

bool canReuseKilledOperandForResult(Operation *op, OpOperand &operand,
                                    const llvm::AMDGPU::IsaVersion &isa) {
  return canReuseKilledOperandForResult(getKilledOperandReuseCandidate(op),
                                        operand, isa);
}

bool canReuseKilledOperandForResult(Operation *op, OpOperand &operand) {
  if (!isKilledOperandReuseCandidate(op))
    return false;
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      waveamdmachine::getAMDGPUTargetIsaVersion(
          op, "waveamd regalloc killed operand reuse");
  if (failed(isa))
    return false;
  return canReuseKilledOperandForResult(op, operand, *isa);
}

bool requiresKilledOperandReuseForResult(Operation *op, OpOperand &operand,
                                         const llvm::AMDGPU::IsaVersion &isa) {
  return requiresKilledOperandReuseForResult(getKilledOperandReuseCandidate(op),
                                             operand, isa);
}

bool requiresKilledOperandReuseForResult(
    waveamdmachine::KilledOperandReuseOpInterface reuse, OpOperand &operand,
    const llvm::AMDGPU::IsaVersion &isa) {
  if (!reuse || !reuse.hasRequiredKilledOperandReuse() ||
      !canReuseKilledOperandForResult(reuse, operand, isa))
    return false;
  return reuse.requiresKilledOperandReuseForResult(isa, operand);
}

bool requiresKilledOperandReuseForResult(Operation *op, OpOperand &operand) {
  if (!isKilledOperandReuseCandidate(op))
    return false;
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      waveamdmachine::getAMDGPUTargetIsaVersion(
          op, "waveamd regalloc required killed operand reuse");
  if (failed(isa))
    return false;
  return requiresKilledOperandReuseForResult(op, operand, *isa);
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

FailureOr<Value>
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
  Operation *op = getOpAt(**block, value.path.back());
  if (!op || value.number >= op->getNumResults())
    return failRegAllocStateIdentity<Value>(diagOp);
  Value resolved = op->getResult(value.number);
  if (failed(checkResolvedRegAllocValue(resolved, value, diagOp)))
    return failure();
  return resolved;
}

void collectRegAllocValues(Region &region, SmallVectorImpl<Value> &values) {
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

static LogicalResult checkRegAllocStateValueKey(
    const wave::RegAllocTransformValue &stateValue, ArrayRef<int64_t> path,
    wave::RegAllocTransformValueKind kind, unsigned number, Operation *diagOp) {
  if (stateValue.kind != kind || stateValue.number != number ||
      !llvm::equal(stateValue.path, path))
    return diagOp->emitError(
        "regalloc state value identity no longer matches IR");
  return success();
}

static LogicalResult appendResolvedRegAllocValue(
    Value payloadValue, ArrayRef<int64_t> path,
    wave::RegAllocTransformValueKind kind, unsigned number,
    ArrayRef<wave::RegAllocTransformValue> values,
    SmallVectorImpl<ResolvedRegAllocValue> &resolved, Operation *diagOp) {
  if (!wave::getRegAllocTransformTrackedRegType(payloadValue))
    return success();
  if (resolved.size() >= values.size())
    return diagOp->emitError("regalloc state value count no longer matches IR");

  const wave::RegAllocTransformValue &stateValue = values[resolved.size()];
  if (failed(
          checkRegAllocStateValueKey(stateValue, path, kind, number, diagOp)) ||
      failed(checkResolvedRegAllocValue(payloadValue, stateValue, diagOp)))
    return failure();
  resolved.push_back({payloadValue, &stateValue});
  return success();
}

static LogicalResult
collectResolvedRegAllocValues(Region &region, ArrayRef<int64_t> regionPath,
                              ArrayRef<wave::RegAllocTransformValue> values,
                              SmallVectorImpl<ResolvedRegAllocValue> &resolved,
                              Operation *diagOp) {
  for (auto [blockIndex, block] : llvm::enumerate(region)) {
    SmallVector<int64_t> blockPath(regionPath);
    blockPath.push_back(blockIndex);
    for (BlockArgument arg : block.getArguments())
      if (failed(appendResolvedRegAllocValue(
              arg, blockPath, wave::RegAllocTransformValueKind::BlockArgument,
              arg.getArgNumber(), values, resolved, diagOp)))
        return failure();
    for (auto [opIndex, op] : llvm::enumerate(block)) {
      SmallVector<int64_t> opPath(blockPath);
      opPath.push_back(opIndex);
      for (auto [regionIndex, nested] : llvm::enumerate(op.getRegions())) {
        SmallVector<int64_t> nestedPath(opPath);
        nestedPath.push_back(regionIndex);
        if (failed(collectResolvedRegAllocValues(nested, nestedPath, values,
                                                 resolved, diagOp)))
          return failure();
      }
      for (OpResult result : op.getResults())
        if (failed(appendResolvedRegAllocValue(
                result, opPath, wave::RegAllocTransformValueKind::OpResult,
                result.getResultNumber(), values, resolved, diagOp)))
          return failure();
    }
  }
  return success();
}

FailureOr<SmallVector<ResolvedRegAllocValue>>
resolveRegAllocStateValues(func::FuncOp func,
                           ArrayRef<wave::RegAllocTransformValue> values) {
  SmallVector<ResolvedRegAllocValue> resolvedValues;
  resolvedValues.reserve(values.size());
  SmallVector<int64_t> rootPath{0};
  if (failed(collectResolvedRegAllocValues(func.getBody(), rootPath, values,
                                           resolvedValues,
                                           func.getOperation())))
    return failure();
  if (resolvedValues.size() != values.size())
    return func.emitError("regalloc state value count no longer matches IR");
  return resolvedValues;
}

static std::pair<Attribute, Attribute>
getRegAllocTransformStateIdentity(DictionaryAttr state) {
  if (wave::RegAllocStateAttr packed = state.getAs<wave::RegAllocStateAttr>(
          wave::getRegAllocTransformPackedStateFieldName()))
    return {packed, packed};
  return {state.get("values"), state.get("alias_sets")};
}

FailureOr<const RegAllocTransformDecodedState *>
RegAllocTransformStateCache::get(func::FuncOp func) {
  DictionaryAttr state = func->getAttrOfType<DictionaryAttr>(
      wave::getRegAllocTransformStateAttrName());
  if (!state)
    return func.emitError("regalloc transform state is missing");
  auto [valuesIdentity, aliasSetsIdentity] =
      getRegAllocTransformStateIdentity(state);
  auto it = states.find(func.getOperation());
  if (it != states.end() && it->second->valuesIdentity == valuesIdentity &&
      it->second->aliasSetsIdentity == aliasSetsIdentity)
    return it->second.get();

  std::unique_ptr<RegAllocTransformDecodedState> decoded =
      std::make_unique<RegAllocTransformDecodedState>();
  FailureOr<SmallVector<wave::RegAllocTransformValue>> values =
      wave::parseRegAllocTransformValues(state, func.getOperation());
  if (failed(values))
    return failure();
  decoded->values = std::move(*values);
  FailureOr<SmallVector<wave::RegAllocTransformAliasSet>> sets =
      wave::parseRegAllocTransformAliasSets(state, decoded->values,
                                            func.getOperation());
  if (failed(sets))
    return failure();
  decoded->sets = std::move(*sets);
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveRegAllocStateValues(func, decoded->values);
  if (failed(resolvedValues))
    return failure();
  decoded->resolvedValues = std::move(*resolvedValues);
  for (auto [value, stateValue] : decoded->resolvedValues)
    decoded->valueLookup[value] = stateValue;
  collectRegAllocOpPositions(func.getBody(), decoded->positions);
  decoded->valuesIdentity = valuesIdentity;
  decoded->aliasSetsIdentity = aliasSetsIdentity;
  RegAllocTransformDecodedState *result = decoded.get();
  states[func.getOperation()] = std::move(decoded);
  return result;
}

void RegAllocTransformStateCache::install(
    func::FuncOp func, DictionaryAttr state,
    std::unique_ptr<RegAllocTransformDecodedState> decoded) {
  std::tie(decoded->valuesIdentity, decoded->aliasSetsIdentity) =
      getRegAllocTransformStateIdentity(state);
  states[func.getOperation()] = std::move(decoded);
}

void RegAllocTransformStateCache::erase(func::FuncOp func) {
  states.erase(func.getOperation());
}

void RegAllocTransformStateCache::clear() { states.clear(); }

FailureOr<SmallVector<ResolvedRegAllocValue>> getResolvedRegAllocSetValues(
    func::FuncOp func, const wave::RegAllocTransformAliasSet &set,
    ArrayRef<ResolvedRegAllocValue> allResolvedValues) {
  SmallVector<ResolvedRegAllocValue> setValues;
  setValues.reserve(set.members.size());
  for (unsigned valueId : set.members) {
    if (valueId >= allResolvedValues.size() ||
        allResolvedValues[valueId].second->id != valueId)
      return func.emitError("regalloc state member value id is invalid");
    setValues.push_back(allResolvedValues[valueId]);
  }
  return setValues;
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

struct RegAllocFailureKind {
  StringRef className;
  StringRef reason;
};

static FailureOr<RegAllocFailureKind>
parseRegAllocFailureKind(DictionaryAttr failureAttr, Operation *diagOp) {
  StringAttr className = failureAttr.getAs<StringAttr>("class");
  StringAttr reason = failureAttr.getAs<StringAttr>("reason");
  if (!className || !reason)
    return diagOp->emitError("regalloc failure state missing string field");
  return RegAllocFailureKind{className.getValue(), reason.getValue()};
}

static FailureOr<std::optional<unsigned>>
parseOptionalRegAllocFailureUnsignedAttr(DictionaryAttr failureAttr,
                                         StringRef name, Operation *diagOp) {
  Attribute attr = failureAttr.get(name);
  if (!attr)
    return std::optional<unsigned>();
  auto integer = dyn_cast<IntegerAttr>(attr);
  if (!integer)
    return diagOp->emitError("regalloc state field `")
           << name << "` is not an integer";
  const APInt &value = integer.getValue();
  if (value.isNegative() ||
      value.getActiveBits() > std::numeric_limits<unsigned>::digits)
    return diagOp->emitError("regalloc state integer `")
           << name << "` exceeds supported range";
  return std::optional<unsigned>(static_cast<unsigned>(value.getZExtValue()));
}

static FailureOr<RegAllocTransformFailure>
parseRegAllocFailure(DictionaryAttr failureAttr, RegAllocFailureKind kind,
                     func::FuncOp func) {
  FailureOr<unsigned> set =
      wave::getRegAllocTransformUnsignedAttr(failureAttr, "set", func);
  FailureOr<unsigned> position =
      wave::getRegAllocTransformUnsignedAttr(failureAttr, "position", func);
  FailureOr<std::optional<unsigned>> limit =
      parseOptionalRegAllocFailureUnsignedAttr(failureAttr, "limit", func);
  FailureOr<std::optional<unsigned>> pressure =
      parseOptionalRegAllocFailureUnsignedAttr(failureAttr, "pressure", func);
  FailureOr<std::optional<unsigned>> request =
      parseOptionalRegAllocFailureUnsignedAttr(failureAttr, "request", func);
  if (failed(set) || failed(position) || failed(limit) || failed(pressure) ||
      failed(request))
    return failure();

  RegAllocTransformFailure parsed;
  parsed.className = kind.className;
  parsed.reason = kind.reason;
  parsed.limit = std::move(*limit);
  parsed.pressure = std::move(*pressure);
  parsed.request = std::move(*request);
  parsed.set = *set;
  parsed.position = *position;
  if (failed(parseRegAllocFailureOverlaps(failureAttr, func, parsed.overlaps)))
    return failure();
  return parsed;
}

FailureOr<std::optional<RegAllocTransformFailure>>
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

bool isAGPRRelievableFailure(const RegAllocTransformFailure &failure) {
  bool relievableClass =
      failure.className == "vgpr" || failure.className == "vgpr_agpr";
  bool relievableReason =
      failure.reason == "pressure" || failure.reason == "allocated-footprint";
  return relievableClass && relievableReason;
}

std::optional<unsigned>
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

const wave::RegAllocTransformAliasSet *
findRegAllocTransformSet(ArrayRef<wave::RegAllocTransformAliasSet> sets,
                         unsigned id) {
  for (const wave::RegAllocTransformAliasSet &set : sets)
    if (set.id == id)
      return &set;
  return nullptr;
}

SmallVector<unsigned>
collectVGPRReliefCandidateIds(const RegAllocTransformFailure &failure) {
  SmallVector<unsigned> ids;
  DenseSet<unsigned> seen;
  auto add = [&](unsigned id) {
    if (seen.insert(id).second)
      ids.push_back(id);
  };
  add(failure.set);
  for (const wave::RegAllocTransformAssignment &overlap : failure.overlaps)
    if (overlap.regClass == waveamdmachine::RegClass::VGPR)
      add(overlap.set);
  return ids;
}

bool hasFixedRegAllocValue(const wave::RegAllocTransformAliasSet &set,
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

bool isRegAllocTransformBridgeRelated(Value value) {
  return isRegAllocTransformBridgeValue(value) ||
         hasRegAllocTransformBridgeUse(value);
}

bool isStructuralLoopCarryUse(Operation *op) {
  return isa_and_nonnull<waveamdmachine::UniformLoopOp,
                         waveamdmachine::ContinueIfOp>(op);
}

bool hasStructuralLoopCarryUse(Value value) {
  return llvm::any_of(value.getUses(), [](OpOperand &use) {
    return isStructuralLoopCarryUse(use.getOwner());
  });
}

void collectRegAllocOpPositions(Region &region,
                                DenseMap<Operation *, unsigned> &ops) {
  for (Block &block : region) {
    for (Operation &op : block) {
      ops[&op] = ops.size();
      for (Region &nested : op.getRegions())
        collectRegAllocOpPositions(nested, ops);
    }
  }
}

RematReliefContext
buildRematReliefContext(ArrayRef<ResolvedRegAllocValue> values,
                        const DenseMap<Operation *, unsigned> &positions) {
  RematReliefContext context;
  context.positions = &positions;
  for (ResolvedRegAllocValue value : values)
    context.values[value.first] = value.second;
  return context;
}

Operation *getAncestorInBlock(Operation *op, Block *block) {
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

bool valueIsAvailableAt(Value value, Operation *user) {
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

std::optional<unsigned> getRematOpPosition(Operation *op,
                                           const RematReliefContext &context) {
  assert(context.positions && "missing remat operation positions");
  auto it = context.positions->find(op);
  if (it == context.positions->end())
    return std::nullopt;
  return it->second;
}

bool isStateValueLiveAt(Value value, unsigned position,
                        const RematReliefContext &context) {
  auto it = context.values.find(value);
  if (it == context.values.end())
    return false;
  const wave::RegAllocTransformValue &stateValue = *it->second;
  return valueLiveAtPosition(stateValue, position);
}

static int64_t getLoopCostScale(unsigned depth) {
  if (depth == 0)
    return 1;
  return int64_t{1} << std::min<unsigned>(depth * 4, 20);
}

int64_t getRematReliefLoopCostScale(Operation *op) {
  unsigned depth = 0;
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(cur))
      ++depth;
  return getLoopCostScale(depth);
}

int64_t getParentLoopCostScale(Operation *op) {
  unsigned depth = 0;
  for (Operation *cur = op->getParentOp(); cur; cur = cur->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(cur))
      ++depth;
  return getLoopCostScale(depth);
}

int64_t getMemoryBridgeCostScale(Operation *anchor, bool beforeAnchor) {
  if (beforeAnchor && isa<waveamdmachine::UniformLoopOp>(anchor))
    return getParentLoopCostScale(anchor);
  return getRematReliefLoopCostScale(anchor);
}

std::optional<unsigned> getUnsignedIntegerAttr(Operation *op, StringRef name) {
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

Attribute findAncestorAttr(Operation *op, StringRef name) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (Attribute attr = cur->getAttr(name))
      return attr;
  return {};
}

} // namespace mlir::wave::regalloc_detail
