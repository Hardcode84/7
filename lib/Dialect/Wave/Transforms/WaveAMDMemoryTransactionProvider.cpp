//===- WaveAMDMemoryTransactionProvider.cpp - AMD memory plans -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveMemoryTransactionProvider.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/TargetParser/AMDGPUTargetParser.h"

#include <array>
#include <cassert>
#include <memory>
#include <optional>
#include <utility>

using namespace mlir;
using namespace mlir::wave;

namespace {

static bool isGfx950(Operation *op) {
  ModuleOp targetModule = waveamdmachine::findAMDGPUTargetModule(op);
  if (!targetModule)
    return false;
  StringAttr attr =
      targetModule->getAttrOfType<StringAttr>("waveamdmachine.target");
  if (!attr)
    return false;
  std::optional<waveamdmachine::AMDGPUTarget> target =
      waveamdmachine::parseAMDGPUTargetAttr(attr.getValue());
  if (!target)
    return false;
  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(target->chip);
  return isa.Major == 9 && isa.Minor == 5;
}

static bool isInsideWhere(Operation *op) {
  func::FuncOp func = op->getParentOfType<func::FuncOp>();
  for (Operation *parent = op->getParentOp(); parent && parent != func;
       parent = parent->getParentOp())
    if (isa<WhereOp>(parent))
      return true;
  return false;
}

class TransposeEmitter final
    : public wave::memory_lowering::GatherTransactionEmitter {
public:
  wave::memory_lowering::GatherTransactionResult
  emit(IRRewriter &rewriter, Location loc, SimdType resultType, Type tokenType,
       Value address, Value dependency) const override {
    VectorType packet = cast<VectorType>(resultType.getElementType());
    SimdType addressSimd = dyn_cast<SimdType>(address.getType());
    Type pointerType =
        addressSimd ? addressSimd.getElementType() : address.getType();
    PtrType pointer = cast<PtrType>(pointerType);
    if (pointer.getElementType() != packet.getElementType()) {
      PtrType typedPointer =
          PtrType::get(rewriter.getContext(), packet.getElementType(),
                       pointer.getAddressSpace());
      Type typedAddress =
          addressSimd ? Type(SimdType::get(rewriter.getContext(), typedPointer,
                                           addressSimd.getWidth()))
                      : Type(typedPointer);
      address = PtrCastOp::create(rewriter, loc, typedAddress, address);
    }
    waveamd::TransposeLoadOp load = waveamd::TransposeLoadOp::create(
        rewriter, loc, resultType, tokenType, address, dependency);
    return wave::memory_lowering::GatherTransactionResult{load.getValue(),
                                                          load.getToken()};
  }
};

static std::shared_ptr<const wave::memory_lowering::GatherTransactionEmitter>
getTransposeEmitter() {
  static const std::shared_ptr<
      const wave::memory_lowering::GatherTransactionEmitter>
      emitter = std::make_shared<TransposeEmitter>();
  return emitter;
}

static FailureOr<sym::ExprHandle> composeIntBinary(sym::Store &store,
                                                   sym::ExprHandle lhs,
                                                   sym::ExprBinaryOp op,
                                                   int64_t rhs) {
  FailureOr<sym::ExprHandle> value = sym::composeExprInt(store, rhs);
  if (failed(value))
    return failure();
  return sym::composeExprBinary(store, lhs, op, *value);
}

static FailureOr<sym::ExprHandle>
composeFloorDiv(sym::Store &store, sym::ExprHandle value, int64_t divisor) {
  FailureOr<sym::ExprHandle> ratio =
      composeIntBinary(store, value, sym::ExprBinaryOp::Div, divisor);
  if (failed(ratio))
    return failure();
  return sym::composeExprFloor(store, *ratio);
}

enum class B16Combine { Add, Xor };

struct B16Composition {
  B16Combine base;
  B16Combine bits;
};

static sym::ExprBinaryOp getB16DeltaOp(B16Combine combine) {
  return combine == B16Combine::Add ? sym::ExprBinaryOp::Sub
                                    : sym::ExprBinaryOp::Xor;
}

static sym::ExprBinaryOp getB16CombineOp(B16Combine combine) {
  return combine == B16Combine::Add ? sym::ExprBinaryOp::Add
                                    : sym::ExprBinaryOp::Xor;
}

static FailureOr<sym::ExprHandle>
specializeAddress(sym::Analysis &analysis, sym::ExprHandle address,
                  sym::ExprHandle item, int64_t itemValue, sym::ExprHandle slot,
                  int64_t slotValue) {
  sym::ExprHandle concreteItem = analysis.composeInteger(itemValue);
  sym::ExprHandle concreteSlot = analysis.composeInteger(slotValue);
  std::array<sym::ExprSubstitution, 2> substitutions{
      sym::ExprSubstitution{item, concreteItem},
      sym::ExprSubstitution{slot, concreteSlot}};
  return analysis.simplify(analysis.substitute(address, substitutions));
}

static FailureOr<sym::ExprHandle> specializeItem(sym::Analysis &analysis,
                                                 sym::ExprHandle expression,
                                                 sym::ExprHandle item,
                                                 int64_t itemValue) {
  sym::ExprHandle concrete = analysis.composeInteger(itemValue);
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{item, concrete}};
  return analysis.simplify(analysis.substitute(expression, substitution));
}

static FailureOr<sym::ExprHandle>
buildB16BitContribution(sym::Analysis &analysis, sym::ExprHandle address,
                        sym::ExprHandle base, sym::ExprHandle item,
                        sym::ExprHandle slot, unsigned firstSlot, int64_t bit,
                        int64_t bitValue, B16Composition composition) {
  int64_t sampleItem = bit < 2 ? 4 * bitValue : bitValue;
  int64_t sampleSlot = bit < 2   ? firstSlot
                       : bit < 4 ? firstSlot + bitValue / 4
                                 : firstSlot;
  if (bit >= 2 && bit < 4)
    sampleItem = 0;
  FailureOr<sym::ExprHandle> sample =
      specializeAddress(analysis, address, item, sampleItem, slot, sampleSlot);
  if (failed(sample))
    return failure();
  FailureOr<sym::ExprHandle> coefficient =
      analysis.compose(*sample, getB16DeltaOp(composition.base), base);
  sym::ExprHandle divisor = analysis.composeInteger(bitValue);
  FailureOr<sym::ExprHandle> ratio =
      analysis.compose(item, sym::ExprBinaryOp::Div, divisor);
  if (failed(coefficient) || failed(ratio))
    return failure();
  sym::ExprHandle itemBit = analysis.composeFloor(*ratio);
  FailureOr<sym::ExprHandle> reduced = analysis.compose(
      itemBit, sym::ExprBinaryOp::Mod, analysis.composeInteger(2));
  if (failed(reduced))
    return failure();
  return analysis.compose(*coefficient, sym::ExprBinaryOp::Mul, *reduced);
}

static FailureOr<sym::ExprHandle>
buildB16SourceAddress(sym::Analysis &analysis, sym::ExprHandle address,
                      sym::ExprHandle item, sym::ExprHandle slot,
                      int64_t itemCount, unsigned firstSlot,
                      B16Composition composition) {
  FailureOr<sym::ExprHandle> base =
      specializeAddress(analysis, address, item, 0, slot, firstSlot);
  if (failed(base))
    return failure();
  FailureOr<sym::ExprHandle> source = *base;
  for (int64_t bit = 0, bitValue = 1; bitValue < itemCount;
       ++bit, bitValue <<= 1) {
    FailureOr<sym::ExprHandle> contribution =
        buildB16BitContribution(analysis, address, *base, item, slot, firstSlot,
                                bit, bitValue, composition);
    if (failed(contribution) || failed(source))
      return failure();
    source = analysis.compose(*source, getB16CombineOp(composition.bits),
                              *contribution);
  }
  return failed(source) ? source : analysis.simplify(*source);
}

static bool verifyB16SourceAddress(sym::Analysis &analysis,
                                   sym::ExprHandle address,
                                   sym::ExprHandle source, sym::ExprHandle item,
                                   sym::ExprHandle slot, int64_t itemCount,
                                   unsigned firstSlot) {
  for (int64_t outputItem = 0; outputItem < itemCount; ++outputItem) {
    int64_t lane = outputItem % 64;
    int64_t sourceBase = outputItem - lane + 16 * (lane / 16) + (lane % 16) / 4;
    for (int64_t within = 0; within < 4; ++within) {
      FailureOr<sym::ExprHandle> actual = specializeAddress(
          analysis, address, item, outputItem, slot, firstSlot + within);
      FailureOr<sym::ExprHandle> supplied =
          specializeItem(analysis, source, item, sourceBase + 4 * within);
      FailureOr<sym::ExprHandle> expected =
          failed(supplied)
              ? FailureOr<sym::ExprHandle>(failure())
              : analysis.compose(*supplied, sym::ExprBinaryOp::Add,
                                 analysis.composeInteger(16 * (lane % 4)));
      FailureOr<sym::ExprHandle> difference =
          failed(actual) || failed(expected)
              ? FailureOr<sym::ExprHandle>(failure())
              : analysis.compose(*actual, sym::ExprBinaryOp::Sub, *expected);
      if (failed(difference))
        return false;
      difference = analysis.simplify(*difference);
      if (failed(difference) || sym::getIntegerLiteralValue(*difference) != 0)
        return false;
    }
  }
  return true;
}

static FailureOr<sym::ExprHandle>
findB16SourceAddress(sym::Analysis &analysis, sym::ExprHandle address,
                     sym::ExprHandle item, sym::ExprHandle slot,
                     int64_t itemCount, unsigned firstSlot) {
  constexpr std::array<B16Composition, 4> compositions{
      B16Composition{B16Combine::Add, B16Combine::Add},
      B16Composition{B16Combine::Add, B16Combine::Xor},
      B16Composition{B16Combine::Xor, B16Combine::Add},
      B16Composition{B16Combine::Xor, B16Combine::Xor}};
  for (B16Composition composition : compositions) {
    FailureOr<sym::ExprHandle> source = buildB16SourceAddress(
        analysis, address, item, slot, itemCount, firstSlot, composition);
    if (succeeded(source) &&
        verifyB16SourceAddress(analysis, address, *source, item, slot,
                               itemCount, firstSlot))
      return source;
  }
  return failure();
}

static bool isValidVerifiedRequest(
    const wave::memory_lowering::GatherTransactionRequest &request) {
  return request.address && request.item && request.slot && request.itemCount &&
         *request.itemCount > 0;
}

static FailureOr<wave::memory_lowering::GatherTransaction>
buildVerifiedB16Transaction(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Store &store,
    std::shared_ptr<const wave::memory_lowering::GatherTransactionEmitter>
        emitter) {
  if (!isValidVerifiedRequest(request))
    return failure();
  FailureOr<sym::ExprHandle> address = indexing::materialize(
      store, request.address->map, request.address->bitOffset);
  if (failed(address))
    return failure();
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, {});
  if (failed(analysis))
    return failure();
  VectorType packet = cast<VectorType>(request.resultType.getElementType());
  if (packet.getNumElements() % 4)
    return failure();
  std::vector<wave::memory_lowering::GatherTransaction::VerifiedAddress>
      verified;
  for (unsigned first = 0; first < packet.getNumElements(); first += 4) {
    FailureOr<sym::ExprHandle> source =
        findB16SourceAddress(**analysis, *address, request.item, request.slot,
                             *request.itemCount, first);
    if (failed(source))
      return failure();
    verified.push_back({first, *source});
  }
  wave::memory_lowering::GatherTransaction transaction;
  transaction.width = 4;
  transaction.verifiedAddresses = std::move(verified);
  transaction.emitter = std::move(emitter);
  return transaction;
}

static FailureOr<sym::ExprHandle>
buildB8VerifiedSourceAddress(sym::Analysis &analysis, sym::Store &store,
                             sym::ExprHandle address, sym::ExprHandle item,
                             sym::ExprHandle slot, unsigned firstSlot) {
  FailureOr<sym::ExprHandle> lane =
      composeIntBinary(store, item, sym::ExprBinaryOp::Mod, 64);
  if (failed(lane))
    return failure();
  FailureOr<sym::ExprHandle> wave = composeFloorDiv(store, item, 64);
  FailureOr<sym::ExprHandle> waveBase =
      failed(wave) ? FailureOr<sym::ExprHandle>(failure())
                   : composeIntBinary(store, *wave, sym::ExprBinaryOp::Mul, 64);
  FailureOr<sym::ExprHandle> group = composeFloorDiv(store, *lane, 16);
  FailureOr<sym::ExprHandle> groupBase =
      failed(group)
          ? FailureOr<sym::ExprHandle>(failure())
          : composeIntBinary(store, *group, sym::ExprBinaryOp::Mul, 16);
  FailureOr<sym::ExprHandle> row =
      composeIntBinary(store, *lane, sym::ExprBinaryOp::Mod, 2);
  FailureOr<sym::ExprHandle> rowBase =
      failed(row) ? FailureOr<sym::ExprHandle>(failure())
                  : composeIntBinary(store, *row, sym::ExprBinaryOp::Mul, 8);
  FailureOr<sym::ExprHandle> sourceItem =
      failed(waveBase) || failed(groupBase) || failed(rowBase)
          ? FailureOr<sym::ExprHandle>(failure())
          : analysis.compose(*waveBase, sym::ExprBinaryOp::Add, *groupBase);
  if (succeeded(sourceItem))
    sourceItem =
        analysis.compose(*sourceItem, sym::ExprBinaryOp::Add, *rowBase);

  FailureOr<sym::ExprHandle> withinGroup =
      composeIntBinary(store, *lane, sym::ExprBinaryOp::Mod, 16);
  FailureOr<sym::ExprHandle> sourceSlot =
      failed(withinGroup) ? FailureOr<sym::ExprHandle>(failure())
                          : composeFloorDiv(store, *withinGroup, 2);
  if (succeeded(sourceSlot))
    sourceSlot =
        composeIntBinary(store, *sourceSlot, sym::ExprBinaryOp::Add, firstSlot);
  if (failed(sourceItem) || failed(sourceSlot))
    return failure();

  // These are the inverse lane/slot coordinates of the gfx950 b8 transpose.
  // The caller proves the resulting address for every participating item and
  // packet slot before allowing the transaction.
  std::array<sym::ExprSubstitution, 2> substitutions{
      sym::ExprSubstitution{item, *sourceItem},
      sym::ExprSubstitution{slot, *sourceSlot}};
  return analysis.simplify(analysis.substitute(address, substitutions));
}

