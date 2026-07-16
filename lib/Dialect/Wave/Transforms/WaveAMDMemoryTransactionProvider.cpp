//===- WaveAMDMemoryTransactionProvider.cpp - AMD memory plans -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveMemoryTransactionProvider.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/TargetParser/AMDGPUTargetParser.h"

#include <array>
#include <memory>
#include <optional>

using namespace mlir;
using namespace mlir::wave;

namespace {

static FailureOr<sym::ExprHandle> composeInt(sym::Store &store,
                                             sym::ExprHandle lhs,
                                             sym::ExprBinaryOp op,
                                             int64_t rhs) {
  FailureOr<sym::ExprHandle> value = sym::composeExprInt(store, rhs);
  if (failed(value))
    return failure();
  return sym::composeExprBinary(store, lhs, op, *value);
}

static FailureOr<sym::ExprHandle> compose(sym::Store &store,
                                          sym::ExprHandle lhs,
                                          sym::ExprBinaryOp op,
                                          sym::ExprHandle rhs) {
  return sym::composeExprBinary(store, lhs, op, rhs);
}

static FailureOr<sym::ExprHandle>
floorDiv(sym::Store &store, sym::ExprHandle value, int64_t divisor) {
  FailureOr<sym::ExprHandle> divided =
      composeInt(store, value, sym::ExprBinaryOp::Div, divisor);
  if (failed(divided))
    return failure();
  return sym::composeExprFloor(store, *divided);
}

static bool proveEqual(sym::Store &store, sym::ExprHandle lhs,
                       sym::ExprHandle rhs,
                       ArrayRef<sym::PredHandle> assumptions) {
  if (lhs == rhs)
    return true;
  FailureOr<sym::ExprHandle> difference =
      compose(store, lhs, sym::ExprBinaryOp::Sub, rhs);
  if (succeeded(difference)) {
    FailureOr<sym::ExprHandle> simplified =
        sym::simplifyExpr(store, *difference, assumptions);
    if (succeeded(simplified) && sym::getIntegerLiteralValue(*simplified) == 0)
      return true;
  }
  FailureOr<sym::PredHandle> equal =
      sym::composePredCmp(store, lhs, sym::PredCmpOp::Eq, rhs);
  return succeeded(equal) && sym::checkPredicate(store, *equal, assumptions) ==
                                 sym::CheckResult::True;
}

static SmallVector<sym::PredHandle> collectAssumptions(
    ArrayRef<wave::memory_lowering::MemoryTransactionPoint> points) {
  SmallVector<sym::PredHandle> assumptions;
  for (const wave::memory_lowering::MemoryTransactionPoint &point : points)
    llvm::append_range(assumptions, point.assumptions);
  return assumptions;
}

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

static const wave::memory_lowering::MemoryTransactionBinding *
findBinding(const wave::memory_lowering::MemoryTransactionPoint &point,
            StringRef name) {
  auto found = llvm::find_if(point.bindings, [&](const auto &binding) {
    return binding.name == name;
  });
  return found == point.bindings.end() ? nullptr : &*found;
}

static bool hasOnlyUniformBindings(
    sym::ExprHandle expr,
    const wave::memory_lowering::MemoryTransactionPoint &point) {
  bool uniform = true;
  sym::walkSymbolNames(expr, [&](StringRef name) {
    if (!uniform || name == "item")
      return;
    const wave::memory_lowering::MemoryTransactionBinding *binding =
        findBinding(point, name);
    uniform = binding && !isa<SimdType>(binding->value.getType());
  });
  return uniform;
}

static std::optional<int64_t> getWorkgroupItemCount(Operation *op) {
  func::FuncOp func = op->getParentOfType<func::FuncOp>();
  if (!func)
    return std::nullopt;
  DenseI32ArrayAttr shape;
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"})
    if ((shape = func->getAttrOfType<DenseI32ArrayAttr>(name)))
      break;
  if (!shape || shape.size() != 3)
    return std::nullopt;

  int64_t count = 1;
  for (int32_t dim : shape.asArrayRef()) {
    if (dim <= 0 || count > 1024 / dim)
      return std::nullopt;
    count *= dim;
  }
  if (count % 64 != 0)
    return std::nullopt;
  return count;
}

static FailureOr<sym::ExprHandle>
substituteItem(sym::Store &store, sym::ExprHandle expr, sym::ExprHandle item,
               int64_t replacement, ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> literal = sym::composeExprInt(store, replacement);
  if (failed(literal))
    return failure();
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{item, *literal}};
  FailureOr<sym::ExprHandle> replaced =
      sym::substituteExpr(store, expr, substitution);
  if (failed(replaced))
    return failure();
  return sym::simplifyExpr(store, *replaced, assumptions);
}

