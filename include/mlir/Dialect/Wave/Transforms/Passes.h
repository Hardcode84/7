//===- Passes.h - Wave passes -----------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_PASSES_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_PASSES_H

#include "mlir/Pass/Pass.h"

// The tablegen-generated pass base classes expand each `dependentDialects`
// entry into an inline `registry.insert<X>()` call. Two-phase lookup
// resolves those non-dependent names at template-definition time, so the
// referenced dialect headers must be visible wherever this header is
// included.
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/GPU/IR/GPUDialect.h"
#include "mlir/Dialect/LLVMIR/ROCDLDialect.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/WaveMachine/IR/WaveMachine.h"

namespace mlir {
namespace wave {

#define GEN_PASS_DECL
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"

#define GEN_PASS_REGISTRATION
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_PASSES_H
