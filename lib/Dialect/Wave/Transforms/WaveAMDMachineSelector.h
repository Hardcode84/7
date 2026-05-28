//===- WaveAMDMachineSelector.h - Wave-to-WaveAMDMachine selector --*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Private header for the Wave-to-WaveAMDMachine selector. Holds the
// `WaveAMDMachineSelector` class plus the small free helpers (register
// builders, `waveamdmachine.*` op factories, OffsetTriple, TermKind) that
// every selection-time TU needs. The IXS-AST materializer / classifier /
// constant evaluator / bucketizer cluster lives next to the class as
// free functions defined in `WaveAMDMachineIndexExpr.cpp` -- this header
// declares them so `WaveAMDMachine.cpp` can call them and so the
// bucketizer TU sees the selector's public state.
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

// Bucketed byte offset for a wave-level pointer. `voffset` carries the
// per-lane VGPR contribution, `soffset` the uniform SGPR / imm part,
// and `instOffset` an accumulated immediate that lands in the
// memory op's `offset N` attr. A null `voffset` / `soffset` and a
// zero `instOffset` each mean "no contribution".
//
// `voffsetExpr` / `soffsetExpr` are the symbolic forms of the V / S
// buckets; `assumptions` are the per-binding range assumptions
// inherited from the source `wave.index_expr`. The emit-time spec
// check calls `sym::provablyInRange` over them and demotes the
// bucket when its proven range overflows the slot's hardware width.
struct OffsetTriple {
  Value voffset;
  Value soffset;
  int64_t instOffset = 0;
  const ::ixs_node *voffsetExpr = nullptr;
  const ::ixs_node *soffsetExpr = nullptr;
  llvm::SmallVector<sym::PredHandle, 2> assumptions;
};

// Symbol kind for the bucketizer's per-summand classification. Bindings
// reachable only through `Const` / `Uniform` paths can land in
// `instOffset` / `soffset`; anything reaching a `Lane` symbol falls
// through to `voffset`.
enum class TermKind { Const = 0, Uniform = 1, Lane = 2 };

// Per-iter-arg snapshot captured at the scf.for boundary. `WMValue`
// carries an already-selected waveamdmachine SSA value straight through;
// `Pointer` collapses a SimdPtr iter arg's triple to a single VGPR
// carry so the body re-derives V / S / inst contributions from a fresh
// PtrAdd. `base` and `isBuffer` ride untouched across the loop body
// for `Pointer` carries.
//
// `strideBytes != 0` marks a global pointer whose per-iter advance is a
// wave-uniform constant: the body recomputes its base as `base + iv *
// strideBytes` in the scalar domain and the voffset carry stays
// loop-invariant, so the per-lane `v_add` advance disappears.
struct CarrySnapshot {
  enum class Kind { WMValue, Pointer };
  Kind kind;
  Value carry;
  Value base;
  bool isBuffer = false;
  int64_t strideBytes = 0;
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

// Pinned variant: the resulting register's physical index is fixed up
// front (HSA-loader-preloaded SGPRs s2..s4, workitem_id VGPR v0, ...).
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

// IXS-AST materializer / classifier / constant evaluator / bucketizer
// cluster. Defined in `WaveAMDMachineIndexExpr.cpp` as free helpers
// taking the selector by reference. The selector publishes the
// `waveamdmachine` op factories, the codegen helpers (addByteOffsets,
// addUniformBytes, mul*, shr/and), the binding maps, and the symbol
// store via public methods that these helpers call.

FailureOr<Value> materializeIndexExprNode(WaveAMDMachineSelector &S,
                                          const ::ixs_node *node,
                                          Operation *user,
                                          const llvm::StringMap<Value> &subs);

TermKind classifyTerm(WaveAMDMachineSelector &S, ::ixs_node *node,
                      const llvm::StringMap<TermKind> &symKinds);

std::optional<int64_t> evalConstantNode(WaveAMDMachineSelector &S,
                                        ::ixs_node *node);

int64_t collectDenominator(::ixs_node *node);

LogicalResult bucketize(WaveAMDMachineSelector &S, ::ixs_node *node,
                        Operation *user, const llvm::StringMap<Value> &subs,
                        const llvm::StringMap<TermKind> &symKinds,
                        OffsetTriple &triple);

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
  // Public because the index-expr / bucketizer cluster lives next door
  // as free helpers (see `WaveAMDMachineIndexExpr.cpp`) and reaches in
  // for `builder`, the substitution maps, the range solver, etc.
  func::FuncOp func;
  OpBuilder builder;
  DenseMap<Value, Value> values;
  DenseMap<Value, Value> pointerBases;
  DenseMap<Value, OffsetTriple> pointerOffsets;
  DenseMap<Value, OffsetTriple> indexTriples;
  DenseMap<Value, bool> pointerBuffers;
  SmallVector<Operation *> opsToErase;
  DataFlowSolver rangeSolver;
  unsigned nextLabel = 0;

  // ---- bucketizer helpers (kept here so out-of-TU callers can use them) --
  std::optional<sym::PredHandle> bindingAssumption(Value binding,
                                                   StringRef name);
  Value collapseTriple(Location loc, const OffsetTriple &t);
  OffsetTriple scaleTriple(Location loc, OffsetTriple t, unsigned size);
  OffsetTriple mergeTriples(Location loc, OffsetTriple a, OffsetTriple b);
  sym::Store &symbolStore();
  bool slotFitsU32(const ::ixs_node *expr,
                   ArrayRef<sym::PredHandle> assumptions);
  SmallVector<NamedAttribute> instOffsetAttrs(int64_t value,
                                              StringRef attrName);
  const ::ixs_node *appendBucketExpr(const ::ixs_node *acc,
                                     const ::ixs_node *add);
  const ::ixs_node *scaleBucketExpr(const ::ixs_node *value,
                                    const ::ixs_node *coeff);
  void sinkImmIntoRemainingSlot(Location loc, OffsetTriple &t, Value imm,
                                bool hasSoffset);
  bool instOffsetOverflows(const OffsetTriple &t,
                           const mlir::waveamdmachine::AddressFieldSpec &spec);
  void demoteToFitSpec(Location loc, OffsetTriple &t,
                       const mlir::waveamdmachine::AddressFieldSpec &spec);
  BucketedOperands
  bucketForSpec(Location loc, OffsetTriple t,
                const mlir::waveamdmachine::AddressFieldSpec &spec);

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
  LogicalResult selectLaneId(LaneIdOp op);
  LogicalResult selectReadCycles(ReadCyclesOp op);
  LogicalResult selectWorkgroupId(WorkgroupIdOp op);
  LogicalResult selectWorkitemId(WorkitemIdOp op);
  LogicalResult selectSplat(SplatOp op);
  LogicalResult selectAssumeRange(AssumeRangeOp op);
  LogicalResult selectBinary(BinaryOp op);
  LogicalResult selectCast(CastOp op);
  LogicalResult selectAddi(AddiOp op);
  LogicalResult selectAddiI32(AddiOp op);
  LogicalResult selectAddiI64(AddiOp op);
  LogicalResult selectMuli(MuliOp op);
  LogicalResult selectMuliI32(MuliOp op);
  LogicalResult selectMuliI64(MuliOp op);
  LogicalResult selectShli(ShliOp op);
  LogicalResult selectShliI32(ShliOp op);
  LogicalResult selectShliI64(ShliOp op);
  LogicalResult selectFAdd(FAddOp op);
  LogicalResult selectFSub(FSubOp op);
  LogicalResult selectFMul(FMulOp op);
  LogicalResult selectFMax(FMaxOp op);
  LogicalResult selectFExp2(FExp2Op op);
  LogicalResult selectFRcp(FRcpOp op);
  LogicalResult selectIndexExpr(IndexExprOp op);
  LogicalResult selectCmp(CmpIOp op);
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
  LogicalResult selectDmaLoadLds(waveamd::DmaLoadLdsOp op);
  LogicalResult selectReturn(func::ReturnOp op);
};

} // namespace mlir::wave::wmsel

#endif // MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINESELECTOR_H