static bool isWaveUniform(Operation *op, sym::Store &store,
                          sym::ExprHandle expr, sym::ExprHandle item,
                          ArrayRef<sym::PredHandle> assumptions) {
  std::optional<int64_t> itemCount = getWorkgroupItemCount(op);
  if (!itemCount)
    return false;
  for (int64_t wave = 0; wave < *itemCount; wave += 64) {
    FailureOr<sym::ExprHandle> reference =
        substituteItem(store, expr, item, wave, assumptions);
    if (failed(reference))
      return false;
    for (int64_t lane = 1; lane < 64; ++lane) {
      FailureOr<sym::ExprHandle> current =
          substituteItem(store, expr, item, wave + lane, assumptions);
      if (failed(current) ||
          !proveEqual(store, *reference, *current, assumptions))
        return false;
    }
  }
  return true;
}

struct CanonicalB8Mapping {
  sym::ExprHandle item;
  sym::ExprHandle lane;
  sym::ExprHandle matrixOffset;
};

static FailureOr<CanonicalB8Mapping>
buildCanonicalB8Mapping(sym::Store &store) {
  FailureOr<sym::ExprHandle> item = sym::composeExprSym(store, "item");
  if (failed(item))
    return failure();
  FailureOr<sym::ExprHandle> lane =
      composeInt(store, *item, sym::ExprBinaryOp::Mod, 64);
  if (failed(lane))
    return failure();
  FailureOr<sym::ExprHandle> group = floorDiv(store, *lane, 16);
  FailureOr<sym::ExprHandle> row =
      composeInt(store, *item, sym::ExprBinaryOp::Mod, 16);
  if (failed(group) || failed(row))
    return failure();
  FailureOr<sym::ExprHandle> groupBytes =
      composeInt(store, *group, sym::ExprBinaryOp::Mul, 128);
  FailureOr<sym::ExprHandle> rowBytes =
      composeInt(store, *row, sym::ExprBinaryOp::Mul, 4);
  if (failed(groupBytes) || failed(rowBytes))
    return failure();
  FailureOr<sym::ExprHandle> matrixOffset =
      compose(store, *groupBytes, sym::ExprBinaryOp::Add, *rowBytes);
  if (failed(matrixOffset))
    return failure();
  return CanonicalB8Mapping{*item, *lane, *matrixOffset};
}

static FailureOr<sym::ExprHandle> getCanonicalB8TileBase(
    const wave::memory_lowering::GatherTransactionRequest &request,
    const CanonicalB8Mapping &mapping, ArrayRef<sym::PredHandle> assumptions) {
  sym::Store &store = *request.store;
  ArrayRef<wave::memory_lowering::MemoryTransactionPoint> points =
      request.points;
  FailureOr<sym::ExprHandle> tileBase =
      compose(store, points.front().byteOffset, sym::ExprBinaryOp::Sub,
              mapping.matrixOffset);
  if (failed(tileBase))
    return failure();
  tileBase = sym::simplifyExpr(store, *tileBase, assumptions);
  if (failed(tileBase) || !hasOnlyUniformBindings(*tileBase, points.front()))
    return failure();
  return tileBase;
}

