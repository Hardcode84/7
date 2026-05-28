//===- WaveFormPackedMath.cpp - Pack scalar Wave math pairs ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"

#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEFORMPACKEDMATH
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

enum class PairKind {
  Cast,
  FAdd,
  FMul,
  Fma,
};

struct PackedPair {
  Value lo;
  Value hi;
  Value packed;
};

static bool isScalarSimdF16(Type type) {
  SimdType simd = dyn_cast<SimdType>(type);
  return simd && simd.getElementType().isF16();
}

static bool isScalarSimdF32(Type type) {
  SimdType simd = dyn_cast<SimdType>(type);
  return simd && simd.getElementType().isF32();
}

static Type getPackedSimdType(Type scalarSimdType) {
  SimdType simd = cast<SimdType>(scalarSimdType);
  VectorType vectorType = VectorType::get({2}, simd.getElementType());
  return SimdType::get(scalarSimdType.getContext(), vectorType,
                       simd.getWidth());
}

static bool isF32ToF16Cast(CastOp op) {
  return op.getKind() == CastKind::FpConvert &&
         isScalarSimdF32(op.getSource().getType()) &&
         isScalarSimdF16(op.getResult().getType());
}

static std::optional<PairKind> getFloatMathKind(Operation *op) {
  if (op->getNumResults() == 0 || !isScalarSimdF16(op->getResult(0).getType()))
    return std::nullopt;
  if (isa<FAddOp>(op))
    return PairKind::FAdd;
  if (isa<FMulOp>(op))
    return PairKind::FMul;
  if (isa<FmaOp>(op))
    return PairKind::Fma;
  return std::nullopt;
}

static std::optional<PairKind> getCandidateKind(Operation *op) {
  if (CastOp castOp = dyn_cast<CastOp>(op)) {
    if (isF32ToF16Cast(castOp))
      return PairKind::Cast;
    return std::nullopt;
  }
  return getFloatMathKind(op);
}

static bool isCommutative(PairKind kind) {
  return kind == PairKind::FAdd || kind == PairKind::FMul;
}

static bool dependsOn(Value value, Operation *needle,
                      SmallPtrSetImpl<Operation *> &seen) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return false;
  if (def == needle)
    return true;
  if (def->getBlock() != needle->getBlock())
    return false;
  if (!seen.insert(def).second)
    return false;
  for (Value operand : def->getOperands())
    if (dependsOn(operand, needle, seen))
      return true;
  return false;
}

static bool dependsOn(Operation *op, Operation *needle) {
  SmallPtrSet<Operation *, 16> seen;
  for (Value operand : op->getOperands())
    if (dependsOn(operand, needle, seen))
      return true;
  return false;
}

static Operation *laterOp(Operation *lhs, Operation *rhs) {
  assert(lhs->getBlock() == rhs->getBlock() && "expected same-block ops");
  return lhs->isBeforeInBlock(rhs) ? rhs : lhs;
}

static bool compatibleCastPair(CastOp lo, CastOp hi) {
  return lo.getSource().getType() == hi.getSource().getType() &&
         lo.getResult().getType() == hi.getResult().getType() &&
         lo.getPolicyAttr() == hi.getPolicyAttr();
}

static bool compatiblePair(Operation *lo, Operation *hi) {
  if (lo == hi || lo->getBlock() != hi->getBlock())
    return false;
  std::optional<PairKind> loKind = getCandidateKind(lo);
  std::optional<PairKind> hiKind = getCandidateKind(hi);
  if (!loKind || !hiKind || *loKind != *hiKind)
    return false;
  if (lo->getResult(0).getType() != hi->getResult(0).getType())
    return false;
  if (auto loCast = dyn_cast<CastOp>(lo))
    return compatibleCastPair(loCast, cast<CastOp>(hi));
  return true;
}

static bool independentPair(Operation *lo, Operation *hi) {
  return !dependsOn(lo, hi) && !dependsOn(hi, lo);
}

class PackedMathBuilder {
public:
  PackedMathBuilder(func::FuncOp func) : builder(func.getContext()) {}

