//===- WaveAMDHardwareResources.h - Singleton resource helpers ---*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef DIALECT_WAVE_TRANSFORMS_WAVEAMDHARDWARERESOURCES_H
#define DIALECT_WAVE_TRANSFORMS_WAVEAMDHARDWARERESOURCES_H

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Operation.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"

#include <cstdint>
#include <optional>

namespace mlir::wave {

enum class HardwareResourceKind : uint8_t { SCC, VCC, EXEC, M0 };

struct HardwareResourceEffects {
  SmallVector<HardwareResourceKind, 4> reads;
  SmallVector<HardwareResourceKind, 4> writes;
};

llvm::StringRef getHardwareResourceName(HardwareResourceKind kind);

std::optional<HardwareResourceKind> getHardwareResourceForValue(Value value);

HardwareResourceEffects getHardwareResourceEffects(Operation *op);

LogicalResult verifyNoHardwareResourceLiveRangeOverlap(func::FuncOp func,
                                                       llvm::StringRef pass);

} // namespace mlir::wave

#endif // DIALECT_WAVE_TRANSFORMS_WAVEAMDHARDWARERESOURCES_H