static LogicalResult verifyCanonicalB8Points(
    const wave::memory_lowering::GatherTransactionRequest &request,
    const CanonicalB8Mapping &mapping, sym::ExprHandle tileBase,
    ArrayRef<sym::PredHandle> assumptions) {
  sym::Store &store = *request.store;
  ArrayRef<wave::memory_lowering::MemoryTransactionPoint> points =
      request.points;
  for (auto [slot, point] : llvm::enumerate(points)) {
    if (point.baseIndex != points.front().baseIndex ||
        !proveEqual(store, point.base, points.front().base, assumptions) ||
        !proveEqual(store, point.targetBlock, points.front().targetBlock,
                    assumptions))
      return failure();
    FailureOr<sym::ExprHandle> expected =
        compose(store, tileBase, sym::ExprBinaryOp::Add, mapping.matrixOffset);
    if (failed(expected))
      return failure();
    expected = composeInt(store, *expected, sym::ExprBinaryOp::Add, slot / 2);
    if (failed(expected) ||
        !proveEqual(store, *expected, point.byteOffset, assumptions))
      return failure();
  }
  return success();
}

static bool isCanonicalB8WaveBaseUniform(
    const wave::memory_lowering::GatherTransactionRequest &request,
    const CanonicalB8Mapping &mapping, sym::ExprHandle tileBase,
    ArrayRef<sym::PredHandle> assumptions) {
  sym::Store &store = *request.store;
  FailureOr<sym::ExprHandle> waveItem =
      compose(store, mapping.item, sym::ExprBinaryOp::Sub, mapping.lane);
  if (failed(waveItem))
    return false;
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{mapping.item, *waveItem}};
  FailureOr<sym::ExprHandle> waveBase =
      sym::substituteExpr(store, tileBase, substitution);
  if (failed(waveBase))
    return false;
  waveBase = sym::simplifyExpr(store, *waveBase, assumptions);
  if (failed(waveBase))
    return false;
  return proveEqual(store, tileBase, *waveBase, assumptions) ||
         isWaveUniform(request.op, store, tileBase, mapping.item, assumptions);
}

static FailureOr<sym::ExprHandle> getCanonicalB8AddressOffset(
    const wave::memory_lowering::GatherTransactionRequest &request) {
  sym::Store &store = *request.store;
  SmallVector<sym::PredHandle> assumptions = collectAssumptions(request.points);
  FailureOr<CanonicalB8Mapping> mapping = buildCanonicalB8Mapping(store);
  if (failed(mapping))
    return failure();
  FailureOr<sym::ExprHandle> tileBase =
      getCanonicalB8TileBase(request, *mapping, assumptions);
  if (failed(tileBase) ||
      failed(
          verifyCanonicalB8Points(request, *mapping, *tileBase, assumptions)) ||
      !isCanonicalB8WaveBaseUniform(request, *mapping, *tileBase, assumptions))
    return failure();
  FailureOr<sym::ExprHandle> laneBytes =
      composeInt(store, mapping->lane, sym::ExprBinaryOp::Mul, 8);
  if (failed(laneBytes))
    return failure();
  FailureOr<sym::ExprHandle> address =
      compose(store, *tileBase, sym::ExprBinaryOp::Add, *laneBytes);
  if (failed(address))
    return failure();
  return sym::simplifyExpr(store, *address, assumptions);
}

