//===- WaveAMDRegAllocPrep.cpp - WaveAMD regalloc preparation ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocPrep.h"

#include "../WaveAMDHardwareResources.h"
#include "WaveAMDRegAllocInternal.h"
#include "WaveAMDRegAllocRegionFlow.h"
#include "WaveAMDRegAllocStorage.h"
#include "WaveAMDRegAllocTransformUtils.h"
#include "WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/MathExtras.h"
#include <optional>

using namespace mlir;

namespace {

enum class DuplicateRematPolicy { Never, AnyLegal, CopyCostBounded };

static bool isReg(Value value) {
  return isa<waveamdmachine::RegType>(value.getType());
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

static bool requiresMCTupleEncoding(Value value) {
  return llvm::any_of(value.getUses(), [](OpOperand &use) {
    return waveamdmachine::requiresMCTupleEncoding(use);
  });
}

static unsigned getFallbackTupleAlignment(waveamdmachine::RegType type) {
  unsigned width = type.getWidth();
  if (width <= 1)
    return 1;
  return std::max<unsigned>(1, llvm::PowerOf2Ceil(width));
}

static unsigned
getAddressableRegisterCount(const wave::WaveAMDRegisterLimits &limits,
                            waveamdmachine::RegType type) {
  if (isSGPR(type))
    return limits.addressableSGPRs;
  if (isVGPR(type))
    return limits.addressableVGPRs;
  if (isAGPR(type))
    return limits.addressableAGPRs;
  return 0;
}

static bool isTupleBaseLegal(const wave::WaveAMDRegisterLimits &limits,
                             waveamdmachine::RegType type, unsigned base,
                             bool exactSGPRBase) {
  if (isSGPR(type))
    return exactSGPRBase ? limits.isSGPRTupleBaseLegal(type.getWidth(), base)
                         : base % getFallbackTupleAlignment(type) == 0;
  return wave::isWaveAMDRegisterTupleBaseLegal(limits, type.getRegClass(),
                                               type.getWidth(), base);
}

static bool hasTargetCompatibleTupleBases(
    waveamdmachine::RegType outerType, waveamdmachine::RegType innerType,
    unsigned innerOffset, const wave::WaveAMDRegisterLimits &targetLimits,
    bool exactOuterSGPRBase, bool exactInnerSGPRBase) {
  unsigned limit = getAddressableRegisterCount(targetLimits, outerType);
  unsigned outerWidth = outerType.getWidth();
  unsigned innerWidth = innerType.getWidth();
  if (outerWidth > limit || innerOffset > outerWidth ||
      innerWidth > outerWidth - innerOffset)
    return false;
  for (unsigned outerBase = 0; outerBase <= limit - outerWidth; ++outerBase) {
    if (!isTupleBaseLegal(targetLimits, outerType, outerBase,
                          exactOuterSGPRBase))
      continue;
    if (isTupleBaseLegal(targetLimits, innerType, outerBase + innerOffset,
                         exactInnerSGPRBase))
      return true;
  }
  return false;
}

static bool
hasCompatibleTupleBases(waveamdmachine::RegType outerType,
                        waveamdmachine::RegType innerType, unsigned innerOffset,
                        const wave::WaveAMDRegisterLimits *targetLimits,
                        bool exactOuterSGPRBase, bool exactInnerSGPRBase) {
  if (outerType.getRegClass() != innerType.getRegClass())
    return false;
  if (!targetLimits ||
      (isSGPR(innerType) && !exactOuterSGPRBase && !exactInnerSGPRBase))
    return innerOffset % getFallbackTupleAlignment(innerType) == 0;
  return hasTargetCompatibleTupleBases(outerType, innerType, innerOffset,
                                       *targetLimits, exactOuterSGPRBase,
                                       exactInnerSGPRBase);
}

static std::optional<waveamdmachine::RegType> trackedRegType(Value v) {
  if (!isReg(v))
    return std::nullopt;
  auto rt = cast<waveamdmachine::RegType>(v.getType());
  if (wave::getHardwareResourceForValue(v))
    return std::nullopt;
  return rt;
}

static std::optional<waveamdmachine::RegType> copyableRegType(Value v) {
  std::optional<waveamdmachine::RegType> rt = trackedRegType(v);
  if (!rt || isAGPR(*rt))
    return std::nullopt;
  return rt;
}

static waveamdmachine::RegType
getUnassignedRegType(waveamdmachine::RegType type) {
  return waveamdmachine::RegType::get(type.getContext(), type.getRegClass(),
                                      type.getWidth(), /*index=*/-1);
}

static bool allResultsDead(Operation *op) {
  return llvm::all_of(op->getResults(),
                      [](Value result) { return result.use_empty(); });
}

static void eraseRegAfterOps(func::FuncOp func) {
  SmallVector<waveamdmachine::RegAfterOp> ops;
  func.walk([&](waveamdmachine::RegAfterOp op) { ops.push_back(op); });
  for (waveamdmachine::RegAfterOp op : ops) {
    op.getResult().replaceAllUsesWith(op.getSource());
    op.erase();
  }
}

static bool isDeadCheapRegOp(Operation *op) {
  return op && op->getNumResults() != 0 && allResultsDead(op) &&
         wave::regalloc::isCheapVGPRPressureReliefExpr(op);
}

static void eraseDeadCheapRegOps(ArrayRef<Operation *> roots) {
  SmallVector<Operation *> worklist(roots);
  DenseSet<Operation *> erased;
  while (!worklist.empty()) {
    Operation *op = worklist.pop_back_val();
    if (!op || erased.contains(op) || !isDeadCheapRegOp(op))
      continue;
    SmallVector<Value> operands(op->getOperands());
    erased.insert(op);
    op->erase();
    for (Value operand : operands)
      if (Operation *def = operand.getDefiningOp())
        worklist.push_back(def);
  }
}

static bool canRematerializeDuplicateRegValue(Value v,
                                              DenseSet<Value> &visiting);

static bool canUseOriginalDuplicateOperand(Value operand) {
  if (!isReg(operand))
    return true;
  std::optional<waveamdmachine::RegType> rt = trackedRegType(operand);
  if (!rt)
    return true;
  return isSGPR(*rt);
}

static bool canRematerializeDuplicateOperand(Value operand,
                                             DenseSet<Value> &visiting) {
  if (canUseOriginalDuplicateOperand(operand))
    return true;
  std::optional<waveamdmachine::RegType> rt = trackedRegType(operand);
  if (!rt || !isVGPR(*rt))
    return false;
  return canRematerializeDuplicateRegValue(operand, visiting);
}

static bool canRematerializeDuplicateRegValue(Value v,
                                              DenseSet<Value> &visiting) {
  std::optional<waveamdmachine::RegType> rt = trackedRegType(v);
  if (!rt || !isVGPR(*rt))
    return false;
  Operation *def = v.getDefiningOp();
  if (!def || !wave::regalloc::isCheapVGPRPressureReliefExpr(def))
    return false;
  if (isa<waveamdmachine::VWorkitemIdXOp, waveamdmachine::VWorkitemIdYOp,
          waveamdmachine::VWorkitemIdZOp>(def))
    return false;
  wave::HardwareResourceEffects effects = wave::getHardwareResourceEffects(def);
  if (!effects.reads.empty() || !effects.writes.empty())
    return false;
  if (!visiting.insert(v).second)
    return false;
  bool canRemat = llvm::all_of(def->getOperands(), [&](Value operand) {
    return canRematerializeDuplicateOperand(operand, visiting);
  });
  visiting.erase(v);
  return canRemat;
}

static bool consumeDuplicateRematerializationOpCost(Operation *op,
                                                    unsigned &budget) {
  if (op->hasTrait<OpTrait::waveamdmachine::NoMachineInst>())
    return true;
  bool charged = false;
  for (Value result : op->getResults()) {
    waveamdmachine::RegType type =
        dyn_cast<waveamdmachine::RegType>(result.getType());
    if (!type)
      continue;
    charged = true;
    if (static_cast<unsigned>(type.getWidth()) > budget)
      return false;
    budget -= static_cast<unsigned>(type.getWidth());
  }
  if (charged)
    return true;
  if (budget == 0)
    return false;
  --budget;
  return true;
}

static bool duplicateRematerializationFitsCost(Value v, unsigned &budget,
                                               DenseSet<Operation *> &counted) {
  Operation *def = v.getDefiningOp();
  assert(def && "rematerialization legality requires an op result");
  if (!counted.insert(def).second)
    return true;
  if (!consumeDuplicateRematerializationOpCost(def, budget))
    return false;
  for (Value operand : def->getOperands()) {
    if (canUseOriginalDuplicateOperand(operand))
      continue;
    if (!duplicateRematerializationFitsCost(operand, budget, counted))
      return false;
  }
  return true;
}

static bool canProfitablyRematerializeDuplicateRegValue(Value v) {
  DenseSet<Value> visiting;
  if (!canRematerializeDuplicateRegValue(v, visiting))
    return false;
  unsigned budget = cast<waveamdmachine::RegType>(v.getType()).getWidth();
  DenseSet<Operation *> counted;
  return duplicateRematerializationFitsCost(v, budget, counted);
}

static FailureOr<Value>
rematerializeDuplicateRegValue(OpBuilder &builder, Location loc, Value v,
                               DenseMap<Value, Value> &cache);

static FailureOr<Value>
mapRematerializedOperand(OpBuilder &builder, Location loc, Value operand,
                         DenseMap<Value, Value> &cache) {
  if (canUseOriginalDuplicateOperand(operand))
    return operand;
  DenseSet<Value> visiting;
  if (!canRematerializeDuplicateRegValue(operand, visiting))
    return emitError(loc) << "waveamd regalloc cannot rematerialize operand "
                             "while duplicating register value";
  return rematerializeDuplicateRegValue(builder, loc, operand, cache);
}

static FailureOr<Value>
rematerializeDuplicateRegValue(OpBuilder &builder, Location loc, Value v,
                               DenseMap<Value, Value> &cache) {
  if (Value cached = cache.lookup(v))
    return cached;
  Operation *def = v.getDefiningOp();
  if (!def)
    return emitError(loc) << "waveamd regalloc cannot rematerialize block "
                             "argument while duplicating register value";

  IRMapping mapper;
  for (Value operand : def->getOperands()) {
    FailureOr<Value> replacement =
        mapRematerializedOperand(builder, loc, operand, cache);
    if (failed(replacement))
      return failure();
    mapper.map(operand, *replacement);
  }

  Operation *clone = builder.clone(*def, mapper);
  for (OpResult result : clone->getResults()) {
    auto resultType = dyn_cast<waveamdmachine::RegType>(result.getType());
    if (!resultType)
      continue;
    result.setType(getUnassignedRegType(resultType));
  }

  for (auto [original, cloned] :
       llvm::zip(def->getResults(), clone->getResults()))
    cache[original] = cloned;
  return clone->getResult(cast<OpResult>(v).getResultNumber());
}

static FailureOr<Value> duplicateRegValue(
    OpBuilder &builder, Location loc, Value v,
    DuplicateRematPolicy rematPolicy = DuplicateRematPolicy::Never) {
  auto rt = cast<waveamdmachine::RegType>(v.getType());
  if (rematPolicy != DuplicateRematPolicy::Never && isVGPR(rt)) {
    bool canRematerialize = false;
    if (rematPolicy == DuplicateRematPolicy::AnyLegal) {
      DenseSet<Value> visiting;
      canRematerialize = canRematerializeDuplicateRegValue(v, visiting);
    } else {
      canRematerialize = canProfitablyRematerializeDuplicateRegValue(v);
    }
    if (canRematerialize) {
      DenseMap<Value, Value> cache;
      return rematerializeDuplicateRegValue(builder, loc, v, cache);
    }
  }

  return wave::regalloc_detail::materializeRegAllocCopy(builder, loc, v);
}

static Value createBranchLocalRegAlias(OpBuilder &builder, Location loc,
                                       Value value) {
  return waveamdmachine::UpdateTupleOp::create(builder, loc, value.getType(),
                                               value, ValueRange{},
                                               builder.getArrayAttr({}))
      .getResult();
}

struct RegCopyPlan {
  Value source;
  Location loc;
  OpOperand *target = nullptr;
  Operation *anchor = nullptr;
  Operation *deadDef = nullptr;
  DuplicateRematPolicy rematPolicy = DuplicateRematPolicy::Never;
  bool localAlias = false;
};

static LogicalResult materializeRegCopyPlans(func::FuncOp func,
                                             ArrayRef<RegCopyPlan> plans) {
  OpBuilder builder(func.getContext());
  SmallVector<Operation *> deadDefs;
  for (const RegCopyPlan &plan : plans) {
    assert(plan.target && plan.anchor && "register copy plan is incomplete");
    builder.setInsertionPoint(plan.anchor);
    FailureOr<Value> copy =
        plan.localAlias ? FailureOr<Value>(createBranchLocalRegAlias(
                              builder, plan.loc, plan.source))
                        : duplicateRegValue(builder, plan.loc, plan.source,
                                            plan.rematPolicy);
    if (failed(copy))
      return failure();
    plan.target->set(*copy);
    if (plan.deadDef)
      deadDefs.push_back(plan.deadDef);
  }
  eraseDeadCheapRegOps(deadDefs);
  return success();
}

static Operation *ancestorInBlock(Operation *op, Block *block) {
  while (op && op->getBlock() != block)
    op = op->getParentOp();
  return op;
}

using wave::regalloc_detail::RegAllocRegionFlow;

static bool hasInvariantRegionRead(Value value, Operation *branch,
                                   Region *region) {
  for (OpOperand &use : value.getUses()) {
    Operation *user = use.getOwner();
    if (user != branch &&
        RegAllocRegionFlow::getChildRegion(branch, user) == region &&
        !(user->getParentRegion() == region &&
          user->hasTrait<OpTrait::IsTerminator>()))
      return true;
  }
  return false;
}

static bool hasUseBeforeBranch(Value value, Operation *branch) {
  Block *block = branch->getBlock();
  for (OpOperand &use : value.getUses()) {
    Operation *user = use.getOwner();
    if (user == branch)
      continue;
    Operation *top = ancestorInBlock(user, block);
    if (!top || top == branch)
      continue;
    if (top->isBeforeInBlock(branch))
      return true;
  }
  return false;
}

static bool hasUseAfterBranch(const RegAllocRegionFlow &flow, Value value,
                              Operation *branch) {
  return llvm::any_of(value.getUses(), [&](OpOperand &use) {
    Operation *user = use.getOwner();
    return user != branch &&
           !RegAllocRegionFlow::isOperationInside(branch, user) &&
           flow.useMayFollow(value, branch, user);
  });
}

static bool valueIsLiveAfter(const RegAllocRegionFlow &flow, Value value,
                             Operation *op) {
  return llvm::any_of(value.getUses(), [&](OpOperand &use) {
    return use.getOwner() != op && flow.useMayFollow(value, op, use.getOwner());
  });
}

static bool valueUseRepeatsAfter(const RegAllocRegionFlow &flow, Value value,
                                 Operation *op) {
  for (Operation *parent = op->getParentOp(); parent;
       parent = parent->getParentOp()) {
    Region *child = RegAllocRegionFlow::getChildRegion(parent, op);
    if (child && flow.isRepetitive(child) &&
        !RegAllocRegionFlow::isDefinedInside(parent, value))
      return true;
  }
  return false;
}

static bool valueDiesAt(const RegAllocRegionFlow &flow, Value value,
                        Operation *op) {
  return !valueUseRepeatsAfter(flow, value, op) &&
         !valueIsLiveAfter(flow, value, op);
}

static Operation *
getUpdateTupleCopyAnchor(const RegAllocRegionFlow &flow,
                         waveamdmachine::UpdateTupleOp update) {
  Operation *anchor = update.getOperation();
  Value base = update.getBase();
  for (Operation *nested = update.getOperation(),
                 *parent = nested->getParentOp();
       parent; nested = parent, parent = parent->getParentOp()) {
    Region *child = RegAllocRegionFlow::getChildRegion(parent, nested);
    if (child && flow.isRepetitive(child) &&
        !RegAllocRegionFlow::isDefinedInside(parent, base))
      anchor = parent;
  }
  return anchor;
}

static LogicalResult splitLiveUpdateTupleBases(func::FuncOp func) {
  SmallVector<waveamdmachine::UpdateTupleOp> updates;
  func.walk(
      [&](waveamdmachine::UpdateTupleOp update) { updates.push_back(update); });
  for (waveamdmachine::UpdateTupleOp update : updates) {
    SmallVector<RegCopyPlan> plans;
    RegAllocRegionFlow flow(func);
    if (!valueIsLiveAfter(flow, update.getBase(), update))
      continue;
    plans.push_back({update.getBase(), update.getLoc(),
                     &update->getOpOperand(0),
                     getUpdateTupleCopyAnchor(flow, update)});
    if (failed(materializeRegCopyPlans(func, plans)))
      return failure();
  }
  return success();
}

static bool shouldRematerializeRegionInit(Value init, Operation *branch) {
  DenseSet<Value> visiting;
  if (!canRematerializeDuplicateRegValue(init, visiting))
    return false;
  Operation *def = init.getDefiningOp();
  if (def && def->getBlock() == branch->getBlock() &&
      def->getNextNode() == branch)
    return false;
  return hasUseBeforeBranch(init, branch);
}

static bool needsLocalNestedRepetitiveInit(const RegAllocRegionFlow &flow,
                                           Operation *branch, Value init) {
  if (!trackedRegType(init))
    return false;
  Region *parentRegion = flow.getEnclosingRepetitiveRegion(branch);
  return parentRegion && !RegAllocRegionFlow::isDefinedInside(
                             parentRegion->getParentOp(), init);
}

static bool needsDistinctRegionInit(const RegAllocRegionFlow &flow, Value init,
                                    Operation *branch, Region *target,
                                    bool repeatedInit, bool rematInit) {
  return repeatedInit || needsLocalNestedRepetitiveInit(flow, branch, init) ||
         rematInit || hasInvariantRegionRead(init, branch, target) ||
         hasUseAfterBranch(flow, init, branch);
}

static void collectDuplicateRepetitiveRegionInitPlans(
    const RegAllocRegionFlow &flow, const RegAllocRegionFlow::Branch &branch,
    SmallVectorImpl<RegCopyPlan> &plans) {
  for (Region *target : branch.regions) {
    if (!flow.isRepetitive(target))
      continue;
    DenseSet<Value> seen;
    for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers) {
      if (transfer.source || transfer.target != target)
        continue;
      Value init = transfer.operand->get();
      if (!trackedRegType(init)) {
        seen.insert(init);
        continue;
      }
      bool repeatedInit = !seen.insert(init).second;
      bool rematInit = shouldRematerializeRegionInit(init, branch.op);
      if (!needsDistinctRegionInit(flow, init, branch.op, target, repeatedInit,
                                   rematInit))
        continue;
      Operation *def = init.getDefiningOp();
      DuplicateRematPolicy rematPolicy =
          rematInit ? DuplicateRematPolicy::AnyLegal
                    : DuplicateRematPolicy::CopyCostBounded;
      plans.push_back({init, branch.op->getLoc(), transfer.operand, branch.op,
                       def, rematPolicy});
    }
  }
}

static SmallVector<Operation *>
collectRegionBranchOperations(func::FuncOp func) {
  SmallVector<Operation *> branches;
  func.walk([&](Operation *op) {
    if (isa<RegionBranchOpInterface>(op))
      branches.push_back(op);
  });
  return branches;
}

static LogicalResult splitDuplicateRepetitiveRegionInits(func::FuncOp func) {
  for (Operation *op : collectRegionBranchOperations(func)) {
    SmallVector<RegCopyPlan> plans;
    RegAllocRegionFlow flow(func);
    const RegAllocRegionFlow::Branch *branch = flow.lookup(op);
    if (!branch)
      continue;
    collectDuplicateRepetitiveRegionInitPlans(flow, *branch, plans);
    if (failed(materializeRegCopyPlans(func, plans)))
      return failure();
  }
  return success();
}

static DenseSet<Value> collectRematerializableMFMAAccumulators(
    ArrayRef<waveamdmachine::MMAOpInterface> ops) {
  DenseSet<Value> rematerializeAccumulators;
  for (waveamdmachine::MMAOpInterface op : ops) {
    Value acc = op.getAcc();
    if (!copyableRegType(acc) || llvm::hasSingleElement(acc.getUses()))
      continue;
    if (canProfitablyRematerializeDuplicateRegValue(acc))
      rematerializeAccumulators.insert(acc);
  }
  return rematerializeAccumulators;
}

static LogicalResult splitDuplicateMFMAAccumulatorInputs(func::FuncOp func) {
  SmallVector<waveamdmachine::MMAOpInterface> ops;
  func.walk([&](waveamdmachine::MMAOpInterface op) {
    if (op.getOperation()->hasTrait<OpTrait::waveamdmachine::MFMAOp>())
      ops.push_back(op);
  });

  DenseSet<Value> rematerializeAccumulators =
      collectRematerializableMFMAAccumulators(ops);

  OpBuilder builder(func.getContext());
  for (waveamdmachine::MMAOpInterface op : ops) {
    Value acc = op.getAcc();
    if (!copyableRegType(acc))
      continue;
    bool canRematerialize = rematerializeAccumulators.contains(acc);
    if (llvm::hasSingleElement(acc.getUses()) && !canRematerialize)
      continue;
    Operation *def = acc.getDefiningOp();
    builder.setInsertionPoint(op.getOperation());
    DuplicateRematPolicy rematPolicy =
        canRematerialize ? DuplicateRematPolicy::CopyCostBounded
                         : DuplicateRematPolicy::Never;
    FailureOr<Value> dup =
        duplicateRegValue(builder, op.getLoc(), acc, rematPolicy);
    if (failed(dup))
      return failure();
    op.setAcc(*dup);
    eraseDeadCheapRegOps({def});
  }
  return success();
}

struct KilledOperandReuseIsaCache {
  KilledOperandReuseIsaCache(func::FuncOp func) : func(func) {}

