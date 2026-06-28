//===- WaveAMDRegAllocTransformState.h - Regalloc loop state ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCTRANSFORMSTATE_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCTRANSFORMSTATE_H

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"
#include <optional>

namespace mlir::wave {

StringRef getRegAllocTransformStateAttrName();
StringRef getRegAllocTransformAssignmentsAttrName();

enum class RegAllocTransformLoopDecision { Done, Restart, Stalled };

enum class RegAllocTransformValueKind { BlockArgument, OpResult };

struct RegAllocTransformLiveRange {
  unsigned start = 0;
  unsigned end = 0;
};

std::optional<waveamdmachine::RegType>
getRegAllocTransformTrackedRegType(Value value);

struct RegAllocTransformValue {
  SmallVector<int64_t> path;
  SmallVector<RegAllocTransformLiveRange, 2> ranges;
  waveamdmachine::RegClass regClass;
  RegAllocTransformValueKind kind = RegAllocTransformValueKind::OpResult;
  std::optional<unsigned> fixed;
  unsigned id = 0;
  unsigned set = 0;
  unsigned start = 0;
  unsigned end = 0;
  unsigned width = 0;
  unsigned offset = 0;
  unsigned number = 0;
};

struct RegAllocTransformAliasMember {
  unsigned value = 0;
  unsigned start = 0;
  unsigned end = 0;
  unsigned width = 0;
  int64_t offset = 0;
};

struct RegAllocTransformAliasSet {
  SmallVector<unsigned> members;
  waveamdmachine::RegClass regClass;
  std::optional<unsigned> fixedBase;
  unsigned id = 0;
  unsigned start = 0;
  unsigned end = 0;
  unsigned width = 0;
};

struct RegAllocTransformAssignment {
  waveamdmachine::RegClass regClass;
  unsigned set = 0;
  unsigned base = 0;
  unsigned width = 0;
  unsigned start = 0;
  unsigned end = 0;
};

struct RegAllocTransformBudget {
  unsigned limit = 0;
  StringRef mode = "default";
};

FailureOr<unsigned> getRegAllocTransformUnsignedAttr(DictionaryAttr dict,
                                                     StringRef name,
                                                     Operation *diagOp);

FailureOr<waveamdmachine::RegClass>
getRegAllocTransformRegClassAttr(DictionaryAttr dict, Operation *diagOp);

FailureOr<SmallVector<RegAllocTransformValue>>
parseRegAllocTransformValues(DictionaryAttr state, Operation *diagOp);

FailureOr<SmallVector<RegAllocTransformAliasSet>>
parseRegAllocTransformAliasSets(DictionaryAttr state,
                                ArrayRef<RegAllocTransformValue> values,
                                Operation *diagOp);

DictionaryAttr buildRegAllocTransformAliasMemberAttr(
    Builder &builder, const RegAllocTransformAliasMember &member);

DictionaryAttr buildRegAllocTransformAliasSetAttr(
    Builder &builder, waveamdmachine::RegClass regClass, unsigned id,
    ArrayRef<RegAllocTransformAliasMember> members, unsigned width);

DictionaryAttr buildRegAllocTransformAssignmentAttr(
    Builder &builder, const RegAllocTransformAssignment &assignment);

RegAllocTransformBudget
getRegAllocTransformBudget(func::FuncOp func,
                           waveamdmachine::RegClass regClass);

unsigned
getRegAllocTransformDefaultBudgetLimit(waveamdmachine::RegClass regClass);

FailureOr<std::optional<RegAllocTransformBudget>>
getRegAllocTransformVGPRFamilyBudget(func::FuncOp func);

void clearRegAllocTransformState(Operation *target);

FailureOr<RegAllocTransformLoopDecision>
getRegAllocTransformLoopDecision(Operation *target);

LogicalResult setRegAllocTransformLoopIteration(Operation *target,
                                                Builder &builder,
                                                int64_t iteration);

} // namespace mlir::wave

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCTRANSFORMSTATE_H
