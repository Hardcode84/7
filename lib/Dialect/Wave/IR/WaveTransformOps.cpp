//===- WaveTransformOps.cpp - Wave transform-dialect ops --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/Wave.h"

#include "mlir/Dialect/Transform/Interfaces/TransformInterfaces.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/STLExtras.h"
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

DiagnosedSilenceableFailure
wave::TransformBindParamOp::apply(transform::TransformRewriter &rewriter,
                                  transform::TransformResults &results,
                                  transform::TransformState &state) {
  auto targets = state.getPayloadOps(getTarget());
  if (llvm::range_size(targets) != 1)
    return emitDefiniteFailure() << "expected exactly one target op, got "
                                 << llvm::range_size(targets);
  Operation *target = *targets.begin();
  auto mod = dyn_cast<ModuleOp>(target);
  if (!mod)
    return emitDefiniteFailure() << "target must be a `builtin.module` op";

  ArrayRef<Attribute> values = state.getParams(getValue());
  if (values.size() != 1)
    return emitDefiniteFailure()
           << "expected the value param to hold one attribute, got "
           << values.size();

  Builder builder(mod.getContext());
  StringAttr paramsName = builder.getStringAttr("wavemeta.params");
  StringAttr keyAttr = builder.getStringAttr(getAttrName());
  SmallVector<NamedAttribute> entries;
  if (auto existing = mod->getAttrOfType<DictionaryAttr>(paramsName)) {
    for (NamedAttribute na : existing) {
      if (na.getName() != keyAttr)
        entries.push_back(na);
    }
  }
  entries.emplace_back(keyAttr, values.front());
  mod->setAttr(paramsName, builder.getDictionaryAttr(entries));
  return DiagnosedSilenceableFailure::success();
}

void wave::TransformBindParamOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  transform::onlyReadsHandle(getTargetMutable(), effects);
  transform::onlyReadsHandle(getValueMutable(), effects);
  transform::modifiesPayload(effects);
}
