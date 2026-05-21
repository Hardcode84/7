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
    module-scoped parameter binding; `wavemeta.static_for` and
    `wavemeta.static_if` get fully unrolled / branch-selected
    once their bounds / conditions become constant. The
    specialiser then leaves no `wavemeta.*` ops behind.

    Design notes: `docs/StaticControlFlowOpsDesign.md`.
  }];
  let hasConstantMaterializer = 1;
}

#endif // MLIR_DIALECT_WAVE_IR_WAVEMETABASE_TD
