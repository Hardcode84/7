//===- WaveTransformOps.cpp - Wave transform-dialect ops --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/Wave.h"

#include "mlir/Dialect/Transform/Interfaces/TransformInterfaces.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "llvm/ADT/SmallVector.h"

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveTransformOps.cpp.inc"

using namespace mlir;

DiagnosedSilenceableFailure
wave::TransformGetIntAttrOp::apply(transform::TransformRewriter &rewriter,
                                   transform::TransformResults &results,
                                   transform::TransformState &state) {
  StringRef key = getAttrName();
  SmallVector<Attribute> values;
  for (Operation *target : state.getPayloadOps(getTarget())) {
    auto attr = target->getAttrOfType<IntegerAttr>(key);
    if (!attr)
      return emitDefiniteFailure()
             << "target op missing IntegerAttr `" << key << "`";
    values.push_back(attr);
  }
  results.setParams(cast<OpResult>(getResult()), values);
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformGetIntAttrOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::producesHandle(getOperation()->getOpResults(), effects);
}