static bool verifyB8SourceAddress(sym::Analysis &analysis,
                                  sym::ExprHandle address,
                                  sym::ExprHandle source, sym::ExprHandle item,
                                  sym::ExprHandle slot, int64_t itemCount,
                                  unsigned firstSlot) {
  for (int64_t outputItem = 0; outputItem < itemCount; ++outputItem) {
    int64_t lane = outputItem % 64;
    int64_t sourceBase = outputItem - lane + 16 * (lane / 16) + (lane % 16) / 8;
    for (int64_t within = 0; within < 8; ++within) {
      FailureOr<sym::ExprHandle> actual = specializeAddress(
          analysis, address, item, outputItem, slot, firstSlot + within);
      FailureOr<sym::ExprHandle> supplied =
          specializeItem(analysis, source, item, sourceBase + 2 * within);
      FailureOr<sym::ExprHandle> expected =
          failed(supplied)
              ? FailureOr<sym::ExprHandle>(failure())
              : analysis.compose(*supplied, sym::ExprBinaryOp::Add,
                                 analysis.composeInteger(8 * (lane % 8)));
      FailureOr<sym::ExprHandle> difference =
          failed(actual) || failed(expected)
              ? FailureOr<sym::ExprHandle>(failure())
              : analysis.compose(*actual, sym::ExprBinaryOp::Sub, *expected);
      if (failed(difference))
        return false;
      difference = analysis.simplify(*difference);
      if (failed(difference) || sym::getIntegerLiteralValue(*difference) != 0)
        return false;
    }
  }
  return true;
}

static FailureOr<wave::memory_lowering::GatherTransaction>
buildVerifiedB8Transaction(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Store &store,
    std::shared_ptr<const wave::memory_lowering::GatherTransactionEmitter>
        emitter) {
  if (!isValidVerifiedRequest(request) || *request.itemCount % 64 != 0)
    return failure();
  FailureOr<sym::ExprHandle> address = indexing::materialize(
      store, request.address->map, request.address->bitOffset);
  if (failed(address))
    return failure();
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, {});
  if (failed(analysis))
    return failure();
  VectorType packet = cast<VectorType>(request.resultType.getElementType());
  if (packet.getNumElements() % 8)
    return failure();
  std::vector<wave::memory_lowering::GatherTransaction::VerifiedAddress>
      verified;
  for (unsigned first = 0; first < packet.getNumElements(); first += 8) {
    FailureOr<sym::ExprHandle> source = buildB8VerifiedSourceAddress(
        **analysis, store, *address, request.item, request.slot, first);
    if (failed(source) ||
        !verifyB8SourceAddress(**analysis, *address, *source, request.item,
                               request.slot, *request.itemCount, first))
      return failure();
    verified.push_back({first, *source});
  }
  wave::memory_lowering::GatherTransaction transaction;
  transaction.width = 8;
  transaction.verifiedAddresses = std::move(verified);
  transaction.emitter = std::move(emitter);
  return transaction;
}

struct TransposeFrame {
  sym::ExprHandle lane;
  sym::ExprHandle waveBase;
  sym::ExprHandle groupBase;
  sym::ExprHandle withinGroup;
  sym::ExprHandle group;
  sym::ExprHandle within;
};

struct TransposeWaveCoordinates {
  sym::ExprHandle lane, waveBase;
};

static FailureOr<TransposeWaveCoordinates>
buildTransposeWaveCoordinates(sym::Store &store, sym::ExprHandle item) {
  FailureOr<sym::ExprHandle> lane =
      composeIntBinary(store, item, sym::ExprBinaryOp::Mod, 64);
  FailureOr<sym::ExprHandle> wave = composeFloorDiv(store, item, 64);
  if (failed(lane) || failed(wave))
    return failure();
  FailureOr<sym::ExprHandle> waveBase =
      composeIntBinary(store, *wave, sym::ExprBinaryOp::Mul, 64);
  if (failed(waveBase))
    return failure();
  return TransposeWaveCoordinates{*lane, *waveBase};
}

struct TransposeGroupCoordinates {
  sym::ExprHandle groupBase, withinGroup;
};

static FailureOr<TransposeGroupCoordinates>
buildTransposeGroupCoordinates(sym::Store &store, sym::ExprHandle lane) {
  FailureOr<sym::ExprHandle> groupIndex = composeFloorDiv(store, lane, 16);
  FailureOr<sym::ExprHandle> groupBase =
      failed(groupIndex)
          ? FailureOr<sym::ExprHandle>(failure())
          : composeIntBinary(store, *groupIndex, sym::ExprBinaryOp::Mul, 16);
  FailureOr<sym::ExprHandle> withinGroup =
      composeIntBinary(store, lane, sym::ExprBinaryOp::Mod, 16);
  if (failed(groupBase) || failed(withinGroup))
    return failure();
  return TransposeGroupCoordinates{*groupBase, *withinGroup};
}

