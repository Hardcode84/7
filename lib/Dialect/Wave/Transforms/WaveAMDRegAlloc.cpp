//===- WaveAMDRegAlloc.cpp - WaveAMD register allocation --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDRegAllocPrep.h"
#include "WaveAMDRegLiveIntervals.h"
#include "WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/MathExtras.h"
#include <optional>
#include <set>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDREGALLOC
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

struct RegisterLimits {
  unsigned numSGPR = 0;
  unsigned numVGPR = 0;
};

static void setRegPhys(Value v, unsigned phys) {
  auto rt = cast<waveamdmachine::RegType>(v.getType());
  v.setType(waveamdmachine::RegType::get(rt.getContext(), rt.getRegClass(),
                                         rt.getWidth(),
                                         static_cast<int64_t>(phys)));
}

static FailureOr<RegisterLimits> getRegisterLimits(ModuleOp module) {
  if (!module->hasAttr("waveamdmachine.target"))
    return module.emitError(
        "waveamd-reg-alloc requires a waveamdmachine.target attribute");
  FailureOr<wave::WaveAMDRegisterLimits> targetLimits =
      wave::getWaveAMDRegisterLimits(module);
  if (failed(targetLimits))
    return failure();

  RegisterLimits limits;
  limits.numSGPR = targetLimits->addressableSGPRs;
  limits.numVGPR = targetLimits->addressableVGPRs;
  return limits;
}

static LogicalResult validateReservedLimit(func::FuncOp func, StringRef cls,
                                           unsigned numPhys,
                                           unsigned reserved) {
  if (numPhys >= reserved)
    return success();
  return func.emitError()
         << "waveamd-reg-alloc " << cls
         << " limit leaves fewer registers than reserved kernel ABI prefix "
         << "(available=" << numPhys << ", reserved=" << reserved << ")";
}

