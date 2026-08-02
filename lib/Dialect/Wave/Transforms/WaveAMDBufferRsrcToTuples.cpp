//===- WaveAMDBufferRsrcToTuples.cpp - buffer SRD aliases -----*- C++ -*-===//
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
#include "llvm/ADT/SmallVector.h"
#include "llvm/MC/MCSubtargetInfo.h"

#include <array>
#include <limits>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDBUFFERRSRCTOTUPLES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::waveamdmachine;

namespace {

static constexpr uint32_t getDefaultBufferRsrcFlags() {
  constexpr uint32_t gfx11Format32Float =
      llvm::AMDGPU::UfmtGFX11::UFMT_32_FLOAT;
  return (gfx11Format32Float << 12) | (1u << 24) | (3u << 28);
}

static uint32_t getLegacyBufferRsrcFlags(MakeBufferRsrcOp make) {
  uint32_t flags = getDefaultBufferRsrcFlags();
  if (!make.getConstAddTidEnable())
    return flags;
  constexpr uint32_t dataFormatMask = 0xfu << 15;
  flags &= ~dataFormatMask;
  flags |= 1u << 23;
  flags |= static_cast<uint32_t>(make.getConstStride() >> 14) << 15;
  return flags;
}

static RegType getTuplePartType(RegType tupleType, unsigned offset,
                                unsigned width) {
  int64_t index = -1;
  if (tupleType.getIndex() >= 0)
    index = tupleType.getIndex() + offset;
  return RegType::get(tupleType.getContext(), RegClass::SGPR, width, index);
}

static Value getImm(IRRewriter &rewriter, Location loc, int64_t value) {
  return ImmOp::create(rewriter, loc, ImmType::get(rewriter.getContext()),
                       value);
}

static RegType getVirtualSGPRType(MLIRContext *context, unsigned width) {
  return RegType::get(context, RegClass::SGPR, width, /*index=*/-1);
}

static RegType getVirtualSCCType(MLIRContext *context) {
  return RegType::get(context, RegClass::SCC, /*width=*/1, /*index=*/-1);
}

static Value getWideImm(IRRewriter &rewriter, Location loc, uint64_t value) {
  return SMovB64ImmOp::create(
      rewriter, loc, getVirtualSGPRType(rewriter.getContext(), 2),
      rewriter.getI64IntegerAttr(static_cast<int64_t>(value)));
}

static constexpr uint64_t getFieldMask(unsigned bits) {
  return (uint64_t{1} << bits) - 1;
}

static std::optional<int64_t> getConstantValue(Value value) {
  if (auto imm = value.getDefiningOp<ImmOp>())
    return imm.getValue();
  if (auto mov = value.getDefiningOp<SMovB64ImmOp>())
    return mov.getValue();
  return std::nullopt;
}

static LogicalResult validateUnsignedFieldConstant(Value value, unsigned bits,
                                                   StringRef field,
                                                   Operation *op) {
  std::optional<int64_t> constant = getConstantValue(value);
  if (!constant)
    return success();
  if (*constant < 0 || static_cast<uint64_t>(*constant) > getFieldMask(bits))
    return op->emitError() << field << " constant must fit unsigned " << bits
                           << "-bit field";
  return success();
}

static LogicalResult validateLegacyBufferRange(Value value, Operation *op) {
  std::optional<int64_t> constant = getConstantValue(value);
  if (constant) {
    if (*constant < 0 ||
        static_cast<uint64_t>(*constant) > std::numeric_limits<uint32_t>::max())
      return op->emitError(
          "buffer range constant must fit unsigned 32-bit target field");
    return success();
  }

  auto type = dyn_cast<RegType>(value.getType());
  if (type && type.getWidth() == 2)
    return op->emitError(
        "dynamic i64 buffer range cannot fit 32-bit target field");
  return success();
}

static bool isUsableSGPR(Value value, RegType type) {
  auto valueType = dyn_cast<RegType>(value.getType());
  if (!valueType || valueType.getRegClass() != RegClass::SGPR ||
      valueType.getWidth() != type.getWidth())
    return false;
  return type.getIndex() < 0 || valueType.getIndex() == type.getIndex();
}

static FailureOr<Value> getSGPR(Value value, RegType targetType,
                                IRRewriter &rewriter, Operation *op) {
  if (auto type = dyn_cast<RegType>(value.getType())) {
    if (isUsableSGPR(value, targetType))
      return value;
    if (type.getRegClass() != RegClass::SGPR ||
        type.getWidth() != targetType.getWidth())
      return op->emitError(
          "buffer descriptor part must be matching-width SGPR or immediate");
  }
  auto mov = SMovB32TupleOp::create(rewriter, op->getLoc(), targetType, value);
  return mov.getResult();
}

static FailureOr<Value> getBufferRange(Value value, RegType targetType,
                                       IRRewriter &rewriter, Operation *op) {
  auto sourceType = dyn_cast<RegType>(value.getType());
  if (!sourceType || sourceType.getWidth() == targetType.getWidth())
    return getSGPR(value, targetType, rewriter, op);
  if (sourceType.getRegClass() != RegClass::SGPR)
    return op->emitError("buffer range must be SGPR or immediate");

  if (sourceType.getWidth() == 2 && targetType.getWidth() == 1) {
    std::array<Type, 2> wordTypes{
        getTuplePartType(sourceType, 0, 1),
        getTuplePartType(sourceType, 1, 1),
    };
    auto split =
        TupleToElementsOp::create(rewriter, op->getLoc(), wordTypes, value);
    return getSGPR(split.getElements().front(), targetType, rewriter, op);
  }

  if (sourceType.getWidth() == 1 && targetType.getWidth() == 2) {
    FailureOr<Value> low =
        getSGPR(value, getTuplePartType(targetType, 0, 1), rewriter, op);
    FailureOr<Value> high =
        getSGPR(getImm(rewriter, op->getLoc(), 0),
                getTuplePartType(targetType, 1, 1), rewriter, op);
    if (failed(low) || failed(high))
      return failure();
    return TupleFromElementsOp::create(rewriter, op->getLoc(), targetType,
                                       ValueRange{*low, *high})
        .getTuple();
  }

  return op->emitError("buffer range must occupy one or two SGPRs");
}

static FailureOr<Value> getWideBufferRange(Value value, IRRewriter &rewriter,
                                           Operation *op) {
  RegType targetType = getVirtualSGPRType(op->getContext(), 2);
  if (auto imm = value.getDefiningOp<ImmOp>())
    return SMovB64ImmOp::create(rewriter, op->getLoc(), targetType,
                                rewriter.getI64IntegerAttr(imm.getValue()))
        .getResult();
  return getBufferRange(value, targetType, rewriter, op);
}

static FailureOr<Value> getLegacyBufferBase(MakeBufferRsrcOp make,
                                            IRRewriter &rewriter,
                                            RegType targetType) {
  FailureOr<Value> base = getSGPR(make.getBase(), targetType, rewriter, make);
  if (failed(base) || !make.getConstAddTidEnable())
    return base;
  constexpr uint64_t baseMask = getFieldMask(48);
  uint64_t stride = static_cast<uint64_t>(make.getConstStride() & 0x3fff) << 48;
  if (std::optional<int64_t> constant = getConstantValue(*base))
    return SMovB64ImmOp::create(
               rewriter, make.getLoc(), targetType,
               rewriter.getI64IntegerAttr(static_cast<int64_t>(
                   (static_cast<uint64_t>(*constant) & baseMask) | stride)))
        .getResult();

  RegType pairType = getVirtualSGPRType(make.getContext(), 2);
  RegType sccType = getVirtualSCCType(make.getContext());
  auto masked =
      SAndB64Op::create(rewriter, make.getLoc(), pairType, sccType, *base,
                        getWideImm(rewriter, make.getLoc(), baseMask));
  return SOrB64Op::create(rewriter, make.getLoc(), targetType, sccType,
                          masked.getResult(),
                          getWideImm(rewriter, make.getLoc(), stride))
      .getResult();
}

static FailureOr<Value>
convertConstantWideMakeBufferRsrc(MakeBufferRsrcOp make, IRRewriter &rewriter,
                                  RegType descriptorType, uint64_t base,
                                  uint64_t range, unsigned baseBits,
                                  unsigned lowNumRecordsBits) {
  constexpr uint64_t flags = uint64_t{getDefaultBufferRsrcFlags()} << 32;
  uint64_t low = base | (range << baseBits);
  uint64_t high = (range >> lowNumRecordsBits) | flags;
  Value lowImm = SMovB64ImmOp::create(
      rewriter, make.getLoc(), getTuplePartType(descriptorType, 0, 2),
      rewriter.getI64IntegerAttr(static_cast<int64_t>(low)));
  Value highImm = SMovB64ImmOp::create(
      rewriter, make.getLoc(), getTuplePartType(descriptorType, 2, 2),
      rewriter.getI64IntegerAttr(static_cast<int64_t>(high)));
  auto tuple = TupleFromElementsOp::create(
      rewriter, make.getLoc(), descriptorType, ValueRange{lowImm, highImm});
  rewriter.replaceOp(make, tuple.getTuple());
  return tuple.getTuple();
}

static FailureOr<Value> convertDynamicWideMakeBufferRsrc(
    MakeBufferRsrcOp make, IRRewriter &rewriter, RegType descriptorType,
    unsigned baseBits, unsigned numRecordsBits, unsigned lowNumRecordsBits) {
  FailureOr<Value> base = getSGPR(
      make.getBase(), getTuplePartType(descriptorType, 0, 2), rewriter, make);
  if (failed(base))
    return failure();
  FailureOr<Value> range = getWideBufferRange(make.getRange(), rewriter, make);
  if (failed(range))
    return failure();

  constexpr uint64_t flags = uint64_t{getDefaultBufferRsrcFlags()} << 32;
  uint64_t baseMask = getFieldMask(baseBits);
  uint64_t rangeMask = getFieldMask(numRecordsBits);
  RegType pairType = getVirtualSGPRType(make.getContext(), 2);
  RegType sccType = getVirtualSCCType(make.getContext());
  auto maskedBase =
      SAndB64Op::create(rewriter, make.getLoc(), pairType, sccType, *base,
                        getWideImm(rewriter, make.getLoc(), baseMask));
  auto maskedRange =
      SAndB64Op::create(rewriter, make.getLoc(), pairType, sccType, *range,
                        getWideImm(rewriter, make.getLoc(), rangeMask));
  auto rangeLow = SLshlB64Op::create(rewriter, make.getLoc(), pairType, sccType,
                                     maskedRange.getResult(),
                                     getImm(rewriter, make.getLoc(), baseBits));
  auto low = SOrB64Op::create(rewriter, make.getLoc(),
                              getTuplePartType(descriptorType, 0, 2), sccType,
                              maskedBase.getResult(), rangeLow.getResult());
  auto rangeHigh = SLshrB64Op::create(
      rewriter, make.getLoc(), pairType, sccType, maskedRange.getResult(),
      getImm(rewriter, make.getLoc(), lowNumRecordsBits));
  auto high = SOrB64Op::create(
      rewriter, make.getLoc(), getTuplePartType(descriptorType, 2, 2), sccType,
      rangeHigh.getResult(), getWideImm(rewriter, make.getLoc(), flags));
  auto tuple = TupleFromElementsOp::create(
      rewriter, make.getLoc(), descriptorType,
      ValueRange{low.getResult(), high.getResult()});
  rewriter.replaceOp(make, tuple.getTuple());
  return tuple.getTuple();
}

static FailureOr<Value>
convertWideMakeBufferRsrc(MakeBufferRsrcOp make, IRRewriter &rewriter,
                          RegType descriptorType,
                          const AMDGPUTargetCapabilities &capabilities) {
  unsigned baseBits = capabilities.bufferResourceBaseBits;
  unsigned numRecordsBits = capabilities.bufferResourceNumRecordsBits;
  unsigned lowNumRecordsBits = 64 - baseBits;
  if (failed(validateUnsignedFieldConstant(make.getBase(), baseBits,
                                           "buffer base", make)) ||
      failed(validateUnsignedFieldConstant(make.getRange(), numRecordsBits,
                                           "buffer range", make)))
    return failure();

  std::optional<int64_t> constantBase = getConstantValue(make.getBase());
  std::optional<int64_t> constantRange = getConstantValue(make.getRange());
  if (constantBase && constantRange)
    return convertConstantWideMakeBufferRsrc(
        make, rewriter, descriptorType, static_cast<uint64_t>(*constantBase),
        static_cast<uint64_t>(*constantRange), baseBits, lowNumRecordsBits);
  return convertDynamicWideMakeBufferRsrc(make, rewriter, descriptorType,
                                          baseBits, numRecordsBits,
                                          lowNumRecordsBits);
}

static FailureOr<Value> convertLegacyMakeBufferRsrc(MakeBufferRsrcOp make,
                                                    IRRewriter &rewriter,
                                                    RegType descriptorType) {
  FailureOr<Value> base = getLegacyBufferBase(
      make, rewriter, getTuplePartType(descriptorType, 0, 2));
  if (failed(base))
    return failure();
  if (failed(validateLegacyBufferRange(make.getRange(), make)))
    return failure();
  FailureOr<Value> range = getBufferRange(
      make.getRange(), getTuplePartType(descriptorType, 2, 1), rewriter, make);
  if (failed(range))
    return failure();
  Value flagsImm =
      getImm(rewriter, make.getLoc(), getLegacyBufferRsrcFlags(make));
  auto flags =
      SMovB32TupleOp::create(rewriter, make.getLoc(),
                             getTuplePartType(descriptorType, 3, 1), flagsImm);
  auto tuple = TupleFromElementsOp::create(
      rewriter, make.getLoc(), make.getDescriptor().getType(),
      ValueRange{*base, *range, flags.getResult()});
  rewriter.replaceOp(make, tuple.getTuple());
  return tuple.getTuple();
}

static FailureOr<Value>
convertMakeBufferRsrc(MakeBufferRsrcOp make, IRRewriter &rewriter,
                      const AMDGPUTargetCapabilities *wideCapabilities,
                      bool supportsConstAddTid) {
  rewriter.setInsertionPoint(make);
  if (make.getConstAddTidEnable() && !supportsConstAddTid)
    return make.emitError("constant TID buffer stride requires a CDNA4 target");
  RegType descriptorType = cast<RegType>(make.getDescriptor().getType());
  if (wideCapabilities)
    return convertWideMakeBufferRsrc(make, rewriter, descriptorType,
                                     *wideCapabilities);
  return convertLegacyMakeBufferRsrc(make, rewriter, descriptorType);
}

static FailureOr<Value>
convertUpdateBufferRsrcBase(UpdateBufferRsrcBaseOp update, IRRewriter &rewriter,
                            const AMDGPUTargetCapabilities *wideCapabilities) {
  rewriter.setInsertionPoint(update);
  auto resultType = cast<RegType>(update.getResult().getType());
  FailureOr<Value> base = getSGPR(
      update.getBase(), getTuplePartType(resultType, 0, 2), rewriter, update);
  if (failed(base))
    return failure();
  if (wideCapabilities) {
    unsigned baseBits = wideCapabilities->bufferResourceBaseBits;
    if (failed(validateUnsignedFieldConstant(update.getBase(), baseBits,
                                             "buffer base", update)))
      return failure();
    uint64_t baseMask = getFieldMask(baseBits);
    RegType pairType = getVirtualSGPRType(update.getContext(), 2);
    RegType sccType = getVirtualSCCType(update.getContext());
    auto descriptorType = cast<RegType>(update.getDescriptor().getType());
    std::array<Type, 2> pairTypes{
        getTuplePartType(descriptorType, 0, 2),
        getTuplePartType(descriptorType, 2, 2),
    };
    auto split = TupleToElementsOp::create(rewriter, update.getLoc(), pairTypes,
                                           update.getDescriptor());
    auto maskedBase =
        SAndB64Op::create(rewriter, update.getLoc(), pairType, sccType, *base,
                          getWideImm(rewriter, update.getLoc(), baseMask));
    auto preserved =
        SAndB64Op::create(rewriter, update.getLoc(), pairType, sccType,
                          split.getElements().front(),
                          getWideImm(rewriter, update.getLoc(), ~baseMask));
    auto low = SOrB64Op::create(rewriter, update.getLoc(),
                                getTuplePartType(resultType, 0, 2), sccType,
                                maskedBase.getResult(), preserved.getResult());
    auto tuple = TupleFromElementsOp::create(
        rewriter, update.getLoc(), resultType,
        ValueRange{low.getResult(), split.getElements().back()});
    rewriter.replaceOp(update, tuple.getTuple());
    return tuple.getTuple();
  }

  auto tuple = UpdateTupleOp::create(rewriter, update.getLoc(), resultType,
                                     update.getDescriptor(), ValueRange{*base},
                                     rewriter.getI64ArrayAttr({0}));
  rewriter.replaceOp(update, tuple.getResult());
  return tuple.getResult();
}

static FailureOr<std::optional<AMDGPUTargetCapabilities>>
getWideBufferCapabilities(Operation *op, const llvm::MCSubtargetInfo &sti) {
  std::optional<AMDGPUTargetCapabilities> capabilities =
      getAMDGPUTargetCapabilities(sti);
  if (!capabilities)
    return std::optional<AMDGPUTargetCapabilities>();

  unsigned baseBits = capabilities->bufferResourceBaseBits;
  unsigned numRecordsBits = capabilities->bufferResourceNumRecordsBits;
  if (baseBits == 0 && numRecordsBits == 0)
    return std::optional<AMDGPUTargetCapabilities>();
  if (baseBits == 0 || baseBits >= 64 || numRecordsBits == 0 ||
      numRecordsBits >= 64) {
    op->emitError() << "invalid AMDGPU buffer resource field widths: base "
                    << baseBits << ", num-records " << numRecordsBits;
    return failure();
  }
  return capabilities;
}

static SmallVector<Operation *> collectBufferRsrcOps(Operation *root) {
  SmallVector<Operation *> ops;
  root->walk([&](Operation *op) {
    if (isa<MakeBufferRsrcOp, UpdateBufferRsrcBaseOp>(op))
      ops.push_back(op);
  });
  return ops;
}

static LogicalResult
convertBufferRsrcOp(Operation *op, IRRewriter &rewriter,
                    const AMDGPUTargetCapabilities *wideCapabilities,
                    bool supportsConstAddTid) {
  if (!op->getParentOp())
    return success();
  if (auto make = dyn_cast<MakeBufferRsrcOp>(op))
    return success(succeeded(convertMakeBufferRsrc(
        make, rewriter, wideCapabilities, supportsConstAddTid)));
  auto update = cast<UpdateBufferRsrcBaseOp>(op);
  return success(succeeded(
      convertUpdateBufferRsrcBase(update, rewriter, wideCapabilities)));
}

struct WaveAMDBufferRsrcToTuplesPass
    : public wave::impl::WaveAMDBufferRsrcToTuplesBase<
          WaveAMDBufferRsrcToTuplesPass> {
  void runOnOperation() override {
    FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
        createAMDGPUMCSubtargetInfo(getOperation(),
                                    "waveamd-buffer-rsrc-to-tuples");
    if (failed(sti))
      return signalPassFailure();
    FailureOr<std::optional<AMDGPUTargetCapabilities>> capabilities =
        getWideBufferCapabilities(getOperation(), **sti);
    if (failed(capabilities))
      return signalPassFailure();
    const AMDGPUTargetCapabilities *wideCapabilities =
        *capabilities ? &**capabilities : nullptr;
    llvm::AMDGPU::IsaVersion isa =
        llvm::AMDGPU::getIsaVersion((**sti).getCPU());
    bool supportsConstAddTid = isa.Major == 9 && isa.Minor == 5;

    IRRewriter rewriter(&getContext());
    for (Operation *op : collectBufferRsrcOps(getOperation()))
      if (failed(convertBufferRsrcOp(op, rewriter, wideCapabilities,
                                     supportsConstAddTid)))
        return signalPassFailure();
  }
};

} // namespace
