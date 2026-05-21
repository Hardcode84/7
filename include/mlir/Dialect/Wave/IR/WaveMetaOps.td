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
include "mlir/IR/BuiltinAttributeInterfaces.td"
include "mlir/IR/OpBase.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

class WaveMeta_Op<string mnemonic, list<Trait> traits = []> :
    Op<WaveMeta_Dialect, mnemonic, traits>;

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

#endif // MLIR_DIALECT_WAVE_IR_WAVEMETAOPS_TD