  const llvm::AMDGPU::IsaVersion *get() {
    if (isa)
      return &*isa;
    if (failed)
      return nullptr;
    FailureOr<llvm::AMDGPU::IsaVersion> parsed =
        waveamdmachine::getAMDGPUTargetIsaVersion(
            func, "waveamd regalloc required killed operand reuse");
    if (mlir::failed(parsed)) {
      failed = true;
      return nullptr;
    }
    isa = *parsed;
    return &*isa;
  }

  std::optional<llvm::AMDGPU::IsaVersion> isa;
  func::FuncOp func;
  bool failed = false;
};

static void collectRequiredKilledOperandInputCopies(
    Operation *op, KilledOperandReuseIsaCache &isaCache,
    SmallVectorImpl<std::pair<Operation *, unsigned>> &operands) {
  waveamdmachine::KilledOperandReuseOpInterface reuse =
      wave::regalloc_detail::getKilledOperandReuseCandidate(op);
  if (!reuse)
    return;
  const llvm::AMDGPU::IsaVersion *targetIsa = isaCache.get();
  if (!targetIsa)
    return;
  for (OpOperand &operand : op->getOpOperands()) {
    if (!wave::regalloc_detail::requiresKilledOperandReuseForResult(
            reuse, operand, *targetIsa))
      continue;
    if (llvm::hasSingleElement(operand.get().getUses()))
      continue;
    operands.push_back({op, operand.getOperandNumber()});
  }
}

static LogicalResult
splitRequiredKilledOperandInputs(func::FuncOp func,
                                 KilledOperandReuseIsaCache &isaCache) {
  SmallVector<std::pair<Operation *, unsigned>> operands;
  func.walk([&](Operation *op) {
    collectRequiredKilledOperandInputCopies(op, isaCache, operands);
  });

  OpBuilder builder(func.getContext());
  for (auto [op, operandNumber] : operands) {
    OpOperand &operand = op->getOpOperand(operandNumber);
    Value value = operand.get();
    if (llvm::hasSingleElement(value.getUses()))
      continue;
    if (!copyableRegType(value))
      return op->emitError("required killed operand reuse has non-copyable "
                           "multi-use operand");
    builder.setInsertionPoint(op);
    FailureOr<Value> dup = duplicateRegValue(builder, op->getLoc(), value);
    if (failed(dup))
      return failure();
    operand.assign(*dup);
  }
  return success();
}

static bool hasUseAfterInBlock(Value value, Operation *op) {
  Block *block = op->getBlock();
  for (OpOperand &use : value.getUses()) {
    Operation *user = ancestorInBlock(use.getOwner(), block);
    if (!user || user->hasTrait<OpTrait::IsTerminator>())
      continue;
    if (op->isBeforeInBlock(user))
      return true;
  }
  return false;
}

static bool needsCycleCopy(const RegAllocRegionFlow &flow,
                           const RegAllocRegionFlow::Transfer &transfer,
                           Value entry) {
  Value carry = transfer.operand->get();
  Value input = transfer.input;
  if (carry == input || carry == entry)
    return false;
  if (transfer.repetitiveInputRelation ==
      RegAllocRegionFlow::RepetitiveInputRelation::SameSlot)
    return false;
  if (transfer.repetitiveInputRelation ==
      RegAllocRegionFlow::RepetitiveInputRelation::DifferentSlots)
    return true;
  Operation *def = carry.getDefiningOp();
  if (!def)
    return true;
  Region *source = transfer.source;
  if (!source ||
      !RegAllocRegionFlow::isOperationInside(source->getParentOp(), def))
    return true;
  if (source != transfer.target)
    return true;
  Operation *top = ancestorInBlock(def, transfer.sourceOperation->getBlock());
  if (!top)
    return true;
  return hasUseAfterInBlock(input, top);
}

struct RepetitiveRegionValues {
  DenseMap<Value, Value> entries;
  DenseMap<OpOperand *, Value> incoming;
};

static RepetitiveRegionValues
collectRepetitiveRegionValues(const RegAllocRegionFlow &flow,
                              const RegAllocRegionFlow::Branch &branch) {
  RepetitiveRegionValues values;
  for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers) {
    if (!transfer.target || !flow.isRepetitive(transfer.target))
      continue;
    if (!transfer.source)
      values.entries.try_emplace(transfer.input, transfer.operand->get());
    else
      values.incoming.try_emplace(transfer.operand, transfer.operand->get());
  }
  return values;
}

