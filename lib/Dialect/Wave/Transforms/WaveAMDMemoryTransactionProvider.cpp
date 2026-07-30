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
#include "llvm/ADT/STLExtras.h"
#include "llvm/TargetParser/AMDGPUTargetParser.h"

#include <algorithm>
#include <array>
#include <memory>
#include <optional>

using namespace mlir;
using namespace mlir::wave;

namespace {

static FailureOr<sym::ExprHandle> composeInt(sym::Analysis &analysis,
                                             sym::ExprHandle lhs,
                                             sym::ExprBinaryOp op,
                                             int64_t rhs) {
  FailureOr<sym::ExprHandle> value = analysis.composeInteger(rhs);
  if (failed(value))
    return failure();
  return analysis.compose(lhs, op, *value);
}

static FailureOr<sym::ExprHandle> compose(sym::Analysis &analysis,
                                          sym::ExprHandle lhs,
                                          sym::ExprBinaryOp op,
                                          sym::ExprHandle rhs) {
  return analysis.compose(lhs, op, rhs);
}

static FailureOr<sym::ExprHandle>
floorDiv(sym::Analysis &analysis, sym::ExprHandle value, int64_t divisor) {
  FailureOr<sym::ExprHandle> divided =
      composeInt(analysis, value, sym::ExprBinaryOp::Div, divisor);
  if (failed(divided))
    return failure();
  return analysis.composeFloor(*divided);
}

static bool proveEqual(sym::Analysis &analysis, sym::ExprHandle lhs,
                       sym::ExprHandle rhs) {
  return analysis.equivalent(lhs, rhs) == sym::CheckResult::True;
}

static FailureOr<sym::ExprHandle>
simplifyForMaterialization(sym::Analysis &analysis, sym::ExprHandle expr) {
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(expr);
  if (failed(simplified))
    return failure();
  return shouldUseSimplifiedIndexExpr(*simplified, expr) ? *simplified : expr;
}

enum class AddressForm { Proof, Materialization };

static sym::ExprHandle
getByteOffset(const wave::memory_lowering::MemoryTransactionPoint &point,
              AddressForm form) {
  return form == AddressForm::Proof ? point.byteOffset
                                    : point.materializationByteOffset;
}

static FailureOr<sym::ExprHandle> simplifyAddress(sym::Analysis &analysis,
                                                  sym::ExprHandle expr,
                                                  AddressForm form) {
  if (form == AddressForm::Proof)
    return analysis.simplify(expr);
  return simplifyForMaterialization(analysis, expr);
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
    const wave::memory_lowering::MemoryTransactionPoint &point,
    StringRef executionItemName = "item") {
  bool uniform = true;
  sym::walkSymbolNames(expr, [&](StringRef name) {
    if (!uniform || name == executionItemName)
      return;
    const wave::memory_lowering::MemoryTransactionBinding *binding =
        findBinding(point, name);
    uniform = binding && !isa<SimdType>(binding->value.getType());
  });
  return uniform;
}

static FailureOr<sym::ExprHandle> selectAddressForMaterialization(
    sym::Analysis &analysis, sym::ExprHandle proof,
    sym::ExprHandle materialization,
    const wave::memory_lowering::MemoryTransactionPoint &point,
    StringRef executionItemName = "item") {
  if (!proveEqual(analysis, proof, materialization))
    return failure();
  sym::ExprHandle selected =
      shouldUseSimplifiedIndexExpr(proof, materialization) ? proof
                                                           : materialization;
  if (!hasOnlyUniformBindings(selected, point, executionItemName))
    return failure();
  return selected;
}

static DenseI32ArrayAttr getWorkgroupShape(Operation *op) {
  func::FuncOp func = op->getParentOfType<func::FuncOp>();
  if (!func)
    return {};
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"})
    if (DenseI32ArrayAttr shape = func->getAttrOfType<DenseI32ArrayAttr>(name))
      return shape;
  return {};
}

static std::optional<int64_t> getWorkgroupItemCount(Operation *op) {
  DenseI32ArrayAttr shape = getWorkgroupShape(op);
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

static bool hasSymbol(sym::ExprHandle expression, StringRef name) {
  bool found = false;
  sym::walkSymbolNames(
      expression, [&](StringRef candidate) { found |= candidate == name; });
  return found;
}

struct ExecutionItem {
  StringRef name;
  sym::ExprHandle expression;
};

static FailureOr<ExecutionItem> getCanonicalExecutionItem(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis) {
  if (!llvm::any_of(request.points, [](const auto &point) {
        return hasSymbol(point.byteOffset, "item");
      }))
    return failure();
  FailureOr<sym::ExprHandle> item = analysis.composeSymbol("item");
  if (failed(item))
    return failure();
  return ExecutionItem{"item", *item};
}

static bool
bindsXAxisWorkitem(const wave::memory_lowering::MemoryTransactionPoint &point,
                   StringRef name) {
  const wave::memory_lowering::MemoryTransactionBinding *binding =
      findBinding(point, name);
  if (!binding || !hasSymbol(point.byteOffset, name))
    return false;
  WorkitemIdOp workitem = binding->value.getDefiningOp<WorkitemIdOp>();
  return workitem && workitem.getAxis() == 0;
}

static FailureOr<ExecutionItem> getBoundExecutionItem(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis) {
  DenseI32ArrayAttr shape = getWorkgroupShape(request.op);
  if (!shape || shape.size() != 3 || shape[1] != 1 || shape[2] != 1)
    return failure();
  for (const wave::memory_lowering::MemoryTransactionBinding &binding :
       request.points.front().bindings) {
    bool common = llvm::all_of(request.points, [&](const auto &point) {
      return bindsXAxisWorkitem(point, binding.name);
    });
    if (!common)
      continue;
    FailureOr<sym::ExprHandle> item = analysis.composeSymbol(binding.name);
    if (succeeded(item))
      return ExecutionItem{binding.name, *item};
  }
  return failure();
}

static FailureOr<ExecutionItem>
getExecutionItem(const wave::memory_lowering::GatherTransactionRequest &request,
                 sym::Analysis &analysis) {
  FailureOr<ExecutionItem> canonical =
      getCanonicalExecutionItem(request, analysis);
  if (succeeded(canonical))
    return canonical;
  return getBoundExecutionItem(request, analysis);
}

static FailureOr<sym::ExprHandle> substituteItem(sym::Analysis &analysis,
                                                 sym::ExprHandle expr,
                                                 sym::ExprHandle item,
                                                 int64_t replacement) {
  FailureOr<sym::ExprHandle> literal = analysis.composeInteger(replacement);
  if (failed(literal))
    return failure();
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{item, *literal}};
  FailureOr<sym::ExprHandle> replaced = analysis.substitute(expr, substitution);
  if (failed(replaced))
    return failure();
  return analysis.simplify(*replaced);
}

static FailureOr<sym::ExprHandle>
substituteItemForMaterialization(sym::Analysis &analysis, sym::ExprHandle expr,
                                 sym::ExprHandle item, int64_t replacement) {
  FailureOr<sym::ExprHandle> literal = analysis.composeInteger(replacement);
  if (failed(literal))
    return failure();
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{item, *literal}};
  FailureOr<sym::ExprHandle> replaced = analysis.substitute(expr, substitution);
  if (failed(replaced))
    return failure();
  return simplifyForMaterialization(analysis, *replaced);
}

