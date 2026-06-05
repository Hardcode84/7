//===- WaveAMDMachineSelector.h - Wave-to-WaveAMDMachine selector --*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Private selector header: shared factories, register builders, pointer
// offsets, and index-expression helpers.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESELECTOR_H
#define MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESELECTOR_H

#include "mlir/Analysis/DataFlow/DeadCodeAnalysis.h"
#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/UB/IR/UBOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringMap.h"

#include <cstdint>
#include <optional>
#include <string>

namespace mlir::wave::wmsel {

// Symbol kind for address-expression classification. Bindings reachable only
// through `Const` / `Uniform` paths can land in `instOffset` / `soffset`;
// anything reaching a `Lane` symbol falls through to `voffset`.
enum class TermKind { Const = 0, Uniform = 1, Lane = 2 };

struct PointerOffsetBinding {
  std::string name;
  Value value;
  TermKind kind = TermKind::Lane;
};

// Canonical symbolic pointer offset. Slot materialization happens in
// AddressPlan.
struct PointerOffset {
  llvm::SmallVector<PointerOffsetBinding, 4> bindings;
  llvm::SmallVector<sym::PredHandle, 2> assumptions;
  sym::ExprHandle expr;
};

// Planned machine byte-address fields. Null expr handle means absent slot.
struct AddressPlan {
  llvm::SmallVector<PointerOffsetBinding, 4> bindings;
  llvm::SmallVector<sym::PredHandle, 2> assumptions;
  sym::ExprHandle voffsetExpr;
  sym::ExprHandle soffsetExpr;
  sym::ExprHandle fullAddressRemainderExpr;
  int64_t instOffset = 0;
};

// Small free helpers used by every selection TU.

inline mlir::waveamdmachine::RegType
getRegType(MLIRContext *ctx, mlir::waveamdmachine::RegClass cls,
           unsigned width = 1) {
  return mlir::waveamdmachine::RegType::get(ctx, cls, width, -1);
}

inline mlir::waveamdmachine::RegType getSCCType(MLIRContext *ctx) {
  return mlir::waveamdmachine::RegType::get(ctx,
                                            mlir::waveamdmachine::RegClass::SCC,
                                            /*width=*/1, /*index=*/-1);
}

inline mlir::waveamdmachine::RegType getVCCType(MLIRContext *ctx) {
  return mlir::waveamdmachine::RegType::get(ctx,
                                            mlir::waveamdmachine::RegClass::VCC,
                                            /*width=*/1, /*index=*/-1);
}

inline LogicalResult emitBufferAddressFieldError(Operation *op) {
  return op->emitError("buffer memory op offset must fit proven unsigned "
                       "32-bit voffset/soffset fields; add wave.assume "
                       "for bounded offsets");
}

// Pinned entry/live-in registers bypass normal allocation.
inline mlir::waveamdmachine::RegType
getPinnedRegType(MLIRContext *ctx, mlir::waveamdmachine::RegClass cls,
                 unsigned width, int64_t index) {
  return mlir::waveamdmachine::RegType::get(ctx, cls, width, index);
}

inline mlir::waveamdmachine::ImmType getImmType(MLIRContext *ctx) {
  return mlir::waveamdmachine::ImmType::get(ctx);
}

inline mlir::waveamdmachine::MemTokenType getMemTokenType(MLIRContext *ctx) {
  return mlir::waveamdmachine::MemTokenType::get(ctx);
}

inline bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         mlir::waveamdmachine::WaveAMDMachineDialect::getDialectNamespace();
}

inline bool isVGPR(Value v) {
  auto rt = dyn_cast<mlir::waveamdmachine::RegType>(v.getType());
  return rt && rt.getRegClass() == mlir::waveamdmachine::RegClass::VGPR;
}

inline bool isImm(Value v) {
  return v.getDefiningOp<mlir::waveamdmachine::ImmOp>() != nullptr;
}

inline Value createImm(OpBuilder &builder, Location loc, int64_t value) {
  return mlir::waveamdmachine::ImmOp::create(builder, loc,
                                             getImmType(builder.getContext()),
                                             static_cast<uint64_t>(value));
}

class WaveAMDMachineSelector;

// Index-expression helpers share selector factories, bindings, and symbol
// store.

FailureOr<Value> materializeIndexExprNode(WaveAMDMachineSelector &S,
                                          sym::ExprHandle expr, Operation *user,
                                          const llvm::StringMap<Value> &subs);