struct WaveAMDRegAllocPass
    : public wave::impl::WaveAMDRegAllocBase<WaveAMDRegAllocPass> {
  using WaveAMDRegAllocBase::WaveAMDRegAllocBase;

  void runOnOperation() override {
    FailureOr<RegisterLimits> limits = getRegisterLimits(getOperation());
    if (failed(limits))
      return signalPassFailure();
    if (vgprLimitOverride >= 0)
      limits->numVGPR =
          std::min(limits->numVGPR, static_cast<unsigned>(vgprLimitOverride));
    if (sgprLimitOverride >= 0)
      limits->numSGPR =
          std::min(limits->numSGPR, static_cast<unsigned>(sgprLimitOverride));
    SmallVector<func::FuncOp> kernels;
    getOperation().walk([&](func::FuncOp f) {
      if (!f.isExternal())
        kernels.push_back(f);
    });
    Builder builder(&getContext());
    int64_t overflowedCount = 0;
    getOperation()->removeAttr(
        wave::getWaveAMDRegAllocOverflowedCountAttrName());
    for (func::FuncOp func : kernels) {
      bool overflow = false;
      func->removeAttr(wave::getWaveAMDRegAllocOverflowedAttrName());
      if (failed(allocateFunction(func, *limits, markOverflow, overflow)))
        return signalPassFailure();
      if (overflow) {
        func->setAttr(wave::getWaveAMDRegAllocOverflowedAttrName(),
                      builder.getI64IntegerAttr(1));
        ++overflowedCount;
        continue;
      }
      if (failed(wave::verifyWaveAMDRegAllocation(
              func, "waveamd-reg-alloc",
              wave::WaveAMDRegAllocVerificationScope::Results)))
        return signalPassFailure();
    }
    if (markOverflow)
      getOperation()->setAttr(wave::getWaveAMDRegAllocOverflowedCountAttrName(),
                              builder.getI64IntegerAttr(overflowedCount));
  }

  LogicalResult allocateFunction(func::FuncOp func, RegisterLimits limits,
                                 bool softFail, bool &overflow) {
    if (failed(wave::prepareWaveAMDRegAllocIR(func)))
      return failure();
    FailureOr<wave::WaveAMDLiveIntervalBuildResult> builtIntervals =
        wave::buildWaveAMDLiveIntervals(func);
    if (failed(builtIntervals))
      return failure();
    wave::WaveAMDLiveIntervalSet &intervals = builtIntervals->intervals;

    unsigned sgprReserved = wave::getWaveAMDReservedSGPRs(func);
    unsigned vgprReserved = wave::getWaveAMDReservedVGPRs(func);
    if (failed(validateReservedLimit(func, "SGPR", limits.numSGPR,
                                     sgprReserved)) ||
        failed(
            validateReservedLimit(func, "VGPR", limits.numVGPR, vgprReserved)))
      return failure();
    if (failed(allocateClass(func, intervals.sgprs, limits.numSGPR,
                             sgprReserved, softFail, overflow)))
      return failure();
    return allocateClass(func, intervals.vgprs, limits.numVGPR, vgprReserved,
                         softFail, overflow);
  }

  // Physically-allocated half-open span `[begin, begin + size)` in a
  // single register class. The class itself is implicit -- each
  // allocator pass walks one class at a time and owns its own set.
  // Sort by `begin` so a `std::set` lets us iterate gaps in order;
  // intervals never overlap, so the begin-only comparison is also a
  // sound equality key when we erase on expiration.
  struct PhysAlloc {
    unsigned begin;
    unsigned size;
    unsigned end() const { return begin + size; }
    bool operator<(const PhysAlloc &o) const { return begin < o.begin; }
  };

  // Release every active interval whose end position is before `pos`,
  // dropping its `PhysAlloc` from `live` so the freed slot rejoins the
  // gap-walking pool. Mirrors the bitmap clear in the previous
  // implementation, just keyed by interval.
  void expireOld(SmallVectorImpl<wave::WaveAMDLiveInterval> &active,
                 std::set<PhysAlloc> &live, unsigned pos) {
    SmallVector<wave::WaveAMDLiveInterval> stillActive;
    for (wave::WaveAMDLiveInterval interval : active) {
      if (interval.end >= pos) {
        stillActive.push_back(interval);
        continue;
      }
      auto rt =
          cast<waveamdmachine::RegType>(interval.values.front().getType());
      live.erase(PhysAlloc{static_cast<unsigned>(rt.getIndex()),
                           static_cast<unsigned>(rt.getWidth())});
    }
    active = std::move(stillActive);
  }

  LogicalResult allocateClass(
      func::FuncOp func, MutableArrayRef<wave::WaveAMDLiveInterval> intervals,
      unsigned numPhys, unsigned reserved, bool softFail, bool &overflow) {
    llvm::stable_sort(intervals, [](const wave::WaveAMDLiveInterval &lhs,
                                    const wave::WaveAMDLiveInterval &rhs) {
      return lhs.start < rhs.start;
    });

    SmallVector<wave::WaveAMDLiveInterval> active;
    // Mirrors aster's `AllocConstraints` (RegisterColoring.cpp:82-258):
    // one `std::set<Allocation>` sorted by `begin` so the allocator
    // can walk gaps in order and pick the first one wide and aligned
    // enough. Reserved registers (kernel preloaded SGPRs, v0 for the
    // packed workitem id) pre-occupy `[0, reserved)`.
    std::set<PhysAlloc> live;
    if (reserved > 0 && reserved <= numPhys)
      live.insert(PhysAlloc{0, reserved});

    for (wave::WaveAMDLiveInterval interval : intervals) {
      if (interval.values.empty())
        continue;
      expireOld(active, live, interval.start);
      unsigned width = interval.type.getWidth();
      // AMDGPU register classes are sized to the next power of two of
      // the tuple width: VReg_96 (3 dwords) sits in a 4-aligned class,
      // VReg_160 (5 dwords) in an 8-aligned class, etc. Pinning the
      // base to `next_power_of_two(width)` keeps the assembler happy
      // for the consumer ops, and matches `width` exactly for the
      // power-of-two widths the pipeline currently produces.
      unsigned align = std::max<unsigned>(1, llvm::PowerOf2Ceil(width));
      std::optional<unsigned> phys = findFreeSlot(live, width, align, numPhys);
      if (!phys) {
        if (softFail) {
          overflow = true;
          return success();
        }
        return func.emitError(
            "WaveAMDMachine register allocator ran out of registers");
      }
      for (auto [v, off] : llvm::zip(interval.values, interval.slotOffsets))
        setRegPhys(v, *phys + off);
      live.insert(PhysAlloc{*phys, width});
      active.push_back(interval);
      llvm::sort(active, [](const wave::WaveAMDLiveInterval &lhs,
                            const wave::WaveAMDLiveInterval &rhs) {
        return lhs.end < rhs.end;
      });
    }
    return success();
  }

  // Walk the gaps between live allocations in `begin` order. For each
  // gap, check whether the requested width fits at `start`; if not,
  // advance `start` to the next `align`-aligned position past the
  // current allocation. After the last allocation, try the tail up to
  // `maxRegs`. Lifted from aster's `AllocConstraints::alloc`
  // (RegisterColoring.cpp:212-258).
  static std::optional<unsigned> findFreeSlot(const std::set<PhysAlloc> &live,
                                              unsigned width, unsigned align,
                                              unsigned maxRegs) {
    auto alignUp = [&](unsigned v) {
      return ((v + align - 1) / align) * align;
    };
    unsigned start = 0;
    for (const PhysAlloc &a : live) {
      if (start + width <= a.begin)
        return start;
      start = alignUp(a.end());
    }
    if (start + width <= maxRegs)
      return start;
    return std::nullopt;
  }
};

} // namespace