static FailureOr<TransposeFrame> buildTransposeFrame(sym::Store &store,
                                                     sym::ExprHandle item) {
  FailureOr<sym::ExprHandle> group = sym::composeExprSym(store, "group");
  FailureOr<sym::ExprHandle> within = sym::composeExprSym(store, "within");
  if (!item || failed(group) || failed(within))
    return failure();
  FailureOr<TransposeWaveCoordinates> wave =
      buildTransposeWaveCoordinates(store, item);
  if (failed(wave))
    return failure();
  FailureOr<TransposeGroupCoordinates> laneGroup =
      buildTransposeGroupCoordinates(store, wave->lane);
  if (failed(laneGroup))
    return failure();
  return TransposeFrame{
      wave->lane, wave->waveBase, laneGroup->groupBase, laneGroup->withinGroup,
      *group,     *within};
}

struct TransposeSource {
  sym::ExprHandle item, intraBits;
};

static FailureOr<TransposeSource>
buildTransposeSource(sym::Store &store, const TransposeFrame &frame,
                     int64_t width, int64_t lanesPerRow, int64_t elementBits) {
  FailureOr<sym::ExprHandle> sourceBase = sym::composeExprBinary(
      store, frame.waveBase, sym::ExprBinaryOp::Add, frame.groupBase);
  FailureOr<sym::ExprHandle> row =
      composeFloorDiv(store, frame.withinGroup, width);
  if (failed(sourceBase) || failed(row))
    return failure();
  FailureOr<sym::ExprHandle> source =
      sym::composeExprBinary(store, *sourceBase, sym::ExprBinaryOp::Add, *row);
  FailureOr<sym::ExprHandle> slotScale = composeIntBinary(
      store, frame.within, sym::ExprBinaryOp::Mul, lanesPerRow);
  if (failed(source) || failed(slotScale))
    return failure();
  source = sym::composeExprBinary(store, *source, sym::ExprBinaryOp::Add,
                                  *slotScale);
  FailureOr<sym::ExprHandle> laneWithinPacket =
      composeIntBinary(store, frame.lane, sym::ExprBinaryOp::Mod, width);
  FailureOr<sym::ExprHandle> intraBits =
      failed(laneWithinPacket)
          ? FailureOr<sym::ExprHandle>(failure())
          : composeIntBinary(store, *laneWithinPacket, sym::ExprBinaryOp::Mul,
                             elementBits);
  if (failed(source) || failed(intraBits))
    return failure();
  return TransposeSource{*source, *intraBits};
}

struct TransposeOrigin {
  sym::ExprHandle item, slot;
};

static FailureOr<TransposeOrigin>
buildTransposeOrigin(sym::Store &store, const TransposeFrame &frame,
                     int64_t width, int64_t lanesPerRow) {
  FailureOr<sym::ExprHandle> sourceBase = sym::composeExprBinary(
      store, frame.waveBase, sym::ExprBinaryOp::Add, frame.groupBase);
  FailureOr<sym::ExprHandle> laneWithinRow =
      composeIntBinary(store, frame.lane, sym::ExprBinaryOp::Mod, lanesPerRow);
  FailureOr<sym::ExprHandle> originLane =
      failed(laneWithinRow) ? FailureOr<sym::ExprHandle>(failure())
                            : composeIntBinary(store, *laneWithinRow,
                                               sym::ExprBinaryOp::Mul, width);
  FailureOr<sym::ExprHandle> originItem =
      failed(sourceBase) || failed(originLane)
          ? FailureOr<sym::ExprHandle>(failure())
          : sym::composeExprBinary(store, *sourceBase, sym::ExprBinaryOp::Add,
                                   *originLane);
  FailureOr<sym::ExprHandle> packetBase =
      composeIntBinary(store, frame.group, sym::ExprBinaryOp::Mul, width);
  FailureOr<sym::ExprHandle> originRow =
      composeFloorDiv(store, frame.withinGroup, lanesPerRow);
  FailureOr<sym::ExprHandle> originSlot =
      failed(packetBase) || failed(originRow)
          ? FailureOr<sym::ExprHandle>(failure())
          : sym::composeExprBinary(store, *packetBase, sym::ExprBinaryOp::Add,
                                   *originRow);
  if (failed(originItem) || failed(originSlot))
    return failure();
  return TransposeOrigin{*originItem, *originSlot};
}

static FailureOr<wave::memory_lowering::GatherTransaction>
buildHardwareTransposePermutation(
    sym::Store &store, const TransposeFrame &frame, int64_t elementBits,
    std::shared_ptr<const wave::memory_lowering::GatherTransactionEmitter>
        emitter) {
  assert((elementBits == 8 || elementBits == 16) &&
         "unsupported AMD transpose element width");
  int64_t width = 64 / elementBits;
  int64_t lanesPerRow = 16 / width;
  FailureOr<TransposeSource> source =
      buildTransposeSource(store, frame, width, lanesPerRow, elementBits);
  FailureOr<TransposeOrigin> origin =
      buildTransposeOrigin(store, frame, width, lanesPerRow);
  if (failed(source) || failed(origin))
    return failure();

  // One 16-lane hardware row returns W=64/E elements per lane.  Output
  // (item, within) reads from the address supplied by `source` and selects
  // `intraBits` within that address.  (`originItem`, `originSlot`) is the
  // zero-displacement inverse section used to materialize that address:
  //
  //   source = wave + row16 + (16/W)*within + floor((item mod 16)/W)
  //   intraBits = E * (item mod W)
  //   originItem = wave + row16 + W*((item mod 16) mod (16/W))
  //   originSlot = group*W + floor((item mod 16)/(16/W))
  //
  // The generic address model proves the complete A = (A o origin o source)
  // + intraBits relation; this target provider only states the fixed gfx950
  // hardware permutation.
  return wave::memory_lowering::GatherTransaction{static_cast<unsigned>(width),
                                                  source->item,
                                                  source->intraBits,
                                                  origin->item,
                                                  origin->slot,
                                                  {},
                                                  std::move(emitter)};
}

static FailureOr<sym::ExprHandle>
buildB8SourceItem(sym::Store &store, const TransposeFrame &frame) {
  FailureOr<sym::ExprHandle> sourceBase = sym::composeExprBinary(
      store, frame.waveBase, sym::ExprBinaryOp::Add, frame.groupBase);
  FailureOr<sym::ExprHandle> sourceRow =
      composeFloorDiv(store, frame.withinGroup, 2);
  if (failed(sourceBase) || failed(sourceRow))
    return failure();
  return sym::composeExprBinary(store, *sourceBase, sym::ExprBinaryOp::Add,
                                *sourceRow);
}

static FailureOr<sym::ExprHandle>
buildB8IntraBits(sym::Store &store, const TransposeFrame &frame) {
  FailureOr<sym::ExprHandle> laneParity =
      composeIntBinary(store, frame.lane, sym::ExprBinaryOp::Mod, 2);
  FailureOr<sym::ExprHandle> withinPair =
      composeFloorDiv(store, frame.within, 2);
  if (failed(laneParity) || failed(withinPair))
    return failure();
  FailureOr<sym::ExprHandle> parityBits =
      composeIntBinary(store, *laneParity, sym::ExprBinaryOp::Mul, 32);
  FailureOr<sym::ExprHandle> withinBits =
      composeIntBinary(store, *withinPair, sym::ExprBinaryOp::Mul, 8);
  if (failed(parityBits) || failed(withinBits))
    return failure();
  return sym::composeExprBinary(store, *parityBits, sym::ExprBinaryOp::Add,
                                *withinBits);
}

static FailureOr<TransposeOrigin> buildB8Origin(sym::Store &store,
                                                const TransposeFrame &frame,
                                                sym::ExprHandle sourceBase) {
  constexpr int64_t width = 8;
  FailureOr<sym::ExprHandle> originLane =
      composeIntBinary(store, frame.lane, sym::ExprBinaryOp::Mod, width);
  if (succeeded(originLane))
    originLane =
        composeIntBinary(store, *originLane, sym::ExprBinaryOp::Mul, 2);
  FailureOr<sym::ExprHandle> originItem =
      failed(originLane)
          ? FailureOr<sym::ExprHandle>(failure())
          : sym::composeExprBinary(store, sourceBase, sym::ExprBinaryOp::Add,
                                   *originLane);
  FailureOr<sym::ExprHandle> originSlot =
      composeIntBinary(store, frame.group, sym::ExprBinaryOp::Mul, width);
  if (failed(originItem) || failed(originSlot))
    return failure();
  return TransposeOrigin{*originItem, *originSlot};
}

static FailureOr<wave::memory_lowering::GatherTransaction>
buildB8BitAffineTransposePermutation(
    sym::Store &store, const TransposeFrame &frame,
    std::shared_ptr<const wave::memory_lowering::GatherTransactionEmitter>
        emitter) {
  constexpr int64_t width = 8;
  FailureOr<sym::ExprHandle> sourceBase = sym::composeExprBinary(
      store, frame.waveBase, sym::ExprBinaryOp::Add, frame.groupBase);
  FailureOr<sym::ExprHandle> sourceItem = buildB8SourceItem(store, frame);
  FailureOr<sym::ExprHandle> intraBits = buildB8IntraBits(store, frame);
  FailureOr<TransposeOrigin> origin =
      failed(sourceBase) ? FailureOr<TransposeOrigin>(failure())
                         : buildB8Origin(store, frame, *sourceBase);
  if (failed(sourceItem) || failed(intraBits) || failed(origin))
    return failure();

  // MXFP scale layout needs this second gfx950 b8 permutation. The generic
  // transaction proof decides whether an access map has the relation.
  return wave::memory_lowering::GatherTransaction{
      width,        *sourceItem, *intraBits,        origin->item,
      origin->slot, {},          std::move(emitter)};
}

