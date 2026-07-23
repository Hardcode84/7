//===- WaveAMDCrossLanePeepholes.cpp - Cross-lane peepholes ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "SIDefines.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/TypeSwitch.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDCROSSLANEPEEPHOLES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamdmachine;

namespace {

enum class PermlaneHalf : uint8_t { Lower, Upper };

class MachineU32Evaluator {
public:
  MachineU32Evaluator(uint32_t lane, uint32_t workitemX)
      : lane(lane), workitemX(workitemX) {}

  std::optional<uint32_t> evaluate(Value value) {
    DenseMap<Value, uint32_t>::iterator cached = values.find(value);
    if (cached != values.end())
      return cached->second;

    Operation *op = value.getDefiningOp();
    if (!op)
      return std::nullopt;

    std::optional<uint32_t> result = evaluateOperation(op);
    if (result)
      values[value] = *result;
    return result;
  }

private:
  std::optional<uint32_t> evaluateOperation(Operation *op) {
    return llvm::TypeSwitch<Operation *, std::optional<uint32_t>>(op)
        .Case<ImmOp>(
            [](ImmOp imm) { return static_cast<uint32_t>(imm.getValue()); })
        .Case<VWorkitemIdXOp>([&](VWorkitemIdXOp) { return workitemX; })
        .Case<VMbcntLoOp>(
            [&](VMbcntLoOp) { return std::min(lane, uint32_t{32}); })
        .Case<VMbcntHiOp>([&](VMbcntHiOp hi) {
          std::optional<uint32_t> low = evaluate(hi.getSource());
          if (!low)
            return std::optional<uint32_t>();
          return std::optional<uint32_t>(*low + (lane >= 32 ? lane - 32 : 0));
        })
        .Case<SMovB32ValueOp>(
            [&](SMovB32ValueOp move) { return evaluate(move.getSource()); })
        .Case<VAddU32Op>([&](VAddU32Op add) {
          return evaluateBinary(
              add.getLhs(), add.getRhs(),
              [](uint32_t lhs, uint32_t rhs) { return lhs + rhs; });
        })
        .Case<VAndB32Op>([&](VAndB32Op bitAnd) {
          return evaluateBinary(
              bitAnd.getLhs(), bitAnd.getRhs(),
              [](uint32_t lhs, uint32_t rhs) { return lhs & rhs; });
        })
        .Case<VOrB32Op>([&](VOrB32Op bitOr) {
          return evaluateBinary(
              bitOr.getLhs(), bitOr.getRhs(),
              [](uint32_t lhs, uint32_t rhs) { return lhs | rhs; });
        })
        .Case<VXorB32Op>([&](VXorB32Op bitXor) {
          return evaluateBinary(
              bitXor.getLhs(), bitXor.getRhs(),
              [](uint32_t lhs, uint32_t rhs) { return lhs ^ rhs; });
        })
        .Case<VLshlrevB32Op>([&](VLshlrevB32Op shift) {
          return evaluateShift(shift.getLhs(), shift.getRhs(), true);
        })
        .Case<VLshrrevB32Op>([&](VLshrrevB32Op shift) {
          return evaluateShift(shift.getLhs(), shift.getRhs(), false);
        })
        .Default(
            [&](Operation *nested) { return evaluateFusedOperation(nested); });
  }

  std::optional<uint32_t> evaluateFusedOperation(Operation *op) {
    return llvm::TypeSwitch<Operation *, std::optional<uint32_t>>(op)
        .Case<VAdd3U32Op>([&](VAdd3U32Op add) {
          return evaluateTernary(add.getA(), add.getB(), add.getC(),
                                 [](uint32_t a, uint32_t b, uint32_t c) {
                                   return std::optional<uint32_t>(a + b + c);
                                 });
        })
        .Case<VLshlAddU32Op>([&](VLshlAddU32Op shift) {
          return evaluateTernary(
              shift.getA(), shift.getB(), shift.getC(),
              [](uint32_t value, uint32_t amount, uint32_t addend) {
                if (amount >= 32)
                  return std::optional<uint32_t>();
                return std::optional<uint32_t>((value << amount) + addend);
              });
        })
        .Case<VAddLshlU32Op>([&](VAddLshlU32Op shift) {
          return evaluateTernary(shift.getA(), shift.getB(), shift.getC(),
                                 [](uint32_t a, uint32_t b, uint32_t amount) {
                                   if (amount >= 32)
                                     return std::optional<uint32_t>();
                                   return std::optional<uint32_t>((a + b)
                                                                  << amount);
                                 });
        })
        .Case<VAndOrB32Op>([&](VAndOrB32Op bitop) {
          return evaluateTernary(bitop.getA(), bitop.getB(), bitop.getC(),
                                 [](uint32_t a, uint32_t b, uint32_t c) {
                                   return std::optional<uint32_t>((a & b) | c);
                                 });
        })
        .Case<VOr3B32Op>([&](VOr3B32Op bitop) {
          return evaluateTernary(bitop.getA(), bitop.getB(), bitop.getC(),
                                 [](uint32_t a, uint32_t b, uint32_t c) {
                                   return std::optional<uint32_t>(a | b | c);
                                 });
        })
        .Case<VXadU32Op>([&](VXadU32Op xad) {
          return evaluateTernary(xad.getA(), xad.getB(), xad.getC(),
                                 [](uint32_t a, uint32_t b, uint32_t c) {
                                   return std::optional<uint32_t>((a ^ b) + c);
                                 });
        })
        .Case<VBitOp3B32Op>(
            [&](VBitOp3B32Op bitop) { return evaluateBitop3(bitop); })
        .Default([](Operation *) { return std::optional<uint32_t>(); });
  }

  template <typename Fn>
  std::optional<uint32_t> evaluateBinary(Value lhsValue, Value rhsValue,
                                         Fn combine) {
    std::optional<uint32_t> lhs = evaluate(lhsValue);
    std::optional<uint32_t> rhs = evaluate(rhsValue);
    if (!lhs || !rhs)
      return std::nullopt;
    return combine(*lhs, *rhs);
  }

  template <typename Fn>
  std::optional<uint32_t> evaluateTernary(Value aValue, Value bValue,
                                          Value cValue, Fn combine) {
    std::optional<uint32_t> a = evaluate(aValue);
    std::optional<uint32_t> b = evaluate(bValue);
    std::optional<uint32_t> c = evaluate(cValue);
    if (!a || !b || !c)
      return std::nullopt;
    return combine(*a, *b, *c);
  }

  std::optional<uint32_t> evaluateShift(Value value, Value amount, bool left) {
    return evaluateBinary(value, amount,
                          [left](uint32_t input, uint32_t shift) {
                            if (shift >= 32)
                              return std::optional<uint32_t>();
                            return std::optional<uint32_t>(
                                left ? input << shift : input >> shift);
                          });
  }

  std::optional<uint32_t> evaluateBitop3(VBitOp3B32Op op) {
    if (op.getBitop3() != 0x96)
      return std::nullopt;
    return evaluateTernary(op.getA(), op.getB(), op.getC(),
                           [](uint32_t a, uint32_t b, uint32_t c) {
                             return std::optional<uint32_t>(a ^ b ^ c);
                           });
  }

  DenseMap<Value, uint32_t> values;
  uint32_t lane;
  uint32_t workitemX;
};

struct BpermutePayload {
  SmallVector<DsBpermuteB32Op> permutes;
  SmallVector<Value> words;
  TupleFromElementsOp tuple;
  Value address;
};

struct PermlaneCandidate {
  BpermutePayload falsePayload;
  BpermutePayload truePayload;
  SmallVector<Value> firstWords;
  SmallVector<Value> secondWords;
  VCndmaskB32TupleOp select;
  PermlaneHalf half;
};

static std::optional<int64_t> getImmediate(Value value) {
  ImmOp imm = value.getDefiningOp<ImmOp>();
  if (!imm)
    return std::nullopt;
  return imm.getValue();
}

static bool sameValues(ArrayRef<Value> lhs, ArrayRef<Value> rhs) {
  if (lhs.size() != rhs.size())
    return false;
  for (auto [left, right] : llvm::zip_equal(lhs, rhs))
    if (left != right)
      return false;
  return true;
}

static std::optional<unsigned> getXLinearWorkgroupSize(func::FuncOp func) {
  DenseI32ArrayAttr shape;
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    shape = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (shape)
      break;
  }
  if (!shape)
    return std::nullopt;
  ArrayRef<int32_t> dims = shape.asArrayRef();
  if (dims.size() != 3 || dims[0] <= 0 || dims[0] % 64 != 0 || dims[1] != 1 ||
      dims[2] != 1)
    return std::nullopt;
  return static_cast<unsigned>(dims[0]);
}

static std::optional<bool> evaluateCondition(Value condition, uint32_t lane,
                                             uint32_t workitemX) {
  MachineU32Evaluator evaluator(lane, workitemX);
  if (VCmpEqU32VccOp compare = condition.getDefiningOp<VCmpEqU32VccOp>()) {
    if (condition != compare.getResult())
      return std::nullopt;
    std::optional<uint32_t> lhs = evaluator.evaluate(compare.getLhs());
    std::optional<uint32_t> rhs = evaluator.evaluate(compare.getRhs());
    if (lhs && rhs)
      return *lhs == *rhs;
  }
  return std::nullopt;
}

static LogicalResult appendBpermuteWord(BpermutePayload &payload, Value word) {
  DsBpermuteB32Op permute = word.getDefiningOp<DsBpermuteB32Op>();
  if (!permute || permute.getOffset() != 0)
    return failure();
  if (payload.address && permute.getAddr() != payload.address)
    return failure();
  payload.address = permute.getAddr();
  payload.permutes.push_back(permute);
  payload.words.push_back(permute.getData());
  return success();
}

static bool isVGPRWord(Value value) {
  RegType type = dyn_cast<RegType>(value.getType());
  return type && type.getRegClass() == RegClass::VGPR && type.getWidth() == 1;
}

static std::optional<BpermutePayload> matchBpermuteTuplePayload(Value value,
                                                                int64_t width) {
  TupleFromElementsOp tuple = value.getDefiningOp<TupleFromElementsOp>();
  if (!tuple || tuple.getElements().size() != static_cast<size_t>(width))
    return std::nullopt;

  BpermutePayload payload;
  payload.tuple = tuple;
  for (Value element : tuple.getElements())
    if (!isVGPRWord(element) || failed(appendBpermuteWord(payload, element)))
      return std::nullopt;
  return payload;
}

static std::optional<BpermutePayload> matchBpermutePayload(Value value) {
  RegType type = dyn_cast<RegType>(value.getType());
  if (!type || type.getRegClass() != RegClass::VGPR)
    return std::nullopt;

  BpermutePayload payload;
  if (type.getWidth() == 1) {
    if (failed(appendBpermuteWord(payload, value)))
      return std::nullopt;
    return payload;
  }

  return matchBpermuteTuplePayload(value, type.getWidth());
}

static std::optional<std::pair<bool, unsigned>>
evaluateSelectedSource(PermlaneCandidate &candidate, uint32_t lane,
                       uint32_t workitemX) {
  std::optional<bool> takeTrue =
      evaluateCondition(candidate.select.getCondition(), lane, workitemX);
  if (!takeTrue)
    return std::nullopt;
  const BpermutePayload &payload =
      *takeTrue ? candidate.truePayload : candidate.falsePayload;
  MachineU32Evaluator evaluator(lane, workitemX);
  std::optional<uint32_t> byteAddress = evaluator.evaluate(payload.address);
  if (!byteAddress || *byteAddress % 4 != 0 || *byteAddress / 4 >= 64)
    return std::nullopt;
  return std::pair<bool, unsigned>{*takeTrue,
                                   static_cast<unsigned>(*byteAddress / 4)};
}

static ArrayRef<Value> getSelectedWords(const PermlaneCandidate &candidate,
                                        bool takeTrue) {
  return takeTrue ? ArrayRef<Value>(candidate.truePayload.words)
                  : ArrayRef<Value>(candidate.falsePayload.words);
}

static std::optional<PermlaneCandidate>
makePermlaneCandidate(VCndmaskB32TupleOp select) {
  std::optional<BpermutePayload> falsePayload =
      matchBpermutePayload(select.getFalseValue());
  std::optional<BpermutePayload> truePayload =
      matchBpermutePayload(select.getTrueValue());
  if (!falsePayload || !truePayload ||
      falsePayload->words.size() != truePayload->words.size() ||
      sameValues(falsePayload->words, truePayload->words))
    return std::nullopt;

  return PermlaneCandidate{
      std::move(*falsePayload), std::move(*truePayload), {}, {}, select,
      PermlaneHalf::Lower};
}

static std::optional<PermlaneHalf>
classifyPermlaneCandidate(PermlaneCandidate &candidate) {
  std::optional<std::pair<bool, unsigned>> first =
      evaluateSelectedSource(candidate, /*lane=*/0, /*workitemX=*/0);
  std::optional<std::pair<bool, unsigned>> second =
      evaluateSelectedSource(candidate, /*lane=*/32, /*workitemX=*/32);
  if (!first || !second)
    return std::nullopt;
  ArrayRef<Value> firstWords = getSelectedWords(candidate, first->first);
  ArrayRef<Value> secondWords = getSelectedWords(candidate, second->first);
  candidate.firstWords.assign(firstWords.begin(), firstWords.end());
  candidate.secondWords.assign(secondWords.begin(), secondWords.end());
  if (sameValues(candidate.firstWords, candidate.secondWords))
    return std::nullopt;
  if (first->second == 0 && second->second == 0)
    return PermlaneHalf::Lower;
  if (first->second == 32 && second->second == 32)
    return PermlaneHalf::Upper;
  return std::nullopt;
}

static bool hasPermlaneSemantics(PermlaneCandidate &candidate,
                                 unsigned workgroupSize) {
  unsigned sourceBase = candidate.half == PermlaneHalf::Upper ? 32 : 0;
  for (unsigned wave : llvm::seq<unsigned>(workgroupSize / 64)) {
    unsigned waveBase = wave * 64;
    for (unsigned lane : llvm::seq<unsigned>(0, 64)) {
      std::optional<std::pair<bool, unsigned>> selected =
          evaluateSelectedSource(candidate, lane, waveBase + lane);
      if (!selected)
        return false;
      ArrayRef<Value> actualWords =
          getSelectedWords(candidate, selected->first);
      ArrayRef<Value> expectedWords =
          lane < 32 ? ArrayRef<Value>(candidate.firstWords)
                    : ArrayRef<Value>(candidate.secondWords);
      if (!sameValues(actualWords, expectedWords) ||
          selected->second != sourceBase + lane % 32)
        return false;
    }
  }
  return true;
}

static std::optional<PermlaneCandidate>
matchPermlaneCandidate(VCndmaskB32TupleOp select, unsigned workgroupSize) {
  std::optional<PermlaneCandidate> candidate = makePermlaneCandidate(select);
  if (!candidate)
    return std::nullopt;
  std::optional<PermlaneHalf> half = classifyPermlaneCandidate(*candidate);
  if (!half)
    return std::nullopt;
  candidate->half = *half;
  if (!hasPermlaneSemantics(*candidate, workgroupSize))
    return std::nullopt;
  return candidate;
}

static std::optional<PermlaneCandidate>
findUpperCandidate(const PermlaneCandidate &lower, unsigned workgroupSize) {
  for (Operation *cursor = lower.select->getNextNode(); cursor;
       cursor = cursor->getNextNode()) {
    VCndmaskB32TupleOp select = dyn_cast<VCndmaskB32TupleOp>(cursor);
    if (!select)
      continue;
    std::optional<PermlaneCandidate> candidate =
        matchPermlaneCandidate(select, workgroupSize);
    if (!candidate || candidate->half != PermlaneHalf::Upper)
      continue;
    if (sameValues(candidate->firstWords, lower.firstWords) &&
        sameValues(candidate->secondWords, lower.secondWords))
      return candidate;
  }
  return std::nullopt;
}

static bool isLaneId(Value value, unsigned wavefrontSize) {
  if (wavefrontSize == 32)
    return isa_and_nonnull<VMbcntLoOp>(value.getDefiningOp());

  VMbcntHiOp hi = value.getDefiningOp<VMbcntHiOp>();
  return hi && isa_and_nonnull<VMbcntLoOp>(hi.getSource().getDefiningOp());
}

static bool isLowFiveBitMask(int64_t value) {
  return value >= 0 && value <= llvm::AMDGPU::Swizzle::BITMASK_MASK;
}

static unsigned encodeBitmaskPerm(unsigned andMask, unsigned orMask,
                                  unsigned xorMask) {
  using namespace llvm::AMDGPU::Swizzle;
  return (andMask << BITMASK_AND_SHIFT) | (orMask << BITMASK_OR_SHIFT) |
         (xorMask << BITMASK_XOR_SHIFT);
}

static std::optional<unsigned> matchXorLaneSwizzle(Value laneExpr,
                                                   unsigned wavefrontSize) {
  if (isLaneId(laneExpr, wavefrontSize))
    return encodeBitmaskPerm(llvm::AMDGPU::Swizzle::BITMASK_MASK, 0, 0);

  VXorB32Op xorOp = laneExpr.getDefiningOp<VXorB32Op>();
  if (!xorOp)
    return std::nullopt;

  auto matchLaneAndMask = [&](Value lhs, Value rhs) -> std::optional<unsigned> {
    if (!isLaneId(lhs, wavefrontSize))
      return std::nullopt;
    std::optional<int64_t> mask = getImmediate(rhs);
    if (!mask || !isLowFiveBitMask(*mask))
      return std::nullopt;
    return encodeBitmaskPerm(llvm::AMDGPU::Swizzle::BITMASK_MASK, 0, *mask);
  };

  if (std::optional<unsigned> offset =
          matchLaneAndMask(xorOp.getLhs(), xorOp.getRhs()))
    return offset;
  return matchLaneAndMask(xorOp.getRhs(), xorOp.getLhs());
}

static std::optional<unsigned>
matchDsPermuteSwizzleOffset(DsPermuteB32Op op, unsigned wavefrontSize) {
  if (op.getOffset() != 0)
    return std::nullopt;

  VLshlrevB32Op byteAddr = op.getAddr().getDefiningOp<VLshlrevB32Op>();
  if (!byteAddr)
    return std::nullopt;
  std::optional<int64_t> shift = getImmediate(byteAddr.getRhs());
  if (!shift || *shift != 2)
    return std::nullopt;

  return matchXorLaneSwizzle(byteAddr.getLhs(), wavefrontSize);
}

static void eraseIfDead(PatternRewriter &rewriter, Operation *op) {
  if (!op || !op->use_empty())
    return;
  rewriter.eraseOp(op);
}

static void eraseDeadAddressChain(PatternRewriter &rewriter, Value addr) {
  VLshlrevB32Op byteAddr = addr.getDefiningOp<VLshlrevB32Op>();
  if (!byteAddr || !byteAddr->use_empty())
    return;

  Value laneExpr = byteAddr.getLhs();
  rewriter.eraseOp(byteAddr);
  if (VXorB32Op xorOp = laneExpr.getDefiningOp<VXorB32Op>()) {
    Operation *lhs = xorOp.getLhs().getDefiningOp();
    Operation *rhs = xorOp.getRhs().getDefiningOp();
    eraseIfDead(rewriter, xorOp);
    eraseIfDead(rewriter, lhs);
    eraseIfDead(rewriter, rhs);
  }
}

static void eraseMatchedPayloads(PatternRewriter &rewriter,
                                 ArrayRef<BpermutePayload> payloads) {
  llvm::SmallPtrSet<Operation *, 16> tuples;
  llvm::SmallPtrSet<Operation *, 32> permutes;
  for (const BpermutePayload &payload : payloads) {
    if (payload.tuple)
      tuples.insert(payload.tuple);
    for (DsBpermuteB32Op permute : payload.permutes)
      permutes.insert(permute);
  }
  for (Operation *tuple : tuples)
    eraseIfDead(rewriter, tuple);
  for (Operation *permute : permutes)
    eraseIfDead(rewriter, permute);
}

struct BpermuteSelectPairToPermlanePattern
    : public OpRewritePattern<VCndmaskB32TupleOp> {
  BpermuteSelectPairToPermlanePattern(MLIRContext *context,
                                      unsigned workgroupSize)
      : OpRewritePattern<VCndmaskB32TupleOp>(context),
        workgroupSize(workgroupSize) {}

  LogicalResult matchAndRewrite(VCndmaskB32TupleOp op,
                                PatternRewriter &rewriter) const override {
    std::optional<PermlaneCandidate> lower =
        matchPermlaneCandidate(op, workgroupSize);
    if (!lower || lower->half != PermlaneHalf::Lower)
      return failure();
    std::optional<PermlaneCandidate> upper =
        findUpperCandidate(*lower, workgroupSize);
    if (!upper)
      return failure();

    SmallVector<Value> sourceWords(lower->firstWords);
    llvm::append_range(sourceWords, lower->secondWords);
    MLIRContext *context = op.getContext();
    Type sourceType = RegType::get(context, RegClass::VGPR, sourceWords.size(),
                                   /*index=*/-1);
    Value source = TupleFromElementsOp::create(rewriter, op.getLoc(),
                                               sourceType, sourceWords)
                       .getTuple();
    VPermlane32SwapB32TupleOp swap = VPermlane32SwapB32TupleOp::create(
        rewriter, op.getLoc(), sourceType, source);
    Type halfType = RegType::get(context, RegClass::VGPR,
                                 lower->firstWords.size(), /*index=*/-1);
    std::array<Type, 2> resultTypes{halfType, halfType};
    TupleToElementsOp split = TupleToElementsOp::create(
        rewriter, op.getLoc(), resultTypes, swap.getResult());

    std::array<BpermutePayload, 4> payloads{
        std::move(lower->falsePayload), std::move(lower->truePayload),
        std::move(upper->falsePayload), std::move(upper->truePayload)};
    rewriter.replaceOp(lower->select, split.getElements()[0]);
    rewriter.replaceOp(upper->select, split.getElements()[1]);
    eraseMatchedPayloads(rewriter, payloads);
    return success();
  }

  unsigned workgroupSize;
};

struct DsPermuteToSwizzlePattern : public OpRewritePattern<DsPermuteB32Op> {
  DsPermuteToSwizzlePattern(MLIRContext *context, unsigned wavefrontSize)
      : OpRewritePattern<DsPermuteB32Op>(context),
        wavefrontSize(wavefrontSize) {}

  LogicalResult matchAndRewrite(DsPermuteB32Op op,
                                PatternRewriter &rewriter) const override {
    std::optional<unsigned> offset =
        matchDsPermuteSwizzleOffset(op, wavefrontSize);
    if (!offset)
      return failure();

    Value addr = op.getAddr();
    DsSwizzleB32Op swizzle = DsSwizzleB32Op::create(
        rewriter, op.getLoc(), op.getResult().getType(), op.getData(),
        rewriter.getI64IntegerAttr(*offset));
    rewriter.replaceOp(op, swizzle.getResult());
    eraseDeadAddressChain(rewriter, addr);
    return success();
  }

  unsigned wavefrontSize;
};

static std::optional<unsigned>
evaluateBpermuteSource(DsBpermuteB32Op op, unsigned lane, unsigned workitemX) {
  if (op.getOffset() != 0)
    return std::nullopt;
  MachineU32Evaluator evaluator(lane, workitemX);
  std::optional<uint32_t> byteAddress = evaluator.evaluate(op.getAddr());
  if (!byteAddress || *byteAddress % 4 != 0 || *byteAddress / 4 >= 64)
    return std::nullopt;
  return *byteAddress / 4;
}

static bool isHalfExchangeAtLane(DsBpermuteB32Op lhs, DsBpermuteB32Op rhs,
                                 unsigned lane, unsigned workitemX) {
  std::optional<unsigned> lhsSource =
      evaluateBpermuteSource(lhs, lane, workitemX);
  std::optional<unsigned> rhsSource =
      evaluateBpermuteSource(rhs, lane, workitemX);
  if (!lhsSource || !rhsSource)
    return false;
  unsigned otherHalf = lane ^ 32;
  return (*lhsSource == lane && *rhsSource == otherHalf) ||
         (*rhsSource == lane && *lhsSource == otherHalf);
}

