//===- WaveAMDPairDsOps.cpp - pair LDS DS ops -------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/TypeSwitch.h"
#include "llvm/Support/MathExtras.h"

#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDPAIRDSOPS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

enum class PairKind { DirectChain, CommonConsumer };

struct DsOpInfo {
  Operation *op = nullptr;
  Value addr;
  Value value;
  Value result;
  Value dependency;
  Value token;
  uint64_t byteOffset = 0;
  unsigned elementBytes = 0;
  bool isLoad = false;
};

struct EncodedOffsets {
  unsigned offset0 = 0;
  unsigned offset1 = 0;
  bool st64 = false;
  bool firstIsOffset0 = false;
};

static bool isMemToken(Value value) {
  return value && isa<waveamdmachine::MemTokenType>(value.getType());
}

static std::optional<DsOpInfo> getDsOpInfo(Operation *op) {
  return llvm::TypeSwitch<Operation *, std::optional<DsOpInfo>>(op)
      .Case<waveamdmachine::DsLoadB32Op>([&](auto load) {
        return DsOpInfo{op,
                        load.getAddr(),
                        {},
                        load.getResult(),
                        load.getDependency(),
                        load.getToken(),
                        load.getOffset(),
                        4,
                        true};
      })
      .Case<waveamdmachine::DsLoadB64Op>([&](auto load) {
        return DsOpInfo{op,
                        load.getAddr(),
                        {},
                        load.getResult(),
                        load.getDependency(),
                        load.getToken(),
                        load.getOffset(),
                        8,
                        true};
      })
      .Case<waveamdmachine::DsStoreB32Op>([&](auto store) {
        return DsOpInfo{op,
                        store.getAddr(),
                        store.getValue(),
                        {},
                        store.getDependency(),
                        store.getToken(),
                        store.getOffset(),
                        4,
                        false};
      })
      .Case<waveamdmachine::DsStoreB64Op>([&](auto store) {
        return DsOpInfo{op,
                        store.getAddr(),
                        store.getValue(),
                        {},
                        store.getDependency(),
                        store.getToken(),
                        store.getOffset(),
                        8,
                        false};
      })
      .Default([](Operation *) { return std::nullopt; });
}

static bool hasUnallocatedResult(const DsOpInfo &info) {
  if (!info.isLoad)
    return true;
  auto type = dyn_cast<waveamdmachine::RegType>(info.result.getType());
  return type && type.getIndex() < 0;
}

static bool hasSameRegShape(Type lhs, Type rhs) {
  auto lhsReg = dyn_cast<waveamdmachine::RegType>(lhs);
  auto rhsReg = dyn_cast<waveamdmachine::RegType>(rhs);
  return lhsReg && rhsReg && lhsReg.getRegClass() == rhsReg.getRegClass() &&
         lhsReg.getWidth() == rhsReg.getWidth();
}

static bool areCompatiblePairOps(const DsOpInfo &first,
                                 const DsOpInfo &second) {
  if (first.isLoad != second.isLoad ||
      first.elementBytes != second.elementBytes)
    return false;
  if (!first.token || !second.token || first.addr != second.addr)
    return false;
  if (!hasUnallocatedResult(first) || !hasUnallocatedResult(second))
    return false;

  if (first.isLoad)
    return first.result.getType() == second.result.getType();
  return hasSameRegShape(first.value.getType(), second.value.getType());
}

static std::optional<EncodedOffsets>
tryEncodeSt64Offsets(uint64_t low, uint64_t high, bool firstIsOffset0) {
  if (low % 64 != 0 || high % 64 != 0)
    return std::nullopt;

  low /= 64;
  high /= 64;
  if (!llvm::isUInt<8>(low) || !llvm::isUInt<8>(high))
    return std::nullopt;

  return EncodedOffsets{static_cast<unsigned>(low), static_cast<unsigned>(high),
                        true, firstIsOffset0};
}

