//===- WaveAMDRegAllocTransformUtils.h - Regalloc utilities ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCTRANSFORMUTILS_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCTRANSFORMUTILS_H

#include "WaveAMDRegAllocTransformState.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Attributes.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallVector.h"
#include <array>
#include <optional>

namespace mlir::wave::regalloc_detail {

using ResolvedRegAllocValue =
    std::pair<Value, const wave::RegAllocTransformValue *>;

struct RegAllocTransformFailure {
  SmallVector<wave::RegAllocTransformAssignment> overlaps;
  StringRef className;
  StringRef reason;
  unsigned set = 0;
  unsigned position = 0;
};

struct RematReliefContext {
  DenseMap<Operation *, unsigned> positions;
  DenseMap<Value, const wave::RegAllocTransformValue *> values;
};

static constexpr unsigned kRegClassCount = 5;
using RegClassPressure = std::array<int64_t, kRegClassCount>;

inline constexpr std::array<waveamdmachine::RegClass, kRegClassCount>
    kRegClasses = {
        waveamdmachine::RegClass::SGPR, waveamdmachine::RegClass::VGPR,
        waveamdmachine::RegClass::AGPR, waveamdmachine::RegClass::SCC,
        waveamdmachine::RegClass::VCC};

template <typename T>
FailureOr<T> failRegAllocStateIdentity(Operation *diagOp) {
  diagOp->emitError("regalloc state value identity no longer matches IR");
  return failure();
}

bool liveRangesOverlap(unsigned lhsStart, unsigned lhsEnd, unsigned rhsStart,
                       unsigned rhsEnd);
bool liveRangesOverlap(const wave::RegAllocTransformLiveRange &lhs,
                       const wave::RegAllocTransformLiveRange &rhs);
bool valueLiveAtPosition(const wave::RegAllocTransformValue &value,
                         unsigned position);
bool valueLiveBeforeAtPosition(const wave::RegAllocTransformValue &value,
                               unsigned position);
bool valueLiveAcrossPosition(const wave::RegAllocTransformValue &value,
                             unsigned position);
bool valueRangeEndsAt(const wave::RegAllocTransformValue &value,
                      unsigned position);
bool isVGPRFamilyClass(waveamdmachine::RegClass regClass);
unsigned getRegClassIndex(waveamdmachine::RegClass regClass);
void addRegClassPressure(RegClassPressure &pressure,
                         waveamdmachine::RegClass regClass, int64_t dwords);
int64_t getTotalPressure(RegClassPressure pressure);
unsigned getCombinedVGPRFamilyPressure(unsigned agprFootprint,
                                       unsigned vgprFootprint);

void collectRegAllocValues(Region &region, SmallVectorImpl<Value> &values);
FailureOr<Value>
resolveRegAllocStateValue(func::FuncOp func,
                          const wave::RegAllocTransformValue &value);
FailureOr<SmallVector<ResolvedRegAllocValue>>
resolveRegAllocStateValues(func::FuncOp func,
                           ArrayRef<wave::RegAllocTransformValue> values);
FailureOr<SmallVector<ResolvedRegAllocValue>>
resolveSetValues(func::FuncOp func, const wave::RegAllocTransformAliasSet &set,
                 ArrayRef<wave::RegAllocTransformValue> values);

FailureOr<std::optional<RegAllocTransformFailure>>
parseRegAllocTransformFailure(func::FuncOp func);
bool isAGPRRelievableFailure(const RegAllocTransformFailure &failure);

std::optional<unsigned>
getRegAllocTransformFixedBase(const wave::RegAllocTransformAliasSet &set,
                              ArrayRef<wave::RegAllocTransformValue> values);
const wave::RegAllocTransformAliasSet *
findRegAllocTransformSet(ArrayRef<wave::RegAllocTransformAliasSet> sets,
                         unsigned id);
SmallVector<unsigned>
collectVGPRReliefCandidateIds(const RegAllocTransformFailure &failure);
bool hasFixedRegAllocValue(const wave::RegAllocTransformAliasSet &set,
                           ArrayRef<wave::RegAllocTransformValue> values);

bool isRegAllocTransformBridgeRelated(Value value);
bool isStructuralLoopCarryUse(Operation *op);
bool hasStructuralLoopCarryUse(Value value);

void collectRegAllocOpPositions(Region &region,
                                DenseMap<Operation *, unsigned> &ops);
RematReliefContext
buildRematReliefContext(func::FuncOp func,
                        ArrayRef<ResolvedRegAllocValue> values);
Operation *getAncestorInBlock(Operation *op, Block *block);
bool valueIsAvailableAt(Value value, Operation *user);
std::optional<unsigned> getRematOpPosition(Operation *op,
                                           const RematReliefContext &context);
bool isStateValueLiveAt(Value value, unsigned position,
                        const RematReliefContext &context);
int64_t getRematReliefLoopCostScale(Operation *op);
int64_t getParentLoopCostScale(Operation *op);
int64_t getMemoryBridgeCostScale(Operation *anchor, bool beforeAnchor);
bool canReuseKilledOperandForResult(Operation *op, OpOperand &operand);
bool requiresKilledOperandReuseForResult(Operation *op, OpOperand &operand);

std::optional<unsigned> getUnsignedIntegerAttr(Operation *op, StringRef name);
Attribute findAncestorAttr(Operation *op, StringRef name);

} // namespace mlir::wave::regalloc_detail

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCTRANSFORMUTILS_H