static FailureOr<sym::ExprHandle> synthesizeBitAffineB8SourceAddress(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::ExprHandle item, int64_t itemCount,
    ArrayRef<sym::PredHandle> assumptions) {
  sym::Store &store = *request.store;
  const wave::memory_lowering::MemoryTransactionPoint &point =
      request.points.front();
  FailureOr<sym::ExprHandle> base =
      substituteItem(store, point.byteOffset, item, 0, assumptions);
  if (failed(base))
    return failure();

  sym::ExprHandle address = *base;
  std::optional<sym::ExprHandle> bitTwoCoefficient;
  for (int64_t bit = 0, bitValue = 1; bitValue < itemCount;
       ++bit, bitValue <<= 1) {
    // Result relation hides source bit 3; hardware tile continues bit 2.
    FailureOr<sym::ExprHandle> coefficient = failure();
    if (bit == 3) {
      if (!bitTwoCoefficient)
        return failure();
      coefficient =
          composeInt(store, *bitTwoCoefficient, sym::ExprBinaryOp::Mul, 2);
    } else {
      int64_t outputItem = bit < 3 ? 2 * bitValue : bitValue;
      FailureOr<sym::ExprHandle> sample = substituteItem(
          store, point.byteOffset, item, outputItem, assumptions);
      if (failed(sample))
        return failure();
      coefficient = compose(store, *sample, sym::ExprBinaryOp::Sub, *base);
    }
    if (failed(coefficient))
      return failure();
    coefficient = sym::simplifyExpr(store, *coefficient, assumptions);
    if (failed(coefficient))
      return failure();
    if (bit == 2)
      bitTwoCoefficient = *coefficient;
    if (sym::getIntegerLiteralValue(*coefficient) == 0)
      continue;

    FailureOr<sym::ExprHandle> itemBit = floorDiv(store, item, bitValue);
    if (failed(itemBit))
      return failure();
    itemBit = composeInt(store, *itemBit, sym::ExprBinaryOp::Mod, 2);
    if (failed(itemBit))
      return failure();
    FailureOr<sym::ExprHandle> contribution =
        compose(store, *coefficient, sym::ExprBinaryOp::Mul, *itemBit);
    if (failed(contribution))
      return failure();
    FailureOr<sym::ExprHandle> next =
        compose(store, address, sym::ExprBinaryOp::Add, *contribution);
    if (failed(next))
      return failure();
    address = *next;
  }
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(store, address, assumptions);
  if (failed(simplified) || !hasOnlyUniformBindings(*simplified, point))
    return failure();
  address = *simplified;
  return address;
}

static LogicalResult verifyBitAffineB8Points(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::ExprHandle item, int64_t itemCount, sym::ExprHandle sourceAddress,
    ArrayRef<sym::PredHandle> assumptions) {
  sym::Store &store = *request.store;
  ArrayRef<wave::memory_lowering::MemoryTransactionPoint> points =
      request.points;
  for (const wave::memory_lowering::MemoryTransactionPoint &point : points) {
    if (point.baseIndex != points.front().baseIndex ||
        !proveEqual(store, point.base, points.front().base, assumptions) ||
        !proveEqual(store, point.targetBlock, points.front().targetBlock,
                    assumptions))
      return failure();
  }
  for (int64_t outputItem = 0; outputItem < itemCount; ++outputItem) {
    int64_t lane = outputItem % 64;
    int64_t sourceItem = outputItem - lane + 16 * (lane / 16) + (lane % 16) / 2;
    FailureOr<sym::ExprHandle> source =
        substituteItem(store, sourceAddress, item, sourceItem, assumptions);
    if (failed(source))
      return failure();
    for (auto [slot, point] : llvm::enumerate(points)) {
      FailureOr<sym::ExprHandle> actual = substituteItem(
          store, point.byteOffset, item, outputItem, assumptions);
      FailureOr<sym::ExprHandle> expected =
          composeInt(store, *source, sym::ExprBinaryOp::Add,
                     4 * (lane % 2) + static_cast<int64_t>(slot / 2));
      if (failed(actual) || failed(expected) ||
          !proveEqual(store, *expected, *actual, assumptions))
        return failure();
    }
  }
  return success();
}

static FailureOr<sym::ExprHandle> getBitAffineB8AddressOffset(
    const wave::memory_lowering::GatherTransactionRequest &request) {
  sym::Store &store = *request.store;
  SmallVector<sym::PredHandle> assumptions = collectAssumptions(request.points);
  FailureOr<sym::ExprHandle> item = sym::composeExprSym(store, "item");
  std::optional<int64_t> itemCount = getWorkgroupItemCount(request.op);
  if (failed(item) || !itemCount)
    return failure();
  FailureOr<sym::ExprHandle> sourceAddress = synthesizeBitAffineB8SourceAddress(
      request, *item, *itemCount, assumptions);
  if (failed(sourceAddress))
    return failure();
  if (failed(verifyBitAffineB8Points(request, *item, *itemCount, *sourceAddress,
                                     assumptions)))
    return failure();
  return sourceAddress;
}

