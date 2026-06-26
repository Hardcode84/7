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
    same-name entry.

    `$value` is a `!transform.param` whose payload must be exactly one
    attribute. By default the attribute is stored as-is. When the
    optional `as` clause is set, the value must be an `IntegerAttr`
    and is re-typed to `$result_type` (which must be an integer or
    index type); this is the standard escape hatch for autotuning
    loops feeding `!transform.param<i64>` values into kernels whose
    `wavemeta.param` ops carry `index` or narrower integer types.

    Definite failure if the target is not a `builtin.module` op, the
    handle resolves to anything other than one op, the value param
    holds anything other than one attribute, the `as` clause was
    requested but the value is not an `IntegerAttr`, or `$result_type`
    is neither an integer nor an index type.
  }];
  let arguments = (ins TransformHandleTypeInterface:$target,
                       StrAttr:$attr_name,
                       TransformParamTypeInterface:$value,
                       OptionalAttr<TypeAttr>:$result_type);
  let results = (outs);
  let assemblyFormat = [{
    $target $attr_name `=` $value (`as` $result_type^)? attr-dict
        `:` functional-type(operands, results)
  }];
}

def Wave_TransformRegAllocLoopOp
    : Op<Wave_Dialect, "transform.regalloc_loop", [
        DeclareOpInterfaceMethods<MemoryEffectsOpInterface>,
        DeclareOpInterfaceMethods<TransformOpInterface>,
        DeclareOpInterfaceMethods<SymbolUserOpInterface>]> {
  let summary = "Run the WaveAMD regalloc transform-loop body";
  let description = [{
    Invokes `$body` with `$target` as its payload handle and returns the
    yielded payload handle. The body is the allocator iteration sequence:
    alias-state build, linear scan, and pressure-relief transforms.
  }];
  let arguments = (ins TransformHandleTypeInterface:$target,
                       SymbolRefAttr:$body);
  let results = (outs TransformHandleTypeInterface:$result);
  let assemblyFormat = [{
    `from` $target `body` `=` $body attr-dict
        `:` functional-type($target, $result)
  }];
}

def Wave_TransformRegAllocBuildAliasStateOp
    : Op<Wave_Dialect, "transform.regalloc_build_alias_state", [
        DeclareOpInterfaceMethods<MemoryEffectsOpInterface>,
        DeclareOpInterfaceMethods<TransformOpInterface>]> {
  let summary = "Build WaveAMD regalloc alias state";
  let description = [{
    Rebuilds function-level regalloc alias state from current payload IR and
    returns the same payload handle. Later allocator transforms consume the
    state attribute.
  }];
  let arguments = (ins TransformHandleTypeInterface:$target);
  let results = (outs TransformHandleTypeInterface:$result);
  let assemblyFormat = [{
    `from` $target attr-dict `:` functional-type($target, $result)
  }];
}

def Wave_TransformRegAllocLinearScanOp
    : Op<Wave_Dialect, "transform.regalloc_linear_scan", [
        DeclareOpInterfaceMethods<MemoryEffectsOpInterface>,
        DeclareOpInterfaceMethods<TransformOpInterface>]> {
  let summary = "Run WaveAMD regalloc linear scan";
  let description = [{
    Consumes the function-level regalloc alias state, runs deterministic linear
    scan, and writes either a complete assignment map or one failure record back
    into the state attribute. Successful scans apply final physical register
    indices to payload IR. Failed scans leave payload value types unchanged.
  }];
  let arguments = (ins TransformHandleTypeInterface:$target);
  let results = (outs TransformHandleTypeInterface:$result);
  let assemblyFormat = [{
    `from` $target attr-dict `:` functional-type($target, $result)
  }];
}

// Runs dense-dataflow PressureAnalysis on each payload op
// (func.func or builtin.module) and yields totalCycles as a
// `!transform.param<i64>`. The arch is read from the enclosing
// module's `waveamdmachine.target` attribute (set by
// `wave-set-target-attr`). For module targets, the result is the
// sum over contained funcs.
//
// totalCycles is currently a straight-line accumulator -- loop
// bodies walked once. Trip-count multiplication lands separately;
// callers should treat the number as ranking-grade until then.
def Wave_TransformEstimateCyclesOp
    : Op<Wave_Dialect, "transform.estimate_cycles", [
        DeclareOpInterfaceMethods<MemoryEffectsOpInterface>,
        DeclareOpInterfaceMethods<TransformOpInterface>]> {
  let summary = "Single-wave cycle estimate as a transform param";
  let description = [{
    For each payload op associated with `$target`, run the
    PressureAnalysis dataflow and append the resulting totalCycles
    to the output parameter. Target ops must be `func.func` or
    `builtin.module` (for modules, the result is the sum over
    contained funcs). Reads the arch from the enclosing module's
    `waveamdmachine.target` attribute.

    Definite failure if the attribute is missing or names an
    unsupported arch.
  }];
  let arguments = (ins TransformHandleTypeInterface:$target);
  let results = (outs TransformParamTypeInterface:$result);
  let assemblyFormat = [{
    `from` $target attr-dict `:` functional-type($target, $result)
  }];
}

