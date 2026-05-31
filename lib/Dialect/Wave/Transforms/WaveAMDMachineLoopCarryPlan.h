//===- WaveAMDMachineLoopCarryPlan.h - scf.for carry planning ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINELOOPCARRYPLAN_H
#define MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINELOOPCARRYPLAN_H

#include "WaveAMDMachineSelector.h"

namespace mlir::wave::wmsel {

struct StrideTerm {
  Value value;
  int64_t scale = 1;
};

struct StrideBytes {
  llvm::SmallVector<StrideTerm, 2> terms;
  int64_t imm = 0;
};

struct StridedBaseCarry {
  StrideBytes stride;
  Value base;
  Value bodyBase;
  Value byteStride;
};

struct CarrySnapshot {
  StrideBytes stride;
  std::string bodyOffsetName;
  std::string resultOffsetName;
  std::string strideName;
  std::optional<int64_t> bodyU32Upper;
  std::optional<int64_t> resultU32Upper;
  enum class Kind { WMValue, Pointer };
  Value carry;
  Value base;
  Value globalBase;
  int64_t stridedBaseGroup = -1;
  Kind kind;
  TermKind offsetKind = TermKind::Lane;
  bool isBuffer = false;
};

struct ScfForCarryPlan {
  llvm::SmallVector<CarrySnapshot> snapshots;
  llvm::SmallVector<StridedBaseCarry> stridedBaseGroups;
};

inline bool hasStride(const StrideBytes &stride) {
  return stride.imm != 0 || !stride.terms.empty();
}

inline bool isImmediateStride(const StrideBytes &stride) {
  return stride.terms.empty();
}

LogicalResult planScfForCarries(WaveAMDMachineSelector &S, scf::ForOp op,
                                ScfForCarryPlan &plan);

} // namespace mlir::wave::wmsel

#endif // MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDMACHINELOOPCARRYPLAN_H
