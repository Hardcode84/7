//===- WaveAMDFormFusedInt.cpp - Fused integer peepholes -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInstrInfo.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/TargetParser/TargetParser.h"

#include <array>
#include <cstdint>
#include <limits>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDFORMFUSEDINT
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::dataflow;
using namespace mlir::wave;
using namespace mlir::waveamdmachine;

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

static constexpr char kLocalBaseAttr[] = "waveamdmachine.local_base";

template <typename OpTy>
static bool canCreateTernary(ArrayRef<Value> operands,
                             const llvm::AMDGPU::IsaVersion &isa) {
  return OpTy::isSupportedOnIsa(isa) &&
         canUseConstantBus(operands, isa, [](Value, Value) { return false; });
}

template <typename InnerOp>
static InnerOp matchSingleUseProducer(Value value, Operation *consumer) {
  InnerOp inner = value.getDefiningOp<InnerOp>();
  if (!inner)
    return InnerOp();
  if (inner->getBlock() != consumer->getBlock())
    return InnerOp();
  if (!inner.getResult().hasOneUse())
    return InnerOp();
  return inner;
}

static SAddI32Op matchDeadSCCSAddProducer(Value value, Operation *consumer) {
  SAddI32Op inner = value.getDefiningOp<SAddI32Op>();
  if (!inner)
    return SAddI32Op();
  if (inner->getBlock() != consumer->getBlock())
    return SAddI32Op();
  if (!inner.getResult().hasOneUse())
    return SAddI32Op();
  if (!inner.getScc().use_empty())
    return SAddI32Op();
  return inner;
}

static bool writesM0(Operation *op) {
  return llvm::any_of(op->getResults(), [](Value result) {
    return isa<M0Type>(result.getType());
  });
}

static bool hasSingleM0UseBeforeClobber(SMovM0Op op) {
  if (!op.getResult().hasOneUse())
    return false;

  Operation *user = *op.getResult().user_begin();
  if (user->getBlock() != op->getBlock())
    return false;

  for (Operation *cur = op->getNextNode(); cur && cur != user;
       cur = cur->getNextNode()) {
    if (cur->getNumRegions() != 0)
      return false;
    if (writesM0(cur))
      return false;
  }
  return true;
}

static std::optional<ConstantIntRanges>
normalizeU32Range(const ConstantIntRanges &range) {
  unsigned bits = range.umin().getBitWidth();
  if (bits == 0 || bits > 32)
    return std::nullopt;
  if (bits == 32)
    return range;
  return ConstantIntRanges(range.umin().zext(32), range.umax().zext(32),
                           range.smin().sext(32), range.smax().sext(32));
}

static std::optional<ConstantIntRanges> getU32Range(DataFlowSolver &solver,
                                                    Value value) {
  const IntegerValueRangeLattice *lattice =
      solver.lookupState<IntegerValueRangeLattice>(value);
  if (!lattice)
    return std::nullopt;
  IntegerValueRange valueRange = lattice->getValue();
  if (valueRange.isUninitialized())
    return std::nullopt;
  return normalizeU32Range(valueRange.getValue());
}

static bool isProvenU24(const ConstantIntRanges &range) {
  if (range.umin().getBitWidth() != 32)
    return false;
  return range.umax().ule(APInt::getLowBitsSet(32, 24));
}

static bool isProvenI24(const ConstantIntRanges &range) {
  if (range.smin().getBitWidth() != 32)
    return false;
  APInt min = APInt::getSignedMinValue(24).sext(32);
  APInt max = APInt::getSignedMaxValue(24).sext(32);
  return range.smin().sge(min) && range.smax().sle(max);
}

template <typename NewOp, typename OldOp>
static void replaceWithTernary(PatternRewriter &rewriter, OldOp oldOp,
                               Operation *deadProducer, Value a, Value b,
                               Value c) {
  NewOp fused = NewOp::create(rewriter, oldOp.getLoc(),
                              oldOp.getResult().getType(), a, b, c);
  fused->setAttrs(oldOp->getAttrs());
  rewriter.replaceOp(oldOp, fused.getResult());
  rewriter.eraseOp(deadProducer);
}

template <typename NewOp, typename OldOp>
static LogicalResult tryReplaceTernary(PatternRewriter &rewriter, OldOp oldOp,
                                       Operation *deadProducer, Value a,
                                       Value b, Value c,
                                       const llvm::AMDGPU::IsaVersion &isa) {
  std::array<Value, 3> operands = {a, b, c};
  if (!canCreateTernary<NewOp>(operands, isa))
    return failure();
  replaceWithTernary<NewOp>(rewriter, oldOp, deadProducer, a, b, c);
  return success();
}

template <typename InnerOp, typename NewOp, typename OldOp>
static LogicalResult tryFuseNestedBinary(PatternRewriter &rewriter, OldOp oldOp,
                                         const llvm::AMDGPU::IsaVersion &isa) {
  if (InnerOp inner = matchSingleUseProducer<InnerOp>(oldOp.getLhs(), oldOp)) {
    if (succeeded(tryReplaceTernary<NewOp>(rewriter, oldOp, inner,
                                           inner.getLhs(), inner.getRhs(),
                                           oldOp.getRhs(), isa)))
      return success();
  }

  if (InnerOp inner = matchSingleUseProducer<InnerOp>(oldOp.getRhs(), oldOp)) {
    if (succeeded(tryReplaceTernary<NewOp>(rewriter, oldOp, inner,
                                           inner.getLhs(), inner.getRhs(),
                                           oldOp.getLhs(), isa)))
      return success();
  }

  return failure();
}

static LogicalResult tryFuseScalarAdd(PatternRewriter &rewriter, VAddU32Op op,
                                      const llvm::AMDGPU::IsaVersion &isa) {
  if (SAddI32Op inner = matchDeadSCCSAddProducer(op.getLhs(), op)) {
    if (succeeded(tryReplaceTernary<VAdd3U32Op>(rewriter, op, inner,
                                                inner.getLhs(), inner.getRhs(),
                                                op.getRhs(), isa)))
      return success();
  }

  if (SAddI32Op inner = matchDeadSCCSAddProducer(op.getRhs(), op)) {
    if (succeeded(tryReplaceTernary<VAdd3U32Op>(rewriter, op, inner,
                                                inner.getLhs(), inner.getRhs(),
                                                op.getLhs(), isa)))
      return success();
  }

  return failure();
}

static bool isScalarAddBaseHardBoundary(Operation *op) {
  if (!isa<WaveAMDMachineDialect>(op->getDialect()))
    return true;
  if (op->hasTrait<OpTrait::IsTerminator>())
    return true;
  if (op->getNumRegions() != 0)
    return true;
  if (op->hasTrait<traits::WaitcntOp>())
    return true;
  if (op->hasTrait<traits::WritesExecOp>())
    return true;
  return isa<LabelOp, SBarrierOp, SSetprioOp, SCBranchExeczOp, SCBranchScc0Op,
             SCBranchScc1Op, SAndSaveexecB32Op, SAndn2ExecB32Op,
             SAndSaveexecB64Op, SAndn2ExecB64Op, SMovExecLoOp, SMovExecB64Op,
             SEndpgmOp, SSetpcB64Op>(op);
}

struct ScalarAddBaseCandidate {
  VAddU32Op outer;
  SAddI32Op scalarAdd;
  Value commonScalar;
  Value commonVector;
  Value varyingScalar;
};

static std::optional<ScalarAddBaseCandidate>
matchScalarAddBaseCandidate(VAddU32Op op, Value expectedCommonScalar,
                            Value expectedCommonVector,
                            const llvm::AMDGPU::IsaVersion &isa) {
  auto tryMatchSide =
      [&](Value maybeScalarSum,
          Value vector) -> std::optional<ScalarAddBaseCandidate> {
    if (expectedCommonVector && vector != expectedCommonVector)
      return std::nullopt;
    if (!isVGPRValue(vector))
      return std::nullopt;

    SAddI32Op inner = matchDeadSCCSAddProducer(maybeScalarSum, op);
    if (!inner)
      return std::nullopt;

    std::array<Value, 3> ternaryOperands = {inner.getLhs(), inner.getRhs(),
                                            vector};
    if (canCreateTernary<VAdd3U32Op>(ternaryOperands, isa))
      return std::nullopt;

    auto tryCommonScalar =
        [&](Value commonScalar,
            Value varyingScalar) -> std::optional<ScalarAddBaseCandidate> {
      if (expectedCommonScalar && commonScalar != expectedCommonScalar)
        return std::nullopt;
      return ScalarAddBaseCandidate{op, inner, commonScalar, vector,
                                    varyingScalar};
    };

    if (std::optional<ScalarAddBaseCandidate> candidate =
            tryCommonScalar(inner.getLhs(), inner.getRhs()))
      return candidate;
    return tryCommonScalar(inner.getRhs(), inner.getLhs());
  };

  if (std::optional<ScalarAddBaseCandidate> candidate =
          tryMatchSide(op.getLhs(), op.getRhs()))
    return candidate;
  return tryMatchSide(op.getRhs(), op.getLhs());
}

static SmallVector<ScalarAddBaseCandidate, 2>
matchScalarAddBaseRootCandidates(VAddU32Op op,
                                 const llvm::AMDGPU::IsaVersion &isa) {
  SmallVector<ScalarAddBaseCandidate, 2> candidates;
  auto appendSide = [&](Value maybeScalarSum, Value vector) {
    if (!isVGPRValue(vector))
      return;

    SAddI32Op inner = matchDeadSCCSAddProducer(maybeScalarSum, op);
    if (!inner)
      return;

    std::array<Value, 3> ternaryOperands = {inner.getLhs(), inner.getRhs(),
                                            vector};
    if (canCreateTernary<VAdd3U32Op>(ternaryOperands, isa))
      return;

    candidates.push_back(ScalarAddBaseCandidate{op, inner, inner.getLhs(),
                                                vector, inner.getRhs()});
    if (inner.getLhs() != inner.getRhs())
      candidates.push_back(ScalarAddBaseCandidate{op, inner, inner.getRhs(),
                                                  vector, inner.getLhs()});
  };

  appendSide(op.getLhs(), op.getRhs());
  appendSide(op.getRhs(), op.getLhs());
  return candidates;
}

static bool
isScalarAddBaseCandidateProducer(Operation *op,
                                 const ScalarAddBaseCandidate &root,
                                 const llvm::AMDGPU::IsaVersion &isa) {
  auto inner = dyn_cast<SAddI32Op>(op);
  if (!inner)
    return false;
  if (!inner.getResult().hasOneUse() || !inner.getScc().use_empty())
    return false;

  Operation *user = *inner.getResult().user_begin();
  if (user->getBlock() != op->getBlock())
    return false;
  auto add = dyn_cast<VAddU32Op>(user);
  if (!add)
    return false;
  return matchScalarAddBaseCandidate(add, root.commonScalar, root.commonVector,
                                     isa)
      .has_value();
}

static SmallVector<ScalarAddBaseCandidate, 4>
collectScalarAddBaseRun(const ScalarAddBaseCandidate &root,
                        const llvm::AMDGPU::IsaVersion &isa) {
  // Bounds new VGPR base lifetime; legality is SSA, not proximity.
  constexpr unsigned maxInterCandidateOps = 4;

  SmallVector<ScalarAddBaseCandidate, 4> candidates;
  candidates.push_back(root);

  unsigned gap = 0;
  for (Operation *cur = root.outer->getNextNode(); cur;
       cur = cur->getNextNode()) {
    if (isScalarAddBaseHardBoundary(cur))
      break;
    if (cur->hasTrait<OpTrait::waveamdmachine::NoMachineInst>())
      continue;

    if (auto add = dyn_cast<VAddU32Op>(cur)) {
      std::optional<ScalarAddBaseCandidate> candidate =
          matchScalarAddBaseCandidate(add, root.commonScalar, root.commonVector,
                                      isa);
      if (candidate) {
        candidates.push_back(*candidate);
        gap = 0;
        continue;
      }
    }

    if (isScalarAddBaseCandidateProducer(cur, root, isa))
      continue;

    ++gap;
    if (gap > maxInterCandidateOps)
      break;
  }

  return candidates;
}

static LogicalResult tryFactorScalarAddBase(PatternRewriter &rewriter,
                                            VAddU32Op op,
                                            const llvm::AMDGPU::IsaVersion &isa,
                                            uint64_t &nextLocalBaseId) {
  SmallVector<ScalarAddBaseCandidate, 2> roots =
      matchScalarAddBaseRootCandidates(op, isa);
  for (const ScalarAddBaseCandidate &root : roots) {
    SmallVector<ScalarAddBaseCandidate, 4> candidates =
        collectScalarAddBaseRun(root, isa);
    if (candidates.size() < 3)
      continue;

    rewriter.setInsertionPoint(candidates.front().outer);
    VAddU32Op base =
        VAddU32Op::create(rewriter, candidates.front().outer.getLoc(),
                          candidates.front().outer.getResult().getType(),
                          root.commonScalar, root.commonVector);
    base->setAttr(kLocalBaseAttr,
                  rewriter.getI64IntegerAttr(nextLocalBaseId++));

    for (ScalarAddBaseCandidate &candidate : candidates) {
      rewriter.setInsertionPoint(candidate.outer);
      VAddU32Op replacement =
          VAddU32Op::create(rewriter, candidate.outer.getLoc(),
                            candidate.outer.getResult().getType(),
                            candidate.varyingScalar, base.getResult());
      replacement->setAttrs(candidate.outer->getAttrs());
      rewriter.replaceOp(candidate.outer, replacement.getResult());
      rewriter.eraseOp(candidate.scalarAdd);
    }
    return success();
  }

  return failure();
}

struct AddChainCandidate {
  SmallVector<Operation *, 4> ops;
  SmallVector<Value, 8> leaves;
  Operation *root = nullptr;
};

struct AddExpression {
  Operation *lastOp = nullptr;
  Value result;
};

static bool isAddOp(Operation *op) {
  return op && isa<VAddU32Op, VAdd3U32Op>(op);
}

static Value getAddResult(Operation *op) { return op->getResult(0); }

static bool hasSameBlockAddUser(Operation *op) {
  for (Operation *user : getAddResult(op).getUsers())
    if (isAddOp(user) && user->getBlock() == op->getBlock())
      return true;
  return false;
}

static bool isGeneratedAddBase(Operation *op) {
  return op->hasAttr(kLocalBaseAttr);
}

static bool isAddChainProducer(Operation *op) {
  return isAddOp(op) && hasSameBlockAddUser(op);
}

static bool flattenAddOperand(Value value, Operation *consumer,
                              AddChainCandidate &candidate) {
  Operation *def = value.getDefiningOp();
  if (!isAddOp(def) || def->getBlock() != consumer->getBlock() ||
      isGeneratedAddBase(def) || !getAddResult(def).hasOneUse()) {
    candidate.leaves.push_back(value);
    return true;
  }

  for (Value operand : def->getOperands())
    if (!flattenAddOperand(operand, def, candidate))
      return false;
  candidate.ops.push_back(def);
  return true;
}

static std::optional<AddChainCandidate> matchAddChainCandidate(Operation *op) {
  if (!isAddOp(op) || isGeneratedAddBase(op) || hasSameBlockAddUser(op))
    return std::nullopt;

  AddChainCandidate candidate;
  candidate.root = op;
  for (Value operand : op->getOperands())
    if (!flattenAddOperand(operand, op, candidate))
      return std::nullopt;
  candidate.ops.push_back(op);
  return candidate;
}

