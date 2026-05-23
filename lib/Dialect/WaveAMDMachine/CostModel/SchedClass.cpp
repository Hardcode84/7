//===- SchedClass.cpp - Scheduling-class enum -----------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"

#include "llvm/Support/ErrorHandling.h"

#include <array>

namespace mlir::waveamdmachine {

// Indexed by enum value; layout must match the SchedClass enum.
static constexpr std::array<llvm::StringLiteral,
                            static_cast<size_t>(SchedClass::NumSchedClasses)>
    kSchedClassNames = {
        "NoInst",
        "WriteSALU",
        "Write32Bit",
        "Write64Bit",
        "WriteFloatFMA",
        "WriteDouble",
        "WriteTrans32",
        "WriteSFPU",
        "Write2PassMAI",
        "Write4PassMAI",
        "Write8PassMAI",
        "Write16PassMAI",
        "WriteXDL2PassWMMA",
        "WriteXDL4PassWMMA",
        "Write4PassWMMA",
        "Write8PassWMMA",
        "Write16PassWMMA",
        "WriteVMEM",
        "WriteSMEM",
        "WriteLDS",
        "WriteBranch",
        "WriteBarrier",
        "WriteExport",
        "WaitcntPseudo",
};

llvm::StringRef getSchedClassName(SchedClass cls) {
  size_t idx = static_cast<size_t>(cls);
  if (idx >= kSchedClassNames.size())
    llvm_unreachable("invalid SchedClass");
  return kSchedClassNames[idx];
}

} // namespace mlir::waveamdmachine