static FailureOr<sym::ExprHandle> getB8AddressOffset(
    const wave::memory_lowering::GatherTransactionRequest &request) {
  FailureOr<sym::ExprHandle> canonical = getCanonicalB8AddressOffset(request);
  if (succeeded(canonical))
    return canonical;
  return getBitAffineB8AddressOffset(request);
}

enum class B16SourceComposition { Add, Xor };

static FailureOr<sym::ExprHandle> synthesizeB16SourceAddress(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::ExprHandle item, int64_t itemCount,
    ArrayRef<sym::PredHandle> assumptions, B16SourceComposition composition) {
  sym::Store &store = *request.store;
  FailureOr<sym::ExprHandle> base = substituteItem(
      store, request.points.front().byteOffset, item, 0, assumptions);
  if (failed(base))
    return failure();

  sym::ExprHandle address = *base;
  for (int64_t bit = 0, bitValue = 1; bitValue < itemCount;
       ++bit, bitValue <<= 1) {
    int64_t slot = 0;
    int64_t outputItem = bitValue;
    if (bit < 2)
      outputItem = 4 * bitValue;
    else if (bit < 4) {
      slot = bitValue / 4;
      outputItem = 0;
    }
    FailureOr<sym::ExprHandle> sample = substituteItem(
        store, request.points[slot].byteOffset, item, outputItem, assumptions);
    if (failed(sample))
      return failure();
    FailureOr<sym::ExprHandle> coefficient = compose(
        store, *sample,
        composition == B16SourceComposition::Add ? sym::ExprBinaryOp::Sub
                                                 : sym::ExprBinaryOp::Xor,
        *base);
    if (failed(coefficient))
      return failure();
    coefficient = sym::simplifyExpr(store, *coefficient, assumptions);
    if (failed(coefficient))
      return failure();
    if (sym::getIntegerLiteralValue(*coefficient) == 0)
      continue;

    FailureOr<sym::ExprHandle> itemBit = floorDiv(store, item, bitValue);
    if (failed(itemBit))
      return failure();
    itemBit = composeInt(store, *itemBit, sym::ExprBinaryOp::Mod, 2);
    if (failed(itemBit))
      return failure();
    FailureOr<sym::ExprHandle> contribution =
        compose(store, *coefficient, sym::ExprBinaryOp::Mul, *itemBit);
    if (failed(contribution))
      return failure();
    FailureOr<sym::ExprHandle> next = compose(
        store, address,
        composition == B16SourceComposition::Add ? sym::ExprBinaryOp::Add
                                                 : sym::ExprBinaryOp::Xor,
        *contribution);
    if (failed(next))
      return failure();
    address = *next;
  }
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(store, address, assumptions);
  if (failed(simplified) ||
      !hasOnlyUniformBindings(*simplified, request.points.front()))
    return failure();
  return simplified;
}

static LogicalResult
verifyB16Points(const wave::memory_lowering::GatherTransactionRequest &request,
                sym::ExprHandle item, int64_t itemCount,
                sym::ExprHandle sourceAddress,
                ArrayRef<sym::PredHandle> assumptions) {
  sym::Store &store = *request.store;
  ArrayRef<wave::memory_lowering::MemoryTransactionPoint> points =
      request.points;
  for (const wave::memory_lowering::MemoryTransactionPoint &point : points) {
    if (point.baseIndex != points.front().baseIndex ||
        !proveEqual(store, point.base, points.front().base, assumptions) ||
        !proveEqual(store, point.targetBlock, points.front().targetBlock,
                    assumptions))
      return failure();
  }
  for (int64_t outputItem = 0; outputItem < itemCount; ++outputItem) {
    int64_t lane = outputItem % 64;
    for (auto [slot, point] : llvm::enumerate(points)) {
      int64_t sourceItem =
          outputItem - lane + 16 * (lane / 16) + (lane % 16) / 4 + 4 * slot;
      FailureOr<sym::ExprHandle> source =
          substituteItem(store, sourceAddress, item, sourceItem, assumptions);
      FailureOr<sym::ExprHandle> actual = substituteItem(
          store, point.byteOffset, item, outputItem, assumptions);
      if (failed(source) || failed(actual))
        return failure();
      FailureOr<sym::ExprHandle> expected =
          composeInt(store, *source, sym::ExprBinaryOp::Add, 2 * (lane % 4));
      if (failed(expected) ||
          !proveEqual(store, *expected, *actual, assumptions))
        return failure();
    }
  }
  return success();
}

