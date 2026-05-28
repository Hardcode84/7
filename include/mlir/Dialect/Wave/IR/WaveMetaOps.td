//===-- WaveMetaOps.td - WaveMeta dialect ops --------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVEMETAOPS_TD
#define MLIR_DIALECT_WAVE_IR_WAVEMETAOPS_TD

include "mlir/Dialect/Wave/IR/WaveMetaBase.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/BuiltinAttributeInterfaces.td"
include "mlir/IR/OpBase.td"
include "mlir/IR/RegionKindInterface.td"
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

class WaveMeta_Op<string mnemonic, list<Trait> traits = []> :
    Op<WaveMeta_Dialect, mnemonic, traits>;

// `!wavemeta.ptuple<T, W>` carries N elements of type T. The width
// W is either a `StringAttr` naming a parameter (resolved by the
// specialiser) or an `IntegerAttr` of concrete N. Once the
// specialiser binds the parameter, the width becomes concrete and
// the tuple's `tuple_get` / `tuple_set` chain typically collapses
// via the folder.
def WaveMeta_PTupleType : TypeDef<WaveMeta_Dialect, "PTuple"> {
  let mnemonic = "ptuple";
  let summary = "Tuple with parameter-driven width";
  let parameters = (ins "::mlir::Type":$elementType,
                        "::mlir::Attribute":$width);
  let assemblyFormat = "`<` $elementType `,` $width `>`";
  let genVerifyDecl = 1;
}

// A typed value backed by a pipeline parameter. While `$value` is
// absent the op behaves as an opaque SSA value of its declared
// result type; a binding pass attaches `$value` once the parameter
// is resolved, the folder then returns the attribute, and the
// canonicaliser rematerialises it as `arith.constant` via the
// dialect's materializer.
//
// `ConstantLike` is intentionally NOT applied: the trait requires
// the folder to always succeed, and an unbound param does not have
// a value to fold to. `Pure` is enough to get CSE / DCE / hoisting
// on bound and unbound params alike.
def WaveMeta_ParamOp : WaveMeta_Op<"param", [Pure]> {
  let summary = "named pipeline parameter, optionally bound to a value";
  let description = [{
    Materialise a typed SSA value for the parameter named `$name`.
    `$value` is optional; when present its type must match the
    op's result type (verified locally). The standard binding
    pipeline is: write `wavemeta.param "name" : T` in the source,
    let the specialiser attach `$value` once `name` resolves, and
    let canonicalisation fold the op away.
  }];
  let arguments = (ins StrAttr:$name, OptionalAttr<TypedAttrInterface>:$value);
  let results = (outs AnyTypeOf<[Index, AnySignlessInteger]>:$result);
  let assemblyFormat = "$name attr-dict `:` type($result)";
  let hasFolder = 1;
  let hasVerifier = 1;
}

// Terminator for wavemeta structured regions.
// `Pure` because it just forwards SSA values along a region edge;
// the RegionBranchTerminatorOpInterface lets dataflow track those
// forwarded values into the body block args (loop back-edge) or
// the parent op's results (loop exit / if-merge).
def WaveMeta_YieldOp : WaveMeta_Op<"yield", [
    Pure,
    ReturnLike,
    Terminator,
    ParentOneOf<["::mlir::wavemeta::StaticForOp",
                 "::mlir::wavemeta::UnrolledForOp",
                 "::mlir::wavemeta::StaticIfOp"]>,
    DeclareOpInterfaceMethods<RegionBranchTerminatorOpInterface,
        ["getMutableSuccessorOperands"]>
]> {
  let summary = "yield values from a wavemeta region";
  let arguments = (ins Variadic<AnyType>:$values);
  let assemblyFormat = "($values^ `:` type($values))? attr-dict";
}

// Loop with statically-known bounds. Same body shape as `scf.for`:
// region has one block whose first argument is the induction var
// and the remainder mirror `$iter_args`. The intent is for the
// WaveMeta specialiser to fully unroll the loop once the bounds
// (and any param-driven iter_args) become concrete; the op is
// `RegionBranchOpInterface` so generic dataflow passes still see
// the loop while it exists.
def WaveMeta_StaticForOp : WaveMeta_Op<"static_for", [
    DeclareOpInterfaceMethods<RegionBranchOpInterface,
        ["getEntrySuccessorOperands", "getSuccessorInputs"]>,
    RecursiveMemoryEffects,
    AllTypesMatch<["iter_args", "results"]>
]> {
  let summary = "structured for-loop with statically-known bounds";
  let description = [{
    Iterates the body region from `$lower_bound` to `$upper_bound`
    (exclusive) in increments of `$step`. The body's entry block
    has `1 + N` arguments: the induction value (`index`) followed
    by the carries that mirror `$iter_args`. The terminator
    `wavemeta.yield` forwards new carry values either back to the
    body (next iteration) or to the op results (loop exit).

    Bounds and step are SSA `index` values. The static-for is
    fully unrolled by the WaveMeta specialiser once the bounds are
    concrete; until then the op survives as ordinary CFG.
  }];
  let arguments = (ins Index:$lower_bound, Index:$upper_bound, Index:$step,
                       Variadic<AnyType>:$iter_args);
  let results = (outs Variadic<AnyType>:$results);
  let regions = (region SizedRegion<1>:$body);
  let assemblyFormat = [{
    $lower_bound `to` $upper_bound `step` $step
    (`iter_args` `(` $iter_args^ `:` type($iter_args) `)`)?
    $body attr-dict (`->` type($results)^)?
  }];
  let hasVerifier = 1;
}

