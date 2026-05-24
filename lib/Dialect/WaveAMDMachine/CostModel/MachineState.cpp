//===- MachineState.cpp - Per-program-point pressure ----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/MachineState.h"

#include "llvm/ADT/Sequence.h"
#include "llvm/ADT/SmallVector.h"

#include <algorithm>

namespace mlir::waveamdmachine {

bool MachineState::join(const MachineState &rhs) {
  bool changed = false;
  for (size_t i : llvm::seq(fuPending.size())) {
    if (rhs.fuPending[i] > fuPending[i]) {
      fuPending[i] = rhs.fuPending[i];
      changed = true;
    }
  }
  for (const auto &kv : rhs.valPending) {
    auto [it, inserted] = valPending.try_emplace(kv.first, kv.second);
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
  if (fuPending != rhs.fuPending)
    return false;
  if (valPending.size() != rhs.valPending.size())
    return false;
  for (const auto &kv : valPending) {
    auto it = rhs.valPending.find(kv.first);
    if (it == rhs.valPending.end() || it->second != kv.second)
      return false;
  }
  return true;
}

void MachineState::advance(int w) {
  if (w <= 0)
    return;
  for (int &p : fuPending)
    p = std::max(0, p - w);
  llvm::SmallVector<mlir::Value, 8> toErase;
  for (auto &kv : valPending) {
    kv.second -= w;
    if (kv.second <= 0)
      toErase.push_back(kv.first);
  }
  for (mlir::Value v : toErase)
    valPending.erase(v);
}

int MachineState::maxFuPending() const {
  return *std::max_element(fuPending.begin(), fuPending.end());
}

} // namespace mlir::waveamdmachine