static bool isHalfExchangePair(DsBpermuteB32Op lhs, DsBpermuteB32Op rhs,
                               unsigned workgroupSize) {
  if (!lhs || !rhs || lhs.getData() != rhs.getData() || workgroupSize < 64 ||
      workgroupSize % 64 != 0)
    return false;
  for (unsigned wave : llvm::seq<unsigned>(workgroupSize / 64)) {
    unsigned waveBase = wave * 64;
    for (unsigned lane : llvm::seq<unsigned>(0, 64))
      if (!isHalfExchangeAtLane(lhs, rhs, lane, waveBase + lane))
        return false;
  }
  return true;
}

template <typename BinaryOp>
struct BpermuteHalfReductionToPermlanePattern
    : public OpRewritePattern<BinaryOp> {
  BpermuteHalfReductionToPermlanePattern(MLIRContext *context,
                                         unsigned workgroupSize)
      : OpRewritePattern<BinaryOp>(context), workgroupSize(workgroupSize) {}

  LogicalResult matchAndRewrite(BinaryOp op,
                                PatternRewriter &rewriter) const override {
    DsBpermuteB32Op lhs = op.getLhs().template getDefiningOp<DsBpermuteB32Op>();
    DsBpermuteB32Op rhs = op.getRhs().template getDefiningOp<DsBpermuteB32Op>();
    if (!isHalfExchangePair(lhs, rhs, workgroupSize))
      return failure();

    Value data = lhs.getData();
    Type pairType =
        RegType::get(op.getContext(), RegClass::VGPR, 2, /*index=*/-1);
    Value source = VMovB32TupleOp::create(rewriter, op.getLoc(), pairType, data)
                       .getResult();
    VPermlane32SwapB32TupleOp swap = VPermlane32SwapB32TupleOp::create(
        rewriter, op.getLoc(), pairType, source);
    Type wordType = data.getType();
    std::array<Type, 2> resultTypes{wordType, wordType};
    TupleToElementsOp split = TupleToElementsOp::create(
        rewriter, op.getLoc(), resultTypes, swap.getResult());
    BinaryOp replacement =
        BinaryOp::create(rewriter, op.getLoc(), op.getResult().getType(),
                         split.getElements()[0], split.getElements()[1]);
    rewriter.replaceOp(op, replacement.getResult());
    eraseIfDead(rewriter, lhs);
    eraseIfDead(rewriter, rhs);
    return success();
  }

  unsigned workgroupSize;
};

static bool hasCrossLanePeepholeCandidate(func::FuncOp func) {
  bool found = false;
  WalkResult result = func.walk([&](Operation *op) {
    if (!isa<DsPermuteB32Op, DsBpermuteB32Op>(op))
      return WalkResult::advance();
    found = true;
    return WalkResult::interrupt();
  });
  return result.wasInterrupted() && found;
}

static LogicalResult runOnFunc(func::FuncOp func) {
  if (!hasCrossLanePeepholeCandidate(func))
    return success();

  FailureOr<unsigned> wavefrontSize = waveamdmachine::getAMDGPUWavefrontSize(
      func, "waveamd-cross-lane-peepholes");
  if (failed(wavefrontSize))
    return failure();
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      waveamdmachine::getAMDGPUTargetIsaVersion(func,
                                                "waveamd-cross-lane-peepholes");
  if (failed(isa))
    return failure();

  RewritePatternSet patterns(func.getContext());
  patterns.add<DsPermuteToSwizzlePattern>(func.getContext(), *wavefrontSize);
  std::optional<unsigned> workgroupSize = getXLinearWorkgroupSize(func);
  if (*wavefrontSize == 64 && workgroupSize &&
      VPermlane32SwapB32TupleOp::isSupportedOnIsa(*isa)) {
    patterns.add<BpermuteSelectPairToPermlanePattern>(func.getContext(),
                                                      *workgroupSize);
    patterns.add<BpermuteHalfReductionToPermlanePattern<VAddF32Op>,
                 BpermuteHalfReductionToPermlanePattern<VMaxF32Op>>(
        func.getContext(), *workgroupSize);
  }
  return applyPatternsGreedily(
      func, std::move(patterns),
      GreedyRewriteConfig().enableFolding(false).setRegionSimplificationLevel(
          GreedySimplifyRegionLevel::Disabled));
}

struct WaveAMDCrossLanePeepholesPass
    : public wave::impl::WaveAMDCrossLanePeepholesBase<
          WaveAMDCrossLanePeepholesPass> {
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
