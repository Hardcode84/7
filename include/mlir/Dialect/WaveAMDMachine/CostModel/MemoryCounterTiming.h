//===- MemoryCounterTiming.h - Waitcnt counter timing ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MEMORYCOUNTERTIMING_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MEMORYCOUNTERTIMING_H

#include <cstdint>

namespace mlir {
class Operation;
} // namespace mlir

namespace mlir::waveamdmachine {

struct ArchData;

enum class MemoryCounterKind : uint8_t {
  None,
  Vmem,
  Lgkm,
  Vscnt,
};

struct MemoryCounterLatencies {
  int vmemLoad = -1;
  int vmemStore = -1;
  int smemLoad = -1;
  int lds = -1;
};

MemoryCounterKind getMemoryCounterKind(Operation *op);

int getMemoryCounterLatency(const ArchData &arch, Operation *op,
                            const MemoryCounterLatencies &overrides = {});

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MEMORYCOUNTERTIMING_H