static bool hasTransposeExecutionContext(
    const wave::memory_lowering::GatherTransactionRequest &request) {
  if (request.cache || !request.item || request.bases.size() != 1)
    return false;
  if (!isGfx950(request.op) || isInsideWhere(request.op))
    return false;
  PtrType baseType = dyn_cast<PtrType>(request.bases.front().getType());
  return baseType && isa<SharedAddressSpaceAttr>(baseType.getAddressSpace());
}

static std::optional<int64_t> getTransposeElementBits(VectorType packet) {
  Type element = packet.getElementType();
  if (element.isInteger(8) && packet.getNumElements() >= 8)
    return 8;
  if (packet.getNumElements() >= 4 &&
      (element.isInteger(16) || element.isF16() || element.isBF16()))
    return 16;
  return std::nullopt;
}

static SmallVector<wave::memory_lowering::GatherTransaction, 2>
buildTransposeTransactions(
    sym::Store &store, const TransposeFrame &frame, int64_t elementBits,
    const wave::memory_lowering::GatherTransactionRequest &request) {
  SmallVector<wave::memory_lowering::GatherTransaction, 2> transactions;
  FailureOr<wave::memory_lowering::GatherTransaction> permutation =
      buildHardwareTransposePermutation(store, frame, elementBits,
                                        getTransposeEmitter());
  if (failed(permutation))
    llvm_unreachable(elementBits == 8
                         ? "failed to construct AMD b8 transpose index map"
                         : "failed to construct AMD b16 transpose index map");
  transactions.push_back(std::move(*permutation));
  if (elementBits == 8) {
    FailureOr<wave::memory_lowering::GatherTransaction> bitAffine =
        buildB8BitAffineTransposePermutation(store, frame,
                                             getTransposeEmitter());
    if (failed(bitAffine))
      llvm_unreachable(
          "failed to construct AMD b8 bit-affine transpose index map");
    transactions.push_back(std::move(*bitAffine));
    FailureOr<wave::memory_lowering::GatherTransaction> verified =
        buildVerifiedB8Transaction(request, store, getTransposeEmitter());
    if (succeeded(verified))
      transactions.push_back(std::move(*verified));
  } else {
    FailureOr<wave::memory_lowering::GatherTransaction> verified =
        buildVerifiedB16Transaction(request, store, getTransposeEmitter());
    if (succeeded(verified))
      transactions.push_back(std::move(*verified));
  }
  return transactions;
}

static SmallVector<wave::memory_lowering::GatherTransaction, 2>
getAMDGatherTransactions(
    const wave::memory_lowering::GatherTransactionRequest &request) {
  if (!hasTransposeExecutionContext(request))
    return {};
  VectorType packet = dyn_cast<VectorType>(request.resultType.getElementType());
  if (!packet || request.resultType.getWidth() != 64)
    return {};

  WaveDialect *dialect =
      request.op->getContext()->getLoadedDialect<WaveDialect>();
  if (!dialect)
    llvm_unreachable("Wave dialect must own symbolic memory lowering");
  sym::Store &store = dialect->getSymbolStore();
  FailureOr<TransposeFrame> frame = buildTransposeFrame(store, request.item);
  if (failed(frame))
    llvm_unreachable("failed to construct AMD transpose index map");
  std::optional<int64_t> elementBits = getTransposeElementBits(packet);
  return elementBits
             ? buildTransposeTransactions(store, *frame, *elementBits, request)
             : SmallVector<wave::memory_lowering::GatherTransaction, 2>{};
}