static bool consumeValue(SmallVectorImpl<Value> &values, Value needle) {
  for (auto it = values.begin(), e = values.end(); it != e; ++it) {
    if (*it != needle)
      continue;
    values.erase(it);
    return true;
  }
  return false;
}

static SmallVector<Value, 8> intersectValues(ArrayRef<Value> lhs,
                                             ArrayRef<Value> rhs) {
  SmallVector<Value, 8> available(rhs.begin(), rhs.end());
  SmallVector<Value, 8> result;
  for (Value value : lhs)
    if (consumeValue(available, value))
      result.push_back(value);
  return result;
}

static SmallVector<Value, 8> subtractValues(ArrayRef<Value> values,
                                            ArrayRef<Value> remove) {
  SmallVector<Value, 8> remaining(remove.begin(), remove.end());
  SmallVector<Value, 8> result;
  for (Value value : values) {
    if (consumeValue(remaining, value))
      continue;
    result.push_back(value);
  }
  return result;
}

static SmallVector<Value, 8> orderAddLeaves(ArrayRef<Value> values) {
  SmallVector<Value, 8> ordered;
  for (Value value : values)
    if (isVGPRValue(value))
      ordered.push_back(value);
  for (Value value : values)
    if (!isVGPRValue(value))
      ordered.push_back(value);
  return ordered;
}

static bool canCreateVAddU32(Value lhs, Value rhs,
                             const llvm::AMDGPU::IsaVersion &isa) {
  std::array<Value, 2> operands = {lhs, rhs};
  return hasAnyVGPROperand(lhs, rhs) &&
         canUseConstantBus(operands, isa, [](Value, Value) { return false; });
}

static FailureOr<unsigned>
estimateAddExpressionCost(ArrayRef<Value> leaves,
                          const llvm::AMDGPU::IsaVersion &isa) {
  SmallVector<Value, 8> ordered = orderAddLeaves(leaves);
  if (ordered.empty())
    return failure();
  if (ordered.size() == 1)
    return 0;
  if (!isVGPRValue(ordered.front()))
    return failure();

  unsigned cost = 0;
  Value acc = ordered.front();
  unsigned index = 1;
  while (index < ordered.size()) {
    if (index + 1 < ordered.size()) {
      std::array<Value, 3> operands = {acc, ordered[index], ordered[index + 1]};
      if (canCreateTernary<VAdd3U32Op>(operands, isa)) {
        ++cost;
        index += 2;
        continue;
      }
    }
    if (!canCreateVAddU32(acc, ordered[index], isa))
      return failure();
    ++cost;
    ++index;
  }
  return cost;
}

static void noteBuiltAddOp(PatternRewriter &rewriter, AddExpression &built,
                           Operation *op, std::optional<uint64_t> localBaseId) {
  built.lastOp = op;
  if (localBaseId)
    op->setAttr(kLocalBaseAttr, rewriter.getI64IntegerAttr(*localBaseId));
}

static FailureOr<Value> tryBuildAdd3Step(PatternRewriter &rewriter,
                                         Location loc, Type resultType,
                                         AddExpression &built, Value acc,
                                         Value lhs, Value rhs,
                                         const llvm::AMDGPU::IsaVersion &isa,
                                         std::optional<uint64_t> localBaseId) {
  std::array<Value, 3> operands = {acc, lhs, rhs};
  if (!canCreateTernary<VAdd3U32Op>(operands, isa))
    return failure();
  VAdd3U32Op add = VAdd3U32Op::create(rewriter, loc, resultType, operands[0],
                                      operands[1], operands[2]);
  noteBuiltAddOp(rewriter, built, add, localBaseId);
  return add.getResult();
}

static FailureOr<Value> buildAddStep(PatternRewriter &rewriter, Location loc,
                                     Type resultType, AddExpression &built,
                                     ArrayRef<Value> ordered, Value acc,
                                     unsigned &index,
                                     const llvm::AMDGPU::IsaVersion &isa,
                                     std::optional<uint64_t> localBaseId) {
  if (index + 1 < ordered.size()) {
    FailureOr<Value> add3 =
        tryBuildAdd3Step(rewriter, loc, resultType, built, acc, ordered[index],
                         ordered[index + 1], isa, localBaseId);
    if (succeeded(add3)) {
      index += 2;
      return add3;
    }
  }

  if (!canCreateVAddU32(acc, ordered[index], isa))
    return failure();
  VAddU32Op add =
      VAddU32Op::create(rewriter, loc, resultType, acc, ordered[index]);
  noteBuiltAddOp(rewriter, built, add, localBaseId);
  ++index;
  return add.getResult();
}

static FailureOr<AddExpression>
buildAddExpression(PatternRewriter &rewriter, Location loc, Type resultType,
                   ArrayRef<Value> leaves, const llvm::AMDGPU::IsaVersion &isa,
                   std::optional<uint64_t> localBaseId = std::nullopt,
                   DictionaryAttr finalAttrs = nullptr) {
  SmallVector<Value, 8> ordered = orderAddLeaves(leaves);
  if (ordered.empty())
    return failure();
  if (ordered.size() == 1)
    return AddExpression{nullptr, ordered.front()};
  if (!isVGPRValue(ordered.front()))
    return failure();

  AddExpression built;
  Value acc = ordered.front();
  unsigned index = 1;
  while (index < ordered.size()) {
    FailureOr<Value> next = buildAddStep(rewriter, loc, resultType, built,
                                         ordered, acc, index, isa, localBaseId);
    if (failed(next))
      return failure();
    acc = *next;
  }
  if (built.lastOp && finalAttrs)
    built.lastOp->setAttrs(finalAttrs);
  built.result = acc;
  return built;
}

static SmallVector<AddChainCandidate, 4>
collectAddChainRun(const AddChainCandidate &root,
                   SmallVectorImpl<Value> &common) {
  constexpr unsigned maxInterCandidateOps = 4;

  SmallVector<AddChainCandidate, 4> candidates;
  candidates.push_back(root);

  unsigned gap = 0;
  for (Operation *cur = root.root->getNextNode(); cur;
       cur = cur->getNextNode()) {
    if (isScalarAddBaseHardBoundary(cur))
      break;
    if (cur->hasTrait<OpTrait::waveamdmachine::NoMachineInst>())
      continue;
    if (isAddChainProducer(cur))
      continue;

    if (std::optional<AddChainCandidate> candidate =
            matchAddChainCandidate(cur)) {
      SmallVector<Value, 8> nextCommon =
          intersectValues(common, candidate->leaves);
      if (nextCommon.size() >= 2) {
        common = std::move(nextCommon);
        candidates.push_back(std::move(*candidate));
        gap = 0;
        continue;
      }
    }

    ++gap;
    if (gap > maxInterCandidateOps)
      break;
  }
  return candidates;
}

static unsigned sumAddChainCost(ArrayRef<AddChainCandidate> candidates) {
  unsigned cost = 0;
  for (const AddChainCandidate &candidate : candidates)
    cost += candidate.ops.size();
  return cost;
}

static FailureOr<unsigned>
estimateFactoredAddCost(ArrayRef<AddChainCandidate> candidates,
                        ArrayRef<Value> common,
                        const llvm::AMDGPU::IsaVersion &isa) {
  FailureOr<unsigned> commonCost = estimateAddExpressionCost(common, isa);
  if (failed(commonCost))
    return failure();

  unsigned cost = *commonCost;
  Value baseProxy = orderAddLeaves(common).front();
  for (const AddChainCandidate &candidate : candidates) {
    SmallVector<Value, 8> rebuildLeaves =
        subtractValues(candidate.leaves, common);
    rebuildLeaves.push_back(baseProxy);
    FailureOr<unsigned> rebuildCost =
        estimateAddExpressionCost(rebuildLeaves, isa);
    if (failed(rebuildCost))
      return failure();
    cost += *rebuildCost;
  }
  return cost;
}