// Attaches a per-FU issue-cycle dictionary to each payload op. Useful
// for scheduler diagnostics. Static walk over
// the op tape -- counts each op as `1` cycle on its FU (per the
// classifier + funit map). Total cycles separately accumulated; see
// `wave.transform.estimate_cycles`.
def Wave_TransformPressureReportOp
    : Op<Wave_Dialect, "transform.pressure_report", [
        DeclareOpInterfaceMethods<MemoryEffectsOpInterface>,
        DeclareOpInterfaceMethods<TransformOpInterface>]> {
  let summary = "Stamp a per-FU issue-cycle dict onto each payload op";
  let description = [{
    For each payload op associated with `$target` (func.func or
    builtin.module), walks contained wave.amd.machine ops and
    counts issue cycles per FunctionalUnit. Stamps the result as
    a DictionaryAttr at `$attr_name` (default
    `wave.pressure_report`). For modules, the dict aggregates over
    all contained funcs.

    Definite failure if the enclosing module's `waveamdmachine.target`
    attribute is missing or names an unsupported arch.
  }];
  let arguments = (ins TransformHandleTypeInterface:$target,
                       DefaultValuedStrAttr<StrAttr, "wave.pressure_report">:$attr_name);
  let results = (outs);
  let assemblyFormat = [{
    `from` $target (`as` $attr_name^)? attr-dict
        `:` functional-type(operands, results)
  }];
}

// Run the ping-pong delay search and return delay plus peak*1000.
def Wave_TransformPingpongScoreOp
    : Op<Wave_Dialect, "transform.pingpong_score", [
        DeclareOpInterfaceMethods<MemoryEffectsOpInterface>,
        DeclareOpInterfaceMethods<TransformOpInterface>]> {
  let summary = "Score the best two-wave ping-pong delay";
  let description = [{
    For each payload op associated with `$target`, runs
    PressureAnalysis, partitions each kernel into FU regions, searches
    candidate two-wave offsets, and returns the selected delay plus the
    predicted peak utilization scaled by 1000.

    Definite failure if the enclosing module's
    `waveamdmachine.target` attribute is missing or names an unsupported
    arch. Currently supports `waves = 2` only.
  }];
  let arguments = (ins TransformHandleTypeInterface:$target,
                       DefaultValuedAttr<I64Attr, "2">:$waves);
  let results = (outs TransformParamTypeInterface:$delay,
                      TransformParamTypeInterface:$peak);
  let assemblyFormat = [{
    `from` $target (`waves` `=` $waves^)? attr-dict
        `:` functional-type($target, results)
  }];
}

// Insert ping-pong sync primitives at auto-detected region
// boundaries. Barrier-insertion-only: partitions each kernel func
// (RegionProfile sliding-window detector) and drops an s_barrier
// between adjacent FU-regions, plus an s_setprio at func entry.
// Phase/role partitioning (body cloning, wave_id predication) is a
// later transform. gfx<=11 path -- s_barrier only.
def Wave_TransformInsertPingpongBarriersOp
    : Op<Wave_Dialect, "transform.insert_pingpong_barriers", [
        DeclareOpInterfaceMethods<MemoryEffectsOpInterface>,
        DeclareOpInterfaceMethods<TransformOpInterface>]> {
  let summary = "Insert s_barrier / s_setprio at region boundaries";
  let description = [{
    For each func.func payload op, partition the body into per-FU
    regions and emit a waveamdmachine.s_barrier before every region
    after the first. `prio` (default 3) sets an s_setprio at func
    entry. Reads arch from the enclosing module `waveamdmachine.target`.
    Definite failure if arch missing/unsupported. gfx<=11 only.
  }];
  let arguments = (ins TransformHandleTypeInterface:$target,
                       DefaultValuedAttr<I64Attr, "3">:$prio);
  let results = (outs);
  let assemblyFormat = [{
    `from` $target attr-dict `:` functional-type(operands, results)
  }];
}

#endif // MLIR_DIALECT_WAVE_IR_WAVETRANSFORMOPS_TD
