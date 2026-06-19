//===- WaveAMDMachineAddressFields.h - Memory-op slot spec ---------*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEADDRESSFIELDS_H
#define MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEADDRESSFIELDS_H

#include <cstdint>

namespace mlir::waveamdmachine {

enum class SOffsetImmPolicy : uint8_t { AnyImm, ZeroImmOnly };

/// Per-op layout for the V / S / inst-offset address fields.
/// `voffset` is always present on a memory op, so it is not modeled
/// here. `instOffsetBits == 0` means the op has no inst-offset slot.
/// Address planning consults this before emission.
struct AddressFieldSpec {
  unsigned instOffsetBits = 0;
  bool instOffsetSigned = false;
  bool hasSoffset = false;
  SOffsetImmPolicy soffsetImmPolicy = SOffsetImmPolicy::AnyImm;
  unsigned instOffsetHeadroom = 0;
};

/// Closed interval `[lo, hi]` for the spec's inst-offset slot, or
/// `{0, 0}` when the op has no slot (`instOffsetBits == 0`).
inline std::pair<int64_t, int64_t>
instOffsetRange(const AddressFieldSpec &spec) {
  if (spec.instOffsetBits == 0)
    return {0, 0};
  if (spec.instOffsetSigned) {
    int64_t bound = int64_t{1} << (spec.instOffsetBits - 1);
    return {-bound, bound - 1};
  }
  return {0, (int64_t{1} << spec.instOffsetBits) - 1};
}

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEADDRESSFIELDS_H