static std::optional<SmallVector<Value, 8>>
chooseCommonAddends(ArrayRef<AddChainCandidate> candidates,
                    ArrayRef<Value> common,
                    const llvm::AMDGPU::IsaVersion &isa) {
  if (candidates.size() < 3)
    return std::nullopt;

  SmallVector<Value, 8> orderedCommon = orderAddLeaves(common);
  if (orderedCommon.size() < 2 || !isVGPRValue(orderedCommon.front()))
    return std::nullopt;

  unsigned oldCost = sumAddChainCost(candidates);
  unsigned bestCost = oldCost;
  unsigned bestCount = 0;
  for (unsigned count = 2; count <= orderedCommon.size(); ++count) {
    ArrayRef<Value> prefix(orderedCommon.data(), count);
    FailureOr<unsigned> newCost =
        estimateFactoredAddCost(candidates, prefix, isa);
    if (failed(newCost) || *newCost >= bestCost)
      continue;
    bestCost = *newCost;
    bestCount = count;
  }
  if (bestCount == 0)
    return std::nullopt;
  return SmallVector<Value, 8>(orderedCommon.begin(),
                               orderedCommon.begin() + bestCount);
}

static void eraseAddChain(PatternRewriter &rewriter,
                          const AddChainCandidate &candidate) {
  for (Operation *op : llvm::reverse(candidate.ops)) {
    if (op == candidate.root)
      continue;
    if (op->use_empty())
      rewriter.eraseOp(op);
  }
}

static LogicalResult tryFactorAddChain(PatternRewriter &rewriter, Operation *op,
                                       const llvm::AMDGPU::IsaVersion &isa,
                                       uint64_t &nextLocalBaseId) {
  std::optional<AddChainCandidate> root = matchAddChainCandidate(op);
  if (!root)
    return failure();

  SmallVector<Value, 8> common = root->leaves;
  SmallVector<AddChainCandidate, 4> candidates =
      collectAddChainRun(*root, common);
  std::optional<SmallVector<Value, 8>> selectedCommon =
      chooseCommonAddends(candidates, common, isa);
  if (!selectedCommon)
    return failure();

  uint64_t localBaseId = nextLocalBaseId++;
  rewriter.setInsertionPoint(candidates.front().root);
  FailureOr<AddExpression> base =
      buildAddExpression(rewriter, candidates.front().root->getLoc(),
                         getAddResult(candidates.front().root).getType(),
                         *selectedCommon, isa, localBaseId);
  if (failed(base))
    return failure();

  for (AddChainCandidate &candidate : candidates) {
    SmallVector<Value, 8> rebuildLeaves =
        subtractValues(candidate.leaves, *selectedCommon);
    rebuildLeaves.push_back(base->result);
    rewriter.setInsertionPoint(candidate.root);
    FailureOr<AddExpression> replacement = buildAddExpression(
        rewriter, candidate.root->getLoc(),
        getAddResult(candidate.root).getType(), rebuildLeaves, isa,
        std::nullopt, candidate.root->getAttrDictionary());
    if (failed(replacement))
      return failure();
    rewriter.replaceOp(candidate.root, replacement->result);
    eraseAddChain(rewriter, candidate);
  }
  return success();
}

static Value getSingleShiftAddend(VLshlrevB32Op op, VAddU32Op add) {
  bool lhsShift = add.getLhs() == op.getResult();
  bool rhsShift = add.getRhs() == op.getResult();
  if (lhsShift == rhsShift)
    return Value();
  return lhsShift ? add.getRhs() : add.getLhs();
}

static LogicalResult
tryFuseShiftAddFanout(PatternRewriter &rewriter, VLshlrevB32Op op,
                      const llvm::AMDGPU::IsaVersion &isa) {
  if (op.getResult().hasOneUse())
    return failure();

  SmallVector<VAddU32Op, 4> users;
  for (Operation *user : op.getResult().getUsers()) {
    auto add = dyn_cast<VAddU32Op>(user);
    if (!add || add->getBlock() != op->getBlock())
      return failure();

    Value addend = getSingleShiftAddend(op, add);
    if (!addend)
      return failure();

    std::array<Value, 3> operands = {op.getLhs(), op.getRhs(), addend};
    if (!canCreateTernary<VLshlAddU32Op>(operands, isa))
      return failure();
    users.push_back(add);
  }

  if (users.size() < 2)
    return failure();

  for (VAddU32Op add : users) {
    Value addend = getSingleShiftAddend(op, add);
    rewriter.setInsertionPoint(add);
    auto fused =
        VLshlAddU32Op::create(rewriter, add.getLoc(), add.getResult().getType(),
                              op.getLhs(), op.getRhs(), addend);
    fused->setAttrs(add->getAttrs());
    rewriter.replaceOp(add, fused.getResult());
  }
  rewriter.eraseOp(op);
  return success();
}

enum class PermuteBitKind : uint8_t { Zero, One, Source };

struct PermuteBit {
  Value source;
  PermuteBitKind kind = PermuteBitKind::Zero;
  uint8_t sourceBit = 0;
};

using PermuteBits = std::array<PermuteBit, 32>;

struct BytePermutationCandidate {
  SmallVector<Operation *, 8> deadOps;
  unsigned instructionCount = 0;
};

struct BytePermutation {
  SmallVector<Value, 2> sources;
  uint32_t selector = 0;
};

static PermuteBits getConstantPermuteBits(uint32_t value) {
  PermuteBits bits;
  for (auto [index, bit] : llvm::enumerate(bits))
    if (value & (uint32_t{1} << index))
      bit.kind = PermuteBitKind::One;
  return bits;
}

static PermuteBits getSourcePermuteBits(Value source) {
  PermuteBits bits;
  for (auto [index, bit] : llvm::enumerate(bits)) {
    bit.source = source;
    bit.kind = PermuteBitKind::Source;
    bit.sourceBit = static_cast<uint8_t>(index);
  }
  return bits;
}

static bool isSamePermuteBit(const PermuteBit &lhs, const PermuteBit &rhs) {
  if (lhs.kind != rhs.kind)
    return false;
  if (lhs.kind != PermuteBitKind::Source)
    return true;
  return lhs.source == rhs.source && lhs.sourceBit == rhs.sourceBit;
}

static std::optional<PermuteBits> andPermuteBits(const PermuteBits &lhs,
                                                 const PermuteBits &rhs) {
  PermuteBits result;
  for (auto [lhsBit, rhsBit, resultBit] : llvm::zip(lhs, rhs, result)) {
    if (lhsBit.kind == PermuteBitKind::Zero ||
        rhsBit.kind == PermuteBitKind::Zero)
      continue;
    if (lhsBit.kind == PermuteBitKind::One) {
      resultBit = rhsBit;
      continue;
    }
    if (rhsBit.kind == PermuteBitKind::One ||
        isSamePermuteBit(lhsBit, rhsBit)) {
      resultBit = lhsBit;
      continue;
    }
    return std::nullopt;
  }
  return result;
}

static std::optional<PermuteBits> orPermuteBits(const PermuteBits &lhs,
                                                const PermuteBits &rhs) {
  PermuteBits result;
  for (auto [lhsBit, rhsBit, resultBit] : llvm::zip(lhs, rhs, result)) {
    if (lhsBit.kind == PermuteBitKind::One ||
        rhsBit.kind == PermuteBitKind::Zero) {
      resultBit = lhsBit;
      continue;
    }
    if (rhsBit.kind == PermuteBitKind::One ||
        lhsBit.kind == PermuteBitKind::Zero) {
      resultBit = rhsBit;
      continue;
    }
    if (!isSamePermuteBit(lhsBit, rhsBit))
      return std::nullopt;
    resultBit = lhsBit;
  }
  return result;
}

static std::optional<PermuteBits> addPermuteBits(const PermuteBits &lhs,
                                                 const PermuteBits &rhs) {
  PermuteBits result;
  for (auto [lhsBit, rhsBit, resultBit] : llvm::zip(lhs, rhs, result)) {
    if (lhsBit.kind != PermuteBitKind::Zero &&
        rhsBit.kind != PermuteBitKind::Zero)
      return std::nullopt;
    resultBit = lhsBit.kind == PermuteBitKind::Zero ? rhsBit : lhsBit;
  }
  return result;
}

static std::optional<unsigned> getShiftAmount(Value value) {
  std::optional<int64_t> amount = getMachineImmValue(value);
  if (!amount || *amount < 0 || *amount >= 32)
    return std::nullopt;
  return static_cast<unsigned>(*amount);
}

static PermuteBits shiftPermuteBits(const PermuteBits &input, unsigned amount,
                                    bool left) {
  PermuteBits result;
  for (unsigned index = 0; index < 32; ++index) {
    if (left) {
      if (index + amount < 32)
        result[index + amount] = input[index];
      continue;
    }
    if (index >= amount)
      result[index - amount] = input[index];
  }
  return result;
}

static bool isBytePermutationExpressionOp(Operation *op) {
  return isa_and_nonnull<VAddU32Op, VAdd3U32Op, VAndB32Op, VOrB32Op,
                         VLshlrevB32Op, VLshrrevB32Op, VLshlAddU32Op,
                         VAddLshlU32Op, VAndOrB32Op, VOr3B32Op>(op);
}

static std::optional<PermuteBits>
matchPermuteValue(Value value, Operation *root,
                  BytePermutationCandidate &candidate);

static std::optional<PermuteBits>
matchPermuteBinary(Value lhsValue, Value rhsValue, Operation *root,
                   BytePermutationCandidate &candidate,
                   std::optional<PermuteBits> (*combine)(const PermuteBits &,
                                                         const PermuteBits &)) {
  std::optional<PermuteBits> lhs = matchPermuteValue(lhsValue, root, candidate);
  if (!lhs)
    return std::nullopt;
  std::optional<PermuteBits> rhs = matchPermuteValue(rhsValue, root, candidate);
  if (!rhs)
    return std::nullopt;
  return combine(*lhs, *rhs);
}

static std::optional<PermuteBits>
matchPermuteShift(Value inputValue, Value amountValue, bool left,
                  Operation *root, BytePermutationCandidate &candidate) {
  std::optional<unsigned> amount = getShiftAmount(amountValue);
  if (!amount)
    return std::nullopt;
  std::optional<PermuteBits> input =
      matchPermuteValue(inputValue, root, candidate);
  if (!input)
    return std::nullopt;
  return shiftPermuteBits(*input, *amount, left);
}

static std::optional<PermuteBits>
matchAdd3Permute(VAdd3U32Op op, Operation *root,
                 BytePermutationCandidate &candidate) {
  std::optional<PermuteBits> ab =
      matchPermuteBinary(op.getA(), op.getB(), root, candidate, addPermuteBits);
  std::optional<PermuteBits> c = matchPermuteValue(op.getC(), root, candidate);
  if (!ab || !c)
    return std::nullopt;
  return addPermuteBits(*ab, *c);
}

static std::optional<PermuteBits>
matchLshlAddPermute(VLshlAddU32Op op, Operation *root,
                    BytePermutationCandidate &candidate) {
  std::optional<PermuteBits> shifted =
      matchPermuteShift(op.getA(), op.getB(), true, root, candidate);
  std::optional<PermuteBits> addend =
      matchPermuteValue(op.getC(), root, candidate);
  if (!shifted || !addend)
    return std::nullopt;
  return addPermuteBits(*shifted, *addend);
}

static std::optional<PermuteBits>
matchAddLshlPermute(VAddLshlU32Op op, Operation *root,
                    BytePermutationCandidate &candidate) {
  std::optional<PermuteBits> sum =
      matchPermuteBinary(op.getA(), op.getB(), root, candidate, addPermuteBits);
  std::optional<unsigned> amount = getShiftAmount(op.getC());
  if (!sum || !amount)
    return std::nullopt;
  return shiftPermuteBits(*sum, *amount, true);
}

static std::optional<PermuteBits>
matchAndOrPermute(VAndOrB32Op op, Operation *root,
                  BytePermutationCandidate &candidate) {
  std::optional<PermuteBits> masked =
      matchPermuteBinary(op.getA(), op.getB(), root, candidate, andPermuteBits);
  std::optional<PermuteBits> other =
      matchPermuteValue(op.getC(), root, candidate);
  if (!masked || !other)
    return std::nullopt;
  return orPermuteBits(*masked, *other);
}

static std::optional<PermuteBits>
matchOr3Permute(VOr3B32Op op, Operation *root,
                BytePermutationCandidate &candidate) {
  std::optional<PermuteBits> ab =
      matchPermuteBinary(op.getA(), op.getB(), root, candidate, orPermuteBits);
  std::optional<PermuteBits> c = matchPermuteValue(op.getC(), root, candidate);
  if (!ab || !c)
    return std::nullopt;
  return orPermuteBits(*ab, *c);
}

static std::optional<PermuteBits>
matchBasicPermuteOp(Operation *op, Operation *root,
                    BytePermutationCandidate &candidate) {
  if (VAndB32Op andOp = dyn_cast<VAndB32Op>(op))
    return matchPermuteBinary(andOp.getLhs(), andOp.getRhs(), root, candidate,
                              andPermuteBits);
  if (VOrB32Op orOp = dyn_cast<VOrB32Op>(op))
    return matchPermuteBinary(orOp.getLhs(), orOp.getRhs(), root, candidate,
                              orPermuteBits);
  if (VAddU32Op addOp = dyn_cast<VAddU32Op>(op))
    return matchPermuteBinary(addOp.getLhs(), addOp.getRhs(), root, candidate,
                              addPermuteBits);
  if (VLshlrevB32Op shiftOp = dyn_cast<VLshlrevB32Op>(op))
    return matchPermuteShift(shiftOp.getLhs(), shiftOp.getRhs(), true, root,
                             candidate);
  if (VLshrrevB32Op shiftOp = dyn_cast<VLshrrevB32Op>(op))
    return matchPermuteShift(shiftOp.getLhs(), shiftOp.getRhs(), false, root,
                             candidate);
  return std::nullopt;
}

static std::optional<PermuteBits>
matchFusedPermuteOp(Operation *op, Operation *root,
                    BytePermutationCandidate &candidate) {
  if (VAdd3U32Op addOp = dyn_cast<VAdd3U32Op>(op))
    return matchAdd3Permute(addOp, root, candidate);
  if (VLshlAddU32Op fusedOp = dyn_cast<VLshlAddU32Op>(op))
    return matchLshlAddPermute(fusedOp, root, candidate);
  if (VAddLshlU32Op fusedOp = dyn_cast<VAddLshlU32Op>(op))
    return matchAddLshlPermute(fusedOp, root, candidate);
  if (VAndOrB32Op fusedOp = dyn_cast<VAndOrB32Op>(op))
    return matchAndOrPermute(fusedOp, root, candidate);
  if (VOr3B32Op fusedOp = dyn_cast<VOr3B32Op>(op))
    return matchOr3Permute(fusedOp, root, candidate);
  return std::nullopt;
}

