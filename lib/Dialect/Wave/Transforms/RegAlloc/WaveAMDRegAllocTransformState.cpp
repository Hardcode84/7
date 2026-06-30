//===- WaveAMDRegAllocTransformState.cpp - Regalloc loop state ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocTransformState.h"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/MathExtras.h"
#include <array>
#include <limits>

using namespace mlir;

namespace mlir::wave {

static constexpr StringLiteral kRegAllocTransformStateAttr =
    "waveamdmachine.regalloc_transform_state";
static constexpr StringLiteral kRegAllocAssignmentsAttr =
    "waveamdmachine.regalloc_assignments";
static constexpr StringLiteral kRegAllocStageSuccess = "linear-scan-success";
static constexpr StringLiteral kRegAllocStageFailure = "linear-scan-failure";
static constexpr StringLiteral kTargetWavesAttr = "waveamdmachine.target_waves";
static constexpr StringLiteral kRegAllocMetadataIterations =
    "wave.regalloc.iterations";
static constexpr StringLiteral kRegAllocMetadataAGPR =
    "wave.regalloc.agpr.dwords";
static constexpr StringLiteral kRegAllocMetadataRemat =
    "wave.regalloc.remat.dwords";
static constexpr StringLiteral kRegAllocMetadataLDS =
    "wave.regalloc.lds.dwords";
static constexpr StringLiteral kRegAllocMetadataScratch =
    "wave.regalloc.scratch.dwords";

StringRef getRegAllocTransformStateAttrName() {
  return kRegAllocTransformStateAttr;
}

StringRef getRegAllocTransformAssignmentsAttrName() {
  return kRegAllocAssignmentsAttr;
}

std::optional<waveamdmachine::RegType>
getRegAllocTransformTrackedRegType(Value value) {
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

FailureOr<unsigned> getRegAllocTransformUnsignedAttr(DictionaryAttr dict,
                                                     StringRef name,
                                                     Operation *diagOp) {
  auto attr = dict.getAs<IntegerAttr>(name);
  if (!attr)
    return diagOp->emitError("regalloc state missing integer `") << name << "`";
  int64_t value = attr.getInt();
  if (value < 0 ||
      static_cast<uint64_t>(value) > std::numeric_limits<unsigned>::max())
    return diagOp->emitError("regalloc state integer `")
           << name << "` exceeds supported range";
  return static_cast<unsigned>(value);
}

FailureOr<waveamdmachine::RegClass>
getRegAllocTransformRegClassAttr(DictionaryAttr dict, Operation *diagOp) {
  auto attr = dict.getAs<StringAttr>("class");
  if (!attr)
    return diagOp->emitError("regalloc state missing string `class`");
  std::optional<waveamdmachine::RegClass> regClass =
      waveamdmachine::symbolizeRegClass(attr.getValue());
  if (!regClass)
    return diagOp->emitError("regalloc state has unknown register class `")
           << attr.getValue() << "`";
  return *regClass;
}

static FailureOr<SmallVector<int64_t>>
parseI64ArrayAttr(DictionaryAttr dict, StringRef name, Operation *diagOp) {
  ArrayAttr array = dict.getAs<ArrayAttr>(name);
  if (!array)
    return diagOp->emitError("regalloc state missing array `") << name << "`";
  SmallVector<int64_t> values;
  values.reserve(array.size());
  for (Attribute attr : array) {
    IntegerAttr intAttr = dyn_cast<IntegerAttr>(attr);
    if (!intAttr)
      return diagOp->emitError("regalloc state array `")
             << name << "` has non-integer element";
    values.push_back(intAttr.getInt());
  }
  return values;
}

static FailureOr<RegAllocTransformLiveRange> parseLiveRange(Attribute attr,
                                                            Operation *diagOp) {
  DictionaryAttr dict = dyn_cast<DictionaryAttr>(attr);
  if (!dict)
    return diagOp->emitError("regalloc state range is not a dictionary");
  FailureOr<unsigned> start =
      getRegAllocTransformUnsignedAttr(dict, "start", diagOp);
  FailureOr<unsigned> end =
      getRegAllocTransformUnsignedAttr(dict, "end", diagOp);
  if (failed(start) || failed(end))
    return failure();
  if (*end < *start)
    return diagOp->emitError("regalloc state range end precedes start");
  return RegAllocTransformLiveRange{*start, *end};
}

static bool lessLiveRange(RegAllocTransformLiveRange lhs,
                          RegAllocTransformLiveRange rhs) {
  return std::tie(lhs.start, lhs.end) < std::tie(rhs.start, rhs.end);
}

static FailureOr<SmallVector<RegAllocTransformLiveRange, 2>>
parseLiveRanges(DictionaryAttr dict, unsigned start, unsigned end,
                Operation *diagOp) {
  ArrayAttr rangeAttrs = dict.getAs<ArrayAttr>("ranges");
  if (!rangeAttrs)
    return SmallVector<RegAllocTransformLiveRange, 2>{
        RegAllocTransformLiveRange{start, end}};
  if (rangeAttrs.empty())
    return diagOp->emitError("regalloc state value has empty ranges");

  SmallVector<RegAllocTransformLiveRange, 2> ranges;
  ranges.reserve(rangeAttrs.size());
  for (Attribute attr : rangeAttrs) {
    FailureOr<RegAllocTransformLiveRange> range = parseLiveRange(attr, diagOp);
    if (failed(range))
      return failure();
    ranges.push_back(*range);
  }
  llvm::stable_sort(ranges, lessLiveRange);
  for (auto [index, range] : llvm::enumerate(ArrayRef(ranges).drop_front()))
    if (range.start <= ranges[index].end)
      return diagOp->emitError("regalloc state value ranges must be disjoint");
  if (ranges.front().start != start || ranges.back().end != end)
    return diagOp->emitError("regalloc state value range envelope mismatch");
  return ranges;
}

static FailureOr<RegAllocTransformValueKind> parseValueKind(DictionaryAttr dict,
                                                            Operation *diagOp) {
  StringAttr attr = dict.getAs<StringAttr>("kind");
  if (!attr)
    return diagOp->emitError("regalloc state missing string `kind`");
  if (attr.getValue() == "block_arg")
    return RegAllocTransformValueKind::BlockArgument;
  if (attr.getValue() == "op_result")
    return RegAllocTransformValueKind::OpResult;
  return diagOp->emitError("regalloc state has unknown value kind `")
         << attr.getValue() << "`";
}

static LogicalResult parseFixedIndex(DictionaryAttr dict, Operation *diagOp,
                                     RegAllocTransformValue &value) {
  auto fixed = dict.getAs<IntegerAttr>("fixed");
  if (!fixed)
    return success();
  int64_t raw = fixed.getInt();
  if (raw < 0 ||
      static_cast<uint64_t>(raw) > std::numeric_limits<unsigned>::max())
    return diagOp->emitError("regalloc state fixed index exceeds range");
  value.fixed = static_cast<unsigned>(raw);
  return success();
}

struct ParsedRegAllocValueUnsignedAttrs {
  unsigned id = 0;
  unsigned number = 0;
  unsigned set = 0;
  unsigned start = 0;
  unsigned end = 0;
  unsigned width = 0;
  unsigned offset = 0;
};

static FailureOr<ParsedRegAllocValueUnsignedAttrs>
parseValueUnsignedAttrs(DictionaryAttr dict, Operation *diagOp) {
  FailureOr<unsigned> id = getRegAllocTransformUnsignedAttr(dict, "id", diagOp);
  FailureOr<unsigned> number =
      getRegAllocTransformUnsignedAttr(dict, "number", diagOp);
  FailureOr<unsigned> set =
      getRegAllocTransformUnsignedAttr(dict, "set", diagOp);
  FailureOr<unsigned> start =
      getRegAllocTransformUnsignedAttr(dict, "start", diagOp);
  FailureOr<unsigned> end =
      getRegAllocTransformUnsignedAttr(dict, "end", diagOp);
  FailureOr<unsigned> width =
      getRegAllocTransformUnsignedAttr(dict, "width", diagOp);
  FailureOr<unsigned> offset =
      getRegAllocTransformUnsignedAttr(dict, "offset", diagOp);
  if (failed(id) || failed(number) || failed(set) || failed(start) ||
      failed(end) || failed(width) || failed(offset))
    return failure();
  return ParsedRegAllocValueUnsignedAttrs{*id,  *number, *set,   *start,
                                          *end, *width,  *offset};
}

static FailureOr<RegAllocTransformValue> parseValue(DictionaryAttr dict,
                                                    Operation *diagOp) {
  FailureOr<waveamdmachine::RegClass> regClass =
      getRegAllocTransformRegClassAttr(dict, diagOp);
  FailureOr<RegAllocTransformValueKind> kind = parseValueKind(dict, diagOp);
  FailureOr<SmallVector<int64_t>> path =
      parseI64ArrayAttr(dict, "path", diagOp);
  FailureOr<ParsedRegAllocValueUnsignedAttrs> unsignedAttrs =
      parseValueUnsignedAttrs(dict, diagOp);
  if (failed(regClass) || failed(kind) || failed(path) || failed(unsignedAttrs))
    return failure();
  if (path->empty())
    return diagOp->emitError("regalloc state value has empty path");
  FailureOr<SmallVector<RegAllocTransformLiveRange, 2>> ranges =
      parseLiveRanges(dict, unsignedAttrs->start, unsignedAttrs->end, diagOp);
  if (failed(ranges))
    return failure();

  RegAllocTransformValue value;
  value.path = std::move(*path);
  value.ranges = std::move(*ranges);
  value.regClass = *regClass;
  value.kind = *kind;
  value.id = unsignedAttrs->id;
  value.set = unsignedAttrs->set;
  value.start = unsignedAttrs->start;
  value.end = unsignedAttrs->end;
  value.width = unsignedAttrs->width;
  value.offset = unsignedAttrs->offset;
  value.number = unsignedAttrs->number;
  if (failed(parseFixedIndex(dict, diagOp, value)))
    return failure();
  return value;
}

FailureOr<SmallVector<RegAllocTransformValue>>
parseRegAllocTransformValues(DictionaryAttr state, Operation *diagOp) {
  auto valueAttrs = state.getAs<ArrayAttr>("values");
  if (!valueAttrs)
    return diagOp->emitError("regalloc state missing `values`");
  SmallVector<RegAllocTransformValue> values;
  values.reserve(valueAttrs.size());
  for (Attribute attr : valueAttrs) {
    auto dict = dyn_cast<DictionaryAttr>(attr);
    if (!dict)
      return diagOp->emitError("regalloc state has non-dictionary value");
    FailureOr<RegAllocTransformValue> value = parseValue(dict, diagOp);
    if (failed(value))
      return failure();
    if (value->id != values.size())
      return diagOp->emitError("regalloc state value id does not match order");
    values.push_back(std::move(*value));
  }
  return values;
}

static LogicalResult parseAliasMembers(DictionaryAttr dict,
                                       ArrayRef<RegAllocTransformValue> values,
                                       Operation *diagOp,
                                       RegAllocTransformAliasSet &set) {
  auto memberAttrs = dict.getAs<ArrayAttr>("members");
  if (!memberAttrs)
    return diagOp->emitError("regalloc state alias set missing `members`");
  set.start = std::numeric_limits<unsigned>::max();
  for (Attribute attr : memberAttrs) {
    auto member = dyn_cast<DictionaryAttr>(attr);
    if (!member)
      return diagOp->emitError("regalloc state has non-dictionary member");
    FailureOr<unsigned> valueId =
        getRegAllocTransformUnsignedAttr(member, "value", diagOp);
    if (failed(valueId) || *valueId >= values.size())
      return diagOp->emitError("regalloc state member value id is invalid");
    const RegAllocTransformValue &value = values[*valueId];
    set.members.push_back(*valueId);
    set.start = std::min(set.start, value.start);
    set.end = std::max(set.end, value.end);
  }
  if (set.members.empty())
    return diagOp->emitError("regalloc state has empty alias set");
  return success();
}

static void
insertAliasSetLiveRange(SmallVectorImpl<RegAllocTransformLiveRange> &ranges,
                        RegAllocTransformLiveRange range) {
  auto it =
      llvm::lower_bound(ranges, range.start,
                        [](RegAllocTransformLiveRange existing,
                           unsigned start) { return existing.end < start; });
  if (it == ranges.end() || range.end < it->start) {
    ranges.insert(it, range);
    return;
  }
  it->start = std::min(it->start, range.start);
  it->end = std::max(it->end, range.end);
  auto next = it;
  ++next;
  while (next != ranges.end() && next->start <= it->end) {
    it->end = std::max(it->end, next->end);
    next = ranges.erase(next);
  }
}

static void collectAliasSetLiveRanges(RegAllocTransformAliasSet &set,
                                      ArrayRef<RegAllocTransformValue> values) {
  for (unsigned valueId : set.members)
    for (RegAllocTransformLiveRange range : values[valueId].ranges)
      insertAliasSetLiveRange(set.ranges, range);
}

static FailureOr<RegAllocTransformAliasSet>
parseAliasSet(DictionaryAttr dict, ArrayRef<RegAllocTransformValue> values,
              Operation *diagOp) {
  FailureOr<waveamdmachine::RegClass> regClass =
      getRegAllocTransformRegClassAttr(dict, diagOp);
  FailureOr<unsigned> id = getRegAllocTransformUnsignedAttr(dict, "id", diagOp);
  FailureOr<unsigned> width =
      getRegAllocTransformUnsignedAttr(dict, "width", diagOp);
  if (failed(regClass) || failed(id) || failed(width))
    return failure();
  RegAllocTransformAliasSet set;
  set.regClass = *regClass;
  set.id = *id;
  set.width = *width;
  if (failed(parseAliasMembers(dict, values, diagOp, set)))
    return failure();
  collectAliasSetLiveRanges(set, values);
  return set;
}

FailureOr<SmallVector<RegAllocTransformAliasSet>>
parseRegAllocTransformAliasSets(DictionaryAttr state,
                                ArrayRef<RegAllocTransformValue> values,
                                Operation *diagOp) {
  auto setAttrs = state.getAs<ArrayAttr>("alias_sets");
  if (!setAttrs)
    return diagOp->emitError("regalloc state missing `alias_sets`");
  SmallVector<RegAllocTransformAliasSet> sets;
  sets.reserve(setAttrs.size());
  for (Attribute attr : setAttrs) {
    auto dict = dyn_cast<DictionaryAttr>(attr);
    if (!dict)
      return diagOp->emitError("regalloc state has non-dictionary alias set");
    FailureOr<RegAllocTransformAliasSet> set =
        parseAliasSet(dict, values, diagOp);
    if (failed(set))
      return failure();
    sets.push_back(std::move(*set));
  }
  llvm::stable_sort(sets, [](const RegAllocTransformAliasSet &lhs,
                             const RegAllocTransformAliasSet &rhs) {
    return std::tie(lhs.start, lhs.id) < std::tie(rhs.start, rhs.id);
  });
  return sets;
}

static Attribute getI64(Builder &builder, int64_t value) {
  return builder.getI64IntegerAttr(value);
}

DictionaryAttr buildRegAllocTransformAliasMemberAttr(
    Builder &builder, const RegAllocTransformAliasMember &member) {
  SmallVector<NamedAttribute> attrs;
  attrs.emplace_back(builder.getStringAttr("end"), getI64(builder, member.end));
  attrs.emplace_back(builder.getStringAttr("offset"),
                     getI64(builder, member.offset));
  attrs.emplace_back(builder.getStringAttr("start"),
                     getI64(builder, member.start));
  attrs.emplace_back(builder.getStringAttr("value"),
                     getI64(builder, member.value));
  attrs.emplace_back(builder.getStringAttr("width"),
                     getI64(builder, member.width));
  return builder.getDictionaryAttr(attrs);
}

DictionaryAttr buildRegAllocTransformAliasSetAttr(
    Builder &builder, waveamdmachine::RegClass regClass, unsigned id,
    ArrayRef<RegAllocTransformAliasMember> members, unsigned width) {
  SmallVector<Attribute> memberAttrs;
  for (const RegAllocTransformAliasMember &member : members)
    memberAttrs.push_back(
        buildRegAllocTransformAliasMemberAttr(builder, member));
  SmallVector<NamedAttribute> attrs;
  attrs.emplace_back(
      builder.getStringAttr("class"),
      builder.getStringAttr(waveamdmachine::stringifyRegClass(regClass)));
  attrs.emplace_back(builder.getStringAttr("id"), getI64(builder, id));
  attrs.emplace_back(builder.getStringAttr("members"),
                     builder.getArrayAttr(memberAttrs));
  attrs.emplace_back(builder.getStringAttr("width"), getI64(builder, width));
  return builder.getDictionaryAttr(attrs);
}

DictionaryAttr buildRegAllocTransformAssignmentAttr(
    Builder &builder, const RegAllocTransformAssignment &assignment) {
  SmallVector<NamedAttribute> attrs;
  attrs.emplace_back(builder.getStringAttr("base"),
                     getI64(builder, assignment.base));
  attrs.emplace_back(builder.getStringAttr("class"),
                     builder.getStringAttr(waveamdmachine::stringifyRegClass(
                         assignment.regClass)));
  attrs.emplace_back(builder.getStringAttr("end"),
                     getI64(builder, assignment.end));
  attrs.emplace_back(builder.getStringAttr("set"),
                     getI64(builder, assignment.set));
  attrs.emplace_back(builder.getStringAttr("start"),
                     getI64(builder, assignment.start));
  attrs.emplace_back(builder.getStringAttr("width"),
                     getI64(builder, assignment.width));
  return builder.getDictionaryAttr(attrs);
}

static StringRef getRegClassBudgetAttr(waveamdmachine::RegClass regClass) {
  switch (regClass) {
  case waveamdmachine::RegClass::SGPR:
    return "waveamdmachine.sgpr_count_max";
  case waveamdmachine::RegClass::VGPR:
    return "waveamdmachine.vgpr_count_max";
  case waveamdmachine::RegClass::AGPR:
    return "waveamdmachine.agpr_count_max";
  case waveamdmachine::RegClass::SCC:
  case waveamdmachine::RegClass::VCC:
    return "";
  }
  llvm_unreachable("unknown register class");
}

unsigned
getRegAllocTransformDefaultBudgetLimit(waveamdmachine::RegClass regClass) {
  switch (regClass) {
  case waveamdmachine::RegClass::SGPR:
    return 128;
  case waveamdmachine::RegClass::VGPR:
  case waveamdmachine::RegClass::AGPR:
    return 256;
  case waveamdmachine::RegClass::SCC:
  case waveamdmachine::RegClass::VCC:
    return 0;
  }
  llvm_unreachable("unknown register class");
}

static std::optional<unsigned> getUnsignedIntegerAttr(Operation *op,
                                                      StringRef name) {
  if (!op)
    return std::nullopt;
  auto attr = op->getAttrOfType<IntegerAttr>(name);
  if (!attr)
    return std::nullopt;
  int64_t value = attr.getInt();
  if (value <= 0)
    return 0;
  if (value > std::numeric_limits<unsigned>::max())
    return std::numeric_limits<unsigned>::max();
  return static_cast<unsigned>(value);
}

static Attribute findAncestorAttr(Operation *op, StringRef name) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (Attribute attr = cur->getAttr(name))
      return attr;
  return {};
}

static bool hasCombinedVGPRFamilyPressure(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 &&
         ((isa.Minor == 0 && isa.Stepping == 10) || isa.Minor == 4 ||
          (isa.Minor == 5 && isa.Stepping == 0));
}

static unsigned getMaxWavesPerEU(const llvm::AMDGPU::IsaVersion &isa) {
  if (hasCombinedVGPRFamilyPressure(isa))
    return 8;
  if (isa.Major < 10)
    return 10;
  return isa.Major == 10 && isa.Minor < 3 ? 20 : 16;
}

static unsigned getCombinedVGPRFamilyBudget(unsigned targetWaves) {
  return llvm::alignDown(512 / targetWaves, 8);
}

static FailureOr<std::optional<unsigned>>
getTargetWaves(func::FuncOp func, unsigned maxWavesPerEU) {
  Attribute attr = findAncestorAttr(func, kTargetWavesAttr);
  if (!attr)
    return std::optional<unsigned>();
  auto intAttr = dyn_cast<IntegerAttr>(attr);
  if (!intAttr)
    return func.emitError("regalloc transform ")
           << kTargetWavesAttr << " must be an integer attribute";
  int64_t value = intAttr.getInt();
  if (value <= 0)
    return func.emitError("regalloc transform ")
           << kTargetWavesAttr << " must be positive";
  if (static_cast<uint64_t>(value) > maxWavesPerEU)
    return func.emitError("regalloc transform ")
           << kTargetWavesAttr << " exceeds target wave capacity";
  return std::optional<unsigned>(static_cast<unsigned>(value));
}

RegAllocTransformBudget
getRegAllocTransformBudget(func::FuncOp func,
                           waveamdmachine::RegClass regClass) {
  StringRef attrName = getRegClassBudgetAttr(regClass);
  if (std::optional<unsigned> limit =
          getUnsignedIntegerAttr(func.getOperation(), attrName))
    return {*limit, "func_attr"};
  Operation *parent = func->getParentOp();
  if (std::optional<unsigned> limit = getUnsignedIntegerAttr(parent, attrName))
    return {*limit, "module_attr"};
  return {getRegAllocTransformDefaultBudgetLimit(regClass), "default"};
}

FailureOr<std::optional<RegAllocTransformBudget>>
getRegAllocTransformVGPRFamilyBudget(func::FuncOp func) {
  if (!findAncestorAttr(func, kTargetWavesAttr))
    return std::optional<RegAllocTransformBudget>();
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      waveamdmachine::getAMDGPUTargetIsaVersion(
          func, "regalloc transform target_waves budget");
  if (failed(isa))
    return failure();
  FailureOr<std::optional<unsigned>> targetWaves =
      getTargetWaves(func, getMaxWavesPerEU(*isa));
  if (failed(targetWaves))
    return failure();
  if (!*targetWaves || !hasCombinedVGPRFamilyPressure(*isa))
    return std::optional<RegAllocTransformBudget>();
  unsigned limit = getCombinedVGPRFamilyBudget(**targetWaves);
  if (limit == 0)
    return func.emitError("regalloc transform ")
           << kTargetWavesAttr << " has no VGPR-family budget for this target";
  return std::optional<RegAllocTransformBudget>(
      RegAllocTransformBudget{limit, "target_waves_combined_vgpr_agpr"});
}

void clearRegAllocTransformState(Operation *target) {
  if (auto func = dyn_cast<func::FuncOp>(target)) {
    func->removeAttr(kRegAllocTransformStateAttr);
    return;
  }
  target->walk(
      [](func::FuncOp func) { func->removeAttr(kRegAllocTransformStateAttr); });
}

static FailureOr<RegAllocTransformLoopDecision>
getFuncRegAllocTransformLoopDecision(func::FuncOp func) {
  if (func.isDeclaration())
    return RegAllocTransformLoopDecision::Done;
  DictionaryAttr state =
      func->getAttrOfType<DictionaryAttr>(kRegAllocTransformStateAttr);
  if (!state)
    return RegAllocTransformLoopDecision::Restart;
  auto stage = state.getAs<StringAttr>("stage");
  if (!stage)
    return func.emitError("regalloc transform state missing `stage`");
  if (stage.getValue() == kRegAllocStageSuccess)
    return RegAllocTransformLoopDecision::Done;
  if (stage.getValue() == kRegAllocStageFailure)
    return RegAllocTransformLoopDecision::Stalled;
  return func.emitError("regalloc transform loop body left unexpected stage `")
         << stage.getValue() << "`";
}

static void
combineRegAllocTransformLoopDecision(RegAllocTransformLoopDecision next,
                                     RegAllocTransformLoopDecision &combined) {
  if (next == RegAllocTransformLoopDecision::Restart ||
      combined == RegAllocTransformLoopDecision::Restart) {
    combined = RegAllocTransformLoopDecision::Restart;
    return;
  }
  if (next == RegAllocTransformLoopDecision::Stalled ||
      combined == RegAllocTransformLoopDecision::Stalled) {
    combined = RegAllocTransformLoopDecision::Stalled;
    return;
  }
  combined = RegAllocTransformLoopDecision::Done;
}

FailureOr<RegAllocTransformLoopDecision>
getRegAllocTransformLoopDecision(Operation *target) {
  RegAllocTransformLoopDecision combined = RegAllocTransformLoopDecision::Done;
  if (auto func = dyn_cast<func::FuncOp>(target))
    return getFuncRegAllocTransformLoopDecision(func);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    FailureOr<RegAllocTransformLoopDecision> decision =
        getFuncRegAllocTransformLoopDecision(func);
    if (failed(decision))
      return WalkResult::interrupt();
    combineRegAllocTransformLoopDecision(*decision, combined);
    return WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return failure();
  return combined;
}

static DictionaryAttr rewriteRegAllocTransformStateAttr(Builder &builder,
                                                        DictionaryAttr state,
                                                        NamedAttribute update) {
  SmallVector<NamedAttribute> attrs;
  for (NamedAttribute attr : state) {
    if (attr.getName() == update.getName())
      continue;
    attrs.push_back(attr);
  }
  attrs.push_back(update);
  return builder.getDictionaryAttr(attrs);
}

static LogicalResult setFuncRegAllocTransformLoopIteration(func::FuncOp func,
                                                           Builder &builder,
                                                           int64_t iteration) {
  DictionaryAttr state =
      func->getAttrOfType<DictionaryAttr>(kRegAllocTransformStateAttr);
  if (!state)
    return success();
  func->setAttr(kRegAllocTransformStateAttr,
                rewriteRegAllocTransformStateAttr(
                    builder, state,
                    builder.getNamedAttr(
                        "iteration", builder.getI64IntegerAttr(iteration))));
  return success();
}

LogicalResult setRegAllocTransformLoopIteration(Operation *target,
                                                Builder &builder,
                                                int64_t iteration) {
  if (auto func = dyn_cast<func::FuncOp>(target))
    return setFuncRegAllocTransformLoopIteration(func, builder, iteration);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(
               setFuncRegAllocTransformLoopIteration(func, builder, iteration))
               ? WalkResult::interrupt()
               : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}

static ArrayRef<StringRef> getRegAllocMetadataNames() {
  static const std::array<StringRef, 5> names = {
      kRegAllocMetadataIterations, kRegAllocMetadataAGPR,
      kRegAllocMetadataRemat, kRegAllocMetadataLDS, kRegAllocMetadataScratch};
  return names;
}

static StringRef getRegAllocProviderMetadataName(StringRef provider) {
  if (provider == "agpr")
    return kRegAllocMetadataAGPR;
  if (provider == "remat")
    return kRegAllocMetadataRemat;
  if (provider == "lds")
    return kRegAllocMetadataLDS;
  if (provider == "scratch")
    return kRegAllocMetadataScratch;
  return {};
}

static FailureOr<std::optional<Attribute>>
getKernelMetadataEntry(Operation *op, StringRef name) {
  FailureOr<SmallVector<waveamdmachine::KernelMetadataEntry>> entries =
      waveamdmachine::getKernelMetadataEntries(op);
  if (failed(entries))
    return failure();
  for (const waveamdmachine::KernelMetadataEntry &entry : *entries)
    if (entry.name.getValue() == name)
      return std::optional<Attribute>(entry.value);
  return std::optional<Attribute>();
}

static FailureOr<int64_t> getRegAllocMetadataCounter(func::FuncOp func,
                                                     StringRef name) {
  FailureOr<std::optional<Attribute>> attr = getKernelMetadataEntry(func, name);
  if (failed(attr))
    return failure();
  if (!*attr)
    return 0;
  auto intAttr = dyn_cast<IntegerAttr>(**attr);
  if (!intAttr)
    return func.emitError("regalloc metadata entry `")
           << name << "` must be an integer";
  int64_t value = intAttr.getInt();
  if (value < 0)
    return func.emitError("regalloc metadata entry `")
           << name << "` must be non-negative";
  return value;
}

static LogicalResult clearFuncRegAllocMetadata(func::FuncOp func,
                                               Builder &builder) {
  if (func.isDeclaration())
    return success();
  return waveamdmachine::removeKernelMetadataEntries(
      func, builder, getRegAllocMetadataNames());
}

LogicalResult clearRegAllocTransformMetadata(Operation *target,
                                             Builder &builder) {
  if (auto func = dyn_cast<func::FuncOp>(target))
    return clearFuncRegAllocMetadata(func, builder);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(clearFuncRegAllocMetadata(func, builder))
               ? WalkResult::interrupt()
               : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}

static LogicalResult setRegAllocMetadataCounter(func::FuncOp func,
                                                Builder &builder,
                                                StringRef name, int64_t value) {
  return waveamdmachine::setKernelMetadataEntry(
      func, builder, name, builder.getI64IntegerAttr(value));
}

struct RegAllocMetadataCounter {
  StringRef name;
  int64_t value = 0;
};

static LogicalResult
setRegAllocMetadataCounters(func::FuncOp func, Builder &builder,
                            ArrayRef<RegAllocMetadataCounter> counters) {
  for (RegAllocMetadataCounter counter : counters)
    if (failed(setRegAllocMetadataCounter(func, builder, counter.name,
                                          counter.value)))
      return failure();
  return success();
}

LogicalResult addRegAllocTransformProviderMetadata(func::FuncOp func,
                                                   Builder &builder,
                                                   StringRef provider,
                                                   int64_t dwords) {
  StringRef name = getRegAllocProviderMetadataName(provider);
  if (name.empty())
    return func.emitError("unknown regalloc metadata provider `")
           << provider << "`";
  FailureOr<int64_t> current = getRegAllocMetadataCounter(func, name);
  if (failed(current))
    return failure();
  return setRegAllocMetadataCounter(func, builder, name, *current + dwords);
}

static LogicalResult finalizeFuncRegAllocMetadata(func::FuncOp func,
                                                  Builder &builder,
                                                  int64_t iterations) {
  if (func.isDeclaration())
    return success();
  FailureOr<int64_t> agpr =
      getRegAllocMetadataCounter(func, kRegAllocMetadataAGPR);
  FailureOr<int64_t> remat =
      getRegAllocMetadataCounter(func, kRegAllocMetadataRemat);
  FailureOr<int64_t> lds =
      getRegAllocMetadataCounter(func, kRegAllocMetadataLDS);
  FailureOr<int64_t> scratch =
      getRegAllocMetadataCounter(func, kRegAllocMetadataScratch);
  if (failed(agpr) || failed(remat) || failed(lds) || failed(scratch))
    return failure();
  if (failed(clearFuncRegAllocMetadata(func, builder)))
    return failure();
  std::array<RegAllocMetadataCounter, 5> counters = {{
      {kRegAllocMetadataIterations, iterations},
      {kRegAllocMetadataAGPR, *agpr},
      {kRegAllocMetadataRemat, *remat},
      {kRegAllocMetadataLDS, *lds},
      {kRegAllocMetadataScratch, *scratch},
  }};
  return setRegAllocMetadataCounters(func, builder, counters);
}

LogicalResult finalizeRegAllocTransformMetadata(Operation *target,
                                                Builder &builder,
                                                int64_t iterations) {
  if (auto func = dyn_cast<func::FuncOp>(target))
    return finalizeFuncRegAllocMetadata(func, builder, iterations);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(finalizeFuncRegAllocMetadata(func, builder, iterations))
               ? WalkResult::interrupt()
               : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}

} // namespace mlir::wave
