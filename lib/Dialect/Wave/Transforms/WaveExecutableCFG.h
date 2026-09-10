//===- WaveExecutableCFG.h - Executable CFG seeding ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef WAVE_LIB_DIALECT_WAVE_TRANSFORMS_WAVEEXECUTABLECFG_H
#define WAVE_LIB_DIALECT_WAVE_TRANSFORMS_WAVEEXECUTABLECFG_H

#include "mlir/IR/Operation.h"

namespace mlir::wave {

// Solver needs every block and CFG edge marked live to make progress.
template <typename MarkBlock, typename MarkEdge>
static inline void seedExecutableCFG(Operation *top, MarkBlock &&markBlock,
                                     MarkEdge &&markEdge) {
  auto markRegions = [&](Operation *op) {
    for (Region &region : op->getRegions()) {
      for (Block &block : region) {
        markBlock(&block);
        Operation *term = block.getTerminator();
        if (!term)
          continue;
        for (Block *successor : term->getSuccessors())
          markEdge(&block, successor);
      }
    }
  };
  markRegions(top);
  top->walk(markRegions);
}

} // namespace mlir::wave

#endif // WAVE_LIB_DIALECT_WAVE_TRANSFORMS_WAVEEXECUTABLECFG_H