static std::optional<EncodedOffsets>
tryEncodePlainOffsets(uint64_t low, uint64_t high, bool firstIsOffset0) {
  if (!llvm::isUInt<8>(low) || !llvm::isUInt<8>(high))
    return std::nullopt;

  return EncodedOffsets{static_cast<unsigned>(low), static_cast<unsigned>(high),
                        false, firstIsOffset0};
}

static std::optional<EncodedOffsets> encodeOffsets(const DsOpInfo &first,
                                                   const DsOpInfo &second) {
  if (first.byteOffset == second.byteOffset)
    return std::nullopt;
  if (first.byteOffset % first.elementBytes != 0 ||
      second.byteOffset % first.elementBytes != 0)
    return std::nullopt;

  uint64_t firstElement = first.byteOffset / first.elementBytes;
  uint64_t secondElement = second.byteOffset / first.elementBytes;
  bool firstIsOffset0 = firstElement < secondElement;
  uint64_t low = firstIsOffset0 ? firstElement : secondElement;
  uint64_t high = firstIsOffset0 ? secondElement : firstElement;

  if (std::optional<EncodedOffsets> encoded =
          tryEncodeSt64Offsets(low, high, firstIsOffset0))
    return encoded;
  return tryEncodePlainOffsets(low, high, firstIsOffset0);
}

static waveamdmachine::RegType getPairType(Type elementType) {
  auto regType = cast<waveamdmachine::RegType>(elementType);
  return waveamdmachine::RegType::get(
      elementType.getContext(), regType.getRegClass(), regType.getWidth() * 2,
      /*index=*/-1);
}

static void collectFinalConsumers(Value token, llvm::DenseSet<Value> &seen,
                                  SmallVectorImpl<Operation *> &consumers,
                                  bool &failed);

static bool collectForwardedConsumers(Value source, OperandRange forwarded,
                                      ValueRange targets,
                                      llvm::DenseSet<Value> &seen,
                                      SmallVectorImpl<Operation *> &consumers,
                                      bool &failed) {
  bool handled = false;
  for (auto [index, operand] : llvm::enumerate(forwarded)) {
    if (operand != source)
      continue;
    handled = true;
    if (index >= targets.size() || !isMemToken(targets[index])) {
      failed = true;
      return handled;
    }
    collectFinalConsumers(targets[index], seen, consumers, failed);
    if (failed)
      return handled;
  }
  return handled;
}

static void
collectTerminatorConsumers(RegionBranchTerminatorOpInterface terminator,
                           Value token, llvm::DenseSet<Value> &seen,
                           SmallVectorImpl<Operation *> &consumers,
                           bool &failed) {
  auto branch =
      dyn_cast_or_null<RegionBranchOpInterface>(terminator->getParentOp());
  if (!branch) {
    failed = true;
    return;
  }

  bool handled = false;
  SmallVector<RegionSuccessor> successors;
  branch.getSuccessorRegions(RegionBranchPoint(terminator), successors);
  for (RegionSuccessor successor : successors) {
    handled |= collectForwardedConsumers(
        token, terminator.getSuccessorOperands(successor),
        branch.getSuccessorInputs(successor), seen, consumers, failed);
    if (failed)
      return;
  }
  if (!handled)
    failed = true;
}

static void collectBranchConsumers(RegionBranchOpInterface branch, Value token,
                                   llvm::DenseSet<Value> &seen,
                                   SmallVectorImpl<Operation *> &consumers,
                                   bool &failed) {
  bool handled = false;
  SmallVector<RegionSuccessor> successors;
  branch.getSuccessorRegions(RegionBranchPoint::parent(), successors);
  for (RegionSuccessor successor : successors) {
    handled |= collectForwardedConsumers(
        token, branch.getEntrySuccessorOperands(successor),
        branch.getSuccessorInputs(successor), seen, consumers, failed);
    if (failed)
      return;
  }
  if (!handled)
    failed = true;
}

