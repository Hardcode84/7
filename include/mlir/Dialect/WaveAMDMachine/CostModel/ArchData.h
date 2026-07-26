//===- ArchData.h - Per-arch structural parameters --------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Static per-arch parameters consumed by the wave.amd.machine cost
// model: wave/SIMD counts, register-file dimensions, VALU pipeline
// depth, issue cadence. Inputs to the cycle estimator + scheduler.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_ARCHDATA_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_ARCHDATA_H

#include "llvm/ADT/StringRef.h"
#include "llvm/TargetParser/AMDGPUTargetParser.h"

#include <cstdint>

namespace mlir::waveamdmachine {

enum class WaveIssueArbitration : uint8_t { RoundRobin };

inline bool isaEq(const llvm::AMDGPU::IsaVersion &lhs,
                  const llvm::AMDGPU::IsaVersion &rhs) {
  return lhs.Major == rhs.Major && lhs.Minor == rhs.Minor &&
         lhs.Stepping == rhs.Stepping;
}

// Structural parameters of one AMDGPU compute-unit + SIMD pipeline.
// One instance per supported gfx target. All counts are integers;
// fields use the same wave size as the arch's native mode (wave32
// on RDNA, wave64 on CDNA) unless noted.
struct ArchData {
  // Canonical IsaVersion. Drives lookup and equality.
  llvm::AMDGPU::IsaVersion isa;

  // Canonical gfx name (e.g. "gfx1100"). Diagnostics-only.
  llvm::StringRef name;

  // Max coresident waves per SIMD unit, ignoring register pressure.
  // RDNA3/RDNA4: 16 per SIMD32. CDNA3/CDNA4: 8 per SIMD16.
  int wavesPerSIMD;

  // SIMD units per CU. RDNA: 2 SIMD32. CDNA: 4 SIMD16.
  int simdsPerCU;

  // Low SIMD-ID bit in the target hardware-ID register.
  int simdIdOffset;

  // Low wave-slot bit in the target hardware-ID register.
  int waveIdOffset;

  // VGPR file size in 32-bit lanes per SIMD (RDNA) / per EU (CDNA),
  // in the arch's native wave mode.
  int vgprFileSize;

  // VGPR allocation granule in the arch's native wave mode.
  int vgprAllocGranule;

  // Dependent-VALU latency in SIMD cycles. RDNA: 5 (exposed, filled
  // by other waves). CDNA: 4 (wave64 occupies SIMD16 for 4 cycles).
  int valuPipelineDepth;

  // Wave64 cost relative to wave32. RDNA executes wave64 as two
  // wave32 halves (=2). CDNA's wave64 is the native unit (=1).
  int wave64IssueMultiplier;

  // Hardware cap on instructions issued per CU per cycle (5 per
  // rocprofiler-compute pipeline-descriptions doc).
  int issuesPerCUPerCycle;

  // SIMD issue period in cycles. RDNA issues every cycle (=1).
  // CDNA issues one wave64 over SIMD16 every 4 cycles (=4).
  int simdIssuePeriod;

  // Default LDS counter drain latency used when no calibration/override exists.
  int ldsCounterLatency;

  // DS and direct-to-LDS issue cadence per SIMD pair. Zero disables it.
  int ldsIssuePeriod;

  // LDS-DMA issue-side accept queue. Zero depth/latency disables the model.
  int ldsDmaIssueQueueDepth;
  int ldsDmaIssueLatency;

  // LDS-DMA cadence per SIMD pair. Zero disables the shared resource.
  int ldsDmaIssuePeriod;

  // Selection policy among ready resident waves on one SIMD.
  WaveIssueArbitration waveIssueArbitration;

  // AGPR allocation consumes VGPR-file capacity.
  bool agprCountsAgainstVGPRs;
};

// Lookup by IsaVersion. Aborts (report_fatal_error) on unsupported
// arch -- callers are expected to validate first via isArchSupported.
const ArchData &getArchData(const llvm::AMDGPU::IsaVersion &isa);

// Returns true if the arch is in the supported set without
// asserting. Useful for early validation paths.
bool isArchSupported(const llvm::AMDGPU::IsaVersion &isa);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_ARCHDATA_H
