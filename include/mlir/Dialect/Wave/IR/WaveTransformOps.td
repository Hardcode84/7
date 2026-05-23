//===-- WaveTransformOps.td - Wave transform-dialect ops --*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVETRANSFORMOPS_TD
#define MLIR_DIALECT_WAVE_IR_WAVETRANSFORMOPS_TD

include "mlir/Dialect/Transform/IR/TransformDialect.td"
include "mlir/Dialect/Transform/Interfaces/TransformInterfaces.td"
include "mlir/Dialect/Wave/IR/WaveBase.td"
include "mlir/IR/OpBase.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

// Query op: pull a named `IntegerAttr` off each payload op and yield it
// as a `!transform.param<i64>` element. Definite failure on missing or
// non-integer attribute. Useful for budget gates / score sequences that
// inspect pass-attached metrics like `waveamdmachine.vgpr_count_max`.
def Wave_TransformGetIntAttrOp
    : Op<Wave_Dialect, "transform.get_int_attr", [
        DeclareOpInterfaceMethods<MemoryEffectsOpInterface>,
        DeclareOpInterfaceMethods<TransformOpInterface>]> {
  let summary = "Read an IntegerAttr off the target op as a transform param";
  let description = [{
    For each payload op associated with `$target`, read the
    `IntegerAttr` named `$attr_name` and append its value to the
    result parameter. The result is associated with the resulting
    list of attributes in payload order. Returns a definite failure
    if any target is missing the attribute or holds it under a
    non-integer type.
  }];
  let arguments = (ins TransformHandleTypeInterface:$target,
                       StrAttr:$attr_name);
  let results = (outs TransformParamTypeInterface:$result);
  let assemblyFormat = [{
    $attr_name `from` $target attr-dict
        `:` functional-type($target, $result)
  }];
}

#endif // MLIR_DIALECT_WAVE_IR_WAVETRANSFORMOPS_TD
