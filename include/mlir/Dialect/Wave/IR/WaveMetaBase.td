//===-- WaveMetaBase.td - WaveMeta dialect base ------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVEMETABASE_TD
#define MLIR_DIALECT_WAVE_IR_WAVEMETABASE_TD

include "mlir/IR/DialectBase.td"

def WaveMeta_Dialect : Dialect {
  let name = "wavemeta";
  let cppNamespace = "::mlir::wavemeta";
  let description = [{
    The WaveMeta dialect carries pipeline-parameter and static
    control-flow ops that survive only as long as the
    specialiser pass needs them. `wavemeta.param` reads a
    module-scoped parameter binding; `wavemeta.static_for`,
    `wavemeta.unrolled_for`, and `wavemeta.static_if` get
    expanded / branch-selected once their controlling params
    become constant; the
    parametric-tuple type `!wavemeta.ptuple` lets iter-arg
    width track an unroll factor and collapses to flat SSA
    values after specialisation.

    Pipeline notes: `docs/TransformDialectPipelineStrategy.md`.
  }];
  let hasConstantMaterializer = 1;
  let useDefaultTypePrinterParser = 1;
  let extraClassDeclaration = [{
    void registerTypes();

    /// Module-level dictionary attribute the specialiser reads to
    /// bind `wavemeta.param` ops and to resolve parameter-named
    /// `!wavemeta.ptuple` widths. Keyed by `wavemeta.param` name;
    /// values are typed attributes matching the param's result type.
    static constexpr ::llvm::StringLiteral getParamsAttrName() {
      return "wavemeta.params";
    }
  }];
}

#endif // MLIR_DIALECT_WAVE_IR_WAVEMETABASE_TD
