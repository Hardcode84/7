//===- WaveAMDMFMAPackedPeephole.cpp - unpack MFMA fillers -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDMachineScheduleEligibility.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/Builders.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallVector.h"

#include <algorithm>
#include <array>
#include <cstdint>
#include <optional>
#include <utility>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMFMAPACKEDPEEPHOLE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::waveamdmachine;

namespace {

enum class PackedF32Kind : uint8_t {
  Add,
  Mul,
  Fma,
};

struct PackedF32Info {
  SmallVector<Value, 3> operands;
  PackedF32Kind kind = PackedF32Kind::Add;
  uint64_t opSel = 0;
  uint64_t opSelHi = 0;
  uint64_t negLo = 0;
  uint64_t negHi = 0;
  bool clamp = false;
};

struct ComputeSlotState {
  std::array<int64_t, static_cast<size_t>(FunctionalUnit::NumFunctionalUnits)>
      readyAt{};
  Operation *activeMfma = nullptr;
  int64_t currentSlot = 0;
  int64_t mfmaReadyAt = 0;
};

static bool tracksComputeResource(FunctionalUnit fu) {
  switch (fu) {
  case FunctionalUnit::VALU:
  case FunctionalUnit::SALU:
  case FunctionalUnit::MFMA_XDL:
  case FunctionalUnit::TRANS:
    return true;
  default:
    return false;
  }
}

static std::optional<PackedF32Info> getPackedF32Info(Operation *op) {
  PackedF32Info info;
  if (VPkAddF32Op add = dyn_cast<VPkAddF32Op>(op)) {
    info.operands.assign({add.getLhs(), add.getRhs()});
    info.kind = PackedF32Kind::Add;
    info.opSel = add.getOpSel();
    info.opSelHi = add.getOpSelHi();
    info.negLo = add.getNegLo();
    info.negHi = add.getNegHi();
    info.clamp = add.getClamp();
    return info;
  }
  if (VPkMulF32Op mul = dyn_cast<VPkMulF32Op>(op)) {
    info.operands.assign({mul.getLhs(), mul.getRhs()});
    info.kind = PackedF32Kind::Mul;
    info.opSel = mul.getOpSel();
    info.opSelHi = mul.getOpSelHi();
    info.negLo = mul.getNegLo();
    info.negHi = mul.getNegHi();
    info.clamp = mul.getClamp();
    return info;
  }
  if (VPkFmaF32Op fma = dyn_cast<VPkFmaF32Op>(op)) {
    info.operands.assign({fma.getA(), fma.getB(), fma.getC()});
    info.kind = PackedF32Kind::Fma;
    info.opSel = fma.getOpSel();
    info.opSelHi = fma.getOpSelHi();
    info.negLo = fma.getNegLo();
    info.negHi = fma.getNegHi();
    info.clamp = fma.getClamp();
    return info;
  }
  return std::nullopt;
}

static RegType getElementType(RegType tupleType, unsigned offset) {
  int64_t index = tupleType.getIndex() < 0 ? -1 : tupleType.getIndex() + offset;
  return RegType::get(tupleType.getContext(), tupleType.getRegClass(),
                      /*width=*/1, index);
}

static bool isExactElementPair(TupleFromElementsOp tuple) {
  RegType tupleType = cast<RegType>(tuple.getTuple().getType());
  return tuple.getElements().size() == 2 &&
         tuple.getElements()[0].getType() == getElementType(tupleType, 0) &&
         tuple.getElements()[1].getType() == getElementType(tupleType, 1);
}

static std::pair<Value, unsigned> getSelectedSourceKey(Value tuple,
                                                       unsigned element) {
  TupleFromElementsOp joined = tuple.getDefiningOp<TupleFromElementsOp>();
  if (joined && isExactElementPair(joined))
    return {joined.getElements()[element], 0};
  return {tuple, element};
}

static RegType getSelectedSourceType(Value tuple, unsigned element) {
  auto [source, offset] = getSelectedSourceKey(tuple, element);
  return getElementType(cast<RegType>(source.getType()), offset);
}

static unsigned getExpansionIssueCount(const PackedF32Info &info) {
  DenseSet<std::pair<Value, unsigned>> negated;
  for (auto [index, operand] : llvm::enumerate(info.operands)) {
    if (info.negLo & (uint64_t{1} << index))
      negated.insert(getSelectedSourceKey(operand, (info.opSel >> index) & 1));
    if (info.negHi & (uint64_t{1} << index))
      negated.insert(
          getSelectedSourceKey(operand, (info.opSelHi >> index) & 1));
  }
  return 2 + negated.size();
}

static bool hasFixedResultClobber(Operation *op, const PackedF32Info &info) {
  RegType resultType = cast<RegType>(op->getResult(0).getType());
  if (resultType.getIndex() < 0)
    return false;
  for (auto [index, operand] : llvm::enumerate(info.operands)) {
    unsigned sourceElement = (info.opSelHi >> index) & 1;
    RegType sourceType = getSelectedSourceType(operand, sourceElement);
    if (sourceType.getIndex() >= 0 &&
        sourceType.getRegClass() == resultType.getRegClass() &&
        sourceType.getIndex() == resultType.getIndex())
      return true;
  }
  return false;
}

static bool fixedRegistersOverlap(Value lhs, Value rhs) {
  RegType lhsType = dyn_cast<RegType>(lhs.getType());
  RegType rhsType = dyn_cast<RegType>(rhs.getType());
  if (!lhsType || !rhsType || lhsType.getIndex() < 0 ||
      rhsType.getIndex() < 0 || lhsType.getRegClass() != rhsType.getRegClass())
    return false;
  return lhsType.getIndex() < rhsType.getIndex() + rhsType.getWidth() &&
         rhsType.getIndex() < lhsType.getIndex() + lhsType.getWidth();
}

static bool hasFixedRegisterDependency(Operation *op, Operation *producer) {
  for (Value produced : producer->getResults()) {
    for (Value operand : op->getOperands())
      if (fixedRegistersOverlap(produced, operand))
        return true;
    for (Value result : op->getResults())
      if (fixedRegistersOverlap(produced, result))
        return true;
  }
  return false;
}

static bool dependsOn(Operation *op, Operation *producer) {
  DenseSet<Value> seen;
  SmallVector<Value, 16> worklist(op->getOperands());
  while (!worklist.empty()) {
    Value value = worklist.pop_back_val();
    if (!seen.insert(value).second)
      continue;
    Operation *def = value.getDefiningOp();
    if (def == producer)
      return true;
    if (def)
      llvm::append_range(worklist, def->getOperands());
  }
  return false;
}

static void resetComputeSlots(ComputeSlotState &state) {
  state.readyAt.fill(state.currentSlot);
  state.mfmaReadyAt = state.currentSlot;
  state.activeMfma = nullptr;
}

static int64_t getResourceReadySlot(Operation *op, const ArchData &arch,
                                    const ComputeSlotState &state) {
  SchedClass cls = classifyOp(op);
  FunctionalUnit fu = funit(arch, cls);
  if (!tracksComputeResource(fu))
    return state.currentSlot;
  return std::max(state.currentSlot, state.readyAt[static_cast<size_t>(fu)]);
}

static void commitOperation(Operation *op, const ArchData &arch,
                            unsigned wavefrontSize, ComputeSlotState &state) {
  SchedClass cls = classifyOp(op);
  if (cls == SchedClass::NoInst)
    return;

  unsigned issues = getInstructionIssueCount(op, arch.isa, wavefrontSize);
  FunctionalUnit fu = funit(arch, cls);
  if (!tracksComputeResource(fu)) {
    state.currentSlot += issues;
    resetComputeSlots(state);
    return;
  }

  int64_t issueSlot = getResourceReadySlot(op, arch, state);
  if (usesMfmaCoissueResource(op, cls, arch))
    issueSlot = std::max(issueSlot, state.mfmaReadyAt);
  unsigned releaseSlots =
      std::max<unsigned>(issues, std::max(1, getResourceCycles(arch, cls)));
  state.readyAt[static_cast<size_t>(fu)] = issueSlot + releaseSlots;
  if (usesMfmaCoissueResource(op, cls, arch)) {
    state.mfmaReadyAt = issueSlot + releaseSlots;
    state.activeMfma =
        op->hasTrait<OpTrait::waveamdmachine::MFMAOp>() ? op : nullptr;
  }
  state.currentSlot = issueSlot + issues;
  if (state.currentSlot >= state.mfmaReadyAt)
    state.activeMfma = nullptr;
}

static bool trySelectPackedCandidate(Operation *op, const PackedF32Info &info,
                                     const ArchData &arch,
                                     ComputeSlotState &state) {
  if (!state.activeMfma || info.clamp)
    return false;
  if (hasFixedResultClobber(op, info))
    return false;
  if (dependsOn(op, state.activeMfma))
    return false;

  int64_t issueWithoutMfma = getResourceReadySlot(op, arch, state);
  if (issueWithoutMfma >= state.mfmaReadyAt)
    return false;

  int64_t expansionBegin =
      std::max(state.currentSlot,
               state.readyAt[static_cast<size_t>(FunctionalUnit::VALU)]);
  int64_t expansionEnd = expansionBegin + getExpansionIssueCount(info);
  if (expansionEnd > state.mfmaReadyAt)
    return false;

  state.readyAt[static_cast<size_t>(FunctionalUnit::VALU)] = expansionEnd;
  state.currentSlot = expansionEnd;
  if (state.currentSlot >= state.mfmaReadyAt)
    state.activeMfma = nullptr;
  return true;
}

static void collectBlockCandidates(Block &block, const ArchData &arch,
                                   unsigned wavefrontSize,
                                   llvm::SetVector<Operation *> &candidates) {
  ComputeSlotState state;
  for (Operation &op : block) {
    if (wave::isSchedulerRegionBoundary(&op) ||
        !wave::isSupportedSchedulerRegionMember(&op)) {
      resetComputeSlots(state);
      continue;
    }

    SchedClass cls = classifyOp(&op);
    if (cls == SchedClass::NoInst)
      continue;
    if (state.activeMfma &&
        (dependsOn(&op, state.activeMfma) ||
         hasFixedRegisterDependency(&op, state.activeMfma))) {
      state.currentSlot = std::max(state.currentSlot, state.mfmaReadyAt);
      state.activeMfma = nullptr;
    }

    std::optional<PackedF32Info> packed = getPackedF32Info(&op);
    if (packed && trySelectPackedCandidate(&op, *packed, arch, state)) {
      candidates.insert(&op);
      continue;
    }
    commitOperation(&op, arch, wavefrontSize, state);
  }
}

static std::array<Value, 2>
getTupleElements(Value tuple, Operation *insertBefore, OpBuilder &builder,
                 DenseMap<Value, std::array<Value, 2>> &elementCache,
                 llvm::SetVector<Operation *> &maybeDeadTuples) {
  DenseMap<Value, std::array<Value, 2>>::iterator cached =
      elementCache.find(tuple);
  if (cached != elementCache.end())
    return cached->second;

  std::array<Value, 2> elements;
  TupleFromElementsOp joined = tuple.getDefiningOp<TupleFromElementsOp>();
  if (joined && isExactElementPair(joined)) {
    elements = {joined.getElements()[0], joined.getElements()[1]};
    maybeDeadTuples.insert(joined);
  } else {
    RegType tupleType = cast<RegType>(tuple.getType());
    std::array<Type, 2> elementTypes = {getElementType(tupleType, 0),
                                        getElementType(tupleType, 1)};
    TupleToElementsOp split = TupleToElementsOp::create(
        builder, insertBefore->getLoc(), elementTypes, tuple);
    elements = {split.getElements()[0], split.getElements()[1]};
  }
  elementCache.try_emplace(tuple, elements);
  return elements;
}

static Value getNegated(Value value, Operation *insertBefore,
                        OpBuilder &builder, DenseMap<Value, Value> &negated,
                        Value &signMask) {
  if (Value cached = negated.lookup(value))
    return cached;
  if (!signMask)
    signMask =
        ImmOp::create(builder, insertBefore->getLoc(),
                      ImmType::get(builder.getContext()), uint64_t{1} << 31)
            .getResult();
  RegType sourceType = cast<RegType>(value.getType());
  Type resultType = RegType::get(value.getContext(), sourceType.getRegClass(),
                                 sourceType.getWidth(), /*index=*/-1);
  Value result = VXorB32Op::create(builder, insertBefore->getLoc(), resultType,
                                   value, signMask)
                     .getResult();
  negated.try_emplace(value, result);
  return result;
}

static Value createScalarPackedLane(const PackedF32Info &info, unsigned lane,
                                    Operation *insertBefore, OpBuilder &builder,
                                    ArrayRef<std::array<Value, 2>> elements,
                                    DenseMap<Value, Value> &negated,
                                    Value &signMask) {
  uint64_t selectors = lane == 0 ? info.opSel : info.opSelHi;
  uint64_t negations = lane == 0 ? info.negLo : info.negHi;
  SmallVector<Value, 3> operands;
  for (auto [index, pair] : llvm::enumerate(elements)) {
    Value value = pair[(selectors >> index) & 1];
    if (negations & (uint64_t{1} << index))
      value = getNegated(value, insertBefore, builder, negated, signMask);
    operands.push_back(value);
  }

  Location loc = insertBefore->getLoc();
  Type resultType =
      getElementType(cast<RegType>(insertBefore->getResult(0).getType()), lane);
  switch (info.kind) {
  case PackedF32Kind::Add:
    return VAddF32Op::create(builder, loc, resultType, operands[0], operands[1])
        .getResult();
  case PackedF32Kind::Mul:
    return VMulF32Op::create(builder, loc, resultType, operands[0], operands[1])
        .getResult();
  case PackedF32Kind::Fma:
    return VFmaF32Op::create(builder, loc, resultType, operands[0], operands[1],
                             operands[2])
        .getResult();
  }
  llvm_unreachable("bad packed f32 kind");
}

static bool isExactResultSplit(TupleToElementsOp split,
                               ArrayRef<Value> scalarResults) {
  return split.getElements().size() == scalarResults.size() &&
         llvm::equal(split.getResultTypes(),
                     llvm::map_range(scalarResults, [](Value value) {
                       return value.getType();
                     }));
}

static void replacePackedResult(Operation *op, ArrayRef<Value> scalarResults,
                                OpBuilder &builder) {
  Value packedResult = op->getResult(0);
  SmallVector<TupleToElementsOp, 2> exactSplits;
  for (Operation *user : packedResult.getUsers())
    if (TupleToElementsOp split = dyn_cast<TupleToElementsOp>(user);
        split && isExactResultSplit(split, scalarResults))
      exactSplits.push_back(split);

  for (TupleToElementsOp split : exactSplits) {
    for (auto [result, replacement] :
         llvm::zip_equal(split.getElements(), scalarResults))
      result.replaceAllUsesWith(replacement);
    split.erase();
  }

  if (packedResult.use_empty())
    return;
  Value joined =
      TupleFromElementsOp::create(builder, op->getLoc(), packedResult.getType(),
                                  scalarResults)
          .getTuple();
  packedResult.replaceAllUsesWith(joined);
}

static void unpackPackedF32(Operation *op) {
  std::optional<PackedF32Info> info = getPackedF32Info(op);
  assert(info && "expected packed f32 operation");

  OpBuilder builder(op);
  DenseMap<Value, std::array<Value, 2>> elementCache;
  llvm::SetVector<Operation *> maybeDeadTuples;
  SmallVector<std::array<Value, 2>, 3> elements;
  for (Value operand : info->operands)
    elements.push_back(
        getTupleElements(operand, op, builder, elementCache, maybeDeadTuples));

  DenseMap<Value, Value> negated;
  Value signMask;
  std::array<Value, 2> scalarResults = {
      createScalarPackedLane(*info, 0, op, builder, elements, negated,
                             signMask),
      createScalarPackedLane(*info, 1, op, builder, elements, negated,
                             signMask)};
  replacePackedResult(op, scalarResults, builder);
  op->erase();

  for (Operation *tuple : llvm::reverse(maybeDeadTuples))
    if (tuple->use_empty())
      tuple->erase();
}

struct WaveAMDMFMAPackedPeepholePass
    : public wave::impl::WaveAMDMFMAPackedPeepholeBase<
          WaveAMDMFMAPackedPeepholePass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    FailureOr<llvm::AMDGPU::IsaVersion> isa =
        getAMDGPUTargetIsaVersion(root, "waveamd-mfma-packed-peephole");
    if (failed(isa))
      return signalPassFailure();

    const ArchData &arch = getArchData(*isa);
    if (!arch.hasMfmaCoissueRestriction)
      return;
    FailureOr<unsigned> wavefrontSize =
        getAMDGPUWavefrontSize(root, "waveamd-mfma-packed-peephole");
    if (failed(wavefrontSize))
      return signalPassFailure();

    llvm::SetVector<Operation *> candidates;
    root->walk([&](Block *block) {
      collectBlockCandidates(*block, arch, *wavefrontSize, candidates);
    });

    for (Operation *candidate : candidates)
      unpackPackedF32(candidate);
  }
};

} // namespace
