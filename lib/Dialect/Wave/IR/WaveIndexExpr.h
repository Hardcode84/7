//===- WaveIndexExpr.h - Private index-expression utilities -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_LIB_DIALECT_WAVE_IR_WAVEINDEXEXPR_H
#define MLIR_LIB_DIALECT_WAVE_IR_WAVEINDEXEXPR_H

#include "mlir/Dialect/Wave/IR/Wave.h"

namespace mlir::wave {

std::optional<int64_t> getSplatOrConstantInt(Value value);

FailureOr<sym::ExprHandle> composeIndexExprRemainder(sym::Store &store,
                                                     BinaryKind kind,
                                                     sym::ExprHandle dividend,
                                                     sym::ExprHandle divisor);

/// Encode a predicate as the integer expression `predicate ? 1 : 0`.
FailureOr<sym::ExprHandle> composeIndexExprIndicator(sym::Store &store,
                                                     sym::PredHandle predicate);

FailureOr<std::unique_ptr<sym::Analysis>>
createClosedIndexExprAnalysis(sym::Store &store,
                              ArrayRef<sym::PredHandle> assumptions,
                              std::string *diagnostic = nullptr);

void collectIndexExprRequiredSymbols(sym::ExprHandle expr,
                                     ArrayRef<sym::PredHandle> assumptions,
                                     llvm::DenseSet<StringRef> &symbols);

SmallVector<sym::PredHandle>
selectIndexExprAnalysisFacts(ArrayRef<sym::ExprHandle> expressions,
                             ArrayRef<sym::PredHandle> requirements,
                             ArrayRef<sym::PredHandle> facts);

struct IndexExprPiecewiseArm {
  uint32_t caseIndex = 0;
  SmallVector<sym::PredHandle, 8> prefixAssumptions;
  SmallVector<sym::PredHandle, 8> activeAssumptions;
  bool needsCondition = false;
};

FailureOr<SmallVector<IndexExprPiecewiseArm, 4>>
planIndexExprPiecewise(sym::Store &store, sym::ExprHandle expr,
                       ArrayRef<sym::PredHandle> assumptions);

FailureOr<std::optional<uint64_t>>
getIndexExprMaterializationCost(sym::Store &store, sym::ExprHandle expr,
                                ArrayRef<sym::PredHandle> assumptions);

FailureOr<bool> shouldUseSimplifiedIndexExpr(
    sym::Store &store, ArrayRef<sym::PredHandle> assumptions,
    sym::ExprHandle candidate, sym::ExprHandle baseline);

bool isItemLocalRedistribution(RedistributionAttr relation);
bool isIdentityRedistribution(RedistributionAttr relation);

} // namespace mlir::wave

#endif // MLIR_LIB_DIALECT_WAVE_IR_WAVEINDEXEXPR_H
