//===- SchedClass.h - Scheduling-class enum ---------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Bucketing enum mirroring the LLVM AMDGPU SchedWrite classes the
// cost model cares about. Each wave.amd.machine op maps to one of
// these (see OpClassifier); LatencyTable maps each one to a per-arch
// cycle count.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_SCHEDCLASS_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_SCHEDCLASS_H

#include "llvm/ADT/StringRef.h"

#include <cstdint>

namespace mlir::waveamdmachine {

// Coarse scheduling buckets. Names mirror LLVM's SISchedule.td
// SchedWrite classes so generated latency tables stay
// grep-correlatable with upstream.
enum class SchedClass : uint8_t {
  // Pseudo-ops that emit no machine instruction. Charge 0 cycles.
  NoInst,

  // Single-cycle scalar ALU (s_add, s_mul, s_lshl, s_cmp, s_mov,
  // exec manipulation).
  WriteSALU,

  // Most 32-bit VALU (v_add_u32, v_and_b32, v_cmp_*_u32,
  // v_mov_b32, ...). RDNA: 5-cycle dependent latency.
  Write32Bit,

  // 64-bit VALU expansions (v_add_u64, v_mul_u64, v_lshlrev_b64).
  // Treated as a separate class because upstream LLVM costs them
  // higher than Write32Bit.
  Write64Bit,

  // Single-precision FMA / mul-add (v_fma_f32, ...).
  WriteFloatFMA,

  // Double-precision VALU (v_*_f64).
  WriteDouble,

  // Transcendentals (v_exp_f32, v_rcp_f32, v_sqrt_f32, ...).
  // Emit through the transcendental pipe on RDNA.
  WriteTrans32,

  // Single-precision functional units that are neither plain VALU
  // nor transcendental (v_sin_f32 etc.; arch-specific).
  WriteSFPU,

  // MAI / MFMA family, bucketed by pass count (per LLVM
  // SISchedule.td: HWXDL resource binding).
  Write2PassMAI,
  Write4PassMAI,
  Write8PassMAI,
  Write16PassMAI,

  // WMMA via the XDL functional unit (gfx1250+; xdl-style WMMA).
  WriteXDL2PassWMMA,
  WriteXDL4PassWMMA,

  // VALU-pipe WMMA classes from LLVM's gfx125x model. gfx11 v_wmma_*
  // uses the 16-pass bucket until a narrower measured class exists.
  Write4PassWMMA,
  Write8PassWMMA,
  Write16PassWMMA,

  // Vector memory ops (global_*, buffer_*, including _lds_ variants).
  WriteVMEM,

  // Scalar memory loads (s_load_*).
  WriteSMEM,

  // LDS / DS ops (ds_load_*, ds_store_*).
  WriteLDS,

  // Scalar branches, s_setpc, s_endpgm.
  WriteBranch,

  // s_barrier and barrier-init/wait family.
  WriteBarrier,

  // Export ops (graphics-side; not used by compute kernels but
  // present in the enum for parity with upstream SchedWrite list).
  WriteExport,

  // s_waitcnt / s_waitcnt_vscnt / s_delay_alu. These issue
  // instantly but expose latency through the counters they wait
  // on; the simulator charges the wait separately.
  WaitcntPseudo,

  // Sentinel.
  NumSchedClasses,
};

// Human-readable name for diagnostics + LatencyTable lookups.
llvm::StringRef getSchedClassName(SchedClass cls);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_SCHEDCLASS_H
