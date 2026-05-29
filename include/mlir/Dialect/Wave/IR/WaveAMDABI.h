//===- WaveAMDABI.h - Wave AMD ABI helpers ----------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVEAMDABI_H_
#define MLIR_DIALECT_WAVE_IR_WAVEAMDABI_H_

#include "mlir/IR/TypeRange.h"
#include "mlir/IR/Types.h"
#include "mlir/Support/LLVM.h"

namespace mlir::waveamd {

struct KernargSlot {
  unsigned offset = 0;
  unsigned size = 0;
  bool isGlobalBuffer = false;
};

bool isKernargPointer(Type type);
bool isKernargBufferPointer(Type type);
bool isKernargGlobalBuffer(Type type);

unsigned getKernargRegisterWidth(Type type);
unsigned getKernargByteSize(Type type);
unsigned getKernargByteSizeForRegisterWidth(unsigned width);

bool isValidKernargRegisterWidth(bool pointer, unsigned width);

SmallVector<KernargSlot> getKernargLayout(TypeRange types);
unsigned alignKernargSegmentSize(unsigned byteSize);
unsigned getKernargSegmentSize(TypeRange types);

} // namespace mlir::waveamd

#endif // MLIR_DIALECT_WAVE_IR_WAVEAMDABI_H_