static void collectBranchCycleCopyPlans(
    const RegAllocRegionFlow &flow, const RegAllocRegionFlow::Branch &branch,
    const RepetitiveRegionValues &values, SmallVectorImpl<RegCopyPlan> &plans) {
  for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers) {
    if (!transfer.source || !transfer.target ||
        !flow.isRepetitive(transfer.target) ||
        !flow.mayReach(transfer.target, transfer.source))
      continue;
    Value carry = values.incoming.lookup(transfer.operand);
    if (!trackedRegType(carry))
      continue;
    if (needsCycleCopy(flow, transfer, values.entries.lookup(transfer.input)))
      plans.push_back({carry, transfer.sourceOperation->getLoc(),
                       transfer.operand, transfer.sourceOperation});
  }
}

static LogicalResult materializeRepetitiveRegionCycleCopies(func::FuncOp func) {
  for (Operation *op : collectRegionBranchOperations(func)) {
    SmallVector<RegCopyPlan> plans;
    RegAllocRegionFlow flow(func);
    const RegAllocRegionFlow::Branch *branch = flow.lookup(op);
    if (!branch)
      continue;
    RepetitiveRegionValues values =
        collectRepetitiveRegionValues(flow, *branch);
    collectBranchCycleCopyPlans(flow, *branch, values, plans);
    if (failed(materializeRegCopyPlans(func, plans)))
      return failure();
  }
  return success();
}

