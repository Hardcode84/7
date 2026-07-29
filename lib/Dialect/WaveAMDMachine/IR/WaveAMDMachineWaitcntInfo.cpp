//===- WaveAMDMachineWaitcntInfo.cpp - wait-counter mapping ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineWaitcnt.h"

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringExtras.h"

using namespace mlir::waveamdmachine;

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineWaitEnums.cpp.inc"

namespace {

struct CounterMappingRule {
  WaitcntEvent event;
  WaitcntCounter completion;
  bool usesXSource;
};

static constexpr CounterMappingRule legacyRules[] = {
    {WaitcntEvent::Vmem, WaitcntCounter::Vmem, false},
    {WaitcntEvent::Flat, WaitcntCounter::Vmem, false},
    {WaitcntEvent::VmemStore, WaitcntCounter::Vscnt, false},
    {WaitcntEvent::ScratchStore, WaitcntCounter::Vscnt, false},
    {WaitcntEvent::Lds, WaitcntCounter::Lgkm, false},
    {WaitcntEvent::Smem, WaitcntCounter::Lgkm, false},
    {WaitcntEvent::Gds, WaitcntCounter::Lgkm, false},
    {WaitcntEvent::Message, WaitcntCounter::Lgkm, false},
};

static constexpr CounterMappingRule splitRules[] = {
    {WaitcntEvent::Vmem, WaitcntCounter::Load, true},
    {WaitcntEvent::VmemStore, WaitcntCounter::Store, true},
    {WaitcntEvent::ScratchStore, WaitcntCounter::Store, true},
    {WaitcntEvent::Lds, WaitcntCounter::Ds, false},
    {WaitcntEvent::Smem, WaitcntCounter::Km, true},
    {WaitcntEvent::Message, WaitcntCounter::Km, false},
    {WaitcntEvent::SccWrite, WaitcntCounter::Km, false},
    {WaitcntEvent::Async, WaitcntCounter::Async, false},
    {WaitcntEvent::Tensor, WaitcntCounter::Tensor, false},
};

static std::optional<WaitcntCounterMapping>
findCounterMapping(WaitcntEvent event, llvm::ArrayRef<CounterMappingRule> rules,
                   bool waitXcnt) {
  for (const CounterMappingRule &rule : rules) {
    if (rule.event != event)
      continue;
    WaitcntCounter source = WaitcntCounter::None;
    if (waitXcnt && rule.usesXSource)
      source = WaitcntCounter::X;
    return WaitcntCounterMapping{rule.completion, source};
  }
  return std::nullopt;
}

} // namespace

std::optional<WaitcntCounterMapping>
mlir::waveamdmachine::getWaitcntCounterMapping(WaitcntEvent event,
                                               WaitCounterFamily family,
                                               bool waitXcnt) {
  if (event == WaitcntEvent::None)
    return WaitcntCounterMapping{};

  if (family == WaitCounterFamily::Legacy)
    return findCounterMapping(event, legacyRules, /*waitXcnt=*/false);
  return findCounterMapping(event, splitRules, waitXcnt);
}

WaitcntCounter
mlir::waveamdmachine::getLegacyWaitcntCounter(WaitcntEvent event) {
  std::optional<WaitcntCounterMapping> mapping =
      getWaitcntCounterMapping(event, WaitCounterFamily::Legacy,
                               /*waitXcnt=*/false);
  return mapping ? mapping->completion : WaitcntCounter::None;
}
