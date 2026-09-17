//===- WaveRedistributePlanning.h - packet proof planning ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEREDISTRIBUTEPLANNING_H
#define MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEREDISTRIBUTEPLANNING_H

#include "../IR/WaveIndexMap.h"

#include <cstdint>
#include <optional>
#include <utility>

namespace mlir::wave {

struct PacketPlan {
  sym::ExprHandle sourceItem, sourceWithin, sourceGroup;
  uint64_t sourceWithinMask = 0, resultWithinMask = 0;
  int64_t vectorElements = 1, sourceGroups = 1, resultGroups = 1;
};

struct GroupWindow {
  sym::ExprHandle stage, local;
  int64_t localGroups = 1, stageCount = 1;
};

/// An invertible physical-item permutation within each aligned item tile.
/// Item XORs are upper triangular; the group phase is constant for one group.
struct ScratchPhysicalLayout {
  SmallVector<std::pair<unsigned, unsigned>, 4> itemXors;
  int64_t groupShift = 0, phaseBits = 0, itemShift = 0;
};

int64_t packedToLogicalSlot(uint64_t withinMask, int64_t slots,
                            int64_t packedSlot);
int64_t logicalToPackedSlot(uint64_t withinMask, int64_t slots,
                            int64_t logicalSlot);

FailureOr<PacketPlan> buildPacketPlan(sym::Store &store, RedistributeOp op,
                                      const indexing::IndexMap &carrier,
                                      int64_t maxElements,
                                      std::optional<int64_t> waveWidth,
                                      bool allowResultPermutation);

FailureOr<GroupWindow> buildGroupWindow(sym::Store &store, RedistributeOp op,
                                        const indexing::IndexMap &carrier,
                                        sym::ExprHandle sourceGroup,
                                        int64_t sourceGroups,
                                        int64_t maxLocalGroups);

FailureOr<ScratchPhysicalLayout>
selectScratchPhysicalLayout(sym::Store &store, RedistributeOp op,
                            const indexing::IndexMap &carrier,
                            const PacketPlan &packet, const GroupWindow &window,
                            int64_t waveWidth, int64_t elementBits);

FailureOr<sym::ExprHandle>
composeScratchPhysicalItem(sym::Store &store, sym::ExprHandle item,
                           sym::ExprHandle localGroup,
                           const ScratchPhysicalLayout &layout);

} // namespace mlir::wave

#endif // MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEREDISTRIBUTEPLANNING_H
