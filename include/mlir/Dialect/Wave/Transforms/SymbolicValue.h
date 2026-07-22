//===- SymbolicValue.h - Wave symbolic SSA values ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_SYMBOLICVALUE_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_SYMBOLICVALUE_H

#include "mlir/Dialect/Wave/IR/Wave.h"

#include <optional>

namespace mlir {
class DataFlowSolver;

namespace wave {

struct SymbolicPredicate {
  SmallVector<SymbolicOffsetBinding, 4> bindings;
  SmallVector<sym::PredHandle, 2> assumptions;
  sym::PredHandle predicate;
};

FailureOr<std::optional<SymbolicOffset>>
buildSymbolicIndexValue(Value value, WaveDialect &dialect,
                        DataFlowSolver &solver);
FailureOr<std::optional<SymbolicPredicate>>
buildSymbolicIndexPredicate(Value value, WaveDialect &dialect,
                            DataFlowSolver &solver);
FailureOr<std::optional<SymbolicPredicate>>
buildSymbolicPacketPredicateRelation(Value value, WaveDialect &dialect,
                                     DataFlowSolver &solver);

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_SYMBOLICVALUE_H
