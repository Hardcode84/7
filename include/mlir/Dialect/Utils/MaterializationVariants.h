//===- MaterializationVariants.h - Choice canonicalization -------*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_UTILS_MATERIALIZATIONVARIANTS_H
#define MLIR_DIALECT_UTILS_MATERIALIZATIONVARIANTS_H

#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"

namespace mlir {
template <typename VariantsOp>
struct FlattenMaterializationVariants : OpRewritePattern<VariantsOp> {
  using OpRewritePattern<VariantsOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(VariantsOp op,
                                PatternRewriter &rewriter) const override {
    SmallVector<Value> worklist =
        llvm::to_vector(llvm::reverse(op.getChoices()));
    SmallVector<Value> choices;
    llvm::SmallDenseSet<Value, 8> seen;
    bool changed = false;
    while (!worklist.empty()) {
      Value value = worklist.pop_back_val();
      // Visit shared subgraphs once; retain first-seen leaf order.
      if (!seen.insert(value).second) {
        changed = true;
        continue;
      }
      if (auto nested = value.getDefiningOp<VariantsOp>()) {
        llvm::append_range(worklist, llvm::reverse(nested.getChoices()));
        changed = true;
      } else
        choices.push_back(value);
    }
    if (!changed)
      return failure();
    rewriter.modifyOpInPlace(op,
                             [&]() { op.getChoicesMutable().assign(choices); });
    return success();
  }
};
} // namespace mlir

#endif