  bool runOnBlock(Block &block) {
    SmallVector<Operation *, 16> candidates;
    for (Operation &op : block)
      if (getCandidateKind(&op))
        candidates.push_back(&op);

    for (auto [index, op] : llvm::enumerate(candidates)) {
      if (vectorizedOps.contains(op))
        continue;
      for (Operation *other : llvm::drop_begin(candidates, index + 1)) {
        if (vectorizedOps.contains(other))
          continue;
        if (!canVectorizeRootPair(op, other))
          continue;
        (void)getOrCreatePackedOp(op, other);
        break;
      }
    }

    replaceScalarUsers();
    eraseDeadScalarOps();
    return changed;
  }

private:
  bool canVectorizeRootPair(Operation *lo, Operation *hi) {
    if (!compatiblePair(lo, hi) || !independentPair(lo, hi))
      return false;
    if (lo->getResult(0).use_empty() && hi->getResult(0).use_empty())
      return false;
    Operation *insertBefore = laterOp(lo, hi);
    return allUsersReachableFromPack(lo->getResult(0), insertBefore, lo, hi) &&
           allUsersReachableFromPack(hi->getResult(0), insertBefore, lo, hi);
  }

  bool allUsersReachableFromPack(Value value, Operation *insertBefore,
                                 Operation *lo, Operation *hi) {
    for (OpOperand &use : value.getUses()) {
      Operation *owner = use.getOwner();
      if (owner == lo || owner == hi || vectorizedOps.contains(owner))
        continue;
      if (owner->getBlock() != insertBefore->getBlock())
        return false;
      if (!insertBefore->isBeforeInBlock(owner))
        return false;
    }
    return true;
  }

  unsigned scoreValuePair(Value lo, Value hi) {
    if (packedValueForPair.lookup({lo, hi}))
      return 4;
    Operation *loDef = lo.getDefiningOp();
    Operation *hiDef = hi.getDefiningOp();
    if (!loDef || !hiDef)
      return 0;
    return compatiblePair(loDef, hiDef) && independentPair(loDef, hiDef) ? 1
                                                                         : 0;
  }

  SmallVector<std::pair<Value, Value>, 3> chooseOperandPairs(Operation *lo,
                                                             Operation *hi) {
    SmallVector<std::pair<Value, Value>, 3> direct;
    for (auto [loOperand, hiOperand] :
         llvm::zip(lo->getOperands(), hi->getOperands()))
      direct.push_back({loOperand, hiOperand});

    std::optional<PairKind> kind = getCandidateKind(lo);
    if (!kind || !isCommutative(*kind) || lo->getNumOperands() != 2)
      return direct;

    SmallVector<std::pair<Value, Value>, 3> swapped = {
        {lo->getOperand(0), hi->getOperand(1)},
        {lo->getOperand(1), hi->getOperand(0)}};
    unsigned directScore = scoreValuePair(direct[0].first, direct[0].second) +
                           scoreValuePair(direct[1].first, direct[1].second);
    unsigned swappedScore =
        scoreValuePair(swapped[0].first, swapped[0].second) +
        scoreValuePair(swapped[1].first, swapped[1].second);
    return swappedScore > directScore ? swapped : direct;
  }

  Value getOrCreatePackedValue(Value lo, Value hi, Operation *insertBefore) {
    std::pair<Value, Value> key{lo, hi};
    if (Value cached = packedValueForPair.lookup(key))
      return cached;

    Operation *loDef = lo.getDefiningOp();
    Operation *hiDef = hi.getDefiningOp();
    if (loDef && hiDef && !vectorizedOps.contains(loDef) &&
        !vectorizedOps.contains(hiDef) && compatiblePair(loDef, hiDef) &&
        independentPair(loDef, hiDef)) {
      Value packed = getOrCreatePackedOp(loDef, hiDef);
      packedValueForPair[key] = packed;
      return packed;
    }

    builder.setInsertionPoint(insertBefore);
    Type packedType = getPackedSimdType(lo.getType());
    Value packed = PackOp::create(builder, insertBefore->getLoc(), packedType,
                                  ValueRange{lo, hi})
                       .getResult();
    packedValueForPair[key] = packed;
    changed = true;
    return packed;
  }