FailureOr<PointerOffset> makePointerOffset(WaveAMDMachineSelector &S,
                                           const SymbolicOffset &offset);

FailureOr<PointerOffset> makePointerOffset(WaveAMDMachineSelector &S,
                                           IndexExprOp op);

TermKind classifyTerm(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                      const llvm::StringMap<TermKind> &symKinds);

FailureOr<AddressPlan>
planAddressFields(WaveAMDMachineSelector &S, const PointerOffset &offset,
                  const mlir::waveamdmachine::AddressFieldSpec &spec);

FailureOr<Value> materializePointerOffsetValue(WaveAMDMachineSelector &S,
                                               Operation *user,
                                               const PointerOffset &offset);

FailureOr<Value> materializePointerOffsetVGPR(WaveAMDMachineSelector &S,
                                              Operation *user,
                                              const PointerOffset &offset);

TermKind classifyPointerOffset(WaveAMDMachineSelector &S,
                               const PointerOffset &offset);

FailureOr<Value> materializePointerOffsetCarry(WaveAMDMachineSelector &S,
                                               Operation *user,
                                               const PointerOffset &offset,
                                               TermKind carryKind);

FailureOr<AddressPlan>
planMemoryAddress(WaveAMDMachineSelector &S, Operation *user,
                  const PointerOffset &offset,
                  const mlir::waveamdmachine::AddressFieldSpec &spec);

FailureOr<Value> materializeFullPlanAddress(WaveAMDMachineSelector &S,
                                            Operation *user, Value base,
                                            const AddressPlan &plan);

// scf.for lowering cluster. Defined in `WaveAMDMachineScfFor.cpp` as free
// helpers taking the selector by reference, mirroring the IXS-cluster
// pattern. `selectScfFor` is the entry point dispatched from
// `selectOperation`; the rest are private to that lowering.
LogicalResult selectScfFor(WaveAMDMachineSelector &S, scf::ForOp op);

// Load/store lowering cluster. Defined in `WaveAMDMachineLoadStore.cpp`
// as free helpers; the LDS / global / buffer variants and
// `finalizeLoad` live in that TU's anon namespace.
LogicalResult selectStore(WaveAMDMachineSelector &S, StoreOp op);
LogicalResult selectLoad(WaveAMDMachineSelector &S, LoadOp op);

class WaveAMDMachineSelector {
public:
  explicit WaveAMDMachineSelector(func::FuncOp func)
      : func(func), builder(func) {}

  LogicalResult run();

  struct BucketedOperands {
    Value voffset;
    Value soffset;
    int64_t instOffset = 0;
  };

  // ---- selector state ----------------------------------------------------
  // Public because the index-expr / address-planner cluster lives next door
  // as free helpers (see `WaveAMDMachineIndexExpr.cpp`) and reaches in
  // for `builder`, the substitution maps, the range solver, etc.
  func::FuncOp func;
  OpBuilder builder;
  DenseMap<Value, Value> values;
  DenseMap<Value, Value> pointerBases;
  DenseMap<Value, Value> pointerGlobalBases;
  DenseMap<Value, PointerOffset> pointerIndexOffsets;
  DenseMap<Value, PointerOffset> indexOffsets;
  DenseMap<Value, bool> pointerBuffers;
  SmallVector<Operation *> opsToErase;
  DataFlowSolver rangeSolver;
  std::optional<unsigned> targetIsaMajor;
  unsigned nextLabel = 0;

  // ---- address-planning helpers -----------------------------------------
  void appendBindingAssumptions(Value binding, StringRef name,
                                SmallVectorImpl<sym::PredHandle> &assumptions,
                                int64_t scale = 1);
  sym::Store &symbolStore();
  bool slotFitsU32(sym::ExprHandle expr, ArrayRef<sym::PredHandle> assumptions);
  SmallVector<NamedAttribute> instOffsetAttrs(int64_t value,
                                              StringRef attrName);

  // ---- codegen helpers ---------------------------------------------------
  bool isBufferPointer(Type type);
  bool isSharedPointer(Type type);
  unsigned pointerBaseWidth(Type type);
  unsigned nonPointerArgWidth(Type type);
  void materializeArgument(BlockArgument arg, size_t index);
  std::string makeLabel(StringRef stem);
  Value expect(Value value, Operation *user);
  void eraseIfTopLevel(Operation *op);
  std::optional<int64_t> getImmediateValue(Value value);
  Value ensureVGPRForVSrc1(Location loc, Value v);
  bool isUniformValue(Value v);
  std::optional<Value> foldImmMul(Location loc, std::optional<int64_t> lhsImm,
                                  std::optional<int64_t> rhsImm);
  Value foldImmAdd(Location loc, Value lhs, Value rhs);
  Value addByteOffsets(Location loc, Value lhs, Value rhs);
  Value addUniformBytes(Location loc, Value acc, Value add);
  Value mulIndexValues(Location loc, Value lhs, Value rhs);
  Value tryLshlPow2(Location loc, std::optional<int64_t> lhsImm, Value lhs,
                    std::optional<int64_t> rhsImm, Value rhs);
  Value mulUniformValues(Location loc, Value lhs, Value rhs);
  Value shrPow2(Location loc, Value v, unsigned log2Den);
  Value andMask(Location loc, Value v, int64_t mask);
  unsigned waveArithElementBits(Type type);
  unsigned elementSizeBytes(Type type);
  Value ensureSGPR1(Location loc, Value v);
  Value materializeSGPR1(Location loc, Value v);

  // ---- top-level dispatch ------------------------------------------------
  LogicalResult selectOperation(Operation *op);

  // ---- per-op selectors --------------------------------------------------
  LogicalResult selectConstant(arith::ConstantIntOp op);
  LogicalResult selectConstant(arith::ConstantOp op);
  LogicalResult selectPoison(ub::PoisonOp op);
  LogicalResult selectLaneId(LaneIdOp op);
  LogicalResult selectReadCycles(ReadCyclesOp op);
  LogicalResult selectWorkgroupId(WorkgroupIdOp op);
  LogicalResult selectWorkitemId(WorkitemIdOp op);
  LogicalResult selectSplat(SplatOp op);
  LogicalResult selectAssume(AssumeOp op);
  LogicalResult selectBinary(BinaryOp op);
  LogicalResult selectBinaryAddI32(BinaryOp op);
  LogicalResult selectBinaryAddI64(BinaryOp op);
  LogicalResult selectBinaryMulI32(BinaryOp op);
  LogicalResult selectBinaryMulI64(BinaryOp op);
  LogicalResult selectBinaryShLI32(BinaryOp op);
  LogicalResult selectBinaryShLI64(BinaryOp op);
  LogicalResult selectPack(PackOp op);
  LogicalResult selectExtract(ExtractOp op);
  LogicalResult selectCast(CastOp op);
  LogicalResult selectFAdd(FAddOp op);
  LogicalResult selectFSub(FSubOp op);
  LogicalResult selectFMul(FMulOp op);
  LogicalResult selectFMax(FMaxOp op);
  LogicalResult selectFma(FmaOp op);
  LogicalResult selectFExp2(FExp2Op op);
  LogicalResult selectFRcp(FRcpOp op);
  LogicalResult selectIndexExpr(IndexExprOp op);
  LogicalResult selectCmp(CmpIOp op);
  LogicalResult selectSelect(SelectOp op);
  LogicalResult selectBallot(BallotOp op);
  LogicalResult selectReadFirst(ReadFirstOp op);
  LogicalResult selectPtrAdd(PtrAddOp op);
  LogicalResult selectMakeBuffer(waveamd::MakeBufferOp op);
  LogicalResult selectToken(TokenOp op);
  LogicalResult selectTokenJoin(Operation *op);
  LogicalResult selectWait(WaitOp op);
  LogicalResult selectWhere(WhereOp op);
  LogicalResult selectRegion(Region &region);
  LogicalResult selectLdsBase(LdsBaseOp op);
  LogicalResult selectBarrier(BarrierOp op);
  LogicalResult selectFragmentFill(waveamd::FragmentFillOp op);
  LogicalResult selectFragmentPack(waveamd::FragmentPackOp op);
  LogicalResult selectFragmentUnpack(waveamd::FragmentUnpackOp op);
  LogicalResult selectMma(waveamd::MmaOp op);
  LogicalResult selectMmaScale(waveamd::MmaScaleOp op);
  LogicalResult selectTransposeLoad(waveamd::TransposeLoadOp op);
  LogicalResult selectDmaLoadLds(waveamd::DmaLoadLdsOp op);
  LogicalResult selectReturn(func::ReturnOp op);
};

FailureOr<WaveAMDMachineSelector::BucketedOperands>
materializePlanBuckets(WaveAMDMachineSelector &S, Operation *user,
                       const AddressPlan &plan,
                       const mlir::waveamdmachine::AddressFieldSpec &spec);

} // namespace mlir::wave::wmsel

#endif // MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESELECTOR_H