static PtrType getPointerType(Type type) {
  if (SimdType simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  return dyn_cast<PtrType>(type);
}

static Value stripBufferPointerOps(Value value) {
  while (true) {
    if (PtrAddOp add = value.getDefiningOp<PtrAddOp>()) {
      value = add.getBase();
      continue;
    }
    if (PtrCastOp cast = value.getDefiningOp<PtrCastOp>()) {
      value = cast.getSource();
      continue;
    }
    return value;
  }
}

static bool hasBufferSentinel(Value value, DenseSet<Value> &seen) {
  if (!seen.insert(value).second)
    return false;
  PtrType pointer = getPointerType(value.getType());
  if (!pointer ||
      !isa<waveamd::BufferAddressSpaceAttr>(pointer.getAddressSpace()))
    return false;

  value = stripBufferPointerOps(value);
  if (value.getDefiningOp<waveamd::MakeBufferOp>())
    return true;
  BlockArgument argument = dyn_cast<BlockArgument>(value);
  if (!argument || argument.getArgNumber() == 0)
    return false;
  scf::ForOp loop = dyn_cast<scf::ForOp>(argument.getOwner()->getParentOp());
  if (!loop)
    return false;
  unsigned index = argument.getArgNumber() - 1;
  if (index >= loop.getNumRegionIterArgs())
    return false;
  return hasBufferSentinel(loop.getInitArgs()[index], seen);
}

static bool hasBufferSentinel(Value value) {
  DenseSet<Value> seen;
  return hasBufferSentinel(value, seen);
}

static bool supportsDmaLoadLds(Operation *op) {
  ModuleOp targetModule = waveamdmachine::findAMDGPUTargetModule(op);
  if (!targetModule)
    return false;
  StringAttr attr =
      targetModule->getAttrOfType<StringAttr>("waveamdmachine.target");
  if (!attr)
    return false;
  std::optional<waveamdmachine::AMDGPUTarget> target =
      waveamdmachine::parseAMDGPUTargetAttr(attr.getValue());
  return target && !(target->isa.Major == 12 && target->isa.Minor == 5);
}

class AMDCopyTransactionEmitter final
    : public wave::memory_lowering::CopyTransactionEmitter {
public:
  Value emit(IRRewriter &rewriter, Location loc, Type tokenType, Value source,
             Value destination, Value dependency, int64_t bytes,
             bool zeroFillInactive) const override {
    assert((bytes == 16 || bytes == 4) &&
           "DMA width must be validated before emission");
    UnitAttr zeroFill = zeroFillInactive ? rewriter.getUnitAttr() : UnitAttr{};
    return waveamd::DmaLoadLdsOp::create(
               rewriter, loc, tokenType, source, destination, dependency,
               rewriter.getI64IntegerAttr(bytes), rewriter.getI64IntegerAttr(0),
               zeroFill, IntegerAttr{}, IntegerAttr{}, IntegerAttr{})
        .getToken();
  }
};

static std::shared_ptr<const wave::memory_lowering::CopyTransactionEmitter>
getCopyEmitter() {
  static const std::shared_ptr<
      const wave::memory_lowering::CopyTransactionEmitter>
      emitter = std::make_shared<AMDCopyTransactionEmitter>();
  return emitter;
}

static bool hasDmaCopyAddressContract(
    const wave::memory_lowering::CopyTransactionRequest &request,
    PtrType source, PtrType destination) {
  if (!source || !destination || !supportsDmaLoadLds(request.op))
    return false;
  if (!isa<GlobalAddressSpaceAttr, waveamd::BufferAddressSpaceAttr>(
          source.getAddressSpace()) ||
      !isa<SharedAddressSpaceAttr>(destination.getAddressSpace()))
    return false;
  return !request.zeroFillInactive ||
         (isa<waveamd::BufferAddressSpaceAttr>(source.getAddressSpace()) &&
          hasBufferSentinel(request.sourceBase));
}

static bool isDmaElementBits(int64_t bits) {
  return bits == 8 || bits == 16 || bits == 32;
}

static SmallVector<int64_t>
getDmaCopyWidths(const wave::memory_lowering::CopyTransactionRequest &request) {
  VectorType packet = dyn_cast<VectorType>(request.packetType.getElementType());
  if (!packet || (request.packetType.getWidth() != 32 &&
                  request.packetType.getWidth() != 64))
    return {};
  Type element = packet.getElementType();
  if (!element.isIntOrFloat())
    return {};
  int64_t elementBits = element.getIntOrFloatBitWidth();
  if (!isDmaElementBits(elementBits))
    return {};
  int64_t elementBytes = elementBits / 8;
  int64_t packetBytes = packet.getNumElements() * elementBytes;
  SmallVector<int64_t> widths;
  for (int64_t bytes : {16, 4})
    if (bytes <= packetBytes && bytes % elementBytes == 0)
      widths.push_back(bytes);
  return widths;
}

static SmallVector<wave::memory_lowering::CopyTransaction>
getAMDCopyTransactions(
    const wave::memory_lowering::CopyTransactionRequest &request) {
  if (!request.op)
    return {};
  PtrType source = dyn_cast<PtrType>(request.sourceBase.getType());
  PtrType destination = dyn_cast<PtrType>(request.destinationBase.getType());
  if (!hasDmaCopyAddressContract(request, source, destination))
    return {};
  SmallVector<wave::memory_lowering::CopyTransaction> transactions;
  int64_t elementBits = cast<VectorType>(request.packetType.getElementType())
                            .getElementType()
                            .getIntOrFloatBitWidth();
  for (int64_t bytes : getDmaCopyWidths(request)) {
    // AMD copy transactions natively pack byte and halfword elements at the
    // provider-selected width. Widening native dword elements still requires
    // the complete u32 window proof.
    int64_t windowBytes = elementBits < 32 ? 0 : bytes;
    transactions.push_back({bytes, windowBytes, getCopyEmitter()});
  }
  return transactions;
}

} // namespace

SmallVector<mlir::wave::memory_lowering::GatherTransaction, 2>
mlir::wave::memory_lowering::getGatherTransactions(
    const GatherTransactionRequest &request) {
  return getAMDGatherTransactions(request);
}

SmallVector<mlir::wave::memory_lowering::CopyTransaction>
mlir::wave::memory_lowering::getCopyTransactions(
    const CopyTransactionRequest &request) {
  return getAMDCopyTransactions(request);
}
