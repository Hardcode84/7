//===- WaveExtensionNanobind.cpp - Wave python bindings -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Wave-c/Dialects.h"
#include "mlir/Bindings/Python/Nanobind.h"
#include "mlir/Bindings/Python/NanobindAdaptors.h"

namespace nb = nanobind;

NB_MODULE(_waveDialectsNanobind, m) {
  // Single `register_dialects(context, load=True)` entry point that exposes
  // both the user-facing `wave` / `waveamd` dialects and the lower-level
  // `wavemachine` dialect. Callers normally only need the first two, but we
  // wire the third one too so a Python-built module can be round-tripped
  // through the WaveMachine pipeline without re-registering out-of-band.
  m.def(
      "register_dialects",
      [](MlirContext ctx, bool load) {
        MlirDialectHandle wave = mlirGetDialectHandle__wave__();
        MlirDialectHandle waveamd = mlirGetDialectHandle__waveamd__();
        MlirDialectHandle wavemachine = mlirGetDialectHandle__wavemachine__();
        mlirDialectHandleRegisterDialect(wave, ctx);
        mlirDialectHandleRegisterDialect(waveamd, ctx);
        mlirDialectHandleRegisterDialect(wavemachine, ctx);
        if (load) {
          mlirDialectHandleLoadDialect(wave, ctx);
          mlirDialectHandleLoadDialect(waveamd, ctx);
          mlirDialectHandleLoadDialect(wavemachine, ctx);
        }
      },
      nb::arg("context"), nb::arg("load") = true);
}