static bool feedsRepetitiveRegionCarry(const RegAllocRegionFlow &flow,
                                       Value value) {
  return flow.feedsRepetitiveTransfer(value);
}

using ToElementsSourceMap = DenseMap<Value, std::pair<Value, unsigned>>;

struct AlignedTupleView {
  Value sourceTuple;
  unsigned sourceOffset = 0;
};

struct AlignedTupleViewState {
  std::optional<unsigned> sourceOffset;
  Value sourceTuple;
  unsigned consumerOffset = 0;
};

static bool addAlignedTupleViewElement(Value element,
                                       const ToElementsSourceMap &source,
                                       AlignedTupleViewState &state) {
  auto sourceIt = source.find(element);
  if (sourceIt == source.end())
    return false;
  auto [elementSource, elementOffset] = sourceIt->second;
  if (!state.sourceTuple)
    state.sourceTuple = elementSource;
  else if (state.sourceTuple != elementSource)
    return false;
  if (elementOffset < state.consumerOffset)
    return false;
  unsigned sourceOffset = elementOffset - state.consumerOffset;
  if (state.sourceOffset && *state.sourceOffset != sourceOffset)
    return false;
  state.sourceOffset = sourceOffset;
  state.consumerOffset +=
      cast<waveamdmachine::RegType>(element.getType()).getWidth();
  return true;
}

