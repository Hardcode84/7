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
               int64_t value, ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> literal = sym::composeExprInt(store, value);
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

struct B8Mapping {
  sym::ExprHandle item;
  sym::ExprHandle lane;
  sym::ExprHandle matrixOffset;
};

static FailureOr<B8Mapping> buildB8Mapping(sym::Store &store) {
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
  return B8Mapping{*item, *lane, *matrixOffset};
}

static FailureOr<sym::ExprHandle>
getB8TileBase(const wave::memory_lowering::GatherTransactionRequest &request,
              const B8Mapping &mapping, ArrayRef<sym::PredHandle> assumptions) {
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

static LogicalResult
verifyB8Points(const wave::memory_lowering::GatherTransactionRequest &request,
               const B8Mapping &mapping, sym::ExprHandle tileBase,
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

static bool isB8WaveBaseUniform(
    const wave::memory_lowering::GatherTransactionRequest &request,
    const B8Mapping &mapping, sym::ExprHandle tileBase,
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

static FailureOr<sym::ExprHandle> getB8AddressOffset(
    const wave::memory_lowering::GatherTransactionRequest &request) {
  // Output slot pairs duplicate bytes; lane addresses advance by eight.
  sym::Store &store = *request.store;
  SmallVector<sym::PredHandle> assumptions = collectAssumptions(request.points);
  FailureOr<B8Mapping> mapping = buildB8Mapping(store);
  if (failed(mapping))
    return failure();
  FailureOr<sym::ExprHandle> tileBase =
      getB8TileBase(request, *mapping, assumptions);
  if (failed(tileBase))
    return failure();
  if (failed(verifyB8Points(request, *mapping, *tileBase, assumptions)))
    return failure();
  if (!isB8WaveBaseUniform(request, *mapping, *tileBase, assumptions))
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

class B8TransposeEmitter final
    : public wave::memory_lowering::GatherTransactionEmitter {
public:
  FailureOr<wave::memory_lowering::GatherTransactionResult>
  emit(IRRewriter &rewriter, Location loc, SimdType resultType, Type tokenType,
       Value address, Value dependency) const override {
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

static bool hasB8ExecutionContext(
    const wave::memory_lowering::GatherTransactionRequest &request) {
  if (request.points.size() != 8 || request.cache)
    return false;
  if (!isGfx950(request.op) || !getWorkgroupItemCount(request.op) ||
      isInsideWhere(request.op))
    return false;
  PtrType baseType = cast<PtrType>(request.bases.front().getType());
  return isa<SharedAddressSpaceAttr>(baseType.getAddressSpace());
}

class AMDGatherTransactionProvider final
    : public wave::memory_lowering::GatherTransactionProvider {
public:
  void
  enumerate(const wave::memory_lowering::GatherTransactionRequest &request,
            SmallVectorImpl<wave::memory_lowering::GatherTransactionCandidate>
                &candidates) const override {
    if (!hasB8PacketType(request.resultType) || !hasB8ExecutionContext(request))
      return;

    FailureOr<sym::ExprHandle> address = getB8AddressOffset(request);
    if (failed(address))
      return;
    wave::memory_lowering::GatherTransactionCandidate candidate;
    candidate.slots = {0, 1, 2, 3, 4, 5, 6, 7};
    candidate.emitter = std::make_unique<B8TransposeEmitter>();
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