static FailureOr<sym::ExprHandle> substituteAddressItem(sym::Analysis &analysis,
                                                        sym::ExprHandle expr,
                                                        sym::ExprHandle item,
                                                        int64_t replacement,
                                                        AddressForm form) {
  if (form == AddressForm::Proof)
    return substituteItem(analysis, expr, item, replacement);
  return substituteItemForMaterialization(analysis, expr, item, replacement);
}

static bool isWaveUniform(Operation *op, sym::Analysis &analysis,
                          sym::ExprHandle expr, sym::ExprHandle item) {
  std::optional<int64_t> itemCount = getWorkgroupItemCount(op);
  if (!itemCount)
    return false;
  for (int64_t wave = 0; wave < *itemCount; wave += 64) {
    FailureOr<sym::ExprHandle> reference =
        substituteItem(analysis, expr, item, wave);
    if (failed(reference))
      return false;
    for (int64_t lane = 1; lane < 64; ++lane) {
      FailureOr<sym::ExprHandle> current =
          substituteItem(analysis, expr, item, wave + lane);
      if (failed(current) || !proveEqual(analysis, *reference, *current))
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
buildCanonicalB8Mapping(sym::Analysis &analysis) {
  FailureOr<sym::ExprHandle> item = analysis.composeSymbol("item");
  if (failed(item))
    return failure();
  FailureOr<sym::ExprHandle> lane =
      composeInt(analysis, *item, sym::ExprBinaryOp::Mod, 64);
  if (failed(lane))
    return failure();
  FailureOr<sym::ExprHandle> group = floorDiv(analysis, *lane, 16);
  FailureOr<sym::ExprHandle> row =
      composeInt(analysis, *item, sym::ExprBinaryOp::Mod, 16);
  if (failed(group) || failed(row))
    return failure();
  FailureOr<sym::ExprHandle> groupBytes =
      composeInt(analysis, *group, sym::ExprBinaryOp::Mul, 128);
  FailureOr<sym::ExprHandle> rowBytes =
      composeInt(analysis, *row, sym::ExprBinaryOp::Mul, 4);
  if (failed(groupBytes) || failed(rowBytes))
    return failure();
  FailureOr<sym::ExprHandle> matrixOffset =
      compose(analysis, *groupBytes, sym::ExprBinaryOp::Add, *rowBytes);
  if (failed(matrixOffset))
    return failure();
  return CanonicalB8Mapping{*item, *lane, *matrixOffset};
}

static FailureOr<sym::ExprHandle> getCanonicalB8TileBase(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, const CanonicalB8Mapping &mapping,
    AddressForm form) {
  ArrayRef<wave::memory_lowering::MemoryTransactionPoint> points =
      request.points;
  FailureOr<sym::ExprHandle> tileBase =
      compose(analysis, getByteOffset(points.front(), form),
              sym::ExprBinaryOp::Sub, mapping.matrixOffset);
  if (failed(tileBase))
    return failure();
  return simplifyAddress(analysis, *tileBase, form);
}

static LogicalResult verifyCanonicalB8Points(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, const CanonicalB8Mapping &mapping,
    sym::ExprHandle tileBase) {
  ArrayRef<wave::memory_lowering::MemoryTransactionPoint> points =
      request.points;
  for (auto [slot, point] : llvm::enumerate(points)) {
    if (point.baseIndex != points.front().baseIndex ||
        !proveEqual(analysis, point.base, points.front().base) ||
        !proveEqual(analysis, point.targetBlock, points.front().targetBlock))
      return failure();
    FailureOr<sym::ExprHandle> expected = compose(
        analysis, tileBase, sym::ExprBinaryOp::Add, mapping.matrixOffset);
    if (failed(expected))
      return failure();
    expected =
        composeInt(analysis, *expected, sym::ExprBinaryOp::Add, slot / 2);
    if (failed(expected) || !proveEqual(analysis, *expected, point.byteOffset))
      return failure();
  }
  return success();
}

static bool isCanonicalB8WaveBaseUniform(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, const CanonicalB8Mapping &mapping,
    sym::ExprHandle tileBase) {
  FailureOr<sym::ExprHandle> waveItem =
      compose(analysis, mapping.item, sym::ExprBinaryOp::Sub, mapping.lane);
  if (failed(waveItem))
    return false;
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{mapping.item, *waveItem}};
  FailureOr<sym::ExprHandle> waveBase =
      analysis.substitute(tileBase, substitution);
  if (failed(waveBase))
    return false;
  waveBase = analysis.simplify(*waveBase);
  if (failed(waveBase))
    return false;
  return proveEqual(analysis, tileBase, *waveBase) ||
         isWaveUniform(request.op, analysis, tileBase, mapping.item);
}

static FailureOr<sym::ExprHandle> getCanonicalB8ProofTileBase(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, const CanonicalB8Mapping &mapping) {
  FailureOr<sym::ExprHandle> tileBase =
      getCanonicalB8TileBase(request, analysis, mapping, AddressForm::Proof);
  if (failed(tileBase) ||
      !hasOnlyUniformBindings(*tileBase, request.points.front()) ||
      failed(verifyCanonicalB8Points(request, analysis, mapping, *tileBase)) ||
      !isCanonicalB8WaveBaseUniform(request, analysis, mapping, *tileBase))
    return failure();
  return tileBase;
}

static FailureOr<sym::ExprHandle>
addCanonicalB8LaneOffset(sym::Analysis &analysis, sym::ExprHandle tileBase,
                         sym::ExprHandle laneBytes, AddressForm form) {
  FailureOr<sym::ExprHandle> address =
      compose(analysis, tileBase, sym::ExprBinaryOp::Add, laneBytes);
  if (failed(address))
    return failure();
  return simplifyAddress(analysis, *address, form);
}

static FailureOr<sym::ExprHandle> getCanonicalB8AddressOffset(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis) {
  FailureOr<CanonicalB8Mapping> mapping = buildCanonicalB8Mapping(analysis);
  if (failed(mapping))
    return failure();
  FailureOr<sym::ExprHandle> proofTileBase =
      getCanonicalB8ProofTileBase(request, analysis, *mapping);
  if (failed(proofTileBase))
    return failure();
  FailureOr<sym::ExprHandle> laneBytes =
      composeInt(analysis, mapping->lane, sym::ExprBinaryOp::Mul, 8);
  if (failed(laneBytes))
    return failure();
  FailureOr<sym::ExprHandle> proofAddress = addCanonicalB8LaneOffset(
      analysis, *proofTileBase, *laneBytes, AddressForm::Proof);
  if (failed(proofAddress))
    return failure();

  FailureOr<sym::ExprHandle> materializationTileBase = getCanonicalB8TileBase(
      request, analysis, *mapping, AddressForm::Materialization);
  if (failed(materializationTileBase))
    return failure();
  FailureOr<sym::ExprHandle> materializationAddress =
      addCanonicalB8LaneOffset(analysis, *materializationTileBase, *laneBytes,
                               AddressForm::Materialization);
  if (failed(materializationAddress))
    return failure();
  return selectAddressForMaterialization(
      analysis, *proofAddress, *materializationAddress, request.points.front());
}

static FailureOr<sym::ExprHandle> getBitAffineB8Coefficient(
    sym::Analysis &analysis,
    const wave::memory_lowering::MemoryTransactionPoint &point,
    sym::ExprHandle item, sym::ExprHandle base, int64_t bit, int64_t bitValue,
    std::optional<sym::ExprHandle> bitTwoCoefficient, AddressForm form) {
  // Result relation hides source bit 3; hardware tile continues bit 2.
  if (bit == 3) {
    if (!bitTwoCoefficient)
      return failure();
    return composeInt(analysis, *bitTwoCoefficient, sym::ExprBinaryOp::Mul, 2);
  }
  int64_t outputItem = bit < 3 ? 2 * bitValue : bitValue;
  FailureOr<sym::ExprHandle> sample = substituteAddressItem(
      analysis, getByteOffset(point, form), item, outputItem, form);
  if (failed(sample))
    return failure();
  FailureOr<sym::ExprHandle> coefficient =
      compose(analysis, *sample, sym::ExprBinaryOp::Sub, base);
  if (failed(coefficient))
    return failure();
  return simplifyAddress(analysis, *coefficient, form);
}

static FailureOr<sym::ExprHandle>
addBitAffineB8Contribution(sym::Analysis &analysis, sym::ExprHandle address,
                           sym::ExprHandle coefficient, sym::ExprHandle item,
                           int64_t bitValue) {
  if (sym::getIntegerLiteralValue(coefficient) == 0)
    return address;
  FailureOr<sym::ExprHandle> itemBit = floorDiv(analysis, item, bitValue);
  if (failed(itemBit))
    return failure();
  itemBit = composeInt(analysis, *itemBit, sym::ExprBinaryOp::Mod, 2);
  if (failed(itemBit))
    return failure();
  FailureOr<sym::ExprHandle> contribution =
      compose(analysis, coefficient, sym::ExprBinaryOp::Mul, *itemBit);
  if (failed(contribution))
    return failure();
  return compose(analysis, address, sym::ExprBinaryOp::Add, *contribution);
}

static FailureOr<sym::ExprHandle> getHardwareB8Coefficient(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, sym::ExprHandle item, sym::ExprHandle base,
    int64_t bit, int64_t bitValue, AddressForm form) {
  size_t slot = 0;
  int64_t outputItem = 0;
  if (bit == 0) {
    // Source lane bit 0 becomes destination lane bit 3.
    outputItem = 8;
  } else if (bit < 4) {
    // Source lane bits 1..3 select one of the eight result bytes.
    slot = static_cast<size_t>(bitValue / 2);
  } else {
    // Wave and 16-lane group bits are unchanged.
    outputItem = bitValue;
  }
  FailureOr<sym::ExprHandle> sample =
      substituteAddressItem(analysis, getByteOffset(request.points[slot], form),
                            item, outputItem, form);
  if (failed(sample))
    return failure();
  FailureOr<sym::ExprHandle> coefficient =
      compose(analysis, *sample, sym::ExprBinaryOp::Sub, base);
  if (failed(coefficient))
    return failure();
  return simplifyAddress(analysis, *coefficient, form);
}

static FailureOr<sym::ExprHandle> synthesizeHardwareB8SourceAddress(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, sym::ExprHandle item, int64_t itemCount,
    AddressForm form) {
  FailureOr<sym::ExprHandle> base = substituteAddressItem(
      analysis, getByteOffset(request.points.front(), form), item, 0, form);
  if (failed(base))
    return failure();

  FailureOr<sym::ExprHandle> offset = analysis.composeInteger(0);
  if (failed(offset))
    return failure();
  for (int64_t bit = 0, bitValue = 1; bitValue < itemCount;
       ++bit, bitValue <<= 1) {
    FailureOr<sym::ExprHandle> coefficient = getHardwareB8Coefficient(
        request, analysis, item, *base, bit, bitValue, form);
    if (failed(coefficient))
      return failure();
    FailureOr<sym::ExprHandle> next = addBitAffineB8Contribution(
        analysis, *offset, *coefficient, item, bitValue);
    if (failed(next))
      return failure();
    offset = next;
  }
  FailureOr<sym::ExprHandle> address =
      compose(analysis, *base, sym::ExprBinaryOp::Add, *offset);
  if (failed(address))
    return failure();
  return simplifyAddress(analysis, *address, form);
}

static FailureOr<sym::ExprHandle> synthesizeBitAffineB8SourceAddress(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, sym::ExprHandle item, int64_t itemCount,
    AddressForm form) {
  const wave::memory_lowering::MemoryTransactionPoint &point =
      request.points.front();
  FailureOr<sym::ExprHandle> base = substituteAddressItem(
      analysis, getByteOffset(point, form), item, 0, form);
  if (failed(base))
    return failure();

  sym::ExprHandle address = *base;
  std::optional<sym::ExprHandle> bitTwoCoefficient;
  for (int64_t bit = 0, bitValue = 1; bitValue < itemCount;
       ++bit, bitValue <<= 1) {
    FailureOr<sym::ExprHandle> coefficient = getBitAffineB8Coefficient(
        analysis, point, item, *base, bit, bitValue, bitTwoCoefficient, form);
    if (failed(coefficient))
      return failure();
    if (bit == 2)
      bitTwoCoefficient = *coefficient;
    FailureOr<sym::ExprHandle> next = addBitAffineB8Contribution(
        analysis, address, *coefficient, item, bitValue);
    if (failed(next))
      return failure();
    address = *next;
  }
  return simplifyAddress(analysis, address, form);
}

static bool hasCommonTransactionBase(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis) {
  ArrayRef<wave::memory_lowering::MemoryTransactionPoint> points =
      request.points;
  for (const wave::memory_lowering::MemoryTransactionPoint &point : points) {
    if (point.baseIndex != points.front().baseIndex ||
        !proveEqual(analysis, point.base, points.front().base) ||
        !proveEqual(analysis, point.targetBlock, points.front().targetBlock))
      return false;
  }
  return true;
}

static LogicalResult verifyHardwareB8Output(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, sym::ExprHandle item,
    sym::ExprHandle sourceAddress, int64_t outputItem) {
  int64_t lane = outputItem % 64;
  int64_t waveBase = outputItem - lane;
  for (auto [slot, point] : llvm::enumerate(request.points)) {
    int64_t sourceItem = waveBase + 16 * (lane / 16) + (lane % 16) / 8 +
                         2 * static_cast<int64_t>(slot);
    FailureOr<sym::ExprHandle> source =
        substituteItem(analysis, sourceAddress, item, sourceItem);
    FailureOr<sym::ExprHandle> actual =
        substituteItem(analysis, point.byteOffset, item, outputItem);
    if (failed(source) || failed(actual))
      return failure();
    FailureOr<sym::ExprHandle> expected =
        composeInt(analysis, *source, sym::ExprBinaryOp::Add, lane % 8);
    if (failed(expected) || !proveEqual(analysis, *expected, *actual))
      return failure();
  }
  return success();
}

static LogicalResult verifyHardwareB8Points(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, sym::ExprHandle item, int64_t itemCount,
    sym::ExprHandle sourceAddress) {
  if (!hasCommonTransactionBase(request, analysis))
    return failure();
  for (int64_t outputItem : llvm::seq<int64_t>(itemCount))
    if (failed(verifyHardwareB8Output(request, analysis, item, sourceAddress,
                                      outputItem)))
      return failure();
  return success();
}

static FailureOr<sym::ExprHandle> getHardwareB8AddressOffset(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis) {
  FailureOr<ExecutionItem> executionItem = getExecutionItem(request, analysis);
  std::optional<int64_t> itemCount = getWorkgroupItemCount(request.op);
  if (failed(executionItem) || !itemCount)
    return failure();
  ExecutionItem item = *executionItem;
  FailureOr<sym::ExprHandle> proofAddress = synthesizeHardwareB8SourceAddress(
      request, analysis, item.expression, *itemCount, AddressForm::Proof);
  if (failed(proofAddress) ||
      failed(verifyHardwareB8Points(request, analysis, item.expression,
                                    *itemCount, *proofAddress)))
    return failure();
  FailureOr<sym::ExprHandle> materializationAddress =
      synthesizeHardwareB8SourceAddress(request, analysis, item.expression,
                                        *itemCount,
                                        AddressForm::Materialization);
  if (failed(materializationAddress))
    return failure();
  return selectAddressForMaterialization(analysis, *proofAddress,
                                         *materializationAddress,
                                         request.points.front(), item.name);
}

static LogicalResult verifyBitAffineB8Output(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, sym::ExprHandle item,
    sym::ExprHandle sourceAddress, int64_t outputItem) {
  int64_t lane = outputItem % 64;
  int64_t sourceItem = outputItem - lane + 16 * (lane / 16) + (lane % 16) / 2;
  FailureOr<sym::ExprHandle> source =
      substituteItem(analysis, sourceAddress, item, sourceItem);
  if (failed(source))
    return failure();
  for (auto [slot, point] : llvm::enumerate(request.points)) {
    FailureOr<sym::ExprHandle> actual =
        substituteItem(analysis, point.byteOffset, item, outputItem);
    FailureOr<sym::ExprHandle> expected =
        composeInt(analysis, *source, sym::ExprBinaryOp::Add,
                   4 * (lane % 2) + static_cast<int64_t>(slot / 2));
    if (failed(actual) || failed(expected) ||
        !proveEqual(analysis, *expected, *actual))
      return failure();
  }
  return success();
}

static LogicalResult verifyBitAffineB8Points(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, sym::ExprHandle item, int64_t itemCount,
    sym::ExprHandle sourceAddress) {
  if (!hasCommonTransactionBase(request, analysis))
    return failure();
  for (int64_t outputItem = 0; outputItem < itemCount; ++outputItem) {
    if (failed(verifyBitAffineB8Output(request, analysis, item, sourceAddress,
                                       outputItem)))
      return failure();
  }
  return success();
}

static FailureOr<sym::ExprHandle> getBitAffineB8AddressOffset(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis) {
  FailureOr<sym::ExprHandle> item = analysis.composeSymbol("item");
  std::optional<int64_t> itemCount = getWorkgroupItemCount(request.op);
  if (failed(item) || !itemCount)
    return failure();
  FailureOr<sym::ExprHandle> proofAddress = synthesizeBitAffineB8SourceAddress(
      request, analysis, *item, *itemCount, AddressForm::Proof);
  if (failed(proofAddress))
    return failure();
  if (failed(verifyBitAffineB8Points(request, analysis, *item, *itemCount,
                                     *proofAddress)))
    return failure();
  FailureOr<sym::ExprHandle> materializationAddress =
      synthesizeBitAffineB8SourceAddress(request, analysis, *item, *itemCount,
                                         AddressForm::Materialization);
  if (failed(materializationAddress))
    return failure();
  return selectAddressForMaterialization(
      analysis, *proofAddress, *materializationAddress, request.points.front());
}

static FailureOr<sym::ExprHandle> getB8AddressOffset(
    const wave::memory_lowering::GatherTransactionRequest &request) {
  sym::Store &store = *request.store;
  SmallVector<sym::PredHandle> assumptions = collectAssumptions(request.points);
  FailureOr<std::unique_ptr<sym::Analysis>> created =
      sym::Analysis::create(store, assumptions);
  if (failed(created))
    return failure();
  sym::Analysis &analysis = **created;
  FailureOr<sym::ExprHandle> hardware =
      getHardwareB8AddressOffset(request, analysis);
  if (succeeded(hardware))
    return hardware;
  FailureOr<sym::ExprHandle> canonical =
      getCanonicalB8AddressOffset(request, analysis);
  if (succeeded(canonical))
    return canonical;
  return getBitAffineB8AddressOffset(request, analysis);
}

enum class B16Combine { Add, Xor };

struct B16SourceComposition {
  B16Combine base;
  B16Combine bits;
};

struct B16Sample {
  int64_t slot;
  int64_t outputItem;
};

static sym::ExprBinaryOp getB16DeltaOp(B16Combine composition) {
  return composition == B16Combine::Add ? sym::ExprBinaryOp::Sub
                                        : sym::ExprBinaryOp::Xor;
}

static sym::ExprBinaryOp getB16CombineOp(B16Combine composition) {
  return composition == B16Combine::Add ? sym::ExprBinaryOp::Add
                                        : sym::ExprBinaryOp::Xor;
}

static B16Sample getB16Sample(int64_t bit, int64_t bitValue) {
  if (bit < 2)
    return B16Sample{0, 4 * bitValue};
  if (bit < 4)
    return B16Sample{bitValue / 4, 0};
  return B16Sample{0, bitValue};
}

static FailureOr<sym::ExprHandle> getB16Coefficient(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, sym::ExprHandle item, sym::ExprHandle base,
    int64_t bit, int64_t bitValue, B16Combine composition, AddressForm form) {
  B16Sample sample = getB16Sample(bit, bitValue);
  FailureOr<sym::ExprHandle> sampledAddress = substituteAddressItem(
      analysis, getByteOffset(request.points[sample.slot], form), item,
      sample.outputItem, form);
  if (failed(sampledAddress))
    return failure();
  FailureOr<sym::ExprHandle> coefficient =
      compose(analysis, *sampledAddress, getB16DeltaOp(composition), base);
  if (failed(coefficient))
    return failure();
  return simplifyAddress(analysis, *coefficient, form);
}

static FailureOr<sym::ExprHandle>
addB16Contribution(sym::Analysis &analysis, sym::ExprHandle offset,
                   sym::ExprHandle coefficient, sym::ExprHandle item,
                   int64_t bitValue, B16Combine composition) {
  if (sym::getIntegerLiteralValue(coefficient) == 0)
    return offset;
  FailureOr<sym::ExprHandle> itemBit = floorDiv(analysis, item, bitValue);
  if (failed(itemBit))
    return failure();
  itemBit = composeInt(analysis, *itemBit, sym::ExprBinaryOp::Mod, 2);
  if (failed(itemBit))
    return failure();
  FailureOr<sym::ExprHandle> contribution =
      compose(analysis, coefficient, sym::ExprBinaryOp::Mul, *itemBit);
  if (failed(contribution))
    return failure();
  return compose(analysis, offset, getB16CombineOp(composition), *contribution);
}

static size_t findGroupedB16AddEnd(sym::Analysis &analysis,
                                   sym::ExprHandle coefficient,
                                   ArrayRef<sym::ExprHandle> coefficients,
                                   size_t begin) {
  size_t end = begin + 1;
  int64_t scale = 2;
  while (end < coefficients.size()) {
    FailureOr<sym::ExprHandle> expected =
        composeInt(analysis, coefficient, sym::ExprBinaryOp::Mul, scale);
    if (failed(expected) || !proveEqual(analysis, *expected, coefficients[end]))
      break;
    ++end;
    scale *= 2;
  }
  return end;
}

static FailureOr<sym::ExprHandle>
addGroupedB16Contribution(sym::Analysis &analysis, sym::ExprHandle offset,
                          sym::ExprHandle coefficient, sym::ExprHandle item,
                          size_t begin, size_t end) {
  FailureOr<sym::ExprHandle> field =
      floorDiv(analysis, item, int64_t{1} << begin);
  if (failed(field))
    return failure();
  field = composeInt(analysis, *field, sym::ExprBinaryOp::Mod,
                     int64_t{1} << (end - begin));
  if (failed(field))
    return failure();
  FailureOr<sym::ExprHandle> contribution =
      compose(analysis, coefficient, sym::ExprBinaryOp::Mul, *field);
  if (failed(contribution))
    return failure();
  return compose(analysis, offset, sym::ExprBinaryOp::Add, *contribution);
}

static FailureOr<sym::ExprHandle>
buildGroupedB16AddOffset(sym::Analysis &analysis, sym::ExprHandle item,
                         ArrayRef<sym::ExprHandle> coefficients) {
  FailureOr<sym::ExprHandle> offset = analysis.composeInteger(0);
  if (failed(offset))
    return failure();
  for (size_t begin = 0; begin < coefficients.size();) {
    sym::ExprHandle coefficient = coefficients[begin];
    if (sym::getIntegerLiteralValue(coefficient) == 0) {
      ++begin;
      continue;
    }
    // Doubling coefficients encode one ordinary integer field.
    size_t end =
        findGroupedB16AddEnd(analysis, coefficient, coefficients, begin);
    offset = addGroupedB16Contribution(analysis, *offset, coefficient, item,
                                       begin, end);
    if (failed(offset))
      return failure();
    begin = end;
  }
  return offset;
}

static FailureOr<SmallVector<sym::ExprHandle>> collectB16Coefficients(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, sym::ExprHandle item, sym::ExprHandle base,
    int64_t itemCount, B16Combine composition, AddressForm form) {
  SmallVector<sym::ExprHandle> coefficients;
  for (int64_t bit = 0, bitValue = 1; bitValue < itemCount;
       ++bit, bitValue <<= 1) {
    FailureOr<sym::ExprHandle> coefficient = getB16Coefficient(
        request, analysis, item, base, bit, bitValue, composition, form);
    if (failed(coefficient))
      return failure();
    coefficients.push_back(*coefficient);
  }
  return coefficients;
}

static FailureOr<sym::ExprHandle>
buildPerBitB16Offset(sym::Analysis &analysis, sym::ExprHandle item,
                     ArrayRef<sym::ExprHandle> coefficients,
                     B16Combine composition) {
  FailureOr<sym::ExprHandle> offset = analysis.composeInteger(0);
  if (failed(offset))
    return failure();
  for (auto [bit, coefficient] : llvm::enumerate(coefficients)) {
    offset = addB16Contribution(analysis, *offset, coefficient, item,
                                int64_t{1} << bit, composition);
    if (failed(offset))
      return failure();
  }
  return offset;
}

static FailureOr<sym::ExprHandle>
buildB16Offset(sym::Analysis &analysis, sym::ExprHandle item,
               ArrayRef<sym::ExprHandle> coefficients, B16Combine composition) {
  if (composition == B16Combine::Add)
    return buildGroupedB16AddOffset(analysis, item, coefficients);
  return buildPerBitB16Offset(analysis, item, coefficients, composition);
}

static FailureOr<sym::ExprHandle> synthesizeB16SourceAddress(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, sym::ExprHandle item, int64_t itemCount,
    B16SourceComposition composition, AddressForm form) {
  FailureOr<sym::ExprHandle> base = substituteAddressItem(
      analysis, getByteOffset(request.points.front(), form), item, 0, form);
  if (failed(base))
    return failure();

  FailureOr<SmallVector<sym::ExprHandle>> coefficients = collectB16Coefficients(
      request, analysis, item, *base, itemCount, composition.base, form);
  if (failed(coefficients))
    return failure();
  FailureOr<sym::ExprHandle> offset =
      buildB16Offset(analysis, item, *coefficients, composition.bits);
  if (failed(offset))
    return failure();
  FailureOr<sym::ExprHandle> address =
      compose(analysis, *base, getB16CombineOp(composition.base), *offset);
  if (failed(address))
    return failure();
  return simplifyAddress(analysis, *address, form);
}

static LogicalResult verifyB16OutputSlot(
    const wave::memory_lowering::GatherTransactionRequest &request,
    sym::Analysis &analysis, sym::ExprHandle item,
    sym::ExprHandle sourceAddress, int64_t outputItem, size_t slot,
    const wave::memory_lowering::MemoryTransactionPoint &point) {
  int64_t lane = outputItem % 64;
  int64_t sourceItem = outputItem - lane + 16 * (lane / 16) + (lane % 16) / 4 +
                       4 * static_cast<int64_t>(slot);
  FailureOr<sym::ExprHandle> source =
      substituteItem(analysis, sourceAddress, item, sourceItem);
  FailureOr<sym::ExprHandle> actual =
      substituteItem(analysis, point.byteOffset, item, outputItem);
  if (failed(source) || failed(actual))
    return failure();
  FailureOr<sym::ExprHandle> expected =
      composeInt(analysis, *source, sym::ExprBinaryOp::Add, 2 * (lane % 4));
  if (failed(expected) || !proveEqual(analysis, *expected, *actual))
    return failure();
  return success();
}

static LogicalResult
verifyB16Output(const wave::memory_lowering::GatherTransactionRequest &request,
                sym::Analysis &analysis, sym::ExprHandle item,
                sym::ExprHandle sourceAddress, int64_t outputItem) {
  for (auto [slot, point] : llvm::enumerate(request.points)) {
    if (failed(verifyB16OutputSlot(request, analysis, item, sourceAddress,
                                   outputItem, slot, point)))
      return failure();
  }
  return success();
}

static LogicalResult
verifyB16Points(const wave::memory_lowering::GatherTransactionRequest &request,
                sym::Analysis &analysis, sym::ExprHandle item,
                int64_t itemCount, sym::ExprHandle sourceAddress) {
  if (!hasCommonTransactionBase(request, analysis))
    return failure();
  for (int64_t outputItem : llvm::seq<int64_t>(itemCount)) {
    if (failed(verifyB16Output(request, analysis, item, sourceAddress,
                               outputItem)))
      return failure();
  }
  return success();
}

static FailureOr<sym::ExprHandle> getB16AddressOffset(
    const wave::memory_lowering::GatherTransactionRequest &request) {
  sym::Store &store = *request.store;
  SmallVector<sym::PredHandle> assumptions = collectAssumptions(request.points);
  std::optional<int64_t> itemCount = getWorkgroupItemCount(request.op);
  if (!itemCount)
    return failure();
  FailureOr<std::unique_ptr<sym::Analysis>> created =
      sym::Analysis::create(store, assumptions);
  if (failed(created))
    return failure();
  sym::Analysis &analysis = **created;
  FailureOr<sym::ExprHandle> item = analysis.composeSymbol("item");
  if (failed(item))
    return failure();
  constexpr std::array<B16SourceComposition, 4> compositions{
      B16SourceComposition{B16Combine::Add, B16Combine::Add},
      B16SourceComposition{B16Combine::Add, B16Combine::Xor},
      B16SourceComposition{B16Combine::Xor, B16Combine::Add},
      B16SourceComposition{B16Combine::Xor, B16Combine::Xor}};
  for (B16SourceComposition composition : compositions) {
    FailureOr<sym::ExprHandle> proofAddress = synthesizeB16SourceAddress(
        request, analysis, *item, *itemCount, composition, AddressForm::Proof);
    if (succeeded(proofAddress) &&
        succeeded(verifyB16Points(request, analysis, *item, *itemCount,
                                  *proofAddress))) {
      FailureOr<sym::ExprHandle> materializationAddress =
          synthesizeB16SourceAddress(request, analysis, *item, *itemCount,
                                     composition, AddressForm::Materialization);
      if (failed(materializationAddress))
        continue;
      FailureOr<sym::ExprHandle> selected = selectAddressForMaterialization(
          analysis, *proofAddress, *materializationAddress,
          request.points.front());
      if (succeeded(selected))
        return selected;
    }
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

static std::optional<unsigned> getTransposeTransactionWidth(SimdType type) {
  VectorType packet = dyn_cast<VectorType>(type.getElementType());
  if (!packet || type.getWidth() != 64)
    return std::nullopt;
  Type element = packet.getElementType();
  if (element.isInteger(8))
    return 8;
  if (element.isInteger(16) || element.isF16() || element.isBF16())
    return 4;
  return std::nullopt;
}

static SimdType getTransposeTransactionType(SimdType type, unsigned width) {
  VectorType packet = cast<VectorType>(type.getElementType());
  VectorType transaction = VectorType::get({width}, packet.getElementType());
  return SimdType::get(type.getContext(), transaction, type.getWidth());
}

static bool hasTransposeExecutionContext(
    const wave::memory_lowering::GatherTransactionRequest &request) {
  if (request.points.empty() || request.cache)
    return false;
  if (!isGfx950(request.op) || !getWorkgroupItemCount(request.op) ||
      isInsideWhere(request.op))
    return false;
  PtrType baseType = dyn_cast<PtrType>(request.bases.front().getType());
  return baseType && isa<SharedAddressSpaceAttr>(baseType.getAddressSpace());
}

static FailureOr<wave::memory_lowering::GatherTransactionCandidate>
buildTransposeCandidate(
    const wave::memory_lowering::GatherTransactionRequest &request,
    ArrayRef<unsigned> slots) {
  SmallVector<wave::memory_lowering::MemoryTransactionPoint> points;
  points.reserve(slots.size());
  for (unsigned slot : slots)
    points.push_back(request.points[slot]);

  wave::memory_lowering::GatherTransactionRequest transactionRequest = request;
  transactionRequest.points = points;
  transactionRequest.resultType =
      getTransposeTransactionType(request.resultType, slots.size());
  FailureOr<sym::ExprHandle> address = failure();
  if (hasB8PacketType(transactionRequest.resultType))
    address = getB8AddressOffset(transactionRequest);
  else if (hasB16PacketType(transactionRequest.resultType))
    address = getB16AddressOffset(transactionRequest);
  if (failed(address))
    return failure();

  wave::memory_lowering::GatherTransactionCandidate candidate;
  llvm::append_range(candidate.slots, slots);
  candidate.emitter = std::make_unique<TransposeEmitter>();
  candidate.byteOffset = *address;
  candidate.addressPoint = slots.front();
  candidate.baseIndex = points.front().baseIndex;
  return candidate;
}

static bool appendNaturalTransposeCover(
    const wave::memory_lowering::GatherTransactionRequest &request,
    unsigned width,
    SmallVectorImpl<wave::memory_lowering::GatherTransactionCandidate>
        &candidates) {
  if (request.points.size() % width)
    return false;
  SmallVector<wave::memory_lowering::GatherTransactionCandidate> cover;
  for (unsigned begin = 0; begin < request.points.size(); begin += width) {
    SmallVector<unsigned> slots;
    llvm::append_range(slots, llvm::seq(begin, begin + width));
    FailureOr<wave::memory_lowering::GatherTransactionCandidate> candidate =
        buildTransposeCandidate(request, slots);
    if (failed(candidate))
      return false;
    cover.push_back(std::move(*candidate));
  }
  for (wave::memory_lowering::GatherTransactionCandidate &candidate : cover)
    candidates.push_back(std::move(candidate));
  return true;
}

static void appendContiguousTransposeCandidates(
    const wave::memory_lowering::GatherTransactionRequest &request,
    unsigned width,
    SmallVectorImpl<wave::memory_lowering::GatherTransactionCandidate>
        &candidates) {
  for (unsigned begin = 0; begin + width <= request.points.size(); ++begin) {
    SmallVector<unsigned> slots;
    llvm::append_range(slots, llvm::seq(begin, begin + width));
    FailureOr<wave::memory_lowering::GatherTransactionCandidate> candidate =
        buildTransposeCandidate(request, slots);
    if (succeeded(candidate))
      candidates.push_back(std::move(*candidate));
  }
}

static bool hasBoundedSubsetCount(unsigned pointCount, unsigned width,
                                  uint64_t limit) {
  if (width > pointCount)
    return false;
  width = std::min(width, pointCount - width);
  uint64_t count = 1;
  for (unsigned index = 1; index <= width; ++index) {
    count *= pointCount - width + index;
    count /= index;
    if (count > limit)
      return false;
  }
  return true;
}

static void enumerateTransposeSubsets(
    const wave::memory_lowering::GatherTransactionRequest &request,
    unsigned width, unsigned next, SmallVectorImpl<unsigned> &slots,
    unsigned &attempts,
    SmallVectorImpl<wave::memory_lowering::GatherTransactionCandidate>
        &candidates) {
  constexpr unsigned maxAttempts = 256;
  if (attempts == maxAttempts)
    return;
  if (slots.size() == width) {
    ++attempts;
    if (slots.back() - slots.front() + 1 == width)
      return;
    FailureOr<wave::memory_lowering::GatherTransactionCandidate> candidate =
        buildTransposeCandidate(request, slots);
    if (succeeded(candidate))
      candidates.push_back(std::move(*candidate));
    return;
  }
  unsigned remaining = width - slots.size();
  for (unsigned slot = next;
       slot + remaining <= request.points.size() && attempts < maxAttempts;
       ++slot) {
    slots.push_back(slot);
    enumerateTransposeSubsets(request, width, slot + 1, slots, attempts,
                              candidates);
    slots.pop_back();
  }
}

class AMDGatherTransactionProvider final
    : public wave::memory_lowering::GatherTransactionProvider {
public:
  void
  enumerate(const wave::memory_lowering::GatherTransactionRequest &request,
            SmallVectorImpl<wave::memory_lowering::GatherTransactionCandidate>
                &candidates) const override {
    std::optional<unsigned> width =
        getTransposeTransactionWidth(request.resultType);
    if (!width || request.points.size() < *width ||
        !hasTransposeExecutionContext(request))
      return;
    if (appendNaturalTransposeCover(request, *width, candidates))
      return;
    appendContiguousTransposeCandidates(request, *width, candidates);
    if (!hasBoundedSubsetCount(request.points.size(), *width, 256))
      return;
    SmallVector<unsigned> slots;
    unsigned attempts = 0;
    enumerateTransposeSubsets(request, *width, 0, slots, attempts, candidates);
  }
};

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
  ArrayRef<int64_t> getSupportedByteWidths() const override {
    static constexpr std::array<int64_t, 2> widths{16, 4};
    return widths;
  }

  FailureOr<Value> emit(IRRewriter &rewriter, Location loc, Type tokenType,
                        Value source, Value destination, Value dependency,
                        int64_t bytes, Value condition) const override {
    if (!llvm::is_contained(getSupportedByteWidths(), bytes))
      return failure();
    if (!condition)
      return create(rewriter, loc, tokenType, source, destination, dependency,
                    bytes, false);

    WhereOp where = WhereOp::create(rewriter, loc, TypeRange{tokenType},
                                    ValueRange{condition});
    Block &thenBlock = where.getThenRegion().emplaceBlock();
    rewriter.setInsertionPointToStart(&thenBlock);
    Value token = create(rewriter, loc, tokenType, source, destination,
                         dependency, bytes, true);
    YieldOp::create(rewriter, loc, token);
    rewriter.setInsertionPointAfter(where);
    return where.getResult(0);
  }

private:
  static Value create(IRRewriter &rewriter, Location loc, Type tokenType,
                      Value source, Value destination, Value dependency,
                      int64_t bytes, bool zeroFillInactive) {
    UnitAttr zeroFill = zeroFillInactive ? rewriter.getUnitAttr() : UnitAttr{};
    return waveamd::DmaLoadLdsOp::create(
               rewriter, loc, tokenType, source, destination, dependency,
               rewriter.getI64IntegerAttr(bytes), rewriter.getI64IntegerAttr(0),
               zeroFill, IntegerAttr{}, IntegerAttr{}, IntegerAttr{})
        .getToken();
  }
};

class AMDCopyTransactionProvider final
    : public wave::memory_lowering::CopyTransactionProvider {
public:
  std::unique_ptr<wave::memory_lowering::CopyTransactionEmitter>
  match(const wave::memory_lowering::CopyTransactionRequest &request)
      const override {
    PtrType source = getPointerType(request.sourceBase.getType());
    PtrType destination = getPointerType(request.destinationBase.getType());
    if (!source || !destination || !supportsDmaLoadLds(request.op))
      return {};
    if (!isa<GlobalAddressSpaceAttr, waveamd::BufferAddressSpaceAttr>(
            source.getAddressSpace()) ||
        !isa<SharedAddressSpaceAttr>(destination.getAddressSpace()))
      return {};
    if (request.zeroFillInactive &&
        (!isa<waveamd::BufferAddressSpaceAttr>(source.getAddressSpace()) ||
         !hasBufferSentinel(request.sourceBase)))
      return {};
    return std::make_unique<AMDCopyTransactionEmitter>();
  }
};

} // namespace

void mlir::wave::memory_lowering::populateGatherTransactionProviders(
    SmallVectorImpl<std::unique_ptr<GatherTransactionProvider>> &providers) {
  providers.push_back(std::make_unique<AMDGatherTransactionProvider>());
}

void mlir::wave::memory_lowering::populateCopyTransactionProviders(
    SmallVectorImpl<std::unique_ptr<CopyTransactionProvider>> &providers) {
  providers.push_back(std::make_unique<AMDCopyTransactionProvider>());
}