static std::optional<AlignedTupleView>
getAlignedTupleView(waveamdmachine::TupleFromElementsOp op,
                    const ToElementsSourceMap &source,
                    const wave::WaveAMDRegisterLimits *targetLimits) {
  AlignedTupleViewState state;
  for (Value element : op.getElements())
    if (!addAlignedTupleViewElement(element, source, state))
      return std::nullopt;
  if (!state.sourceTuple)
    return std::nullopt;
  if (!state.sourceOffset)
    return std::nullopt;
  waveamdmachine::RegType tupleType =
      cast<waveamdmachine::RegType>(op.getTuple().getType());
  unsigned tupleWidth = tupleType.getWidth();
  unsigned sourceWidth =
      cast<waveamdmachine::RegType>(state.sourceTuple.getType()).getWidth();
  if (state.consumerOffset != tupleWidth)
    return std::nullopt;
  if (*state.sourceOffset + tupleWidth > sourceWidth)
    return std::nullopt;
  waveamdmachine::RegType sourceType =
      cast<waveamdmachine::RegType>(state.sourceTuple.getType());
  if (!hasCompatibleTupleBases(sourceType, tupleType, *state.sourceOffset,
                               targetLimits,
                               requiresMCTupleEncoding(state.sourceTuple),
                               requiresMCTupleEncoding(op.getTuple())))
    return std::nullopt;
  return AlignedTupleView{state.sourceTuple, *state.sourceOffset};
}

static bool addFixedBaseConstraint(Value value, unsigned offset,
                                   std::optional<int64_t> &fixedBase) {
  int64_t index = cast<waveamdmachine::RegType>(value.getType()).getIndex();
  if (index < 0)
    return true;
  if (index < offset)
    return false;
  int64_t base = index - offset;
  if (fixedBase && *fixedBase != base)
    return false;
  fixedBase = base;
  return true;
}

static bool hasFixedViewConflict(waveamdmachine::TupleFromElementsOp op,
                                 AlignedTupleView view,
                                 const ToElementsSourceMap &source) {
  std::optional<int64_t> fixedBase;
  if (!addFixedBaseConstraint(view.sourceTuple, 0, fixedBase) ||
      !addFixedBaseConstraint(op.getTuple(), view.sourceOffset, fixedBase))
    return true;
  for (Value element : op.getElements()) {
    auto sourceIt = source.find(element);
    assert(sourceIt != source.end() && "aligned view element lacks source");
    if (!addFixedBaseConstraint(element, sourceIt->second.second, fixedBase))
      return true;
  }
  return false;
}

static bool hasSingleUseBy(Value value, Operation *user) {
  return llvm::hasSingleElement(value.getUses()) &&
         value.use_begin()->getOwner() == user;
}

static DenseMap<Value, unsigned>
getTupleElementSlots(waveamdmachine::TupleFromElementsOp op) {
  DenseMap<Value, unsigned> slots;
  unsigned offset = 0;
  for (Value element : op.getElements()) {
    slots.try_emplace(element, offset);
    offset += cast<waveamdmachine::RegType>(element.getType()).getWidth();
  }
  return slots;
}

static std::optional<unsigned>
getReanchorShift(waveamdmachine::TupleFromElementsOp op, Value element,
                 const ToElementsSourceMap &source,
                 const DenseMap<Value, unsigned> &consumerSlots) {
  auto sourceIt = source.find(element);
  if (sourceIt == source.end())
    return std::nullopt;
  auto slotIt = consumerSlots.find(element);
  if (slotIt == consumerSlots.end())
    return std::nullopt;
  if (!hasSingleUseBy(element, op.getOperation()))
    return std::nullopt;
  if (slotIt->second < sourceIt->second.second)
    return std::nullopt;
  return slotIt->second - sourceIt->second.second;
}

static std::optional<unsigned>
getTupleReanchorShift(waveamdmachine::TupleFromElementsOp op,
                      waveamdmachine::TupleToElementsOp split,
                      const ToElementsSourceMap &source,
                      const DenseMap<Value, unsigned> &consumerSlots) {
  std::optional<unsigned> shift;
  for (Value element : split.getElements()) {
    std::optional<unsigned> elementShift =
        getReanchorShift(op, element, source, consumerSlots);
    if (!elementShift)
      return std::nullopt;
    if (shift && *shift != *elementShift)
      return std::nullopt;
    shift = elementShift;
  }
  return shift;
}

static bool reanchorMeetsTargetConstraints(
    waveamdmachine::TupleFromElementsOp op, Value sourceTuple, unsigned shift,
    const wave::WaveAMDRegisterLimits *targetLimits) {
  if (!targetLimits)
    return true;
  waveamdmachine::RegType sourceType =
      cast<waveamdmachine::RegType>(sourceTuple.getType());
  waveamdmachine::RegType resultType =
      cast<waveamdmachine::RegType>(op.getTuple().getType());
  bool exactSourceSGPRBase = requiresMCTupleEncoding(sourceTuple);
  bool exactResultSGPRBase = requiresMCTupleEncoding(op.getTuple());
  bool hasTargetConstraint =
      (isSGPR(sourceType) && (exactSourceSGPRBase || exactResultSGPRBase)) ||
      (isVGPR(sourceType) && targetLimits->vgprTupleAlignment);
  if (!hasTargetConstraint)
    return true;
  return hasCompatibleTupleBases(resultType, sourceType, shift, targetLimits,
                                 exactResultSGPRBase, exactSourceSGPRBase);
}

static bool
isReanchorableSource(waveamdmachine::TupleFromElementsOp op, Value sourceTuple,
                     Value representative, const ToElementsSourceMap &source,
                     const DenseMap<Value, unsigned> &consumerSlots,
                     const wave::WaveAMDRegisterLimits *targetLimits) {
  auto split =
      representative.getDefiningOp<waveamdmachine::TupleToElementsOp>();
  if (!split)
    return false;
  if (!hasSingleUseBy(sourceTuple, split.getOperation()))
    return false;
  std::optional<unsigned> shift =
      getTupleReanchorShift(op, split, source, consumerSlots);
  if (!shift)
    return false;
  return reanchorMeetsTargetConstraints(op, sourceTuple, *shift, targetLimits);
}

