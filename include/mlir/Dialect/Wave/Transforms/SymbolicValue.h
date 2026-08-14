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

#include <cstdint>
#include <optional>

namespace mlir {
class DataFlowSolver;

namespace wave {

struct SymbolicPredicate {
  SmallVector<SymbolicOffsetBinding, 4> bindings;
  SmallVector<sym::PredHandle, 2> assumptions;
  sym::PredHandle predicate;
};

enum class SymbolicIndexValueMode { Default, PacketProof, Materialization };

FailureOr<std::optional<SymbolicOffset>> buildSymbolicIndexValue(
    Value value, WaveDialect &dialect, DataFlowSolver &solver,
    SymbolicIndexValueMode mode = SymbolicIndexValueMode::Default);
FailureOr<std::optional<SymbolicPredicate>>
buildSymbolicIndexPredicate(Value value, WaveDialect &dialect,
                            DataFlowSolver &solver);
FailureOr<std::optional<SymbolicPredicate>>
buildSymbolicPacketPredicateRelation(Value value, WaveDialect &dialect,
                                     DataFlowSolver &solver);
FailureOr<std::optional<SymbolicPredicate>>
buildSymbolicMaskPredicate(Value value, WaveDialect &dialect,
                           DataFlowSolver &solver);

/// Analyze a complete in-memory integer packet for a production consumer;
/// unsupported or unproved roots decline.
FailureOr<std::optional<SymbolicOffset>>
buildSymbolicIntegerPacket(Value value, WaveDialect &dialect);

/// Analyze a complete mask packet; unsupported or partial roots decline.
FailureOr<std::optional<SymbolicPredicate>>
buildSymbolicMaskPredicate(Value value, WaveDialect &dialect);

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_SYMBOLICVALUE_H
