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
class CalibrationData;

enum class MemoryCounterKind : uint8_t {
  None,
  Vmem,
  Lgkm,
  Vscnt,
};

enum class MemoryIssueKind : uint8_t {
  None,
  VmemLoad,
  VmemStore,
  VmemLoadLds,
  Lds,
  Smem,
};

struct MemoryCounterLatencies {
  int vmemLoad = -1;
  int vmemStore = -1;
  int smemLoad = -1;
  int lds = -1;
};

struct MemoryValueLatencies {
  int vmemLoad = -1;
  int smemLoad = -1;
  int lds = -1;
};

MemoryCounterKind getMemoryCounterKind(Operation *op);

MemoryIssueKind getMemoryIssueKind(Operation *op);

bool isLdsDmaIssuer(Operation *op);

int getMemoryCounterLatency(const ArchData &arch, Operation *op,
                            const MemoryCounterLatencies &overrides = {},
                            const CalibrationData *calibration = nullptr);

bool hasMemoryValueLatency(Operation *op);

int getMemoryValueLatency(const ArchData &arch, Operation *op,
                          const MemoryValueLatencies &overrides = {},
                          const CalibrationData *calibration = nullptr);

int getMemoryValueLatency(const ArchData &arch, Operation *op,
                          const MemoryCounterLatencies &counterOverrides,
                          const MemoryValueLatencies &valueOverrides,
                          const CalibrationData *calibration = nullptr);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MEMORYCOUNTERTIMING_H