static DenseSet<Value>
getReanchorableSources(waveamdmachine::TupleFromElementsOp op,
                       const ToElementsSourceMap &source,
                       const DenseMap<Value, unsigned> &consumerSlots,
                       const wave::WaveAMDRegisterLimits *targetLimits) {
  DenseMap<Value, Value> representatives;
  for (Value element : op.getElements()) {
    auto sourceIt = source.find(element);
    if (sourceIt != source.end())
      representatives.try_emplace(sourceIt->second.first, element);
  }

  DenseSet<Value> result;
  for (auto [sourceTuple, representative] : representatives)
    if (isReanchorableSource(op, sourceTuple, representative, source,
                             consumerSlots, targetLimits))
      result.insert(sourceTuple);
  return result;
}

static bool hasDestructiveStorageAliasUse(OpOperand &use) {
  auto aliasOp =
      dyn_cast<waveamdmachine::RegisterStorageAliasOpInterface>(use.getOwner());
  if (!aliasOp)
    return false;
  SmallVector<waveamdmachine::RegisterStorageAlias, 8> aliases;
  aliasOp.getRegisterStorageAliases(aliases);
  return llvm::any_of(aliases, [&](waveamdmachine::RegisterStorageAlias alias) {
    return alias.destructive && alias.alias == use.get();
  });
}

static bool isMFMAAccumulatorUse(OpOperand &use) {
  Operation *user = use.getOwner();
  auto mma = dyn_cast<waveamdmachine::MMAOpInterface>(user);
  return mma && user->hasTrait<OpTrait::waveamdmachine::MFMAOp>() &&
         mma.getAcc() == use.get();
}

static bool requiresKilledOperandReuse(OpOperand &use,
                                       KilledOperandReuseIsaCache &isaCache) {
  waveamdmachine::KilledOperandReuseOpInterface reuse =
      wave::regalloc_detail::getKilledOperandReuseCandidate(use.getOwner());
  if (!reuse)
    return false;
  const llvm::AMDGPU::IsaVersion *isa = isaCache.get();
  return isa && wave::regalloc_detail::requiresKilledOperandReuseForResult(
                    reuse, use, *isa);
}

static bool isStorageClobberUse(const RegAllocRegionFlow &flow, OpOperand &use,
                                KilledOperandReuseIsaCache &isaCache) {
  return flow.isRepetitiveTransferOperand(&use) ||
         hasDestructiveStorageAliasUse(use) || isMFMAAccumulatorUse(use) ||
         requiresKilledOperandReuse(use, isaCache);
}

static bool hasStorageClobberUse(const RegAllocRegionFlow &flow, Value value,
                                 KilledOperandReuseIsaCache &isaCache) {
  return llvm::any_of(value.getUses(), [&](OpOperand &use) {
    return isStorageClobberUse(flow, use, isaCache);
  });
}

struct RegSplatMove {
  Value source;
  Value result;
  Operation *op = nullptr;
};

static std::optional<RegSplatMove> getRegSplatMove(Operation *op) {
  waveamdmachine::RegisterCopyOpInterface copy =
      dyn_cast<waveamdmachine::RegisterCopyOpInterface>(op);
  if (!copy)
    return std::nullopt;
  return RegSplatMove{copy.getRegisterCopySource(),
                      copy.getRegisterCopyResult(), op};
}

static bool isLastUseRegSplat(RegSplatMove move,
                              KilledOperandReuseIsaCache &isaCache,
                              const RegAllocRegionFlow &flow) {
  std::optional<waveamdmachine::RegType> sourceType =
      copyableRegType(move.source);
  waveamdmachine::RegType resultType =
      cast<waveamdmachine::RegType>(move.result.getType());
  return sourceType && sourceType->getRegClass() == resultType.getRegClass() &&
         sourceType->getWidth() == 1 && sourceType->getIndex() < 0 &&
         resultType.getIndex() < 0 && resultType.getWidth() > 1 &&
         llvm::hasSingleElement(move.result.getUses()) &&
         isStorageClobberUse(flow, *move.result.use_begin(), isaCache) &&
         valueDiesAt(flow, move.source, move.op);
}

static void
decomposeLastUseRegSplatCopies(func::FuncOp func,
                               KilledOperandReuseIsaCache &isaCache,
                               DenseSet<Operation *> &decomposedSplatTuples) {
  SmallVector<RegSplatMove> moves;
  {
    RegAllocRegionFlow flow(func);
    func.walk([&](Operation *op) {
      std::optional<RegSplatMove> move = getRegSplatMove(op);
      if (move && isLastUseRegSplat(*move, isaCache, flow))
        moves.push_back(*move);
    });
  }

  OpBuilder builder(func.getContext());
  for (RegSplatMove move : moves) {
    builder.setInsertionPoint(move.op);
    waveamdmachine::RegType resultType =
        cast<waveamdmachine::RegType>(move.result.getType());
    SmallVector<Value> elements(resultType.getWidth(), move.source);
    waveamdmachine::TupleFromElementsOp tuple =
        waveamdmachine::TupleFromElementsOp::create(builder, move.op->getLoc(),
                                                    resultType, elements);
    decomposedSplatTuples.insert(tuple.getOperation());
    move.result.replaceAllUsesWith(tuple.getTuple());
    move.op->erase();
  }
}

static bool hasAlignedViewLifetimeConflict(
    waveamdmachine::TupleFromElementsOp op, AlignedTupleView view,
    const RegAllocRegionFlow &flow, KilledOperandReuseIsaCache &isaCache) {
  if (llvm::none_of(op.getTuple().getUses(), [&](OpOperand &use) {
        return isStorageClobberUse(flow, use, isaCache);
      }))
    return false;
  auto split = op.getElements()
                   .front()
                   .getDefiningOp<waveamdmachine::TupleToElementsOp>();
  if (!split || split.getTuple() != view.sourceTuple ||
      !hasSingleUseBy(view.sourceTuple, split.getOperation()))
    return true;
  return llvm::any_of(op.getElements(), [&](Value element) {
    return !hasSingleUseBy(element, op.getOperation());
  });
}

static bool hasSlotMismatch(const DenseMap<Value, unsigned> &anchorSlot,
                            Value element, unsigned slot) {
  auto anchorIt = anchorSlot.find(element);
  return anchorIt != anchorSlot.end() && anchorIt->second != slot;
}

static bool needsTupleElementCopy(const RegAllocRegionFlow &flow, Value element,
                                  bool slotMismatch, bool reuse,
                                  bool dragInConflict,
                                  bool fixedElementInUnfixedTuple,
                                  bool liveThroughClobber) {
  return slotMismatch || reuse || dragInConflict ||
         fixedElementInUnfixedTuple || liveThroughClobber ||
         feedsRepetitiveRegionCarry(flow, element);
}

static bool canPreserveAlignedView(waveamdmachine::TupleFromElementsOp op,
                                   AlignedTupleView view,
                                   const ToElementsSourceMap &source,
                                   const RegAllocRegionFlow &flow,
                                   KilledOperandReuseIsaCache &isaCache) {
  if (hasFixedViewConflict(op, view, source))
    return false;
  return !hasAlignedViewLifetimeConflict(op, view, flow, isaCache);
}

static bool isReanchoredElement(Value element,
                                const ToElementsSourceMap &source,
                                const DenseSet<Value> &reanchorableSources) {
  auto sourceIt = source.find(element);
  if (sourceIt == source.end())
    return false;
  return reanchorableSources.contains(sourceIt->second.first);
}

static bool hasSharingSlotConflict(const DenseMap<Value, unsigned> &anchorSlot,
                                   Value element, unsigned slot,
                                   bool preserveLayout) {
  return !preserveLayout && hasSlotMismatch(anchorSlot, element, slot);
}

static bool hasSharingReuse(const DenseSet<Value> &consumed, Value element,
                            bool preserveAlignedView) {
  return !preserveAlignedView && consumed.contains(element);
}

static bool hasSourceDragConflict(Value element,
                                  const ToElementsSourceMap &source,
                                  bool preserveLayout) {
  return !preserveLayout && source.contains(element);
}

static bool hasFixedElementConflict(Value element,
                                    waveamdmachine::RegType tupleType,
                                    bool preserveAlignedView) {
  if (preserveAlignedView || tupleType.getIndex() >= 0)
    return false;
  return cast<waveamdmachine::RegType>(element.getType()).getIndex() >= 0;
}

static bool isUnitReg(Value value, waveamdmachine::RegClass regClass) {
  std::optional<waveamdmachine::RegType> type = trackedRegType(value);
  return type && type->getRegClass() == regClass && type->getWidth() == 1;
}

static bool isUnassignedUnitReg(Value value,
                                waveamdmachine::RegClass regClass) {
  std::optional<waveamdmachine::RegType> type = trackedRegType(value);
  return type && type->getRegClass() == regClass && type->getWidth() == 1 &&
         type->getIndex() < 0;
}

static Value getTupleCopySource(Value value) {
  waveamdmachine::RegisterCopyOpInterface copy =
      dyn_cast_or_null<waveamdmachine::RegisterCopyOpInterface>(
          value.getDefiningOp());
  return copy ? copy.getRegisterCopySource() : Value{};
}

static Value getUnitRegTupleCopySource(Value value, Operation *tuple,
                                       waveamdmachine::RegClass regClass) {
  if (!hasSingleUseBy(value, tuple) || !isUnitReg(value, regClass))
    return {};
  Value source = getTupleCopySource(value);
  if (!source || !isUnitReg(source, regClass))
    return {};
  return source;
}

struct RegSplatSource {
  Value value;
  unsigned directElements = 0;
};

static std::optional<RegSplatSource>
getRegSplatSource(waveamdmachine::TupleFromElementsOp op,
                  waveamdmachine::RegClass regClass) {
  RegSplatSource source;
  for (Value element : op.getElements()) {
    Value root =
        getUnitRegTupleCopySource(element, op.getOperation(), regClass);
    if (!root) {
      root = element;
      ++source.directElements;
    }
    if (!isUnassignedUnitReg(root, regClass))
      return std::nullopt;
    if (source.value && source.value != root)
      return std::nullopt;
    source.value = root;
  }
  return source.value ? std::optional<RegSplatSource>(source) : std::nullopt;
}

static bool isLastUseRegSplat(waveamdmachine::TupleFromElementsOp op,
                              bool newlyDecomposed,
                              const RegAllocRegionFlow &flow) {
  std::optional<waveamdmachine::RegType> tupleType =
      copyableRegType(op.getTuple());
  if (!tupleType || tupleType->getIndex() >= 0 || tupleType->getWidth() <= 1)
    return false;
  std::optional<RegSplatSource> source =
      getRegSplatSource(op, tupleType->getRegClass());
  return source && (newlyDecomposed || source->directElements == 1) &&
         valueDiesAt(flow, source->value, op.getOperation());
}

static bool shouldCopyTupleElementForSharing(
    const RegAllocRegionFlow &flow, waveamdmachine::TupleFromElementsOp op,
    Value element, unsigned slot, unsigned useCount,
    waveamdmachine::RegType tupleType, bool preserveAlignedView,
    bool preserveLayout, bool tupleIsClobbered, bool lastUseSplat,
    DenseMap<Value, unsigned> &anchorSlot, const ToElementsSourceMap &source,
    DenseSet<Value> &consumedByFromElements) {
  bool slotMismatch =
      hasSharingSlotConflict(anchorSlot, element, slot, preserveLayout);
  bool reuse =
      hasSharingReuse(consumedByFromElements, element, preserveAlignedView);
  bool dragInConflict = hasSourceDragConflict(element, source, preserveLayout);
  bool fixedConflict =
      hasFixedElementConflict(element, tupleType, preserveAlignedView);
  bool elementDies = lastUseSplat
                         ? valueDiesAt(flow, element, op.getOperation())
                         : useCount == 1;
  bool liveThroughClobber = tupleIsClobbered && !elementDies;
  if (needsTupleElementCopy(flow, element, slotMismatch, reuse, dragInConflict,
                            fixedConflict, liveThroughClobber))
    return true;
  if (!preserveAlignedView)
    anchorSlot[element] = slot;
  consumedByFromElements.insert(element);
  return false;
}

static void
collectFromElementsCopyPlans(const RegAllocRegionFlow &flow,
                             waveamdmachine::TupleFromElementsOp op,
                             DenseMap<Value, unsigned> &anchorSlot,
                             const ToElementsSourceMap &toElementsSource,
                             DenseSet<Value> &consumedByFromElements,
                             const DenseSet<Operation *> &decomposedSplatTuples,
                             KilledOperandReuseIsaCache &isaCache,
                             const wave::WaveAMDRegisterLimits *targetLimits,
                             SmallVectorImpl<RegCopyPlan> &plans) {
  DenseMap<Value, unsigned> consumerSlots = getTupleElementSlots(op);
  DenseMap<Value, unsigned> useCounts;
  for (Value element : op.getElements())
    if (!useCounts.contains(element))
      useCounts[element] = llvm::range_size(element.getUses());
  DenseSet<Value> reanchorableSources =
      getReanchorableSources(op, toElementsSource, consumerSlots, targetLimits);
  std::optional<AlignedTupleView> alignedView =
      getAlignedTupleView(op, toElementsSource, targetLimits);
  if (alignedView && !canPreserveAlignedView(op, *alignedView, toElementsSource,
                                             flow, isaCache)) {
    reanchorableSources.erase(alignedView->sourceTuple);
    alignedView.reset();
  }
  unsigned cumOffset = 0;
  waveamdmachine::RegType tupleType =
      cast<waveamdmachine::RegType>(op.getTuple().getType());
  bool preserveAlignedView = alignedView.has_value();
  bool tupleIsClobbered = hasStorageClobberUse(flow, op.getTuple(), isaCache);
  bool lastUseSplat =
      tupleIsClobbered &&
      isLastUseRegSplat(op, decomposedSplatTuples.contains(op.getOperation()),
                        flow);
  for (auto [index, element] : llvm::enumerate(op.getElements())) {
    unsigned slot = cumOffset;
    bool reanchorSource =
        isReanchoredElement(element, toElementsSource, reanchorableSources);
    bool preserveLayout = preserveAlignedView || reanchorSource;
    if (shouldCopyTupleElementForSharing(
            flow, op, element, slot, useCounts.lookup(element), tupleType,
            preserveAlignedView, preserveLayout, tupleIsClobbered, lastUseSplat,
            anchorSlot, toElementsSource, consumedByFromElements)) {
      plans.push_back({element, op.getLoc(), &op->getOpOperand(index), op});
    }
    cumOffset += cast<waveamdmachine::RegType>(element.getType()).getWidth();
  }
}