static void collectFinalConsumers(Value token, llvm::DenseSet<Value> &seen,
                                  SmallVectorImpl<Operation *> &consumers,
                                  bool &failed) {
  if (failed)
    return;
  if (!seen.insert(token).second)
    return;

  for (OpOperand &use : token.getUses()) {
    Operation *owner = use.getOwner();

    if (auto terminator = dyn_cast<RegionBranchTerminatorOpInterface>(owner)) {
      collectTerminatorConsumers(terminator, token, seen, consumers, failed);
      continue;
    }

    if (auto branch = dyn_cast<RegionBranchOpInterface>(owner)) {
      collectBranchConsumers(branch, token, seen, consumers, failed);
      continue;
    }

    consumers.push_back(owner);
  }
}

static std::optional<Operation *> getSingleFinalConsumer(Value token) {
  llvm::DenseSet<Value> seen;
  SmallVector<Operation *> consumers;
  bool failed = false;
  collectFinalConsumers(token, seen, consumers, failed);
  if (failed || consumers.empty())
    return std::nullopt;

  Operation *consumer = consumers.front();
  for (Operation *op : llvm::drop_begin(consumers))
    if (op != consumer)
      return std::nullopt;
  return consumer;
}

static std::optional<PairKind> getPairKind(const DsOpInfo &first,
                                           const DsOpInfo &second) {
  if (second.dependency == first.token && first.token.hasOneUse())
    return PairKind::DirectChain;

  if (!first.dependency || first.dependency != second.dependency)
    return std::nullopt;

  std::optional<Operation *> firstConsumer =
      getSingleFinalConsumer(first.token);
  std::optional<Operation *> secondConsumer =
      getSingleFinalConsumer(second.token);
  if (firstConsumer && secondConsumer && *firstConsumer == *secondConsumer)
    return PairKind::CommonConsumer;
  return std::nullopt;
}

static Operation *createLoadPair(IRRewriter &rewriter, const DsOpInfo &first,
                                 const EncodedOffsets &offsets) {
  Location loc = first.op->getLoc();
  Type resultType = getPairType(first.result.getType());
  Type tokenType = first.token.getType();
  IntegerAttr offset0 = rewriter.getI64IntegerAttr(offsets.offset0);
  IntegerAttr offset1 = rewriter.getI64IntegerAttr(offsets.offset1);
  BoolAttr st64 = rewriter.getBoolAttr(offsets.st64);
  if (first.elementBytes == 4)
    return waveamdmachine::DsLoad2B32Op::create(
        rewriter, loc, resultType, tokenType, first.addr, first.dependency,
        offset0, offset1, st64);
  return waveamdmachine::DsLoad2B64Op::create(
      rewriter, loc, resultType, tokenType, first.addr, first.dependency,
      offset0, offset1, st64);
}

static Operation *createStorePair(IRRewriter &rewriter, const DsOpInfo &first,
                                  const DsOpInfo &second,
                                  const EncodedOffsets &offsets) {
  Value value0 = offsets.firstIsOffset0 ? first.value : second.value;
  Value value1 = offsets.firstIsOffset0 ? second.value : first.value;
  Type tokenType = first.token.getType();
  Location loc = second.op->getLoc();
  IntegerAttr offset0 = rewriter.getI64IntegerAttr(offsets.offset0);
  IntegerAttr offset1 = rewriter.getI64IntegerAttr(offsets.offset1);
  BoolAttr st64 = rewriter.getBoolAttr(offsets.st64);
  if (first.elementBytes == 4)
    return waveamdmachine::DsStore2B32Op::create(
        rewriter, loc, tokenType, first.addr, value0, value1, first.dependency,
        offset0, offset1, st64);
  return waveamdmachine::DsStore2B64Op::create(
      rewriter, loc, tokenType, first.addr, value0, value1, first.dependency,
      offset0, offset1, st64);
}

static void replaceLoadPair(IRRewriter &rewriter, const DsOpInfo &first,
                            const DsOpInfo &second, PairKind kind,
                            const EncodedOffsets &offsets) {
  rewriter.setInsertionPoint(first.op);
  Operation *pair = createLoadPair(rewriter, first, offsets);

  SmallVector<Type, 2> elementTypes = {first.result.getType(),
                                       second.result.getType()};
  rewriter.setInsertionPointAfter(pair);
  auto split = waveamdmachine::TupleToElementsOp::create(
      rewriter, pair->getLoc(), elementTypes, pair->getResult(0));

  Value firstValue =
      offsets.firstIsOffset0 ? split.getElements()[0] : split.getElements()[1];
  Value secondValue =
      offsets.firstIsOffset0 ? split.getElements()[1] : split.getElements()[0];
  rewriter.replaceAllUsesWith(first.result, firstValue);
  rewriter.replaceAllUsesWith(second.result, secondValue);

  if (kind == PairKind::CommonConsumer)
    rewriter.replaceAllUsesWith(first.token, pair->getResult(1));
  rewriter.replaceAllUsesWith(second.token, pair->getResult(1));
  rewriter.eraseOp(second.op);
  rewriter.eraseOp(first.op);
}

static void replaceStorePair(IRRewriter &rewriter, const DsOpInfo &first,
                             const DsOpInfo &second, PairKind kind,
                             const EncodedOffsets &offsets) {
  rewriter.setInsertionPoint(second.op);
  Operation *pair = createStorePair(rewriter, first, second, offsets);

  if (kind == PairKind::CommonConsumer)
    rewriter.replaceAllUsesWith(first.token, pair->getResult(0));
  rewriter.replaceAllUsesWith(second.token, pair->getResult(0));
  rewriter.eraseOp(second.op);
  rewriter.eraseOp(first.op);
}

static bool tryPairBlock(Block &block, IRRewriter &rewriter) {
  for (auto firstIt = block.begin(), e = block.end(); firstIt != e; ++firstIt) {
    std::optional<DsOpInfo> first = getDsOpInfo(&*firstIt);
    if (!first)
      continue;

    for (auto secondIt = std::next(firstIt); secondIt != e; ++secondIt) {
      std::optional<DsOpInfo> second = getDsOpInfo(&*secondIt);
      if (!second || !areCompatiblePairOps(*first, *second))
        continue;

      std::optional<EncodedOffsets> offsets = encodeOffsets(*first, *second);
      if (!offsets)
        continue;

      std::optional<PairKind> kind = getPairKind(*first, *second);
      if (!kind)
        continue;

      if (first->isLoad)
        replaceLoadPair(rewriter, *first, *second, *kind, *offsets);
      else
        replaceStorePair(rewriter, *first, *second, *kind, *offsets);
      return true;
    }
  }
  return false;
}

static Value getUnaryTokenWrapperInput(Operation *op) {
  if (auto join = dyn_cast<waveamdmachine::TokenJoinOp>(op))
    if (join.getDependencies().size() == 1)
      return join.getDependencies().front();

  if (auto after = dyn_cast<waveamdmachine::AfterOp>(op))
    if (after.getDependencies().size() == 1)
      return after.getDependencies().front();

  return {};
}

static bool foldUnaryTokenWrappers(Operation *root, IRRewriter &rewriter) {
  SmallVector<Operation *> wrappers;
  root->walk([&](Operation *op) {
    if (getUnaryTokenWrapperInput(op))
      wrappers.push_back(op);
  });

  for (Operation *op : wrappers) {
    if (op->getParentOp() == nullptr)
      continue;
    Value input = getUnaryTokenWrapperInput(op);
    if (!input)
      continue;
    rewriter.replaceAllUsesWith(op->getResult(0), input);
    rewriter.eraseOp(op);
  }
  return !wrappers.empty();
}

struct WaveAMDPairDsOpsPass
    : public wave::impl::WaveAMDPairDsOpsBase<WaveAMDPairDsOpsPass> {
  using WaveAMDPairDsOpsBase::WaveAMDPairDsOpsBase;

  void runOnOperation() override {
    Operation *root = getOperation();
    IRRewriter rewriter(root->getContext());

    bool changed;
    do {
      changed = foldUnaryTokenWrappers(root, rewriter);
      WalkResult result = root->walk([&](Block *block) {
        if (!tryPairBlock(*block, rewriter))
          return WalkResult::advance();
        changed = true;
        return WalkResult::interrupt();
      });
      (void)result;
    } while (changed);
  }
};

} // namespace
