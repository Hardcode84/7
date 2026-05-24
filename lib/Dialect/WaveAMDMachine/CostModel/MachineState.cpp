//===- MachineState.cpp - Per-program-point pressure ----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/MachineState.h"

#include "llvm/ADT/Sequence.h"

#include <algorithm>

namespace mlir::waveamdmachine {

bool MachineState::join(const MachineState &rhs) {
  bool changed = false;
  for (size_t i : llvm::seq(fuReadyAt.size())) {
    if (rhs.fuReadyAt[i] > fuReadyAt[i]) {
      fuReadyAt[i] = rhs.fuReadyAt[i];
      changed = true;
    }
  }
  for (const auto &kv : rhs.readyAt) {
    auto [it, inserted] = readyAt.try_emplace(kv.first, kv.second);
    if (inserted) {
      changed = true;
    } else if (kv.second > it->second) {
      it->second = kv.second;
      changed = true;
    }
  }
  return changed;
}

bool MachineState::operator==(const MachineState &rhs) const {
  if (fuReadyAt != rhs.fuReadyAt)
    return false;
  if (readyAt.size() != rhs.readyAt.size())
    return false;
  for (const auto &kv : readyAt) {
    auto it = rhs.readyAt.find(kv.first);
    if (it == rhs.readyAt.end() || it->second != kv.second)
      return false;
  }
  return true;
}

int64_t MachineState::maxFuCycle() const {
  return *std::max_element(fuReadyAt.begin(), fuReadyAt.end());
}

} // namespace mlir::waveamdmachine