// Runtime loop whose body is expanded into unrolled full chunks plus a
// scalar tail during WaveMeta specialisation.
def WaveMeta_UnrolledForOp : WaveMeta_Op<"unrolled_for", [
    DeclareOpInterfaceMethods<RegionBranchOpInterface,
        ["getEntrySuccessorOperands", "getSuccessorInputs"]>,
    RecursiveMemoryEffects,
    AllTypesMatch<["iter_args", "results"]>
]> {
  let summary = "structured for-loop with a parameterized unroll factor";
  let description = [{
    Carries the same body contract as `scf.for`: body block argument 0 is
    the induction value and the remaining arguments mirror `$iter_args`.
    The WaveMeta specialiser lowers this op to a full-chunk `scf.for`
    containing `wavemeta.static_for`, followed by a scalar tail `scf.for`.
  }];
  let arguments = (ins Index:$lower_bound, Index:$upper_bound, Index:$step,
                       Index:$unroll, Variadic<AnyType>:$iter_args);
  let results = (outs Variadic<AnyType>:$results);
  let regions = (region SizedRegion<1>:$body);
  let assemblyFormat = [{
    $lower_bound `to` $upper_bound `step` $step `unroll` $unroll
    (`iter_args` `(` $iter_args^ `:` type($iter_args) `)`)?
    $body attr-dict (`->` type($results)^)?
  }];
  let hasVerifier = 1;
}

// Compile-time branch on an `i1` condition. After specialisation
// the chosen region's contents are inlined in place of the op.
def WaveMeta_StaticIfOp : WaveMeta_Op<"static_if", [
    DeclareOpInterfaceMethods<RegionBranchOpInterface,
        ["getSuccessorInputs", "getRegionInvocationBounds"]>,
    RecursiveMemoryEffects,
    NoRegionArguments
]> {
  let summary = "structured if/else with no run-time branch";
  let description = [{
    Selects between the `then` and `else` regions based on
    `$condition`. Both regions yield values via `wavemeta.yield`;
    the operand types of the yield must equal `$results`. The
    `else` region is required iff `$results` is non-empty.

    The WaveMeta specialiser replaces the op with the chosen
    region's contents once `$condition` is a constant; until then
    the op survives as ordinary CFG.
  }];
  let arguments = (ins I1:$condition);
  let results = (outs Variadic<AnyType>:$results);
  let regions = (region SizedRegion<1>:$thenRegion,
                        AnyRegion:$elseRegion);
  let assemblyFormat = [{
    $condition (`->` `(` type($results)^ `)`)?
    $thenRegion (`else` $elseRegion^)? attr-dict
  }];
  let hasVerifier = 1;
}

//===----------------------------------------------------------------------===//
// Parametric tuple ops
//===----------------------------------------------------------------------===//

// Construct a parametric tuple by broadcasting one value to every
// slot. The result type's width (either parameter-named or concrete)
// is supplied by the user; the verifier just enforces that the
// init's type matches the result's element type.
def WaveMeta_TupleMakeBroadcastOp
    : WaveMeta_Op<"tuple_make_broadcast", [Pure]> {
  let summary = "Construct a parametric tuple by broadcasting one value";
  let arguments = (ins AnyType:$init);
  let results = (outs WaveMeta_PTupleType:$result);
  let assemblyFormat = "$init attr-dict `:` type($init) `->` type($result)";
  let hasVerifier = 1;
}

// Construct a parametric tuple from N explicit elements. The
// result's width MUST be concrete (`IntegerAttr`); a parameter-named
// width here would be a malformed op (no way to know how many
// operands to expect).
def WaveMeta_TupleMakeOp
    : WaveMeta_Op<"tuple_make", [Pure, SameTypeOperands]> {
  let summary = "Construct a parametric tuple from explicit elements";
  let arguments = (ins Variadic<AnyType>:$elements);
  let results = (outs WaveMeta_PTupleType:$result);
  let assemblyFormat = "$elements attr-dict `:` functional-type(operands, results)";
  let hasVerifier = 1;
}

// Read the element at `$index` from a parametric tuple. `$index`
// is an `index`-typed SSA value that must resolve to a constant
// after specialisation. The result type equals the tuple's
// element type.
def WaveMeta_TupleGetOp : WaveMeta_Op<"tuple_get", [Pure]> {
  let summary = "Read the element at a static index";
  let arguments = (ins WaveMeta_PTupleType:$tuple, Index:$index);
  let results = (outs AnyType:$result);
  let assemblyFormat = [{
    $tuple `[` $index `]` attr-dict `:` type($tuple) `->` type($result)
  }];
  let hasVerifier = 1;
  let hasFolder = 1;
}

// Functional update: produce a new tuple with `$value` substituted
// at `$index`. Same restrictions on `$index` as `tuple_get`.
def WaveMeta_TupleSetOp
    : WaveMeta_Op<"tuple_set",
                  [Pure, AllTypesMatch<["tuple", "result"]>]> {
  let summary = "Functional update of a parametric tuple at a static index";
  let arguments = (ins
    WaveMeta_PTupleType:$tuple,
    Index:$index,
    AnyType:$value
  );
  let results = (outs WaveMeta_PTupleType:$result);
  let assemblyFormat = [{
    $tuple `[` $index `]` `,` $value attr-dict
    `:` type($tuple) `,` type($value)
  }];
  let hasVerifier = 1;
}

#endif // MLIR_DIALECT_WAVE_IR_WAVEMETAOPS_TD
