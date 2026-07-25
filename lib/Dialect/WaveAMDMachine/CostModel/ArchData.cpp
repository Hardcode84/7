//===- ArchData.cpp - Per-arch structural parameters ----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"

#include "llvm/ADT/Twine.h"
#include "llvm/Support/ErrorHandling.h"

namespace mlir::waveamdmachine {

// GFX8 / Fiji-era GCN. Coarse scheduler model for legacy codegen tests:
// wave64 over 4 SIMD16 units, smaller VGPR file than CDNA.
static constexpr ArchData kGfx803{
    /*isa=*/{8, 0, 3},
    /*name=*/"gfx803",
    /*wavesPerSIMD=*/10,
    /*simdsPerCU=*/4,
    /*simdIdOffset=*/4,
    /*vgprFileSize=*/256,
    /*vgprAllocGranule=*/4,
    /*valuPipelineDepth=*/4,
    /*wave64IssueMultiplier=*/1,
    /*issuesPerCUPerCycle=*/5,
    /*simdIssuePeriod=*/4,
    /*ldsCounterLatency=*/5,
    /*ldsIssuePeriod=*/0,
    /*ldsDmaIssueQueueDepth=*/0,
    /*ldsDmaIssueLatency=*/0,
    /*ldsDmaIssuePeriod=*/0,
    /*waveIssueArbitration=*/WaveIssueArbitration::RoundRobin,
};

// CDNA3 / MI300. LLVM AMDGPUBaseInfo gives 8 waves/EU,
// VGPR alloc granule 8, total VGPRs 512.
// Wave64 native unit; 4-cycle SIMD16 issue period.
static constexpr ArchData kGfx942{
    /*isa=*/{9, 4, 2},
    /*name=*/"gfx942",
    /*wavesPerSIMD=*/8,
    /*simdsPerCU=*/4,
    /*simdIdOffset=*/4,
    /*vgprFileSize=*/512,
    /*vgprAllocGranule=*/8,
    /*valuPipelineDepth=*/4,
    /*wave64IssueMultiplier=*/1,
    /*issuesPerCUPerCycle=*/5,
    /*simdIssuePeriod=*/4,
    /*ldsCounterLatency=*/5,
    /*ldsIssuePeriod=*/0,
    /*ldsDmaIssueQueueDepth=*/0,
    /*ldsDmaIssueLatency=*/0,
    /*ldsDmaIssuePeriod=*/0,
    /*waveIssueArbitration=*/WaveIssueArbitration::RoundRobin,
};

// CDNA4 / MI350. Shares the gfx9_4 feature shape with gfx942 on
// every dimension this table tracks.
static constexpr ArchData kGfx950{
    /*isa=*/{9, 5, 0},
    /*name=*/"gfx950",
    /*wavesPerSIMD=*/8,
    /*simdsPerCU=*/4,
    /*simdIdOffset=*/4,
    /*vgprFileSize=*/512,
    /*vgprAllocGranule=*/8,
    /*valuPipelineDepth=*/4,
    /*wave64IssueMultiplier=*/1,
    /*issuesPerCUPerCycle=*/5,
    /*simdIssuePeriod=*/4,
    /*ldsCounterLatency=*/20,
    /*ldsIssuePeriod=*/4,
    /*ldsDmaIssueQueueDepth=*/7,
    /*ldsDmaIssueLatency=*/180,
    /*ldsDmaIssuePeriod=*/4,
    /*waveIssueArbitration=*/WaveIssueArbitration::RoundRobin,
};

// RDNA3 Navi31 (RX 7900 series). FeatureGFX10_3Insts +
// Feature1536VGPRs -> getMaxWavesPerEU=16, wave32 granule=24,
// wave32 file=1536. SIMD32 single-cycle issue, wave64 = 2x wave32.
static constexpr ArchData kGfx1100{
    /*isa=*/{11, 0, 0},
    /*name=*/"gfx1100",
    /*wavesPerSIMD=*/16,
    /*simdsPerCU=*/2,
    /*simdIdOffset=*/8,
    /*vgprFileSize=*/1536,
    /*vgprAllocGranule=*/24,
    /*valuPipelineDepth=*/5,
    /*wave64IssueMultiplier=*/2,
    /*issuesPerCUPerCycle=*/5,
    /*simdIssuePeriod=*/1,
    /*ldsCounterLatency=*/20,
    /*ldsIssuePeriod=*/0,
    /*ldsDmaIssueQueueDepth=*/0,
    /*ldsDmaIssueLatency=*/0,
    /*ldsDmaIssuePeriod=*/0,
    /*waveIssueArbitration=*/WaveIssueArbitration::RoundRobin,
};

// RDNA4. FeatureISAVersion12 carries Feature1536VGPRs by default.
// Matches gfx1100 on the structural dimensions.
static constexpr ArchData kGfx1200{
    /*isa=*/{12, 0, 0},
    /*name=*/"gfx1200",
    /*wavesPerSIMD=*/16,
    /*simdsPerCU=*/2,
    /*simdIdOffset=*/8,
    /*vgprFileSize=*/1536,
    /*vgprAllocGranule=*/24,
    /*valuPipelineDepth=*/5,
    /*wave64IssueMultiplier=*/2,
    /*issuesPerCUPerCycle=*/5,
    /*simdIssuePeriod=*/1,
    /*ldsCounterLatency=*/20,
    /*ldsIssuePeriod=*/0,
    /*ldsDmaIssueQueueDepth=*/0,
    /*ldsDmaIssueLatency=*/0,
    /*ldsDmaIssuePeriod=*/0,
    /*waveIssueArbitration=*/WaveIssueArbitration::RoundRobin,
};

template <const ArchData &A> static constexpr bool saneLdsDmaIssue() {
  static_assert(A.ldsIssuePeriod >= 0 && A.ldsIssuePeriod <= 64,
                "LDS issue period out of range");
  static_assert(A.ldsDmaIssueQueueDepth >= 0,
                "ldsDmaIssueQueueDepth below range");
  static_assert(A.ldsDmaIssueQueueDepth <= 64,
                "ldsDmaIssueQueueDepth above range");
  static_assert(A.ldsDmaIssueLatency >= 0, "ldsDmaIssueLatency below range");
  static_assert(A.ldsDmaIssueLatency <= 512, "ldsDmaIssueLatency above range");
  static_assert((A.ldsDmaIssueQueueDepth == 0) == (A.ldsDmaIssueLatency == 0),
                "LDS-DMA issue model requires depth and latency");
  static_assert(A.ldsDmaIssuePeriod >= 0 && A.ldsDmaIssuePeriod <= 64,
                "ldsDmaIssuePeriod out of range");
  static_assert(A.ldsDmaIssuePeriod == 0 || A.ldsDmaIssueQueueDepth != 0,
                "shared LDS-DMA issue requires an accept queue");
  return true;
}

// Compile-time invariants. Anything failing here means a typo in
// the table above slipped past review.
template <const ArchData &A> static constexpr bool sane() {
  static_assert(A.wavesPerSIMD > 0 && A.wavesPerSIMD <= 32,
                "wavesPerSIMD out of range");
  static_assert(A.simdsPerCU == 2 || A.simdsPerCU == 4,
                "simdsPerCU is 2 (RDNA) or 4 (CDNA)");
  static_assert(static_cast<unsigned>(A.simdIdOffset) < 32,
                "simdIdOffset out of range");
  static_assert(A.vgprFileSize >= 256 && A.vgprFileSize <= 2048,
                "vgprFileSize out of range");
  static_assert(A.vgprAllocGranule > 0 &&
                    A.vgprFileSize % A.vgprAllocGranule == 0,
                "granule must divide file size");
  static_assert(A.valuPipelineDepth >= 1 && A.valuPipelineDepth <= 8,
                "valuPipelineDepth out of range");
  static_assert(A.wave64IssueMultiplier == 1 || A.wave64IssueMultiplier == 2,
                "wave64IssueMultiplier is 1 (CDNA) or 2 (RDNA)");
  static_assert(A.issuesPerCUPerCycle >= 1 && A.issuesPerCUPerCycle <= 8,
                "issuesPerCUPerCycle out of range");
  static_assert(A.simdIssuePeriod == 1 || A.simdIssuePeriod == 4,
                "simdIssuePeriod is 1 (RDNA) or 4 (CDNA wave64)");
  static_assert(A.ldsCounterLatency >= 0 && A.ldsCounterLatency <= 512,
                "ldsCounterLatency out of range");
  static_assert(saneLdsDmaIssue<A>());
  return true;
}

static_assert(sane<kGfx803>());
static_assert(sane<kGfx942>());
static_assert(sane<kGfx950>());
static_assert(sane<kGfx1100>());
static_assert(sane<kGfx1200>());

bool isArchSupported(const llvm::AMDGPU::IsaVersion &isa) {
  return isaEq(isa, kGfx803.isa) || isaEq(isa, kGfx942.isa) ||
         isaEq(isa, kGfx950.isa) || isaEq(isa, kGfx1100.isa) ||
         isaEq(isa, kGfx1200.isa);
}

const ArchData &getArchData(const llvm::AMDGPU::IsaVersion &isa) {
  if (isaEq(isa, kGfx803.isa))
    return kGfx803;
  if (isaEq(isa, kGfx942.isa))
    return kGfx942;
  if (isaEq(isa, kGfx950.isa))
    return kGfx950;
  if (isaEq(isa, kGfx1100.isa))
    return kGfx1100;
  if (isaEq(isa, kGfx1200.isa))
    return kGfx1200;
  llvm::report_fatal_error(llvm::Twine("ArchData: unsupported IsaVersion ") +
                           llvm::Twine(isa.Major) + "." +
                           llvm::Twine(isa.Minor) + "." +
                           llvm::Twine(isa.Stepping));
}

} // namespace mlir::waveamdmachine
