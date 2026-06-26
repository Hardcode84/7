//===- WaveAMDRegAllocScratchPlanning.cpp - Scratch spill slots -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocInternal.h"

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "llvm/TargetParser/TargetParser.h"

#include <limits>

using namespace mlir;
using namespace mlir::wave::regalloc;

namespace {

static constexpr llvm::StringLiteral kWavePrivateSegmentFixedSizeAttr =
    "wave.private_segment_fixed_size";

static bool supportsScratchSpillTarget(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 11 || isa.Major == 12 ||
         (isa.Major == 9 && isa.Minor >= 4);
}

static std::optional<unsigned> getUnsignedAttr(Operation *op, StringRef name) {
  IntegerAttr attr = op->getAttrOfType<IntegerAttr>(name);
  if (!attr)
    return std::nullopt;
  int64_t value = attr.getInt();
  if (value < 0 ||
      static_cast<uint64_t>(value) > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  return static_cast<unsigned>(value);
}

static unsigned getPrivateSegmentBytes(func::FuncOp func,
                                       unsigned reservedBytes) {
  if (std::optional<unsigned> fixed =
          getUnsignedAttr(func, kWavePrivateSegmentFixedSizeAttr))
    return *fixed;

  unsigned total =
      getUnsignedAttr(func, kPrivateSegmentFixedSizeAttr).value_or(0);
  if (total >= reservedBytes)
    return total - reservedBytes;
  return 0;
}

static ScratchSpillPlan reject(ScratchSpillPlanStatus status,
                               unsigned existingBytes, unsigned reservedBytes,
                               unsigned valueBytes) {
  ScratchSpillPlan plan;
  plan.status = status;
  plan.existingPrivateBytes = existingBytes;
  plan.reservedSpillBytes = reservedBytes;
  plan.valueBytes = valueBytes;
  return plan;
}

static ScratchSpillPlan available(unsigned existingBytes,
                                  unsigned reservedBytes, unsigned valueBytes) {
  ScratchSpillPlan plan;
  plan.status = ScratchSpillPlanStatus::Available;
  plan.existingPrivateBytes = existingBytes;
  plan.reservedSpillBytes = reservedBytes;
  plan.slotBase = existingBytes + reservedBytes;
  plan.slotBytes = valueBytes;
  plan.valueBytes = valueBytes;
  plan.usesFlatScratch = true;
  return plan;
}

static bool checkedAdd(unsigned lhs, unsigned rhs, unsigned &result) {
  if (std::numeric_limits<unsigned>::max() - lhs < rhs)
    return true;
  result = lhs + rhs;
  return false;
}

static ScratchSpillPlan buildScratchSpillPlan(func::FuncOp func,
                                              unsigned valueBytes,
                                              unsigned reservedSpillBytes,
                                              unsigned existingBytes) {
  if (!func->hasAttr(wave::WaveDialect::getKernelAttrName()))
    return reject(ScratchSpillPlanStatus::NotKernel, existingBytes,
                  reservedSpillBytes, valueBytes);
  if (valueBytes == 0)
    return reject(ScratchSpillPlanStatus::InvalidValueBytes, existingBytes,
                  reservedSpillBytes, valueBytes);

  FailureOr<waveamdmachine::AMDGPUTarget> target =
      waveamdmachine::getAMDGPUTarget(func, "waveamd-reg-alloc scratch "
                                            "planning");
  if (failed(target))
    return reject(ScratchSpillPlanStatus::UnsupportedTarget, existingBytes,
                  reservedSpillBytes, valueBytes);
  if (!supportsScratchSpillTarget(llvm::AMDGPU::getIsaVersion(target->chip)))
    return reject(ScratchSpillPlanStatus::UnsupportedTarget, existingBytes,
                  reservedSpillBytes, valueBytes);

  unsigned usedBytes = 0;
  unsigned nextBytes = 0;
  if (checkedAdd(existingBytes, reservedSpillBytes, usedBytes) ||
      checkedAdd(usedBytes, valueBytes, nextBytes))
    return reject(ScratchSpillPlanStatus::PrivateSegmentOverflow, existingBytes,
                  reservedSpillBytes, valueBytes);
  return available(existingBytes, reservedSpillBytes, valueBytes);
}

} // namespace

StringRef mlir::wave::regalloc::getScratchSpillPlanStatusName(
    ScratchSpillPlanStatus status) {
  switch (status) {
  case ScratchSpillPlanStatus::Available:
    return "available";
  case ScratchSpillPlanStatus::NotKernel:
    return "not_kernel";
  case ScratchSpillPlanStatus::UnsupportedTarget:
    return "unsupported_target";
  case ScratchSpillPlanStatus::InvalidValueBytes:
    return "invalid_value_bytes";
  case ScratchSpillPlanStatus::PrivateSegmentOverflow:
    return "private_segment_overflow";
  }
  llvm_unreachable("unknown scratch spill plan status");
}

unsigned mlir::wave::regalloc::getExistingPrivateSegmentBytes(
    func::FuncOp func, unsigned reservedSpillBytes) {
  return getPrivateSegmentBytes(func, reservedSpillBytes);
}

ScratchSpillPlan mlir::wave::regalloc::planScratchSpillSlot(
    func::FuncOp func, unsigned valueBytes, unsigned reservedSpillBytes) {
  unsigned existingBytes = getPrivateSegmentBytes(func, reservedSpillBytes);
  return buildScratchSpillPlan(func, valueBytes, reservedSpillBytes,
                               existingBytes);
}

ScratchSpillPlan mlir::wave::regalloc::planScratchSpillSlot(
    func::FuncOp func, unsigned valueBytes, unsigned reservedSpillBytes,
    unsigned existingPrivateBytes) {
  return buildScratchSpillPlan(func, valueBytes, reservedSpillBytes,
                               existingPrivateBytes);
}
