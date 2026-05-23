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
include "mlir/IR/SymbolInterfaces.td"
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

// Autotune op. Enumerates the Cartesian product of named tune-var
// domains, invokes an optional feasibility filter, runs the body
// sequence on a cloned payload module per surviving trial, scores
// the result, and replaces the original payload with the winning
// clone (max score, lower enumeration index breaks ties).
def Wave_TransformTuneOp : Op<Wave_Dialect, "transform.tune", [
    DeclareOpInterfaceMethods<MemoryEffectsOpInterface>,
    DeclareOpInterfaceMethods<TransformOpInterface>,
    DeclareOpInterfaceMethods<SymbolUserOpInterface>]> {
  let summary = "Run a compilation sequence over a bounded search space";
  let description = [{
    Enumerates `$variables` in deterministic lex order (variable order
    is the dictionary's key order; per-variable values are explored in
    domain order). For each config:

      * If `$assumes` is set, invokes that named sequence with the
        config's i64 values bound to the trailing `!transform.param<i64>`
        arguments. Silenceable failure -> skip this config without
        running the body. Definite failure -> propagate.
      * Otherwise: clones the payload, invokes `$body` on the clone
        with the config values, then `$score` on the same clone.
        Records the score.

    Picks the trial with the highest score; on tie, the lower
    enumeration index wins. Replaces the original payload with the
    winning clone via the standard transform-state machinery.

    Definite failures: no config is feasible (all skipped by
    `$assumes`); every trial silenceably failed; `$body` or `$score`
    returned definite failure.
  }];
  let arguments = (ins TransformHandleTypeInterface:$target,
                       SymbolRefAttr:$body,
                       SymbolRefAttr:$score,
                       OptionalAttr<SymbolRefAttr>:$assumes,
                       DictionaryAttr:$variables);
  let results = (outs TransformHandleTypeInterface:$winner,
                      TransformParamTypeInterface:$best_score);
  let assemblyFormat = [{
    $target `body` `=` $body `score` `=` $score
        (`assumes` `=` $assumes^)? attr-dict
        `:` functional-type(operands, results)
  }];
}

// Write op: patch one entry of the target module's `wavemeta.params`
// dictionary attribute. Tune sequences use this to push per-trial
// variable bindings into a cloned module before invoking the
// specialiser.
def Wave_TransformBindParamOp
    : Op<Wave_Dialect, "transform.bind_param", [
        DeclareOpInterfaceMethods<MemoryEffectsOpInterface>,
        DeclareOpInterfaceMethods<TransformOpInterface>]> {
  let summary = "Patch one entry of the target module's wavemeta.params dict";
  let description = [{
    Sets `wavemeta.params[$attr_name] = $value` on the target builtin
    module, creating the dict if absent and replacing any pre-existing
    same-name entry. Definite failure if the target is not a
    `builtin.module` op, the handle resolves to anything other than
    one op, or the value param holds anything other than one
    attribute.
  }];
  let arguments = (ins TransformHandleTypeInterface:$target,
                       StrAttr:$attr_name,
                       TransformParamTypeInterface:$value);
  let results = (outs);
  let assemblyFormat = [{
    $target $attr_name `=` $value attr-dict
        `:` functional-type(operands, results)
  }];
}

#endif // MLIR_DIALECT_WAVE_IR_WAVETRANSFORMOPS_TD
