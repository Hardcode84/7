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
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/Support/MathExtras.h"

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

struct PackedMathCapabilities {
  bool packedF16Math = true;
  bool packedF32ToF16Rtz = true;
  bool packedF32ToF16Rne = false;
};

static bool isScalarSimdF16(Type type) {
  SimdType simd = dyn_cast<SimdType>(type);
  return simd && simd.getElementType().isF16();
}

static bool isScalarSimdF32(Type type) {
  SimdType simd = dyn_cast<SimdType>(type);
  return simd && simd.getElementType().isF32();
}

static Type getPackedSimdType(Type scalarSimdType, int64_t elements = 2) {
  SimdType simd = cast<SimdType>(scalarSimdType);
  VectorType vectorType = VectorType::get({elements}, simd.getElementType());
  return SimdType::get(scalarSimdType.getContext(), vectorType,
                       simd.getWidth());
}

static std::optional<int64_t> getPackedF16SimdElements(Type type) {
  SimdType simd = dyn_cast<SimdType>(type);
  if (!simd)
    return std::nullopt;
  VectorType vectorType = dyn_cast<VectorType>(simd.getElementType());
  if (!vectorType || vectorType.getRank() != 1 || vectorType.isScalable())
    return std::nullopt;
  if (!vectorType.getElementType().isF16())
    return std::nullopt;
  int64_t elements = vectorType.getNumElements();
  if (!llvm::isPowerOf2_64(elements))
    return std::nullopt;
  return elements;
}

static bool isF32ToF16Cast(CastOp op) {
  return op.getKind() == CastKind::FpConvert &&
         isScalarSimdF32(op.getSource().getType()) &&
         isScalarSimdF16(op.getResult().getType());
}

static CastRounding getFpConvertRounding(CastOp op) {
  std::optional<DictionaryAttr> policy = op.getPolicy();
  if (!policy)
    return CastRounding::RNE;
  Attribute attr = policy->get("rounding");
  if (!attr)
    return CastRounding::RNE;
  return cast<CastRoundingPolicyAttr>(attr).getValue();
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

static bool isCandidateSupported(Operation *op,
                                 const PackedMathCapabilities &capabilities) {
  std::optional<PairKind> kind = getCandidateKind(op);
  if (!kind)
    return false;
  if (*kind == PairKind::Cast) {
    CastRounding rounding = getFpConvertRounding(cast<CastOp>(op));
    if (rounding == CastRounding::RTZ)
      return capabilities.packedF32ToF16Rtz;
    if (rounding == CastRounding::RNE)
      return capabilities.packedF32ToF16Rne;
    return false;
  }
  return capabilities.packedF16Math;
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

static FailureOr<PackedMathCapabilities>
getPackedMathCapabilities(Operation *op) {
  if (!waveamdmachine::findAMDGPUTargetModule(op))
    return PackedMathCapabilities{};

  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      waveamdmachine::getAMDGPUTargetIsaVersion(op, "wave-form-packed-math");
  if (failed(isa))
    return failure();

  PackedMathCapabilities capabilities;
  capabilities.packedF16Math =
      waveamdmachine::VPkAddF16Op::isSupportedOnIsa(*isa) &&
      waveamdmachine::VPkMulF16Op::isSupportedOnIsa(*isa) &&
      waveamdmachine::VPkFmaF16Op::isSupportedOnIsa(*isa);
  capabilities.packedF32ToF16Rtz =
      waveamdmachine::VCvtPkRtzF16F32Op::isSupportedOnIsa(*isa);
  capabilities.packedF32ToF16Rne =
      waveamdmachine::VCvtPkF16F32Op::isSupportedOnIsa(*isa);
  return capabilities;
}

class PackedMathBuilder {
public:
  PackedMathBuilder(func::FuncOp func, PackedMathCapabilities capabilities)
      : builder(func.getContext()), capabilities(capabilities) {}

  bool runOnBlock(Block &block) {
    formPackedCastPackUsers(block);

    SmallVector<Operation *, 16> candidates;
    for (Operation &op : block)
      if (isCandidateSupported(&op, capabilities))
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
  bool canFormPackedPair(Operation *lo, Operation *hi) {
    return compatiblePair(lo, hi) && independentPair(lo, hi) &&
           isCandidateSupported(lo, capabilities) &&
           isCandidateSupported(hi, capabilities);
  }

  bool canVectorizeRootPair(Operation *lo, Operation *hi) {
    if (!canFormPackedPair(lo, hi))
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
    return canFormPackedPair(loDef, hiDef) ? 1 : 0;
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
        !vectorizedOps.contains(hiDef) && canFormPackedPair(loDef, hiDef)) {
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

  std::optional<SmallVector<CastOp, 8>> getPackCastInputs(PackOp pack) {
    std::optional<int64_t> elements =
        getPackedF16SimdElements(pack.getResult().getType());
    if (!elements || *elements != static_cast<int64_t>(pack.getInputs().size()))
      return std::nullopt;

    SmallVector<CastOp, 8> casts;
    casts.reserve(pack.getInputs().size());
    for (Value input : pack.getInputs()) {
      CastOp castOp = input.getDefiningOp<CastOp>();
      if (!castOp || castOp->getBlock() != pack->getBlock())
        return std::nullopt;
      if (!isCandidateSupported(castOp, capabilities))
        return std::nullopt;
      if (!casts.empty() && !compatibleCastPair(casts.front(), castOp))
        return std::nullopt;
      casts.push_back(castOp);
    }
    return casts;
  }

  void replacePackedCastPack(PackOp pack, ArrayRef<CastOp> casts) {
    SmallVector<Value, 8> sources;
    sources.reserve(casts.size());
    for (CastOp castOp : casts)
      sources.push_back(castOp.getSource());

    builder.setInsertionPoint(pack);
    CastOp firstCast = casts.front();
    Type sourceType =
        getPackedSimdType(firstCast.getSource().getType(), casts.size());
    Value sourcePack =
        PackOp::create(builder, pack.getLoc(), sourceType, sources).getResult();
    Value packed =
        CastOp::create(builder, pack.getLoc(), pack.getResult().getType(),
                       CastKind::FpConvert, sourcePack,
                       firstCast.getPolicyAttr())
            .getResult();
    pack.getResult().replaceAllUsesWith(packed);
    pack.erase();

    SmallPtrSet<Operation *, 8> seen;
    for (CastOp castOp : casts)
      if (seen.insert(castOp).second && castOp->use_empty())
        castOp.erase();
    changed = true;
  }

  void formPackedCastPackUsers(Block &block) {
    SmallVector<std::pair<PackOp, SmallVector<CastOp, 8>>, 8> rewrites;
    for (Operation &op : block) {
      PackOp pack = dyn_cast<PackOp>(&op);
      if (!pack)
        continue;
      std::optional<SmallVector<CastOp, 8>> casts = getPackCastInputs(pack);
      if (casts)
        rewrites.push_back({pack, std::move(*casts)});
    }

    for (auto &[pack, casts] : rewrites)
      replacePackedCastPack(pack, casts);
  }

  void replacePackedRebuildUsers(PackedPair pair) {
    SmallVector<PackOp, 4> packUsers;
    for (OpOperand &use : pair.lo.getUses()) {
      PackOp pack = dyn_cast<PackOp>(use.getOwner());
      if (!pack || use.getOperandNumber() != 0)
        continue;
      if (pack.getInputs().size() != 2 || pack.getInputs()[1] != pair.hi)
        continue;
      if (pack.getResult().getType() != pair.packed.getType())
        continue;
      if (!canUsePackedValueBefore(pair.packed, pack))
        continue;
      packUsers.push_back(pack);
    }

    for (PackOp pack : packUsers) {
      pack.getResult().replaceAllUsesWith(pair.packed);
      vectorizedOps.insert(pack);
      eraseOps.push_back(pack);
      changed = true;
    }
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
    for (PackedPair pair : packedPairs)
      replacePackedRebuildUsers(pair);
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
  PackedMathCapabilities capabilities;
  bool changed = false;
};

struct WaveFormPackedMathPass
    : public wave::impl::WaveFormPackedMathBase<WaveFormPackedMathPass> {
  using WaveFormPackedMathBase::WaveFormPackedMathBase;

  void runOnOperation() override {
    Operation *root = getOperation();
    WalkResult result = root->walk([&](func::FuncOp func) -> WalkResult {
      if (func.isExternal())
        return WalkResult::advance();
      FailureOr<PackedMathCapabilities> capabilities =
          getPackedMathCapabilities(func);
      if (failed(capabilities))
        return WalkResult::interrupt();

      SmallVector<Block *, 16> blocks;
      func.walk([&](Operation *op) {
        for (Region &region : op->getRegions())
          for (Block &block : region)
            blocks.push_back(&block);
      });
      for (Block *block : blocks) {
        PackedMathBuilder packedMath(func, *capabilities);
        (void)packedMath.runOnBlock(*block);
      }
      return WalkResult::advance();
    });
    if (result.wasInterrupted())
      return signalPassFailure();
  }
};

} // namespace
