//===- WaveMachine.cpp - Wave to WaveMachine backend passes -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/WaveMachine/IR/WaveMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/ADT/TypeSwitch.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/TargetParser/TargetParser.h"
#include <limits>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_CONVERTWAVEAMDTOWAVEMACHINE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;

namespace {

struct LiveInterval {
  Operation *def = nullptr;
  unsigned start = std::numeric_limits<unsigned>::max();
  unsigned end = 0;
};

static wavemachine::RegType getRegType(MLIRContext *ctx,
                                       wavemachine::RegClass regClass,
                                       unsigned width = 1) {
  return wavemachine::RegType::get(ctx, regClass, width, -1);
}

static wavemachine::RegType getSCCType(MLIRContext *ctx) {
  return wavemachine::RegType::get(ctx, wavemachine::RegClass::SCC, /*width=*/1,
                                   /*index=*/-1);
}

// Pinned variant: the resulting register's physical index is fixed up
// front (e.g. for HSA-loader-preloaded SGPRs s2..s4 or workitem_id VGPR
// v0). The register allocator skips these defs and leaves the value in
// place.
static wavemachine::RegType getPinnedRegType(MLIRContext *ctx,
                                             wavemachine::RegClass regClass,
                                             unsigned width, int64_t index) {
  return wavemachine::RegType::get(ctx, regClass, width, index);
}

static wavemachine::ImmType getImmType(MLIRContext *ctx) {
  return wavemachine::ImmType::get(ctx);
}

static wavemachine::MemTokenType getMemTokenType(MLIRContext *ctx) {
  return wavemachine::MemTokenType::get(ctx);
}

static bool isWaveMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         wavemachine::WaveMachineDialect::getDialectNamespace();
}

static bool isVGPR(Value v) {
  auto rt = dyn_cast<wavemachine::RegType>(v.getType());
  return rt && rt.getRegClass() == wavemachine::RegClass::VGPR;
}

static bool isImm(Value v) {
  return v.getDefiningOp<wavemachine::ImmOp>() != nullptr;
}

static Operation *createWMOp(OpBuilder &builder, Location loc, StringRef name,
                             ValueRange operands, TypeRange resultTypes,
                             ArrayRef<NamedAttribute> attrs = {}) {
  std::string opName = ("wavemachine." + name).str();
  OperationState state(loc, opName);
  state.addOperands(operands);
  state.addTypes(resultTypes);
  state.addAttributes(attrs);
  return builder.create(state);
}

static Operation *createWMOp(OpBuilder &builder, Location loc, StringRef name,
                             ValueRange operands, Type resultType,
                             ArrayRef<NamedAttribute> attrs = {}) {
  SmallVector<Type, 1> resultTypes{resultType};
  return createWMOp(builder, loc, name, operands, resultTypes, attrs);
}

static Value createImm(OpBuilder &builder, Location loc, int64_t value) {
  Operation *op = createWMOp(
      builder, loc, "imm", {}, getImmType(builder.getContext()),
      {builder.getNamedAttr("value", builder.getI64IntegerAttr(value))});
  return op->getResult(0);
}

static Value createInstr(OpBuilder &builder, Location loc, StringRef name,
                         ValueRange operands, Type resultType,
                         ArrayRef<NamedAttribute> attrs = {}) {
  Operation *op = createWMOp(builder, loc, name, operands, resultType, attrs);
  return op->getResult(0);
}

static Operation *createInstrNoResult(OpBuilder &builder, Location loc,
                                      StringRef name, ValueRange operands,
                                      ArrayRef<NamedAttribute> attrs = {}) {
  return createWMOp(builder, loc, name, operands, TypeRange{}, attrs);
}

class WaveMachineSelector {
public:
  explicit WaveMachineSelector(func::FuncOp func) : func(func), builder(func) {}

  LogicalResult run() {
    if (!func.getBody().hasOneBlock())
      return func.emitError("WaveMachine selection supports one-block funcs");

    Block &block = func.getBody().front();
    builder.setInsertionPointToStart(&block);
    for (auto [index, arg] : llvm::enumerate(func.getArguments()))
      materializeArgument(arg, index);

    SmallVector<Operation *> topLevelOps;
    for (Operation &op : llvm::make_early_inc_range(block))
      if (!isWaveMachineOp(&op))
        topLevelOps.push_back(&op);

    for (Operation *op : topLevelOps)
      if (failed(selectOperation(op)))
        return failure();

    for (Operation *op : llvm::reverse(opsToErase))
      op->erase();

    auto oldType = func.getFunctionType();
    func.setType(
        FunctionType::get(func.getContext(), oldType.getInputs(), TypeRange{}));
    return success();
  }

private:
  func::FuncOp func;
  OpBuilder builder;
  DenseMap<Value, Value> values;
  DenseMap<Value, Value> pointerBases;
  DenseMap<Value, Value> pointerOffsets;
  DenseMap<Value, bool> pointerBuffers;
  SmallVector<Operation *> opsToErase;
  unsigned nextLabel = 0;

  bool isBufferPointer(Type type) {
    if (auto simd = dyn_cast<SimdType>(type))
      type = simd.getElementType();
    auto ptr = dyn_cast<PtrType>(type);
    return ptr && isa<waveamd::BufferAddressSpaceAttr>(ptr.getAddressSpace());
  }

  bool isSharedPointer(Type type) {
    if (auto simd = dyn_cast<SimdType>(type))
      type = simd.getElementType();
    auto ptr = dyn_cast<PtrType>(type);
    return ptr && isa<SharedAddressSpaceAttr>(ptr.getAddressSpace());
  }

  unsigned pointerBaseWidth(Type type) { return isBufferPointer(type) ? 4 : 2; }

  void materializeArgument(BlockArgument arg, size_t index) {
    Type type = arg.getType();
    bool isPtr = isa<PtrType>(type);
    wavemachine::RegClass regClass = isa<SimdType>(type)
                                         ? wavemachine::RegClass::VGPR
                                         : wavemachine::RegClass::SGPR;
    unsigned width = isPtr ? pointerBaseWidth(type) : 1;
    Operation *argOp = createWMOp(
        builder, func.getLoc(), "arg", {},
        getRegType(func.getContext(), regClass, width),
        {builder.getNamedAttr("index", builder.getI64IntegerAttr(index)),
         builder.getNamedAttr("pointer", builder.getBoolAttr(isPtr))});
    values[arg] = argOp->getResult(0);
    if (!isPtr)
      return;
    pointerBases[arg] = argOp->getResult(0);
    pointerOffsets[arg] = createImm(builder, func.getLoc(), 0);
    pointerBuffers[arg] = isBufferPointer(type);
  }

  std::string makeLabel(StringRef stem) {
    return (Twine(".Lwave_") + func.getSymName() + "_" + stem + "_" +
            Twine(nextLabel++))
        .str();
  }

  Value expect(Value value, Operation *user) {
    auto it = values.find(value);
    if (it != values.end())
      return it->second;
    user->emitError("value has no WaveMachine location");
    return createImm(builder, user->getLoc(), 0);
  }

