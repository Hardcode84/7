//===- WaveSymbolicTransformTiming.h - Symbolic pass timing ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef WAVE_LIB_DIALECT_WAVE_TRANSFORMS_WAVESYMBOLICTRANSFORMTIMING_H
#define WAVE_LIB_DIALECT_WAVE_TRANSFORMS_WAVESYMBOLICTRANSFORMTIMING_H

#include "mlir/Support/Timing.h"

namespace mlir::wave {

namespace detail {
struct SymbolicTransformTimingManager {
  SymbolicTransformTimingManager() {
    applyDefaultTimingManagerCLOptions(manager);
  }

  DefaultTimingManager manager;
};
} // namespace detail

inline DefaultTimingManager &getSymbolicTransformTimingManager() {
  static detail::SymbolicTransformTimingManager timing;
  return timing.manager;
}

class SymbolicTransformTiming {
public:
  explicit SymbolicTransformTiming(StringRef passName) {
    rootScope = getSymbolicTransformTimingManager().getRootScope();
    symbolicScope = rootScope.nest("wave_symbolic_transform_stages");
    passScope = symbolicScope.nest(passName);
  }

  TimingScope nest(StringRef stageName) { return passScope.nest(stageName); }

private:
  TimingScope rootScope;
  TimingScope symbolicScope;
  TimingScope passScope;
};

} // namespace mlir::wave

#endif // WAVE_LIB_DIALECT_WAVE_TRANSFORMS_WAVESYMBOLICTRANSFORMTIMING_H