static FailureOr<sym::ExprHandle> getB16AddressOffset(
    const wave::memory_lowering::GatherTransactionRequest &request) {
  sym::Store &store = *request.store;
  SmallVector<sym::PredHandle> assumptions = collectAssumptions(request.points);
  FailureOr<sym::ExprHandle> item = sym::composeExprSym(store, "item");
  std::optional<int64_t> itemCount = getWorkgroupItemCount(request.op);
  if (failed(item) || !itemCount)
    return failure();
  for (B16SourceComposition composition :
       {B16SourceComposition::Add, B16SourceComposition::Xor}) {
    FailureOr<sym::ExprHandle> sourceAddress = synthesizeB16SourceAddress(
        request, *item, *itemCount, assumptions, composition);
    if (succeeded(sourceAddress) &&
        succeeded(verifyB16Points(request, *item, *itemCount, *sourceAddress,
                                  assumptions)))
      return sourceAddress;
  }
  return failure();
}

class TransposeEmitter final
    : public wave::memory_lowering::GatherTransactionEmitter {
public:
  FailureOr<wave::memory_lowering::GatherTransactionResult>
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

static bool hasB8PacketType(SimdType type) {
  VectorType packet = dyn_cast<VectorType>(type.getElementType());
  return packet && type.getWidth() == 64 && packet.getNumElements() == 8 &&
         packet.getElementType().isInteger(8);
}

static bool hasB16PacketType(SimdType type) {
  VectorType packet = dyn_cast<VectorType>(type.getElementType());
  if (!packet || type.getWidth() != 64 || packet.getNumElements() != 4)
    return false;
  Type element = packet.getElementType();
  return element.isInteger(16) || element.isF16() || element.isBF16();
}

static bool hasTransposeExecutionContext(
    const wave::memory_lowering::GatherTransactionRequest &request,
    size_t pointCount) {
  if (request.points.size() != pointCount || request.cache)
    return false;
  if (!isGfx950(request.op) || !getWorkgroupItemCount(request.op) ||
      isInsideWhere(request.op))
    return false;
  PtrType baseType = dyn_cast<PtrType>(request.bases.front().getType());
  return baseType && isa<SharedAddressSpaceAttr>(baseType.getAddressSpace());
}

class AMDGatherTransactionProvider final
    : public wave::memory_lowering::GatherTransactionProvider {
public:
  void
  enumerate(const wave::memory_lowering::GatherTransactionRequest &request,
            SmallVectorImpl<wave::memory_lowering::GatherTransactionCandidate>
                &candidates) const override {
    FailureOr<sym::ExprHandle> address = failure();
    if (hasB8PacketType(request.resultType) &&
        hasTransposeExecutionContext(request, 8))
      address = getB8AddressOffset(request);
    else if (hasB16PacketType(request.resultType) &&
             hasTransposeExecutionContext(request, 4))
      address = getB16AddressOffset(request);
    else
      return;
    if (failed(address))
      return;
    wave::memory_lowering::GatherTransactionCandidate candidate;
    for (unsigned slot = 0; slot < request.points.size(); ++slot)
      candidate.slots.push_back(slot);
    candidate.emitter = std::make_unique<TransposeEmitter>();
    candidate.byteOffset = *address;
    candidate.baseIndex = request.points.front().baseIndex;
    candidates.push_back(std::move(candidate));
  }
};

} // namespace

void mlir::wave::memory_lowering::populateGatherTransactionProviders(
    SmallVectorImpl<std::unique_ptr<GatherTransactionProvider>> &providers) {
  providers.push_back(std::make_unique<AMDGatherTransactionProvider>());
}
