//===- WaveAMDMachineWaitcnt.h - wait-counter mapping ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEWAITCNT_H
#define MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEWAITCNT_H

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"

#include <optional>

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineWaitEnums.h.inc"

namespace mlir::waveamdmachine {

struct WaitcntInfo {
  WaitcntEvent event = WaitcntEvent::None;
  unsigned issueCount = 0;
  bool outOfOrder = false;

  bool isIssuer() const { return event != WaitcntEvent::None; }
};

struct WaitcntCounterMapping {
  WaitcntCounter completion = WaitcntCounter::None;
  WaitcntCounter source = WaitcntCounter::None;
};

std::optional<WaitcntCounterMapping>
getWaitcntCounterMapping(WaitcntEvent event, WaitCounterFamily family,
                         bool waitXcnt);

WaitcntCounter getLegacyWaitcntCounter(WaitcntEvent event);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEWAITCNT_H
