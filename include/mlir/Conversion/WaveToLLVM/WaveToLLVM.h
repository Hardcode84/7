//===- WaveToLLVM.h - Wave to LLVM conversion -------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Type-conversion-only bridge: maps `!wave.ptr<T, #wave.{global,shared,private}>`
// onto `!llvm.ptr<addrspace>` so host code can hold and forward Wave pointers
// (kernel ABI handles) through the standard convert-to-llvm pipeline. The
// device-side wave ops (wave.store, wave.ptr_add, ...) are never LLVM-lowered;
// they are consumed by wave-translate on the kernel side.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_CONVERSION_WAVETOLLVM_WAVETOLLVM_H
#define MLIR_CONVERSION_WAVETOLLVM_WAVETOLLVM_H

namespace mlir {
class DialectRegistry;
class LLVMTypeConverter;

namespace wave {

/// Add the `!wave.ptr<T, #space>` -> `!llvm.ptr<addrspace>` conversion to
/// `converter`. Idempotent; safe to call from multiple lowering entry points.
void populateWaveToLLVMTypeConversions(LLVMTypeConverter &converter);

/// Attach the Wave -> LLVM `ConvertToLLVMPatternInterface` to `WaveDialect`
/// in `registry`. Once registered, the generic `convert-to-llvm` pipeline
/// (and any pass that walks `ConvertToLLVMPatternInterface`s) will pick up
/// the Wave pointer type conversion automatically.
void registerConvertWaveToLLVMInterface(DialectRegistry &registry);

} // namespace wave
} // namespace mlir

#endif // MLIR_CONVERSION_WAVETOLLVM_WAVETOLLVM_H