static std::optional<PermuteBits>
matchPermuteOp(Operation *op, Operation *root,
               BytePermutationCandidate &candidate) {
  std::optional<PermuteBits> bits;
  if (isa<VAddU32Op, VAndB32Op, VOrB32Op, VLshlrevB32Op, VLshrrevB32Op>(op))
    bits = matchBasicPermuteOp(op, root, candidate);
  else
    bits = matchFusedPermuteOp(op, root, candidate);

  if (!bits)
    return std::nullopt;
  ++candidate.instructionCount;
  if (op != root)
    candidate.deadOps.push_back(op);
  return bits;
}

static std::optional<PermuteBits>
matchPermuteValue(Value value, Operation *root,
                  BytePermutationCandidate &candidate) {
  if (std::optional<int64_t> immediate = getMachineImmValue(value))
    return getConstantPermuteBits(static_cast<uint32_t>(*immediate));

  Operation *def = value.getDefiningOp();
  if (isBytePermutationExpressionOp(def) &&
      def->getBlock() == root->getBlock() && def->getResult(0).hasOneUse()) {
    BytePermutationCandidate trial = candidate;
    if (std::optional<PermuteBits> bits = matchPermuteOp(def, root, trial)) {
      candidate = std::move(trial);
      return bits;
    }
  }

  if (!isVGPRValue(value))
    return std::nullopt;
  return getSourcePermuteBits(value);
}

static std::optional<unsigned>
getPermuteSourceIndex(Value source, BytePermutation &permutation) {
  for (auto [index, existing] : llvm::enumerate(permutation.sources))
    if (existing == source)
      return index;
  if (permutation.sources.size() == 2)
    return std::nullopt;
  permutation.sources.push_back(source);
  return permutation.sources.size() - 1;
}

static std::optional<uint8_t> getConstantByteSelector(const PermuteBits &bits,
                                                      unsigned outputByte,
                                                      PermuteBitKind kind) {
  for (unsigned bit = 1; bit < 8; ++bit)
    if (bits[outputByte * 8 + bit].kind != kind)
      return std::nullopt;
  return kind == PermuteBitKind::Zero ? uint8_t{0x0c} : uint8_t{0xff};
}

static bool matchesSourceByteBit(const PermuteBit &bit, const PermuteBit &first,
                                 unsigned offset) {
  return bit.kind == PermuteBitKind::Source && bit.source == first.source &&
         bit.sourceBit == first.sourceBit + offset;
}

static std::optional<uint8_t>
getSourceByteSelector(const PermuteBits &bits, unsigned outputByte,
                      BytePermutation &permutation) {
  const PermuteBit &first = bits[outputByte * 8];
  if (first.sourceBit % 8 != 0)
    return std::nullopt;
  for (unsigned bit = 1; bit < 8; ++bit)
    if (!matchesSourceByteBit(bits[outputByte * 8 + bit], first, bit))
      return std::nullopt;

  std::optional<unsigned> sourceIndex =
      getPermuteSourceIndex(first.source, permutation);
  if (!sourceIndex)
    return std::nullopt;
  return static_cast<uint8_t>(first.sourceBit / 8 + *sourceIndex * 4);
}

static std::optional<uint8_t>
getPermuteByteSelector(const PermuteBits &bits, unsigned outputByte,
                       BytePermutation &permutation) {
  PermuteBitKind kind = bits[outputByte * 8].kind;
  if (kind == PermuteBitKind::Source)
    return getSourceByteSelector(bits, outputByte, permutation);
  return getConstantByteSelector(bits, outputByte, kind);
}

static std::optional<BytePermutation>
getBytePermutation(const PermuteBits &bits) {
  BytePermutation permutation;
  for (unsigned outputByte = 0; outputByte < 4; ++outputByte) {
    std::optional<uint8_t> byte =
        getPermuteByteSelector(bits, outputByte, permutation);
    if (!byte)
      return std::nullopt;
    permutation.selector |= uint32_t{*byte} << (outputByte * 8);
  }
  if (permutation.sources.empty())
    return std::nullopt;
  if (permutation.sources.size() == 1 && permutation.selector == 0x03020100)
    return std::nullopt;
  return permutation;
}

static bool isInlinePermuteSelector(uint32_t selector) {
  int32_t signedSelector = static_cast<int32_t>(selector);
  return signedSelector >= -16 && signedSelector <= 64;
}

static void eraseDeadPermuteOps(PatternRewriter &rewriter,
                                ArrayRef<Operation *> ops) {
  for (Operation *op : llvm::reverse(ops))
    if (op->use_empty())
      rewriter.eraseOp(op);
}

static bool hasBytePermutationExpressionUser(Operation *op) {
  if (!op->getResult(0).hasOneUse())
    return false;
  Operation *user = *op->getResult(0).user_begin();
  if (user->getBlock() != op->getBlock())
    return false;
  return isBytePermutationExpressionOp(user);
}

static bool needsPermuteSelectorMove(uint32_t selector,
                                     const llvm::AMDGPU::IsaVersion &isa) {
  if (isInlinePermuteSelector(selector))
    return false;
  return isa.Major == 8 || isa.Major == 9;
}

static Value createPermuteSelector(PatternRewriter &rewriter, Operation *op,
                                   uint32_t selector, bool materialize) {
  int64_t signedSelector = static_cast<int32_t>(selector);
  Value value = ImmOp::create(rewriter, op->getLoc(),
                              ImmType::get(op->getContext()), signedSelector);
  if (!materialize)
    return value;
  Type sgpr1 = RegType::get(op->getContext(), RegClass::SGPR, 1, -1);
  return SMovB32ValueOp::create(rewriter, op->getLoc(), sgpr1, value);
}

static VPermB32Op createBytePermutation(PatternRewriter &rewriter,
                                        Operation *op,
                                        const BytePermutation &permutation,
                                        bool materializeSelector,
                                        const llvm::AMDGPU::IsaVersion &isa) {
  // Selector 0..3 reads src1; 4..7 reads src0.
  Value src1 = permutation.sources.front();
  Value src0 =
      permutation.sources.size() == 2 ? permutation.sources.back() : src1;
  Value selector = createPermuteSelector(rewriter, op, permutation.selector,
                                         materializeSelector);
  std::array<Value, 3> operands = {src0, src1, selector};
  assert(canCreateTernary<VPermB32Op>(operands, isa) &&
         "VGPR byte permutation must satisfy VOP3 constant-bus limits");
  return VPermB32Op::create(rewriter, op->getLoc(), op->getResult(0).getType(),
                            operands[0], operands[1], operands[2]);
}

static LogicalResult
tryFormBytePermutation(PatternRewriter &rewriter, Operation *op,
                       const llvm::AMDGPU::IsaVersion &isa) {
  if (!VPermB32Op::isSupportedOnIsa(isa))
    return failure();
  if (hasBytePermutationExpressionUser(op))
    return failure();

  BytePermutationCandidate candidate;
  std::optional<PermuteBits> bits = matchPermuteOp(op, op, candidate);
  if (!bits)
    return failure();
  std::optional<BytePermutation> permutation = getBytePermutation(*bits);
  if (!permutation)
    return failure();

  bool materializeSelector =
      needsPermuteSelectorMove(permutation->selector, isa);
  unsigned replacementCost = materializeSelector ? 2 : 1;
  if (candidate.instructionCount <= replacementCost)
    return failure();

  VPermB32Op perm = createBytePermutation(rewriter, op, *permutation,
                                          materializeSelector, isa);
  perm->setAttrs(op->getAttrs());
  rewriter.replaceOp(op, perm.getResult());
  eraseDeadPermuteOps(rewriter, candidate.deadOps);
  return success();
}

template <typename OpTy>
struct BytePermutationPattern : public OpRewritePattern<OpTy> {
  BytePermutationPattern(MLIRContext *context,
                         const llvm::AMDGPU::IsaVersion &isa)
      : OpRewritePattern<OpTy>(context, /*benefit=*/2), isa(isa) {}