  void eraseIfTopLevel(Operation *op) {
    if (op->getBlock()->getParentOp() == func)
      opsToErase.push_back(op);
  }

  LogicalResult selectOperation(Operation *op) {
    // Reset the insertion point only when stepping into a fresh top-level
    // op (either directly inside the function body, or inside a
    // structured loop body whose pre/post layout we are rebuilding from
    // scratch).
    Operation *parentOp = op->getBlock()->getParentOp();
    if (parentOp == func || isa<wavemachine::UniformLoopOp>(parentOp))
      builder.setInsertionPoint(op);
    return llvm::TypeSwitch<Operation *, LogicalResult>(op)
        .Case<arith::ConstantIntOp>([&](auto o) { return selectConstant(o); })
        .Case<LaneIdOp>([&](auto o) { return selectLaneId(o); })
        .Case<WorkgroupIdOp>([&](auto o) { return selectWorkgroupId(o); })
        .Case<WorkitemIdOp>([&](auto o) { return selectWorkitemId(o); })
        .Case<SplatOp>([&](auto o) { return selectSplat(o); })
        .Case<BinaryOp>([&](auto o) { return selectBinary(o); })
        .Case<AddiOp>([&](auto o) { return selectAddi(o); })
        .Case<MuliOp>([&](auto o) { return selectMuli(o); })
        .Case<ShliOp>([&](auto o) { return selectShli(o); })
        .Case<IndexExprOp>([&](auto o) { return selectIndexExpr(o); })
        .Case<CmpIOp>([&](auto o) { return selectCmp(o); })
        .Case<BallotOp>([&](auto o) { return selectBallot(o); })
        .Case<ReadFirstOp>([&](auto o) { return selectReadFirst(o); })
        .Case<PtrAddOp>([&](auto o) { return selectPtrAdd(o); })
        .Case<waveamd::MakeBufferOp>(
            [&](auto o) { return selectMakeBuffer(o); })
        .Case<TokenOp>([&](auto o) { return selectToken(o); })
        .Case<AfterOp, JoinOp>([&](auto o) { return selectTokenJoin(o); })
        .Case<WaitOp>([&](auto o) { return selectWait(o); })
        .Case<WhereOp>([&](auto o) { return selectWhere(o); })
        .Case<StoreOp>([&](auto o) { return selectStore(o); })
        .Case<LoadOp>([&](auto o) { return selectLoad(o); })
        .Case<LdsBaseOp>([&](auto o) { return selectLdsBase(o); })
        .Case<BarrierOp>([&](auto o) { return selectBarrier(o); })
        .Case<waveamd::FragmentFillOp>(
            [&](auto o) { return selectFragmentFill(o); })
        .Case<waveamd::FragmentPackOp>(
            [&](auto o) { return selectFragmentPack(o); })
        .Case<waveamd::MmaOp>([&](auto o) { return selectMma(o); })
        .Case<waveamd::FragmentStoreOp>(
            [&](auto o) { return selectFragmentStore(o); })
        .Case<func::ReturnOp>([&](auto o) { return selectReturn(o); })
        .Case<scf::ForOp>([&](auto o) { return selectScfFor(o); })
        .Case<scf::YieldOp>([&](auto) {
          // scf.yield is consumed by selectScfFor; we drop it here.
          return success();
        })
        .Case<YieldOp>([&](auto) { return success(); })
        .Default([&](auto) {
          return op->emitError(
              "unsupported operation in WaveMachine selection");
        });
  }