  Value getOrCreatePackedOp(Operation *lo, Operation *hi) {
    std::pair<Value, Value> key{lo->getResult(0), hi->getResult(0)};
    if (Value cached = packedValueForPair.lookup(key))
      return cached;

    Operation *insertBefore = laterOp(lo, hi);
    SmallVector<std::pair<Value, Value>, 3> operandPairs =
        chooseOperandPairs(lo, hi);
    SmallVector<Value, 3> packedOperands;
    for (std::pair<Value, Value> operands : operandPairs)
      packedOperands.push_back(getOrCreatePackedValue(
          operands.first, operands.second, insertBefore));

    builder.setInsertionPoint(insertBefore);
    Type packedType = getPackedSimdType(lo->getResult(0).getType());
    Value packed = createPackedOp(lo, packedType, packedOperands);
    packedValueForPair[key] = packed;
    packedPairs.push_back({lo->getResult(0), hi->getResult(0), packed});
    vectorizedOps.insert(lo);
    vectorizedOps.insert(hi);
    eraseOps.push_back(lo);
    eraseOps.push_back(hi);
    changed = true;
    return packed;
  }

  Value createPackedOp(Operation *op, Type packedType,
                       ArrayRef<Value> packedOperands) {
    Location loc = op->getLoc();
    if (auto castOp = dyn_cast<CastOp>(op))
      return CastOp::create(builder, loc, packedType, CastKind::FpConvert,
                            packedOperands[0], castOp.getPolicyAttr())
          .getResult();
    if (isa<FAddOp>(op))
      return FAddOp::create(builder, loc, packedType, packedOperands[0],
                            packedOperands[1])
          .getResult();
    if (isa<FMulOp>(op))
      return FMulOp::create(builder, loc, packedType, packedOperands[0],
                            packedOperands[1])
          .getResult();
    return FmaOp::create(builder, loc, packedType, packedOperands[0],
                         packedOperands[1], packedOperands[2])
        .getResult();
  }

  bool canUsePackedValueBefore(Value packed, Operation *user) {
    Operation *def = packed.getDefiningOp();
    return def && def->getBlock() == user->getBlock() &&
           def->isBeforeInBlock(user);
  }

  void replaceLaneUses(Value scalar, Value packed, unsigned lane) {
    for (OpOperand &use : llvm::make_early_inc_range(scalar.getUses())) {
      Operation *owner = use.getOwner();
      if (vectorizedOps.contains(owner))
        continue;
      if (!canUsePackedValueBefore(packed, owner))
        continue;
      builder.setInsertionPoint(owner);
      Value extracted = ExtractOp::create(builder, owner->getLoc(),
                                          scalar.getType(), packed, lane)
                            .getResult();
      use.set(extracted);
      changed = true;
    }
  }

  void replaceScalarUsers() {
    for (PackedPair pair : packedPairs) {
      replaceLaneUses(pair.lo, pair.packed, 0);
      replaceLaneUses(pair.hi, pair.packed, 1);
    }
  }

  void eraseDeadScalarOps() {
    for (Operation *op : llvm::reverse(eraseOps))
      if (op->use_empty())
        op->erase();
  }

  OpBuilder builder;
  DenseMap<std::pair<Value, Value>, Value> packedValueForPair;
  SmallVector<PackedPair, 16> packedPairs;
  DenseSet<Operation *> vectorizedOps;
  SmallVector<Operation *, 16> eraseOps;
  bool changed = false;
};

struct WaveFormPackedMathPass
    : public wave::impl::WaveFormPackedMathBase<WaveFormPackedMathPass> {
  using WaveFormPackedMathBase::WaveFormPackedMathBase;

  void runOnOperation() override {
    Operation *root = getOperation();
    root->walk([&](func::FuncOp func) {
      if (func.isExternal())
        return;
      SmallVector<Block *, 16> blocks;
      func.walk([&](Operation *op) {
        for (Region &region : op->getRegions())
          for (Block &block : region)
            blocks.push_back(&block);
      });
      for (Block *block : blocks) {
        PackedMathBuilder packedMath(func);
        (void)packedMath.runOnBlock(*block);
      }
    });
  }
};

} // namespace