  LogicalResult matchAndRewrite(OpTy op,
                                PatternRewriter &rewriter) const override {
    return tryFormBytePermutation(rewriter, op.getOperation(), isa);
  }

  llvm::AMDGPU::IsaVersion isa;
};

struct BitOp3Candidate {
  SmallVector<Operation *, 4> deadOps;
  SmallVector<Value, 3> sources;
  unsigned bitOpCount = 0;
};

static bool isBitOp3SourceOp(Operation *op) {
  return isa_and_nonnull<VAndB32Op, VOrB32Op, VXorB32Op>(op);
}

static std::optional<uint8_t> getConstantTruthTable(Value value) {
  std::optional<int64_t> imm = getMachineImmValue(value);
  if (!imm)
    return std::nullopt;
  if (*imm == 0)
    return 0;
  if (static_cast<uint32_t>(*imm) == std::numeric_limits<uint32_t>::max())
    return 0xff;
  return std::nullopt;
}

static std::optional<uint8_t> getSourceTruthTable(Value value,
                                                  BitOp3Candidate &candidate) {
  constexpr std::array<uint8_t, 3> srcBits = {0xf0, 0xcc, 0xaa};
  for (auto [index, source] : llvm::enumerate(candidate.sources))
    if (source == value)
      return srcBits[index];
  if (candidate.sources.size() == srcBits.size())
    return std::nullopt;
  uint8_t bits = srcBits[candidate.sources.size()];
  candidate.sources.push_back(value);
  return bits;
}

static std::optional<uint8_t> matchBitOp3Value(Value value, Operation *root,
                                               BitOp3Candidate &candidate);

static std::optional<uint8_t> combineBitOp3Tables(Operation *op, uint8_t lhs,
                                                  uint8_t rhs) {
  if (isa<VAndB32Op>(op))
    return lhs & rhs;
  if (isa<VOrB32Op>(op))
    return lhs | rhs;
  if (isa<VXorB32Op>(op))
    return lhs ^ rhs;
  return std::nullopt;
}

static std::optional<uint8_t> matchBitOp3Op(Operation *op, Operation *root,
                                            BitOp3Candidate &candidate) {
  if (op != root && !op->getResult(0).hasOneUse())
    return std::nullopt;

  std::optional<uint8_t> lhs =
      matchBitOp3Value(op->getOperand(0), root, candidate);
  std::optional<uint8_t> rhs =
      matchBitOp3Value(op->getOperand(1), root, candidate);
  if (!lhs || !rhs)
    return std::nullopt;

  std::optional<uint8_t> table = combineBitOp3Tables(op, *lhs, *rhs);
  if (!table)
    return std::nullopt;
  ++candidate.bitOpCount;
  if (op != root)
    candidate.deadOps.push_back(op);
  return table;
}

static std::optional<uint8_t> matchBitOp3Value(Value value, Operation *root,
                                               BitOp3Candidate &candidate) {
  if (std::optional<uint8_t> table = getConstantTruthTable(value))
    return table;

  Operation *def = value.getDefiningOp();
  if (isBitOp3SourceOp(def) && def->getBlock() == root->getBlock()) {
    BitOp3Candidate trial = candidate;
    if (std::optional<uint8_t> table = matchBitOp3Op(def, root, trial)) {
      candidate = std::move(trial);
      return table;
    }
  }

  return getSourceTruthTable(value, candidate);
}

static void eraseDeadBitOps(PatternRewriter &rewriter,
                            ArrayRef<Operation *> ops) {
  for (Operation *op : llvm::reverse(ops))
    if (op->use_empty())
      rewriter.eraseOp(op);
}

static LogicalResult tryFuseBitOp3(PatternRewriter &rewriter, Operation *op,
                                   const llvm::AMDGPU::IsaVersion &isa,
                                   unsigned minBitOps = 2) {
  if (!VBitOp3B32Op::isSupportedOnIsa(isa))
    return failure();

  BitOp3Candidate candidate;
  std::optional<uint8_t> table = matchBitOp3Op(op, op, candidate);
  if (!table || candidate.bitOpCount < minBitOps || candidate.sources.empty())
    return failure();

  rewriter.setInsertionPoint(op);
  while (candidate.sources.size() < 3) {
    Value zero = ImmOp::create(rewriter, op->getLoc(),
                               ImmType::get(op->getContext()), 0);
    candidate.sources.push_back(zero);
  }

  std::array<Value, 3> operands = {candidate.sources[0], candidate.sources[1],
                                   candidate.sources[2]};
  if (!canCreateTernary<VBitOp3B32Op>(operands, isa))
    return failure();

  VBitOp3B32Op fused = VBitOp3B32Op::create(
      rewriter, op->getLoc(), op->getResult(0).getType(), operands[0],
      operands[1], operands[2], rewriter.getI64IntegerAttr(*table));
  fused->setAttrs(op->getAttrs());
  fused->setAttr("bitop3", rewriter.getI64IntegerAttr(*table));
  rewriter.replaceOp(op, fused.getResult());
  eraseDeadBitOps(rewriter, candidate.deadOps);
  return success();
}

class DataFlowListener : public RewriterBase::Listener {
public:
  DataFlowListener(DataFlowSolver &solver) : solver(solver) {}

protected:
  void notifyOperationErased(Operation *op) override {
    solver.eraseState(solver.getProgramPointAfter(op));
    for (Value result : op->getResults())
      solver.eraseState(result);
  }

  DataFlowSolver &solver;
};

struct Mad24FusionPattern : public OpRewritePattern<VAddU32Op> {
  Mad24FusionPattern(MLIRContext *context, const llvm::AMDGPU::IsaVersion &isa,
                     DataFlowSolver &solver)
      : OpRewritePattern<VAddU32Op>(context), isa(isa), solver(solver) {}

  LogicalResult matchAndRewrite(VAddU32Op op,
                                PatternRewriter &rewriter) const override {
    if (succeeded(tryFuse(op, op.getLhs(), op.getRhs(), rewriter)))
      return success();
    return tryFuse(op, op.getRhs(), op.getLhs(), rewriter);
  }

  LogicalResult tryFuse(VAddU32Op op, Value maybeMul, Value addend,
                        PatternRewriter &rewriter) const {
    VMulLoU32Op inner = matchSingleUseProducer<VMulLoU32Op>(maybeMul, op);
    if (!inner)
      return failure();

    std::optional<ConstantIntRanges> lhs = getU32Range(solver, inner.getLhs());
    std::optional<ConstantIntRanges> rhs = getU32Range(solver, inner.getRhs());
    if (!lhs || !rhs)
      return failure();

    if (isProvenU24(*lhs) && isProvenU24(*rhs))
      return tryReplaceTernary<VMadU32U24Op>(
          rewriter, op, inner, inner.getLhs(), inner.getRhs(), addend, isa);
    if (isProvenI24(*lhs) && isProvenI24(*rhs))
      return tryReplaceTernary<VMadI32I24Op>(
          rewriter, op, inner, inner.getLhs(), inner.getRhs(), addend, isa);
    return failure();
  }

  llvm::AMDGPU::IsaVersion isa;
  DataFlowSolver &solver;
};

struct ScalarAddBaseFactorPattern : public OpRewritePattern<VAddU32Op> {
  ScalarAddBaseFactorPattern(MLIRContext *context,
                             const llvm::AMDGPU::IsaVersion &isa)
      : OpRewritePattern<VAddU32Op>(context), isa(isa) {}

  LogicalResult matchAndRewrite(VAddU32Op op,
                                PatternRewriter &rewriter) const override {
    return tryFactorScalarAddBase(rewriter, op, isa, nextLocalBaseId);
  }

  llvm::AMDGPU::IsaVersion isa;
  mutable uint64_t nextLocalBaseId = 0;
};