  LogicalResult selectConstant(arith::ConstantIntOp op) {
    values[op.getResult()] = createImm(builder, op.getLoc(), op.value());
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectLaneId(LaneIdOp op) {
    auto simdType = cast<SimdType>(op.getType());
    if (!simdType.getElementType().isInteger(32) || simdType.getWidth() != 32)
      return op.emitError(
          "WaveMachine backend supports only !wave.simd<i32, 32> lane_id");
    values[op.getResult()] =
        createInstr(builder, op.getLoc(), "v_mbcnt_lo", {},
                    getRegType(op.getContext(), wavemachine::RegClass::VGPR));
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectWorkgroupId(WorkgroupIdOp op) {
    StringRef opcode;
    int64_t sgprIndex;
    switch (op.getAxis()) {
    case 0:
      opcode = "s_workgroup_id_x";
      sgprIndex = 2;
      break;
    case 1:
      opcode = "s_workgroup_id_y";
      sgprIndex = 3;
      break;
    case 2:
      opcode = "s_workgroup_id_z";
      sgprIndex = 4;
      break;
    default:
      return op.emitError("workgroup_id axis must be 0, 1, or 2");
    }
    values[op.getResult()] = createInstr(
        builder, op.getLoc(), opcode, {},
        getPinnedRegType(op.getContext(), wavemachine::RegClass::SGPR,
                         /*width=*/1, sgprIndex));
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectWorkitemId(WorkitemIdOp op) {
    if (op.getAxis() != 0)
      return op.emitError(
          "WaveMachine backend supports only workitem_id along axis 0 (x)");
    values[op.getResult()] = createInstr(
        builder, op.getLoc(), "v_workitem_id_x", {},
        getPinnedRegType(op.getContext(), wavemachine::RegClass::VGPR,
                         /*width=*/1, /*index=*/0));
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectSplat(SplatOp op) {
    values[op.getResult()] = expect(op.getSource(), op);
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectBinary(BinaryOp op) {
    // addi / muli / shli have moved to dedicated wave.addi / muli / shli
    // ops with full uniform-and-SIMD support; reject those kinds here so
    // stragglers fail loudly instead of silently going through the old
    // SIMD-only path.
    StringRef machineOpcode = llvm::StringSwitch<StringRef>(op.getKind())
                                  .Case("andi", "v_and_b32")
                                  .Case("ori", "v_or_b32")
                                  .Case("xori", "v_xor_b32")
                                  .Case("shri", "v_lshrrev_b32")
                                  .Default("");
    if (machineOpcode.empty())
      return op.emitError("unsupported wave.binary kind '")
             << op.getKind()
             << "' (addi/muli/shli migrated to wave.addi/wave.muli/wave.shli)";
    Value lhs = expect(op.getLhs(), op);
    Value rhs = expect(op.getRhs(), op);
    // VOP2 shift / commutative ops require `vsrc1` to be a VGPR.
    if (machineOpcode == "v_lshrrev_b32") {
      lhs = ensureVGPRForVSrc1(op.getLoc(), lhs);
    } else {
      if (isImm(rhs))
        rhs = ensureVGPRForVSrc1(op.getLoc(), rhs);
      if (!isVGPR(lhs) && !isVGPR(rhs))
        lhs = ensureVGPRForVSrc1(op.getLoc(), lhs);
    }
    values[op.getResult()] =
        createInstr(builder, op.getLoc(), machineOpcode, {lhs, rhs},
                    getRegType(op.getContext(), wavemachine::RegClass::VGPR));
    eraseIfTopLevel(op);
    return success();
  }

  // Element bit-width of an iN or !wave.simd<iN, W> type. Caller has
  // already verified the type is one of these via the op verifier.
  unsigned waveArithElementBits(Type type) {
    if (auto simd = dyn_cast<SimdType>(type))
      return simd.getElementType().getIntOrFloatBitWidth();
    return cast<IntegerType>(type).getWidth();
  }

  // Common shape check across the new width-independent arith ops:
  // require i32 today, fail with a clear diagnostic for anything else.
  LogicalResult requireI32(Operation *op, Type resultTy, StringRef mnemonic) {
    unsigned bits = waveArithElementBits(resultTy);
    if (bits == 32)
      return success();
    return op->emitError("WaveMachine backend only supports i32 wave.")
           << mnemonic << " today (got i" << bits << ")";
  }

  LogicalResult selectAddi(AddiOp op) {
    if (failed(requireI32(op, op.getResult().getType(), "addi")))
      return failure();
    Value lhs = expect(op.getLhs(), op);
    Value rhs = expect(op.getRhs(), op);
    if (!isa<SimdType>(op.getResult().getType())) {
      // Uniform i32 add: s_add_i32 (with a dead SCC result).
      Operation *added =
          createWMOp(builder, op.getLoc(), "s_add_i32", {lhs, rhs},
                     {getRegType(op.getContext(), wavemachine::RegClass::SGPR),
                      getSCCType(op.getContext())});
      values[op.getResult()] = added->getResult(0);
      eraseIfTopLevel(op);
      return success();
    }
    // SIMD or mixed: v_add_u32 with the existing SGPR-in-vsrc0 shuffle.
    values[op.getResult()] = addByteOffsets(op.getLoc(), lhs, rhs);
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectMuli(MuliOp op) {
    if (failed(requireI32(op, op.getResult().getType(), "muli")))
      return failure();
    Value lhs = expect(op.getLhs(), op);
    Value rhs = expect(op.getRhs(), op);
    if (!isa<SimdType>(op.getResult().getType())) {
      values[op.getResult()] =
          createInstr(builder, op.getLoc(), "s_mul_i32", {lhs, rhs},
                      getRegType(op.getContext(), wavemachine::RegClass::SGPR));
      eraseIfTopLevel(op);
      return success();
    }
    // v_mul_lo_u32 is VOP3, operand placement is unconstrained.
    values[op.getResult()] =
        createInstr(builder, op.getLoc(), "v_mul_lo_u32", {lhs, rhs},
                    getRegType(op.getContext(), wavemachine::RegClass::VGPR));
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectShli(ShliOp op) {
    if (failed(requireI32(op, op.getResult().getType(), "shli")))
      return failure();
    Value lhs = expect(op.getLhs(), op);
    Value rhs = expect(op.getRhs(), op);
    if (!isa<SimdType>(op.getResult().getType())) {
      values[op.getResult()] =
          createInstr(builder, op.getLoc(), "s_lshl_b32", {lhs, rhs},
                      getRegType(op.getContext(), wavemachine::RegClass::SGPR));
      eraseIfTopLevel(op);
      return success();
    }
    // VOP2 v_lshlrev_b32: shift amount in src0, value (vsrc1) must be VGPR.
    lhs = ensureVGPRForVSrc1(op.getLoc(), lhs);
    values[op.getResult()] =
        createInstr(builder, op.getLoc(), "v_lshlrev_b32", {rhs, lhs},
                    getRegType(op.getContext(), wavemachine::RegClass::VGPR));
    eraseIfTopLevel(op);
    return success();
  }

  // Materialize an SGPR or immediate value into a fresh VGPR so it can be
  // used in a position that the AMDGPU e32 encoding restricts to VGPR_32
  // (typically `vsrc1` on commutative VALU ops or the value operand of
  // `v_lshlrev_b32`). VGPR sources are returned as-is.
  Value ensureVGPRForVSrc1(Location loc, Value v) {
    if (isVGPR(v))
      return v;
    return createInstr(builder, loc, "v_mov_b32_tuple", {v},
                       getRegType(builder.getContext(),
                                  wavemachine::RegClass::VGPR, /*width=*/1));
  }

  LogicalResult selectCmp(CmpIOp op) {
    auto maskType = cast<MaskType>(op.getType());
    if (maskType.getWidth() != 32)
      return op.emitError("WaveMachine backend supports only !wave.mask<32>");

    StringRef machineOpcode =
        llvm::StringSwitch<StringRef>(stringifyCmpIPredicate(op.getPredicate()))
            .Case("eq", "v_cmp_eq_u32")
            .Case("ne", "v_cmp_ne_u32")
            .Case("ult", "v_cmp_lt_u32")
            .Case("ule", "v_cmp_le_u32")
            .Case("ugt", "v_cmp_gt_u32")
            .Case("uge", "v_cmp_ge_u32")
            .Default("");
    if (machineOpcode.empty())
      return op.emitError("unsupported wave.cmpi predicate");
    values[op.getResult()] =
        createInstr(builder, op.getLoc(), machineOpcode,
                    {expect(op.getLhs(), op), expect(op.getRhs(), op)},
                    getRegType(op.getContext(), wavemachine::RegClass::SGPR));
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectBallot(BallotOp op) {
    values[op.getResult()] = expect(op.getMask(), op);
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectReadFirst(ReadFirstOp op) {
    Value src = expect(op.getSource(), op);
    if (auto regType = dyn_cast<wavemachine::RegType>(src.getType());
        regType && regType.getRegClass() == wavemachine::RegClass::SGPR) {
      values[op.getResult()] = src;
      eraseIfTopLevel(op);
      return success();
    }
    values[op.getResult()] =
        createInstr(builder, op.getLoc(), "v_readfirstlane_b32", src,
                    getRegType(op.getContext(), wavemachine::RegClass::SGPR));
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectStore(StoreOp op) {
    auto baseIt = pointerBases.find(op.getPtr());
    auto offsetIt = pointerOffsets.find(op.getPtr());
    auto bufferIt = pointerBuffers.find(op.getPtr());
    if (baseIt == pointerBases.end() || offsetIt == pointerOffsets.end())
      return op.emitError("WaveMachine backend expects selected wave pointer");
    auto simdType = cast<SimdType>(op.getValue().getType());
    unsigned registers = loadRegisterCount(simdType);
    if (isSharedPointer(op.getPtr().getType())) {
      Value addr = ensureVGPRForVSrc1(
          op.getLoc(),
          addByteOffsets(op.getLoc(), baseIt->second, offsetIt->second));
      SmallVector<Value> operands{addr, expect(op.getValue(), op)};
      if (Value dependency = op.getDependency())
        operands.push_back(expect(dependency, op));
      StringRef opcode = registers == 1 ? "ds_store_b32" : "ds_store_tuple_b32";
      Operation *store = createWMOp(builder, op.getLoc(), opcode, operands,
                                    getMemTokenType(op.getContext()));
      values[op.getToken()] = store->getResult(0);
      eraseIfTopLevel(op);
      return success();
    }
    if (registers != 1)
      return op.emitError("global/buffer tuple stores are not supported by "
                          "the WaveMachine backend yet");
    SmallVector<Value> operands{offsetIt->second, expect(op.getValue(), op),
                                baseIt->second};
    if (Value dependency = op.getDependency())
      operands.push_back(expect(dependency, op));
    Operation *store =
        createWMOp(builder, op.getLoc(),
                   bufferIt != pointerBuffers.end() && bufferIt->second
                       ? "buffer_store_b32"
                       : "global_store_b32",
                   operands, getMemTokenType(op.getContext()));
    values[op.getToken()] = store->getResult(0);
    eraseIfTopLevel(op);
    return success();
  }

  unsigned elementSizeBytes(Type type) {
    if (auto ptr = dyn_cast<PtrType>(type))
      type = ptr.getElementType();
    if (auto simd = dyn_cast<SimdType>(type))
      type = cast<PtrType>(simd.getElementType()).getElementType();
    if (type.isInteger(8))
      return 1;
    if (type.isInteger(16) || type.isF16())
      return 2;
    if (type.isIntOrFloat() && type.getIntOrFloatBitWidth() == 32)
      return 4;
    return 4;
  }

  std::optional<int64_t> getImmediateValue(Value value) {
    auto imm = value.getDefiningOp<wavemachine::ImmOp>();
    if (!imm)
      return std::nullopt;
    return imm->getAttrOfType<IntegerAttr>("value").getInt();
  }

  Value addByteOffsets(Location loc, Value lhs, Value rhs) {
    std::optional<int64_t> lhsImm = getImmediateValue(lhs);
    std::optional<int64_t> rhsImm = getImmediateValue(rhs);
    if (lhsImm && rhsImm)
      return createImm(builder, loc, *lhsImm + *rhsImm);
    if (lhsImm && *lhsImm == 0)
      return rhs;
    if (rhsImm && *rhsImm == 0)
      return lhs;
    // v_add_nc_u32_e32 lays operands out as `vdst, vsrc0, vsrc1`, and the
    // VOP2 encoding only allows SGPR/literal in vsrc0 (vsrc1 must be a
    // VGPR). Hoist literals out of the rhs slot the same way
    // `selectBinary` does, otherwise the asm printer will produce
    // `v_add_nc_u32_e32 v, v, <literal>` which the assembler rejects.
    if (isImm(rhs))
      rhs = ensureVGPRForVSrc1(loc, rhs);
    if (!isVGPR(lhs) && !isVGPR(rhs))
      lhs = ensureVGPRForVSrc1(loc, lhs);
    return createInstr(
        builder, loc, "v_add_u32", {lhs, rhs},
        getRegType(builder.getContext(), wavemachine::RegClass::VGPR));
  }

  std::optional<Value> foldImmMul(Location loc, std::optional<int64_t> lhsImm,
                                  std::optional<int64_t> rhsImm) {
    if (lhsImm && rhsImm)
      return createImm(builder, loc, *lhsImm * *rhsImm);
    if ((lhsImm && *lhsImm == 0) || (rhsImm && *rhsImm == 0))
      return createImm(builder, loc, 0);
    return std::nullopt;
  }

  Value mulIndexValues(Location loc, Value lhs, Value rhs) {
    std::optional<int64_t> lhsImm = getImmediateValue(lhs);
    std::optional<int64_t> rhsImm = getImmediateValue(rhs);
    if (auto folded = foldImmMul(loc, lhsImm, rhsImm))
      return *folded;
    if (lhsImm && *lhsImm == 1)
      return rhs;
    if (rhsImm && *rhsImm == 1)
      return lhs;
    // v_mul_lo_u32 is VOP3, so SGPR/literal in either slot is legal.
    return createInstr(
        builder, loc, "v_mul_lo_u32", {lhs, rhs},
        getRegType(builder.getContext(), wavemachine::RegClass::VGPR));
  }

  // Structural integer literal of a node without materializing anything:
  // IXS_INT or IXS_RAT with unit denominator.
  static std::optional<int64_t> staticIntLiteral(::ixs_node *node) {
    switch (ixs_node_tag(node)) {
    case IXS_INT:
      return ixs_node_int_val(node);
    case IXS_RAT:
      if (ixs_node_rat_den(node) == 1)
        return ixs_node_rat_num(node);
      return std::nullopt;
    default:
      return std::nullopt;
    }
  }

  FailureOr<Value> materializeIxsRat(::ixs_node *node, Operation *user) {
    if (ixs_node_rat_den(node) != 1)
      return user->emitError(
          "wave.index_expr selection rejects non-integer rational");
    return createImm(builder, user->getLoc(), ixs_node_rat_num(node));
  }

  FailureOr<Value> materializeIxsSym(::ixs_node *node, Operation *user,
                                     const llvm::StringMap<Value> &subs) {
    StringRef name = ixs_node_sym_name(node);
    auto it = subs.find(name);
    if (it == subs.end())
      return user->emitError("wave.index_expr leaf '")
             << name << "' has no binding";
    return it->second;
  }

  // ADD = coeff + sum(term_coeff[i] * term[i]). Skip materializing
  // coeff when it's 0 and term_coeff[i] when it's 1.
  FailureOr<Value> materializeIxsAdd(::ixs_node *node, Operation *user,
                                     const llvm::StringMap<Value> &subs) {
    Location loc = user->getLoc();
    ::ixs_node *coeff = ixs_node_add_coeff(node);
    std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
    std::optional<Value> acc;
    if (!coeffInt || *coeffInt != 0) {
      FailureOr<Value> seed = materializeIndexExprNode(coeff, user, subs);
      if (failed(seed))
        return failure();
      acc = *seed;
    }
    uint32_t nterms = ixs_node_add_nterms(node);
    for (uint32_t i = 0; i < nterms; ++i) {
      FailureOr<Value> scaled = materializeIxsAddTerm(node, i, user, subs);
      if (failed(scaled))
        return failure();
      acc = acc ? addByteOffsets(loc, *acc, *scaled) : *scaled;
    }
    return acc ? *acc : createImm(builder, loc, 0);
  }

  FailureOr<Value> materializeIxsAddTerm(::ixs_node *node, uint32_t i,
                                         Operation *user,
                                         const llvm::StringMap<Value> &subs) {
    Location loc = user->getLoc();
    ::ixs_node *termCoeff = ixs_node_add_term_coeff(node, i);
    FailureOr<Value> term =
        materializeIndexExprNode(ixs_node_add_term(node, i), user, subs);
    if (failed(term))
      return failure();
    std::optional<int64_t> tcInt = staticIntLiteral(termCoeff);
    if (tcInt && *tcInt == 1)
      return *term;
    FailureOr<Value> tcVal = materializeIndexExprNode(termCoeff, user, subs);
    if (failed(tcVal))
      return failure();
    return mulIndexValues(loc, *tcVal, *term);
  }

  // MUL = coeff * prod(base[i] ^ exp[i]). Skip the coeff when it's 1.
  FailureOr<Value> materializeIxsMul(::ixs_node *node, Operation *user,
                                     const llvm::StringMap<Value> &subs) {
    Location loc = user->getLoc();
    ::ixs_node *coeff = ixs_node_mul_coeff(node);
    std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
    std::optional<Value> acc;
    if (!coeffInt || *coeffInt != 1) {
      FailureOr<Value> seed = materializeIndexExprNode(coeff, user, subs);
      if (failed(seed))
        return failure();
      acc = *seed;
    }
    uint32_t nfactors = ixs_node_mul_nfactors(node);
    for (uint32_t i = 0; i < nfactors; ++i) {
      FailureOr<Value> pow = materializeIxsMulFactor(node, i, user, subs);
      if (failed(pow))
        return failure();
      acc = acc ? mulIndexValues(loc, *acc, *pow) : *pow;
    }
    return acc ? *acc : createImm(builder, loc, 1);
  }

  FailureOr<Value> materializeIxsMulFactor(::ixs_node *node, uint32_t i,
                                           Operation *user,
                                           const llvm::StringMap<Value> &subs) {
    int32_t exp = ixs_node_mul_factor_exp(node, i);
    if (exp <= 0)
      return user->emitError(
          "wave.index_expr selection rejects non-positive mul exponent");
    FailureOr<Value> base =
        materializeIndexExprNode(ixs_node_mul_factor_base(node, i), user, subs);
    if (failed(base))
      return failure();
    Value pow = *base;
    for (int32_t e = 1; e < exp; ++e)
      pow = mulIndexValues(user->getLoc(), pow, *base);
    return pow;
  }

  // Top-level dispatch over a #wave.expr AST. Substitutes bound SSA values
  // at IXS_SYM leaves and folds ADD / MUL chains via the typed accessors
  // (ixsimpl stores `coeff + sum(c_i * t_i)` and `coeff * prod(b_i^e_i)`).
  // Floor / ceil / mod / rat with non-unit denominator are rejected.
  FailureOr<Value>
  materializeIndexExprNode(const ::ixs_node *cnode, Operation *user,
                           const llvm::StringMap<Value> &substitution) {
    // ixsimpl introspection accessors take non-const ixs_node *.
    auto *node = const_cast<::ixs_node *>(cnode);
    switch (ixs_node_tag(node)) {
    case IXS_INT:
      return createImm(builder, user->getLoc(), ixs_node_int_val(node));
    case IXS_RAT:
      return materializeIxsRat(node, user);
    case IXS_SYM:
      return materializeIxsSym(node, user, substitution);
    case IXS_ADD:
      return materializeIxsAdd(node, user, substitution);
    case IXS_MUL:
      return materializeIxsMul(node, user, substitution);
    default:
      return user->emitError(
                 "wave.index_expr selection does not support node tag ")
             << static_cast<int>(ixs_node_tag(node));
    }
  }

  LogicalResult selectIndexExpr(IndexExprOp op) {
    llvm::StringMap<Value> substitution;
    for (auto [nameAttr, binding] :
         llvm::zip(op.getNames(), op.getBindings())) {
      StringRef key = cast<StringAttr>(nameAttr).getValue();
      substitution[key] = expect(binding, op);
    }
    FailureOr<Value> result =
        materializeIndexExprNode(op.getExpr().getNode(), op, substitution);
    if (failed(result))
      return failure();
    values[op.getResult()] = *result;
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectPtrAdd(PtrAddOp op) {
    auto baseIt = pointerBases.find(op.getBase());
    auto offsetIt = pointerOffsets.find(op.getBase());
    if (baseIt == pointerBases.end() || offsetIt == pointerOffsets.end())
      return op.emitError("WaveMachine backend expects selected base pointer");
    // Snapshot mapped values before mutating any of the maps below; inserting
    // into a DenseMap can rehash and invalidate live iterators.
    Value baseValue = baseIt->second;
    Value baseOffsetValue = offsetIt->second;

    Value offset = expect(op.getOffset(), op);
    unsigned size = elementSizeBytes(op.getBase().getType());
    Value byteOffset = offset;
    if (auto offsetDef = offset.getDefiningOp<wavemachine::ImmOp>()) {
      int64_t scaled =
          offsetDef->getAttrOfType<IntegerAttr>("value").getInt() * size;
      byteOffset = createImm(builder, op.getLoc(), scaled);
    } else if (size != 1) {
      byteOffset = createInstr(
          builder, op.getLoc(), "v_lshlrev_b32",
          {offset, createImm(builder, op.getLoc(), llvm::Log2_32(size))},
          getRegType(op.getContext(), wavemachine::RegClass::VGPR));
    }
    byteOffset = addByteOffsets(op.getLoc(), baseOffsetValue, byteOffset);

    pointerBases[op.getResult()] = baseValue;
    pointerOffsets[op.getResult()] = byteOffset;
    pointerBuffers[op.getResult()] = pointerBuffers.lookup(op.getBase());
    values[op.getResult()] = baseValue;
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectMakeBuffer(waveamd::MakeBufferOp op) {
    auto baseIt = pointerBases.find(op.getBase());
    auto offsetIt = pointerOffsets.find(op.getBase());
    if (baseIt == pointerBases.end() || offsetIt == pointerOffsets.end())
      return op.emitError("WaveMachine backend expects selected base pointer");
    // See selectPtrAdd: snapshot before any DenseMap insertion.
    Value baseValue = baseIt->second;
    Value baseOffsetValue = offsetIt->second;
    Operation *descriptor =
        createWMOp(builder, op.getLoc(), "make_buffer_rsrc",
                   {baseValue, expect(op.getRange(), op)},
                   getRegType(op.getContext(), wavemachine::RegClass::SGPR, 4));
    pointerBases[op.getResult()] = descriptor->getResult(0);
    pointerOffsets[op.getResult()] = baseOffsetValue;
    pointerBuffers[op.getResult()] = true;
    values[op.getResult()] = descriptor->getResult(0);
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectToken(TokenOp op) {
    Operation *token = createWMOp(builder, op.getLoc(), "token", {},
                                  getMemTokenType(op.getContext()));
    values[op.getResult()] = token->getResult(0);
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectTokenJoin(Operation *op) {
    SmallVector<Value> operands;
    for (Value dependency : op->getOperands())
      operands.push_back(expect(dependency, op));
    Operation *join = createWMOp(builder, op->getLoc(), "token_join", operands,
                                 getMemTokenType(op->getContext()));
    values[op->getResult(0)] = join->getResult(0);
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectWait(WaitOp op) {
    SmallVector<Value> operands;
    for (Value dependency : op.getDependencies())
      operands.push_back(expect(dependency, op));
    createInstrNoResult(builder, op.getLoc(), "wait", operands);
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectFragmentFill(waveamd::FragmentFillOp op) {
    auto fragmentType = cast<waveamd::FragmentType>(op.getResult().getType());
    Value source = expect(op.getSource(), op);
    values[op.getResult()] = createInstr(
        builder, op.getLoc(), "v_mov_b32_tuple", source,
        getRegType(op.getContext(), wavemachine::RegClass::VGPR,
                   fragmentType.getRegisters()),
        {builder.getNamedAttr("registers", builder.getI64IntegerAttr(
                                               fragmentType.getRegisters()))});
    eraseIfTopLevel(op);
    return success();
  }

  // FragmentPack is a no-op rename at the WaveMachine level: the per-lane
  // register tuple selected for the source SIMD value already has the
  // exact register width required by the destination fragment.
  LogicalResult selectFragmentPack(waveamd::FragmentPackOp op) {
    values[op.getResult()] = expect(op.getRegisters(), op);
    eraseIfTopLevel(op);
    return success();
  }

  // Compute the per-lane register count for a wave.load result. Returns 1
  // for scalar results and the vector element count for tuple results.
  // The verifier guarantees the vector element width is 32 bits, so this
  // count directly maps to the destination VGPR tuple width.
  unsigned loadRegisterCount(SimdType simdType) {
    if (auto vecTy = dyn_cast<VectorType>(simdType.getElementType()))
      return vecTy.getNumElements();
    return 1;
  }

  // Build the WaveMachine load op with `opcode` and rebind the original
  // value/token to the produced VGPR tuple and memory token. Shared by
  // every variant of `selectLoad` (LDS / global / buffer).
  void finalizeLoad(LoadOp op, StringRef opcode, ArrayRef<Value> operands,
                    unsigned registers) {
    SmallVector<Type, 2> resultTypes{
        getRegType(op.getContext(), wavemachine::RegClass::VGPR, registers),
        getMemTokenType(op.getContext())};
    Operation *load =
        createWMOp(builder, op.getLoc(), opcode, operands, resultTypes);
    values[op.getValue()] = load->getResult(0);
    values[op.getToken()] = load->getResult(1);
    eraseIfTopLevel(op);
  }

  LogicalResult selectSharedLoad(LoadOp op, Value base, Value offset,
                                 unsigned registers) {
    Value addr = ensureVGPRForVSrc1(op.getLoc(),
                                    addByteOffsets(op.getLoc(), base, offset));
    SmallVector<Value> operands{addr};
    if (Value dependency = op.getDependency())
      operands.push_back(expect(dependency, op));
    finalizeLoad(op, registers == 1 ? "ds_load_b32" : "ds_load_tuple_b32",
                 operands, registers);
    return success();
  }

  LogicalResult selectGlobalOrBufferLoad(LoadOp op, Value base, Value offset,
                                         bool isBuffer, unsigned registers) {
    SmallVector<Value> operands{offset, base};
    if (Value dependency = op.getDependency())
      operands.push_back(expect(dependency, op));
    StringRef opcode;
    if (isBuffer)
      opcode = registers == 1 ? "buffer_load_b32" : "buffer_load_tuple_b32";
    else
      opcode = registers == 1 ? "global_load_b32" : "global_load_tuple_b32";
    finalizeLoad(op, opcode, operands, registers);
    return success();
  }

  LogicalResult selectLoad(LoadOp op) {
    auto baseIt = pointerBases.find(op.getPtr());
    auto offsetIt = pointerOffsets.find(op.getPtr());
    auto bufferIt = pointerBuffers.find(op.getPtr());
    if (baseIt == pointerBases.end() || offsetIt == pointerOffsets.end())
      return op.emitError("WaveMachine backend expects selected wave pointer");

    auto simdType = cast<SimdType>(op.getValue().getType());
    unsigned registers = loadRegisterCount(simdType);

    if (isSharedPointer(op.getPtr().getType()))
      return selectSharedLoad(op, baseIt->second, offsetIt->second, registers);

    bool isBuffer = bufferIt != pointerBuffers.end() && bufferIt->second;
    return selectGlobalOrBufferLoad(op, baseIt->second, offsetIt->second,
                                    isBuffer, registers);
  }

  LogicalResult selectLdsBase(LdsBaseOp op) {
    Value baseValue = createImm(builder, op.getLoc(), 0);
    pointerBases[op.getResult()] = baseValue;
    pointerOffsets[op.getResult()] =
        createImm(builder, op.getLoc(), op.getOffset());
    values[op.getResult()] = baseValue;
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectBarrier(BarrierOp op) {
    SmallVector<Value> operands;
    for (Value dependency : op.getDependencies())
      operands.push_back(expect(dependency, op));
    Operation *barrier = createWMOp(builder, op.getLoc(), "s_barrier", operands,
                                    getMemTokenType(op.getContext()));
    values[op.getToken()] = barrier->getResult(0);
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectMma(waveamd::MmaOp op) {
    if (op.getKind() != "wmma.i32.16x16x16.iu8" &&
        op.getKind() != "wmma.f32.16x16x16.f16")
      return op.emitError("unsupported WaveMachine matrix operation kind");
    auto resultType = cast<waveamd::FragmentType>(op.getResult().getType());
    StringRef machineOpcode = op.getKind() == "wmma.i32.16x16x16.iu8"
                                  ? "wmma_i32_16x16x16_iu8"
                                  : "wmma_f32_16x16x16_f16";
    values[op.getResult()] = createInstr(
        builder, op.getLoc(), machineOpcode,
        {expect(op.getA(), op), expect(op.getB(), op), expect(op.getAcc(), op)},
        getRegType(op.getContext(), wavemachine::RegClass::VGPR,
                   resultType.getRegisters()));
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectFragmentStore(waveamd::FragmentStoreOp op) {
    auto fragmentType = cast<waveamd::FragmentType>(op.getFragment().getType());
    auto baseIt = pointerBases.find(op.getPtr());
    auto offsetIt = pointerOffsets.find(op.getPtr());
    if (baseIt == pointerBases.end() || offsetIt == pointerOffsets.end())
      return op.emitError("WaveMachine backend expects selected wave pointer");
    Value lane =
        createInstr(builder, op.getLoc(), "v_mbcnt_lo", {},
                    getRegType(op.getContext(), wavemachine::RegClass::VGPR));
    Value byteOffset =
        createInstr(builder, op.getLoc(), "v_lshlrev_b32",
                    {lane, createImm(builder, op.getLoc(), 5)},
                    getRegType(op.getContext(), wavemachine::RegClass::VGPR));
    byteOffset = addByteOffsets(op.getLoc(), offsetIt->second, byteOffset);

    SmallVector<Value> storeTokens;
    for (int64_t component = 0, e = fragmentType.getRegisters(); component != e;
         ++component) {
      SmallVector<Value> operands{byteOffset, expect(op.getFragment(), op),
                                  baseIt->second};
      if (Value dependency = op.getDependency())
        operands.push_back(expect(dependency, op));
      Operation *store =
          createWMOp(builder, op.getLoc(), "global_store_tuple_b32", operands,
                     getMemTokenType(op.getContext()),
                     {builder.getNamedAttr(
                         "component", builder.getI64IntegerAttr(component))});
      storeTokens.push_back(store->getResult(0));
    }
    Operation *token =
        createWMOp(builder, op.getLoc(), "token_join", storeTokens,
                   getMemTokenType(op.getContext()));
    values[op.getToken()] = token->getResult(0);
    eraseIfTopLevel(op);
    return success();
  }

  // Ensure `v` is an SGPR1 by inserting a v_readfirstlane_b32 if it is
  // currently a VGPR. Imm values pass through as-is. Caller is
  // responsible for handling the SIMD lifting (we don't expect SIMD
  // here because scf.for operands are index/i32 scalars).
  Value ensureSGPR1(Location loc, Value v) {
    if (auto rt = dyn_cast<wavemachine::RegType>(v.getType())) {
      if (rt.getRegClass() == wavemachine::RegClass::SGPR && rt.getWidth() == 1)
        return v;
      if (rt.getRegClass() == wavemachine::RegClass::VGPR && rt.getWidth() == 1)
        return createInstr(
            builder, loc, "v_readfirstlane_b32", v,
            getRegType(builder.getContext(), wavemachine::RegClass::SGPR));
    }
    // Imm passes through; the WaveMachine_SGPR1OrImm constraint accepts it.
    return v;
  }

  // Strict variant of `ensureSGPR1`: also lifts immediates into a
  // freshly allocated SGPR via `s_mov_b32_value`. Required when the
  // destination operand constraint is plain WaveMachine_Reg (e.g. a
  // `uniform_loop` init carry).
  Value materializeSGPR1(Location loc, Value v) {
    v = ensureSGPR1(loc, v);
    if (isa<wavemachine::ImmType>(v.getType()))
      return createInstr(
          builder, loc, "s_mov_b32_value", v,
          getRegType(builder.getContext(), wavemachine::RegClass::SGPR));
    return v;
  }

  // Snapshot of the wave-level information we need to (a) emit an init
  // carry for an `scf.for` iter arg and (b) rebind the corresponding
  // body block argument so downstream selectors see the same shape they
  // would outside the loop. For SimdPtr iter args we carry the per-lane
  // *offset* through the loop; the base / buffer flag is assumed
  // loop-invariant and is captured from the surrounding scope.
  struct CarrySnapshot {
    enum class Kind { WMValue, Pointer };
    Kind kind;
    // `WMValue`: the already-selected wavemachine SSA value for the
    // init arg (e.g. a VGPR tuple holding a fragment).
    // `Pointer`: the selected per-lane offset VGPR for the pointer.
    Value carry;
    // `Pointer` only: the loop-invariant base register and buffer flag
    // copied from the outer sidecars.
    Value base;
    bool isBuffer = false;
  };

  // Capture the wavemachine "shape" for every `scf.for` iter arg. Wave
  // SimdPtr inits resolve through the pointer sidecars (base/offset),
  // everything else goes through the standard `values` map.
  LogicalResult snapshotScfCarries(scf::ForOp op,
                                   SmallVectorImpl<CarrySnapshot> &out) {
    out.reserve(op.getInitArgs().size());
    for (Value initArg : op.getInitArgs()) {
      if (auto simd = dyn_cast<SimdType>(initArg.getType());
          simd && isa<PtrType>(simd.getElementType())) {
        auto baseIt = pointerBases.find(initArg);
        auto offsetIt = pointerOffsets.find(initArg);
        if (baseIt == pointerBases.end() || offsetIt == pointerOffsets.end())
          return op.emitError(
              "scf.for pointer iter arg has no WaveMachine sidecar");
        out.push_back({CarrySnapshot::Kind::Pointer,
                       /*carry=*/offsetIt->second, baseIt->second,
                       pointerBuffers.lookup(initArg)});
        continue;
      }
      out.push_back({CarrySnapshot::Kind::WMValue, expect(initArg, op),
                     /*base=*/Value{}, /*isBuffer=*/false});
    }
    return success();
  }

  // Materialise the `wavemachine.uniform_loop` op with the requested
  // optional entry condition and init carries [IV, *iterArgCarries].
  Operation *buildUniformLoopOp(Location loc, Value entryCond,
                                ArrayRef<Value> inits) {
    SmallVector<Type> resultTypes;
    for (Value v : inits)
      resultTypes.push_back(v.getType());
    OperationState state(loc, "wavemachine.uniform_loop");
    if (entryCond)
      state.addOperands(entryCond);
    state.addOperands(inits);
    state.addTypes(resultTypes);
    int32_t segs[2] = {entryCond ? 1 : 0, static_cast<int32_t>(inits.size())};
    state.addAttribute("operandSegmentSizes",
                       builder.getDenseI32ArrayAttr(segs));
    Region *body = state.addRegion();
    body->emplaceBlock();
    for (Value init : inits)
      body->front().addArgument(init.getType(), loc);
    return builder.create(state);
  }

  // Register the loop body block args back into the selector maps so
  // recursive selection inside the body resolves IV / iter args /
  // carried pointers correctly.
  void bindLoopBodyArgs(scf::ForOp op, Block &loopBody,
                        ArrayRef<CarrySnapshot> snapshots) {
    values[op.getInductionVar()] = loopBody.getArgument(0);
    for (auto [idx, scfArg] : llvm::enumerate(op.getRegionIterArgs())) {
      Value blockCarry = loopBody.getArgument(idx + 1);
      const CarrySnapshot &snap = snapshots[idx];
      if (snap.kind == CarrySnapshot::Kind::Pointer) {
        pointerBases[scfArg] = snap.base;
        pointerOffsets[scfArg] = blockCarry;
        pointerBuffers[scfArg] = snap.isBuffer;
        continue;
      }
      values[scfArg] = blockCarry;
    }
  }

  // Recursively select every non-terminator op in the scf.for body.
  // The original scf.yield is consumed by the caller.
  LogicalResult selectScfBody(scf::ForOp op) {
    auto savedIP = builder.saveInsertionPoint();
    SmallVector<Operation *> bodyOps;
    for (Operation &child :
         llvm::make_early_inc_range(op.getBody()->without_terminator()))
      bodyOps.push_back(&child);
    for (Operation *child : bodyOps) {
      builder.restoreInsertionPoint(savedIP);
      if (failed(selectOperation(child)))
        return failure();
      savedIP = builder.saveInsertionPoint();
    }
    builder.restoreInsertionPoint(savedIP);
    return success();
  }

  // Build the `continue_if` carry operand list out of the scf.yield
  // results, looking up pointer offsets through the sidecar maps and
  // enforcing that pointer carries preserve their loop-invariant base.
  LogicalResult collectYieldCarries(scf::YieldOp yield,
                                    ArrayRef<CarrySnapshot> snapshots,
                                    SmallVectorImpl<Value> &out) {
    for (auto [idx, y] : llvm::enumerate(yield.getResults())) {
      const CarrySnapshot &snap = snapshots[idx];
      if (snap.kind == CarrySnapshot::Kind::Pointer) {
        auto baseIt = pointerBases.find(y);
        auto offsetIt = pointerOffsets.find(y);
        if (baseIt == pointerBases.end() || offsetIt == pointerOffsets.end())
          return yield.emitError(
              "scf.yield pointer carry has no WaveMachine sidecar");
        if (baseIt->second != snap.base)
          return yield.emitError(
              "scf.yield pointer carry must keep loop-invariant base");
        out.push_back(offsetIt->second);
        continue;
      }
      out.push_back(expect(y, yield));
    }
    return success();
  }

  // Rebind the scf.for results to the wavemachine loop op results,
  // skipping the synthetic IV carry at slot 0. Pointer carries get
  // their sidecar entries reconstructed from the captured base.
  void bindLoopResults(scf::ForOp op, Operation *loop,
                       ArrayRef<CarrySnapshot> snapshots) {
    for (auto [idx, scfResult] : llvm::enumerate(op.getResults())) {
      Value wmResult = loop->getResult(idx + 1);
      const CarrySnapshot &snap = snapshots[idx];
      if (snap.kind == CarrySnapshot::Kind::Pointer) {
        pointerBases[scfResult] = snap.base;
        pointerOffsets[scfResult] = wmResult;
        pointerBuffers[scfResult] = snap.isBuffer;
        continue;
      }
      values[scfResult] = wmResult;
    }
  }

  // Lower scf.for to wavemachine.uniform_loop with explicit IV
  // bookkeeping. `wave.nonzero_trip` on the for op skips the entry
  // SCC test (post-tested do/while), otherwise an `s_cmp_lt_i32
  // lower, upper` is materialised immediately before the loop op.
  LogicalResult selectScfFor(scf::ForOp op) {
    Location loc = op.getLoc();
    Value lower = ensureSGPR1(loc, expect(op.getLowerBound(), op));
    Value upper = ensureSGPR1(loc, expect(op.getUpperBound(), op));
    Value step = ensureSGPR1(loc, expect(op.getStep(), op));

    Type scc = getSCCType(builder.getContext());
    Value entryCond;
    if (!op->hasAttr("wave.nonzero_trip"))
      entryCond =
          createInstr(builder, loc, "s_cmp_lt_i32", {lower, upper}, scc);

    SmallVector<CarrySnapshot> snapshots;
    if (failed(snapshotScfCarries(op, snapshots)))
      return failure();

    SmallVector<Value> inits;
    inits.push_back(materializeSGPR1(loc, lower));
    for (const CarrySnapshot &snap : snapshots)
      inits.push_back(snap.carry);

    Operation *loop = buildUniformLoopOp(loc, entryCond, inits);
    Block &loopBody = loop->getRegion(0).front();
    bindLoopBodyArgs(op, loopBody, snapshots);

    builder.setInsertionPointToStart(&loopBody);
    if (failed(selectScfBody(op)))
      return failure();

    Type sgpr1 =
        getRegType(builder.getContext(), wavemachine::RegClass::SGPR, 1);
    Operation *add =
        createWMOp(builder, loc, "s_add_i32", {loopBody.getArgument(0), step},
                   TypeRange{sgpr1, scc});
    Value nextIv = add->getResult(0);
    Value backCond =
        createInstr(builder, loc, "s_cmp_lt_i32", {nextIv, upper}, scc);

    SmallVector<Value> contOperands{backCond, nextIv};
    auto yield = cast<scf::YieldOp>(op.getBody()->getTerminator());
    if (failed(collectYieldCarries(yield, snapshots, contOperands)))
      return failure();
    createWMOp(builder, loc, "continue_if", contOperands, TypeRange{});

    builder.setInsertionPointAfter(loop);
    bindLoopResults(op, loop, snapshots);
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectWhere(WhereOp op) {
    std::string endLabel = makeLabel("endif");
    std::string elseLabel =
        op.getElseRegion().empty() ? endLabel : makeLabel("else");
    Value condition = expect(op.getCondition(), op);
    Value savedExec =
        createInstr(builder, op.getLoc(), "s_and_saveexec_b32", condition,
                    getRegType(op.getContext(), wavemachine::RegClass::SGPR));
    createInstrNoResult(
        builder, op.getLoc(), "s_cbranch_execz", {},
        {builder.getNamedAttr("label", builder.getStringAttr(elseLabel))});
    if (failed(selectRegion(op.getThenRegion())))
      return failure();
    if (!op.getElseRegion().empty()) {
      createInstrNoResult(builder, op.getLoc(), "s_andn2_exec_b32",
                          {savedExec, condition});
      createInstrNoResult(
          builder, op.getLoc(), "s_cbranch_execz", {},
          {builder.getNamedAttr("label", builder.getStringAttr(endLabel))});
      createInstrNoResult(
          builder, op.getLoc(), "label", {},
          {builder.getNamedAttr("name", builder.getStringAttr(elseLabel))});
      if (failed(selectRegion(op.getElseRegion())))
        return failure();
    }
    createInstrNoResult(
        builder, op.getLoc(), "label", {},
        {builder.getNamedAttr("name", builder.getStringAttr(endLabel))});
    createInstrNoResult(builder, op.getLoc(), "s_mov_exec_lo", savedExec);
    eraseIfTopLevel(op);
    return success();
  }

  LogicalResult selectRegion(Region &region) {
    if (!region.hasOneBlock())
      return failure();
    for (Operation &op : llvm::make_early_inc_range(region.front())) {
      if (failed(selectOperation(&op)))
        return failure();
    }
    return success();
  }

  LogicalResult selectReturn(func::ReturnOp op) {
    if (op.getNumOperands() > 1)
      return op.emitError(
          "WaveMachine backend supports at most one return value");
    if (func->hasAttr("wave.kernel")) {
      if (op.getNumOperands() != 0)
        return op.emitError("kernel functions must return void");
      createInstrNoResult(builder, op.getLoc(), "s_endpgm", {});
      op.getOperandsMutable().clear();
      return success();
    }

    if (op.getNumOperands() == 1) {
      Value ret = expect(op.getOperand(0), op);
      auto regType = dyn_cast<wavemachine::RegType>(ret.getType());
      if (regType && regType.getRegClass() == wavemachine::RegClass::VGPR)
        ret = createInstr(
            builder, op.getLoc(), "v_readfirstlane_b32", ret,
            getRegType(op.getContext(), wavemachine::RegClass::SGPR));
      createInstrNoResult(
          builder, op.getLoc(), "s_mov_b32", ret,
          {builder.getNamedAttr("dst", builder.getStringAttr("s0"))});
    }
    createInstrNoResult(builder, op.getLoc(), "s_setpc_b64", {});
    op.getOperandsMutable().clear();
    return success();
  }
};

struct ConvertWaveAMDToWaveMachinePass
    : public wave::impl::ConvertWaveAMDToWaveMachineBase<
          ConvertWaveAMDToWaveMachinePass> {
  void runOnOperation() override {
    ModuleOp module = getOperation();
    for (func::FuncOp func : module.getOps<func::FuncOp>()) {
      if (failed(WaveMachineSelector(func).run()))
        return signalPassFailure();
    }
  }
};

} // namespace