static LogicalResult
splitTupleElementSharing(func::FuncOp func,
                         KilledOperandReuseIsaCache &isaCache,
                         const DenseSet<Operation *> &decomposedSplatTuples,
                         const wave::WaveAMDRegisterLimits *targetLimits) {
  DenseMap<Value, unsigned> anchorSlot;
  ToElementsSourceMap toElementsSource;
  DenseSet<Value> consumedByFromElements;
  SmallVector<waveamdmachine::TupleFromElementsOp> fromElementsOps;
  func.walk([&](Operation *op) {
    if (waveamdmachine::TupleToElementsOp toElements =
            dyn_cast<waveamdmachine::TupleToElementsOp>(op)) {
      unsigned cumOffset = 0;
      for (Value element : toElements.getElements()) {
        anchorSlot[element] = cumOffset;
        toElementsSource[element] = {toElements.getTuple(), cumOffset};
        cumOffset +=
            cast<waveamdmachine::RegType>(element.getType()).getWidth();
      }
    } else if (waveamdmachine::TupleFromElementsOp fromElements =
                   dyn_cast<waveamdmachine::TupleFromElementsOp>(op))
      fromElementsOps.push_back(fromElements);
  });
  for (waveamdmachine::TupleFromElementsOp op : fromElementsOps) {
    SmallVector<RegCopyPlan> plans;
    {
      RegAllocRegionFlow flow(func);
      collectFromElementsCopyPlans(
          flow, op, anchorSlot, toElementsSource, consumedByFromElements,
          decomposedSplatTuples, isaCache, targetLimits, plans);
    }
    if (failed(materializeRegCopyPlans(func, plans)))
      return failure();
  }
  return success();
}

static bool
isUniqueJoinIncoming(const RegAllocRegionFlow::Branch &branch,
                     const RegAllocRegionFlow::Transfer &current, Value value,
                     const DenseMap<OpOperand *, Value> &incomingValues) {
  for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers)
    if (!transfer.target && transfer.input != current.input &&
        incomingValues.lookup(transfer.operand) == value)
      return false;
  return true;
}

static bool alternativesCanOverwrite(
    const RegAllocRegionFlow &flow, const RegAllocRegionFlow::Branch &branch,
    const RegAllocRegionFlow::Transfer &current, Value value,
    const DenseMap<OpOperand *, Value> &incomingValues) {
  bool sawAlternative = false;
  for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers) {
    if (transfer.target || transfer.input != current.input ||
        &transfer == &current)
      continue;
    if (!flow.areMutuallyExclusive(current.source, transfer.source))
      return false;
    sawAlternative = true;
    Value incoming = incomingValues.lookup(transfer.operand);
    if (incoming == value)
      continue;
    Operation *def = incoming.getDefiningOp();
    if (!def || !RegAllocRegionFlow::isDefinedInside(branch.op, incoming) ||
        !valueDiesAt(flow, value, def))
      return false;
  }
  return sawAlternative;
}

static bool canAliasExternalJoinIncoming(
    const RegAllocRegionFlow &flow, const RegAllocRegionFlow::Branch &branch,
    const RegAllocRegionFlow::Transfer &transfer, Value value,
    const DenseMap<OpOperand *, Value> &incomingValues) {
  std::optional<wave::regalloc_detail::RegAllocStorageProperties> storage =
      wave::regalloc_detail::getRegAllocStorageProperties(value);
  if (!storage || !storage->mayAliasExclusiveJoin ||
      !valueDiesAt(flow, value, transfer.sourceOperation))
    return false;
  if (!isUniqueJoinIncoming(branch, transfer, value, incomingValues))
    return false;
  return alternativesCanOverwrite(flow, branch, transfer, value,
                                  incomingValues);
}

static bool
requiresBranchLocalRegisterAlias(const RegAllocRegionFlow::Transfer &transfer) {
  if (!isa<waveamdmachine::YieldOp>(transfer.sourceOperation))
    return false;
  Operation *parent = transfer.sourceOperation->getParentOp();
  return isa_and_nonnull<waveamdmachine::ExecIfOp, waveamdmachine::UniformIfOp>(
      parent);
}

static void
collectAcyclicRegionJoinCopyPlans(const RegAllocRegionFlow &flow,
                                  const RegAllocRegionFlow::Branch &branch,
                                  SmallVectorImpl<RegCopyPlan> &plans) {
  DenseMap<OpOperand *, Value> incomingValues;
  for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers)
    incomingValues.try_emplace(transfer.operand, transfer.operand->get());
  for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers) {
    if (transfer.target || !transfer.source ||
        flow.isRepetitive(transfer.source))
      continue;
    Value value = incomingValues.lookup(transfer.operand);
    if (!trackedRegType(value) ||
        RegAllocRegionFlow::isDefinedInside(branch.op, value))
      continue;
    if (canAliasExternalJoinIncoming(flow, branch, transfer, value,
                                     incomingValues)) {
      if (requiresBranchLocalRegisterAlias(transfer)) {
        plans.push_back({value, transfer.sourceOperation->getLoc(),
                         transfer.operand, transfer.sourceOperation, nullptr,
                         DuplicateRematPolicy::Never, true});
      }
      continue;
    }
    plans.push_back({value, transfer.sourceOperation->getLoc(),
                     transfer.operand, transfer.sourceOperation});
  }
}

static LogicalResult materializeAcyclicRegionJoinCopies(func::FuncOp func) {
  for (Operation *op : collectRegionBranchOperations(func)) {
    SmallVector<RegCopyPlan> plans;
    RegAllocRegionFlow flow(func);
    const RegAllocRegionFlow::Branch *branch = flow.lookup(op);
    if (!branch)
      continue;
    collectAcyclicRegionJoinCopyPlans(flow, *branch, plans);
    if (failed(materializeRegCopyPlans(func, plans)))
      return failure();
  }
  return success();
}

} // namespace

LogicalResult mlir::wave::prepareWaveAMDRegAllocIR(func::FuncOp func) {
  std::optional<WaveAMDRegisterLimits> targetLimits;
  if (waveamdmachine::findAMDGPUTargetModule(func)) {
    FailureOr<WaveAMDRegisterLimits> limits = getWaveAMDRegisterLimits(func);
    if (failed(limits))
      return failure();
    targetLimits = std::move(*limits);
  }
  eraseRegAfterOps(func);
  if (failed(splitLiveUpdateTupleBases(func)))
    return failure();
  if (failed(materializeAcyclicRegionJoinCopies(func)))
    return failure();
  if (failed(materializeRepetitiveRegionCycleCopies(func)))
    return failure();
  if (failed(splitDuplicateRepetitiveRegionInits(func)))
    return failure();
  if (failed(splitDuplicateMFMAAccumulatorInputs(func)))
    return failure();
  KilledOperandReuseIsaCache isaCache(func);
  if (failed(splitRequiredKilledOperandInputs(func, isaCache)))
    return failure();
  DenseSet<Operation *> decomposedSplatTuples;
  decomposeLastUseRegSplatCopies(func, isaCache, decomposedSplatTuples);
  return splitTupleElementSharing(func, isaCache, decomposedSplatTuples,
                                  targetLimits ? &*targetLimits : nullptr);
}