template <typename OpTy>
struct AddChainFactorPattern : public OpRewritePattern<OpTy> {
  AddChainFactorPattern(MLIRContext *context,
                        const llvm::AMDGPU::IsaVersion &isa)
      : OpRewritePattern<OpTy>(context), isa(isa) {}

  LogicalResult matchAndRewrite(OpTy op,
                                PatternRewriter &rewriter) const override {
    return tryFactorAddChain(rewriter, op.getOperation(), isa, nextLocalBaseId);
  }

  llvm::AMDGPU::IsaVersion isa;
  mutable uint64_t nextLocalBaseId = 0;
};

struct AddFusionPattern : public OpRewritePattern<VAddU32Op> {
  AddFusionPattern(MLIRContext *context, const llvm::AMDGPU::IsaVersion &isa)
      : OpRewritePattern<VAddU32Op>(context), isa(isa) {}

  LogicalResult matchAndRewrite(VAddU32Op op,
                                PatternRewriter &rewriter) const override {
    if (succeeded(tryFuseNestedBinary<VLshlrevB32Op, VLshlAddU32Op>(rewriter,
                                                                    op, isa)))
      return success();
    if (succeeded(
            tryFuseNestedBinary<VAddU32Op, VAdd3U32Op>(rewriter, op, isa)))
      return success();
    if (succeeded(tryFuseScalarAdd(rewriter, op, isa)))
      return success();
    if (succeeded(tryFuseNestedBinary<VXorB32Op, VXadU32Op>(rewriter, op, isa)))
      return success();

    return failure();
  }

  llvm::AMDGPU::IsaVersion isa;
};

struct M0AddFusionPattern : public OpRewritePattern<SMovM0Op> {
  M0AddFusionPattern(MLIRContext *context)
      : OpRewritePattern<SMovM0Op>(context) {}

  LogicalResult matchAndRewrite(SMovM0Op op,
                                PatternRewriter &rewriter) const override {
    SAddI32Op inner = matchDeadSCCSAddProducer(op.getSource(), op);
    if (!inner || !hasSingleM0UseBeforeClobber(op))
      return failure();

    SAddM0I32Op fused = SAddM0I32Op::create(
        rewriter, op.getLoc(), op.getResult().getType(),
        inner.getScc().getType(), inner.getLhs(), inner.getRhs());
    rewriter.replaceOp(op, fused.getM0());
    rewriter.eraseOp(inner);
    return success();
  }
};

struct LshlFusionPattern : public OpRewritePattern<VLshlrevB32Op> {
  LshlFusionPattern(MLIRContext *context, const llvm::AMDGPU::IsaVersion &isa)
      : OpRewritePattern<VLshlrevB32Op>(context), isa(isa) {}

  LogicalResult matchAndRewrite(VLshlrevB32Op op,
                                PatternRewriter &rewriter) const override {
    VAddU32Op inner = matchSingleUseProducer<VAddU32Op>(op.getLhs(), op);
    if (inner)
      return tryReplaceTernary<VAddLshlU32Op>(rewriter, op, inner,
                                              inner.getLhs(), inner.getRhs(),
                                              op.getRhs(), isa);

    return tryFuseShiftAddFanout(rewriter, op, isa);
  }

  llvm::AMDGPU::IsaVersion isa;
};

struct OrFusionPattern : public OpRewritePattern<VOrB32Op> {
  OrFusionPattern(MLIRContext *context, const llvm::AMDGPU::IsaVersion &isa)
      : OpRewritePattern<VOrB32Op>(context), isa(isa) {}

  LogicalResult matchAndRewrite(VOrB32Op op,
                                PatternRewriter &rewriter) const override {
    if (succeeded(tryFuseBitOp3(rewriter, op, isa, 3)))
      return success();
    if (succeeded(
            tryFuseNestedBinary<VAndB32Op, VAndOrB32Op>(rewriter, op, isa)))
      return success();
    if (succeeded(tryFuseNestedBinary<VOrB32Op, VOr3B32Op>(rewriter, op, isa)))
      return success();

    return tryFuseBitOp3(rewriter, op, isa);
  }

  llvm::AMDGPU::IsaVersion isa;
};

template <typename OpTy>
struct BitOp3FusionPattern : public OpRewritePattern<OpTy> {
  BitOp3FusionPattern(MLIRContext *context, const llvm::AMDGPU::IsaVersion &isa)
      : OpRewritePattern<OpTy>(context), isa(isa) {}

  LogicalResult matchAndRewrite(OpTy op,
                                PatternRewriter &rewriter) const override {
    return tryFuseBitOp3(rewriter, op.getOperation(), isa);
  }

  llvm::AMDGPU::IsaVersion isa;
};

static bool hasFusedIntCandidate(func::FuncOp func) {
  bool found = false;
  WalkResult result = func.walk([&](Operation *op) {
    if (!isa<VAddU32Op, VAdd3U32Op, VLshlrevB32Op, VLshrrevB32Op, VAndB32Op,
             VOrB32Op, VXorB32Op, VLshlAddU32Op, VAddLshlU32Op, VAndOrB32Op,
             VOr3B32Op, SMovM0Op>(op))
      return WalkResult::advance();
    found = true;
    return WalkResult::interrupt();
  });
  return result.wasInterrupted() && found;
}

static LogicalResult runOnFunc(func::FuncOp func) {
  if (!hasFusedIntCandidate(func))
    return success();

  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getAMDGPUTargetIsaVersion(func, "waveamd-form-fused-int");
  if (failed(isa))
    return failure();

  RewritePatternSet patterns(func.getContext());
  DataFlowSolver solver;
  loadBaselineAnalyses(solver);
  solver.load<IntegerRangeAnalysis>();
  if (failed(solver.initializeAndRun(func)))
    return func.emitError("IntegerRangeAnalysis failed for fused-int pass");

  patterns.add<Mad24FusionPattern>(func.getContext(), *isa, solver);
  patterns.add<M0AddFusionPattern>(func.getContext());
  patterns.add<ScalarAddBaseFactorPattern>(func.getContext(), *isa);
  patterns
      .add<AddChainFactorPattern<VAddU32Op>, AddChainFactorPattern<VAdd3U32Op>>(
          func.getContext(), *isa);
  patterns.add<
      BytePermutationPattern<VAddU32Op>, BytePermutationPattern<VAdd3U32Op>,
      BytePermutationPattern<VAndB32Op>, BytePermutationPattern<VOrB32Op>,
      BytePermutationPattern<VLshlrevB32Op>,
      BytePermutationPattern<VLshrrevB32Op>,
      BytePermutationPattern<VLshlAddU32Op>,
      BytePermutationPattern<VAddLshlU32Op>,
      BytePermutationPattern<VAndOrB32Op>, BytePermutationPattern<VOr3B32Op>>(
      func.getContext(), *isa);
  patterns.add<AddFusionPattern, LshlFusionPattern, OrFusionPattern>(
      func.getContext(), *isa);
  patterns.add<BitOp3FusionPattern<VAndB32Op>, BitOp3FusionPattern<VXorB32Op>>(
      func.getContext(), *isa);
  DataFlowListener listener(solver);
  return applyPatternsGreedily(
      func, std::move(patterns),
      GreedyRewriteConfig()
          .enableFolding(false)
          .setRegionSimplificationLevel(GreedySimplifyRegionLevel::Disabled)
          .setListener(&listener));
}

struct WaveAMDFormFusedIntPass
    : public wave::impl::WaveAMDFormFusedIntBase<WaveAMDFormFusedIntPass> {
  void runOnOperation() override {
    WalkResult result = getOperation()->walk([&](func::FuncOp func) {
      if (failed(runOnFunc(func)))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if (result.wasInterrupted())
      return signalPassFailure();
  }
};

} // namespace
